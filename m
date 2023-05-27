Return-Path: <netdev+bounces-5910-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07E21713514
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F9721C20A2C
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67667125A6;
	Sat, 27 May 2023 13:56:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9D420EB
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 13:56:53 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2133.outbound.protection.outlook.com [40.107.94.133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0F6D9
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 06:56:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMi+4OUCrYNBpCq4L4YF8VLc3xsTfStLO70TQ0ZxmA0+T0oUqxocYeZdNlmN1+EMm7PpyRPT5gecC3VYEcaSkh/4/kWJbDUgQk+oUF2v6xQWo+TFQq4faAOJ5K2Cp3zQbOjTWWY07MVrHKl5mQsYwI/uzHWs8SOQO5QCFe/9C3Dm58NVaFrJFcZjXMGo1luEW4cvzQUFW01GLo1/QqVylm0Hfq2a34+YTMXU2B3EnF2UolPSq1TOlUt+zIJLJL4jQG6Ufj3fY6Em1tsFB+4fX00qb68uQGB1nd3CwA85ItkvB+HKFBULqq21l2+ze9ugKKE3r15Ot5YFtspQ+hTCYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fCJloE2AjBpsYv4ZhpW4fp9m4a9kFaDg9RM5LfjyYfw=;
 b=lQeFQapnVTCx2+MPmgjPEfxHZwv6Da8SBZQ5VAZUBD+xilxYpTO6G6uCOuxImnCVX9e1KSD+mTOEpPKe6FSzdWTK8rVzsxKVL+PMvGndmUdHcmgzYEbD3rXAluBSGe2xiFhH11dAeViADk6nnLli+A3JQre7oGFI8oBW4LlYXoMgAkNsfQvqBluObtjgcbZcwDJVJYBeNNGUYfjEwGucRLnSEt5ROC/YrHD9wyd+dMHi4fEEuDsQnPU9+xT074Z+yzsfaSa3Y92ivCPRmeViVGvnYJCHOoV6vR29Syj6lR8MwuqsTKnSZXBwxtsIdBGdHxeuJqgWggNUyVyQ2p2iJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCJloE2AjBpsYv4ZhpW4fp9m4a9kFaDg9RM5LfjyYfw=;
 b=iR0gOUVj0l0qkLqOgSOcjxOvC4F9wUdCmX++rtuVOsrO9aR/Msy/Tvr+JQWTZE9m08JjwWaQswho9Ho5qA/JuX+OYF3scBjwsKwzKsk9Ss2D38eFwR1aQSFYsa3BU2A7DIjw3UTyQOpwo6o1zD5t1qvNSIVUoVRer1HTjcTKJ3g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM4PR13MB5859.namprd13.prod.outlook.com (2603:10b6:8:48::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.19; Sat, 27 May
 2023 13:56:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.018; Sat, 27 May 2023
 13:56:45 +0000
Date: Sat, 27 May 2023 15:56:39 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Tristram.Ha@microchip.com
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs.
Message-ID: <ZHIMF8k+bYGosakh@corigine.com>
References: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
X-ClientProxiedBy: AM0PR02CA0024.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM4PR13MB5859:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e25b9a8-90d8-446a-13dd-08db5eba350e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ndVW3ejwch1t3cqtIpbMnVOV+v8H33aRLD5ougLYF7E+gpoxXAqtvyL197uPFoeUvtcvuPi0qVbhOJ1vHPTHrPsQqz+s0ScfjBJAvN6Oan0QurzOwDX3NV/qetZwzfk6/qI3SHy2YC/lv31QrTWAy+lWWN0nw3xrG++gAOlX9JOFO4E1LbLaPAyD26ckb49foqCJ8+wfMie2hR/QBw8HLRclOO1bfsNFr7Wlw273GP5Ny2y0ZwWCnDgGvGZSLViepMrzuMfdtz65uQWP3T9DpHO60cMXDNFyNdZecqcYrfD9TnJHYbQ1WhEp/HDRSmhAOAnQz2QeuRQKiBDPCYGqDoT1ymGPd2hn+ek09P1Wac3r87clfyeYfPPtnhUlM0Fu3OJ5+l/ue9KdR87p5l+vsutnLC5Lq8rsjFF4Pv7tH3H2sUq2sVHMF7bwpF8pPvh3PrHBeg+xLNdoUc+4MoluFVTg/10nxz4HpCnAf4vBqB0/GjYakbGLXwru1IwkRUtRbbuV6PTt68h8inJp0N/zLEdDHMtBww1Pu+WrNgwKkTbTeY1aiSYbMsqJVFeAyrvG8xpybPyp2pIJ+MajXIZ1XDbRYnn1+wGU7V2RXSnqijE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39830400003)(376002)(346002)(136003)(396003)(451199021)(86362001)(36756003)(4326008)(186003)(8936002)(8676002)(41300700001)(83380400001)(6512007)(6506007)(2616005)(5660300002)(54906003)(478600001)(6916009)(66946007)(66476007)(66556008)(316002)(6486002)(6666004)(38100700002)(44832011)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PKMI9Osk3eDZDZ/LHy+mv6eSUkNQi3Tk9/0Co46QKSkmBPlY7F7EZbmAhCHz?=
 =?us-ascii?Q?y1zkPH/tMEUoK3YA3BCgTQ9WRf6zcNUaI0vEPKHKXS5+TEdoqlHgHosU5DX2?=
 =?us-ascii?Q?O2/esEnPf0Bag5mM5mYmivWUoDobaWdsc4jmF7tSheel+ymDbNNv3t7UaCYq?=
 =?us-ascii?Q?oaaYSQ/vzO5gVD8WaOPnvBi8oZ2MLk+dnWYgASurkPEZu6g5Tms3STMQOoMk?=
 =?us-ascii?Q?wSekukkWcxPSHdOrr4rj1tdKPAMgU4y/l8BXdhj/XUYDxwdt3T2yke15wx7w?=
 =?us-ascii?Q?pH7fAbGWKke1Di6om6Ejk1GhvAKA5bgj0EOqaswuTMSLLhcmo5VXdAC/IIAN?=
 =?us-ascii?Q?ameZELr/gR1rN4lEoP8xuoU6ZH6x4jNjYkrsNZ0PiCsCxDAht3YYvx0+ZFp2?=
 =?us-ascii?Q?h97BnkJJQlleqZoMeUD671EN8ry/3rI3nABgjStSQ7rDi4XckyJtt7yXng0R?=
 =?us-ascii?Q?VvjyhnTtUSi4eHaY32KaQOy7sskIWDOFpumrYBX5mLxG+LaLRfUuvfBbVk+Z?=
 =?us-ascii?Q?iPm0n0WdmWVIfd7Xvn/oRLUborsrSGmae3jjhD9w4eTFEFz1U2uAyem/Eo3d?=
 =?us-ascii?Q?EgKRD54K/5YawNSQ5RK4Hq0tw4KsIZjPi+E5Ou0J9KBICE87tLmLEJyGMqxV?=
 =?us-ascii?Q?mLLifrO8njcTMHEB69Akw5ftbdjvB3aab+5VvJBihrhaKxwJRV/IzdcrA+ur?=
 =?us-ascii?Q?xIyTkZ216E4/8n3NbScbyl4bEy8Xbj2nU5thBRKFBibQvEw4hoADlIvYanf3?=
 =?us-ascii?Q?TXoSUqa1qRXtkZoq4msxMZFd2UF3T9hyBBKsOe4DhzrVBSdvhtHeHugJsl1H?=
 =?us-ascii?Q?rnJ4Kl4Hg0z+fYaAVHu6DjatUyJWFOxI64B7gHzt1Qa8ew6ihKYy4ygu0eiD?=
 =?us-ascii?Q?zRNn1X6ygFuThJzITfFzf6prSl5o16pH8K9ZPiQBpO2CE5NvSIb5TEQ0Vk6h?=
 =?us-ascii?Q?qyKhXJRTUGqrbWyPGcKWKgepWp6TjrIjJLnxm6lpezLkHwUQ+QSmvb9m0Boi?=
 =?us-ascii?Q?rtk43opmwlZiX8nAVfn3/i0sP7iTpf81DSNa8E1x4UMA0n0LpisdTlaU30Jj?=
 =?us-ascii?Q?QyN15RdfNBGw/Jbw67ET1zjeeLhijG/LOHoPVNF7x6coXlp4fLI3OxKdj/NY?=
 =?us-ascii?Q?sD9+h6waOEhLqup99KtK+/5FF2pqfeh4kX6kkDGIVfqUOh6ngXR4dB1C+agv?=
 =?us-ascii?Q?U/Q1M0RoalqT8euH77L0v2ubJwhBGsBB+Kni2vgNRFvj9aSgaHw5VA9p3sW3?=
 =?us-ascii?Q?emuPI1tia0ADkQiKfME1OThEpxBzudpFc7CLfkdKGHHXjjMNze/Grjlt8CDq?=
 =?us-ascii?Q?mCbQEA8uBfk7LzpqKQJ3sqQL1Wmd24c+SI9ZOD7+X3MS6U/YxoNMGLkPHD6E?=
 =?us-ascii?Q?wdodAcRRxQhZwZKsuTWgyngNj0h+ihrf6cDsB6Uz30rYHdtFUbZDp4n1e77s?=
 =?us-ascii?Q?avdcd8tT0v1SQT2H7buF9M4D1mDR8pCaQj++8RhDPAGNUTkP9wJtqMZJ32sB?=
 =?us-ascii?Q?W0p1lvmmetOm/qJ4n1l6ZF1KNtKPGxhQSoZJg3ECZhllGhVK55hTGVVIft3a?=
 =?us-ascii?Q?rKtZ/rRr7H8bV7JtMkkaW5cwCpR/AkU9d6EcDtldM8id8jUrmy5vBpRFA9/3?=
 =?us-ascii?Q?45u9oVshTTmBR7wBP2ePSAbaSA0uC8yvPEc5ViTq/7vfavf0INDNVQyZDc/7?=
 =?us-ascii?Q?dgWnuA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e25b9a8-90d8-446a-13dd-08db5eba350e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2023 13:56:45.2452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7db6eix1jL8fI4GlR62x6B3eirB86poMWUBTZ8eN9B0qg2tmTEKMmMME4f1EaAPaYuX/xSOPGoiTKlDfqu1NGRCHb0XTeB3lsmguyW9/Nic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR13MB5859
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 06:39:34PM -0700, Tristram.Ha@microchip.com wrote:
> From: Tristram Ha <Tristram.Ha@microchip.com>
> 
> Microchip LAN8740/LAN8742 PHYs support basic unicast, broadcast, and
> Magic Packet WoL.  They have one pattern filter matching up to 128 bytes
> of frame data, which can be used to implement ARP or multicast WoL.
> 
> ARP WoL matches ARP request for IPv4 address of the net device using the
> PHY.
> 
> Multicast WoL matches IPv6 Neighbor Solicitation which is sent when
> somebody wants to talk to the net device using IPv6.  This
> implementation may not be appropriate and can be changed by users later.
> 
> Signed-off-by: Tristram Ha <Tristram.Ha@microchip.com>

...

> +static int lan874x_set_wol(struct phy_device *phydev,
> +			   struct ethtool_wolinfo *wol)
> +{
> +	struct net_device *ndev = phydev->attached_dev;
> +	struct smsc_phy_priv *priv = phydev->priv;
> +	u16 val, val_wucsr;
> +	u8 data[128];
> +	u8 datalen;
> +	int rc;
> +
> +	if (wol->wolopts & WAKE_PHY)
> +		return -EOPNOTSUPP;
> +
> +	/* lan874x has only one WoL filter pattern */
> +	if ((wol->wolopts & (WAKE_ARP | WAKE_MCAST)) ==
> +	    (WAKE_ARP | WAKE_MCAST)) {
> +		phydev_info(phydev,
> +			    "lan874x WoL supports one of ARP|MCAST at a time\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	rc = phy_read_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_WOL_WUCSR);
> +	if (rc < 0)
> +		return rc;
> +
> +	val_wucsr = rc;
> +
> +	if (wol->wolopts & WAKE_UCAST)
> +		val_wucsr |= MII_LAN874X_PHY_WOL_PFDAEN;
> +	else
> +		val_wucsr &= ~MII_LAN874X_PHY_WOL_PFDAEN;
> +
> +	if (wol->wolopts & WAKE_BCAST)
> +		val_wucsr |= MII_LAN874X_PHY_WOL_BCSTEN;
> +	else
> +		val_wucsr &= ~MII_LAN874X_PHY_WOL_BCSTEN;
> +
> +	if (wol->wolopts & WAKE_MAGIC)
> +		val_wucsr |= MII_LAN874X_PHY_WOL_MPEN;
> +	else
> +		val_wucsr &= ~MII_LAN874X_PHY_WOL_MPEN;
> +
> +	/* Need to use pattern matching */
> +	if (wol->wolopts & (WAKE_ARP | WAKE_MCAST))
> +		val_wucsr |= MII_LAN874X_PHY_WOL_WUEN;
> +	else
> +		val_wucsr &= ~MII_LAN874X_PHY_WOL_WUEN;
> +
> +	if (wol->wolopts & WAKE_ARP) {
> +		const u8 *ip_addr =
> +			((const u8 *)&((ndev->ip_ptr)->ifa_list)->ifa_address);

Hi Tristram,

Sparse seems unhappy about this:

.../smsc.c:449:27: warning: cast removes address space '__rcu' of expression

> +		const u16 mask[3] = { 0xF03F, 0x003F, 0x03C0 };
> +		u8 pattern[42] = {
> +			0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +			0x08, 0x06,
> +			0x00, 0x01, 0x08, 0x00, 0x06, 0x04, 0x00, 0x01,
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +			0x00, 0x00, 0x00, 0x00,
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +			0x00, 0x00, 0x00, 0x00 };
> +		u8 len = 42;
> +
> +		memcpy(&pattern[38], ip_addr, 4);
> +		rc = lan874x_chk_wol_pattern(pattern, mask, len,
> +					     data, &datalen);
> +		if (rc)
> +			phydev_dbg(phydev, "pattern not valid at %d\n", rc);
> +
> +		/* Need to match broadcast destination address. */
> +		val = MII_LAN874X_PHY_WOL_FILTER_BCSTEN;
> +		rc = lan874x_set_wol_pattern(phydev, val, data, datalen, mask,
> +					     len);
> +		if (rc < 0)
> +			return rc;
> +		priv->wol_arp = true;
> +	}
> +
> +	if (wol->wolopts & WAKE_MCAST) {
> +		u8 pattern[6] = { 0x33, 0x33, 0xFF, 0x00, 0x00, 0x00 };
> +		u16 mask[1] = { 0x0007 };
> +		u8 len = 3;
> +
> +		/* Try to match IPv6 Neighbor Solicitation. */
> +		if (ndev->ip6_ptr) {
> +			struct list_head *addr_list =
> +				&ndev->ip6_ptr->addr_list;

And this:

.../smsc.c:485:38: warning: incorrect type in initializer (different address spaces)
.../smsc.c:485:38:    expected struct list_head *addr_list
.../smsc.c:485:38:    got struct list_head [noderef] __rcu *
.../smsc.c:449:45: warning: dereference of noderef expression

Please make sure that patches don't intoduce new warnings with W=1 C=1 builds.

> +			struct inet6_ifaddr *ifa;
> +
> +			list_for_each_entry(ifa, addr_list, if_list) {
> +				if (ifa->scope == IFA_LINK) {
> +					memcpy(&pattern[3],
> +					       &ifa->addr.in6_u.u6_addr8[13],
> +					       3);
> +					mask[0] = 0x003F;
> +					len = 6;
> +					break;
> +				}
> +			}
> +		}
> +		rc = lan874x_chk_wol_pattern(pattern, mask, len,
> +					     data, &datalen);
> +		if (rc)
> +			phydev_dbg(phydev, "pattern not valid at %d\n", rc);
> +
> +		/* Need to match multicast destination address. */
> +		val = MII_LAN874X_PHY_WOL_FILTER_MCASTTEN;
> +		rc = lan874x_set_wol_pattern(phydev, val, data, datalen, mask,
> +					     len);
> +		if (rc < 0)
> +			return rc;
> +		priv->wol_arp = false;
> +	}

...

> diff --git a/include/linux/smscphy.h b/include/linux/smscphy.h
> index e1c88627755a..b876333257bf 100644
> --- a/include/linux/smscphy.h
> +++ b/include/linux/smscphy.h
> @@ -38,4 +38,38 @@ int smsc_phy_set_tunable(struct phy_device *phydev,
>  			 struct ethtool_tunable *tuna, const void *data);
>  int smsc_phy_probe(struct phy_device *phydev);
>  
> +#define MII_LAN874X_PHY_MMD_WOL_WUCSR		0x8010
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_CFGA	0x8011
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_CFGB	0x8012
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK0	0x8021
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK1	0x8022
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK2	0x8023
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK3	0x8024
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK4	0x8025
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK5	0x8026
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK6	0x8027
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK7	0x8028
> +#define MII_LAN874X_PHY_MMD_WOL_RX_ADDRA	0x8061
> +#define MII_LAN874X_PHY_MMD_WOL_RX_ADDRB	0x8062
> +#define MII_LAN874X_PHY_MMD_WOL_RX_ADDRC	0x8063
> +#define MII_LAN874X_PHY_MMD_MCFGR		0x8064
> +
> +#define MII_LAN874X_PHY_PME1_SET		(2<<13)
> +#define MII_LAN874X_PHY_PME2_SET		(2<<11)

nit: Maybe GENMASK is appropriate here.
     If not, please consider spaces around '<<'

> +#define MII_LAN874X_PHY_PME_SELF_CLEAR		BIT(9)
> +#define MII_LAN874X_PHY_WOL_PFDA_FR		BIT(7)
> +#define MII_LAN874X_PHY_WOL_WUFR		BIT(6)
> +#define MII_LAN874X_PHY_WOL_MPR			BIT(5)
> +#define MII_LAN874X_PHY_WOL_BCAST_FR		BIT(4)
> +#define MII_LAN874X_PHY_WOL_PFDAEN		BIT(3)
> +#define MII_LAN874X_PHY_WOL_WUEN		BIT(2)
> +#define MII_LAN874X_PHY_WOL_MPEN		BIT(1)
> +#define MII_LAN874X_PHY_WOL_BCSTEN		BIT(0)
> +
> +#define MII_LAN874X_PHY_WOL_FILTER_EN		BIT(15)
> +#define MII_LAN874X_PHY_WOL_FILTER_MCASTTEN	BIT(9)
> +#define MII_LAN874X_PHY_WOL_FILTER_BCSTEN	BIT(8)
> +
> +#define MII_LAN874X_PHY_PME_SELF_CLEAR_DELAY	0x1000 /* 81 milliseconds */
> +
>  #endif /* __LINUX_SMSCPHY_H__ */

-- 
pw-bot: cr


