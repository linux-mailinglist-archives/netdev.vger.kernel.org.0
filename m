Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECE263B694
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbiK2AYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234590AbiK2AYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:24:45 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4661B7BC;
        Mon, 28 Nov 2022 16:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669681484; x=1701217484;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/ITOL+SpDeHNQtyvtlXwkRxlI5WXQo5wOlCdlrLlqLI=;
  b=TqOBN8SEClJRrse5YK8iGehYfXyLRryUJ4idEgYdPG/pt/r/A/UDimFr
   cnhQChEakEINFS3jlxyIwjlvz5uQiKleTkuYIWbRH/uBcf9kU/RoWDzTQ
   GJ3yleEh73KPfTCI/SGbysHCZaVlvNd7op+U2N/bqIEPmOCWzP4CaOyUj
   YPEMS4Q4z0Vg3i3xpukuYZF51oMf9dklIz1zFtkTISXkDp1OCW1iEv3Fg
   Cz5Lfix/YqH0gAvtjEZV6tGdv5AbXViMm2bTpBndHtS/n83XRJS75rV7F
   /DWEXKJhtV6DS73Vlm+Jl1OSWELwqBAr4O7Fsj35jOUfjrHX8lKl8Eefz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="316817354"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="316817354"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 16:24:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="637411798"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="637411798"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 28 Nov 2022 16:24:21 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 16:24:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 16:24:20 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 16:24:20 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 16:24:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3yDV0+zmwsNilsPSMVz93aZnhmCyBOTjLzWguqVNl6/4eTfrDV7jbWBwt9mLNqJyk4kQObZs9PNbntbfoS95V7ChBpc3cGo6hvRGzFetSW+S5xX2KJVfcZXMt+E3JdeWZtgied6ZzNo0Tm2xhjxfAadve0nWEzCgZn2GorTZuq7DRQybUdImdPk25QlWft0D4Bjf1X9/85/BrOOZcKQcn4Ef+Y6t/jbRngxDn0IvVbXuUQDnnH7140W7VmyTT0BRE0WSHHEyn6gpLNmW1xd5U/nqKSux50fsm1u6FMlTXruI8EJmc063jprK5HRJqDO/EaNv9fS8PaVS/QPwjE0iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ITOL+SpDeHNQtyvtlXwkRxlI5WXQo5wOlCdlrLlqLI=;
 b=UxHDUi/qs9TOQOnerG4HCcn/GPxacPG0pCn5JWXdra5pUvB5C5FpBvPl37wKV65QP4RSgdqOsrTFhbme75C2E8cAxumn9elwrzuqVw9kXwnCeSo8enG3K9pNwhW4bLL1+sKwkAiUH9YZ/X9ElwemJMZKVMfmfZTt2dMUbfPXj1LpWgowg2sNPT9ZDllS4Oz69J+CiniNrXjcNavLz1z/kjB/n1acY9hZE6LkVb9aEMlISTWu+y62MQjzqONblKXZ/tBytWIFnBky5qUduyXet3eFYpny06NrkECz2k6sW6mkaXWOpDOJUQSwgZ4TRJaDKpYsWHckjrsxg6OZ1kdvsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM6PR11MB4610.namprd11.prod.outlook.com (2603:10b6:5:2ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 00:24:18 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 00:24:18 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Shijith Thotton <sthotton@marvell.com>,
        Simon Horman <simon.horman@corigine.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "Linu Cherian" <lcherian@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Leon Romanovsky <leon@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Shalom Toledo <shalomt@mellanox.com>,
        Srujana Challa <schalla@marvell.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Vadim Fedorenko" <vadfed@fb.com>, Paolo Abeni <pabeni@redhat.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Petr Machata <petrm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "Dimitris Michailidis" <dmichail@fungible.com>,
        Manish Chopra <manishc@marvell.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Taras Chornyi <tchornyi@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next v5 3/4] net: devlink: make the
 devlink_ops::info_get() callback optional
