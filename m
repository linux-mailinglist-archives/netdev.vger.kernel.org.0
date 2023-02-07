Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAE368D4C5
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjBGKs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjBGKsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:48:21 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB49A15C86;
        Tue,  7 Feb 2023 02:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675766900; x=1707302900;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jxoy7u+Qs+XLCJMFGPoifNaVQgQ6HNHk+jfglIzbU5c=;
  b=EUQaVDeF3t26QlmrirS//fwVt3VY85il+y+HbjWaSPMcOkDdGNd10Mku
   rC/s2ao2DKG8Hq0ay1cmGMyRp1yVbLKKhAwLl/k8ObRzIgz6GI1WJkUq5
   lY3xkOHX6nFdzayPHqb+Sbw6CR7XXiefvPyDTJj3GDd+VJqnDv234BVNt
   CLTdd1xgAfYpvIsk1zH5OfPEBYtdvMYEGmx1E3FMn5KKTx5SCqHNsFHaK
   s0i6O15pfFBdEnVkbehLeGOpv8laWBolZzPXbygakCxYjaoJTlnYQKJ2/
   i8eqJWeL0BXs7SDhH1gaegl6V3/z4hSKhYw6LiHIqMPoXnGDdOTu5Vu6t
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317493293"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="317493293"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 02:48:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="660188017"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="660188017"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 07 Feb 2023 02:48:18 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 02:48:16 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 02:48:16 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 02:48:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ob1EyPRvBkaBRKSbN0clLr3UOViv5KxIHNK3LeFRQbO4noLHmyzWEoq5ErQMdS4vq6hodxvfU4UaDXeqMik4RttBT7Bnw0O+UXBExeTZzScMidHNMRI+mqOoXwapLN/3PzHtb0m/a8qyhpfOI6AiBFMv3DGl7b15ymiE5+PtwdgvsdqsIGxcc+Kk0+C5+LVlFdpV+LajLbKTUovBJtM6IYGzjwWtM5MUw5rLr1uXLFuH8d47Zwnq73YYTcaj36usLL7v6l5cD6QQiVaw4kKAXFtQ9lQipGtfuwRnWPw8pvzLL3Vn9DV6Hlz9Y+cL5QpTts/q6Y/KNg7Nl0k50M9oiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4YG3rckZ7Stk/8H1jziWywQlNibLMfrZfHuFaWeX1RM=;
 b=cLcAbdroV/cfPPjh5ZozEGQ4LHdKcH1cQk+8uk5SsZDA0A4irQhWqb+qzr7JY4fCs0a5F4xKwgBVThXwybcrxwt31U769Q3o4yLFWNWOk8K/x+MhgFZdUJPbQzHwZ31RL/38KDtk9SEBwzNdYKbitEJ5s5F1UKQlq0hGBwLPK3C5MwXsFg1EYZgtedwVmHRTJlrKVHaVEbBZndg7aOSi0/CZP0NifXqG5v3xW2JI1zUpPsOMOJ4Q6MIT37zv7MbK1WeaNlp1q33Zt0YabEbygdjCGJbd/mSF+p9AQnbWpzfcrO/M2CHhOCuidahdc0Ii7yrkHnXW73HOroyv2Rk+kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by SJ0PR11MB6695.namprd11.prod.outlook.com (2603:10b6:a03:44e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 10:48:14 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44%4]) with mapi id 15.20.6064.036; Tue, 7 Feb 2023
 10:48:14 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Natalia Petrova <n.petrova@fintech.ru>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH v3] i40e: Add checking for null for
 nlmsg_find_attr()
Thread-Topic: [Intel-wired-lan] [PATCH v3] i40e: Add checking for null for
 nlmsg_find_attr()
Thread-Index: AQHZNlnuDC/c2QBywEW1r2ZcSsXzba7DVoLQ
Date:   Tue, 7 Feb 2023 10:48:14 +0000
Message-ID: <BYAPR11MB3367632E082D882E7A5D6D73FCDB9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20230125141328.8479-1-n.petrova@fintech.ru>
 <20230201090610.52782-1-n.petrova@fintech.ru>
