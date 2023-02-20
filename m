Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F1369C6B4
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbjBTIbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjBTIbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:31:00 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE06A13D7F;
        Mon, 20 Feb 2023 00:30:42 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id bg25-20020a05600c3c9900b003e21af96703so1260957wmb.2;
        Mon, 20 Feb 2023 00:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=38iBZGa7mhNZ+ybXNGzs0YzZQaRgPLDUglmvTZSdzf8=;
        b=BsV5zdPskSj8ghH5JlJqRFefi7fNHP2JNs7LiuqtoTEuZw5vhwy9OCzDhPUZHEbxIQ
         1fYiNp7947ovMQX67Svb38s1tj0jHXDe85g1Ayl7XLPF3MaaawYySEV+MZ9sEPWJQCsd
         kPhaaFFX/4E3OHWQe5rcmWND/mtQzJhML44Y91zs6ARXUTHx3158xlAod1aCAKkXW5CH
         sgMcB17Z6SJpC8z7kkKJR+/GQQ01Z2LscndGD3mhc+HbOUvM8gnkcx52vw/EjYVh6hR3
         ee0rtGeEas1nugZ5yyVG+O/VVQUMTyBi4SWFh6dyzxbPGl/rM+FwTNEe6w/2YeFuVRGr
         0u8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=38iBZGa7mhNZ+ybXNGzs0YzZQaRgPLDUglmvTZSdzf8=;
        b=RSURK9c3L90R6Veo9eiEjSue3iuZCGlVKsABrkpiyZI9KS/Kpn/PzDJdTBRgFSO9Hh
         PGX7sbu5JNuF9A3xUC6wQGKlmHzb7SBR9sOqW1pxQpYGIvK8n6S/TkpBF3iRN2oJZRqk
         Mgzw7LvXV87r2YUYSlUOjFOzvehNbU7E3GohDNddnrJrWRSOQ9Z90MngCX/lzL2S85B0
         YUtwI+ZRhmQCyPeckfg8d8luflZgpS6choCdBmzqF5ODlXx9+XTHyKCl1dhG7brK6Fvc
         dQYt8S4iCQFTtuQz01H82Ynlcb/zRalAoDLwwd47K0o9tDb1lgmNFl/RS7ts5H7+uIVI
         u6JQ==
X-Gm-Message-State: AO0yUKXrpxhmb8r2x9CnhEQrCoUsd1jdvk/HbF1y6BChqYUe3ahXnq3N
        DCLa9ztARHnFkzq7MtIdjQQ=
X-Google-Smtp-Source: AK7set/qzxLQRKHaj6GQzJWNraXjbW3LuAlEL2csLSRSz7eHOVKxOLZGQbn+89Bs4fr/SJOwF5zOvQ==
X-Received: by 2002:a05:600c:1f06:b0:3df:9858:c03c with SMTP id bd6-20020a05600c1f0600b003df9858c03cmr417216wmb.17.1676881841332;
        Mon, 20 Feb 2023 00:30:41 -0800 (PST)
Received: from [192.168.1.115] ([77.124.87.109])
        by smtp.gmail.com with ESMTPSA id l18-20020adfe9d2000000b002bfe08c566fsm1505663wrn.106.2023.02.20.00.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 00:30:40 -0800 (PST)
Message-ID: <19004c92-6913-9e8e-7dc3-7d9173f131c1@gmail.com>
Date:   Mon, 20 Feb 2023 10:30:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH] net/mlx4_en: Introduce flexible array to silence overflow
 warning
Content-Language: en-US
To:     Josef Oskera <joskera@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20230218183842.never.954-kees@kernel.org>
 <07b5c523-7174-ac30-65cb-182e07db08dc@gmail.com>
 <CA+hmzGDGRTOv9RBe8Kt9b8LdKpHLiGNTA5DkivatraXigWbDjg@mail.gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <CA+hmzGDGRTOv9RBe8Kt9b8LdKpHLiGNTA5DkivatraXigWbDjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20/02/2023 4:09, Josef Oskera wrote:
> I've tried Kees's patch and it works for me. I am able to compile mlx4
> without the fortify warning.
> 
> ne 19. 2. 2023 v 10:43 odesílatel Tariq Toukan <ttoukan.linux@gmail.com> napsal:

Thanks Josef.
Then let's go with this one.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

