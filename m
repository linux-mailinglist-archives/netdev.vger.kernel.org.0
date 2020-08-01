Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F81C235456
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 22:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgHAUuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 16:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgHAUuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 16:50:03 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664B8C06174A;
        Sat,  1 Aug 2020 13:50:03 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z188so8319375pfc.6;
        Sat, 01 Aug 2020 13:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hWO5AFP/Ra3rZ/6h9TxrrYwgTQG4HXWe23lIQLTKVBg=;
        b=SZ2vapNnkjIGtLf0LHvNLqdchp5kSLvoJIl4890zcd9GkujJBdYCqZFTN8x4ovjTVr
         lrhSayZCnqcx771D8+vgYW+iON18wzNMdic43q/hqwuD2XXmntpdynvzplKxFk7CUYxO
         gnu0pWRkX7yr0CBkpANz2R4o0XszHwxTOzArZWhoyWJQBBsNsgxDldl9fTmLMH+fAOjD
         Pn0FfQKJVIBNLKUiILbSWuPI5+G3OLg8/Mjxaefjz5Kquex4QBJhzz92S5phVK6EI9ZJ
         0tpo9rxqDTjEoDbd+7WYTb775pH2ae8odbrZiP7a4GWrHVPX5rDdzJdqMQUFawGu2CSt
         zEVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hWO5AFP/Ra3rZ/6h9TxrrYwgTQG4HXWe23lIQLTKVBg=;
        b=ZZMzC1Bxr+IuCIhaf1FjH7aeE2uqC1kQvMWYPJSRbmpvr9c+Sc0xcDXy77en0bZNcr
         hQws7SimAWsNAhw49nrgdRN7efXStOV2vUCoem2YbCGgBO7fP2TNhOTRoiEerImusIfX
         itPGvvYMPGPtt2Y0/3lA1u1GvEGX8SoKMzH0DiPz+RZkRtWv5LjE0G1PgR1pH5ua+1t5
         /RM7SoGTCvKv1NlLwYTdsbSHmRy0dhTwHv9z0WtCs9gKL+en4SQ91VDYNHURSEu5mTrw
         nNT84LvtpBNrcbi2Xeo9tlVF1mIp1uZmslHbZhkYkPBZjRwn7pZ3rHpygX5h96ReKL8l
         EKdg==
X-Gm-Message-State: AOAM530/+RhQ+yzGM4aKUvGuyf6BgwrbU9fP5yjOoG5OGTN9ObTBX+Uk
        e9Mvr/RFA63Di7/i65urNgBg1fTq
X-Google-Smtp-Source: ABdhPJxjSG2BiTp3nwtBQIIrkks9sOctNkSbUPmCwl9Ivbx4zsH9G9a9xw5k26yiST51q2PGtE5OyA==
X-Received: by 2002:a63:4450:: with SMTP id t16mr8999109pgk.3.1596315002577;
        Sat, 01 Aug 2020 13:50:02 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k8sm16022924pfu.68.2020.08.01.13.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Aug 2020 13:50:01 -0700 (PDT)
Subject: Re: [PATCH net-next v3 2/2] net: dsa: qca8k: Add 802.1q VLAN support
To:     Jonathan McDowell <noodles@earth.li>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200721171624.GK23489@earth.li>
 <ec320e8e5a9691b85ee79f6ef03f1b0b6a562655.1596301468.git.noodles@earth.li>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8f57b796-d0a9-2a09-0e2b-dca457dc3c06@gmail.com>
Date:   Sat, 1 Aug 2020 13:50:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ec320e8e5a9691b85ee79f6ef03f1b0b6a562655.1596301468.git.noodles@earth.li>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/1/2020 10:06 AM, Jonathan McDowell wrote:
> This adds full 802.1q VLAN support to the qca8k, allowing the use of
> vlan_filtering and more complicated bridging setups than allowed by
> basic port VLAN support.
> 
> Tested with a number of untagged ports with separate VLANs and then a
> trunk port with all the VLANs tagged on it.
> 
> v3:
> - Pull QCA8K_PORT_VID_DEF changes into separate cleanup patch
> - Reverse Christmas tree notation for variable definitions
> - Use untagged instead of tagged for consistency
> v2:
> - Return sensible errnos on failure rather than -1 (rmk)
> - Style cleanups based on Florian's feedback
> - Silently allow VLAN 0 as device correctly treats this as no tag
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
