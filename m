Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE6A6ADD9B
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjCGLia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjCGLiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:38:09 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFF57BA0C;
        Tue,  7 Mar 2023 03:37:34 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id cw28so50972223edb.5;
        Tue, 07 Mar 2023 03:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678189051;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ylf/mq//lzVCs2kUwljoL1tKekI4ibQM03In0NCDXLs=;
        b=qfmrPmJWAlfuCrezU2zfyKjyPn1k15H8+DCWstzdR9q7Zdiw4p9EkGmXZLB4rvVaxO
         M8aFDlQU0WuJpCglA1/MTurm/Fs9mO0a+9M0rnn9YBsCoecDZZdUCH1MKo8ioElHt93f
         LdvcbQrlXKmKTsXvH8qoi1c65T3TCx06by9wDB+/WdkF0dTci6q8qBJA1mEGeXcrmETM
         9walOuPtXw//rddNM/yep3yIj5xNMptphS89eB4FnFz220hagzMKv6bYNHwX7TwaiQVz
         9OuJYAvcafUDxLF1MLy+SH6LBdjtUEOuUysIHYZUbz/sp/4emVJ/sBewjMfBmXO+CS9m
         eRDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678189051;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ylf/mq//lzVCs2kUwljoL1tKekI4ibQM03In0NCDXLs=;
        b=gJj9ajSheTUgF/VVbiBoqVDRQgSRZI82QgbNHnDvVKJQkWtVuuuVMDTVLX+q2GdYLZ
         zZAGWvxb3GtdIIkHqJHrGgTElyq9viwofDBbmACsdOAM9qHHuY5joeEsaoRZWgLvfNoo
         JiZ/nijf6hpLLPeDQR+FB5p8jrGbS8v1LIiFB3bKmOkDAmB46kdbYyNqb3RouVOddZVa
         MQ9HBAl8QEd9gwDXIvmEcRDF74xJkNEeo6uUxO0NwLLI+JIRQBZuT3othKx+J0Ixziat
         Y3Rw7pIT2CdM9dllc6dkcn40S8moObNwoZg4dT3qC3sYYN+MTXdTE3GvTekr1l3vzvS+
         6yHQ==
X-Gm-Message-State: AO0yUKUd/kAFxa+RFYnvC1lu9IVdPDilD1p5e7qNDj5nQhr58GCKv8ci
        TJo91UesZA3+l5N3h0cD+pM=
X-Google-Smtp-Source: AK7set+q9vyTDat0wK16qtvlKptYHYpRS/dTB7ZGYkMsDFFHqZU8dAjrdZF/YlQjZziUdW9i2UzcXA==
X-Received: by 2002:a17:906:1317:b0:88d:d304:3433 with SMTP id w23-20020a170906131700b0088dd3043433mr14026907ejb.67.1678189051410;
        Tue, 07 Mar 2023 03:37:31 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id q27-20020a17090622db00b008b1787ce722sm5939973eja.152.2023.03.07.03.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 03:37:31 -0800 (PST)
Date:   Tue, 7 Mar 2023 13:37:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Alexander Couzens <lynxis@fe80.eu>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH net] net: dsa: mt7530: move PLL setup out of port 6
 pad configuration
Message-ID: <20230307113728.4lg6xqfhj5szcpd3@skbuf>
References: <20230304125453.53476-1-arinc.unal@arinc9.com>
 <20230304125453.53476-1-arinc.unal@arinc9.com>
 <20230306154552.26o6sbwf3rfekcyz@skbuf>
 <65f84ef3-8f72-d823-e6f9-44d33a953697@arinc9.com>
 <20230306201905.yothcuxokzlk3mcq@skbuf>
 <a8ad9299-1f9f-e184-4429-eef9950e22d8@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a8ad9299-1f9f-e184-4429-eef9950e22d8@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 02:26:08PM +0300, Arınç ÜNAL wrote:
> Port 5 as CPU port works fine with this patch. I completely removed from
> port 6 phy modes.
> 
> With your patch on MT7621 (remember port 5 always worked on MT7623):
> 
> - Port 5 at rgmii as the only CPU port works, even though the PLL frequency
> won't be set. The download/upload speed is not affected.

That's good. Empirically it seems to prove that ncpo1 only affects p6,
which was my initial assumption.

