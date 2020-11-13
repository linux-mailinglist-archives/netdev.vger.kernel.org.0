Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DA32B1B14
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 13:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgKMMZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 07:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgKMMZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 07:25:37 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E4DC0613D1;
        Fri, 13 Nov 2020 04:25:37 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id n132so8565962qke.1;
        Fri, 13 Nov 2020 04:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=97rh3yhbNM4UgzDuGAdlpFKNlUvk+KXh3RaRY7uZ5+Q=;
        b=CNvNIUgqxKcV3WFJp7Zl/PYD6d2+QojBBasJfBXOVMA84vmmWc/HpkOr2Cum+BUEcu
         9udBIbrZDHp56elcAbVCb3N5ILztZpxWO/GiEuDtEzGCUbYxJMNBd5Mdny+lM0SOqqez
         qwRJ+FhKLhDcuRepny1GvKc8uy5BbSbmRrz7VFUsJMgToXb88f4V0vvz4RrgpxCl9x0r
         NqkF09KyGOrDwUtlpXbX2efV741EXPY8dDNFvbiiRYozFpYkulyLf+yGKq33puiZTVgg
         AnvPuutSOYlzz/G07DuHl45MPX/jIU0VpaIWoqD9Bwc9GtKxSoSzRRqDbxUKKvRgV/UH
         G2Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=97rh3yhbNM4UgzDuGAdlpFKNlUvk+KXh3RaRY7uZ5+Q=;
        b=WEBxHQJfgow/HNat+SW8ifXXGB5uB5xehtQzmTpx75URB0DFPxnERjtbW4opuFq/Ou
         9+NL7aoJwqPakUoTQ3CB0ViFmA55SzSiBw4G1IIUVgVct2xBJEf/bMVN+flukbUpjEIJ
         mc1RTalIHK0r7zD3SvUUe188XFMRAbYiS0WEW9zww13pio9wDsfvZ1TEzohCsyfHFMVB
         W7PlrzG/c4O07fNhYk2/RDELY2N4IBWpchmWoKQrzbru35L92g1KxOY/Yzn1k0px/YE2
         k8NjB38+jVPiO81f2xn8fl3qX8Se1mHk5zpOEE+sAawnqUSjvaFaOoMRsPGsqT/rFM1L
         wDLQ==
X-Gm-Message-State: AOAM533R5UROZYB886dmBCg7iqSmOxuC9YTIgRKDVrn29KPOrWlLI9C7
        Ke2Hm05NUXLaCTppJo8BIiw1LRRBlL8oZclaIlYJNJjragUH+CEAzKM=
X-Google-Smtp-Source: ABdhPJzi66xisG6ZsvScbYqK7rGS897YWiPLRygxVz/tX1xxsOD1sWx26guFF6LQoC4sIlwFSDQitLGlSgSEatafBi8=
X-Received: by 2002:a37:a481:: with SMTP id n123mr1661660qke.114.1605270336862;
 Fri, 13 Nov 2020 04:25:36 -0800 (PST)
MIME-Version: 1.0
References: <44c8b5ae-3630-9d98-1ab4-5f57bfe0886c@gmail.com>
 <20201113085804.115806-1-lev@openvpn.net> <53474f83c4185caf2e7237f023cf0456afcc55cc.camel@sipsolutions.net>
In-Reply-To: <53474f83c4185caf2e7237f023cf0456afcc55cc.camel@sipsolutions.net>
From:   Lev Stipakov <lstipakov@gmail.com>
Date:   Fri, 13 Nov 2020 14:25:25 +0200
Message-ID: <CAGyAFMUrNRAiDZuNa2QCJQ-JuQAUdDq3nOB17+M=wc2xNknqmQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] net: mac80211: use core API for updating TX/RX stats
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lev Stipakov <lev@openvpn.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> This looks like a 1/3 but I only ever saw this, not the others.

The rest are similar changes for openvswitch and xfrm subsystems, so
I've sent those to the list of maintainers I got from
scripts/get_maintainer.pl.

-- 
-Lev
