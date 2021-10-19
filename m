Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B078433FA2
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 22:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbhJSULm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 16:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhJSULl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 16:11:41 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED257C061746
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 13:09:27 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 5so16705969edw.7
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 13:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=MCiMjPMHcTTkBhYtg1/GE2/aA0h4R9lMKuiobLGMcvk=;
        b=IXVNzjzgt9Cu8nsyWui0FUBb/Ma+YCd3Eb9xwOIf4Gkpz7r69J5lUvesLJZxaB5pzo
         SW8FNslOqnIKM9TJY8l8Ck7Uk8G0MrDfzV77y43oRF001fr+lsrGIkERbR79hNVk6MC9
         agZcw9IiiDFwSth2NONaz6ihl4GiaVwJhsnybh9y+0hHZhxDruhO+lnXbrgII2gkWx0t
         MmEeqfLuZO6sCMSaidMk2FJL0OyaPKYF6n7mEmTk+ssQ0rk+g+36WimkjlsJDRx00z+/
         0fOhRrOwbhIB//MR7NjWJ7wfFE4JultLOfXs4Ktk0O/eNiq07wlmFChWZKBy2LVcNRDl
         O+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=MCiMjPMHcTTkBhYtg1/GE2/aA0h4R9lMKuiobLGMcvk=;
        b=tOO+Ax4CRoH9J5pguAdw2vdGe2/BH/K53DxjRd4dMQjKWnWeTas1EBXE7qpapjmu9e
         dDSsySw/o3ziDNzAOThksDMWWggIQCv+SwWeWFAP77jSUqzYMh3YnxqUKIb4l6S3RGV2
         UxMkv3P0VKkNJom4VPJXV27z5izFMbMJ4a4ebmjNFnhHur5Pn5OXFwqhh8bL3PXlo+50
         5JctmmKK9CuDh+9Moc1+wht7hEJ4/52UfHVJEBj6eUh+ekpL3+uINYJqpNnGSsyVJx7R
         3vKhHOuKd4CzmVnG6opCRcIYEkPR8YcTKOv5jRovjmrEezrBGBnP0kwNW6ExkVZWYayT
         s/wg==
X-Gm-Message-State: AOAM532X+q24NfGybpbqS24cvVT6yrJ63DnF3FjPwXEMkvq9Zkc0mih/
        ks9vsSgT4RjdZoRUFbUAJOBKdzie/E+C05/0Z1p0lg==
X-Google-Smtp-Source: ABdhPJxDSiEX19+RLkwQtRN0AxR/sJy51+aS4R40JWYE6JdNnyA1Due3diavnk2XvRGxCqS4qO11AzFg3xkXwLViG7g=
X-Received: by 2002:a17:907:75e4:: with SMTP id jz4mr39619542ejc.106.1634674166347;
 Tue, 19 Oct 2021 13:09:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211018183709.124744-1-erik@kryo.se> <20211019191806.csewm7p26x3imk25@gmail.com>
In-Reply-To: <20211019191806.csewm7p26x3imk25@gmail.com>
From:   Erik Ekman <erik@kryo.se>
Date:   Tue, 19 Oct 2021 22:09:15 +0200
Message-ID: <CAGgu=sDimxN7=mW+JeTRTxDLUCq875DnaAFwx_SkfJwUgO_fdA@mail.gmail.com>
Subject: Re: [PATCH] sfc: Export fibre-specific link modes for 1/10G
To:     Erik Ekman <erik@kryo.se>, Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 at 21:18, Martin Habets <habetsm.xilinx@gmail.com> wrote:
>
> On Mon, Oct 18, 2021 at 08:37:08PM +0200, Erik Ekman wrote:
> > These modes were added to ethtool.h in 5711a98221443 ("net: ethtool: add support
> > for 1000BaseX and missing 10G link modes") back in 2016.
> >
> > Only setting CR mode for 10G, similar to how 25/40/50/100G modes are set up.
> >
> > Tested using SFN5122F-R7 (with 2 SFP+ ports) and a 1000BASE-BX10 SFP module.
> > Before:
> >
> > $ ethtool ext
> > Settings for ext:
> >       Supported ports: [ FIBRE ]
> >       Supported link modes:   1000baseT/Full
> >                               10000baseT/Full
> >       Supported pause frame use: Symmetric Receive-only
> >       Supports auto-negotiation: No
> >       Supported FEC modes: Not reported
> >       Advertised link modes:  Not reported
> >       Advertised pause frame use: No
> >       Advertised auto-negotiation: No
> >       Advertised FEC modes: Not reported
> >       Link partner advertised link modes:  Not reported
> >       Link partner advertised pause frame use: No
> >       Link partner advertised auto-negotiation: No
> >       Link partner advertised FEC modes: Not reported
> >       Speed: 1000Mb/s
> >       Duplex: Full
> >       Auto-negotiation: off
> >       Port: FIBRE
> >       PHYAD: 255
> >       Transceiver: internal
> >         Current message level: 0x000020f7 (8439)
> >                                drv probe link ifdown ifup rx_err tx_err hw
> >       Link detected: yes
> >
> > After:
> >
> > $ ethtool ext
> > Settings for ext:
> >       Supported ports: [ FIBRE ]
> >       Supported link modes:   1000baseX/Full
> >                               10000baseCR/Full
> >       Supported pause frame use: Symmetric Receive-only
> >       Supports auto-negotiation: No
> >       Supported FEC modes: Not reported
> >       Advertised link modes:  Not reported
> >       Advertised pause frame use: No
> >       Advertised auto-negotiation: No
> >       Advertised FEC modes: Not reported
> >       Link partner advertised link modes:  Not reported
> >       Link partner advertised pause frame use: No
> >       Link partner advertised auto-negotiation: No
> >       Link partner advertised FEC modes: Not reported
> >       Speed: 1000Mb/s
> >       Duplex: Full
> >       Auto-negotiation: off
> >       Port: FIBRE
> >       PHYAD: 255
> >       Transceiver: internal
> >       Supports Wake-on: g
> >       Wake-on: d
> >         Current message level: 0x000020f7 (8439)
> >                                drv probe link ifdown ifup rx_err tx_err hw
> >       Link detected: yes
> >
> > Signed-off-by: Erik Ekman <erik@kryo.se>
>
> Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
>

I will send a v2 patch with more modes marked supported.

/Erik
