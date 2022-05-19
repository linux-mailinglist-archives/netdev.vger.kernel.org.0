Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B713D52CC9B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 09:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiESHM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 03:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234689AbiESHMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 03:12:51 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2856C68318
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 00:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652944370; x=1684480370;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W23qM1Z9+INZRFcTHnrAYMnFccxugl5v6ZXgrz/meJ0=;
  b=PdyF5HudesaV4Al+YCaGwZ2SaL5IMgA9C0j4iYMF2E615M5xv1pOsb4V
   Gh5kyDO0ajLc2s6KlwnhuoKxQYAbXgQn9NfGWhLDZ6RLREPQERJX3uJVR
   7DbnYNNWQvpQTBwxuzWGalXvTB6ui5Fhvs6q64NVgjMdhM4WUJWspQLjV
   LCghl2n2E40/4SScUKJ0CmcXV3lfdB6696zoCSim7x20nSDiH0/qrz1pT
   IZr/zWUzfi99QTVA4Om7CP+0FQ/SnxavuzGPxc4DGyeqiFuefrtNkfsfa
   19QsJlag8kfCqUb14ddi1g+ln4RdNGD+48btKWErJsosjAQpwGkFWEjlP
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="270884473"
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="270884473"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 00:12:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="606340239"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga001.jf.intel.com with ESMTP; 19 May 2022 00:12:49 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 19 May 2022 00:12:49 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 19 May 2022 00:12:49 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 19 May 2022 00:12:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdYX8veFyWqeNOWqN4MW66moEMw9Re//hQ46cy6Bsl7aeF/UCehbgyBeEMHJ6W/AC7tUETxoba1cOPan9TV3fbXmOByaNaasUoT2Ek5tJcph8eHHaiFsKsDaDeiv6UF7/14F0bNIli5sEosoXKlYxjN6iIW7DJjJZr/WYHeWN3sTcKlsFBlH1PNaFWnYbxF7N0q3dr0qlwpX0F4cmoZbAnHvpld0npL9D6itG+T8QWRGJ3luLxLMiBJ23XGZ4BU1NR41IrNfWKSaX08E42weXikl/TcYJLqpzXjO9JqzXRkZ2jwZ7RoKgw6nncFSzeEqbqOP64GYoAcxGrOVVbh17Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W23qM1Z9+INZRFcTHnrAYMnFccxugl5v6ZXgrz/meJ0=;
 b=n1p9GXzMhdJrML+DQjhnSO12ED7wjksuALTcc1pM+xT6rGDv4z1muRY1jxnLoiPC0PG/+ZM0aaXikRR0U7cvEXcJw694uXyBf85bkHxngBF2XqFJgy2cCtgByRgqbsSnbHx6ofWJ4qugpC6FH9NYpa+ogrA5gxoDbjXoBXErfEsmN2KTAh8g6JbXm54u7earlybF64sTNv2YfurPYpQO2dHAqqEo0CuVZ7XoofYfz7b9yS+1v5FEt3dBj/BMPQAMccOgqZhscUEPlJUiV/ps0oM9VO9Q7Vzei36MX6OQn0BJbkrWghiztO6lJSRjFcGgAJe8p0+lMwUyhasmnar0gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by DM6PR11MB4393.namprd11.prod.outlook.com (2603:10b6:5:206::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.17; Thu, 19 May
 2022 07:12:48 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3968:a4a:e305:b6f2]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3968:a4a:e305:b6f2%4]) with mapi id 15.20.5273.016; Thu, 19 May 2022
 07:12:47 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        linuxwwan <linuxwwan@intel.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: RE: [PATCH net-next] net: wwan: iosm: remove pointless null check
