Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C08F58FE7D
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 16:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbiHKOpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 10:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiHKOpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 10:45:44 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643A166A7B;
        Thu, 11 Aug 2022 07:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660229143; x=1691765143;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lnCSmyG440Klyu3JWpo6dpLRvlMo39ZIKZWKbmFnxqg=;
  b=Y86eW0T97jJoowsgEX0FGo9IInwIL+Lw7vQmD6S6RZikap7IoXJVcBSl
   anMSDkcpcRFaVoeRVpBjXKk6bjSpUqUW5yVwZm42z6MCs6O/dqSImGNdg
   tH/Qpznh/582pj0MI6YgD5pZ7EOpCGlOaEwn3KeRyR0PqSshIotOvuq1L
   K7j+O+Ba7PaOgPywz5oKQi2976Dh3SsyyYj6vW6M6YQeBXB2fyWTBM9ZJ
   v4JZPyghEyolQV6MnoKwDfsBUcOVWD9qc8F6q9EJVE7mdNyC3CZmXL+pw
   7SrpZMpd6FBh/crh+tfu5MLjRzoG9aQtEJjzCkm0puw8NHLaqHLkpnZmh
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="291361803"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="291361803"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 07:45:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="731890521"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 11 Aug 2022 07:45:37 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 07:45:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 11 Aug 2022 07:45:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 11 Aug 2022 07:45:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWiGD20wYB7MI5DSjb8+sGmGja/CZi0l1TwbCBoU51t4X4IOsJC5afLSt4e9j/iVe+RD4Tj4KsI8bbMq2qJsA5BjwqCvSTmMmZyjrSW56GM9IrBJ2RYCIQDGcKJA9P0YG+ZoP533trSnGur2UC4/UJSTi1U764/H7+ko8G4E/tIJub9UBJcbinodq7jc5wBLPXuW0ilFlui7t5uX/jP7ALn1S1UYNvaOnp/Zi9WxVdpuaGfhA0YeB7OKWt/QHsfddf4Ty1DmlEaa1vjsY9UwI9+HNvghyzYSWH3GouknozRXITKNCGF7SxeirskRJzlTPd5GwA8dwqA5yfmR4o27Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lnCSmyG440Klyu3JWpo6dpLRvlMo39ZIKZWKbmFnxqg=;
 b=B5A48ebldhD/Rm/iEJIxelTGNNVM96kh73DODC9yeUi3wUeTmHiwRvpgPAZOPPX1bzeMYTdBz3xQcfPWfUmxonVdWKjvbnfthA3BVi7tsj9WEwwB6U4L97umOEEBxtVImEg2NXVarEhkMKj4MIEcOOAhmRYjoP9q8toi2H2CbwXXt9KniGe4kra/2XWcCJVl3JUZCJTe54ae6Nyr9ZfQlXGIZrJdYbnPjfekcHv74VXif4o4LyitCkkFuRXjY8zfs8H8lXea47JhzvzfHPYcuZ7F691SXifeLKcwwSO9DgNkyA3UX0HcqfYH+UQeduRz62bjAIIcxO7iD1rM0wxVtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3995.namprd11.prod.outlook.com (2603:10b6:5:6::12) by
 BY5PR11MB4257.namprd11.prod.outlook.com (2603:10b6:a03:1ca::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 11 Aug
 2022 14:45:34 +0000
Received: from DM6PR11MB3995.namprd11.prod.outlook.com
 ([fe80::11b4:36eb:5ccd:5656]) by DM6PR11MB3995.namprd11.prod.outlook.com
 ([fe80::11b4:36eb:5ccd:5656%5]) with mapi id 15.20.5504.021; Thu, 11 Aug 2022
 14:45:34 +0000
From:   "Koikkara Reeny, Shibin" <shibin.koikkara.reeny@intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "Loftus, Ciara" <ciara.loftus@intel.com>
Subject: RE: [PATCH bpf-next v4] selftests: xsk: Update poll test cases
Thread-Topic: [PATCH bpf-next v4] selftests: xsk: Update poll test cases
Thread-Index: AQHYp0d93z8FCSWl1EuyXCZTpTPUdK2oJfAAgAAkJQCAAYjnAA==
Date:   Thu, 11 Aug 2022 14:45:34 +0000
Message-ID: <DM6PR11MB3995199856C28BE79EEF8EE1A2649@DM6PR11MB3995.namprd11.prod.outlook.com>
References: <20220803144354.98122-1-shibin.koikkara.reeny@intel.com>
 <YvOtvgdSnOhUd9Po@boxer> <36e36fb2-948f-84c7-0d3b-d97e76373dfa@iogearbox.net>
In-Reply-To: <36e36fb2-948f-84c7-0d3b-d97e76373dfa@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae8dae2e-9c7e-40c1-db32-08da7ba825a9
x-ms-traffictypediagnostic: BY5PR11MB4257:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fRIPVIzbqaXMn0OHhEQH5ayOW+mxiA77XrvCjyY10wKjQTUchfqdr/W7hoON0xMMfgLYeCF7obxwujv74TAP5nsfupgaGMHXAUXvGli6X1PtmcoDe2FZBt3rgqy9s6wVFacR6nNJZidGVco5cHVLG1ST6HfNHjdK//+ho93qlgl6e+4mEXhC1ctkh4EBA28ltZUOJeXo4w5Mpt0CETR0+8xu1o/qGilMyIZP7sfrVffeUYBBUchEmJSDQuNuAZe2NE5vCNQSx8YQV3xPqPR9XDzajK9BfGOgpbayM67oIQPXMuZ1LgI1UnIx5mUNqtgOV/lqVbJXJV0WQG++UA7FShnJUwx3Uzf/BFl1vsgYkTQXkrI8+o0XnCi1HgeRUFx14wg92+AeYlMtvFJYHbIk5U000vA5EXmm+KmXXiW3JwA8Xx7svvWttyVw0hsup6dvGwOrILN5oRwqx5CxAXM4OuyILmszXxqQeaw1ptxDM/r7M2d4ROMfDCji7m4XatWwNKdLz7W0pTQeeaVGB/40jIQtZm8PbHXqpvgbwS/H9WwmFHPjcAVXloE+FDNlgngbpsprLJxSj61k3KvjenXClSviTg8fvBWnkNUa8G8rHuhBmtapz+1l+7gOnHoS1y9IFkrECYM4ZAqMKtUAmrWO1JfksPS9gYrOwmnrq1jIIo0XJVoCI975Zxd2hOklLuwOrLlNb5vfs7q914ro4EWmiHhz4WeGL2Roz/E7lC69O+EJojbfsOSZwO8A0SalIXlLY0xcDlw+U21OU1w1nlR3k2aHT03YnkHd5V/XgxbKhCAIv5coJX+1Xng9KUZtKAhduHyvCwQMSXpQhfh0oYIaMdbTc8lry9csQWOaP1l0nwXMb9V/WibzxDgf2/irV61r
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3995.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(346002)(136003)(376002)(366004)(33656002)(86362001)(38070700005)(122000001)(53546011)(9686003)(7696005)(83380400001)(82960400001)(107886003)(186003)(6506007)(478600001)(41300700001)(54906003)(316002)(26005)(6636002)(71200400001)(966005)(66946007)(52536014)(64756008)(110136005)(66446008)(38100700002)(66556008)(8676002)(8936002)(5660300002)(76116006)(15650500001)(66476007)(4326008)(2906002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?djFMUDY0MkxOVStncUxTYW9tZ0pzSXFOYXBFeEVtMHVpZS9ncjBGYUxyZFNi?=
 =?utf-8?B?a1o3V1dSSUdHT3V5SW5jaVk0QzhjNTJSYjI2OVFIWXpNTEV1dlV0Ui8yTkJM?=
 =?utf-8?B?amdwTE1zVGg0aU5xKytaTndrZFdTMWN5Y24ycUh1WktHMVh2ZnV0Nk5OVXY4?=
 =?utf-8?B?aXl1YkE3NkRwb1dBZ3ZJZ0VOSDRDYnZxSVc2eXhmRFh5Wll0N1JtR3NEVW1r?=
 =?utf-8?B?UGwzaW1VVmtUTFNYK2pISzZBZHQzT1EzMllVY284VmFQQnppaTVNTTlYWDB2?=
 =?utf-8?B?RXIxWlRRQXNlMG5PcUFhVFk4S3YyKzJ0U2JQTVNHcDlFc3NodU5VWG9veTZZ?=
 =?utf-8?B?bmZJeVJIZDlNdi95ZjhpTVN1KytkdjRHSWNGam80NXpZZnd0aXRmeHdkQUcr?=
 =?utf-8?B?RC9sbWZ5d25leDQxQ0UxZVQyeURQb0NEVWZzR1ZOdlF5MDJ0WFNpZGxaOVV3?=
 =?utf-8?B?aTJSQmtUc1FJa1doYm94TU5Nb0xoL29oZGQ3SHl1TXA3U09BdDhTbXQ5SzNk?=
 =?utf-8?B?Mko0S1pNbTZUL1BGbjNtMXB3dzVNZjR3dFdIQm1GRVhLUWkwWmxQVGRJT2NB?=
 =?utf-8?B?emQ5S3Q3MUNPTy96NmFtSHJjWWhGK0xQV2VjL0ViY0RnS1l2eVJaMWUzT0tG?=
 =?utf-8?B?QlFqb0N3SXNHelc2MFFOcEswVldUckVKTWc4cFY3eHBlYTZoeW13ZFhTejZC?=
 =?utf-8?B?eHBGTkJqcWhVamNIS3g2YllFSmtHNzdodG1xMXRIcnFqRXRMQ2Fsa2Vkc2tz?=
 =?utf-8?B?TVZCSHEyVEZIUTRmSDBpVWlHY1d4aDJNcFNkR0pHUjlKek9QV1VncC9FRXQy?=
 =?utf-8?B?dlJJNjVuVTcwWDlkTmE0Ui9QT0VtUUFRMVdVTkpzN015MWxiV1loVHhkL1No?=
 =?utf-8?B?QWRkQ2I5N0JVb01BS044bUxsYUtWMzhWdE56bkFjcXFnMWNRZk1KNmJTU05j?=
 =?utf-8?B?MWdmQ1gwWk8zMEVhcjJEaS83bkxhejI4NFl5alZyQUV3ZEQ2U2JEZlpVMDJw?=
 =?utf-8?B?VkpYa0xjaVY3L2VLOGc0S2RzZHRXcmdWZ2VCT01kcVZZSDhMeDNKVlowSTR5?=
 =?utf-8?B?bGRiazkwSnAvM21tZ0VnZ3RVd3NCMU1DSDFPK3cxcDhPRWJ6YWRGRHZVbnY2?=
 =?utf-8?B?b05vc3BxNVJudVhSbWp1ZllteG4wdUJXQjlFbFhkTU80c1lpVHl1Ym4ydDY0?=
 =?utf-8?B?eUpFSEUxWEVMOWVpa2hURVBNSlQ4RnpwSERvRm1uQTBOVVRmaTR1aGJqaXBV?=
 =?utf-8?B?Z2M1QXo5S1NPSnBqQ3VEbW1zdXNvRUxCdVJwMXg4RERKWnR0RXFrN3lZeEU3?=
 =?utf-8?B?S2hTdVArZzhBNHFHQXFUbjFyRUZMQnNsS3V6bjQ1UHRWSjc1ZWM0aUdnMkx0?=
 =?utf-8?B?ZUZtQ25mSmhkUUlnN0tYa2pPUEloS1NWNVYzZGVFdEl0amRzZFA0Zk9HaGlH?=
 =?utf-8?B?VGk3aGlUOFdPVWd2L3dTQU1OSzVtcFhzcUxBVCtYMU9mL2R5NkN4bnJWTlJk?=
 =?utf-8?B?SmpKR3B2WTA2QkUvMzIvd0NBYStkdDdteFpjMldzaFZXRng5TWhyQWNPL0pv?=
 =?utf-8?B?QU9JTE1wS25IeXRkdGlMMkkxZ1VZUkFsbFliNmNzTmQ5VjJEMFYzdERzRkc3?=
 =?utf-8?B?cmhJWjRFbXdOOU45TjdEQjMyaWtLZS91d281K1I0bUlUR0RyQmNGckdvcVM0?=
 =?utf-8?B?NGN3K3BBVktkYUtOT2swTms4Y1ZUYTU0SHQ2S0ttczZ1M3NBR3VicUVtZUlE?=
 =?utf-8?B?eUc0d3FLeHhveFFvbXp2SHhVRUJHTGdJbVFQR3ZxSG05MGNOVjduT1ZrUnZw?=
 =?utf-8?B?N2o0Nk01MTlFdm1XN1c1T2puZlhOUFBOZjF4QytCK1oxUE9pSit4c1NUUVYv?=
 =?utf-8?B?L3JGazJjK3U0V1N0TXFBTHN2S2QzMEx3Z3JhMlArWFlhWWhlUnIrNjF0TkM3?=
 =?utf-8?B?Zmp2NUJjOTQ3QUJySm83bndUQUMwbkdlNHVSaGNCd25Selk5dXhCb3VTWTI4?=
 =?utf-8?B?OS8rK3VWeHU2QzVDL2F3Q0tvRkFQcy9GWHdKSkp4VWpxR2RSeFZpcks3dUZj?=
 =?utf-8?B?YTNZYjJLYkdqMFFXTmI0NGZQSldjMmdmL1M5T0dtdWgxSW50YlpIN1BSU2R3?=
 =?utf-8?B?RUFSVGtxME0vOG85cW45a0JmRHdPNnRIYnJveTFyZHJaSUNDZExxdW05N0Zy?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3995.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae8dae2e-9c7e-40c1-db32-08da7ba825a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2022 14:45:34.2801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rnYjEEX17bZaY/Xf5mIPz3Mv/hNBn5GSB5QoEnAJCsYMeTv7rGiW/l0+zfAgLbLX3TuZdwZtR7Ib8du8pPoF5jBMW/zQiu00uMxZy6RvsUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4257
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGFuaWVsIEJvcmttYW5u
IDxkYW5pZWxAaW9nZWFyYm94Lm5ldD4NCj4gU2VudDogV2VkbmVzZGF5LCBBdWd1c3QgMTAsIDIw
MjIgNDoxOCBQTQ0KPiBUbzogRmlqYWxrb3dza2ksIE1hY2llaiA8bWFjaWVqLmZpamFsa293c2tp
QGludGVsLmNvbT47IEtvaWtrYXJhIFJlZW55LA0KPiBTaGliaW4gPHNoaWJpbi5rb2lra2FyYS5y
ZWVueUBpbnRlbC5jb20+DQo+IENjOiBicGZAdmdlci5rZXJuZWwub3JnOyBhc3RAa2VybmVsLm9y
ZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgS2FybHNzb24sDQo+IE1hZ251cyA8bWFnbnVzLmth
cmxzc29uQGludGVsLmNvbT47IGJqb3JuQGtlcm5lbC5vcmc7DQo+IGt1YmFAa2VybmVsLm9yZzsg
YW5kcmlpQGtlcm5lbC5vcmc7IExvZnR1cywgQ2lhcmEgPGNpYXJhLmxvZnR1c0BpbnRlbC5jb20+
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggYnBmLW5leHQgdjRdIHNlbGZ0ZXN0czogeHNrOiBVcGRh
dGUgcG9sbCB0ZXN0IGNhc2VzDQo+IA0KPiBPbiA4LzEwLzIyIDM6MDggUE0sIE1hY2llaiBGaWph
bGtvd3NraSB3cm90ZToNCj4gPiBPbiBXZWQsIEF1ZyAwMywgMjAyMiBhdCAwMjo0Mzo1NFBNICsw
MDAwLCBTaGliaW4gS29pa2thcmEgUmVlbnkgd3JvdGU6DQo+ID4+IFBvbGwgdGVzdCBjYXNlIHdh
cyBub3QgdGVzdGluZyBhbGwgdGhlIGZ1bmN0aW9uYWxpdHkgb2YgdGhlIHBvbGwNCj4gPj4gZmVh
dHVyZSBpbiB0aGUgdGVzdHN1aXRlLiBUaGlzIHBhdGNoIHVwZGF0ZSB0aGUgcG9sbCB0ZXN0IGNh
c2Ugd2hpY2gNCj4gPj4gY29udGFpbiAyIHRlc3RjYXNlcyB0bw0KPiA+DQo+ID4gdXBkYXRlcywg
Y29udGFpbnMsIHRlc3QgY2FzZXMNCj4gPg0KPiA+PiB0ZXN0IHRoZSBSWCBhbmQgdGhlIFRYIHBv
bGwgZnVuY3Rpb25hbGl0eSBhbmQgYWRkaXRpb25hbA0KPiA+PiAyIG1vcmUgdGVzdGNhc2VzIHRv
IGNoZWNrIHRoZSB0aW1lb3V0IGZlYXR1cmVzIG9mIHRoZQ0KPiA+DQo+ID4gZmVhdHVyZQ0KPiA+
DQo+ID4+IHBvbGwgZXZlbnQuDQo+ID4+DQo+ID4+IFBvbGwgdGVzdHN1aXRlIGhhdmUgNCB0ZXN0
IGNhc2VzOg0KPiA+DQo+ID4gdGVzdCBzdWl0ZSwgaGFzDQo+ID4NCj4gPj4NCj4gPj4gMS4gVEVT
VF9UWVBFX1JYX1BPTEw6DQo+ID4+IENoZWNrIGlmIFJYIHBhdGggUE9MTElOIGZ1bmN0aW9uIHdv
cmsgYXMgZXhwZWN0LiBUWCBwYXRoDQo+ID4NCj4gPiB3b3Jrcw0KPiA+DQo+ID4+IGNhbiB1c2Ug
YW55IG1ldGhvZCB0byBzZW50IHRoZSB0cmFmZmljLg0KPiA+DQo+ID4gc2VuZA0KPiA+DQo+ID4+
DQo+ID4+IDIuIFRFU1RfVFlQRV9UWF9QT0xMOg0KPiA+PiBDaGVjayBpZiBUWCBwYXRoIFBPTExP
VVQgZnVuY3Rpb24gd29yayBhcyBleHBlY3QuIFJYIHBhdGggY2FuIHVzZSBhbnkNCj4gPj4gbWV0
aG9kIHRvIHJlY2VpdmUgdGhlIHRyYWZmaWMuDQo+ID4+DQo+ID4+IDMuIFRFU1RfVFlQRV9QT0xM
X1JYUV9FTVBUWToNCj4gPj4gQ2FsbCBwb2xsIGZ1bmN0aW9uIHdpdGggcGFyYW1ldGVyIFBPTExJ
TiBvbiBlbXB0eSByeCBxdWV1ZSB3aWxsIGNhdXNlDQo+ID4+IHRpbWVvdXQuSWYgcmV0dXJuIHRp
bWVvdXQgdGhlbiB0ZXN0IGNhc2UgaXMgcGFzcy4NCj4gPg0KPiA+IHNwYWNlIGFmdGVyIGRvdA0K
PiA+DQo+ID4+DQo+ID4+IDQuIFRFU1RfVFlQRV9QT0xMX1RYUV9GVUxMOg0KPiA+PiBXaGVuIHR4
cSBpcyBmaWxsZWQgYW5kIHBhY2tldHMgYXJlIG5vdCBjbGVhbmVkIGJ5IHRoZSBrZXJuZWwgdGhl
biBpZg0KPiA+PiB3ZSBpbnZva2UgdGhlIHBvbGwgZnVuY3Rpb24gd2l0aCBQT0xMT1VUIHRoZW4g
aXQgc2hvdWxkIHRyaWdnZXINCj4gPj4gdGltZW91dC4NCj4gPj4NCj4gPj4gdjE6DQo+ID4+IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2JwZi8yMDIyMDcxODA5NTcxMi41ODg1MTMtMS1zaGliaW4u
a29pa2thcmEucg0KPiA+PiBlZW55QGludGVsLmNvbS8NCj4gPj4gdjI6DQo+ID4+IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2JwZi8yMDIyMDcyNjEwMTcyMy4yNTA3NDYtMS1zaGliaW4ua29pa2th
cmEucg0KPiA+PiBlZW55QGludGVsLmNvbS8NCj4gPj4gdjM6DQo+ID4+IGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2JwZi8yMDIyMDcyOTEzMjMzNy4yMTE0NDMtMS1zaGliaW4ua29pa2thcmEucg0K
PiA+PiBlZW55QGludGVsLmNvbS8NCj4gPj4NCj4gPj4gQ2hhbmdlcyBpbiB2MjoNCj4gPj4gICAq
IFVwZGF0ZWQgdGhlIGNvbW1pdCBtZXNzYWdlDQo+ID4+ICAgKiBmaXhlZCB0aGUgd2hpbGUgbG9v
cCBmbG93IGluIHJlY2VpdmVfcGt0cyBmdW5jdGlvbi4NCj4gPj4gQ2hhbmdlcyBpbiB2MzoNCj4g
Pj4gICAqIEludHJvZHVjZWQgc2luZ2xlIHRocmVhZCB2YWxpZGF0aW9uIGZ1bmN0aW9uLg0KPiA+
PiAgICogUmVtb3ZlZCBwa3Rfc3RyZWFtX2ludmFsaWQoKS4NCj4gPj4gICAqIFVwZGF0ZWQgVEVT
VF9UWVBFX1BPTExfVFhRX0ZVTEwgdGVzdGNhc2UgdG8gY3JlYXRlIGludmFsaWQgZnJhbWUuDQo+
ID4+ICAgKiBSZW1vdmVkIHRpbWVyIGZyb20gc2VuZF9wa3RzKCkuDQo+ID4+ICAgKiBSZW1vdmVk
IGJvb2xlYW4gdmFyaWFibGUgc2tpcF9yeCBhbmQgc2tpcF90eC4NCj4gPj4gQ2hhbmdlIGluIHY0
Og0KPiA+PiAgICogQWRkZWQgaXNfdW1lbV92YWxpZCgpDQo+ID4NCj4gPiBmb3Igc2luZ2xlIHBh
dGNoZXMsIEkgYmVsaWV2ZSB0aGF0IGl0J3MgY29uY2VybmVkIGEgYmV0dGVyIHByYWN0aWNlIHRv
DQo+ID4gaW5jbHVkZSB0aGUgdmVyc2lvbmluZyBiZWxvdyB0aGUgJy0tLScgbGluZT8NCj4gPg0K
PiA+Pg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBTaGliaW4gS29pa2thcmEgUmVlbnkNCj4gPj4gPHNo
aWJpbi5rb2lra2FyYS5yZWVueUBpbnRlbC5jb20+DQo+ID4+IC0tLQ0KPiA+PiAgIHRvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2JwZi94c2t4Y2VpdmVyLmMgfCAxNjYgKysrKysrKysrKysrKysrKyst
LS0tLQ0KPiAtDQo+ID4+ICAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3hza3hjZWl2ZXIu
aCB8ICAgOCArLQ0KPiA+PiAgIDIgZmlsZXMgY2hhbmdlZCwgMTM0IGluc2VydGlvbnMoKyksIDQw
IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gSSBkb24ndCB0aGluayB0aGVzZSBncmFtbWFyIHN1Z2dl
c3Rpb25zIHJlcXVpcmUgYSBuZXcgcmV2aXNpb24sIHNvOg0KPiA+IFJldmlld2VkLWJ5OiBNYWNp
ZWogRmlqYWxrb3dza2kgPG1hY2llai5maWphbGtvd3NraUBpbnRlbC5jb20+DQo+IA0KPiBJIGNs
ZWFuZWQgdGhlc2UgdXAgd2hpbGUgYXBwbHlpbmcuIFNoaWJpbiwgcGxlYXNlIHRha2UgY2FyZSBv
ZiB0aGlzIGJlZm9yZQ0KPiBzZW5kaW5nIG91dCBuZXh0IHRpbWUsIHRoYW5rcyBndXlzIQ0KDQpU
aGFuayB5b3UgRGFuaWVsLiBBcHByZWNpYXRlIGl0LiDwn5iKDQo=
