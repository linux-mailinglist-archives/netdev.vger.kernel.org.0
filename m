Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD22455F26
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 16:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbhKRPRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 10:17:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56963 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229583AbhKRPRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 10:17:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637248488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=G4oRpuSTmBkd4PVdly95kO3JvOq0lOC0VYbda5fY7Qg=;
        b=ay7SZEan/jspfaeepg3MWIQBJYXmzUylARAmZiGrbR2k4/wx488gKeaHSIYLsOH2Vc1o+j
        Kvt8y9gAjcMC7wycVNaOvgxIvd7Yxp0FPo4lHK3nBtQkWZHONW1ZbFBm8BzKZt7H89rnZT
        +TkfysT/FPE+huXKhFTzTYJ2duOAeb4=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-uIFLWoGLPr-hu80TAleLnQ-1; Thu, 18 Nov 2021 10:14:47 -0500
X-MC-Unique: uIFLWoGLPr-hu80TAleLnQ-1
Received: by mail-il1-f199.google.com with SMTP id j13-20020a056e02218d00b002677e6a569bso4248166ila.11
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 07:14:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=G4oRpuSTmBkd4PVdly95kO3JvOq0lOC0VYbda5fY7Qg=;
        b=H/EysYfNF+ZzLnx2vxdz9+7ZTGO9y83sNdMveQ/+ZrCKLU+Z92mo4y23g0Qr5qcxcX
         NcHeshTgP9PV4x5D7NXRtNQHHuTXtRDJ2bl9RciJKhA9XJmBKxxnNLZjVQp737X6pUHz
         NWCx7g3hD1028QjdRmTo+nTWqmB8SAo51dCapMTwFO6eoEWtpFpc/bhZDP6zjsmvlUCK
         21/1UEwBZGnVJP7QU2TqavO9wuFeZWoMpUAVG7l5hFUsIURJmj6/ZkRV4n9R2GQeCPNz
         KblG0yu9UkDxZ/LESH3SSh+UxE8H1AQvngyzjqeS/71e4bCidEWigRh5I9wwTwDYx0Yc
         Yixw==
X-Gm-Message-State: AOAM532SA7O4qOJJSgU+eaeI6gFc6hhGPj9gWcj9o2mtmiAnGSm7PcXl
        pI9TveAc70KXHHhvaPNKn1mO5nezrLcmBylJjfC/X3TuARgiCtYz6WBDfJy5NzEDhLSnXEtjGa3
        9ApJeukoJ3Zr/dd1qzsSM8MxRvdktkHjd
X-Received: by 2002:a5e:9b07:: with SMTP id j7mr7302030iok.136.1637248486471;
        Thu, 18 Nov 2021 07:14:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGhjBN8Z7eHMiPt6hYYfMz3bha26Un3vcDsqMm8GTdo8v4If+Bog2BvKhC7vSdYe4XxRR1jAsSpdDbPI60E0s=
X-Received: by 2002:a5e:9b07:: with SMTP id j7mr7302006iok.136.1637248486257;
 Thu, 18 Nov 2021 07:14:46 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Thu, 18 Nov 2021 16:14:35 +0100
Message-ID: <CACT4oudChHDKecLfDdA7R8jpQv2Nmz5xBS3hH_jFWeS37CnQGg@mail.gmail.com>
Subject: Bad performance in RX with sfc 40G
To:     Edward Cree <ecree.xilinx@gmail.com>, habetsm.xilinx@gmail.com
Cc:     netdev@vger.kernel.org, Dinan Gunawardena <dinang@xilinx.com>,
        Pablo Cascon <pabloc@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Doing some tests a few weeks ago I noticed a very low performance in
RX using 40G Solarflare NICs. Doing tests with iperf3 I got more than
30Gbps in TX, but just around 15Gbps in RX. Other NICs from other
vendors could send and receive over 30Gbps.

I was doing the tests with multiple threads in iperf3 (-P 8).

The models used are SFC9140 and SFC9220.

Perf showed that most of the time was being expended in
`native_queued_spin_lock_slowpath`. Tracing the calls to it with
bpftrace I got that most of the calls were from __napi_poll > efx_poll
> efx_fast_push_rx_descriptors > __alloc_pages >
get_page_from_freelist > ...

Please can you help me investigate the issue? At first sight, it seems
a not very optimal memory allocation strategy, or maybe a failure in
pages recycling strategy...

This is the output of bpftrace, the 2 call chains that repeat more
times, both from sfc

@[
    native_queued_spin_lock_slowpath+1
    _raw_spin_lock+26
    rmqueue_bulk+76
    get_page_from_freelist+2295
    __alloc_pages+214
    efx_fast_push_rx_descriptors+640
    efx_poll+660
    __napi_poll+42
    net_rx_action+547
    __softirqentry_text_start+208
    __irq_exit_rcu+179
    common_interrupt+131
    asm_common_interrupt+30
    cpuidle_enter_state+199
    cpuidle_enter+41
    do_idle+462
    cpu_startup_entry+25
    start_kernel+2465
    secondary_startup_64_no_verify+194
]: 2650
@[
    native_queued_spin_lock_slowpath+1
    _raw_spin_lock+26
    rmqueue_bulk+76
    get_page_from_freelist+2295
    __alloc_pages+214
    efx_fast_push_rx_descriptors+640
    efx_poll+660
    __napi_poll+42
    net_rx_action+547
    __softirqentry_text_start+208
    __irq_exit_rcu+179
    common_interrupt+131
    asm_common_interrupt+30
    cpuidle_enter_state+199
    cpuidle_enter+41
    do_idle+462
    cpu_startup_entry+25
    secondary_startup_64_no_verify+194
]: 17119

--
=C3=8D=C3=B1igo Huguet

