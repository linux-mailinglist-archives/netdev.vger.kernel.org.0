Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C4520F6B6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730836AbgF3OHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729341AbgF3OHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:07:17 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B84CC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 07:07:17 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id f5so6845453ljj.10
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 07:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:cc:subject:from:to:date:message-id
         :in-reply-to;
        bh=VkFSa0Hx6McRxiDsvWegC7LNRphnK9bu5b8QB4H6uKA=;
        b=V8/N8HEiMXoCSAOmm75vGg21vieEl+Q0qwC2zgNMUylD31LurkJo33merXcZQ702Hy
         wunnsUcRnl8HuocFENPjFC3DnbX6FKgAvJ300iUV0QT4uQvNHWPUsTX+RcNDvAGoE8P+
         /eGBkj8AI9sWcX58WFM0+rHUpHd6DMt4hHvHI6/oZBnTixaSmSFN/wQMfboUrVZ8PE6N
         9g+HoJNuZACAezU3LSheV/EljZvxkfXDiuY80khzxwRfJIiOKNjc6dPBJeDtmRpbOY3F
         +jg+gZOcadmfMHg3MNsqHwSJ9u6q799j5SGEwyNbtlc8+J0z8FM9JuIibEVPvZRyavWU
         1tkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:cc:subject:from:to
         :date:message-id:in-reply-to;
        bh=VkFSa0Hx6McRxiDsvWegC7LNRphnK9bu5b8QB4H6uKA=;
        b=sganxyezkG5DrkUaDnbZNAUMzFOn3Ib+z//3j2pUgUGQcVn6FBvT9FW8C1RvZL8TmI
         I8c0gLlU0daZPXoKenaLNsjOmMza08A9QpqpUNRnKECkYlGxzFFq0xra/VT8w6OV6LCt
         RtAU+Tq8W+vztcdJ0tkwtQgPBxaCmCoWjjg9wjvNEf32E/b1Qj4IEJ2iJPZQiiaIroLy
         ua31WI3F9thju/ls6lcFC/lBSeUrTgHgpfB5Y6CQlHYCdT09SzzTu1tCj7bDiGd/OWQU
         GxdJbXpemVM+03JeZokJV8x4WIEXwP4hF+48xLOtGkIoZu+9KqmqaRD2PySUbgUFqxcL
         eNlQ==
X-Gm-Message-State: AOAM530lNK9HCf8xwv1lRTjLe1FZZU+USIX1lUD8XqWllsVZx59hhFfF
        n61BTNnb9mvJoU0anPG45WW84npwh9g=
X-Google-Smtp-Source: ABdhPJwx+ggJQrdkcp71Ibd5M0djtSGPf1tKJXfLVJ3y6pVRM0GchpE0eO9BgDfS5GWqnBv2WOcWyQ==
X-Received: by 2002:a2e:b5ab:: with SMTP id f11mr10532555ljn.438.1593526035357;
        Tue, 30 Jun 2020 07:07:15 -0700 (PDT)
Received: from localhost (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v20sm847212lfe.46.2020.06.30.07.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 07:07:14 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next] net: ethernet: fec: prevent tx
 starvation under high rx load
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Andy Duan" <fugang.duan@nxp.com>,
        "David Miller" <davem@davemloft.net>
Date:   Tue, 30 Jun 2020 15:45:51 +0200
Message-Id: <C3UHDOU16UJF.1HSCO9KJ9CIRG@wkz-x280>
In-Reply-To: <AM6PR0402MB36074675DB9DBCD9788DCE9BFF6F0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue Jun 30, 2020 at 11:47 AM CEST, Andy Duan wrote:
> Tobias, sorry, I am not running the net tree, I run the linux-imx tree:
> https://source.codeaurora.org/external/imx/linux-imx/refs/heads
> branch=EF=BC=9Aimx_5.4.24_2.1.0
> But the data follow is the same as net tree.

I've now built the same kernel. On this one the issue does not occur,
consistent throughput of ~940Mbps just like you're seeing.

Now moving to mainline 5.4 to rule out any NXP changes first, then
start bisecting.
