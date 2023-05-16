Return-Path: <netdev+bounces-3092-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5520A7056B9
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:06:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B7392812DF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBF8929101;
	Tue, 16 May 2023 19:06:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59E0290FC
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:06:36 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2135.outbound.protection.outlook.com [40.107.93.135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB64F1717
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:06:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xbxef01nSlOKExL5hKYsm55+2P48q/TkXKSpwn+OCeecXyYi8tZchZ9vLKXx/4flMK2pbk8qbDJq5nmrFK+CUvV5i8ma8QbdM+rT/hb2ha/s4VBMa8RU5vMiNEPqfvbs+CpaQ4bBgKcr5ObXbqxooL+V5B7NqPyAO5QxWdAfJvgRFae80eqiUJpXoC8jm8Q8yilUmbjUoGwWlXP5/VdZn+BVbtPAta6a2BsUqdRMiZj2UgZlC0EYGgT15XE6d0/CxzPkb34YD5q6BSNXIvm+/AucFewRfGnsgBbPu0e45xvU7KjSA+mHsrg3eDV2kJ9sJbdsfQnWON9rWgwjCV01gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LLBarGcYUNt3DxGUXWGL5v8P8pfRsJNoWlDmZZIz7CE=;
 b=UcldQ6wPtm1hOxSAZ5+zaz2WcGDifPKLBXSWtK83CF92iLGERPvGBVGFvS01Wli/Uj2pgYmoyufeENJMc7B2W3owGUWMZhjz7hTCvY1wMfUAesgrwNdS42FCfx+Htiou91NVtqI5pf8UKPaI71oOUI0T9RZyM8BGw1l2cFGEQJD1scOZNK6TFq8StOOnl8jZHw7BoZU0JBBxRl0fJS2PcSPoes8+l0pi9mC/r0qlUZ7adXkyTyEzZMGlj+bK+BZR7M1Lb6BpWUyPQTiS/DXBzPpINKq5pRunNnIVhI7vuQM7cKJ+A3s6xuxLQ5rx44Xj+KnZPnXkB4Pm96fYUH10sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LLBarGcYUNt3DxGUXWGL5v8P8pfRsJNoWlDmZZIz7CE=;
 b=mOGLWjlWfIKct2ZcytiIsLTrtBqdH9aSQCY/+7VtRpkqMXJcenTqzGClba4JvEHfNQAGxWuaPmow61Ke055N9JUbYxyHnsrI2xL+920Lr0OH3oHCVRUPJJ2PluronZbEHdjjPK3fsB+/oZ3ttjkCubCcMD+vOiIXpNj7uLIKgKs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5968.namprd13.prod.outlook.com (2603:10b6:a03:418::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 19:06:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 19:06:30 +0000
Date: Tue, 16 May 2023 21:05:46 +0200
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
Message-ID: <ZGPUCiX06Y7/p6pZ@corigine.com>
References: <20230515134643.48314-1-lanhao@huawei.com>
 <20230515134643.48314-4-lanhao@huawei.com>
 <ZGKOdijGtX03qV2p@corigine.com>
 <55ca40e4-eae1-c037-7038-46160a76d5e8@huawei.com>
 <ZGOPGhF6w08CHr8j@corigine.com>
 <199c9494-e26c-f665-744f-6475ba7dae3a@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <199c9494-e26c-f665-744f-6475ba7dae3a@huawei.com>
X-ClientProxiedBy: AS4P190CA0001.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5968:EE_
X-MS-Office365-Filtering-Correlation-Id: 45a01fb0-131d-46b9-2d0b-08db5640a84c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	daENE2UXuqHbW4KdQnUCdDqN/WkoH+loDykY/HzLBKqj5GJzLoW1UxhTRMagkIN3yxDL94Uafz0NX9ys73/9EFO30nPKAA5uj4QK+YbQiZUxxc58tFhsmUC8XbwjM0GI73jnw84nXU8+XTGvFQ0PIFtcBXFB7+Rxppmf3Rw4JNMUo0J1P4yXhiZIgjyiX/sfwb38EV6YGWaGCUIJSk21ip+m7s4Bk2dXul6SDeGbV3o4BpIQRu+9YAS2XCj/0rvRqZ82QkCMs8wMkJrZScPQ+aYIZ+7vdrrnJEpaHycXmQ80/T2qOCrs1auyyyKnqbpdS4a0LIlMJazrV1ws5sCiydQiK9PrL89g5OCtHKNnTLKWjFHRkE8lUG2/DvMayAQBTPJjoqey5B9xdxsdplXAsECTqPLoUO1mSoHYEkYIuc1Q8GMnUaFjq6gTYDO/v/uTbqXyVAxY7QixNVFQkhQqFg8VJ87YUYvk0jRvbUPhFlqi8T5gUepqQP5HzLQARMqBEu+RXS57dCNG1DIZMcFcnSorCs7Ii1UVCVyOiGUVKs0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(39840400004)(376002)(346002)(396003)(451199021)(478600001)(186003)(6512007)(6506007)(53546011)(86362001)(6666004)(83380400001)(6916009)(66476007)(4326008)(66556008)(66946007)(6486002)(2616005)(966005)(5660300002)(316002)(7416002)(8676002)(8936002)(2906002)(44832011)(38100700002)(41300700001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zxa9C+wh9vM2filMT7B1kdbWo/isRLCQ6GDhiJ8no8c6oTFeroLp1scXdfpU?=
 =?us-ascii?Q?xhaHmdOqMiT3dpR28kQJSP0Dz/9SO81E5Dw8HhfHc2Tsdhl5RUDeObRkHVR4?=
 =?us-ascii?Q?kPPKpG+Hy71AxTVFyoMSUC1+qMIz/kbAZ8RezT6ef2Ll2yyavNzyebL5ovek?=
 =?us-ascii?Q?uOTQTUWTAWPN9/hbztztlGCsY8gFqrP+BUGgr+9xWOVnGJpXsUUFovUVewJu?=
 =?us-ascii?Q?hJII7HjIa8tOJioJ8YS86A9/Cm+g0wskWVoIjU0PwVsiQUk49Zaz7Qa91aH0?=
 =?us-ascii?Q?Vy4Fid5j1fFmcjWty6npIvykryLlBQ5/azOl070XRVkD0UP5DeOEL49RJJqz?=
 =?us-ascii?Q?HZ27L2VhKBKKKynwsJIKCjDPlWm3udX2rVVLR4/qnJr/mqEmWYJiYCjRL1jh?=
 =?us-ascii?Q?MjLIeO1ueytTWbwP2EyV9Dco381Xt2M+pxOGncPrP7js7Ki7bnFhNpQKGPOh?=
 =?us-ascii?Q?NOAbNC2KUQiED2E/rcTL/ommGsc7gtcR9HdmHlnU81VYXr9FmTimHeT50CwL?=
 =?us-ascii?Q?SthwhzowBTMjqVUM7+5L2ImsCxK7PwFDcDFxZWCAIZa3+3etJMbFXrad2qw2?=
 =?us-ascii?Q?QqGWlIQA61us/QfW1Zo2iZsqoB7k0fKzy7nsyRrrXRP63vPn/ZKhKNQT3H5q?=
 =?us-ascii?Q?U7+MBHT3cD96/Lcpr0Xg8XdTr+11Ojm0Kq3MphzBvpK76it/IwppbnfsCiCN?=
 =?us-ascii?Q?hn0j9D97jRgUwlVVhYBG0bYJpdPCtfC+BXMSBwJobWnq/CJ+IX6eoZLTp+GU?=
 =?us-ascii?Q?WRIB2YQJiq08P8YsZW8fiYvtLuX6g2ZJm1qlV6w/7ujZDXGAU58lgkj3IxtN?=
 =?us-ascii?Q?6P0kHFNSDMo+gAd6G6N+Qpo3N0WCGUN88pGNaoguNxQ8uiQXBCp1RH9lsDc+?=
 =?us-ascii?Q?5vx1qU6sn4bDzensJtEQ52+BFQ/oXgWNE9Uyt86Hipcoaq/vCmoOf9ckXGGy?=
 =?us-ascii?Q?oiXDS9Ue9gKyQcT+yNKXwXQ/vqQByGqBIqUHsbtAFpVbys+fG2sW1+DVC9R6?=
 =?us-ascii?Q?AD5fEZowgwl1PHPVeTv66v4kcTYr31mRkBKHiS78VIoSFEknK5cqFRDBy8IX?=
 =?us-ascii?Q?UfDHGju4SDdYOfwuJhC5//vP0Vipoi+l9IRhxleeH/lxxOnslXffQgjAlnEB?=
 =?us-ascii?Q?mBH8L9ziDQh3HH+evKhx+Zk1sRoMCHyzm10BYNpurkgXPxlCeJCGskwoVxz3?=
 =?us-ascii?Q?nIXKUzjwKfL2XByUmMsRZp9FD5PUy7w8BvX8W90dcKSoFsFNUSdRTiauOhwP?=
 =?us-ascii?Q?zaIhJ813/7yUKlDf+d2DuOWFjOGxLQE4Rxd/5ljzmZQnJj34EqU/FhiUt4aU?=
 =?us-ascii?Q?RCPjiYcUtbjACesezG81DW211MC/bg2im0vTgvzSqnMQAlAp66HDlFJ/bMgk?=
 =?us-ascii?Q?F4ttNv98mRVf6vz9basaCq2rYQt5Mfqai9iliD7aLq6U9bq2+coJcJ2qBzRn?=
 =?us-ascii?Q?ZByVEVWmDSLRm+jmlonosQB/5JZoYr002+6fO9UUaSrxfZnfO5a/l2OMlQoZ?=
 =?us-ascii?Q?Uv6NAps1YieEEMT7Jc2kocVr6b5h607JB2oyT11GW/HI0Yyn8q1tVMw/2MzN?=
 =?us-ascii?Q?hctgyNVV85mqDhDjfHe0gp4M9eai51AEYLvHJtyKI9B35XtWmReC4RPLhhaZ?=
 =?us-ascii?Q?/rp+yPtYToafThqpTbArMUybRFTqBPrFJQf/byV+sOxR/seP1dUE3spS62kZ?=
 =?us-ascii?Q?/ROa+w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45a01fb0-131d-46b9-2d0b-08db5640a84c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 19:06:30.7188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mkWy7zkKX2QcEDbVvz3tZtRTSMvp7eCA/doiWKTNdpToBV0lQQkuULex5zjFoocddzww/8833S5gaJ2Om6BSynRSpEHPiuK4wzSE+kg3dI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5968
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 11:35:55PM +0800, Hao Lan wrote:
> 
> 
> On 2023/5/16 22:11, Simon Horman wrote:
> > On Tue, May 16, 2023 at 09:09:45PM +0800, Hao Lan wrote:
> >>
> >>
> >> On 2023/5/16 3:57, Simon Horman wrote:
> >>> On Mon, May 15, 2023 at 09:46:42PM +0800, Hao Lan wrote:
> >>>> From: Hao Chen <chenhao418@huawei.com>
> >>>>
> >>>> Now, strncpy() in hns3_dbg_fill_content() use src-length as copy-length,
> >>>> it may result in dest-buf overflow.
> >>>>
> >>>> This patch is to fix intel compile warning for csky-linux-gcc (GCC) 12.1.0
> >>>> compiler.
> >>>>
> >>>> The warning reports as below:
> >>>>
> >>>> hclge_debugfs.c:92:25: warning: 'strncpy' specified bound depends on
> >>>> the length of the source argument [-Wstringop-truncation]
> >>>>
> >>>> strncpy(pos, items[i].name, strlen(items[i].name));
> >>>>
> >>>> hclge_debugfs.c:90:25: warning: 'strncpy' output truncated before
> >>>> terminating nul copying as many bytes from a string as its length
> >>>> [-Wstringop-truncation]
> >>>>
> >>>> strncpy(pos, result[i], strlen(result[i]));
> >>>>
> >>>> strncpy() use src-length as copy-length, it may result in
> >>>> dest-buf overflow.
> >>>>
> >>>> So,this patch add some values check to avoid this issue.
> >>>>
> >>>> Signed-off-by: Hao Chen <chenhao418@huawei.com>
> >>>> Reported-by: kernel test robot <lkp@intel.com>
> >>>> Closes: https://lore.kernel.org/lkml/202207170606.7WtHs9yS-lkp@intel.com/T/
> >>>> Signed-off-by: Hao Lan <lanhao@huawei.com>
> >>>> ---
> >>>>  .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 31 ++++++++++++++-----
> >>>>  .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 29 ++++++++++++++---
> >>>>  2 files changed, 48 insertions(+), 12 deletions(-)
> >>>>
> >>>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> >>>> index 4c3e90a1c4d0..cf415cb37685 100644
> >>>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> >>>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> >>>> @@ -438,19 +438,36 @@ static void hns3_dbg_fill_content(char *content, u16 len,
> >>>>  				  const struct hns3_dbg_item *items,
> >>>>  				  const char **result, u16 size)
> >>>>  {
> >>>> +#define HNS3_DBG_LINE_END_LEN	2
> >>>>  	char *pos = content;
> >>>> +	u16 item_len;
> >>>>  	u16 i;
> >>>>  
> >>>> +	if (!len) {
> >>>> +		return;
> >>>> +	} else if (len <= HNS3_DBG_LINE_END_LEN) {
> >>>> +		*pos++ = '\0';
> >>>> +		return;
> >>>> +	}
> >>>> +
> >>>>  	memset(content, ' ', len);
> >>>> -	for (i = 0; i < size; i++) {
> >>>> -		if (result)
> >>>> -			strncpy(pos, result[i], strlen(result[i]));
> >>>> -		else
> >>>> -			strncpy(pos, items[i].name, strlen(items[i].name));
> >>>> +	len -= HNS3_DBG_LINE_END_LEN;
> >>>>  
> >>>> -		pos += strlen(items[i].name) + items[i].interval;
> >>>> +	for (i = 0; i < size; i++) {
> >>>> +		item_len = strlen(items[i].name) + items[i].interval;
> >>>> +		if (len < item_len)
> >>>> +			break;
> >>>> +
> >>>> +		if (result) {
> >>>> +			if (item_len < strlen(result[i]))
> >>>> +				break;
> >>>> +			memcpy(pos, result[i], strlen(result[i]));
> >>>> +		} else {
> >>>> +			memcpy(pos, items[i].name, strlen(items[i].name));
> >>>
> >>> Hi,
> >>>
> >>> The above memcpy() calls share the same property as the warning that
> >>> is being addressed: the length copied depends on the source not the
> >>> destination.
> >>>
> >>> With the reworked code this seems safe. Which is good. But I wonder if,
> >>> given all the checking done, it makes sense to simply call strcpy() here.
> >>> Using strlen() as a length argument seems odd to me.
> >>>
> >> Hi,
> >> Thanks for your review.
> >> 1. We think the memcpy is correct, our length copied depends on the source,
> >> or do I not understand you?
> >> void *memcpy(void *dest, const void *src, size_t count)
> >> Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/lib/string.c#n619
> >>
> >> 2. We don't know any other way to replace strlen. Do you have a better way for us?
> > 
> > My point is that strcpy() could be used here.
> > Because the source is a string, and the length of the copy
> > is the length of the source (string).
> > 
> > f.e., aren't the following functionally equivalent?
> > 
> > 	memcpy(pos, result[i], strlen(result[i]));
> > 
> > 	strcpy(pos, result[i])
> > 
> > In my view using strcpy here seems a bit simpler and therefore nicer.
> > But if you don't think so, that is fine.
> > 
> Hi,
> Thanks for your review.
> Here is a warning report about using strcpy. This patch is used to fix the warning.
> Link: https://lore.kernel.org/lkml/202207170606.7WtHs9yS-lkp@intel.com/T/

Thanks.

Just to clarify, I was suggesting strcpy() rather than strncpy().
But I didn't try my suggestion.

In any case, all these ideas, including memcpy() have the underlying
issue that is being flagged below: that the length of the copy is based on
the source not the destination.

As I said earlier, I agree that your changes make this safe,
regardless of what function is used to actually copy the data.
And my suggestion is cosmetic rather than functional.

> All warnings (new ones prefixed by >>):
> 
>    In function 'hclge_dbg_fill_content',
>        inlined from 'hclge_dbg_dump_vlan_filter_config.constprop' at drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:2080:2:
>    drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:92:25: warning: 'strncpy' specified bound depends on the length of the source argument [-Wstringop-truncation]
>       92 |                         strncpy(pos, items[i].name, strlen(items[i].name));
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    In function 'hclge_dbg_fill_content',
>        inlined from 'hclge_dbg_dump_vlan_filter_config.constprop' at drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:2102:3:
> >> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:90:25: warning: 'strncpy' output truncated before terminating nul copying as many bytes from a string as its length [-Wstringop-truncation]
>       90 |                         strncpy(pos, result[i], strlen(result[i]));
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    In function 'hclge_dbg_fill_content',
>        inlined from 'hclge_dbg_dump_mac_list' at drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:1872:2:
>    drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:92:25: warning: 'strncpy' specified bound depends on the length of the source argument [-Wstringop-truncation]
>       92 |                         strncpy(pos, items[i].name, strlen(items[i].name));
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    In function 'hclge_dbg_fill_content',
>        inlined from 'hclge_dbg_dump_mac_list' at drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:1887:4:
>    drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:90:25: warning: 'strncpy' specified bound depends on the length of the source argument [-Wstringop-truncation]
>       90 |                         strncpy(pos, result[i], strlen(result[i]));
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    In function 'hclge_dbg_fill_content',
>        inlined from 'hclge_dbg_dump_tm_pg' at drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:735:2:
>    drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:92:25: warning: 'strncpy' specified bound depends on the length of the source argument [-Wstringop-truncation]
>       92 |                         strncpy(pos, items[i].name, strlen(items[i].name));
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    In function 'hclge_dbg_fill_content',
>        inlined from 'hclge_dbg_dump_tm_pg' at drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:775:3:
>    drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:90:25: warning: 'strncpy' specified bound depends on the length of the source argument [-Wstringop-truncation]
>       90 |                         strncpy(pos, result[i], strlen(result[i]));
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    In function 'hclge_dbg_fill_content',
>        inlined from 'hclge_dbg_dump_tm_qset' at drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:1027:2:
>    drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:92:25: warning: 'strncpy' specified bound depends on the length of the source argument [-Wstringop-truncation]
>       92 |                         strncpy(pos, items[i].name, strlen(items[i].name));
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    In function 'hclge_dbg_fill_content',
>        inlined from 'hclge_dbg_dump_tm_qset' at drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:1059:3:
>    drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:90:25: warning: 'strncpy' specified bound depends on the length of the source argument [-Wstringop-truncation]
>       90 |                         strncpy(pos, result[i], strlen(result[i]));
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    In function 'hclge_dbg_fill_content',
>        inlined from 'hclge_dbg_dump_vlan_offload_config' at drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:2123:2:
>    drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:92:25: warning: 'strncpy' specified bound depends on the length of the source argument [-Wstringop-truncation]
>       92 |                         strncpy(pos, items[i].name, strlen(items[i].name));
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    In function 'hclge_dbg_fill_content',
>        inlined from 'hclge_dbg_dump_vlan_offload_config' at drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:2154:3:
> >> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:90:25: warning: 'strncpy' output truncated before terminating nul copying as many bytes from a string as its length [-Wstringop-truncation]
>       90 |                         strncpy(pos, result[i], strlen(result[i]));
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> > ...
> > .
> > 

