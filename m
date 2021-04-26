Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B8D36B08D
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 11:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbhDZJ3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 05:29:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25427 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232161AbhDZJ3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 05:29:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619429335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cCFCWpyxmc5W/HWTSmhYAGg0kenBWgWwT9Odj+UVjmM=;
        b=OFnUicJjEDBeogNe0ZAzFo1fFtMZStkZvjWNLY92HV4zfh/jMeB+djcqLGdGiozcJOHSGS
        5BY+Axhy3nif4DNhJF6CXYNHjbFJRqZuP26OKjYTMyoai95OphK1P6r1tnw+qrqteqeTzJ
        J7qI6p5n1cqLUD9nSlognXH1F+LfBt4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-zRFaT7j5OYO3XtW7FkRl6A-1; Mon, 26 Apr 2021 05:28:51 -0400
X-MC-Unique: zRFaT7j5OYO3XtW7FkRl6A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16266802B78;
        Mon, 26 Apr 2021 09:28:49 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCDA160C4A;
        Mon, 26 Apr 2021 09:28:33 +0000 (UTC)
Date:   Mon, 26 Apr 2021 11:28:32 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFQ=?= =?UTF-8?B?w7ZwZWw=?= 
        <bjorn.topel@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        brouer@redhat.com
Subject: Re: [PATCHv9 bpf-next 4/4] selftests/bpf: add xdp_redirect_multi
 test
Message-ID: <20210426112832.0b746447@carbon>
In-Reply-To: <20210422071454.2023282-5-liuhangbin@gmail.com>
References: <20210422071454.2023282-1-liuhangbin@gmail.com>
        <20210422071454.2023282-5-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Apr 2021 15:14:54 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> Add a bpf selftest for new helper xdp_redirect_map_multi(). In this
> test there are 3 forward groups and 1 exclude group. The test will
> redirect each interface's packets to all the interfaces in the forward
> group, and exclude the interface in exclude map.
> 
> Two maps (DEVMAP, DEVMAP_HASH) and two xdp modes (generic, drive) will
> be tested. XDP egress program will also be tested by setting pkt src MAC
> to egress interface's MAC address.
> 
> For more test details, you can find it in the test script. Here is
> the test result.
> ]# ./test_xdp_redirect_multi.sh

Running this test takes a long time around 3 minutes.

$ sudo time -v ./test_xdp_redirect_multi.sh
Pass: xdpgeneric arp ns1-2
Pass: xdpgeneric arp ns1-3
Pass: xdpgeneric arp ns1-4
Pass: xdpgeneric ping ns1-2
Pass: xdpgeneric ping ns1-3
Pass: xdpgeneric ping ns1-4
Pass: xdpgeneric ping6 ns1-2
Pass: xdpgeneric ping6 ns1-1 number
Pass: xdpgeneric ping6 ns1-2 number
Pass: xdpdrv arp ns1-2
Pass: xdpdrv arp ns1-3
Pass: xdpdrv arp ns1-4
Pass: xdpdrv ping ns1-2
Pass: xdpdrv ping ns1-3
Pass: xdpdrv ping ns1-4
Pass: xdpdrv ping6 ns1-2
Pass: xdpdrv ping6 ns1-1 number
Pass: xdpdrv ping6 ns1-2 number
Pass: xdpegress mac ns1-2
Pass: xdpegress mac ns1-3
Pass: xdpegress mac ns1-4
Summary: PASS 21, FAIL 0
	Command being timed: "./test_xdp_redirect_multi.sh"
	User time (seconds): 0.15
	System time (seconds): 0.51
	Percent of CPU this job got: 0%
	Elapsed (wall clock) time (h:mm:ss or m:ss): 3:09.68
	Average shared text size (kbytes): 0
	Average unshared data size (kbytes): 0
	Average stack size (kbytes): 0
	Average total size (kbytes): 0
	Maximum resident set size (kbytes): 6904
	Average resident set size (kbytes): 0
	Major (requiring I/O) page faults: 13
	Minor (reclaiming a frame) page faults: 46316
	Voluntary context switches: 1907
	Involuntary context switches: 371
	Swaps: 0
	File system inputs: 0
	File system outputs: 0
	Socket messages sent: 0
	Socket messages received: 0
	Signals delivered: 0
	Page size (bytes): 4096
	Exit status: 0

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

