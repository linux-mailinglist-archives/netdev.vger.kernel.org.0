Return-Path: <netdev+bounces-975-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E246FBA5B
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 23:57:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A0E21C20A6B
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE965111AF;
	Mon,  8 May 2023 21:57:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED8C847B
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 21:57:19 +0000 (UTC)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455271721;
	Mon,  8 May 2023 14:57:15 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6439df6c268so2811722b3a.0;
        Mon, 08 May 2023 14:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683583035; x=1686175035;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nr1Zb6Ozywk7OVF4mmQ0nbkLri6483J5psmZMkp9VDE=;
        b=TMFDRIjkvtXVCXBuaJUOULkN+1LUbCEudijsoxnX7vthCc3Jx1/n06KLm+uLJkv1A9
         jLGGJl3mefeMvoXEUWjWGEZsxe7rpUIoRjoRu0jk+txTEgO1eno5SCFTw1fXfJI2eaDB
         jzv3FTZ9PSVa56rokIwjUu33duzXs/Am8o5vuxBGySo97d5QQhTlDRsKaa0aO6Ma5hvH
         IyENyy6Q1FL4sERJEIZRm1CSXaJxN3W5tl3Hm6k7dkWqHmrh3GzK3eNhBpmttbW8Fi6j
         1vVnBSHDEtFf+hFQJxXTJfCVruNYuy23Nie6nPPRGrIgambnZ8gJStl6s7n16gqx8TYZ
         lsoA==
X-Gm-Message-State: AC+VfDzPGxwnsKhcHkc9EK/U5nHJWzosK84wu37VL3wmXA6O4gfoQ+SI
	vYy85ecDZ1D/r3Sq91aPjAkxpx9D+3rUSw==
X-Google-Smtp-Source: ACHHUZ4tmxB4rSam8sD0aXWYGzOrZuBXAB3fu1o2Ht0Y3lvfZX53viwZJ/q4lq99vIdeBO0T4uDjxA==
X-Received: by 2002:a05:6a21:7898:b0:101:167d:8472 with SMTP id bf24-20020a056a21789800b00101167d8472mr1720812pzc.26.1683583035227;
        Mon, 08 May 2023 14:57:15 -0700 (PDT)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com. [209.85.214.179])
        by smtp.gmail.com with ESMTPSA id i6-20020a17090aa90600b0024e262feac1sm10223415pjq.23.2023.05.08.14.57.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 14:57:15 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1aaea43def7so34646075ad.2;
        Mon, 08 May 2023 14:57:13 -0700 (PDT)
X-Received: by 2002:a17:903:1247:b0:1ac:3605:97ec with SMTP id
 u7-20020a170903124700b001ac360597ecmr15056103plh.62.1683583033433; Mon, 08
 May 2023 14:57:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230310224128.2638078-1-u.kleine-koenig@pengutronix.de>
 <20230412171056.xcluewbuyytm77yp@pengutronix.de> <AM0PR04MB6289BB9BA4BC0B398F2989108F9B9@AM0PR04MB6289.eurprd04.prod.outlook.com>
 <20230413060004.t55sqmfxqtnejvkc@pengutronix.de> <20230508134300.s36d6k4e25f6ubg4@pengutronix.de>
In-Reply-To: <20230508134300.s36d6k4e25f6ubg4@pengutronix.de>
From: Li Yang <leoyang.li@nxp.com>
Date: Mon, 8 May 2023 16:57:00 -0500
X-Gmail-Original-Message-ID: <CADRPPNQ0QiLzzKhHon62haPJCanDoN=B4QsWCxunJTc4wXwMaA@mail.gmail.com>
Message-ID: <CADRPPNQ0QiLzzKhHon62haPJCanDoN=B4QsWCxunJTc4wXwMaA@mail.gmail.com>
Subject: Re: [PATCH 0/6] bus: fsl-mc: Make remove function return void
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Gaurav Jain <gaurav.jain@nxp.com>, 
	Roy Pledge <roy.pledge@nxp.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, 
	Eric Dumazet <edumazet@google.com>, 
	"Diana Madalina Craciun (OSS)" <diana.craciun@oss.nxp.com>, Stuart Yoder <stuyoder@gmail.com>, 
	Horia Geanta <horia.geanta@nxp.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Laurentiu Tudor <laurentiu.tudor@nxp.com>, Richard Cochran <richardcochran@gmail.com>, 
	Pankaj Gupta <pankaj.gupta@nxp.com>, Alex Williamson <alex.williamson@redhat.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Vinod Koul <vkoul@kernel.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"kernel@pengutronix.de" <kernel@pengutronix.de>, "Y.B. Lu" <yangbo.lu@nxp.com>, 
	"dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 8, 2023 at 8:44=E2=80=AFAM Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@pengutronix.de> wrote:
>
> Hello Leo,
>
> On Thu, Apr 13, 2023 at 08:00:04AM +0200, Uwe Kleine-K=C3=B6nig wrote:
> > On Wed, Apr 12, 2023 at 09:30:05PM +0000, Leo Li wrote:
> > > > On Fri, Mar 10, 2023 at 11:41:22PM +0100, Uwe Kleine-K=C3=B6nig wro=
te:
> > > > > Hello,
> > > > >
> > > > > many bus remove functions return an integer which is a historic
> > > > > misdesign that makes driver authors assume that there is some kin=
d of
> > > > > error handling in the upper layers. This is wrong however and
> > > > > returning and error code only yields an error message.
> > > > >
> > > > > This series improves the fsl-mc bus by changing the remove callba=
ck to
> > > > > return no value instead. As a preparation all drivers are changed=
 to
> > > > > return zero before so that they don't trigger the error message.
> > > >
> > > > Who is supposed to pick up this patch series (or point out a good r=
eason for
> > > > not taking it)?
> > >
> > > Previously Greg KH picked up MC bus patches.
> > >
> > > If no one is picking up them this time, I probably can take it throug=
h
> > > the fsl soc tree.
> >
> > I guess Greg won't pick up this series as he didn't get a copy of it :-=
)
> >
> > Browsing through the history of drivers/bus/fsl-mc there is no
> > consistent maintainer to see. So if you can take it, that's very
> > appreciated.
>
> My mail was meant encouraging, maybe it was too subtile? I'll try again:
>
> Yes, please apply, that would be wonderful!

Sorry for missing your previous email.  I will do that.  Thanks.

Regards,
Leo

