Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53503F4383
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 05:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhHWDCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 23:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbhHWDC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 23:02:29 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B457DC061575;
        Sun, 22 Aug 2021 20:01:47 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so17719014pjr.1;
        Sun, 22 Aug 2021 20:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VUSCWaHr794uxKbw9ZSl7eYSMxn8eUX4SnaHucm+ud0=;
        b=hJ2KLDu4n+kQBjkiaj+Yo65M/r88NnH2nM7kiC4/3ilhwd5qqh4rXXHITzQr+4kf/M
         639/nj28RSaoAcR2Fdyrziin5L/MMxeQJNfN0jOnlYlGOozL6BsUgDnAQgorCqIxEDwy
         IR71UH43gdxi+tpHFdPyCAWA6RJn8jn0v/R22nXTYHAbFJ4hhObhDG8n36uYWkoEIT3y
         QGfjVlH0g2Zxk3F1k+A0RWBPykbRJoaSwRjqiFaIwi++F+xr1vXcdojTZCXGDw14T34Z
         HnM8HwX63d80xs1vhlGvW4bABS0vE/3wS/B4N0jSjY646uriq710UhCF1ETmU5IYDfXI
         o8Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VUSCWaHr794uxKbw9ZSl7eYSMxn8eUX4SnaHucm+ud0=;
        b=PztiMzCTpYc2DSfu3J+pMKvgThgaeKc+WHrdvuuM85i5t1D7oxKoA8bXlHA3apT81N
         9zAVcqJD0jr4yeVCzUvSi+HIM1+XIt2d4+605TUrO9YPrkp5WtJ4EXWMOvWo6oGchnV9
         nFuBKIeJF8AvVRcVSgWEnd7pobqEwBr57wBmCzTQGBu8zHg6NY/kf3+g3aks8H/e17FP
         7hvDJmBPkmp9xhNEy0LLl4QNgZN2nrRcBjmzo4/D2z4Tf9hgDb+MxB2uMOoUO2sioWB/
         KCIFL0anEBmAky+KV+IsatYxke0uJctcevL3Rt9nbCyWrZkOKHxGVBWZBzr4w6xasX/c
         zzmg==
X-Gm-Message-State: AOAM533uLLu0MxyJWpQhTa5N4Mnq6slwiaOVz6J609MNOhTh0+GNDrGM
        4UisZ0VnxH8qG8QwZ5BWGj0=
X-Google-Smtp-Source: ABdhPJyn7EDf07XPgwZJOFJi32fo1jg/MVO7kaTlBY4eMx/tOVZ2oMuX1Z65Qs4NFgK0iQSCHf0JVQ==
X-Received: by 2002:a17:90a:ec0f:: with SMTP id l15mr1573221pjy.82.1629687707322;
        Sun, 22 Aug 2021 20:01:47 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id a15sm7192486pfn.219.2021.08.22.20.01.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 20:01:46 -0700 (PDT)
Subject: Re: [PATCH net-next v4] ipv6: add IFLA_INET6_RA_MTU to expose mtu
 value in the RA message
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
References: <ad32c931-3056-cdef-4b9b-aab654c61cb9@gmail.com>
 <20210821061030.26632-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a4a52162-c645-b369-a9f3-120f48115cde@gmail.com>
Date:   Sun, 22 Aug 2021 20:01:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210821061030.26632-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/21 12:10 AM, Rocco Yue wrote:
> In this patch, if an RA no longer carries an MTU or if accept_ra_mtu is reset,
> in6_dev->ra_mtu will not be reset to 0, its value will remain the previous
> accept_ra_mtu=1 and the value of the mtu carried in the RA msg. This behavior
> is same with mtu6. This should be reasonable, it would show that the device
> had indeed received the ra_mtu before set accept_ra_mtu to 0 or an RA no longer
> carries an mtu value. I am willing to listen to your suggestions and make
> changes if needed, maybe it needs to add a new separate proc handler for
> accept_ra_mtu.

fair point. Consistency is important.


> 
> In addition, at your prompt, I find that this patch maybe have a defect for
> some types of virtual devices, that is, when the state of the virtual device
> updates the value of ra_mtu during the UP period, when its state is set to
> DOWN, ra_mtu is not reset to 0, so that its ra_mtu value remains the previous
> value after the interface is re-UP. I think I need to fix it.
> 

Please do. Also, that problem should apply to all netdev's not just
virtual devices if you are referring to admin down (e.g., ip link set
$DEV down)
