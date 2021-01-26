Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BFD3057EC
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 11:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S314378AbhAZXGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:06:04 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46618 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390571AbhAZSCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 13:02:22 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10QHxQBn029129;
        Tue, 26 Jan 2021 10:01:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=K5LBys8cEO4cy+XNRAqshoDoZDmNl2DO5kn8fWeUGww=;
 b=P2JP4BUxnyUXX3E4gaev0cMiXRpmN0Mas4e/7s+7FX7RKKChuRciaXXs5ELeNrigFdLB
 8tQhQn7rupwMPcxg0PgeujVupxL1p2uSCQsusfE68pdL7AMfwlG03pPdkr8fgl8T74R4
 rG2RunYQaJRGlt/uG/zC+beeRx4k5J+GPlM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36950a5mg8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 26 Jan 2021 10:01:22 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 26 Jan 2021 10:01:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Umn00u8vvufNmThZGmDkbBV6t54nX1YFTRZFYIRKvJdlVG2hXtrltNtUupAoD9v2cVXI65eJrIIiJhO0J6Pdhx3m3bQ9HbFMieKsyqoefwU76vLFecw8yoNkqztlz8z8Zlu7XopZP9XtM5pkGR9rzsohzuSLO2yTvmpsEmMwT6l4y9FvtUqMQ54EL7UCUF9Odrf+j/wJWxGEOldz6giYKQdP12Ntb/5PLBCCJ9BT2AOxt0QXUucYtk0+dtOF6armL2qqbzHrF0eNG1i6ZfoTGxGXHl70QVGp9muNi0tgFTLl3dCATMIGIV0v1PMPb1ykF/9Ae2mkB+3bKyWi/zMGKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5LBys8cEO4cy+XNRAqshoDoZDmNl2DO5kn8fWeUGww=;
 b=D5938v2YTrfefsNIK0KDSibp5GvOEYx1GdPxOJOERquOlfTA4Nj9SKOxXyDzQCzV4m/VKUSLKZfXyjB2ywp4y/j7gvnaHSniSEg6JB0uMA9x8PldIU1KzF8oCu8Xn+f0/wbJkYYzqXC1fwoHZr3AtV/FSVEDkv940QZ6fe84oVLN8Eia7j/DM1htQC+dynONgSI7Xz3XnC9CbaXMCwWFRVHEk6MYtT8DEVAgYKXgHmLNqiylPMplOc35ytU4FAIgQbk8K5rNYwn2r0aDCERrbQWpToviOHRTyQZfcnW+XHkcTXpfRBHYa/Oqj3+iebII0w2wXn7KyX1TV2cwwFosVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5LBys8cEO4cy+XNRAqshoDoZDmNl2DO5kn8fWeUGww=;
 b=aIyWc9xt5mwGpw4hmBX7DJ1IPj66lIwcsE3rR/YC7yMsbzZPEqFIDkQ+FVk0I+gKxEwOPWILt0i0wPhaqMwbc0xQKyTjnHSt9+I/f8gj9xdTL0c8lkvolXtEN7poHMV5CaF76IvK6vTNN2SPJILkBSuyWLvshyfP/9aeJk+htjk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2840.namprd15.prod.outlook.com (2603:10b6:a03:b2::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Tue, 26 Jan
 2021 18:01:20 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66%3]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 18:01:20 +0000
Date:   Tue, 26 Jan 2021 10:01:11 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v3 1/2] bpf: allow rewriting to ports under
 ip_unprivileged_port_start
