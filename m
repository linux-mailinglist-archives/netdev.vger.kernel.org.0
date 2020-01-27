Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38B9014A1DA
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 11:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgA0KUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 05:20:41 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44065 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgA0KUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 05:20:41 -0500
Received: by mail-wr1-f68.google.com with SMTP id q10so10485393wrm.11
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 02:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zslk4wmBhGFoeNUTTOT1nWg3gqwSlHOwujjjmR57suw=;
        b=hREZWbwtIq6rYhBk0kMKns1G9N5zqYgJat85FPCNjTaUBRTkIfrochsM+2qOUWx1KF
         rVr8+lRCHJAWZIs0vMOnFh/0icHy5CuYY5PkgxGtemIDVK6EQxnYe4zdbF4NeS02bT9N
         PVIYN5jvuX9LClIjm8H58RFuV0n0ktsWHR9E99MOei1AQhVIjvF/HMuo4BnmAjFbM1pf
         uWENfgvaMw2KETL0JoQP+25oiSWMWgjbEe0ur7nTy1/iXYN/FJWbnQXHtTzV9XSyKOa7
         ygflGO1vDWiVLlR5ilqZRkoDYNvzYoguMeojKJNOHzcdlPWZCUDyy5nwEc3DA1xccfzq
         3KKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Zslk4wmBhGFoeNUTTOT1nWg3gqwSlHOwujjjmR57suw=;
        b=dnox5nI9linDau1JO0clj/PKy4BnfkYbzK1RW3mk8mQA/2qSUsqRxZ5O+ZCkwWa4E3
         7TKs/l9266CKRmxbisT/EDv1xBVcNi8nyLbVO1py0GBd0nU6IAii8y389rv7A+nc48cM
         uPiwg/yEi5ibK9cZo7/MvSaDppckRzGpW/+/IzHtmg52N/SSkRCDxbMpD3PYJ/u+WxPU
         ktcLLcSWIlV9swCPepRd2zlMSgU2hXJf/Php9ptcclcU+TWEIF8o/ek4xOZtk4Ugp3CR
         hwivQBnubXJyJpclYNS7viTPHMuhhaOUFt5L+ysbK6EkCz08GScpOqr1o2yLpcib228k
         mMyA==
X-Gm-Message-State: APjAAAVZ+KeLoZYwi+BQ/+BCMqupI23xLYLve0j+sTVzd1itNudHRy0x
        w8pRFjoK/d52UzqsoIgHHpUZhdgHM/M=
X-Google-Smtp-Source: APXvYqyRXPYTTvkYvEVsMzxSn9bWBrp0G7szIfXFFsN2Ap9vgleMgTK5Sr1IcGJFCZujJYWhfxGorg==
X-Received: by 2002:adf:fe43:: with SMTP id m3mr21978343wrs.213.1580120438807;
        Mon, 27 Jan 2020 02:20:38 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:84eb:1bd0:49ec:9a40? ([2a01:e0a:410:bb00:84eb:1bd0:49ec:9a40])
        by smtp.gmail.com with ESMTPSA id b16sm20206911wrj.23.2020.01.27.02.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 02:20:38 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec v3 0/2] ipsec interfaces: fix sending with
 bpf_redirect() / AF_PACKET sockets
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <6407b52a-b01d-5580-32e2-fbe352c2f47e@6wind.com>
 <20200113083247.14650-1-nicolas.dichtel@6wind.com>
 <20200115095652.GR8621@gauss3.secunet.de>
 <35524394-8ba1-1868-4e85-ddfd9d829c6c@6wind.com>
 <20200127095810.GC27973@gauss3.secunet.de>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <9dab50e2-3892-d53a-b5f3-d1e913c20aa0@6wind.com>
Date:   Mon, 27 Jan 2020 11:20:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200127095810.GC27973@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 27/01/2020 à 10:58, Steffen Klassert a écrit :
[snip]
> I'll do an ipsec stable submission the next days.
> 

Thanks!
