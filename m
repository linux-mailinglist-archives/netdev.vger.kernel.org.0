Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43294487D5F
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 20:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbiAGT5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 14:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiAGT5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 14:57:22 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFCDC061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 11:57:22 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id s15so5991296pfk.6
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 11:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sf34ZwHCQIjrCE06P9c8pyJ/yb4QzwMo6kkRSe6E0zk=;
        b=XrdRZamG2PGefz1mv7LfwY+9Zv3KZctx+/CtLcfMzSjGZFE73T0sYu4XQCObOptfsk
         gZjuzprQleVCrb9rwuMKGSSyu0il/tVjGXkTRe165Qq8c4Xb4wogHjVCPrc+fAkB4ZeE
         YofsyqYTi6IBUnic3SKpa4peKLvUpTKAzvbnA6H5KTBT7QQbkF1Rxy1BaALobTRcgCaE
         fZ+Ba9UimF3c0M4k8jU91pPm9Fc7ZhGFeGVY/fTXU5hl1R5SODimJsQgQYYxnZM2C/if
         JaYcdkStEBtuaZeNcErKZUIP7mjiR2hlKiwdAq9EMSKOnDVpJ8HBd8mRoXfT9azAH+xC
         Lr9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sf34ZwHCQIjrCE06P9c8pyJ/yb4QzwMo6kkRSe6E0zk=;
        b=JD5SLzo9P7Tt3HUOYiZPhAzqroZ6PEUrHTIDplAUiOdg7sILdjbsChBU3SKYLyIqa3
         FdRK+1nkdvYXtMClEpBR2f56LD6E2ZxK/6/lNK9hxV938z6QEPsHfUAandWeAbbh/GSn
         cnGgwvkhQxrmuGngkzMfMyPUSgtynGKWPOqYwBNFoTHpvlKMNLTBDcDvULOK5uKmdy7H
         tPS/weuagFHB2UEZOHje294bORhUXEnqSuT+ZNMPpHVYmXTCmZS5K1/lbMJEpy7ya4EA
         hEpEO9Ud+ZTI6xCXDAOL+aKRjSEb+lIGm0eW2TsSJotXJkd8J44jcvu1r3QqteMHZYrW
         Zjrg==
X-Gm-Message-State: AOAM531NJzvpOd6OcIahKxxPdAuCHXApONaWJZjGCWt58/vZ+Xoyn2tn
        iuOpcOzW3XyWZhDOf9+H6Ug=
X-Google-Smtp-Source: ABdhPJyLA78OG0g8sRYkCjayE0YwiSQ+U5KKhKc7EK8XLfI7Bh7lJnAaCX2KDzSZ5yaaB/rKmrsKmw==
X-Received: by 2002:a63:87c6:: with SMTP id i189mr58885509pge.172.1641585442303;
        Fri, 07 Jan 2022 11:57:22 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j14sm6955555pfu.15.2022.01.07.11.57.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 11:57:21 -0800 (PST)
Subject: Re: [RFC PATCH net-next 2/2] net: dsa: remove lockdep class for DSA
 master address list
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
References: <20220107184842.550334-1-vladimir.oltean@nxp.com>
 <20220107184842.550334-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <acf49d7b-c502-5b78-dcca-82878e1c4f15@gmail.com>
Date:   Fri, 7 Jan 2022 11:57:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220107184842.550334-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/22 10:48 AM, Vladimir Oltean wrote:
> Since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA
> master to get rid of lockdep warnings"), suggested by Cong Wang, the
> DSA interfaces and their master have different dev->nested_level, which
> makes netif_addr_lock() stop complaining about potentially recursive
> locking on the same lock class.
> 
> So we no longer need DSA masters to have their own lockdep class.
> 
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
