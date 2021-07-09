Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C22F3C1F37
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 08:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhGIGHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 02:07:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65320 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230075AbhGIGHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 02:07:43 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16961C56000950;
        Thu, 8 Jul 2021 23:04:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=cSjjry3Yd9gyTuADo4vyvZsRsTpoC8n9umyJXQ9J/34=;
 b=LC01TPejbPWOUgxkshFAh6fJxVoGWvd5s9pLkwvdVJ/aGhjQJw/ma+ZCiAoKqr8ikCEt
 u/dffxyTjInO8Zh/2HlCC9XoGxMlnU3QRSPIMsOuxBmZbcQiqTFFaQYrBmrB9b71PQcP
 8gOUqwJJFdsrtq1xYCgwU5XuPLsXooxbDvY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39p39g4pbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 08 Jul 2021 23:04:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 8 Jul 2021 23:04:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PReLIYGlXcwGEwFQqqltK6+3rUg19dkebFZTjXCn3Dl1iATWPzcYkLJs60+xl39CENMTxoyNhM56TOv/Ul9AHuzutdfNNo8zSt0OXbjkRbTb2B6ciE29SymEJZ9ZjJg8SfYOJDcO9YuHjTzOG0eVOD1mqdzUecg8fTY88U9eX03P1/ww68Ra4tGi7K1vS6GBM97ItQiIonRZFbunzg63Oo/1bdxg3UJZ16Zb+W7zT2NuUCLbfW3tcuv6L8QFKXSz3PvUDCHsUebrWeLOPwqjZVTZiGSAURcxeiWNUHanSisl46N1Wmx1plJxoSEpOBsv6TnZFxj6Z+muxzHf+oPOtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSjjry3Yd9gyTuADo4vyvZsRsTpoC8n9umyJXQ9J/34=;
 b=kp1pB9/EjNISdPn0VBVAVLLyYjJKxhUhxPwK2AMI5CfiYL9yU2bvhHJIuwvhs1Vvhr4oOwjkRUsQCzqIuSJs0tdGdMaWCflHXXTTJEGET8CeBDS5A4ISNhQUzEOesFBdDhtyugnTiK3M8s9os/PEGqsu6FaawlgdLmLd8Hve0Zz7G5/X7BwqMt3x1tX5NBHya1aFQ8te+vNdM+q76CVz9vN/KryuDlbeOeg3U5pbwP4jXnDNyqmuUc4vQg9oCo4VR96On4j/GJp4DklroGDqlp4tbvKHCrgfeWfPDykW8fjUUERl6whyuj1/jzdT3eZ0Pj/bBapRWEqjSeUATWnn1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4321.namprd15.prod.outlook.com (2603:10b6:806:1ac::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Fri, 9 Jul
 2021 06:04:44 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%9]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 06:04:44 +0000
Date:   Thu, 8 Jul 2021 23:04:42 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <davem@davemloft.net>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH v5 bpf-next 04/11] bpf: Add map side support for bpf
 timers.
Message-ID: <20210709060442.55py42lmbwfzd4zx@kafai-mbp.dhcp.thefacebook.com>
References: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
 <20210708011833.67028-5-alexei.starovoitov@gmail.com>
 <20210709015119.l5kxp5kao24bjft7@kafai-mbp.dhcp.thefacebook.com>
 <20210709035223.s2ni6phkdajhdg2i@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210709035223.s2ni6phkdajhdg2i@ast-mbp.dhcp.thefacebook.com>
