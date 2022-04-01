Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449DD4EF8AC
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 19:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346648AbiDARLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 13:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239345AbiDARLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 13:11:19 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC912A248;
        Fri,  1 Apr 2022 10:09:29 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s72so2872381pgc.5;
        Fri, 01 Apr 2022 10:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LImEOxfyIPGlQbCQpplXE60DtSoSNNxE1+4gEbrz2CE=;
        b=cs2hIo1S07860WC/5XZ0dR/RsivlP0TwpIQKBXM2BF8Q+Dfl2P62mdz0Ota8I+e9AP
         JaTwdeyGd/rvilDz/t2qLn4yYUmSb5kZFnt70yVrxS/cCFYlKiCL2QZAu3bVnPHkEEd4
         vfKQ+Mns7K7AtAH8C6d74FxAYWIA9qp2I+snEEzOaHu5tXrHHrlEU2sowSJXA1Uq6thQ
         toNlRAqYsmtX8ruR4IpP1hHYcKw182FKOz6dKZhFjU81ZFIABp7DCZfeOh5z0hpQXa/X
         eKzvrHqo5I0KPIbJ5w8XhnVTp0HC87h2oujurqPx4O8fpKE+lSs+mtKhz7591GEkRgUQ
         xOTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LImEOxfyIPGlQbCQpplXE60DtSoSNNxE1+4gEbrz2CE=;
        b=ItFGK/8gE+7xat4friLhBKvUHG6J2I3hH6gGk37325MewvMsIhbqIDpGBw4xuAvhem
         q/rcBqHGZOEhVK7xmlzQHWi1nT2CeKCXYrXrRei7QSFEiDO+jeeNp6Hs0sJt+TSGLdzL
         t5VMMl17czvT/ED377OP2B7a7RAx4AkYtPCR/HNbgkEzqGsUeswC4KVNQjdpm66nX8Re
         YtPpHv5HVnWxMY/e29QQ2zxaQW9G65bY+t5t1TrNx18mQwA/o2oGpadrRYVvkdC4q8TH
         VCHrv9jvugGZ7GHDU5Qg3J8jyMJVQeUz5XUONdH+7nqZbRrncIalzMzKmAREg4jBUigs
         rf4A==
X-Gm-Message-State: AOAM531FYL66bGdUbxhFscIsOTUkp0u+CnxJ2GMlnZ5RkNn9WsZamb/c
        cEdHozseweAW59OEEH3smOQ=
X-Google-Smtp-Source: ABdhPJyTguw1YFMZTCc6C259mXYcn/eEEQuG6PzA3/XrlZClxztaNrfrUxhFbqJ1CDk7VdLpq8x+GA==
X-Received: by 2002:a62:840b:0:b0:4fa:31ae:7739 with SMTP id k11-20020a62840b000000b004fa31ae7739mr11730077pfd.6.1648832969146;
        Fri, 01 Apr 2022 10:09:29 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id bt18-20020a056a00439200b004faad3ae59esm3581968pfb.95.2022.04.01.10.09.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 10:09:28 -0700 (PDT)
Message-ID: <5d9fed4f-ff87-cb14-3c7d-8899cb3e4370@gmail.com>
Date:   Fri, 1 Apr 2022 10:09:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] net/ipv4: fix potential NULL dereference in
 sisfb_post_sis300()
Content-Language: en-US
To:     Haowen Bai <baihaowen@meizu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1648785432-21824-1-git-send-email-baihaowen@meizu.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1648785432-21824-1-git-send-email-baihaowen@meizu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/31/22 20:57, Haowen Bai wrote:
> psin and psl could be null without checking null and return, so
> we need to dereference after checking.
>
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
>   net/ipv4/igmp.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index 2ad3c7b..d400080 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -2569,7 +2569,7 @@ int ip_mc_msfget(struct sock *sk, struct ip_msfilter *msf,
>   	    copy_to_user(optval, msf, IP_MSFILTER_SIZE(0))) {
>   		return -EFAULT;
>   	}
> -	if (len &&
> +	if (len && psl &&


len can not be !0 here if len was 0

psl = rtnl_dereference(pmc->sflist);

if (!psl) {

    count = 0;


->len == 0


>   	    copy_to_user(&optval->imsf_slist_flex[0], psl->sl_addr, len))
>   		return -EFAULT;
>   	return 0;
> @@ -2608,7 +2608,7 @@ int ip_mc_gsfget(struct sock *sk, struct group_filter *gsf,
>   	count = psl ? psl->sl_count : 0;
>   	copycount = count < gsf->gf_numsrc ? count : gsf->gf_numsrc;
>   	gsf->gf_numsrc = count;
> -	for (i = 0; i < copycount; i++, p++) {
> +	for (i = 0; i < copycount && psin && psl; i++, p++) {
>   		struct sockaddr_storage ss;
>   
>   		psin = (struct sockaddr_in *)&ss;


Same here.


