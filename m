Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84E86B6DDB
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 04:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCMDNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 23:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCMDNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 23:13:10 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFE361AA
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 20:13:04 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id z6so11979452qtv.0
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 20:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678677183;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=whWyeqitWsphyJd54vhyIkUgbH8sKt8CqjF2EH5msyU=;
        b=TTivJ5ntWUxiwVQ9DdKz++5fvwrha6j/+hDy9q2REXWQXE2SXBn+vHmgPus7NvVM8E
         18nM2Ni/VO43pKez1mBVQDrHllDlryV65CvfZHiejgM60Zl0gN3+NW471IeaXG0XfTsX
         8nF1bgerqEJkhG17qEEjvY3NEO1UujxEBPsYfKP8AzxjxhKzmaAp3sLs9pyYYDFAupos
         GfanMa6xpi4kXcKKL3DMZ1nWges0l8Axt1r+Q8CWAgy8NcmN9Axnl4m8PBalli6OfKrV
         v3K7Ury074sHMoeb50+mr3nq1ciGAzAPVOPDNqIS6202CmSg5hFny0PbzaXY+jdiktkC
         qDsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678677183;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=whWyeqitWsphyJd54vhyIkUgbH8sKt8CqjF2EH5msyU=;
        b=bKruHkwkp/Llqc2MMTivvFQJDqRTKQY7Updx2aExqlTpnChBdNNAOF5IReERpIj54h
         qxpQSdhLaT8fIliYJFHfJerzBbIlB6cZv506/FgDaJPmNmHG+i0uN9FIu3XiCqDkvYfQ
         YQrq7FVJGs/QsDmw57wrYDbrxH/Bmg/1IZytgwJTXkdYEHNu4fzyVbKh1PXJ/cy+zbZT
         wV6pYNOFEcrtrlIcuPyPMltX8HuaKxnA9isj5G1v0MbA2PWX2HNm4m+X3IWbCfMcqG5Y
         35OVE/MqpXbJgan5wQuFIru6G0bM6aa9Q6mbDPF2zEqKkwMo1+iveJuw6oBnCnDRA1vm
         XlEg==
X-Gm-Message-State: AO0yUKUlVYCqlEYE+8wKX1Ra51zU95QJ7/fHZpYvviXacu9Oy76rhcWI
        VSNNg0wdUR7/ofhi/iDih0GQkYwSfrk=
X-Google-Smtp-Source: AK7set/X9uwiD1TVwgqNqoiF7NPoBHapm5qJuaWiTTIyHDeHZGCWlK3p9X03r4Q8ipGxqohu592h0A==
X-Received: by 2002:a05:622a:609:b0:3bf:c388:cbea with SMTP id z9-20020a05622a060900b003bfc388cbeamr58884713qta.43.1678677183647;
        Sun, 12 Mar 2023 20:13:03 -0700 (PDT)
Received: from ?IPV6:2607:fea8:1b9f:c5b0::4c4? ([2607:fea8:1b9f:c5b0::4c4])
        by smtp.gmail.com with ESMTPSA id i14-20020ac8764e000000b003c034837d8fsm4710207qtr.33.2023.03.12.20.13.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Mar 2023 20:13:03 -0700 (PDT)
Message-ID: <da4c461c-324f-76e3-b114-4579bbb60172@gmail.com>
Date:   Sun, 12 Mar 2023 23:13:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Etienne Champetier <champetier.etienne@gmail.com>
Subject: Re: mv88e6xxx / MV88E6176 + VLAN-aware unusable in 5.15.98 (ok in
 5.10.168) (resend)
To:     Tobias Waldekranz <tobias@waldekranz.com>
References: <cd306c78-14a6-bebb-e174-2917734b4799@gmail.com>
 <87edpudv9c.fsf@waldekranz.com>
