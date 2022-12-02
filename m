Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A0A6405CC
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 12:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbiLBL15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 06:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiLBL1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 06:27:43 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9381118;
        Fri,  2 Dec 2022 03:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669980460; x=1701516460;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6Cx4fjTosYrReIL9+2JHK4nHIlm/gKP1lulySshKZcY=;
  b=MIhxfYac1ij4oAamiDX9rpROX/Xw4VZI4GqvmtYr1YkVAVmEiEKdCp9v
   jUWNMZ/c/aUQkB/EtZZHrqWhRVNBDmpnz/TtVURz2z8XAzpVXX7CkD810
   q+l1tQFwJjX/SnwSmXDuY4mnkKlB7iYG0sBjJHrZoPOsk04zouz3DcRsq
   z9OG6FBF0Bnwf5VKQmKlzD/ldSiF4U9us54epeLaV28qfps3mB8VtaOL7
   LY0w8gATBnvssFv3oY3mue9gzBLHjdHaqKQmzINz1TR3I2etlU3VEGzSb
   kNWi9q2dOXMxDXcB5NLqHJCtNtuXW8CcRW5fPdAk3WoHzv5TDWH8OMi0H
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317083535"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="317083535"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 03:27:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="708448657"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="708448657"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 02 Dec 2022 03:27:38 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 03:27:38 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 03:27:38 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 03:27:38 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 03:27:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctdHeSacFdt9NTXG4aRiUHP6ihj1OvNYDy7p4oWiEpQX4TVBgUUsXYpD36HZFgZ3VsoyItBnHLYtQWWiz9Rxnflcy0L2VtOXcBn6d3j2yOHuZNJAu4bVCCU5A7lfrtfp0ugFigv7zgXq+cCL8SzIAC5qqwVH4ZNFxSkjH53cGt/ocULqXq9cMzwuwYY3z2idma7Pfw4M/vZISCBRjQZDwmCuFEwXTbdoyLP2okqh/ciU5HVmJxlue1MpMfHjJldUbfkNv5F1vV8Ty2pUeaw5y6TL9lI9ckqg0GFetuQfdDPVDIYIkCM2O5EOm54A93PPykMEe3D5ATstoh6gkmauvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AGwziU/a9EbdgEdbBSkd59MKuukmcwXwNOBt30EK7D0=;
 b=I9aBFwrgwtf7yyYKN/06/6v5RGoQKkvK+oThgz1n4fY8Fd8HA9/AQT4X6a2NaXBmFgT93UZpY1jsQR6b7eB0IJSGF1DmvPF3glbleENK3asXXu7oxnX0MZ1QpM8oJ2MBc/8jNZkkQkLo7J/9912cgWtMDwSNTlU5macf7NlY+1B5Zljx1sTcKcuLQtzZsL62MEoAV72DyR6XxOcrpQiR4tqpNOg8O3ljBmCRnohezHj5dmKC7d880hGZddAn9+lvDC09ncWLacNa0FBz+poaIE0e681Xm6dD+a9dr05QuTHJmS6NekpSoRiI15RyQYC4WVdoq/xc56Ajp2QAKUnb3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.10; Fri, 2 Dec 2022 11:27:35 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%8]) with mapi id 15.20.5880.010; Fri, 2 Dec 2022
 11:27:35 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        Vadim Fedorenko <vfedorenko@novek.ru>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: RE: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Thread-Index: AQHZBDrzHhOO6jCKv0uW33ic8hB1f65Xq5eAgALEiZA=
