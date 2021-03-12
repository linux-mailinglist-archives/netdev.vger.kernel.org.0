Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F97E3397A4
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 20:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbhCLTqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 14:46:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59094 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbhCLTpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 14:45:33 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12CJiZC8162633;
        Fri, 12 Mar 2021 19:45:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=QQIquXwa6kk1chwpk6IZzaqh+G2O2OocEhPqyq0K7C4=;
 b=gVQ0OKhCJnVwGD2byrNJk+EgWDwBDoBQvggA5ghIPrmK95pR4NukdIp2x8Qgjy5wSmv0
 7IdrxltT7GYTWG6S8C3Plu1AolZFO7VyAIwQ6mzyO22BYwRMnN5ph29k0Bv7ptYRyHeE
 RT4x+9IWSPGkaFAWGE47AoSaiUK/taP35WM+jUNev9lldV0vqTTQdWI0/xvpM2IO2vG6
 n64DK3T6yle+ruPbGCRF7jZol8NAR5DycrrLRul+N5Ak+RtR7IjKlOtsPiSIN3KgsiiZ
 ni3QlRmU9E54CggpFTUmLC1nolRAE0AVoGeTjJsDzWYipkrV5E82LRBH/TTLQHpn5eJR NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37415rjx3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 19:45:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12CJj2Xn075046;
        Fri, 12 Mar 2021 19:45:06 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2040.outbound.protection.outlook.com [104.47.74.40])
        by userp3030.oracle.com with ESMTP id 378cdc7pvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 19:45:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcAXR60BBney4JmbI86kB650hqXwj05McOV/C69JkdqUJi/uxFG9YV+mNfOlk0UNM83F4XmFIi+58xq2DF2M1yKefn6DEYGyRQm59MNqc8Z/ZpUxSgA2gKTPUT/a7rA5afq99ofEmUryFbnqMgKe9s4HVzCiczSkn4uqM4TCL9z+4J++ov7YpF5bjHnx9zXq1obxYloFKt63PfZ4tp5AHUGtZEeZOPp9byvkNNlTVR4uh4hU5lFVLh7r4AsPVuAp328AXwl+pMi9OxgWhoAzsYIzqxJLdVNJFvzP1jpso9q9tpJ/LzRLfQmPNhwJ1968U9Yk2vsHZZnsIMvHRqtT4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQIquXwa6kk1chwpk6IZzaqh+G2O2OocEhPqyq0K7C4=;
 b=aeZJQe2DUUfD74DSvbVdaXHEpeeMtkkgC3IO0wbjZfyCcMoLOerhdg8dmUgS1TVRCL2r7JnzJtoyD9yr4TjF/fOBmGWlqmlYWGhBxUugY6N76d+y72C/UUKya8bmT1quHiSiZeiL6nXUvWfOuTJS+SzGRpKfF/vvT/XRylND0auwJK7whqRXlINJJfxMa1xavvImXvtAnMBuhPEG1HHR2wclOHp5XrPXu1sr3wcSfzYMKbuKY50NAaYg/fSXHQKV0ymQ9+tq/8GpiHNDLpyx/pPye3DNYEahvej5e4/+josukLiLIzCO+VE26UrxYl83zEaR/zvVuB/zBSHrBmCBrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQIquXwa6kk1chwpk6IZzaqh+G2O2OocEhPqyq0K7C4=;
 b=SQ4JvgCsyupqfJ86LVNDEPScnFeGWzDZJTaijtRzMkxTEhdFllonVrB6b5AWLQtE8FynEqUuhAWNiHU6gNOKbjdIFhP6d+LpZfdRNfse43WKvksXgItjNSvlggNl8KmOeR0IPx0EPcugEhkNV1r4Uwfze0AwqSAAlkd5s9LFYa0=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BYAPR10MB3383.namprd10.prod.outlook.com (2603:10b6:a03:15c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.18; Fri, 12 Mar
 2021 19:22:43 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9%4]) with mapi id 15.20.3933.032; Fri, 12 Mar 2021
 19:22:43 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Mel Gorman <mgorman@techsingularity.net>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 5/7] SUNRPC: Refresh rq_pages using a bulk page allocator