Content-Language: en-US, fr-FR
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
In-Reply-To: <87edpudv9c.fsf@waldekranz.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 12/03/2023 à 08:11, Tobias Waldekranz a écrit :
> On sön, mar 12, 2023 at 00:41, Etienne Champetier 
> <champetier.etienne@gmail.com> wrote:
>> (properly formatted this time)
>>
>> Hello Vladimir, Tobias,
>>
>> Sending this email to both of you as reverting some of your patches 
>> 'fix' the issues I'm seeing.
>> I'm slowly investigating a regression in OpenWrt going from 22.03 
>> (5.10.168 + some backports)
>> to current master (5.15.98 + some backports). Using my Turris Omnia 
>> (MV88E6176) with the following network config:
>>
>> # bridge vlan
>> port vlan-id
>> lan0 6 PVID Egress Untagged
>> lan1 5 PVID Egress Untagged
>> lan2 4 PVID Egress Untagged
>> lan3 3 PVID Egress Untagged
>> lan4 2 PVID Egress Untagged
>> br-lan 2
>> 3
>> 4
>> 5
>> 6
>> wlan1 3 PVID Egress Untagged
>> wlan1-1 5 PVID Egress Untagged
>> wlan1-2 6 PVID Egress Untagged
>> wlan0 2 PVID Egress Untagged
>>
>> I get tagged frame with VID 3 on lan4 (at least some multicast & 
>> broadcast), but lan4 is not a member of VLAN 3
> Are these packets being sent to the CPU with a FORWARD tag or TO_CPU? If
> it is the latter, what is the CPU_CODE set to? Better yet, could you
> post some output from `tcpdump -Q in -evnli <YOUR-DSA-INTERFACE>`?

To clear out some possible confusion, I capturing on a laptop connected 
to lan4, not using `tcpdump -i lan4`

On the router,
root@turris:~# tcpdump -Q out -evnli eth1
tcpdump: listening on eth1, link-type DSA_TAG_EDSA (Marvell EDSA), 
snapshot length 262144 bytes
02:26:36.735092 c8:4a:a0:b7:1e:d7 > 33:33:00:01:00:02, Marvell EDSA 
ethertype 0xdada (Unknown), rsvd 0 0, mode Forward, dev 1, port 0, 
tagged, VID 3, FPri 0, ethertype IPv6 (0x86dd), length 118: ...
02:26:38.524915 ca:d0:2c:4f:ed:bb > 01:00:5e:7f:ff:fa, Marvell EDSA 
ethertype 0xdada (Unknown), rsvd 0 0, mode Forward, dev 1, port 0, 
tagged, VID 2, FPri 0, ethertype IPv4 (0x0800), length 175: ...
02:26:38.825569 ca:d0:2c:4f:ed:bb > 01:00:5e:7f:ff:fa, Marvell EDSA 
ethertype 0xdada (Unknown), rsvd 0 0, mode Forward, dev 1, port 0, 
tagged, VID 2, FPri 0, ethertype IPv4 (0x0800), length 175: ...
02:26:39.124409 ca:d0:2c:4f:ed:bb > 01:00:5e:7f:ff:fa, Marvell EDSA 
ethertype 0xdada (Unknown), rsvd 0 0, mode Forward, dev 1, port 0, 
tagged, VID 2, FPri 0, ethertype IPv4 (0x0800), length 175: ...
02:26:40.186939 d8:58:d7:00:4e:39 > ff:ff:ff:ff:ff:ff, Marvell EDSA 
ethertype 0xdada (Unknown), rsvd 0 0, mode Forward, dev 1, port 0, 
tagged, VID 3, FPri 0, ethertype ARP (0x0806), length 50: ...
02:26:41.218401 d8:58:d7:00:4e:39 > ff:ff:ff:ff:ff:ff, Marvell EDSA 
ethertype 0xdada (Unknown), rsvd 0 0, mode Forward, dev 1, port 0, 
tagged, VID 3, FPri 0, ethertype ARP (0x0806), length 50: ...
02:26:42.258393 d8:58:d7:00:4e:39 > ff:ff:ff:ff:ff:ff, Marvell EDSA 
ethertype 0xdada (Unknown), rsvd 0 0, mode Forward, dev 1, port 0, 
tagged, VID 3, FPri 0, ethertype ARP (0x0806), length 50: ...

