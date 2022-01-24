Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D7949867B
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236241AbiAXRWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiAXRWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:22:02 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61474C06173B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:22:02 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ah7so23224872ejc.4
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9RQXkNd3SB/c6F61FmRnBwlyXUxWu+hArYNYaULhbQ0=;
        b=IZC/AnWiz0jAqwrOBMC/HsYQOrh9YRHdsJobAKRoVOogf0WVls2lchfcjPA+zJLHj/
         4c0LrFDc2YEtjYKlUPemWOHbGyN4SRD65lbc4VXAkA1VXZfdh+/jWHVcbNGQl+vhF/An
         8mlD+hDRKudiRna9dj35FgPpegA+pdMqw5FVlzNMYVy7BxJEsAVaUCNyA/zYQL0P9ae8
         wjWGlezGyuh5V8orCicqZMrZqvIB1RQ/BGVEGMNZFIvo7XrvdrC7QYUkh2H0EWN0+tQL
         N+6zbPrebvXcR5seGDYy1d8OZe+Kb8qACF37o6dXMDV0hme910zj7/+fkH70Ibr+wgXf
         lreg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9RQXkNd3SB/c6F61FmRnBwlyXUxWu+hArYNYaULhbQ0=;
        b=eR8B1I5sIlsKoaBlBeS0zC1k0PveD/1f/coiIJ+aZVUjrYmLt4tXzc+1HYKLmLUTXR
         Dk2elepmVtuDHFYwGACvIgM8p5WUKTWzvXEY97KkEcs53tG+8jPO2yTCFRJ7AJrvnvEh
         SeI6OEnbBh7ai9P6NkyT2eh3f4FOrfyeM8DEI/v3yaY5mypX6n389IQ65TaEwoI535Xd
         RZLARTQZhe5p123VethlUzu/C77Kixfml1scqTpMNb18aIDoXghlsqLnBN3ZsfqSN5t7
         wOJMysEwofxloDm7VcEZrfl/P9co/A77bssXUrQnCLwu3sFFNIZ5YxTP7lnOkX5PtXe7
         JN2A==
X-Gm-Message-State: AOAM532hOGp7/CNtRGB2bFyL899Hku5fZcxd/n1BLjS91Y1z9hGB43Rx
        o7cFlhPDd1N7qW+7D0ESsxI=
X-Google-Smtp-Source: ABdhPJxdnMs5I8znisa2q0HDhH6+Y/Kgk/tvuHHj0hgA7WQQhuw+13yOwVUFviUWEKMEgpSkqZxiww==
X-Received: by 2002:a17:907:6e03:: with SMTP id sd3mr8367309ejc.536.1643044920859;
        Mon, 24 Jan 2022 09:22:00 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id cf25sm3808285edb.63.2022.01.24.09.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 09:22:00 -0800 (PST)
Date:   Mon, 24 Jan 2022 19:21:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Message-ID: <20220124172158.tkbfstpwg2zp5kaq@skbuf>
References: <20220121020627.spli3diixw7uxurr@skbuf>
 <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
 <20220121185009.pfkh5kbejhj5o5cs@skbuf>
 <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
 <20220121224949.xb3ra3qohlvoldol@skbuf>
 <CAJq09z6aYKhjdXm_hpaKm1ZOXNopP5oD5MvwEmgRwwfZiR+7vg@mail.gmail.com>
 <20220124153147.agpxxune53crfawy@skbuf>
 <20220124084649.0918ba5c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124165535.tksp4aayeaww7mbf@skbuf>
 <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 09:01:20AM -0800, Florian Fainelli wrote:
> On 1/24/2022 8:55 AM, Vladimir Oltean wrote:
> > On Mon, Jan 24, 2022 at 08:46:49AM -0800, Jakub Kicinski wrote:
> > > I thought for drivers setting the legacy NETIF_F_IP*_CSUM feature
> > > it's driver's responsibility to validate the geometry of the packet
> > > will work with the parser the device has. Or at least I think that's
> > > what Tom was pushing for when he was cleaning up the checksumming last
> > > (and wrote the long comment on the subject in skbuff.h).
> > 
> > Sorry Jakub, I don't understand what you mean to say when applied to the
> > context discussed here?
> 
> I believe what Jakub meant to say is that if a DSA conduit device driver
> advertises any of the NETIF_F_IP*_CSUM feature bits, then the driver's
> transmit path has the responsibility of checking that the payload being
> transmitted has a chance of being checksummed properly by the hardware. The
> problem here is not so much the geometry itself (linear or not, number/size
> of fragments, etc.) as much as the placement of the L2/L3 headers usually.
> 
> DSA conduit network device drivers do not have the ability today to
> determine what type of DSA tagging is being applied onto the DSA master but
> they do know whether DSA tagging is in use or not which may be enough to be
> overly compatible.
> 
> It is not clear to me whether we can solve this generically within the DSA
> framework or even if this is desirable, but once we have identified a
> problematic association of DSA tagger and DSA conduit, we can always have
> the DSA conduit driver do something like:
> 
> if (netdev_uses_dsa(dev))
> 	skb_checksum_help()
> 
> or have a fix_features callback which does reject the enabling of
> NETIF_F_IP*_CSUM if netdev_uses_dsa() becomes true.

Yes, but as you point out, the DSA master driver doesn't know what
header/trailer format it's dealing with. We could use netdev_uses_dsa()
as a very rough approximation, and that might work when we know that the
particular Ethernet controller is used only in conjunction with a single
type of DSA switch [from the same vendor], but I think we're just
delaying the inevitable, which is to treat the case where an Ethernet
controller can be a DSA master for more than one switch type, and it
understands some protocols but not others.
Also, scattering "if (netdev_uses_dsa(dev)) skb_checksum_help()" in
DSA-unaware drivers (the common case) seems like the improper approach.
We might end up seeing this pattern quite a lot, so DSA-unaware drivers
won't be DSA-unaware any longer.
It's still possible I'm misunderstanding something...
