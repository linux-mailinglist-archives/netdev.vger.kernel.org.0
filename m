Return-Path: <netdev+bounces-6355-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66ECD715E40
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:00:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A531E1C20C1A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:00:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E514D182B8;
	Tue, 30 May 2023 12:00:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EE317AC6
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:00:09 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2098.outbound.protection.outlook.com [40.107.92.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A01F3;
	Tue, 30 May 2023 04:59:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MyLp//T/ihHwxBJcAr+CitwneoSBOjxPhzwQBUOuYaVkFlDkBCV6ecKXzCpHunOHmKBRMZ4xaW+t5VCX5ErNxRaK3BTuOOW3jJ+Mt6hkKH2qsRwCNV8izxCUh8EENLhi5fNcDUxx2hctiPEsy0UJc5dnPrUwrkbcEQPsNPMzqz6kbGC6haK+0ZmP9A093fS07dTWMPvp6Ij87jvc6K8p83SbMWA3GYo55vSMkHnC5yQ/xXTg7+M/E+VHtufcSv5dtNp8pY+N+GxZcUTi5u5p0HfO4BIu2lndDAsA2GsGv1ogbFx+n/vvlB+hcb3nKIwZJdKcvURTG3/LpMTffzBkIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JRs1pY0AWC9GkXfojTlUJBVE/6M0Gl0ZOzh3mssJh4U=;
 b=aYC+kMQgz5BIIcptYVwurQMRiWyG8x0ItaojOzdfl8SKmqswKhXfYfpOPdDjJobOEZxCSTgZ5+/qnJh58JATJ8gwLg5KaN6MZmTcP53p4U1weA1Loe4nPH21zaI5t4dQWKm5W5/14t2Gh3wIhcDTargJmtEZWOeU5fUrowKQ4prXTZxuH4GQioKw8NPXm3OI32eSdopBKUS+XpHe6VfJF71xGQDiQrh8vpSM1G3tCyPmweQ/r/ffTKfSFS+wVym1rmQI0/JhF4Emn7EVcoChM6H06vu2Wy9sl/zk5hP6VxfrL4xXZz1Ap6JRAHV4Aq9SzGub/SNAKQ2XWV1x0Dky4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRs1pY0AWC9GkXfojTlUJBVE/6M0Gl0ZOzh3mssJh4U=;
 b=XRgZDQIYLA9VO7NN+Lp+9swHyjkEQGuWjpO6YlDFTco43A3dqe+MrX4h3TDC/1WhVKn0G56XGgVtL5DwjqzMm070jz6jZW3z/e0Mo5tUKiwsIBFaw5RXqCyGgFEelYqbuxVPGUQvwFBNFs/eSDSxbWDLqWfpRog6VT6JCRsP/x0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3820.namprd13.prod.outlook.com (2603:10b6:5:245::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 11:59:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 11:59:27 +0000
Date: Tue, 30 May 2023 13:59:20 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Richard Gobert <richardbgobert@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, lixiaoyan@google.com, alexanderduyck@fb.com,
	linyunsheng@huawei.com, lucien.xin@gmail.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] gro: decrease size of CB
Message-ID: <ZHXlGH2YqVnO6KYq@corigine.com>
References: <20230529160503.GA3884@debian>
 <20230529161240.GA3958@debian>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529161240.GA3958@debian>
X-ClientProxiedBy: AM0PR01CA0082.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3820:EE_
X-MS-Office365-Filtering-Correlation-Id: 319fbc3c-d980-4e9f-ae3b-08db6105517e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	A9QGACjASvGaSi4WwxsKhnNmCDIhhpS+rHpTkThjEfq9Ia3APjLobFVXWnQPB5q5ZDJSd8hgXQbVxFzJYcAQSUVnBV6SAeKOaIWLr1CdSS930Gr00uXGwy21nOYTDlJnJEI+EnDrkEpOOizxUmmstHbJAmwVL123nDQ6v9N2FZHVe/WAHWpSUmECKZQFeJvISHiyd4t0qTdpCTHWh1YINFV2YRXczYJFH/C+geP7HoDLcC5eilFn64rSycZfCGI8v8ZOLslvcy3wHjlZGYJrZzepCJHNVpSM/cyLQVdqJxlrY1pWaWkyyRW9mskIRRsg4ucYa4R45j93OIi6663OhCWtZoe5SA1QzE8aFJAE2ExrcmFqCUbgC6YETZM4VV18nltwwxZIXwdmieN3ssLlBMf9BjviY6tZkfupao1in6O5eFLD8ZzJmHR1WnWDvZOsVKzdz6MNHncDwQXEN7umO5uV/G1PjFw+jSWP5UIMjyFSiZ884yTemYInq0J5NPrraw95AC0Q/QcL/lD40KNscQu8bOflwOMoSDAy2fJtg9v06qsTYfjkknp28tDUfyrR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39830400003)(346002)(136003)(376002)(451199021)(6512007)(6506007)(186003)(2906002)(2616005)(478600001)(44832011)(83380400001)(86362001)(8936002)(8676002)(6486002)(41300700001)(38100700002)(66946007)(66476007)(5660300002)(66556008)(36756003)(6666004)(316002)(7416002)(4326008)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?on1S3usz/EXMw1j3Mwx8WkNxk/BJjr2ZbR1PBEix7mtfmBuCqZbG4wbKCGz8?=
 =?us-ascii?Q?HYTX9p72EHgGZaEwjCVW1b0GiwtuzF0QVKKbRtSrcqKPSxaLdO74KMvxmw+M?=
 =?us-ascii?Q?WVTxd784EwdmXWp+ZoZSZ6EIqsykjuO6zq3lEffVyamTjtA+ntnQ5QAWM60P?=
 =?us-ascii?Q?uzFTR4lPguIamm7viqRyfo6+7nrE74Q4rFUKPvb8ddhgv75mDCSwi6ffRKZY?=
 =?us-ascii?Q?z7NO6UiuoJM67UxYiVfS5tcQMNzPVdjtHZM7j4o8GeiNTMnf3k95lyO4rns9?=
 =?us-ascii?Q?KPO0NjbTQR+8oAwfvVIRn2Mr+0vnEjePWOQJuKlK5dxU/oPlfOsWWQbdLzky?=
 =?us-ascii?Q?CZU2MDUWEB84DcBkWyQQWO2960iXAUpI6Rrv+rp5O9P2jDc6OisFnBlgLCJ1?=
 =?us-ascii?Q?Y7OZTr79RHaLJ5v9Cts59CHHjJmRQ0T4TDuTd08gQmVzID3MdhhUhydKE4fG?=
 =?us-ascii?Q?NAoDZh180K1MfhqbhrOWykdLONMys8oTYmfpkQaCUC8vbk0Ukj4q8a3Rz9u3?=
 =?us-ascii?Q?IcHbvcoOynaZm6BWWTAKWKnDQTvf6Ql24c+mdMx4R93fZ9oGRGi3AM/ZjX7N?=
 =?us-ascii?Q?FQirQDudXqymywMzoKQVaOQ3oucPMpOhG+x32YKML7jFsIoYclA2IqOIipAr?=
 =?us-ascii?Q?RT8dpQOVO8Y8sBNVJ6UZBYK9nkMf015xJYIzOlfTLA5GrTSyqfJjZ1tGjz0A?=
 =?us-ascii?Q?cRtNQwiaFnphyC04XsDQQF4rGei/p4JUQpd7Px4abDaw9yiPKnPJvARU4RMQ?=
 =?us-ascii?Q?FznTLBkqhD+5qPA9fShT7SfL4URUVroe7hfurAivGEO/JOo9aDNHGoTaqirS?=
 =?us-ascii?Q?0BXANIYfb20cZ5ieqhq/uaIgS3u12mVq8pfJ1BSETjtoriMGDgkUNgaTMDKm?=
 =?us-ascii?Q?W7qIs69wwPdHYcxjMPJwsVJQtjUjeMIQncxqZTJX2sWsPj8YJA5n8sepOyih?=
 =?us-ascii?Q?s5U9DaoL15J4d3utlSZ7gIvz7I/WFJ3UXHRe94+WXWj9dKaqJ5nlhMNAY2Td?=
 =?us-ascii?Q?ULguCTSDeXqD04M5I821G9h/3J4RO+HVEfskALJ0yYb0BOgvpoq+UGxNpGmf?=
 =?us-ascii?Q?dCvJ7CRQdM8NnNw5ChN5c0Yx55mMZ3hpSzaNk+5tLu4/niccTrCiVaXUC47q?=
 =?us-ascii?Q?yC/rslCHudglBTSUo/4XYvTtgrOxX8tuXrlqnHKBSBt3q5piTx+BF176FWcI?=
 =?us-ascii?Q?TjVKRORMolhxiUdFfWiJUpqQlAjoreC7rZ7Ve1NzcC43TPYDQUtjDgyAzGdv?=
 =?us-ascii?Q?oF6gB8MCScA3PL+AceZ4lNNlqNOhBuMqYSesGfRiNv5F2zLaAzNxTnU5Kw9L?=
 =?us-ascii?Q?O1oFwyyyjhuABKWpKvsvFGVO3VIzWMJWtVxZSscQaKzo6hh4j+w5ytuVyvx9?=
 =?us-ascii?Q?KI33MyvDqe7iqGbhtkm/KQuy08oFLgbcIYG8R8ANIC8WgdCrl9futc2c7Kdm?=
 =?us-ascii?Q?QIYJBOGlt/nn3eras97Vit3JZsGN6HcoVVApSWOBzjwN6Y91nceLoxyGAMuY?=
 =?us-ascii?Q?+PN1lPhLSckrXeJZ/bHlQP0VSR1nd1eaOvqSn9Ol/oGf8dDmlTbNWzjcMMQP?=
 =?us-ascii?Q?xGAtWo4tEygExA6raz0mbehJyjr2IGZUtcet0KoazOCkDVK3nMBrMQlKJ0xx?=
 =?us-ascii?Q?IsZ8trlryIEnaOp0gjl8GRc2curXpLx6Ux9AzcSmbwpSDn30zVd8J2Ulq8wf?=
 =?us-ascii?Q?PhiTdA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 319fbc3c-d980-4e9f-ae3b-08db6105517e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 11:59:27.4132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8bdMp7Id/KpjET3g2ZTNT5F+dTrqZshvKqJtDECq29/THX7Oy8NnVVftQtccdXXXai1bIacnWr3PwAI+7VB/sYNJo2RmIhW1pAhasEoPxak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3820
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 06:12:42PM +0200, Richard Gobert wrote:
> The GRO control block (NAPI_GRO_CB) is currently at its maximum size.
> This commit reduces its size by putting two groups of fields that are
> used only at different times into a union.
> 
> Specifically, the fields frag0 and frag0_len are the fields that make up
> the frag0 optimisation mechanism, which is used during the initial
> parsing of the SKB.
> 
> The fields last and age are used after the initial parsing, while the
> SKB is stored in the GRO list, waiting for other packets to arrive.
> 
> There was one location in dev_gro_receive that modified the frag0 fields
> after setting last and age. I changed this accordingly without altering
> the code behaviour.
> 
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>

...

> diff --git a/net/core/gro.c b/net/core/gro.c
> index 2d84165cb4f1..91454176a6d8 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -460,6 +460,14 @@ static void gro_pull_from_frag0(struct sk_buff *skb, int grow)
>  	}
>  }
>  
> +static inline void gro_try_pull_from_frag0(struct sk_buff *skb)

Hi Richard,

In general it is preferred not to use the inline keyword in C files,
but rather let the compiler do it's thing.

Unless you think the compiler isn't doing it's thing very well
in this case, please consider removing the inline keyword.

> +{
> +	int grow = skb_gro_offset(skb) - skb_headlen(skb);
> +
> +	if (grow > 0)
> +		gro_pull_from_frag0(skb, grow);
> +}
> +
>  static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)
>  {
>  	struct sk_buff *oldest;

...

