Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714F7445B8B
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 22:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhKDVNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 17:13:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41770 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230162AbhKDVNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 17:13:54 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1A4GBTrv004180;
        Thu, 4 Nov 2021 14:11:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=zTQwCCF/TydqlKAjfLxRd69FX0SXskmBWJ3MopMIHvU=;
 b=lrFUlR6daChHbnXCm5kY/gspTjBdLKEu1EQz24hjhratWdkKZ4NHl9TullEGO8KUwemA
 wSfI9aR72v8jHtx7ByKpC3YvEnSQPSDchRlNK0H5TW4Ae4mexzbTfaRTcGsbxPK6xqew
 vksjJAPxIv/sdRhZ/1aWGw4ImuyxquCt8EY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3c45wqfkdm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Nov 2021 14:11:15 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 4 Nov 2021 14:11:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igJVb4qbvQ3mrxom4PHhLOLFB5mHnRVqWM8SGC6u1sYyv2/QeXrMxkkfXpHNDVIbeRBdefFc10U2BOKn0DM5UMs9uRXf/qEQJg9cPkZu1+1524FIjofbyak8Ms9bAWHZJmLkvi+FA0UEMPqoQKOxWKOKO8GgIg3nzguP67yg45RKI7A1xJWYiUAEDIYb0ZDeN8kM7/cXak7i0irjS2TJaRkyc92OV6Ap7pjO6WUS7oI7kyhFr4n1T52R5L0a+xR6tpzXsjPCI2sZYAGnGZof9OB+TLgIQDU8hhKMVixVvU+MRsgx3Vn6VW8oa+rgOAL0GWeoAWkP/AdZgPkLfUtlbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yLukex2qob3C1e+oav/m+cYwB+oRZaEgKVjAhurGSTA=;
 b=K4DPjhgMn9ONpnQXvx+ifSLsAyROhsnHaFoP4UmfdlFMppceaxf9Nq2iwjwJ+R+ISQwUxmTb7Qh0SQnDLECqFdyBRxLBlmLOXC8XaUXZPQiwoMqNVC7qn+BbmzcmyuHCkw04iAUQVXD2e/fFokhzdYMokWxOVJELaw/9mPIhL+Uyw/VH1wYcBKH2A9j0rf2chAUebvILJI0YZWBcHMmghrh02ip/bD7toR3yv/jIL3qpM7wAo8l/hLSHJfeFaPg7st/t/Y8O78HdiK/f/njwhf5Ydze9TZsYkk2BBRzYWsEw/VmbQ5UleTbvDNktbO2XqsIQKRTYs6DnG0eftlg/NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5258.namprd15.prod.outlook.com (2603:10b6:806:22a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Thu, 4 Nov
 2021 21:11:13 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953%9]) with mapi id 15.20.4669.013; Thu, 4 Nov 2021
 21:11:13 +0000
From:   Song Liu <songliubraving@fb.com>
To:     kernel test robot <lkp@intel.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: introduce helper bpf_find_vma
Thread-Topic: [PATCH v2 bpf-next 1/2] bpf: introduce helper bpf_find_vma
Thread-Index: AQHX0UmwYDsL5du11kO3TuvqOZ+VF6vz1O4AgAAJeIA=
Date:   Thu, 4 Nov 2021 21:11:13 +0000
Message-ID: <60072279-1775-4359-8E65-C2956D4BE8BE@fb.com>
References: <20211104070016.2463668-2-songliubraving@fb.com>
 <202111050424.dT5wiJAZ-lkp@intel.com>
