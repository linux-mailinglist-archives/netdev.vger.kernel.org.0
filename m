Return-Path: <netdev+bounces-2761-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB7CE703DF4
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 21:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54CA22812EA
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 19:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC861952A;
	Mon, 15 May 2023 19:56:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E6FD2E4
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:56:27 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEE6E727
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:56:21 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-965f7bdab6bso2339082066b.3
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684180580; x=1686772580;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C+XyNMlAETg+dR3Oy03ffSYzFpJWsWFCxJlmwho5nuY=;
        b=CYZSny1QI7fCwdUCHviYVtHoqUKOzpK+e2NFy1X/SbXEWI75v7qaSOzixaKdj2wkIT
         DpwtHIkI1ILrC56vo/+shvobpuXyPiVMDR8K9CagTBIUftXKl9Wube1A1KUWW5ZtdO7f
         fl4e3xiRh/2fAiKFCM/XX5WDPJuI2xcWcj7njNLLtvagqTVEAkrKQHI9MJ+3980b5nnL
         XQNtZ+kMnAo7/nlLLVaZ6uxoeyY+MgpR0qYdbbqGTHccFNUen3Ovlw9iNDrmgqfy5Q9u
         kG3SlfBcDodIvlOE1AykUooxhqDFoTkUxi5z6JgQqID3ttOY8LUZgoaxMx8WXrN3B6pQ
         DgOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684180580; x=1686772580;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C+XyNMlAETg+dR3Oy03ffSYzFpJWsWFCxJlmwho5nuY=;
        b=Wd/U00kRijER3ek5wOQycnqmrXu+mCtWUcAQ5kc4OepXd/W40lAqjl1lI2jBUyeN7v
         AFz2qP88B+silJJ+aVOJlWVQNf7sFhskv2QzvUzSB5QGrcrFAIX4Dvb8wI77jwvDTSF1
         VYi/4G7ph9TFo2KoFgq/9ZnV0VmNsx5YAXd3+Llh+oD0jNItqmM5kC1ed9u+dFfOBmOi
         z296S/6x27LZ55OyC+jC8fxshhD/Y48T6CdqTnB+dRadYYMMNkNVm6RSrqi/fsmeJ4m+
         hlwMfjSfJ1mLqxSFlQCIxHtOXMbytBJOBL+58RqHW9VG2r0WoswILpQ1xTw4GzQkWnTH
         rZyA==
X-Gm-Message-State: AC+VfDzcCwir48a167sNLDuHXRWOiW93DP4yoNn+5IhvwZeA8h/blsn1
	StuniTbGPc6uGE9UfJKRkFA=
X-Google-Smtp-Source: ACHHUZ5Kze+PqMpF282DHjtxjRicRfGuHPl9XdDUyiPnJ8JCMhXoquCk8nP+oGKjyTsyVtdTzZG57Q==
X-Received: by 2002:a17:907:2da9:b0:94f:247d:44d2 with SMTP id gt41-20020a1709072da900b0094f247d44d2mr32695380ejc.5.1684180579593;
        Mon, 15 May 2023 12:56:19 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id s1-20020a1709070b2100b0096a16761ab4sm8570364ejl.144.2023.05.15.12.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 12:56:19 -0700 (PDT)
Date: Mon, 15 May 2023 22:56:16 +0300
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
Message-ID: <20230515195616.uwg62f7hw47mktfu@skbuf>
References: <ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

On Mon, May 15, 2023 at 01:22:50PM +0100, Russell King (Oracle) wrote:
> 1. Should 10GBASE-KR be included in the SGMII et.al. case in the code?
>    Any other interface modes that should be there? Obviously,
>    PHYLINK_PCS_NEG_NONE is not correct for 10GBASE-KR since it does use
>    inband AN. Does it make sense for the user to disable inband AN for
>    10GBASE-KR? If so, maybe it should be under the 1000base-X case.

What physical process (reference to IEEE 802.3 clause is fine) would be
controlled by the phylink_pcs_neg_mode() function for the so-called
10GBASE-KR phy-mode?

