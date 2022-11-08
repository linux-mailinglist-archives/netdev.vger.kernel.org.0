Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A864620BD3
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbiKHJM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbiKHJMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:12:25 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4A81EAC6
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 01:12:24 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id v27so21480749eda.1
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 01:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4HOVgEjxwcFCQc0zCu4SmIeyaJ/ziMQ20WmcNjRKP6Q=;
        b=N5Z5ElZW0PjiIyubbH7byooqEpswR8r+BpH/THhAF/C0j9khOqa3CqNelrpiSKqYdj
         +Vap44IVXMhtCRdiOeA5AM8qZALskMC8M3dN2tjqanFYU4APVJw3jk9JF085B7nKDTk+
         OXikOKkkmaD+4EvkrBMVQtbwKpON/ktE+c+yjFlLyJma8OgLzFL8SHVLw1FSLHclxxsT
         VC7yJ/oaUA/tPc7Q9KayrsAyQqjsLhrI7CDQpV0Mery4971uO0cC2cAtqLSnJKIC4X8D
         nSJTpgFMa5RpCMOmP/cvGX0xwnWB3cICDf+oAKVhGWnQS1M8yewYKt9yssuThFuNugX8
         ZuIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HOVgEjxwcFCQc0zCu4SmIeyaJ/ziMQ20WmcNjRKP6Q=;
        b=lfWmtDYBkzDYlMdTwrEmDKgZenWblsJLr2GAC3q7FN9YAw2KTzXy48tb3a8nu2ZWmv
         L9gFkF6F+tJkwpGzy0Dm3xwKjmgnIBx2UfM+0xbBdLsXYvRLbXYUzwV43gjJeij0Uva1
         ICXDSknn6A5TvSb2EkNj1u+CsqEFwdrlBP7q55+Dininjkf+3RmuNr0Oe72zsWOFtTTO
         BvEqnrDGbjzIv6/dXPsexjT533XE1Wy7O/pqbqFSAJZ+tReqoIZvqjkczMvXgZmks2Na
         t245YZnjTQ+23VIpoFD49+3Wq2Pd16370PKYyM1kFOkiOcZV2VnguWnp4PBQIFUMQY5i
         OtcA==
X-Gm-Message-State: ACrzQf0e9LBqocYcoiU+5jLqh4+fIcJTe9aEecBQZFoNX6lZPGdIeUWi
        221OWwE1eCHuRyTZAYo8Kh4=
X-Google-Smtp-Source: AMsMyM68bt94n6/5lq7G4kqninglhKBZbxEROaoL1ccJJPMD7Qs31VO5xP3GUoBxFONOwY0UEdkFdw==
X-Received: by 2002:a05:6402:1e89:b0:461:a8b5:402a with SMTP id f9-20020a0564021e8900b00461a8b5402amr56046283edf.336.1667898743097;
        Tue, 08 Nov 2022 01:12:23 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id 1-20020a170906308100b007a97a616f3fsm4393854ejv.196.2022.11.08.01.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 01:12:22 -0800 (PST)
Date:   Tue, 8 Nov 2022 11:12:20 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH 3/9] net: dsa: mv88e6xxx: implement get_phy_address
Message-ID: <20221108091220.zpxsduscpvgr3zna@skbuf>
References: <20221108082330.2086671-1-lukma@denx.de>
 <20221108082330.2086671-4-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108082330.2086671-4-lukma@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 09:23:24AM +0100, Lukasz Majewski wrote:
> From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> 
> Avoid the need to specify a PHY for each physical port in the device tree
> when phy_base_addr is not 0 (6250 and 6341 families).
> 
> This change should be backwards-compatible with existing device trees,
> as it only adds sensible defaults where explicit definitions were
> required before.
> 
> Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

Needs your Signed-off-by tag as well.

> ---

Would it be possible to do like armada-3720-turris-mox.dts does, and put
the phy-handle in the device tree, avoiding the need for so many PHY
address translation quirks?

If you're going to have U-Boot support for this switch as well, the
phy-handle mechanism is the only thing that U-Boot supports, so device
trees written in this way will work for both (and can be passed by
U-Boot to Linux):

	switch1@11 {
		compatible = "marvell,mv88e6190";
		reg = <0x11>;
		dsa,member = <0 1>;
		interrupt-parent = <&moxtet>;
		interrupts = <MOXTET_IRQ_PERIDOT(1)>;
		status = "disabled";

		mdio {
			#address-cells = <1>;
			#size-cells = <0>;

			switch1phy1: switch1phy1@1 {
				reg = <0x1>;
			};

			switch1phy2: switch1phy2@2 {
				reg = <0x2>;
			};

			switch1phy3: switch1phy3@3 {
				reg = <0x3>;
			};

			switch1phy4: switch1phy4@4 {
				reg = <0x4>;
			};

			switch1phy5: switch1phy5@5 {
				reg = <0x5>;
			};

			switch1phy6: switch1phy6@6 {
				reg = <0x6>;
			};

			switch1phy7: switch1phy7@7 {
				reg = <0x7>;
			};

			switch1phy8: switch1phy8@8 {
				reg = <0x8>;
			};
		};

		ports {
			#address-cells = <1>;
			#size-cells = <0>;

			port@1 {
				reg = <0x1>;
				label = "lan9";
				phy-handle = <&switch1phy1>;
			};

			port@2 {
				reg = <0x2>;
				label = "lan10";
				phy-handle = <&switch1phy2>;
			};

			port@3 {
				reg = <0x3>;
				label = "lan11";
				phy-handle = <&switch1phy3>;
			};

			port@4 {
				reg = <0x4>;
				label = "lan12";
				phy-handle = <&switch1phy4>;
			};

			port@5 {
				reg = <0x5>;
				label = "lan13";
				phy-handle = <&switch1phy5>;
			};

			port@6 {
				reg = <0x6>;
				label = "lan14";
				phy-handle = <&switch1phy6>;
			};

			port@7 {
				reg = <0x7>;
				label = "lan15";
				phy-handle = <&switch1phy7>;
			};

			port@8 {
				reg = <0x8>;
				label = "lan16";
				phy-handle = <&switch1phy8>;
			};

			switch1port9: port@9 {
				reg = <0x9>;
				label = "dsa";
				phy-mode = "2500base-x";
				managed = "in-band-status";
				link = <&switch0port10>;
			};

			switch1port10: port@a {
				reg = <0xa>;
				label = "dsa";
				phy-mode = "2500base-x";
				managed = "in-band-status";
				link = <&switch2port9>;
				status = "disabled";
			};

			port-sfp@a {
				reg = <0xa>;
				label = "sfp";
				sfp = <&sfp>;
				phy-mode = "sgmii";
				managed = "in-band-status";
				status = "disabled";
			};
		};
	};
