Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C913DC63B
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 16:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbhGaOIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 10:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbhGaOIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 10:08:11 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DFAC06175F
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 07:08:04 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id o7-20020a05600c5107b0290257f956e02dso4559771wms.1
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 07:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8JwCnrBQjsgBVXWNwAsHcfb+DAKs5JRaEidFNsPaOG0=;
        b=go1WxYaL+pIgLDgHEoJWKxbNje0zFUvaEcDJWszEGzYxan2L9Ik8RjFBVwEx+0kFEL
         7rPbO5e6UHSb67pSPtdOh4JQWCelQ/xNq55nl2Db4iGvGokc61WO/vemPKrPNBTYz2E5
         wnj+7ZmRVW7AuLFYlf828xskGTyLw3V2kbKG9H1xI2QZKy5DGHyX8Ux1brqoPhdksm2V
         cXQ/aa//Olp3E+6NFUKcynUGiJD3K4fFzgMBrH+ImEOX8s/4KZTbwyGkae39YtNKvd7K
         hayL74Ptpa+h2ICtwnuFnKQBaAdHXClS/DAqAGCIkrQ59Dh+5Cwzy/k+sUQihgVGq0m5
         DD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8JwCnrBQjsgBVXWNwAsHcfb+DAKs5JRaEidFNsPaOG0=;
        b=oFQFbrTS6895/rKUHnm2i/YFYEYG4Oy/hEsi21t0l9ypL+kM6Drk3or2nb6Y4XZWEK
         ujKaXbCYWo/JUb+iV2b0SHq4ILoo7t0jvJP5dCbzBg31ZU1iCcnC6RuaNjf4XhKl/+Qf
         YpGArhqrCM2lLlDVXAH3qGKJf7ZsXQK1dmIQ446pTR3mW6udsln84E++4uORoyXIUey1
         Z0qQHtIDBy9RYOmhVy6nxZ74pe88z8R2zmj5P0j+ftES+BK5YepBgp/8qSOKyTMwW8Aq
         nsfVsaqv0nyZWQCgH/e3Ku+HhK0swpfmdJk5LGFJoBNzwQFwUKsZKKsDQx3LWjDeuAFx
         M+Xw==
X-Gm-Message-State: AOAM532lc7EcOuKMR9bMg4ZBqC7MQQLjqM4fymcSSChR9CUDuchwuGMZ
        GFom6PkJ73xT4KNf69fI8ds=
X-Google-Smtp-Source: ABdhPJxPO9PGV0wQaIqqEPvDHXVJV8Y/POCx4A3SgXw8ulD2eTIRiehIcjcsX7kwpDHrkvKT2AGBUw==
X-Received: by 2002:a05:600c:ac4:: with SMTP id c4mr8391414wmr.10.1627740482641;
        Sat, 31 Jul 2021 07:08:02 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id h8sm4972845wmb.35.2021.07.31.07.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 07:08:02 -0700 (PDT)
Date:   Sat, 31 Jul 2021 17:08:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: drop paranoid checks in
 .get_tag_protocol()
Message-ID: <20210731140800.ahs6lyrcekbxsycn@skbuf>
References: <20210730225714.1857050-1-vladimir.oltean@nxp.com>
 <cc8e24d2-9fed-872f-4f0a-92a6892dfd5e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc8e24d2-9fed-872f-4f0a-92a6892dfd5e@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 08:08:43PM -0700, Florian Fainelli wrote:
> On 7/30/2021 3:57 PM, Vladimir Oltean wrote:
> > It is desirable to reduce the surface of DSA_TAG_PROTO_NONE as much as
> > we can, because we now have options for switches without hardware
> > support for DSA tagging, and the occurrence in the mt7530 driver is in
> > fact quite gratuitout and easy to remove. Since ds->ops->get_tag_protocol()
> > is only called for CPU ports, the checks for a CPU port in
> > mtk_get_tag_protocol() are redundant and can be removed.
> 
> The point of the check was in case the designated CPU port from device
> tree/platform data would not match what the Mediatek driver supports,
> similar to what b53 does in the same vein. I am fine with removing that
> check for mt7530 as it does not look like there is an use case where the CPU
> port is not actually MT7530_CPU_PORT.

So if mt7530 only supports port 6 as a CPU port, how is Qingfang testing
multiple CPU ports on it?
