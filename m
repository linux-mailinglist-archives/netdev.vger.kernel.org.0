Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E149C368AF0
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240103AbhDWCIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 22:08:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40876 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhDWCIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 22:08:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13N10ep3030311;
        Fri, 23 Apr 2021 01:00:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=P4dKJkFyVBCUK+y+wVZKH1iyvcNry9UIskjR99MH5to=;
 b=RsCXe8RRIOO52kuuaWVnki+xVRDbQQmrNjTxoPqIQ29rUf6pnKQd+ZO2bR7BcGvO1/jq
 ZGYewPxWMX9yiGIkWuIMtck7KNdJGswhRSBev/bqL81cQ/alvKKgRTW9JHN6b9eBktDL
 Hz0EQsqtJrprwTtYG0Qj749v2bEanPrONTIEyX+i+OR62KIb008orbIMRkHImKjFiMDc
 /BvlmhHhiRD4fmbAMpMbygCAMFGLdrNHOPa2vtlJZueTbMxk7VFRvdlC9IgKnlXtt7DI
 hsgmA5XbTYiBdfT384mX4oMgJBf2yuFhqS+96g9NOYUWrYUPhg+zf8hrxcQpsPUokZZZ qQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37yveapnba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 01:00:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13N10CnE159868;
        Fri, 23 Apr 2021 01:00:40 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2051.outbound.protection.outlook.com [104.47.37.51])
        by userp3030.oracle.com with ESMTP id 383cdsaebx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 01:00:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MljdvMmoeiI60r+z2zyTiHoj3r69JB4fdGb+J588j4NfrvWKP9meFkHj4nrTe2IXkBfD0gD5zZT8+n++T0eHh5mmZpBsWddvL6YeFWCeWdcwQs3K7H1C/uPgth8RY9nqSjU9Q2YHZVkxKNN3EX7wjKBzY54LKbvXCNEqtAepVDENitZQgIFLIGT71pZ95bYgFZBmAn+7CsMrEFC9W7v7CaT5DY9vyVHqPqcSupk88kcgx56z9yR1/13jTMBBlFXNjah2jkvl9KCISbXihsPDP3/jpYHSJIivZS92+OTABwcM8gBkk1uJ77hxacfe6Mq3dJ/8UxXP2Y7C9qkSPX6JIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4dKJkFyVBCUK+y+wVZKH1iyvcNry9UIskjR99MH5to=;
 b=NILkwqStYswOFU2i3aW2aoHQKtxNtUEbvVEzp2zFw6+Ki7gsORU2CIb2EhVsbpllzXmnKyVnTLsex5kEnWEVDmehR0JR/DokwX6kar6B+iY9YPV2XnXl6S2OC0b6n+R6T9iaZkO77go6FLxZk3efNc4jnZli8hp+IaBCAHSbhmE0gFppQNnGap7ZktbF6kcL3KG7lllo4+qLwrr4pAU7ngqvKPgKgLZWAGlGWzmaBC5V9ksoQ/0ay/4z1ViH6lFBpU5eU93WonbWBLcnZqOU5+gotz9H8cP6BRyuL1AhbD2IxzRJhxfSO9/XXHZNW+xVSPedimC1FgKjjaAnQF6mJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4dKJkFyVBCUK+y+wVZKH1iyvcNry9UIskjR99MH5to=;
 b=UXyLoqn9I7v4B8zhohsiaoxTVns/j3vDTXc1Iv3mGl4m3DCjOL8imhpwlkP8i0JFUEZFYwFl8lt/COBOgwSs8VyqfTXWW0Bo5TO8VoTghLhoPY2HtUx4qG1d8HNs1y6m5IAWVdtKhVDwWuSvNNAE8SW3lfbscbOxgqjXVj9qds8=
Received: from MWHPR10MB1582.namprd10.prod.outlook.com (2603:10b6:300:22::8)
 by MWHPR10MB1919.namprd10.prod.outlook.com (2603:10b6:300:10a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 23 Apr
 2021 01:00:36 +0000
Received: from MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811]) by MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811%8]) with mapi id 15.20.4065.022; Fri, 23 Apr 2021
 01:00:36 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Will Deacon <will@kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH 1/3] arm64: armv8_deprecated: Fix swp_handler() signal
 generation
Thread-Topic: [PATCH 1/3] arm64: armv8_deprecated: Fix swp_handler() signal
 generation
Thread-Index: AQHXNgU7pAWIynV4NUyh79ZCugEeMKrAgoAAgADJiYA=
Date:   Fri, 23 Apr 2021 01:00:35 +0000
Message-ID: <20210423010023.4jmzyzjzbnu4jgoa@revolver>
References: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
 <20210422125903.GD1521@willie-the-truck>
