Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B275D530D
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 00:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfJLW2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 18:28:51 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45271 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfJLW2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 18:28:50 -0400
Received: by mail-pf1-f196.google.com with SMTP id y72so8165842pfb.12
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 15:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=VUz1ok8zlsDkN/e0yUa6daO7kk73qbRZHIQaMPMh0hE=;
        b=AQfsKzX8geJNl0V3ZkcnS+mCYrX046vbVPp5c/4JMWzngZzjPlE/E/2X3QKfNAnSXk
         Fuoc5/xF4NrL74uRzOlZGdwWb9UyxhC59QTI2L8Zf95OQ2Ir+xU3FswM6h9+ujqm833K
         654zPKRCmlej1yad8T2aUILu4uXNSLl/+wN2DpPtHcwCbaEqwNJckphA/x4zRWtPmd10
         wPu4hUpYyWGEupt3Fie/Vv/cBfWe9guYiCXuSHd9MYlrpcYeEsMQmm54uxclgY9YcEWW
         eSzKYYFVm0K33SnlSH6tKosm7BvgdJEszz6I3RFpDyFXeSXZf6oRKE8rDeQQJQInk+2n
         We1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=VUz1ok8zlsDkN/e0yUa6daO7kk73qbRZHIQaMPMh0hE=;
        b=kpPBBxWz2QUszm+aiNBIHA7jWbznQDJD9/HOJU436bjPIIlI8nSFW+maowI9V1fxbo
         AZAjb7CsTZpIjtYUhNlAAT5CYYM3l9rgIrwxV2K6Ny78oQsg41mtgwP2nrGUZiDCr0Aj
         U2j6II2itqLpn5YOcjtO+jnJzwf4/a8TWDFLF9ig3hdpxwclA9OTiv4pWVqnRLGBenMv
         2nJl5G97V4qL1KE6JBuvHDi0KqhRoriqn8xEwKNBpKYs+7+0J2Z4pYz9DZMyiHQOynjS
         p7RXEpzuEoi+p5cckRHyU6+1jaACfi1BfW7G8G83n6R40+74L+x3d8zrhFRMG3JmGMwa
         Tayg==
X-Gm-Message-State: APjAAAVPAeGCntRHM1qlB9jB81X4di0W7pjpstBfuO+/bPu+MMJwvIhg
        qm43+v0S6OnbLSo8LOn1iiPf2y9qSXc=
X-Google-Smtp-Source: APXvYqzKx+XsKrTmeylXJ5g9lfyCuIEbJb/hZJmUWpL72bhHFDogMj6eaYFbbssnqSKW6mnUKiMOew==
X-Received: by 2002:a65:685a:: with SMTP id q26mr6608450pgt.32.1570919329917;
        Sat, 12 Oct 2019 15:28:49 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::2])
        by smtp.gmail.com with ESMTPSA id f6sm12756846pfq.169.2019.10.12.15.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 15:28:49 -0700 (PDT)
Date:   Sat, 12 Oct 2019 15:28:45 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mariusz Bialonczyk <manio@skyboo.net>
Subject: Re: [PATCH net] r8169: fix jumbo packet handling on resume from
 suspend
Message-ID: <20191012152845.6ff9430d@cakuba.netronome.com>
In-Reply-To: <03561754-aec2-7015-4b4d-32707bf3bd2d@gmail.com>
References: <05ef825e-6ab2-cc25-be4e-54d52acd752f@gmail.com>
        <20191010163630.0afb5dd8@cakuba.netronome.com>
        <03561754-aec2-7015-4b4d-32707bf3bd2d@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Oct 2019 08:03:24 +0200, Heiner Kallweit wrote:
> On 11.10.2019 01:36, Jakub Kicinski wrote:
> > On Wed, 9 Oct 2019 20:55:48 +0200, Heiner Kallweit wrote: =20
> >> Mariusz reported that invalid packets are sent after resume from
> >> suspend if jumbo packets are active. It turned out that his BIOS
> >> resets chip settings to non-jumbo on resume. Most chip settings are
> >> re-initialized on resume from suspend by calling rtl_hw_start(),
> >> so let's add configuring jumbo to this function.
> >> There's nothing wrong with the commit marked as fixed, it's just
> >> the first one where the patch applies cleanly.
> >>
> >> Fixes: 7366016d2d4c ("r8169: read common register for PCI commit")
> >> Reported-by: Mariusz Bialonczyk <manio@skyboo.net>
> >> Tested-by: Mariusz Bialonczyk <manio@skyboo.net>
> >> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com> =20
> >=20
> > Applied, somewhat begrudgingly - this really isn't the way the Fixes
> > tag should be used, but I appreciate it may be hard at this point to
> > pin down a commit to blame given how many generations of HW this driver
> > supports and how old it is.. perhaps I should have removed the tag in
> > this case, hm.
> >=20
> > Since the selected commit came in 5.4 I'm not queuing for stable.
> >  =20
> The issue seems to have been there forever, but patch applies from a
> certain kernel version only. I agree that using the Fixes tag to provide
> this information is kind of a misuse. How would you prefer to get that
> information, add a comment below the commit message similar to the list
> of changes in a new version of a patch series?

I'd put the backport help under the --- lines, maybe additionally
mentioning its presence in the commit message (lore link would
complete the picture). Like we do for merges.=20

Although I think Dave queues for stable immediately when patch is=20
merged to net, so if the backport is to last release or two I think=20
the info under --- could be as useful as in the commit message.

Another way would be posting the backported patch (say for the most
recent LTS) if the backport is hard and fix important =F0=9F=A4=94
