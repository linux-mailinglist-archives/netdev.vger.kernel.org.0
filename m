Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F894DD6B7
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 10:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiCRJAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 05:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiCRJAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 05:00:36 -0400
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184CF2709;
        Fri, 18 Mar 2022 01:59:14 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id bn33so10461190ljb.6;
        Fri, 18 Mar 2022 01:59:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=I+DAvFkKurUFDaU4un333ZxZazdliPSkbA9dCCZ/O8M=;
        b=ND2h6f2unmfi2/b3lcmdVe81O6BBrgd78NNprYuTvT5muc5bz6xLZYYyJ8t79l1jFi
         NK7Nx6iyLbCW9PK09bGNXg/EBrMQrEM97/1UlpyJay0riBOG/zemDq7gQGXrBElm3Qn9
         GwQ35e7JbC9qaw4HsNTOYknI/nkWLo4bPyKmkdb1oPpptULwil8DvzhGJgOQ1raODy8b
         4lY03hkPC4Nla4bDbL5Wm5I88rQlBvSuqqcMI3zYUrtZDlzgXF3xWf2e7J4i9dREnUal
         EdXKz+OxI12z5vh4ciBXPpjhBkyy1OyZEInj/RtXMdyMRrokvDRCBAWaWlq6bWfwTzJU
         ic1g==
X-Gm-Message-State: AOAM532udjepHI0A2nMxH9PaEBwV5ebeLSGPS5oG0BOcmCWpLfhx7H0x
        +M6+ZLf9vGY3oa23cSGFlwI=
X-Google-Smtp-Source: ABdhPJzVJulFHn2cmxPUGFqexOrRZs5KpUv1/PMGVOHmOXq9fbd7jj9GCBJR7b6QDKRdgb9CSErT5g==
X-Received: by 2002:a05:651c:90a:b0:249:5d82:fe9c with SMTP id e10-20020a05651c090a00b002495d82fe9cmr5377070ljq.300.1647593952390;
        Fri, 18 Mar 2022 01:59:12 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.googlemail.com with ESMTPSA id w27-20020ac2599b000000b004481e254f08sm751643lfn.240.2022.03.18.01.59.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 01:59:11 -0700 (PDT)
Message-ID: <5cada983-ece8-9d44-6ffc-0bbceaa6c11f@kernel.org>
Date:   Fri, 18 Mar 2022 09:59:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   krzk@kernel.org
Subject: Re: [PATCH -next] nfc: st21nfca: remove unnecessary skb check before
 kfree_skb()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, colin.king@intel.com, kuba@kernel.org,
        davem@davemloft.net
References: <20220318072728.2659578-1-yangyingliang@huawei.com>
In-Reply-To: <20220318072728.2659578-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/03/2022 08:27, Yang Yingliang wrote:
> The skb will be checked in kfree_skb(), so remove the outside check.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/nfc/st21nfca/i2c.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 


Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>


Best regards,
Krzysztof
