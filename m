Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8141F3A9B73
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 15:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbhFPNGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 09:06:40 -0400
Received: from mail-eopbgr140097.outbound.protection.outlook.com ([40.107.14.97]:33349
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233060AbhFPNGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 09:06:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QfoM4Io6J3EsVayg7DBshFrYVresDp817a6CWFdhCfypm32wa2/fO+WCrEhlVsXWIMK6giNRYhylf0UbxXTjVbGS2fwZ1CSiMcVXlg/g9BNwRjCsMpWlGbh6T3NtwdXBmTIgqzRM0rY5dJY7ZsjAkZQd4isaeACbkLEtUodsr5XapN4AdrSwH0SSoy0H/0+sVTBztRdcWfJFk6WQ93v/9TzLxOLfv7i7o25Yg9VzcroUlAl9NOECKtl9KI6grJpxe3O/j3LX/hxDGdJClCHWfR4qCbtUIFBowh5qI6FQ2AOSIBoi6ZmYQlGNENa8702XVEHk0rfnQzTVb/8rHkxPPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDXlmlqb2B78+gWwQ7KLApJMXA9phpQLn7kOpMkUiMI=;
 b=KqGEvPm3g3PGBMN8bDHmJ7ItOHvXWc5jmkDxUynmpJfjreptZmI8RvEghEmxMx9N9GoNmDudbMk9es/IxHyo0cAbyM+eTnqFhkjUbzLA/rDU6/Rt+bQEKFZvOUo/Mry3aDmesJaCsBWvE88QzXFv1PjddVOufbGXlHXbQb8r6xShlm7PTEeG5Q4Y8UO1ZQ9lf8WjUfnmnM7lHAC7v09c5WIwxS9ALQb61GEoVorkREegdN+MzRVYpgL0uzfztmM0JrZ33tZbZ7XVToNCt7j+Unmtnsg6qRTrgL8C0F7TrpGxq5AqSa1c9x4fWJCj9jEWDKDtE9qb3w5BEhh94HWa9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDXlmlqb2B78+gWwQ7KLApJMXA9phpQLn7kOpMkUiMI=;
 b=x6MdTLl9lVFMpZgdqlPc/+l2e79wu5pBvQzcKFigipE1sgLr+YZaghWuHJReRnIp5lcpgcaNhdUI1xAt6DBYC9ftiQx0ykk20hXCYY9KvsGRwVJx/TpvIPRNqPQv0agN6MkAuDlqoD/9eLdmVuK+nFq1xQilVQDoOil47c+mmVI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0121.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:c2::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.24; Wed, 16 Jun 2021 13:04:27 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.025; Wed, 16 Jun 2021
 13:04:27 +0000
Date:   Wed, 16 Jun 2021 16:04:24 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH net-next 1/2] net: marvell: Implement TC flower offload
Message-ID: <20210616130424.GB9951@plvision.eu>
References: <20210615125444.31538-1-vadym.kochan@plvision.eu>
 <20210615125444.31538-2-vadym.kochan@plvision.eu>
 <20210616005453.cuu3ocedgfcafa7o@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616005453.cuu3ocedgfcafa7o@skbuf>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8P189CA0022.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:31f::14) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AS8P189CA0022.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:31f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 13:04:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7493761-d709-48e3-e8f4-08d930c7456e
