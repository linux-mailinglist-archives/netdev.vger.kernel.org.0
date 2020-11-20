Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA322BB9BD
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgKTXLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728559AbgKTXLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:11:19 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F89C0613CF;
        Fri, 20 Nov 2020 15:11:19 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id 131so9320214pfb.9;
        Fri, 20 Nov 2020 15:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UWPMH4F8zpYKMQ+iVwWJvlmgxu/1LnPnr3HnFQg/Y88=;
        b=OiOHYUgLaPXz88CxKOhR4d3ZFqH0WOaQDpA+KqZxYvwRPo+uT1j6TXzvSd1Wk1VMVd
         huzg4SXZYqZnkcGlSFveMgn5IcRIktiabykZLdux4TCJtNsAtSk0F/fH/eeJ4oQxco1t
         Ussp3YptQZfqMjiLQ3hYdU0YPBKiZsGxnhyfE84XT1WO20knxUt48hhrCNu0MeoDUPrb
         8h5I/RvyrczBjFazMLoZ2d+CQ4HmM+87kGUkTUL86ogd0heqRPwue4uSF2gG5sTeg2nY
         xxr5G2svkZHRS5rWea3Wzq5yQNVPUc/7/7UlyS43zkCWDGCsLpkQuc58N+ohaQGlHVmn
         +z6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UWPMH4F8zpYKMQ+iVwWJvlmgxu/1LnPnr3HnFQg/Y88=;
        b=SbdWDYIxtqi6zTv2mqp+D4cCv5Mo/OxImRIB3cG/apU6S9bNHe9T67XDkl8SEB4/Z3
         vmTmbFWN3fjojJm9JmVt37Re1WygE+z5RF/eE4M1D6aXswiaoM0Uz3HXG2fvl88I2WUE
         2viSGqUOnYppcQttzujHLimKYU4G/ZlVboSStbiGsh5CbcVIpUCOc9p+FUa+G/MnB9H5
         s0fIPKi+CSbyZbEvORT0Mh57qgDDt4ZTA1ydSeptJHrvzbsaFDpBO6wvd2+kj+9GPwxU
         GfPDTC9FySL2bW4uTa1u5m3gF1dLYDO6pOnaSfwJfNsRi3LzKsecMagjYpNl2ORb18u2
         NZgA==
X-Gm-Message-State: AOAM531ITaw1TQP0L9VyQjggS8UwyAjLKb5pOZWCBIqUT3zvS+B+Jhgy
        72DNQJRY/ctU7R/3ZEwv+bd42G0zNDfX4AOXsD8=
X-Google-Smtp-Source: ABdhPJx/noFFLOnUSlLmjGmIxaez52dyLTunVPd3zpn170oZGX3zK/9/zfNzI67dSiBhfp7QOaNh6+DT29tRWVw8rSI=
X-Received: by 2002:a62:170a:0:b029:196:5765:4abc with SMTP id
 10-20020a62170a0000b029019657654abcmr16122116pfx.4.1605913878966; Fri, 20 Nov
 2020 15:11:18 -0800 (PST)
MIME-Version: 1.0
References: <20201120054036.15199-1-ms@dev.tdt.de> <20201120054036.15199-3-ms@dev.tdt.de>
In-Reply-To: <20201120054036.15199-3-ms@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 20 Nov 2020 15:11:08 -0800
Message-ID: <CAJht_EONd3+S12upVPk2K3PWvzMLdE3BkzY_7c5gA493NHcGnA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/5] net/lapb: support netdev events
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Should we also handle the NETDEV_UP event here? In previous versions
of this patch series you seemed to want to establish the L2 connection
on device-up. But in this patch, you didn't handle NETDEV_UP.

Maybe on device-up, we need to check if the carrier is up, and if it
is, we do the same thing as we do on carrier-up.
