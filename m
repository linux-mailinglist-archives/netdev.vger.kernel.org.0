Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB134EFA58
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 21:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351560AbiDATZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 15:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbiDATZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 15:25:29 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4919D60A8B
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 12:23:37 -0700 (PDT)
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 5A5333F814
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 19:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1648841011;
        bh=ay5vnR1FzgYbrJ3fVkSq0cJeptmHke/9bnDckfAaX/o=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=a3IGVwOsC1J80HcKYGwK6xCWbyCPXeQ8OhHJIjqpUfXzFEMorzmew7+P/KwWQAP7V
         vwmjTzakuQdE27OYYepkcHxRp38WbRxvuSGP9ujaJO+97oy/AXx/xDoZ1vtW+mr2Ja
         w2FQMmCqKkIA26DLtRdF1Bf0lDKpqt38JblAtpLP8z3EWhCyfri7EhgHhYMdEyCZQ8
         SluuErcq62wRP7FleMiQZTEso1gPTg9KygibSyledL8mNC0o+ZeTz4Gm6M3VaLVFdm
         iF/2/27yrYN1r1XVcbqc2fbvAXmb/WCeJ+x8gHrt7Pnx9nIuJdPOIKBp1BvVI3D0ak
         NQZf1DP1npIuw==
Received: by mail-pg1-f199.google.com with SMTP id r19-20020a635d13000000b00398cdd429f8so2105272pgb.9
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 12:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ay5vnR1FzgYbrJ3fVkSq0cJeptmHke/9bnDckfAaX/o=;
        b=q5aCo28lhNutE5kZ6FZN68XrMf+1D8SwQ/DFMPJjCJ8YadB3RdyUWvDBybzymI8ISM
         Zi1Q8DbW9yjH44bZ1NEf6CimmUB8PANzlLQnKHYZWUrAXKdF8ohFg1Dg7DwsOIKnwsmB
         d/aRsgincI4kXOudmgwEOfoJpidSBCsNt8o70nJkTgkjI/7ewQ3hC/xYP0zTbYvo7U7h
         SRM0Zt2+S7e4HL1V2YoP3Q6gHtYCwre3luX6gX6u2Kt6yDDEve4rv2+IIy9Q0z13Ot3d
         1LDbP1hXBIbW/xqiAjMaKzxJLYGx2G59IzikvGk0NTXlDmEUd8YKVrSJaPI5e1JrBL3k
         idGg==
X-Gm-Message-State: AOAM533S+cRbgWRif7lyxbLd6+eO0+ctJSSePYA9qmPDsWV+1G9ZXRf7
        DZ9FTZtOIeN223A04Wp7Zo3zgkEK6Aae7ywhneRnGpP1deAc7NUUaH9QYMDs+PjLtXTRhZk4F1W
        /keenA3BY2MbsPPHv8Cp8xok2O7D1KJ3tKg==
X-Received: by 2002:a17:90b:2502:b0:1c6:d783:6e76 with SMTP id ns2-20020a17090b250200b001c6d7836e76mr13563509pjb.158.1648841009193;
        Fri, 01 Apr 2022 12:23:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWu4ERuNPbVHVxEdRpUveht1sZeHrPOxeFBGCqUoQpU1ZtjtBIRI2kg4sRtWOVVVbNq5mfzQ==
X-Received: by 2002:a17:90b:2502:b0:1c6:d783:6e76 with SMTP id ns2-20020a17090b250200b001c6d7836e76mr13563497pjb.158.1648841008912;
        Fri, 01 Apr 2022 12:23:28 -0700 (PDT)
Received: from [192.168.1.3] ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id me5-20020a17090b17c500b001c63699ff60sm15103659pjb.57.2022.04.01.12.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 12:23:28 -0700 (PDT)
Message-ID: <b8ebba84-62cb-b1fb-d6f7-1d6b6682da45@canonical.com>
Date:   Fri, 1 Apr 2022 13:23:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net] qed: fix ethtool register dump
Content-Language: en-US
To:     Manish Chopra <manishc@marvell.com>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, aelior@marvell.com, palok@marvell.com,
        pkushwaha@marvell.com, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <20220401185304.3316-1-manishc@marvell.com>
From:   Tim Gardner <tim.gardner@canonical.com>
In-Reply-To: <20220401185304.3316-1-manishc@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/1/22 12:53, Manish Chopra wrote:
> To fix a coverity complain, commit d5ac07dfbd2b
> ("qed: Initialize debug string array") removed "sw-platform"
> (one of the common global parameters) from the dump as this
> was used in the dump with an uninitialized string, however
> it did not reduce the number of common global parameters
> which caused the incorrect (unable to parse) register dump
> 
> this patch fixes it with reducing NUM_COMMON_GLOBAL_PARAMS
> bye one.
> 
> Cc: stable@vger.kernel.org
> Cc: Tim Gardner <tim.gardner@canonical.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Fixes: d5ac07dfbd2b ("qed: Initialize debug string array")
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Alok Prasad <palok@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> ---
>   drivers/net/ethernet/qlogic/qed/qed_debug.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> index e3edca187ddf..5250d1d1e49c 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> @@ -489,7 +489,7 @@ struct split_type_defs {
>   
>   #define STATIC_DEBUG_LINE_DWORDS	9
>   
> -#define NUM_COMMON_GLOBAL_PARAMS	11
> +#define NUM_COMMON_GLOBAL_PARAMS	10
>   
>   #define MAX_RECURSION_DEPTH		10
>   

Looks good to me.

Reviewed-by: Tim Gardner <tim.gardner@canonical.com>

rtg
-- 
-----------
Tim Gardner
Canonical, Inc
