Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C21D4B1B28
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 02:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346768AbiBKBVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 20:21:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238761AbiBKBVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 20:21:45 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4FE8267F
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 17:21:43 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id r19so13452642pfh.6
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 17:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lo2d4VwD5AAY/xrh4hcT2tzZX45H1Qy5gHAjo6j42d8=;
        b=TuR6i4lf3tm4hL1X5PhUUcU7AxKwkQLoAR5bJNvfA8h+KvwaATOm42TBqzjKyzfChm
         Ig4T81+OdkRoaPaKnvHdj1u6sBvXlAtBUTrlMwivFfvYx+BfKha5ZYyRBceZIKwLrwgc
         6W0yk5+qu1MWPUR90traAtdsRnqTWUuF9xnjIr1MCix6LL5kaditn6/u4PWZ6vnHgOOI
         HidbDlaVncL8uDzX+J0A9uc9dYHsOUAK/JTTsJkplTzefMEP4PoZ2JCRmpNX0R33iwuo
         ttXcB3eLm4eX+hyReZtZmkuIg/pvUTsIdGAgwKqTxUlyiCqwRlE8JFsro0yx3Znwaq0K
         Rd0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lo2d4VwD5AAY/xrh4hcT2tzZX45H1Qy5gHAjo6j42d8=;
        b=ptZPswMitYYfmHyVxHtEDCwGeCdK/Zc2lFP0eB+wJV2pPg2RhvjAxxOCSiOTtlvc3m
         dgGB79aipT6wrtn22OrMUggb4JOdYq5EctJ4NSHFJipdvP89zHeMLTLAma1FaB6ME05i
         1m4u7t9doGxnvQDAiGWZR6wfIpWHni0JlwYn2gROOsL6Go4XvLJ/z8KBUhR5MvLdRDPf
         Ll3qjGOk5WDhb2av4Dk5zgHkkUSugnyPMkA/n07ETxyO8P0acno3K35r4yGeMpqh0chE
         Pj9x/HfA7UhW2MoQlbsf0GrBDvVhXZDjAA1R7nxwXAu1tOqAgR4Ii2IVfHlmqGKXTDzF
         45JQ==
X-Gm-Message-State: AOAM531N5t2ZpClYwVa3Kn2xleGegYd7VSswurFJWPTCVJj9iCWg+ql6
        Rt15aBwlGsczq3nsWn40ul0vcA==
X-Google-Smtp-Source: ABdhPJxpUScbKihyaGUMPC5VllmPZLi1pcb3QOC5y8sHyr4vMLS+iPfWBh9WRs/J3ugUv7H51+451w==
X-Received: by 2002:a63:cd0a:: with SMTP id i10mr8379311pgg.190.1644542503287;
        Thu, 10 Feb 2022 17:21:43 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id ob12sm3339493pjb.47.2022.02.10.17.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 17:21:42 -0800 (PST)
Date:   Thu, 10 Feb 2022 17:21:40 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Maor Dickman <maord@nvidia.com>
Subject: Re: [PATCH iproute2] tc_util: Fix parsing action control with space
 and slash
Message-ID: <20220210172140.04d861d1@hermes.local>
In-Reply-To: <20220203122046.307076-1-roid@nvidia.com>
References: <20220203122046.307076-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 14:20:46 +0200
Roi Dayan <roid@nvidia.com> wrote:

> For action police there is an conform-exceed action control
> which can be for example "jump 2 / pipe".
> The current parsing loop is doing one more iteration than necessary
> and results in ok var being 3.
> 
> Example filter:
> 
> tc filter add dev enp8s0f0_0 ingress protocol ip prio 2 flower \
>     verbose action police rate 100mbit burst 12m \
>     conform-exceed jump 1 / pipe mirred egress redirect dev enp8s0f0_1 action drop
> 
> Before this change the command will fail.
> Trying to add another "pipe" before mirred as a workaround for the stopping the loop
> in ok var 3 resulting in result2 not being saved and wrong filter.
> 
> ... conform-exceed jump 1 / pipe pipe mirred ...
> 
> Example dump of the action part:
> ... action order 1:  police 0x1 rate 100Mbit burst 12Mb mtu 2Kb action jump 1 overhead 0b  ...
> 
> Fix the behavior by removing redundant case 2 handling, either argc is over or breaking.
> 
> Example dump of the action part with the fix:
> ... action order 1:  police 0x1 rate 100Mbit burst 12Mb mtu 2Kb action jump 1/pipe overhead 0b ...
> 
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> ---
>  tc/tc_util.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tc/tc_util.c b/tc/tc_util.c
> index 48065897cee7..b82dbd5dc75d 100644
> --- a/tc/tc_util.c
> +++ b/tc/tc_util.c
> @@ -476,7 +476,6 @@ static int parse_action_control_slash_spaces(int *argc_p, char ***argv_p,
>  			NEXT_ARG();
>  			/* fall-through */
>  		case 0: /* fall-through */
> -		case 2:
>  			ret = parse_action_control(&argc, &argv,
>  						   result_p, allow_num);
>  			if (ret)

Applied, and removed the now unnecessary second fall-through comment.
