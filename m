Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1F347A49A
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 06:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbhLTFdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 00:33:50 -0500
Received: from mga07.intel.com ([134.134.136.100]:32674 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234029AbhLTFdt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 00:33:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639978429; x=1671514429;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DALxOANWIj1HP151VnflsbPzZg029LyLtvZCU8S2fG8=;
  b=U8S0Fnbk/iGgpasoEQ0p5ZPi1GyqlBgG5j46brmhuu8H4dyhVSWDpkUe
   uhRsz/+2AdWqe2J7Te2oioihyVkJxmIe5J2hIcKWPnKKgbJbncFXWJjUq
   mXsim+PF0IGMsxMlkIq7ghdMtPtcFe95paJXUYlT3wZJYglm4TH/ywx5T
   bw8KGi93jbw09rCL3e+2qXTWjS6ou6je7OVB60dQJjT7PCyBMais6gCNO
   VcF1P1OYUPwoEZGR2iWBN4I/ZKA0aGDSWPjAkUFhoV2F5/KscIijcCi5j
   MFVo2OEc4AAGmOcjURcDCSvYY/coCWOSNDGebvDlZN3e1XuLo7w36jQ/R
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10203"; a="303474733"
X-IronPort-AV: E=Sophos;i="5.88,219,1635231600"; 
   d="scan'208";a="303474733"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2021 21:33:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,219,1635231600"; 
   d="scan'208";a="569734845"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga008.fm.intel.com with ESMTP; 19 Dec 2021 21:33:44 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 19 Dec 2021 21:33:43 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 19 Dec 2021 21:33:43 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 19 Dec 2021 21:33:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjcTDdRLuk5U5l72MDb+PKtcP//MMoqLOBkv+rx2GmQdvs56A3yDgttw8/fP0QvnVwAOPFTWbVhUezFM6vAPID49UpyPHgD/bHCAPP/RLsGQoEJYZQuLa3rYob2KX7fcbm7my7+PHh1IEkEOUlkIsbLkynXnazEZXrP0oTHmJGOqMbu7NcjiuCZ14HGgKBER/OmhkHyJvN452rz6CgKhL/5YDe0GOX8jOpEJlSLlYukbveFC3noZNdrboPQFPIuQVee6E5iKqtU8LW0GmJDJn5r7FlG8iN2P0KGw72gbvXLCIEGP+lFMsZ0LFo5iQLEf1IrURLiI3Oq9uu/VECIFBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DALxOANWIj1HP151VnflsbPzZg029LyLtvZCU8S2fG8=;
 b=nOZ2YcJ1oLmKDbzk0QHvaMRM7z8Hi7Po0JagJqKJyM9qYTiU9asudwOET5K+6C4fiHcHVvS15BIHLn8Mb6LWRwQxG/VQKLcGvMsQHXe3Le/y/86oRc+Lpokct+JNqX3xx4BHtcxwWouwlv+eFLBIUX0ByL6duvyqvWoKyWKQl6o6MDX/k16tHNKWf/ll87ljaSfpnks7wWQdbPac4unsxZ2ezTcTteXgcoa8DxwAji8zbrZveChW5u4Eut9gMeKVq3Km2UhJdhAnCEitYbbsH3jXLBCPaIERz2JRDB4loozETqc7Es+C2BhA5um7TFPpvjf+fgZv4S2MFkgPdlG8Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2780.namprd11.prod.outlook.com (2603:10b6:5:c8::19) by
 DM6PR11MB3497.namprd11.prod.outlook.com (2603:10b6:5:6e::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.14; Mon, 20 Dec 2021 05:33:40 +0000
Received: from DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::e08d:fd5a:f208:566d]) by DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::e08d:fd5a:f208:566d%5]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 05:33:40 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nambiar, Amritha" <amritha.nambiar@intel.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "Kanzenbach, Kurt" <kurt.kanzenbach@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [PATCH net-next 0/2] net: stmmac: add EthType Rx Frame steering
Thread-Topic: [PATCH net-next 0/2] net: stmmac: add EthType Rx Frame steering
Thread-Index: AQHX7RBbnZeGu5vcJkStLNALMpEpYqwroBYAgACAw4CAAEh/AIAAMZWAgA5PcvA=
Date:   Mon, 20 Dec 2021 05:33:40 +0000
Message-ID: <DM6PR11MB27804CFB9A93A287DC4CB3A9CA7B9@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20211209151631.138326-1-boon.leong.ong@intel.com>
        <20211210115730.bcdh7jvwt24u5em3@skbuf>
        <20211210113821.522b7c00@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <MWHPR11MB1293030F02EDACD0A7C25425F1719@MWHPR11MB1293.namprd11.prod.outlook.com>
 <20211210185517.30d27cfd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211210185517.30d27cfd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 933ce088-79c2-4b4a-0ffe-08d9c37a47ae
