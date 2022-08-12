Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA58590CD8
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 09:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237597AbiHLHuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 03:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237221AbiHLHuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 03:50:22 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C22EF39;
        Fri, 12 Aug 2022 00:50:21 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e13so335059edj.12;
        Fri, 12 Aug 2022 00:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=PbDmuCCKzyRWwV8QvEQk0Rlp9mi8auTSVSuf8xoS7Cc=;
        b=HbKrQw+8JKGp3PXqegOBmVGvjTbQ78gJOZHgTnCRX7fwUoWe4Pfa94dweOR13sKavP
         9OFdMxYSaNgfjE1JUIv1nOo3mRcJ3uYYTSwtpIEqjUN6UnQW04it9SRkODE4jkGu9nfx
         1cyIOyQ8dIQqnOdjWpT7oKMdO9bzFWiGkD5PNoM0ke9JvAQIM38+pYcx7Engka/mBMFn
         4qsK/nUIvJIiPU4wzH/Hi/5v7IgzHXdnoXh+CIX480u9jZ/E9fiJiaG2hlxcTuRR/KeB
         MHkLtp/KYoMCWCJtZtx9eDsgFcNVq46giBO0bm+2/6tVquA8lsEiweU8Tnnb0kwXpErl
         Z8TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=PbDmuCCKzyRWwV8QvEQk0Rlp9mi8auTSVSuf8xoS7Cc=;
        b=rx1mR8yfTbIYb7feJ1idebVOASo/GSESJMPsZ6zR8lHtjZGfntWIW0OVFFZJszHyhk
         qn0wkR8F7x5SexCbHYLcUqO4jtBCjPpHnoNkYjGbi/gExh3P7v3WLU51qoxlo0Gcac8e
         bpceS4rBZBVxVbrm2Eo2sKqIn9Own7QTws9QfJKLwaY3Qqo6oUpz54noPcGYXfFvlwkh
         PQ+EYCD8Dx5qJtf2DqRbi4Kwdj/kVrUVWVAlo8UOZhI4Q05FlVPrpzicSu7WpahOKQB8
         DgfjlRIRotjv2JU90qdLZAkqjgYYU9x8E/5bZyQNXyrWvcbwnI0CJiwwE4D5zzjkfwLH
         8O5w==
X-Gm-Message-State: ACgBeo2B7fVAPYrPItysqPqLWlOcHRomriSF1xTuBB/1FOEFaT3cNeKr
        T1sGvjq9NV4B6mMG1DY5CuU=
X-Google-Smtp-Source: AA6agR7P7YP0YhQyYsLESfYmj9z03Jl0/PAT5zjN1y1OddquPRebDzZCrhq4G+9BUUZZ1SZaQw1Vsw==
X-Received: by 2002:a05:6402:5289:b0:43b:69a9:38c8 with SMTP id en9-20020a056402528900b0043b69a938c8mr2554553edb.263.1660290619770;
        Fri, 12 Aug 2022 00:50:19 -0700 (PDT)
Received: from debian64.daheim (pd9e292f4.dip0.t-ipconnect.de. [217.226.146.244])
        by smtp.gmail.com with ESMTPSA id jx27-20020a170907761b00b0072b55713daesm515099ejc.56.2022.08.12.00.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 00:50:19 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.96)
        (envelope-from <chunkeey@gmail.com>)
        id 1oMNYi-0006Th-0d;
        Fri, 12 Aug 2022 09:50:18 +0200
Message-ID: <4666c90f-b119-b283-7f6d-ad7b97a754b4@gmail.com>
Date:   Fri, 12 Aug 2022 09:50:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.1
Subject: Re: [PATCH] wifi: p54: Fix comment typo
To:     Jason Wang <wangborong@cdjrlc.com>, kvalo@kernel.org
Cc:     chunkeey@googlemail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220811120340.12968-1-wangborong@cdjrlc.com>
Content-Language: de-DE, en-US
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20220811120340.12968-1-wangborong@cdjrlc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/08/2022 14:03, Jason Wang wrote:
> The double `to' is duplicated in the comment, remove one.

Oh, there might be more errors... much more.

If you can, please aggregated spelling and grammar errors.

Acked-by: Christian Lamparter <chunkeey@gmail.com>

> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---
>   drivers/net/wireless/intersil/p54/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
> index b925e327e091..e127453ab51a 100644
> --- a/drivers/net/wireless/intersil/p54/main.c
> +++ b/drivers/net/wireless/intersil/p54/main.c
> @@ -635,7 +635,7 @@ static int p54_get_survey(struct ieee80211_hw *dev, int idx,
>   				/*
>   				 * hw/fw has not accumulated enough sample sets.
>   				 * Wait for 100ms, this ought to be enough to
> -				 * to get at least one non-null set of channel
> +				 * get at least one non-null set of channel
>   				 * usage statistics.
>   				 */
>   				msleep(100);

