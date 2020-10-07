Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DD528679E
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 20:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgJGSo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 14:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgJGSoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 14:44:21 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48458C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 11:44:21 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id n18so3462450wrs.5
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 11:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lyeewHuLtb/TNYUf/qIPKMASSMZ2oBiQRF7cyiqltog=;
        b=ZU6C7BnHYbYg26t7OIDdajBNU9oFlh0LOsKlMdx+XzX7g3LS4BlC87xZI1h7jyBb1H
         INGxpKl+upb1ubBi/YJ1rMsTyXOwniXVW9+B3Fm14UiPtXxRcNnmUKqrz8KXH/xsajag
         oWIvqCuI6nLYAbywu1aP15RCrhj7GsX67UO06pBcXpOkaC9Gtw/P1r6W/wSMufzwCBp4
         2x5YwJye4xjy86NMXXYXBMzXPfenOD0XT9uqJyj0BY/m4TK+iXC5VC5Qdqh2cUj3MMXW
         TijwcS4ncLkfCm1YCySLxfdRLok+CgouD5r3x+PyRILVzu0p/V3SwTpn6IJ+CJc1JTmW
         y2QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=lyeewHuLtb/TNYUf/qIPKMASSMZ2oBiQRF7cyiqltog=;
        b=KNRsNRpTwiryyfw5AFKxDGME4C9UlxdR4W0PjfPGJaaC2/H8k/urfOuy8i10eXhBCN
         I3MH/0OO3FuvZiSHSPBQGXKU1+TN3UAwk/hfh8CddH460evcYyqMB/z6QsiRqWstB1oU
         TQxjOr2TFbNKitHmbwvqy8sjECwT23yHfFy7bjjRc6RmMBb91GfkLMyAA9DR/KOQvmTX
         mf/Bm3igwapawZiZezNOKdOfpi+OZ/IPP5hOe7AayGTCNIt5lNCsWhKYpNfO+RjSCMat
         1CX9+sd/oqL1cplzHHvP3cKdi0Q8dBMj0+Vkxzc5wt4NafQ8i89N2fzVkYKNnIfCnL9I
         SDQw==
X-Gm-Message-State: AOAM533Wc9u1C2KdDPYl0eteMN12zo1hd7gVb61zAdsLyhxzarX0FzAk
        7aXSTbJSWDsCq1aEUyRyMoz4qbxjtTUh4Q==
X-Google-Smtp-Source: ABdhPJyzSOczl+3iHi5OXzv3vbGizvO99vynLxl5NusJ+8hur1DdIaUlNix/VE68JMW6AeuV0cq97Q==
X-Received: by 2002:adf:8302:: with SMTP id 2mr2174906wrd.231.1602096259484;
        Wed, 07 Oct 2020 11:44:19 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:199a:22f:7140:b143? ([2a01:e0a:410:bb00:199a:22f:7140:b143])
        by smtp.gmail.com with ESMTPSA id h76sm3737052wme.10.2020.10.07.11.44.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 11:44:18 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 10/19] xfrm: interface: support IP6IP6 and IP6IP tunnels
 processing with .cb_handler
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        network dev <netdev@vger.kernel.org>
References: <20200730054130.16923-1-steffen.klassert@secunet.com>
 <20200730054130.16923-11-steffen.klassert@secunet.com>
 <c79acf02-f6a9-8833-fca4-94f990c1f1f3@6wind.com>
 <CADvbK_c6gbV-F9Lv6aiT6JbGGJD96ExWxTj_SWerJsvwvzOoXQ@mail.gmail.com>
 <621ebebc-c73d-b707-3faf-c315e45cf4a4@6wind.com>
 <2df6aeeb-bad8-e148-d5de-d7a30207cd4c@6wind.com>
 <CADvbK_cmcLqOyuDjBTizj7x-nUf6HoWu1pO8S9XL1Dc63=ZWwA@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <a873114a-61fb-017d-f1b1-ed279c989ea3@6wind.com>
Date:   Wed, 7 Oct 2020 20:44:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CADvbK_cmcLqOyuDjBTizj7x-nUf6HoWu1pO8S9XL1Dc63=ZWwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 07/10/2020 à 18:26, Xin Long a écrit :
> On Wed, Oct 7, 2020 at 11:40 PM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
[snip]
>> Do you think that you will have time to send the patch before the release (v5.9)
>> goes out?
> Sure, I will do it tomorrow.
> 
Thanks!
