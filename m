Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0236970D8
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjBNWqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBNWqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:46:33 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24E32CC4B
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:46:32 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id i18so10109362pli.3
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FNzyiL4vW9T30Y4lsM+1I1M3/jmK/O9rCXhFvYC6j7w=;
        b=qXeJojk8Dvp7TWv2qQCs436J8+vphaFVpCzCheudw23+fPho62y6X1s6CVnqWf3Jhq
         +u9qEXNmoCRbwS51QIZ11+V4YwiKWu321DN2VqwZwPz8FCGGc31bCiG1KREsciv0uvlV
         3I2aS3dXc9NtkeRz0kD1KbQVYonuDqlqyiN/9pM+W+NwvjT0cLfeYiDP6yzWwxpAv6Kb
         XVMnZKZi8VNSXTI8DojuPFu+nWxKFCHglLQwnhbdhaP/fAfkzBVIFdBgaBzaZ8wGj9ak
         KDIOg0ERN44tNsQlOfIXegJfoYW9iwqZ4jNk+F+nGRGeOAbl6D8SqC9E7O1ATtqogbHl
         OS5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FNzyiL4vW9T30Y4lsM+1I1M3/jmK/O9rCXhFvYC6j7w=;
        b=Gl8xMHSYji/cmatwQf8H34p1KmgFxOyHUAOUgRJjbbMb0/rvw3AfDqIoxOImiu1YaA
         eo44igODceFSc348s2hplW8zmOaOULatpfU25K9yS24QyANFrU5+C3bRSBTTdYPCB/NB
         mHEXg1zEfaQTjeb7Q3yJs7KlExcD3sswM9swbCIZzfe5dGQ8Ohpp99KrKl84VVPt5zf+
         BgtIyxNwxl6ZYCthnwR1AHPJjk9Z5fGAn8E/hR/1tFfoGlVIvbpCmVP8oL21ZfmnfDbP
         wIeIWRGB8+Ocpw4Co5gBOpWciwFXIrczeZfd61mRgG5belhsXRxwNr92YUcjtE6EUmO3
         zp0A==
X-Gm-Message-State: AO0yUKVRhfTCZfgyYzaQeG+YklWEZ90Sb+3msOU2r8bhL69WcCpW8pag
        lv2I1bhLcMTj5fIK7K+i7Y7udQ==
X-Google-Smtp-Source: AK7set9xvM98LzY+n7VZM61YwpBKFa8Tvi94JLgMFf6MQd5Zw44BEfCaxFVnc6s5OFVIQagrJk2tEg==
X-Received: by 2002:a17:903:228d:b0:19a:93fa:2921 with SMTP id b13-20020a170903228d00b0019a93fa2921mr355932plh.24.1676414792206;
        Tue, 14 Feb 2023 14:46:32 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id c7-20020a170902848700b00194ac38bc86sm10695504plo.131.2023.02.14.14.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 14:46:31 -0800 (PST)
Date:   Tue, 14 Feb 2023 14:46:26 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net] net/sched: tcindex: search key must be 16 bits
Message-ID: <20230214144626.262f5d58@hermes.local>
In-Reply-To: <20230214014729.648564-1-pctammela@mojatatu.com>
References: <20230214014729.648564-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Feb 2023 22:47:29 -0300
Pedro Tammela <pctammela@mojatatu.com> wrote:

> diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> index ba7f22a49..6640e75ea 100644
> --- a/net/sched/cls_tcindex.c
> +++ b/net/sched/cls_tcindex.c
> @@ -503,7 +503,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  		/* lookup the filter, guaranteed to exist */
>  		for (cf = rcu_dereference_bh_rtnl(*fp); cf;
>  		     fp = &cf->next, cf = rcu_dereference_bh_rtnl(*fp))
> -			if (cf->key == handle)
> +			if (cf->key == (u16)handle)
>  				break;

Rather than truncating silently. I think the code should first test that handle is
not outside of range and return EINVAL instead.
