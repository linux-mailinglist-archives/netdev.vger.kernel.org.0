Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8DB5E5383
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 21:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiIUTFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 15:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiIUTFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 15:05:02 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBD261B36
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 12:05:00 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id dv25so15667758ejb.12
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 12:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=IxntBIW0RLzy1+3BQvRrd1NhIYCRQti08E5urq5/Ck8=;
        b=OVO6acMPsn6CxNdQM37Po7u9GyyeI2ojRd4ccFNUvEkZtpCIcD8ti32JnlhxWJhbpv
         x2bu/nMNHxWhPubfGxE5BW5gN0qQIWMfiEkvo5GyNJ7+8T8kDXqXOxlIADdoRIdmd2+v
         YDwLvdo2iQROz39XlbArpDmaK2tZexysgicQEDWwC/r53f7C5L0g1TWOqUD3atZy2655
         2UgiDnWDFm0cZj3TJcVJVMKTY4iASrWF+XUtMnTi6Iagl/grJmX6a7Q5dwuxgTdbbGly
         yyV+gLeeBiWZ482wjYUKQEOi1HtjBQ22JEpqVSjOZrGv7gqF+/iUQOTCGmQhN61h7yxn
         AIqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=IxntBIW0RLzy1+3BQvRrd1NhIYCRQti08E5urq5/Ck8=;
        b=oPN5+JTxGSK6a3XMivJeRyKa56MozlkLJUGgnJitrR/KpFZJoToo+giM8q+Q93bUns
         1yPpwuNR+S8UVf2/KCoV1pTfhiUYFkOA7VcvBRG7et9A+FjyYhgM2Fb5U2hdc/axQJ8J
         /B20KEfpLZINkHrhMnBPUobUA8Ifa1tMfLnV5l0OO6XMNbj3MLB+b+cRDCD/qi5TSd18
         5GhjRsdX2yhib8IdXCN9s2yzjcc7qE2R1xDf/+kxEAW9ZmS1zj0AVut3DORTfXmKEkBf
         IMactipp1W9PcgttGic2FUeEXI+4G8I/BW10Sa+1keWLU1fEAnpY1PLiRghmcZqiSDom
         zIVQ==
X-Gm-Message-State: ACrzQf0rfYN5o89Tpj5PFlMoR5Oft3KyX74CdhVDLO0wuwX8iW2bu9wM
        w7HjJTY0gj2SxJ1lEdek5rU0H68B5IdkdHcDGUs=
X-Google-Smtp-Source: AMsMyM5lZzNI+wzoLXI7ulQD2Yqa46wMvxxOR2EjhhFMWmxJ2VV0H7u0H4Jem7UXKZHsr/t/yhjMQXsjA97P2Lb7IFk=
X-Received: by 2002:a17:907:7e94:b0:77a:c48b:c80 with SMTP id
 qb20-20020a1709077e9400b0077ac48b0c80mr20850255ejc.690.1663787098794; Wed, 21
 Sep 2022 12:04:58 -0700 (PDT)
MIME-Version: 1.0
References: <0a1d6421-b618-9fea-9787-330a18311ec0@bursov.com>
 <CAMet4B4iJjQK6yX+XBD2CtH3B30oqECUAYDj3ZE3ysdJVu8O4w@mail.gmail.com>
 <CALs4sv2YVu0euy5-stBNuES3Bf2SR7MtiD0TJDfGmTLAiUONSA@mail.gmail.com>
 <02400c1a-e626-d6c3-ecfd-3b9e9e4b6988@bursov.com> <CALs4sv3XOTBKCxaUieYosMdXuuqiuHT5Gbhz8oixGv2XGw4+Ug@mail.gmail.com>
 <a5c6e92f-cc59-0214-56f6-66632c5e59c2@bursov.com> <CALs4sv2PWbijor=7aU4oh=yipYo2OMD79wMqEGfj3c4Lw9uycA@mail.gmail.com>
 <ae4bd2c2-6e88-2b1c-c47d-7510ef6a8010@bursov.com> <CALs4sv2mq5=FehCcxPveCbCMNT1aw=8LhqZ4g3=GXhKw8hsrmA@mail.gmail.com>
 <be0e1e7d-272e-7f32-9626-ed4724d7fd9a@bursov.com> <CALs4sv0uo7+RQ0hNmNC=3tD8gk=MS4chygeiuzf4Ve9iiKt9uA@mail.gmail.com>
 <ca16d60c-6853-f80f-99f0-0511b8ac1ef6@bursov.com>
