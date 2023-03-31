Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AD36D26BA
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 19:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjCaReO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 13:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjCaReN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 13:34:13 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D3F1DFB7;
        Fri, 31 Mar 2023 10:34:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FE46kLz9uJjW5SKgCGzgfu0ngHsZTKPhOoZMpfKXsLWgbW/ZJMeyYHrX0DcTADnAJOaLFU8up+AmgmNLCmeys7WJsA/uT4z3qFVpl8UxAAAooVHd3RSdYluiQ0HHE60O3BgYjOcB/CnUdi9uk7AEvtNdRQK7xgEIE14xo+KR/tk+6vGxaotLYpqITjZuk36z+YEu0G3oBVKp+2aQrvZH1PaQIF/KIyvNAD/SWYfJBdmsxy2/kimPgnGGt3GdfY5gsedIP5OD8IlOuz1wR2qos2ma4k/00I6xdW2x8iSCTMvD8DyMb9NThfb5kuRsalF00T6JbRRTHUvGHdaVj5Ye+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSLuyk1uuwO09VNuKuVBkl1XKKaCqQ51pP511L4Ggg4=;
 b=UCyLt8CREmMWoA7boQp59sZ1DhLOKpFU54TETKmwnEh0jhVqs10rwZ8JEjDYlUdBod+ev5J9SvM4x6EjRiZFTEU5cy5WORwR91tyOCiQkHtm+NvrLCQCtzN53+KtOABk20+GGGgmtC1HlL1qSoapVfCVHJPnOx2X3eBo1z2AZqZUHBmrAwsF6413s+Ni2arelqoFkCw2IspwE9ShNXAePq5mWhNVBxd9KyBSIvzEmMQLX1PK/GNCQqAceQfwlDyhBTIW2pNJf9HNz2y1jLz830K5RMX0k+nPedMiX+V58xYRv8BquYaG+Zn38hAd0/HNudRoi33TRTbWCQItH3S/4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSLuyk1uuwO09VNuKuVBkl1XKKaCqQ51pP511L4Ggg4=;
 b=MvLjzsZAARkTme48Pua6M4rO+AgE47hqgkAHJ7i5LbuIqXaHP3oYxZoudO4fyKS1Wge/OEMLv2SQgGZHgeDD4zQXZ99fLGuPS393nBloVN4Pm6Wb/0fCC3A16B+tht2Dxd4r8hG9T6i2fpUVtXrDgFj9LRw+3f0UwTlyeyE98Ps=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6070.namprd13.prod.outlook.com (2603:10b6:a03:4fd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Fri, 31 Mar
 2023 17:34:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 17:34:04 +0000
Date:   Fri, 31 Mar 2023 19:33:57 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Chenyuan Mi <michenyuan@huawei.com>
Cc:     isdn@linux-pingi.de, marcel@holtmann.org, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cmtp: fix argument error
Message-ID: <ZCcZhZXuGXqnIjiZ@corigine.com>
References: <20230331064520.1320749-1-michenyuan@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331064520.1320749-1-michenyuan@huawei.com>
Organisation: Horms Solutions BV
X-ClientProxiedBy: AS4PR09CA0006.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6070:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aee3e91-97a0-4bd6-ef81-08db320e1f79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /EPjzq0UCa633aRSUFeJyUt2LrSYT/0kHxJ98pF25rHJU6PrFgbgxtqcRSjrX6wgLHccQ5JnJcfoCp8ideBevYkN5OLqpWTQN4LTuwz4L4k40Sk7OoxkTQnaniTx+8l47g/wAfA+DWDhECuFjwWFwxvgB1jO//qkn4JiefCvoQqKdz99utwQijfrGx+Eir+TOoMzOvGRWtNYTWZxXr41Ufm3DwxPfxNjg1VjtQPxrlcao1PQ25AoKtrxs0re+9EKtsRvb+1w1Vzzv2MPVJUr2wKExoM9BgnyZaUuKTU7Bs26uTRbe+VsXznpFoCAFaRUgq5jkmdsc5/XGc314WP1Bgfi+9eB2D3yy8e4+L4BDAmR1+WnwOCN/zrWn+NOFu7nOlUeYr9clRzcu7WBNOX/p2G1fhe6dtBBltzzgavOkmm4lemNKTv/ewrzhPGyuz6NJYL/YTlwCuqy17H1r56sMVCqDkGfZPweKCnsnXtw7dRTDeyjDKPHl1OzsCKe5/0uDd8LurBbClvFQZ3cNkuWYn1CpOpCgkGohMp3ddM81Ik=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39840400004)(136003)(366004)(346002)(451199021)(2616005)(316002)(6666004)(478600001)(6506007)(6512007)(66946007)(8676002)(186003)(4326008)(6916009)(83380400001)(6486002)(66556008)(66476007)(5660300002)(7416002)(41300700001)(8936002)(44832011)(2906002)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wguVCwWq6rVbycae1YF+x/HhYKmAwWi6iXTf3fgtFLlQlUyQBcALQVdIu1k5?=
 =?us-ascii?Q?2sEusWLq3nw1/gFx9ak0WSvpxhn7Y6PnArjEP0h8PQ2HUMWSt0r4+3Rxr6A8?=
 =?us-ascii?Q?2Xa3I8d3VFI+lp+tqzo6UdolF+Lqo032eNAhtdWun76Y4x+lj+2jn/YpHOJG?=
 =?us-ascii?Q?/QbzbryUrrUb7umepTQMvayVtOfbRqFKq56tBkT6lcYANlvuPKu+RiqwdLRE?=
 =?us-ascii?Q?wayvj8E+jWBysyzTdu62VeyA7swIWvnQOEdGRYQ4Phu8VdDrUYqeKtzsuHiZ?=
 =?us-ascii?Q?63VvBX3EfYuiqld/v9Soh8632Gw3Kdp31dVvnDIXny3xHqKrBljseQmRra6k?=
 =?us-ascii?Q?bjvHtqjo437PQLGmkEv0TPvRcRWGbAghQ32oanmfeaGBscqnMkePpQH0j5EF?=
 =?us-ascii?Q?9/YZkB+PGuDf1KIP2L7iit/Zdz7DfhJYrHn3coGDLA71IJ+ddfX54H611xOY?=
 =?us-ascii?Q?P0Gx692BWFOpH7U3Sh1ew3pwZFbrM3k47cY7K1qd7fGn+XYbffXI91C5NzcI?=
 =?us-ascii?Q?+11g2Rtmi3RsoNLfOs3VIhcR6zJ0HJIBcztDGjiOZo7ECUntJXOJS3gbMjQL?=
 =?us-ascii?Q?Y4GH2NIgpPu5ftUjMd/j+QXqeqrf7Y0fUg2EI46FTRn/q0swXd2UGh6nw8kX?=
 =?us-ascii?Q?H9SuAyQltYqHYtiPY2EohwROA8X8TDojm8SNY3WRDZz50t/PvkyqxQoipPNP?=
 =?us-ascii?Q?M2Y2M62HXuRx7kNdVSdfGNgVzUzzu5Z+dicCmjjS/eDr4VqbF3yAlgcaDcCK?=
 =?us-ascii?Q?i7XlOO71LDvHPbv0RdL9cTYVr9wT79ns31mvx+N5GWR5SXHkx9K4M/p0qs/A?=
 =?us-ascii?Q?6VOzxTYxdpBW3BTQo1LOpzesTBUvwhgoPVNalGUoXk6aZ++hw7LJnV6OOWiK?=
 =?us-ascii?Q?oViW5bQwZidYxg+xFR+Y/NVYf6x1CPufqkf2WccPskc2s48YoKi9wcG/a22O?=
 =?us-ascii?Q?5Sk0SL7OZMjRNIzc2Oj1jrmxTcCPJFreIOHfZHkVg8HqtIftpeRqG7AgvpQE?=
 =?us-ascii?Q?LDFtKG0yqqnhIIIWPmFoO9MSq4NWAsPH3yxqz1n4uy31VLXvClanjMDYGlur?=
 =?us-ascii?Q?5b6pbZvxYlOwLgGOxJoXR3ACOQOyk7gB6BP6RgL42wIm+wELP8wQEZK7qeEW?=
 =?us-ascii?Q?iIOpZBU0TnZdUkt0NQHzBX8f8TlEOmwPKsTKK6LMPrA3poZRoENCJI1KGbcr?=
 =?us-ascii?Q?ag3RjbehwVc3o7wuMyFZ2yw3vdKqadNKzqk0LtZ2myNX8vMmJsoppCJFNhbK?=
 =?us-ascii?Q?suXs+5nAxzH0caWVjNruSzdyse6dpBkFM8J2Q9SrFntPw19Bj9Q7FiepXc7r?=
 =?us-ascii?Q?4tbG3A7YkojDoo/7x+OFQf5DqrwDZ011t62jCxn3j07m7ovsZ/mfob5KIQ34?=
 =?us-ascii?Q?AZN6abYuwdxCMvW/A6kbiO6DDWnr/YDAqdNHqa4eifeASF+BxuOK9CUPdst5?=
 =?us-ascii?Q?elR0f7N9kHKgRz8XHn+hRVr41rZYKMDcwZcyZiExnyDqMW67Z4Rj9Y2tg/G6?=
 =?us-ascii?Q?qUFt3r/LWCsuqDd4sGuZIH/3gBux3B3OB7GITGsVl18bawm6N6CXSKWSLyEH?=
 =?us-ascii?Q?ARYYpiOc2+wx3F/3KRNcq7a7cXtQjbIyvSpH29JHvmC8JOoP+vR5ZEnk2Bjm?=
 =?us-ascii?Q?RkTW3hjMKpnkrifkaaNZKTyCs7Vh8NP8YQPJ2FtRdqS2FWOX15h+ToaNNJS1?=
 =?us-ascii?Q?4jNvYg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aee3e91-97a0-4bd6-ef81-08db320e1f79
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 17:34:04.4960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IUevW7V/7t41/xBjVKIC4jIZ3gJMJ5jd3u5j9YULEubORjhpgASQEOa+T+rdvVmylIh8QtOabij1WlnKqORHXeVFhvCs+7ItYY7HkhLRVcs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6070
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 02:45:20PM +0800, Chenyuan Mi wrote:
> Fix this issue by using BTPROTO_CMTP as argument instead of BTPROTO_HIDP.

Thanks for your patch. Some things you may want to consider:

* I think it would be good to describe what the effect of this problem is,
  if it can be observed. And if not, say so. I think it would
  also be useful to state how the problem was found. F.e. using a tool, or
  by inspection.

* As this is described as a fix, it should probably have a fixes tag.
  I think it would be:

Fixes: 8c8de589cedd ("Bluetooth: Added /proc/net/cmtp via bt_procfs_init()")
> Signed-off-by: Chenyuan Mi <michenyuan@huawei.com>
> ---
>  net/bluetooth/cmtp/sock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Code change looks good.

> diff --git a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c
> index 96d49d9fae96..cf4370055ce2 100644
> --- a/net/bluetooth/cmtp/sock.c
> +++ b/net/bluetooth/cmtp/sock.c
> @@ -250,7 +250,7 @@ int cmtp_init_sockets(void)
>  	err = bt_procfs_init(&init_net, "cmtp", &cmtp_sk_list, NULL);
>  	if (err < 0) {
>  		BT_ERR("Failed to create CMTP proc file");
> -		bt_sock_unregister(BTPROTO_HIDP);
> +		bt_sock_unregister(BTPROTO_CMTP);
>  		goto error;
>  	}
>  
> -- 
> 2.25.1
