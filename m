Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3699F2AC82D
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729886AbgKIWUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgKIWUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 17:20:00 -0500
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2436FC0613CF;
        Mon,  9 Nov 2020 14:20:00 -0800 (PST)
Received: by mail-vs1-xe42.google.com with SMTP id u7so5886553vsq.11;
        Mon, 09 Nov 2020 14:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NkRhdWUjyBAq9RdkQbodw+dQbZwpkI++aUs2Z/kHrgA=;
        b=mccDTbWJ2u3OvdVtsp+jDwL4z2qtcW6NPcO83WHToJrRzbTIqWVDTv3Og1RC4jzTCk
         OVje4KKR/WprUu8VOwYbbvPEHp0dhHLEe471unDTriNOmE3F5TFq+nRLywpFYl/3sv6Q
         Kyxi50xFpNmt2Su3ijVKULFZ7Iq75S9Mik1GeUeeyiMePtTDZm5bX5BquB/gCT8J9zUI
         RJSdFRTlrTC2PZDTq5Drc8qnxKSBY/DjbDgC675SebVFmCvphEkWdXIgc8N+VcgJz5N3
         IXQtrG80XNl6OU5uqNImYdD+ntvi0idxASmD+NKT6uTMZ8aB+MMkMNZ/B02WO7BfaErK
         jfRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NkRhdWUjyBAq9RdkQbodw+dQbZwpkI++aUs2Z/kHrgA=;
        b=TGzZ0Hm3Evw8sT4fp0nOQ6Wl3VBjGZ/aWqwQoG9KmWmPOk7pSRBkLj+fIPtQ/cUzvY
         qFSj5Tp8KuQaqrfBuEL0SK3U55ShdP+j/ZnvaHNvHEjANWHlVkHrkt+dBQRvrkpGrRzj
         eisRNenS88BZ6HJmG38mqJ7BHGeg7B00fjs6DAAVkafLzn6ZOwaoHqWLitr+qgR84FZ8
         kWpCsmdI45K0hIBchKQvjc1uG+zhrzUoF9SsN7U0mwusBHlKPyQvw9CqPm0YYirXh5XZ
         QuN29uzFnRfgLYaOLpoomc70uDuLcDdPudIseiMNT5O9NXdievvDRzf8MqDAh1UrdCp9
         Uxug==
X-Gm-Message-State: AOAM5308LksGYXZaq06mzMp1KJHcivwDvrFNBij1ig6R2VhQ5GABJd+i
        JQcv9r1VuVzD+RnHELthhjP2IH2wy9Z342WXDQwFc0HO
X-Google-Smtp-Source: ABdhPJwQlpmjamXNAzbB0AIyk+TQD+2N2RybvhJNM6ZRirFuvy3YigGZB/avIN2QFxvHNSgJeQl4j3cQcO1eznwjxOA=
X-Received: by 2002:a67:2ac1:: with SMTP id q184mr9356588vsq.57.1604960399361;
 Mon, 09 Nov 2020 14:19:59 -0800 (PST)
MIME-Version: 1.0
References: <20201109193117.2017-1-TheSven73@gmail.com> <20201109130900.39602186@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAGngYiUt8MBCugYfjUJMa_h0iekubnOwVwenE7gY50DnRXq5VQ@mail.gmail.com>
 <20201109132421.720a0e13@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAGngYiXeBRBzDuUScfxnkG2NwO=oPw5dwfxzim1yDf=Lo=LZxA@mail.gmail.com> <20201109140428.27b89e0e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109140428.27b89e0e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Mon, 9 Nov 2020 17:19:48 -0500
Message-ID: <CAGngYiWUJ=bdJVMjzXBOc54H4Ubx5vQmaFnUbAWUjhaZ8nvP3A@mail.gmail.com>
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

On Mon, Nov 9, 2020 at 5:04 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Yup

Just a minute. Earlier in the thread, Andrew Lunn is suggesting I
create a new spi helper function, and cross-post to the spi group(s).

That doesn't sound like a minimal fix, should it go to net or net-next?

Thanks,
Sven
