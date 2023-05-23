Return-Path: <netdev+bounces-4696-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62D3370DF19
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43CD31C20D30
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0B481F183;
	Tue, 23 May 2023 14:20:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3571F182
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:20:08 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2108.outbound.protection.outlook.com [40.107.96.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C728132
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:20:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXhf8++cywraMfKgXoDASIKqJ9VJLkAm4sVygtq913ecwvkdc4mbEDGbKbSjLG8D8rqANhr/E7AGhNl7AeQQz1Fdm6T92MKDJ4tAIVSJywCz9JaCKjlmni4Y31hkmS1+G6IvD0J8IaHumZbnYHneTDVkIgARZuSst5TIkPxNuSD8GntMttGGMqTMT7EIGlVbj3Y6+krSZ5IOaSzmUjVkEnx1wNXGjvKMFuCH/3GFlXGoboTnyOiML8PwoubYsHXp1yj7uCzY7tq1Lj29ugbWt38if/r+CMTH0XoEsytQNeFaZFtkaJ7QqOI08gCLm3qnVjTJb1XDKncHoOiW+VOnKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQ7vQkFqdSiGT2U4lIMX+YhR+sDSv79tiJTS154Bxp8=;
 b=XMHZV5wD2lE202Y7na9Ufs5xa+h07mIhGnKKtyLTkFf/50tZOJab3A4i6UDl2V8FFm09zwjgVbJLEXTvVXzBsHSoGWJgSEXnicJH+j812uxfnWDQgtmeQyERVkPlTjAyRiRFc+4Tq9b9vO69cBAxDvvBs6C1arppa39R0JyfAEfSeWx4TnVDC94nPRVv4fPnel3qUO4+9GzdpPsLiunsFYbZAC7WIeAJGCnNg7Op5Yr66PzaUA7ix/0irYaKAHEiWVE10Kc8/ig0555F95N+KZbWU5KlLsBT/BlLpKl09glidbJM0kr54Ou5s08Tejo4gYvezjeqe/v9wDckIaxEqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQ7vQkFqdSiGT2U4lIMX+YhR+sDSv79tiJTS154Bxp8=;
 b=r4wUHhqhW+692JFG0z7J/cbpgbU5rkjZ/ezysF8hPVmYfZlOiM4rVGIlgDzZ7jq7MxugJtXAfwgOUXH/B6+zRXs6n9d3m4h5OyAA4rKb4AA+I87+FjONSJwpf8Y9MmNjV9vhBBr+UfhwmmDKGCzW4OqVtIeDgJCkG6HWK+kFyBY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6407.namprd13.prod.outlook.com (2603:10b6:408:196::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Tue, 23 May
 2023 14:20:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 14:20:04 +0000
Date: Tue, 23 May 2023 16:19:58 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	davem@davemloft.net, edumazet@google.com, leon@kernel.org,
	saeedm@nvidia.com, moshe@nvidia.com
Subject: Re: [patch net-next 3/3] devlink: pass devlink_port pointer to
 ops->port_del() instead of index
Message-ID: <ZGzLjv6Z+h1qpDr+@corigine.com>
References: <20230523123801.2007784-1-jiri@resnulli.us>
 <20230523123801.2007784-4-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523123801.2007784-4-jiri@resnulli.us>
X-ClientProxiedBy: AM0PR06CA0104.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::45) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6407:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d97187f-aaa7-496a-53d8-08db5b98cda9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	N5xdGaba6RPu7eUK+9a8BmHxUDhZ3DsWgcKzABbguR7k6nmO8C9m5pOoxSvwti5Yw2d84Ss4NptTHqG/+/bzfBbg9mNSiUfxtVrXARebzqMaEZ0mTfQuBcDSTbkoC4t9U2NX6XPpJ3DYatu+DDJ6ckkLiOIg8EleXJIricA8cbOvFElf9VLnEoRg6VgKPZ/2JfLK1j5c2RUjkqVMBIcEGd4TXSn2N/nFkM9s6o6FCLqdWAW9hqQUJV3lOlzb5jJX9KlZe4TgaKEENeDGY0eDhWdnMpBAm/XLQ5ClC0OPwMTOSayE/kPWFGjV6JZHsVMQes3kOkUaFBtOywBSFvyhgJrqMkoSW0oqL/YijZgcHE1VDGCNKTgZqbEmLibLz0kbjODG/5QyOaqyMOuFkw09b9j6rUUElcNIPpgTJ1JGkDWB/0O4O6FTFjobpy8jwz4iBh1FH0mkasSx6PZsAjg1VKVMufd9sxtwbSkbKu+hWMZm02+7MUd/r7lE2n5knerf4qp9bkxCRJ0PyPakAn3IV8+fqCoKn0Yeew/mZJWZUnwdU57tOrzjVyXR5pTuHS2rBsHw/83QUWInoq8+FMPx+aMmxOTNQ8dJu1yVURcgzUA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(136003)(376002)(346002)(396003)(451199021)(316002)(4326008)(66556008)(66476007)(6916009)(66946007)(41300700001)(6486002)(6666004)(478600001)(38100700002)(86362001)(5660300002)(8936002)(8676002)(44832011)(186003)(6506007)(6512007)(4744005)(36756003)(83380400001)(2906002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x/F0cejXAjzqVHSVH1CmHbyoK4i/fM91ImmdEbFpMjh41b728kc8uP7L6B/R?=
 =?us-ascii?Q?FAV8KDbC5bQUjnBnrTTOq9Sh/eOTVGM5op6u62XEbuDQb+MfuuPvanr8LDW5?=
 =?us-ascii?Q?lVqiBSTV3snjA3TMoQvGEnAieGE8uPCA/51jXx65LymrkeyjdG95wI+07Lam?=
 =?us-ascii?Q?19FZ8iLXcgRV3w/va0eJzYEBqgXSVdD0as83byfSYYa5npHOhbSdHkqtffmN?=
 =?us-ascii?Q?HBT2xJw/EVXmLQoXVc3ONEq16iOQYivcoyvad+CuhhypvfxaNTENQ1Hj07Bj?=
 =?us-ascii?Q?1pL4f4iZRPCJgGpZGtvc9nvIh30jln8GxRJQo/6bDtY9FBbmQ3u+5Nue2vU9?=
 =?us-ascii?Q?ylQjnNCAmDv45iflXRu6g/Q8vxyJWTzpWJ5Mssh8xlBVOja61M2vpDXZrshZ?=
 =?us-ascii?Q?0181WkmYibYe3K6gFME48NfF8TyhAzk1T35x2PZmpfapYuQv31IzM15KVtlt?=
 =?us-ascii?Q?1hWYLIioVTTUT9n3UrkrGeRIO2OP+0V2AfOq6oeKhNWWPuBchPsxYdS8S85u?=
 =?us-ascii?Q?Gu4j9r55ba3OWubwhX9vutv2ZIyWrPPKWvPM5kWHuXoUdSqJrNS2ER1RqJ8N?=
 =?us-ascii?Q?9ylAMqzy5qyXe8YE3nAwgDGyXDtD8jCQNgDmQfEP8XcwC88oisqiOUxrvnKT?=
 =?us-ascii?Q?gzFCq7s3IRun/RWN6b6Gh9h701WXfvnIHfE/4bmJPzXdFH1o61AFTfMPK1s+?=
 =?us-ascii?Q?GJtneGXDJZklfSGG2oZZV7oOFfCSl8rgJPIkbvpj7vVAnYe1bd5+ZRwz32bL?=
 =?us-ascii?Q?VhGeWQgK+iF87kgc/YezleK9QLpQDZMjr/44Q4Q5zC5Ck9Eg8nTkv1Tc5Xw7?=
 =?us-ascii?Q?7cIVhnZ9p7dsNBd3Lqr5a9dlzlJKp89CKqLo/RDZSPOpF7yUJw5pMwChPxZt?=
 =?us-ascii?Q?M0KrrivLUF/Ay43t5lqt4USjfQsvx9SS/ENzhZuxrWgQHl8+kMmaJCa6yYrV?=
 =?us-ascii?Q?0irHW+y/w+B0b8e0V930llAwoa45hqkzw4sgDFkvzZRKbvgVfq76RvCMqcx4?=
 =?us-ascii?Q?h3oge+GvDVbLlJtVDGCe+aLe8OJB3eN0nGtpQucXr65T/DjobvHAx5rftZs4?=
 =?us-ascii?Q?On85RdowVS0iOvYzJT3il1T1L/A1+gXMntuEEjyvtjurm6w5aszCtTpz7s6i?=
 =?us-ascii?Q?idgHmUu/4d50i+pj8KkLqoprkRmJR/VEJ6irxh3bwA35o3g7p8MTfK3O3+m7?=
 =?us-ascii?Q?KeZIx/Lt+sIhCvaIQrhvGvizBmVz2PKdO5siK+SDYc+RRWC1o7bE0Hyr4kas?=
 =?us-ascii?Q?CvoniDyq3PrOx6d2ROAtEegwPbXEMcLte/I0raKCY7XPmbw+54eZc7cOl58X?=
 =?us-ascii?Q?dDuUb366++8sy3zxmWkLWEkOAwsScAM5tinGB4qqjDfwMZj+SnU1Omj1yZTD?=
 =?us-ascii?Q?J+Cw98BpnppKEkACaH2e8rziBF5YNBjd4xWz69rDdfJt8HoweSfed0Xwvb7p?=
 =?us-ascii?Q?cfaza2sTrspCStUlf9/IXxiAqXLAyDpyyixqk0VrMgG8y2/hWn9lhLIs11/e?=
 =?us-ascii?Q?iMARx8aK6UAJq2ht/rPogkhDy8/mqJNVLXQx7KDyLL82p/d2CL0aK5whB8tR?=
 =?us-ascii?Q?Ykh/rdTTcT/WqBY7LvcTeQqU6THXGTH+Brq7zxAKKfCN/ziwfdHEK55hF7WR?=
 =?us-ascii?Q?fzal1XLYkLCJcp+oUk9KfnZDVlj+BkFfjGwiPb6+9+a42L/wWl2x/rCTyE0f?=
 =?us-ascii?Q?jhX5EA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d97187f-aaa7-496a-53d8-08db5b98cda9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 14:20:04.8049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 57BgYUw0QTNG7jbM0EbSZ6Be2NQYnFv4Dh0JCD7mm/U4qb7UU7oCOuJf4Hnxxmqy/gqs8amjuqsDsvhRJFIAJdW5NfDxdQuPqR6uV7Avi9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6407
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 02:38:01PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Historically there was a reason why port_dev() along with for example
> port_split() did get port_index instead of the devlink_port pointer.
> With the locking changes that were done which ensured devlink instance
> mutex is hold for every command, the port ops could get devlink_port
> pointer directly. Change the forgotten port_dev() op to be as others
> and pass devlink_port pointer instead of port_index.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