On the laptop

[root@echampetier ~]# tcpdump -evnli enp0s31f6 -Q in
dropped privs to tcpdump
tcpdump: listening on enp0s31f6, link-type EN10MB (Ethernet), snapshot 
length 262144 bytes
22:26:36.757382 c8:4a:a0:b7:1e:d7 > 33:33:00:01:00:02, ethertype 802.1Q 
(0x8100), length 114: vlan 3, p 0, ethertype IPv6 (0x86dd), ...
22:26:38.547328 ca:d0:2c:4f:ed:bb > 01:00:5e:7f:ff:fa, ethertype IPv4 
(0x0800), length 167: ...
22:26:38.847746 ca:d0:2c:4f:ed:bb > 01:00:5e:7f:ff:fa, ethertype IPv4 
(0x0800), length 167: ...
22:26:39.146702 ca:d0:2c:4f:ed:bb > 01:00:5e:7f:ff:fa, ethertype IPv4 
(0x0800), length 167: ...
22:26:40.209365 d8:58:d7:00:4e:39 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q 
(0x8100), length 60: vlan 3, p 0, ethertype ARP (0x0806), ...
22:26:41.240603 d8:58:d7:00:4e:39 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q 
(0x8100), length 60: vlan 3, p 0, ethertype ARP (0x0806), ...
22:26:42.280428 d8:58:d7:00:4e:39 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q 
(0x8100), length 60: vlan 3, p 0, ethertype ARP (0x0806), ...


>> Also unicast frames from wifi to lan4 exit tagged with VID 2, 
>> broadcast frames are fine (verifed with scapy)
> If you're capturing on the lan4 interface, this is to be expected.

As clarified, I'm capturing on a laptop connected to lan4

> When forwarding offloading is enabled. In order for the tag driver to
> generate the correct DSA tag, we need to know to which VLAN the packet
> belongs (there could be more than one VLAN configured to egress
> untagged). Since a FORWARD tag is (should be) generated, the switch will
> handle the stripping of the VLAN tag for untagged members.
>
> If you tcpdump at the DSA interface, are the packet sent to the switch
> with a FORWARD tag or FROM_CPU?

If the dst mac is not in `bridge fdb` / the ATU, frame arrives untagged 
(as they should)
root@turris:~# tcpdump -Q out -evnli eth1
tcpdump: listening on eth1, link-type DSA_TAG_EDSA (Marvell EDSA), 
snapshot length 262144 bytes
02:39:02.835931 44:85:00:cf:86:45 > ff:ff:ff:ff:ff:ff, Marvell EDSA 
ethertype 0xdada (Unknown), rsvd 0 0, mode Forward, dev 1, port 0, 
tagged, VID 2, FPri 0, ethertype ARP (0x0806), length 50: Ethernet (len 
6), IPv4 (len 4), Request who-has 5.6.7.8 tell 1.2.3.4, length 28
02:39:04.089792 44:85:00:cf:86:45 > 50:7b:9d:f0:06:4e, Marvell EDSA 
ethertype 0xdada (Unknown), rsvd 0 0, mode Forward, dev 1, port 0, 
tagged, VID 2, FPri 0, ethertype ARP (0x0806), length 50: Ethernet (len 
6), IPv4 (len 4), Request who-has 5.6.7.8 tell 1.2.3.4, length 28
[root@echampetier ~]# tcpdump -evnnli enp0s31f6 -Q in
tcpdump: listening on enp0s31f6, link-type EN10MB (Ethernet), snapshot 
length 262144 bytes
22:39:02.859622 44:85:00:cf:86:45 > ff:ff:ff:ff:ff:ff, ethertype ARP 
(0x0806), length 60: Ethernet (len 6), IPv4 (len 4), Request who-has 
5.6.7.8 tell 1.2.3.4, length 46
22:39:04.113555 44:85:00:cf:86:45 > 50:7b:9d:f0:06:4e, ethertype ARP 
(0x0806), length 60: Ethernet (len 6), IPv4 (len 4), Request who-has 
5.6.7.8 tell 1.2.3.4, length 46