In-Reply-To: <ca16d60c-6853-f80f-99f0-0511b8ac1ef6@bursov.com>
From:   Etienne Champetier <champetier.etienne@gmail.com>
Date:   Wed, 21 Sep 2022 15:04:21 -0400
Message-ID: <CAOdf3gpy1wc1p60f86ZYOOxX6mHe7MwmTTHm0wGeW_CfqQPiGg@mail.gmail.com>
Subject: Re: tg3 RX packet re-order in queue 0 with RSS
To:     Vitaly Bursov <vitaly@bursov.com>
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le lun. 1 nov. 2021 =C3=A0 06:17, Vitaly Bursov <vitaly@bursov.com> a =C3=
=A9crit :
>
>
>
> 01.11.2021 11:10, Pavan Chebbi wrote:
> > On Mon, Nov 1, 2021 at 1:50 PM Vitaly Bursov <vitaly@bursov.com> wrote:
> >>
> >>
> >>
> >> 01.11.2021 09:06, Pavan Chebbi wrote:
> >>> On Fri, Oct 29, 2021 at 9:15 PM Vitaly Bursov <vitaly@bursov.com> wro=
te:
> >>>>
> >>>>
> >>>>
> >>>> 29.10.2021 08:04, Pavan Chebbi =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>>>> 90On Thu, Oct 28, 2021 at 9:11 PM Vitaly Bursov <vitaly@bursov.com>=
 wrote:
> >>>>>>
> >>>>>>
> >>>>>> 28.10.2021 10:33, Pavan Chebbi wrote:
> >>>>>>> On Wed, Oct 27, 2021 at 4:02 PM Vitaly Bursov <vitaly@bursov.com>=
 wrote:
