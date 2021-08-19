Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8167F3F0FF4
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 03:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235449AbhHSBWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 21:22:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25456 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234194AbhHSBWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 21:22:34 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17J1F4Np006176;
        Wed, 18 Aug 2021 18:21:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ZeBRW6bClWldC/zAc0ELJ/OT3xlOzgvzh11QqwJMQCI=;
 b=b+aaXJV5YREh2qAomw4heaBaFwQacP6ECBPdiVXzjPceadOU0Yv0VN4u6wNSG9DIRcJj
 NgqJASaDGJdSWD9pNabOQaFf5R8/fmIDT1bcc8tm64632JY9nF333pZVDFR04aQf086z
 6iN9lp/VHW/xn5VaPQlFPfXOzXNHAwckdFQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3aga68mnq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Aug 2021 18:21:40 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 18:21:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJ3QtaXsRAoTvhWnLmEtOF532uE0LmsUBP6gWlhHgofmAlkhshXSNZFdEhcJPGrhHoAHNw7NQdlxY3pkWcZa5PK3u1lvV90KPf3A2nH4O50OWCAZZeuQDK72Kd7aWrs9CsgJ4B1xoZllsB3f6wNrAZD6FhzfHwAkK3HJ1+CqI5XxaTL9tdcNse2HZPm+AKYdjtuHWBQJ5fgoOblxbmSIqK6+WJiuqWKUnwe1h/yPSwQFCs3ytu7l93WN/Gor/LZtaLEFK+xXwdqCAwz6yHrhgfv0CieCQs8ojnP+9ZJZjOaXApAHHQIMI5y1bx6XEGlPIe9vKsMAbSeYt9j9QKkQSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZeBRW6bClWldC/zAc0ELJ/OT3xlOzgvzh11QqwJMQCI=;
 b=nXX1U7FW6ipMF2lnNm00ApxYNRdgSYI11dsMier0GeLSD9fuWJWu6325Y+9r0Xw9TeYHQ/MyppiH735tQjAl/5AZEd5kSSS3t9wtcNMM6+RIGqLPpEjfz3gwxAL5t5poMZjWsAW9SxKvRdCqDD2oObZi1I4Y5QgJ46hr0fxIsf7e+lXHtEUkEYypoYSomEwGieZbIoFYxKy9F2FxZyaV03AKn6p+rK11tmKkQF+n7Sh1eO9UgIE4AtdlKGBrgQeU9IAdIkKEKI5Cy/VhVKI50GuuY22BsSA5PqtM1UeSSJi4bkzRr86nO6K5yx6CxH8SKiughYbnKdm0HYHUgFi9eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8)
 by PH0PR15MB5086.namprd15.prod.outlook.com (2603:10b6:510:c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Thu, 19 Aug
 2021 01:21:34 +0000
Received: from PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::51d1:4986:40f3:3676]) by PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::51d1:4986:40f3:3676%6]) with mapi id 15.20.4415.024; Thu, 19 Aug 2021
 01:21:34 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Li Zhijian <lizhijian@cn.fujitsu.com>
CC:     Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "philip.li@intel.com" <philip.li@intel.com>,
        "yifeix.zhu@intel.com" <yifeix.zhu@intel.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] selftests/bpf: enlarge select() timeout for test_maps
Thread-Topic: [PATCH v2] selftests/bpf: enlarge select() timeout for test_maps
Thread-Index: AQHXlJf7aE7OyDa9OkSTbjlwzuuuxqt6B+eA
Date:   Thu, 19 Aug 2021 01:21:34 +0000
Message-ID: <5FF586C4-7FF8-49EA-9F3B-A2D210271915@fb.com>
References: <20210819011506.27563-1-lizhijian@cn.fujitsu.com>
In-Reply-To: <20210819011506.27563-1-lizhijian@cn.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: cn.fujitsu.com; dkim=none (message not signed)
 header.d=none;cn.fujitsu.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b074d41-8823-4b80-72f2-08d962afaef5
