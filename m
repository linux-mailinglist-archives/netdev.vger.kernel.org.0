Return-Path: <netdev+bounces-8120-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25621722CEC
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:49:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFA29280F7F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A58D9449;
	Mon,  5 Jun 2023 16:49:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFC58BF0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 16:49:25 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C64D9;
	Mon,  5 Jun 2023 09:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=83NktPWyotPnIP6ctRP/lbvydHsK9DrqhUfJFfVVMCY=; b=Ix/RnCPT2/sRZIFzldq0mqWSyV
	vdUg1T0JTIVInWRDJMfB9yqmx5rskWb8olvB+pa9YI+lYTAGYqQ+fKuVD2rSJgOlVOYyTj3PGaDHP
	1ipA5LbMPchF5C7QrZTRp6eP9Qc5e32XuEGr8o1U8ILq+iXvDi7srxE4Eif76559b6Ac=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q6DOK-00Ev7j-OH; Mon, 05 Jun 2023 18:49:12 +0200
Date: Mon, 5 Jun 2023 18:49:12 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Michal Smulski <michal.smulski@ooma.com>
Cc: "msmulski2@gmail.com" <msmulski2@gmail.com>,
	"f.fainelli@gmail.com" <f.fainelli@gmail.com>,
	"olteanv@gmail.com" <olteanv@gmail.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"linux@armlinux.org.uk" <linux@armlinux.org.uk>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"simon.horman@corigine.com" <simon.horman@corigine.com>,
	"kabel@kernel.org" <kabel@kernel.org>,
	"ioana.ciornei@nxp.com" <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v7 0/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Message-ID: <87a5491e-6697-48d3-94fe-aa2c6f5ab129@lunn.ch>
References: <20230605053954.4051-1-msmulski2@gmail.com>
 <b38bd01c-dbaa-440d-93ae-b1b772f8e8e1@lunn.ch>
 <BYAPR14MB2918D3EBDA5120130D12BAB2E34DA@BYAPR14MB2918.namprd14.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR14MB2918D3EBDA5120130D12BAB2E34DA@BYAPR14MB2918.namprd14.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 04:32:03PM +0000, Michal Smulski wrote:
> Andrew,
> 

> I will remove this line and resend v7. This was a mistake on my
> part. However, could you clarify on what is the best way to let
> reviewers know what changed between different version of the same
> patch? It seemed to me that changlist should not be part of the git
> commit message and hence I decided to add 'cover-letter' email for
> each new version of the patch so that it would not be part of the
> applied patch to net-next git repo (but it would also be easy to
> match changelist email with patch email to people reviewing latest
> patch)

Some people think the history is actually useful, it shows what has
been considered etc and the patch matured.

However, anything text after the --- marker in a patch will get
discarded by git am when the patch is merged. So you can place the
history there.

	Andrew