> >>>>>>>>
> >>>>>>>>
> >>>>>>>> 27.10.2021 12:30, Pavan Chebbi wrote:
> >>>>>>>>> On Wed, Sep 22, 2021 at 12:10 PM Siva Reddy Kallam
> >>>>>>>>> <siva.kallam@broadcom.com> wrote:
> >>>>>>>>>>
> >>>>>>>>>> Thank you for reporting this. Pavan(cc'd) from Broadcom lookin=
g into this issue.
> >>>>>>>>>> We will provide our feedback very soon on this.
> >>>>>>>>>>
> >>>>>>>>>> On Mon, Sep 20, 2021 at 6:59 PM Vitaly Bursov <vitaly@bursov.c=
om> wrote:
> >>>>>>>>>>>
> >>>>>>>>>>> Hi,
> >>>>>>>>>>>
> >>>>>>>>>>> We found a occassional and random (sometimes happens, sometim=
es not)
> >>>>>>>>>>> packet re-order when NIC is involved in UDP multicast recepti=
on, which
> >>>>>>>>>>> is sensitive to a packet re-order. Network capture with tcpdu=
mp
> >>>>>>>>>>> sometimes shows the packet re-order, sometimes not (e.g. no r=
e-order on
> >>>>>>>>>>> a host, re-order in a container at the same time). In a pcap =
file
> >>>>>>>>>>> re-ordered packets have a correct timestamp - delayed packet =
had a more
> >>>>>>>>>>> earlier timestamp compared to a previous packet:
> >>>>>>>>>>>           1.00s packet1
> >>>>>>>>>>>           1.20s packet3
> >>>>>>>>>>>           1.10s packet2
> >>>>>>>>>>>           1.30s packet4
> >>>>>>>>>>>
> >>>>>>>>>>> There's about 300Mbps of traffic on this NIC, and server is b=
usy
> >>>>>>>>>>> (hyper-threading enabled, about 50% overall idle) with its
> >>>>>>>>>>> computational application work.
> >>>>>>>>>>>
> >>>>>>>>>>> NIC is HPE's 4-port 331i adapter - BCM5719, in a default ring=
 and
> >>>>>>>>>>> coalescing configuration, 1 TX queue, 4 RX queues.
> >>>>>>>>>>>
> >>>>>>>>>>> After further investigation, I believe that there are two sep=
arate
> >>>>>>>>>>> issues in tg3.c driver. Issues can be reproduced with iperf3,=
 and
> >>>>>>>>>>> unicast UDP.
> >>>>>>>>>>>
> >>>>>>>>>>> Here are the details of how I understand this behavior.
> >>>>>>>>>>>
> >>>>>>>>>>> 1. Packet re-order.
> >>>>>>>>>>>
> >>>>>>>>>>> Driver calls napi_schedule(&tnapi->napi) when handling the in=
terrupt,
> >>>>>>>>>>> however, sometimes it calls napi_schedule(&tp->napi[1].napi),=
 which
> >>>>>>>>>>> handles RX queue 0 too:
> >>>>>>>>>>>
> >>>>>>>>>>>           https://github.com/torvalds/linux/blob/master/drive=
rs/net/ethernet/broadcom/tg3.c#L6802-L7007
> >>>>>>>>>>>
> >>>>>>>>>>>           static int tg3_rx(struct tg3_napi *tnapi, int budge=
t)
> >>>>>>>>>>>           {
> >>>>>>>>>>>                   struct tg3 *tp =3D tnapi->tp;
> >>>>>>>>>>>
> >>>>>>>>>>>                   ...
> >>>>>>>>>>>
> >>>>>>>>>>>                   /* Refill RX ring(s). */
> >>>>>>>>>>>                   if (!tg3_flag(tp, ENABLE_RSS)) {
> >>>>>>>>>>>                           ....
> >>>>>>>>>>>                   } else if (work_mask) {
> >>>>>>>>>>>                           ...
> >>>>>>>>>>>
> >>>>>>>>>>>                           if (tnapi !=3D &tp->napi[1]) {
> >>>>>>>>>>>                                   tp->rx_refill =3D true;
> >>>>>>>>>>>                                   napi_schedule(&tp->napi[1].=
napi);
> >>>>>>>>>>>                           }
> >>>>>>>>>>>                   }
> >>>>>>>>>>>                   ...
> >>>>>>>>>>>           }
> >>>>>>>>>>>
> >>>>>>>>>>>       From napi_schedule() code, it should schedure RX 0 traf=
fic handling on
> >>>>>>>>>>> a current CPU, which handles queues RX1-3 right now.
> >>>>>>>>>>>
> >>>>>>>>>>> At least two traffic flows are required - one on RX queue 0, =
and the
> >>>>>>>>>>> other on any other queue (1-3). Re-ordering may happend only =
on flow
> >>>>>>>>>>> from queue 0, the second flow will work fine.
> >>>>>>>>>>>
> >>>>>>>>>>> No idea how to fix this.
> >>>>>>>>>
> >>>>>>>>> In the case of RSS the actual rings for RX are from 1 to 4.
> >>>>>>>>> The napi of those rings are indeed processing the packets.
> >>>>>>>>> The explicit napi_schedule of napi[1] is only re-filling rx BD
> >>>>>>>>> producer ring because it is shared with return rings for 1-4.
> >>>>>>>>> I tried to repro this but I am not seeing the issue. If you are
> >>>>>>>>> receiving packets on RX 0 then the RSS must have been disabled.
> >>>>>>>>> Can you please check?
> >>>>>>>>>
> >>>>>>>>
> >>>>>>>> # ethtool -i enp2s0f0
> >>>>>>>> driver: tg3
> >>>>>>>> version: 3.137
> >>>>>>>> firmware-version: 5719-v1.46 NCSI v1.5.18.0
> >>>>>>>> expansion-rom-version:
> >>>>>>>> bus-info: 0000:02:00.0
> >>>>>>>> supports-statistics: yes
> >>>>>>>> supports-test: yes
> >>>>>>>> supports-eeprom-access: yes
> >>>>>>>> supports-register-dump: yes
> >>>>>>>> supports-priv-flags: no
> >>>>>>>>
> >>>>>>>> # ethtool -l enp2s0f0
> >>>>>>>> Channel parameters for enp2s0f0:
> >>>>>>>> Pre-set maximums:
> >>>>>>>> RX:             4
> >>>>>>>> TX:             4
> >>>>>>>> Other:          0
> >>>>>>>> Combined:       0
> >>>>>>>> Current hardware settings:
> >>>>>>>> RX:             4
> >>>>>>>> TX:             1
> >>>>>>>> Other:          0
> >>>>>>>> Combined:       0
> >>>>>>>>
> >>>>>>>> # ethtool -x enp2s0f0
> >>>>>>>> RX flow hash indirection table for enp2s0f0 with 4 RX ring(s):
> >>>>>>>>          0:      0     1     2     3     0     1     2     3
> >>>>>>>>          8:      0     1     2     3     0     1     2     3
> >>>>>>>>         16:      0     1     2     3     0     1     2     3
> >>>>>>>>         24:      0     1     2     3     0     1     2     3
> >>>>>>>>         32:      0     1     2     3     0     1     2     3
> >>>>>>>>         40:      0     1     2     3     0     1     2     3
> >>>>>>>>         48:      0     1     2     3     0     1     2     3
> >>>>>>>>         56:      0     1     2     3     0     1     2     3
> >>>>>>>>         64:      0     1     2     3     0     1     2     3
> >>>>>>>>         72:      0     1     2     3     0     1     2     3
> >>>>>>>>         80:      0     1     2     3     0     1     2     3
> >>>>>>>>         88:      0     1     2     3     0     1     2     3
> >>>>>>>>         96:      0     1     2     3     0     1     2     3
> >>>>>>>>        104:      0     1     2     3     0     1     2     3
> >>>>>>>>        112:      0     1     2     3     0     1     2     3
> >>>>>>>>        120:      0     1     2     3     0     1     2     3
> >>>>>>>> RSS hash key:
> >>>>>>>> Operation not supported
> >>>>>>>> RSS hash function:
> >>>>>>>>          toeplitz: on
> >>>>>>>>          xor: off
> >>>>>>>>          crc32: off
> >>>>>>>>
> >>>>>>>> In /proc/interrupts there are enp2s0f0-tx-0, enp2s0f0-rx-1,
> >>>>>>>> enp2s0f0-rx-2, enp2s0f0-rx-3, enp2s0f0-rx-4 interrupts, all on
> >>>>>>>> different CPU cores. Kernel also has "threadirqs" enabled in
> >>>>>>>> command line, I didn't check if this parameter affects the issue=
.
> >>>>>>>>
> >>>>>>>> Yes, some things start with 0, and others with 1, sorry for a co=
nfusion
> >>>>>>>> in terminology, what I meant:
> >>>>>>>>       - There are 4 RX rings/queues, I counted starting from 0, =
so: 0..3.
> >>>>>>>>         RX0 is the first queue/ring that actually receives the t=
raffic.
> >>>>>>>>         RX0 is handled by enp2s0f0-rx-1 interrupt.
> >>>>>>>>       - These are related to (tp->napi[i]), but i is in 1..4, so=
 the first
> >>>>>>>>         receiving queue relates to tp->napi[1], the second relat=
es to
> >>>>>>>>         tp->napi[2], and so on. Correct?
> >>>>>>>>
> >>>>>>>> Suppose, tg3_rx() is called for tp->napi[2], this function most =
likely
> >>>>>>>> calls napi_gro_receive(&tnapi->napi, skb) to further process pac=
kets in
> >>>>>>>> tp->napi[2]. And, under some conditions (RSS and work_mask), it =
calls
> >>>>>>>> napi_schedule(&tp->napi[1].napi), which schedules tp->napi[1] wo=
rk
> >>>>>>>> on a currect CPU, which is designated for tp->napi[2], but not f=
or
> >>>>>>>> tp->napi[1]. Correct?
> >>>>>>>>
> >>>>>>>> I don't understand what napi_schedule(&tp->napi[1].napi) does fo=
r the
> >>>>>>>> NIC or driver, "re-filling rx BD producer ring" sounds important=
. I
> >>>>>>>> suspect something will break badly if I simply remove it without
> >>>>>>>> replacing with something more elaborate. I guess along with re-f=
illing
> >>>>>>>> rx BD producer ring it also can process incoming packets. Is it =
possible?
> >>>>>>>>
> >>>>>>>
> >>>>>>> Yes, napi[1] work may be called on the napi[2]'s CPU but it gener=
ally
> >>>>>>> won't process
> >>>>>>> any rx packets because the producer index of napi[1] has not chan=
ged. If the
> >>>>>>> producer count did change, then we get a poll from the ISR for na=
pi[1]
> >>>>>>> to process
> >>>>>>> packets. So it is mostly used to re-fill rx buffers when called
> >>>>>>> explicitly. However
> >>>>>>> there could be a small window where the prod index is incremented=
 but the ISR
> >>>>>>> is not fired yet. It may process some small no of packets. But I =
don't
> >>>>>>> think this
> >>>>>>> should lead to a reorder problem.
> >>>>>>>
> >>>>>>
> >>>>>> I tried to reproduce without using bridge and veth interfaces, and=
 it seems
> >>>>>> like it's not reproducible, so traffic forwarding via a bridge int=
erface may
> >>>>>> be necessary. It also does not happen if traffic load is low, but =
moderate
> >>>>>> load is enough - e.g. two 100 Mbps streams with 130-byte packets. =
It's easier
> >>>>>> to reproduce with a higher load.
> >>>>>>
> >>>>>> With about the same setup as in an original message (bridge + veth=
 2
> >>>>>> network namespaces), irqbalance daemon stopped, if traffic flows v=
ia
> >>>>>> enp2s0f0-rx-2 and enp2s0f0-rx-4, there's no reordering. enp2s0f0-r=
x-1
> >>>>>> still gets some interrupts, but at a much lower rate compared to 2=
 and
> >>>>>> 4.
> >>>>>>
> >>>>>> namespace 1:
> >>>>>>       # iperf3 -u -c server_ip -p 5000 -R -b 300M -t 300 -l 130
> >>>>>>       - - - - - - - - - - - - - - - - - - - - - - - - -
> >>>>>>       [ ID] Interval           Transfer     Bandwidth       Jitter=
    Lost/Total Datagrams
> >>>>>>       [  4]   0.00-300.00 sec  6.72 GBytes   192 Mbits/sec  0.008 =
ms  3805/55508325 (0.0069%)
> >>>>>>       [  4] Sent 55508325 datagrams
> >>>>>>
> >>>>>>       iperf Done.
> >>>>>>
> >>>>>> namespace 2:
> >>>>>>       # iperf3 -u -c server_ip -p 5001 -R -b 300M -t 300 -l 130
> >>>>>>       - - - - - - - - - - - - - - - - - - - - - - - - -
> >>>>>>       [ ID] Interval           Transfer     Bandwidth       Jitter=
    Lost/Total Datagrams
> >>>>>>       [  4]   0.00-300.00 sec  6.83 GBytes   196 Mbits/sec  0.005 =
ms  3873/56414001 (0.0069%)
> >>>>>>       [  4] Sent 56414001 datagrams
> >>>>>>
> >>>>>>       iperf Done.
> >>>>>>
> >>>>>>
> >>>>>> With the same configuration but different IP address so that inste=
ad of
> >>>>>> enp2s0f0-rx-4 enp2s0f0-rx-1 would be used, there is a reordering.
> >>>>>>
> >>>>>>
> >>>>>> namespace 1 (client IP was changed):
> >>>>>>       # iperf3 -u -c server_ip -p 5000 -R -b 300M -t 300 -l 130
> >>>>>>       - - - - - - - - - - - - - - - - - - - - - - - - -
> >>>>>>       [ ID] Interval           Transfer     Bandwidth       Jitter=
    Lost/Total Datagrams
> >>>>>>       [  4]   0.00-300.00 sec  6.32 GBytes   181 Mbits/sec  0.007 =
ms  8506/52172059 (0.016%)
> >>>>>>       [  4] Sent 52172059 datagrams
> >>>>>>       [SUM]  0.0-300.0 sec  2452 datagrams received out-of-order
> >>>>>>
> >>>>>>       iperf Done.
> >>>>>>
> >>>>>> namespace 2:
> >>>>>>       # iperf3 -u -c server_ip -p 5001 -R -b 300M -t 300 -l 130
> >>>>>>       - - - - - - - - - - - - - - - - - - - - - - - - -
> >>>>>>       [ ID] Interval           Transfer     Bandwidth       Jitter=
    Lost/Total Datagrams
> >>>>>>       [  4]   0.00-300.00 sec  6.59 GBytes   189 Mbits/sec  0.006 =
ms  6302/54463973 (0.012%)
> >>>>>>       [  4] Sent 54463973 datagrams
> >>>>>>
> >>>>>>       iperf Done.
> >>>>>>
> >>>>>> Swapping IP addresses in these namespaces also changes the namespa=
ce exhibiting the issue,
> >>>>>> it's following the IP address.
> >>>>>>
> >>>>>>
> >>>>>> Is there something I could check to confirm that this behavior is =
or is not
> >>>>>> related to napi_schedule(&tp->napi[1].napi) call?
> >>>>>
> >>>>> in the function tg3_msi_1shot() you could store the cpu assigned to
> >>>>> tnapi1 (inside the struct tg3_napi)
> >>>>> and then in tg3_poll_work() you can add another check after
> >>>>>            if (*(tnapi->rx_rcb_prod_idx) !=3D tnapi->rx_rcb_ptr)
> >>>>> something like
> >>>>> if (tnapi =3D=3D &tp->napi[1] && tnapi->assigned_cpu =3D=3D smp_pro=
cessor_id())
> >>>>> only then execute tg3_rx()
> >>>>>
> >>>>> This may stop tnapi 1 from reading rx pkts on the current CPU from
> >>>>> which refill is called.
> >>>>>
> >>>>
> >>>> Didn't work for me, perhaps I did something wrong - if tg3_rx() is n=
ot called,
> >>>> there's an infinite loop, and after I added "work_done =3D budget;",=
 it still doesn't
> >>>> work - traffic does not flow.
> >>>>
> >>>
> >>> I think the easiest way is to modify the tg3_rx() calling condition
> >>> like below inside
> >>> tg3_poll_work() :
> >>>
> >>> if (*(tnapi->rx_rcb_prod_idx) !=3D tnapi->rx_rcb_ptr) {
> >>>           if (tnapi !=3D &tp->napi[1] || (tnapi =3D=3D &tp->napi[1] &=
&
> >>> !tp->rx_refill)) {
> >>>                           work_done +=3D tg3_rx(tnapi, budget - work_=
done);
> >>>           }
> >>> }
> >>>
> >>> This will prevent reading rx packets when napi[1] is scheduled only f=
or refill.
> >>> Can you see if this works?
> >>>
> >>
> >> It doesn't hang and can receive the traffic with this change, but I do=
n't see
> >> a difference. I'm suspectig that tg3_poll_work() is called again, mayb=
e in tg3_poll_msix(),
> >> and refill happens first, and then packets are processed anyway.
> >>
> >
> > OK I see it now. Let me try this out myself. Will get back on this.
> > However, can you see with your debug prints if there is any correlation
> > between the time and number of prints where napi 1 is reading packets
> > on unassigned CPU to the time and number of packets you received
> > out of order up the stack? Do they match with each other? If not, we ma=
y be
> > incorrectly suspecting napi1 here.
> >
>
> No corellation that I can see - reordered packets are received sometimes =
-
> 10000 in 300 seconds in this test, but napi messages are logged and
> rate-limited at about 100000 per second. If bandwidth is very low, then
> there are no messages and no reordering. Not sure if I can isolate these
> events specifically.

I'm facing the same issue, multicast packet reordering received by tg3
going to a macvlan,
tcpdump on the nic is ok, tcpdump on the macvlan show reordering.
I'm using Alma 8.6, and for me the only fix is to go to 1 RX queue.

Was there another email thread with more progress / was there a fix
outside of tg3.c for this issue ?
(looking at the git log for tg3.c I don't see anything relevant)

Thanks
Etienne

>
> --
> Thanks
> Vitalii
>
>
>
