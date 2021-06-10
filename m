Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735033A342B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 21:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhFJTjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 15:39:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18972 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230117AbhFJTjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 15:39:25 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15AJXwPC003084;
        Thu, 10 Jun 2021 12:37:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=0VAksPdmsHvjTrHQoemz91kTzwlDlNDr61G/VB+20dk=;
 b=IbkiKtte1Biwur0PfkxHzHDZP0hZ8jHp/GZazEl+V3yl13QDb0ytNkmJZ8fDqimyFnbR
 6vHOaRme2+cWxWXnmrSm9uRWlu58LAEP4wsvFdxAyixgYO3PtrzFo+XSJa1+n6pSiIwK
 ztUrFpyxCVgursvYOPUjifyLKfPIOLeUrkg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 392wj39vuh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Jun 2021 12:37:25 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 12:37:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hzl/YQ9xQyaBgupoJclu+n68Wuf4rujgnL+nelV4H34f5rvXj2ZUGIKu97AycmxzZPA1LUhIUDAvrxHOGO94VtKzCeaRxE/7WKWD1mnERp1z8mJr6fDSdV3udyQdkfxe37xIXAtqcaSmlX/tjPBqJHJcCIi/Dj2sOWY5XvVREA8vX3rogQUHiLj3oVt7f7dnxuUFWhN2O48igZyJUCq9vEMBPgTt2lHTgUDASWmUJDaef/lMMrdJglCKHbf5xxxIZGwT90h7dm5aLQxCxIcJ8otyjnDnT0jSS8FUqsV9Vh/3UtdTVHOHzXLkuaUsbnqe1dM8kimyYRmPXizY2sBTww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBRLCMeCCH+kYLknGBLZjY/JTAS3ZQ0cek/W/uPlS0k=;
 b=byyMY0fqxU/64YOwsoNjdweCTV8qpIghhzjoFJlKz5IlAlEBID9ysZOJOPBpFmNVn1UuGjnR1dyN3vxzF7dBSX3aovd5dMRUess6/kgf58O5XU2cCoz/46gkMfH2IN//5hGB3beDsoI70jipXibmYjGgZseelPT9Ft5UrBhAYQCHyX7ybQxKdsmwFp2+nkQp9lLnMuFj2Hm3mMRS9K2O/2J43tIlZKOKpMWvvC1EaOB1K1sxGhSbM2HylW68IZ7cgkwBqYwRrulxfjkwcMALQFijI/ynjsobDXjtP/5tuByqzr5YZ4c9VnBDzzvCQZMrDj3gROvPaNGghfi052pxeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4468.namprd15.prod.outlook.com (2603:10b6:806:197::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 19:37:24 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f88a:b4cc:fc4f:4034]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f88a:b4cc:fc4f:4034%3]) with mapi id 15.20.4195.031; Thu, 10 Jun 2021
 19:37:24 +0000
Date:   Thu, 10 Jun 2021 12:37:22 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH bpf-next 03/17] dev: add rcu_read_lock_bh_held() as a
 valid check when getting a RCU dev ref
