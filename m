Return-Path: <netdev+bounces-12205-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CBC3736B1C
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:37:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B2CE1C20BFC
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4624314A86;
	Tue, 20 Jun 2023 11:37:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF84101F3
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 11:37:36 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99096E71
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:37:35 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-985b04c46caso689491866b.0
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687261054; x=1689853054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NMEE90c0IBCsD7LFJml/8sjFvnyhPhrZRee5xwU8p18=;
        b=YhzEpMbKMHwsrlCHb2OiBdLczNYisw667ZaO54Vx+gWdv5M7tCIjzqj+pmEGzSVkpC
         uVnLUgz4vv+isJhfOseNzywZy63puf/qDE6wOgcgzxi28Y3CnoJL0yagN6gKv924t1CB
         yzhY9RSljfpoRhAfDMjqiM8ORlAdrfPuCyuc9amRXfE1Dx1oYNUrzpUFv70xd33TSQ+4
         mlp/xs0JQgSRcV0n0NQV2jZ0bxLcnimtycPKHFYPEPRIM4/b8b+G5EWbcPC3yszgLGMY
         kk7KcHB9/iFPD97Zu6bIBS87HaN8ARteuU1PVtMWmLiiC1mR2sWUxOmj+rbEC3TttTdA
         ysFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687261054; x=1689853054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NMEE90c0IBCsD7LFJml/8sjFvnyhPhrZRee5xwU8p18=;
        b=dBLZWOgXB49PBIDLN+DYkdg35rndy77qzxFdgb1bDxc5d8MONe8xPXyntsEcSwkJuz
         GkvKALcJq1dq+ggftbl7Sj03BwZoNYtk8M4TUbCGlK86IwKXyE4d1LI+4wQ91/kdp9ab
         bvrhZYqrABG3ps4Bc7SDPLp2l9X+WAXT3lAb4IF+9g8pZYNUg7Vl6LWOeqJwNpqjcjhp
         hc4hBEjmbgYXfK05Ll6PEmzb+InnaQaeRo80CcXInktTOBb0o0VilRnnfbhl6w5uQ2KZ
         36l1JjylPNNzrJuKgbhj6OQTCwVQwkP4KGnbKOMUrs62CqWBEEfQBu5eNsFe534ps9zd
         F7UQ==
X-Gm-Message-State: AC+VfDywrjVIjrD6UapeWPQ4wIa6VDc4XKfjfxJIwP97Qf4a89P3lmLm
	k1eTaY07NM1vqJT9ksxOuNc=
X-Google-Smtp-Source: ACHHUZ5veFArsAZT5CFKWDJY/4wZm+8ltgJGaFy7RSjrs+WnWtSf4Ehl3eahOvaNGQbhPtI/d68pOA==
X-Received: by 2002:a17:906:58ce:b0:988:ffb9:b944 with SMTP id e14-20020a17090658ce00b00988ffb9b944mr2666267ejs.29.1687261053855;
        Tue, 20 Jun 2023 04:37:33 -0700 (PDT)
Received: from skbuf ([188.25.159.134])
        by smtp.gmail.com with ESMTPSA id y9-20020a17090668c900b009891f667b7bsm1102540ejr.214.2023.06.20.04.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 04:37:33 -0700 (PDT)
Date: Tue, 20 Jun 2023 14:37:30 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Alexander Couzens <lynxis@fe80.eu>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Cc@web.codeaurora.org:Claudiu Beznea <claudiu.beznea@microchip.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	DENG Qingfang <dqfext@gmail.com>, Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Madalin Bucur <madalin.bucur@nxp.com>,
	Marcin Wojtas <mw@semihalf.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Michal Simek <michal.simek@amd.com>, netdev@vger.kernel.org,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 01/15] net: phylink: add PCS negotiation mode
Message-ID: <20230620113730.vm2buvcifdcvhujb@skbuf>
References: <ZIxQIBfO9dH5xFlg@shell.armlinux.org.uk>
 <E1qA8De-00EaFA-Ht@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1qA8De-00EaFA-Ht@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 01:06:22PM +0100, Russell King (Oracle) wrote:
> @@ -443,6 +526,7 @@ struct phylink_pcs_ops;
>   */
>  struct phylink_pcs {
>  	const struct phylink_pcs_ops *ops;
> +	bool neg_mode;
>  	bool poll;
>  };

I deleted one of my own comments while trimming the email... Yay me :)

Would it be more appropriate to name this "bool pass_neg_mode" to avoid
a naming collision between "bool neg_mode" and "unsigned int neg_mode"?

