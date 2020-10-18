Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3CC291796
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 15:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgJRNJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 09:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgJRNJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 09:09:39 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D5EC061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 06:09:39 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id e22so10141720ejr.4
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 06:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C4MhzEacrfveI7LIuOBZ2tOXreV1Ub/mznptaci644c=;
        b=VXJta1jIbjhMSOdzQTo35/f8eMx8hmiE3MWls/mDN11d/ylMt8pCVu7S108MdQ4ICU
         Ba6e0OtBUEjNCHMgxYGQQ8SHlKdSd4pA0hNmamKLBDeLnIABekqXJfbBM5QBcfPFXi7V
         8QC987wt8Ukdlw2bg4SyLgiTY486h4dChjBLHiDAXRrhI9+wgB/hZl1arx6EgOWBGXqI
         ZWwDP5X+oYutCSLSYFJKFrV63Xnw37ueKS6JbMeYgtxuCOnJ9adkKxY9VpWTCB+8ZU65
         C0fmiUC86854+NL+9ymC5dDY9vusaxAAtB9fvnccArYSVfu00ctunqxDRf3sdfmMaY32
         jGqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C4MhzEacrfveI7LIuOBZ2tOXreV1Ub/mznptaci644c=;
        b=QUJoPTVkDUg4JI6h7t2BH1/M/H/1T3size8t71xxmm+y1SFYsyrNR93vnMW6Y5Xsd7
         hGYM55XNKPPRAutyc40yAQCHWTy/WK9iPeKtW4wcyGglGMSSssIJ+kGgaILXv6VfmkZn
         ypU53SvGjS9ONPSOU7RSefSoOUNp/3KcpeeHTHJ6mxyoMGMdzeuJ+8jUB/HfRnYuR7XX
         61pmJhvJmXL+6C5JaRO00jDnLSGur7GSVk3fhBCZt0cOSkcorWyw+G9n7qWCSX+BOOuD
         NGzYuEs8E0hhUc5O9XcAZkPD6AYnI8aO5PUGlSd2AljYU9JeYHX/MG6PhQtfjYb5UVU5
         wnGA==
X-Gm-Message-State: AOAM532cUIHl2uUatkNksTQ49nz4MEY85B9D9eP4JuqAxKhBwrkyQliy
        Q5Pi933ZWgcnk4hgNzr1mPs=
X-Google-Smtp-Source: ABdhPJxFbrWFSceJ5vNc09y+Eo+4jm2CEJzMKiqPPMNMnuFgAt2DSuCY6PSoo4wzK8Uzxord5Bn7TA==
X-Received: by 2002:a17:906:e15:: with SMTP id l21mr13137421eji.509.1603026578228;
        Sun, 18 Oct 2020 06:09:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:8821:97f2:24b4:2f18? (p200300ea8f232800882197f224b42f18.dip0.t-ipconnect.de. [2003:ea:8f23:2800:8821:97f2:24b4:2f18])
        by smtp.googlemail.com with ESMTPSA id me12sm7337365ejb.108.2020.10.18.06.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2020 06:09:37 -0700 (PDT)
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-2-vladimir.oltean@nxp.com>
 <06538edb-65a9-c27f-2335-9213322bed3a@gmail.com>
 <20201018121640.jwzj6ivpis4gh4ki@skbuf>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <19f10bf4-4154-2207-6554-e44ba05eed8a@gmail.com>
Date:   Sun, 18 Oct 2020 15:09:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201018121640.jwzj6ivpis4gh4ki@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.10.2020 14:16, Vladimir Oltean wrote:
> On Sun, Oct 18, 2020 at 02:02:46PM +0200, Heiner Kallweit wrote:
>> Wouldn't a simple unsigned long (like in struct net_device_stats) be
>> sufficient here? This would make handling the counter much simpler.
>> And as far as I understand we talk about a packet counter that is
>> touched in certain scenarios only.
> 
> I don't understand, in what sense 'sufficient'? This counter is exported
> to ethtool which works with u64 values, how would an unsigned long,
> which is u32 on 32-bit systems, help?
> 
Sufficient for me means that it's unlikely that a 32 bit counter will
overflow. Many drivers use the 32 bit counters (on a 32bit system) in
net_device_stats for infrequent events like rx/tx errors, and 64bit
counters only for things like rx/tx bytes, which are more likely to
overflow.
