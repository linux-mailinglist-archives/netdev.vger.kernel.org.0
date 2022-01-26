Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6715449C23B
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiAZDmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237249AbiAZDmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:42:39 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777BFC06161C;
        Tue, 25 Jan 2022 19:42:39 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id i30so2814884pfk.8;
        Tue, 25 Jan 2022 19:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=K1WyeGYezne19214IRAQWvSDltEgxn3XDoQpdetw7bg=;
        b=DsGAPtTFGfvOA61xg0f3nJvleU3CpPPq9W1cxQ5EwZXY8BOCe+QPNDLz8penIEiS+8
         YZ7w+f5NaSpZ6Rd+lnwNrWcZFF3F8Jb3f8PcSttTe5OM12y5Ib1BGSaT0XYnrp02Ebin
         YLjEjY+WSe91T8Mm0IROphypxUbDwozg8GYqMyMDSvN9uno+fAJA/0ex8+7X9KdMDDiD
         6WlBSAHHUtcPQgRVxZHEQPTKOaInkl2d8RV9S8u9AT9h/ZG7+j5lAwYtbnXFdGzdKVf2
         cJxcsj7azL/bFMtRgU2xUe0QLz6Mm7XDo4bnuHtfZ9vSrd81ySvVLjyC+fqAlrdHGlrV
         0fSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K1WyeGYezne19214IRAQWvSDltEgxn3XDoQpdetw7bg=;
        b=j0Dyt3ldRueZCewn7eTXjNkCkgNDWubOGAZdZaBTvs2lgOZknMwgXTIl4BMB5Dr4Zg
         es3o2ueVCYCIf2iRAVny98dIcKTyeWXRjVfFlFpKIAUyZmgAjTAbPaH8/OifKVJN7BAP
         q9kxz6U3aQ4bzSYBfz45EWD2hvpbsRfqqHrEVRiSJDTChWv3fca8wU3JsnF0OrdpJhDb
         OyhAVVLHcnYgB/RvztMF3UlErFbE7Y3EyrbnpCmWMPPdonj3GWkhE6Smsrgnd1mNPbFS
         j7dtgxtXuDA8vG+ni1DFWfJTg3cgoMLloq7gE+mwbYUYnOKi552aTipoL8WPdsjd/LLo
         lSLA==
X-Gm-Message-State: AOAM531gQXGeRTEWOT9IdTpk9chWwtw7HY1p0C3AU0vQLum7fD1oW2sB
        1gctGUQDez8PxXMSYgdRlPw=
X-Google-Smtp-Source: ABdhPJzl+/Yfm34IakLL/o9t/S/HumPeC6qSszNbPmuOFWiiVFyQs+hhAtl6LCCGwZMRyHScubFQrQ==
X-Received: by 2002:a05:6a00:14c9:b0:4c7:f5db:5bd7 with SMTP id w9-20020a056a0014c900b004c7f5db5bd7mr15772616pfu.46.1643168558977;
        Tue, 25 Jan 2022 19:42:38 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id n2sm15670408pga.39.2022.01.25.19.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 19:42:38 -0800 (PST)
Message-ID: <e8a1ed56-ba04-45bf-8e89-3404ae1b3239@gmail.com>
Date:   Tue, 25 Jan 2022 19:42:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v7 14/16] net: dsa: qca8k: cache lo and hi for mdio
 write
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-15-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123013337.20945-15-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2022 5:33 PM, Ansuel Smith wrote:
>  From Documentation, we can cache lo and hi the same way we do with the
> page. This massively reduce the mdio write as 3/4 of the time as we only
> require to write the lo or hi part for a mdio write.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
