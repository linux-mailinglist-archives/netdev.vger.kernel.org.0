Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E202481680
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 20:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhL2T65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 14:58:57 -0500
Received: from poczta.tygrys.net ([213.108.112.254]:39854 "EHLO tygrys.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231419AbhL2T64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 14:58:56 -0500
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Dec 2021 14:58:56 EST
Received: from psi-laptop-x1 (unknown [192.168.0.142])
        by tygrys.net (Postfix) with ESMTPSA id 9CB5C446E576;
        Wed, 29 Dec 2021 20:50:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nowatel.com;
        s=default; t=1640807443;
        bh=5BD2b+T6U2hmby/6i6WoBWmilFcjZsapkFQ/yKYHX/s=;
        h=Date:From:Reply-To:To:CC:Subject;
        b=NfBtoV4U/Npg4ECw4lB8+e3eJ8UCu7vfAiVpDk55pQ3GLo7qsW2UEAhqrH6zZ9ENu
         JCvG4jaES5ZuXnID4ZKEOaY6B63hMKv4rkM6JP+4+TK4mJZ10o4s6Ah5zHwVWACBtX
         fMykvyQDm/CzQpyArnhdRT/pyj1Quv86AFQf9ES8=
Date:   Wed, 29 Dec 2021 20:50:44 +0100
From:   =?utf-8?Q?Stanis=C5=82aw_Czech?= <s.czech@nowatel.com>
Reply-To: =?utf-8?Q?Stanis=C5=82aw_Czech?= <s.czech@nowatel.com>
Organization: Nowatel Sp. z o.o.
Message-ID: <1429844592.20211229205044@nowatel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: htb offload support in i40e (intel nic)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I saw that the htb offload needs additional changes in the mlx5 driver to s=
upport it.
I couldn't find any info regarding the htb offload support on any other dri=
vers/vendors like intel
nic (i40e) We use multiple XL710 that seems to support hardware tc queues:

qdisc noqueue 0: dev lo root refcnt 2
qdisc mq 0: dev enp65s0f1 root
qdisc fq_codel 0: dev enp65s0f1 parent :18 limit 10240p flows 1024 quantum =
1514                                                                       =
                                       target 5ms interval 100ms memory_lim=
it 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :17 limit 10240p flows 1024 quantum =
1514                                                                       =
                                       target 5ms interval 100ms memory_lim=
it 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :16 limit 10240p flows 1024 quantum =
1514                                                                       =
                                       target 5ms interval 100ms memory_lim=
it 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :15 limit 10240p flows 1024 quantum =
1514                                                                       =
                                       target 5ms interval 100ms memory_lim=
it 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :14 limit 10240p flows 1024 quantum =
1514                                                                       =
                                       target 5ms interval 100ms memory_lim=
it 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :13 limit 10240p flows 1024 quantum =
1514                                                                       =
                                       target 5ms interval 100ms memory_lim=
it 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :12 limit 10240p flows 1024 quantum =
1514                                                                       =
                                       target 5ms interval 100ms memory_lim=
it 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :11 limit 10240p flows 1024 quantum =
1514                                                                       =
                                       target 5ms interval 100ms memory_lim=
it 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :10 limit 10240p flows 1024 quantum =
1514                                                                       =
                                       target 5ms interval 100ms memory_lim=
it 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :f limit 10240p flows 1024 quantum 1=
514 t                                                                      =
                                       arget 5ms interval 100ms memory_limi=
t 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :e limit 10240p flows 1024 quantum 1=
514 t                                                                      =
                                       arget 5ms interval 100ms memory_limi=
t 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :d limit 10240p flows 1024 quantum 1=
514 t                                                                      =
                                       arget 5ms interval 100ms memory_limi=
t 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :c limit 10240p flows 1024 quantum 1=
514 t                                                                      =
                                       arget 5ms interval 100ms memory_limi=
t 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :b limit 10240p flows 1024 quantum 1=
514 t                                                                      =
                                       arget 5ms interval 100ms memory_limi=
t 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :a limit 10240p flows 1024 quantum 1=
514 t                                                                      =
                                       arget 5ms interval 100ms memory_limi=
t 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :9 limit 10240p flows 1024 quantum 1=
514 t                                                                      =
                                       arget 5ms interval 100ms memory_limi=
t 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :8 limit 10240p flows 1024 quantum 1=
514 t                                                                      =
                                       arget 5ms interval 100ms memory_limi=
t 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :7 limit 10240p flows 1024 quantum 1=
514 t                                                                      =
                                       arget 5ms interval 100ms memory_limi=
t 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :6 limit 10240p flows 1024 quantum 1=
514 t                                                                      =
                                       arget 5ms interval 100ms memory_limi=
t 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :5 limit 10240p flows 1024 quantum 1=
514 t                                                                      =
                                       arget 5ms interval 100ms memory_limi=
t 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :4 limit 10240p flows 1024 quantum 1=
514 t                                                                      =
                                       arget 5ms interval 100ms memory_limi=
t 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :3 limit 10240p flows 1024 quantum 1=
514 t                                                                      =
                                       arget 5ms interval 100ms memory_limi=
t 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :2 limit 10240p flows 1024 quantum 1=
514 t                                                                      =
                                       arget 5ms interval 100ms memory_limi=
t 32Mb ecn drop_batch 64
qdisc fq_codel 0: dev enp65s0f1 parent :1 limit 10240p flows 1024 quantum 1=
514 t                                                                      =
                                       arget 5ms interval 100ms memory_limi=
t 32Mb ecn drop_batch 64

Is this enough to support the htb offload or we must wait for the driver up=
date to support it?



Greetings,
Stanis=C5=82aw Czech

=C2=A0

