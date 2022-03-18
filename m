Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18904DE37A
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241119AbiCRVZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbiCRVZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:25:02 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB39612CC1E;
        Fri, 18 Mar 2022 14:23:43 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id s11so10491646pfu.13;
        Fri, 18 Mar 2022 14:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uxURDRvkvhdqX8HS2lAZx56DlMAgFYWcg7rrxZ/NZrc=;
        b=bQQgl0cVWzU5zdVTIXs1dEcY6gpe4gnj+BqenV1ft0GDZISKQITzf07O12y6ld3hFT
         MjL5qjNigxsVkRV94FU3OSiwIJfFQfREYzbMmJ45/IBAfdH3V2QJDhAvROzGY8qUbfHZ
         ypMOMJUIv2UMEVhr8XXs0WTphGHsKy9zz69ukCk/iTBWb99RUCu7mPR8L/+L0sxWxfha
         jUCqFcbcYQ9ksckBoKb3rK3fZcU2zc6b8tvnh3HNEfWngleibo1+Zv79M6LxuDoS+lbr
         d/xxGHzJjVqWsE5fTqIOxiGaL+spdqXDoDtS000p5ypx31wchenoQ4I7beCNCy51qgMV
         0vOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uxURDRvkvhdqX8HS2lAZx56DlMAgFYWcg7rrxZ/NZrc=;
        b=kTiRXNhpd8pnlYLk8jRBwit4kAFvNhyiiiCHu98U7OfNXrJr81jKXnhe2KeFDoqSp6
         rc7iWVPCWQ/T2BMociJTFLzZLg2XfAKqTEZ2AE1aY/Le2Gj5zr41lMZOl7WUL9+WhywA
         iSdA3w5bIMwZ/KxFswKcFC8u0LZdguGXFHI9hlCq3aAFLY0iVVjWqNxMfIMi7ntNe9M3
         fQ6clh6UGOsQ6Vi0XE0VBRjS0FDkHiwyeO9Rr6dRptsBawzgxTMtxNV5MU1CPC8vZFuo
         I5Ap9a0kuOvfD5ilTzYOeGgq7w9X81B+FV6uuO9D8DNAxPAAXPjMbTHdvc725//NKA0m
         PZZQ==
X-Gm-Message-State: AOAM533n0zeoODZkr9U4wlZoDPfeHWMCADGexaBJbK3446s4SHK7G0ji
        Lw3KK2BPEK5IAHecwa8vby5EPIVHd+g=
X-Google-Smtp-Source: ABdhPJwBHUErqOo+73P5Qlyzd3cKcVCcWGaz0NcxokrHLF7q24/63u/XHs/4hfUUm/eut1xuC7kJ4Q==
X-Received: by 2002:a65:6746:0:b0:377:16e2:33a2 with SMTP id c6-20020a656746000000b0037716e233a2mr9492504pgu.47.1647638623034;
        Fri, 18 Mar 2022 14:23:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pf15-20020a17090b1d8f00b001bf5d59a8fdsm13465413pjb.2.2022.03.18.14.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 14:23:42 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Ensure STU support in
 VLAN MSTI callback
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Marek Behun <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220318201321.4010543-1-tobias@waldekranz.com>
 <20220318201321.4010543-3-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <720472a1-9ea5-853d-7f7e-9d4a39e33817@gmail.com>
Date:   Fri, 18 Mar 2022 14:23:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220318201321.4010543-3-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/22 1:13 PM, Tobias Waldekranz wrote:
> In the same way that we check for STU support in the MST state
> callback, we should also verify it before trying to change a VLANs
> MSTI membership.
> 
> Fixes: acaf4d2e36b3 ("net: dsa: mv88e6xxx: MST Offloading")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
