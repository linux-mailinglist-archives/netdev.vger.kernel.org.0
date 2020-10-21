Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F87294EFC
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 16:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443713AbgJUOq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 10:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442691AbgJUOqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 10:46:55 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39242C0613CE;
        Wed, 21 Oct 2020 07:46:55 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id n15so2024289otl.8;
        Wed, 21 Oct 2020 07:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1IUZ6I6V7LqNbiAO/jvNIl7pEQEeI/Zj04i8X71a+ms=;
        b=qPbep5+ETyoX0YcK+v5CxNod1eUBDBEcuWhJswN9dejqu9VvO0uUrmTVi1doU/lJCF
         SA+BYBbk5tJw7GdllVJGDW3MkaShKpbs2pJF0dzmTGhkBO76yBvZQyqBIx9zKTbgpFeL
         XTgh8U1l67Hi3EThp2SBIbjXbG8AZat/3f8AaXGLK84g86+QLtiGqqO73NnIkiIPZkw7
         Y8TN/sTyPcaK7fSSqxFl9psD0hZlQwcUrA0/G+3AoDqh/2A3UrhovjwqgtX05LitZx1+
         Rl0JIq51di9V4w8WLzlBXdrWJSXqQho+GvDZ/KOdCY3d00avQ9l2QW4jcz8nkJ/Syt+/
         JN7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1IUZ6I6V7LqNbiAO/jvNIl7pEQEeI/Zj04i8X71a+ms=;
        b=DYpf0Q4Jaj+goEK1OVB0K3ASDdTJKcIpQJFbjoeLXazrvd/jNgzMctTKTnN4/Psw6+
         p9wBnnSdeUGCnaESE4+SI1MyokUxy+hmo2STGdJLCdNWNoL251b4rIajOGxzRp7+Yd4q
         FjctWdr0/VNdRlaxqPqJV23G7LlZ/0xgD3+EEgvRjJI6j7rWWsny9cuML0GOjuHU1ngk
         nqhwv1KAkIBBtlTL5MTmLWc3OcaGS4cHtFjegUvpnITEgdnmn/Yxlx/M/+QnfxlaiqVV
         IfrQZ34bVkfQ7M9S6ubKPpuizmIYgdq35RDv0X3TxouLxambwwnJce8EPCbKXEkDcWTE
         LfZg==
X-Gm-Message-State: AOAM533Vw/rGlKTOrVt1j4wW1I+dKGYvhfvTFuiOoi/zLRFANtDImFJ9
        e+EtRVMRimKxyMTZV4CaejS28PylYpn60NguarI=
X-Google-Smtp-Source: ABdhPJz3cx2YSXE+eoT35+abgW4d4thuCG+e2MxOh8ZpjImNE4uQlVCgS76nyPsdvHovONXEhQe/VPTddrxyLPWcfsw=
X-Received: by 2002:a05:6830:2153:: with SMTP id r19mr2758372otd.207.1603291614667;
 Wed, 21 Oct 2020 07:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <20201021135140.51300-1-alexandru.ardelean@analog.com>
 <20201021135140.51300-2-alexandru.ardelean@analog.com> <20201021140852.GN139700@lunn.ch>
 <CA+U=DsrZM4gRpmez6KqT8XTEBYwA-gwHjHQWa3Pn+G1nsYD3CA@mail.gmail.com> <20201021142804.GP139700@lunn.ch>
In-Reply-To: <20201021142804.GP139700@lunn.ch>
From:   Alexandru Ardelean <ardeleanalex@gmail.com>
Date:   Wed, 21 Oct 2020 17:46:43 +0300
Message-ID: <CA+U=DsqFcLRVYfbsQ6y=98epaX0DYTbbh8PMiDkQS6bxkFRQAQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: phy: adin: implement cable-test support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        David Miller <davem@davemloft.net>, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 5:28 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Actually, I'd also be interested [for this PHY], to report a
> > "significance impedance" detection, which is similar to the
> > short-detection that is already done.
>
> You can add that as just another element of the enum.
>
> > At first, this report would sound like it could be interesting; but
> > feel free to disagree with me.
> >
> > And there's also some "busy" indicator; as-in "unknown activity during
> > diagnostics"; to-be-honest, I don't know what this is yet.
>
> The link partner did not go quiet. You can only do cable tests if the
> partner is not sending frames or pulses. You will find most PHYs have
> some sort of error status for this. For the Marvell driver, this is
> MII_VCT7_RESULTS_INVALID. In that case, the Marvell driver returns
> ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC.

Good to know.
So, then a quick question: would this patchset [well, a V2 of this] be
ok in this form, for the initial cable-test support of this PHY?

For other enhancements on the PHY's cable-test [that also require some
new netlink attributes, I can do other patches, in the form of
"new-netlink-attr, then driver change, and then ethtool update".

>
>         Andrew