In-Reply-To: <202111050424.dT5wiJAZ-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8f124a8-b314-4f55-7821-08d99fd7a1db
x-ms-traffictypediagnostic: SA1PR15MB5258:
x-microsoft-antispam-prvs: <SA1PR15MB525830D17232E7A0E840462BB38D9@SA1PR15MB5258.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E3PFmj4eLGHqM3dAik40YupdtX2/z0Qcv93QAnvTKPZX5CYPhevzyzowUhvPtHSIMB8Q81QmNX+plIAEQ1y9Rded7hrBHonANeOXC57AF0bFJEqCIuFONs8GXATfhMGe2I+qMbVe9zc75CEj+22+WONVbyaO6Bz/z9giHXh2zuXENaLZGiueva9RD/c3cWIBvQaZaTC8JtONH3bhtJb6FOSU+bNbwrNhJsSxxYyEgMHRwPCTe0blE/Eigg6yaF/m+cZKmlhfIG43dK0n0yCHgQ1FzssGRJlCj3pBssz1vmFVS0RYn2KwvzwTl9FgSVyXx0xJyhqBC0AxdDqzUB+neQF9N8EE0r2rwkTiTPSI8BUo5AX8+8M9/LT/jqJ1u6lIuhhQKZjjPQiJdn/cOGtFT8IescTar+sFbio9O8XzcVY7bI0IBGfDJsfuV1uLckr+5SwX0sDB7oEp0F7l5ogDOJ78kHkyolVEW3ZPN23Obs1HG2iaMc8m7Sm3LMsmWYjkpa2z2wfPy/ClT0f3HNOUoat5tsyOR4gZPH+d9PnGjAK2ZRHN/EaJTXp/nincpWavIAt6ZwAOl6Zt33i7RpYjYKnsv+qzCgYmRnvw7QaUtOXtVxWy+Ktawqt0kvO/34p0oc+bjv4Ym8qVO6f0Sbg4IhR6AcqpJTjnZbjmCKcdlrpDLFegBDMudFmha0j9Vys61wUkNt0iaSYVt8Nw1iFLkYKqSDJrQ/QTsv+g1YKlBn8FhkNWEL5WTHfzIZQm59oE/Uf6v0J0CG4ryC+xY3/24iBcWh3fJzpPYaE/ekLpnphofJDMvlar9qV+W22HCJbkxsjdmQkGJYkYvYCXz3XSmtuT1074dmp3usCNMPueQDe/hDpD4G7Pc7EwZZFnENpP7acyKh1idhpFnb3jXFeKnA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(54906003)(186003)(66556008)(66446008)(8676002)(66946007)(8936002)(76116006)(86362001)(71200400001)(122000001)(6506007)(4326008)(33656002)(6512007)(508600001)(38070700005)(966005)(5660300002)(2906002)(66476007)(83380400001)(53546011)(36756003)(91956017)(6916009)(38100700002)(2616005)(316002)(6486002)(45980500001)(1758585002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?chvkTwZPPYElD2nyQF3Q02y2iyyrwF/XDXQ5wjmkoHZsBnhzCPw53UrKQ32+?=
 =?us-ascii?Q?4NMb5rtLJAsygfh6fqxoKk/613h+W3APj0mcU/e4AH+9dZUjywDh09zZQ5Lq?=
 =?us-ascii?Q?pzy13dBgALmmuTmhjNkKI8bTdpcz9wyJ/EwqUY+oiaianRjqaGbpeug6/tX4?=
 =?us-ascii?Q?V4jpc9GMoFeuVMnK1mBM7ykOFkjrCHMNQn79T3d0l0P3Rjyp6xtoDgYMQ3Ma?=
 =?us-ascii?Q?08Bz7q80V/tdFrpiMO99jHCNQsZ997MSNrpA3/Ose98c9M2l2DgkLpTrvtIj?=
 =?us-ascii?Q?ae+IX0lOar647tVtuTAoPg4flRk+cfithWFwqU9g9PTpJDGbtKceRZnY5f23?=
 =?us-ascii?Q?WwnT3K0LAKjU2MfjW9nH94eiP3Kk2VyEhWx38d40jxQZJYHxsR81lY/g9gpB?=
 =?us-ascii?Q?WZr1wzhZ4ZgXJToDqCOzTzVHYX24q9a4jwrftcyJ9zcSaZTu26uKhc3O4/78?=
 =?us-ascii?Q?O2zY1cdU0yWxchQPNuYNWhlKL5dgVIaNPNjG31omEl9NOo642XzBnk+++ReU?=
 =?us-ascii?Q?E3NLLLsOCZT48Kl7P9ihIK2zp4YH+n/ydl3bvZ1jGcRp/Gw7Il5xuoEv+j3r?=
 =?us-ascii?Q?vCSBcFb0iw8BzFq2gVFUQzdhqUTcnO5zCGztMxdqQN6CwPG4Unyyk7tpTll+?=
 =?us-ascii?Q?2sSnoPOW4Gfca7eLKHumkOsp0lmxG686s15gv+4AQfNVei0ccgiBlizGkN45?=
 =?us-ascii?Q?ZbfyFMqxSmaEOiC4r79IaRlu17M/QjWSm2uAAtLqCBbd00IIxuQ5YTWmwEKC?=
 =?us-ascii?Q?Ue8Tg6OkQNPyvaoopZm8jJxnR4CKPMZlXiofxAHy8MBAgn2SWPYKX/aPAC2G?=
 =?us-ascii?Q?C+ejTrTrqVMPkz4zj++iLnO0SW0SkmbfxRmLiEwG2eIieRC6nA2p4BLc0pL3?=
 =?us-ascii?Q?cCP4YU5zSLoRRpFt9cdHRWI7lnotR6wvTHXLWCbV5e7bB+zDCJliHFGPDJil?=
 =?us-ascii?Q?tWq4+hHWjEmNCUTckxgrMWJ1c6d6mfs7s2LLJ5y8DYuwsYyQCJ4990UrkEts?=
 =?us-ascii?Q?I+dYLn9b4U7vqLoWVoCfnrudAqHZYD9v6rEW8aL2rjNQOcY0doWaYiCmaht4?=
 =?us-ascii?Q?TJxgdttut8XpQh2RwHXMyOjqJI7Ic0RYqeF31usmSFsnUMp1muJ5XXot1nCO?=
 =?us-ascii?Q?1wWoWgAF9yoBG2ij+H5SMurQ+11mQzyl8I8pl0v7C8q8j9ZpVsOXKwcspSf4?=
 =?us-ascii?Q?tXQ0JSX1ZCI7kIlZwJHYK6YSiFp69q3jm58fCKx48ix7niw2KFz2EWslPtTM?=
 =?us-ascii?Q?+oTtVUd0GABkPuGzdolyQfPp8owCvbVVr4/RX0XCdJJ+/dEbbamerR1pMseg?=
 =?us-ascii?Q?7JqCVIamOR5/bhJarGkBIRdawsxYP37fkS8Jrsl5MAVRpCyLEb1IyvBE9Pj2?=
 =?us-ascii?Q?8dpRbmRzbnuJ1fOuHXigZVhmA8kMn4ZXEpzD1qJLQcjS5ZJ1O0c/XdZbRuu+?=
 =?us-ascii?Q?0993Dappd2pt2FY/+EGg3nLI+APYgUxl5guLRaJjtv1tVx5q3kZ18vI3CVf1?=
 =?us-ascii?Q?AloJOMpb8w9UVhH1c84dUjnHHrQHk5UQqg+lpbRkyEqDXi1GORsA1nVavKEf?=
 =?us-ascii?Q?KVfSvp2+nbXBIoGWnUSUIspTkWfUBY11kWsKcXdQp8cnB97YHsFHOGAQ0nqA?=
 =?us-ascii?Q?LWW+L6Mi3Kp5UWuBo1ZuGUDFTxEOlsUKTVzmfJI7JwfzOR5bXwTM4Rr4PklA?=
 =?us-ascii?Q?8r6lSA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E3D8058BF0BF5C44942F8F842F89D7EC@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8f124a8-b314-4f55-7821-08d99fd7a1db
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 21:11:13.1268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N2Cy2UAObBUjq147O84J1lr7pKnT1v/Z9UERo9jbuYZlBNy57eiIfFCa1gunjOgwGoly8tV6Qo5vQZNDKy3X7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5258
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: PLg47qrhyNDJ0y1SMTNiqvcQBmJbjRAp
X-Proofpoint-ORIG-GUID: PLg47qrhyNDJ0y1SMTNiqvcQBmJbjRAp
X-Proofpoint-UnRewURL: 2 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_07,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0
 mlxlogscore=797 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040081
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 4, 2021, at 1:37 PM, kernel test robot <lkp@intel.com> wrote:
> 
> Hi Song,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on bpf-next/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Song-Liu/introduce-bpf_find_vma/20211104-150210
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: riscv-randconfig-r034-20211104 (attached as .config)
> compiler: riscv64-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross  -O ~/bin/make.cross
>        chmod +x ~/bin/make.cross
>        # https://github.com/0day-ci/linux/commit/e219efba8d04dede08b1d87fa1e8c5c01180caaf
>        git remote add linux-review https://github.com/0day-ci/linux
>        git fetch --no-tags linux-review Song-Liu/introduce-bpf_find_vma/20211104-150210
>        git checkout e219efba8d04dede08b1d87fa1e8c5c01180caaf
>        # save the attached .config to linux build tree
>        mkdir build_dir
>        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=riscv SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>   riscv64-linux-ld: kernel/bpf/task_iter.o: in function `bpf_find_vma':
>   task_iter.c:(.text+0x3dc): undefined reference to `mmap_unlock_work'
>>> riscv64-linux-ld: task_iter.c:(.text+0x3e0): undefined reference to `mmap_unlock_work'
>   riscv64-linux-ld: task_iter.c:(.text+0x400): undefined reference to `mmap_unlock_work'

Sigh, I didn't see this before sending v3. Will fix in v4. 

> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org 
> <.config.gz>