Message-ID: <20210126180055.a5vg7vnng2u6r7te@kafai-mbp>
References: <20210126165104.891536-1-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126165104.891536-1-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:694d]
X-ClientProxiedBy: CO2PR07CA0057.namprd07.prod.outlook.com (2603:10b6:100::25)
 To BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:694d) by CO2PR07CA0057.namprd07.prod.outlook.com (2603:10b6:100::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Tue, 26 Jan 2021 18:01:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b082047-1bcf-4df0-58f4-08d8c224621d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2840:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB28404B675800D113FD09E6B6D5BC9@BYAPR15MB2840.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tJHry0iKC2FODrM7ql+Dep3FZaT+A9Kd/5/ADS7cL3lJn+mjm9SctChsLOTuwajdYumOYqaaFVB4d6gkhMzYCA54ge4I1/2wl5XeQtS+h4TBhnyH2CzrzjBsOk9wrybgUvOvO2fQpp+PkGcEbQ9l7xxulnJxvt1iGn+Jfesh6mCtIJ4GVzDR1yQMancWFtH9gSSE73BWjDEwyU+Q7F1T1kosUp2yHy6LMn0rAaSzXWSY0PA2XuzIdhJ3sFlNt1c/F16GeHFioOBi46kg9gUl2Lk5joW89noikIWyhRJptyBl7TjcVllFtAnDyO052MQ1JVBzMTIhzn/fLNOQj+Jo0O+sTHOY1AVMK4xEKv0i0guqV33WnkABCZ31cXxcUWJDeJjOQMz6HmSE/U4OYVVtB6UZcOwclVQ9VkqJicaWh/fZiAF+9F8pscu3kBlC0ZiBg2DtErCTy8b4NijolxZOXT4uOHh3KO4MPcoR6/A3adqRfaKnP3HjUvbl/RZ1+v/k4Jon98js+nFnmrX7DoNNDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(376002)(39860400002)(396003)(316002)(478600001)(2906002)(5660300002)(6916009)(86362001)(66476007)(33716001)(66556008)(66946007)(83380400001)(1076003)(186003)(6496006)(9686003)(52116002)(8936002)(6666004)(16526019)(55016002)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?92uqVADZvw0niyIkD3jmVwVqtgdUwHAN4+QFv5C+B13FjBig4iO4vQroBlR9?=
 =?us-ascii?Q?OzQDxev/8oDJ6hOo5X3exYuk3Z31GZdPN0NNOxZuItfutA7cMHfXpNzhK6Xv?=
 =?us-ascii?Q?efXBRAeYAHmi2pwUsBjFl3IOCuNwrFZ4FJLbu+oR/6wpc42ZykfdDKrdLWHz?=
 =?us-ascii?Q?PG/YDHbd8cMdMmStL3ADbqUVduYtE8bRZwO5REYWxsV2vSS/oa+A2F4e58nU?=
 =?us-ascii?Q?7RfPcU+M/kdB1OHbtIsPSdxRJ5yt+sWOG/Pcdx1w04XHCyqsDhp3Jc9F0jgZ?=
 =?us-ascii?Q?hQo/5yxN1eE4OqT80qlezBXt4FwJtp4vKi4UUFp5wFnQkEjSCuiG3LQRWOkh?=
 =?us-ascii?Q?AcQiJH8ESVftza0LdMEAcXsOB7aZiudc5QIUgtJipOZKVju/q+63pfH3Gx7c?=
 =?us-ascii?Q?n0bsV7iPdmCM48L6r61ndDtjolkYG39Q63la40q/9mnfdaavZOcdpHzsnass?=
 =?us-ascii?Q?WS0JMYvcAtCX3345AtoBuEhsxBBf0JMurT/jTabix4JZ+FrUUQOgUw4cnp+l?=
 =?us-ascii?Q?hDlBRAfZYbbYrUw7FYCHFKWDyQHkchGRkXUEhtn32PgM+9pxWqmUvloNjT4i?=
 =?us-ascii?Q?NBIhQwYGAkLDvufoWPxYUG9nIEOz7Q4lDEmiRrZXHnhhYLahpBUduX7nhZHQ?=
 =?us-ascii?Q?JFj+fEvhXss8UAJHe9teD4JM2Yi1srt+I2NbgRALn/Noh6jIlSS9/qxK8Te+?=
 =?us-ascii?Q?jkZLNZUOOLUeSUAiZNnJ+ZMFM4ha/kjMSh0BV7TfSluGq8X+zfulk0QTRiZA?=
 =?us-ascii?Q?rETHp55vpRixGigZXbaoKTr/24h+zHuqYYzr/it9b2/bGkSBKLS5duKD0T7c?=
 =?us-ascii?Q?Gw4UU3eYj05ZiLPvaZNqoH4A7nb2BRHpeNIglGS4eCa87HO/1MJayaS9Hvk9?=
 =?us-ascii?Q?ykAAbx3TNe+Wo5N8DYVOckgnnX7FsoQ9N2p4I05fxElGUUMwxnWigte3swTB?=
 =?us-ascii?Q?Ef1ir3rbQ4SdjGgZDcSqW0O6N+eU1qvL1hHssGECrx5IayC2rK2jUNXysmm7?=
 =?us-ascii?Q?oiAnF6d2kKFhA5wZuxiAlCoxWh1RmOdWm+1xdud/ymn6PDOF7vUSJ0S+w+eb?=
 =?us-ascii?Q?3rF6mt0LvhUzRXIObIg6FagXGkIBAnqZOdKqKPAM1nn5EkS228M=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b082047-1bcf-4df0-58f4-08d8c224621d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 18:01:19.9663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G3yjQaITP2HzFrMuVCeoO5OuWQyACrJZzg460H+XZQ0KomXlyrAk8GiH7azSVECh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2840
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-26_09:2021-01-26,2021-01-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 bulkscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101260094
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 08:51:03AM -0800, Stanislav Fomichev wrote:
> At the moment, BPF_CGROUP_INET{4,6}_BIND hooks can rewrite user_port
> to the privileged ones (< ip_unprivileged_port_start), but it will
> be rejected later on in the __inet_bind or __inet6_bind.
> 
> Let's add another return value to indicate that CAP_NET_BIND_SERVICE
> check should be ignored. Use the same idea as we currently use
> in cgroup/egress where bit #1 indicates CN. Instead, for
> cgroup/bind{4,6}, bit #1 indicates that CAP_NET_BIND_SERVICE should
> be bypassed.
> 
> v3:
> - Update description (Martin KaFai Lau)
> - Fix capability restore in selftest (Martin KaFai Lau)
> 
> v2:
> - Switch to explicit return code (Martin KaFai Lau)
> 

[ ... ]

> @@ -499,7 +501,8 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
>  
>  	snum = ntohs(addr->sin_port);
>  	err = -EACCES;
> -	if (snum && inet_port_requires_bind_service(net, snum) &&
> +	if (!(flags & BIND_NO_CAP_NET_BIND_SERVICE) &&
> +	    snum && inet_port_requires_bind_service(net, snum) &&
The same change needs to be done on __inet6_bind()
and also adds a test for IPv6 in patch 2.

>  	    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
>  		goto out;
>  
