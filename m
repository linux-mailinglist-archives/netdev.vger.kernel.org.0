Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3902A689EF3
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 17:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbjBCQPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 11:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbjBCQO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 11:14:56 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC8092EDA;
        Fri,  3 Feb 2023 08:14:55 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C8DDE5C0109;
        Fri,  3 Feb 2023 11:14:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 03 Feb 2023 11:14:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675440893; x=1675527293; bh=ZsTfWTfG+sKlRejLobl9gKT+7jxs
        vBf1Pr6YqiH/tfc=; b=fpwVXDIw98vLEX4I2DHTFp1G2HYcxx39hLDAmQtzN3ej
        rM4DwBU7iCWaWBA56FL5KJiPqoSa2aKno4iZTyJEtpIlVpN2EQREF6y5bK7KLds3
        p+vw/kvvtH7VTMIV/EPGtNIDiRmcCW7NnRUliQcNZPIxDdEC3RNnsVH8K08hpGlT
        3uy9234605kg27fNMWtfgPZmo9+3cN6Rjtg5fBvNvVpiDm9lSmtz1E9Qbo3yXRGW
        shHNi1kLjWQr5RgxuQHzZBtu7f1uEVGhrQ+2AmB0UCfTo2sPjxBf4jpJ1VOemO8x
        X1h+myMj/y9VmgCW+mczgf1jAAsFCk6nh13/y8dyZw==
X-ME-Sender: <xms:_DLdYzu7X6oVmRfm3q90esmij_lttZP9-kqc74YnrC6vFCWk2a-Y7Q>
    <xme:_DLdY0fWU5m6e2R2npEvbQQSwloV1CYUaPViAgc0XYBvy7LUKRTOgjAf2-i873vYm
    eqHln_quXBBfvQ>
X-ME-Received: <xmr:_DLdY2xeCq609omG-m6DlStWSL-RrikRtKOd4bN_GLO3VdADDVl7aM-AmZtFOvvEibCiOz9sDcj1TMmebxXs65MY2zo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudegtddgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefhtdejvdeiffefudduvdffgeetieeigeeugfduffdvffdtfeehieejtdfh
    jeeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:_DLdYyOosmO3_ufDbHOtNTbmGiHwZWPDwn3ixU4kuoGRx4yd-Rg-gA>
    <xmx:_DLdYz_NqIypcR8Ze3yUQ0loUTLyTtMoMtAgcZcNkPQTRspogLLarg>
    <xmx:_DLdYyWaQOWe0MAzlK-Rp3NVvL38OX5ooM5tHtlkyyHszhCp932ozg>
    <xmx:_TLdY_IJkxBTC5LxI1faRSzYKzdNsc0OITEhUSgU1w3O0JuGHd0sWA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Feb 2023 11:14:51 -0500 (EST)
Date:   Fri, 3 Feb 2023 18:14:46 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 1/5] net: bridge: add dynamic flag to switchdev
 notifier
Message-ID: <Y90y9u+4PxWk4b9E@shredder>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-2-netdev@kapio-technology.com>
 <Y9qrAup9Xt/ZDEG0@shredder>
 <f27dd18d9d0b7ff8b693af8a58ea8616@kapio-technology.com>
 <Y9vgz4x/O+dIp+0/@shredder>
 <766efaf94fcb6362c5ceb176ad7955f1@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <766efaf94fcb6362c5ceb176ad7955f1@kapio-technology.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 05:38:06PM +0100, netdev@kapio-technology.com wrote:
> On the first question please look here:
> https://lore.kernel.org/netdev/20230119134045.fqdt6zrna5x3iavt@skbuf/

It seems Vladimir also wants the new field to be named 'is_static'
instead of 'is_dyn'. In your reason you mention
'SWITCHDEV_FDB_ADD_TO_BRIDGE', but this is not the interesting case for
the field. This event is used for devices to notify the bridge on new
learned entries. The bridge marks them as "extern_learn" which means
that "dynamic" / "static" flags are irrelevant.

The interesting case for the new field is the bridge to device direction
('SWITCHDEV_FDB_ADD_TO_DEVICE'). Drivers need to be patched to take the
new field into account when deciding the policy to program the entry
with. They can do it just as well if you name the new field 'is_static'
instead of 'is_dyn'.

> On the second question it is what Oltean pointed out to me here...
> https://lore.kernel.org/netdev/20230118230135.szu6a7kvt2mjb3i5@skbuf/
> 
> Oltean says there:
> "This is not true, because it assumes that DSA never called port_fdb_add()
> up until now for bridge FDB entries with the BR_FDB_STATIC flag unset,
> which is incorrect (it did)."
> 
> Though as I see it, if it is only from the DSA layer on, the new is_dynamic
> flag would not be set anyway in the case he references. And as can be seen
> the change is in the bridge layer, as the rest is just propagating the flag,
> but it ensures that to set this flag that it comes from the user adding an
> FDB entry.

OK, so can't this hunk:

```
	if (fdb_info->is_dyn)
		fdb_flags |= DSA_FDB_FLAG_DYNAMIC;
```

Become:

```
	if (fdb_info->is_dyn && !fdb_info->added_by_user)
		fdb_flags |= DSA_FDB_FLAG_DYNAMIC;
```

?

Then there is no need to fold 'added_by_user' into 'is_dyn' in the
bridge driver. I *think* this is the change Vladimir asked you to do.