Thread-Topic: [Intel-wired-lan] [PATCH net-next v5 3/4] net: devlink: make the
 devlink_ops::info_get() callback optional
Thread-Index: AQHZA4aMUpovNpkURUqKWHrpaJfbO65VCqvQ
Date:   Tue, 29 Nov 2022 00:24:18 +0000
Message-ID: <CO1PR11MB5089701265DA7B1FF7CAB26BD6129@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
 <20221129000550.3833570-4-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20221129000550.3833570-4-mailhol.vincent@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|DM6PR11MB4610:EE_
x-ms-office365-filtering-correlation-id: 1eef9d81-c4af-423b-9db5-08dad1a00dc9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HOM1Y37Paa3mp0Epl2zD4KPdo6FdzqkxyJ45M+AahyB6LtRFyRviX1lHEjHi5jWOxik3GJpMXIBfF/DNO3FqwtXNADgFy4USDDFvLJnJjTvZ7WN/yjFMUfcsZyE8q2diHHKSRqFI3PmSJNQdIaaKCCi37123hCVS6QRbYUJ/jFv6gk7HJECiMj4EVR1rQz7TLLtvWJf6pLMlHdoSp+sSzBvgpLM1DJn3WB4BjKl1DNFrSUEKLunY5ZMx7ZFwZS5YqaBoDCIfnIgLZVdk3r+1JLNRU3C+IyPztpz/p0EBhg661JWG0/XaG86Mb022TwDOQ1Y44cyyoD35+hGmZarB2M+LFOHwBBVEJ6f0eDulKRc2RBYzTpSighvJjexaP++to+YIObWpxpTK+jPTynwDb9t6UKjCMRg+ZKqDm6bgfJb9FSV1X6FX5nL3aHhl36A0EvYDuu5yBHcRGwPhyL0WiKrvPHqmSFZwVSxxqQHcetLQtwwcSleh/AW3widmaQGQyPCPkHH00jyh6DtlhBnVO3dpNzc1wnBzGKYgzhS5Vp+xod0LzFbIIXxmLp5oBhnysFu8HwMyeBOepTwH/fFaxQ/8zqXwRhjmR8UWu5fSjuMBAfs9xDnj9Dq6JKwC5vg4CWs5SsTrm6DiF7ZgkRVsBHW4uz4VIcjBmUlnUXAEGiPvXmS0+Avg6nQNYtl/CfPq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(39860400002)(376002)(346002)(451199015)(55016003)(38070700005)(86362001)(33656002)(26005)(71200400001)(7696005)(6506007)(110136005)(9686003)(54906003)(53546011)(478600001)(5660300002)(7366002)(7406005)(52536014)(8936002)(41300700001)(76116006)(4326008)(2906002)(66946007)(316002)(66476007)(8676002)(64756008)(66556008)(7416002)(66446008)(122000001)(82960400001)(186003)(83380400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CXUYvMH7NUfgk7r8usRIhViUM/m+BfjC2aGbFBHh3T9xST23h/yrOocU2ZV6?=
 =?us-ascii?Q?+mPcCslKX9D0848nX/5OFmpsMwLAzqpow6Jda3JF06pnUhDM8S7+wTrstvNi?=
 =?us-ascii?Q?qwPe7RhnncjoEVUuYTR5Fb7IlvVvCprvXNfwLN5qs8lcgsxb/AZp9asjXbZX?=
 =?us-ascii?Q?3yxFnJB02iB6koWwNkx/qW/47YGwPdWEIFbFUtQB8RbcjHanRaN3T4T6JLF8?=
 =?us-ascii?Q?+WdEMhnUPsHXGj5s2S+yc53U90MuYq3swqo8UwnFMWp+loMLLoM1sFb//QED?=
 =?us-ascii?Q?pY58/qkcNsKPsEIXtguqWSseAkD47Vb1hyqbePH+dNdqIn3Fnwxvjc/Fs0Yh?=
 =?us-ascii?Q?jLt2jC57OqazcP+bxNVqRzrpEabouxCSoF2RhMni3DC+qFstUZytBnJO0Gnj?=
 =?us-ascii?Q?HFH9idVoTtCwHtYvGTGsncNXJd1crE7yzLFE3O/pAYDhidAhFHusCLvUW/Ct?=
 =?us-ascii?Q?rcxNPVz6SgNMRzLfu80/1zpIDnZxZjuMkOLOaijoNDWlVjwrpfBCnOTdBwfP?=
 =?us-ascii?Q?oy/hf1HJrw3cJ+bdjMF6q+WcX4ZJo3MDwonr5eTpgi5vudoAVsBtZpn5H5rI?=
 =?us-ascii?Q?q3qXevdkWAc5R2ahwFiIf0WZhrv4Pj/nfI50gHUObr77FQXsLmTl9xeOGr4c?=
 =?us-ascii?Q?iAZ68xOg3ddJxfDaXoK1Srm13Net0/tL6czachNydh7oRX/vibImfJn40ZC6?=
 =?us-ascii?Q?LC4ocOizsA/4PAGG8XWs6fZF9Ta14SVdc67qUtjXbP1ws77au6U/gLKZB+f2?=
 =?us-ascii?Q?kbVrC9+TicmIqlWL1erS8hek1b1wRpw1LeT5n7Le6eBt6TAcjyJv1oGEkdjm?=
 =?us-ascii?Q?nCy8Is/jqIHLut7yTAibjp6J6ekFyJdexRJIMZnVdIMssQBg579mo5KRwpps?=
 =?us-ascii?Q?g2vuuGKrJI5UeziLaJ2vrsKt/4jEv5IBDUt4p2aCfDRg80UvKGWUfPCfgQrJ?=
 =?us-ascii?Q?pgg96AeZlWA2X3TyFD5b8vUF+xu+EjUiysT9X/JMqBjXR85noNKMl95UNIxQ?=
 =?us-ascii?Q?kQgMTF1tLtB/5ebvYyy3SUf5Ez7l6AXV/1h19GEDi+HLdiQ7V48eNrZpK9wl?=
 =?us-ascii?Q?iea+qrD9x+IKpdG9IIRj5nssQh+XcUQbwFftec5xr8P/8tz+r/gelWBNlzGl?=
 =?us-ascii?Q?5W9yAjCkDJ9uP917rSC8tF13gSOnr3Bc+7c+GAsgPoFg6sBkqUyW3LkuLB1t?=
 =?us-ascii?Q?qwJqKwq2VFoQjmDTO3wi/V/Z2EPKTorGzva9WsXwd1ryGKbj6o+Vl8mt0ZzF?=
 =?us-ascii?Q?K8ygJRYYpO/nCGzzoYhz9aa/eJLwM7hS0qAaQ4vEnVVKBgWXbeXFJzPSTzYu?=
 =?us-ascii?Q?QdXxM8aW6edIcUST7Sv3rvTa7WQFVVzXhVkPxktQq66N57Vq/htAUT+uIoJz?=
 =?us-ascii?Q?kSydXSYJMpQxc5+7aKgJS4MdPbFwz1c2ZTHS6qKPnkiO7WM7kUYZNDGaOjhw?=
 =?us-ascii?Q?3pxrsAEVvGkLedlljrpMDpqDlVDzJ25q4MPVkOIwYqdunuMci/5QPJgq6vmN?=
 =?us-ascii?Q?MWVIMrMoTy3ZBg6A8d4Cag0/EfI+WgMvN+JfC93TJZ4fldXjNXDT0kKTh4eL?=
 =?us-ascii?Q?HSoXKcuwsbjRVNXb0MqBJs8O8aFU87FnHjX1wGRc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eef9d81-c4af-423b-9db5-08dad1a00dc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 00:24:18.2323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9F/Xp2PLU1/BstF4x9p+T9yOusydmJwWWr2TNe4KQ+bXWPoXreCiUUOZOyfktxTsmzh9vte8H01enCG4J3P7BfmU2WHycN0FpqHHquyO/xU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4610
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Vincent Mailhol
> Sent: Monday, November 28, 2022 4:06 PM
> To: Jiri Pirko <jiri@nvidia.com>; netdev@vger.kernel.org; Jakub Kicinski
> <kuba@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>; Shijith Thotton <sthotton@marvell.com>;
> Simon Horman <simon.horman@corigine.com>; Kurt Kanzenbach
> <kurt@linutronix.de>; Eric Dumazet <edumazet@google.com>; Jerin Jacob
> <jerinj@marvell.com>; Subbaraya Sundeep <sbhatta@marvell.com>; Ioana
> Ciornei <ioana.ciornei@nxp.com>; drivers@pensando.io; Linu Cherian
> <lcherian@marvell.com>; Florian Fainelli <f.fainelli@gmail.com>; Herbert =
Xu
> <herbert@gondor.apana.org.au>; Leon Romanovsky <leon@kernel.org>; linux-
> rdma@vger.kernel.org; Shalom Toledo <shalomt@mellanox.com>; Srujana
> Challa <schalla@marvell.com>; Minghao Chi <chi.minghao@zte.com.cn>; Hao
> Chen <chenhao288@hisilicon.com>; Guangbin Huang
> <huangguangbin2@huawei.com>; Shannon Nelson <snelson@pensando.io>;
> intel-wired-lan@lists.osuosl.org; Vadim Fedorenko <vadfed@fb.com>; Paolo
> Abeni <pabeni@redhat.com>; Yisen Zhuang <yisen.zhuang@huawei.com>; Sunil
> Goutham <sgoutham@marvell.com>; Ariel Elior <aelior@marvell.com>; Ido
> Schimmel <idosch@nvidia.com>; Richard Cochran <richardcochran@gmail.com>;
> Arnaud Ebalard <arno@natisbad.org>; Jiri Pirko <jiri@mellanox.com>; Micha=
el
> Chan <michael.chan@broadcom.com>; Vincent Mailhol
> <mailhol.vincent@wanadoo.fr>; Petr Machata <petrm@nvidia.com>; Salil Meht=
a
> <salil.mehta@huawei.com>; Dimitris Michailidis <dmichail@fungible.com>;
> Manish Chopra <manishc@marvell.com>; Boris Brezillon
> <bbrezillon@kernel.org>; oss-drivers@corigine.com; Vadim Pasternak
> <vadimp@mellanox.com>; linux-kernel@vger.kernel.org; David S . Miller
> <davem@davemloft.net>; Taras Chornyi <tchornyi@marvell.com>; hariprasad
> <hkelam@marvell.com>; linux-crypto@vger.kernel.org; Jonathan Lemon
> <jonathan.lemon@gmail.com>; Vladimir Oltean <olteanv@gmail.com>; Saeed
> Mahameed <saeedm@nvidia.com>; Geetha sowjanya <gakula@marvell.com>
> Subject: [Intel-wired-lan] [PATCH net-next v5 3/4] net: devlink: make the
> devlink_ops::info_get() callback optional
>=20
> Some drivers only reported the driver name in their
> devlink_ops::info_get() callback. Now that the core provides this
> information, the callback became empty. For such drivers, just
> removing the callback would prevent the core from executing
> devlink_nl_info_fill() meaning that "devlink dev info" would not
> return anything.
>=20
> Make the callback function optional by executing
> devlink_nl_info_fill() even if devlink_ops::info_get() is NULL.
>=20
> N.B.: the drivers with devlink support which previously did not
> implement devlink_ops::info_get() will now also be able to report
> the driver name.
>=20

Makes sense to me.

Thanks,
Jake
