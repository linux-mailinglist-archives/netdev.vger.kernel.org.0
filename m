Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F31624989D
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 10:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgHSIvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 04:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgHSIv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 04:51:27 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195B0C061757;
        Wed, 19 Aug 2020 01:51:27 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o23so25390289ejr.1;
        Wed, 19 Aug 2020 01:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bD/V3oHfC4mdtWiSnBHrHT7AWlw0/W7HDJQKVaZ6gTQ=;
        b=Ff3F/qoQER5XqG2ymWUd9ZJ7yj+Zot/32PJuaO2OyxWsWxHuNTebKo7DrvpNvVGrPf
         W32vBZUXYuusDfszlWGS1H4YXohfvIPZTNIZJPo8DrM3drsyJbjOEymISGUhEuIAjBU+
         hr3SCeaZoE2zn8M+J7bLanCAO6TVJ2KbYsj8qEzT7+bzF/Syn9PyahzY8VeiDONWiNYs
         rQr+x7oF9ECjT3NcrNdj5jgiDY9sgOOd6W8SOGe7nGVsPv3caAp0++7luCjL/vXcXO0G
         ySp3ZCW7CPUc+E/LPpgchLRQXgZ09C2d+yoDIk9/9j1uuTm2xu6hlTp7Smzxybpyd0sa
         7SHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bD/V3oHfC4mdtWiSnBHrHT7AWlw0/W7HDJQKVaZ6gTQ=;
        b=uRoYkdANFR9pPDed9WeUwC3eITH0mrNpJJNuKouwDjKj4E/S4gFKXAx6woNZpyjCX8
         queE6V+CdzK8+YrdzCXG+rgf5BODXn1rTblNdsiJsfIxFIQh2MAUqFunVch6B7Yzd8xZ
         GNkv5mDOfqpCAG05PGfcBdVfsv/wFkw6jf7BYGUxsCIgjO7+K6UhB6eIeOfeIuF4nfEh
         X65VkLCd5/1fs517DMcDkCgwJSQaJv323AWyOca/y0iR9YPhyraIlBXpvTrlEJhYom+d
         Be/de4McUG0TigPCKVlnwJEutEEpRh3Bm3umsjN9TCYiGMsY9OKJr4PH6wWL6hXGyHEa
         QhHA==
X-Gm-Message-State: AOAM531flpGJ+qnOU34UF/JzOGauA2V1gef8bnxycnnSNpubJOiewtAw
        /cR3YUiujohcGeMqfYxSEksfORkCsLg=
X-Google-Smtp-Source: ABdhPJwrCnrpCpI8Yx0K36plyOiwgjN7xbPdj34hvXofbPZKcbYpCn7GyAv9vKT6M42mUOsPcIvEQw==
X-Received: by 2002:a17:907:40bf:: with SMTP id nu23mr23780441ejb.243.1597827085771;
        Wed, 19 Aug 2020 01:51:25 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id cm22sm17791480edb.44.2020.08.19.01.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 01:51:25 -0700 (PDT)
Date:   Wed, 19 Aug 2020 11:51:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@savoirfairelinux.com" 
        <vivien.didelot@savoirfairelinux.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sean Wang <Sean.Wang@mediatek.com>,
        "opensource@vdorst.com" <opensource@vdorst.com>,
        "frank-w@public-files.de" <frank-w@public-files.de>,
        "dqfext@gmail.com" <dqfext@gmail.com>
Subject: Re: [PATCH net-next v2 7/7] arm64: dts: mt7622: add mt7531 dsa to
 bananapi-bpi-r64 board
Message-ID: <20200819085122.wiuq3fi23rebja6d@skbuf>
References: <cover.1597729692.git.landen.chao@mediatek.com>
 <2a986604b49f7bfbee3898c8870bb0cf8182e879.1597729692.git.landen.chao@mediatek.com>
 <20200818162433.elqh3dxmk6vilq6u@skbuf>
 <1597824901.31846.42.camel@mtksdccf07>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597824901.31846.42.camel@mtksdccf07>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 04:15:01PM +0800, Landen Chao wrote:
> On Wed, 2020-08-19 at 00:24 +0800, Vladimir Oltean wrote:
> > On Tue, Aug 18, 2020 at 03:14:12PM +0800, Landen Chao wrote:
> > > Add mt7531 dsa to bananapi-bpi-r64 board for 5 giga Ethernet ports support.
> > > 
> > > Signed-off-by: Landen Chao <landen.chao@mediatek.com>
> > > ---
> > >  .../dts/mediatek/mt7622-bananapi-bpi-r64.dts  | 44 +++++++++++++++++++
> > >  1 file changed, 44 insertions(+)
> > > 
> > > diff --git a/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts b/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
> > > index d174ad214857..c57b2571165f 100644
> > > --- a/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
> > > +++ b/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
> > > @@ -143,6 +143,50 @@
> > >  	mdio: mdio-bus {
> > >  		#address-cells = <1>;
> > >  		#size-cells = <0>;
> > > +
> > > +		switch@0 {
> > > +			compatible = "mediatek,mt7531";
> > > +
> [snip]
> > > +				port@6 {
> > > +					reg = <6>;
> > > +					label = "cpu";
> > > +					ethernet = <&gmac0>;
> > > +					phy-mode = "2500base-x";
> > > +				};
> > 
> > Is there any reason why you're not specifying a fixed-link node here?
> I got the below feedback in v1, so I follow the DSA common design in v2.
> v2 can work with fixed-link node or without fixed-link node in CPU port
> node.
> 
>   "This fixed-link should not be needed. The DSA driver is supposed to
>    configure the CPU port to its fastest speed by default. 2500 is
>    the fastest speed a 2500Base-X link can do..."

See this discussion and the replies to it:

https://www.spinics.net/lists/netdev/msg630102.html

I think if mt7530 is using phylink for non-netdev ports (and it is), it
would be good to have standard bindings that phylink can parse. For
example, in lack of a "pause" specifier, will the CPU port use flow
control or won't it? Why? I think there's simply no good reason why
you'd omit 3 more lines now.

> > > +			};
> > > +		};
> > > +
> > >  	};
> > >  };
> > >  
> > > -- 
> > > 2.17.1
> > 
> > Thanks,
> > -Vladimir
> 

-Vladimir
