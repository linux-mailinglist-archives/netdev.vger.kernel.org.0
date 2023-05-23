Return-Path: <netdev+bounces-4517-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 084DB70D289
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:54:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3370128115E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 182257491;
	Tue, 23 May 2023 03:54:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B186FA6
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:54:22 +0000 (UTC)
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1DB90
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:54:21 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-517ca8972c5so273243a12.0
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684814061; x=1687406061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G9Kiok+G1+JX588yrgEB766HCcoqilu3vmrJ1+oid88=;
        b=cZj11ClcQgx9CxB+DqbbV/M8jwv0y7JEC1Y2/8TcHQyKBmInS3pFsyZko3NpcTfa2j
         vVk/Xr1lJosE1Mt1cnX70/GhPKIAZno91vMuBAmPbToravAy6T5+2DblfqaESFRwK+Lp
         lYYqLnRwxjWfsU5Xd8Xv4/9koeW65mN6j0Ka1AW9uzuU/RCAfqNlCfNPPdAqLiPG1/KG
         F19OVuA/mvrfjgifeeWKGiXEmTEzW17/t0OyALOXZHvPBjFnaYDUd6ZWIXwVge6RrL88
         hrTAq06jw/qsI0HGObTvhqrMnbVCf8xFoyrhkEX8uCqK2fNtlLKv3plAYptjnVqleGOi
         91Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684814061; x=1687406061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G9Kiok+G1+JX588yrgEB766HCcoqilu3vmrJ1+oid88=;
        b=gqSr6GSLRvulYWahHU5TovbPmUx3zfc7Xa5kFJ/j1zIMNJTuUIwvmPhbeJ4RUdKZoC
         +ICk+UE4s9NPQa8dsMAAXPCB5lMd7pEZfN0i6bb1IucFkJOSEWVFoBwHWEjzHk4+xcCb
         Xxz4FHJCxiUHijTFeXYs8OplPDhjq3ZU9n/cYt4xWXQZDHQMYLoHHaiRJ0bKYaC7dqyP
         r71z41osVGtwTGY3ubqi5ZXUn4N9+7OFTXwVLy15N3nzgFm/670y1hQeS6691j1Ooy5d
         UUUq9VjGuvFhNNiA3iRM9el3aEbQdYrG88j/XBrRiDSZYcKrY6TFC1YNctt9LNu/AP1/
         JpZw==
X-Gm-Message-State: AC+VfDxceBEvhopYqeCocljs2ADmAyZGcKzXkAxJ6l1HQHHbvwB43V35
	mJr/iB90mBqngyec3hyQGUY=
X-Google-Smtp-Source: ACHHUZ4Ms3UGRCI3cYzxwpoRrUCouR5dyEONVJ2YJ9Tc/mXA5+eBTNa/U5qiwxE4TFP45zAA9i1XmQ==
X-Received: by 2002:a17:902:ec8a:b0:1a6:cf4b:4d7d with SMTP id x10-20020a170902ec8a00b001a6cf4b4d7dmr14103741plg.2.1684814061111;
        Mon, 22 May 2023 20:54:21 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id jw22-20020a170903279600b001ac444fd07fsm5609162plb.100.2023.05.22.20.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 20:54:20 -0700 (PDT)
Date: Mon, 22 May 2023 20:54:18 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
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
Message-ID: <ZGw46hrpiqCVNeXS@hoboy.vegasvil.org>
References: <20230511150902.57d9a437@kernel.org>
 <20230511230717.hg7gtrq5ppvuzmcx@skbuf>
 <20230511161625.2e3f0161@kernel.org>
 <20230512102911.qnosuqnzwbmlupg6@skbuf>
 <20230512103852.64fd608b@kernel.org>
 <20230519132802.6f2v47zuz7omvazy@skbuf>
 <20230519132250.35ce4880@kernel.org>
 <SJ1PR11MB61800D87C61ADC94C57DB237B8439@SJ1PR11MB6180.namprd11.prod.outlook.com>
 <ZGvK0aBhluD0OxWp@hoboy.vegasvil.org>
 <20230522132144.018b375b@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522132144.018b375b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 01:21:44PM -0700, Jakub Kicinski wrote:
> On Mon, 22 May 2023 13:04:33 -0700 Richard Cochran wrote:
> > On Mon, May 22, 2023 at 03:56:36AM +0000, Zulkifli, Muhammad Husaini wrote:
> > 
> > > A controller may only support one HW Timestamp (PHY/Port) and one MAC Timestamp 
> > > (DMA Timestamp) for packet timestamp activity. If a PTP packet has used the HW Timestamp (PHY/Port),   
> > 
> > This is wrong.
> >
> > The time stamping setting is global, at the device level, not at the
> > socket.  And that is not going to change.  This series is about
> > selecting between MAC/PHY time stamping globally, at the device level.
> 
> What constitutes a device?

Sorry, maybe I should have said "interface".

You cannot have one socket with MAC and another with DMA time stamps,
as the above post implies or wishes for.

Thanks,
Richard

