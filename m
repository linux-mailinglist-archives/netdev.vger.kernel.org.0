Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7795E57C058
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 00:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiGTW47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 18:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiGTW46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 18:56:58 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864983AE6B;
        Wed, 20 Jul 2022 15:56:57 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id b11so71779eju.10;
        Wed, 20 Jul 2022 15:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g4MvgsP4srg9f8E2HWMF3FD8P6Q9jUuZxC4vOXa9tjY=;
        b=Ko5J0JM40COndr6nYcLGfiin1SEVsO15qiCVzL5YOseZ6mmoOQSCQi0AYxw9YAnpF8
         Gr4/1p1cCKG4kt6SJeODxCrHnDo7aecB4EGQaIUxJIYtwdHE1e0kuLwkgs/jQDdvGY6N
         iKuCHuM8Lv6bGQewHojd1VFz0K3HBU58Zv36dhB994g2LslYiRxfpPfjHfbFU5W+01kM
         LTKIzfT3yiT96KcFPmp5q6oJu83L30OZ7oMynHD0biZzCXl9O+1NWvz/uBqGU0roPrw/
         GxtkzBC2TN0MtF9QEbPghAANVW2tgtQ+bAlJlCdBZuwq7Pp4tqtox2H8vWxC4c8WBz22
         5HYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g4MvgsP4srg9f8E2HWMF3FD8P6Q9jUuZxC4vOXa9tjY=;
        b=BWZ+Dx6Xi19oKoeViGOdXmHU6zZrJpckAGzsQLFPLGqfDmh2F9sqUZySZJRM8nF8dL
         m3RdqmmFWzl4gRArtBTdLYzbj+TilgqbRjS3wgOGbWgeb/g7iqPFvrOJTCpyxVJSreLx
         4LM3qDKQ5sXyY2q43y89+6QheYsUeQPV3NOynN06O/zvilDQOmcTwK+pL/9TTgZyeUUI
         3K0x3vc1v5ARDEv9QgHZ4G2u7M864wacX4zYX9yoaG3bm2CPOdqz7jrWzrk4flj704Nt
         TB1Byd+5zSsFf7ZCu3e3Ij/XzWNCOYlfi39+AADS85WR9WtZXdguc70d/mmElpC3QKvs
         hZsA==
X-Gm-Message-State: AJIora96HcUg3d9zjlTLoM4pgITTj3i5t7MSb6pdOBocFzIXw3d4ZD9I
        +xRQPWZTCMC/vAtugvFu4Ao=
X-Google-Smtp-Source: AGRyM1sEjwZqpdJnhnIi/sybxziNdCXoqRVcRlhVQNFjiWCgtSwmMYgElHOvt4zxzelhEKIf5A6ggg==
X-Received: by 2002:a17:907:1b16:b0:72b:8c16:dac0 with SMTP id mp22-20020a1709071b1600b0072b8c16dac0mr36517314ejc.286.1658357816062;
        Wed, 20 Jul 2022 15:56:56 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id kw2-20020a170907770200b0072b609d9a36sm161874ejc.16.2022.07.20.15.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 15:56:55 -0700 (PDT)
Date:   Thu, 21 Jul 2022 01:56:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 2/6] software node: allow named software node to
 be created
Message-ID: <20220720225652.4uo6fcdcunenej3j@skbuf>
References: <20220715201715.foea4rifegmnti46@skbuf>
 <YtHPJNpcN4vNfgT6@smile.fi.intel.com>
 <20220715204841.pwhvnue2atrkc2fx@skbuf>
 <YtVSQI5VHtCOTCHc@smile.fi.intel.com>
 <YtVfppMtW77ICyC5@shell.armlinux.org.uk>
 <YtWp3WkpCtfe559l@smile.fi.intel.com>
 <YtWwbMucEyO+W8/Y@shell.armlinux.org.uk>
 <YtW9goFpOLGvIDog@smile.fi.intel.com>
 <YtXE0idsKe6FZ+n4@shell.armlinux.org.uk>
 <YtZwU9BKAO/WSRmK@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtZwU9BKAO/WSRmK@paasikivi.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sakari,

On Tue, Jul 19, 2022 at 08:50:27AM +0000, Sakari Ailus wrote:
> Basically what your patch is doing is adding a helper function that creates
> an fwnode with a given name. This functionality was there previously through
> software_node_register_nodes(), with node allocation responsibility residing
> on the caller. It's used e.g. here:
> drivers/media/pci/intel/ipu3/cio2-bridge.c .
> 
> The larger question is perhaps when can you safely remove software nodes.
> And which of these two APIs would be preferred. I haven't checked how many
> users each has. There's no refcounting nor locking for software nodes, so
> once made visible to the rest of the kernel, they're always expected to be
> there, unchanged, or at least it needs to be known when they can be removed.

Just for my clarity, are you saying that this printf selftest is
violating the software nodes' expectation to always be there unchanged
and never be removed?

static void __init fwnode_pointer(void)
{
	const struct software_node softnodes[] = {
		{ .name = "first", },
		{ .name = "second", .parent = &softnodes[0], },
		{ .name = "third", .parent = &softnodes[1], },
		{ NULL /* Guardian */ }
	};
	const char * const full_name = "first/second/third";
	const char * const full_name_second = "first/second";
	const char * const second_name = "second";
	const char * const third_name = "third";
	int rval;

	rval = software_node_register_nodes(softnodes);
	if (rval) {
		pr_warn("cannot register softnodes; rval %d\n", rval);
		return;
	}

	test(full_name_second, "%pfw", software_node_fwnode(&softnodes[1]));
	test(full_name, "%pfw", software_node_fwnode(&softnodes[2]));
	test(full_name, "%pfwf", software_node_fwnode(&softnodes[2]));
	test(second_name, "%pfwP", software_node_fwnode(&softnodes[1]));
	test(third_name, "%pfwP", software_node_fwnode(&softnodes[2]));

	software_node_unregister_nodes(softnodes);
}

The use case in this patch set is essentially equivalent to what printf
does: exposing the software nodes to the rest of the kernel and to user
space is probably not necessary, it's just that we need to call a
function that parses their structure (essentially an equivalent to
calling "test" above). Could you indicate whether there is a better
alternative of doing this?
