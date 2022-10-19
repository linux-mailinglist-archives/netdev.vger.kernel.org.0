Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD87460498B
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 16:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiJSOnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 10:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbiJSOmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 10:42:42 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C528C1CBAAB
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 07:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666189700; x=1697725700;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R2FBA6Uma+AZBKYTmnI6VCSjYkJIrCZDqyG+9DqpHdI=;
  b=f2srQ/u3AJNwtj4VmCgRzQN5oT6SbskiNq1722I/vnA7xeduu2ugsfus
   0RGw525/QzX/7R9uQlO/RK4KXDBaSNDpkABRUKtAO0uJewmQSZx5so7ND
   llJcyDeqz9XYc9t+t3j6lWI2C+Hu6Hw7FD3MDHsfs5FOLBKU+S/V06fgv
   KvyS+YkfcVO1KTlCWo0X0rQPnV5ww2vxtVAY0kk3jQo8VtXKuowHOdrEE
   5UNaYLFzEplq1q+BSMHlktdQl0uHY9fj3WYZyAgC6Xa3Lu9RiRUQvX9XA
   UYAhwN5iwMOxT0W7Q1Mh3kLSg4YdAlZjbn5xsWBqkEGGP4RCcYGkyN7yP
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="307530189"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="307530189"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 07:23:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="607118431"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="607118431"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 19 Oct 2022 07:23:13 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 07:23:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 07:23:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 19 Oct 2022 07:23:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 19 Oct 2022 07:23:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ww63qmZfYfOX1na6/spYTScst9671/m2sTAO1qQY3epM8o+6Ej7l02HY8aiU7oxpYlBHCjWbUgdcFahMV77Grri/MeOBfuoSg/UjRVFPjuygMnA/bRqAKd2qKKgRLK9iwkAR8MqJ/QF0A4BsvgfhfzIlZWujOTNnYVMHB1PX8NxdHqTVPEGOpQpApW9LXTcl8Xb6UlItIf0CxFa/epOF6Us8b3PIfbHuEouegPmp3zBJJWPsbL+/X0vGxA2qGGiDYHioJwcUHeC3gtYmbG33W8T0GivvWRH0nKxLb0lJCX3q+dX3h+HHw5/7/CSdZoJMN1lNgBMN77foL/nR/X2lVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R2FBA6Uma+AZBKYTmnI6VCSjYkJIrCZDqyG+9DqpHdI=;
 b=ERxCUDHqJZK7J8294ypXeqUZPi+JhYU/DVZOBsQDNVsxVFnSrllG6uME06dIuQifqr5g2CQzuQKPA1E+Yg7wyUh+x5AHi56vK+KMyzeoMneOdpEhJX8GOaN6fUey6cubLpIsRRs+W2sq0v/viSMUL9DaSZHLAYA350ULF5yxTYS8DOjQWr8lrh5BNJIij7KjBsjClmwitJqdGdPAL3hUxBqNkhWRDHnOdJYKnGfDwzJQ61OSNjL10ctuUvXKrhY1i/bJhM1wdCqA7pAUvGbvFN5qh7pJjHrqSPz3bS7JM3/j8z1aUQVI5iDWVznI1B+C7AHpHunOuNXey5Gc+65lAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by SA2PR11MB5082.namprd11.prod.outlook.com (2603:10b6:806:115::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Wed, 19 Oct
 2022 14:23:10 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::ec4c:6d34:fe3f:8c60]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::ec4c:6d34:fe3f:8c60%4]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 14:23:09 +0000
From:   "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To:     Gal Pressman <gal@nvidia.com>,
        "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>
Subject: RE: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP packets
Thread-Topic: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP packets
Thread-Index: AQHY4o49ev0KReGUxEyWlnOqPWSac64UNSoAgAGJqPA=
Date:   Wed, 19 Oct 2022 14:23:09 +0000
Message-ID: <SJ1PR11MB6180523C0BEBB1AECB72C109B82B9@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
 <44132260-2eba-1b92-af75-883a3c4e908c@nvidia.com>