x-ms-traffictypediagnostic: DM6PR11MB3497:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB3497BBB0324009DFF31D22D7CA7B9@DM6PR11MB3497.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9YYjMRYPQ20lu+fi2Rz+BRb4QczYOCQcR6AooHX4QaZOxJpYoBSapZ1XOkjfzo8Oe3dJs/qEtzqK/BUKuX/FwKw8vjwWQ97ZL0q8/iF4W2yOFSm+PcX9pGfGDdq/fxFiHG/p/6GDMVr7z9paiLIzZs2A1JF1MlBR8bkZjKY0DxigK/NrotjmzmCNCjNWWs05N3BnNWPa72sxASltfuzDo/wBLCsLiia7cC/3oqognRkdT4tL5247SsP6Ub0qiXqDFWD9mUd0hY1qVkBrUaJGs0NdZQ0oHcV4RhPMvZtZoP42gh5NT3PfNt28M+Rey2sfVq7Ofa2FTZkmtGPGBTBOL8r/KbYDsWQyHm5nHUiUMp7CrfZn8R7dnQ8BnOf5VxMLKHMJ/XTnO6pWZNjqcduiyUCLWvpMfaTOAY8+CwvfWGtN4d3sYNo/07tsHFMKXQaRDVmRbCESXuGyE9A6lXvOqds8DraD5jCtAD8FeJjT2jYftVQphe2eYV7CZ0+4mpbCuYFSbXsk1Ywo2Z5QReWGGaWs94sIByzUyFF22stJe+XwK6aYstBzvQygzNIDm4qJbWk63cQbBPU6gO9HF4Dcn9IC1ZCegqw59lv4Y6qimcoeh8l8mDoa/CWy3rQS/pyedM8ZlHTeqiGiyVaIBLXGEBu2gKW2izhRHs561b4V1qUdpsTf/vCK8P9OI51A24mSSu7GGx9iqLVrG/CxXha/pBtzPdpBB0tPDYD5KUIU7Fp5gqHl0xKgzi/RrM6PHGnCkXFq6Fz4s7Z2W6pksmFrEI1ECfNWgbEnEiN8brD9fnU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38070700005)(4326008)(52536014)(966005)(55016003)(107886003)(71200400001)(82960400001)(7696005)(76116006)(66946007)(66556008)(110136005)(64756008)(54906003)(66446008)(316002)(508600001)(8936002)(9686003)(5660300002)(86362001)(4744005)(8676002)(7416002)(122000001)(6506007)(38100700002)(33656002)(2906002)(26005)(186003)(6636002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+m7DkwfsEsn+RIK/HWrO3froIt0/mglw8qdcaxdo5aR72roPOEvrnJ67l8iv?=
 =?us-ascii?Q?5AEZ7jyAnowTr5hx/F2o7FbDqnWMxbbiTFs2R05ZsBEqzKzgDBAI5I1UZEBu?=
 =?us-ascii?Q?bKCAj5fs67S9L1R2iCGTWzOHSRJIExPYdChtZQMjaXBIDCYjXkY2uaxy2KSk?=
 =?us-ascii?Q?uLh/EvixZ0S7n+s2U3ApdzlLN/Fd85WFj/VBpBjiD+foBOSlBibRblyQrFNk?=
 =?us-ascii?Q?sprq5gLnasWuaPZeDuHK8SnspG0oYP+ntsJOWfc26XSdbE0ZfcNl05sfoOQU?=
 =?us-ascii?Q?diXagJp3+g43HH1WrJqjmOf0pTF3NzaBiNEXY5SZVJONxfYMkey0nIsEpNpt?=
 =?us-ascii?Q?btneHy7etgkjizqBHKaf9mzGkCZFScg2skjnZMDFwnfNJkMFvSava1/JGFXa?=
 =?us-ascii?Q?6/fUjkC/j6LK6zVIWmEbK40Q2URZrCaK5LPV1QQlnMNnoiKDquKBgyo4KHOH?=
 =?us-ascii?Q?7a51GoHWcClK8picV9TLdjmJsdQYNEpE6Go5i179nhFgQaApb/9I+N/5dTQq?=
 =?us-ascii?Q?MKunr2a0/57L+jFF2dzXUwRV792ydHEde4kMHN+NQ/GmUqKhDO1L90MJvXdE?=
 =?us-ascii?Q?8cKdds1UxskHbq44f0Rr5jBm/KMlLO6rL0gxgaMZqjQ1hjTLr9OYGo5OIeO6?=
 =?us-ascii?Q?wWNfZMs3uM/g2zJPEIRyw0JaRy7S9NBF7VjJ2t6oHk+GC+osGS/1TP6Jlkqy?=
 =?us-ascii?Q?ufyVc43dwW99EIwFcQVGLTv1zc+af0Z0QTp1bgCwJIYuuFEK71xm3v5cQqqG?=
 =?us-ascii?Q?/YyuMrCyDqxwJvpgY7htTn+xdXsfcvbFTJryCScTyeYHyPtdO6T2zCEehzKG?=
 =?us-ascii?Q?nqyX6gw5jUGQqMZ+97dLPBalxPyNemYDmW6lUstwJHqQEzjkB1GcijsPNqHh?=
 =?us-ascii?Q?Y6PRg4L1QPoLh33EtzX439glCSf+YBUSseM0EoXQRY5cx6DJEyBdb1rkY8kP?=
 =?us-ascii?Q?gmCoMxh/THxUj7bHBnI12Gd2/EgzHFX3I7btnnTwZthvv3zBOk+jN+TFX4IU?=
 =?us-ascii?Q?0qqJln8Rul6qZXWJlvJoniNllUt3ngaUB3wvEjRStEWzJKUgWNFx1c/GHB6l?=
 =?us-ascii?Q?cqB7QCgqWNHXfYZDFsqCEzqdMtcvGIZS4Z5kh8ovK4eycUGsswmNixHhyPTg?=
 =?us-ascii?Q?pIdRkbJXzb02A9jpZxhl0YY8/SXFd3AZQe9roLq66h++t5vXTnmh5pz331Zk?=
 =?us-ascii?Q?eJwN9zCP45fy1AOblNFlRVaRNw+zUPsU7CuJVYQpSUTYRwhEYEVPo47cHiD4?=
 =?us-ascii?Q?KQTfPMybmQCCI7j0JBb/h/GMyZMQmOKDSeWn420OMGJmJl9iN38TTlZ2KnYy?=
 =?us-ascii?Q?Yiw/73dqlWUWyZPbQ/nRedI70jtd9cPM2Q7D2Ormux4UznUy8mSMOVAWQfKC?=
 =?us-ascii?Q?zOBqbsQZoJomSXU2IL3kp3QslPN7KCJAEioizaicblr1un3Agw5HVKeuweFS?=
 =?us-ascii?Q?lA/IUTGAi9TxUeW2L94io03O8a4qCFa4oYtDqjeIXhf1QWLqGXbwKvFrdPBH?=
 =?us-ascii?Q?LbvJS7dfakAg6Up2btus6guELozSVrCF9DmYjMRpuJ168wFyhnoG+a0AXPLf?=
 =?us-ascii?Q?9TLeM8R40JgVAXZLDFXpV77Dx2Cv7SEbkIlA+NfZGORmbcqXvymYER05aQX+?=
 =?us-ascii?Q?qi49FCXI2C0LWsqEnI9aE2zo2NfhHnuGtyhfAT2A3US+mpTvsPIBQCbmZ+R5?=
 =?us-ascii?Q?0zdg6Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 933ce088-79c2-4b4a-0ffe-08d9c37a47ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2021 05:33:40.4714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EwPaJrrVfcxpK70JbzPxtRMXNPPNOlPmMidR+x0xnITRkmKpM5BtstdPu81VERwRqWilmfBa3cX3ieajlh8qiXwnRMO8AlgLjQDRTNzNMQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3497
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Fri, 10 Dec 2021 23:57:50 +0000 Nambiar, Amritha wrote:
>> ethtool did not support directing flows to a queue-group, but only a spe=
cific
>individual
>> queue
>
>Just to clarify - not sure how true that part is, ethtool rules can
>direct to RSS contexts since March 2018, your presentation is from 2020.

Just realized there is mistake in reply-to email list.

Now that the VLAN priority based RX steering patch is merged to net branch =
[1],
I would like to resume the discussion for this track.

Currently, we have vlan priority based RX steering be configured for stmmac
driver using tc flower way. Will community agree to the same tc flower
interface for EtherType based RX frame steering? If there is no further con=
cern
on this, I will send v2 for the patch.=20

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20211211145134.630=
258-1-boon.leong.ong@intel.com/




