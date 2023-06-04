Return-Path: <netdev+bounces-7772-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E4A721764
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 15:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AC50281172
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 13:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F2F8AD25;
	Sun,  4 Jun 2023 13:25:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7132E23C6
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 13:25:57 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02D9CA;
	Sun,  4 Jun 2023 06:25:55 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-5147f4bbfdaso5204768a12.0;
        Sun, 04 Jun 2023 06:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685885154; x=1688477154;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bIF2ahGzJpyo+TqeABEPHibTttnCkEMB3Njy7q/BSEo=;
        b=N4P+EYIEs8NjOqM/Dmregn7Jp/GB1iY+W/H4AyYoNezm+92mg9UetM3yHca1fGjhZG
         /4854DPF5NfM/9eUZ9OtKL7xYKYqfH6/WMLcpyDJ99JJIWC0FfbhoAkH+XHa8kN3RGGF
         IinXBa20IFIEGo7ktOSH5SCo/YfLGjirKDKwBFrHvn+ez6wCqftSoQXBZkoAuiR/L6Jz
         SzbrfVawaQrL22pGLzYX+8d3G+1g1r3A5iPwhBFti7nZed3oE+p5csx0oY5Uc1BZRuoG
         UNxEZAE3M3+aQnaFi8fI3iEqLCyTOiU8fHXw+l2wkak1IVi1k9gIAWxEKr0ncVZYwTsn
         3MXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685885154; x=1688477154;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bIF2ahGzJpyo+TqeABEPHibTttnCkEMB3Njy7q/BSEo=;
        b=ZGB9W7aI5Q844+YSO1rX4C1GtxSR+wig231XLfn3UVcneck4ZzXDxlze0qllvLg4Sv
         l9OEivejAcseAzirNY9cTZhdpFxsQst14hbs7mExAZ91vwSAJXty7uKbYcoH29SqzmK6
         kR0Cz1lfVvD6r8DEBxBnMKONJdQ2YzNqE5syitWauZhFVN1OUTCHi21Eejbd9bTRH6dE
         XHXPJ3fRTdjbUhjxFlc9FZ6htCmVyxLqpm8hWc0vPPiJWQ77wLlw9TYQoZcyYuWdT5e2
         QS/L7Z6M6YL5s1ZgAclwMIVhEDZ+yTgFgaH4FEnrdC5rcUARm+zbJhTzi1F9GmA7cwhK
         wsEA==
X-Gm-Message-State: AC+VfDzVld7ElZ/WogiLae2TjSQJLKHPow9ZBqPw8zymgw9c/18c379p
	ebp0f0sS/zOrfm6dO+nN/WA=
X-Google-Smtp-Source: ACHHUZ7Xq1sZH47pNrsamktZ+ZKVyMGi7kuDL7zZxGwL/JJ/n4KR4qPLUyOyVhtiGxlWvPVgPOzNxA==
X-Received: by 2002:a17:907:608c:b0:933:868:413a with SMTP id ht12-20020a170907608c00b009330868413amr4349728ejc.15.1685885153871;
        Sun, 04 Jun 2023 06:25:53 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id x13-20020a170906710d00b0096f694609f3sm3098369ejj.31.2023.06.04.06.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 06:25:53 -0700 (PDT)
Date: Sun, 4 Jun 2023 16:25:50 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com, mithat.guner@xeront.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 08/30] net: dsa: mt7530: change p{5,6}_interface
 to p{5,6}_configured
Message-ID: <20230604132550.zi32bvniqg7ztd5o@skbuf>
References: <20230524175107.hwzygo7p4l4rvawj@skbuf>
 <576f92b0-1900-f6ff-e92d-4b82e3436ea1@arinc9.com>
 <20230526130145.7wg75yoe6ut4na7g@skbuf>
 <7117531f-a9f2-63eb-f69d-23267e5745d0@arinc9.com>
 <ZHsxdQZLkP/+5TF0@shell.armlinux.org.uk>
 <826fd2fc-fbf8-dab7-9c90-b726d15e2983@arinc9.com>
 <ZHyA/AmXmCxO6YMq@shell.armlinux.org.uk>
 <20230604125517.fwqh2uxzvsa7n5hu@skbuf>
 <ZHyMezyKizkz2+Wg@shell.armlinux.org.uk>
 <d269ac88-9923-c00c-8047-cc8c9f94ef2c@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d269ac88-9923-c00c-8047-cc8c9f94ef2c@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 04:14:31PM +0300, Arınç ÜNAL wrote:
> On 4.06.2023 16:07, Russell King (Oracle) wrote:
> > On Sun, Jun 04, 2023 at 03:55:17PM +0300, Vladimir Oltean wrote:
> > > On Sun, Jun 04, 2023 at 01:18:04PM +0100, Russell King (Oracle) wrote:
> > > > I don't remember whether Vladimir's firmware validator will fail for
> > > > mt753x if CPU ports are not fully described, but that would be well
> > > > worth checking. If it does, then we can be confident that phylink
> > > > will always be used, and those bypassing calls should not be necessary.
> > > 
> > > It does, I've just retested this:
> > > 
> > > [    8.469152] mscc_felix 0000:00:00.5: OF node /soc/pcie@1f0000000/ethernet-switch@0,5/ports/port@4 of CPU port 4 lacks the required "phy-handle", "fixed-link" or "managed" properties
> > > [    8.494571] mscc_felix 0000:00:00.5: error -EINVAL: Failed to register DSA switch
> > > [    8.502151] mscc_felix: probe of 0000:00:00.5 failed with error -22
> > 
> > ... which isn't listed in dsa_switches_apply_workarounds[], and
> > neither is mt753x. Thanks.
> > 
> > So, that should be sufficient to know that the CPU port will always
> > properly described, and thus bypassing phylink in mt753x for the CPU
> > port should not be necessary.
> 
> Perfect! If I understand correctly, there's this code - specific to MT7531
> and MT7988 ports being used as CPU ports - which runs in addition to what's
> in mt753x_phylink_mac_config():
> 
> 	mt7530_write(priv, MT7530_PMCR_P(port),
> 		     PMCR_CPU_PORT_SETTING(priv->id));
> 
> This should be put on mt753x_phylink_mac_config(), under priv->id ==
> ID_MT7531, priv->id == ID_MT7988, and dsa_is_cpu_port(ds, port) checks?
> 
> Arınç

Given that mt753x_phylink_mac_config() and mt753x_phylink_mac_link_up() also
both modifies MT7530_PMCR_P(port), have you studied the code to see what
really is changed compared to what's in the PMCR_CPU_PORT_SETTING() macro,
after both phylink methods have run?

