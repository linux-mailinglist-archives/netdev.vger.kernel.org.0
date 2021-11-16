Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F1D45299F
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 06:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhKPF14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 00:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbhKPF0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 00:26:09 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D8AC048CA7;
        Mon, 15 Nov 2021 18:40:10 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id bf8so39161094oib.6;
        Mon, 15 Nov 2021 18:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=J2P6f/Qll54psTzyshVTaRUOsXK9V7Nooaq1sBo16AM=;
        b=LpJQ9l5eNWhRzMJZ+xAPvmtGeEWSZcsq/EbnPw/xlX1wTgsD4R6fX1SkvGvn5mDWs4
         U/XDGd2vlLuUKQKTh5LfsTRVv9mleDxVzZNIL2O4wftg7UwDIDGNQxDPRhUPz01P1jpg
         wkQOekmP//nsHA37J3Q7Zd/+8EcFoV3cS9rN5OkUTxT3xki/jPwxD7UVJyK5ckKJ4hjU
         tZBoNZbERlVD5xA+nVjRpaJT6b1O+2vQVoTsoDlZ0D+8lggkNKpyRwf/EuvNjSG8d7H6
         u66OjPV3abPHiaaV8QPd48ug6jDjPRLP6vMjp+jnymNPIYs24eA9bCLu5YY1jHUcur/i
         6ELQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J2P6f/Qll54psTzyshVTaRUOsXK9V7Nooaq1sBo16AM=;
        b=SJzSFxTkQd9KN+vZhFUVq89NXMLsFFTL7BWRqx4yMVZXRXK8FJ4jXHQ+1KqXcg3cG9
         uhx1LSNHQ5+d3NSqH1PgbNGfMo76J7VHpH/5ULLR8gQv2Oit/Q+hOeCjbMsLd8C9PFps
         NRYXezsjBB9mC9OiMXXHh0oc0hHaDYq42SBZLvpRbrSydBEqTbHzsF+vkfkYYHEGs/zS
         9XWA+qMxwKOrhJY6opObpSGUItECTHCB6oJA2f7QUQFlWN/nKMWcvxapyns5VsYXXAAE
         lU+jGWvXA5Zbz/byyVxgBmBTMzeKInlvyNJa+s+Wk/5bnijHO5Zau1TImFcX7HPxuLlr
         fqWA==
X-Gm-Message-State: AOAM531yGuNfUnJ8Pyi+VyfsRxDN3QH2WCfWRTQNvVA0KPfkBaSAs2Sm
        trs7RQQ2zseFHZDlUGXJxDA=
X-Google-Smtp-Source: ABdhPJwrqr/f9zGtFfDhRDzosynmlvgk8Ol+BxnLfPEd/r3UzkWFd2RReMfqAjP0pnoJh/ol2/7uXA==
X-Received: by 2002:aca:ac8a:: with SMTP id v132mr36254278oie.44.1637030409922;
        Mon, 15 Nov 2021 18:40:09 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id l9sm2902366oom.4.2021.11.15.18.40.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 18:40:09 -0800 (PST)
Message-ID: <69706525-65b1-8372-8ef1-1ee12e7bbc26@gmail.com>
Date:   Mon, 15 Nov 2021 19:40:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH net-next] ipv6: don't generate link-local addr in random
 or privacy mode
Content-Language: en-US
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Rocco.Yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
References: <de051ecb-0efe-27e2-217c-60a502f4415f@gmail.com>
 <20211116022145.31322-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211116022145.31322-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/21 7:21 PM, Rocco Yue wrote:
> 
> Due to I can see this patch from the link below, I'm not sure why this
> happened, could you kindly tell me what the merge window is, so I can
> avoid such problem next time.
>   https://lore.kernel.org/netdev/20211113084636.11685-1-rocco.yue@mediatek.com/t/
>   https://lore.kernel.org/lkml/20211113084636.11685-1-rocco.yue@mediatek.com/T/

check patch status here:
    https://patchwork.kernel.org/project/netdevbpf/list/

check net-next status here:
    http://vger.kernel.org/~davem/net-next.html


