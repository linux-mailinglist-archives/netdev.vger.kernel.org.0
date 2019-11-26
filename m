Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2958D10977A
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 02:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfKZBN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 20:13:28 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39608 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfKZBN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 20:13:27 -0500
Received: by mail-qk1-f194.google.com with SMTP id z65so9897941qka.6
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 17:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2rfPK0DW11RQCCEDcxZu9s9ehCYd8wL3gZp5EtT3+S4=;
        b=J+HyXtxJxQ9cmxUOaTi3edrKTi1um9hQ0jl5kLojxkLncTYNx/1VSM946bOpff6x+v
         np/hS25qgsQFaFoccVLTunSDJKdxc7MZdXwz8syC/1rwbtklaNSw80VoXG2uOu6ERbH5
         ltEuDVFv8LHpEBXTslHVbOuOXXBM3bP/y8IHw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2rfPK0DW11RQCCEDcxZu9s9ehCYd8wL3gZp5EtT3+S4=;
        b=AW4JOFuGE+CFQuqo05VKRoR4Nd4tsOLmFr1xgIt23KNC1DA4YJXm6Ll5aPQgQ+Lh+Z
         zBFA4mhDMN3cYLP+ihmgv7X956E7bReTiX9xZflETSfRxb6OrsbvTDlm4YJsN7yXqqfW
         pcmpdBsjgkn+a0ksC+sthjnGYfxfQa7EuQ9HwZFxWJWQbz9bdZn6sqYYGAoCoMO1ivEi
         BJvff8+a4Q1SlzYR7ef6IygZaf5tyOXZ57CWDcEoRv5EMqojBpkA4/5J4tK+w5XD5KLh
         Xrx5LVGupdpEK4Fvvc+VaOTG4Yawog+95GNNMXlQ7pUVxIHW3/8eBxQ/k7JB96FVGrmb
         saJQ==
X-Gm-Message-State: APjAAAV4gPxmxybZRuZ6bYSnBla70+szW70N8tFoQ9dbgdrMnRhCxaen
        sOZhbcCEBNLQkClmG2AWUXh8QUl6/bU=
X-Google-Smtp-Source: APXvYqzUoqUuBvfEdygmdjQoXtfkTQKx3K0IPzoLmrctZYSJgc3WyXf1o8P/cJV0ldUSmTc4QsKdXg==
X-Received: by 2002:a37:67c5:: with SMTP id b188mr28704859qkc.199.1574730805618;
        Mon, 25 Nov 2019 17:13:25 -0800 (PST)
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com. [209.85.222.177])
        by smtp.gmail.com with ESMTPSA id y21sm4396777qka.49.2019.11.25.17.13.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 17:13:24 -0800 (PST)
Received: by mail-qk1-f177.google.com with SMTP id q70so14651652qke.12
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 17:13:23 -0800 (PST)
X-Received: by 2002:a37:8285:: with SMTP id e127mr13935443qkd.62.1574730803238;
 Mon, 25 Nov 2019 17:13:23 -0800 (PST)
MIME-Version: 1.0
References: <20191113005816.37084-1-briannorris@chromium.org>
 <32422b2d-6cab-3ea2-aca3-3e74d68599a3@gmail.com> <20191123005054.GA116745@google.com>
 <9d6210ec-fab5-c072-bdf4-ed43a6272a51@gmail.com>
In-Reply-To: <9d6210ec-fab5-c072-bdf4-ed43a6272a51@gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 25 Nov 2019 17:13:11 -0800
X-Gmail-Original-Message-ID: <CA+ASDXMN-=jXQieqsCN+18H7wMnYLw_M1WijAYcb_2AaCwK5cg@mail.gmail.com>
Message-ID: <CA+ASDXMN-=jXQieqsCN+18H7wMnYLw_M1WijAYcb_2AaCwK5cg@mail.gmail.com>
Subject: Re: [PATCH] [RFC] r8169: check for valid MAC before clobbering
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 2:46 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> On 23.11.2019 01:51, Brian Norris wrote:
> > On Wed, Nov 13, 2019 at 09:30:42PM +0100, Heiner Kallweit wrote:
> >> If recompiling the BIOS isn't an option,
> >
> > It's not 100% impossible, but it seems highly unlikely to happen. To me
> > (and likely the folks responsible for this BIOS), this looks like a
> > kernel regression (this driver worked just fine for me before commit
> > 89cceb2729c7).
> >
> On an additional note:
> The referenced coreboot driver is part of the Google JECHT baseboard
> support. Most likely the driver is just meant to support the Realtek
> chip version found on this board. I doubt the driver authors intended
> to support each and every Realtek NIC chip version.

I understand that -- I'm specifically seeing problems on the Jecht
family of devices (Jecht was the reference board), which is why I
pointed you there :) All devices in that family use a Realtek chipset
that appears to be RTL8168G, and they all only program the registers I
pointed at in the first place.

One side note: I'm not quite sure how (again, no documentation...) but
some devices appear to have a different valid MAC address in the
GigaMAC register, which is why I see this problem. If they all just
left it 0x00, then I'd be in OK shape.

Brian
