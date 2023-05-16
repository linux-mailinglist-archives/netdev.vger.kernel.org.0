Return-Path: <netdev+bounces-2970-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 810F0704C20
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:17:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48D0A1C20B26
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F1334CE3;
	Tue, 16 May 2023 11:17:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A3D34CC4
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:17:18 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20702.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::702])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE80E3C01;
	Tue, 16 May 2023 04:16:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hOr53oxvh4cGjtHHaqg+I9tN+BJl3z1b1RlyCkaqmKeacRC7cAZEXCG/CZvCaaySwXqgE3BOkgyKZ29Jp3CbfZl3guIRjaJHGrrqeGwQOQDum/JlavHaKckwHrrLtdHX5+/GmF4/UFiuIzVhalFsCVLKbJG12pLkD7ApdzreDyy2M4O/beUsoVARUc32Wz9V/4qXvuOEqbwEtludBEqVY53g/fVvlzcCxXsrLpq2FNg0h/VBoaZujMvAWAe+uwlwbGdn+yJOKXxvKAG2vfu+/10D2eYB9dgqg2uncvzGEsCXiGVdCE7a7+84GqH7PCMkJ0tGCw1+YDqUaToChq745g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+zSFJm5ug3bRNM9R2WUmbQ2kwPwaTBJ4/9ab59qgA0E=;
 b=ZG2C9NjRDEV87a4hhjTxdhZszdJQBBcguR0gQFDijVXcFbN6vwEkC2JWSH6m1HpjfRqXXSYoLfc52ftDteh1lBZGEbJ/ZeVcAbAVjV489azb0GBPbHlhtlLeR2nQ/bZCOPkIxcsJXicGdhZAj1vbOK/5WCUg/0SRsa6JPx5k5XlyFO3ZFOQnCuV99k43Dm7LtCDBPcefAr2XjWj/35ubGiFU1NMvGvrTwa7TYJYWD3nhmzxUBXlACbPxcYBqhLSbxq0GRFXUKosvCk9Y4/iNKp7nMXByqIuI7aYgkF579yFx0MMMKyGhBo1/v9rI2MfDPU1hmwcQjVtWAhuBUjjLhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zSFJm5ug3bRNM9R2WUmbQ2kwPwaTBJ4/9ab59qgA0E=;
 b=M9TbBnrRLzg8TnVM0aJPcCBjOOl/ls41cO6qxUSQRE1KijKOZm9y0tkJuFVDmIJA0zIsmWO2C+5Fc+SNoc5Wp93lzxssxwLNGbX4h4X+zzks8wnixAJeB/jFLmEldekmKmy/Qq6SEL5LteZnS81pNSrN7yXg1iw6J83QQ5ZzX/0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM4PR13MB5836.namprd13.prod.outlook.com (2603:10b6:8:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 11:16:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 11:16:10 +0000
Date: Tue, 16 May 2023 13:16:03 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Baozhu Ni <nibaozhu@yeah.net>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"moderated list:INTEL ETHERNET DRIVERS" <intel-wired-lan@lists.osuosl.org>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	Outreachy <outreachy@lists.linux.dev>
Subject: Re: [PATCH] e1000e: Add desc after trailing whitespace
Message-ID: <ZGNl8yHEko7LpCBr@corigine.com>
References: <20230516071509.GA3550@john-VirtualBox>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516071509.GA3550@john-VirtualBox>
X-ClientProxiedBy: AM0PR04CA0126.eurprd04.prod.outlook.com
 (2603:10a6:208:55::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM4PR13MB5836:EE_
X-MS-Office365-Filtering-Correlation-Id: e5e36bda-93e2-4c5b-b0e5-08db55fef393
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DEBJCv6tbaIZ2OXxXTtKB1uuJXFlJdWLBnPFlug/HUiqaPWy8Pca/vpOYcWHBT0QKA8CgprhpzbvHlmwaFWXluGPD+NQC0LAkT25AEu5rVOnilrW+Q8aQkyz1EOsgauePV63IRIciOVFputhJP0AkneGZxpkumMg+jc2yV2Lye4+oNljQm/F4Eu2IZyDATk4lusagMR0npkv09d3hlgpX4uy5evZDiV+erW4E0jY0WtUKN+BA+UDwqGNmMoXV/6AtftAPtMd7PUGOohI8Mm6x5XSbKwxNt6stvQBVO4EMt18T7cQIoN6uVCYuIQsPsW+fHBcdYKB4Er6xOUKjrd8Du40VIk+GqwW9Nr1FuN+frlceK1AZeGlkiuoHmY/5uUsF8ZVe05waFRHoi1+ZTe1ZbBKKWTmsWKVE+8uH9/jSSOGAs49Lr6/0GhDl3VIRZN3nBPxdx0Pxtzyqz1nxP5T8qiVH0Hdjt7gxGFrmdvdki4BeXbLvOlaTR7wgevIJTQChh490MANwAkOxDSkIqs8H3LALkm7Q7o0BKj4oKYBYtk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(376002)(39840400004)(136003)(451199021)(36756003)(6666004)(6486002)(966005)(2616005)(83380400001)(6506007)(6512007)(186003)(5660300002)(44832011)(7416002)(38100700002)(54906003)(86362001)(41300700001)(316002)(66946007)(66476007)(66556008)(6916009)(8676002)(8936002)(4326008)(478600001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dxbDRzlY4DsmUl/qQOCHfUtKQW9/kXFApIQ5Ri9cvI5DgZbLfowmQ9nyNLCo?=
 =?us-ascii?Q?agdpEwz76U1avuerVJQ+th/omQG0/mga5pmV7kMnFHNG4IDwjmZWOJt0YHrd?=
 =?us-ascii?Q?IHHRwXs3LHh+Z38cRYbPKc0HbTqAMGB1BWh7v8xy0w77KUM4s0X/WFifdF0O?=
 =?us-ascii?Q?oGC+1/7BuJT+mFL7hHH2ACDwmjiD3zFL2Hcvs5gBa6xH03lyDUgsePhAs2Fv?=
 =?us-ascii?Q?BjWBcw5S1zET3+ZQWwyWN0+dH7U/qsl5cp0o1O5J3MlBVPNIP8uK+7uWElaG?=
 =?us-ascii?Q?JS0hNkRHVKH8bV4FoRxzawDswLJ4ewRhxt7Qrh0qUyB8QfNQfMLVldouky7Y?=
 =?us-ascii?Q?tN/h4IWi7nPNqMA2iflcKmfJxVgZHBTe4q+DFN0Qs/rqHivxtJOhiRdtDTFR?=
 =?us-ascii?Q?CzqtgB65d/tkZqEfI5veXJTYVH0uE3AGDI7FMAx8UDTqLtn2DvCHtgzr22mn?=
 =?us-ascii?Q?w0VbbXFk5n8N3d9n9+4Ohes32UdrcTPqgUZa1BWJSSwVEWtTtjXq9NcWte5U?=
 =?us-ascii?Q?RlpY+EQ/I+3wPpcmnj4GqmAMm92Ki/LcBtZVCKpXUEHIj2I383j8YO9eYPDL?=
 =?us-ascii?Q?SnvXLiMMSoQH3fP3d9qwcE66EnoNg8GwY+D7LNALJiQfByZp9uMY47dX21HA?=
 =?us-ascii?Q?hswB5HYGOyPAKYN2Cr+z23EZF9prmOgWrw6F5IpUvV+W32OoClxsdODIezoU?=
 =?us-ascii?Q?/zRx2l3bk88vwcLaV0/pDgkcXbGaZUssFizxJyV7o5ccadWftDnHw5hUncbA?=
 =?us-ascii?Q?tq5I90DygXIyxALEckAE1IiHOZAPrQG0mJTvHElDwnef4GVI58J3lS0NawU9?=
 =?us-ascii?Q?pzf5RXjaKvO514K/KzVZxWrpV4/EAUHg1hb7lARVUeesLjJKoEcHMArSAcSH?=
 =?us-ascii?Q?pCLoxo4v6oztvCHz+2sc/zrigo4Vv3+a7tnxgdjl9C9P0HTseNC07KxEhg3A?=
 =?us-ascii?Q?nqbK2vPFj89ENrEmCAQ8djJ2huBMEYjH61iL2yRsuOCaoJdLd3prya2rTLpi?=
 =?us-ascii?Q?lZcQs7UC0Ucer4UtRPqTTRlBTHuUsYUYpfNAeF2HPTKmHZYIwIxVo0n1SkbZ?=
 =?us-ascii?Q?xia2WeKcQOgJCk8wRfyCBFeUU0jiuGr3oW1E4xXf7d6isvgWm6Rhdkgk3Run?=
 =?us-ascii?Q?l29ks926bFK/YNuHvOXryAwBbTYLemL7ZAA/tjEvCN3HsaAzUBytfsM3sK77?=
 =?us-ascii?Q?Vb1igQIy/2uc8uALb56b8Aa8Z+kklHy/I6/jivLpBPIHdmyVQ/6tgJhcExpF?=
 =?us-ascii?Q?xgpCWIxUZpk5wecsIT+2xKdaf97WDKXxEB0TjX6Puh9aOOMzlfjcIB7wBLd+?=
 =?us-ascii?Q?VZoAe92Qz4NpZtwEDFiPOUQuScm/B01ibgMHqvDIUn12BXRNIt+cCyXWr1Yx?=
 =?us-ascii?Q?dae3TcCHahoaX1rrS5o6Q/S7qZmF+4G3kBt50XcpLqv7nFEo1ibbYqYeRWa4?=
 =?us-ascii?Q?C24hkb/TiOFI0NbP2njAJ1RElYETitG0lKVqaMLGwaiBA+MTQRpRPlgxltU8?=
 =?us-ascii?Q?8y7G3FyP+Pt8wGrsg2Q24oG0eBV1X/3t4oSfGHs0raMQHviI4vwIS5ZvV4ud?=
 =?us-ascii?Q?aalExd68+BIBN5iU42xhPZeIx4FBjb0oOH0P3yCYtHtjhzFBySY9NaZ1FKPw?=
 =?us-ascii?Q?sp12ZBwLTqN8+9ytBYHn6Pspygg8xGgvgxEAQcZqlH271pMsCwMZKhANlosb?=
 =?us-ascii?Q?0eWREw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e36bda-93e2-4c5b-b0e5-08db55fef393
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 11:16:10.2798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wo6vUU6qRMi5LR5ffeqXIBGTxatjrMSfskh0oQg+NPb9dfBxNkZpyqpbIdzCowDFk2opdesnxrdJgMGDU+elI3JFUinQpJfJkgdD338eQ1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR13MB5836
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 03:15:09PM +0800, Baozhu Ni wrote:
> ./scripts/checkpatch.pl check error, so add description.
> 
> Signed-off-by: Baozhu Ni <nibaozhu@yeah.net>

Hi,

this patch looks good.
But I think the subject and description could be a little clearer.

In my view the key is that, the adapter parameter is being documented
in the kernel doc for the function.

Also, the target-tree, 'net-next' should be noted.

So perhaps:

Subject: [PATCH v2 net-next] e1000e: Add @adapter description to kdoc

Provide a description for the kernel doc of the @adapter parameter
of e1000e_trigger_lsc().

Flagged by checkpatch.pl

Signed-off-by: ...

When posting a v2, please wait 24h, as per the guidance here.
Link: https://kernel.org/doc/html/latest/process/maintainer-netdev.html

> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 6f5c16aebcbf..cadeb5bc5e16 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -4198,7 +4198,7 @@ void e1000e_reset(struct e1000_adapter *adapter)
>  
>  /**
>   * e1000e_trigger_lsc - trigger an LSC interrupt
> - * @adapter: 
> + * @adapter: board private structure
>   *
>   * Fire a link status change interrupt to start the watchdog.
>   **/

--
pw-bot: cr

