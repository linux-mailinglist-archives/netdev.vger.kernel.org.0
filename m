Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313014EFE4F
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 05:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240824AbiDBEAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 00:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiDBEA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 00:00:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7999F2BFC;
        Fri,  1 Apr 2022 20:58:34 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2323wAJA023183;
        Sat, 2 Apr 2022 03:58:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=8Ceu+yWRal14ySCbgsrxX3sqdYq/b4UH4QHlYw8VVqI=;
 b=ImVoO877/0aRiGrW8GHHX3KZLzhUT3JIa8LwdCEmQgTW22C79PtiguufIT7j5GCXgEmo
 +YPQ8ulo+cqadPoio5n/lrwGjCrq2WGNBdDnObVF2pzW5pfBKbKwKJhKQIJJYaZndykp
 er0j1919uI39LB4trz5EUPgfwXCjtggfDZPQltgWtuU/RE3xiGdl/YcxmLuBsVUATk+a
 i6tHNoXt68ufZon+09+I3J2PyUuoviSjUqOVa2fIGhYJeLRTO1LcbRCi83i1A8B9h0Vb
 YjFXP1iog8/yQodEmYtPtF1KcPAQA1hxcGrOSWLvZGFbnDYhUj611PHtRYWYEBTl3lXM YQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1t0005-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 03:58:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2323pZ6f039497;
        Sat, 2 Apr 2022 03:58:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx11rda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 03:58:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gW83n/qoQbnAlXoKUFIexHeZhP3EPSoVsSO64jsFEmhCcQY4ubpx7hlwA8ZNgZ0TSVbF8DJ8SbQzG41zPf8Sp8fk72RU7sOTmbKm87X6ZgASPEFZChFmvL9ZaXA2xPJ8hjEBiO3j3ngfzbIVX4U0sF8wq8B47DgwbmFcxRKnwBisoPLUW6+GW1+AyWUW2afj/xpBUz4DBR3wJsCENEXinsmJVer3EPTBKGr+7bPFUus4aWIqPHmwSN557rsLD/dfo6V1dGOi6BGG8NoLb6vaLxOJEhk7cx/in+XraGHB3CEuEvKOXhZU+7MaLfJkaTkJDO6Ps9AEbO61ht+v5DZzlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Ceu+yWRal14ySCbgsrxX3sqdYq/b4UH4QHlYw8VVqI=;
 b=MT9KbAV7V606q2f6FqEP7pLN4cOouO/+OompRcBsG6yAcGz+wZHGkzLpG23UWA4akdrOF7EATDrG7IgYRPYCh4oFhkbah/ywql3i6EqF4DKkfUQrAgWAA6iwWpZczqvifCF0PoXqGpl3D1UPHvNQw2o4yIZxsscVcBcVeD+xmBxpe8fTWWDYbUu7QMY4SVtOBuZyYZnF0lNIDwMAYV8letSYIS5NDHkUnIV6mRy4jMvFRI+xEfT87/4MaHYYfl8w2YoSjeMbRdeG5xNh3ZB21jNakIAbqq66rkvMI101fEVQLFDnE/W1rB0/SXQmLsZGg5aublQTY6CoZpDGVxbjKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ceu+yWRal14ySCbgsrxX3sqdYq/b4UH4QHlYw8VVqI=;
 b=0PgyCACeqvj0BwxJwEsHwebhnY9ERQa6ODzLlinjial01RZkxeh7EhKTzcfnnJ201vmZhyuTST5sSdIoWpNOtoECNYyLkTg0vX8prWk+VEqQ+VBIl4xOC4kNBel+8ocEhx9nb/uGGAcDedHMoAscserqd9tWL+AbaRI9I6MT6Kg=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB2890.namprd10.prod.outlook.com
 (2603:10b6:5:71::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.29; Sat, 2 Apr
 2022 03:58:09 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d4e7:ee60:f060:e20c]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d4e7:ee60:f060:e20c%7]) with mapi id 15.20.5081.025; Sat, 2 Apr 2022
 03:58:08 +0000
Date:   Sat, 2 Apr 2022 06:57:49 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Laura Abbott <labbott@kernel.org>,
        Luo Likang <luolikang@nsfocus.com>,
        "Michael S . Tsirkin" <mst@redhat.com>, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, oss-security@lists.openwall.com
Subject: Re: [PATCH AUTOSEL 5.15 13/16] vdpa: clean up get_config_size ret
 value handling
Message-ID: <20220402035749.GA31424@kili>
References: <20220123001216.2460383-1-sashal@kernel.org>
 <20220123001216.2460383-13-sashal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123001216.2460383-13-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZRAP278CA0008.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2be384a8-569e-48d4-1d1e-08da145cff8a