Date:   Fri, 2 Dec 2022 11:27:35 +0000
Message-ID: <DM6PR11MB4657DE713E4E83E09DFCFA4B9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-3-vfedorenko@novek.ru> <Y4eGxb2i7uwdkh1T@nanopsycho>
In-Reply-To: <Y4eGxb2i7uwdkh1T@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_
x-ms-office365-filtering-correlation-id: 650a7509-855a-4b95-16c3-08dad4583626
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nm88XkM4M2sr+yYoYtWXF95KjhlqUx8j2r3JKbwo8l5fe9ztDnjdDpbGmoMHG+EYgP9u894SenVxjF4FbE7TQc1+/3sy2OkAef/g+XExgwDXpV0u/nzUVeFKTxUNgYMU6rrP0Tup2O73jseSag9DTVpOK7YFl6aLJ+Lz3f4UJMHadkuMO51P38GgFJJQgwXNzjM45ffYKuyUBVrFxJp4UP0vcYAnInpo9OACOgbkZgn8/zRpgqwQz3nIxvo49F/a8upN5t0GipsezwwZD951Vx+j2FqON0Wwg1acEqvrnXOriZhMIjsAjaxMRnCiPnvdig0WhD3qMI2oTBm6V2RI1OqAfcnQ2eycWF5KixNsN+uhP3xk8MdzadqE964t2yV6l25di+UXhr1TTMQzcmypPQqFnHha9p9e+efHJNSJVmTWEaRK3R47dsol5VMBVFCgxDNhv2IYs875UlM+pinjfH1mbG2OuL6gKWmUi0g5LXsK5hJ/DpMn3l4MtLW2EycMVLY3pLERPZt1FD/HcVu/uvHWNPtGnR5q4y+ZspVLCMK9zc8JI+Wl+p7IVzzcYgr4rgNDkx/uj+A/YfC50Q0hFjD05ulx17xoV9Pd59IYFbjmEET/J/RRF36MuhW3xUuaw+muwzT1wt8qJmi2wangwoq43LfPBiizzl3beiYgPVBbtEHn1jnMxuJIOT1zZ53WQKrLev4LD6EM7tTBru6eVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(55016003)(33656002)(316002)(186003)(26005)(9686003)(54906003)(110136005)(41300700001)(30864003)(83380400001)(8936002)(52536014)(5660300002)(76116006)(66476007)(66556008)(66446008)(64756008)(66946007)(2906002)(4326008)(8676002)(478600001)(38070700005)(122000001)(6506007)(7696005)(107886003)(86362001)(71200400001)(38100700002)(82960400001)(579004)(559001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Nvp0G+y5rdaw4uU2ur5LSvPtF1rR3cmlBMsCT5dxLliNJbeg97bgYYfLf4CF?=
 =?us-ascii?Q?41NKZSIQetQE9fFULbP0L9aHiVlk6Mbb5dFT9MMLKjV7VuB+eZTf6PbJP5Ih?=
 =?us-ascii?Q?FEsw6xWnEBe2ZHHQG33S5nM/YyG4V7FHq2I99swGBw873KogWwdUFv96IatT?=
 =?us-ascii?Q?2XuDUWv/MaT5U3SNRd2ecf+wWR28qlW6tNRCHoZOrSah1njJWZnCjFQPxHk/?=
 =?us-ascii?Q?AHl6gmA8Z4WuQALF8LXOUFnNUVzAoWWVXNZdIqdu94fPZgCDgyhpOXPKO+/h?=
 =?us-ascii?Q?ObuJ17GHb5Lrkhodw+BBVZVOr964R8lFC/52zEDyCDkkR7SpXbJSgyAhJ2as?=
 =?us-ascii?Q?PW5oqS/zd2JtKiBmg4/m4fGGQzxj//v4RQg69OMnYl1ogFof8/3XV8N1M+y3?=
 =?us-ascii?Q?vM69yvDrX6x/UPj9Lie5l5QkH9Rm1H8y2CFzpqqSkKTRt+WmaaTw9HWKJVeo?=
 =?us-ascii?Q?ajZ/ZlnYTrLch8w8h9kvwHSO9pIMGVj6Y2y0m1VgeHZwO/9Lw2A7i4BGooKJ?=
 =?us-ascii?Q?FVjXFB3QGFZ5DN6L1yIrwKWKuJoYgYlUy5IBx26gYM8/B1Ldc9EuwOymM9A8?=
 =?us-ascii?Q?X7c8Al0n9Ymvy6YTcjtxBGTqFrP6Xl3eCCFF7oN7wRyrja9PC/qkZWZVCTC6?=
 =?us-ascii?Q?yiOyZt04nBrOH0K8IYD42oZ6RT4cpXH43Zyi4jZHtuFF1X2oqxCeaK15vyKl?=
 =?us-ascii?Q?bekhjeLbD6z/UoaOmBolEvsFqxZyi5pXatuOXZaQ9tPXxa33gwCrnlMPdI9P?=
 =?us-ascii?Q?vK3UFeQxNZiBoc/bsh8QEoHpkJ6oLM9h+dsQI3jrDOC3p+guXl+GRuvpa0el?=
 =?us-ascii?Q?KtE/ZgTLXMQSfD1XqFLyPP3/W+9/RPotFznAHkH/duulxFmqBceJhgJuEVBM?=
 =?us-ascii?Q?CMui/ffurfnHTmCzPTapREHuL8sxTciJYonf8mWzR1NlVayR8Z/EK2Ep/t4o?=
 =?us-ascii?Q?dHEkS/x2eVx2McUNNoSJHqJr6dT4FMrUMSfaEyd38r0dxc0qFS1+Ri3R+M7r?=
 =?us-ascii?Q?Q+q/Y/urTn4ZalBsl9tgyrN2EdBu3HmPgHkz2FTxQXG5xzBZujYHyd8d8YZp?=
 =?us-ascii?Q?a3WKmGiuRwdKBe13/NdSE6Qm3mrGwmEgoQsrE5pzz4iZy+hpl7784uMbPICH?=
 =?us-ascii?Q?PR848HqOnwPsMNH9EGv4Vj7pjXMnH0C/dWK6cI/7A2iPC16ortWfljg/Oq/T?=
 =?us-ascii?Q?Rz8LErBTcxQrfj0FAgKKLjhdqXG+aGF3dmiXunWzR+L/NbaucFxcrNMdxTKJ?=
 =?us-ascii?Q?WMMTsrbwRJnfmt9WntI54+WmHMjrBQtJnzz/5EacCZt2NCYNoPvApE+KImk3?=
 =?us-ascii?Q?MxZfyqTtquyWxtZtruvqx3B+KTT/O1Pa+RwVwrVYcR2jJRgg3q8AxI37aOGX?=
 =?us-ascii?Q?RAqxy+/JU2p4INt4Fq3dOknx/zlH2OlhKfiv9cHWy5AQT9r9W9rdAZh6IiiE?=
 =?us-ascii?Q?O16zM0KyiEHd/wzl6VIxg/FaxzQX/KURSdS/tAiKqisBU8/TNBoIFrYPho4W?=
 =?us-ascii?Q?0ck/Iv4R/08IZkGibgE079aipAYZHws6kCIx0C5dPw0xFmKXws55+IQfMIWC?=
 =?us-ascii?Q?YvkqJkUHHucqUExldb8FIltD8py/8JsCEgFYrkynuN676Kmpc0cZj6GfWtVC?=
 =?us-ascii?Q?bg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 650a7509-855a-4b95-16c3-08dad4583626
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 11:27:35.6863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yy41mb57lZ+pqrVQslnS14RNXNdpfpvzY2TOwL0H/Bj5SG5ZWUBYRC9P5mv0OjKQn66qX0sElNwfmRy9iobbUb0FueAVenOfLJ642MHs/Ro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4657
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Wednesday, November 30, 2022 5:37 PM
>Tue, Nov 29, 2022 at 10:37:22PM CET, vfedorenko@novek.ru wrote:
>>From: Vadim Fedorenko <vadfed@fb.com>
>
>[...]
>
>>+
>>+static const struct nla_policy dpll_cmd_device_get_policy[] =3D {
>>+	[DPLLA_ID]		=3D { .type =3D NLA_U32 },
>>+	[DPLLA_NAME]		=3D { .type =3D NLA_STRING,
>>+				    .len =3D DPLL_NAME_LEN },
>>+	[DPLLA_DUMP_FILTER]	=3D { .type =3D NLA_U32 },
>>+	[DPLLA_NETIFINDEX]	=3D { .type =3D NLA_U32 },
>
>Only pin has a netdevice not the dpll. Also does not make sense to allow
>as an input attr.

Yes, this part shall be removed.

>
>
>>+};
>>+
>>+static const struct nla_policy dpll_cmd_device_set_policy[] =3D {
>>+	[DPLLA_ID]		=3D { .type =3D NLA_U32 },
>>+	[DPLLA_NAME]		=3D { .type =3D NLA_STRING,
>>+				    .len =3D DPLL_NAME_LEN },
>>+	[DPLLA_MODE]		=3D { .type =3D NLA_U32 },
>>+	[DPLLA_SOURCE_PIN_IDX]	=3D { .type =3D NLA_U32 },
>>+};
>>+
>>+static const struct nla_policy dpll_cmd_pin_set_policy[] =3D {
>>+	[DPLLA_ID]		=3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_IDX]		=3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_TYPE]	=3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_SIGNAL_TYPE]	=3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_CUSTOM_FREQ] =3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_STATE]	=3D { .type =3D NLA_U32 },
>>+	[DPLLA_PIN_PRIO]	=3D { .type =3D NLA_U32 },
>>+};
>>+
>>+struct dpll_param {
>>+	struct netlink_callback *cb;
>>+	struct sk_buff *msg;
>>+	struct dpll_device *dpll;
>>+	struct dpll_pin *pin;
>>+	enum dpll_event_change change_type;
>>+};
>>+
>>+struct dpll_dump_ctx {
>>+	int dump_filter;
>>+};
>>+
>>+typedef int (*cb_t)(struct dpll_param *);
>>+
>>+static struct genl_family dpll_gnl_family;
>>+
>>+static struct dpll_dump_ctx *dpll_dump_context(struct netlink_callback
>*cb)
>>+{
>>+	return (struct dpll_dump_ctx *)cb->ctx;
>>+}
>>+
>>+static int dpll_msg_add_id(struct sk_buff *msg, u32 id)
>>+{
>>+	if (nla_put_u32(msg, DPLLA_ID, id))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_name(struct sk_buff *msg, const char *name)
>>+{
>>+	if (nla_put_string(msg, DPLLA_NAME, name))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int __dpll_msg_add_mode(struct sk_buff *msg, enum dplla msg_type,
>>+			       enum dpll_mode mode)
>>+{
>>+	if (nla_put_s32(msg, msg_type, mode))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_mode(struct sk_buff *msg, const struct dpll_attr
>*attr)
>>+{
>>+	enum dpll_mode m =3D dpll_attr_mode_get(attr);
>>+
>>+	if (m =3D=3D DPLL_MODE_UNSPEC)
>>+		return 0;
>>+
>>+	return __dpll_msg_add_mode(msg, DPLLA_MODE, m);
>>+}
>>+
>>+static int dpll_msg_add_modes_supported(struct sk_buff *msg,
>>+					const struct dpll_attr *attr)
>>+{
>>+	enum dpll_mode i;
>>+	int  ret =3D 0;
>>+
>>+	for (i =3D DPLL_MODE_UNSPEC + 1; i <=3D DPLL_MODE_MAX; i++) {
>>+		if (dpll_attr_mode_supported(attr, i)) {
>>+			ret =3D __dpll_msg_add_mode(msg, DPLLA_MODE_SUPPORTED, i);
>>+			if (ret)
>>+				return -EMSGSIZE;
>>+		}
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_msg_add_source_pin(struct sk_buff *msg, struct dpll_attr
>*attr)
>>+{
>>+	u32 source_idx;
>>+
>>+	if (dpll_attr_source_idx_get(attr, &source_idx))
>>+		return 0;
>>+	if (nla_put_u32(msg, DPLLA_SOURCE_PIN_IDX, source_idx))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_netifindex(struct sk_buff *msg, struct dpll_attr
>*attr)
>>+{
>>+	unsigned int netifindex; // TODO: Should be u32?
>>+
>>+	if (dpll_attr_netifindex_get(attr, &netifindex))
>>+		return 0;
>>+	if (nla_put_u32(msg, DPLLA_NETIFINDEX, netifindex))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_lock_status(struct sk_buff *msg, struct dpll_att=
r
>*attr)
>>+{
>>+	enum dpll_lock_status s =3D dpll_attr_lock_status_get(attr);
>>+
>>+	if (s =3D=3D DPLL_LOCK_STATUS_UNSPEC)
>>+		return 0;
>>+	if (nla_put_s32(msg, DPLLA_LOCK_STATUS, s))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_temp(struct sk_buff *msg, struct dpll_attr *attr=
)
>>+{
>>+	s32 temp;
>>+
>>+	if (dpll_attr_temp_get(attr, &temp))
>>+		return 0;
>>+	if (nla_put_u32(msg, DPLLA_TEMP, temp))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_idx(struct sk_buff *msg, u32 pin_idx)
>>+{
>>+	if (nla_put_u32(msg, DPLLA_PIN_IDX, pin_idx))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_description(struct sk_buff *msg,
>>+					const char *description)
>>+{
>>+	if (nla_put_string(msg, DPLLA_PIN_DESCRIPTION, description))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_parent_idx(struct sk_buff *msg, u32
>parent_idx)
>>+{
>>+	if (nla_put_u32(msg, DPLLA_PIN_PARENT_IDX, parent_idx))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int __dpll_msg_add_pin_type(struct sk_buff *msg, enum dplla attr,
>>+				   enum dpll_pin_type type)
>>+{
>>+	if (nla_put_s32(msg, attr, type))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_type(struct sk_buff *msg, const struct dpll_pin_attr
>*attr)
>>+{
>>+	enum dpll_pin_type t =3D dpll_pin_attr_type_get(attr);
>>+
>>+	if (t =3D=3D DPLL_PIN_TYPE_UNSPEC)
>>+		return 0;
>>+
>>+	return __dpll_msg_add_pin_type(msg, DPLLA_PIN_TYPE, t);
>>+}
>>+
>>+static int dpll_msg_add_pin_types_supported(struct sk_buff *msg,
>>+					    const struct dpll_pin_attr *attr)
>>+{
>>+	enum dpll_pin_type i;
>>+	int ret;
>>+
>>+	for (i =3D DPLL_PIN_TYPE_UNSPEC + 1; i <=3D DPLL_PIN_TYPE_MAX; i++) {
>>+		if (dpll_pin_attr_type_supported(attr, i)) {
>>+			ret =3D __dpll_msg_add_pin_type(msg,
>>+						      DPLLA_PIN_TYPE_SUPPORTED,
>>+						      i);
>>+			if (ret)
>>+				return ret;
>>+		}
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+static int __dpll_msg_add_pin_signal_type(struct sk_buff *msg,
>>+					  enum dplla attr,
>>+					  enum dpll_pin_signal_type type)
>>+{
>>+	if (nla_put_s32(msg, attr, type))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_signal_type(struct sk_buff *msg,
>>+					const struct dpll_pin_attr *attr)
>>+{
>>+	enum dpll_pin_signal_type t =3D dpll_pin_attr_signal_type_get(attr);
>>+
>>+	if (t =3D=3D DPLL_PIN_SIGNAL_TYPE_UNSPEC)
>>+		return 0;
>>+
>>+	return __dpll_msg_add_pin_signal_type(msg, DPLLA_PIN_SIGNAL_TYPE, t);
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_signal_types_supported(struct sk_buff *msg,
>>+					const struct dpll_pin_attr *attr)
>>+{
>>+	const enum dplla da =3D DPLLA_PIN_SIGNAL_TYPE_SUPPORTED;
>>+	enum dpll_pin_signal_type i;
>>+	int ret;
>>+
>>+	for (i =3D DPLL_PIN_SIGNAL_TYPE_UNSPEC + 1;
>>+	     i <=3D DPLL_PIN_SIGNAL_TYPE_MAX; i++) {
>>+		if (dpll_pin_attr_signal_type_supported(attr, i)) {
>>+			ret =3D __dpll_msg_add_pin_signal_type(msg, da, i);
>>+			if (ret)
>>+				return ret;
>>+		}
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_custom_freq(struct sk_buff *msg,
>>+					const struct dpll_pin_attr *attr)
>>+{
>>+	u32 freq;
>>+
>>+	if (dpll_pin_attr_custom_freq_get(attr, &freq))
>>+		return 0;
>>+	if (nla_put_u32(msg, DPLLA_PIN_CUSTOM_FREQ, freq))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_states(struct sk_buff *msg,
>>+				   const struct dpll_pin_attr *attr)
>>+{
>>+	enum dpll_pin_state i;
>>+
>>+	for (i =3D DPLL_PIN_STATE_UNSPEC + 1; i <=3D DPLL_PIN_STATE_MAX; i++)
>>+		if (dpll_pin_attr_state_enabled(attr, i))
>>+			if (nla_put_s32(msg, DPLLA_PIN_STATE, i))
>>+				return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_msg_add_pin_states_supported(struct sk_buff *msg,
>>+					     const struct dpll_pin_attr *attr)
>>+{
>>+	enum dpll_pin_state i;
>>+
>>+	for (i =3D DPLL_PIN_STATE_UNSPEC + 1; i <=3D DPLL_PIN_STATE_MAX; i++)
>>+		if (dpll_pin_attr_state_supported(attr, i))
>>+			if (nla_put_s32(msg, DPLLA_PIN_STATE_SUPPORTED, i))
>>+				return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_prio(struct sk_buff *msg, const struct dpll_pin_attr
>*attr)
>>+{
>>+	u32 prio;
>>+
>>+	if (dpll_pin_attr_prio_get(attr, &prio))
>>+		return 0;
>>+	if (nla_put_u32(msg, DPLLA_PIN_PRIO, prio))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_pin_netifindex(struct sk_buff *msg, const struct
>dpll_pin_attr *attr)
>>+{
>>+	unsigned int netifindex; // TODO: Should be u32?
>>+
>>+	if (dpll_pin_attr_netifindex_get(attr, &netifindex))
>>+		return 0;
>>+	if (nla_put_u32(msg, DPLLA_PIN_NETIFINDEX, netifindex))
>
>I was thinking about this. It is problematic. DPLL has no notion of
>network namespaces. So if the driver passes ifindex, dpll/user has no
>clue in which network namespace it is (ifindexes ovelay in multiple
>namespaces).
>
>There is no easy/nice solution. For now, I would go without this and
>only have linkage the opposite direction, from netdev to dpll.

Well, makes sense to me.
Although as I have checked `ip a` showed the same ifindex either if port wa=
s
in the namespace or not.
Isn't it better to let the user know ifindex, even if he has to iterate all
the namespaces he has created?

>
>
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_msg_add_event_change_type(struct sk_buff *msg,
>>+			       enum dpll_event_change event)
>>+{
>>+	if (nla_put_s32(msg, DPLLA_CHANGE_TYPE, event))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+__dpll_cmd_device_dump_one(struct sk_buff *msg, struct dpll_device *dpll=
)
>>+{
>>+	int ret =3D dpll_msg_add_id(msg, dpll_id(dpll));
>>+
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_name(msg, dpll_dev_name(dpll));
>>+
>>+	return ret;
>>+}
>>+
>>+static int
>>+__dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_device *dpll,
>>+			struct dpll_pin *pin)
>>+{
>>+	struct dpll_pin_attr *attr =3D dpll_pin_attr_alloc();
>>+	struct dpll_pin *parent =3D NULL;
>>+	int ret;
>>+
>>+	if (!attr)
>>+		return -ENOMEM;
>>+	ret =3D dpll_msg_add_pin_idx(msg, dpll_pin_idx(dpll, pin));
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_description(msg,
>dpll_pin_get_description(pin));
>>+	if (ret)
>>+		goto out;
>>+	parent =3D dpll_pin_get_parent(pin);
>>+	if (parent) {
>>+		ret =3D dpll_msg_add_pin_parent_idx(msg, dpll_pin_idx(dpll,
>>+								    parent));
>>+		if (ret)
>>+			goto out;
>>+	}
>>+	ret =3D dpll_pin_get_attr(dpll, pin, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_type(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_types_supported(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_signal_type(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_signal_types_supported(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_custom_freq(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_states(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_states_supported(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_prio(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+	ret =3D dpll_msg_add_pin_netifindex(msg, attr);
>>+	if (ret)
>>+		goto out;
>>+out:
>>+	dpll_pin_attr_free(attr);
>>+
>>+	return ret;
>>+}
>>+
>>+static int __dpll_cmd_dump_pins(struct sk_buff *msg, struct dpll_device
>*dpll)
>>+{
>>+	struct dpll_pin *pin;
>>+	struct nlattr *attr;
>>+	unsigned long i;
>>+	int ret =3D 0;
>>+
>>+	for_each_pin_on_dpll(dpll, pin, i) {
>>+		attr =3D nla_nest_start(msg, DPLLA_PIN);
>>+		if (!attr) {
>>+			ret =3D -EMSGSIZE;
>>+			goto nest_cancel;
>>+		}
>>+		ret =3D __dpll_cmd_pin_dump_one(msg, dpll, pin);
>>+		if (ret)
>>+			goto nest_cancel;
>>+		nla_nest_end(msg, attr);
>>+	}
>>+
>>+	return ret;
>>+
>>+nest_cancel:
>>+	nla_nest_cancel(msg, attr);
>>+	return ret;
>>+}
>>+
>>+static int
>>+__dpll_cmd_dump_status(struct sk_buff *msg, struct dpll_device *dpll)
>>+{
>>+	struct dpll_attr *attr =3D dpll_attr_alloc();
>>+	int ret =3D dpll_get_attr(dpll, attr);
>>+
>>+	if (ret)
>>+		return -EAGAIN;
>>+	if (dpll_msg_add_source_pin(msg, attr))
>>+		return -EMSGSIZE;
>>+	if (dpll_msg_add_temp(msg, attr))
>>+		return -EMSGSIZE;
>>+	if (dpll_msg_add_lock_status(msg, attr))
>>+		return -EMSGSIZE;
>>+	if (dpll_msg_add_mode(msg, attr))
>>+		return -EMSGSIZE;
>>+	if (dpll_msg_add_modes_supported(msg, attr))
>>+		return -EMSGSIZE;
>>+	if (dpll_msg_add_netifindex(msg, attr))
>>+		return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>>+static int
>>+dpll_device_dump_one(struct dpll_device *dpll, struct sk_buff *msg,
>>+		     int dump_filter)
>>+{
>>+	int ret;
>>+
>>+	dpll_lock(dpll);
>>+	ret =3D __dpll_cmd_device_dump_one(msg, dpll);
>>+	if (ret)
>>+		goto out_unlock;
>>+
>>+	if (dump_filter & DPLL_DUMP_FILTER_STATUS) {
>>+		ret =3D __dpll_cmd_dump_status(msg, dpll);
>>+		if (ret)
>>+			goto out_unlock;
>>+	}
>>+	if (dump_filter & DPLL_DUMP_FILTER_PINS)
>>+		ret =3D __dpll_cmd_dump_pins(msg, dpll);
>>+	dpll_unlock(dpll);
>>+
>>+	return ret;
>>+out_unlock:
>>+	dpll_unlock(dpll);
>>+	return ret;
>>+}
>>+
>>+static enum dpll_pin_type dpll_msg_read_pin_type(struct nlattr *a)
>>+{
>>+	return nla_get_s32(a);
>>+}
>>+
>>+static enum dpll_pin_signal_type dpll_msg_read_pin_sig_type(struct nlatt=
r
>*a)
>>+{
>>+	return nla_get_s32(a);
>>+}
>>+
>>+static u32 dpll_msg_read_pin_custom_freq(struct nlattr *a)
>>+{
>>+	return nla_get_u32(a);
>>+}
>>+
>>+static enum dpll_pin_state dpll_msg_read_pin_state(struct nlattr *a)
>>+{
>>+	return nla_get_s32(a);
>>+}
>>+
>>+static u32 dpll_msg_read_pin_prio(struct nlattr *a)
>>+{
>>+	return nla_get_u32(a);
>>+}
>>+
>>+static u32 dpll_msg_read_dump_filter(struct nlattr *a)
>>+{
>>+	return nla_get_u32(a);
>>+}
>>+
>>+static int
>>+dpll_pin_attr_from_nlattr(struct dpll_pin_attr *pa, struct genl_info
>*info)
>>+{
>>+	enum dpll_pin_signal_type st;
>>+	enum dpll_pin_state state;
>>+	enum dpll_pin_type t;
>>+	struct nlattr *a;
>>+	int rem, ret =3D 0;
>>+	u32 prio, freq;
>>+
>>+	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
>>+			  genlmsg_len(info->genlhdr), rem) {
>>+		switch (nla_type(a)) {
>>+		case DPLLA_PIN_TYPE:
>>+			t =3D dpll_msg_read_pin_type(a);
>>+			ret =3D dpll_pin_attr_type_set(pa, t);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLLA_PIN_SIGNAL_TYPE:
>>+			st =3D dpll_msg_read_pin_sig_type(a);
>>+			ret =3D dpll_pin_attr_signal_type_set(pa, st);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLLA_PIN_CUSTOM_FREQ:
>>+			freq =3D dpll_msg_read_pin_custom_freq(a);
>>+			ret =3D dpll_pin_attr_custom_freq_set(pa, freq);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLLA_PIN_STATE:
>>+			state =3D dpll_msg_read_pin_state(a);
>>+			ret =3D dpll_pin_attr_state_set(pa, state);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLLA_PIN_PRIO:
>>+			prio =3D dpll_msg_read_pin_prio(a);
>>+			ret =3D dpll_pin_attr_prio_set(pa, prio);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		default:
>>+			break;
>>+		}
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_cmd_pin_set(struct sk_buff *skb, struct genl_info *info)
>>+{
>>+	struct dpll_pin_attr *old =3D NULL, *new =3D NULL, *delta =3D NULL;
>>+	struct dpll_device *dpll =3D info->user_ptr[0];
>>+	struct nlattr **attrs =3D info->attrs;
>>+	struct dpll_pin *pin;
>>+	int ret, pin_id;
>>+
>>+	if (!attrs[DPLLA_PIN_IDX])
>>+		return -EINVAL;
>>+	pin_id =3D nla_get_u32(attrs[DPLLA_PIN_IDX]);
>>+	old =3D dpll_pin_attr_alloc();
>>+	new =3D dpll_pin_attr_alloc();
>>+	delta =3D dpll_pin_attr_alloc();
>>+	if (!old || !new || !delta) {
>>+		ret =3D -ENOMEM;
>>+		goto mem_free;
>>+	}
>>+	dpll_lock(dpll);
>>+	pin =3D dpll_pin_get_by_idx(dpll, pin_id);
>>+	if (!pin) {
>>+		ret =3D -ENODEV;
>>+		goto mem_free_unlock;
>>+	}
>>+	ret =3D dpll_pin_get_attr(dpll, pin, old);
>>+	if (ret)
>>+		goto mem_free_unlock;
>>+	ret =3D dpll_pin_attr_from_nlattr(new, info);
>>+	if (ret)
>>+		goto mem_free_unlock;
>>+	ret =3D dpll_pin_attr_delta(delta, new, old);
>>+	dpll_unlock(dpll);
>>+	if (!ret)
>>+		ret =3D dpll_pin_set_attr(dpll, pin, delta);
>>+	else
>>+		ret =3D -EINVAL;
>>+
>>+	dpll_pin_attr_free(delta);
>>+	dpll_pin_attr_free(new);
>>+	dpll_pin_attr_free(old);
>>+
>>+	return ret;
>>+
>>+mem_free_unlock:
>>+	dpll_unlock(dpll);
>>+mem_free:
>>+	dpll_pin_attr_free(delta);
>>+	dpll_pin_attr_free(new);
>>+	dpll_pin_attr_free(old);
>>+	return ret;
>>+}
>>+
>>+enum dpll_mode dpll_msg_read_mode(struct nlattr *a)
>>+{
>>+	return nla_get_s32(a);
>>+}
>>+
>>+u32 dpll_msg_read_source_pin_id(struct nlattr *a)
>>+{
>>+	return nla_get_u32(a);
>>+}
>>+
>>+static int
>>+dpll_attr_from_nlattr(struct dpll_attr *dpll, struct genl_info *info)
>>+{
>>+	enum dpll_mode m;
>>+	struct nlattr *a;
>>+	int rem, ret =3D 0;
>>+	u32 source_pin;
>>+
>>+	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
>>+			  genlmsg_len(info->genlhdr), rem) {
>>+		switch (nla_type(a)) {
>>+		case DPLLA_MODE:
>>+			m =3D dpll_msg_read_mode(a);
>>+
>>+			ret =3D dpll_attr_mode_set(dpll, m);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		case DPLLA_SOURCE_PIN_IDX:
>>+			source_pin =3D dpll_msg_read_source_pin_id(a);
>>+
>>+			ret =3D dpll_attr_source_idx_set(dpll, source_pin);
>>+			if (ret)
>>+				return ret;
>>+			break;
>>+		default:
>>+			break;
>>+		}
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_cmd_device_set(struct sk_buff *skb, struct genl_info
>*info)
>>+{
>>+	struct dpll_attr *old =3D NULL, *new =3D NULL, *delta =3D NULL;
>>+	struct dpll_device *dpll =3D info->user_ptr[0];
>>+	int ret;
>>+
>>+	old =3D dpll_attr_alloc();
>>+	new =3D dpll_attr_alloc();
>>+	delta =3D dpll_attr_alloc();
>>+	if (!old || !new || !delta) {
>>+		ret =3D -ENOMEM;
>>+		goto mem_free;
>>+	}
>>+	dpll_lock(dpll);
>>+	ret =3D dpll_get_attr(dpll, old);
>>+	dpll_unlock(dpll);
>>+	if (!ret) {
>>+		dpll_attr_from_nlattr(new, info);
>>+		ret =3D dpll_attr_delta(delta, new, old);
>>+		if (!ret)
>>+			ret =3D dpll_set_attr(dpll, delta);
>>+	}
>>+
>>+mem_free:
>>+	dpll_attr_free(old);
>>+	dpll_attr_free(new);
>>+	dpll_attr_free(delta);
>>+
>>+	return ret;
>>+}
>>+
>>+static int
>>+dpll_cmd_device_dump(struct sk_buff *skb, struct netlink_callback *cb)
>>+{
>>+	struct dpll_dump_ctx *ctx =3D dpll_dump_context(cb);
>>+	struct dpll_device *dpll;
>>+	struct nlattr *hdr;
>>+	unsigned long i;
>>+	int ret;
>>+
>>+	hdr =3D genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh-
>>nlmsg_seq,
>>+			  &dpll_gnl_family, 0, DPLL_CMD_DEVICE_GET);
>>+	if (!hdr)
>>+		return -EMSGSIZE;
>>+
>>+	for_each_dpll(dpll, i) {
>>+		ret =3D dpll_device_dump_one(dpll, skb, ctx->dump_filter);
>>+		if (ret)
>>+			break;
>>+	}
>>+
>>+	if (ret)
>>+		genlmsg_cancel(skb, hdr);
>>+	else
>>+		genlmsg_end(skb, hdr);
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_cmd_device_get(struct sk_buff *skb, struct genl_info
>*info)
>>+{
>>+	struct dpll_device *dpll =3D info->user_ptr[0];
>>+	struct nlattr **attrs =3D info->attrs;
>>+	struct sk_buff *msg;
>>+	int dump_filter =3D 0;
>>+	struct nlattr *hdr;
>>+	int ret;
>>+
>>+	if (attrs[DPLLA_DUMP_FILTER])
>>+		dump_filter =3D
>>+			dpll_msg_read_dump_filter(attrs[DPLLA_DUMP_FILTER]);
>>+
>>+	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>+	if (!msg)
>>+		return -ENOMEM;
>>+	hdr =3D genlmsg_put_reply(msg, info, &dpll_gnl_family, 0,
>>+				DPLL_CMD_DEVICE_GET);
>>+	if (!hdr)
>>+		return -EMSGSIZE;
>>+
>>+	ret =3D dpll_device_dump_one(dpll, msg, dump_filter);
>>+	if (ret)
>>+		goto out_free_msg;
>>+	genlmsg_end(msg, hdr);
>>+
>>+	return genlmsg_reply(msg, info);
>>+
>>+out_free_msg:
>>+	nlmsg_free(msg);
>>+	return ret;
>>+
>>+}
>>+
>>+static int dpll_cmd_device_get_start(struct netlink_callback *cb)
>>+{
>>+	const struct genl_dumpit_info *info =3D genl_dumpit_info(cb);
>>+	struct dpll_dump_ctx *ctx =3D dpll_dump_context(cb);
>>+	struct nlattr *attr =3D info->attrs[DPLLA_DUMP_FILTER];
>>+
>>+	if (attr)
>>+		ctx->dump_filter =3D dpll_msg_read_dump_filter(attr);
>>+	else
>>+		ctx->dump_filter =3D 0;
>>+
>>+	return 0;
>>+}
>>+
>>+static int dpll_pre_doit(const struct genl_split_ops *ops, struct sk_buf=
f
>*skb,
>>+			 struct genl_info *info)
>>+{
>>+	struct dpll_device *dpll_id =3D NULL, *dpll_name =3D NULL;
>>+
>>+	if (!info->attrs[DPLLA_ID] &&
>>+	    !info->attrs[DPLLA_NAME])
>>+		return -EINVAL;
>>+
>>+	if (info->attrs[DPLLA_ID]) {
>>+		u32 id =3D nla_get_u32(info->attrs[DPLLA_ID]);
>>+
>>+		dpll_id =3D dpll_device_get_by_id(id);
>>+		if (!dpll_id)
>>+			return -ENODEV;
>>+		info->user_ptr[0] =3D dpll_id;
>>+	}
>>+	if (info->attrs[DPLLA_NAME]) {
>>+		const char *name =3D nla_data(info->attrs[DPLLA_NAME]);
>>+
>>+		dpll_name =3D dpll_device_get_by_name(name);
>>+		if (!dpll_name)
>>+			return -ENODEV;
>>+
>>+		if (dpll_id && dpll_name !=3D dpll_id)
>>+			return -EINVAL;
>>+		info->user_ptr[0] =3D dpll_name;
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>>+static const struct genl_ops dpll_ops[] =3D {
>>+	{
>>+		.cmd	=3D DPLL_CMD_DEVICE_GET,
>>+		.flags  =3D GENL_UNS_ADMIN_PERM,
>>+		.start	=3D dpll_cmd_device_get_start,
>>+		.dumpit	=3D dpll_cmd_device_dump,
>>+		.doit	=3D dpll_cmd_device_get,
>>+		.policy	=3D dpll_cmd_device_get_policy,
>>+		.maxattr =3D ARRAY_SIZE(dpll_cmd_device_get_policy) - 1,
>>+	},
>>+	{
>>+		.cmd	=3D DPLL_CMD_DEVICE_SET,
>>+		.flags	=3D GENL_UNS_ADMIN_PERM,
>>+		.doit	=3D dpll_cmd_device_set,
>>+		.policy	=3D dpll_cmd_device_set_policy,
>>+		.maxattr =3D ARRAY_SIZE(dpll_cmd_device_set_policy) - 1,
>>+	},
>>+	{
>>+		.cmd	=3D DPLL_CMD_PIN_SET,
>>+		.flags	=3D GENL_UNS_ADMIN_PERM,
>>+		.doit	=3D dpll_cmd_pin_set,
>>+		.policy	=3D dpll_cmd_pin_set_policy,
>>+		.maxattr =3D ARRAY_SIZE(dpll_cmd_pin_set_policy) - 1,
>>+	},
>>+};
>>+
>>+static struct genl_family dpll_family __ro_after_init =3D {
>>+	.hdrsize	=3D 0,
>>+	.name		=3D DPLL_FAMILY_NAME,
>>+	.version	=3D DPLL_VERSION,
>>+	.ops		=3D dpll_ops,
>>+	.n_ops		=3D ARRAY_SIZE(dpll_ops),
>>+	.mcgrps		=3D dpll_mcgrps,
>>+	.n_mcgrps	=3D ARRAY_SIZE(dpll_mcgrps),
>>+	.pre_doit	=3D dpll_pre_doit,
>>+	.parallel_ops   =3D true,
>>+};
>>+
>>+static int dpll_event_device_id(struct dpll_param *p)
>>+{
>>+	int ret =3D dpll_msg_add_id(p->msg, dpll_id(p->dpll));
>>+
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_name(p->msg, dpll_dev_name(p->dpll));
>>+
>>+	return ret;
>>+}
>>+
>>+static int dpll_event_device_change(struct dpll_param *p)
>>+{
>>+	int ret =3D dpll_msg_add_id(p->msg, dpll_id(p->dpll));
>>+
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_event_change_type(p->msg, p->change_type);
>>+	if (ret)
>>+		return ret;
>>+	switch (p->change_type)	{
>>+	case DPLL_CHANGE_PIN_ADD:
>>+	case DPLL_CHANGE_PIN_DEL:
>>+	case DPLL_CHANGE_PIN_TYPE:
>>+	case DPLL_CHANGE_PIN_SIGNAL_TYPE:
>>+	case DPLL_CHANGE_PIN_STATE:
>>+	case DPLL_CHANGE_PIN_PRIO:
>>+		ret =3D dpll_msg_add_pin_idx(p->msg, dpll_pin_idx(p->dpll, p-
>>pin));
>>+		break;
>>+	default:
>>+		break;
>>+	}
>>+
>>+	return ret;
>>+}
>>+
>>+static const cb_t event_cb[] =3D {
>>+	[DPLL_EVENT_DEVICE_CREATE]	=3D dpll_event_device_id,
>>+	[DPLL_EVENT_DEVICE_DELETE]	=3D dpll_event_device_id,
>>+	[DPLL_EVENT_DEVICE_CHANGE]	=3D dpll_event_device_change,
>>+};
>>+
>>+/*
>>+ * Generic netlink DPLL event encoding
>>+ */
>>+static int dpll_send_event(enum dpll_event event, struct dpll_param *p)
>>+{
>>+	struct sk_buff *msg;
>>+	int ret =3D -EMSGSIZE;
>>+	void *hdr;
>>+
>>+	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>+	if (!msg)
>>+		return -ENOMEM;
>>+	p->msg =3D msg;
>>+
>>+	hdr =3D genlmsg_put(msg, 0, 0, &dpll_family, 0, event);
>>+	if (!hdr)
>>+		goto out_free_msg;
>>+
>>+	ret =3D event_cb[event](p);
>>+	if (ret)
>>+		goto out_cancel_msg;
>>+
>>+	genlmsg_end(msg, hdr);
>>+
>>+	genlmsg_multicast(&dpll_family, msg, 0, 0, GFP_KERNEL);
>>+
>>+	return 0;
>>+
>>+out_cancel_msg:
>>+	genlmsg_cancel(msg, hdr);
>>+out_free_msg:
>>+	nlmsg_free(msg);
>>+
>>+	return ret;
>>+}
>>+
>>+int dpll_notify_device_create(struct dpll_device *dpll)
>>+{
>>+	struct dpll_param p =3D { .dpll =3D dpll };
>>+
>>+	return dpll_send_event(DPLL_EVENT_DEVICE_CREATE, &p);
>>+}
>>+
>>+int dpll_notify_device_delete(struct dpll_device *dpll)
>>+{
>>+	struct dpll_param p =3D { .dpll =3D dpll };
>>+
>>+	return dpll_send_event(DPLL_EVENT_DEVICE_DELETE, &p);
>>+}
>>+
>>+int dpll_notify_device_change(struct dpll_device *dpll,
>>+			      enum dpll_event_change event,
>>+			      struct dpll_pin *pin)
>>+{
>>+	struct dpll_param p =3D { .dpll =3D dpll,
>>+				.change_type =3D event,
>>+				.pin =3D pin };
>
>This is odd. Why don't you just pass the object you want to expose the
>event for. You should have coupling between the object and send event
>function:
>dpll_device_notify(dpll, event);
>dpll_pin_notify(pin, event);
>Then you can avoid this param struct.

Makes sense to me.

>
>
>>+
>>+	return dpll_send_event(DPLL_EVENT_DEVICE_CHANGE, &p);
>>+}
>
>[...]
>
>
>>+/* dplla - Attributes of dpll generic netlink family
>>+ *
>>+ * @DPLLA_UNSPEC - invalid attribute
>>+ * @DPLLA_ID - ID of a dpll device (unsigned int)
>>+ * @DPLLA_NAME - human-readable name (char array of DPLL_NAME_LENGTH
>size)
>>+ * @DPLLA_MODE - working mode of dpll (enum dpll_mode)
>>+ * @DPLLA_MODE_SUPPORTED - list of supported working modes (enum
>dpll_mode)
>>+ * @DPLLA_SOURCE_PIN_ID - ID of source pin selected to drive dpll
>>+ *	(unsigned int)
>>+ * @DPLLA_LOCK_STATUS - dpll's lock status (enum dpll_lock_status)
>>+ * @DPLLA_TEMP - dpll's temperature (signed int - Celsius degrees)
>>+ * @DPLLA_DUMP_FILTER - filter bitmask (int, sum of DPLL_DUMP_FILTER_*
>defines)
>>+ * @DPLLA_NETIFINDEX - related network interface index
>>+ * @DPLLA_PIN - nested attribute, each contains single pin attributes
>>+ * @DPLLA_PIN_IDX - index of a pin on dpll (unsigned int)
>>+ * @DPLLA_PIN_DESCRIPTION - human-readable pin description provided by
>driver
>>+ *	(char array of PIN_DESC_LEN size)
>>+ * @DPLLA_PIN_TYPE - current type of a pin (enum dpll_pin_type)
>>+ * @DPLLA_PIN_TYPE_SUPPORTED - pin types supported (enum dpll_pin_type)
>>+ * @DPLLA_PIN_SIGNAL_TYPE - current type of a signal
>>+ *	(enum dpll_pin_signal_type)
>>+ * @DPLLA_PIN_SIGNAL_TYPE_SUPPORTED - pin signal types supported
>>+ *	(enum dpll_pin_signal_type)
>>+ * @DPLLA_PIN_CUSTOM_FREQ - freq value for
>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ
>>+ *	(unsigned int)
>>+ * @DPLLA_PIN_STATE - state of pin's capabilities (enum dpll_pin_state)
>>+ * @DPLLA_PIN_STATE_SUPPORTED - available pin's capabilities
>>+ *	(enum dpll_pin_state)
>>+ * @DPLLA_PIN_PRIO - priority of a pin on dpll (unsigned int)
>>+ * @DPLLA_PIN_PARENT_IDX - if of a parent pin (unsigned int)
>>+ * @DPLLA_CHANGE_TYPE - type of device change event
>>+ *	(enum dpll_change_type)
>>+ * @DPLLA_PIN_NETIFINDEX - related network interface index for the pin
>>+ **/
>>+enum dplla {
>>+	DPLLA_UNSPEC,
>>+	DPLLA_ID,
>>+	DPLLA_NAME,
>>+	DPLLA_MODE,
>>+	DPLLA_MODE_SUPPORTED,
>>+	DPLLA_SOURCE_PIN_IDX,
>>+	DPLLA_LOCK_STATUS,
>>+	DPLLA_TEMP,
>
>Did you consider need for DPLLA_CLOCK_QUALITY? The our device exposes
>quality of the clock. SyncE daemon needs to be aware of the clock
>quality
>
>Also, how about the clock identification. I recall this being discussed
>in the past as well. This is also needed for SyncE daemon.
>DPLLA_CLOCK_ID - SyncE has it at 64bit number.
>

Yep, definitely I agree with both.

>
>>+	DPLLA_DUMP_FILTER,
>>+	DPLLA_NETIFINDEX,
>
>Duplicate, you have it under pin.

The pin can have netifindex as pin signal source may originate there by
Clock recovery mechanics.
The dpll can have ifindex as it "owns" the dpll.
Shall user know about it? probably nothing usefull for him, although
didn't Maciej Machnikowski asked to have such traceability?

Thanks,
Arkadiusz

>
>
>>+	DPLLA_PIN,
>>+	DPLLA_PIN_IDX,
>>+	DPLLA_PIN_DESCRIPTION,
>>+	DPLLA_PIN_TYPE,
>>+	DPLLA_PIN_TYPE_SUPPORTED,
>>+	DPLLA_PIN_SIGNAL_TYPE,
>>+	DPLLA_PIN_SIGNAL_TYPE_SUPPORTED,
>>+	DPLLA_PIN_CUSTOM_FREQ,
>>+	DPLLA_PIN_STATE,
>>+	DPLLA_PIN_STATE_SUPPORTED,
>>+	DPLLA_PIN_PRIO,
>>+	DPLLA_PIN_PARENT_IDX,
>>+	DPLLA_CHANGE_TYPE,
>>+	DPLLA_PIN_NETIFINDEX,
>>+	__DPLLA_MAX,
>>+};
>>+
>>+#define DPLLA_MAX (__DPLLA_MAX - 1)
>
>
>[...]

