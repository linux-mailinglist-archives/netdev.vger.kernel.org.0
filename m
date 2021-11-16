Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED373453BE4
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 22:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhKPVuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 16:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhKPVuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 16:50:32 -0500
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA92AC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 13:47:34 -0800 (PST)
Received: by mail-vk1-xa2c.google.com with SMTP id q21so403964vkn.2
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 13:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NzIImoMpSNlct2P2v9AJLMv+SjDD/ZALWNmLMTbdO/Q=;
        b=zlRL2hZj4sCHUhLh1IxhqEpOfopoYRME8+W3quqbJDer8lsUG681QpHcN0Ub6FTICi
         52nW69jrZZqOffdrePFEO79MFoOKSEhpyud60QH6EQT3Ud5+K+Pcf00D3HU/6S8ZLQgk
         brGfLWQ0p3liUiX+z7vyQ2kRvyz+d8TOLuUQ+6zBEQTR8kE9Lt02TamG30m7w5AYt3D8
         Z/eEq+8hHqSsVfxIFB/DFDQ42cVnf0A/dveITUe0Ls8arLEJAVvn95v/BS8u+ntZhZSt
         6Cq8RMR957YR500taRiWpAJacVsiIJKcNpP3zHjzqGL7PzRm3hMRKGGFFCVyIapGRgZ9
         Ficg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NzIImoMpSNlct2P2v9AJLMv+SjDD/ZALWNmLMTbdO/Q=;
        b=iY0zefFJh6J25tgW2LTaZTA7tKHswvT5LzO3X+BcKaovt04cE8ku+vB+Y2VsS6wUNo
         ysBwxExWx3IXIEKihF9MyQ8H13lGnrQheJNFiiwxuHawkmm0P1FeM4t/UlCY42JxI3FY
         YoNM4iR8Y4pAX68IbshY38S3J0IhLiQXT/sN+CwYXdfJdGmcZSXqNWFMwuEUuLt1wZ+9
         S2qJPOnohsUwcHX6ezIwCOye/C3mZa/cJHWlzQG4r0UNp9RBRtdQnkNlzmPt2D4olmJz
         RJbgEBMKP2TGtj8M0GfitTDfLh9vR8STYITet8miI1LMywgCOest3XyfiUG0oiiXrHC3
         dEpA==
X-Gm-Message-State: AOAM533fkjeKiSBV/1cvBmNHzTGVpJAFoggisDWID0wXDyeAXGdBx/kz
        P52NEiMl4a1cLwQdO1Vuqr7AVLyN9X09G06Cgx7UkCdV3NUzvl+l
X-Google-Smtp-Source: ABdhPJx+1ANOj/L9RdbZ+yPUaCHIksDoa5fWxEGLR6HhHEfEqLjfy7WtVUnw+uk/CHxMXz32SWi7i3RtPO0xRhQQTRI=
X-Received: by 2002:a05:6122:8cb:: with SMTP id 11mr81500354vkg.11.1637099254035;
 Tue, 16 Nov 2021 13:47:34 -0800 (PST)
MIME-Version: 1.0
References: <20211115205005.6132-1-gerhard@engleder-embedded.com>
 <20211115205005.6132-4-gerhard@engleder-embedded.com> <577ffb42-d74e-9da7-d921-b7f62c26b596@gmail.com>
In-Reply-To: <577ffb42-d74e-9da7-d921-b7f62c26b596@gmail.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Tue, 16 Nov 2021 22:47:22 +0100
Message-ID: <CANr-f5yiJG_+K63NpSuiAefqM4Cb=UWEdBGKv6mkS5fMZ96new@mail.gmail.com>
Subject: Re: [PATCH net-next v5 3/3] tsnep: Add TSN endpoint Ethernet MAC driver
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 11:21 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> On 15.11.2021 21:50, Gerhard Engleder wrote:
> > +     /* entry->properties shall be valid before write pointer is
> > +      * incrememted
> > +      */
> > +     wmb();
>
> A lighter variant like smp_wmb() is not sufficient here?

This is some leftover from lockless descriptor ring processing, which has
been replaced by a spinlock. I will remove it.

> > +             dma_rmb();
> > +
>
> Memory barriers should always have a comment explaining why
> they are needed. I think checkpatch would complain here.

I don't see any checkpatch warning, but you are right. I will document
all DMA memory barriers.

Gerhard
