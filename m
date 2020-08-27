Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F37254B11
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 18:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgH0Qph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 12:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbgH0Qpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 12:45:35 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF1CC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 09:45:33 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id q9so3597165wmj.2
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 09:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x/CpHXQu+AfQY/C5sx950OgPR2UXD7lgTOic5RxGwPI=;
        b=QJ6ptyUWs+9NUcQT4Gzpdaayco09UiYhlRVwgkc1nN/7Va4WtzrbYN4aWZaEe7wZGb
         OkxzYXKCvdC6ctdOUI0rpW9BilYxhN4jZJaDJMc0CyjA8A8qCs7dB0hz/2SNuwWQ5PW+
         /YZ5BUpSkYDcAkTKd4cFjtJ9AyPGJa57zh0RpAbu5gZqZdLjMa62+MYzBNrl5TeSjX+Q
         Mn7vWKUwR5OVB1LfNi9aYXWBsyoU2qkfBF9TkzxOfWDlm3x3uk2e7HPNf1QWULlZsB59
         v+WqW9XDSV9nz9v854Jxe38YiXc20UBpwqaHfVxosrhb4LhcXC+qetKs4XFSsQA9oN/h
         B6Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=x/CpHXQu+AfQY/C5sx950OgPR2UXD7lgTOic5RxGwPI=;
        b=CrmSTo1jYWseCxU1rxP99sX59LLIz+xkkIWi0Gpf6yRXNnHI+y6ghSjCPeTLeKFhu7
         Aj+K9D/ScnnnzSoUM4vOD+EdsopQtYddD/jFEXGkOfGx1wllmtO3Jwqq6mr0s0w8lH03
         IIhLknzfppC5136AK6NpK7qQqQtpu9lx3HkDz3fo1rBzLNmdWqcRClA//c6FgXPkk5jS
         t+fyWgR/oa3T4zRt1puethXtcgRmVx/4wGWXXmTWnZ87UH2ds7+e0LkJYuu45Vb1KsHv
         2zkPqjbtn3ZB0EOs0ucX6XXe3Aaxcm7f5XCk1AyQiZkK0hJNE8j0mBkiDtmN6vdoSCiV
         BJ3g==
X-Gm-Message-State: AOAM5319T1jcMbmKbCthPXrdPyn5L9zL64pGUYifBAwc4q5eGxve6bd9
        3vdfOTly2y9sV/b55v1Po486pA==
X-Google-Smtp-Source: ABdhPJzqWHjt/jpV1F2n6yXJKUW/T2yp9W2ys+LExe3xXnpMWeF2a0PTf7M9AFxrSDOO/vaWIibXcw==
X-Received: by 2002:a7b:cd9a:: with SMTP id y26mr13574591wmj.154.1598546732431;
        Thu, 27 Aug 2020 09:45:32 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:590d:8a36:840b:ee6c? ([2a01:e0a:410:bb00:590d:8a36:840b:ee6c])
        by smtp.gmail.com with ESMTPSA id k15sm6217047wrp.43.2020.08.27.09.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 09:45:31 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v3] gtp: add notification mechanism
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        gabriel.ganne@6wind.com
References: <20200827121923.7302-1-nicolas.dichtel@6wind.com>
 <20200827.080514.1573033574724120328.davem@davemloft.net>
 <d0c3b1c8-4275-6b5a-3d93-4c9ac198b1a3@6wind.com>
 <20200827.094412.1386296048660013556.davem@davemloft.net>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <0c472a87-00b3-55d9-c1d8-9ba09a1fd0bc@6wind.com>
Date:   Thu, 27 Aug 2020 18:45:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827.094412.1386296048660013556.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 27/08/2020 à 18:44, David Miller a écrit :
> Was build testing, it's pushed out now.
> 
Thanks David!
