Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBB7B313A
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 19:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbfIORp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 13:45:28 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35003 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbfIORp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 13:45:28 -0400
Received: by mail-pf1-f195.google.com with SMTP id 205so21211548pfw.2
        for <netdev@vger.kernel.org>; Sun, 15 Sep 2019 10:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D+ZuwlIeFhlxG49/vIWvHw6wGGRGoNyIbDJE79x6GKk=;
        b=CIFhqiqC59N3AHjEQJC1RsKYM97fAs0LsOa5ldXmYD4kAfl6+yFpq3byePS5/y2FKw
         2+u9B25uzNAnB5a5D6BpLq2zeaQBq6jiOLGrbWXaH+LgBLyn49RTUI641gWpFi+i522j
         iZbnnVcrEJKvybbL2pDUwF0gmZNR0wuaU6F20dDLtGB9VEnazvw7XUmBpUTAp0RlrOw8
         Plt1EcXy74mLaUSmJGVdBSPRl+CLv06NO9Dm65GzfChHnAnVtiIww+16Y0aco8rJDUN9
         z7jnf2HDEPfWU81HYpAoggkbugdPO3Wh9ZInPhRDiOUe7T3hp3uD7lJEdxvf4GxAGeqZ
         AJwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D+ZuwlIeFhlxG49/vIWvHw6wGGRGoNyIbDJE79x6GKk=;
        b=RMds/xm+FHnx0gGhGfdhLsrqOA3ekH+YmYWQ3/foLqAa+qWBGtfLUyDX4l5tyPYtyu
         loa1QA/ScQREatCGo/bdmpfeqjS1HhaX14BOoT7Jq1kgpRriRl46z6wu2DgQe+I4YXnv
         HqVsPsf/KxdsRci/gMoY4iiGP6AFNNYYV/R0aLKEMGnq6MOWqqScnKCg/A4xYzOgKo4Z
         E0ghb1Ms0TpM+j4c3/o24VaYik+zuOF4Xh8h3L5juBnkMVtn67d1yzYRfwZUyy0VH0n0
         gONjUQQMNp2Rpx4aw3E94d3AfIINcRSpcdgjhQBx1esvE5umK5knlTiOMixuMuweJ/au
         F1LA==
X-Gm-Message-State: APjAAAVUZU/FZ8TDMBDha9ZEcoymgKuqcO65clIZL9lX6dhiMWOgKEvI
        NiZiwjMan8oxr4aBpLB3pIU=
X-Google-Smtp-Source: APXvYqy6oyFc9PuSpe33UM58yMwXDEYtsX4Q0Mai5aRTZI2Ahe7GPffIB/g7NPpqbMHaF+FMcMKoSA==
X-Received: by 2002:a62:3844:: with SMTP id f65mr69159923pfa.142.1568569527798;
        Sun, 15 Sep 2019 10:45:27 -0700 (PDT)
Received: from [172.27.227.180] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id v43sm9607125pjb.1.2019.09.15.10.45.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 10:45:26 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] bpf: replace snprintf with asprintf when
 dealing with long buffers
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
References: <d2631870837a01f1488bf0bd547bb126f24de6b9.1568043463.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8fd965a6-ece1-6fcb-4fa8-5d12f79f79e3@gmail.com>
Date:   Sun, 15 Sep 2019 11:45:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <d2631870837a01f1488bf0bd547bb126f24de6b9.1568043463.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/19 10:05 AM, Andrea Claudi wrote:
> This reduces stack usage, as asprintf allocates memory on the heap.
> 
> This indirectly fixes a snprintf truncation warning (from gcc v9.2.1):
> 
> bpf.c: In function ‘bpf_get_work_dir’:
> bpf.c:784:49: warning: ‘snprintf’ output may be truncated before the last format character [-Wformat-truncation=]
>   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
>       |                                                 ^
> bpf.c:784:2: note: ‘snprintf’ output between 2 and 4097 bytes into a destination of size 4096
>   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fixes: e42256699cac ("bpf: make tc's bpf loader generic and move into lib")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  lib/bpf.c | 95 +++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 57 insertions(+), 38 deletions(-)
> 
> diff --git a/lib/bpf.c b/lib/bpf.c
> index 7d2a322ffbaec..18e0334d3f11b 100644
> --- a/lib/bpf.c
> +++ b/lib/bpf.c
> @@ -406,13 +406,14 @@ static int bpf_derive_elf_map_from_fdinfo(int fd, struct bpf_elf_map *map,
>  					  struct bpf_map_ext *ext)
>  {
>  	unsigned int val, owner_type = 0, owner_jited = 0;
> -	char file[PATH_MAX], buff[4096];
> +	char *file, buff[4096];
>  	FILE *fp;
>  
> -	snprintf(file, sizeof(file), "/proc/%d/fdinfo/%d", getpid(), fd);
> +	asprintf(&file, "/proc/%d/fdinfo/%d", getpid(), fd);

Thanks for taking this on.

From 'man asprintf':
  "If  memory  allocation  wasn't  possible, or some other error occurs,
these functions will return -1, and the contents of strp are undefined."

ie., you should check the return code of asprintf and make sure the
pointer passed is always initialized to NULL (static ones do not need
the init).
