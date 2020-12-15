Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD402DAE2D
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 14:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbgLONl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 08:41:28 -0500
Received: from mail-oo1-f67.google.com ([209.85.161.67]:44359 "EHLO
        mail-oo1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbgLONlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 08:41:21 -0500
Received: by mail-oo1-f67.google.com with SMTP id j21so2230782oou.11;
        Tue, 15 Dec 2020 05:41:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c+L7KsCOY6qFeiR1Hwd17et+mSRPWVYNWJEy3hpVFbM=;
        b=MRy0QzsuGZMx4Qs03x/xu+QuWpT5888jY0woR9KkWdU0BNSy7CRa9w5nyte2gn4d3W
         KUoJwuKeZWpDVWITWOP937C2uSdJon/jDzOaFOe7PwO+kKxK9+wm9oRzkpsDm7lr2htk
         o/ASqpPoJZTOZzDrO3mbMH2SI26oIwJEQukNa+dyvGNAxLis/0lNP1Hq2y2wVDTwtzXQ
         7WYTbnotvguBYjalI28KV6WHTUAt7TjnZkslwrnxSwIY1J+e6zGMLvSscQCy+oLzzUZ0
         VzI/4VTIHeQZMcysT3IEiA6cEje+A5QCZZArzeCjg2Yz7L1Ghn6yEzGEj6GRuSWDI+eE
         7UhA==
X-Gm-Message-State: AOAM530qMlAbrOlCAAjCRgH8mkP/jnYr392t3SQmTTbQMPNS9YOCvxkS
        WRhDV2zC+WdCMvIP/CahtQ==
X-Google-Smtp-Source: ABdhPJzYp2gtH1L2laiW+oCQr2gnK/ycYaSVTaTB2Tc9PcJnULV+N/4EBmlZVacWMQE9WtNA3QwS6A==
X-Received: by 2002:a4a:98a3:: with SMTP id a32mr19107834ooj.51.1608039640709;
        Tue, 15 Dec 2020 05:40:40 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id p4sm5084387oib.24.2020.12.15.05.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 05:40:39 -0800 (PST)
Received: (nullmailer pid 3705961 invoked by uid 1000);
        Tue, 15 Dec 2020 13:40:38 -0000
Date:   Tue, 15 Dec 2020 07:40:38 -0600
From:   Rob Herring <robh@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, jianxin.pan@amlogic.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        khilman@baylibre.com, Neil Armstrong <narmstrong@baylibre.com>,
        jbrunet@baylibre.com, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH RFC v2 1/5] dt-bindings: net: dwmac-meson: use
 picoseconds for the RGMII RX delay
Message-ID: <20201215134038.GA3702703@robh.at.kernel.org>
References: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
 <20201115185210.573739-2-martin.blumenstingl@googlemail.com>
 <20201207191716.GA647149@robh.at.kernel.org>
 <CAFBinCDXqnPQtu4ZQW2ngxKVSbRQNFbnhy6M04gE+Mc8HOTM8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCDXqnPQtu4ZQW2ngxKVSbRQNFbnhy6M04gE+Mc8HOTM8g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 05:59:05PM +0100, Martin Blumenstingl wrote:
> Hi Rob,
> 
> On Mon, Dec 7, 2020 at 8:17 PM Rob Herring <robh@kernel.org> wrote:
> >
> > On Sun, Nov 15, 2020 at 07:52:06PM +0100, Martin Blumenstingl wrote:
> > > Amlogic Meson G12A, G12B and SM1 SoCs have a more advanced RGMII RX
> > > delay register which allows picoseconds precision. Deprecate the old
> > > "amlogic,rx-delay-ns" in favour of a new "amlogic,rgmii-rx-delay-ps"
> > > property.
> > >
> > > For older SoCs the only known supported values were 0ns and 2ns. The new
> > > SoCs have 200ps precision and support RGMII RX delays between 0ps and
> > > 3000ps.
> > >
> > > While here, also update the description of the RX delay to indicate
> > > that:
> > > - with "rgmii" or "rgmii-id" the RX delay should be specified
> > > - with "rgmii-id" or "rgmii-rxid" the RX delay is added by the PHY so
> > >   any configuration on the MAC side is ignored
> > > - with "rmii" the RX delay is not applicable and any configuration is
> > >   ignored
> > >
> > > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > > ---
> > >  .../bindings/net/amlogic,meson-dwmac.yaml     | 61 +++++++++++++++++--
> > >  1 file changed, 56 insertions(+), 5 deletions(-)
> >
> > Don't we have common properties for this now?
> I did a quick:
> $ grep -R rx-delay Documentation/devicetree/bindings/net/
> 
> I could find "rx-delay" without vendor prefix, but that's not using
> any unit in the name (ns, ps, ...)
> Please let me know if you aware of any "generic" property for the RX
> delay in picosecond precision

{rx,tx}-internal-delay-ps in ethernet-controller.yaml and 
ethernet-phy.yaml.
