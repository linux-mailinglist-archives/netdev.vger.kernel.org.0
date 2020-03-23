Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1989B190083
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgCWVjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:39:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:43762 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgCWVjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 17:39:00 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jGUmg-0004Eh-EY; Mon, 23 Mar 2020 22:38:58 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jGUmg-000FKT-5E; Mon, 23 Mar 2020 22:38:58 +0100
Subject: Re: [PATCH bpf-next v5 0/2] Refactor perf_event sample user program
 with libbpf bpf_link
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20200321100424.1593964-1-danieltimlee@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5eb37262-60d8-0604-377d-e08835b42ce3@iogearbox.net>
Date:   Mon, 23 Mar 2020 22:38:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200321100424.1593964-1-danieltimlee@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25760/Mon Mar 23 14:12:45 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/20 11:04 AM, Daniel T. Lee wrote:
> Currently, some samples are using ioctl for enabling perf_event and
> attaching BPF programs to this event. However, the bpf_program__attach
> of libbpf(using bpf_link) is much more intuitive than the previous
> method using ioctl.
> 
> bpf_program__attach_perf_event manages the enable of perf_event and
> attach of BPF programs to it, so there's no neeed to do this
> directly with ioctl.
> 
> In addition, bpf_link provides consistency in the use of API because it
> allows disable (detach, destroy) for multiple events to be treated as
> one bpf_link__destroy.
> 
> To refactor samples with using this libbpf API, the bpf_load in the
> samples were removed and migrated to libbbpf. Because read_trace_pipe
> is used in bpf_load, multiple samples cannot be migrated to libbpf,
> this function was moved to trace_helpers.

Applied, thanks!
