Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A8940F071
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 05:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244054AbhIQDjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 23:39:39 -0400
Received: from mail-bn8nam12on2111.outbound.protection.outlook.com ([40.107.237.111]:30816
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242037AbhIQDji (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 23:39:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fp/AlGhe8OyIBuSds69bbQQpw+4FjZ6kLfcM0v/bCIjQcpQVpAa7SOgQHnw+bep6IAKeNcIQJXj1bZMSzeNVshCVae5v7DdFIvpELLaf9ZNm6S7IQ86SEFT+UqrqvYYvnpG7OXDJs7ZKfsOMEAa64jzanmpStAVFlO7clhdfgicHXH67IBhBDoi8oz6Ppq0CgBhVhyQ9CDoaUjH5vUeAXTPEgfZ84Jab0ynJVpnG2932iP9av9SpboAzRYrF/IQs8KTtkM42SEjC+nsrkQM9eVqOg37KjNVRH/sJdfZ/9IVbgThYbG5TWrEnhfpYmv6kh/3UkeSxECxQFaPKXYVaNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PD0nfMj4Gl7WdVKXtUWIufmgHaBAPlOrc6QxMnzNKIg=;
 b=Pfug6MPGq/Y/LJ5dhgYHOVrI9nn7pZHZk4o/Li0d9c5n10BTBpxMGxeJVDMbVhgdMM9JyYNI7b5M7UjHJLNQ7KFDpeRdsloFcxYu1nmBSjxVJDvJkf8Ayj3SlOLoOKrs1qTbxE8er3gg1jAY9bm+0ngGNNGHFFSlpJr8ss4rgyXWsR760lxqC1j4EhZqj6r6IJD+9gQrnPYt0A7jQJCEck2NgMfO7t62Z/B5cVGwqggkL6hjMoumyaTkRyaWXR/HSj4IWQN6jWAqE/+ct1xTzD+YZskcEsEsjQKH/RIElKxer2k8FSwpN0mqpiabfyuzJb8mBqHRgZcG8aNkrYZ0EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PD0nfMj4Gl7WdVKXtUWIufmgHaBAPlOrc6QxMnzNKIg=;
 b=Eg68DNRgpA6/vBd3q58M7KLt5Cbd0wAoEq2TdnDtAZssIUznFV8qvQtFgmesLSEc9yjp8dTRMlS+RkXikXPZ5AybkHQ67wHsUbe9OtF9/+pNGg2jdsAfNVVG94z7iwVuLn2dEGHLxz/fG+RKeXtW2Sq3oDSywQiD0IyjMtSXOxY=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1342.namprd10.prod.outlook.com
 (2603:10b6:300:1f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 17 Sep
 2021 03:38:13 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93%7]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 03:38:13 +0000
Date:   Thu, 16 Sep 2021 20:38:02 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 net] net: mscc: ocelot: remove buggy and useless write
 to ANA_PFC_PFC_CFG
Message-ID: <20210917033802.GA681448@euler>
References: <20210916010938.517698-1-colin.foster@in-advantage.com>
 <20210916114917.aielkefz5gg7flto@skbuf>
 <DB8PR04MB67954EE02059714DD9A72435E6DD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB67954EE02059714DD9A72435E6DD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-ClientProxiedBy: BYAPR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:40::43) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from euler (67.185.175.147) by BYAPR04CA0030.namprd04.prod.outlook.com (2603:10b6:a03:40::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 03:38:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 494754cd-7582-4b4c-5fc1-08d9798c9375
X-MS-TrafficTypeDiagnostic: MWHPR10MB1342:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1342A7F2066F489BDE6913A6A4DD9@MWHPR10MB1342.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +XIX69lgP9jxCBkugjfNr5CFbisvTeYKnygBij72jdLzfzbeFeHa3W6AVNHHc4HUu1S2qgR1A1lIc49RQAG2pypqQhmz8tSUttYT+n2yiIqF7a5OWLW36AjzgXuXMLzTpMqSffcjndz1YQ1sOj0uJRfJS2xDAUH/dpuO8H6AKqHxTEz0shnjLOEl7wKE6564xwYLWqR1f6dzVwq2xptgzUqz2azxmU1ggPpQB8V+ShpY/HWTaMtZ6OeiJXNJ3lkWv8TR0XDrmrOUf7Q3pzPKXlkEmtnDAZPPzQmToeFQn3u/hEC9E4y1SclmBppgIe4AYR4KDJ6r92ZJjhQV6bo9PZPqXLTcn6PabH20VASH7NV0fyvaiH2LyVsnX3QCJ1UzvGcZqkEGsaC9LAGI9lo06zWlAtMNThSx+YqYsEDEgNIWgZ7HasUiIWv7bb8YeIYOdVwPX2/iPYxpY2eT2VZaf4Z0RoeEBbDJ4083TncSphAXX9feynot/1Un53HsF1PmiQby7DcvgJkoo9g8jnKGUuPma16ioeVCBd2BaqWrzfp53lG0PEQiJq0iBj8V5x4u2U0w3KSzea+hmgg21nGQDiUO4jdSnsPmPyfkfDAtgYIwcohlCwzqBYXldRZPOmCrvQwo0CqDoQRn6WTL3WFTxQhY1zDNyXTyV7IfOguCzWuH6kf1GMoSUpvdAhqY0tOHYklUqkv2FYEwdp8qC/6IzbXTbyeNiAlN7DP1uiIsmx9r4dxH/xfHst5pevN4kP7ZVwjyRU1s7rY6uT+T4UzAN0VUvsx+ui6x3N9yt+X8pEs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(346002)(39830400003)(136003)(4326008)(44832011)(54906003)(956004)(5660300002)(2906002)(478600001)(52116002)(8676002)(38350700002)(186003)(1076003)(83380400001)(55016002)(66556008)(9576002)(26005)(6666004)(38100700002)(316002)(53546011)(33716001)(66946007)(45080400002)(6916009)(8936002)(9686003)(86362001)(66476007)(33656002)(6496006)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTZ5TDdLc0JMa2hqQXhXVmtIQjA5cXVKVXMxKzRhVk16WUZDRVBVMWo1NWRh?=
 =?utf-8?B?NmhyVDZrYkdTWG1Pb0w2RGZ0cU83bytKL2xNR1JOb2Z0aTR4Q25UY3dnanhM?=
 =?utf-8?B?cEQvaWdXQXlvSDNVVFE5Qm5WNW95ZEFCUWs4U1RKRTdSZkllVWlZdHZSM2li?=
 =?utf-8?B?ZDRVWTRtcFJwblpHYUd3c3hJNHowK2poeTNldjBBVmVNdlFwK1VkQ0NPd0hz?=
 =?utf-8?B?YnFRNTNsZS93SDFoUktyYThlclVsdlE3Z3E3WG1BeERGN0dBS2h3aWxIb3B2?=
 =?utf-8?B?empYTWF5K1FTR1NyaXF0bUZWcjFzdWpPWG01dXlERDQxK2ttN1ZTOWlVbHda?=
 =?utf-8?B?WkJQMnhBMm1DVlZZbkx2cHFJeXRzTzA3Q0NCc0hKeC9YWkN0a01VOXpzRHQ1?=
 =?utf-8?B?SDhSUTVEWG5PejFidnZZTmtKaUZmY29BeUFZcXBBNzRCbFA0VDVjbEJoQnJM?=
 =?utf-8?B?UGM0YWgwM0lWR0VadU1CYTJibjRUWUo5bkZWaHduSFhyWldCMDh5VWhYUWp2?=
 =?utf-8?B?OHBYTEtodlQyUTlXZ2lrM1l5MENoTUJ4bDlmbWZBVllqK0xpNStLWjgzY0dm?=
 =?utf-8?B?MUg3VTJvUExEQzRwWFp6WEYrRmY3dXNDdk5IQW1ITTBrekk4bzB3cVAyOHVP?=
 =?utf-8?B?Z2lBQUlheWZRSDVxTU9acVVFcEFkZ3dJOGVneUh0T0lTMHNrMi81K1dqRUV4?=
 =?utf-8?B?TEw5Qk00M09mVTc4RlBuZmRNbHZ6Qm1WeTZIVEVHQmpYa1Q4MC9uaXBnUkRM?=
 =?utf-8?B?ZUg1ditMdUtHNFdKMkZNOGk5MFBYQjBqRGxlV3JScXNSOFlxaTc3MDVKU3B4?=
 =?utf-8?B?d1Q0MHJPVk5aVjlEKzV6VmxZd2tkbUc0aUhkUGZWeVgxOW1TT25nd09HdHBu?=
 =?utf-8?B?NjdVajdXSmdub1ZVaEhJcHdSMVBBM1UrVk1OZ2J2ckJlTklsVUx4dmNyREZC?=
 =?utf-8?B?U2U3ajJkcDRSQ1J3Y1k3SWs4WWdVc2RxdU9pRE5Rb1k2WUVpMHBBMGtwTWd2?=
 =?utf-8?B?VjJUM1pLOWtvYWwyZnAvaXFLS3lOY3dHMGRsM01tQXphTFVMSTZ1NlhvQjQ3?=
 =?utf-8?B?cUV1SlRjMHVuYnp1QXlZcVlFczVNUGw0OVd0WVYvdWMyTWYvcXQ5QjczYUMy?=
 =?utf-8?B?ZGdsQmRzKzEzdGQ1VFNxM3ZhbUVjTkRBUnNZanhDVFROSEdQQjVtUCtEeFVk?=
 =?utf-8?B?MU5uSThibDZjSDVlUUtLQXUwMEtjL2l5MGRIeUJnWFRuMmhXaHZwVkthOEhP?=
 =?utf-8?B?YktiQ1loUWlRaVdCYXF1NzRJMU5UMjQxeEVRdzJrWGpaNXlPZjRZWlRqd2Zu?=
 =?utf-8?B?MmFZUkQ4aTNLdlk5SVhhM09HUzRSTVdrQmhJdVJzeGRtenZsN29Pcmh5cjRO?=
 =?utf-8?B?SW4ycU1teEhVZysrU1FvV1FsNmZnc0lsUDZkV0xLdlNNRUYwK3R6SzNXeFRJ?=
 =?utf-8?B?eUEwUUwzdE1jcXRRanY3ckg4RHRDYzFSZUlqNHJqK3J6ZHNjN2lRMUQ3c1hL?=
 =?utf-8?B?azhSbU9zZU0vczZCMUlTTkxqTWovdC9lZ2ErYUhtbncwNldQU0VtNzFuVi91?=
 =?utf-8?B?SXArSmV0NzNlU0MyU09NUGdIZ2Mzb2RlSXo4YTNicmdmcXd6Q29Vc2UwdStK?=
 =?utf-8?B?eURNRGY2SDNZVkVwQXYvSWRDWjFxREZOUmR4ZS9QYnlOSWFiUnUvdEVGdGtj?=
 =?utf-8?B?dzJENFhVZWlEMVhpQXU5NUcvR0kxM0kvREJRRzdudTBTcUQzYStiVmNiYkxE?=
 =?utf-8?Q?+0RFmAVN4RTacuaaFuhQ1Hsz5j909Xec8mja7Kp?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 494754cd-7582-4b4c-5fc1-08d9798c9375
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 03:38:12.9439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GDXNmN+Zi+G8+bJS326je6296dgt+S+epvhjbuNsyJCKbDc/2Rr3wwpw5XxvUGHJaAwBGVzghu0E/TWQGVHbF6GIGCyA+cNOVpovG4WbJVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1342
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 02:34:37AM +0000, Joakim Zhang wrote:
> 
> Hi Vladimir,
> 
> > -----Original Message-----
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Sent: 2021年9月16日 19:49
> > To: Colin Foster <colin.foster@in-advantage.com>
> > Cc: Claudiu Manoil <claudiu.manoil@nxp.com>; Alexandre Belloni
> > <alexandre.belloni@bootlin.com>; UNGLinuxDriver@microchip.com; David S.
> > Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v1 net] net: mscc: ocelot: remove buggy and useless write
> > to ANA_PFC_PFC_CFG
> > 
> > On Wed, Sep 15, 2021 at 06:09:37PM -0700, Colin Foster wrote:
> > > A useless write to ANA_PFC_PFC_CFG was left in while refactoring
> > > ocelot to phylink. Since priority flow control is disabled, writing
> > > the speed has no effect.
> > >
> > > Further, it was using ethtool.h SPEED_ instead of OCELOT_SPEED_
> > > macros, which are incorrectly offset for GENMASK.
> > >
> > > Lastly, for priority flow control to properly function, some scenarios
> > > would rely on the rate adaptation from the PCS while the MAC speed
> > > would be fixed. So it isn't used, and even if it was, neither "speed"
> > > nor "mac_speed" are necessarily the correct values to be used.
> > >
> > > Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
> > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > ---
> > >  drivers/net/ethernet/mscc/ocelot.c | 4 ----
> > >  1 file changed, 4 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/mscc/ocelot.c
> > > b/drivers/net/ethernet/mscc/ocelot.c
> > > index c581b955efb3..08be0440af28 100644
> > > --- a/drivers/net/ethernet/mscc/ocelot.c
> > > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > > @@ -569,10 +569,6 @@ void ocelot_phylink_mac_link_up(struct ocelot
> > *ocelot, int port,
> > >  	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(speed),
> > >  			   DEV_CLOCK_CFG);
> > >
> > > -	/* No PFC */
> > > -	ocelot_write_gix(ocelot, ANA_PFC_PFC_CFG_FC_LINK_SPEED(speed),
> > > -			 ANA_PFC_PFC_CFG, port);
> > > -
> > 
> > This will conflict with the other patch.... why didn't you send both as part of a
> > series? By not doing that, you are telling patchwork to build-test them in
> > parallel, which of course does not work:
> > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpatchw
> > ork.kernel.org%2Fproject%2Fnetdevbpf%2Fpatch%2F20210916012341.518512-
> > 1-colin.foster%40in-advantage.com%2F&amp;data=04%7C01%7Cqiangqing.zh
> > ang%40nxp.com%7C546aa03ab17b45f0891a08d97908095f%7C686ea1d3bc2b
> > 4c6fa92cd99c5c301635%7C0%7C0%7C637673897688805938%7CUnknown%7
> > CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiL
> > CJXVCI6Mn0%3D%7C1000&amp;sdata=fmGI6K2dS36tm5xuuKLKdVF1pEj9umv
> > FLA8kyfXWD3A%3D&amp;reserved=0
> > 
> > Also, why didn't you bump the version counter of the patch, and we're still at v1
> > despite the earlier attempt?
> > 
> > git format-patch -2 --cover-letter --subject-prefix="PATCH v3 net" -o
> > /opt/patches/linux/ocelot-phylink-fixes/v3/
> > ./scripts/get_maintainer.pl /opt/patches/linux/ocelot-phylink-fixes/v3/*.patch
> > ./scripts/checkpatch.pl --strict
> > /opt/patches/linux/ocelot-phylink-fixes/v3/*.patch
> > # Go through patches, write change log compared to v2 using vimdiff, meld, git
> > range-diff, whatever # Write cover letter summarizing what changes and why.
> > If fixing bugs explain the impact.
> > git send-email \
> > 	--to='netdev@vger.kernel.org' \
> > 	--to='linux-kernel@vger.kernel.org' \
> > 	--cc='Vladimir Oltean <vladimir.oltean@nxp.com>' \
> > 	--cc='Claudiu Manoil <claudiu.manoil@nxp.com>' \
> > 	--cc='Alexandre Belloni <alexandre.belloni@bootlin.com>' \
> > 	--cc='UNGLinuxDriver@microchip.com' \
> > 	--cc='"David S. Miller" <davem@davemloft.net>' \
> > 	--cc='Jakub Kicinski <kuba@kernel.org>' \
> > 	/opt/patches/linux/ocelot-phylink-fixes/v3/*.patch
> > 
> > Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > Please keep this tag but resend a new version. You can download the patch
> > with the review tags automatically using:
> > git b4 20210916010938.517698-1-colin.foster@in-advantage.com
> > git b4 20210916012341.518512-1-colin.foster@in-advantage.com
> > 
> > where "git b4" is an alias configured like this in ~/.gitconfig:
> > 
> > [b4]
> > 	midmask =
> > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.ker
> > nel.org%2Fr%2F%2525s&amp;data=04%7C01%7Cqiangqing.zhang%40nxp.co
> > m%7C546aa03ab17b45f0891a08d97908095f%7C686ea1d3bc2b4c6fa92cd99c5
> > c301635%7C0%7C0%7C637673897688815892%7CUnknown%7CTWFpbGZsb3d
> > 8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3
> > D%7C1000&amp;sdata=t8N%2F%2FAnLVLtoMDzNDL%2Fv7ixEkBeiIqB6Go%2F
> > zD19gisE%3D&amp;reserved=0
> > [alias]
> > 	b4 = "!f() { b4 am -t -o - $@ | git am -3; }; f"
> 
> I came across this detailed suggestions, sometime we need download the patch from the patchwork,
> so I have a try with above method(adding these two symbol in my .gitconfig), but I met below error,
> could you please tell me what I am missing? Thanks.

One that I can answer.

b4 is a Python command.
"pip install b4" should install it, then export
/home/username/.local/bin into PATH
"export PATH=/home/colin/.local/bin:$PATH"

You can add this path to ~/.profile if you want it to persist.

> 
> $ git b4 20210916010938.517698-1-colin.foster@in-advantage.com
> f() { b4 am -t -o - $@ | git am -3; }; f: 1: f() { b4 am -t -o - $@ | git am -3; }; f: b4: not found
> 
> Best Regards,
> Joakim Zhang
