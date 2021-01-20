Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37DF2FD74B
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbhATRg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 12:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731303AbhATR3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 12:29:41 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9952C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 09:28:57 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id m6so14919000pfm.6
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 09:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9Mkmpv9PFAxMnPKm8GBmEbqnKuQLLkGr4QOfMfIpd7w=;
        b=Sq7hBEVFTJF2AoShRevlABx7wRgNe5Zh5YXd9KmvhRag1mVa3w1lV3cy7Io4MGr2VB
         S3unvRLaiDksAh8crs/vVbmQvQ3WVHtmjSLe0cm0eu9rEXh6z5mwXEsQqVKnpQ6DHCVR
         49MAvilbud69tiWXx9r52zRx3kKpOawYqkYHQ6XydgupjMS0GdkJ17XbkRgowp+IoD3b
         urvDo3ILP7T7jyW3OcUpL15aQWZfY/+Y8Ut5y8+LFEf1No6eJzMM9B+gZ/qcoXUHn9Kr
         WCSAYwMAKj/ubDkzFMHFX83YyAypN/EqyW6xwSdNJtc4eZW3kW1l5Sc4OkfVhas0wfm8
         0nsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Mkmpv9PFAxMnPKm8GBmEbqnKuQLLkGr4QOfMfIpd7w=;
        b=dlfKcibvBAWLGjsmG4d0dPEMcrBdsAzWebl294jE8ef2C4rV2lcD094pphHZKD/BUz
         KgAjOJZaYcZ3CFwhYLNNAnqH5wqk4ZEJI2fM1duUT9BQePPiuIwoCpO1Up73xjAKODjo
         OkBeSc42G2wh6YvJhwt/SKV6QamKYjZfma05L+oouvM2n1vWG+ba3v/Tm8m/EUpHGe9Q
         0oM+HfK9ctYW8Z9QuuTg4dqpDq743b/8i0MuJWHSnVGKq3+B47DHLVLUknqfq8RaUeXC
         Ze/im9foLcJCK+fpJgKavaAaqKH8gQw3+ZXUqdapNE9AtWf/XKHidsJJaqZRBeiY9460
         cUxQ==
X-Gm-Message-State: AOAM532ovCs4vE2nAGBWd4WByKQh/jUGWG9rFMQbeCCJABz7GgOCbncJ
        jgwzb5zeqIzunUkXhP5TECY=
X-Google-Smtp-Source: ABdhPJyv/oY1Crowy9wSnQEOglqFtaMH0u2gG+n1/Be+HjmvUZy1eqodyE1Uad+R/ZCKc2q0ULpPMQ==
X-Received: by 2002:a63:ea4b:: with SMTP id l11mr10268105pgk.61.1611163737326;
        Wed, 20 Jan 2021 09:28:57 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 14sm2692221pfi.131.2021.01.20.09.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 09:28:56 -0800 (PST)
Subject: Re: [PATCH net-next v7 3/3] net: add sysfs attribute to control napi
 threaded mode
To:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        Alexander Duyck <alexander.duyck@gmail.com>
References: <20210120033455.4034611-1-weiwan@google.com>
 <20210120033455.4034611-4-weiwan@google.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e5714161-d8ca-d5dd-f12c-a6b206558cf9@gmail.com>
Date:   Wed, 20 Jan 2021 09:28:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210120033455.4034611-4-weiwan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/2021 7:34 PM, Wei Wang wrote:
> This patch adds a new sysfs attribute to the network device class.
> Said attribute provides a per-device control to enable/disable the
> threaded mode for all the napi instances of the given network device.
> User sets it to 1 or 0 to enable or disable threaded mode per device.
> However, when user reads from this sysfs entry, it could return:
>   1: means all napi instances belonging to this device have threaded
> mode enabled.
>   0: means all napi instances belonging to this device have threaded
> mode disabled.
>   -1: means the system fails to enable threaded mode for certain napi
> instances when user requests to enable threaded mode. This happens
> when the kthread fails to be created for certain napi instances.
> 
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Co-developed-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Wei Wang <weiwan@google.com>

Can you document the new threaded sysfs attribute under
Documentation/ABI/testing/sysfs-class-net?
-- 
Florian
