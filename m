Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B6840599D
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240885AbhIIOsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239137AbhIIOsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 10:48:09 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD28C0698DE;
        Thu,  9 Sep 2021 07:39:20 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id z4so2908640wrr.6;
        Thu, 09 Sep 2021 07:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Nn30ccIH4JoWD6yLd4SqcwwQB1qB1pHSCA5yIkmN8mQ=;
        b=fR1EXGC+uJQQ64WeKXfdo3uxWGtDr7y/vk/GRzYs3SYdxIkhM+8f2DoUN7ER/DckyK
         fvnT7CeJxWFJ8fHx9EU4sPELcZfjZ6o3FSC1/4sq8ZJHV1xUY3QCX2N3XyHNhfWm5muB
         OIPJwdaC6bFvjMynm7lm4UlqJgUGeZc3XcBYJGKJfLERneQX1l54SxFNtPW6d6Y4Ue5A
         9K6E+i2btsG8QBgEOcaXJCMDvekIQf2sylYn4BQrfOa1yGRsFHxHxktEXeq22yDSiHlj
         TwUMPjimUpMOWDVF3cdZ0DpmQxeJ9PKjLKjfFez2WtpQRAC3Udevzfv7ft84mrCNMk46
         dW3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nn30ccIH4JoWD6yLd4SqcwwQB1qB1pHSCA5yIkmN8mQ=;
        b=AZOWlVIUfihLI837B3qRhD0zUV7bk4pCa14+GkKeJqvkJs4W8fHWsjey7ZiZuPpl7i
         2khQ9vtpoALz+9335MD2exvVvNLr888+JJGQSrjK+LutjteoxXxdORD5B9xmqGEmixW5
         EhkbddNEgB3Xro/5tIwYKYgS73dz6gahMf30HI5k/JiL/KP2a4waQ8saI9A2TZMJI3Lm
         SdjQDquTRNJB01/EJ/C7FCs5iTRUUk9zXxNDNtgMUkpmksGz+7m85dYBj4wIOqgPazz7
         MY5M7WJpTGeIJxoGI7LQDIverTKOCxuq/byj+M3CXGyIoj/B7y2HJ0DYGbrO/E/Yq7kd
         byWg==
X-Gm-Message-State: AOAM532nWQj2XL0xbGvbqPhLlTbcKSFZOia3TWSmd4JfLbj3XPKj+q1J
        gDIiXR8wSMQLWblL+sBsDtw4Qe3XAmKPAw==
X-Google-Smtp-Source: ABdhPJwrxlwFsCmqwVWSXKZgDNYjJYVLduuehkklCjsdf37obwJjiX6yDFHueOSCYQQ/Q8IoMhNsmA==
X-Received: by 2002:a5d:4488:: with SMTP id j8mr4044189wrq.260.1631198359342;
        Thu, 09 Sep 2021 07:39:19 -0700 (PDT)
Received: from [80.5.213.92] (cpc108963-cmbg20-2-0-cust347.5-4.cable.virginm.net. [80.5.213.92])
        by smtp.gmail.com with ESMTPSA id n4sm1724249wme.31.2021.09.09.07.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 07:39:18 -0700 (PDT)
Subject: Re: [PATCH net 0/2] sfc: fallback for lack of xdp tx queues
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20210909092846.18217-1-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <5233eedf-42a7-f938-67cd-e7acc5f3bbce@gmail.com>
Date:   Thu, 9 Sep 2021 15:39:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210909092846.18217-1-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/09/2021 10:28, Íñigo Huguet wrote:
> Íñigo Huguet (2):
>   sfc: fallback for lack of xdp tx queues
>   sfc: last resort fallback for lack of xdp tx queues
Patches LGTM, thanks for working on this.

However, I would like to grumble a bit about process: firstly I would
 have thought this was more net-next than net material.
Secondly and more importantly, I would really have liked to have had
 more than 72 minutes to review this before it was applied.  Dave, I
 realise you never sleep, but the rest of us occasionally have to :P

-ed