x-ms-traffictypediagnostic: PH0PR15MB5086:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR15MB50866D975FEC0AECD05E4A94B3C09@PH0PR15MB5086.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LLCQtvwV68wtSc44Ofx8oWxqSl9xowKqS/ESkv0bAfJ/KK8L3bzd4LXdCpDP50YGPl1DV0Q7tSpNA+7xrvhcO8rV9eQT4mmeHaGo7IRJq9radcIZUJsT7A1G5PI2471JI7DFE1PZa+fRwcpQ348CY/TaniffKoEHFQ9qfFxp1YK8yg32/RWKb33QaCdHrpQvmzZ8Y74qGm64JlgYdHglNz6XVxF3j5aCYFYpy3t2+E1tM6+Sez8bVgiBMu77E09qe5qpUwxi6Apre3aWsZROj9ljULHbXvX5V1MsnfIJ1Rs21ZCxMhtv6xM9T5ZokM3BsNKthsaClKbJz/AsxT1loSzFYNCJeqPBJjnzqvyQRSMsbMOEqpJGC7qFqBZXPjpHD/pfe8mvr0sqh0NFB4d8FHAT3ChUH+yE7P4pKRInu9gs8NTRRpVXdZRU05UtWoPJGbHWq1GDvRnmgIzDI1ID/4lb6qpsCiUlJRAi8vDpHsDEkEm4hQQ7ByhC92fV7OhnMNLpTYt9bADKzAepww1GX9sA66SIF+rnqtVMcSSQQJkEW12wB9gazim57RlowG2JMHQ63cd2GMTrUYMCupkvx31HSeXdX7+xLesR6Hbcgi7GkUBSvSquMSc+1B/dpvmsQdQDUicoBRo0r7BxTK0NtRpDjU1iPlLs9TFyxqWyafUdpENT4rpj8H9Y7rVF5zFuOx12nk9F4RHD/Te5zi8V3h4HCnhJzEZvEZKoCRBgBMDDT1gxwTChapkECmCgqbr20UbrjDqn0a7DAWmtfdVCk8+b328Ru3dx2NeSxsjIoOs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5117.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(66446008)(64756008)(66556008)(76116006)(66946007)(66476007)(7416002)(478600001)(6512007)(2616005)(186003)(86362001)(8676002)(36756003)(5660300002)(6486002)(38100700002)(33656002)(4326008)(53546011)(6506007)(2906002)(8936002)(6916009)(122000001)(38070700005)(54906003)(316002)(71200400001)(83380400001)(161623001)(147533002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gUoTXvEkm5lkhpMIKgTugF5XR0gTJlpI1Xa420HK2fMtw70OONP6hlaLs9So?=
 =?us-ascii?Q?YhLNXkOZ348EP9g2ANUP06vLvXFYy1YBHtcbYYz5Ja49HPMgD1Eh43zt1cQP?=
 =?us-ascii?Q?hP2zyv5JjznCEKcSHVIBl2MW57q1vb2Pm/tjCZzP5vlbb08GSt3sQ1TIfkW2?=
 =?us-ascii?Q?W6YSzZIfEEhEKDStCrcJQkgPEvb8TvDg8hgwpLPmDtu9umqGZiM79dBHmfs/?=
 =?us-ascii?Q?HotT8WKnFhw8N0yaXZDha7BlaSH9WNT4eo92pWUuEm39BEbn0SlVFzIpICGM?=
 =?us-ascii?Q?C3MjA+YquFT/qoxK0AvnsiqG+2CiBbrKQk7pKGxrd0uT66xmEzeyUnA5DEfN?=
 =?us-ascii?Q?/mEiyZBim3BIpIpCkabp2S/ZSfF+sBm7eilgVC8bsFiJWKDLXh+F6NbZm4qU?=
 =?us-ascii?Q?MzIPUvvja1fjmk7tWlftgfviTgQNT6OAyNbdgXAe+i/MdJJ/sqxDX/2yOF5C?=
 =?us-ascii?Q?cIzwRgFUywmSDgMOOwU4zDCjK9SQmyFgwFCa2sIHFiyxAknnlF8FsjrOo0hU?=
 =?us-ascii?Q?2n8g9YjsI41kvVDd38B8mMCIKPyb/2zCnLseHHBLsTrlN6G0S6tCi+w1SZOz?=
 =?us-ascii?Q?BtXmuxRYsW1RAMb4maRsJ5tx7PSdOWoqZlU/RiVSnGbuEJLcGaYTuSbaLGIy?=
 =?us-ascii?Q?qsAo4GSqXLouo/r/VxrzgEO4FcweG6fK//e6pbKKPnh1szOcpA6TVCEdD6eQ?=
 =?us-ascii?Q?IyVlUe7WExG8zYK+Rp8utgx1MxUI0EnJEBDtwkEq0kkAdUcmoeewWY+N4vTR?=
 =?us-ascii?Q?2lSzqg910SUm0tV2wQTS8KYsPcWGYpChqDOLfe2EUomVBy244/sbEjf8Jcpt?=
 =?us-ascii?Q?bakO+MiG8eccJfsliolNwGHfwqeQZ0ch4R8cRIccU6/aqV20MhPMEXtz+GM1?=
 =?us-ascii?Q?ktm8B7OiehQGshy9Q5ijPLAD2HZVHg/GVyYglUU8Mm2Y+MbaC43WRIwveCBz?=
 =?us-ascii?Q?uonnV2xNtkT2VNfbuwwoeo/wpZeu/t98GvphimyY0+R0AcXvVxO/YnPmi/h+?=
 =?us-ascii?Q?WTj93iD5twJ69F/aZWUrTzn0bMjBhz9o3EDLjoEDWhWWgEzs40ehFysrCxHE?=
 =?us-ascii?Q?cVgukfxlo9sPQYvyGjOo8WlMub8yuYU4wGZ/46mLv3b9936AnD7GFPK7gxyP?=
 =?us-ascii?Q?4LT7FmtbLs0jCugC16RzC0f4FI5gVoK62sO0jhXKniGLqMMqDYa53+eeGUaB?=
 =?us-ascii?Q?53VLg2yHfXhSI/DoKf1FkX2OS3jktO/hKjSt6z1sjSyssae/vClxUtzCaITP?=
 =?us-ascii?Q?nAJlIoLPEGk89tUb+pS16zlUgH35FzV9+343J8TrK5FIj0YvJswDFzoD3NTX?=
 =?us-ascii?Q?K3cyqXtz+hU/t7BSldJVpHSS4j24KvMdUozZz5+FB7/M/yl0PJXKDxjMf9BZ?=
 =?us-ascii?Q?1zPc79E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E6742AD26F28F94D9FB7EA1F9092500C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5117.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b074d41-8823-4b80-72f2-08d962afaef5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 01:21:34.2172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NQaWWtmNfmU/MLZL6Oi+hFNewzDhKUg+NbgisFCzV2CEGcia1qCcO96GY/7tRvpkosc9qYw+NfiYId1zyo4dDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5086
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: dJIcx1PhS2wMEfImllqH4O1mWP_-DlqH
X-Proofpoint-ORIG-GUID: dJIcx1PhS2wMEfImllqH4O1mWP_-DlqH
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_08:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 clxscore=1011 impostorscore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108190004
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 18, 2021, at 6:15 PM, Li Zhijian <lizhijian@cn.fujitsu.com> wrote:
>=20
> 0Day robot observed that it's easily timeout on a heavy load host.
> -------------------
> # selftests: bpf: test_maps
> # Fork 1024 tasks to 'test_update_delete'
> # Fork 1024 tasks to 'test_update_delete'
> # Fork 100 tasks to 'test_hashmap'
> # Fork 100 tasks to 'test_hashmap_percpu'
> # Fork 100 tasks to 'test_hashmap_sizes'
> # Fork 100 tasks to 'test_hashmap_walk'
> # Fork 100 tasks to 'test_arraymap'
> # Fork 100 tasks to 'test_arraymap_percpu'
> # Failed sockmap unexpected timeout
> not ok 3 selftests: bpf: test_maps # exit=3D1
> # selftests: bpf: test_lru_map
> # nr_cpus:8
> -------------------
> Since this test will be scheduled by 0Day to a random host that could hav=
e
> only a few cpus(2-8), enlarge the timeout to avoid a false NG report.
>=20
> In practice, i tried to pin it to only one cpu by 'taskset 0x01 ./test_ma=
ps',
> and knew 10S is likely enough, but i still perfer to a larger value 30.
>=20
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>

Acked-by: Song Liu <songliubraving@fb.com>=
