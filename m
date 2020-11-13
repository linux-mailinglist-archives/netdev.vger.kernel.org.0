Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221172B194F
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 11:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgKMKrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 05:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgKMKrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 05:47:13 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75053C0613D1;
        Fri, 13 Nov 2020 02:47:13 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id d142so7671657wmd.4;
        Fri, 13 Nov 2020 02:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=UnIKmcUVnQcfuz68wvpapsSCJSAR/8vfXGalpq+6JD0=;
        b=Gx66ynat6q3oOo6SBe/7s1wcRHaAt0iRT6Nb8ivtiyCVPeYQyVsi3CIpIK1YHAlCut
         E/N3RanbAR4Gs25KTQpNIu8nhK9YOgOOh56K4eFnni13iLCj1mm9aHYKJdae9+3s5AEb
         oOrQY/Ei4q8Ltre7WRHmxdEMQed9/fjebnK/y+nDyzPuRbRJPkFKK8MevrRv49n9W9bD
         xkp4O2dI8jvuULNMeYTCVxuX9vbfbHwn/70ktzXtfnd0sOs9GKGiF8nWSsdc040aDpM9
         5qlJ4tbLsw/FzbeZzY5mDQHEDU+xuYkOh/ebTb2d4o7LYCONFXoVtkx0OeviPneBv5yV
         B8Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=UnIKmcUVnQcfuz68wvpapsSCJSAR/8vfXGalpq+6JD0=;
        b=SZtOall52CVqLnSQb+C+1uCHIcACRBkKBPvtOBg8G+wIea86Pmgb6qRCn736ljbwUr
         k3OmJ29SSBU6eXnnU/NLPfixjPEU75MHZ8R5LiIx7u/KLhy4OPQSZJmWTbVfPD6k2KZ8
         e63kWfJY+jVANPhC7/CVKKOkNpl8taDtbJM3RrrqHeNysiE/WViBZRUz9togPTVmiHIb
         qOFixQQvzt+G6vn26gD2YIPW72LmFSQqwo/DynpohWPmwgR4fBl8ZezF0c4whIjZUfAM
         bwLU1pYsrZd1i+Vy7zmnT+yA1wTLMLHpdulEOFVRjibdBrWmsTvXs83bgUUOlN8hWkEk
         3WCg==
X-Gm-Message-State: AOAM531vnqr3HtiO/iSTM9CI5NVLm1UX+8xI3qDrRCV2hTN9Nq9DfBbv
        xxLgCIaFv14RaWi64hIuuC7IHsZcDzR6Iw==
X-Google-Smtp-Source: ABdhPJwmo5K+tviYqOpCRn5kx2lh0UvD5M9yE5r4zOHg9ZT8ALr9REkdAY3MF4fLJ7n/1eqc7W2VOw==
X-Received: by 2002:a1c:1f05:: with SMTP id f5mr1827474wmf.98.1605264432041;
        Fri, 13 Nov 2020 02:47:12 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:e113:5d8d:7b96:ca98? (p200300ea8f232800e1135d8d7b96ca98.dip0.t-ipconnect.de. [2003:ea:8f23:2800:e113:5d8d:7b96:ca98])
        by smtp.googlemail.com with ESMTPSA id i6sm9985711wma.42.2020.11.13.02.47.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 02:47:11 -0800 (PST)
Subject: Re: [PATCH v2 1/3] net: mac80211: use core API for updating TX/RX
 stats
To:     Lev Stipakov <lstipakov@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.ke, linux-kernel@vger.kernel.org
Cc:     Lev Stipakov <lev@openvpn.net>
References: <44c8b5ae-3630-9d98-1ab4-5f57bfe0886c@gmail.com>
 <20201113085804.115806-1-lev@openvpn.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <ecd9fb3f-ced5-2802-4d69-1d39bf27ef25@gmail.com>
Date:   Fri, 13 Nov 2020 11:44:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201113085804.115806-1-lev@openvpn.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 13.11.2020 um 09:58 schrieb Lev Stipakov:
> Commits
> 
>   d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add")
>   451b05f413d3f ("net: netdevice.h: sw_netstats_rx_add helper)
> 
> have added API to update net device per-cpu TX/RX stats.
> 
> Use core API instead of ieee80211_tx/rx_stats().
> 
> Signed-off-by: Lev Stipakov <lev@openvpn.net>
> ---
>  v2: also replace ieee80211_rx_stats() with dev_sw_netstats_rx_add()
> 
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
