Return-Path: <netdev+bounces-685-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA4A86F9049
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 09:41:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6B74281156
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 07:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C6915B9;
	Sat,  6 May 2023 07:41:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822271FB0
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 07:41:25 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2099.outbound.protection.outlook.com [40.107.94.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1541BE2;
	Sat,  6 May 2023 00:41:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ogNORB2CtIA0Gf6S9h/rfwrYzWp4fMv0vigiNhBjcqKs6E1dbJsuA94iHviQNnT6BZLGsT9v2TCvDtP8jl3WR2R43vg8mrqd9tpp3eHOzTZ25hubyhN5Qmj3mS7OCwwB9K0R4rBNgxqJe0dp2bjXg3v/jIi/d4ZSVhtweLjNGi2G2bDYtgyT70q6CaomvNRgru3NASxO0OuVkZQciK3PKT1bsksaQFaFt598i8J4gGzw2GpbdWk+BCMZjQtrnzocImI4cKWNakZchMVF7VwLdxGR8I+lP6T8QEpQOrNUGW3WKAA6IS8gWBS8fRs/FAYUMSr4R+DFnBIWsM47KktnYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3tBEdzpGebDUTi3T+Dj59WeSTzE+06hQectE4X90hQ=;
 b=nYFELf1DWC9b64ZL+gMseLMASzXxRWeUw3uFSqpQ4cnku8d/xNRMKZy+l/gkcODze24/NQOBLn0K/yfOtWBGoDRcvSzQyw3kMNI9YsuGtHOWJLYwgAX264KRFutc0cgR28y6z88Q9Px1ehyFvXmmapK4MAzU3rzx+I19eJrMHMZtdCH3dOw0x4/BUSkWYcMfipMsZ7Bp0G6ppo/5ljsIDtbccfYLWrqhxP7pgVwnRmQUorH4IDPGxyo15d7aKEShLFWtX/M0MYDtNPa9LepBwroIvL7EHImAH15UxOMW1rlyQ2bkrSWVX3vfJq4R5QJ+TRSxXFIwO2OGZsO0aBq+jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3tBEdzpGebDUTi3T+Dj59WeSTzE+06hQectE4X90hQ=;
 b=kC94lezOj3e/TYkIbvdEoUye5QXedn6EJHn0Wbg9CVBYAvLHvQ2Jmm6lqV4lMrh6Rz+osTCzMaG+94Ezwv31z3b/6JDmtSpHxahD7jJOo/E6Zzn5kACSjqM0rgeZfKprgXqMGppSR7TBbxeJtmGU5HWh7dhm2IgKYS6qvGGFpSE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5548.namprd13.prod.outlook.com (2603:10b6:a03:421::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.29; Sat, 6 May
 2023 07:41:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.026; Sat, 6 May 2023
 07:41:22 +0000
Date: Sat, 6 May 2023 09:41:08 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Tobias Waldekranz <tobias@waldekranz.com>, Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH net] net: mdio: mvusb: Fix an error handling path in
 mvusb_mdio_probe()
Message-ID: <ZFYElMmDqyhBzy3E@corigine.com>
References: <bd2244d44b914dec1aeccee4eba2e7e8135b585b.1683311885.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd2244d44b914dec1aeccee4eba2e7e8135b585b.1683311885.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM4PR0202CA0006.eurprd02.prod.outlook.com
 (2603:10a6:200:89::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5548:EE_
X-MS-Office365-Filtering-Correlation-Id: 132c5dd6-d899-43e5-9159-08db4e05499d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	B+vlzlp+Y4GLO0+EMtP4/4mGITURiTLWfQz9jlkXQFFWx8uaxhmu0i0VRS4mf+4AYorVaWwoM0/na6oVZAYny9myScoAYb0hdSy/qsQoB69odB40viRk92Yzc12LXu1y+UhDr2lP+54VnUprwdIC0Rqdtje0zHuPHwGZ44+kKd5xFvwm1/UTwDvkwM4WiPmA0u8Ctsl4vsBPjFp4oiFIVcgD3R0qxK9Z7TZpqo9T5Wz9nIDiBPmQehKYr7QFv9nIErh9Pr5FubFGLW2wI5Hsyymglq1xYEKnrwWN0v0/qijEBwC7BbORInBjjAmFQnVHJR+aqBqr8+LfyCyRnQxomq4ZgyNH5Xe4awApMXv6vFcLQTp0SjKW8S28DTNiuV2pPbO/nwwuQfv+PnWEWXl6bH4+DMpGBqvO8R/J7EZfNHShdYWCkqdd931vgCkyHiuH2sg8d1I7Y7P1Iz9HgzyARhklbQQ5ez+vBckcVX7DRjtFS9slhQcHrYJvqmRISa7Hqsx/D49YrlBvAegnC3wSAbQAZrFE5ICI8zCPrA9gk0gyDro5I9n4ZIt4DfymzoVW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(346002)(366004)(376002)(396003)(451199021)(7416002)(86362001)(8676002)(8936002)(6916009)(6486002)(66946007)(66476007)(66556008)(4326008)(5660300002)(36756003)(38100700002)(478600001)(41300700001)(2906002)(54906003)(4744005)(2616005)(316002)(6512007)(6506007)(6666004)(44832011)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mxYC9VFLHntGySs6s2J2dOHBAiFvrhjIT3Z0/Idfvslja6JCmOIUzqrZNpyn?=
 =?us-ascii?Q?jQa+tiEdYYXm7GuayUW1k8kwlFw5hOJ4yh04dDVk7OA3IqEEbr9lucVBXiyz?=
 =?us-ascii?Q?yT5hX2a+V1qqITSHFDvJy0rqlQjf53UNpqxyOqe34rHqgpSOMlwph6KhSdA4?=
 =?us-ascii?Q?RcSEKSjmoiu1Q8/rbspnGq66Ve1kljqHDeyrYhR3hd6psoSW6z0rTPlGvEb7?=
 =?us-ascii?Q?Rq0TJbQRip/4+pE7s9Pyg/8jm1QVFi15liFS8t9Smpo/dUoihUC7vwhJq1tn?=
 =?us-ascii?Q?AQl0i0bICQtcmImOm9mKuCBSm7k8AtvtX5FCa2nuq60+Ukl5PS4JIy4f94kf?=
 =?us-ascii?Q?tWZtsQS6rGsc31uQ8nCLBEhs2u5DVY6LiGW3rtrdP5OG4zu6luJDlTq8oKQm?=
 =?us-ascii?Q?g1+aKvszL0/KPdyhGSvmuYsQweih532KZ2h8DB9vQerIMy+dhxNOrWO+iqjm?=
 =?us-ascii?Q?V/ZOpzT/0iabxPSMjKLKfao7xY/2essIQfIXRiQ8k0NFp5aHdXAwo5wRGi8e?=
 =?us-ascii?Q?tjWxO69JLrXzphpFIgvZrL54iRp30XTrkDXrf5mBCDOUe6tiCTJEm34K8OCs?=
 =?us-ascii?Q?cUWIFd8cM4QbmuCekeriwvBubQqONY6mzI+PTQDln0W9kmPLhQavF3eR7yPn?=
 =?us-ascii?Q?PjB51KTPvsReohQMpt4ayClJmZRkId1HMmjPYZF65X8ZPtJEW5m+OuRGTx2c?=
 =?us-ascii?Q?kllmLq7KiNz98zQKpdpLQykJV2+eZTZ7Ypwma3a/vn9vOgjJ4XmSfsfxKJam?=
 =?us-ascii?Q?lHGNIsL10ZKbKok7+Au8NyIJzsg4vZFJ4+IXbnY5b00F/H2T68BIBF4SZJ7p?=
 =?us-ascii?Q?wKkRw9Sk+wqbn33ykoZ52zDoKCmjYHYnhIA+K9QMQf0hxNOu3qp3UhMx7V0c?=
 =?us-ascii?Q?UKlqKgHK/Zcj6uEPhRGbQOfRuXj9u/gZkKXIB0kS7U3t5RnZOJuJFVocVLmh?=
 =?us-ascii?Q?squuXz0JrWxR1SaE/5LewYrrNssMKj31Fu+RDyaA36db30vbdcU3OsBk5P5X?=
 =?us-ascii?Q?CI0A9nmyhVictSZP/7XUrUUSZln8IWgcshzXrxwR9/RKbsK9/9wUQuzpqNBj?=
 =?us-ascii?Q?lVP3tJilacwF/F4P4cagoOxJW7A00LYNbZ6OK4b3s1g5zk3Ivd61cQ50lHdp?=
 =?us-ascii?Q?h2h9qyX6nRoFLTnDtqOjC9U1p07v1ySNag+wDJBASAblDFqD/IqMr/Gk9y13?=
 =?us-ascii?Q?QFrr0S/UMrDcxWFG0D36db+o6/CoqF+GZ6C/KpmmIF4aj7PauDxkBp8jyDCo?=
 =?us-ascii?Q?xnf0Ulvo2NDrhFcvMPP47qUSSC0V+2CJe0mvF/3OCVKM7SOTMn0twP4TgOFb?=
 =?us-ascii?Q?si3CN2hOaj7vMnkqUk7UT/diHp0dGqJ3Sd9gVoYU/4vmCenK57xGthoDdOip?=
 =?us-ascii?Q?nEbE1uel8pGtG2VROby0TkKsIxPc2wsdrTmE9LitsAikOhz23LOiE0gq8KzY?=
 =?us-ascii?Q?Q8d0LHYROOgLwKKuSopJut+rwU4t7bntKHlH/1h0vnGnX74zrk8Wp/TXYtzR?=
 =?us-ascii?Q?zsuwAMlgkm+BkWc2+U+Hmw/U3cXcJQ0MvndG6sqMDBemNm0G9mTkp01572is?=
 =?us-ascii?Q?3iDaAFTf1LxQUghl5ZSQhFTDM8QGtJh7k0MyhJpa41pV7btCNabKpIDzFyYr?=
 =?us-ascii?Q?jsCknb14cMDoU1KkCAogvtBOPk+vQuPw0KeQpvzNscMNor+ONnbawpXko/wy?=
 =?us-ascii?Q?J5Aa8g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 132c5dd6-d899-43e5-9159-08db4e05499d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 07:41:22.2601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +NnClAShWGo+iUeY4iy7l77RVis9deYGgTqWjdTRi9UNzX5HwiEB/LGk/1DAqu2EgobjVQNJiUQhiSTfh8kLeE9IvpiLVpZ6OvBIdnssevM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5548
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 05, 2023 at 08:39:33PM +0200, Christophe JAILLET wrote:
> Should of_mdiobus_register() fail, a previous usb_get_dev() call should be
> undone as in the .disconnect function.
> 
> Fixes: 04e37d92fbed ("net: phy: add marvell usb to mdio controller")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