Thread-Topic: [PATCH net-next] net: wwan: iosm: remove pointless null check
Thread-Index: AQHYaxmQyDjPwT0iYkyYiNHTGXla060lyJNQ
Date:   Thu, 19 May 2022 07:12:47 +0000
Message-ID: <SJ0PR11MB50087702603728A3BB01D33AD7D09@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20220519004342.2109832-1-kuba@kernel.org>
In-Reply-To: <20220519004342.2109832-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abec3da4-e8a4-49de-ce39-08da3966fa8b
x-ms-traffictypediagnostic: DM6PR11MB4393:EE_
x-microsoft-antispam-prvs: <DM6PR11MB4393787F0C59EE0C80E18754D7D09@DM6PR11MB4393.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CTDeyXH84NHbdKzk3VP+b6pngnk4TQRC4Z1vfFmMnSCxycgKN8TE0zYkqq7Jy4Y32xFelYWCm8siV2693BrAahb3kMIeoUeRt/arazYTEPSSZaU5A9oSY3pLdiBIx798MduB2stGEIqTlh/HI4fefPL7064uE7+oJKU7fVukjkRwJek7mCnTzjI3FB4t7pPv9mJaRFiqMK5ORwnYapyZOAJCLhEdL3qOHnpK2xAv7cdpHE5i425gfnGt85jduEwrFtQ7FCQzPW6XVUdl7l9S+k70HZTo7fv9cRnEdgWN8CVQ+SySoMxrAaOgt6+UxTRNEGdyCPAhpsmCcyFt07TjOIawcWF6/QPuZhbl3xpP7a4NxBkQSZx8eNTuiwbFM3KBPvLwAkww8NcB9/Gib6ZB12G0vSWPBSU6MyxXI3wHWMuuyxKxwetJWTHCTDtIlDcNKmyzaGX4vpUShT4OpyHXK0yUHf+BRT9gq77ZiRPLOBdL3A0RoyNyyOLXD5FYZJ1OsavfkzcCsQSyeuYVUMkraAKpKSS33OktnU1rAfAVdltP18BAM6MAjN4rCKe3JTysYrQq1z0vCBnrB0+HjSL+u49I1435jSjM4cTKJkhs1cDtia8p/07YdWvonnmMwGjFBpR8epvwt05d8WhkQkMoKWp2j4i47C/8C8K+ab6jEYfclVPk8Rtl8105hI5mamGj9JHorjlV3ZxblDXvktlRPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66556008)(76116006)(66946007)(2906002)(66476007)(4744005)(66446008)(316002)(9686003)(26005)(8676002)(33656002)(110136005)(53546011)(54906003)(64756008)(71200400001)(82960400001)(52536014)(186003)(122000001)(55016003)(8936002)(7696005)(83380400001)(6506007)(38100700002)(86362001)(5660300002)(38070700005)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1dkcTY5bjVsMC8vNzBrY3ZQM05RT1dPaXZWUnhwa0J0RFFVQjFlam1LaWtp?=
 =?utf-8?B?ZDVmVHUrZml3R3BXdFprTkRPbWcxUWtDWlVsZEZVVVR4NlRhbWlQNHdpN0sx?=
 =?utf-8?B?aVMzazdJUFpxaW9zb3Z2R0c1SS9ReXhyT0hCcDRiWUErUThMUlJhOXZ1Z1dZ?=
 =?utf-8?B?bi92cWlnT1pydnEvblNuSVl4dXRzQlpPTWF6STg3dHNacXA5UURsMENEa1lo?=
 =?utf-8?B?RGtWMU9YVmF6SkFWOTdjNVN4bUYyZHd2Ukt3OGtQSWlRRWhCYUJkUXROdWxX?=
 =?utf-8?B?QUFxRFdrOVFmSU1ONHBYbEdrR3htSEQ0cVVBWGFsaEliNnltZUIyU1huMExN?=
 =?utf-8?B?R2ZwdEVxamFPQjlmQ0EzOFNFbmlQdGljckx5N2twQ2JlZS9uS1J2ZFRqWEd4?=
 =?utf-8?B?cVNLdTV3Y25IRi9yWk45ZVNrOHJJTzBLVTh3bnh3U1FoMWEraERtMmMrOG5t?=
 =?utf-8?B?RlBHaTNRV2JLaEdQcnkzTjNFMENLdXRIeFhnLzB0THM4cnNJS3psUFdGR2pi?=
 =?utf-8?B?N2hzYUVPdDBXNC85QkVteE14WXY4ZjdGVllnd09Uc1VadEQzQWcxZjFpekdm?=
 =?utf-8?B?S0xtTE9IakRIcU5LdEtJUkhNU05CLzlmSi9rdndIRUVZSmV5eXV3UkRyRVFX?=
 =?utf-8?B?a05kRDhMNHlGK2ROMUxRRjNXNjNQT1o3MG1pWllOR0ZHMEFtRVBPaEhBWEZE?=
 =?utf-8?B?NnJYRFhFZmp4VFpFL3RkWUxhZjFiblI3Tnh1NXdxem9GYUlTZnZVQjZGSjgw?=
 =?utf-8?B?eHdYdzFEZ0N3ZG82VXNpck1qSUtTUmdRNmlkZ3RRd1czLzJRdWFiR002b3hx?=
 =?utf-8?B?RjAvalZZRXFYS1VMQmtOTWtmblVIZkhzdmRjdXYxWVlpV3B5b1d1dURseURP?=
 =?utf-8?B?Y2RtZjJBOEhlQnFwWU5hdjQ4dGFLbmdpUWkxck5oQnpXSS9TN1BpV05EL2tN?=
 =?utf-8?B?aDlmNGpWdFYzMkFPa0ZQc2hVSFhVcnFNQnFhSXlYcXlSQWRVTWwwYTNQOWhz?=
 =?utf-8?B?amtyZCtzSjhieEpCUFhmd002aXBSQTlzMGdYeW1sdTBoeUhMM2lVVjdPZ0Fs?=
 =?utf-8?B?QzZoUFBZU01FY3ZvOG5jMjliYzZOeW13MW51OEZ1bmlNYlV2Y2JUaEt0ODEr?=
 =?utf-8?B?bDk1SkpJYzBBdFVnY05uaVYwUkxWQnBabzlxSFdQYUQrdW1pNjA3U3hOUlRX?=
 =?utf-8?B?ZU9oRERaU1dCYTdDQTFRUkR4VmE0QlRUejhmN3hYWnhWaFV4TXJqM0RYRHc4?=
 =?utf-8?B?ZjVCWTc5SnY3a1NNbFlWRmlPc2VNT3NmSE1SQmVKOUNROFA2MUtlU0t2TERF?=
 =?utf-8?B?M1d4T20zSTZNcHhKSHV6TUIvdjFKOG5hRWZZaFRTSkFLSDJWaHNRQTBpWXdG?=
 =?utf-8?B?UzNjRUV4NXBYRjJtL245c2t4TlowQ0l5YjM3OHMxandPQ3dBemNWSzVkUENv?=
 =?utf-8?B?VmNjQWpPOXdsNWxnNmU3azlWWkQ3OUlobXNuajQ0SGhRWjJUMWE2eUM0anc1?=
 =?utf-8?B?T3BCclNVRVlzSXpWRVZqdk9CUXJWcGNrUlQ0YXlMcmZMNHk4THdUY2pPY291?=
 =?utf-8?B?L1pITGNlb1Vrc0Z3M1NnV3haZjdsK3lHd0JOdHk3ZFpkZCttQ0haQWdNdGxI?=
 =?utf-8?B?OHhvOE1Hc051SUJMNUk2N0tkaHRxV1ZBS3ppSnNObGVYU2c0R0tmZWFsdi92?=
 =?utf-8?B?VVRsMTBScHQyZ3FmeUg4VVR4bGJ5Z0g1cWV4QnRiYnZHc1lmSWFoYmt6WUtr?=
 =?utf-8?B?TlQ1Yy96dytiQ2w4VXNHaVUyV0g1WXZOVVZTWnYrWEhPenQzR2NYb3V2VTBu?=
 =?utf-8?B?OXJXb2d6UVF6Z2Z0eWsweHRsUnNLZ2JVbGNtdm5yYmp6QzNEY0pkWmhsak5x?=
 =?utf-8?B?eTY2VHpveXhLZE1UdEFEWHp6cUZtaEkvY2lad0tPd3cxd09IdTNneGtIeTB4?=
 =?utf-8?B?VUUwbXFpQ2liWTgxZzZWUnhqeW14RlNaMkc5cC9rWllDZ2F6anFqT0IrSFE4?=
 =?utf-8?B?UDA0VXhkMmU5Zi9jRDgwRnY2WmdXVlozaEprTlNZVWxJdWdtU01NNFRYZGJR?=
 =?utf-8?B?TlJWTkZkRkR4MmU4UkVIQ1FZMXltSkI1UFRKS2pQV1IzY0hLWEc2TXQzV2Zs?=
 =?utf-8?B?a2NWMkp5SDluQ0tzM01rZjFWR3dJbTRuVG93elZYWEdCK2NZVkNteFF3VG4y?=
 =?utf-8?B?M1JRTVdrWUNNTDlHSzVyVVdrZ1l5RWVhVU10aGlmbytjTEQ0clk2ZmFyS0o1?=
 =?utf-8?B?OXN6NHExWEtEaUlJbVVNb3ZjVDhZODE0d1R4RE9JL1gydG1aTDN0WXA5NmlV?=
 =?utf-8?B?WGVMd2dTV0dBajZPSFVJeTc4dDhlWGRsWlJrVk9CSEJLcFlzV2gyNjhzWnJF?=
 =?utf-8?Q?guXzD3VEK1HIkAcg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abec3da4-e8a4-49de-ce39-08da3966fa8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 07:12:47.8791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LFQLvysj8rPgAigMMg4oQzDV3jk5S0pSaepavGdrqwoEKqPg6t8qA+M88cBU5Ur1AvMBq8EavOL5LefZdtVM9jtAoksfbgDH43yVtqh8Ruw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4393
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYWt1YiBLaWNpbnNraSA8a3Vi
YUBrZXJuZWwub3JnPg0KPiBTZW50OiBUaHVyc2RheSwgTWF5IDE5LCAyMDIyIDY6MTQgQU0NCj4g
VG86IGRhdmVtQGRhdmVtbG9mdC5uZXQNCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGVk
dW1hemV0QGdvb2dsZS5jb207IHBhYmVuaUByZWRoYXQuY29tOw0KPiBKYWt1YiBLaWNpbnNraSA8
a3ViYUBrZXJuZWwub3JnPjsgS3VtYXIsIE0gQ2hldGFuDQo+IDxtLmNoZXRhbi5rdW1hckBpbnRl
bC5jb20+OyBsaW51eHd3YW4gPGxpbnV4d3dhbkBpbnRlbC5jb20+Ow0KPiBsb2ljLnBvdWxhaW5A
bGluYXJvLm9yZzsgcnlhemFub3Yucy5hQGdtYWlsLmNvbTsNCj4gam9oYW5uZXNAc2lwc29sdXRp
b25zLm5ldA0KPiBTdWJqZWN0OiBbUEFUQ0ggbmV0LW5leHRdIG5ldDogd3dhbjogaW9zbTogcmVt
b3ZlIHBvaW50bGVzcyBudWxsIGNoZWNrDQo+IA0KPiBHQ0MgMTIgd2FybnM6DQo+IA0KPiBkcml2
ZXJzL25ldC93d2FuL2lvc20vaW9zbV9pcGNfcHJvdG9jb2xfb3BzLmM6IEluIGZ1bmN0aW9uDQo+
IOKAmGlwY19wcm90b2NvbF9kbF90ZF9wcm9jZXNz4oCZOg0KPiBkcml2ZXJzL25ldC93d2FuL2lv
c20vaW9zbV9pcGNfcHJvdG9jb2xfb3BzLmM6NDA2OjEzOiB3YXJuaW5nOiB0aGUNCj4gY29tcGFy
aXNvbiB3aWxsIGFsd2F5cyBldmFsdWF0ZSBhcyDigJh0cnVl4oCZIGZvciB0aGUgYWRkcmVzcyBv
ZiDigJhjYuKAmSB3aWxsIG5ldmVyIGJlDQo+IE5VTEwgWy1XYWRkcmVzc10NCj4gICA0MDYgfCAg
ICAgICAgIGlmICghSVBDX0NCKHNrYikpIHsNCj4gICAgICAgfCAgICAgICAgICAgICBeDQo+IA0K
PiBJbmRlZWQgdGhlIGNoZWNrIHNlZW1zIGVudGlyZWx5IHBvaW50bGVzcy4gSG9wZWZ1bGx5IHRo
ZSBvdGhlciB2YWxpZGF0aW9uDQo+IGNoZWNrcyB3aWxsIGNhdGNoIGlmIHRoZSBjYiBpcyBiYWQs
IGJ1dCBpdCBjYW4ndCBiZSBOVUxMLg0KDQpSZXZpZXdlZC1ieTogTSBDaGV0YW4gS3VtYXIgPG0u
Y2hldGFuLmt1bWFyQGludGVsLmNvbT4NCg==
