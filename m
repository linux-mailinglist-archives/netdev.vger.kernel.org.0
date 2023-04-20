Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2BF66E97D0
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 17:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbjDTPAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 11:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbjDTPAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 11:00:50 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4063B35AF
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:00:48 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id he11-20020a05600c540b00b003ef6d684102so3205520wmb.3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1682002847; x=1684594847;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=b2uX+OeTJOGBNA3Jr45G/KYvawe4Z56MYH4+LtuDgc4=;
        b=fnRGbOOCDWrMuNSFxEY67pN1A931o6cABc60ua7OXgTwQ79MI5cVCtZMtCp7Qd6MdO
         m0T43zbFX1TaD5s7tJaU9Fj/kqiK5FB3ZyVARDP6JCc2bFMnBrhyQucgyRFgvvKAsxvU
         nBneBbjk+fcozy4Ku6dCtwN5bNxOBYzxqTDK/aSE0bOpPffj128RyEDRkaAj2nfC1lSm
         ahHd7TAKzl6o1sN/L3O6l3gn9k0Bo/a4nzLlCiaE0LC/EFdf+F4Je/yzIIHYFf1Pmug1
         tI0fxVF3jkyTf/bmtSrQw3H4iEzudLrn8wKn7XzK6pAaKdXcCvA3yDG057vEdkc6GBXW
         3A4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682002847; x=1684594847;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b2uX+OeTJOGBNA3Jr45G/KYvawe4Z56MYH4+LtuDgc4=;
        b=Ab6D3AdXb/F7xKrx2Xej2+6OhoVZsqDY7L5hUXs4Ws5DeJvbA81zLKA/9xNdjGbbDz
         nRCLXV+p8/NidrI8z6l2cdcoXAoeHaINo63S4hWq0kuFqYvZtY0Ogc0bMewUZSDGl/Ui
         GvIYkvkSqlCovCRcPsV1LM7/vXiduUdhJzSj5S588RcO98tW9FBCCRzJO6gxDYXnyvE5
         Od8j7fOGS01VqO3sCJoWAfmcSIBzt8CIJZttdHSK07NxNmerQ3/93BZYsXV3owPa9xx/
         ppMfswIvx4wDNvvDolECtpQHvbDLH6ocupcEZbIqcj0SgmSACltwd8Sr0EEKHgIQVCXl
         X5RQ==
X-Gm-Message-State: AAQBX9dIUry46HSUyWUNqzX4DWTcf8cHM7hCO0qfB7C75zeUZZh9tnsr
        FspQZ8jN0wpBw6gqdMlRa//ZkinSFRtl2Tj7/5M=
X-Google-Smtp-Source: AKy350bH4F0Pr3EVDHcKW+dV4v/cDMWhITRFQO66EQq9HfvR8h5IAK+Ja5TOjq+E1ieTQ99ac0WjGg==
X-Received: by 2002:a05:600c:22cd:b0:3ed:e4ac:d532 with SMTP id 13-20020a05600c22cd00b003ede4acd532mr1691891wmg.36.1682002846749;
        Thu, 20 Apr 2023 08:00:46 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:387:c4d7:9b0f:fb46? ([2a01:e0a:b41:c160:387:c4d7:9b0f:fb46])
        by smtp.gmail.com with ESMTPSA id o2-20020a05600c4fc200b003f1738e64c0sm5679125wmq.20.2023.04.20.08.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 08:00:45 -0700 (PDT)
Message-ID: <457447f9-4996-f9e9-2bb7-a858dff49b43@6wind.com>
Date:   Thu, 20 Apr 2023 17:00:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH iproute2 v2 2/2] iplink: fix help of 'netns' arg
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        dsahern@gmail.com
References: <20230420084849.21506-1-nicolas.dichtel@6wind.com>
 <20230420084849.21506-3-nicolas.dichtel@6wind.com>
 <ZEEhnt4G76URbksh@corigine.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <ZEEhnt4G76URbksh@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 20/04/2023 à 13:27, Simon Horman a écrit :
[snip]
> nit: The text in this and the previous hunk was and is inconsistent.
>      Is that something that could be addressed (at some point) ?

I will send a v3. Just waiting a bit in case there are more comments.


Regards,
Nicolas
