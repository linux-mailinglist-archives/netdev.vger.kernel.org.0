Return-Path: <netdev+bounces-2806-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF14E7040BE
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 00:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 998202813B9
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F59F19BDE;
	Mon, 15 May 2023 22:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D77FBF9
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 22:10:22 +0000 (UTC)
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A887C11605
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 15:09:51 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-30639daee76so8666632f8f.1
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 15:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684188517; x=1686780517;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AFjZ1HFlkdOphu8pt3P+AWZ69ukQH9DHAMTAQ/Xss68=;
        b=jCZAZfao+7urCsudftc6jkfDj/2BabReD755Lx3fn1dKSGFE8P+XUhJfetM3lXUVi2
         nFlGkzC8TnCzgHh0vcLQBzWYHNFqtOov8imMrYGlULEXoknHW8rGMvunRZL1c2xqMmLF
         I1ZvGzrSL6Ki+6lQhx9L+RnAJDOAH9yYBBvcn1HbTLsLAm8/O8jmFWjx7VwJ27aJuobW
         MUb7P1xK7oaateQzIODp/taP4UP8uWzHX/hwwhEbp4kqjQn67SWWJ4u6vBTArV/slxrO
         vy42QNPp4T/3l/QrjRxpFHze3XzrV28jubwqbzmH9DqH9z+312yVlzOjv8fLAJACJx3G
         uoMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684188517; x=1686780517;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFjZ1HFlkdOphu8pt3P+AWZ69ukQH9DHAMTAQ/Xss68=;
        b=PLSiqmMrqpoMVu4ckyLonNKH5ZujRab43FJFBHsq2Rtdj4omfQlGaaq5Ha0/HP/PFy
         Hqak4Wf22n1EPB3dROIBtOUMjw82KNxOfhuXxTbqBMR3rqxJ+RcAL+HHxPetgyjQ51et
         D0MC8zcnOjjp/ZKdLSpRfFVVs+sSgX5Ly5Jpq90m7LPBOIB2aEc4YuE0FvsE+mHlDOfl
         rhja6IxbBi97ra/gYG1NAN2CakLwI5mtPhoif1tSOLElMRwM6omGsrscq0XUidqFiMBG
         BWeBrABz5sH/EmM4saBAt4a29AwbiC78WcVNSGQd6YWQeJZkPtwr/PiiR6JcjvBdcEAu
         6pvg==
X-Gm-Message-State: AC+VfDwr//wPLrpJYKsk6RKp+iVI1Jqu56eYFKaAqUVfzZ7xbcJjbHx+
	cC9I7003Hb9kF0is3zkCi24=
X-Google-Smtp-Source: ACHHUZ6g223jgjwxElDQeuXepqmkV1hCAf2XwEgxvvDxiNyJ813t9ca04v7vzE7HdERNUFZXrcJ3GA==
X-Received: by 2002:a5d:4b04:0:b0:306:3e96:6c5f with SMTP id v4-20020a5d4b04000000b003063e966c5fmr24691493wrq.15.1684188517176;
        Mon, 15 May 2023 15:08:37 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id o4-20020a5d6704000000b00306299be5a2sm394081wru.72.2023.05.15.15.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 15:08:36 -0700 (PDT)
Date: Tue, 16 May 2023 01:08:33 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>, John Crispin <john@phrozen.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Marcin Wojtas <mw@semihalf.com>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>, Sean Wang <sean.wang@mediatek.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] Providing a helper for PCS inband negotiation
Message-ID: <20230515220833.up43pd76zne2suy2@skbuf>
References: <ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk>
 <20230515195616.uwg62f7hw47mktfu@skbuf>
 <ZGKn8c2W1SI2CPq4@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGKn8c2W1SI2CPq4@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 10:45:21PM +0100, Russell King (Oracle) wrote:
> Clause 73.1:
> 
> So, my reading of these statements is that the _user_ should be
> able to control via ethtool whether Clause 73 negotiation is
> performed on a 10GBASE-KR (or any other backplane link that
> uses clause 73 negotiation.) Having extracted that from 802.3,
> I now believe it should be treated the same as 1000BASE-X, and
> the Autoneg bit in ethtool should determine whether Clause 73
> negotiation is used for 10GBASE-KR (and any other Clause 73
> using protocol.)

Having said that copper backplane link modes should be treated "the
same" as fiber link modes w.r.t. ethtool -s autoneg, it should also be
said that there are significant differences between clause 37 and 73
autoneg too.

Clause 73 negotiates the actual use of 10GBase-KR as a SERDES protocol
through the copper backplane in favor of other "Base-K*" alternative
link modes, so it's not quite proper to say that 10GBase-KR is a clause
73 using protocol.

To me, the goals of clause 73 autoneg are much more similar to those of
the twisted pair autoneg process - clause 28, which similarly selects
between different media side protocols in the PHY, using a priority
resolution function. For those, we use phylib and the phy_device
structure. What are the merits of using phylink_pcs for copper backplanes
and not phylib?