> - port 6 at trgmii mode won't work if the PLL frequency is not set. The
> SoC's MAC (gmac0) won't receive anything. It checks out since setting the
> PLL frequency is put under the "Setup the MT7530 TRGMII Tx Clock" comment.
> So port 6 cannot properly transmit frames to the SoC's MAC.
> 
> - Port 6 at rgmii mode works without setting the PLL frequency. Speed is not
> affected.
> 
> I commented out core_write(priv, CORE_PLL_GROUP5,
> RG_LCDDS_PCW_NCPO1(ncpo1)); to stop setting the PLL frequency.
> 
> In conclusion, setting the PLL frequency is only needed for the trgmii mode,
> so I believe we can get rid of it on other cases.

Got it, sounds expected, then? My patch can be submitted as-is, correct?

> One more thing, on MT7621, xtal matches to both HWTRAP_XTAL_40MHZ and
> HWTRAP_XTAL_25MHZ so the final value of ncpo1 is 0x0a00. I'm not sure if
> xtal matching both of them is the expected behaviour.
> 
> > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > index fbf27d4ab5d9..12cea89ae0ac 100644
> > --- a/drivers/net/dsa/mt7530.c
> > +++ b/drivers/net/dsa/mt7530.c
> > @@ -439,8 +439,12 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
> >  			/* PLL frequency: 150MHz: 1.2GBit */
> >  			if (xtal == HWTRAP_XTAL_40MHZ)
> >  				ncpo1 = 0x0780;
> > +				dev_info(priv->dev, "XTAL is 40MHz, ncpo1 is 0x0780\n");

In the C language, you need to put brackets { } around multi-statement
"if" blocks. Otherwise, despite the indentation, "dev_info" will be
executed unconditionally (unlike in Python for example). There should
also be a warning with newer gcc compilers about the misleading
indentation not leading to the expected code.

Like this:

			if (xtal == HWTRAP_XTAL_40MHZ) {
				ncpo1 = 0x0780;
				dev_info(priv->dev, "XTAL is 40MHz, ncpo1 is 0x0780\n");
			}

> >  			if (xtal == HWTRAP_XTAL_25MHZ)
> >  				ncpo1 = 0x0a00;
> > +				dev_info(priv->dev, "XTAL is 25MHz, ncpo1 is 0x0a00\n");
> > +			if (xtal == HWTRAP_XTAL_20MHZ)
> > +				dev_info(priv->dev, "XTAL is 20MHz too\n");
> >  		} else { /* PLL frequency: 250MHz: 2.0Gbit */
> >  			if (xtal == HWTRAP_XTAL_40MHZ)
> >  				ncpo1 = 0x0c80;
> 
> > [    0.710455] mt7530 mdio-bus:1f: MT7530 adapts as multi-chip module
> > [    0.734419] mt7530 mdio-bus:1f: configuring for fixed/rgmii link mode
> > [    0.741766] mt7530 mdio-bus:1f: Link is Up - 1Gbps/Full - flow control rx/tx
> > [    0.743647] mt7530 mdio-bus:1f: configuring for fixed/trgmii link mode
> > [    0.755422] mt7530 mdio-bus:1f: XTAL is 40MHz, ncpo1 is 0x0780
> > [    0.761250] mt7530 mdio-bus:1f: XTAL is 25MHz, ncpo1 is 0x0a00
> > [    0.769414] mt7530 mdio-bus:1f: Link is Up - 1Gbps/Full - flow control rx/tx
> > [    0.772067] mt7530 mdio-bus:1f lan1 (uninitialized): PHY [mt7530-0:00] driver [MediaTek MT7530 PHY] (irq=17)
> > [    0.788647] mt7530 mdio-bus:1f lan2 (uninitialized): PHY [mt7530-0:01] driver [MediaTek MT7530 PHY] (irq=18)
> > [    0.800354] mt7530 mdio-bus:1f lan3 (uninitialized): PHY [mt7530-0:02] driver [MediaTek MT7530 PHY] (irq=19)
> > [    0.812031] mt7530 mdio-bus:1f lan4 (uninitialized): PHY [mt7530-0:03] driver [MediaTek MT7530 PHY] (irq=20)
> > [    0.823418] mtk_soc_eth 1e100000.ethernet eth1: entered promiscuous mode
> > [    0.830250] mtk_soc_eth 1e100000.ethernet eth0: entered promiscuous mode
> > [    0.837007] DSA: tree 0 setup
> 
> Thunderbird limits lines to about 72 columns, so I'm pasting as quotation
> which seems to bypass that.

That seems to have worked, but shouldn't have been needed. I've uninstalled
Thunderbird in favor of mutt + vim for email editing.. although, isn't
there a Word Wrap option which you can just turn off?