In-Reply-To: <44132260-2eba-1b92-af75-883a3c4e908c@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|SA2PR11MB5082:EE_
x-ms-office365-filtering-correlation-id: 12196815-ece0-496b-67c2-08dab1dd72dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yrw0vedjdIxNkc7cSl7bVQCT8P+RVJWdKLYzZX4zE/2zEMojV8fJNzxK0pkPwlkqKP5reDqzLitTuV7RmOlvJ9jPK84X4dnTB0+HVeOnJV/mvqAfrMes3ln9EsP8pacROi7UozVbIngW3f/XdXjn7JMue1Z6zmgEKOqfQYfFhSJcBBlV97lGO5TfmSzv3lYlzXoGC9j3i5rNsD85eZ45uL5NqFF6rzqT21esbWJdkBZtwh4hM9bwlrTSGgfr7fPOSp+Lj3OgRTVIpYqzQucDGXvy7Lc5fq872b7sqdOaL4+l0PmNsyF4m+JdUP4gQ3WX2Rg5TNufB5I/cO1mNOCD/6Dc5X0RCLH7/6jE7L9DxlTuxVcqac3ejAr+oP2gcgsq/MPaalRx7APjWolrcC/5PRt3fu2MP/F0Png/7UEpIoZ+OO6KBOTKU2nvUJG8M8ZscHZnp3ugRwTWWsvYSZslGNFdvPdQ/18nskoXoMusOzHeReUIHnr3kBAJsiZRS6lu1voHszaWAmZDaq69YQfJU6vFDP8z4cdLeAp1xdOXtlmWJNmZWMCFQUEipJtngULRW4M9JeMdGHnUeuMwk2WpNPKGKEELHe7gMj1oHlmCWBlZKkJ7M2Fis/17zGZAWeLtjWlAo1UQlRboqjQIGj/dybmR26FgBEVX3puCmk32T0pUay1Km11Ey9I5LNDV0ctxR3WrZeGwRu8F/OhmshGMeigGm093wsGCo4pWDlKadMy8k2Kbjw6OhMzGFtJ6ELrsR7BGx9puHLQ6Puyu4ZY5XA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(376002)(136003)(366004)(451199015)(38100700002)(82960400001)(122000001)(86362001)(38070700005)(71200400001)(76116006)(66556008)(66476007)(64756008)(5660300002)(66446008)(4326008)(316002)(110136005)(8676002)(66946007)(54906003)(7416002)(2906002)(8936002)(52536014)(186003)(83380400001)(41300700001)(107886003)(53546011)(478600001)(26005)(9686003)(6506007)(7696005)(55016003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWlnbm1IR3NEUGViam9SbWlnWUZ2Wi91RXVLTTF3MFRkMFl4ZUFSMTFlb3Iw?=
 =?utf-8?B?RW5oZGprd3Q1UFdqblRzSWFQWEwyWElsM05vSi9Ma0Z3ZTNtWG1NdVppMzB1?=
 =?utf-8?B?R01WVmZLNk9BOEVWM0kyNS9mSDU5TTFXRXJ2amFQamFUSkg5aWJocDBpQUF1?=
 =?utf-8?B?YWFqTDJ6aFhscTM5MUczM2FxS0hzNVUzWXloZ2pFOTJIVVN6enZpU1NFUlBm?=
 =?utf-8?B?ZjRCK1A0dzViblEvOVV5VmVKS2JURTQ0UU5jWms4dnhrYU11bjZtWnBIc3l2?=
 =?utf-8?B?bkJQdGpOWmxzdFhkY1UzZWYvUUhZc0VzREx0MnBTNnBIQlFaS3grS2tsOHNt?=
 =?utf-8?B?MkZtK1FQbFRBdmJNU25KYWxwQWlyT1ZOYWh1cUtQcUpCenVuOXNheFR5SVY1?=
 =?utf-8?B?UzJXakpTTUhkckRqZHRVOUpHRGdaeHpsRW5tV1A2MjVndFhKYWtSQkVSVFZI?=
 =?utf-8?B?TTBBZDVSOTRYajZkRmFXYUR0NGVNbmpHR1dSenVPRndFZGgzbk5NakpqdjdV?=
 =?utf-8?B?ME1hTno2TGlpUmpZa3diVzZqNExOREJFMzM0L2RUMG44VGpQdzJaUTh3ajY0?=
 =?utf-8?B?anVzSHRIUDZmZ0dQcGM4WWI4ZEdhL2JITGtUekg3azBISnRzSTJ2c0tXb1E2?=
 =?utf-8?B?bnZ2YVNIR2tBNEl3ZzNKTFVVZHhiR2tZMXBVVlQwcXVLZENmZ2RWTTJmRkJF?=
 =?utf-8?B?TmRrVVRQYXFaNnhPaldhM2ViZE11R0xpYzRMNnpBZWVBRVJ4ODBQY29OdGdZ?=
 =?utf-8?B?eTRaN3FrejRFaFp2b1MxY202T1ZQa1YyU2tHTXpMKzdQY2psN1h5LytUOUlu?=
 =?utf-8?B?bGZQRzB3Qy92d1VJeGVKVlFJdEU4K0VWZ1BnbGFIRk9DbW5Rb1VpYTF6czBH?=
 =?utf-8?B?TjhnMHVkQ1plWHJzeGxsOWEya21yZ0lTYmFGMG1GRy85ZktLM1RVcGFIeGJK?=
 =?utf-8?B?c2pnN1VadGEvajZ0R0xxQzNlUjVyT0lJZGhXV09tQ0lwL3IwT1VSTlk0T3I4?=
 =?utf-8?B?U1E5c1RMdFRnNENLRDM0ZXh6NWU1ZHZKbGl1VDU3MG1rWG40ODhPbzBWVUJ1?=
 =?utf-8?B?MUttcHFyVWNBaUM4dDgzSWJPdzExNzViN0JBYUNZMVplelh5MFY5cW9UanBz?=
 =?utf-8?B?RURPY0RPOGs1Tk1xZG51YWhheWw2Zy9iVTE4Mk5sbzlaQ29XdTFKaGRXL1Nl?=
 =?utf-8?B?N2tFVTZ6dGpOMHZLUEh3bGRXVlRkeklkYzltUlNTUFVHa0FnTFdVTEo1eWpR?=
 =?utf-8?B?a3RwQ3EySjV4eHdvVG4ybVkxemovRWI4ZUE0YVcvb0pGQ0JXM3lpY2RTcGNi?=
 =?utf-8?B?eGVSL3lrVHExQXIraFR2NUplZ2h2VllvTzFGc2NLT0RQZnNvVTlWU1NYN2hS?=
 =?utf-8?B?TktoOTR5N0NOTEg1SFpzckpwTjUrcWRXR3dyY0JkUkhMOG0zZFMxaG5sU2di?=
 =?utf-8?B?ZzY4L1dtdFFvcjNrcklzTGVoL2ZtTnpObUZVOU5tSVAyZDd1OVFqRW1ISU1E?=
 =?utf-8?B?UzEvc2VjczJCL3pQWS92S0NwRjZpaE5SK3NLYkgzczczeTVZa1V6MHE2WWRy?=
 =?utf-8?B?Q3labUh6Ni9zSkR0aUdIUm51cjgrR3A0N213a3N4Tm1tWmh0aWpxcDFoWHNZ?=
 =?utf-8?B?WmpyWUJxK3AzR0dtSlRsTFZmaUhyTXBuMmVZcHEwUTVLaGx3WktuYlI3N2xH?=
 =?utf-8?B?anBOcUwrdldGU211NDQ3cVJnc1AxSXRHY3J5bUpNQlZGZUcxZHVObWE5UDlw?=
 =?utf-8?B?WnptYUNzUVNMVnl5WkVjT0hmVGhVRVNNbWREeG1kUS9CRmx2SXlwR1pubW9L?=
 =?utf-8?B?YVVwY2ZqbDJXZndnaStTT0h2KzF3YTROMHRsaEU2Mm9ZdWFNa2dqYmE0UGw0?=
 =?utf-8?B?S3YrUFRSUE5zNjZrM1hoQjNESTJBVGlURk54TEt5bFh6YlVURTZaTW1Vdk9j?=
 =?utf-8?B?bmZUeUhNWE80UThMOXVXTlhXVDQrMlhnbE5XbTMwbUdLOTNYZmlmZ1Zsa1Bz?=
 =?utf-8?B?TVVDMm85Uks1UXk4N2MveTgvUzZ2OHhmZ3BTT3ZMcGljT0gvU25xRmpPd0dH?=
 =?utf-8?B?a3BpRkw1aDFRY3RMTGMwcFY4Z2kzeWlGZVNWbFNLTUhJZUtuZHlVQzNXN3c1?=
 =?utf-8?B?OWNMZ1RMaUFwSVFFV0ZDM2MvbXBPSmhUTTNLWXNiUVZyS1ZkZE1kUXIrVVVu?=
 =?utf-8?Q?xnZS8MFGuikKtmHpq8wzyVQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12196815-ece0-496b-67c2-08dab1dd72dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2022 14:23:09.8813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u9Dk5XRk6ByqCX2pUpL/oemjX+fLHlvVHfiqAtjvR9D/Zp0loeUMT4ud5iJ9+EIAuqcCT6LYRj/SXy7xOwqyd/MxKuU1Olh/Gr5/mqctrSVyAw61WnwsekNOdMgZQyCA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5082
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2FsLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEdhbCBQcmVz
c21hbiA8Z2FsQG52aWRpYS5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIDE4IE9jdG9iZXIsIDIwMjIg
MTA6MjMgUE0NCj4gVG86IFp1bGtpZmxpLCBNdWhhbW1hZCBIdXNhaW5pIDxtdWhhbW1hZC5odXNh
aW5pLnp1bGtpZmxpQGludGVsLmNvbT47DQo+IGludGVsLXdpcmVkLWxhbkBvc3Vvc2wub3JnDQo+
IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBrdWJhQGtlcm5lbC5vcmc7IGRhdmVtQGRhdmVt
bG9mdC5uZXQ7DQo+IGVkdW1hemV0QGdvb2dsZS5jb207IEd1bmFzZWthcmFuLCBBcmF2aW5kaGFu
DQo+IDxhcmF2aW5kaGFuLmd1bmFzZWthcmFuQGludGVsLmNvbT47IHJpY2hhcmRjb2NocmFuQGdt
YWlsLmNvbTsNCj4gc2FlZWRAa2VybmVsLm9yZzsgbGVvbkBrZXJuZWwub3JnOyBtaWNoYWVsLmNo
YW5AYnJvYWRjb20uY29tOw0KPiBhbmR5QGdyZXlob3VzZS5uZXQ7IEdvbWVzLCBWaW5pY2l1cyA8
dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIDAvNV0g
QWRkIHN1cHBvcnQgZm9yIERNQSB0aW1lc3RhbXAgZm9yIG5vbi1QVFANCj4gcGFja2V0cw0KPiAN
Cj4gSGVsbG8gTXVoYW1tYWQsDQo+IA0KPiBPbiAxOC8xMC8yMDIyIDA0OjA3LCBNdWhhbW1hZCBI
dXNhaW5pIFp1bGtpZmxpIHdyb3RlOg0KPiA+IFRoZSBwcm9ibGVtIGlzIHRoYXQsIHdoZW4gdGhl
cmUgaXMgYSBsb3Qgb2YgdHJhZmZpYywgdGhlcmUgaXMgYSBoaWdoDQo+ID4gY2hhbmNlIHRoYXQg
dGhlIHRpbWVzdGFtcHMgZm9yIGEgUFRQIHBhY2tldCB3aWxsIGJlIGxvc3QgaWYgYm90aCBQVFAN
Cj4gPiBhbmQgTm9uLVBUUCBwYWNrZXRzIHVzZSB0aGUgc2FtZSBTT0YgVElNRVNUQU1QSU5HIFRY
IEhBUkRXQVJFDQo+IGNhdXNpbmcgdGhlIHR4IHRpbWVvdXQuDQo+IA0KPiBXaHkgd291bGQgdGhl
IHRpbWVzdGFtcCBiZSBhZmZlY3RlZCBieSB0aGUgYW1vdW50IG9mIHRyYWZmaWM/DQo+IFdoYXQg
dHggdGltZW91dD8NCg0KQmFzaWNhbGx5LCB0aGUgb3JpZ2luYWwgdGltZXN0YW1wIHJlZ2lzdGVy
IGNvbGxlY3QgdGhlIHRpbWVzdGFtcCBhdCB0aGUgUEhZIGxldmVsIA0KYW5kIGludGVycnVwdCBp
cyB0cmlnZ2VyZWQgZm9yIHRoZSBkcml2ZXIgdG8gcmVhZCBpdC4gV2Ugb2JzZXJ2ZWQgdGltZXN0
YW1wIG1pc3NlZCANCmlzc3VlcyB3aGVuIHRoZSB0cmFmZmljIGlzIGhpZ2guIERNQSBUaW1lc3Rh
bXAgZ3VhcmFudGVlcyB0aGUgdGltZXN0YW1wIGZvciBldmVyeQ0KcGFja2V0cyBhcyBpdCBpcyBk
ZWxpdmVyZWQgdGhyb3VnaCBkZXNjcmlwdG9yIHdyaXRlLWJhY2sgbWVjaGFuaXNtLg0KDQpXaGVu
IHRoZXJlIGlzIGEgdGltZXN0YW1wIG1pc3NlZCwgcHRwNGwgYXBwbGljYXRpb24gd2lsbCBjb21w
bGFpbiB0aGVyZSBpcyBhIHR4X3RpbWVvdXQuDQoNCj4gDQo+ID4gRE1BIHRpbWVzdGFtcHMgdGhy
b3VnaCBzb2NrZXQgb3B0aW9ucyBhcmUgbm90IGN1cnJlbnRseSBhdmFpbGFibGUgdG8NCj4gPiB0
aGUgdXNlci4gQmVjYXVzZSBpZiB0aGUgdXNlciB3YW50cyB0bywgdGhleSBjYW4gY29uZmlndXJl
IHRoZQ0KPiA+IGh3dHN0YW1wIGNvbmZpZyBvcHRpb24gdG8gdXNlIHRoZSBuZXcgaW50cm9kdWNl
ZCBETUEgVGltZSBTdGFtcCBmbGFnDQo+ID4gdGhyb3VnaCB0aGUgc2V0c29ja29wdCgpLg0KPiA+
DQo+ID4gV2l0aCB0aGVzZSBhZGRpdGlvbmFsIHNvY2tldCBvcHRpb25zLCB1c2VycyBjYW4gY29u
dGludWUgdG8gdXRpbGlzZSBIVw0KPiA+IHRpbWVzdGFtcHMgZm9yIFBUUCB3aGlsZSBzcGVjaWZ5
aW5nIG5vbi1QVFAgcGFja2V0cyB0byB1c2UgRE1BDQo+ID4gdGltZXN0YW1wcyBpZiB0aGUgTklD
IGNhbiBzdXBwb3J0IHRoZW0uDQo+IA0KPiBJcyBpdCBwZXIgc29ja2V0Pw0KDQpZZXMgaXQgaXMg
cGVyIHNvY2tldC4NCg0KPiBXaWxsIHRoZXJlIGJlIGEgd2F5IHRvIGtub3cgd2hpY2ggdHlwZXMg
b2YgdGltZXN0YW1wcyBhcmUgZ29pbmcgdG8gYmUgdXNlZA0KPiBvbiBxdWV1ZXMgc2V0dXAgdGlt
ZT8NCg0KV2UgY2FuIGdldCB0aGUgd2hpY2ggdGltZXN0YW1wIHRoYXQgaXMgc3VwcG9ydGVkIHRo
cm91Z2ggImV0aHRvb2wgLVQiIGNvbW1hbmQuDQpNYXkgSSBrbm93IHdoeSB5b3Ugd2FudCB0byBr
bm93IHdoaWNoIHRpbWVzdGFtcCBuZWVkIHRvIGNvbmZpZ3VyZSBkdXJpbmcgcXVldWUgc2V0dXA/
DQoNCj4gDQo+ID4gVGhpcyBwYXRjaCBzZXJpZXMgYWxzbyBhZGQgYSBuZXcgSFdUU1RBTVBfRklM
VEVSX0RNQV9USU1FU1RBTVANCj4gcmVjZWl2ZQ0KPiA+IGZpbHRlcnMuIFRoaXMgZmlsdGVyIGNh
biBiZSBjb25maWd1cmVkIGZvciBkZXZpY2VzIHRoYXQgc3VwcG9ydC9hbGxvdw0KPiA+IHRoZSBE
TUEgdGltZXN0YW1wIHJldHJpZXZhbCBvbiByZWNlaXZlIHNpZGUuDQo+IA0KPiBTbyBpZiBJIHVu
ZGVyc3RhbmQgY29ycmVjdGx5LCB0byBzb2x2ZSB0aGUgcHJvYmxlbSB5b3UgZGVzY3JpYmVkIGF0
IHRoZQ0KPiBiZWdpbm5pbmcsIHlvdSdsbCBkaXNhYmxlIHBvcnQgdGltZXN0YW1wIGZvciBhbGwg
aW5jb21pbmcgcGFja2V0cz8gcHRwDQo+IGluY2x1ZGVkPw0KDQpGb3IgcHRwLCBpdCB3aWxsIGFs
d2F5cyB1c2UgUG9ydCBUaW1lc3RhbXAuDQpPdGhlciBhcHBsaWNhdGlvbiB0aGF0IHdhbnQgdG8g
dXNlIERNQSBUaW1lc3RhbXAgY2FuIHJlcXVlc3QgZm9yIHRoZSBzYW1lLg0KDQo=