X-ClientProxiedBy: BYAPR02CA0066.namprd02.prod.outlook.com
 (2603:10b6:a03:54::43) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:2250) by BYAPR02CA0066.namprd02.prod.outlook.com (2603:10b6:a03:54::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 06:04:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bf29fe1-8530-4500-2781-08d9429f7300
X-MS-TrafficTypeDiagnostic: SA1PR15MB4321:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB432198D1B8DD11C1925AACE6D5189@SA1PR15MB4321.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hL9b2EkCFofjDiIrsoBiu7p8HKQJVVzo+jShwDkA18Pdiu8tc4+xgIK9jM5jzMqvFyO599Mbzy4ssICuGve8fyojLZfrl2kZSxge0tbfItxXN2HNEJyciH6E0UOTyopNiUMR8KG0gDHQyeTTHNt81EWyt2mRdBuswcawdtCuWFRW/0vAqbCa69KLugY3n+unuiaPuUa/AQTIYeUFiz7pOZdhWLKcEAUGkr0tCdR0Zx7doNEqCUNvtJw1/niWBlDyP2qV1KShz0j4uhhnja+3bbHEMGrZ18nJc5zScyMnN5v878eWQN121vBvnJjqrA9maA8QmuadLxGZM6Q9nYTErM051fXj+dvF58MqfTSet96QRueSGyfaFQr7IrnG8TcYhMYCSCkSMO0VYUhLMw9u+4YmE9o2TOICl4uN5q8ThBF9IGi4bMYmcFoZQu0jTWUqZDe7CiX0a69B1JZZonhsa3wBhUZUMM2vMfyMFThRYyoD0JxRxZxmYTDJwlOapIqgsJzbDQy6TGrESnvVbhfvb4W+Y9a01X9hRcXIZ5VCB3Y9CG8SSzZ8fMup7ixL0/6hwbKroF5urlhIEZdhnv2C5DVMUFjF4TCuo9EFWE+sjeQMUJKFPDq2pVbLYKm8eWGCyGAXQ+U9iAmosOa3gc/wsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(366004)(52116002)(55016002)(6916009)(66556008)(66476007)(4326008)(316002)(86362001)(9686003)(7696005)(38100700002)(2906002)(478600001)(83380400001)(8676002)(186003)(1076003)(5660300002)(6506007)(8936002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vbzBN2r9Hv30kZmsvELo8UsI+Xdm7Pg7qaRTKfmF/al/s9qrno4uI6ibn8HR?=
 =?us-ascii?Q?ejIu1YBBDZlRUQlyT4jApVDL5jhMbGK2wy0Pvfp/wMd+AYm27g63WqKMlKAd?=
 =?us-ascii?Q?H76QJZ9RSb7eqI/pSRuVI8rdrs3qA0PZDOapAvcdIqfISC0z8pEWmF8hUD0V?=
 =?us-ascii?Q?2CR5T7lY6XOgnh4oJGnfI53iMtZ108dzupc66s66vw82xoTi69dplpyKuO6A?=
 =?us-ascii?Q?u1AaYXBC+y1eXp3P0FTQjDQqvJMUbk2zjKUJcmczW6wN3sHY0nHuBaVnIp2K?=
 =?us-ascii?Q?XNLkYQdIKfJo703e5QCoNsA5mQitOCUiAQ5oU0YSXYFNEWyKUl2womPQNwwe?=
 =?us-ascii?Q?lDpy4Y/120o58ilD0547ap2HgOD3pCjiRWl+dMbLPp8pOL/cPkW59KW7OZOT?=
 =?us-ascii?Q?kz/DzN9KC7oiCOLhZnlO1Rl7sefl0kifWXEUFAlFcH8wyVRMX1TKlQWCZiXD?=
 =?us-ascii?Q?Hz8a0c0cI5qOBvL2dw9tVvwlvnY9Ju24XPIoDkN8DUPSRplvbMfrkauApmaP?=
 =?us-ascii?Q?M5kOrsRUByuqU5aQdjFY+9ZHRwdCCaIqgmCDBs4DKljAgI+KOHMfQP2G5CXe?=
 =?us-ascii?Q?fk8uw1FBmrVpsyC8tkt8Ryt4fRO7jCwGNMrVT1/1LWeCcbCGD8JO9ePgbJBJ?=
 =?us-ascii?Q?nm1PIA57tB1OlIlpbuiGgVQq8aBNheV6mgnVhvzuAuGc5qYJoP0rjZ3K5ujA?=
 =?us-ascii?Q?aAEBjGcL2VnDziAmjIscQ1uwFtJWOGi+xy54iOxbWp26nMIbN9zTwpZs+Wvy?=
 =?us-ascii?Q?U0+oVbrAhOYdksB5c2wNPJwlTA8ITML3L+7F7k6GpTMnGaymz9khJ2Jc5SAZ?=
 =?us-ascii?Q?JTzwyPlayi78yYXqE5YzTUa5lGyJfhQRJAZIGChdntEqbLcGQ2udcbF0qoI7?=
 =?us-ascii?Q?z/jFGKL374Mmk2DO6x1DHtPK6qCfMl74P6+PeOmE3/b19zMXb2EMnA3Aadq2?=
 =?us-ascii?Q?Av9N0HphaItFoOqqcD2vRnnYc8Jpy8BtO6TY/CcuPG1bl1R2Ih5EJxHM2PYY?=
 =?us-ascii?Q?Nq0H/RdvYN9WU7hhhbkoAM9Zx7sIIfr6V2tl0xPz2kSz7eELR0HjtfYNUrLY?=
 =?us-ascii?Q?E/n5ON1prn26YUddZTwevywtfXvYjafsv+Q749P0GyPzUqPI+mQuTgpDtPjb?=
 =?us-ascii?Q?hM94J6JMTZ6Xr5FuW6YnX7e6S5RknTJveEBqNO+v3tzDFQpGh62+XpgrZxle?=
 =?us-ascii?Q?WGSmDkgiMzF0BfcxwLv7SqVlsYk7eugWZMIBRS41Y/C7GVOYFg8NuD1T6Qao?=
 =?us-ascii?Q?bBpAFxmJe1myeSD2+UbKZLknJPWKGnQ4xApZGqimDBNqU5XxQyOrCvhug1B7?=
 =?us-ascii?Q?Pe1TSMHZFLRAoYMkhakfSDsR9NH1xNRrIrnydnCXKuacTA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf29fe1-8530-4500-2781-08d9429f7300
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 06:04:44.7573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4gYcIA0YrDxXZfBT37jVzbrxcMkLPS3GVKP5LANmDJ3qCcqJmfzqStGWb9K8XdrE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4321
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: jxzS7Lb_cYlZrn3km_QFp-cN-v7emlW4
X-Proofpoint-GUID: jxzS7Lb_cYlZrn3km_QFp-cN-v7emlW4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-09_01:2021-07-09,2021-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 impostorscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2107090029
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 08:52:23PM -0700, Alexei Starovoitov wrote:
> On Thu, Jul 08, 2021 at 06:51:19PM -0700, Martin KaFai Lau wrote:
> > > +
> > >  /* Called when map->refcnt goes to zero, either from workqueue or from syscall */
> > >  static void array_map_free(struct bpf_map *map)
> > >  {
> > > @@ -382,6 +402,7 @@ static void array_map_free(struct bpf_map *map)
> > >  	if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
> > >  		bpf_array_free_percpu(array);
> > >  
> > > +	array_map_free_timers(map);
> > array_map_free() is called when map->refcnt reached 0.
> > By then, map->usercnt should have reached 0 before
> > and array_map_free_timers() should have already been called,
> > so no need to call it here again?  The same goes for hashtab.
> 
> Not sure it's that simple.
> Currently map->usercnt > 0 check is done for bpf_timer_set_callback only,
> because prog refcnting is what matters to usercnt and map_release_uref scheme.
> bpf_map_init doesn't have this check because there is no circular dependency
> prog->map->timer->prog to worry about.
> So after usercnt reached zero the prog can still do bpf_timer_init.
Ah. right. missed the bpf_timer_init().

> I guess we can add usercnt > 0 to bpf_timer_init as well.
> Need to think whether it's enough and the race between atomic64_read(usercnt)
> and atomic64_dec_and_test(usercnt) is addressed the same way as the race
> in set_callback and cancel_and_free. So far looks like it. Hmm.
hmm... right, checking usercnt > 0 seems ok.
When usercnt is 0, it may be better to also error out instead of allocating
a timer that cannot be used.

I was mostly thinking avoiding changes in map_free could make future map
support a little easier.

> 
> > 
> > > +static void htab_free_malloced_timers(struct bpf_htab *htab)
> > > +{
> > > +	int i;
> > > +
> > > +	rcu_read_lock();
> > > +	for (i = 0; i < htab->n_buckets; i++) {
> > > +		struct hlist_nulls_head *head = select_bucket(htab, i);
> > > +		struct hlist_nulls_node *n;
> > > +		struct htab_elem *l;
> > > +
> > > +		hlist_nulls_for_each_entry(l, n, head, hash_node)
> > May be put rcu_read_lock/unlock() in the loop and do a
> > cond_resched() in case the hashtab is large.
Just recalled cond_resched_rcu() may be cleaner, like:

static void htab_free_malloced_timers(struct bpf_htab *htab)
{
        int i;

        rcu_read_lock();
	for (i = 0; i < htab->n_buckets; i++) {
		/* ... */
		hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
			check_and_free_timer(htab, l);
		cond_resched_rcu();
	}
	rcu_read_unlock();
}

> 
> Feels a bit like premature optimization. delete_all_elements()
> loop right above is doing similar work without cond_resched.
> I don't mind cond_resched. I just don't see how to cleanly add it
> without breaking rcu_read_lock and overcomplicating the code.
yep, it can be done later together with delete_all_elements().
