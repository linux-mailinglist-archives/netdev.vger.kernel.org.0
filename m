Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF80520F15C
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 11:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731910AbgF3JPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 05:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729866AbgF3JPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 05:15:38 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8D5C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 02:15:38 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h22so14429825lji.9
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 02:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:cc:subject:from:to:date:message-id
         :in-reply-to;
        bh=T3joqHkLHraTuPnWCUoikewNR5I9EBQzqVSvwFZJcPs=;
        b=it2VVlrzKIINX7HF+K2rxW25mK/HfuPt4hiXOSueskjBJb3YCQCXQSbcNJb052BRue
         asbFsl8nDKhL48oYu8dPeeq1a7UkSrH/hEv3oh5PqJHWd6iMtubgEskiRE3bMEHjOP6v
         cAbr+L2lLAqPR4GH5xYCxBDG5gxfrVOcDG5X2dg/cxEgk/hxFFuEubShUp4Io7d5+X2M
         vjhChobhXPuKL6Oa8CtfSHKZm6gxcCzOryxXB//vrwHvokKL06lm2H87VS7fd3L5T8T8
         +DCPSq6lFl41iyrMM8imvUiANk1cu6R1KwdV9sbiL6a/FtTM5z5XImmu/hrnv83PqbXu
         aEQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:cc:subject:from:to
         :date:message-id:in-reply-to;
        bh=T3joqHkLHraTuPnWCUoikewNR5I9EBQzqVSvwFZJcPs=;
        b=fHymqeaMDgS/zYwvUIE5LAZCPOV0phWfMXdX1YrJ0GGblWsUakmb93iziI+o2brSWc
         bAmyMYlc5ZNhiTF7w4UG8iUbdvkSR0nsiAi3cPhfWUBxPY0MSA+9iAnCLlwbamH3U5lF
         M4sVTnWvAdtiLUBJNZNd9zpEV6952OYLzWwAjHuFRekyfzIoC6ciXEMJwkwtXWAZt2eo
         z+DEQYpvxC8CD/0nhl5nE43egBf6vuyxb7xms2udEthag8UUbIw67x4wsWlpCoDYyWnN
         Hz8nYiSHeSr7A7Gcte4yGGUQeLUU2O1CqYCrr7K+gKHZnh3SZYSZQ2cV7lSLzdqNaMjS
         edyA==
X-Gm-Message-State: AOAM530+niZYLkOcL6BWR0aIie/R2+FVVzxG+Hi1LD8nXYsnaRxH0mzp
        non1fNyb2JH2BRQuJc1dAfdacZKt3X0=
X-Google-Smtp-Source: ABdhPJzsJO66ERK+SkhY9RezunPsooCP0WoxrtX8UoejWTzGxYZuUwCnEJHqgKO+bXGvi1PTjoPHFw==
X-Received: by 2002:a2e:b554:: with SMTP id a20mr9370132ljn.108.1593508536491;
        Tue, 30 Jun 2020 02:15:36 -0700 (PDT)
Received: from localhost (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id q13sm597642lfb.55.2020.06.30.02.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 02:15:34 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next] net: ethernet: fec: prevent tx
 starvation under high rx load
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Andy Duan" <fugang.duan@nxp.com>,
        "David Miller" <davem@davemloft.net>
