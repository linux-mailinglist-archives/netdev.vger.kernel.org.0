Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E0C21573
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 10:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfEQIjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 04:39:32 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40380 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbfEQIjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 04:39:31 -0400
Received: by mail-lf1-f66.google.com with SMTP id h13so4718611lfc.7
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 01:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3BHeb/pAMDnMMuI/QgUZ1CO7IvsSE49+tcylQB3p47Y=;
        b=DSqaIQtCHh5l8cqvFBp9qsjY9ZqtVKAt1pGEyJ4TmXkVxKjb2xvDlDN0tfp6FK8AXs
         LFt6lg1vv6qP5D8oF4Eb1/5fhteCjTygkbqWyFVbuc2H6xxxBXt/Wg0r3si1lhsmGUnO
         9jzLONP8eHVvHATHr09YKPs4TXWvBw0oHx4a1EOd6gfOsx6VrJ+SZeIEM/8htflIJtWr
         6LDV7UipVrOeVYkX/GhfPtrLGTnMDtfeUlYqbuqpFyIelgULOfPEzSRMakjSuYnglgig
         vr51RHvLbFiFfbfOrNU4B/uE+wZF9vV2/hfU5O3XFofSjAGUUMJRmkyPXGgVkHrCGqEJ
         k+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3BHeb/pAMDnMMuI/QgUZ1CO7IvsSE49+tcylQB3p47Y=;
        b=p3dBWnrYxNzloMFv78cvyl+1/pFSTI1QNYBlcZsvFlW/v8rW09MtFHdUlJ0ULdfhco
         V5Sl24zu8CRSHjxpCQE8NBqDcceKSRjFPBLBzJzIvMYMgwLSyOiZUotP0nRn/kOmnB+N
         rEKhk7y/1hVTduGyBefv9g4Zfl96t3nKS9f60Kux5JqHXS7wUDI0g+3WGyRudjM4sVoF
         /wBM7+lvvzecao9xquop0Tsdh5smc6KE5//RIKBsyaFImiaGlW3X7j53iWV5TdCSbrVw
         YdFOPupgf1pfiNA8PXrmId8e36UCIUsijVFY5JY13X9xzzNna1QhPbR9phPiVJXUE0KH
         aA2w==
X-Gm-Message-State: APjAAAUQI9sK+4NrNo34bQOQh5crOOBeh8oIyIC0BehB7tAkNsji9dVV
        xStJiptD+6aEyySOvI0YX6jYsDLUYPk=
X-Google-Smtp-Source: APXvYqxewO22ltX/ysCOZ0G9Ay4VmL14Ar5JrVLK5mdSTTgXl80ZcS5gJErbyTehtHaiFPV9sCs2dw==
X-Received: by 2002:a19:e619:: with SMTP id d25mr1584887lfh.34.1558082369879;
        Fri, 17 May 2019 01:39:29 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.86.94])
        by smtp.gmail.com with ESMTPSA id a29sm822566ljf.33.2019.05.17.01.39.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 01:39:29 -0700 (PDT)
Subject: Re: [PATCH] net/mlx5e: Add bonding device for indr block to offload
 the packet received from bonding device
To:     wenxu@ucloud.cn, saeedm@mellanox.com, roid@mellanox.com
Cc:     netdev@vger.kernel.org
References: <1558081318-15810-1-git-send-email-wenxu@ucloud.cn>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <6934261d-caa9-bc7f-d50e-ec5edcf8769f@cogentembedded.com>
Date:   Fri, 17 May 2019 11:39:18 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558081318-15810-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 17.05.2019 11:21, wenxu@ucloud.cn wrote:

> From: wenxu <wenxu@ucloud.cn>
> 
> The mlx5e support the lag mode. When add mlx_p0 and mlx_p1 to bond0.
> packet received from mlx_p0 or mlx_p1 and in the ingress tc flower
> forward to vf0. The tc rule can't be offloaded for the non indr
> rejistor block for the bonding device.

    What is "non indr rejistor"?

> Signed-off-by: wenxu <wenxu@ucloud.cn>
[...]

MBR, Sergei
