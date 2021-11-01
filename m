Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3054419AF
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 11:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhKAKTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 06:19:39 -0400
Received: from sender11-of-o53.zoho.eu ([31.186.226.239]:21893 "EHLO
        sender11-of-o53.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbhKAKTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 06:19:38 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1635761823; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=TSk6neWVjPGRtNGb19/Rs6MuzRhO5Vdp66oOMNEnwKruvDnC2qweh4ogCBjaCIjgayOJqVRfrN1ZzQ/f9xwqx70q7ZNi37SHI8emQ8uphz+CLOqCZR2el3Etq/IQBT6T3xC8bo6sHaIt32fnju0W3X5Uu0c+R2V/MUd/F3pp2s4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1635761823; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=CCZQ+HLKZjS9R1tctjaW45x9LRWkNjtyVur3PjsOq9g=; 
        b=Vt/VDBait3FyPWnQGGnTJPKJvaCbkgMNLwFYXrp+mX+4oz7g+HfPYfZoVlsv3bjYDrJXBF3OgqIt3dVmt9GVya1cHZYJ4l0oI49J6TJDKxDv7kBR3PkGfAL5HRyOlIV+1raU75r59PqUpmqxLE/fyQDoGlf3SKeH3iRotW4x1KE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=bursov.com;
        spf=pass  smtp.mailfrom=vitaly@bursov.com;
        dmarc=pass header.from=<vitaly@bursov.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1635761823;
        s=zoho; d=bursov.com; i=vitaly@bursov.com;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=CCZQ+HLKZjS9R1tctjaW45x9LRWkNjtyVur3PjsOq9g=;
        b=n4JVfFG2TaSRI5KNmj3VWQxvJvj+4aDFTgsSlw+NSCqc2HvLesMnZzfqabNIrUqU
        F0gnF22/J0kkAdFZ42RVMjK6JRuEn/seeCnEuLPLMCjzHPdc3t5uO7XWIWWyN0rnJdT
        lKkQ5mBqnixLW1WZ8nabZXT78kS/BYRk5cjIsznk=
Received: from [192.168.11.99] (31.133.98.254 [31.133.98.254]) by mx.zoho.eu
        with SMTPS id 1635761821630653.6996148352924; Mon, 1 Nov 2021 11:17:01 +0100 (CET)
Subject: Re: tg3 RX packet re-order in queue 0 with RSS
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Linux Netdev List <netdev@vger.kernel.org>
References: <0a1d6421-b618-9fea-9787-330a18311ec0@bursov.com>
 <CAMet4B4iJjQK6yX+XBD2CtH3B30oqECUAYDj3ZE3ysdJVu8O4w@mail.gmail.com>
 <CALs4sv2YVu0euy5-stBNuES3Bf2SR7MtiD0TJDfGmTLAiUONSA@mail.gmail.com>
 <02400c1a-e626-d6c3-ecfd-3b9e9e4b6988@bursov.com>
 <CALs4sv3XOTBKCxaUieYosMdXuuqiuHT5Gbhz8oixGv2XGw4+Ug@mail.gmail.com>
 <a5c6e92f-cc59-0214-56f6-66632c5e59c2@bursov.com>
 <CALs4sv2PWbijor=7aU4oh=yipYo2OMD79wMqEGfj3c4Lw9uycA@mail.gmail.com>
 <ae4bd2c2-6e88-2b1c-c47d-7510ef6a8010@bursov.com>
 <CALs4sv2mq5=FehCcxPveCbCMNT1aw=8LhqZ4g3=GXhKw8hsrmA@mail.gmail.com>
 <be0e1e7d-272e-7f32-9626-ed4724d7fd9a@bursov.com>
 <CALs4sv0uo7+RQ0hNmNC=3tD8gk=MS4chygeiuzf4Ve9iiKt9uA@mail.gmail.com>
From:   Vitaly Bursov <vitaly@bursov.com>
Message-ID: <ca16d60c-6853-f80f-99f0-0511b8ac1ef6@bursov.com>
Date:   Mon, 1 Nov 2021 12:17:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CALs4sv0uo7+RQ0hNmNC=3tD8gk=MS4chygeiuzf4Ve9iiKt9uA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru-RU
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



01.11.2021 11:10, Pavan Chebbi wrote:
> On Mon, Nov 1, 2021 at 1:50 PM Vitaly Bursov <vitaly@bursov.com> wrote:
>>
>>
>>
>> 01.11.2021 09:06, Pavan Chebbi wrote:
>>> On Fri, Oct 29, 2021 at 9:15 PM Vitaly Bursov <vitaly@bursov.com> wrote=
:
>>>>
>>>>
>>>>
>>>> 29.10.2021 08:04, Pavan Chebbi =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>>>> 90On Thu, Oct 28, 2021 at 9:11 PM Vitaly Bursov <vitaly@bursov.com> w=
rote:
>>>>>>
>>>>>>
>>>>>> 28.10.2021 10:33, Pavan Chebbi wrote:
>>>>>>> On Wed, Oct 27, 2021 at 4:02 PM Vitaly Bursov <vitaly@bursov.com> w=
rote:
>>>>>>>>
>>>>>>>>
>>>>>>>> 27.10.2021 12:30, Pavan Chebbi wrote:
>>>>>>>>> On Wed, Sep 22, 2021 at 12:10 PM Siva Reddy Kallam
>>>>>>>>> <siva.kallam@broadcom.com> wrote:
>>>>>>>>>>
>>>>>>>>>> Thank you for reporting this. Pavan(cc'd) from Broadcom looking =
into this issue.
>>>>>>>>>> We will provide our feedback very soon on this.
>>>>>>>>>>
>>>>>>>>>> On Mon, Sep 20, 2021 at 6:59 PM Vitaly Bursov <vitaly@bursov.com=
> wrote:
>>>>>>>>>>>
>>>>>>>>>>> Hi,
>>>>>>>>>>>
>>>>>>>>>>> We found a occassional and random (sometimes happens, sometimes=
 not)
>>>>>>>>>>> packet re-order when NIC is involved in UDP multicast reception=
, which
>>>>>>>>>>> is sensitive to a packet re-order. Network capture with tcpdump
>>>>>>>>>>> sometimes shows the packet re-order, sometimes not (e.g. no re-=
order on
>>>>>>>>>>> a host, re-order in a container at the same time). In a pcap fi=
le
>>>>>>>>>>> re-ordered packets have a correct timestamp - delayed packet ha=
d a more
>>>>>>>>>>> earlier timestamp compared to a previous packet:
>>>>>>>>>>>           1.00s packet1
>>>>>>>>>>>           1.20s packet3
>>>>>>>>>>>           1.10s packet2
>>>>>>>>>>>           1.30s packet4
>>>>>>>>>>>
>>>>>>>>>>> There's about 300Mbps of traffic on this NIC, and server is bus=
y
>>>>>>>>>>> (hyper-threading enabled, about 50% overall idle) with its
>>>>>>>>>>> computational application work.
>>>>>>>>>>>
>>>>>>>>>>> NIC is HPE's 4-port 331i adapter - BCM5719, in a default ring a=
nd
>>>>>>>>>>> coalescing configuration, 1 TX queue, 4 RX queues.
>>>>>>>>>>>
>>>>>>>>>>> After further investigation, I believe that there are two separ=
ate
>>>>>>>>>>> issues in tg3.c driver. Issues can be reproduced with iperf3, a=
nd
>>>>>>>>>>> unicast UDP.
>>>>>>>>>>>
>>>>>>>>>>> Here are the details of how I understand this behavior.
>>>>>>>>>>>
>>>>>>>>>>> 1. Packet re-order.
>>>>>>>>>>>
>>>>>>>>>>> Driver calls napi_schedule(&tnapi->napi) when handling the inte=
rrupt,
>>>>>>>>>>> however, sometimes it calls napi_schedule(&tp->napi[1].napi), w=
hich
>>>>>>>>>>> handles RX queue 0 too:
>>>>>>>>>>>
>>>>>>>>>>>           https://github.com/torvalds/linux/blob/master/drivers=
/net/ethernet/broadcom/tg3.c#L6802-L7007
>>>>>>>>>>>
>>>>>>>>>>>           static int tg3_rx(struct tg3_napi *tnapi, int budget)
>>>>>>>>>>>           {
>>>>>>>>>>>                   struct tg3 *tp =3D tnapi->tp;
>>>>>>>>>>>
>>>>>>>>>>>                   ...
>>>>>>>>>>>
>>>>>>>>>>>                   /* Refill RX ring(s). */
>>>>>>>>>>>                   if (!tg3_flag(tp, ENABLE_RSS)) {
>>>>>>>>>>>                           ....
>>>>>>>>>>>                   } else if (work_mask) {
>>>>>>>>>>>                           ...
>>>>>>>>>>>
>>>>>>>>>>>                           if (tnapi !=3D &tp->napi[1]) {
>>>>>>>>>>>                                   tp->rx_refill =3D true;
>>>>>>>>>>>                                   napi_schedule(&tp->napi[1].na=
pi);
>>>>>>>>>>>                           }
>>>>>>>>>>>                   }
>>>>>>>>>>>                   ...
>>>>>>>>>>>           }
>>>>>>>>>>>
>>>>>>>>>>>       From napi_schedule() code, it should schedure RX 0 traffi=
c handling on
>>>>>>>>>>> a current CPU, which handles queues RX1-3 right now.
>>>>>>>>>>>
>>>>>>>>>>> At least two traffic flows are required - one on RX queue 0, an=
d the
>>>>>>>>>>> other on any other queue (1-3). Re-ordering may happend only on=
 flow
>>>>>>>>>>> from queue 0, the second flow will work fine.
>>>>>>>>>>>
>>>>>>>>>>> No idea how to fix this.
>>>>>>>>>
>>>>>>>>> In the case of RSS the actual rings for RX are from 1 to 4.
>>>>>>>>> The napi of those rings are indeed processing the packets.
>>>>>>>>> The explicit napi_schedule of napi[1] is only re-filling rx BD
>>>>>>>>> producer ring because it is shared with return rings for 1-4.
>>>>>>>>> I tried to repro this but I am not seeing the issue. If you are
>>>>>>>>> receiving packets on RX 0 then the RSS must have been disabled.
>>>>>>>>> Can you please check?
>>>>>>>>>
>>>>>>>>
>>>>>>>> # ethtool -i enp2s0f0
>>>>>>>> driver: tg3
>>>>>>>> version: 3.137
>>>>>>>> firmware-version: 5719-v1.46 NCSI v1.5.18.0
>>>>>>>> expansion-rom-version:
>>>>>>>> bus-info: 0000:02:00.0
>>>>>>>> supports-statistics: yes
>>>>>>>> supports-test: yes
>>>>>>>> supports-eeprom-access: yes
>>>>>>>> supports-register-dump: yes
>>>>>>>> supports-priv-flags: no
>>>>>>>>
>>>>>>>> # ethtool -l enp2s0f0
>>>>>>>> Channel parameters for enp2s0f0:
>>>>>>>> Pre-set maximums:
>>>>>>>> RX:             4
>>>>>>>> TX:             4
>>>>>>>> Other:          0
>>>>>>>> Combined:       0
>>>>>>>> Current hardware settings:
>>>>>>>> RX:             4
>>>>>>>> TX:             1
>>>>>>>> Other:          0
>>>>>>>> Combined:       0
>>>>>>>>
>>>>>>>> # ethtool -x enp2s0f0
>>>>>>>> RX flow hash indirection table for enp2s0f0 with 4 RX ring(s):
>>>>>>>>          0:      0     1     2     3     0     1     2     3
>>>>>>>>          8:      0     1     2     3     0     1     2     3
>>>>>>>>         16:      0     1     2     3     0     1     2     3
>>>>>>>>         24:      0     1     2     3     0     1     2     3
>>>>>>>>         32:      0     1     2     3     0     1     2     3
>>>>>>>>         40:      0     1     2     3     0     1     2     3
>>>>>>>>         48:      0     1     2     3     0     1     2     3
>>>>>>>>         56:      0     1     2     3     0     1     2     3
>>>>>>>>         64:      0     1     2     3     0     1     2     3
>>>>>>>>         72:      0     1     2     3     0     1     2     3
>>>>>>>>         80:      0     1     2     3     0     1     2     3
>>>>>>>>         88:      0     1     2     3     0     1     2     3
>>>>>>>>         96:      0     1     2     3     0     1     2     3
>>>>>>>>        104:      0     1     2     3     0     1     2     3
>>>>>>>>        112:      0     1     2     3     0     1     2     3
>>>>>>>>        120:      0     1     2     3     0     1     2     3
>>>>>>>> RSS hash key:
>>>>>>>> Operation not supported
>>>>>>>> RSS hash function:
>>>>>>>>          toeplitz: on
>>>>>>>>          xor: off
>>>>>>>>          crc32: off
>>>>>>>>
>>>>>>>> In /proc/interrupts there are enp2s0f0-tx-0, enp2s0f0-rx-1,
>>>>>>>> enp2s0f0-rx-2, enp2s0f0-rx-3, enp2s0f0-rx-4 interrupts, all on
>>>>>>>> different CPU cores. Kernel also has "threadirqs" enabled in
>>>>>>>> command line, I didn't check if this parameter affects the issue.
>>>>>>>>
>>>>>>>> Yes, some things start with 0, and others with 1, sorry for a conf=
usion
>>>>>>>> in terminology, what I meant:
>>>>>>>>       - There are 4 RX rings/queues, I counted starting from 0, so=
: 0..3.
>>>>>>>>         RX0 is the first queue/ring that actually receives the tra=
ffic.
>>>>>>>>         RX0 is handled by enp2s0f0-rx-1 interrupt.
>>>>>>>>       - These are related to (tp->napi[i]), but i is in 1..4, so t=
he first
>>>>>>>>         receiving queue relates to tp->napi[1], the second relates=
 to
>>>>>>>>         tp->napi[2], and so on. Correct?
>>>>>>>>
>>>>>>>> Suppose, tg3_rx() is called for tp->napi[2], this function most li=
kely
>>>>>>>> calls napi_gro_receive(&tnapi->napi, skb) to further process packe=
ts in
>>>>>>>> tp->napi[2]. And, under some conditions (RSS and work_mask), it ca=
lls
>>>>>>>> napi_schedule(&tp->napi[1].napi), which schedules tp->napi[1] work
>>>>>>>> on a currect CPU, which is designated for tp->napi[2], but not for
>>>>>>>> tp->napi[1]. Correct?
>>>>>>>>
>>>>>>>> I don't understand what napi_schedule(&tp->napi[1].napi) does for =
the
>>>>>>>> NIC or driver, "re-filling rx BD producer ring" sounds important. =
I
>>>>>>>> suspect something will break badly if I simply remove it without
>>>>>>>> replacing with something more elaborate. I guess along with re-fil=
ling
>>>>>>>> rx BD producer ring it also can process incoming packets. Is it po=
ssible?
>>>>>>>>
>>>>>>>
>>>>>>> Yes, napi[1] work may be called on the napi[2]'s CPU but it general=
ly
>>>>>>> won't process
>>>>>>> any rx packets because the producer index of napi[1] has not change=
d. If the
>>>>>>> producer count did change, then we get a poll from the ISR for napi=
[1]
>>>>>>> to process
>>>>>>> packets. So it is mostly used to re-fill rx buffers when called
>>>>>>> explicitly. However
>>>>>>> there could be a small window where the prod index is incremented b=
ut the ISR
>>>>>>> is not fired yet. It may process some small no of packets. But I do=
n't
>>>>>>> think this
>>>>>>> should lead to a reorder problem.
>>>>>>>
>>>>>>
>>>>>> I tried to reproduce without using bridge and veth interfaces, and i=
t seems
>>>>>> like it's not reproducible, so traffic forwarding via a bridge inter=
face may
>>>>>> be necessary. It also does not happen if traffic load is low, but mo=
derate
>>>>>> load is enough - e.g. two 100 Mbps streams with 130-byte packets. It=
's easier
>>>>>> to reproduce with a higher load.
>>>>>>
>>>>>> With about the same setup as in an original message (bridge + veth 2
>>>>>> network namespaces), irqbalance daemon stopped, if traffic flows via
>>>>>> enp2s0f0-rx-2 and enp2s0f0-rx-4, there's no reordering. enp2s0f0-rx-=
1
>>>>>> still gets some interrupts, but at a much lower rate compared to 2 a=
nd
>>>>>> 4.
>>>>>>
>>>>>> namespace 1:
>>>>>>       # iperf3 -u -c server_ip -p 5000 -R -b 300M -t 300 -l 130
>>>>>>       - - - - - - - - - - - - - - - - - - - - - - - - -
>>>>>>       [ ID] Interval           Transfer     Bandwidth       Jitter  =
  Lost/Total Datagrams
>>>>>>       [  4]   0.00-300.00 sec  6.72 GBytes   192 Mbits/sec  0.008 ms=
  3805/55508325 (0.0069%)
>>>>>>       [  4] Sent 55508325 datagrams
>>>>>>
>>>>>>       iperf Done.
>>>>>>
>>>>>> namespace 2:
>>>>>>       # iperf3 -u -c server_ip -p 5001 -R -b 300M -t 300 -l 130
>>>>>>       - - - - - - - - - - - - - - - - - - - - - - - - -
>>>>>>       [ ID] Interval           Transfer     Bandwidth       Jitter  =
  Lost/Total Datagrams
>>>>>>       [  4]   0.00-300.00 sec  6.83 GBytes   196 Mbits/sec  0.005 ms=
  3873/56414001 (0.0069%)
>>>>>>       [  4] Sent 56414001 datagrams
>>>>>>
>>>>>>       iperf Done.
>>>>>>
>>>>>>
>>>>>> With the same configuration but different IP address so that instead=
 of
>>>>>> enp2s0f0-rx-4 enp2s0f0-rx-1 would be used, there is a reordering.
>>>>>>
>>>>>>
>>>>>> namespace 1 (client IP was changed):
>>>>>>       # iperf3 -u -c server_ip -p 5000 -R -b 300M -t 300 -l 130
>>>>>>       - - - - - - - - - - - - - - - - - - - - - - - - -
>>>>>>       [ ID] Interval           Transfer     Bandwidth       Jitter  =
  Lost/Total Datagrams
>>>>>>       [  4]   0.00-300.00 sec  6.32 GBytes   181 Mbits/sec  0.007 ms=
  8506/52172059 (0.016%)
>>>>>>       [  4] Sent 52172059 datagrams
>>>>>>       [SUM]  0.0-300.0 sec  2452 datagrams received out-of-order
>>>>>>
>>>>>>       iperf Done.
>>>>>>
>>>>>> namespace 2:
>>>>>>       # iperf3 -u -c server_ip -p 5001 -R -b 300M -t 300 -l 130
>>>>>>       - - - - - - - - - - - - - - - - - - - - - - - - -
>>>>>>       [ ID] Interval           Transfer     Bandwidth       Jitter  =
  Lost/Total Datagrams
>>>>>>       [  4]   0.00-300.00 sec  6.59 GBytes   189 Mbits/sec  0.006 ms=
  6302/54463973 (0.012%)
>>>>>>       [  4] Sent 54463973 datagrams
>>>>>>
>>>>>>       iperf Done.
>>>>>>
>>>>>> Swapping IP addresses in these namespaces also changes the namespace=
 exhibiting the issue,
>>>>>> it's following the IP address.
>>>>>>
>>>>>>
>>>>>> Is there something I could check to confirm that this behavior is or=
 is not
>>>>>> related to napi_schedule(&tp->napi[1].napi) call?
>>>>>
>>>>> in the function tg3_msi_1shot() you could store the cpu assigned to
>>>>> tnapi1 (inside the struct tg3_napi)
>>>>> and then in tg3_poll_work() you can add another check after
>>>>>            if (*(tnapi->rx_rcb_prod_idx) !=3D tnapi->rx_rcb_ptr)
>>>>> something like
>>>>> if (tnapi =3D=3D &tp->napi[1] && tnapi->assigned_cpu =3D=3D smp_proce=
ssor_id())
>>>>> only then execute tg3_rx()
>>>>>
>>>>> This may stop tnapi 1 from reading rx pkts on the current CPU from
>>>>> which refill is called.
>>>>>
>>>>
>>>> Didn't work for me, perhaps I did something wrong - if tg3_rx() is not=
 called,
>>>> there's an infinite loop, and after I added "work_done =3D budget;", i=
t still doesn't
>>>> work - traffic does not flow.
>>>>
>>>
>>> I think the easiest way is to modify the tg3_rx() calling condition
>>> like below inside
>>> tg3_poll_work() :
>>>
>>> if (*(tnapi->rx_rcb_prod_idx) !=3D tnapi->rx_rcb_ptr) {
>>>           if (tnapi !=3D &tp->napi[1] || (tnapi =3D=3D &tp->napi[1] &&
>>> !tp->rx_refill)) {
>>>                           work_done +=3D tg3_rx(tnapi, budget - work_do=
ne);
>>>           }
>>> }
>>>
>>> This will prevent reading rx packets when napi[1] is scheduled only for=
 refill.
>>> Can you see if this works?
>>>
>>
>> It doesn't hang and can receive the traffic with this change, but I don'=
t see
>> a difference. I'm suspectig that tg3_poll_work() is called again, maybe =
in tg3_poll_msix(),
>> and refill happens first, and then packets are processed anyway.
>>
>=20
> OK I see it now. Let me try this out myself. Will get back on this.
> However, can you see with your debug prints if there is any correlation
> between the time and number of prints where napi 1 is reading packets
> on unassigned CPU to the time and number of packets you received
> out of order up the stack? Do they match with each other? If not, we may =
be
> incorrectly suspecting napi1 here.
>=20

No corellation that I can see - reordered packets are received sometimes -
10000 in 300 seconds in this test, but napi messages are logged and
rate-limited at about 100000 per second. If bandwidth is very low, then
there are no messages and no reordering. Not sure if I can isolate these
events specifically.

--=20
Thanks
Vitalii

