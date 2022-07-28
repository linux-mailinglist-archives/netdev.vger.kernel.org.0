Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E1E583ED0
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 14:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238536AbiG1M1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 08:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238527AbiG1M1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 08:27:08 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E815E30B;
        Thu, 28 Jul 2022 05:27:06 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q18so1970618wrx.8;
        Thu, 28 Jul 2022 05:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc;
        bh=0Z7zc/NLFxNR7z+iq6l+L3Lwh2EO882P65hFqnmFPUU=;
        b=mA8fQRopsCMgsSbi8lqXuPPdkaPRxhxL4zgTk8N/G9fBrX2fqcC1HSU3KjXVDblvD1
         2tXGpSsqLgr5FlgPDEwR5kRwFfOW1A+D/qAh6LOHwqImv+wkvZkbiP0c6Bq/EWZ6Ejfq
         nr7AKBgKm4+ClP7xNkxNXf5psKXvB7Fu2ZGP+1EyXf2A31wyrUWKnxzFqE8yzHuqQzbC
         RttOY+bPEjA1hYyGK95pV2y7gJTE4OnhRJhZmz6pwFQnPb0ot5Wo4hgHoht6zNugStZp
         IAb7IWIRIi17zYbf84NuUN9NsKHqhNoTXrG+aDxBEZ5pDxC9KqI2vSVLcYn3mTzwWpXW
         egbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc;
        bh=0Z7zc/NLFxNR7z+iq6l+L3Lwh2EO882P65hFqnmFPUU=;
        b=oU0bizY4W2O2xj4w/WhmReoRwpCPx8xDhRgs9MdcZgbPEmUXzIBsQOq3yIU8tJps9o
         tUWf0OcxRpJHZufRhI5zyMQ0uSSWn/9SlAJ95BJaYVJgaPRkeWm3+UJL9i04KddDYZd+
         yzAmy9xLb/Y+Wa88421rMfyhId/0l/YmFwpecLZr3Zu06WWu4E0ndRupiPeYhAKVgu3s
         QU3YqOLA/JlG7Mp/Dc7F3y9lflh9NR1lAadisF4pT6nfCxqa0ViMKZj727DUIMrkv2ql
         Gl3fJu1l0rdIuDM521CnREO0iNReHasj7E16FJCOpAhm8B31+q+E3p5//6/MS+LlDK16
         vG+w==
X-Gm-Message-State: AJIora9Aoxsq+F4fJZe9dXKcsWLUHsV9Sxy2buf6CpkSnFbKeh/a1hZV
        PcQcapaE8lOd6yWqelWoH6vt7sVmMdw=
X-Google-Smtp-Source: AGRyM1v8uHSgYb+wg8j4otMNERrPWH1GpT4MCu3ukhokwW7zsrkGFEmA/+ZA8V1Ub0mgq+m/aAqxZg==
X-Received: by 2002:adf:e30c:0:b0:21e:51b9:113c with SMTP id b12-20020adfe30c000000b0021e51b9113cmr17675065wrj.247.1659011224473;
        Thu, 28 Jul 2022 05:27:04 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id e13-20020a5d65cd000000b0020fcaba73bcsm864062wrw.104.2022.07.28.05.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 05:27:04 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 28 Jul 2022 14:27:02 +0200
To:     Xu Kuohai <xukuohai@huaweicloud.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Bruno Goncalves <bgoncalv@redhat.com>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf-next] bpf: Fix NULL pointer dereference when
 registering bpf trampoline
Message-ID: <YuKAlk+p/ABzfUQ+@krava>
References: <20220728114048.3540461-1-xukuohai@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728114048.3540461-1-xukuohai@huaweicloud.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 07:40:48AM -0400, Xu Kuohai wrote:
> From: Xu Kuohai <xukuohai@huawei.com>

SNIP

> 
> It's caused by a NULL tr->fops passed to ftrace_set_filter_ip(). tr->fops
> is initialized to NULL and is assigned to an allocated memory address if
> CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS is enabled. Since there is no
> direct call on arm64 yet, the config can't be enabled.
> 
> To fix it, call ftrace_set_filter_ip() only if tr->fops is not NULL.
> 
> Fixes: 00963a2e75a8 ("bpf: Support bpf_trampoline on functions with IPMODIFY (e.g. livepatch)")
> Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> Tested-by: Bruno Goncalves <bgoncalv@redhat.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> ---
>  kernel/bpf/trampoline.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 42e387a12694..0d5a9e0b9a7b 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -255,8 +255,15 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
>  		return -ENOENT;
>  
>  	if (tr->func.ftrace_managed) {
> -		ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 0);
> -		ret = register_ftrace_direct_multi(tr->fops, (long)new_addr);
> +		if (tr->fops)
> +			ret = ftrace_set_filter_ip(tr->fops, (unsigned long)ip,
> +						   0, 0);
> +		else
> +			ret = -ENOTSUPP;
> +
> +		if (!ret)
> +			ret = register_ftrace_direct_multi(tr->fops,
> +							   (long)new_addr);
>  	} else {
>  		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
>  	}

do we need to do the same also in unregister_fentry and modify_fentry ?

jirka
