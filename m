Return-Path: <netdev+bounces-3011-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60D9D70503E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:11:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DCED1C20DE3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C48428C06;
	Tue, 16 May 2023 14:11:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EC034CD9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 14:11:53 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2138.outbound.protection.outlook.com [40.107.212.138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EC0527D
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:11:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elCB2s3nwv8Fc/Jow6aBP8Z19fNWUeypFw8RcLjL6l/ggXoz4w1U9+gorCyl5miiZDeNibVM9o9EijHP0Wqq5qTXnsUyRL+A026M29fgDzM8XZm/nWVBiMK/O8wwlIf49iLUvTd34fF1OT94wNWQxc0C3ZTT88i6TWw1dyYBJMUY0CogiMCKUXnDKQp9CUVVrfNgn2fnWp5o/5j2kXPzSKYbSV30dDnlz9WSdAUdfAFsYvh87Fd91iDp8b8Sfim42HjuXliqQiIuinWoNMMlxo2kYAZIe7x8GQd7BeWwc0g6bemKqXZ6NxAgsYdYG4315AOlPDqgQaVJ+rY2+9oVYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xYYYKIopJoMuewSSWaOxd9yWJfNU+NDaOLF4niFzuU8=;
 b=Ygm5Rl1Hay6Snq4cv6g5ytFoDPCEQnp2KCip7z+E2szlsXQrHPPye2EYOybX/B0oegs7a28mJEnNBLclBw2k64rgCfdhWHnPkzSZNnOmHIQ6lgJkMMrwuh6Nf46+c9mjCa4Q6V0HNqN4/okUI6eDSwqaobbCVPQlexchkkl5GDBdufzvuEuCnkLonjhmpaePv8pM0/FkXK3hN15hm0lMPEaFfEu0b4d7gb6fwRV3sdDQkMaG5zHhfC53RG6q3rBhtr17n/aTamx7PdiCEROYt8AWdvBcD5T1q8rgreILRniSd42mjgApeBNmWDLwYviQjP0WiWWcJtQteMi2aEAhGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYYYKIopJoMuewSSWaOxd9yWJfNU+NDaOLF4niFzuU8=;
 b=XjcHjXWXdoLWzbdjJQATf+OBi24KIxLuEg5p3rWiMnSD8rTPLPaHdTPg7b4N3DmSh6GOz7/rvGJhhZB1dntSGELdF3RCasrWZikinh/NjhUEQzyQ44je5cS+SKhxC7abXeyD6tj1bNI91tS8RrTBUYR2KByGgls1SLMzRCdW2N8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4140.namprd13.prod.outlook.com (2603:10b6:303:59::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 16 May
 2023 14:11:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 14:11:45 +0000
Date: Tue, 16 May 2023 16:11:38 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hao Lan <lanhao@huawei.com>
Cc: netdev@vger.kernel.org, yisen.zhuang@huawei.com, salil.mehta@huawei.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, richardcochran@gmail.com,
	wangpeiyang1@huawei.com, shenjian15@huawei.com,
	chenhao418@huawei.com, wangjie125@huawei.com, yuanjilin@cdjrlc.com,
	cai.huoqing@linux.dev, xiujianfeng@huawei.com
Subject: Re: [PATCH net-next 3/4] net: hns3: fix strncpy() not using dest-buf
 length as length issue
Message-ID: <ZGOPGhF6w08CHr8j@corigine.com>
References: <20230515134643.48314-1-lanhao@huawei.com>
 <20230515134643.48314-4-lanhao@huawei.com>
 <ZGKOdijGtX03qV2p@corigine.com>
 <55ca40e4-eae1-c037-7038-46160a76d5e8@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55ca40e4-eae1-c037-7038-46160a76d5e8@huawei.com>
X-ClientProxiedBy: AM8P190CA0008.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4140:EE_
X-MS-Office365-Filtering-Correlation-Id: be7da234-c350-4a3e-ec82-08db56177b39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rfeOI9G0ciiSfB4v1eRjrgCeFDWrM2jaizFjIs1O1sxFq/35wPNuicOg7JVXlBizdFhzN/79wWcBE1Jg4Nvw/Yw+RXJx3oIPfl7vfOXiVsOz50KaNNf/EwZxpkFCjK1d3ksDqjKt7b3uPMxN9Phuor2SIJIdQlH8JAnmoc5hmwjPSFc4HeSWxfd4hSKhTNBE55JifpVTmeVQSCeEjc2jPnvmGMpAP41V8NiR20hW7XE5XRSIbaFBOx6rPFpeuk3okNHUl9m/D5ZSh+blnolMfNT0qeto/K6gHaF1qBhOqr1WDHdRjwzO/yuz2+x+/lObXZ8Qfot+0SwfL2ZdX2RRc2y6n8GZr6DwwIN64Mi7pavnWw7ZX+Smk5UiktGemMbRYKcG7J7ZpMszTXpWhM4feJFR50ZHjOGbiNaDogbz0jcaQymAgpq6Kj7PX+yeO4sC5JSaqel1DGeqRMb8siANSECJ1cPJr4aEZcuZElQOylxm7cuc7+KbeZFLuV0y5Po+ZIB7NLna3czJbKlrtVRQrDL+bCvtyaJ3TvOPesCkank=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(136003)(376002)(346002)(396003)(451199021)(478600001)(4326008)(6666004)(186003)(2616005)(83380400001)(38100700002)(966005)(66476007)(66946007)(6486002)(66556008)(6916009)(86362001)(6506007)(2906002)(53546011)(36756003)(41300700001)(5660300002)(316002)(6512007)(7416002)(44832011)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n2MU9OH8NtfTvFWbdOdl67wauk6Q54qedNK3lZbGcm3JaLYh07nupk9SVIBx?=
 =?us-ascii?Q?gy+Q+fgP/f09BbWBRgJ6mChjTGXsA0S7QbjDWrqKu2NgHE/Ym8MAejvuQsHi?=
 =?us-ascii?Q?IcGCtgjFiIoHmebb/ndLZ09MEZoImwyvhP3/iXjO+qTe9Z/PxO0mQIvleSd0?=
 =?us-ascii?Q?+Hk4E7i2Q2J7zJeRSdZKRuLHnbIM/0py6xqAkDozrGJcEieErcQsXC5e3gTx?=
 =?us-ascii?Q?5vbBoDv2n4DjoGFnlXE7pA+oZOyjnyJ0YZ+vZSusP4TIUwHEYhtWN/I3AT94?=
 =?us-ascii?Q?QVIfBqDxBGeaVstZKPSU98Wh7ZFUuDqQb6oykygHkcb2lv/0NSxXhMuS7JiF?=
 =?us-ascii?Q?axl+vmAJ42ED7pDF8bTUEh2r2S2zA4E4LEuN4sJd1jluZXTJ5AnxNQvYPqs0?=
 =?us-ascii?Q?hH3nprYw+xtK4mjRfQ88Crgg1lwH0qkEZ5Nb5KlFMrlQ+TgzGLfFK1tw3IWu?=
 =?us-ascii?Q?BOJzxtzu03YtRg6JAOooIfcH8aoupodrQM33RJ0ebpxU9glQc4alII/3xhTS?=
 =?us-ascii?Q?UK2lSzr62RZrP1ZT2r61XRA/qvJNte3EV3opFvqgPFVNJCKtyhex/qizLXeP?=
 =?us-ascii?Q?DCAwe4G06BufZS9+033BpDpM96RRs6B91kXJI6KQkhzuk4Kc4iXw5YrQNKzO?=
 =?us-ascii?Q?oiNtn1K8juS+hAH1K+ZRGwIzsmfOgpXRR7yO+uec3BZXTq42qTdZpyPeNMt9?=
 =?us-ascii?Q?NZl771UIbnfCmVRJxWRpPfa3DIovkwvqk/oO7aRJODkRyDJrN/hjAUJxPieS?=
 =?us-ascii?Q?+zF01RyM0rNQtNWyiSeOKnOdkRDk8gt6MUPNwcu6n2CErZVeAnIPW1G718eL?=
 =?us-ascii?Q?02N6s0ooRSaqybXfef+rpIeZyUY8C2ZtyVPlxYaa66st/ROHV7R18fazzx/1?=
 =?us-ascii?Q?uFJ4Vafmrn8XI/D0gxkJeCOb0RAj4VtrOSmmsR/lsnB93UPSqM7y7jCwBJno?=
 =?us-ascii?Q?Mr6oQ1t2JPY8RejF05OVSAsyiDGRZRx8FagzcLu40MBVRc1iLZBVaV3iQ2SW?=
 =?us-ascii?Q?U//3Mv+jizJ48NuVphYWXoooKz0mpOp618fmW0SkPL9kwsCY7OC2dWM9CIE4?=
 =?us-ascii?Q?KRim3NTcBfcCYFxkj9VZJ4JdMvAHBicOt5cI9FiI3XEOQYyHibTSoU2eIsaL?=
 =?us-ascii?Q?4XA29Bzsc77Qld0qtyuymibyS7WN3dwt63N9drBMTpF1p7tEP+0LIMEMUdP1?=
 =?us-ascii?Q?Hr5Zuft/qLwiybhKSbvyeZr24uYgTXewHP8w3n7BTXnvRQK2ES71WScmVFiW?=
 =?us-ascii?Q?cWXHWBxc1vhQhyM5BagAm4Tr8m5d/eVW7SlvByVvFeguTmFm/r95veApQ23Y?=
 =?us-ascii?Q?6py7UpsSwoqpttADsIYmcYWLHD4beermiQmEWVBfDxiRJALu5gPpZG25R/oM?=
 =?us-ascii?Q?xoURvhP3vnvBlKKqlzJkl89wjVdXTiqYS7ZI0L+uVDN/w94HTZtXoHM3r0Ww?=
 =?us-ascii?Q?idf0Zy6CfG01brPIoNkHyRGPlZ6iKPTva2TBA367JgDpAhQuLAaTeqezgUjv?=
 =?us-ascii?Q?WSBDcsUmTdprA9qyWJlwjPPhwkDcuxKD5OS3rhbb0Yk4ZkdU+hnwRPj2MUSV?=
 =?us-ascii?Q?dnHqPrUgiCum+n9uzNyvqqtA9cSxwBMYQ6iFp/nOIkmvzlGfZaaeRKl4p4iq?=
 =?us-ascii?Q?sZDqdFNHO1BMWiIVbGGCfs5rSZwCIIbbMnEinxrYtExE1TPRuBUNHTaWejJx?=
 =?us-ascii?Q?HOXQNQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be7da234-c350-4a3e-ec82-08db56177b39
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 14:11:45.7423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3QrVHZjxGRaI75LjDbL2UyzCTi02I7hAipae+cNPPj0lDkAzDdyDevNvZL65I23W7Wir/7UE+qZNYbjESmbDvOakaiBM/J7Cchvf13NJlew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4140
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 09:09:45PM +0800, Hao Lan wrote:
> 
> 
> On 2023/5/16 3:57, Simon Horman wrote:
> > On Mon, May 15, 2023 at 09:46:42PM +0800, Hao Lan wrote:
> >> From: Hao Chen <chenhao418@huawei.com>
> >>
> >> Now, strncpy() in hns3_dbg_fill_content() use src-length as copy-length,
> >> it may result in dest-buf overflow.
> >>
> >> This patch is to fix intel compile warning for csky-linux-gcc (GCC) 12.1.0
> >> compiler.
> >>
> >> The warning reports as below:
> >>
> >> hclge_debugfs.c:92:25: warning: 'strncpy' specified bound depends on
> >> the length of the source argument [-Wstringop-truncation]
> >>
> >> strncpy(pos, items[i].name, strlen(items[i].name));
> >>
> >> hclge_debugfs.c:90:25: warning: 'strncpy' output truncated before
> >> terminating nul copying as many bytes from a string as its length
> >> [-Wstringop-truncation]
> >>
> >> strncpy(pos, result[i], strlen(result[i]));
> >>
> >> strncpy() use src-length as copy-length, it may result in
> >> dest-buf overflow.
> >>
> >> So,this patch add some values check to avoid this issue.
> >>
> >> Signed-off-by: Hao Chen <chenhao418@huawei.com>
> >> Reported-by: kernel test robot <lkp@intel.com>
> >> Closes: https://lore.kernel.org/lkml/202207170606.7WtHs9yS-lkp@intel.com/T/
> >> Signed-off-by: Hao Lan <lanhao@huawei.com>
> >> ---
> >>  .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 31 ++++++++++++++-----
> >>  .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 29 ++++++++++++++---
> >>  2 files changed, 48 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> >> index 4c3e90a1c4d0..cf415cb37685 100644
> >> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> >> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> >> @@ -438,19 +438,36 @@ static void hns3_dbg_fill_content(char *content, u16 len,
> >>  				  const struct hns3_dbg_item *items,
> >>  				  const char **result, u16 size)
> >>  {
> >> +#define HNS3_DBG_LINE_END_LEN	2
> >>  	char *pos = content;
> >> +	u16 item_len;
> >>  	u16 i;
> >>  
> >> +	if (!len) {
> >> +		return;
> >> +	} else if (len <= HNS3_DBG_LINE_END_LEN) {
> >> +		*pos++ = '\0';
> >> +		return;
> >> +	}
> >> +
> >>  	memset(content, ' ', len);
> >> -	for (i = 0; i < size; i++) {
> >> -		if (result)
> >> -			strncpy(pos, result[i], strlen(result[i]));
> >> -		else
> >> -			strncpy(pos, items[i].name, strlen(items[i].name));
> >> +	len -= HNS3_DBG_LINE_END_LEN;
> >>  
> >> -		pos += strlen(items[i].name) + items[i].interval;
> >> +	for (i = 0; i < size; i++) {
> >> +		item_len = strlen(items[i].name) + items[i].interval;
> >> +		if (len < item_len)
> >> +			break;
> >> +
> >> +		if (result) {
> >> +			if (item_len < strlen(result[i]))
> >> +				break;
> >> +			memcpy(pos, result[i], strlen(result[i]));
> >> +		} else {
> >> +			memcpy(pos, items[i].name, strlen(items[i].name));
> > 
> > Hi,
> > 
> > The above memcpy() calls share the same property as the warning that
> > is being addressed: the length copied depends on the source not the
> > destination.
> > 
> > With the reworked code this seems safe. Which is good. But I wonder if,
> > given all the checking done, it makes sense to simply call strcpy() here.
> > Using strlen() as a length argument seems odd to me.
> > 
> Hi,
> Thanks for your review.
> 1. We think the memcpy is correct, our length copied depends on the source,
> or do I not understand you?
> void *memcpy(void *dest, const void *src, size_t count)
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/lib/string.c#n619
> 
> 2. We don't know any other way to replace strlen. Do you have a better way for us?

My point is that strcpy() could be used here.
Because the source is a string, and the length of the copy
is the length of the source (string).

f.e., aren't the following functionally equivalent?

	memcpy(pos, result[i], strlen(result[i]));

	strcpy(pos, result[i])

In my view using strcpy here seems a bit simpler and therefore nicer.
But if you don't think so, that is fine.

...

