Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC1B610EE7
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiJ1Kom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiJ1Koj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:44:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A806EE39;
        Fri, 28 Oct 2022 03:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666953868; x=1698489868;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DryBo/ck7N3Fy+Rhe8x655EqUU3Vc9+mXBFYh4uZVyw=;
  b=Vf8kHpUvCz0ChaZNZwfqEANjvnP25f7hbw+4+MVTDD7zpV0mTJt+vfpc
   bL1QTFPCoE5rJlQB6wKUO9Uc6IAEGN/Us3tCMZrKYoRcEbHLcgUzuZck9
   eXmIYAlg9bf2vYscqoI1oOUlsr6+M4wlwSnTbpNeHmFtRG/INpzvCm1j1
   TJaLtfLgMr6HuRTxO2xosnE+HqQ0mXK0kf/pqEYXxKhrp/wxZX+l7hE9H
   Ecm8SPmsHxLD3V1iclQkbOIv9ZU9+tMssNdpLIlou4V4SnNl9D7RrefDx
   fROfFRlQD4QN8s/TANUzWK5jsXj6Le/Rd4leXkyu77NQEkxsitFv6gDJb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="288858542"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="288858542"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 03:44:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="775334287"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="775334287"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 28 Oct 2022 03:44:28 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 03:44:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 03:44:27 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 28 Oct 2022 03:44:27 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 28 Oct 2022 03:44:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVfcIFqHzTkOp4DgYGPdO9mX7+xIir8lo7GkOAE44sNdLD7D7Go7FoTN98uLt9vgImzEFps2gSYRK8LkPpf07M+ZZi2k4gYi7WGClWz7dWvAJ9owpqZDI/Wr59kD9s7rhWpErwUbS31F5fmdX8G52amh2xu1r+Hp/7XETma2fM00Rpa8Rv11XeRbd0AAVXA+AGJk4Rcl8/iV2vLnH1fjChvmkH4x5Ta1ROZAW9slBV/HY1Ca9A8Cy/ddnxuneKHgRHXuJvX6tNWTYMV+mHiYyDLB0Oq25L0Ot+aPaSIsssrsfh0gyw/RoqF/kBVHvsWbtAP9X1jBgJpTRiYtRlV6hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DryBo/ck7N3Fy+Rhe8x655EqUU3Vc9+mXBFYh4uZVyw=;
 b=glDVq3jFTmS0WAwCVlVtBCPBwLNzP4sFu5kZY9PrN2T1JJl2opdgczvdqSqBKqVP/TLiy3W4KmxEhgsIbDoEKyrFsYnJJo5x+mom4GeapbkR5Trq/vIh8C/LjXOmOoB7nFkRrUdWaJo7ljp19AE809WJ3xsi1naadCzENJJsCruv2/0rUdCsS/E703VafTgr5b27c+FG0v8XGujtmhu5gftBKtgy42Ba7tz7SgbqF02bTbsBtJIc+pBPsTWhBlNrGE95S0QWe7Uig9JM8LjQum0ZYwQfN0s0o3tovJGSr8Wqw/9F6YoiG5jXZ3g0JHw7NA+kmaddSG2w8zLbKdZrPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM5PR11MB1593.namprd11.prod.outlook.com (2603:10b6:4:6::19) by
 MW4PR11MB6618.namprd11.prod.outlook.com (2603:10b6:303:1ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 10:44:25 +0000
Received: from DM5PR11MB1593.namprd11.prod.outlook.com
 ([fe80::7940:c5ad:796e:3e1b]) by DM5PR11MB1593.namprd11.prod.outlook.com
 ([fe80::7940:c5ad:796e:3e1b%12]) with mapi id 15.20.5769.015; Fri, 28 Oct
 2022 10:44:24 +0000
From:   "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
To:     Vee Khee Wong <veekhee@apple.com>
CC:     "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Gan, Yi Fang" <yi.fang.gan@intel.com>,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>
Subject: RE: [PATCH net-next 1/1] stmmac: intel: Separate ADL-N and RPL-P
 device ID from TGL
Thread-Topic: [PATCH net-next 1/1] stmmac: intel: Separate ADL-N and RPL-P
 device ID from TGL
Thread-Index: AQHY6rPg5goS174pIkicitQA/O1ExK4jnlxQ
Date:   Fri, 28 Oct 2022 10:44:24 +0000
Message-ID: <DM5PR11MB15935E3AF06794F523DB48C69D329@DM5PR11MB1593.namprd11.prod.outlook.com>
References: <A23A7058-5598-46EB-8007-C401ADC33149@apple.com>
In-Reply-To: <A23A7058-5598-46EB-8007-C401ADC33149@apple.com>
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
x-ms-traffictypediagnostic: DM5PR11MB1593:EE_|MW4PR11MB6618:EE_
x-ms-office365-filtering-correlation-id: cb591a27-1aec-4e2c-2d15-08dab8d1614b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bor4Gdbw+zd52AyMpN2QRZw+HQaysLH5B83Dr4qqd869rmork+sBswHY7MFmBea8IROe35OQYDQrutVWFf1Ftp/xyrD1HpQOdTyzhAOKc4JaqF4JnADrogUiZq/g7JOZXOXvADMaTQ1aNaapzTxtW4EgIJvVFgWeaEm4fS55ZU1k/k5sLpA+yUKO6wBA5CtfayO+DGwnEUqbYV7tiMDSauGSnUywAVwZXjUuISuz9hdsE/olyfUm5Dv96f7zH0T6kkqvZXGQHPUUbHBuga1e2pCNCo06wNxUInoibkBbaPR3SaSvfEz2WXopX54KvtBVWVRh6A8xDYGXBLmsgZV2nz5wZVTYJ5I6TsCXNnhh0XykF6ehSpYxu+C4fZO04vAa2tU49AVjgKCdC1IiaIkXy4sxBb+O/ve5uGrFFQrM9ZVReOeg5HBbLeijSYXLG4Xxz0z1VqcSQ0P08zlWdIx//4mJvPt1JOcSreUQm13nzXVoFP2kUR1enAiy3zQgG2YZg4y8wU0c/s8CZV4+j2hrqG6GbabIIMNEGJmhr33y51MK3z45Qi6j99SE/3GAFyE1nh9f9F81HbF+epLYLMHJ/hGTgA1xpCcwzSHgeAM7mfFy6eAgiWr8xtth9Ax4Hd0h4pSdMwRidtV6661p0Clpk9t0mEYXXjKNPVYOaEgoNcsqzw/1DQEZed22zb83RWvS1ow/UcO1ghpTwsVfCEcskZxhRN+qNO6/18C/dRcCy28PXxf+P2FGMqLp8YRmOwb6vyvIK7LqZtqXGZwmz/rYjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1593.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199015)(55016003)(82960400001)(38100700002)(4744005)(2906002)(5660300002)(7416002)(122000001)(83380400001)(33656002)(86362001)(38070700005)(26005)(107886003)(186003)(53546011)(9686003)(71200400001)(478600001)(316002)(6916009)(54906003)(8936002)(41300700001)(52536014)(6506007)(8676002)(64756008)(66446008)(66476007)(66556008)(4326008)(66946007)(7696005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjJnUEJleDhmNkVGb0x4dloyMlEwcG10R0VqbU8rOEoyS09CTGk1Q3B1YlZz?=
 =?utf-8?B?czhyamd4bHdNRW9EcUtHTXNxQ1QvaW05ckpLVVlMODVyaWIvSzJ6Tm1rZm9q?=
 =?utf-8?B?QVN2ZGpmVDdzbU9qY0tvS2xrUTFBUjhRSGU4ZFQ5Mm9DSkJHeTQ3cmJnSERt?=
 =?utf-8?B?dmNGNDg0Sm9OMzlsRjh0MUMvMTZGVnY4RzQ1OHZ3d1BGeVN5bHN4Y2VUQlI3?=
 =?utf-8?B?NUlOR3l0T2RLeUlwYmFieWsxZDRmMWpabUF0b1JUcm9RUzhxNDRBK0lPR2lH?=
 =?utf-8?B?OGdYRkViYU9RaFBCU1JwWmtDWVJreGhWb1d1cUpzTjkrWWwydnBrWExBUDhL?=
 =?utf-8?B?dFJLMThPTnp5ZmwrRjY3MVlsRktQV0ZLUXlVZExERU1icGJRK3BYdUZKam8w?=
 =?utf-8?B?MTlFYUUxVXhmWFVZYkFHQ3pab2RCWDZ2cTQrVGdFSU5DakVvclIycXBTT1dE?=
 =?utf-8?B?ZVQ0Sk96MUZmY1QvR2RpL1ZVVWcxQis5dnUwNFZzYzdGL0ZLRVU0b3pCN3g3?=
 =?utf-8?B?TnlnQnpwVG9jSnRHYzZyL3phUlF4QmsrSVZYSmlLWUl6SUdWODF0b3JzaWdp?=
 =?utf-8?B?c3E0R0RTQmdCcktKTWQxaTdjWjZxeVd1RVllcXUxSldOVlNYSkhIZjlLQitJ?=
 =?utf-8?B?aG5MUlRRUzU3dkFzTlJMWXh2NCtCYVVqNDJpS0tDTzQ5SGxTeWRZaFRyWm0z?=
 =?utf-8?B?SUk5cHRtZklGRm1tMXg1OFp0cnpHci9aMVk4Sm1rQS9rWHJuSUI3QnJTT0Jm?=
 =?utf-8?B?Y2p4YzF0MDc5WjhmWlFIbDNqNkZoZWRLOGNWajdzdXFYYnRYa0tWeDZpUE9G?=
 =?utf-8?B?N1ZzWlNoR2JSeEVBdW8yWEdoQjB0K0tsWWR5Kzd4UmJsSGcyMDhQTjlqRFIr?=
 =?utf-8?B?b2lXS3hpcDgwbkVMSTR5NXcwcmJIZG04R2wwWjJpbnFjdnUrb1FKUUxLUnBW?=
 =?utf-8?B?ZkJvcmFsVWV3bTdIclpwMWFmcGpHVjljcHhKRjc0Z1dvc2srUFl5bDkxR1JI?=
 =?utf-8?B?ZURIR3NOWDZ0aFRpelZsYk5kcjEwZXNNd2pjSWw1RmhLdTlrUWhZcUg3VkE4?=
 =?utf-8?B?SWtTWTNzb1drTjZrRzdVTUFlVlhUbFZoMXloZUZlSktScE5ReitNSE1WT2Rl?=
 =?utf-8?B?QW90Z0wycUNQN3VrOXBrcGhybjJCZkpBN0ZrOUFSQkk1N3ByYjQwUlpKZFFI?=
 =?utf-8?B?WGFsNnJlUjlvN0hrWGVmSUN2OExMREZzYTZVSUV4VTVrYVV5UVpPUG5DMFYv?=
 =?utf-8?B?cSt4MlpmanB5TWpFWEhiQXV6ejNDdk03eTZjWitFU2Jub09hb2RrQ0MwaVM0?=
 =?utf-8?B?UnU0clRIaE1aMG5tVE5jM2JjbnNoS2hLUEhqRm5SMTFwZk9XYUtaYzNHa0JD?=
 =?utf-8?B?ZG5KaTkzM3Jsai8wK3FHK1hWNlo0WnVVUXFiREE5QURhdjV2eDZWQ3U1ejBI?=
 =?utf-8?B?R3crWFc4WDVqd2x1d2hWbEZnTmNnRGlJRVgvMkxVV2NtU2RONndFMit5WW1y?=
 =?utf-8?B?aHdCdmxOcDB5QjVtTDBJSG93MlZWdzcySmhPY0UrMzRYbTk4d1dyamhyaUhS?=
 =?utf-8?B?VXZ1WS9DazM1VmY5WVpBMzNtYW5kUXFiZWpzSXlzbFBjWm1PYXNhOXFOT1E4?=
 =?utf-8?B?UjZHY0cxbXA5K25LYjVxMG5hR0ZFWVFCaU9TQ0xkOFV1M1VkeVRqYlIyTkhv?=
 =?utf-8?B?VmlpdFQrM3JLeFA2S0d6RzlOdXNJTTlmV1VpNktEeTg4T0JNekdLV253Q3NO?=
 =?utf-8?B?VDZiNzhzamVqWVZkZHl1TE91ZGtpZnVPSWNBandZV0wwYzdRRnVWb3ErWDg5?=
 =?utf-8?B?eW5LelRkTStmMEJLZHlGSmNSVmRRS0c1Y1hwU3RYU0Q5dTllai9DcE5pOUFK?=
 =?utf-8?B?ek80RFgxa0htN3g3aDRhK3VzczdoZnliN1o1dCt4OXZQYlQwY3NXcnFMRjVn?=
 =?utf-8?B?MFlzb2VQdXZQRjZ4SC81cHlldDVoRTVNKys1azk1WStqczJpNnV3NnhpOVhw?=
 =?utf-8?B?anNiTmxrb0QzWW1GVHp5eEduVFdCQzhXYm1TdWlBZlJSZmpRRFpaK29TR1U1?=
 =?utf-8?B?NkwwelBOTDU3dmE1YUhlNWpYN2RtdXI5d2FJT2Nkb3lsUlFvR3pNKzVyR0Vk?=
 =?utf-8?B?RWNpWnQ3ZC9BMlR0dmNwY2c2SjMxZ0ZMempTMm52SFdvYWFGZGJUR3Rudmxv?=
 =?utf-8?B?eVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1593.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb591a27-1aec-4e2c-2d15-08dab8d1614b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 10:44:24.6026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BXaZvj9K+AHBKFY9DoevDJYHogF/ni4OZSR1Ld/vpTlquDra6y1NK3NNkskdxWo+WiTJG0Yd7/hRmelf+6HIObSdfLL3n2VJc7899HO9+Rk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6618
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBpcyB0byBhbGxvdyBmaW5lciBjb250cm9sIG9uIHBsYXRmb3JtIHNwZWNpZmljIGZlYXR1
cmVzIGZvciBBREwgYW5kIFJQTC4NClRoZXJlIGFyZSBzb21lIGZlYXR1cmVzIHRoYXQgQURMIGFu
ZCBSUEwgZG9lc27igJl0IHN1cHBvcnQgYW5kIFRHTCBzdXBwb3J0cyB2aWNlIHZlcnNhLg0KDQpS
ZWdhcmRzLA0KTWljaGFlbA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206
IFZlZSBLaGVlIFdvbmcgPHZlZWtoZWVAYXBwbGUuY29tPg0KPiBTZW50OiBGcmlkYXksIE9jdG9i
ZXIgMjgsIDIwMjIgNTo1OCBQTQ0KPiBUbzogU2l0LCBNaWNoYWVsIFdlaSBIb25nIDxtaWNoYWVs
LndlaS5ob25nLnNpdEBpbnRlbC5jb20+DQo+IENjOiBhbGV4YW5kcmUudG9yZ3VlQGZvc3Muc3Qu
Y29tOyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBlZHVtYXpldEBnb29nbGUuY29tOyBMb29pLCBI
b25nIEF1bg0KPiA8aG9uZy5hdW4ubG9vaUBpbnRlbC5jb20+OyBqb2FicmV1QHN5bm9wc3lzLmNv
bTsNCj4ga3ViYUBrZXJuZWwub3JnOyBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5v
cmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1zdG0zMkBzdC1tZC0N
Cj4gbWFpbG1hbi5zdG9ybXJlcGx5LmNvbTsgbWNvcXVlbGluLnN0bTMyQGdtYWlsLmNvbTsgWnVs
a2lmbGksDQo+IE11aGFtbWFkIEh1c2FpbmkgPG11aGFtbWFkLmh1c2FpbmkuenVsa2lmbGlAaW50
ZWwuY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207DQo+
IHBlcHBlLmNhdmFsbGFyb0BzdC5jb207IFRhbiwgVGVlIE1pbiA8dGVlLm1pbi50YW5AaW50ZWwu
Y29tPjsNCj4gVm9vbiwgV2VpZmVuZyA8d2VpZmVuZy52b29uQGludGVsLmNvbT47IEdhbiwgWWkg
RmFuZw0KPiA8eWkuZmFuZy5nYW5AaW50ZWwuY29tPjsgU29uZywgWW9vbmcgU2lhbmcNCj4gPHlv
b25nLnNpYW5nLnNvbmdAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0
IDEvMV0gc3RtbWFjOiBpbnRlbDogU2VwYXJhdGUgQURMLU4NCj4gYW5kIFJQTC1QIGRldmljZSBJ
RCBmcm9tIFRHTA0KPiANCj4gV2hhdCBpcyB0aGUgcHVycG9zZSBvZiB0aGlzIHBhdGNoPw0KPiAN
Cj4gVGhlIGZ1bmN0aW9uIGRlZmluaXRpb24gbG9va3MgZXhhY3RseSB0aGUgc2FtZSBhcw0KPiDi
gJh0Z2xfc2dtaWlfcGh5MF9kYXRh4oCZLg0KPiANCj4gDQo+IFJlZ2FyZHMsDQo+IFZlZSBLaGVl
DQo=
