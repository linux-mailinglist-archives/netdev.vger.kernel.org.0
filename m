Return-Path: <netdev+bounces-8514-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E1C724698
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:45:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85083280F43
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9313219934;
	Tue,  6 Jun 2023 14:45:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F75311C9B
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 14:45:08 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::70b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706BA1FFB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:44:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClQUOOkfBZBIDjXp+j07gb1N5CkjKsL1AVK2em17XazRmI965HO+7FjlPZV4GdLgrmyb7ZxiYhWSKWV9cMzEtzx4a9d4qGo/1p/fsWUQorg57qnd8vqzpqH/cXf5ZnIK8fh00wKqwY+A2hOxkQJI1BW5632QzuvlkN5I7abg1AWVZTwMPzzS323pQzbEWk10ukKKnoJNcVHLjtcPl9se5mUJCA3XIaAzneN3B6iUkwP2q4PCWWEdbGaWtwinhyBageWm6VK81YdfKD8CWajsmCqP37kGG8wRHWeakrcGNGJ4yr+bXv2hasU7/3XHdXuIJOAyw/SPJrxlhYxvbKkLvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLnq7gCXLm+b2+13O8T855780We2DO0Q4l88LbLHd5g=;
 b=kpmvsZDH0MwSnlSNMgugIjOzKIXGJ9JyM5F/REqAMN3Se4mJBuBb4+cV+45P8SksBN2yKYy3ukTHUPAdOf7LOZ9L7K7F5fmk68BKtf+gYKDsTIWqTC2AhP2H2LCBDDBRm/+Jtj8+uxW42j7upMRWmrSktMlaYCQjw1Cuh3W0IVcCSjRQPjS4pYXdqAceG61tXYBfAfBGFf+r7zKwyRm2lUGskmk+G66zpKpsAZcTmJkin6bVLDY1DIcAzZesUG3Hc4IOrIVyduLls/vJFVNvqpnDQJi4Mc7jgCFcL8oCK6px8xUKCxl8iiiVG762Ks8buU2ha/3GWxj75xjv2KGXqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLnq7gCXLm+b2+13O8T855780We2DO0Q4l88LbLHd5g=;
 b=CkkKaEQCZG/5cN53t6/6/13z3bqYP8cig9BYkgYRSslkEmnfVq+cDUaWLxqGo29tJuxMbbFwzE/ZD52+iKGc7vpkWT0hS0XelX0EhI3tnUeiPo/4NfLCDJvrGpszfoaatHcCRsMShcE0wksHUrMa5hPrVaXwuneKwIFV/WHoqKw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY1PR13MB6192.namprd13.prod.outlook.com (2603:10b6:a03:534::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Tue, 6 Jun
 2023 14:43:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 14:43:38 +0000
Date: Tue, 6 Jun 2023 16:43:31 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH ipsec-next v1] xfrm: delete not-needed clear to zero of
 encap_oa