X-MS-TrafficTypeDiagnostic: HE1P190MB0121:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0121D0CDE62CC60BE38FF1B7950F9@HE1P190MB0121.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4v3oAHOjRoPXHadYPbGBHcgomGutPleqEsxCc+h7pb3VuBP7hB62HyAETB8X/BV8cibgocFQk0NoER9LhbSWiupwmHXOR00igViw/+vhfwJktis/gRhsT6YpMbpSSO8jijFxWEIwqFlDd7roRxAXchcoe90HQ1PRK60c+vDcDM0TqSTaX9NMSK/M7w085MsE2ocUnNY3gauD6/U5lkaxXmM5fMzxfNsKAF3zAFMDktIgWMOkw6QEYct/b1ztDcuaZhtQGkeolFUe9t0A0ghjB/Rvfl8cVHlSUkuGqP7wFlMK+//4yh0dB58HE40EwM7GfN95JgqP4AgwS3xpuEUM72j/oqkB7Xxey2+xSSPFzGpYCZuzZ0gK7qIkUoolEo9ZXBKUoiiAUxjZtZPlKMT621Tc8zzNlcUcchtqUmkwa1Ds3mCmszpRxRmoCI4MEbYoFtXixmR3sN2Rs5oAeefs72qgGN6wu780i8S1scELy/kJZ+p8aex4GkHzxozs+AfCWE3/vYzHmUkgcJvtoQEykmj32tkBDe+ydWVmfEjwB7NS+qFJh7HgP7TLk6iGFC9PaHtXuR9mfXUrla3ii/XjCejVk4KBCRMW8MZ++fAdGzZcD43S7gL79+EG91jvDv+wVvXL18bdOrZhzq/knU4R3TSUaT7wqJkv/juA+8JeE/o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(39830400003)(136003)(366004)(396003)(376002)(8886007)(1076003)(36756003)(8936002)(44832011)(6916009)(8676002)(2616005)(83380400001)(956004)(5660300002)(2906002)(7696005)(33656002)(4744005)(316002)(66946007)(7416002)(54906003)(4326008)(66476007)(16526019)(478600001)(38100700002)(26005)(186003)(38350700002)(52116002)(55016002)(66556008)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?23Q8wap5bJOeLEP4atxwjpEQWwOlOxYj6UV+jWwIqGDpVjCtBOgItr91f9Md?=
 =?us-ascii?Q?NxkS34oiCZrlyk49EclJYeo8jX48Wysk43oURGagcvhDqAqAeD5+QKbRgdPk?=
 =?us-ascii?Q?9a9uavuGGsUg1rO6Jyez2y2KuhP5+AS+kVPDtGZ9WXJleDV9wrxbS7CTGAdq?=
 =?us-ascii?Q?syoCwjqJHjKPxLFq902V/LgX52terB5Ugi0usGQPZOCDnU5ma+TPjeDch0Oj?=
 =?us-ascii?Q?hHS8QiMcNztQfQAn0Tk2TSFpamxgweT9QM47U10NLRhaMUPydzaaOXaFxGT/?=
 =?us-ascii?Q?tzCmyrLPWAEVeoBDXhTqNiHK3wVgp2HQNbFCjtBB/3e9o0uc2O4zjm83IUNP?=
 =?us-ascii?Q?nCGq6LD5wNs4zjOTawsVNhCCSS+jb2CD5xl8A/4ynMRlm1J8BlXQjnZobivT?=
 =?us-ascii?Q?JxAot6OjIf1Qk/EVJwk4bUh7OqJB+0NiDiENkZ6bwtEW2fXQ5GkIs4TAxjOC?=
 =?us-ascii?Q?iUal09ec1O7iOqXotWHfFTSTG6btw8QuUnqdJoplQv2t7IMJfAhpRkAGNw90?=
 =?us-ascii?Q?YOxYxp5qK6YQKXWBk60vtVEI9+PRrX5r6buOPvKv0c5N+gda7QYA6YTNbjCi?=
 =?us-ascii?Q?Mr5HJSelh+CXR3Cu6YBzey/r8RUSAcN220fq/RTZRdrC/OvU3wg6k6Azm3lS?=
 =?us-ascii?Q?QMsGBC9WcQfZDv6M9o4flDUYYZAxm7oiKoHVuYZ8c/CcwyE48xaajKihia22?=
 =?us-ascii?Q?cvd6AcBLQrhtjOXMOxH9pgsdKjLFVQtRrcmvZshYAdvBDFMva1e6YGs+LU6M?=
 =?us-ascii?Q?EuDRsQwmhyCFgzA+Q+sgSWCBpIXi7oHeoU0iCOZnTHGFusHnmuMQulHF12TW?=
 =?us-ascii?Q?nKm/vzfu+0ogHp6ExylYsA+DFsdeOgY85r7qySj0tjBLCnQLBqxJFnQOsDn9?=
 =?us-ascii?Q?tZ1yMt6JgcqFj84p8hJpmtiDwVRPfWCuBoatjk0cwrQMKc+GOWsoGV0qz2Lw?=
 =?us-ascii?Q?KgSBAD3dadJ2i1YTuZcNUQLODYpJr2foWyOxF78UIL5GiMQ9PDGkDsbMoIfH?=
 =?us-ascii?Q?ZUykg+Xg7nd0JpYRpSLgCdiq7lQyJLuyW04CnT5AYkECqnmVvbSkZ3jTZHTC?=
 =?us-ascii?Q?Hk8LI1lRtxX5SIGoEvzc+O3MrW8Uhf4Xdl74+/+iOLRznZ2UcQzsG89hxhcr?=
 =?us-ascii?Q?sMg/8hm/N/n1e6zC9vxygD4ShY4ouVMIvx079c+c4goKkKLS5ZpFKgYfQx5y?=
 =?us-ascii?Q?6fhYUvTknNYeaoiqaZGcV8qujmw2sJ4sDd5cLiSpJVL9cfe9qMLlMqAN7eLU?=
 =?us-ascii?Q?Hv5iDp6xA0ffTALbkJaGzFPalg/dxZ5dpjg35Aa9idWPBMhP4BO9qSg0F0qp?=
 =?us-ascii?Q?lUW/vpR8b9BE/83DIcxoEBQt?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: b7493761-d709-48e3-e8f4-08d930c7456e
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 13:04:27.3426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0a0pXdJqg4NFro29P7P2+40MFhk0u/zk+U9NOCq0sTE4F+1bsFifBo0aJTJyGWN9PcdUSv/z0AuDw6Y3BxFsFq+Qzhez/pof+IOxNHxU8wU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Wed, Jun 16, 2021 at 03:54:53AM +0300, Vladimir Oltean wrote:
> On Tue, Jun 15, 2021 at 03:54:43PM +0300, Vadym Kochan wrote:
> > +static int prestera_port_set_features(struct net_device *dev,
> > +				      netdev_features_t features)
> > +{
> > +	netdev_features_t oper_features = dev->features;
> > +	int err;
> > +
> > +	err = prestera_port_handle_feature(dev, features, NETIF_F_HW_TC,
> > +					   prestera_port_feature_hw_tc);
> 
> Why do you even make NETIF_F_HW_TC able to be toggled and not just fixed
> to "on" in dev->features? If I understand correctly, you could then delete
> a bunch of refcounting code whose only purpose is to allow that feature
> to be disabled per port.
> 

The only case where it can be used is when user want to disable TC
offloading and apply set of rules w/o skip_hw.

So you think it is OK to not having an ability to disable offloading at
all ?

> > +
> > +	if (err) {
> > +		dev->features = oper_features;
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
