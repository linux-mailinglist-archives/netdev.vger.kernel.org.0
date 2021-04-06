Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FC0355A45
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 19:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346922AbhDFR0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 13:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbhDFR0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 13:26:40 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D33C06174A;
        Tue,  6 Apr 2021 10:26:32 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id a76so4541263wme.0;
        Tue, 06 Apr 2021 10:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l2/DDXuF1+UJKEzekjcIbjpsXi5IY5979dhiBTUUxbE=;
        b=XiBqqzgK89mbNj19h6IecSmWVJJawESApqacalMTNPaCsBtnreXtSwgyaFGSVrcUOC
         2ssn4nmRz1YBlgCBAmZBUDZlqrlKPm0sCY01oJ4fMgEqPD3wQYDl1c1ZVwCkLhZ2TwQS
         7v0c9uqCjMbvzzrJbz4ByI0hjGkYwixjDQA8SqJdbM1uYSGdK8tFX6v4HpCf5+kc0SNv
         CuxEdQiDEfMuAJCk/i/avuLMvvLlkz7p1UZswc1pZAKpC9Xo18aElhyNT7PSWotpjoM3
         yodbkVDbqCRVMmKe7VR7uBWX41jlMdttd8PnxIPgOH+PaQSdenY5OdAn4wq8eXnj8/8Q
         kM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l2/DDXuF1+UJKEzekjcIbjpsXi5IY5979dhiBTUUxbE=;
        b=TufvN8viPbG064n1LQAfRJl9nXWGFzCZq41hEdSApuS4C0hL8Dhl3EdNM9WRuIYJla
         pZxhEDP59HGLlEzZh0Z43sR64Nl8R1PNKBQJFCLVG6nmS+wgNNaailK6a13XWPjsGKXJ
         AC5DagCCqsTJPZGcJEmYFtZV1ySu/dJlkFCH9p8Lx2dCH7VMaGajyfWkQvqWNzSUaova
         msvHBgyBHti16v/TcOspj4y4R9WHBvRne33zL+s5oRjHqJRZ3eWDbI/lRUnIVPkGhlT5
         DnnwefQMDdkMxN0ZEYAB2q5nGpMRUBPVDF7Qi0ZWzUQKWegDYvtKdHdh4Ro11zGgaQhC
         ElWw==
X-Gm-Message-State: AOAM5323OdSQNM4EcgpuDE7MkWMQ0Gle4L1lBLB1gthMuwO3JTcof/oT
        v2k3bvfXwdikdtLqPN41g0ZazvwhL9w=
X-Google-Smtp-Source: ABdhPJxrUI0tY+zcjCcYikXxT6vSF5p4TvLUBIItXIa+0CjyHRagPQpIzyIozklEra4MmzkGupOucw==
X-Received: by 2002:a7b:c219:: with SMTP id x25mr5163419wmi.163.1617729991118;
        Tue, 06 Apr 2021 10:26:31 -0700 (PDT)
Received: from [192.168.1.101] ([37.170.65.138])
        by smtp.gmail.com with ESMTPSA id m15sm32011333wrp.96.2021.04.06.10.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 10:26:30 -0700 (PDT)
Subject: Re: [PATCH] net: tun: set tun->dev->addr_len during TUNSETLINK
 processing
To:     Phillip Potter <phil@philpotter.co.uk>, davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210405113555.9419-1-phil@philpotter.co.uk>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ba1f5946-d1ef-ee4f-4ce1-15af2b324181@gmail.com>
Date:   Tue, 6 Apr 2021 19:26:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210405113555.9419-1-phil@philpotter.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/5/21 1:35 PM, Phillip Potter wrote:
> When changing type with TUNSETLINK ioctl command, set tun->dev->addr_len
> to match the appropriate type, using new tun_get_addr_len utility function
> which returns appropriate address length for given type. Fixes a
> KMSAN-found uninit-value bug reported by syzbot at:
> https://syzkaller.appspot.com/bug?id=0766d38c656abeace60621896d705743aeefed51
> 
> Reported-by: syzbot+001516d86dbe88862cec@syzkaller.appspotmail.com
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> ---

Please give credits to people who helped.

You could have :

Suggested-by: Eric Dumazet <edumazet@google.com>

Or
Diagnosed-by: Eric Dumazet <edumazet@google.com>

Or at least CCed me :/

