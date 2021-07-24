Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63203D4534
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 08:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhGXFet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 01:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhGXFet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 01:34:49 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C45CC061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 23:15:21 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id k4-20020a17090a5144b02901731c776526so11995909pjm.4
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 23:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=5tXS3XL03t0z5EU0PFP/M0ogxvI9O7Vxc/y2WeSoApQ=;
        b=L9u/lNUXjT4L9nvJn2hKk+32dKy2aXhiOH1iMYrdP7BtnubkGkacMQzc/vxLPRPxzh
         a9noCgXN8MZBGWw0pSRBpq25izI2Pl5WfvgnH7Y+pN7rDfryBB5E+fybLG5bgijvYwUz
         toc/sFmKIQmUT/9nY5o+XxXLUmTg+a9XV4x9/vLFD3lJmMzxpSjoHAUWFXpfO6i7HQCV
         CVQFJ3UgbD1/wa3XU1juddIP34Xwrrea7vjYBhR+bGP4on1R3vIIbiJyr1J/ZrorRLWa
         k4hgNzGv+P2ckmIpJ7HRtvI/77Fvec3/ut7FPz6s1yb/jy7KfCXH/NI2ojyg5B/J07mV
         CHag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5tXS3XL03t0z5EU0PFP/M0ogxvI9O7Vxc/y2WeSoApQ=;
        b=jv9kHfswjqvAkEd7QVor5yQ8cbYKpwmt1nZrhxYRkJyhMyZYM2XQk6URjXVs/tH9ED
         CfbcyAyNxZ8WTm/j65EqxQTgy/Ze2Ym0LjQgoelA+PJuJDGohSFwHH9rHyzCT5YxTrfd
         D2nlFrbEosStV4wbCTV35yKXX5nrkUpPRO9qFp+qHhtFQh36k+CQ19SXI8EKMxhfe+0Y
         GYZ8GfZ5bmWS7CY4qN6+f1SCEfqPSC2SwQ4hzKOmZxz5LlI7eF4fx9csEFzZCBTydJnD
         HE5mGKwQrVC2Q8XmgGqclLD6hiJy1n/gbXkOUJkTM3DYGEaolJT2uO8jWPnz/c9MxD1I
         eALg==
X-Gm-Message-State: AOAM530kWy9DMYs1hak27kVobqTwO8Om9wKLti0+pdvMsda9xsU6+SRT
        k7lVcTMQH7ykyeOgw068n3Khg59IRC/sUg==
X-Google-Smtp-Source: ABdhPJwVbAg6VZ7BWoGdn8LpOnAqIitOjYf494II3jysCXgzBtf1w6+hpj9DpKH5N4AtxQtVXYnmUg==
X-Received: by 2002:a63:5a08:: with SMTP id o8mr8151361pgb.120.1627107320800;
        Fri, 23 Jul 2021 23:15:20 -0700 (PDT)
Received: from ?IPv6:2601:647:4f00:3770:dd3e:3210:9b39:a423? ([2601:647:4f00:3770:dd3e:3210:9b39:a423])
        by smtp.gmail.com with ESMTPSA id b17sm32317106pfm.54.2021.07.23.23.15.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 23:15:20 -0700 (PDT)
Subject: question about configuring multiple interfaces on a host within the
 same ipv6 sub-net
From:   hui wang <huiwangforfbjob@gmail.com>
To:     netdev@vger.kernel.org
References: <20210724010117.GA633665@minyard.net>
 <91bce7da-163d-dee3-5309-ebcf27de1abb@gmail.com>
Message-ID: <25484f7d-e058-0976-5e93-30a8cf7aaf99@gmail.com>
Date:   Fri, 23 Jul 2021 23:15:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <91bce7da-163d-dee3-5309-ebcf27de1abb@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All

I have an host (running centos8), it has multiple interfaces connecting 
to the same IPv6 sub-net. Different IPv6 addresses are statically 
assigned to these interfaces. All these interfaces are assigned with the 
same gateway address.

I'd like to config the routing policy so that:

     All packets with source IP address specified goes out via the 
interface where the source IP address was assigned to.
     When source IP address is not specified by application. (ex. TCP 
sync packet), different interfaces' IP address is picked (as source IP 
address) randomly (if the destination IP address is different).

How do I config routing policy to achieve these in such an environment.

Please let me know if there are more appropriate mail lists for my question.

Thanks,

Hui

