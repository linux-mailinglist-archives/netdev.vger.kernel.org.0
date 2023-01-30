Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94FF3680B9A
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 12:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbjA3LGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 06:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235871AbjA3LFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 06:05:30 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2043.outbound.protection.outlook.com [40.107.212.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6939BEB6A;
        Mon, 30 Jan 2023 03:05:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdZmjOzkj8tjOVv5P0O/g2ClEdwUMVOKejw+hMcmrCpPv9azeIN0UJVTBxZJ9Vm6ziTM4w2nK1YjS2v6dayW5+//3g9Hv9tJIMWXLqcAEWBnPj/jWnhIApDK2fyU5OKSVVcP1BV1q+ocY3Q6wdoV2uUV96qSqFZHnUQGbNWpMhmoP3yHS0EkX3dUHe7xby+i4cg42F6emvNvnHOHNPqZgXbKoM8go9rJ0Ax/r9C/LmFjuLgcs+fZR0mhEdVcYQMsGBxBuuc7VfzTJVgH1cbdXkMPZ/LKKxOwGTfaHjogP0aX/TO+HCns47YNjrzj+qYi3UakwmLlkOhAm6Etq3p8Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5TRGfffdbGVdU2djJATSOGzv2lyx21BjqOZ+X8sH9MY=;
 b=SY1Ri6pM41Q4q66dbyZX+j75v6ENarG19PbeOCphq3UAyAH9t4qEGIGGYsOYB5kZIlF3g2FNrF+fptricO27j7p2GJ7kzbANrlRJzvngxQ/d9/KflfcLa680hTm+Gng97brlxhE7OBGvSZL49JWQT2I7sPPtFaxNhtFttzW2zZVsFbR8VpJW6pRJg5zXmkb4ZpmY9+hanxMBTXfTaeiQdTTRfdyAL4miDnNZr4L8wlIONeIhVoPfs0+OZ+vhLxvYL1sAVpla00tPB5Ik8kemPQ4zP044d9m5o9F6c8oWuP29Ap/w1Q1uHmK8G7A//KTqmj0t2SUCBeai2KyEHgnJjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TRGfffdbGVdU2djJATSOGzv2lyx21BjqOZ+X8sH9MY=;
 b=q9K4tykCpZpBAk6geGUC6YYaqIsuUWaefaTiHraoBxsVFytmHwhNCkirgBBdY/I5d6Yphxn/bGiOTVD00sm4OJ4EfaZwRmJwsEBjIATkuBByieQC0aAeLDXomtWQCIuyjWDR/EDgoCOC6g7FoTdiJrpxhqCLByRRQWCO6vloEJz/qEBDsXW32dVLujpWzbpTbbyl/g1LTHDECc811oVlQJUJxRmv+i01mdOg8i465dBUIk4yKhfLQ/WyS9IiBLC0JbkmfqJcQgWyuI1CbMqtQOQqGxOZxAGGAxKUTUML+aYyet6kJ5t3+qxtMtHXSlYlfAOM3w91nSZVeR4XzF5Jcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by MN2PR12MB4190.namprd12.prod.outlook.com (2603:10b6:208:1dd::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 11:05:11 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e%4]) with mapi id 15.20.6043.023; Mon, 30 Jan 2023
 11:05:11 +0000
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <97a17a6ab7e59be4287a2a94d43bb787300476b4.1674538665.git-series.apopple@nvidia.com>
 <20230124005356-mutt-send-email-mst@kernel.org>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 02/19] drivers/vhost: Convert to use vm_account
Date:   Mon, 30 Jan 2023 21:43:52 +1100
In-reply-to: <20230124005356-mutt-send-email-mst@kernel.org>
Message-ID: <87357s1dwf.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SYCPR01CA0011.ausprd01.prod.outlook.com
 (2603:10c6:10:31::23) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|MN2PR12MB4190:EE_
