Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D77E3770C6
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 11:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhEHJGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 05:06:50 -0400
Received: from mail-mw2nam12on2076.outbound.protection.outlook.com ([40.107.244.76]:24695
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229583AbhEHJGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 05:06:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+bRMhM45MzBztz1iHQ8b0DccTkX3AFn5rS5HZDaqJ+h0mAset3PssgZmZleJ8PEMQxl6lKKUWRLbHB18ygIiZjXnZ3a1xgQvOFgg9+CfD8wHfo7Huel4cOX74ULF2LK6FXr3rel+rh0i2fMsvL9vPA0JdsDfPZx3s1aGxg3piEEn24a8v4couJ1+WDZ43BaiB6zIIBKM8U865CoLzJ0TYTB+WvjuVfiZd2g/dYE3aWCrJOxgwKqQiuiK7me273wHfVAnaW8+J+hOfp8uCTTw+HFWKYyuwUYBXBtkY8T6SZtitcrbm5LUMw9sIHdk1Xjc0wk2ppUUUCbXjk/HJJ5LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QI0TNbQxsXzc9WVw1RtzOGXQyusGHdtPXWkBlXVTb54=;
 b=PvcZrQok5vJXNarKstxHacSnHi6dhTxzGXOPTJ+WcmsbWQhgLtdObw9YB/F4wHU1tiPU4qp58nYqFmGHJwZTslL5B492sRoHSlDT41kTlwd8KGHanJWIDOY2KFAtohw5QxbHy8sdleqUNFVwIiGP665f/V0y9Tn5oPgeYQANoy6WHoFLeTcj+xkX2SPuSvwK8b7ZrskZTtsVvhf3v9WyHYler/ehwq/f+AGBapylKZ/DyPaDBdMUTjCZOxbOLdE+H9yVszmaRsGxlR1xxQ7r4NEIzVnqsrmYdIfDl2Jgs42/E2MPPAqYFZG7qZ13dJcGDPJDwjSr6EQMiN2XGoYklg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QI0TNbQxsXzc9WVw1RtzOGXQyusGHdtPXWkBlXVTb54=;
 b=dX6vB5rK5v+kHjo3av+HI/ScEwZcujXGo1O/9AwYwRKO7qQQA/GFEcS+JuGUK9LLzhP28o9VN9TjaiVkgeoIG8cZVHo8pu5EwFblKBm+e2g6ktR5kBgrnisaubZAzSgjhL9m+WDgNr5cn1DPHF+jAjGJij30gOHlLwn4D85OnEs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synaptics.com;
Received: from BN9PR03MB6058.namprd03.prod.outlook.com (2603:10b6:408:137::15)
 by BN6PR03MB3009.namprd03.prod.outlook.com (2603:10b6:404:10e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24; Sat, 8 May
 2021 09:05:44 +0000
Received: from BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::308b:9168:78:9791]) by BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::308b:9168:78:9791%4]) with mapi id 15.20.4108.030; Sat, 8 May 2021
 09:05:43 +0000
Date:   Sat, 8 May 2021 17:05:29 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH V4 net] net: stmmac: Fix MAC WoL not working if PHY does
 not support WoL