Date:   Tue, 30 Jun 2020 11:12:30 +0200
Message-Id: <C3UBKDYGF8HW.TITR4KSQBHBQ@wkz-x280>
In-Reply-To: <AM6PR0402MB3607C60F2C8E7B3E63906B6AFF6F0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue Jun 30, 2020 at 11:02 AM CEST, Andy Duan wrote:
> From: Tobias Waldekranz <tobias@waldekranz.com> Sent: Tuesday, June 30,
> 2020 4:56 PM
> > On Tue Jun 30, 2020 at 10:26 AM CEST, Andy Duan wrote:
> > > From: Tobias Waldekranz <tobias@waldekranz.com> Sent: Tuesday, June
> > > 30,
> > > 2020 3:31 PM
> > > > On Tue Jun 30, 2020 at 8:27 AM CEST, Andy Duan wrote:
> > > > > From: Tobias Waldekranz <tobias@waldekranz.com> Sent: Tuesday,
> > > > > June 30,
> > > > > 2020 12:29 AM
> > > > > > On Sun Jun 28, 2020 at 8:23 AM CEST, Andy Duan wrote:
> > > > > > > I never seem bandwidth test cause netdev watchdog trip.
> > > > > > > Can you describe the reproduce steps on the commit, then we
> > > > > > > can reproduce it on my local. Thanks.
> > > > > >
> > > > > > My setup uses a i.MX8M Nano EVK connected to an ethernet switch=
,
> > > > > > but can get the same results with a direct connection to a PC.
> > > > > >
> > > > > > On the iMX, configure two VLANs on top of the FEC and enable
> > > > > > IPv4 forwarding.
> > > > > >
> > > > > > On the PC, configure two VLANs and put them in different
> > namespaces.
> > > > > > From one namespace, use trafgen to generate a flow that the iMX
> > > > > > will route from the first VLAN to the second and then back
> > > > > > towards the second namespace on the PC.
> > > > > >
> > > > > > Something like:
> > > > > >
> > > > > >     {
> > > > > >         eth(sa=3DPC_MAC, da=3DIMX_MAC),
> > > > > >         ipv4(saddr=3D10.0.2.2, daddr=3D10.0.3.2, ttl=3D2)
> > > > > >         udp(sp=3D1, dp=3D2),
> > > > > >         "Hello world"
> > > > > >     }
> > > > > >
> > > > > > Wait a couple of seconds and then you'll see the output from
> > fec_dump.
> > > > > >
> > > > > > In the same setup I also see a weird issue when running a TCP
> > > > > > flow using iperf3. Most of the time (~70%) when i start the
> > > > > > iperf3 client I'll see ~450Mbps of throughput. In the other cas=
e
> > > > > > (~30%) I'll see ~790Mbps. The system is "stably bi-modal", i.e.
> > > > > > whichever rate is reached in the beginning is then sustained fo=
r
> > > > > > as long as the session is kept
> > > > alive.
> > > > > >
> > > > > > I've inserted some tracepoints in the driver to try to
> > > > > > understand what's going
> > > > > > on:
> > > > > > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%=
2F%
> > > > > > 2Fsv
> > > > > > gsha
> > > >
> > re.com%2Fi%2FMVp.svg&amp;data=3D02%7C01%7Cfugang.duan%40nxp.com%
> > > > > >
> > > >
> > 7C12854e21ea124b4cc2e008d81c59d618%7C686ea1d3bc2b4c6fa92cd99c5c
> > > > > >
> > > >
> > 301635%7C0%7C0%7C637290519453656013&amp;sdata=3Dby4ShOkmTaRkFfE
> > > > > > 0xJkrTptC%2B2egFf9iM4E5hx4jiSU%3D&amp;reserved=3D0
> > > > > >
> > > > > > What I can't figure out is why the Tx buffers seem to be
> > > > > > collected at a much slower rate in the slow case (top in the
> > > > > > picture). If we fall behind in one NAPI poll, we should catch u=
p
> > > > > > at the next call (which we
> > > > can see in the fast case).
> > > > > > But in the slow case we keep falling further and further behind
> > > > > > until we freeze the queue. Is this something you've ever
> > > > > > observed? Any
> > > > ideas?
> > > > >
> > > > > Before, our cases don't reproduce the issue, cpu resource has
> > > > > better bandwidth than ethernet uDMA then there have chance to
> > > > > complete current NAPI. The next, work_tx get the update, never ca=
tch
> > the issue.
> > > >
> > > > It appears it has nothing to do with routing back out through the
> > > > same interface.
> > > >
> > > > I get the same bi-modal behavior if just run the iperf3 server on
> > > > the iMX and then have it be the transmitting part, i.e. on the PC I=
 run:
