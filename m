Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EA63A356F
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhFJVLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:11:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1542 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229941AbhFJVLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 17:11:12 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 15AKlA2T023582;
        Thu, 10 Jun 2021 14:09:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=X1mCAlfVOI/gDehqurmiAF7AAzTihpeXf9Q9bZb0Kpc=;
 b=b+UDrJPmOLDJberQyPWYBDCfabEzjd46EbrHaa4Kx2VGNVr25PU4BD7mwSLXGr8lTKWb
 iFeK2bQuiedoZyDpf7jMRL6Cr/mcqfoDjDnRGvuMJWg1DacjmrKU8XB4HTJFkvcvn/3N
 nY+6Wdkz791mPqg822zXK5mS/gHScdoRpmc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 393skjgf7u-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Jun 2021 14:09:12 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 14:09:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPpFR9GVCt3CqhK5yEZ2oBXT8eXb/FUNsfNrp3+q10MBZXx7OWA12sKZH6aoM6N4sGpIvQHEhkOz3YUs4jQa3RiEqS8dcK5LukQnTaxCaGJ9c9/e7sQDStHR6zOUtm+RKTJLSZEdHnVf/Ct8yAkWsYHUw52F8Ra94GCR4ydBicJ8+YJU9hR04ezUusUkyLIamGf1rkFbY6T3HN6febmNvsDMOrZD5upP4j/OVxLpzvl7HU0Eq3/5syygmb5yQsEw6x4zRvoiThoI2FCZvH9XgvwTIHz5JOjf82J5viqpWo2Gj2xw7p6I0s3RauOGF80SwLObkduWN9+PcaP/LW9nCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrDwUvB/S6Bx2yyZY+2ICt8NUyL96xmBr6MrYihg2uw=;
 b=TnbkMWRYJX758dc7Z+3pNWcvszsE3Yo/JCvswUjuesLak+NPx4nFaWBxk2PXm9EFSW6/UgZOod1JhWTCLgSzKoIJ91mRIAn5ZhdlrIgn+8e8DhIXQXrGnV7PAlwczfDDCzTzzQFroFElnTKHYr9bCngf/zO/8Rw42B6f7/uCTiZvy6/db8gU4CTsJp6ymNMDOVWjDtMzV6sYmJ2sGVQyDxNeeRfsWqFEsiXCoZ2zN34HGRzXxqGWhFxOo6lGommDd77eo1JPIU4QLbmAuM2neFjBv7BE2S4agYTuitwsTgWLdLdniv2VWcKPAcT2QByUTfwMVkzruklOQco22ORyLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2464.namprd15.prod.outlook.com (2603:10b6:805:25::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21; Thu, 10 Jun
 2021 21:09:09 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f88a:b4cc:fc4f:4034]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f88a:b4cc:fc4f:4034%3]) with mapi id 15.20.4195.031; Thu, 10 Jun 2021
 21:09:09 +0000
Date:   Thu, 10 Jun 2021 14:09:07 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH bpf-next 04/17] xdp: add proper __rcu annotations to
 redirect map entries
