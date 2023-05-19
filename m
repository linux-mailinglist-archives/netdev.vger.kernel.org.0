Return-Path: <netdev+bounces-3887-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F37A7709691
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:33:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 627261C21268
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9A88BFA;
	Fri, 19 May 2023 11:33:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E526ABF
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:33:12 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2110.outbound.protection.outlook.com [40.107.244.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D831B0
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 04:33:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAAEgnhuTtU4vdcc2Lyfgi2mwAkVENNZgB8xWg5lsuNEI9cJBaCDsE4m4SXWf1m24tFljLEB/3NdT7QmKJSLcBL8T+pBSNuIkNmw5SXp3HYaB2++mjb+GxLj/0ePr56nTmdYfH2PGg9mXphkv49Du1lTfp/RmK70flv9Z9hGYH4EW5ukuKF6zVRe5KhTboT5QFP2XKhVlH5UYgA5YbIFStnVkwjJgt937lM5FMS29ufDZAKLLuoAvVWSgy+HYMq+AlMqI0ObxKV1BMWs+x1xB4aDHRDaotDrrp2qmApBt/hBSrvVNtG5SusKgVmvClyjVqyDn1MvoOFrhsO/Rknjvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LSvYHf7wsItxPECth4BhNPbkGqh0XgM4W31lp0+BBUM=;
 b=e0kTvX8iK6uBW39Wbdko7SGwhkZxzVFiSxvwffmn1TlAvblQqKHDNjXspiBt1dnZhTP4yFlUIvYdSpkgaUpV5YLutbBLmlflI+3mo8wpKCzvoeMVs2Pd/IuYjuaUYyfMexfwg1bRQATphM37VWbQvloYzJ7vDOabb5WpWoseh2ksG91r+b6MlplvQdoQ7S/YGXQ9mn9zzunPBPq+ZUQt0ZXmJamfh8Dc23S4qubYzKghUE+hRAq1S5WTCbP8iL/jJ+bWNMllGaGA2AwSlKkkDK64XVp/qfiynyMke4mHaoqFjG96sR1qlaD9jLfvempllZTyIZi4+hovM8TIMBX1sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSvYHf7wsItxPECth4BhNPbkGqh0XgM4W31lp0+BBUM=;
 b=G2WcjxZJFydJbNA8Yr+wYHu7y9BUZp+LVvGJOJV/KnJI0dROjtTJh+4MpAb+QcHhvrtADzG7TkbxqX+lSLIzpOvt+4ea7GWIqclEQAOMev/YUWzfXae7FW9NILukbIatDcJpndpNG/vJE7k5gw+ICgCBkesF2OErl8Xm2W9hTfs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5073.namprd13.prod.outlook.com (2603:10b6:208:33c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 11:33:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 11:33:08 +0000
Date: Fri, 19 May 2023 13:33:00 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
	taras.chornyi@plvision.eu, saeedm@nvidia.com, leon@kernel.org,
	petrm@nvidia.com, vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
	alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
	jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	taspelund@nvidia.com
Subject: Re: [PATCH net-next 3/5] flow_offload: Reject matching on layer 2
 miss
Message-ID: <ZGdebBM8mxGOTovV@corigine.com>
References: <20230518113328.1952135-1-idosch@nvidia.com>
 <20230518113328.1952135-4-idosch@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518113328.1952135-4-idosch@nvidia.com>
X-ClientProxiedBy: AM3PR04CA0128.eurprd04.prod.outlook.com (2603:10a6:207::12)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: ae781999-4141-48ef-de25-08db585cd19a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	u6nlL3bijtYIG0aA7VHQ1Y/GRDCdanZwcUTNMzS7kC5P6idR7ChrZgSfqVzTz1jCmluNJbVwaG02Y1045ziBQoWdK4GzlBny9EHeD0YbsqLOrfwCwmsyOP49CImJdH3J6Q1J7ZMnJQQ3ADNMyWi6SWg8hN6UGtf6GKGWeVeMAJg0esCEJVV3vTYGl5d72wFN5HMlD9+h9kMNmz9Cggv+huj6dW7VMaEovMACHN7fycMc/1iWJ6Cy+Wtd7zuVCP93XSQQ9Jdei3LTm3FbhL0+NHd2qBhtZEmnMKJGpTAQcIYTcq9JokU60rYpJryAxrDg2fdrHeGD0wNtBoeVtu2VsWNvkl7u1naoJIbKmeqMXAX1V1mlfkptzMwuuw3+KD3Z7OsapmsHlWq5IGFz9k96jrPWuvq7t2CyrsjCC3pZLsrOAu3dIeaZyTpndsY3PW3WKaRPLnp0pU8JvzoR+baZOz7qqqwFsJXveteyRUezEFsURmr73AzzakBySz7jm667sjey/nOXWBpFRX56QjR3fob2BedXLu7+Bl9LeXsMgOc3KSOckePIdJScCXMpjEUK
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39840400004)(366004)(451199021)(478600001)(316002)(5660300002)(44832011)(8936002)(8676002)(41300700001)(7416002)(4326008)(6916009)(2906002)(4744005)(66476007)(66556008)(66946007)(36756003)(6486002)(6512007)(6666004)(186003)(6506007)(38100700002)(2616005)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HRvy2S5E8VcTSHEzweYlB1h4GUL8vKV7FxSUsbE1/DpuoDe4RAhRDRhL1llT?=
 =?us-ascii?Q?ijr3Fo3SkpWOlck2M/NR9uKHLDY5JY5zkMSg3gfuFIRdAR4JnsxixsS2Z8kN?=
 =?us-ascii?Q?JaYE/t1hchdAJ198bjJV0+4FGhZIgggsGPMJWyx7x0YaRgNbx5RD5q9mdbn4?=
 =?us-ascii?Q?EhqujxL648RMIMOlmSkkZIffktJGPVkFtA3UuuerFMZtvdHjcLDvpmhFZwHS?=
 =?us-ascii?Q?w03CvAomKN9qJTyrkVUQ0kBG94SP/waycUV/y+RU/vrlmZTHNGZFKxmkddzr?=
 =?us-ascii?Q?JgA7LzrM9pKsFtEIwoEZVLSIilq/Iqs0uZwPc5CaS39fQ4OUX7nBenvbtgco?=
 =?us-ascii?Q?OYdxxG2/LgFo2QDDTHoKwFvVi5GwjCZT88U9Snbv9FY67Wk0FYEkV7Y0cVZZ?=
 =?us-ascii?Q?1motb7RU7um0OPDc6aOCkin1xZXQpaPxCTHMlGYPGU2wtDuiqjyQI3haUVVx?=
 =?us-ascii?Q?2OqYVy+cvhFRxhwJMfMZfGzSzdTBCd6WOoklGZ6X8FK4C5iitSdNKIZn73et?=
 =?us-ascii?Q?eJxB12MEERi4GQYFia56HzEj8+keeUMqe5YlFZQZSR0sp4OlQEIAUfq0qxUE?=
 =?us-ascii?Q?fAcXN33df99AU4F7hK7DpkniO4gu9jjI4eiMJgXbiTstWBihbGwxX2MMon+b?=
 =?us-ascii?Q?OzJmw3xnUEbsKO0NWvpTpk9iHa9po0uBcS3GrKLQ33Pnc809bKJ01Z4PoPJU?=
 =?us-ascii?Q?k9wvIGp8dH7ZiDVoI2NM3uI+akt+Z/t4i8QJfjQ/vI0ZgAnPCDT8TAPxOpQk?=
 =?us-ascii?Q?KSZfM5Uqh+Q+U2DewOGzdFLI1Nu49+GuV2iwnsk5FcKMl1ZhlgB0BYj3nfb1?=
 =?us-ascii?Q?qno13y2bF9XC1TeEAMUujJJQdCGzbzLuA50ZQei4Fu3NLCcoP19VwJSGHlwd?=
 =?us-ascii?Q?Uhrat+QLsWXtMnbyeiM2P+qjjMxXbuc6mDKGGu6GojJqy3p/JtLj09oKTgns?=
 =?us-ascii?Q?WlJJC2hO1pE/oM5tLwDKldmZtYgDCrvFIUT+y/hkpo/NNiOZqR+RaiF+gUrg?=
 =?us-ascii?Q?h8zcVbl4cGqVDMZgHAanwdfzMIPYXO94WfNRrJQiPqumofLdOsyNQjWt1ncM?=
 =?us-ascii?Q?cdzyBZ4d4fC9b135GzqYVlkJrPBS2970az4qRG6XEtIBpJsHtLZWgzyRsD18?=
 =?us-ascii?Q?/+7jsNMxoJPscPfolqS4Von6Y+kAkteuzG7F21xMx36lqptF5gTc7DWdD619?=
 =?us-ascii?Q?16/taETJTs64dQC2msoKwHmVcDDkxzXWLC3cNSGQjXi8b/JXp6AR0Sc4JvyS?=
 =?us-ascii?Q?ip9ZUo0ycRHrNdLmJ+knQQg2LVwn+Ovk9eXwV/iEGltocwUiiwx6QlBNNsWR?=
 =?us-ascii?Q?/i5nkSzeVYDjx54IbVdGxBhnFTZZDeLkSLA9QWiNvBbm8OWEmmA5MQuNi+0o?=
 =?us-ascii?Q?x8SkazpIEyo2MSfGXfKORR6O4xDcL7BHZtMh4+vbXrI3YKEPof3d5wxKxRg3?=
 =?us-ascii?Q?9OhpdNTXzJ36m3zZw+/JPCNfn42OqU+9xUHTyeZLKSWPEmNuvuneC8pYcaDg?=
 =?us-ascii?Q?6d5WrlY7tfpkSR2d7gkGe/wPN0QkrvUMbhwCJacgn+XLE+xtnsg015dx+leb?=
 =?us-ascii?Q?BPxpe4T9c6PpUidZ4aeP0bjCsOQul1UhH9Va7Qo/YQ2n9C5bcrb0Lo5OwRgs?=
 =?us-ascii?Q?7R+XGAVLGKqaTHiUlmGTUlRS4/casAEjebCYpBn2jEfgiBDByZ8WSfGwWDwZ?=
 =?us-ascii?Q?AmAbUA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae781999-4141-48ef-de25-08db585cd19a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 11:33:08.1631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OEYF14hrI62pHFrJ43OFro7q/wVxRcbkliHcUrfbZoFBYKkGFJNAZLkSO0AhUIUDkYym7mEuIemAVlTNk5kEy/MWhJYpCkpAFwytXaFfV1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5073
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 02:33:26PM +0300, Ido Schimmel wrote:
> Adjust drivers that support the 'FLOW_DISSECTOR_KEY_META' key to reject
> filters that try to match on the newly added layer 2 miss option. Add an
> extack message to clearly communicate the failure reason to user space.

Hi Ido,

FLOW_DISSECTOR_KEY_META is also used in the following.
Perhaps they don't need updating. But perhaps it is worth mentioning why.

 * drivers/net/ethernet/mediatek/mtk_ppe_offload.c
 * drivers/net/ethernet/netronome/nfp/flower/conntrack.c

> 
> Example:
> 
>  # tc filter add dev swp1 egress pref 1 proto all flower skip_sw l2_miss true action drop
>  Error: mlxsw_spectrum: Can't match on "l2_miss".
>  We have an error talking to the kernel
> 
> Acked-by: Elad Nachman <enachman@marvell.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

...