Message-ID: <ZH9GEw+czskKKjxY@corigine.com>
References: <1cd4aeb4a84ecb26171dbb90dc8300a0d71e0921.1686046811.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cd4aeb4a84ecb26171dbb90dc8300a0d71e0921.1686046811.git.leon@kernel.org>
X-ClientProxiedBy: AM8P251CA0012.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY1PR13MB6192:EE_
X-MS-Office365-Filtering-Correlation-Id: ff083e36-b981-40fe-0f34-08db669c69e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ebqvXjACb5ydpIJvBeCr33pyPUrNi8trd8uoMG630GNAe5phGX5RZmG7CRuvVjEBRACb8dXMyijUZ3+LIWOtGciOlxSSFOm473w71GeTx4VTapz24N+B2q5v9OGlR52N/iuACtLIyQqg0RePksHkNyLnPF3h+tYM60RezQAHIegOo8RiURF/TnCf9DdS1z9Mw3Z0sGxN40MBk3L66uhqJ6pSHI/XxTlnydgNhKEjuP+il3b4wWmM+IZ+OLokrlcFzdy6iREw3GE6lk4O0DwJN2/FJMPLLF/vcNQu/lfA5qlJWtrMfGWbwFyDNNZ9n9AbPbNA7WEFxL4ALt++X9/pzzPMnna/Dgssbzo58VnK/201e8vzkec2Wy4+Eygfg1KJPFTLyyu9Jq5k+n/gt21iPJatsFTUCT4sA+lIz/FwSl6PwpWfKSD3mmz0RWDtlOjr5xk6nlIMyx9yeNdhhrsrGZAveTIqik+DW4CU68AADGiJHeOuJbp4/rHq9YNtJHA07fxGoaBdWONpGx4ET1EI3iRWmqm21P4vH+6snNNwti92rPcFnMP2EGe3Rd/Dz37U3ovohPLs8ASm6VJYPY6VfwgyzZskZb0tUb7nFTKmQvQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39840400004)(366004)(396003)(136003)(451199021)(6486002)(6666004)(6512007)(6506007)(36756003)(2616005)(86362001)(186003)(38100700002)(54906003)(44832011)(5660300002)(316002)(41300700001)(8936002)(66476007)(8676002)(6916009)(66556008)(66946007)(4326008)(478600001)(2906002)(4744005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6b1YW9MmBf+Z+E0aLsLRcC2WOLghcyirrY7zRdGfnWiuVyD7NI3kR9nAFBLz?=
 =?us-ascii?Q?/638uDSy3+I09BKIowj8wBpR+AdgZHaVefi35C+cm+otl/Zvo98aYK+K/Iq5?=
 =?us-ascii?Q?8oZfnVoimV0RSIidrrsk/vSlF85lsOdMCj+vtoO5Gpg6yYBsKMmLAutMF7Xh?=
 =?us-ascii?Q?P5reb1Tpq9KZxIXIb9bSompy0lRwS0RN/SUFmnKc03w9OqG60IoeF+LSeaMn?=
 =?us-ascii?Q?V2Bo92SX6NSmgAPxS9ISVRsV/bxR6PXA7/ShW3Lf2S2ymvR5XBAqaghvPYTt?=
 =?us-ascii?Q?U3bGWBglAtsczDwUS4CPmKogMIAs/zoreWGWoh5U3PgIHz388a8r1FlbkRbV?=
 =?us-ascii?Q?64ckRmgU1iizn5/SMBCKkP2B1QAPXb48BpbVaqd7vpDbrzeZvwtHzhVQR4cr?=
 =?us-ascii?Q?y94H5pi2At16CIN3KOKcbZ5/aTzJzaLhlVW1RuZLGyTJN93kFAfm4RY2HboE?=
 =?us-ascii?Q?xlnIWJmVZiBqYxtgIhGKfE3+wepJkqYYdrIiU55PdBQ/vgs7WX+iiic0BeOE?=
 =?us-ascii?Q?xbtIJvFNfMM8w/ON49g0n163LKfIVt5XNeYxQ8ly6aoSm3hGx3LalJPNE5/3?=
 =?us-ascii?Q?pGsYOd1WoRq3QrFpCUOanBCjoGw9S3rtrm3ikblKl8WE2eqdLfHoLKvS2hQp?=
 =?us-ascii?Q?RQLEigPgrhKQy0AjUiwZc0HIW4armiaxsmSto7IoXzbkkn4W8F2C+GiqDMT9?=
 =?us-ascii?Q?FOMpRMh4+DZrPqhqoTvbnZRDXB4GHFyyhhl48JwL2giBfCgLENIKxL9ltYxj?=
 =?us-ascii?Q?RGkZXn8ezA2TXfAVKwt9KPoP80l5KP/A5yR7it0f+dpdYtT1BKL5H5zHv4/r?=
 =?us-ascii?Q?KVICXJ9g8x5Vg0d3ZlKjoWLQmK3+FTf7B7Gg/MM7pgSUf6HAbXQaCSpZhoLS?=
 =?us-ascii?Q?Zy8CmfcIt1+i4yhxQ7kvWdZeaJJYkv7cVy8MOxM55GM76zxRuoT6bIQzPVpF?=
 =?us-ascii?Q?VWsmrm0tnxnzOLqntM/KRCdm3nOmue4gSuopTkqLs97oya2XZVe3zXRRUgVG?=
 =?us-ascii?Q?6C9D4CekDNHX2imdZXnbRcAprL7DRvn39EEIhG5vREjed1cMyj8zo8s/pp3Q?=
 =?us-ascii?Q?0R6sornHCmi8DFwMl1+Hpm9m/+mdBaq6LC3VvJkBxXZZRQdPbpzISjr0Bgfw?=
 =?us-ascii?Q?RPZuTABQKuj/s+0g0M6vrs+T1773edk9V1jFra+9Rg2XR248rjTbX3kabCse?=
 =?us-ascii?Q?9vhxYsjJCM/3Jn6nszpPzWDrBPRMMhDq99w/8fjvAxptjUcYoXnTqPAsGgRk?=
 =?us-ascii?Q?f2rBnuYm/mFS1LfOhBbNi/jKFo3B0tpYi2O7oi+WBxcopOaf38WsmbQmgeUb?=
 =?us-ascii?Q?EAaWNs1IkvqXnEvtbEVBFiwi8WmDf5wxArqrqxdd2N715FkQgFn5FXdvxqVm?=
 =?us-ascii?Q?fE1UBKwSDleX2GTiLuiqmZlBK29XYS5BK0GGevHl9KruWN+VOcat+VvMFlnK?=
 =?us-ascii?Q?YP1+TCBW8A8d3++Pf/HX4Fqu1AsHvt+HfxszZPjfGpzNJ5kocPam6SFzVU/c?=
 =?us-ascii?Q?iY6jeH9YzL9Iju8MAiYbwo1Hv+GfbcinFZVeUU83Zyh9YLUrCnydetQ9Zt4l?=
 =?us-ascii?Q?uXlSxIeuR1TXsl5/9HUeNbxWxxs9NPgOwimSZcH+xWm6EfEAy7BOc2Afon2I?=
 =?us-ascii?Q?zOT5Ti9GiO7MNVo5N5foNVg/shfur5vvUD6XKn7BvrFvbR3a1Ov03NpbXLK7?=
 =?us-ascii?Q?Dy0E4g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff083e36-b981-40fe-0f34-08db669c69e7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 14:43:38.2948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2a7djbMataKIRgeCS93k/W5zz8KnQPdMBBEHEMwkaiX0HlavfrDcsETYVCOL/IFhfSIu8wzAgiI91CQwpi+d9W4dQ4IMzjAW1ZEFk5+TZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR13MB6192
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 01:23:06PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> After commit 2f4796518315 ("af_key: Fix heap information leak"), there is
> no need to clear encap_oa again as it is already initialized to zero.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