In-Reply-To: <20230201090610.52782-1-n.petrova@fintech.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3367:EE_|SJ0PR11MB6695:EE_
x-ms-office365-filtering-correlation-id: 5f80a807-d0eb-4603-ed35-08db08f8d03a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GkACKreHoUpjip8Bl4sMIIEkQvaCDc4OL7/P996QFkRv4hm5Lyz9yjDXg/Csuph+LX3uphAXViPZPiNR0xEp2zweuUfGIoHCS+rK9sIs8SpLK/nOA4KnTDdFxR7jydV7XiIJR3i2YPVC6YS8XpJOzLair4tx2oycx4KxzFrqb9aqKFAnirApcoKtcynfucGI58YCqsYjf8LbDuxppsjKlPfupshl2nP0ntDM3Hrn9uM7Ws/XyxlBBY364BgMOjuzH4FmkYqrFDUG/koMJWNPKQQOI4hW9BNy27XlsYnZ2usc3UfHAvr4meai8kUpR74sT6E7gl1me+D/yNlwBtZn1Z0++1RqkaaYnY2nF+Ty93F9bPkStl/pRJLEPj5Wr1gVRTmg7pogBEFWy91fxwBFGLa7XBHq+5GBXZgeUXWm7uAHq1eeqL89WU8arrfzpOp6NnnRCUwXSm+T+OTsnmHG8gj+B8R4PaYMvqAKrg/aIbBRKuHk2p/OwQ/oDFSmcfVu0tQF5S1Y5pwXraA922rZ4obLjqNTZpOvO75Csw49bIfG4LKKZrGPpiW2CpexxFFpFRJ0yQ6/LiNl/O2QpLCQ442ItrehYwStT3eBcsaIfobbn4xT522IO58tOqm67XF58G8R1Y1v1mCuuJRXvbhUiHbABzM1ainS4wRUAITBn3C9wCT8/mmSV2p3tEUlI398GXJKHNYe7Qr7vfEXOfElfw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(376002)(346002)(39860400002)(366004)(451199018)(52536014)(8936002)(41300700001)(5660300002)(4326008)(66476007)(66446008)(76116006)(8676002)(64756008)(66556008)(66946007)(2906002)(54906003)(122000001)(6636002)(316002)(86362001)(110136005)(38070700005)(7696005)(6506007)(478600001)(82960400001)(71200400001)(9686003)(38100700002)(53546011)(186003)(33656002)(83380400001)(55016003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HEa/K9GIW0BKdYhGe4rhdOzEfDYY8p1+rPTFKK/L6bPuod3WdwDRxAO5k1LW?=
 =?us-ascii?Q?TGfoTrQVafSAGpCvNfogCUXxi5Pm7dt1h2OJLqWGq/hftpBKqSnDyzerhQfs?=
 =?us-ascii?Q?qpVKPZVgR5o0eMIJZEujulfkI5sYTRXO1/ELvDa0NEP+xupUwTjxQD3JBezy?=
 =?us-ascii?Q?1I4SGClY/7tkF5zV5X8VybfCYvuUO38evHYFTJ6+5Oc1hZzee9gBwrBpHeHY?=
 =?us-ascii?Q?UdduFhW3j4iwwTHkg8r+bztF9ojMTFnQuOSnXaR8GwZRbrBnnUgYaMoheQYX?=
 =?us-ascii?Q?1wp8wyD8VV55uwD2qJFATDrKpEH3MjuiswmF4uUPllR8qAK3cW3I+uWcNW2P?=
 =?us-ascii?Q?9K5Gy5HYcV/ockRgIIaTgz81xlE8SasU4S1+I3jSYf4bOd2s/0iNx41baqMP?=
 =?us-ascii?Q?nwi/X17WbZVjSLDczrFuJLQWyg5W0QC0pHcQTwB1VBKcq03x6Anq6pPofkfE?=
 =?us-ascii?Q?jm/hxVuP//ZUp/3XmjlMGbNRwgUuHtaLp9uKN3vpQJr9rzlaJJxlHXvuiMlo?=
 =?us-ascii?Q?tkwwjcdrl1SWCYaoJfXEMgSU65bzi7CCfJl7Fv70ZtCyXNLjacLLwZ1rxqRd?=
 =?us-ascii?Q?jMPb6kY2Uaza/npwfO5HMk5vSTLuNi0VXbO4IVMxpW0ec1moq949wBTS7a7q?=
 =?us-ascii?Q?tvCRSG72ELyqqxOmrV2q6Ohk/bIAVTZIoYUyiEts4+vgN8eD1oDtfIHoENOt?=
 =?us-ascii?Q?R26d14BGtKUyjRnE5TR3kbbyuGX08DXPLhwiGpBhl6Ns3mbBi+eoaNkIraHx?=
 =?us-ascii?Q?oaqf+6XrBcL8MFvgTcSKoY070FI78rRrTIYrWtm/1FOwzPa0rMEGNhT09v2B?=
 =?us-ascii?Q?wl4FRBKG/dwcK0+vmqbATWMwbw4ASpuRiMUqwDjOqkRs3i7MG1XJX3KsGP2J?=
 =?us-ascii?Q?sxbMseNaRID+OzG3XwdITxjXt9sFw/69K8mFIkdG+0iiPo1+k8YhYWpv5dQa?=
 =?us-ascii?Q?kAiw6v8G+Z6DcB4akPn89fcIyWQ/B7AMU/qZFuaW/p9kAcAleMNANwIk3O/f?=
 =?us-ascii?Q?GrBQGdwive+nti6TvzefD8ybLMud0vJMOV+gpTpNcmwrIBi3LzxjGyQjxIWJ?=
 =?us-ascii?Q?yXv2LmBt6WjEgEc0fcF3k1rK+v0z7oCle9iw5r82mdTamFDgjrQQyarWbVd3?=
 =?us-ascii?Q?dzEY456j6CDWjgfKjgIAE31CKMuMmuZZl5IxVMPMhYD1Jh7b4lIBm90/tkkj?=
 =?us-ascii?Q?OiXLsd/0gtSCO8DPHU+UkDXnEexmDI6rM4Dpb3FmUNJxYlPV+2TqTmi/Cunv?=
 =?us-ascii?Q?/AsCMuaf99AgdDhIduCqymxJ6ZG2GoQBqDkMyiRcX8kyXbAKPNI9374XYfk1?=
 =?us-ascii?Q?MNfNbum/gs2MXhPVqDYe/eEqD0irPPJtlIke/3yu2kWgDtoEBtiIBSM7Y5b0?=
 =?us-ascii?Q?jD83zhPEN3nfhb7YFpAEkGsd4k/qrwfj6C4f/Gp5EdgZX6egKqH7L9/9L6UP?=
 =?us-ascii?Q?LHp9xhTVCNB0itmvq2nqLOp4SYVGeMbFadkYV7QhVM6KAFXr2aHfkvBRYev2?=
 =?us-ascii?Q?17L3LN4he86pFu2asjvO2PJ/PtCd+y0jYXBvjRtLY5YTj6xP3rHgQT305RA0?=
 =?us-ascii?Q?9hAXwMEtaSPss5H6ycvluTXeXCFP/XEI6SgWwv+0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f80a807-d0eb-4603-ed35-08db08f8d03a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 10:48:14.0866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w0PIPvYghV+iWJGptBk4plnV4Tx95GQuB26yDtOcv6vg+5OLHiLVZQWFeTLeIU9Z8GIQCZXe6UfhYTO2153V5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6695
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



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Natalia Petrova
> Sent: Wednesday, February 1, 2023 2:36 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>
> Cc: lvc-project@linuxtesting.org; intel-wired-lan@lists.osuosl.org; Natal=
ia
> Petrova <n.petrova@fintech.ru>; linux-kernel@vger.kernel.org; Eric
> Dumazet <edumazet@google.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; netdev@vger.kernel.org; Jakub Kicinski
> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S. Miller
> <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH v3] i40e: Add checking for null for
> nlmsg_find_attr()
>=20
> The result of nlmsg_find_attr() 'br_spec' is dereferenced in
> nla_for_each_nested(), but it can take NULL value in nla_find() function,
> which will result in an error.
>=20
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>=20
> Fixes: 51616018dd1b ("i40e: Add support for getlink, setlink ndo ops")
> Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
> v3: Fixed mailing list.
> v2: The remark about the error code by Simon Horman
> <simon.horman@corigine.com> was taken into account; return value -
> ENOENT was changed to -EINVAL.
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
