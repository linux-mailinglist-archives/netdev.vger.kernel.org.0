Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE8C40ECDB
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 23:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbhIPVqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 17:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238100AbhIPVqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 17:46:19 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309A5C061766
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 14:44:58 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t20so5507337pju.5
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 14:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J7zGtdLvKvOe8ICH65aGgixwwBsF46sfmmNr6BguxYU=;
        b=jsYa6l8OxInYrPcDf850gMevL8Ib/4g5G6K2fQYhyle7LVVynjDg8ZpCEcdCe1h5As
         OYK6N+TKII0GS8JT4L+Ys2HNWzvztZ52ZwL8ZaZrKl1xhN/TBXeBZOqq2HZeFHz0B45v
         lkiZ6C4wJwSyJR9JrluoaukLjRn0VedZcMth+BWFcno2rhogSUl1kSM7S/GdJzptOCVG
         opzjKCtMUFztrNj8GrxVTtJAnHLwe1vSIgiUvH5MBciXE/1IzaTWclFtM8ThMfcLfM5L
         pFwLTjLM2Y6cnWWXKXMYbFIRhqNcQimMSvSW62Ai+Pq7sZwuVfdFYJkH428tSiu2Y6O+
         MB5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J7zGtdLvKvOe8ICH65aGgixwwBsF46sfmmNr6BguxYU=;
        b=fsd2qjRjD8KVeU8RHexLSNiFN94BZQBejjWBH4aU6PPNS2QXKz4yKA2erlZ43zUJmk
         jzuyPFXZXMR7dG6pLByVpuG+FxmDvMFJVllOASdkWK8cTrLAHVOzNZn8qC1sybW2QXdb
         zihsnyfDCQ6/1mb4qN+GpS5E0DVFnFW2+YksVScdasN4DOBZD57knV6nJRZj/dLoy8fC
         RtNmVGbBkba0KKuJyANtV0smVcBeVFb0CCc7L4IB2qNvcQUvbFvhB1At3iCkX+sE4UL6
         4VlPDSOIJ6mdEcd0CNDrl1XLjrBwvr6kYJflXWl+OPpQKc5pf90seQhslyJu6jacB2Rc
         U+pg==
X-Gm-Message-State: AOAM533bw8P1K/jVYuvo3HUVk1/HlFwTVfUveBt9+ebWzs8OYI5bRd6V
        WnrBd+h+Eyn1GiYo9cpOnuY=
X-Google-Smtp-Source: ABdhPJz+r2bR5Cp4aK5/9SFR11GdphDuX9bH5Y9XpLcjMwKbVRmKoXiIGmmdb7slTJJKJEz57eHa7w==
X-Received: by 2002:a17:902:8503:b0:13a:366:8c46 with SMTP id bj3-20020a170902850300b0013a03668c46mr6491917plb.37.1631828697644;
        Thu, 16 Sep 2021 14:44:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f205sm2937968pfa.92.2021.09.16.14.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 14:44:56 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] net: dsa: b53: Improve flow control setup on
 BCM5301x
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210916120354.20338-1-zajec5@gmail.com>
 <20210916120354.20338-4-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a0317dbb-0d41-7f9a-ff3e-84d92364c2db@gmail.com>
Date:   Thu, 16 Sep 2021 14:44:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210916120354.20338-4-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/21 5:03 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> According to the Broadcom's reference driver flow control needs to be
> enabled for any CPU switch port (5, 7 or 8 - depending on which one is
> used). Current code makes it work only for the port 5. Use
> dsa_is_cpu_port() which solved that problem.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
