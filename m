Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D7446293E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 01:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbhK3AuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 19:50:21 -0500
Received: from mga12.intel.com ([192.55.52.136]:9307 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232910AbhK3AuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 19:50:20 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="216126186"
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="216126186"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 16:47:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="499549370"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 29 Nov 2021 16:47:01 -0800
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 16:47:00 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 29 Nov 2021 16:47:00 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 29 Nov 2021 16:47:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6tzKW++UqeytzOVMPBJsDDwIjCILGTF2SSysJUCKq1b3l2+6OzXLHtg400a+WwR/NiRuhiSM98LR+zULbe7PkXIyq1fAawlJKOO/dPWzCVSlEMLSExvevMOi7eXZ3wofCgn6JAFia2vcVPosOyInzVMaNN4E3deR5VAbfSDy3AZ3DSWPPxJjpNruXSNHO0dtqTBVGlxsj0ihF2zO54vvJSMcXZG+VH++pVsEBjBm+LFr+M5hhHyhLpSojnen8WlFGp5TI8GTGQ1ejIyrfcyizdIxSdKEXy2LQ+Eme3seL1zdz5SrRvus6RgeKoJKrgQrdU1XrrxOjzcy9LK7hgL4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6XWW411OHLA/erTcFPczdmpfz9JcBBOcQHQl8hjUL7Q=;
 b=jlFlm/KsmnDYNK2qvtB04yBHewhWYVtOx+/crZyNmvOxJ0G865iRmUL24E5CxEoeref3dyCTJsMqvukA5m+b5jnbdomiRWZxBsrP/n4xgVKtwsvjbx8xCwcZQCuKdMeoaAnO6ziKUfg/Mj20SbxF0O3GyPZCQI9XOVCCuGGwB3fxQLM8Z5AjANy09I4gyNGG+UytU+66PESERQ5fkZXSvbWK7vPpP0PPgyzXd6m5aAWhyhfujkLECvIlbPds6SgA2IH+u1TkYL9+f5WfaDcjOG37PfcXccQfgobFiLbTBvQMnVqBhg2W1Okvo6E/v5tiqlNimOS/OrPdFnMwo6GXBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XWW411OHLA/erTcFPczdmpfz9JcBBOcQHQl8hjUL7Q=;
 b=G9pO51kezVsf7ofjgDiRmd72VUJ6zx/DVxJuKVuu23rqFls2uRBjf//owJ/Dds8ugV2pCUYBI4xTNPAUQUs2+wiQnJ6lPMEGD2nb8NMKTWK8EZl2B0fQDjO0MEly5W3L8eM9EutWan/RH51nxxaYAxnLILZG2SJmGllb0/FEEYg=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1837.namprd11.prod.outlook.com (2603:10b6:300:10f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 00:47:00 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::2986:f32f:617b:6b76]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::2986:f32f:617b:6b76%9]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 00:47:00 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "pali@kernel.org" <pali@kernel.org>,
        "vadimp@nvidia.com" <vadimp@nvidia.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: RE: [RFC PATCH net-next 0/4] ethtool: Add ability to flash and query
 transceiver modules' firmware
Thread-Topic: [RFC PATCH net-next 0/4] ethtool: Add ability to flash and query
 transceiver modules' firmware
Thread-Index: AQHX47ani9+cxgiI0UCYt80+3C7UZ6wayBwAgAB3o2A=
Date:   Tue, 30 Nov 2021 00:47:00 +0000
Message-ID: <CO1PR11MB508909706D9D5A44060C90FCD6679@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20211127174530.3600237-1-idosch@idosch.org>
 <20211129093724.3b76ebff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211129093724.3b76ebff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7637a08f-8392-4a4e-242a-08d9b39aeb2c
x-ms-traffictypediagnostic: MWHPR11MB1837:
x-microsoft-antispam-prvs: <MWHPR11MB1837402E4F1279FFB40884FBD6679@MWHPR11MB1837.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kg0dSEVQzEWJUWQCN0CXJQK/aPAuPfw3WMXIbCGqpPfzlStaJewsDQa3lMOfku4XDXwuGOyeV17iotPVRTHz2nLZTBAQmW9/7LX/hkS0kGw3Mf3al0oKpMMRr265OsgD0VEtwamLm7l2LcJ4aBVTrA4yOJ8bpgfc8WxNpZ46DrV2YGUFGbasimSjgrNjWgNMXO30V5QKtTrVs5KEImuIDtdNDBA416/YRpjw3dj1nTDT5F27XDtuYeZE5WPw9BnRR5vjdxVcVkClwtEMbBqEQ3F700skf3Ouq3+A0u2y6XV73PVQ+OloDxkN/2CpV4LTrXp1y9urcYUgiiD9rlS17uKbRXYZsKmNj5cU3CCBGd+3c7nhRLooVcjjqrzdfKdyFHpXWLJ2M5UZKD+xSkD9sIAj7IGfio3vBX2GbI6R6kblFNJEzWfAizmNfbxhmG6Xhw/bDtLIFq9CwgC5SSxupeVZ0JkX2vUqdtmzeMM2TGDH+y8COOoM9xPJJP9+PADXMF7uydu29QKMpUE1IzuEn3R27YUYl+rD5GaI+TO4KwcO9zhhXxhMoB6K5WQc1fxnGzj+GtA2hNMc2PwNSXrgphuUSc4BMkj0A9x5s1zVCgLNdUZN5WQiiML0ELR7AkjsNAFSWOW1+3e0Z9igTiGlcJ3q0VYHgNB6xccqsXiqxC5LW9Vw0UcwpA9h6RU6dKoRV7R1/seiyjFQUiP+iAADnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(6506007)(55016003)(66446008)(86362001)(508600001)(52536014)(4326008)(76116006)(64756008)(66946007)(53546011)(9686003)(7416002)(83380400001)(66556008)(186003)(38070700005)(82960400001)(66476007)(5660300002)(8936002)(71200400001)(26005)(38100700002)(8676002)(2906002)(316002)(122000001)(33656002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QvjNidenxerepSBUrfZYoodh6mGPvMGQxzf7aY/yVBH5fmOzNbW+LXLWizk9?=
 =?us-ascii?Q?Z6uVqXkL6ZouNSQ8htGMg/yYTv0dZdyBzCqznELf1+Rmp/PDunJy4/siqxwW?=
 =?us-ascii?Q?RX1RP07cp3QSH27jTRB+xAU5uupHWrR+D/A7Ae9u+xZSJJqZ/iN0OPvyMyFm?=
 =?us-ascii?Q?KH58w+6kdylu+BcmAj3WgTcpIzG61gLgreZeSBV/O20VqNMWF1ETuR2ervOi?=
 =?us-ascii?Q?xNglnk0MpIx3C+WJm5ZLyfzUaJhwmAMnEbT41x66ZtRwoDLPPDMivcCdVa4e?=
 =?us-ascii?Q?yv2CuEwsl3g8yD0JteLa6OZeFOGo6kR1+m/SA8ZpaI7bCCZuzj1GkOvlJ16/?=
 =?us-ascii?Q?fSqN1FL46wSQCJr+rzXZ1yPic0Y8MO54sQgo3EezxNOiUVkleFvht+Xq3PcR?=
 =?us-ascii?Q?vbe3XL1bwcVbCkoTY5bU4Wdnh+DZGh0NqAy2739dXAHcnXZKNU5Wy7O/AFrG?=
 =?us-ascii?Q?l1fzm8rrRwyKb7zOwZJHfHLuoT4jffXRcQVjUVWvBIsFTQB/NhQ8w8KWcCdQ?=
 =?us-ascii?Q?Ay28yL95aQ6Y0/xcvtwVrTri/a2ws+MoERGlDP0DKYz69b3tLfGyH3NkzOzK?=
 =?us-ascii?Q?Khseq+vBPbpd1wo2uKvS/C/1AoNQOSyQTchg2wCbkkJi867Mzfbv4Ie8OwYU?=
 =?us-ascii?Q?r356iE/jDPGZM+C4q4khcY4KDy8sKjmYCTnUmqXBArcjM2mPRF7/DabM7bnf?=
 =?us-ascii?Q?7Ad0QhorrOaMahONZoelyO7IwBtaG3SOeR+0rB+c52PrQhqiQz8RCtAHzQzO?=
 =?us-ascii?Q?Z9O3QsHs8mCsDVCXimtUwm2TLPbsxCvYGOd3loLwg557JzYvU8GYTVgKABot?=
 =?us-ascii?Q?5CbkBep4GbD3GKYivAHbQs0PtNT5jup5Rph3saV0BfVzOwb56J8tenJPaeAd?=
 =?us-ascii?Q?F0p1O4eAQTfSBavlV5o/cmvMTikqA1RQRWHhx9dTi7QZgQs8/8Gs1vWs4fs+?=
 =?us-ascii?Q?L2vh3sSUPWs893fgYA9PeGUb8rDnifrKASGGWsLUx/QJcqE5X5sro4DurEbq?=
 =?us-ascii?Q?TCfube550rPrLQ30yu2M+34cWCRgiXPHsW1HhFENm/sXMuBxzcXqRMlEflj9?=
 =?us-ascii?Q?PnFD9kSSI+xfVb8lRL4XZLJKHF7EEtRFIhoxrID7qqYWmwK1R//YzS4Ie0cd?=
 =?us-ascii?Q?h10HhPWqkujbR0YLhS//be4MfBQyJlpAnEViWPUg+9lbNKh95m/vqziyrKhC?=
 =?us-ascii?Q?zKX/rBKsED1ZQxzUaWgCfuAekaKp1Jo4t2N35jyibsc7H3FT90gQDltmBWhM?=
 =?us-ascii?Q?XqSP+ANB3DiL2daxEmN0zpRXSDgj5Q63zvAxlL9EVYRNR5Q8JB9303v8JIsX?=
 =?us-ascii?Q?rvb5N1LGLSSaPIBDH9noZPSkTJofPHz980qkj8OCP9To4bBgcroU7rxxOFt3?=
 =?us-ascii?Q?flwTHWtBZiyLfBUSMpIcVc+CJCNnTr9YM5grkzov46j/eSFUkXikiUyLVUyP?=
 =?us-ascii?Q?rauZhBGlEW/GrUOfFTf0bdSN40ce99gYV5uLA+fi83Q0Ke76VxHQSge5Sium?=
 =?us-ascii?Q?vWTewBss2w6qKPUcBdZWxJ4Qnse4CJtuRJfM76Dm2Z9IDy9YqkSCRXst9YJD?=
 =?us-ascii?Q?asnLRoDQguuRoC79l/8a23rj28eISikyAh7NJbo0VKvs245Imb274Sblnsu5?=
 =?us-ascii?Q?hljhsNBYfyN9tfujBjuIgi1daZr1ucvEDCfYqImggzE3K2Wy2Dd1bxdFJo75?=
 =?us-ascii?Q?mztISw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7637a08f-8392-4a4e-242a-08d9b39aeb2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 00:47:00.0394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iegM8Qic/mA8RRLjQZbcW1Fn67wCS9jl5jXWR8Prr+QBIHgjbCQ3mJuO2yQm/sJn974EyxWux6aJJYW9OtShd28nRTp37bQicxpqeqItVM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1837
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, November 29, 2021 9:37 AM
> To: Ido Schimmel <idosch@idosch.org>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; andrew@lunn.ch;
> mkubecek@suse.cz; pali@kernel.org; Keller, Jacob E <jacob.e.keller@intel.=
com>;
> vadimp@nvidia.com; mlxsw@nvidia.com; Ido Schimmel <idosch@nvidia.com>
> Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to flash and q=
uery
> transceiver modules' firmware
>=20
> On Sat, 27 Nov 2021 19:45:26 +0200 Ido Schimmel wrote:
> > This patchset extends the ethtool netlink API to allow user space to
> > both flash transceiver modules' firmware and query the firmware
> > information (e.g., version, state).
> >
> > The main use case is CMIS compliant modules such as QSFP-DD. The CMIS
> > standard specifies the interfaces used for both operations. See section
> > 7.3.1 in revision 5.0 of the standard [1].
> >
> > Despite the immediate use case being CMIS compliant modules, the user
> > interface is kept generic enough to accommodate future use cases, if
> > these arise.
> >
> > The purpose of this RFC is to solicit feedback on both the proposed use=
r
> > interface and the device driver API which are described in detail in
> > patches #1 and #3. The netdevsim patches are for RFC purposes only. The
> > plan is to implement the CMIS functionality in common code (under lib/)
> > so that it can be shared by MAC drivers that will pass function pointer=
s
> > to it in order to read and write from their modules EEPROM.
> >
> > ethtool(8) patches can be found here [2].
>=20
> Immediate question I have is why not devlink. We purposefully moved
> FW flashing to devlink because I may take long, so doing it under
> rtnl_lock is really bad. Other advantages exist (like flashing
> non-Ethernet ports). Ethtool netlink already existed at the time.
>=20
> I think device flashing may also benefit from the infra you're adding.

I also immediately thought of devlink here.

Thanks,
Jake
