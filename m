Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5147D6251D4
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 04:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiKKDlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 22:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiKKDlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 22:41:23 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBE718E20;
        Thu, 10 Nov 2022 19:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668138083; x=1699674083;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=3Ji/njsDXjLLXiEF16riT6+7XPdECAqNrMpXdCVdyfM=;
  b=cHDOYLkUBYOekzBC5MRErIExPcahbVhWIW2q3idxMfLn+XtWDBSIpZDr
   DBnvQaNe1xiL6fPZBSdDfJ04nZd+IJ+QMeQ8hCpsytOG/5EIYJ85vpmrH
   wYbfh87p9lMKoVfFVNNl3fXQbZhIGxi6vWZrnIQwnP0yjnCdfJOPlBhua
   5sJdbD9xFu/eyTpL0Nz6Bou+QcZMXpbtvWjrjS207Qwjo4sjONs7+Ln/G
   vdtB0qyRflyLSGaHzHbqinl9RrOBQdnna26AmCx1DAKaqqmKZy9guV1bM
   AGu89lkuLdrbUfw0NYKqffOeX/wUCVj9zTpdQ4MSiwoa+jwgJQdpOzWko
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="294869403"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="294869403"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:41:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="966681928"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="966681928"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 10 Nov 2022 19:41:22 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 19:41:22 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 19:41:21 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 19:41:21 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 19:41:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Srjb+4GtPW8MdjHvoTP0zh//rID95i+73f0PCxWratj1qvwZf3E4PFepfHnaNw06ebxWc7ljKXPnmEasusCTC11MwCJ05tC0hdNOouzbLBpbW3PQuS14IakIoEc4UQZFq7TemioDe3BtpXg3fFhrYv5lGXlIzbbnp7qsh12WbEQkmBrfJD1bz6u1FC2Lus32RDZuoP9nUcB7fUAxm2b+e39qqNH0+YX7cLjdpM9wvmiQgL3tvakocoS0zicL7/C4rIBIIwyJ6ePwhvnhFNwGDwIF+W+zGVhVzNcvDWPTCNl1v/6evCOUU9gGlOEJEMLlENRuVw4pD76T6N8Zc2ve/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Ji/njsDXjLLXiEF16riT6+7XPdECAqNrMpXdCVdyfM=;
 b=EybgBRpDSKBVn9uDqywhLO4C1sJHeQSoiNZ6dnSNxjn5uaNGl2vpz/qwuXzHWWg7zU3I0hy09LhjDwGM6FUXKLeOO+kUzHQueYNxQC2x5HDE1u2ykw/qUA/KQnCq2nOKSF9afF0rBun0+9Da7s6PGBLTq0SNxLdeTJ5oUsI7Yqm21FBEESjqAgDFy1vf5NBMtbaZRhEF8KIGuRTRodkaIbE/OPuKFCYsVAyDB91bJJJjEuUGRuLU75abcEP+77wklIwhR0NBRwIqV44ikEdFY+Tt6d5Ds3yA+lYr3Fw7ZFJxxHcxwIJYIex5cXLWBKXKKUQ2PciZ262cU6M9/9XwSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4348.namprd11.prod.outlook.com (2603:10b6:5:1db::18)
 by PH8PR11MB7070.namprd11.prod.outlook.com (2603:10b6:510:216::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 03:41:19 +0000
Received: from DM6PR11MB4348.namprd11.prod.outlook.com
 ([fe80::7c3c:eff3:9f4a:358]) by DM6PR11MB4348.namprd11.prod.outlook.com
 ([fe80::7c3c:eff3:9f4a:358%4]) with mapi id 15.20.5791.027; Fri, 11 Nov 2022
 03:41:18 +0000
From:   "Jamaluddin, Aminuddin" <aminuddin.jamaluddin@intel.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>
Subject: Recall: [PATCH net-next v2] net: phy: marvell: add sleep time after
 enabling the loopback bit
Thread-Topic: [PATCH net-next v2] net: phy: marvell: add sleep time after
 enabling the loopback bit
Thread-Index: AQHY9X91SrwmYSWwnUSX74ZpBF5nbQ==
X-CallingTelephoneNumber: IPM.Note
X-VoiceMessageDuration: 1
X-FaxNumberOfPages: 0
Date:   Fri, 11 Nov 2022 03:41:18 +0000
Message-ID: <DM6PR11MB43487B271E5000308AF0FA5181009@DM6PR11MB4348.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4348:EE_|PH8PR11MB7070:EE_
x-ms-office365-filtering-correlation-id: 427eb6cf-0fd2-42c8-2719-08dac39697fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UXN4lQX1U3e+xT8J7zOeb1tWG63VGhwwse7sOHxzdk8SFisGNOnDSy1TBi0/w8rHaFlQ2Q/OlJ0M6/tJUuK6U1GpbATWPujuTw3fVX+s1MiIAlFLygNUE5Khg3ZIW+8R1+uh0o8/X3OGvTuA8SDHR+IV9VJqLfKcJ3IFFLPZoLbkNTeP1uS8TsmYin7WcLidJEHDXkIG1sIExWcWJ4nR//WtGb2a186HkkAsyOqEPKE718jkITNKhjzG1y/EcXEtHdR2xneeI7Q8KlceHBIfXxADosK7XRAN74z3U1j2TZEKO81D6ASP/Q29wPsm5tTO30xsfUc9t+yIlLMv4FVQCA12MuWR8i6711uNatW9iTViiQt73nVe+a9wzgKxx6qEiByLkctIPDJtOEtv7+feAD9R3IBPGingTCd2EDUJnnL37sE3YJ31eAPmu/yVdRr/QJUWN6vBmC4XOf7CdxRUITJtUWYt0kklO6qb27m2y/0AWI/T5Zv+T6S3akoBsDuhoc57yqlKbF8hSHAC2eEFMtZv36zSs9/DuWQO2fEjID/vERQ7kRJZbs/q6LI9dD64J+9X+iCqk53xzRY5oFfh/K3RSfGM200eUVSGwBgMFsXwzp1WBHt15oIRzVIckWVAfXMMwkL3HJZDpL1jlSvypSb1G7SlkHu5oyckON7jal8kGaQQXzlqMBc9Bg284Uo27Li2mx54e1TWELvEliPHyp6bz03nKYJpJXe42UOe7iWnh9EY2uFyXajLEW5oyLeMQkUiFubXWPDQLOMW5NhbGbQmbMv8Dgkym/0wUI7HsSo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4348.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(39860400002)(136003)(346002)(396003)(451199015)(55016003)(558084003)(478600001)(83380400001)(7696005)(33656002)(921005)(6506007)(316002)(2906002)(86362001)(6636002)(76116006)(41300700001)(107886003)(9686003)(66946007)(8676002)(66476007)(66556008)(26005)(110136005)(66446008)(54906003)(64756008)(122000001)(82960400001)(71200400001)(38100700002)(4326008)(5660300002)(52536014)(38070700005)(7416002)(186003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4YZD2+j+TPF2CWBDDHuk3s1bgbDU8jALAWbE3RtBOXfwYdK9w3lWlkHbwK7c?=
 =?us-ascii?Q?HFJT5qEKLPJiSl6vfbXsFd4xdoafMqt1gOLyLOV0vA6uAdmJXGuyizk99pHv?=
 =?us-ascii?Q?f2QjhXuwmcAyW7Ec0gsKJAPzMp+Y8N10HgVSJUiAnfrscJvBQ5aAhgIwRdwh?=
 =?us-ascii?Q?IQUXl8o0zf+RTYlsqruBQtdoH2KIucDriCTQxTYJLvs96ZP6CD5rjNBs9RFK?=
 =?us-ascii?Q?3lmoVsYhkY7BflZorwNL0p55zWJUKlrVkDfaeYH4onlenNHc2WHts4xdQNTs?=
 =?us-ascii?Q?f/k6TQ7MpORiVx6FWiE+vYIU8ZR3Z4R8tkcbUtMKDq3QPYucDU0/T5svWBnT?=
 =?us-ascii?Q?IXlKeOcjRmRRiOoYSLClnM1BUzHp+YZi/A2kCIYKOEqY2aRRIED+NJwdFEEy?=
 =?us-ascii?Q?OtVqsORzQOBjDiil3oC5LIZ0l9GX3h3GmmK0gKCbBi7OVxUCe5YZEfEu448F?=
 =?us-ascii?Q?SxFP1V1svr770cypXuAtJLKNM40KZEz5duwOKziJeF4tmomO08YOSrW9LUW8?=
 =?us-ascii?Q?2F3oiI+jcxw16Im5oWuSX+kLEg28xLV5EEesIjiY0zMSUw/W6JvgLpNh+qGc?=
 =?us-ascii?Q?MKLMUZDD0YNCvc2rTvOtx64hvhB9tqLqUdFXp1FuUi9zYBjhdtrK5jPx8xUt?=
 =?us-ascii?Q?yS63llVvXdyFbgOmsAbvolum8I/5sKaHv4kyVDzvmima2/u7os5bURmN9zS+?=
 =?us-ascii?Q?RThQKtuRJF8LzFeTytMWHJeGoJqK6eFqNYDdLtA4Jl3Ym9h+W+5VzrFxi4w/?=
 =?us-ascii?Q?WsuELGz7vaYkBxy0A5e8U8NMyJaQES5ULYpCv3n7Uv8c5gqDSCqLbnFXtV4U?=
 =?us-ascii?Q?5YFT9aRLrEmWckvLsLoAEJ/FWiOox0kfkaQOklEWZuaNRKCWrICykS/t7QvW?=
 =?us-ascii?Q?uHu3cyOl6D+mhctvFjIkeixdkgdgsAi9pLeSuNLDjD7ZTNvkTZXJg9drA/3d?=
 =?us-ascii?Q?fe77YlVsC1KjIAcNauW/8yC6h/QQR7IOd28kK63w04nrPa8rZLbiagsboATB?=
 =?us-ascii?Q?OrpTjlcf5UGi3sJAmFgBU/9AvPqkySetVhnqcuOUtRafvRz1KOelikBflTEi?=
 =?us-ascii?Q?sa7xnJydD6DW+pge5OkM5o+eH+QXQyBJ80lp8s1Fm741hvqSH8ifmBzwFVlx?=
 =?us-ascii?Q?VH3X53oevCBCpLY/iQa/2M34ASpEKvtSaj4PVn3B1Sj1XOP5jBe7jG+eB2jN?=
 =?us-ascii?Q?UofxCPTNI/Vbj0jGYpDQYbhAI08AT6A7yPch7Zi4rQbY6z2DYo+7DFBAMRSN?=
 =?us-ascii?Q?4xMecr4FeNnjYA61kStLVWLjFM/FPA/hDAv2pR7n+dqaXguiwxveptwAn04Y?=
 =?us-ascii?Q?0GfrC+TnzjKcwIkigMKetlJ+ZQizSizAKnnq1Xp4NkcedLnxcngMv0Z6hiQ4?=
 =?us-ascii?Q?4n6Bk1gliyA7hdqEBMnt+R2Sr0VmqTnImvP7yOV/jFb65xedAaMUlHUa7qP+?=
 =?us-ascii?Q?+jQ66WYzFSb0UzSnO0HC/w36aOy8sjqdaEVxN5S6uLavpPCvHgcjoCjNkJLR?=
 =?us-ascii?Q?QZwk+SPqHVbwC2BLinOg899GvP9Z6QkeL7HeaRM29ls+sk8liF38bvFpPMzZ?=
 =?us-ascii?Q?qKxY6EBwih408X5EH+HlTSysdy4OLf5Fs+vLkVCOeIzVffeZR7veVOq2eOcQ?=
 =?us-ascii?Q?og=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4348.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 427eb6cf-0fd2-42c8-2719-08dac39697fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 03:41:18.8116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c3XZLrJhPP41Gkh8bciYYou1M8E4CImOecTjZOGVnIDz8zHphkK8n0SKrlARfsEB9UZoKWYOAY+7pjG6Ts94qbzJYReRnp8ag6n75GHbTM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7070
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jamaluddin, Aminuddin would like to recall the message, "[PATCH net-next v2=
] net: phy: marvell: add sleep time after enabling the loopback bit".=
