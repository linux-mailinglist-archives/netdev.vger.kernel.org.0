Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 176734D48C
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 19:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732033AbfFTRHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 13:07:51 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35764 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfFTRHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 13:07:51 -0400
Received: by mail-ot1-f66.google.com with SMTP id j19so3478589otq.2;
        Thu, 20 Jun 2019 10:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j3x8AndmJKQZh/Utkg78GR65Apa8EJT0dbv4Dq0oZqo=;
        b=X+HKKWwJ8emsAcKDH25vZVWQmRBXdWoerOd1+Rm0G2jv8uKznJ8GkPVJijYOXUJv5G
         ctUbZlMXpCbCtVTxxGZe3/kJVl6fvcn3Oj7kftBelwgOoMe62SOEBdXw+AJoB3KvXnoc
         F9HPWtsO38/WfUcZKfxClhLpl43xDXMZ5MWtlkFK0FS2bgiFrzfcTU3gc/jsSkeshTzx
         xnx8MP2fWRE+X66QP2crHt7JWsp96cr+WiZnGBcCffupVjKBwiLR1OlH20I4j1KDwAh4
         AVYMqlnbPlAHekCJY1vPbbhN9eqA6qv0cLgn24FUq1feMMqaJoZlJ5l+6XSd1KIUt3Fl
         vlDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j3x8AndmJKQZh/Utkg78GR65Apa8EJT0dbv4Dq0oZqo=;
        b=g/Q3nmy5V5pvQxN9/sei30LFQxVFVfX+c+d/FwAFzjwfi0LAv1rFl0FBxByvKQuRtj
         1vR5MUwK+B/i2m7TwYEFnV9lPOglnEpj+MDmKIoz52+2Zgef71AkCqokKStayaantZ5g
         URpHlqLzKaRyksqm1+izyexx8RxPpxCFQA6DQpmlj9Ir2jt3lXKiPLdyJlU36gd76eFj
         S/e5RsZyBpuGwBj0fXiJcdYIG2P4TYPMAqP4EO3RglQUoaraYOS4+VP75KOh9z8+Zb7z
         lrjyniey6qaLZDB80hMgkd+vDBvw3bxFRJyGVWjTlPmX3t9d6SyvniKUz05WKvY65Xen
         dj/A==
X-Gm-Message-State: APjAAAW8M7ou/RZ5BTZx8QpV0PmWUojb1d8RlI0nyuMWNNAbstMuGzHK
        qhJjqbMnotnlpfjs8YEbqUbJIf4eb8KzJYu9S6U+jw==
X-Google-Smtp-Source: APXvYqwS2rmf74hZr9Za2VocUXy4vwMOLTljjsdpb9Gs4Ml46+PIC/e4smye/d6yez8/aTYUZ3grN84Q84Z7tPvcO6A=
X-Received: by 2002:a9d:39a6:: with SMTP id y35mr4884042otb.81.1561050470326;
 Thu, 20 Jun 2019 10:07:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190618203927.5862-1-martin.blumenstingl@googlemail.com> <20190619.174128.213376833708672164.davem@davemloft.net>
In-Reply-To: <20190619.174128.213376833708672164.davem@davemloft.net>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 20 Jun 2019 19:07:39 +0200
Message-ID: <CAFBinCAOsAiYFnBzoUaoCHXmanfgv2KQ_MaAJduq9af0V3VsNQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1] net: stmmac: initialize the reset delay array
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joabreu@synopsys.com, alexandre.torgue@st.com,
        peppe.cavallaro@st.com, khilman@baylibre.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 11:41 PM David Miller <davem@davemloft.net> wrote:
>
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Date: Tue, 18 Jun 2019 22:39:27 +0200
>
> > Commit ce4ab73ab0c27c ("net: stmmac: drop the reset delays from struct
> > stmmac_mdio_bus_data") moved the reset delay array from struct
> > stmmac_mdio_bus_data to a stack variable.
> > The values from the array inside struct stmmac_mdio_bus_data were
> > previously initialized to 0 because the struct was allocated using
> > devm_kzalloc(). The array on the stack has to be initialized
> > explicitly, else we might be reading garbage values.
> >
> > Initialize all reset delays to 0 to ensure that the values are 0 if the
> > "snps,reset-delays-us" property is not defined.
> > This fixes booting at least two boards (MIPS pistachio marduk and ARM
> > sun8i H2+ Orange Pi Zero). These are hanging during boot when
> > initializing the stmmac Ethernet controller (as found by Kernel CI).
> > Both have in common that they don't define the "snps,reset-delays-us"
> > property.
> >
> > Fixes: ce4ab73ab0c27c ("net: stmmac: drop the reset delays from struct stmmac_mdio_bus_data")
> > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>
> Applied, thanks.
thank you!

> > Please feel free to squash this into net-next commit ce4ab73ab0c27c.
>
> We do not "squash" things into existing net-next commits, as commits in
> my tree(s) are permanent and immutable.
understood. other maintainers do it so I thought I would mention it
I'm happy either way


Martin
