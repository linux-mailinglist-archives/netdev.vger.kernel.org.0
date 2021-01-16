Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DF82F89F4
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 01:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbhAPAcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 19:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbhAPAb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 19:31:59 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80530C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 16:31:19 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id dj23so8877481edb.13
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 16:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=r6nq8+TQ7idAH4fEuNNsYAdF0PbqKKcc8L4hMnbveVQ=;
        b=rYWCwu2KHr+gV0OmU6GHj/isTO0odV8yPC/1Ll5OuKJsEyMas3UJycx4eIgfd4c6K3
         LJwCFaNhtrtjAnLoUs4eABBT0EmZErfNZN3A/EyFAtVoUBURNBpRTDc4Mdi4tA+W5UYX
         IPXG2JGKwC60x/EX2axY/yQy2UrFKETFYjcWV1bQXdhLlt4gwekxFzWmYCYBH9m8O4St
         y/6QKG0r6hoNIT1x6ztD0ny22IOl9Smp4nYaytn/IX2+zmSaxhmnXeQ+ZV6cIVNYK3O2
         9wai+rA22iDjL2EJ09RwtfOz9y3xkTIVyWB8r+l3dmx+j/r8JFN+IZy1sZ9hNME1aMvF
         oXvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=r6nq8+TQ7idAH4fEuNNsYAdF0PbqKKcc8L4hMnbveVQ=;
        b=ICpZthAYU6eLUWT2NI999pgRbBg//b3VQiqIkbK9VNndBsV8XqlRIUcPP2KjDR84Tr
         al+PNdl4ccsl6/b8yiupg7SXIoVjZDCEzJJ9f0gR+fsZYlDAlGegEXt9F21pfSBxzcvx
         fzTE48n5fIWudmo4jYkN6ori1ET0C2cIq9k3SGD5ywDZGmGOUO50tg7vyp2rDHg6wNvl
         19j29PNXm5USmeq+5oVwviiS/tAvO++SbOX2xsZGh5PRVccL85TlkwisMArejJH+D0uO
         3JnRSQCRQHO9Iv2kNzWoFuydb1d6pSocf+DoNB4pW5Uvwye/Te70ujMmvcx1RCoWMUdC
         8BDQ==
X-Gm-Message-State: AOAM532GwxyrbJ8yy6CeSUKW89Yg1r1KZ8CW4cME1Uw3exH/ET451kPS
        /amy+4o8gt0lAXuJwOOSHWU=
X-Google-Smtp-Source: ABdhPJxppFWyFsyl7JwbTqJWFAT1sKJJ8vICKBF61WGvTxhQoXaNVSkukGlodfiGf9m/jKs7lyxV7g==
X-Received: by 2002:aa7:cb12:: with SMTP id s18mr11744020edt.125.1610757078260;
        Fri, 15 Jan 2021 16:31:18 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id e19sm5484125edr.61.2021.01.15.16.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 16:31:17 -0800 (PST)
Date:   Sat, 16 Jan 2021 02:31:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v16 2/6] net: phy: Add 5GBASER interface mode
Message-ID: <20210116003116.4iajyx4i3in3fsut@skbuf>
References: <20210114043331.4572-1-kabel@kernel.org>
 <20210114043331.4572-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210114043331.4572-3-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 05:33:27AM +0100, Marek Behún wrote:
> From: Pavana Sharma <pavana.sharma@digi.com>
> 
> Add 5GBASE-R phy interface mode
> 
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---

This patch now conflicts with commit b1ae3587d16a ("net: phy: Add 100
base-x mode"). Could you resend and also carry over my review tags from
the previous version?
https://patchwork.kernel.org/project/netdevbpf/patch/20210112195405.12890-5-kabel@kernel.org/
