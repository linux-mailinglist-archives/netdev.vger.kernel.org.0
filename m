Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDF12AC8B9
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730528AbgKIWjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729493AbgKIWjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 17:39:35 -0500
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8B8C0613CF;
        Mon,  9 Nov 2020 14:39:34 -0800 (PST)
Received: by mail-ua1-x944.google.com with SMTP id w3so3330318uau.2;
        Mon, 09 Nov 2020 14:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d+NfxzyRkzRw3pdaoxWCq5v07Uu6q3uueUp1SzP+cfg=;
        b=PVbOnYVWoiBG+7BlUd44D9i6J4R1FaFGBCwC15kodFPGiM5xAZfldZxDkKRY4SgPAy
         sXmMbUW138lnptKJkl+ic3I3veoveoMc3yfTHKUvA3o7JSQ7WlLXJ59qjAtIXTdWbDzu
         EWk+FgM9iabOdBeRoC2Y9nMQRXa6pphze6o+MkSEsBBY107RvfTuvi0+baIUil6L+UmZ
         89s2lsVHemd7KMNznsXsenWyetsA0BTvuJiW9xY+yhpDJGwfT74Tl5ROMvABy/t55s/u
         refHcO8RzkG9S6Gt7y0HAKhVJhX8c2yrsnB9dBDpldoCNLX5lAxc1YWfFQUXfsSeufHD
         gJ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d+NfxzyRkzRw3pdaoxWCq5v07Uu6q3uueUp1SzP+cfg=;
        b=r6YhdUSegMyn1PgpizVa5R+TWCz0gWOFhlLE2U5fzABy6RojRNxumHba1WOPv7h1CU
         Z7v4E4jeYZuvhuGdONe+fSlOgqbjM+HXEtwHKhgywaEuMmmPte/5d6/Z+IqULZS0TBkz
         HFXNUrd7TZ9QiPSdnwA0QiooMpfWYVNFKUc1cuCr1htT7yjaBJg0CWocLsMI/34Xajyo
         7Xf9blo8fubstwFbpGZqg3iA+CcGcrBrtD4lMVUAqOQA/qlgUxzKqgN/ewPWnmtRmz+1
         IXziawaC41m2QY0+0/oCizi6GRLJvJrVMMdOVbmGeHifpxmd2nb1cevQl8hmDAASMGnO
         DIVg==
X-Gm-Message-State: AOAM53212Y8XEScwM9S5FSSEX5Dl7w/6015StJfa23XxTR02D/ELOyiq
        CyhJvub6av2h4Ty0+VT1DOoxaWjzMDOL9jxtSbA=
X-Google-Smtp-Source: ABdhPJx8SGa88QNC9L9JEyzAt062NmKGsS70aQym3pL39yFfpoN2HuNNHeuoJTeB71KJAUHnVDPcvQIR/KCgLa4tJrA=
X-Received: by 2002:ab0:380d:: with SMTP id x13mr8341198uav.41.1604961573263;
 Mon, 09 Nov 2020 14:39:33 -0800 (PST)
MIME-Version: 1.0
References: <20201109193117.2017-1-TheSven73@gmail.com> <20201109130900.39602186@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAGngYiUt8MBCugYfjUJMa_h0iekubnOwVwenE7gY50DnRXq5VQ@mail.gmail.com>
 <20201109132421.720a0e13@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAGngYiXeBRBzDuUScfxnkG2NwO=oPw5dwfxzim1yDf=Lo=LZxA@mail.gmail.com>
 <20201109140428.27b89e0e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAGngYiWUJ=bdJVMjzXBOc54H4Ubx5vQmaFnUbAWUjhaZ8nvP3A@mail.gmail.com>
 <20201109142322.782b9495@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAGngYiVaQ4u7-2HJ6X92vJ9D4ZuC+GZhGmr2LhSMjCKBYfbZuA@mail.gmail.com> <20201109143605.0a60b2ab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109143605.0a60b2ab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Mon, 9 Nov 2020 17:39:22 -0500
Message-ID: <CAGngYiWYKsTURi0pRMxX=SjzPnx-OF0cC43dnaGc+o15kLwk_A@mail.gmail.com>
Subject: Re: [PATCH net-next v1] net: phy: spi_ks8995: Do not overwrite SPI
 mode flags
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 5:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Yes, most certainly. Especially with 5.10 being LTS.
>
> You can send a minimal fix (perhaps what you got already?), and follow
> up with the helper as suggested by Andrew after ~a week when net is
> merged into net-next.
>

What I already posted (as v1) should be the minimal fix.
Can we proceed on that basis? I'll follow up with the helper
after the net -> net-next merge, as you suggested.
