Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0687E2983A5
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 22:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418844AbgJYVSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 17:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728886AbgJYVSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 17:18:51 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546BEC061755
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 14:18:50 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id n6so7854934ioc.12
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 14:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GkTx40TBg2FUjYW1YbfeIbR9G/xX/g3eNQt3n4Sa8Gc=;
        b=fn94jjtQUcILCcHYWiPEZxnkuSogV1GpSKvNanNBelbckoso7/TYXs1Jn19mFrA9P1
         DtfA5m+wgqDgy2Xld/K31QoDPjLTh93pw5Awa5tg9nOccRFLCgRbFJfm10MsjUfPTfA6
         jFRvm4AOdtM6uU3amy/BAy/T2DROU6UD0wC/VU+bMr9GzEqyeFAv0X6DcW0XtlCg19Gv
         gwG9089R3TrL6ojtuQ6A4jtKW+NVK8/j3Kik2JYrwZMddinEYiaqn23QULEmv+PXhtzI
         g1tfJn8GP7DpdFc5Zqbs6sYrNwviYJiNUNOQbWIITo8RUj2FrDhMl+q4c/AAkpkdlyDI
         pSCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GkTx40TBg2FUjYW1YbfeIbR9G/xX/g3eNQt3n4Sa8Gc=;
        b=DSJl1iZNlkpIk9ZsxTPPqBKPf2PYPgxUb+FM7KrEEOW8qLsqmFBSf8404TsusGWIJ9
         Do7li6SoVLq/G7D1n0OltBIf9eW+ENlMH+vcndyp61hmZkq5cAoaakGLBvhiXnPf/W1J
         sB5kvwYiIExy1t7WmRJMIdhdAeauf7fVwMReHxJu70pRTl/VYhUlFLoZNiexHO4pZF/F
         D1hmZBzXUpYCKMF4C9IK1zu5o6uYX6F8vkewDozaiqTAoQAOTEmvpXUwsRWBdCQjldGW
         FB8t5tFQaGl9O/TqSlOeFbF+treEnTlv83635jDFeGBzNVG3X282Oq6hsrCNupxOgNX7
         geiw==
X-Gm-Message-State: AOAM532U8kMgUDhsYwK2tE8bl3HUucvynFm1zM1jHQpWSvQj+y4DpjKN
        uhAuSXAEWmwtM/ElwImRnm8=
X-Google-Smtp-Source: ABdhPJxTDqBGOO5QJzXMMjHLZ+g47BYjYXacGni2wHi9Wkd9J0VNnq5q1GR+CA2eMnfnxEYiQ1T5/A==
X-Received: by 2002:a6b:d21a:: with SMTP id q26mr8291886iob.128.1603660729605;
        Sun, 25 Oct 2020 14:18:49 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e928:c58a:d675:869a])
        by smtp.googlemail.com with ESMTPSA id e13sm958338ili.67.2020.10.25.14.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2020 14:18:49 -0700 (PDT)
Subject: Re: [iproute2-next] tc flower: use right ethertype in icmp/arp
 parsing
To:     Zahari Doychev <zahari.doychev@linux.com>, netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jhs@mojatatu.com
References: <20201019114708.1050421-1-zahari.doychev@linux.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bd0eb394-72a3-1c95-6736-cd47a1d69585@gmail.com>
Date:   Sun, 25 Oct 2020 15:18:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201019114708.1050421-1-zahari.doychev@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/20 5:47 AM, Zahari Doychev wrote:
> Currently the icmp and arp prsing functions are called with inccorect
> ethtype in case of vlan or cvlan filter options. In this case either
> cvlan_ethtype or vlan_ethtype has to be used.
> 
> Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
> ---
>  tc/f_flower.c | 43 ++++++++++++++++++++++++++-----------------
>  1 file changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/tc/f_flower.c b/tc/f_flower.c
> index 00c919fd..dd9f3446 100644
> --- a/tc/f_flower.c
> +++ b/tc/f_flower.c
> @@ -1712,7 +1712,10 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
>  			}
>  		} else if (matches(*argv, "type") == 0) {
>  			NEXT_ARG();
> -			ret = flower_parse_icmp(*argv, eth_type, ip_proto,
> +			ret = flower_parse_icmp(*argv, cvlan_ethtype ?
> +						cvlan_ethtype : vlan_ethtype ?
> +						vlan_ethtype : eth_type,
> +						ip_proto,

looks correct to me, but would like confirmation of the intent from Simon.

Also, I am not a fan of the readability of that coding style. Rather
than repeat that expression multiple times, make a short helper to
return the relevant eth type and use a temp variable for it. You should
also comment that relevant eth type changes as arguments are parsed.

Thanks,