Message-ID: <20210610210907.hgfnlja3hbmgeqxx@kafai-mbp>
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-5-toke@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210609103326.278782-5-toke@redhat.com>
X-Originating-IP: [2620:10d:c090:400::5:7e31]
X-ClientProxiedBy: BY3PR10CA0005.namprd10.prod.outlook.com
 (2603:10b6:a03:255::10) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:7e31) by BY3PR10CA0005.namprd10.prod.outlook.com (2603:10b6:a03:255::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22 via Frontend Transport; Thu, 10 Jun 2021 21:09:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 656ec5d7-893b-478a-7ce5-08d92c53fd5c
X-MS-TrafficTypeDiagnostic: SN6PR15MB2464:
X-Microsoft-Antispam-PRVS: <SN6PR15MB24645B958A03199CB1A7BAF4D5359@SN6PR15MB2464.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XMuJhxzFtLme2KWJuAWW07jMUNRL4QFSx9RPNp19hhKCOB4JhpqhKbntv7gj7jekPPImiFgDNA8YDTdW5H9optfo5BP68n1GZ7waqdLAFbu9x3y2Itn7O23hYTiPl3agbvZmUlTKAAHco9n9jEKICAlp9cqizHTuQrKlewrSso1O8+3lED88ChS1SpN7nmEBkZuPy7gJWyBwf3qclsZfqLZU3tMb9bG/OmiCS1dzJYjoh1Cm7dUA4LHG+ysNU7BOZ9P/ySEgxdMPm0h9lMtuzE0SLZ2BLPQ3Zib2aMrBYbuaeIJQ6wRL3SusSvrXJ0PR+VdDiT0StSrYRJXFUekOYlCnBmwjnY1INU6GFq/1sHu3G9CNzslYVv3fcUKxzPpPBCL+85xgB9ieJD1E3eVhvBONYXQHmwmNK+tox1KOepKQxKITuZ3XmrI9acL05+IkAR/6JWmeP82jANyTtAk9CA8X/PIjW6VXNCeI3UXQHT2U9XieTOYR/5kPCKdC2TW8ltHuYZO89MkTjQ4CBhh0V2LpjjeQsaIGrlP+3Kd0qyDW1oX4Qlx+Kn0KTImZe6h7Reb4iZcQ/HRFOdQFRuvTYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39840400004)(396003)(136003)(1076003)(316002)(83380400001)(54906003)(66574015)(5660300002)(4326008)(9686003)(55016002)(33716001)(8676002)(16526019)(186003)(8936002)(52116002)(86362001)(478600001)(2906002)(66946007)(6496006)(66476007)(6916009)(66556008)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?wdEfTP8eInqnpQXlsHgyBaptYn8JoeZvdLC6KS0E7tEqu4lpmBNtRaT5v2?=
 =?iso-8859-1?Q?+N0LeDkVAzhs4LxePeKjCDbnAvKeazP63+G5krQzov2V9dhbw91jCyS0WD?=
 =?iso-8859-1?Q?yYCRs8VMxwURuWm2WB3wuMnxvw4vBTbTQC60ywizB+uQ96HBDlhJ/KkNvP?=
 =?iso-8859-1?Q?9Jf4PGcPVCb8aaAdn2pASH6QPMG+qm1nx7+ICQM9Aamv6jBwoi2d5ff+b8?=
 =?iso-8859-1?Q?lZIybKn4/+ICxlPE/XL19U2b1I3Ov0/Q4D4A68VtfE53l1rTEgMujc9JCG?=
 =?iso-8859-1?Q?dy5rWnh14l/BsPKSPEJbUYlBM20Q/uYCR8mX/Esw5UCmil7/qpQtKA/CAI?=
 =?iso-8859-1?Q?Xt96BvUhAE5m9GR0wu4JYalnKkE4leSaPbKnfeOfeGhA28uDsWfPJXJAyR?=
 =?iso-8859-1?Q?jE4tKTyKovEPcbYPu+Tkw2HJS4WrKVLwUgAih3IVSUJP6O9ab4hlLZed//?=
 =?iso-8859-1?Q?f2le5lOuXzXQBuYTWc5nVjHbmW+3Cs755EXsQ6uQayR1nlNPLkQk55prSY?=
 =?iso-8859-1?Q?yCYF0FbfNs+tSvjJh+wkpEoTKmwJv4WUfi+Nx0LDOuRyDG+G/uO9DtrwH9?=
 =?iso-8859-1?Q?OkL3a0lfrHs79oMkT0l6zN0H577kVpeP4d+mPNrRqF6U1qWGgqLvbYNraU?=
 =?iso-8859-1?Q?xHczz7oT5eAyXvZMTzLrb+sJn9ILj9tBY7jDLe/13/f2eLv9+v3GLRjDhs?=
 =?iso-8859-1?Q?my7KUkjgI/4uI5e9mQ615bSonvm2EOqPTHv3J4xhH+FaKsTu+QJlaqIbpF?=
 =?iso-8859-1?Q?mBfvHlkax4npIwVFar1OX6Z7DnMTUJMGQ5iMzAHXbaKYOgyEdr4QcVh5+4?=
 =?iso-8859-1?Q?nVN19Womno/uyBGFUBCMxY1X/ba5kJaYL9i2LxebURQP9lQVTNLviXI4Gt?=
 =?iso-8859-1?Q?VK0DWUGei1LTkQPwqmAPOrhI7szN68aehyR8tPfJPuKLYV0rnq4u6WmqX7?=
 =?iso-8859-1?Q?IbssGvVdYYxXF+U6JRxRDBYe5W7Y79yGvD+BL705fGSgex2fP7BRjbGPUi?=
 =?iso-8859-1?Q?O/mYgnVBC4+NZ1JOKEE1RO6p2RxI0AqHax1E1r4I6s1JMWeg3eLB7CuAU8?=
 =?iso-8859-1?Q?DSh2GuhqwunB24njaD9cCcuhUcdmmvHVRaJvUmKW0f1NoXlkAohV+6udYR?=
 =?iso-8859-1?Q?fWWv1gnvdORWu3aMMcBeMm6nRmY4tsTePXygQHSVogPPwldaMRtueUVV1Y?=
 =?iso-8859-1?Q?Q1R8xzjC9SGfsCMSFtLBrrP6UXDApCPxoK7ByHxFqHIzQ7ot6dQwd64mg1?=
 =?iso-8859-1?Q?lVtWPAEyg11gzxoEB8fcBKlmRbAopkQm8fDKIXZ3Pj2hdo++MkjX6ln61U?=
 =?iso-8859-1?Q?ibV0gLOQxuns/o7qiAkAzYDWh+l5kCiVhqgfi4Z6pmQI8KzbxwNs79SAhv?=
 =?iso-8859-1?Q?4iI0yWtv4lMTWbaRpyxGlhXN8dwEuWRQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 656ec5d7-893b-478a-7ce5-08d92c53fd5c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 21:09:09.5674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uBiIWKFnQvv1lG7GFTcKxJCAKvCsC63xnRm27bmqAa8/8ijHfHb7tbiOwwhbXXIq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2464
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: jufPU1LqTwr4lCMScZkB5i-yxDfcWx5J
X-Proofpoint-ORIG-GUID: jufPU1LqTwr4lCMScZkB5i-yxDfcWx5J
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_13:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 mlxscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 mlxlogscore=772 spamscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100130
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 12:33:13PM +0200, Toke Høiland-Jørgensen wrote:
[ ... ]

