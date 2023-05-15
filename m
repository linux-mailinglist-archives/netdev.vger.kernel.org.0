Return-Path: <netdev+bounces-2691-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8865A7031DE
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 17:51:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 430172813AC
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF34E561;
	Mon, 15 May 2023 15:51:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2B4E560
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 15:51:16 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2119.outbound.protection.outlook.com [40.107.244.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2C91FE4
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 08:51:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=blqcwu6At9NGASBmHHK09GBSmgbL8cNeiSw1PFWcd4L4pvz6dbBLCNgowz11ddqPHHDfrQcatSASEz6np6xSu9749f1kG90QtXFLo8jwITZUzFa0kdsqI9KTRXRfmoX40dpzls31txQZxCf5INvUia4GzWaVanm+DOdmenkNlO0S/9h7CV9GvEd2bM6M+Rcm3Ow2DBExk5jy9enu82Pofrjp7PM59zeiiBUIfJ2bL4DQrBBiArYqK5PkB2rA8hOzmOqnu+GZ/Ve6XhSHm/6ZOu/AIrui2gRXSRe3lPK6i5tjVw0t09bjLzjAUttYWDBmz88rfs8+dkdN/o/mzOKTcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLCFJsuGZXsMzSavOAknrumiSOPmGxOmnXTeM0t410Q=;
 b=Gi3Vu/eHjyRzMaXLTZwVNaYHA0uY5VR6ypY8kaOGCPXynxE7Dlf74Hmk3PIS+YJKxtbV66fKxMCg7+otVkMi3mnikbGsIOVFDD0vQU26XvyachJNwG5lR6j1CtMUT3Dkpz6l6j9f+A13cKU7lPgw7d7blCdw7XAJnA9RFSK96V48nQn2u3K21aTG/R27pJJhUHXC8XE4EcF+038l2/giqIqLVJYMJelz6lSMhi8wrqHoUR4VI9PWqzJThAcq/t2HUR3VPn1gZA9WCatyvDBl2DcxQQ5L+PoXOya5PqUCOjMGjMfeAkWGHKt6uJRIcOjXBRrySpoTyrWSUKG21WVooQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLCFJsuGZXsMzSavOAknrumiSOPmGxOmnXTeM0t410Q=;
 b=en5L8S/IbA7pQMC5atZTiTpyaBj5sBbck2aa/DPSSKBL14ttAnWJmLBO7o+SibvTEaE2FIE8GClL7g6bZfsHK27TCcrEJovh9ni5J0jR5rbeaPNEgSMpfNMB8DhMcVSBoRk88B4AeqSTdJ4rCK7WN0jVdNPqtjGtc6jEc/0fGAg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB6033.namprd13.prod.outlook.com (2603:10b6:806:20a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 15:51:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 15:51:12 +0000
Date: Mon, 15 May 2023 17:51:03 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hao Lan <lanhao@huawei.com>
Cc: netdev@vger.kernel.org, yisen.zhuang@huawei.com, salil.mehta@huawei.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, richardcochran@gmail.com,
	wangpeiyang1@huawei.com, shenjian15@huawei.com,
	chenhao418@huawei.com, wangjie125@huawei.com, yuanjilin@cdjrlc.com,
	cai.huoqing@linux.dev, xiujianfeng@huawei.com
Subject: Re: [PATCH net-next 1/4] net: hns3: refine the tcam key convert
 handle
Message-ID: <ZGJU55jrzqZYlWPH@corigine.com>
References: <20230515134643.48314-1-lanhao@huawei.com>
 <20230515134643.48314-2-lanhao@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230515134643.48314-2-lanhao@huawei.com>
X-ClientProxiedBy: AS4P192CA0053.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB6033:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e2accd1-2df2-4812-c191-08db555c3523
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5o2D9SUzd1pIqMptqPuzALV9qXVQvHIOaBW8xYVS0uOH70pBza2iJxml6pI6MW6CqT+Zfu+KYykskjfSyQQjPy4nGSwiJikDW8JCAPBx2bhoFDCGvIzz+YBPo8jY94SebPC+BDjNXvil/uLKkGDEdT9N3udYS4aDMzAAkgYOrvCkTCtvPMTSrgF1b/oR0UNcak5mOLR48Sykgfet5zLku9FGkwLYvrqP6yRTbE+Yt52bCnpEeQQCIuiuSmq8J0uwCMi+gZXBQECf/j/bele/9ZUR8XK6BjzdeXK6UzYTPKdjV3yCn2jNv6AQ6bGrbKWQd1OtmIwf9Bf5cgZqDzXvTQ7mcE8e37tnWryjfW4LNRlxXLjJPtH/YA9Cbj9BgM8BXPXRGV0edhK5NEJhZna94CwQ9SF5aC+vDWKutFIOVVALNrdKZ5OeIH0eoRcmtzdeEv9IxmYbUCzyrIuL+AUliHmGaYdmQHl1h9QmFIGnQiu96JCM/hhRCzeMSzDmtgwy+eL26048mE2JGdqjN7sE9T2x0K8TMXfrfrTqmYSAF1mK6aDb7W0x3nTL9DWYtDIp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(396003)(346002)(136003)(376002)(451199021)(83380400001)(6506007)(2906002)(6512007)(36756003)(186003)(2616005)(38100700002)(7416002)(86362001)(5660300002)(6486002)(44832011)(8936002)(8676002)(6666004)(66556008)(66476007)(6916009)(4326008)(478600001)(66946007)(41300700001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3ZRTUlGelhpeXFaQjhFQmJUaWs4YklSaCtjZGhzdnRwQkZGL0MrQmhRc3JW?=
 =?utf-8?B?QmF3WjliQVdVTEovUW92c0VUSHR3Y2hzcDU4b3AxMWhOaTBvNUY1blMybnFF?=
 =?utf-8?B?QVV0UXRHclVqV3luMWxJUmo5TTRpdnA3SHVqWGR3NFVtUVlQVUJSb0c4ekxh?=
 =?utf-8?B?ZmRiUHJmMmo3ZUtKbGREdEYwYVlTaXNOZzdMRW54RVpqc0FCb0UrU0xrOXh0?=
 =?utf-8?B?LzFvTXpxS0taN1oycERkc0FHUk00ODVqRHZaejFXNXU0UXRrR3oyVjlWYk9a?=
 =?utf-8?B?MStCOEdDTzNEeEJpUHBjdWlFUkR6RUFPTmZMWjR3RXJDODU5S2dwc1JnVjIr?=
 =?utf-8?B?ZVgvdTBkMjRPYm85N0ZyRzBRYVZXWG5VS2Fzc2JNMS8yUmU0U3BubER3VHI2?=
 =?utf-8?B?anZXU1pFTmVrZTVJZmFlM2prZ1NpYXN4bkxrcWVDM0ZTeWdkS2hPUFVXVW5M?=
 =?utf-8?B?bVZoWS9HOG83VytEbVhjTU13UVZGK3dmRnNubllnRW91TEUvMko0NjZwTDNW?=
 =?utf-8?B?YUhtYWY2S2d1WGZEM0d1b0RBbE9laXhjNlFpdHVJL2RPY0VyLzZBSXVidnRF?=
 =?utf-8?B?UlI1VmE1N1g4L2FHOGtIem5ua0dpVyt2S282dWJsY2NnMVVCcy9jNStraDJV?=
 =?utf-8?B?Z2JKOXZJSE1HYzBBTTByLzZwaElvV3NOY0NVS0Y4YVVRV09SQkhCN2dCS2d6?=
 =?utf-8?B?TzVuemxHQXlYNDB6N3lSMWs2MUROdE9yY05SM2drNFJhL3NETytTQkFVdWE0?=
 =?utf-8?B?RXJlaU1lRjJDeXBjUlUvck9jamJDMlcrbFVRWUJUMkhNZEVGZHZxWW1mUThi?=
 =?utf-8?B?b1RXelp2R0t2b2dUeTV2ZFlqUFNCQUZFTnhJUEo5OXFRb1AvckRzVml3WUx0?=
 =?utf-8?B?MlJIK1JyZjhlY2h0Q1R1VFhNQ2FiWVZGM3IxLzBkWDVoOVNnRXFSSElQYWZN?=
 =?utf-8?B?dVZIeExQM3BvK3dyckhleDVGUzF6cVdPMEQwVnUxQmw5K3JVZE1RTjZKRnF4?=
 =?utf-8?B?WU1YZTBHVCtwMGRIMWw3VEtSRndYUTFIZW4xajFGUWl5N1JrbWdvdkJ4Tys2?=
 =?utf-8?B?VEg2aFhkeVVEZ2pIeStxWU1ObHhIUlZZZGErMFhLMjJhWDlzZzRKbzRma0E2?=
 =?utf-8?B?dGhqM2dUQVpIQUJLNXlweXB2emFBWUlYWk4zN1J5UG5xYUpsTnQ2MnNYb1Q5?=
 =?utf-8?B?dk5jRVcyLzhUekJlWnJlamVYaEMwdDdSeVRhclZabms0Ry9mQ2FBM2ZsQVY4?=
 =?utf-8?B?ZlFoLzF4b3k2SHVpcVFDN3JEcXVBcExpOFg4b3JxOGlTVFVUbmdZckpJUUEz?=
 =?utf-8?B?R09ZSzAwTDdHRWhYY0lnL0d2dmlsZ0t3WGdyUzExZjlER29RUkRVcSt1bk03?=
 =?utf-8?B?Mm9TcExvajNydGU1cnV1N0ZIZCsxUk5OYjdGZzA0aEJ5amJSeXRkdFA2cnVn?=
 =?utf-8?B?QlpOZDgySnJUem9zY2Y4UnB0bDNmVFVTRzk5ZEpoclBIYSt6ODg2aStlYjBX?=
 =?utf-8?B?RU9hMVBoQ2lPaWNLRnJxRlZXZ0c4SHhmWjlzOUUwMDlMRm54NFRWRVprdy8z?=
 =?utf-8?B?ZytWMDRMNlJaeVI4NXExS21IUUV2ODRUQnMyN1lTa2g3elhSUWVPVW90WVMx?=
 =?utf-8?B?c29xd0NndE1EVGpQaWN3cG45T1FoZG9NQUNrSmRaM3RrU1VmU1YwUHFEOFlo?=
 =?utf-8?B?c1BLelZYT0FwZVNvSS9odmNULzBTbnpvbTVsM2pBa2NyS3JoYWUzaHJPM3NV?=
 =?utf-8?B?bElVM0p5UXhzUHRqL2JyNk5BNmxGV0JvNXllZVRoMjc5bWRReXZDMkZTSVRp?=
 =?utf-8?B?WXZ2VHp5UVEwZTVzQWNmRjQxTGJieFIxL3J0eDVVOXhKK29Vdld5SmJEbHZQ?=
 =?utf-8?B?aE5BdFd1bFlLSFI4WjBYRUxLdGFKOTJ5Y3VIVWd3ZkExZmpSTy9CTmE1S2F1?=
 =?utf-8?B?TTFSZXVaQlVQRjFpeVJlODRXdk4ycWZtalpJWGU5Qmx4a0tmdDB4aGJIL1A3?=
 =?utf-8?B?M3BPOTNUUXkxM3MwWHFGZEZpN1pmbmJiUGppRTkvNFQzd1pxdW1LeG5jWU05?=
 =?utf-8?B?WU9BUEc1TVBxN3cyMC9aMkJJTmp2a3YxMWg0ZVkvcGsvY2p1TE5SS29sTmN1?=
 =?utf-8?B?NkNKeXhyUDNYWDVmQ0pYMVR5dDRDRGNmeWJqU2d1NERmNm9Yb1N5NXprdTBs?=
 =?utf-8?B?dWdWTWtQV3p6QjdSM3FXTFNkMnYyQjdPODV0MUVZZHRaRXVMQ3N1dUdPTmx2?=
 =?utf-8?B?ZVc1T1lTd2RiUlg5NVN5aS95TjF3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e2accd1-2df2-4812-c191-08db555c3523
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 15:51:12.2020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4OXZ9cFu6QfIRbXpqXLwYqTwVCN23R6dNs14xjjvpRH/g6BFKziqtg/y2Q9LG1YhToXGrIS3xICddrbxPiBSG8myGLaMILZVez35MzeWwcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB6033
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 09:46:40PM +0800, Hao Lan wrote:
> From: Jian Shen <shenjian15@huawei.com>
> 
> The expression '(k ^ ~v)' is exaclty '(k & v)', and

This part doesn't seem correct to me.

Suppose both k and v are 0.
For simplicity, consider only one bit.

Then: (k ^ ~v) == (0 ^ ~0) == (0 ^ 1) = 1
But   (k & v)  == (0 & 0)  == 0

> '(k & v) & k' is exaclty 'k & v'. So simplify the
> expression for tcam key convert.

This I follow.

> (k ^ ~v) & k ==  (k & v) & k ==  k & k & v == k & v

Looking at the truth table (in non table form), this seems correct.

k == 0, v == 0:

  (k ^ ~v) & k == (0 ^ ~0) & 0 == (0 ^ 1) & 0 == 1 & 0 == 0
  k & v == 0 & 0 == 0
  Good!

k == 0, v == 1:

  (k ^ ~v) & k == (0 ^ ~1) & 0 == (0 ^ 0) & 0 == 1 & 0 == 0
  k & v == 0 & 1 == 0
  Good!

k == 1, v == 0:

  (k ^ ~v) & k == (1 ^ ~0) & 1 == (1 ^ 1) & 1 == 0 & 1 == 0
  k & v == 1 & 0 == 0
  Good!

k == 1, v == 1:

  (k ^ ~v) & k == (1 ^ ~1) & 1 == (1 ^ 0) & 1 == 1 & 1 == 1
  k & v == 1 & 1 == 1
  Good!

> 
> It also add necessary brackets for them.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> Signed-off-by: Hao Lan <lanhao@huawei.com>
> ---
>  .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h   | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> index 81aa6b0facf5..6a43d1515585 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> @@ -835,15 +835,10 @@ struct hclge_vf_vlan_cfg {
>   * Then for input key(k) and mask(v), we can calculate the value by
>   * the formulae:
>   *	x = (~k) & v
> - *	y = (k ^ ~v) & k
> + *	y = k & v
>   */
> -#define calc_x(x, k, v) (x = ~(k) & (v))
> -#define calc_y(y, k, v) \
> -	do { \
> -		const typeof(k) _k_ = (k); \
> -		const typeof(v) _v_ = (v); \
> -		(y) = (_k_ ^ ~_v_) & (_k_); \
> -	} while (0)
> +#define calc_x(x, k, v) ((x) = ~(k) & (v))
> +#define calc_y(y, k, v) ((y) = (k) & (v))

This also looks good to me.

>  
>  #define HCLGE_MAC_STATS_FIELD_OFF(f) (offsetof(struct hclge_mac_stats, f))
>  #define HCLGE_STATS_READ(p, offset) (*(u64 *)((u8 *)(p) + (offset)))

