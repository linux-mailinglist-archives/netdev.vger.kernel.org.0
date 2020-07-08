Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B426218357
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 11:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgGHJQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 05:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgGHJQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 05:16:31 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1862DC08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 02:16:31 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id w16so49565726ejj.5
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 02:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=nar9QFnAOuM1ng6Yu5KM3VzSHM8K0TuozP7n/B35miI=;
        b=FCHTUH+TnmeQyjMw0pdOwRR74zHcCIL+/wHm98LpiCRPQbJ4AIK/ZPWqLRXEu9joSP
         taY6A0MvzBZGBhh352flK7012BceqK+4TSqxU12WVOqrDhMoC5IXE3gL+OlOHpLiFc16
         5OsATU60BVcEmsBfKV5gSLIWTnX2X1AKW92/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nar9QFnAOuM1ng6Yu5KM3VzSHM8K0TuozP7n/B35miI=;
        b=dWHHK8xkEd+dm5cT13m/sZB3wzbXTqqNIT6N71vSbmgroqMR/8ql1NQepV6ZEJF+UC
         QM2Miw8REN7VtrOsHVQRHYTQX085hfqwFAB2TmqrHwn2OGNSOcgf3XPCCH6dSpp74b+y
         uuaG0Ondm9eTkjitMQ+giyBuNLS+RpqSHwXB4BGWIwso56lqDueLEkSp5aWMR7BLwbSh
         iSWLNQ4eOX71lasgteRbG+DzGmwUE95NI2RyZ0eRKuEx4qC4Q+8PR34lCZQys2XAvx2R
         uNlvXN5GMxafxRipqUzxLvgSTG/WePTuVzEgz5eVkokFkejgh/sm4vzbzY1Qr/Z/YO3M
         pcMg==
X-Gm-Message-State: AOAM5317txTQstElEWQzEaT/8jkUe8VCF8raQIrC+rxmia4dDN/ayS/x
        2Sq6PifHZdPjIdaNt/+Yv4VDFulWJD0ZCg==
X-Google-Smtp-Source: ABdhPJwxefVk2ymWA0bDYtGdHVpK6Bi1fBuWCsNB8zxlFP3W+bOA7aclh4635qXNzegBktnYswpPAA==
X-Received: by 2002:a17:906:ca57:: with SMTP id jx23mr48405151ejb.256.1594199789340;
        Wed, 08 Jul 2020 02:16:29 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f10sm21651468edr.69.2020.07.08.02.16.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 02:16:28 -0700 (PDT)
Subject: Re: What is the correct way to install an L2 multicast route into a
 bridge?
To:     Vladimir Oltean <olteanv@gmail.com>, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org
References: <20200708090454.zvb6o7jr2woirw3i@skbuf>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <6e654725-ec5e-8f6d-b8ae-3cf8b898c62e@cumulusnetworks.com>
Date:   Wed, 8 Jul 2020 12:16:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200708090454.zvb6o7jr2woirw3i@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/07/2020 12:04, Vladimir Oltean wrote:
> Hi,
> 
> I am confused after reading man/man8/bridge.8. I have a bridge br0 with
> 4 interfaces (eth0 -> eth3), and I would like to install a rule such
> that the non-IP multicast address of 09:00:70:00:00:00 is only forwarded
> towards 3 of those ports, instead of being flooded.
> The manual says that 'bridge mdb' is only for IP multicast, and implies
> that 'bridge fdb append' (NLM_F_APPEND) is only used by vxlan. So, what
> is the correct user interface for what I am trying to do?
> 
> Thank you,
> -Vladimir
> 

Hi Vladimir,
The bridge currently doesn't support L2 multicast routes. The MDB interface needs to be extended
for such support. Soon I'll post patches that move it to a new, entirely netlink attribute-
based, structure so it can be extended easily for that, too. My change is motivated mainly by SSM
but it will help with implementing this feature as well.
In case you need it sooner, patches are always welcome! :)

Current MDB fixed-size structure can also be used for implementing L2 mcast routes, but it would
require some workarounds. 

Cheers,
 Nik