X-MS-TrafficTypeDiagnostic: DM6PR10MB2890:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB28907723AFF671EB176F95508EE39@DM6PR10MB2890.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iVl2gChXN6Lw26qvqKoQmdCMw23JB6GP6GYD4iFOFxNOMT2pXgv5Nfe8vuRIhgCccD610foXT7vWz0JEoozC3MwdOkrAVuo1Clws+gfxhjfLUoGbdpWZmGo0JHJqyxbweZKpSvTTv+V2I/0KHFbRDA0qy2dTNgA/TPPqGnrf2zpgztHK7bk2AeBWg64o7UHTc2r/xcG6RKB/7DQdON3ZXRF87QSw1bHWXwx0utRAsxdDZuTH2viOOrlme+Asaeg1CXFXSAB5es9II+z9U25rzER9gmRG4YPE1lJ4R6MSeR5vflDUK7jnWZ2zItTUfbWax3ti5aBBIVVrijwh+Xi2i8Zu6qik6irtJaEYj27EqTTzcOvzw37sxL4mLLM2FjG3tUC9aCqY2dJ4FC2i2OdAe9OhxfvBwsABiK3rs4ceB95V+BAejNsPqk327uR6AGE5LrZMHlxm9BV3Qve8yAR65pJQcPDF9W1UQBELLsxNa3aDa3B7Otsj4JX7NesDN8QAlvHvKuWoe+kPSa/cjgdw2ztAK1OEzfAaJCbSb2Uv2gCsIQVocHtl/QjYCVa2H0+buHmEdFBkBiVLKl2lzlF/EsU7KSpPENA9AxwkbtKiORJ70XZwcMI6stiyqZiVPJDTPwbJN3HlVl9u19BBBTOvy841dL23I078I4281CeODI4tp0fzWC6xmnQ15zLEcgVbTcFAwyt7f9VE6xvrBWBfvKxAsbJCqZjHiezvX8tWNJ0E8zOLcCLHuT2zDKABtDJrHDWT05lgsUbHRItvXXZo8YxfYwrRyfVGOyDehIuRE4N2nrE6fAHPtBvW1lZYGI7WQ4VuFOg72TCyKKXP0FRqjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6512007)(508600001)(9686003)(86362001)(316002)(2906002)(38350700002)(6506007)(5660300002)(52116002)(83380400001)(6916009)(1076003)(33656002)(186003)(26005)(8936002)(6666004)(7416002)(966005)(6486002)(4326008)(54906003)(66556008)(66946007)(66476007)(33716001)(38100700002)(8676002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PeYjNRn+HnLXPFXl6jLdYSe3TSxQQFdoChPPdMikllJspXGqrzTIPCNRZQYF?=
 =?us-ascii?Q?srGueBIBApIV+4xe4cENHAllL/+CsoceRYm3hq7nD3kCLgUVy4Cneaz2ejT8?=
 =?us-ascii?Q?F8VDQjN2N0zOO1HLBBktgixbGQR0S3Gdt4Frx1CgBh+sEvr5WMrKwnQq+rKa?=
 =?us-ascii?Q?97zG6Hkd7tHxSDhiVzvzGqPy8CeEzNkBGKPjtOGy9gTQgAPD5U5wB6YiL71t?=
 =?us-ascii?Q?eN/NTG7qcU3GODMDl7Cv4yRcdbkkYTifKq6koJjxo2YZoy6M+MkqozVIelBe?=
 =?us-ascii?Q?lpLJIkrx5VfM5RWUspf372tX6WtOr6TOQq59AysNKXKNrYFy53+NxTYPl8lc?=
 =?us-ascii?Q?tPMtRBON4P3jDmugcrcB1NuIPd4kowOKiUVuen5Z61HKO5SAuy9p7dkN0r19?=
 =?us-ascii?Q?guiOlWABLJhJgJtIs2M3OxYMxsHYMuEJoSa4L6hVTD3IR6Us5nyhGy2Q/9LE?=
 =?us-ascii?Q?1ivtywjN1vqyBCb7YOQ5Ib42jBgUvSSgEd1+PvSqERJ2OE8T0tEUw1R5dO+f?=
 =?us-ascii?Q?EBZP9lmZPGM9ZS5NMarKzqaiKScCNteJPvWIVmWbe1DARysEIoHawyJrbWmZ?=
 =?us-ascii?Q?pJJeZjtc9mT3Ul6zv0NkciTNvovy6VI6CvVokTBcU5QgXhdqLGZGk7kDuTso?=
 =?us-ascii?Q?WlaRX1FSq0suyRosMCYHjqufQImNX35st5waIeiUazKSgO67yvbkCtXIBNJT?=
 =?us-ascii?Q?i7O/pRQrvkU9X6NfwBJKIsChn9kChFCpnQKrk+vMqbUyraHEUVTZub1BwkLy?=
 =?us-ascii?Q?FnedB9Co53TS6+MvJYK730LWQWy3vPRS4t1v5AnHtq+slvGfKlDIruJKxjea?=
 =?us-ascii?Q?eu6hjPR46K1czWAD5pUKb4NaTbgh2vYWwD6mZRGTSaTHN0k6R4S4ieDPohKU?=
 =?us-ascii?Q?jcz/C17VWesWs00zaodWLsOHVD1TyheHmfdOOC8HoXZC7SY73F5KtcByEJPU?=
 =?us-ascii?Q?kbo9O0hQpN/QzZ3JbSH4dN8CR0BaG+6AuKjQ3G89lP/FiWDo4EV/VeRhqnJ2?=
 =?us-ascii?Q?MlYAXd7SpBvw7TfE6dxcUFI0KqX+7Iiooq46e6Y3zgXbjMdQM3vEJaeUiKTQ?=
 =?us-ascii?Q?J5TlU5qDLWswEKpRSq9DnnFJ7lOQF+uct8WCsVcDyFX+4mMJlvn3KOhIWzpt?=
 =?us-ascii?Q?iCXmY3ugD8gfxdz+E6QpGe1Gamdy+9XmdLm15ZZfvEIQVnBfQMFJLSzMTqgJ?=
 =?us-ascii?Q?GExgGWORiY3naNMi6piKNTDB1BaQYKATGO11K1ttvKJSFK1fJ594dm0VGbw5?=
 =?us-ascii?Q?9W5aUneCeIs1MFedr+9wmECvBjkaSXypnvv/i3zPrnkUl7zhhyJAR5b64bOY?=
 =?us-ascii?Q?2OOT5IHI0DEBi6N1PjC7SNp8aGJFitJCjr21awxmM/oLGO+KsKx8dJUGOj/U?=
 =?us-ascii?Q?hU6A7tBbp6aglHFH0QUzD/CbYDWvIas8jYK7V6PKy3CYFTTPrIQY+3vgx81U?=
 =?us-ascii?Q?wu+eyKlGD2ZoOj60PgPQZArLN4WXNynC+GV2bzN6zlKmUTedbiIk32Lg+Ps0?=
 =?us-ascii?Q?xEuY3QiK4jzqxh63keje6zJB+VF8wmqZE5n/uckOrpkHkTkYki1N2vr6gkN7?=
 =?us-ascii?Q?B5h8xbPKA4pxemAj/oqcip5uSvJ6n07uoVLiny9X/44Q3zA8ktyrWoHOZQio?=
 =?us-ascii?Q?UsLlhF+kfq1e7hRg+5KT8ue9fGN9r7vmZzpehBMbxxLoVz6LdeE9PfoBbHW0?=
 =?us-ascii?Q?A+MyjCpL59B4Oyxh5iLtbn/7kA/3Z3aCeMnmPinB4H/63CZVTySE74MGOHHR?=
 =?us-ascii?Q?JUVtSgirSyG4lp/lKqX0UrGI3pJIclE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be384a8-569e-48d4-1d1e-08da145cff8a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 03:58:08.7196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5/t/rD8CIcjxh/si43L+9xZWuVaZbMugzclvR+jM95By+3lVkzwkFzNuZ8GuuY822mMMUNlnqnI0hS5UtSitWq9FES9kaCI+UURkD4SQY9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2890
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_01:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204020021
X-Proofpoint-ORIG-GUID: 0qP8d3j8zvK9r4TrNqCz1mkF59sVXDFV
X-Proofpoint-GUID: 0qP8d3j8zvK9r4TrNqCz1mkF59sVXDFV
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mitre.org page

https://cve.mitre.org/cgi-bin/cvename.cgi?name=2022-0998

says this is a fix for CVE-2022-0998 but if you apply it by itself it
creates a serious security problem.  Originally this bug only affected
32 bit systems but this patch will change it to affect everyone.

You need to apply commit 3ed21c1451a1 ("vdpa: check that offsets are
within bounds").

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3ed21c1451a14d139e1ceb18f2fa70865ce3195a

I don't know if this affects anyone, but it seemed worth mentioning.

regards,
dan carpenter

On Sat, Jan 22, 2022 at 07:12:12PM -0500, Sasha Levin wrote:
> From: Laura Abbott <labbott@kernel.org>
> 
> [ Upstream commit 870aaff92e959e29d40f9cfdb5ed06ba2fc2dae0 ]
> 
> The return type of get_config_size is size_t so it makes
> sense to change the type of the variable holding its result.
> 
> That said, this already got taken care of (differently, and arguably
> not as well) by commit 3ed21c1451a1 ("vdpa: check that offsets are
> within bounds").
> 
> The added 'c->off > size' test in that commit will be done as an
> unsigned comparison on 32-bit (safe due to not being signed).
> 
> On a 64-bit platform, it will be done as a signed comparison, but in
> that case the comparison will be done in 64-bit, and 'c->off' being an
> u32 it will be valid thanks to the extended range (ie both values will
> be positive in 64 bits).
> 
> So this was a real bug, but it was already addressed and marked for stable.
> 
> Signed-off-by: Laura Abbott <labbott@kernel.org>
> Reported-by: Luo Likang <luolikang@nsfocus.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/vhost/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index d62f05d056b7b..913cd465f9f1e 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -195,7 +195,7 @@ static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
>  				      struct vhost_vdpa_config *c)
>  {
>  	struct vdpa_device *vdpa = v->vdpa;
> -	long size = vdpa->config->get_config_size(vdpa);
> +	size_t size = vdpa->config->get_config_size(vdpa);
>  
>  	if (c->len == 0 || c->off > size)
>  		return -EINVAL;
> -- 
> 2.34.1
> 
> 
