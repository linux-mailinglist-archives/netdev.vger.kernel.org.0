Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC80966E4
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 18:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbfHTQ5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 12:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbfHTQ5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 12:57:19 -0400
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A33212339F;
        Tue, 20 Aug 2019 16:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566320238;
        bh=XXjiYxQkert7CQKwnQYwS/DJ9k/U3UTDnEKYjjCX/3Q=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=2jX2Ag8APIFwCLyU4kAtKBfXXb5lV2endNabWcuWxLvWLoywws5J1NWZ3jhvOolz1
         21Gyotmv1EcMF9cr0YZwBagfs2iDSHfxsTScMZfVVdQ13/8sSyk2/8nrJPCz54HUIF
         Ggt4fV6axtAZrFH7DH3IG0RL35pbuGbZLHiApFbY=
Received: by mail-qt1-f182.google.com with SMTP id t12so6823609qtp.9;
        Tue, 20 Aug 2019 09:57:18 -0700 (PDT)
X-Gm-Message-State: APjAAAX2Ayouk88Kft7Ye6hgRvPSET1S5McaDKjP4897FKhw+7g6X9pj
        YSys8mp7nvWG1UJD7CobcpHClWVPLTZ7kzoBOg==
X-Google-Smtp-Source: APXvYqyXzp+QqhlPh4ms6hvrPcB1uD6IRBalVujsZrtIEmK/kh6+PbQH7E0GTYlHODGJjOvZfk0fqz3SyXtNfugq1Q4=
X-Received: by 2002:ac8:386f:: with SMTP id r44mr27730593qtb.300.1566320237772;
 Tue, 20 Aug 2019 09:57:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190820145343.29108-1-megous@megous.com> <20190820145343.29108-3-megous@megous.com>
 <CAL_JsqLHeA6A_+ZgmCzC42Y6yJrEq6+D3vKn8ETh2D7LJ+1_-g@mail.gmail.com> <20190820163433.sr4lvjxmmhjtbtcb@core.my.home>
In-Reply-To: <20190820163433.sr4lvjxmmhjtbtcb@core.my.home>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 20 Aug 2019 11:57:06 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJHNL91KMAP5ya97eiyTypGniCJ+tbP=NchPJK502i5FQ@mail.gmail.com>
Message-ID: <CAL_JsqJHNL91KMAP5ya97eiyTypGniCJ+tbP=NchPJK502i5FQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] dt-bindings: net: sun8i-a83t-emac: Add phy-io-supply property
To:     Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 11:34 AM Ond=C5=99ej Jirman <megous@megous.com> wro=
te:
>
> On Tue, Aug 20, 2019 at 11:20:22AM -0500, Rob Herring wrote:
> > On Tue, Aug 20, 2019 at 9:53 AM <megous@megous.com> wrote:
> > >
> > > From: Ondrej Jirman <megous@megous.com>
> > >
> > > Some PHYs require separate power supply for I/O pins in some modes
> > > of operation. Add phy-io-supply property, to allow enabling this
> > > power supply.
> >
> > Perhaps since this is new, such phys should have *-supply in their node=
s.
>
> Yes, I just don't understand, since external ethernet phys are so common,
> and they require power, how there's no fairly generic mechanism for this
> already in the PHY subsystem, or somewhere?

Because generic mechanisms for this don't work. For example, what
happens when the 2 supplies need to be turned on in a certain order
and with certain timings? And then add in reset or control lines into
the mix... You can see in the bindings we already have some of that.

> It looks like other ethernet mac drivers also implement supplies on phys
> on the EMAC nodes. Just grep phy-supply through dt-bindings/net.
>
> Historical reasons, or am I missing something? It almost seems like I mus=
t
> be missing something, since putting these properties to phy nodes
> seems so obvious.

Things get added one by one and one new property isn't that
controversial. We've generally learned the lesson and avoid this
pattern now, but ethernet phys are one of the older bindings.

Rob
