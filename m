Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F6E259CAD
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 19:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbgIARSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 13:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732651AbgIARSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 13:18:22 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF3FC061246
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 10:18:21 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id f142so1677691qke.13
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 10:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BFVCoWvSC/F+kVcSqv3UBzsK7m9szdpNyGobTDVXbqE=;
        b=lHNfP5jBkjJpfLBiRxwDFlzFv301FgN6JAkzoRTlLgL+NDDU+z3kcp+TCP63QQbB/P
         7NW/vETIi0Jm4CCH+ER+qyeUs3Tk7ppTrOcCOSlKV9MKz2a/0X3sigjI0ydsbS4ZzR9n
         cHv3Ph7OeomNqIL1HWoYZ9/I7XNLQ5xe/iYktyo/qstRWKbdYWN6yNgqxdgw4lQ4myYA
         T3GPutel3WNGf1Oe5APDPaHzAYn+yR8zhuAjWQNOxK7ACMAU3dAcjDPYeIde2ogpg6GJ
         V16T8dMVpJEqBQiq1nATqawDLayWeiz4r9f9qzKHuxsOaGK/QciNPCDBhpcGORdDOHvL
         K1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BFVCoWvSC/F+kVcSqv3UBzsK7m9szdpNyGobTDVXbqE=;
        b=mVXQKvVp9jWoBgW+B64p1+4WN3hOfnHZWJhHgi+VeaPA7pk4Z1o/mircxRkXZ4oS3O
         EuzToWCA264PnJ/RxGyRUQKi6u2Ad9sOv44BzCpQsXksRPW++nRTTY9cj8g6XHB4ezG7
         XmLwyBLk/BKeaRydtAppE2k5u9Gb1tx5peQ85cXGTiWGQi+alMPcOKLVrBLWX9b5N9TX
         sNvAYMPYR2JVG41ZP3MAu2Iaozjr4LktbfSVqAxZ+iG1xBXV+KqbW61vbeUSpwDLN2p/
         CLPS+dqYZkvfte3PyYZ6TfSOoDC4VlUrZ8P/Vr9Qcu/GIXW2F+2NzcLfybP3QezauNxi
         fAkw==
X-Gm-Message-State: AOAM533kfpwbERH/RKdcDINDbrc23+o2DJl+A02NOf3qlWZLRsdaQJLx
        nOkPe2lj5pDaIRIdZZCZsKn82A==
X-Google-Smtp-Source: ABdhPJxVfnAjvAWMKfr1FDdRrLYw2on8rTQCSqo/OLP6gHpHJXMp+kNI0/6wyzHiVIOTAixbTX4x3Q==
X-Received: by 2002:a37:a84a:: with SMTP id r71mr2846827qke.481.1598980700059;
        Tue, 01 Sep 2020 10:18:20 -0700 (PDT)
Received: from [192.168.1.45] (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id v185sm2253715qki.128.2020.09.01.10.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 10:18:19 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2 1/2] bpf: avoid iterating duplicated files for
 task_file iterator
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
References: <20200828053815.817726-1-yhs@fb.com>
 <20200828053815.817806-1-yhs@fb.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <01bc7a06-e294-7cfe-d284-1b7e834ba90f@toxicpanda.com>
Date:   Tue, 1 Sep 2020 13:18:18 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200828053815.817806-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/20 1:38 AM, Yonghong Song wrote:
> Currently, task_file iterator iterates all files from all tasks.
> This may potentially visit a lot of duplicated files if there are
> many tasks sharing the same files, e.g., typical pthreads
> where these pthreads and the main thread are sharing the same files.
> 
> This patch changed task_file iterator to skip a particular task
> if that task shares the same files as its group_leader (the task
> having the same tgid and also task->tgid == task->pid).
> This will preserve the same result, visiting all files from all
> tasks, and will reduce runtime cost significantl, e.g., if there are
> a lot of pthreads and the process has a lot of open files.
> 
> Suggested-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>   kernel/bpf/task_iter.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
> 
> It would be good if somebody familar with sched code can help check
> whether I missed anything or not (e.g., locks, etc.)
> for the code change
>    task->files == task->group_leader->files
> 
> Note the change in this patch might have conflicts with
> e60572b8d4c3 ("bpf: Avoid visit same object multiple times")
> which is merged into bpf/net sometimes back.
> 
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index 232df29793e9..0c5c96bb6964 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -22,7 +22,8 @@ struct bpf_iter_seq_task_info {
>   };
>   
>   static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
> -					     u32 *tid)
> +					     u32 *tid,
> +					     bool skip_if_dup_files)
>   {
>   	struct task_struct *task = NULL;
>   	struct pid *pid;
> @@ -32,7 +33,10 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>   	pid = idr_get_next(&ns->idr, tid);
>   	if (pid) {
>   		task = get_pid_task(pid, PIDTYPE_PID);
> -		if (!task) {
> +		if (!task ||
> +		    (skip_if_dup_files &&
> +		     task->tgid != task->pid &&
> +		     task->files == task->group_leader->files)) {
>   			++*tid;
>   			goto retry;

Sorry I only checked the task->files and task->group_leader thing, I forgot to 
actually pay attention to what the patch itself was doing.

This will leak task structs, you need something like

if (!task) {
	++*tid;
	goto retry;
}
if (skip_if_dup_files && etc) {
	++*tid;
	put_task_struct(task);
	goto retry;
}

otherwise you'll leak tasks.  Thanks,

Josef
