Return-Path: <netdev+bounces-4418-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9961D70CA4F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 22:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4FBB280E96
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA533171D0;
	Mon, 22 May 2023 20:04:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE471171A9
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:04:37 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CBA91
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:04:36 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64d28c9696cso1055500b3a.1
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684785876; x=1687377876;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4hBjus/u2+P+hEsaq4y70R7fqiqoHgoQ18GA3OSe+wM=;
        b=rLFgsqnIjGvz8SkzVZTs8q2Ns6tOPIotkpXKZgdoTJNUwSPdbvfZhkfrKISX/6/FAH
         rcVezJyBEG50Frj5+jr4ai2qWVdo/y6oy/iv853vHs0Wz3PCUBXzwAsEQD7fUOKl9cFx
         NrQTSC6+UMf0koeRkgls40XOtfnTEoD3k2mk1JfgyMK9X5gXbkK+Hf0S+95oN0BwkNQx
         mru0AneehfDiYYiPXnJh8Spr7TRZ4RCPNaKf2ejpF6NcdJtfxNYQo+N7MP1ZKSwYwLfV
         6jj73Y+drD8ku0HvJsoroIrg9wrPNt45RwwwPHAT2pNldUbBZ2ByqQWiifCvuBwjawLP
         WOkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684785876; x=1687377876;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4hBjus/u2+P+hEsaq4y70R7fqiqoHgoQ18GA3OSe+wM=;
        b=OJCwUyKLgi8v3Ap9qu40eqoQIcTWZm44ci/oJs2UW4fbKkacdbqJlZJqGTnLkyn9zW
         tz9m0xttIPlWXJ2OHI/P0viSKIIpCAuiFujHnptY75wmuK1rx5DeW3ZwoRChIIXxqR7n
         yd6+7Sg8tfX4suIiC3YIrw6bFRC+Qd4Xek8nSGS8FgpkLx77uSbY1IO/MY7cgW+/Gbb7
         zk3VGmb6uhw5pf01fcnpbMTzZnlL4/0ZJsqNmI1LdazjjzOvrQakOHbSx122kmhYTqqc
         vSgWkGQYg/Ve9FM6v5NotrAVyqVr3tVmTDxii8OddQltHisYHm0uLozDuMDxSgxiQagD
         20ag==
X-Gm-Message-State: AC+VfDwln4B2cFaU1sZFpVxJ61L+Z/J45D06o8SmX5/8Z5TLGcst6hK/
	KZWTbPkvlJwv7Mu9hMevhJ0=
X-Google-Smtp-Source: ACHHUZ4CFmxwPighfM2RWXLeFymypB8KcShlw/pqiDFAgN5uvKSmVSJ3X+GNdCg3q43MyRo1D3XPJQ==
X-Received: by 2002:a05:6a00:26ce:b0:643:9ad1:b292 with SMTP id p14-20020a056a0026ce00b006439ad1b292mr10846739pfw.0.1684785875924;
        Mon, 22 May 2023 13:04:35 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id k4-20020aa78204000000b0063b6fb4522esm4506025pfi.20.2023.05.22.13.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 13:04:35 -0700 (PDT)
Date: Mon, 22 May 2023 13:04:33 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Andrew Lunn <andrew@lunn.ch>,
	=?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"glipus@gmail.com" <glipus@gmail.com>,
	"maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
	"vadim.fedorenko@linux.dev" <vadim.fedorenko@linux.dev>,
	"gerhard@engleder-embedded.com" <gerhard@engleder-embedded.com>,
	"thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
	"krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"Keller, Jacob E" <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <ZGvK0aBhluD0OxWp@hoboy.vegasvil.org>
References: <ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
 <20230511210237.nmjmcex47xadx6eo@skbuf>
 <20230511150902.57d9a437@kernel.org>
 <20230511230717.hg7gtrq5ppvuzmcx@skbuf>
 <20230511161625.2e3f0161@kernel.org>
 <20230512102911.qnosuqnzwbmlupg6@skbuf>
 <20230512103852.64fd608b@kernel.org>
 <20230519132802.6f2v47zuz7omvazy@skbuf>
 <20230519132250.35ce4880@kernel.org>
 <SJ1PR11MB61800D87C61ADC94C57DB237B8439@SJ1PR11MB6180.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB61800D87C61ADC94C57DB237B8439@SJ1PR11MB6180.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:56:36AM +0000, Zulkifli, Muhammad Husaini wrote:

> A controller may only support one HW Timestamp (PHY/Port) and one MAC Timestamp 
> (DMA Timestamp) for packet timestamp activity. If a PTP packet has used the HW Timestamp (PHY/Port), 

This is wrong.

The time stamping setting is global, at the device level, not at the
socket.  And that is not going to change.  This series is about
selecting between MAC/PHY time stamping globally, at the device level.

Thanks,
Richard

