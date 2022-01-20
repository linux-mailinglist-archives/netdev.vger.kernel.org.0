Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9626A495694
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 00:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347816AbiATXHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 18:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiATXHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 18:07:53 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFCBC061574;
        Thu, 20 Jan 2022 15:07:52 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id r132-20020a1c448a000000b0034e043aaac7so1323725wma.5;
        Thu, 20 Jan 2022 15:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vmFFOpp9KaiBejo0AXO2MZgkzOXxSKhiNPkSLBsJN50=;
        b=SpQsG4lnrcx8nKCVflpXwx6c0r2t5+cP/qeGYOa+gk2Xkxxe0Wnyn7bzGtotX09041
         UY1gi3zFrXk3OaI82V4irsnRmqjBGEvSNS/KOaepL/FZnuTgAQhBHk+uvDbfygByONTK
         Cft3MAbmwRsg8I+AotmA3IicTz1WGLfVGFFUmEXZ36QSn1uXAkEK7V7nqp3dqYyNebxv
         2SIMPBAAt+vDoF+sEB703JZEHxZHT6IPOVTU9sfdq2xz/kZgYB8AAm7T7E1j441omeJw
         ISQGmYOUv/0ys9vibJ8Pivs9RLoJdgKW3mBCjCsAPssDTL19oQ/M2BlsyRG6Rr4Lw9cK
         TZ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vmFFOpp9KaiBejo0AXO2MZgkzOXxSKhiNPkSLBsJN50=;
        b=lEV++PTrGPCLsmUtEoGfk+ELFuRzv6M+fAUNrat/AFUvNvIm6tincnsPxDHEOlrQ+z
         vmKjZrAEcxqmuy5KA3LS00rFmh8N4EXlQHAa6cIElgEEaU0O6ymqBgghleEnvYXMXK6Q
         REyblD/F53ByVa9s/mbrO8h/fx53hJAscdRn7YNhIqiaMij8ALZHj3gu0dAde/QpHLGJ
         0uui1MWAhHAHO8VObTHZbClOQZoRhdJ1h0Eqfj2eXe25HsV7mh2d3Tk2MnQB2iFyiRIy
         Lb42/Lc/hqFN5Jb1CKc4VmSQ9Whw/4pYeOlFe0S5/RRBDCBiKvX5jlFT96gDU265D22k
         +Z7Q==
X-Gm-Message-State: AOAM531H700FEBSO+5gCONKDkOS59HA6Q7MwnCSN5mW6usx22SbOR1VP
        nX2hMS0DL2My/+F6kIhyqTABxlqQg8NJItmk6I4=
X-Google-Smtp-Source: ABdhPJygGSsESap1qSSMLlTqwRf9pKUjrtmcPmWtBnTS8NoooVMJkJ8aGUZzIIIdQ9cc5mM1BaFStf20lFHYW3fpTgc=
X-Received: by 2002:adf:e7c2:: with SMTP id e2mr1238527wrn.207.1642720071086;
 Thu, 20 Jan 2022 15:07:51 -0800 (PST)
MIME-Version: 1.0
References: <20220120112115.448077-1-miquel.raynal@bootlin.com> <CAB_54W5_dALTBdvXSRMpiEJBFTqVkzewHJcBjgLn79=Ku6cR9A@mail.gmail.com>
In-Reply-To: <CAB_54W5_dALTBdvXSRMpiEJBFTqVkzewHJcBjgLn79=Ku6cR9A@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 20 Jan 2022 18:07:39 -0500
Message-ID: <CAB_54W7jpcauDsFPvoYvb=AEF_8U60jD4E3fjsk1PNn7vZpRJA@mail.gmail.com>
Subject: Re: [wpan-next v2 0/9] ieee802154: A bunch of fixes
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 20 Jan 2022 at 17:52, Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > In preparation to a wider series, here are a number of small and random
> > fixes across the subsystem.
> >
> > Changes in v2:
> > * Fixed the build error reported by a robot. It ended up being something
> >   which I fixed in a commit from a following series. I've now sorted
> >   this out and the patch now works on its own.
> >
>
> This patch series should be reviewed first and have all current
> detected fixes, it also should be tagged "wpan" (no need to fix that
> now). Then there is a following up series for a new feature which you
> like to tackle, maybe the "more generic symbol duration handling"? It
> should be based on this "fixes" patch series, Stefan will then get
> things sorted out to queue them right for upstream.
> Stefan, please correct me if I'm wrong.
>
> Also, please give me the weekend to review this patch series.

and please don't send other patch-series after this one isn't applied.
After it's applied, then send another patch series. Only one please,
then wait again for it to be applied... and so on.

- Alex
