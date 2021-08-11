Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6303E92A2
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhHKN3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbhHKN3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 09:29:03 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF7BC061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:28:39 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id m18so4614805ljo.1
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IwDGEQJ4i/ev0FP0ADQz0gJW5FdFYa6sUoC4M9Njma8=;
        b=hx/2Qwz6R8tgEzzr8OE2IFn3Q6SxMODj8dBUrr+J6xoooIk+ArDpPKfrY7YUTuk3Uu
         a6wlC6ILq9xHsZBhU6PXsFJWVIMhardTWqMGMHLhZOnCl6lHcvdQIdGeGBBJyA3q/1rP
         zsFtkyvSJ4HaNSKYorF1D3ud60pH3etyNxRwAqOMNuwhgNY3HkSbpsev/I9tYi1R6LbS
         Rfo7p4KF5yfiVU8zCEK+z1MP9j4LbMEiqp/7Oy5mABuz8gDwWNT39lS7t8+Dt9C9LXbr
         IpGviAL8a75Sjg2LCz8wBZQXqYsLPIWH2ocShEEI4HIH1iiR+HWUtQK0wtWxjGMtdtQN
         mi6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IwDGEQJ4i/ev0FP0ADQz0gJW5FdFYa6sUoC4M9Njma8=;
        b=ClBBSk5fuG7v6G5Tx7wjjIXuLTFwsSAfmDO0a4nJrjHDRD1RNfLS/VkCGkqKbtOI+2
         bCEBhq+lv47uqubGk79Ouz0FzCcMyouvjixN8yRpiimQb0Odx2He7nczAApNp1dx60Rk
         RVPEtOsIIdy+3H6hkmj9FE9NcPH6Ipn3hNrWWGUghAsBJixy7iZ2IPWOBXejlRVCUa92
         gpb/aSN4z+lF81fo9/rmdmm/UQpY7UTA5iLSeIMs19YlM6qbqC4VBm8PoHy41NhsIWak
         bIPJEeJsLQb1Btt8n6INXPrXeQmSqZbDcQ7GbkT3jn+fDa5Bpl1jsxt+xVkofQQutUBl
         EQzA==
X-Gm-Message-State: AOAM531295TLs386Nr7SrqrTNUJ0MxmjsDgP0sPBNYA3oSSd4L/L4wXl
        ltIxaIn2UnlXCnYpnfzVxvo+yr5/RD4CKD0FmiBGBQ==
X-Google-Smtp-Source: ABdhPJxMZrsbzeyBShszez19dlBX2iXRHQuT5z949B5HbVdF8UK64014taCHK15qQcWlJvISK1rpAE2enJaaG4JIbcI=
X-Received: by 2002:a2e:9a4b:: with SMTP id k11mr12857498ljj.368.1628688518077;
 Wed, 11 Aug 2021 06:28:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210809115722.351383-1-vladimir.oltean@nxp.com> <20210809115722.351383-5-vladimir.oltean@nxp.com>
In-Reply-To: <20210809115722.351383-5-vladimir.oltean@nxp.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 11 Aug 2021 15:28:27 +0200
Message-ID: <CACRpkdY2M8MoXBRX628kyuB3eR5YXJJEir4AiPYybSdVd7Pf4A@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 4/4] net: dsa: create a helper for locating
 EtherType DSA headers on TX
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 9, 2021 at 1:57 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> Create a similar helper for locating the offset to the DSA header
> relative to skb->data, and make the existing EtherType header taggers to
> use it.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
