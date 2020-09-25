Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1367E279037
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgIYSYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:24:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729593AbgIYSYZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 14:24:25 -0400
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73FEC2344C;
        Fri, 25 Sep 2020 18:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601058264;
        bh=3+UjR32phag7o0qtGDIn18Bhp3Te2gJhkXo8qfae49I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gYZyZw6q1BO+3QxLi6Yhxa52YdvWOGP6Bwynz1IgdeP4AoQ8O9LACjSjJq9kUdPAQ
         2A9gwH2FC9gAFJD9v+rsBafSLadQqFs4m/Wfn1Ng9uYeWn8xQWdC+TallzF6jFqiCs
         Engcd77zB1U31bxCR0JWjkmiWHv0KP9rxXqaifVg=
Received: by mail-ot1-f48.google.com with SMTP id g96so3163099otb.12;
        Fri, 25 Sep 2020 11:24:24 -0700 (PDT)
X-Gm-Message-State: AOAM532wevVVVtVHP55vKKTUjCeACz7kwAnMOk4H8MCS/NVQQEjuB6TD
        NnA+hQfddiZvFZknBAajlSaMBlVRXJZH3+GP+A==
X-Google-Smtp-Source: ABdhPJzHcLMNb6xVVlodE5OyqgAY19wIaDZiXPKwHOA40n53jDTNUtNA3wjcwjLHWn8v5JC2xFhuQcSVkjaR6rPxT5I=
X-Received: by 2002:a9d:6b0d:: with SMTP id g13mr1190401otp.129.1601058263764;
 Fri, 25 Sep 2020 11:24:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200920095724.8251-1-ansuelsmth@gmail.com> <20200920095724.8251-4-ansuelsmth@gmail.com>
In-Reply-To: <20200920095724.8251-4-ansuelsmth@gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 25 Sep 2020 12:24:12 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKhyeh2=pJcpBKkh+s3FM__DY+VoYSYJLRUErrujTLn9A@mail.gmail.com>
Message-ID: <CAL_JsqKhyeh2=pJcpBKkh+s3FM__DY+VoYSYJLRUErrujTLn9A@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] of_net: add mac-address-increment support
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 3:57 AM Ansuel Smith <ansuelsmth@gmail.com> wrote:
>
> Lots of embedded devices use the mac-address of other interface
> extracted from nvmem cells and increments it by one or two. Add two
> bindings to integrate this and directly use the right mac-address for
> the interface. Some example are some routers that use the gmac
> mac-address stored in the art partition and increments it by one for the
> wifi. mac-address-increment-byte bindings is used to tell what byte of
> the mac-address has to be increased (if not defined the last byte is
> increased) and mac-address-increment tells how much the byte decided
> early has to be increased.

I'm inclined to say if there's a platform specific way to transform
MAC addresses, then there should be platform specific code to do that
which then stuffs the DT using standard properties. Otherwise, we have
a never ending stream of 'generic' properties to try to handle
different platforms' cases.

Rob