In-Reply-To: <20210422125903.GD1521@willie-the-truck>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [23.233.25.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ce18cef-51c6-4953-18a0-08d905f3344a
x-ms-traffictypediagnostic: MWHPR10MB1919:
x-microsoft-antispam-prvs: <MWHPR10MB19196070AD068DEA8A9B981AFD459@MWHPR10MB1919.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b5t29otyL03sdw6/jrz2Xt3KlbHV/ERlAc7iY/hicrfoZRH+Is1ZHRwmvqDSP9cRWzKDM5/ORHPazkWEHfhAbg5uN2MhyoiqiZMYjuxY2exQ9eTwp830n0r4kK5c3TIz6QQk7bnTCV+3Q44E7tMaO2T8p7f39kZiU/BtT+Vpz2IJ0aiNyXEkbwH7rBNWQX1KqzU6yopzAT3ZIoZja99PFWlpMUZcbIjRl4mCYtm/WRUxqdOoopzp1+T0q03ktUeqTVSmu+9okS1hoFudgKqmvQR1der7s6VVX8Jkb+aVit52fDsirjhLrQHpinD5oZb4OtJx/OUW0l3yqxVYfK0blc5m897jNfhNFyaWlxbZy2uIzX59mjUynYg6Pc5Js3p7gCM11x6MjbIcOnbWVMfM/ToMA2SwnxH6G0edxnSeVk0e4M2w+MEXU/0/0KJ7fKVgfduOis6d06UHct4qUBL01Cos/JMuBrKbVOMOi6Q14HTpiOPy6pL5LtNftSv6ppNR3g7G6okQyf0bwq7VbpHf1gwFRYoQ64ouuRHj/F/0//769lDt5AbWU+7RB5tORW+S7DTi6H/vU8MzAm5vCeBrccQv3lQ49ho3gGVVehT9o2Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1582.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(346002)(366004)(136003)(376002)(39860400002)(396003)(186003)(66476007)(316002)(7416002)(44832011)(66446008)(6506007)(26005)(9686003)(33716001)(122000001)(38100700002)(8936002)(91956017)(66946007)(2906002)(6512007)(6916009)(76116006)(83380400001)(66556008)(64756008)(8676002)(478600001)(4326008)(1076003)(86362001)(5660300002)(71200400001)(6486002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qpx3lRq7O0d1nkELHUrHoHuYF+VfR5b//dtrB9kv8eUDQQNlapWYVKRY3k/3?=
 =?us-ascii?Q?V9t7L//UWIN3s+SrAcdNJueueSJEaOdDUPdU2XSh3mDDEuk/OqMvMHoAkEVM?=
 =?us-ascii?Q?89AyWnqoXDKc76uaQuEbBxEEJFkwG39S0HXcAoUP+9MrPtfutDZ7t/K+C2ZK?=
 =?us-ascii?Q?mPmEP1/ao6PKP0HMSrgYCzjPo9CEspSmv1lALSX2SX1OtnuVOBWKzJgOa1Ac?=
 =?us-ascii?Q?hJLeU7g9SM5prHbKTw0WRJpsKH+YNlBER1x9hAy9WTDSXt66FqRYTNiBaezy?=
 =?us-ascii?Q?8/Py7wuI/OLyxshU/LXDtzMo5shQ1qoSJEj2jakeOdwGKRHMpzqjqETYCk30?=
 =?us-ascii?Q?3o/gyALc9xdmlrbZRUfEBH2SSfdFq+bYZtHUcPJRJ83hU0VhkMHj0bDQjQ3K?=
 =?us-ascii?Q?xomiJkgqcLhzkvVRUi6mRmqf+dyDDgV/8zk4m2CLvuAZDoGpf3QKcHye5j5Z?=
 =?us-ascii?Q?4GJl2TIacGS4O+cNlU502k2YNA+3B9rdETQ2wPeCn1Nic9prvczM60HxQhnU?=
 =?us-ascii?Q?U/yW+Aw/Gl5kI1jvF94iAfdDL7zCVRCMJhdKfvoGHe0U/FVHGY3Ck8H8tLjr?=
 =?us-ascii?Q?PpegpDlf2klfNP3/mR2wgk9ayHLF3EXECypkkhSS1pmWelPz7/11heIVTGAI?=
 =?us-ascii?Q?yojVkye4Mn0WdgYMbUxOh9cAMzcYUaLPZjZmocA16rL0bqZuBXCYwJx3g+Ye?=
 =?us-ascii?Q?fDE+2DBTTkCqmS5En7hMMcE1dkzH7/paC+7zjn0zSmSgBkxLqBx4aRAr67Rf?=
 =?us-ascii?Q?13xqCYTqK2YAmjIMiVTyf3/Yrfk63/OegTf4gXVpkTH6mC95hew2jTdXYQzz?=
 =?us-ascii?Q?LSufwWSBqxtvY+mKSPJYjCvZOaK30FGvMiAUwtZ9X2pU6kFDidsqYmdnraN4?=
 =?us-ascii?Q?1LBqVI9/CW4MIVDnJMYtRMBrZaCosOGsfwanzKfhbycvv9IJ7zD/GzleO4ep?=
 =?us-ascii?Q?ZEm/E+MW0k9rHqYtbCLA51QRNjfug6geJqJxsfv9+k0fz4phVKp2Ket1grHq?=
 =?us-ascii?Q?j4KarA9vSCiMUT8VSWJoQKA3Rtu5AbBsEmU04iMA09abPRxzZ/fW29Koowm1?=
 =?us-ascii?Q?LgXUfz0lSk8yy7r9Z7vg2BU5Y5G43TH0+7nmtAKbe7HD5P7WcwBq61A+92sL?=
 =?us-ascii?Q?y0wCnqOD/63BQHXZbeyTho6rhIPCk+MDsWLGbvZ92wicSyNB7L7hIVZbvS+f?=
 =?us-ascii?Q?6JBofUEEhA9oPhv4DZn2PUVh5kpOh6dd39jzL2Xg6UWjT5yT62JYAMtBg6cF?=
 =?us-ascii?Q?xu4an0Ndje6CmDgHx0BtJnDdkUyVtpmCT5IF++Y5i5EZ+dPizAZSI+eOnQ31?=
 =?us-ascii?Q?NW7jA7mktr+ZJzqtSXfiGnJk?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <625BF4051A54D044AE54F7DCFFC1F2F6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1582.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ce18cef-51c6-4953-18a0-08d905f3344a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2021 01:00:36.1229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7IzEUzf8gkEHMxb9cv9kmCfht2XAK6S/H1aDgUlIlBxrGMMf/3Yx8ntFYLogzBmq98ZZsauDDpbUgfprh6sl1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1919
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104230003
X-Proofpoint-GUID: MgqmFGWpCUucO1K-0a8dhO7bZ0az5ZFS
X-Proofpoint-ORIG-GUID: MgqmFGWpCUucO1K-0a8dhO7bZ0az5ZFS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104230003
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Will Deacon <will@kernel.org> [210422 09:01]:
> On Tue, Apr 20, 2021 at 04:50:12PM +0000, Liam Howlett wrote:
> > arm64_notify_segfault() was written to decide on the si_code from the
> > assembly emulation of the swp_handler(), but was also used for the
> > signal generation from failed access_ok() and unaligned instructions.
> >=20
> > When access_ok() fails, there is no need to search for the offending
> > address in the VMA space.  Instead, simply set the error to SIGSEGV wit=
h
> > si_code SEGV_ACCERR.
> >=20
> > Change the return code from emulate_swpX() when there is an unaligned
> > pointer so the caller can differentiate from the EFAULT.  It is
> > unnecessary to search the VMAs in the case of an unaligned pointer.
> > This change uses SIGSEGV and SEGV_ACCERR instead of SIGBUS to keep with
> > what was returned before.
> >=20
> > Fixes: bd35a4adc413 (arm64: Port SWP/SWPB emulation support from arm)
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> > ---
> >  arch/arm64/kernel/armv8_deprecated.c | 20 +++++++++++++-------
>=20
> Can you give an example of something that is fixed by this, please? At fi=
rst
> glance, it doesn't look like it changes the user-visible behaviour.

In short, when !access_ok(), don't return SEGV_MAPERR.

access_ok() is defined as __range_ok() which checks if the address is a
userspace address.  If the access is not okay, then the return should be
SEGV_ACCERR.  However, if the address is above any known VMA, then the
return will be SEGV_MAPERR.  Isn't this a bug?

Right now this particular bug is masked almost always by the fact that
find_vma() will return SIGV_ACCERR unless it's abvove any known VMA, but
patch 3 in this series will alter the behaviour and thus, I wanted to
fix the bug here before fixing that bug.

>=20
> We should also be compatible with arch/arm/ here (see set_segfault()).


Yes, the same error exists there it seems.  If my solution is
acceptable, I can expand it to include the same change there.

Thanks,
Liam=
