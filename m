Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFA56562A8
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 13:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbiLZMrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 07:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLZMrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 07:47:24 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD30C3F
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 04:47:23 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id b88so8092495edf.6
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 04:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=foL0E+XmXJgWRYJHWJRKNv3OOeQkzHZ30eG06cAtkhE=;
        b=GTyqJ+m4Fsuc3SrMtTylAtFDpeGyEpYp4YqIw0qSI71mNpYqGJyOCmLKHQWIo6/XGA
         qsqBOojLDnZE5K0YStJpqUln+shEh8zdG9KGdf1w1djfOEC5fH1eG26RPilRR8W5QdQF
         TOfIDEWDWZKPbyiekdx8huCTrykC5FjurAEQWh2fNsnRZjyHYRARzlPiYEBWTk6I61N0
         /TZSKZh4ICpjbampLfe1bqk/l42R44hwLc+OWi+bhcO4rbo4e6+og0GTWU0Z2Evo0JYQ
         0pfC65jDd7F0USsjsb3Ozx40vBgtksM3vY026TaLVfTdOrJgA/QsVwn2dvGABZeYlwMZ
         PMYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=foL0E+XmXJgWRYJHWJRKNv3OOeQkzHZ30eG06cAtkhE=;
        b=NR4FYHksI/O4SSBNAkurViaS7v+sstoGjDjz6YSS6eL3+MG9cBxeqjzdV1PvqhZYSw
         lEy3ck0r3cBpHZJMZeEovgtE5r16wF/L4SFUGQjBo3UG0aw/cwbpcaw6hwEBXb1izFT8
         lw7/SwY6/K1//Asx5O56puG742l8c0rPLk8Tql336/2nrWksPoTjRnkmZAnQ05sNL7zj
         Yr5V4EvRP4a7tGfuTO6GYAmwtFC51k9oqh+DUWtZZApKzkDn0Qwh2VtdZmCfdFtKsKOi
         UC/j+oy1s5w1KeZhonEOULNhXX164q7cvVSGo3fmgsOVPT+rI6fhOpEp9zNS6o4FkWB2
         XVvA==
X-Gm-Message-State: AFqh2krkaQ2406qViUgk55mDFMYyisNLzKh2SAeLV3g0sMds1tuluH+i
        zDmsNNfrQ+p48h25ByFeXG9kACtdhCU=
X-Google-Smtp-Source: AMrXdXt8VjFWMMJf55lo2jIx0MoBKxQq6IZ2ZhaaWGPz1DRkoh9O6zqoCLauIMkMu9eK7QZ2vRG7BQ==
X-Received: by 2002:a05:6402:1948:b0:470:1f1:257a with SMTP id f8-20020a056402194800b0047001f1257amr16530145edz.25.1672058841610;
        Mon, 26 Dec 2022 04:47:21 -0800 (PST)
Received: from ?IPV6:2a01:c23:b980:7800:e1ac:248e:2848:f0b5? (dynamic-2a01-0c23-b980-7800-e1ac-248e-2848-f0b5.c23.pool.telefonica.de. [2a01:c23:b980:7800:e1ac:248e:2848:f0b5])
        by smtp.googlemail.com with ESMTPSA id bx4-20020a170906a1c400b007c0e6d6bd10sm4777605ejb.132.2022.12.26.04.47.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Dec 2022 04:47:20 -0800 (PST)
Message-ID: <0c19caa8-b91e-f939-49c2-89fcb92df942@gmail.com>
Date:   Mon, 26 Dec 2022 13:47:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To:     Chunhao Lin <hau@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com
References: <20221226123153.4406-1-hau@realtek.com>
 <20221226123153.4406-2-hau@realtek.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net v3 1/2] r8169: move rtl_wol_enable_rx() and
 rtl_prepare_power_down()
In-Reply-To: <20221226123153.4406-2-hau@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.12.2022 13:31, Chunhao Lin wrote:
> There is no functional change. Moving these two functions for following
> patch "r8169: fix dmar pte write access is not set error".
> 
> Signed-off-by: Chunhao Lin <hau@realtek.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 44 +++++++++++------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
> 
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>

Note: This series doesn't apply on kernel versions older than 5.15

