Return-Path: <netdev+bounces-1193-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 987E26FC900
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 926731C20A60
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476AD19526;
	Tue,  9 May 2023 14:29:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338F38BE3
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:29:46 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2103.outbound.protection.outlook.com [40.107.237.103])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E423AC3;
	Tue,  9 May 2023 07:29:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENisjn6SKVqCtMu8+2ujO557SgMC88fGQoVw9MAumhHQDJzyzxbtSiy+nKE7UIr1GfnMCnvQxKsVvYDIXDY4ZAO6l5lIdMYu4hv4AWqf3k7Q23NGX7SLsRAZ2iQlG4W5ct6+AVYicCxQ9ye1BBDohQwEFZI8lJoLO6EwIxbhM9oJoq/0JhVp1QdrsZgT+OvbPZ5o4GMdwKrAkUV2bHVOLuVIDzTEHL00FtfLFAuDiJEictXyNlJ9tz8qvSsl+93vcZHHL9o8BYXrq1wiA7eNzhKRD2Dm4me9lgc0tE+xUBSCS2uCJL7alCvU/kUgzhXMGRg42WH73chcR4i0djCHKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWDqeP60lPbyUZnW/pK8/8J5izKCSAHN6Qo8T5BlzoU=;
 b=oKqI8Nf5Vuhh3SRNuPECQRYkekQLYB09hc2C8anafzBQd5HbatdbzXzbbJVHdBver0KD55jieBlSKP+3IAc7MJ6L1S4WCE1+zfAedhmAXP3GJa8UAhWhMukV5ac4jWsm88Wqgy7vjvkkCextbMb5R+KQR4Yktakzy4XKtpDsfM+JjkKh6UYzWQ0gsTpDzqLx5DsqgNvZ78pnKTgB/LuidO/MQU6ndZHFFHZHDoBRmlK2X4odqfOPtoJKwzOKTkF7mj3d5ikKgRJhJdhWCTZNbzen7Dqa5RwWO8uJuBk4YM54UVbP66mlEhF4xROEhMYMhojoHUI30xmZN7KPevmmuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWDqeP60lPbyUZnW/pK8/8J5izKCSAHN6Qo8T5BlzoU=;
 b=UuYu/CUVgd1AHNyUrGEBNCFKOVsOfvOmuQRkQ1tQhyBgCjtHY96aJ9f3JKCQ/bfqcWdbBSBXVHYn3buaDF9QFQ1ntvzLohNKZlv7opLwyB5Ll0Ze+mjKJOZ4vP3Mo8WylBH4QH9tHjiMI3j5I5DVoM/IStDaT6/J+BRu2Z1feQI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5897.namprd13.prod.outlook.com (2603:10b6:510:164::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 14:29:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 14:29:38 +0000
Date: Tue, 9 May 2023 16:29:18 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ivan Mikhaylov <fr0st61te@gmail.com>
Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Subject: Re: [PATCH v2 1/5] net/ncsi: make one oem_gma function for all mfr id
Message-ID: <ZFpYvohj5WKqqkis@corigine.com>
References: <20230509143504.30382-1-fr0st61te@gmail.com>
 <20230509143504.30382-2-fr0st61te@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509143504.30382-2-fr0st61te@gmail.com>
X-ClientProxiedBy: AM0PR03CA0004.eurprd03.prod.outlook.com
 (2603:10a6:208:14::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5897:EE_
X-MS-Office365-Filtering-Correlation-Id: 00e95cd4-b53a-4d27-c3b2-08db5099d16f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	A9mF1aHRC6d5TkeikdOoC3e7wSuOtwQkX7Lf7g9rgDWxoHFzrCQsmh6xMsm9yC0yRJ/nIpCysPgv6eWwBb89cC7QAcxL9kgHq8CfQYTuODPOn7bCxiOOa0GJrLLi6iNL+IA0kftUfbHK1gJNFL/OmXwOHrJLDboHjI0PWV2ue5UsyeZ4Tknm/+t914M3S33Fcjk+bhCmXlejF3NEIIOcHYkVBcHG1mWCeCMIJIRbJ+0TTo41YR2BsE70MKn3dOFTh+OvJvsGjO6kdd7KU2JxcnVCEsk9XYzisL1TkoD3zemwVB50HK146Rsx4mBZuKBAJSqU7TAjiqfmZRI2AkuVTtxwA3HMvEa178Mah+EqvLz129NVlr74q1QTmqnPdxH19DxCGIrkBgs5vcdqsiw9VjPg9POz1L5eCvMJQBP2AS7Ql+mGQLVqluUDIXmXJSty+KYUh1vuwmFgS/bClDTSSWRYsLCE1gPFEULCfoMVUhRZmaACY2jBVhZEZ8tUogDo6zjgsx3e4ewsWOQqUQ3KXZYLdFCRHUk+XXWLpb7lenADJqOmE7dKa611VoNsdKqscafVHckLfjhUPHaRfcnLS0haKsIHfFxkfAlBVEpY57U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(396003)(366004)(376002)(136003)(346002)(451199021)(86362001)(36756003)(558084003)(6666004)(316002)(54906003)(4326008)(6916009)(478600001)(66556008)(66946007)(66476007)(6486002)(5660300002)(7416002)(8936002)(8676002)(2906002)(41300700001)(44832011)(186003)(38100700002)(6506007)(6512007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dJ+916NoWXJJKosIQuW9kI9TQUan+L70tL17bjfhVepOGcRcWcbZ132v0Tat?=
 =?us-ascii?Q?4/1REsa82fzgIvYgzzORzwvKpE9frXOUG9Qol1L/cFMvx8zS0t2/TQ1c4WRs?=
 =?us-ascii?Q?G6cGsOpKU9qWIjq8CL3fLszU40/IocLAfPHYJKLksnfVWX8v8sQ5qfq6s92H?=
 =?us-ascii?Q?iXw6URg8aWp6fTzs0OUb4+PX8NuNV8e1mIeWn9WBeoTWhpFk7qZEs6z6YRWD?=
 =?us-ascii?Q?jtqByfGYeDnkFnT2ZSc9r7C7+g1JoaOhZ5kqoQmd3GSv50V+JoWOweewegL1?=
 =?us-ascii?Q?eFzdddXdTg0zr5ZT97uPExsw2dnnkDTRf23XxmpKbEmgTwO2pE9A42tElmIo?=
 =?us-ascii?Q?/2UAKXZT7mRNxVZgQfB+kZx5c23g2LD6Wg6qGpYFZrRqhzyeU9ZiXQD3kRz3?=
 =?us-ascii?Q?FZnp7I/0t9TRUMflF03uTw55dqKzLUG3bEXTIlgm5GcNgUP1HFks21ycCmNU?=
 =?us-ascii?Q?hQpRdWH6j2WOiBykxQ9T7ew43A84D0J6yhtfuCNe4R8LrfyD2NznuH6ATGfp?=
 =?us-ascii?Q?RBj85oLl2/wzHTKmJVV7pMleiXPNj6E+1zPbNUTUrB+KAhoJJqsAizFXlKYF?=
 =?us-ascii?Q?t3j3bp//RFTEk3wO3SvbZ/cnm3YWYA3La3OJWGqiAUGqo/R6/64exaAPJdfs?=
 =?us-ascii?Q?XLrRe6jXvlGbsETu77vM6vnDpQlZt9MBm4lcgGMNZqVbGHf8DGcLb0uTLjsY?=
 =?us-ascii?Q?dJUBhUim5v29D0AQr4ysblI9/jFLcZRVSVVdXPxcOHyUSvCPBn5Nu6ParcD8?=
 =?us-ascii?Q?xYNEIp5F2kfAMzlSE508BD91e7cvYx/LXT0HMXTBGhR4sifZjD31J7qNFStb?=
 =?us-ascii?Q?5LLHyUx9J5EeXQf958RCj/DNQXxLEr0iQVajcWA1jKJ6byuAc4n9UgBqC6e6?=
 =?us-ascii?Q?nTQMV7DZszfrrEO7T+HNz7UYACx2QQfAZQBAScQ4Ep2dsCc+pRNbydBneCgQ?=
 =?us-ascii?Q?k5W7dd3//ZtCp4JZ4JG4053pQ9ZGfqmuZQNxMPKBj87YVg2ZsdQ+LBwB6Y6n?=
 =?us-ascii?Q?SiMU6ERZ1rBTIun2NcTUh1QwTEe/LaZhG0MTN6m7D66895h515OaEcq135a/?=
 =?us-ascii?Q?rjoLI396ivdnVZvIfTXj/WP9RntugTbPvOjj5p4PZVh8f5+e7EhyQHRfvKse?=
 =?us-ascii?Q?a0YbK3+4kLhDU5QkpTNmIbgHnQDY7lkHInllmTHOt0jtoAAdQB/0xeLqz0rA?=
 =?us-ascii?Q?bMfUYN7kUxo4W69eaR4Qan4kDXzkGgtNwIuem8wRoO/5s5x4P9teJ2DUiTC9?=
 =?us-ascii?Q?3cs6hxYxjqFwZTdOF2B+AEsrklpMFisPJ8LygxNCMFuIKWvnDoudFOcsn27B?=
 =?us-ascii?Q?174ZQw+Fr5giFwj3wVgm69GTwS1QhtBDSjJPD7b8vGw7nYQdMYbvI4/2eY6C?=
 =?us-ascii?Q?YB3CRasOtT87G9QW4T9JpALlC9I9VKVlEJFotXDm5X37bhtWPT/Wso4JVR3q?=
 =?us-ascii?Q?D+1ZXovte2JMp9Fk2MP8v6qhjjPo8Q3If/Iia63JLpdudupIK8s1yrCqypeX?=
 =?us-ascii?Q?o8fjZncYviV5tw2JOUSacAaBO0re2XNI+KhOkyi8m3K27/Aw8ZkEtznr5tEt?=
 =?us-ascii?Q?pyvbL5nMN7Os6IptTFzmgIESX/mk5fQJMk48roHBAW1gn4kUeudITJv3GeTy?=
 =?us-ascii?Q?fjxQUH4YStsxWEFuYB2cMH+3/2A0+B0NLTSHwrBkvBgVC+a6cUQWCm/xKfSj?=
 =?us-ascii?Q?5xciug=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00e95cd4-b53a-4d27-c3b2-08db5099d16f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 14:29:38.1390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lEdB1IckgVLwkJS8MGIpwjBpoFHXe0hT55OEc2NPxaz20cZ+sTMI211TSNt5zawoeIw2CcnpM7E8L363wfmpf8uW5uxp3sWtSf+Gwt5i8ZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5897
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 02:35:00PM +0000, Ivan Mikhaylov wrote:
> Make the one Get Mac Address function for all manufacturers and change
> this call in handlers accordingly.
> 
> Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


