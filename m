Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407F249457B
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 02:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344950AbiATBVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 20:21:05 -0500
Received: from mail-dm6nam12on2046.outbound.protection.outlook.com ([40.107.243.46]:51216
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344114AbiATBVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 20:21:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVxsCbgjoz/d2OYBB3oD9tXHRB4xzvKRA2EGJm5s2AqxMKRlttJ7hu4sMAM4CwGQy/YJ66MO3l5UGiAaU1azUi6SRG1uL6jH2szMdS/AXiiuhL90K4U+yPA+eapoHak5XNl0f0rYBl11kk+zmNnp4Kx0tI0VrCs9I4bUtxDUdexppmLJEFHUFxL4cN4xFn4T9Ma+qqX2BnOIIOMgfG0EBF2qDtzYUaj1DD7yKgiI4uIpuokOCTt/ohEtHPVp0/8hFqGGyayG4f7rE2ZrFNgcVqb1GrNOjcGqisa18x7qR18YF9LhwawDOi16vSm+m/KCe01D6SDFuM4I7DBxgLWLtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pbTqnzyO0Rs/2I3ICXZzgTul8NQ7Zu4IhThSIY2uumw=;
 b=avsaPq1cWdDULJgIMs6SQTq8piMyz49il0WE+G1XuyQ3XCbD7xkewaJj6lnTvFwJIoz2Eocap2U1YmumnRXnOy5dGE21zHHY44WRL6Jff48e7Cxfx96M4lezHa3VgbVtrMqQeaBJ3Gq6J2u6s3f4WVNV8oQhTmF+q7TVnzxyXl/dJ/OOPfY6b47l0PGuBLovhgOgMcLKoSjmYA3eKTrDpKHx9KAUB1uP6oJTM9sBNVZ5FPbPxK8Ra1zvKQLE6ovM7gZLG9kmOb8lOH5uA8jQD8Jp1jSXXfN30hLfZNGMNaUkhmMa/xWjxi+tZEeyJviGAu7yY5QnCwLnbIg4Br0vWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pbTqnzyO0Rs/2I3ICXZzgTul8NQ7Zu4IhThSIY2uumw=;
 b=Q3mUl/kI4J18hsoF7daDmT/VDTMh9x4Bx1VZqqgPiidMTgWVIxt6Hhn9JaXYtBSvLhABmK8HykHM67RCyo8+7As1P5a9o2B8v5afIvK5Z/zA7YSoEoXGxH22YfvA2nUmmsZbRJgB/2fVQllXO5SnVzTPY3JQvR+Y/wu5IVtXYM8Bt3u7fhsWUQskNTLnWGWBDr6GkEqPsc0twnKl5hiPzK+YV7hPCXi6mYAd9fVqehb93v62PyqM8KRCFXWJ5pYUrVPYt6qNpA88tSN1YOz3IalLJfK+ujZnAPu1YL3jmaR30J35O4iSkFMoaVUQopIGejzIL4DjRApKcgKkgOSQwg==
Received: from BN6PR1201CA0023.namprd12.prod.outlook.com
 (2603:10b6:405:4c::33) by MN2PR12MB3293.namprd12.prod.outlook.com
 (2603:10b6:208:106::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 20 Jan
 2022 01:21:02 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4c:cafe::34) by BN6PR1201CA0023.outlook.office365.com
 (2603:10b6:405:4c::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7 via Frontend
 Transport; Thu, 20 Jan 2022 01:21:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Thu, 20 Jan 2022 01:21:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 20 Jan
 2022 01:20:59 +0000
Received: from nvdebian.localnet (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Wed, 19 Jan 2022
 17:20:54 -0800
From:   Alistair Popple <apopple@nvidia.com>
To:     Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        =?ISO-8859-1?Q?Andr=E9?= Almeida <andrealmeid@collabora.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:LANDLOCK SECURITY MODULE" 
        <linux-security-module@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "open list:NETWORKING [MPTCP]" <mptcp@lists.linux.dev>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>
CC:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        <kernel@collabora.com>
Subject: Re: [PATCH V2 10/10] selftests: vm: remove dependecy from internal kernel macros
Date:   Thu, 20 Jan 2022 12:20:51 +1100
Message-ID: <8257315.FuKUqIaFJu@nvdebian>
In-Reply-To: <20220119101531.2850400-11-usama.anjum@collabora.com>
References: <20220119101531.2850400-1-usama.anjum@collabora.com> <20220119101531.2850400-11-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b17aa941-ef21-4860-0aff-08d9dbb31f39
X-MS-TrafficTypeDiagnostic: MN2PR12MB3293:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3293C2F6B58D94B62743A2F7DF5A9@MN2PR12MB3293.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XoloNfPO5dWRVcuYsdezIKOxguVvwQwJ3mnJbjdmM54tfwa2P+pknSiRta6S2el+LCKYQKpLGHeHpXM41t42cpCJHEnqtk+OL307MkjQRGrGuftbcwGoEEq/H01kQ3T205DiDxTRFU44GEmbED3fwMDWr7dK7c1O3SFAHRbQxmFZOB8O/X9S8VGfurs6lp74yJ+bGFlYqfW7EN+F4b+8ePszIzzkdygt7wBYij5ZqCmaCUPOCdyhoaxyq9VODtYKQTxzAj3db/gWSjlQp81WA/1BHmaEvN8qER/xiD6KA5eRgIVOIPMVcqm7j5QJGOyLI2/o4ZemA2rJ7Cktl4hdnMm1ER6NZaJwAgrXb3HCSj5J5EmzrPiU9D8aLdUNN0k06kKUhHDjnbZgNHlrCIUNEz0RQZGqK5rEuFgeolirEx/qEtVWRiPZom8CWgeHFj+qGfv3xSRs/g/2EUpoLIt7jgwbWtUMBUJzse37177aBJAS7NUXE96uQD0xPA+UKHA20lqdDUjVgUBPr4ZgpudvWXvCU+cEcBAfqiWcKKoilRtjQwKq/zyoFwASTC1Z/Pt/WlZYPrdNcDfvBb+EFlnZ9VhcdRr+Jn77kiHBOwgK1HVsSQiDV81JrB+nVEh5o+95pQYCVfDNFGBl4FFhWCykenzkAL1BqTLjZfpgrR9W21xZe85YvEBAnij84St0tn67dXqGioarYgfNUUYsRJ2JfFqWj8Re6rHagD0sTjEZ3JxM62cW868hbI7L3cPo2MvCtfFyF5OQLP7glC4OaochIYED57rnuvOR0ZZKjWsuLQEGYa57Bvh+lgbKbddbWcPi
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(426003)(83380400001)(36860700001)(316002)(2906002)(8676002)(16526019)(82310400004)(86362001)(47076005)(81166007)(508600001)(40460700001)(9576002)(921005)(8936002)(6666004)(7416002)(356005)(9686003)(186003)(110136005)(70206006)(5660300002)(4326008)(26005)(54906003)(33716001)(336012)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 01:21:01.7221
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b17aa941-ef21-4860-0aff-08d9dbb31f39
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3293
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Alistair Popple <apopple@nvidia.com>

On Wednesday, 19 January 2022 9:15:31 PM AEDT Muhammad Usama Anjum wrote:
> The defination of swap() is used from kernel's internal header when this
> test is built in source tree. The build fails when this test is built
> out of source tree as defination of swap() isn't found. Selftests
> shouldn't depend on kernel's internal header files. They can only depend
> on uapi header files. Add the defination of swap() to fix the build
> error:
>=20
> 	gcc -Wall  -I/linux_mainline2/build/usr/include -no-pie    userfaultfd.c=
 -lrt -lpthread -o /linux_mainline2/build/kselftest/vm/userfaultfd
> 	userfaultfd.c: In function =E2=80=98userfaultfd_stress=E2=80=99:
> 	userfaultfd.c:1530:3: warning: implicit declaration of function =E2=80=
=98swap=E2=80=99; did you mean =E2=80=98swab=E2=80=99? [-Wimplicit-function=
=2Ddeclaration]
> 	 1530 |   swap(area_src, area_dst);
> 	      |   ^~~~
> 	      |   swab
> 	/usr/bin/ld: /tmp/cclUUH7V.o: in function `userfaultfd_stress':
> 	userfaultfd.c:(.text+0x4d64): undefined reference to `swap'
> 	/usr/bin/ld: userfaultfd.c:(.text+0x4d82): undefined reference to `swap'
> 	collect2: error: ld returned 1 exit status
>=20
> Fixes: 2c769ed7137a ("tools/testing/selftests/vm/userfaultfd.c: use swap(=
) to make code cleaner")
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
>  tools/testing/selftests/vm/userfaultfd.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/sel=
ftests/vm/userfaultfd.c
> index d3fd24f9fae8..d2480ab93037 100644
> --- a/tools/testing/selftests/vm/userfaultfd.c
> +++ b/tools/testing/selftests/vm/userfaultfd.c
> @@ -119,6 +119,9 @@ struct uffd_stats {
>  				 ~(unsigned long)(sizeof(unsigned long long) \
>  						  -  1)))
> =20
> +#define swap(a, b) \
> +	do { typeof(a) __tmp =3D (a); (a) =3D (b); (b) =3D __tmp; } while (0)
> +
>  const char *examples =3D
>      "# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
>      "./userfaultfd anon 100 99999\n\n"
>=20