Message-ID: <20210508170529.2b7aedbd@xhacker.debian>
In-Reply-To: <20210507154624.31186614@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210506050658.9624-1-qiangqing.zhang@nxp.com>
        <20210506175522.49a2ad5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB6795107C0B25B2E199FE0A0EE6579@DB8PR04MB6795.eurprd04.prod.outlook.com>
        <20210507154624.31186614@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: SJ0PR05CA0187.namprd05.prod.outlook.com
 (2603:10b6:a03:330::12) To BN9PR03MB6058.namprd03.prod.outlook.com
 (2603:10b6:408:137::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by SJ0PR05CA0187.namprd05.prod.outlook.com (2603:10b6:a03:330::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.12 via Frontend Transport; Sat, 8 May 2021 09:05:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59fadd8e-57b1-4f3d-1f7e-08d9120075e1
X-MS-TrafficTypeDiagnostic: BN6PR03MB3009:
X-Microsoft-Antispam-PRVS: <BN6PR03MB3009C4274D9946B288131D1DED569@BN6PR03MB3009.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3lYCdcJgDo/iu8F8zKd3Rc+LPktb/x+Mf+kWDDzYxPWRGMf96lOZHnSP/j7SKNEc4Qdg/8hOPUaohjAQJtENOaJZ0ESULmuXMHtFqV89SFKrJKSNyAFHjnHDZ4ojbtul2tY5mJQPpLebi7N3FOS0Df37LAkHK5IhRNfZjXxB7+jv/+wxJ1pzE8GhLgv4A8a2tOYmHWfGmlEhgXPveinz3Qc8j5YPu4LYAwq0aNTKF1RXDQrtVpgGIkXf1KHk5Ygtm6Q12slUiP+BoabRMx2LIyzGhAqd8Wluda+ySKjH0jnlE5w5Cd6irXw8q9SR8/XlI7TqM0ONcOr9v0sOlk5PVZJr+5VIxCoGFFsYXoVOSBYHFUYT++2t3vvNsRrFMg89j+im4NNli5N1T/khYNuS9Ogh6LMoXOH5hGpn5Wm2zCgAaVDntovZyFGa1KvtKk/FaMXaJRGfnlejDo7vf2yQbAEJ3NaQuYTC9cpU8QlZXMJPQLbT+EDYRTp09MqDTLkOScSXnjjwHFKctgMsty7W1jWAGDKFTeR8ZC1ybN+Veb6eyFqbgV7rPdBEg5v2410eFHngYaWnZY1xMUCM5S7XK2fIPnwX7HL8uZcHmt2uFp9UFepGXhcFG5oinm/0rTz9R3M8OMohPaTpQreEP4a2tYLc0EI/2HhzZP7YfPaPjwo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR03MB6058.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39850400004)(376002)(346002)(366004)(316002)(54906003)(8936002)(8676002)(16526019)(2906002)(6666004)(110136005)(6506007)(26005)(186003)(55016002)(83380400001)(5660300002)(9686003)(38350700002)(38100700002)(66476007)(66556008)(66946007)(4326008)(1076003)(7416002)(7696005)(956004)(478600001)(52116002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?T6bQVr8rNkiMb9Ie8CnjgkmZbGAG+yyTKepyxvzY6cHRF4gEEzp3BIeVO0Mm?=
 =?us-ascii?Q?onoSIfdjFBtUhtbNV4d+p+1/+G5FtIDRGLuHlQXXeAvN0FboiEGKntkcDNMT?=
 =?us-ascii?Q?/rdv2nyKZXFUCjYs5/6HZrYcGc9cKxCF7l9254lEmKGlFrx9qtGvt+UHf7Wh?=
 =?us-ascii?Q?2kWGQk57Em2V46lpHhe5IoD2ZpY+NHgeu+LBQ3AcUcmNhke5kK5QLgQ4GDyI?=
 =?us-ascii?Q?9LnnAT/FceIQ6E0edGQxRgEHD9ZRVBnfK5d5BYA/ceOeLouEPhdsi0Bo4VJ3?=
 =?us-ascii?Q?ydtpFTLQCfSHMrzdX7FoHo4bJ3FaU+oQcEpRCbmMk2FrmUEQtdDIXNClm+q5?=
 =?us-ascii?Q?ibVwQTT21djwSoTmckIV7cKKHEVj5PPyyNHrI71ejP4VT6tgAF3TJSKSFJj3?=
 =?us-ascii?Q?8FoO4UWM2gNAFtrFHMHrx1uXIKYqCV5htOtSEkMf7U8yiONXcM8J/VRbPS2F?=
 =?us-ascii?Q?RlkGgZlg7UYdfwyu8dLTHGTB7hsQ2IwR+68s4SVPz6Qagurs+bPDs0redpzt?=
 =?us-ascii?Q?22K0uOlzaRR9qU+rtAr7FqJJK3k6HeeJ9BqByuplGsTPlNxnLBRnOrM/O0Ee?=
 =?us-ascii?Q?3NS2DmF7j7DeHU1rnJp7TSARbwlyIJ8nD+k9DoStml/s5jMjgDfTsrEITqQu?=
 =?us-ascii?Q?XNyLh4IdTB/62ATNRMo3BJL86PyuDUVvTAUNpv8kAb8AJ0cLMHrLoklM98MG?=
 =?us-ascii?Q?o7do2AiyvtYsGv9CC7daqnMceIA9mknULn6pZNpOJaFcmrI2j2qJKqdrycfQ?=
 =?us-ascii?Q?u4GAFGMxfbBN8WvgydxcIxYvC5EEsx9/Z+QhsQOYCaNKHRaprKOHhO34n0Li?=
 =?us-ascii?Q?M6t6Xy7PJ3MAdjtxOnJgRUdosbS8HcIGJr/3uI4UVHiWCtizLbo6O4ohgu9+?=
 =?us-ascii?Q?4N/9krKt8BbULGRBFRM+asJNZ2XbKJXJ0Uy/JaNJlJrL/7YOyoLr9Q2B/lCG?=
 =?us-ascii?Q?YWm81agXKhR415oKC8iwYCIpWvBE4sh6aeBAdKpuZD097USy6GekgHptIghW?=
 =?us-ascii?Q?xc0wTg4bIKnI359pD4CYFdcZIjGrrp6oF0bNrSAK+uGN0KrohykN8szT98Hg?=
 =?us-ascii?Q?nPSlCWAMen3eTJowe90VcH0vevuD4jeZcAG22dacakJXIi5JXDevBGCWEjj9?=
 =?us-ascii?Q?kfrtRIwuc9qYW7Im/RPSDkjtIoqYfyBmaYrTT0dzN6ciYBqbg/XQ/URj1eaD?=
 =?us-ascii?Q?NFCdCUl1I7RhXAdTnSd+To3H/d4fKwP7Wx1u6WDEAh05Uv2+kLmn1wLAHqLB?=
 =?us-ascii?Q?wO9ROI4KDsQdcUGGbB1M16L+WTPGF1GklPLImZfujcoAUGueaEbenSeawXwL?=
 =?us-ascii?Q?xmQbKjf9mxOB91OaopTx0Eon?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59fadd8e-57b1-4f3d-1f7e-08d9120075e1
X-MS-Exchange-CrossTenant-AuthSource: BN9PR03MB6058.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2021 09:05:43.8007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7vmdc46dTwOVlJSJNqpAKNit2wFb1noofRQ5cvRzwSRRmbqwWGH2SORKFxKQdt17z2yE6Zxu6rTFEpjdNQaKXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB3009
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 May 2021 15:46:24 -0700 Jakub Kicinski wrote:


> 
> 
> On Fri, 7 May 2021 10:59:12 +0000 Joakim Zhang wrote:
> > > On Thu,  6 May 2021 13:06:58 +0800 Joakim Zhang wrote:  
> > > > Both get and set WoL will check device_can_wakeup(), if MAC supports
> > > > PMT, it will set device wakeup capability. After commit 1d8e5b0f3f2c ("net:
> > > > stmmac: Support WOL with phy"), device wakeup capability will be
> > > > overwrite in stmmac_init_phy() according to phy's Wol feature. If phy
> > > > doesn't support WoL, then MAC will lose wakeup capability.  
> > >
> > > Let's take a step back. Can we get a minimal fix for losing the config in
> > > stmmac_init_phy(), and then extend the support for WoL for devices which do
> > > support wake up themselves?  
> >
> > Sure, please review the V1, I think this is a minimal fix, then we
> > can extend this as a new feature.

I lost the v1 patch in my email inbox, but I found it by searching it in
web and reviewed v1. If going this way(a minimal fix then make improvements
in net-next) feel free to add below reviewed-by tag for the v1 patch:

Reviewed-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

> 
> Something like that, yes (you can pull the get_wol call into the same
> if block).
> 
> Andrew, would that be acceptable to you? As limited as the either/or
> approach is it should not break any existing users, and the fix needs
> to go to longterm 5.10. We could make the improvements in net-next?
> 