X-MS-Office365-Filtering-Correlation-Id: 56f8c58b-9ba0-48b9-d28c-08db02b1daf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FngUeYFP3xw4ZpQUSKE0OKpZXunCcH/uUNj/0H7A9rrIufT4B0WxNhlk4uA4GunRjozZ3IKdY96GlZTQXSSJu1nHHktU+PPTkrUutarebdDqHnFm7ch405nT/02F+pmF9peW0LtgI19qNaXexUq/ndPkQ4tMB64WMjNcV3WIvpBaWMzQ2BtM1/I1moHyGyPZzjlADpsEm7eY11WnguF75jyC5F9dTaAOLt0JCrYw/ZSjqt305/z6B3GyN/13vsGHlaGNAUx44pkHBl33cYpzUIwFPKPhEw6Xw/3AKRspHfLKnqZ7RazECAiziEdQFRyCUM0IfD533bgNtBQrFbWxB3wXU3EPgAzrZhAbk6kyhzwYsToYNTQeDoJx2ueuTWs4/WoXlxLZP4AV6mmFzb9NHAOuQ/GyyFjIPvBI9R/bJ8EylVZ+1MLXvE4021FjajP4GcOxmohlK2w7DXKKXkYH1kAFX+BLEWaFX9/CvlFZB5o3cldAT8ucwNzoxxafCcAR2cYDcz8nF4jS44mSyrW7e8yAeUsgm+MgW0Xu3DiNEXGte7NndhOY3u/IERIsEuK9JDA2Ta5Pq/VteuKy0mQO5G97R7tqj2tBa+8PjjOVTaEGYsnufOxksvfczYIa2UdIJ5QL1qW3lAWsiCIyS64t6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199018)(36756003)(316002)(66946007)(8676002)(4326008)(6916009)(66556008)(66476007)(8936002)(41300700001)(5660300002)(38100700002)(86362001)(6666004)(186003)(6512007)(6506007)(26005)(7416002)(2906002)(478600001)(6486002)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z+YvkO6rZK2vr22NEeO/vIonYAw+E+BjZzTnL2FadDL3SrIaGf3QjoHpBwWc?=
 =?us-ascii?Q?FVBSrK+Ow50oBQUEeeG/OCbaVFa8zlowfYjKtTh1HjY7CiXzfCKg/9rvGbpZ?=
 =?us-ascii?Q?BFur31WgHt4gH50Y/1w/Ns/hB3VNst7m5X/VkfmsJhHAk/EtaRBfA8LqJsU1?=
 =?us-ascii?Q?AqHCg8bGXhXFvalcO2MD7a8CHD66juFXWXmumnRTpxRlJJQWG9nmJx62qWEO?=
 =?us-ascii?Q?PhQWxE8FATe8W3+mT5CRgFC8ML+J2g++xY+1mD/YKTWrWwLOfHB0vv7hwnW0?=
 =?us-ascii?Q?p5sw4afCl4rrOAO/7GG9JrPFQ2mD0cP2cnK680J1QXC2J+R8EXc+LhcTbVUs?=
 =?us-ascii?Q?DXty4c9O41fwb6CmiSiIJJ5CyAl06W2967mS0kysFewBGQr8M1+gs6IBT331?=
 =?us-ascii?Q?iDapJRXUju09acYVEJzya/dpTg2qTGtCaUs594c8nPNpdT+E7lDqyL3H3ehJ?=
 =?us-ascii?Q?Baj1TYR6va2odluXZGnyV5RXY5twZwxmvHC7X+7CoOSO5v6tlrZ9h1NA8aqm?=
 =?us-ascii?Q?Mz553ODglwlnYXoPPTWU3wwqYp88ItejjTgGXHA37vjuDTt1NAz9UzkVHi2Y?=
 =?us-ascii?Q?xFxh4jJQrus+H91syAQRO3yYUAyx2+kziX7RWTXe7+BvloL/FsRJ/qPas0Az?=
 =?us-ascii?Q?aYvZceN+fh6cV8V1HCdR+KO0OORkDWIJTAQ8K1crPqCQKwyG6x3YC6YmzZ49?=
 =?us-ascii?Q?2RNM6NpL6uZa/quPYM3oUXSaZ0EuDK6PTEq+Kp2rdhNAh4pb0sN6cDJ1ugx5?=
 =?us-ascii?Q?lG7HcFlK0UiSLP3v4npKZ+20WkmtMgDWo+huiPpAYnCzvr5zm3Vu6jH1mmfl?=
 =?us-ascii?Q?MNx2I226Co8HOyYY0g8Y98HGLNkiweCGyMAElZD3yTp925Z2RkgOJcsupOIq?=
 =?us-ascii?Q?LKOUcruB8X5vhLxQ3/zOqUu4Kfk5uwc3m/nePHeF3FuLf6esp19ZrqAi5Vo7?=
 =?us-ascii?Q?Iowovolqo3Nw8SfNm8HfNrZOpqUnDEh4lcOZQwqNL/2zuH99HIAq1pigapHk?=
 =?us-ascii?Q?bxHobzwsKT1WJPgVt/YV6M2B6oBT5mxu/5fMkHLdcKc32DO4aVXhF9Xxvmia?=
 =?us-ascii?Q?7GOTi+4jz2ZeBmld36kUnZq7X3tgtv6+NZNgeeKDMoOjfOaBiZUDjenCSrkJ?=
 =?us-ascii?Q?veaSLdNRjatvFmpHDUlUgG8PRHwXZYw0ctJXbjMAANB6tLIAl+cnbRhXQf1p?=
 =?us-ascii?Q?beCDT+NnxU4SDAmi8okSX8fmhWkBFXpFrErQbtCgkjbc9Gh2xsoS4gFth6Jh?=
 =?us-ascii?Q?xpBPrJpB3NyUYsdNdmf9+y/Sp8enRh/Xx/ECLNOw0D+GeACvNT7SXIrdgz4w?=
 =?us-ascii?Q?g6wo+N2GhuAvz9n34r84aGN+CWtB4SCN3q1FJK4nLyF+rTTH7DZp5wR/Tr6Z?=
 =?us-ascii?Q?sXDkxeTg1yvTgvTBQ0dqHq6QVWhRBJtliM2wqov7MsEtDbPXNh26yHIUjBXj?=
 =?us-ascii?Q?fSqTrAPC5upC+Ude1vv0lXkRAI7Gh2BCWHLNVzQDi2u4+mC7b38/fbQxLQZs?=
 =?us-ascii?Q?y1IDe1vi+3uW5HmkihOcdwvM2epq+9VIS5na3spNmYmHyR+fu0XngnVwavxf?=
 =?us-ascii?Q?sbfxcn3BUNkFNoIjIeZVk+Qceeb8esFggAQCi4Fc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56f8c58b-9ba0-48b9-d28c-08db02b1daf5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 11:05:11.1254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6iyN4IoH0UR5hFt6hZBWgK1597mkw9/cSzxgtXu/W02IMXR0/ZRYwr4h0jYkOAGdp5mzSPEe6pooRtDRR9eQ9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4190
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Tue, Jan 24, 2023 at 04:42:31PM +1100, Alistair Popple wrote:
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index ec32f78..a31dd53 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>
> ...
>
>> @@ -780,6 +780,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>>  	u32 asid = iotlb_to_asid(iotlb);
>>  	int r = 0;
>>  
>> +	if (!vdpa->use_va)
>> +		if (vm_account_pinned(&dev->vm_account, PFN_DOWN(size)))
>> +			return -ENOMEM;
>> +
>>  	r = vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1,
>>  				      pa, perm, opaque);
>>  	if (r)
>
> I suspect some error handling will have to be reworked then, no?

Thanks. I had meant to go back and double check some of these driver
conversions. Will add something like below:

@@ -787,7 +787,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	r = vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1,
 				      pa, perm, opaque);
 	if (r)
-		return r;
+		goto out_unaccount;
 
 	if (ops->dma_map) {
 		r = ops->dma_map(vdpa, asid, iova, size, pa, perm, opaque);
@@ -798,12 +798,14 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 		r = iommu_map(v->domain, iova, pa, size,
 			      perm_to_iommu_flags(perm));
 	}
-	if (r) {
+	if (r)
 		vhost_iotlb_del_range(iotlb, iova, iova + size - 1);
-		return r;
-	}
 
-	return 0;
+out_unaccount:
+	if (!vdpa->use_va)
+		vm_unaccount_pinned(&dev->vm_account, PFN_DOWN(size));
+
+	return r;
 }
 
 static void vhost_vdpa_unmap(struct vhost_vdpa *v,

>> -- 
>> git-series 0.9.1

