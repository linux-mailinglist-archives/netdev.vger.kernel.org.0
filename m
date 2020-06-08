Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BC41F1ABA
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 16:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbgFHOP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 10:15:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:38058 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgFHOP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 10:15:58 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jiIYy-0006tM-It; Mon, 08 Jun 2020 16:15:44 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jiIYy-000EuU-4N; Mon, 08 Jun 2020 16:15:44 +0200
Subject: Re: [PATCH] bpf_stats_record: Add null check after malloc
To:     gaurav singh <gaurav1086@gmail.com>, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        davem@davemloft.net, kuba@kernel.org, awk@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <CAFAFadBRhEwuFCa-kMNPgRF8+gHycVvWcGfvbX0Pmjb6wt4SZA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f26fa159-f850-5a21-14ab-a8b9cc48a125@iogearbox.net>
Date:   Mon, 8 Jun 2020 16:15:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAFAFadBRhEwuFCa-kMNPgRF8+gHycVvWcGfvbX0Pmjb6wt4SZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25837/Mon Jun  8 14:50:11 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/20 1:46 AM, gaurav singh wrote:
> Hi,
> 
> The memset call is made right after malloc call. To fix this, add the null
> check right after malloc and then do memset.
> 
> Please find the patch below.
> 
> Thanks and regards,
> Gaurav.

Hello Gaurav, your patch is whitespace damaged. Please try and resubmit with git-send-email.

>  From 8083a35f85c6047f0377883ed66ae147f85fd3a9 Mon Sep 17 00:00:00 2001
> From: Gaurav Singh <gaurav1086@gmail.com>
> Date: Sat, 6 Jun 2020 19:42:53 -0400
> Subject: [PATCH] bpf_stats_record: Add null check after malloc
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
> ---
>   samples/bpf/xdp_rxq_info_user.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/samples/bpf/xdp_rxq_info_user.c
> b/samples/bpf/xdp_rxq_info_user.c
> index 4fe47502ebed..c44b9a844066 100644
> --- a/samples/bpf/xdp_rxq_info_user.c
> +++ b/samples/bpf/xdp_rxq_info_user.c
> @@ -233,11 +233,11 @@ static struct stats_record *alloc_stats_record(void)
>    int i;
> 
>    rec = malloc(sizeof(*rec));
> - memset(rec, 0, sizeof(*rec));
>    if (!rec) {
>    fprintf(stderr, "Mem alloc error\n");
>    exit(EXIT_FAIL_MEM);
>    }
> + memset(rec, 0, sizeof(*rec));
>    rec->rxq = alloc_record_per_rxq();
>    for (i = 0; i < nr_rxqs; i++)
>    rec->rxq[i].cpu = alloc_record_per_cpu();
> 