If the dst is not silent / present in `bridge fdb` / the ATU
root@turris:~# bridge fdb | grep ^50
50:7b:9d:f0:06:4e dev lan4 vlan 2 master br-lan
50:7b:9d:f0:06:4e dev lan4 vlan 2 self
(I see some entries with offload, not this one)

root@turris:~# mv88e6xxx_dump --atu
FID MAC T 0123456 Prio State
7 50:7b:9d:f0:06:4e 00001000000 0 Age 7

then we have
02:47:13.427645 44:85:00:cf:86:45 > ff:ff:ff:ff:ff:ff, Marvell EDSA 
ethertype 0xdada (Unknown), rsvd 0 0, mode Forward, dev 1, port 0, 
tagged, VID 2, FPri 0, ethertype ARP (0x0806), length 50: Ethernet (len 
6), IPv4 (len 4), Request who-has 5.6.7.8 tell 1.2.3.4, length 28
02:47:14.409168 44:85:00:cf:86:45 > 50:7b:9d:f0:06:4e, Marvell EDSA 
ethertype 0xdada (Unknown), rsvd 0 0, mode From CPU, target dev 0, port 
4, tagged, VID 2, FPri 0, ethertype ARP (0x0806), length 50: Ethernet 
(len 6), IPv4 (len 4), Request who-has 5.6.7.8 tell 1.2.3.4, length 28
02:47:15.383509 44:85:00:cf:86:45 > ff:ff:ff:ff:ff:ff, Marvell EDSA 
ethertype 0xdada (Unknown), rsvd 0 0, mode Forward, dev 1, port 0, 
tagged, VID 2, FPri 0, ethertype ARP (0x0806), length 50: Ethernet (len 
6), IPv4 (len 4), Request who-has 5.6.7.8 tell 1.2.3.4, length 28

22:47:13.440691 44:85:00:cf:86:45 > ff:ff:ff:ff:ff:ff, ethertype ARP 
(0x0806), length 60: Ethernet (len 6), IPv4 (len 4), Request who-has 
5.6.7.8 tell 1.2.3.4, length 46
22:47:14.422167 44:85:00:cf:86:45 > 50:7b:9d:f0:06:4e, ethertype 802.1Q 
(0x8100), length 60: vlan 2, p 0, ethertype ARP (0x0806), Ethernet (len 
6), IPv4 (len 4), Request who-has 5.6.7.8 tell 1.2.3.4, length 42
22:47:15.396450 44:85:00:cf:86:45 > ff:ff:ff:ff:ff:ff, ethertype ARP 
(0x0806), length 60: Ethernet (len 6), IPv4 (len 4), Request who-has 
5.6.7.8 tell 1.2.3.4, length 46


