Return-Path: <netdev+bounces-10524-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F57E72ED73
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 22:59:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B105F1C20915
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C7C330B94;
	Tue, 13 Jun 2023 20:59:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70182174FA
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 20:59:22 +0000 (UTC)
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCCC1713;
	Tue, 13 Jun 2023 13:59:20 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-97881a996a0so2436166b.0;
        Tue, 13 Jun 2023 13:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686689959; x=1689281959;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FnCC76S/R/td93VtAHcKLzfGTNnlN+6UbWPXpb6p1xM=;
        b=egNnBfbVJb6ap+gKmUpxLnNKAP1aI4oSDbxk59NgNwt+BzliMV4/nSS/IpZq4LZo6M
         TbNRtvO4m6XYRQMVbcRP76aBQy4/D3kjbnH7+mlPYzei94kdJ6KHIbMRv9SRP+w05yg0
         nJVdAoqExTs6Q8xdmzcLXfLlpJOW1ti2CPfYWkqwnvvRpGoYv8bPFUecfNVS0NAqCr7X
         ZOHLe7E5nTkTs8L9lpdFK7OwjrIZDsrlU6O1km3lJ3KTOfq0CYKLUShS5s7BOMoJOuQo
         i+OtyUz7HpWzd3qIBOByE8Xl3tjS5wN4HzSJbNFDo78XW9DdP6+Uzv9v38fjY0kpJ/cA
         kOQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686689959; x=1689281959;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FnCC76S/R/td93VtAHcKLzfGTNnlN+6UbWPXpb6p1xM=;
        b=iRqPRyHXfFlrm2hZcYVzDaaSP5elyvFFXyy+2DxCszH5Ypq9O8pXGLZjUIB3Qyu0FL
         4UA+CRGmFSTjffTAVvodqPkWNCd17RHZjUt+f0m3ZnV5BpWjUauReAuo9EIDsSCmCKcQ
         6fnWnCUVM2vOQn46pRwA4nHl3/55ANs41gvwDIPnxQjQ1va6PRK5Cbz6hVO2Il31c4db
         BFq/ElM164IfxpuhJ+L7t0CP3Kltgiz4+MGUhOXRE5nf4Cy2F/XM5WdIyU+IDIlHtWVM
         UyA85XhUhaMwSkoMl+Obt1Y0tT3ND7ZCPxX5OiwB3nPPhsFwJ4/SUujEJi0W1mOMIJge
         y+hA==
X-Gm-Message-State: AC+VfDy7FPJFZYgP4rRBzlbu891gkgxHQtv+RfwfRJPwYpSRI78sxSH9
	GK3VcNobtL5STnCHw/SfmR4=
X-Google-Smtp-Source: ACHHUZ6IiFahRQUP7LVJYSUAngqZVdb8DjBTGPrETG/oSI2Q6OrlBQiz8RoreTA2ZJ4shhrIV0ft6g==
X-Received: by 2002:a17:907:1c26:b0:94a:8291:a1e3 with SMTP id nc38-20020a1709071c2600b0094a8291a1e3mr13103976ejc.74.1686689958752;
        Tue, 13 Jun 2023 13:59:18 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id mh2-20020a170906eb8200b0097073f1ed84sm7142079ejb.4.2023.06.13.13.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 13:59:18 -0700 (PDT)
Date: Tue, 13 Jun 2023 23:59:15 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v2 2/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7530
Message-ID: <20230613205915.rmpuqq7ahmd7taeq@skbuf>
References: <20230611081547.26747-2-arinc.unal@arinc9.com>
 <20230613150815.67uoz3cvvwgmhdp2@skbuf>
 <a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
 <20230613171858.ybhtlwxqwp7gyrfs@skbuf>
 <20230613172402.grdpgago6in4jogq@skbuf>
 <ca78b2f9-bf98-af26-0267-60d2638f7f00@arinc9.com>
 <20230613173908.iuofbuvkanwyr7as@skbuf>
 <edcbe326-c456-06ef-373b-313e780209de@arinc9.com>
 <20230613201850.5g4u3wf2kllmlk27@skbuf>
 <4a2fb3ac-ccad-f56e-4951-e5a5cb80dd1b@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4a2fb3ac-ccad-f56e-4951-e5a5cb80dd1b@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 11:35:08PM +0300, Arınç ÜNAL wrote:
> On 13.06.2023 23:18, Vladimir Oltean wrote:
> > On Tue, Jun 13, 2023 at 08:58:33PM +0300, Arınç ÜNAL wrote:
> > > On 13.06.2023 20:39, Vladimir Oltean wrote:
> > > > Got it. Then this is really not a problem, and the commit message frames
> > > > it incorrectly.
> > > 
> > > Actually this patch fixes the issue it describes. At the state of this
> > > patch, when multiple CPU ports are defined, port 5 is the active CPU port,
> > > CPU_PORT bits are set to port 6.
> > > 
> > > Once "the patch that prefers port 6, I could easily find the exact name but
> > > your mail snipping makes it hard" is applied, this issue becomes redundant.
> > 
> > Ok. Well, you don't get bonus points for fixing a problem in 2 different
> > ways, once is enough :)
> 
> This is not the case here though.
> 
> This patch fixes an issue that can be stumbled upon in two ways. This is for
> when multiple CPU ports are defined on the devicetree.
> 
> As I explained to Russell, the first is the CPU_PORT field not matching the
> active CPU port.
> 
> The second is when port 5 becomes the only active CPU port. This can only
> happen with the changing the DSA conduit support.
> 
> The "prefer port 6" patch only prevents the first way from happening. The
> latter still can happen. But this feature doesn't exist yet. Hence why I
> think we should apply this series as-is (after some patch log changes) and
> backport it without this patch on kernels older than 5.18.
> 
> Arınç

I was following you until the last phrase. Why should we apply this series
as-is [ to net.git ], if this patch fixes a problem (the *only* problem in
lack of .port_change_master() support, aka for stable kernels) that is
already masked by a different patch targeted to net.git?

