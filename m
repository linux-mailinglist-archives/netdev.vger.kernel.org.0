Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B076128395D
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgJEPQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgJEPQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 11:16:16 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F32C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 08:16:15 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id l11so802649wmh.2
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 08:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8P/Y+cdQgU4hGcdJmbgViUyKjvisofzjM0HdBo0hzYg=;
        b=WI9PQTnbI0KSSwVoL1D66SDULtmtnJXAmSCSjQDIGBPS8zHDouW/45ViQKBD9fFC2v
         ZcYfmcHWn3s3B8Vs9uHJy/hcbLK8SAJEXEJrs0qq/sff0mp68SCbWVPOLeWj8SzWhD6m
         vmxDG1ZnWFHKZoDvbPYAhA3Vx3til7Kxox0hIFE3m0U1X2azCyauZmnuw2sHtETtS9AL
         IszpqKPV0/wuNIMCMRTGxk2/NHulexUcBk2lmeRe+cn2QjgSOkAXiBMWCA8ysUIuUomy
         BWqWxRU9nRG/ZUhhaklmtUMMl/zpY97MH/7wmslgF//ZZjf1Zoay3LbS5jVIXrX7x9Q/
         y1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8P/Y+cdQgU4hGcdJmbgViUyKjvisofzjM0HdBo0hzYg=;
        b=fHcphlzvijHvWqM6/KGOUrlzmQImbfd6IkXlQk9Hb6d4NVIKumzsHeJxTlEasFc6Op
         FUXtSmNwBk8+WXgYLNR+TXtbXOKr04Sfcj9Q1iL7vYzCTPVI+dP97kW1zQMUYyf5ZDCn
         UbkXLj85yFq4esa/5kUfq7ZPmPduZmR2h8vsMcH2mnAKB59dDkgFn455xiLUrfZS7RDd
         S3XFDLm6RGl6vuQDdRyauVIRnYR3xU1PIWtVozxozsqdH1T8mY6C7/16Tj9goLJzyfY+
         JoMdwhBwVqsrfIw8VY76iAVs2o6L/LbGl/3NNfTSPbQPHcrdVDXByzLX50AL20NL/Bnp
         2zHQ==
X-Gm-Message-State: AOAM531uv4SWkWXuDxExygffdr54dhz3D9Z4rbqn3CVDiPWclYVn69aW
        rQxw8jS8zXphn0tvMRQx5Z+Z3MRFmD+Tig==
X-Google-Smtp-Source: ABdhPJyzVDa6SKJ+ULjxiOgqwDSPF1nh42mka7H+ShD2rLXs4iad+Z3hXbIOALYykHXPV+/abLP/OA==
X-Received: by 2002:a1c:ed09:: with SMTP id l9mr76120wmh.89.1601910974099;
        Mon, 05 Oct 2020 08:16:14 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:d146:d085:7412:4af5? ([2a01:e0a:410:bb00:d146:d085:7412:4af5])
        by smtp.gmail.com with ESMTPSA id o129sm49488wmb.25.2020.10.05.08.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 08:16:12 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net 08/12] ipv6: advertise IFLA_LINK_NETNSID when dumping
 ipv6 addresses
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org
References: <cover.1600770261.git.sd@queasysnail.net>
 <00ecfc1804b58d8dbb23b8a6e7e5c0646f0100e1.1600770261.git.sd@queasysnail.net>
 <40925424-06ff-c0c5-0456-c7a9d58dff91@6wind.com>
 <20201002090323.GC3565727@bistromath.localdomain>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <acfa6911-f00e-fae8-cbc4-4b008ad7c793@6wind.com>
Date:   Mon, 5 Oct 2020 17:16:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201002090323.GC3565727@bistromath.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 02/10/2020 à 11:03, Sabrina Dubroca a écrit :
[snip]
> I guess I could push the rcu_read_lock down into veth and vxcan's
> handlers instead of the rcu_dereference_rtnl change in patch 6 and
> adding this rcu_read_lock.
> 
Yes, I think it would avoid having this problem later, when someone else will
use this helper.
