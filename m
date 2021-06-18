Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A3C3AC829
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhFRKAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:00:43 -0400
Received: from mail-eopbgr80139.outbound.protection.outlook.com ([40.107.8.139]:21513
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232796AbhFRKAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 06:00:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPkku3GxG4deqj3HcTc5RXmG3u7VcqJAcA5V1S1cFoIwPQ+hNrXaOVL0/e229QJbaoNjgvOxd/0ZkYEBtpDoY4gMmpFhbRo+YxUrTGZ5j3htC1d0XNaAroq+1GDsfzvYq7qLTbBH6UUutbCuNPSkrrxP6qKb735r8ad/pb01xr/C3BUl+ofhiWvBpeOAX45oCG72zJIWnY4cFLR1raCgRGkaeulMhWhOxLMNPbp/twT7TcBIj/NmcmQZksk9pmz1bVNSbT4iOM5cFYYySM93KgI9vtMrZY3mtvLCrCeBbfuceJTqO1xP4YvBFSGopKrUbgQsAhjE8i5lya68C5jHgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zq6e0Dbl7iC4uyWpa/G+zETqKaJZFKQL1EoQXfWLO+U=;
 b=U0avEw0W0cXa47J/67FiSZ/Ep8Mw31rpKJrOb/YNy/OgGhODEy4zc6J9lLa1Pk7fGMD1RLWgtaNLIbth8ZRo7FNBBXFLAEwh6V6cEpE5Qi9RMc/bAwL70+9ksj/0f8LuO7a97yP2N3HvDZpMkaiWzDIxi2aRgUU/rm796PdV9c0z8VeKwQolGtkaKzQTMCcd5AzS/CQEzL2RxP+yOPDhAswCSI5GeqWYOJirRTKqBiVIqNRu4vNGrNaOa9t54uDfFqeNYFeKGL59/KZLA5tc0QWxcbOhiiRa7DAOgEOikYToQlrDdh7xkKDZpaZYnGEQHcecI71U29PM8BBgfTaJFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zq6e0Dbl7iC4uyWpa/G+zETqKaJZFKQL1EoQXfWLO+U=;
 b=bWC5as1rs7IKGZ/iLVUVn0nXRrYBOmQAGP+f7Av0hMfC/gO9odWjV/gZ2PMZgX0EPvyRYOQslXBlZx2Vah9cQAydN9pHZ1qoX3SbrsHqDg0Bppg1yEIX/oUsTmhQhzY1eK0K4EKu6BNBqrJMw6MNdaGevQM6+LvlE3Rd3uZoh6A=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0394.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.19; Fri, 18 Jun 2021 09:58:27 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%7]) with mapi id 15.20.4242.021; Fri, 18 Jun 2021
 09:58:27 +0000
Date:   Fri, 18 Jun 2021 12:58:24 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-firmware@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [GIT PULL] linux-firmware: mrvl: prestera: Update Marvell
 Prestera Switchdev v3.0 with policer support
Message-ID: <20210618095824.GA21805@plvision.eu>
References: <20210617154206.GA17555@plvision.eu>
 <YMt8GvxSen6gB7y+@lunn.ch>
 <20210617165824.GA5220@plvision.eu>
 <YMv0WEchRT25GC0Q@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMv0WEchRT25GC0Q@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P193CA0053.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:8e::30) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P193CA0053.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:8e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Fri, 18 Jun 2021 09:58:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c906f6b-0817-4808-5fb5-08d9323f9e6b