Message-ID: <20210610193722.753tqgrovwyg2v6v@kafai-mbp>
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-4-toke@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210609103326.278782-4-toke@redhat.com>
X-Originating-IP: [2620:10d:c090:400::5:6314]
X-ClientProxiedBy: SJ0PR03CA0208.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::33) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:6314) by SJ0PR03CA0208.namprd03.prod.outlook.com (2603:10b6:a03:2ef::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 19:37:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ac107e6-0c19-49ee-ba5d-08d92c472c06
X-MS-TrafficTypeDiagnostic: SA1PR15MB4468:
X-Microsoft-Antispam-PRVS: <SA1PR15MB446857F66354FC8ED81ACF6AD5359@SA1PR15MB4468.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QXdBdy/vSdd7DjOgQ0/WI3unuEIlH22552nyGGOZhnnFochrMVYpERvB2K2usOAgPcuDWd1Wb4apeyHJ5Pe1Ym0+jF+7BSDTy8G4N3hB5Bt8ic7hDBh/xrlVbjONr65ZF6cwByxq9r7h70BitZSJwybFvoN+IgOVu4trkYulIvl0Y+RsfMBtsRn5SjzTnRZNP5EJt6z12DagAbln1dgSguKZgLLS/kp50TOcr0cl4uIBY77AlquATxaLcRkYl1Y/w3nmWMG4OJ287H7Jd8UzqZeWRSRgtLNBqQfzxBjTZSJaD3TukqT4OCU66MXTUX6O5BWR8SsVtOzs12Anl2NT4Hdxusp31HEjg/9gZSwoz7JA2cOl6KDRkfqcaMPJ04jUgxx/4U7PJZyBP8nQb9EWpt4xpfR2youIqV/ux7K5bR5xEjTflpv0PwlsOzY0PerptNlzfv76IwGa+3xDmsjYuV8yjL6YakXs9wEA4JJR6VVw/ZXF3PhZIe1KRkbdmrSbK/0O+g3L1gSpeLOoYGf1i84ERYaM0NKIZDwgQj9UwiiPQi0t7rUy3OxpOVYWMPOUQVIHMDFYu/dxnMgXMdfH1Dgmi+Hcr3q8oWxCM1uoH24=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(52116002)(4326008)(186003)(16526019)(86362001)(6496006)(478600001)(6916009)(38100700002)(66946007)(66476007)(1076003)(66556008)(9686003)(33716001)(55016002)(83380400001)(8676002)(54906003)(2906002)(5660300002)(316002)(66574015)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?JqxG90El3ecgkkz3zY6UunmiiTGiQ2NvrVn5OSQWFJrXdE/mQK/Wp9uh1D?=
 =?iso-8859-1?Q?bCJZlMV4zm6T1wcFI6bYMpryT9JtdAmn+qIUNQxqDfZgKnEyikzmKQbuiV?=
 =?iso-8859-1?Q?mo+RKRIE70NfcP+9XihlAs+au2w3+gu47w6mlMYagNAtafGpL+itiV4il6?=
 =?iso-8859-1?Q?ngFDG0Vol8Z01VA0iFgRw7zV2qNFpREAM+x2AvS7CpU884bX80NoyI0PF/?=
 =?iso-8859-1?Q?Q9hLNk70N5rK3IWjPGKqyhTgTCeOmZUVwbrw+SZPUVOW5SjH+VAvy1LcUa?=
 =?iso-8859-1?Q?X6y9rSsU5316lvRyBfHO8uDAHle3gjkG8xprEhCM8qFwulIln+vwbe6HPA?=
 =?iso-8859-1?Q?qVFResCARQmA36D/AgBIESw9Rf9cEDhoDo/5J2kcHtHH6eRA14tzdSqZeH?=
 =?iso-8859-1?Q?GONI0vCHqE19CTOGY5sitpRcIkFnbhd4I0CSsTWlQ80vs1s/WX4zcVga5H?=
 =?iso-8859-1?Q?NLZ/pt4c2bOeRSwlRSVGie2c3+A+V7izZ7D1FUh5nPL/T1mDBd0+kRVmgl?=
 =?iso-8859-1?Q?RjJmj9VJLNBycjSkPyfA9ewWgFLep0jYw2v5dpaljOEobeX5F5Nf9EVJv5?=
 =?iso-8859-1?Q?yDS772KA6CE8PCE/v+uUggkmTK+O8ELymYR4oSuh/Velh0qfGFe5w1uSfW?=
 =?iso-8859-1?Q?3PsMZm4FZ7dZQVhOw/7hoODdztTjEnJs1LdCK+NMCWsAUXJfM7muCkZ0yc?=
 =?iso-8859-1?Q?YuVnqeGmPW74BfM3o4RANgha81bl3+XDoWWWId0MIjYOfcIdryFQC3Daqb?=
 =?iso-8859-1?Q?Koz1sFBcEGfcTc8IH3tCnULweZ5GguvbVK3TJ051yy4WFvLgmyV0JIoi+v?=
 =?iso-8859-1?Q?bN3NSJoA6WZzwMsrr2pNEdIpnQRNoFTUcyBYQdbr9K0MzsEKdSg4TQsfiS?=
 =?iso-8859-1?Q?dI1JKMBUR61aFdlF35l/n+meBbbXG6Z4IC7kmA/oBDDpINjjADmPwPb+V/?=
 =?iso-8859-1?Q?mBrj6ote0cLaN4ER/6TAKk7tJp/turb4XVaWEuRjVaALyRDkXz02SyjDG2?=
 =?iso-8859-1?Q?Ar+ACAQLEkSO6FkuP6l1n5YdTJ9r0SeJyl0D40Lud9spIHMn3QAYla7I1O?=
 =?iso-8859-1?Q?honVshx8wwFQEMiPw1XNPxvnV2gNxKt5CbobuAcBg+bTZgSbYqMJ5csW48?=
 =?iso-8859-1?Q?w5RtZc7c92fDPgGKtw3qHZV1ret0jOyZjRxz4Io6ZfvwRtIdpyMBgnQdy1?=
 =?iso-8859-1?Q?3gY3bWRPJ233XOMwwM95b/FXUyPP7Dio5vUqlZO0d19yiWtoJvy2uIMY/4?=
 =?iso-8859-1?Q?pE/K56D8zep+BhbTtOoc11q++JSZRKmNYfyq4RaDF86Ikxh8QJ3ho5ZWlS?=
 =?iso-8859-1?Q?MoO2FttwJJeXKS0wTNgkKRR/Hy5pvVGkHLrDB57E6XP/+tEPztfDCtfU2X?=
 =?iso-8859-1?Q?S9423qIhR7On05vLY+pjr1mt8Nen44pg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac107e6-0c19-49ee-ba5d-08d92c472c06
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 19:37:24.3958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWS1yC0qsE5KhBYwEUXOX/AV6hF3OAk3xBAkm4xhTXuI6yYbCE3w2fJZwWhnIly9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4468
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 0RWPrtNKNKPXORD0HvrljrOXDuef6MwL
X-Proofpoint-ORIG-GUID: 0RWPrtNKNKPXORD0HvrljrOXDuef6MwL
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_13:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 mlxscore=0 clxscore=1015 phishscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106100125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 12:33:12PM +0200, Toke Høiland-Jørgensen wrote:
> Some of the XDP helpers (in particular, xdp_do_redirect()) will get a
> struct net_device reference using dev_get_by_index_rcu(). These are called
> from a NAPI poll context, which means the RCU reference liveness is ensured
> by local_bh_disable(). Add rcu_read_lock_bh_held() as a condition to the
> RCU list traversal in dev_get_by_index_rcu() so lockdep understands that
> the dereferences are safe from *both* an rcu_read_lock() *and* with
> local_bh_disable().
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  net/core/dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index febb23708184..a499c5ffe4a5 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1002,7 +1002,7 @@ struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex)
>  	struct net_device *dev;
>  	struct hlist_head *head = dev_index_hash(net, ifindex);
>  
> -	hlist_for_each_entry_rcu(dev, head, index_hlist)
> +	hlist_for_each_entry_rcu(dev, head, index_hlist, rcu_read_lock_bh_held())
Is it needed?  hlist_for_each_entry_rcu() checks for
rcu_read_lock_any_held().  Did lockdep complain?