Thread-Topic: [PATCH 5/7] SUNRPC: Refresh rq_pages using a bulk page allocator
Thread-Index: AQHXF1tVdfZNbUNlaEOVbp5QB1YPQaqAsKcAgAAKxwA=
Date:   Fri, 12 Mar 2021 19:22:43 +0000
Message-ID: <17DF335E-9194-4A16-B18E-668AD1362697@oracle.com>
References: <20210312154331.32229-1-mgorman@techsingularity.net>
 <20210312154331.32229-6-mgorman@techsingularity.net>
 <CAKgT0Uf-4CY=wU079Y87xwzz_UDm8AqGBdt_6OuVtADR8AN0hA@mail.gmail.com>
In-Reply-To: <CAKgT0Uf-4CY=wU079Y87xwzz_UDm8AqGBdt_6OuVtADR8AN0hA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17d4aea3-6277-4c5d-6921-08d8e58c360a
x-ms-traffictypediagnostic: BYAPR10MB3383:
x-microsoft-antispam-prvs: <BYAPR10MB3383D17F6EE50ED5580B6913936F9@BYAPR10MB3383.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DdPJLrk/WyGcJd7SioMLXFpuCL5VNsTMZjmOWltYueTMXbwOo7J/EDIVztxn2FYmznxyVe+FG/rj9yzV7GeBetrKtdSZPmUf81fMxiucfT+UOov4xPKWup7nsmqYma8DypSWxfZr4Us+qte/wObi0T5K+KXHUXhbGkUQ8CCNoQ1PROxbRqRR4sidvQQMJj0ps22PaMcqIHcnAtVVyxYyrxGuMWnA+r/EYtND7eEBuRW1QjC7YR+0Hmz5BflN8qgDs1Sho+AquijAOphI5V8MyRa/X0hF+MkQF2/oaywrmiGN5Ou5PwkADAEvMGnje1Qb6CtFWOLZ02FZ7H491b2P/QgBAtcZlPLKs58Da7cuQiG8CEcMqpcwYE3kL9j0+vM9DBVp6pt5zabtbSnMM3b2AW5vxTNwoeklKxSyUc/UgJvtjLQjxxEQgIOiZ+8FjA0rRJ2fJlAfkDm+ihqzC/mHyepHKO2Y9zXsn8O5mz7kwys7Hmcnmu64WMmUmAcEHrHjAJeS1pRer7398Ulq1hf7ErW2yheHftlQqISFkIRcTlyHG6QzbKqwqkru4KtrqJZB9FW7EkOnJFegyV2WlexhbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(136003)(396003)(346002)(376002)(91956017)(6506007)(66476007)(76116006)(71200400001)(4326008)(66446008)(2616005)(64756008)(66556008)(83380400001)(36756003)(316002)(8676002)(186003)(5660300002)(66946007)(6486002)(478600001)(8936002)(53546011)(2906002)(26005)(86362001)(6512007)(33656002)(7416002)(110136005)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4/fpBjFtQPZg9aT24kz+09SMpBsqlqighqsvOeAJaAKCYEcl341BqCnU/mRd?=
 =?us-ascii?Q?2sLwUGKOeclNXckTuE25/E5MTWMAvJVUB2Hz4QhieY6svOfle6qldiwEjSOX?=
 =?us-ascii?Q?Q0MdWI5izRjcrftauveuQyoMYEpUivYbjqaurLI4tfv8h8IPVmFn2nas2GOL?=
 =?us-ascii?Q?Npy+/HoEfLaz75GdzvUWEQ8G9VH4WWbD7YTosefvM1YMVWPRSgGC1rIPhewN?=
 =?us-ascii?Q?7/pangLgKgcYBo0LERDrV8ZW3fi3AGtroiKcKfJoY/kL4rslrwOZRoOzsmiz?=
 =?us-ascii?Q?ozuGE1qmsHp1D/od5liSGFfWDJcG+NvrL4RgP5Yrl84hzLFSM2Fiek9oaoTW?=
 =?us-ascii?Q?leYUg5NFG3hluqn28Vv/M23fJgidPaKHuwPn9Fll9cDHeyre5cOy0EZ2Q9BC?=
 =?us-ascii?Q?MVbtTB9TkwQ2+QVI6OXvlRBvUlCuDzjI6RWQ3Ma2zAT7r+LAMuwtD1n1nxQM?=
 =?us-ascii?Q?L77z0k3Ucnaanm1b46GD1CKLjzDylf16whOol6oWkA8ZqazbJGtTGOZ7rCfv?=
 =?us-ascii?Q?OBqVC+zp5GBgm/mo0NgAJzTbuFLCKcitfC/iBugHZ5aN7affmX7JSMUtfony?=
 =?us-ascii?Q?ICqxdQA4wFHk5ABG97I5NBufyfGnQL40JjgGqmjF0FJmSm38lUu+a3IGzYEh?=
 =?us-ascii?Q?Nsh/6ArO/bKnRe/IANDJVd0b23/gEgnyE/WfvlQUacaKr2Pkw7m2xz6JVxxn?=
 =?us-ascii?Q?PC4bVauJEPUpimrsLPh7cK7xCQm0WnKrEKhIS9X+3KgAJyFVq+kTSHbj2wiR?=
 =?us-ascii?Q?/iA9xU28ubuT1wADIvIpykr8zo7c5lK5U0QRZuc1TjPs4ZXxmhI0aMIpAHUb?=
 =?us-ascii?Q?sFiHpkuki0FPcSjUm9t04K9JEycVgKA1Tb961gSyLI1EKvHN2mnHIBENnuoc?=
 =?us-ascii?Q?WzjwQD7kuz+hyhCWc9+qoKAtH+sfITbllv0rQhORJfvNwd/HU4WOzpIsOUQV?=
 =?us-ascii?Q?Kr3rGDG93KVyJlqc+ihYtRaLMXxsiCSD6kiz8Jhmu8DscYxaLfLpQkUQ3t5g?=
 =?us-ascii?Q?FAmpcTUzq7tV2/W7yq8bYAZebfBm9boTWvI+WD4dLi6nRbvl8j88t/7FPKrN?=
 =?us-ascii?Q?YKm5hAUA5myoIQ70RqH8jDlgip/bIFeGkNtJHMcQBnNErsJpU0Mk/gzRajSe?=
 =?us-ascii?Q?JZ0v1QDx3Vall8xKRMeeELa6Onq/wi3y+SkcXiubRPeR+7UfkRKCtneHp6fM?=
 =?us-ascii?Q?5vDIzQp9Q0p/EIFIiqEYhFni0RZtfZZ5ZFZZHmU4lUSH/UBOtPqZKqBWvJh+?=
 =?us-ascii?Q?Vz5+YucDUPe6IlwnL5fUrYQZWL52LuUQOTyAi/1YqJVerZvsXOFX7fIV+nm8?=
 =?us-ascii?Q?qgQdByuHX7sOmduFB3oUHY3b?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <680E2CC1CA140141BBEF26EAF6B563E1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17d4aea3-6277-4c5d-6921-08d8e58c360a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 19:22:43.3816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZZGNfIa2ZFnVA0JPfyZm0qKWHhF2WFXBTa9bq8S61+M82ePBZ+wjLVg8C2PIHq+vqR3fkMUbLPP/CM6ksnsS4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3383
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9921 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103120143
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9921 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103120143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mel, I can send you a tidied and tested update to this patch,
or you can drop the two NFSD patches and I can submit them via
the NFSD tree when alloc_pages_bulk() is merged.