X-MS-TrafficTypeDiagnostic: HE1P190MB0394:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0394CB1ECBD83DF81F20BF35950D9@HE1P190MB0394.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vi1y3CZTHRNYa3XbUYRe/t30Lz1lchuy6qMjkNLAUn/vhBgqJWjnSS+ZCZuWqGjGN/+pGzzrJsjJ5+EcXlYxQjlz+GKyBT/cipLpIbUsaGRxZFDgsYMY2fen1KK6lSI/1tpj7IrQ6sVdyJKyi40NzS9on/T+vUi3L47/SolLbg1dIGcOYOCfKYb9AiygbgMKLpzGFefN10qv99vaYdJgpP3HpZDx9FiXPTOBqG95L+Nfxt+K6iR5+3QzwG2EeRY2dKM3iG6tesKQdagEIXABeVFari/kRBfidXYc/oGkAOCWgKdpiXFGx3q6CHhyngZ1x67j4BkxMcmWWPIEXb0ewdZ9hukT5MhOyysSBD3m5JzRFpt5hRFRcPT+ZOGbCGozktFle+xoQvLKoMVt4pxZgAq5vz+tLjZrC2SIfrjy1jbvV9z/OmWn6ypzCJSI9V0A5XGnDSKkY+S7UDVgQ2ap4pWRGNAwWHt4qjeKOSdMp/FqKalmzkSEkTHz1ZkfJi3KISr/ivTB1ug08uVz8hblht3n42ngzlvdODM8IH//RCHbcmLOAPhCP8/1dSnxU75HbEv+pC9OggpY29YO6kRjrGPxknUF46cCc10UE/kAR7bH80toWww+FZzlYLnOZvTNVNgTfRKZEiYg8BqO+HDNbl/nAx1Qomc9yaMu0zcu72kFGhhEFYHeAgFt0zoCoPfXR+eQiS8Uj2sKh2//qKfUURD4c0IKxLky4s60cOZqoQSOqI7wdogqceEJzo6HkR7Rnw4c9baBq4s+GtE++3Tzog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(39830400003)(346002)(396003)(8886007)(6916009)(16526019)(36756003)(86362001)(5660300002)(8936002)(15650500001)(956004)(478600001)(316002)(52116002)(7696005)(54906003)(4326008)(66476007)(186003)(66946007)(966005)(8676002)(2616005)(66556008)(44832011)(2906002)(26005)(38100700002)(1076003)(55016002)(83380400001)(33656002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uge0bSKaQfosC1PssUarrCRjEYrw/eASNAU5Ky1UAZPxuQG7lqSZvYwBbYIu?=
 =?us-ascii?Q?n0Hd0JNylAJ5J3x9C6x2ChUpuShBT8EdQwYagkFuhctAcOEX7C4Roz/JdTYR?=
 =?us-ascii?Q?DvxqcAs9i+8HjJQcMmjVCXdSbXJYFLt1cKti9JmeXXKAG2x9a6sUpPlTksG8?=
 =?us-ascii?Q?dVU1p1y7ZnAe70r4aDi975v6f48R6cncJWN3T5/nFX+DQ8d6tXBsFVayNeiU?=
 =?us-ascii?Q?utVJdfQNtA0COwRLBpdL3XPvzQEeZSmS1dOaCvMxLdTWc7wBcFudG8wX8oeq?=
 =?us-ascii?Q?M+VYg9NVNf63vHymFxQtYC/itqdRzjXUNBg0MztC9PL7SMPsueouvfGG7QqP?=
 =?us-ascii?Q?Vu3iNqYTQsGrqcr9GYOMjU5LVKQ3wG4ygWiWYurxFmD2iGf9loZwoFBfvsa8?=
 =?us-ascii?Q?mSLqYadUfKDp6Kd0S85NyBq+rgVwznMUWCk/OwKhsoETXce3C2nHTnLWdh5Z?=
 =?us-ascii?Q?+tD9djNv8ehJrvEmQvmVrw7KleQOFbTwNSDsJc9ErFqw3T5ezG+aNTcC1M53?=
 =?us-ascii?Q?u4vy0ukmd2QAtlrW0sLloj62fee0e7JMXsARwhf+i7oKFxrhLNEsEkcL5lI2?=
 =?us-ascii?Q?IUlyJC5EAIVy4NpNZoAWhrlLvar22/OEqTV66fVzb8TG906U1cWXF0T3L5cD?=
 =?us-ascii?Q?GnhVLuvJdhDHPwg1o/Sd9pzqsngW8NjNnYR7AqR3ZMv/5STcfNQSFeo38oir?=
 =?us-ascii?Q?x0gSm4ySmiCvjvgh5COJeJgV+vBBvDIfDvwCZmjpulCxIIvDRqxyKvKDuOye?=
 =?us-ascii?Q?t+GjybMIRNRL05wkW83zgBqKkP+xdMgHvOtPSZ3SQm1UWgyVwoz8nesgMnDd?=
 =?us-ascii?Q?RimO/v4ypcQ4qavy5rZJUwW4RVYylg6SnmO7uTNk3diEtRUXcc9yDhjmYvoG?=
 =?us-ascii?Q?7ckb2eaH/l841kq/aP+YoD0hChyCN0nT0aN2cvsRZDj+jGLKTc3z2KccE3Le?=
 =?us-ascii?Q?7s3z82GHjrEj5eV4WwUk0BxWFZZ+z/uIva5+W2zvkDJjxN+FoiF3bYAHuyeY?=
 =?us-ascii?Q?BgcLivtctV+DJe3wyvM+R/5TjtEOpuY2mayG4UuM4YRFFcWanq+IAdTbetlO?=
 =?us-ascii?Q?eNqSI/8T4merRjHBmUkFgDCpmbtqM8+3desdFjvJUZ5uS3to3gaQmsXBZD0b?=
 =?us-ascii?Q?1928uHw3QWrnImhK/xvBwJ6Beb3KG9gbccxcVLguuuOmX5kVtSTETE/KFhVP?=
 =?us-ascii?Q?B4HzBeI/oKb4A+jsWj9N4yog5+RbtT5Z6+jpe2UAI1Q5d5mqHcPkvh06tXem?=
 =?us-ascii?Q?5bEDaWZNQz2eG90BuEMg5Z1LqjY6VicK6o/w0+EVWOVwFo8Co8sbYandOJ1l?=
 =?us-ascii?Q?c7L65P7ItvMsKzXcxxCwGpOs?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c906f6b-0817-4808-5fb5-08d9323f9e6b
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 09:58:27.3420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cgb6GVk5W9kn0RSq1RqmFcPI189htFp7YftN67MeKMESzc1UAc02RSsxs7bu1wwkLgM6a23V4LPTELf7fjFISRx7dh+findurRaZvANxedM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0394
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Jun 18, 2021 at 03:18:16AM +0200, Andrew Lunn wrote:
> On Thu, Jun 17, 2021 at 07:58:24PM +0300, Vadym Kochan wrote:
> > Hi Andrew,
> > 
> > On Thu, Jun 17, 2021 at 06:45:14PM +0200, Andrew Lunn wrote:
> > > On Thu, Jun 17, 2021 at 06:42:06PM +0300, Vadym Kochan wrote:
> > > > The following changes since commit 0f66b74b6267fce66395316308d88b0535aa3df2:
> > > > 
> > > >   cypress: update firmware for cyw54591 pcie (2021-06-09 07:12:02 -0400)
> > > > 
> > > > are available in the Git repository at:
> > > > 
> > > >   https://github.com/PLVision/linux-firmware.git mrvl-prestera
> > > > 
> > > > for you to fetch changes up to a43d95a48b8e8167e21fb72429d860c7961c2e32:
> > > > 
> > > >   mrvl: prestera: Update Marvell Prestera Switchdev v3.0 with policer support (2021-06-17 18:22:57 +0300)
> > > > 
> > > > ----------------------------------------------------------------
> > > > Vadym Kochan (1):
> > > >       mrvl: prestera: Update Marvell Prestera Switchdev v3.0 with policer support
> > > > 
> > > >  mrvl/prestera/mvsw_prestera_fw-v3.0.img | Bin 13721584 -> 13721676 bytes
> > > >  1 file changed, 0 insertions(+), 0 deletions(-)
> > > 
> > > Hi Vadym
> > > 
> > > You keep the version the same, but add new features? So what does the
> > > version number actually mean? How does the driver know if should not
> > > use the policer if it cannot tell old version 3.0 from new version
> > > 3.0?  How is a user supposed to know if they have old version 3.0
> > > rather than new 3.0, when policer fails?
> > > 
> > >     Andrew
> > 
> > So the last 'sub' x.x.1 version will be showed in dmesg output and via:
> > 
> >     $ ethtool -i $PORT
> > 
> >     ...
> >     firmware-version: 3.0.1
> 
> That is pretty unfriendly, the filename saying one thing, the kernel
> another.
> 
> If you look back in the git history, are there other firmware blobs
> which get updated while retaining the same version? If this is very
> unusual, you probably should not be doing it. If it is common
> practice, then i will be surprised, and it is probably acceptable.
> 
> I suppose you could consider another alternative: Make
> mrvl/prestera/mvsw_prestera_fw-v3.0.img a symbolic link, and it would
> point to mrvl/prestera/mvsw_prestera_fw-v3.0.1.img.
> 
> 	  Andrew

I just picked some from the git log:

    48237834129d ("QCA: Update Bluetooth firmware for QCA6174")

this just updates the binary and description says that it updates
to v26.

Not sure if it is good example.

But anyway, I agree with you that better if new changes also reflects
the FW binary name (version) so it will be easy to find out which FW binary
have or not particular features.

So I think better to add new FW 3.1 binary ?

Thank you,
