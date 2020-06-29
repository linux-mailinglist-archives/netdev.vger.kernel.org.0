Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8606B20D90C
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbgF2Tni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387972AbgF2Tmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:42:43 -0400
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272BFC02F024;
        Mon, 29 Jun 2020 07:56:58 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jpvDM-0000R0-IX; Mon, 29 Jun 2020 16:56:56 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jpvDM-000Lsy-9J; Mon, 29 Jun 2020 16:56:56 +0200
Subject: Re: [PATCH bpf-next v2 0/3] bpf, netns: Prepare for multi-prog
 attachment
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
References: <20200623103459.697774-1-jakub@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9b9f413c-fa55-2fd9-a6d8-12e434a2b603@iogearbox.net>
Date:   Mon, 29 Jun 2020 16:56:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200623103459.697774-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25858/Mon Jun 29 15:30:49 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/20 12:34 PM, Jakub Sitnicki wrote:
> This patch set prepares ground for link-based multi-prog attachment for
> future netns attach types, with BPF_SK_LOOKUP attach type in mind [0].
> 
> Two changes are needed in order to attach and run a series of BPF programs:
> 
>    1) an bpf_prog_array of programs to run (patch #2), and
>    2) a list of attached links to keep track of attachments (patch #3).
> 
> I've been using these patches with the next iteration of BPF socket lookup
> hook patches, and saw that they are self-contained and can be split out to
> ease the review burden.
> 
> Nothing changes for BPF flow_dissector. That is at most one prog can be
> attached.
> 
> Thanks,
> -jkbs
> 
> [0] https://lore.kernel.org/bpf/20200511185218.1422406-1-jakub@cloudflare.com/
> 
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Cc: Stanislav Fomichev <sdf@google.com>
> 
> v1 -> v2:
> 
> - Show with a (void) cast that bpf_prog_array_replace_item() return value
>    is ignored on purpose. (Andrii)
> - Explain why bpf-cgroup cannot replace programs in bpf_prog_array based
>    on bpf_prog pointer comparison in patch #2 description. (Andrii)
> 
> Jakub Sitnicki (3):
>    flow_dissector: Pull BPF program assignment up to bpf-netns
>    bpf, netns: Keep attached programs in bpf_prog_array
>    bpf, netns: Keep a list of attached bpf_link's
> 
>   include/linux/bpf.h          |   3 +
>   include/net/flow_dissector.h |   3 +-
>   include/net/netns/bpf.h      |   7 +-
>   kernel/bpf/core.c            |  20 +++-
>   kernel/bpf/net_namespace.c   | 189 +++++++++++++++++++++++++----------
>   net/core/flow_dissector.c    |  34 +++----
>   6 files changed, 173 insertions(+), 83 deletions(-)
> 

Applied, thanks!