> On Mar 12, 2021, at 1:44 PM, Alexander Duyck <alexander.duyck@gmail.com> =
wrote:
>=20
> On Fri, Mar 12, 2021 at 7:43 AM Mel Gorman <mgorman@techsingularity.net> =
wrote:
>>=20
>> From: Chuck Lever <chuck.lever@oracle.com>
>>=20
>> Reduce the rate at which nfsd threads hammer on the page allocator.
>> This improves throughput scalability by enabling the threads to run
>> more independently of each other.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
>> ---
>> net/sunrpc/svc_xprt.c | 43 +++++++++++++++++++++++++++++++------------
>> 1 file changed, 31 insertions(+), 12 deletions(-)
>>=20
>> diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
>> index cfa7e4776d0e..38a8d6283801 100644
>> --- a/net/sunrpc/svc_xprt.c
>> +++ b/net/sunrpc/svc_xprt.c
>> @@ -642,11 +642,12 @@ static void svc_check_conn_limits(struct svc_serv =
*serv)
>> static int svc_alloc_arg(struct svc_rqst *rqstp)
>> {
>>        struct svc_serv *serv =3D rqstp->rq_server;
>> +       unsigned long needed;
>>        struct xdr_buf *arg;
>> +       struct page *page;
>>        int pages;
>>        int i;
>>=20
>> -       /* now allocate needed pages.  If we get a failure, sleep briefl=
y */
>>        pages =3D (serv->sv_max_mesg + 2 * PAGE_SIZE) >> PAGE_SHIFT;
>>        if (pages > RPCSVC_MAXPAGES) {
>>                pr_warn_once("svc: warning: pages=3D%u > RPCSVC_MAXPAGES=
=3D%lu\n",
>> @@ -654,19 +655,28 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
>>                /* use as many pages as possible */
>>                pages =3D RPCSVC_MAXPAGES;
>>        }
>> -       for (i =3D 0; i < pages ; i++)
>> -               while (rqstp->rq_pages[i] =3D=3D NULL) {
>> -                       struct page *p =3D alloc_page(GFP_KERNEL);
>> -                       if (!p) {
>> -                               set_current_state(TASK_INTERRUPTIBLE);
>> -                               if (signalled() || kthread_should_stop()=
) {
>> -                                       set_current_state(TASK_RUNNING);
>> -                                       return -EINTR;
>> -                               }
>> -                               schedule_timeout(msecs_to_jiffies(500));
>> +
>=20
>> +       for (needed =3D 0, i =3D 0; i < pages ; i++)
>> +               if (!rqstp->rq_pages[i])
>> +                       needed++;
>=20
> I would use an opening and closing braces for the for loop since
> technically the if is a multiline statement. It will make this more
> readable.
>=20
>> +       if (needed) {
>> +               LIST_HEAD(list);
>> +
>> +retry:
>=20
> Rather than kind of open code a while loop why not just make this
> "while (needed)"? Then all you have to do is break out of the for loop
> and you will automatically return here instead of having to jump to
> two different labels.
>=20
>> +               alloc_pages_bulk(GFP_KERNEL, needed, &list);
>=20
> Rather than not using the return value would it make sense here to
> perhaps subtract it from needed? Then you would know if any of the
> allocation requests weren't fulfilled.
>=20
>> +               for (i =3D 0; i < pages; i++) {
>=20
> It is probably optimizing for the exception case, but I don't think
> you want the "i =3D 0" here. If you are having to stop because the list
> is empty it probably makes sense to resume where you left off. So you
> should probably be initializing i to 0 before we check for needed.
>=20
>> +                       if (!rqstp->rq_pages[i]) {
>=20
> It might be cleaner here to just do a "continue" if rq_pages[i] is popula=
ted.
>=20
>> +                               page =3D list_first_entry_or_null(&list,
>> +                                                               struct p=
age,
>> +                                                               lru);
>> +                               if (unlikely(!page))
>> +                                       goto empty_list;
>=20
> I think I preferred the original code that wasn't jumping away from
> the loop here. With the change I suggested above that would switch the
> if(needed) to while(needed) you could have it just break out of the
> for loop to place itself back in the while loop.
>=20
>> +                               list_del(&page->lru);
>> +                               rqstp->rq_pages[i] =3D page;
>> +                               needed--;
>>                        }
>> -                       rqstp->rq_pages[i] =3D p;
>>                }
>> +       }
>>        rqstp->rq_page_end =3D &rqstp->rq_pages[pages];
>>        rqstp->rq_pages[pages] =3D NULL; /* this might be seen in nfsd_sp=
lice_actor() */
>>=20
>> @@ -681,6 +691,15 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
>>        arg->len =3D (pages-1)*PAGE_SIZE;
>>        arg->tail[0].iov_len =3D 0;
>>        return 0;
>> +
>> +empty_list:
>> +       set_current_state(TASK_INTERRUPTIBLE);
>> +       if (signalled() || kthread_should_stop()) {
>> +               set_current_state(TASK_RUNNING);
>> +               return -EINTR;
>> +       }
>> +       schedule_timeout(msecs_to_jiffies(500));
>> +       goto retry;
>> }
>>=20
>> static bool
>> --
>> 2.26.2

--
Chuck Lever



