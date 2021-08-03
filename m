Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31A23DF1CE
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbhHCPut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:50:49 -0400
Received: from mail-bn8nam12on2092.outbound.protection.outlook.com ([40.107.237.92]:3392
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237011AbhHCPus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 11:50:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FR0wIPErAViW+xLNICeeyGhUHRz5Au6+spSDomgOMBZVU83NTqwMv3uJV2gWLEugS2e2v1NoKnJAlU+GwRc6RPUn6JsrSfMyanKD8EGj/gFAH3FfBnV888YA4Visz+SimjATR9hQCyzbhNM1T4gv0ZwHe8Numu6pBwflv4/271KcHofYCmRcPBrQk+enwEr/Y3bG7f6zfTmVrsvPWQrdRDAA2rTlf1cKFBLAyHtyh3OejiZFAK7lg3RcN/c65bXdTYBe+KI9PWb+mHCVeQF9NSlTn8AxQdKkE9P10uJlar/XOL77guDsQrTF93J2jt1jH9dqK/kaAocuq05imP0NvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lmjr2pgwavpfIAqJ22zdSwiBmNnoDayIMK/b3R5pY+c=;
 b=WbspFRMsKEkXBrUdn4m9Uz+XwBrRCcME/hQoELmdDIHAO9Qhci6G6ijxA0mFaNYeDLuymoOsaZwJoToYTpafXejmzzCngz7Bplpmy1mpBvaQLQtMhoJZf/r1Cr5biSvweaccg5wvuf/BM3IM1UTL3yK4Nt//dBli5dC36GXnzeH57MYAwfrnCxfi1/H0RWj70OZOVsabri7wgMrGvCGwt1/5waAKWlznV9W40srFZaEirg5jchBoViSaESXA/2jeoWXiAuogDQz9/Vl8o3avg3EaQtVke8Eh+Rts3WVacmePlgom4SidvdpFvwjxd4hM5jlgiIo8WU31+TRnVKZkiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lmjr2pgwavpfIAqJ22zdSwiBmNnoDayIMK/b3R5pY+c=;
 b=NMGAMwKHDMUFj1tDMqTSl1F+D6oON8b+yl4+rw3LfPVXAQUA/zwHMq8R84woZxRAkhkViq59wlocGNFciu+jGBWGjEFCfGj84KXSj5OnZjUId8QSPtZUEOFMcKs9OLkBPaJD1JkaoZ1mztUUBiOJbEf3KZcSzJpYm8NB94rg0Xs=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4907.namprd13.prod.outlook.com (2603:10b6:510:99::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.14; Tue, 3 Aug
 2021 15:50:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Tue, 3 Aug 2021
 15:50:33 +0000
Date:   Tue, 3 Aug 2021 17:50:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Fei Qin <fei.qin@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net] nfp: update ethtool reporting of pauseframe control
Message-ID: <20210803155023.GC17597@corigine.com>
References: <20210803103911.22639-1-simon.horman@corigine.com>
 <YQlaxfef22GxTF9r@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQlaxfef22GxTF9r@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: YTXPR0101CA0004.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by YTXPR0101CA0004.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 3 Aug 2021 15:50:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09e438a5-0478-4226-74cd-08d956966d9c
X-MS-TrafficTypeDiagnostic: PH0PR13MB4907:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4907B2C1B413ADAD6650BFB8E8F09@PH0PR13MB4907.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RGm/nkFk8BQasGvtyVlkFgXQ3eJaGXqD+HaJ/FOUF+WEk7EDO4XnMoY2ttPvM4RbQKjXxEqFUfPgAMZIr2P2neQElosC/RI7Zfvokcxw8LDncr96QHU+DcwBXBrZj9a6sRb0BZr0bMaNrOpG+w9gR9Ww+6AEnckkIF9v6f9xtqXabBz31y3f1lWh8Yn+uh6Fdyuq+/i6M6DpUOD6PfI0IBw6Bj+s02/aa20TpG2TRJKlIEZfiR0yQKHfRbG1PobkFf4TcOmChp0ljb2LZrHpc0IECCcodBargrSa9Z9BjlkxG1LbBlgxzoS3nOvpw36zevdYVu4Xv8W4Nf9snmo8lI/d+MOKFR5BbLxL15VWy/ALdWmqFC+5i8Q3aAiINuLxs4LDAqWVNunhiRNYlpti4Oro1hNb5Owg1y3gKcxovS8irexh3K6TPYXmslIE90SND1S/zL40e/xGR6AsRxZ+iaFz/wPhsbD+wKSRDZEIq46Xg+/J+YAtGupyACoQZU/I31BGKmIceEH0vv0JMASFS/CQrWclqLfTwiudJXJtbh4BUXiJILI5M4b0YxNNjhtADjLtCOkmZlEabvu83+b2nSyRpDI1OgKdjFdVCx4VWoQIjSIRnVK2es4AU/ncyA3YAkTCrznt1Zlb1NGOQwNFxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(136003)(366004)(376002)(346002)(54906003)(55016002)(1076003)(38100700002)(2906002)(86362001)(8676002)(36756003)(33656002)(44832011)(4326008)(6916009)(5660300002)(2616005)(8886007)(7696005)(186003)(107886003)(316002)(66556008)(8936002)(66476007)(52116002)(6666004)(66946007)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sAc4QCX4QggKlZPeh5JtcyUtfwJnRAx/AR92UNYCQGzIfbXcF3XPBuYhX4db?=
 =?us-ascii?Q?w+N85xEzFEGndBSsLqrtAhWqUFxV301q43wjLVSGDDfquwnuqWcYBiSNs4Pn?=
 =?us-ascii?Q?MNHO14yEnxf8jFfBPJBsRQ8FxlgCjo2rM7q/Nd+ImiwhokB45+WXZu0UOtDM?=
 =?us-ascii?Q?p6AIv62L3stJ+/deezBilBk5U/8vD5Rz155aypMUfmG3EvkDGGHHN1V1n6qc?=
 =?us-ascii?Q?veaopVZxL36jK2hvHNKw1YCMPc1y5wTgk68iL76I22w+2ri0iwOOFuL/Zpjd?=
 =?us-ascii?Q?QE+dGraM5OizO2LMVLomxlmymO98T1NpioodUq73+7auj5CSV1gfh/ClSS2R?=
 =?us-ascii?Q?PcSQkrxv3FjcjM4h8pTn3Dnyacn0gV47Kr3VP6GsCbecIKElDmgE9zCa3fx6?=
 =?us-ascii?Q?RzQ0oAlT9ZvcpAhALfwoVlAJSuQrbTQCx3Fm9RKFJZXurel0tjtdOkZrPQXW?=
 =?us-ascii?Q?NNWB6eu4us1sKwSq8kzT/k1ogdDDQ8FgDtsniYPMTWRAsCT/C5ftPqPuW06/?=
 =?us-ascii?Q?2ckSLAEmEq7UG4mm0t95aF7nmkhJfnaQCth4MHbVy4dqisk4BI7mXDqn1VQz?=
 =?us-ascii?Q?xckJV0MLkANboPgYJhJE2uS6UuNLWb78ZU0Ar+7WlHz5Oeq7+d0f2i8tOovp?=
 =?us-ascii?Q?4xTvEv1KWw6VDqRpkPnftQvXOZWlBNfcQmp6UVCYvoViUmdTYoJ8K5N1b67U?=
 =?us-ascii?Q?3zx1DoKp0dmW5+DQsU6CHl+7/BQD1auxPi5ly97SO+G7Oimr7/qPbY9FoOru?=
 =?us-ascii?Q?OSkQWFKQQVKl8pl0vEQWeIk7ruG6wr3LHiy5MbEjXQv5St3ox4pCDknrS+sZ?=
 =?us-ascii?Q?800SbJQsk1H9jfRrRv4/LdOCCE7uWLtGgmkrLeVvgonlzloZwKgdPg45gqlN?=
 =?us-ascii?Q?RFaA6ifBpDkaEASa+p2GYh9Mo0uJ9T/VLo5gL31Ou5gY/HnZP9IwGUZaY1f2?=
 =?us-ascii?Q?DIRKX9LHNy+0opF0PC1bH/pFggcRp1gH0wTYVfReobzfkAXZSPcf5sjQE4TW?=
 =?us-ascii?Q?3mN3UWGlf926Z/FUwcJ82lyR6YDKLAPvrCyzq6TLbhnCb4NF1q+DQ6OUmZ20?=
 =?us-ascii?Q?skPW1iU1s1wsPqyWPcPlPvlHi8Dk47zFkdFPanG28Aq6uI9s+2TzocWJpG3n?=
 =?us-ascii?Q?ICy3NFVSeN2ck3ngrIQ3XMKLqj1uCIp9dpsExojBOQQJjEq8lCeLi0X6W2rh?=
 =?us-ascii?Q?OyCQg6fwEY8skzoIIH+bUIk1PMiF0NnY8ozJjUwtk1jvEaBMg1qDUvDf1At1?=
 =?us-ascii?Q?/gmFD1IQ+9wE2s47eIRbZzUWuqoJp8xu6CvXKFjbYymRzC9D5vWKLVs2bA4/?=
 =?us-ascii?Q?zOdr1S3ccz5Shcll0nIczoifpIvyLI2zVKVoj00Oj/Qi7DxtyF4Y37WVLYxM?=
 =?us-ascii?Q?sVc7EJQPS7sSlZ39iRqDawD41ULc?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09e438a5-0478-4226-74cd-08d956966d9c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 15:50:33.5949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N+nzLzCqUOpdOoYnb1Jn5CmF+K7Jo/5+xM35noYxLmC4p9EN3jr3TMiMXaAZWfa5hg70HFVrnoXnyCAfcWFfsDkswLzxJUVBfpvXcLcTYrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4907
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 05:03:33PM +0200, Andrew Lunn wrote:
> On Tue, Aug 03, 2021 at 12:39:11PM +0200, Simon Horman wrote:
> > From: Fei Qin <fei.qin@corigine.com>
> > 
> > Pauseframe control is set to symmetric mode by default on the NFP.
> > Pause frames can not be configured through ethtool now, but ethtool can
> > report the supported mode.
> > 
> > Fixes: 265aeb511bd5 ("nfp: add support for .get_link_ksettings()")
> > Signed-off-by: Fei Qin <fei.qin@corigine.com>
> > Signed-off-by: Louis Peens <louis.peens@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > ---
> >  drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> > index 1b482446536d..8803faadd302 100644
> > --- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> > +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> > @@ -286,6 +286,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
> >  
> >  	/* Init to unknowns */
> >  	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
> > +	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
> > +	ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
> 
> Hi Simon
> 
> Does it act on the results of the pause auto-neg? If the link peer
> says it does not support pause, will it turn pause off?

Thanks Andrew,

I'll try and get an answer to that question for you.