>> Reverting
>> 5bded8259ee3 "net: dsa: mv88e6xxx: isolate the ATU databases of 
>> standalone and bridged ports" from Vladimir
>> and
>> b80dc51b72e2 "net: dsa: mv88e6xxx: Only allow LAG offload on 
>> supported hardware"
>> 57e661aae6a8 "net: dsa: mv88e6xxx: Link aggregation support"
>> from Tobias allow me to get back to 5.10 behavior / working system.
>>
>> On the OpenWrt side, 5.15 is the latest supported kernel, so I was 
>> not able to try more recent for now.
>>
>> I'm happy to try to backport any patches that can help fix or narrow 
>> down the issue, or provide more infos / tests results.
>>
>> These issues affect other devices using mv88e6xxx: 
>> https://github.com/openwrt/openwrt/issues/11877
>> In the Github issue the reporter note that first packet is not tagged 
>> and the following are.
>>
>> Here a diff of "mv88e6xxx_dump --vtu --ports --global1 --global2" 
>> between 5.10 and 5.15 (without revert)
>>
>> @@ -9,18 +9,18 @@
>> 05 Port control 1 0000 0000 0000 0000 0000 0000 0000
>> 06 Port base VLAN map 007e 007d 007b 0077 006f 005f 003f
>> 07 Def VLAN ID & Prio 0006 0005 0004 0003 0002 0000 0000
>> -08 Port control 2 0c80 0c80 0c80 0c80 0c80 1080 2080
>> +08 Port control 2 0c80 0c80 0c80 0c80 0c80 1080 1080
>> 09 Egress rate control 0001 0001 0001 0001 0001 0001 0001
>> 0a Egress rate control 2 0000 0000 0000 0000 0000 0000 0000
>> -0b Port association vec 1001 1002 1004 1008 1010 1000 1000
>> +0b Port association vec 1001 1002 1004 1008 1010 1020 1040
>> 0c Port ATU control 0000 0000 0000 0000 0000 0000 0000
>> 0d Override 0000 0000 0000 0000 0000 0000 0000
>> 0e Policy control 0000 0000 0000 0000 0000 0000 0000
>> 0f Port ether type 9100 9100 9100 9100 9100 dada dada
>> 10 In discard low 0000 0000 0000 0000 0000 0000 0000
>> 11 In discard high 0000 0000 0000 0000 0000 0000 0000
>> -12 In filtered 0000 0000 0000 0000 0000 0000 0000
>> -13 RX frame count 0000 0000 0000 008c 0000 021a 0000
>> +12 In filtered 0000 0000 0000 0003 0000 0000 0000
>> +13 RX frame count 0000 0000 0000 008e 0000 04dd 0000
>> 14 Reserved 0000 0000 0000 0000 0000 0000 0000
>> 15 Reserved 0000 0000 0000 0000 0000 0000 0000
>> 16 LED control 0000 0000 0000 0000 0000 0000 0000
>> @@ -39,22 +39,23 @@
>> T - a member, egress tagged
>> X - not a member, Ingress frames with VID discarded
>> P VID 0123456 FID SID QPrio FPrio VidPolicy
>> -0 1 XXXXXVV 1 0 - - 0
>> -0 2 XXXXUVV 6 0 - - 0
>> -0 3 XXXUXVV 5 0 - - 0
>> -0 4 XXUXXVV 4 0 - - 0
>> -0 5 XUXXXVV 3 0 - - 0
>> -0 6 UXXXXVV 2 0 - - 0
>> +0 1 XXXXXVV 2 0 - - 0
>> +0 2 XXXXUVV 7 0 - - 0
>> +0 3 XXXUXVV 6 0 - - 0
>> +0 4 XXUXXVV 5 0 - - 0
>> +0 5 XUXXXVV 4 0 - - 0
>> +0 6 UXXXXVV 3 0 - - 0
>> +0 4095 UUUUUVV 1 0 - - 0
>> Global1:
>> 00 Global status c814
>> -01 ATU FID 0006
>> -02 VTU FID 0002
>> +01 ATU FID 0007
>> +02 VTU FID 0001
>> 03 VTU SID 0000
>> 04 Global control 40a8
>> -05 VTU operations 4000
>> -06 VTU VID 0fff
>> -07 VTU/STU Data 0-3 3331
>> -08 VTU/STU Data 4-6 0303
>> +05 VTU operations 4043
>> +06 VTU VID 1fff
>> +07 VTU/STU Data 0-3 1111
>> +08 VTU/STU Data 4-6 0111
>> 09 Reserved 0000
>> 0a ATU control 0149
>> 0b ATU operations 4000
>> @@ -90,10 +91,10 @@
>> 08 Trunk mapping 7800
>> 09 Ingress rate command 1600
>> 0a Ingress rate data 0000
>> -0b Cross chip port VLAN addr 31ff
>> -0c Cross chip port VLAN data 0000
>> -0d Switch MAC/WoL/WoF 05c5
>> -0e ATU Stats 000f
>> +0b Cross chip port VLAN addr 3010
>> +0c Cross chip port VLAN data 007f
>> +0d Switch MAC/WoL/WoF 05fe
>> +0e ATU Stats 001f
>> 0f Priority override table 0f00
>> 10 Reserved 0000
>> 11 Reserved 0000
>>
>> Thanks in advance
>> Etienne