> > > >
> > > >     iperf3 -c $IMX_IP -R
> > > >
> > > > I would be very interesting to see what numbers you see in this sce=
nario.
> > > I just have on imx8mn evk in my hands, and run the case, the numbers
> > > is ~940Mbps as below.
> > >
> > > root@imx8mnevk:~# iperf3 -s
> > > -----------------------------------------------------------
> > > Server listening on 5201
> > > -----------------------------------------------------------
> > > Accepted connection from 10.192.242.132, port 43402 [ 5] local
> > > 10.192.242.96 port 5201 connected to 10.192.242.132 port
> > > 43404
> > > [ ID] Interval Transfer Bitrate Retr Cwnd [ 5] 0.00-1.00 sec 109
> > > MBytes 913 Mbits/sec 0 428 KBytes [ 5] 1.00-2.00 sec 112 MBytes 943
> > > Mbits/sec 0 447 KBytes [ 5] 2.00-3.00 sec 112 MBytes 941 Mbits/sec 0
> > > 472 KBytes [ 5] 3.00-4.00 sec 113 MBytes 944 Mbits/sec 0 472 KBytes [
> > > 5] 4.00-5.00 sec 112 MBytes 942 Mbits/sec 0 472 KBytes [ 5] 5.00-6.00
> > > sec 112 MBytes 936 Mbits/sec 0 472 KBytes [ 5] 6.00-7.00 sec 113
> > > MBytes 945 Mbits/sec 0 472 KBytes [ 5] 7.00-8.00 sec 112 MBytes 944
> > > Mbits/sec 0 472 KBytes [ 5] 8.00-9.00 sec 112 MBytes 941 Mbits/sec 0
> > > 472 KBytes [ 5] 9.00-10.00 sec 112 MBytes 940 Mbits/sec 0 472 KBytes =
[
> > > 5] 10.00-10.04 sec 4.16 MBytes 873 Mbits/sec 0 472 KBytes
> > > - - - - - - - - - - - - - - - - - - - - - - - - - [ ID] Interval
> > > Transfer Bitrate Retr [ 5] 0.00-10.04 sec 1.10 GBytes 939 Mbits/sec 0
> > > sender
> >=20
> > Are you running the client with -R so that the iMX is the transmitter?
> > What if you run the test multiple times, do you get the same result eac=
h time?
>
> Of course, PC command like: iperf3 -c 10.192.242.96 -R
> Yes, the same result for each time.

Very strange, I've now reduced my setup to a simple direct connection
between iMX and PC and I still see the same issue:

for i in $(seq 5); do iperf3 -c 10.0.2.1 -R -t2; sleep 1; done
Connecting to host 10.0.2.1, port 5201
Reverse mode, remote host 10.0.2.1 is sending
[  5] local 10.0.2.2 port 53978 connected to 10.0.2.1 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   110 MBytes   919 Mbits/sec
[  5]   1.00-2.00   sec   112 MBytes   941 Mbits/sec    0   0.00 Bytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-2.04   sec   223 MBytes   918 Mbits/sec    0             sende=
r
[  5]   0.00-2.00   sec   222 MBytes   930 Mbits/sec                  recei=
ver

iperf Done.
Connecting to host 10.0.2.1, port 5201
Reverse mode, remote host 10.0.2.1 is sending
[  5] local 10.0.2.2 port 53982 connected to 10.0.2.1 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  55.8 MBytes   468 Mbits/sec
[  5]   1.00-2.00   sec  56.3 MBytes   472 Mbits/sec    0   0.00 Bytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-2.04   sec   113 MBytes   464 Mbits/sec    0             sende=
r
[  5]   0.00-2.00   sec   112 MBytes   470 Mbits/sec                  recei=
ver

iperf Done.
Connecting to host 10.0.2.1, port 5201
Reverse mode, remote host 10.0.2.1 is sending
[  5] local 10.0.2.2 port 53986 connected to 10.0.2.1 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  55.7 MBytes   467 Mbits/sec
[  5]   1.00-2.00   sec  56.3 MBytes   472 Mbits/sec    0   0.00 Bytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-2.04   sec   113 MBytes   464 Mbits/sec    0             sende=
r
[  5]   0.00-2.00   sec   112 MBytes   470 Mbits/sec                  recei=
ver

iperf Done.
Connecting to host 10.0.2.1, port 5201
Reverse mode, remote host 10.0.2.1 is sending
[  5] local 10.0.2.2 port 53990 connected to 10.0.2.1 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   110 MBytes   920 Mbits/sec
[  5]   1.00-2.00   sec   112 MBytes   942 Mbits/sec    0   0.00 Bytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-2.04   sec   223 MBytes   919 Mbits/sec    0             sende=
r
[  5]   0.00-2.00   sec   222 MBytes   931 Mbits/sec                  recei=
ver

iperf Done.
Connecting to host 10.0.2.1, port 5201
Reverse mode, remote host 10.0.2.1 is sending
[  5] local 10.0.2.2 port 53994 connected to 10.0.2.1 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   110 MBytes   920 Mbits/sec
[  5]   1.00-2.00   sec   112 MBytes   941 Mbits/sec    0   0.00 Bytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-2.04   sec   223 MBytes   918 Mbits/sec    0             sende=
r
[  5]   0.00-2.00   sec   222 MBytes   931 Mbits/sec                  recei=
ver

iperf Done.

Which kernel version are you running? I'm on be74294ffa24 plus the
starvation fix in this patch.
