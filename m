Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0D85F4699
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 17:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJDPZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 11:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJDPZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 11:25:35 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2046.outbound.protection.outlook.com [40.107.21.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EE51C913;
        Tue,  4 Oct 2022 08:25:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrYtNqIkiUs9IXglb9auJ/CzpC70sfFA0CrgS9cEoTz0JnArdr+y/3XdUbb+0logjUkSanL/1C5xPA3D6T64SfePlweLqg1q6Azjlx5pi3veQvLASACr+7laetPhGz62lRzfMXrEnNmBm4yQlMEyqNOM9CeBDDjW5YNdY7x70pALFgrgQEDgH4KifZor3Mr46xYFKWdLlKcgFwID8UDf7AdgAxoMLuelzcIHRKCk9wLpKwvtXt91wOUmUPeZaw/o1q4zQmlOEMseRcZGpCY94Q5yI95FO6MsZI/hbawcKcbvWbItnbUhEz76phADeONmbH378llpI/yzlP3cE+8yUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rn/1nf+QlHOc7TvVPZitBgKsaqY0uEEOzXkpV0dOpPs=;
 b=DLta61T7pFv9vLikonoGw5NZ1uRGKmWvF7hjcjvseGGKuxTjHWJumq5qUqNoqhwnNQTRvx32HKSRrUETy8Sj65Zux1YYgSd8taBZbIhT4Fw5/Q2J0hny+v/yFUlZQ5zRH3vni5coWCzwR7qd/MN7zMFjBXy13AMhs56XdyzUM/hlpNeftoB2aPLVkRLO6KwZXRku/iqn8rDecHGa5EsBE9PBgkd1Yq1oyRxv6AHPyFLVxWXURMms6SJgdqMlflQ40e4HMqcohXQlPIwiTVH/AwtEazUy4KHeT8poOe7iJXv42i4Nj92QWylpXqBTvYeb/acHPDEXQF+mXLhRZL4rfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rn/1nf+QlHOc7TvVPZitBgKsaqY0uEEOzXkpV0dOpPs=;
 b=VGv1UQ27ywNoznEi4OxPha9wA5VlWaboibEXFqKFQaOgRcSsHInbKrgkmNR7zmyJkkrBu4UNrv4P1ZZENQGyuunLsG3vAZAZIcBk5ch6AAfAzz0iUKO3Y4HnxzKfp7uJJK9oSjFINex/oLQ6MQUEwCJTWyPtmlqkREQr2DkAOMh1GZwk3bNuJf79+JSDG6ppWfCpBga7am81s+xoYlxZyBgMg5AAGzpmbwflhzsRpPx7CK95UTemnmCQpmatR5bdje/51PpJfXdsQrdK+sJCX97m9nJQaJgup20r3fy6TWyTCAvdMXE3vHbiRJKFOiG977HKZaFYRnluyrcSzI3W8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB9PR03MB9734.eurprd03.prod.outlook.com (2603:10a6:10:452::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Tue, 4 Oct
 2022 15:25:29 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 15:25:29 +0000
Subject: Re: [PATCH net-next v6 5/9] net: fman: memac: Use lynx pcs driver
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>
References: <20220930200933.4111249-1-sean.anderson@seco.com>
 <20220930200933.4111249-6-sean.anderson@seco.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <807db1e6-fd51-0add-90af-1813a5d47fab@seco.com>
Date:   Tue, 4 Oct 2022 11:25:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220930200933.4111249-6-sean.anderson@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR08CA0011.namprd08.prod.outlook.com
 (2603:10b6:208:239::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|DB9PR03MB9734:EE_
X-MS-Office365-Filtering-Correlation-Id: c658bc9a-0797-41e6-ae89-08daa61caaf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2KaSQ4onbIyHxqgSJC1cIZdgdtw+04OvAoTz19xlhtD3NMXqCFhuwIac+8uq859WG4wB0aNmSimU6kv/vG7ZdxrPKdXqJyrNW5NY8cuPezQDrqCJB1+Fnu4QmK/e3noG0azfvq4BKTvVpuA7rI2z61ItB6Az87Vwl6n5ZjPVlDvdrtt9c2TYakGnRP5FXq24NVK+9Ok6c0acO3FD54chBQWROMYGW61rGAW37KIw4uJ75MwM3F+0krg9P1jlb2LALdPFefyqKQtJUmWgUTmI2q7aaNzRHzITWB94oAP9fVUdOfgXMwEsx5XTx1LrsygnqEZUb0oFTU/oc7ctnLNTwnXXyA266LerAOQHIYqsyOfY+J4MewJPOyrn79DKyDhLwRwz64SBois8GcXjDRmBohRtzRPMogWr7MLWSw7VelMeWKQkwji/fdgyMFn9r/F603b+PL6W1j2NO3vp0VjSPyIDKTzDx+nSSR5MflLS92QMj8AKbtU8jZ6vRwjbOcA+PxbCv6Rhwj6qOYuEdLSVlRF6IUn7hl6/qEWUZAc01Eb24dXPrS+X8dRmYyd27QiaTvnnswyThiSigr0efVyZbYjc2ZcuuYPwLUKPOFB4YEqob/ZK0T5SJGxl9ESiCavzsBHNuTgmNynqosfoaUrgxj18s5p4gB/ERoUWaMqWefFDJunBpiNH4RcJtwJbt5qCnJx7XnVe/WWTFDVEhTFpPLeIQv8dlFZqn4nGB3nffyLBa1NStvwy5955ydeuq9SqObCqFjwaEHgYRBGuqtOKuiHN/Igabmq1QJkp9XyUJT5ug2GsznVdZVeKRdhoLR0NsxJuR4x5X4KagT6/Eg2FkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39850400004)(376002)(366004)(346002)(396003)(451199015)(26005)(31686004)(52116002)(2906002)(53546011)(6506007)(5660300002)(36756003)(30864003)(83380400001)(41300700001)(8676002)(2616005)(316002)(54906003)(66946007)(7416002)(38100700002)(186003)(66476007)(110136005)(6512007)(6666004)(86362001)(6486002)(44832011)(66556008)(8936002)(38350700002)(478600001)(4326008)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjdYdjg4amd5eW1ZWDJTRUNsWS92Nnl5MC83ODRGUytBZ0l1Yk9YajM3clBk?=
 =?utf-8?B?b3dzWTRNYmNic0VKbUkzejVIQ0tvSWZBeDUrdVlhZ3JBTkY2Vm91b1BRNVpE?=
 =?utf-8?B?b24yL0hJYmZ6Y1dGWUllOXVld1crWlhVWDdXVGVnaE8wTldDdU5KT3pOcy9w?=
 =?utf-8?B?VVZJM3l6bitmbGh3dWxtb245TUU1R0RHcTRTbXFhUjhCTXMyM0p2bzliVGgz?=
 =?utf-8?B?U2tWa2lON1poVWlrV1hnemkybFNkUjNHQnZCNGVTR1dmRnRKWThzd2N1ay83?=
 =?utf-8?B?RDBVYTRXSWJycVhYRm9sZGpIMGIrQlBGWnppVGU2SEhicUFpVEtKaVFFWVBT?=
 =?utf-8?B?WjI5NHZaNjhvZjJ1NmRUcml0YzIwL2tFM2Y5d0pHSXFvZTVtdlZYck1BbXlY?=
 =?utf-8?B?N3hRU1NQM21QRWJ1RnFNY0NmV210dHUvcXh4aUV2ejVMSXRRSGU3VlRsRUdJ?=
 =?utf-8?B?Wm10VFdCVDFLZjhwdzc5OFJrc2JpUlBUOXRLK1VYdWRER21FTHVlUFFiaUpQ?=
 =?utf-8?B?aUlPOHFiTU9IK2RwbmVZeDdUSGhWY3NxR0JNaDVQa2hmTkdGQkFicUZkdzJU?=
 =?utf-8?B?NklUaGNJd213UFpqQXZsZ3FUTkVlbCttOHdiT25xbDZ6SEFIckErcVFBMHFj?=
 =?utf-8?B?SzZTQTc2WDhVYW5hcXlBcXBkRE1UeFRpMVhSdDUwVjNJNk9xMDRTNDVvaG9u?=
 =?utf-8?B?TGIrdklJTW1xaHVNdmd0ZkZxa0lkemMrVi9TVi9mNHNrVmgxNEQrZ01mUlB2?=
 =?utf-8?B?Nm9SeXBKMG9lU0NrZEtNUkNoZDZDaFZpV2ZQU3NtNit3a1pOMXF2eWZUVG1T?=
 =?utf-8?B?dE5qWnczalJsanlCWm4vN3JCd2hXMEp0WHhFOWZPb2MvaTJ5UVhPTktnNmRs?=
 =?utf-8?B?bVhsSlZiVWNydzhKZ2hnZjhTVGhyUlE5Rlp3d2Fzbm9OczRpZ0pQTFlaSlJ2?=
 =?utf-8?B?NGZpTDh1NFhpU0NqYnQrL2M3ZEw2K0ZvaTN3Z2d6b3ppVXRIQlFaczgzZ1Rh?=
 =?utf-8?B?Y3hiYlcyYWY3cVI4dUtCemNxSEM1YjBYa2Q3VVFBRy96blVRQWxCZ1hucDR2?=
 =?utf-8?B?V3RUbWZhUXBhUXNSQkNXUXRtWWhPNG9Ub0V6MEt0Um51ZlpRWVZ2SGxHQ0hh?=
 =?utf-8?B?RG5KTDJ4Q3dVMWZEcnlJUlVIZEVKUkVrSCtlZkZ2b093QnROMUxadmFPK0VY?=
 =?utf-8?B?bGxycUFNRFlBdFlJREY1UHVWRDNCNjZmT3liMHNZaHVrV2x4VXM4OElrSW1G?=
 =?utf-8?B?bk44SllReTQ5VW1xVnRxRFlObGNQV2NvK2dxMmprTTJONXVydnVMYlg1b0hV?=
 =?utf-8?B?Nk1rbWhOY0VmWUlqbjRBRmRJMmgxbmRzYVhpTlFZMDRYck1hNU1DNWI3TkxQ?=
 =?utf-8?B?Y3hKRVVNTDhOeTNkWVFtTWhsNTNRVHVROUdTOFBLZWc5Nk95NGhTcHpEVnBL?=
 =?utf-8?B?SkZVeXpBRGdWV281a2E5RVlFYkFTTUQzeHMyMW1aWXFtcHhzMnVUVGkrQWJJ?=
 =?utf-8?B?clR5WEVoYWRFekQrZnpZdlgvY1JhYlgzQ3IvdFlCeGhVTVZJdjVLaVdYa0FC?=
 =?utf-8?B?dk04eUFPOHUwYXVHRkFmaGpNZmdQN3RBUGM1TmN0UkV3cHJleUJGaEVXaW9Y?=
 =?utf-8?B?RFpTQWsvQ2trYThjSXRadzZKVWFhZ0t3Z0o0dlg0L0tyZzRZNGROVmpna2Qz?=
 =?utf-8?B?cXBiOVMyWUJRRkljUTFJdFZRTS8zSG44Umk3dEMyQjhDbFlONzkzVkR6ZG9B?=
 =?utf-8?B?RVRpTWFpMjlmMzJyN0N6a2NBOU5BL0dQRkk2WCt0ZTgyclVtNDBLQlJDb0p5?=
 =?utf-8?B?KzA2MGNMVExENStBaGN5dTVCN2pHaXdYTDNjV1dobkkwV3VBRlBuOWVuQytY?=
 =?utf-8?B?QzJvSFRGREtXSFd6VytocFBzSnEva3lMRnQ3blJOME80dkxLYWoyamo4L3BK?=
 =?utf-8?B?SlN1emRpalEzdlNLVCsyYXQ1aUFGTHJqdktHZEg1MFlqenBOb3JJRXBFZkV3?=
 =?utf-8?B?SVB2VzBUZUdRZXRqclhQam9xeWxXTVkrRTJ1VDhnQWdOQ0plc0RQb2pMeFVB?=
 =?utf-8?B?dVdmNzNBalc0eXRmTXcwallNRlNmOVNibDNzbVhEL0RjNzRrMEZxdytYa3JM?=
 =?utf-8?B?S2JHUWYrMFd5Vk5oQ1NWTlpNTlpHTXhkSW4xZjl5V0phYS9kdjl1RmhFSDF1?=
 =?utf-8?B?Z0E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c658bc9a-0797-41e6-ae89-08daa61caaf4
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 15:25:28.9272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BObxQJ2QVAyNgqwWctAr06Ri5IdGolaoqSLxaxaC4ko8dWl1CptT+FXNKEofkNGlRuGEFw6bobi2jikbc9lEBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB9734
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/22 4:09 PM, Sean Anderson wrote:
> Although not stated in the datasheet, as far as I can tell PCS for mEMACs
> is a "Lynx." By reusing the existing driver, we can remove the PCS
> management code from the memac driver. This requires calling some PCS
> functions manually which phylink would usually do for us, but we will let
> it do that soon.
> 
> One problem is that we don't actually have a PCS for QSGMII. We pretend
> that each mEMAC's MDIO bus has four QSGMII PCSs, but this is not the case.
> Only the "base" mEMAC's MDIO bus has the four QSGMII PCSs. This is not an
> issue yet, because we never get the PCS state. However, it will be once the
> conversion to phylink is complete, since the links will appear to never
> come up. To get around this, we allow specifying multiple PCSs in pcsphy.
> This breaks backwards compatibility with old device trees, but only for
> QSGMII. IMO this is the only reasonable way to figure out what the actual
> QSGMII PCS is.
> 
> Additionally, we now also support a separate XFI PCS. This can allow the
> SerDes driver to set different addresses for the SGMII and XFI PCSs so they
> can be accessed at the same time.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> Changes in v6:
> - Fix 81-character line
> 
> Changes in v3:
> - Put the PCS mdiodev only after we are done with it (since the PCS
>   does not perform a get itself).
> 
> Changes in v2:
> - Move PCS_LYNX dependency to fman Kconfig
> 
>  drivers/net/ethernet/freescale/fman/Kconfig   |   3 +
>  .../net/ethernet/freescale/fman/fman_memac.c  | 258 +++++++-----------
>  2 files changed, 105 insertions(+), 156 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fman/Kconfig b/drivers/net/ethernet/freescale/fman/Kconfig
> index 48bf8088795d..8f5637db41dd 100644
> --- a/drivers/net/ethernet/freescale/fman/Kconfig
> +++ b/drivers/net/ethernet/freescale/fman/Kconfig
> @@ -4,6 +4,9 @@ config FSL_FMAN
>  	depends on FSL_SOC || ARCH_LAYERSCAPE || COMPILE_TEST
>  	select GENERIC_ALLOCATOR
>  	select PHYLIB
> +	select PHYLINK
> +	select PCS
> +	select PCS_LYNX
>  	select CRC32
>  	default n
>  	help
> diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
> index 56a29f505590..eeb71352603b 100644
> --- a/drivers/net/ethernet/freescale/fman/fman_memac.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
> @@ -11,43 +11,12 @@
>  
>  #include <linux/slab.h>
>  #include <linux/io.h>
> +#include <linux/pcs-lynx.h>
>  #include <linux/phy.h>
>  #include <linux/phy_fixed.h>
>  #include <linux/phy/phy.h>
>  #include <linux/of_mdio.h>
>  
> -/* PCS registers */
> -#define MDIO_SGMII_CR			0x00
> -#define MDIO_SGMII_DEV_ABIL_SGMII	0x04
> -#define MDIO_SGMII_LINK_TMR_L		0x12
> -#define MDIO_SGMII_LINK_TMR_H		0x13
> -#define MDIO_SGMII_IF_MODE		0x14
> -
> -/* SGMII Control defines */
> -#define SGMII_CR_AN_EN			0x1000
> -#define SGMII_CR_RESTART_AN		0x0200
> -#define SGMII_CR_FD			0x0100
> -#define SGMII_CR_SPEED_SEL1_1G		0x0040
> -#define SGMII_CR_DEF_VAL		(SGMII_CR_AN_EN | SGMII_CR_FD | \
> -					 SGMII_CR_SPEED_SEL1_1G)
> -
> -/* SGMII Device Ability for SGMII defines */
> -#define MDIO_SGMII_DEV_ABIL_SGMII_MODE	0x4001
> -#define MDIO_SGMII_DEV_ABIL_BASEX_MODE	0x01A0
> -
> -/* Link timer define */
> -#define LINK_TMR_L			0xa120
> -#define LINK_TMR_H			0x0007
> -#define LINK_TMR_L_BASEX		0xaf08
> -#define LINK_TMR_H_BASEX		0x002f
> -
> -/* SGMII IF Mode defines */
> -#define IF_MODE_USE_SGMII_AN		0x0002
> -#define IF_MODE_SGMII_EN		0x0001
> -#define IF_MODE_SGMII_SPEED_100M	0x0004
> -#define IF_MODE_SGMII_SPEED_1G		0x0008
> -#define IF_MODE_SGMII_DUPLEX_HALF	0x0010
> -
>  /* Num of additional exact match MAC adr regs */
>  #define MEMAC_NUM_OF_PADDRS 7
>  
> @@ -326,7 +295,9 @@ struct fman_mac {
>  	struct fman_rev_info fm_rev_info;
>  	bool basex_if;
>  	struct phy *serdes;
> -	struct phy_device *pcsphy;
> +	struct phylink_pcs *sgmii_pcs;
> +	struct phylink_pcs *qsgmii_pcs;
> +	struct phylink_pcs *xfi_pcs;
>  	bool allmulti_enabled;
>  };
>  
> @@ -487,91 +458,22 @@ static u32 get_mac_addr_hash_code(u64 eth_addr)
>  	return xor_val;
>  }
>  
> -static void setup_sgmii_internal_phy(struct fman_mac *memac,
> -				     struct fixed_phy_status *fixed_link)
> +static void setup_sgmii_internal(struct fman_mac *memac,
> +				 struct phylink_pcs *pcs,
> +				 struct fixed_phy_status *fixed_link)
>  {
> -	u16 tmp_reg16;
> -
> -	if (WARN_ON(!memac->pcsphy))
> -		return;
> -
> -	/* SGMII mode */
> -	tmp_reg16 = IF_MODE_SGMII_EN;
> -	if (!fixed_link)
> -		/* AN enable */
> -		tmp_reg16 |= IF_MODE_USE_SGMII_AN;
> -	else {
> -		switch (fixed_link->speed) {
> -		case 10:
> -			/* For 10M: IF_MODE[SPEED_10M] = 0 */
> -		break;
> -		case 100:
> -			tmp_reg16 |= IF_MODE_SGMII_SPEED_100M;
> -		break;
> -		case 1000:
> -		default:
> -			tmp_reg16 |= IF_MODE_SGMII_SPEED_1G;
> -		break;
> -		}
> -		if (!fixed_link->duplex)
> -			tmp_reg16 |= IF_MODE_SGMII_DUPLEX_HALF;
> -	}
> -	phy_write(memac->pcsphy, MDIO_SGMII_IF_MODE, tmp_reg16);
> -
> -	/* Device ability according to SGMII specification */
> -	tmp_reg16 = MDIO_SGMII_DEV_ABIL_SGMII_MODE;
> -	phy_write(memac->pcsphy, MDIO_SGMII_DEV_ABIL_SGMII, tmp_reg16);
> -
> -	/* Adjust link timer for SGMII  -
> -	 * According to Cisco SGMII specification the timer should be 1.6 ms.
> -	 * The link_timer register is configured in units of the clock.
> -	 * - When running as 1G SGMII, Serdes clock is 125 MHz, so
> -	 * unit = 1 / (125*10^6 Hz) = 8 ns.
> -	 * 1.6 ms in units of 8 ns = 1.6ms / 8ns = 2*10^5 = 0x30d40
> -	 * - When running as 2.5G SGMII, Serdes clock is 312.5 MHz, so
> -	 * unit = 1 / (312.5*10^6 Hz) = 3.2 ns.
> -	 * 1.6 ms in units of 3.2 ns = 1.6ms / 3.2ns = 5*10^5 = 0x7a120.
> -	 * Since link_timer value of 1G SGMII will be too short for 2.5 SGMII,
> -	 * we always set up here a value of 2.5 SGMII.
> -	 */
> -	phy_write(memac->pcsphy, MDIO_SGMII_LINK_TMR_H, LINK_TMR_H);
> -	phy_write(memac->pcsphy, MDIO_SGMII_LINK_TMR_L, LINK_TMR_L);
> -
> -	if (!fixed_link)
> -		/* Restart AN */
> -		tmp_reg16 = SGMII_CR_DEF_VAL | SGMII_CR_RESTART_AN;
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
> +	phy_interface_t iface = memac->basex_if ? PHY_INTERFACE_MODE_1000BASEX :
> +				PHY_INTERFACE_MODE_SGMII;
> +	unsigned int mode = fixed_link ? MLO_AN_FIXED : MLO_AN_INBAND;
> +
> +	linkmode_set_pause(advertising, true, true);
> +	pcs->ops->pcs_config(pcs, mode, iface, advertising, true);
> +	if (fixed_link)
> +		pcs->ops->pcs_link_up(pcs, mode, iface, fixed_link->speed,
> +				      fixed_link->duplex);
>  	else
> -		/* AN disabled */
> -		tmp_reg16 = SGMII_CR_DEF_VAL & ~SGMII_CR_AN_EN;
> -	phy_write(memac->pcsphy, 0x0, tmp_reg16);
> -}
> -
> -static void setup_sgmii_internal_phy_base_x(struct fman_mac *memac)
> -{
> -	u16 tmp_reg16;
> -
> -	/* AN Device capability  */
> -	tmp_reg16 = MDIO_SGMII_DEV_ABIL_BASEX_MODE;
> -	phy_write(memac->pcsphy, MDIO_SGMII_DEV_ABIL_SGMII, tmp_reg16);
> -
> -	/* Adjust link timer for SGMII  -
> -	 * For Serdes 1000BaseX auto-negotiation the timer should be 10 ms.
> -	 * The link_timer register is configured in units of the clock.
> -	 * - When running as 1G SGMII, Serdes clock is 125 MHz, so
> -	 * unit = 1 / (125*10^6 Hz) = 8 ns.
> -	 * 10 ms in units of 8 ns = 10ms / 8ns = 1250000 = 0x1312d0
> -	 * - When running as 2.5G SGMII, Serdes clock is 312.5 MHz, so
> -	 * unit = 1 / (312.5*10^6 Hz) = 3.2 ns.
> -	 * 10 ms in units of 3.2 ns = 10ms / 3.2ns = 3125000 = 0x2faf08.
> -	 * Since link_timer value of 1G SGMII will be too short for 2.5 SGMII,
> -	 * we always set up here a value of 2.5 SGMII.
> -	 */
> -	phy_write(memac->pcsphy, MDIO_SGMII_LINK_TMR_H, LINK_TMR_H_BASEX);
> -	phy_write(memac->pcsphy, MDIO_SGMII_LINK_TMR_L, LINK_TMR_L_BASEX);
> -
> -	/* Restart AN */
> -	tmp_reg16 = SGMII_CR_DEF_VAL | SGMII_CR_RESTART_AN;
> -	phy_write(memac->pcsphy, 0x0, tmp_reg16);
> +		pcs->ops->pcs_an_restart(pcs);
>  }
>  
>  static int check_init_parameters(struct fman_mac *memac)
> @@ -983,7 +885,6 @@ static int memac_set_exception(struct fman_mac *memac,
>  static int memac_init(struct fman_mac *memac)
>  {
>  	struct memac_cfg *memac_drv_param;
> -	u8 i;
>  	enet_addr_t eth_addr;
>  	bool slow_10g_if = false;
>  	struct fixed_phy_status *fixed_link = NULL;
> @@ -1036,32 +937,10 @@ static int memac_init(struct fman_mac *memac)
>  		iowrite32be(reg32, &memac->regs->command_config);
>  	}
>  
> -	if (memac->phy_if == PHY_INTERFACE_MODE_SGMII) {
> -		/* Configure internal SGMII PHY */
> -		if (memac->basex_if)
> -			setup_sgmii_internal_phy_base_x(memac);
> -		else
> -			setup_sgmii_internal_phy(memac, fixed_link);
> -	} else if (memac->phy_if == PHY_INTERFACE_MODE_QSGMII) {
> -		/* Configure 4 internal SGMII PHYs */
> -		for (i = 0; i < 4; i++) {
> -			u8 qsmgii_phy_addr, phy_addr;
> -			/* QSGMII PHY address occupies 3 upper bits of 5-bit
> -			 * phy_address; the lower 2 bits are used to extend
> -			 * register address space and access each one of 4
> -			 * ports inside QSGMII.
> -			 */
> -			phy_addr = memac->pcsphy->mdio.addr;
> -			qsmgii_phy_addr = (u8)((phy_addr << 2) | i);
> -			memac->pcsphy->mdio.addr = qsmgii_phy_addr;
> -			if (memac->basex_if)
> -				setup_sgmii_internal_phy_base_x(memac);
> -			else
> -				setup_sgmii_internal_phy(memac, fixed_link);
> -
> -			memac->pcsphy->mdio.addr = phy_addr;
> -		}
> -	}
> +	if (memac->phy_if == PHY_INTERFACE_MODE_SGMII)
> +		setup_sgmii_internal(memac, memac->sgmii_pcs, fixed_link);
> +	else if (memac->phy_if == PHY_INTERFACE_MODE_QSGMII)
> +		setup_sgmii_internal(memac, memac->qsgmii_pcs, fixed_link);
>  
>  	/* Max Frame Length */
>  	err = fman_set_mac_max_frame(memac->fm, memac->mac_id,
> @@ -1097,12 +976,25 @@ static int memac_init(struct fman_mac *memac)
>  	return 0;
>  }
>  
> +static void pcs_put(struct phylink_pcs *pcs)
> +{
> +	struct mdio_device *mdiodev;
> +
> +	if (!pcs)

This should be IS_ERR_OR_NULL. Will fix for next spin.

--Sean

> +		return;
> +
> +	mdiodev = lynx_get_mdio_device(pcs);
> +	lynx_pcs_destroy(pcs);
> +	mdio_device_free(mdiodev);
> +}
> +
>  static int memac_free(struct fman_mac *memac)
>  {
>  	free_init_resources(memac);
>  
> -	if (memac->pcsphy)
> -		put_device(&memac->pcsphy->mdio.dev);
> +	pcs_put(memac->sgmii_pcs);
> +	pcs_put(memac->qsgmii_pcs);
> +	pcs_put(memac->xfi_pcs);
>  
>  	kfree(memac->memac_drv_param);
>  	kfree(memac);
> @@ -1153,12 +1045,31 @@ static struct fman_mac *memac_config(struct mac_device *mac_dev,
>  	return memac;
>  }
>  
> +static struct phylink_pcs *memac_pcs_create(struct device_node *mac_node,
> +					    int index)
> +{
> +	struct device_node *node;
> +	struct mdio_device *mdiodev = NULL;
> +	struct phylink_pcs *pcs;
> +
> +	node = of_parse_phandle(mac_node, "pcsphy-handle", index);
> +	if (node && of_device_is_available(node))
> +		mdiodev = of_mdio_find_device(node);
> +	of_node_put(node);
> +
> +	if (!mdiodev)
> +		return ERR_PTR(-EPROBE_DEFER);
> +
> +	pcs = lynx_pcs_create(mdiodev);
> +	return pcs;
> +}
> +
>  int memac_initialization(struct mac_device *mac_dev,
>  			 struct device_node *mac_node,
>  			 struct fman_mac_params *params)
>  {
>  	int			 err;
> -	struct device_node	*phy_node;
> +	struct phylink_pcs	*pcs;
>  	struct fixed_phy_status *fixed_link;
>  	struct fman_mac		*memac;
>  
> @@ -1188,23 +1099,58 @@ int memac_initialization(struct mac_device *mac_dev,
>  	memac = mac_dev->fman_mac;
>  	memac->memac_drv_param->max_frame_length = fman_get_max_frm();
>  	memac->memac_drv_param->reset_on_init = true;
> -	if (memac->phy_if == PHY_INTERFACE_MODE_SGMII ||
> -	    memac->phy_if == PHY_INTERFACE_MODE_QSGMII) {
> -		phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
> -		if (!phy_node) {
> -			pr_err("PCS PHY node is not available\n");
> -			err = -EINVAL;
> +
> +	err = of_property_match_string(mac_node, "pcs-names", "xfi");
> +	if (err >= 0) {
> +		memac->xfi_pcs = memac_pcs_create(mac_node, err);
> +		if (IS_ERR(memac->xfi_pcs)) {
> +			err = PTR_ERR(memac->xfi_pcs);
> +			dev_err_probe(mac_dev->dev, err, "missing xfi pcs\n");
>  			goto _return_fm_mac_free;
>  		}
> +	} else if (err != -EINVAL && err != -ENODATA) {
> +		goto _return_fm_mac_free;
> +	}
>  
> -		memac->pcsphy = of_phy_find_device(phy_node);
> -		if (!memac->pcsphy) {
> -			pr_err("of_phy_find_device (PCS PHY) failed\n");
> -			err = -EINVAL;
> +	err = of_property_match_string(mac_node, "pcs-names", "qsgmii");
> +	if (err >= 0) {
> +		memac->qsgmii_pcs = memac_pcs_create(mac_node, err);
> +		if (IS_ERR(memac->qsgmii_pcs)) {
> +			err = PTR_ERR(memac->qsgmii_pcs);
> +			dev_err_probe(mac_dev->dev, err,
> +				      "missing qsgmii pcs\n");
>  			goto _return_fm_mac_free;
>  		}
> +	} else if (err != -EINVAL && err != -ENODATA) {
> +		goto _return_fm_mac_free;
> +	}
> +
> +	/* For compatibility, if pcs-names is missing, we assume this phy is
> +	 * the first one in pcsphy-handle
> +	 */
> +	err = of_property_match_string(mac_node, "pcs-names", "sgmii");
> +	if (err == -EINVAL)
> +		pcs = memac_pcs_create(mac_node, 0);
> +	else if (err < 0)
> +		goto _return_fm_mac_free;
> +	else
> +		pcs = memac_pcs_create(mac_node, err);
> +
> +	if (!pcs) {
> +		dev_err(mac_dev->dev, "missing pcs\n");
> +		err = -ENOENT;
> +		goto _return_fm_mac_free;
>  	}
>  
> +	/* If err is set here, it means that pcs-names was missing above (and
> +	 * therefore that xfi_pcs cannot be set). If we are defaulting to
> +	 * XGMII, assume this is for XFI. Otherwise, assume it is for SGMII.
> +	 */
> +	if (err && mac_dev->phy_if == PHY_INTERFACE_MODE_XGMII)
> +		memac->xfi_pcs = pcs;
> +	else
> +		memac->sgmii_pcs = pcs;
> +
>  	memac->serdes = devm_of_phy_get(mac_dev->dev, mac_node, "serdes");
>  	err = PTR_ERR(memac->serdes);
>  	if (err == -ENODEV || err == -ENOSYS) {
> 