> @@ -551,7 +551,8 @@ static void cpu_map_free(struct bpf_map *map)
>  	for (i = 0; i < cmap->map.max_entries; i++) {
>  		struct bpf_cpu_map_entry *rcpu;
>  
> -		rcpu = READ_ONCE(cmap->cpu_map[i]);
> +		rcpu = rcu_dereference_check(cmap->cpu_map[i],
> +					     rcu_read_lock_bh_held());
Is rcu_read_lock_bh_held() true during map_free()?

[ ... ]

> @@ -149,7 +152,8 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
>  			       u64 map_flags)
>  {
>  	struct xsk_map *m = container_of(map, struct xsk_map, map);
> -	struct xdp_sock *xs, *old_xs, **map_entry;
> +	struct xdp_sock __rcu **map_entry;
> +	struct xdp_sock *xs, *old_xs;
>  	u32 i = *(u32 *)key, fd = *(u32 *)value;
>  	struct xsk_map_node *node;
>  	struct socket *sock;
> @@ -179,7 +183,7 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
>  	}
>  
>  	spin_lock_bh(&m->lock);
> -	old_xs = READ_ONCE(*map_entry);
> +	old_xs = rcu_dereference_check(*map_entry, rcu_read_lock_bh_held());
Is it actually protected by the m->lock at this point?

[ ... ]

>  void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
> -			     struct xdp_sock **map_entry)
> +			     struct xdp_sock __rcu **map_entry)
>  {
>  	spin_lock_bh(&map->lock);
> -	if (READ_ONCE(*map_entry) == xs) {
> -		WRITE_ONCE(*map_entry, NULL);
> +	if (rcu_dereference(*map_entry) == xs) {
nit. rcu_access_pointer()?

> +		rcu_assign_pointer(*map_entry, NULL);
>  		xsk_map_sock_delete(xs, map_entry);
>  	}
>  	spin_unlock_bh(&map->lock);
> -- 
> 2.31.1
> 
