Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41F53E8600
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 00:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbhHJWSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 18:18:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:53714 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234168AbhHJWSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 18:18:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="237022318"
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="237022318"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 15:18:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="675434396"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga005.fm.intel.com with ESMTP; 10 Aug 2021 15:18:15 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 10 Aug 2021 15:18:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 10 Aug 2021 15:18:14 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 10 Aug 2021 15:18:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H2Btghs3KlDxeRQuSq2Gfy31kS0n5aQ91ChFAi5OJUmPV4AqHmR1U2tQRzeBQcDrVoozOwR0wRDCgAGlRVwvgVZ7+ZMIyQkcOpk416+AwzzbcIib/sghYalpPypndx+Y/eTksN76lacFycTVFBZge6bxh7C9clv0t8qTLFnoDNDos8YC59XzRgW7Fy2oXnjLrgFLY0B7u2+fSzeYdYUDbqeFoE1jYNwOtOpg2TAU0IoFihbRCBK8vAc2G96Tf39J1MTVSnS+eu/2KLRAKeAkYSLnOAVW+yz0MZDXaCutKfp/EgNYBCyPdvikkmV5D9S/j+8/DLgNs5A7zo5D1HEezw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipmRp4Uc+rca9lEFgy0L8X+b0g2Iuf/X45RO+iKhtAk=;
 b=aE/Jz+ndUlfPt7/gQ03TZcsc63/+kPN+KyLN6qlgKBsQuIKQA/Y/PDpe+pUu99OzPL5mPIv4TIaAhxhGu6XTAZjFlYWqBcJ+PSjXffJbSkYhR0EdK1n8aPtQxO/zHfofr/c7oNWJHVYZu7qrfhYOd/fL+KZPnylvT+KTyOJoWJvTBzlzDs1u3xGR0R9Qk4s05DsJZCZ4emDuDfjG/UwrZUtAh3S7atSJazdmb0Jk+WPS1oI5vXtzc5vBFV44siiX19j/3sOZQ5i9BDkywMz4ggwLYrlIVMfz6NjwR34Lq8pLhi/3xgo65jWVUdlsQKyGZyU/yeRoqMKmBNQKpc5HHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipmRp4Uc+rca9lEFgy0L8X+b0g2Iuf/X45RO+iKhtAk=;
 b=WLUd+slkVs6IjMf2DHIcZ0/Vo87tXCdEjAZHuROXmkZkCIAqK10Q+c9HbhU9fyp0IiyN3tfToH+FqPrfCF72p4qc5VTnXy61PzzWHKdeRsQm6Tx0ywp/F/fYIQW0cnO6MOAnvbmUQHeqOguT+lWazknRs03plX4ubyG36/48M2c=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR1101MB2301.namprd11.prod.outlook.com (2603:10b6:301:53::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Tue, 10 Aug
 2021 22:18:13 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960%3]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 22:18:12 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "pali@kernel.org" <pali@kernel.org>,
        "vadimp@nvidia.com" <vadimp@nvidia.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Thread-Topic: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Thread-Index: AQHXjQh2iw3UgViIbkGUQrHAheSIDKtrO5cAgAEcgYCAAGu3AIAAAh0AgABxmACAABTCAIAAAaEAgAADOQA=
Date:   Tue, 10 Aug 2021 22:18:12 +0000
Message-ID: <4512fede-0581-34fc-e609-dc986c468daa@intel.com>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-2-idosch@idosch.org> <YRE7kNndxlGQr+Hw@lunn.ch>
 <YRIqOZrrjS0HOppg@shredder> <YRKElHYChti9EeHo@lunn.ch>
 <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLlpCutXmthqtOg@shredder> <71a5bd72-2154-a796-37b7-f39afdf2e34d@intel.com>
 <20210810150636.26c17a8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210810150636.26c17a8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b70c1631-ac55-45d1-2a28-08d95c4cbe3f
x-ms-traffictypediagnostic: MWHPR1101MB2301:
x-microsoft-antispam-prvs: <MWHPR1101MB23012BAD8CD47A9DE102548CD6F79@MWHPR1101MB2301.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oZbbPAGaYNrvj3NYE91iGPQiLFUe0TmOqjeCSQdESu6iaRGsGKXAS//jU2iMkuXVGHpNyFDlrM1cdhaYekMNRtnNh5/mlJ0nUq2yuP47ryCdywgC6m0dYLqbk4a3iIRBGumnz12cduUn0XYOAkrD1RhtDLffxZcaOiZHf4tEZyMC/TuGYKlqU/mrKvrXXrDtfEj7ZF3F4y9c0GSWd/dZ8oBSW1oH+LlyuqpYytwIhE5De1k659L7HB/hfr4iqYECOL+Pn09BCgPhC1OJAqndCVO7UMZk8worRu5pOVgc3FPqIOnDkJn4RqnvanUh8gZrZt3uNO/uix3iXU/j/MansYCLKt4rHa4UAt3sdEhXX4AUXS45R17s9smaIlyx7W8U01viLzHgqiqP04BfbGIrKME2adyzJ7xbEaxmjQLriyezkmJ8kC5FK4S8jwr2VDm6WzPx1fWmvbEDJ+5ax2LMzEvFiMNthZo61joDgp0Dk6QfOJx1nRO13FzLq8hKv4yFcnnAd3gh4trSTV5rZHajryFjoalp4PcNeAcQEA7DYWrKRYkThgg21J34dQY/N4DhJ88ejExf1sTd/omlOp5OulB1fN+leLeoZ3NORUo20QSTnED4zCq4nvVAwsHlpvFyxRtCKrEkg2rGchMoIVDEu5riL+AM7H6G3SUu02D0gDhqs6YhItgwJarSnB0PGlIgLhncBzchGlcJPQLSIqAPV63WJeKiYCOu5mQAOeEoo31ExVr4rdGbmMOt2SWBZ9tDO7eW5D08Gtr3T2mKmp856Ie/TrVkBpEV0S5wHj/GY71Cd5/Nk50M4amJo3fHYgUVImJbObTuHwadTX3kF1zRLBrSBaRAS65FmHI8BETRXtId3c9nDNBfnYs+LwYIMQrZbZhmLs7rLsLpRFhsd8rNqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(8936002)(6512007)(66946007)(6916009)(478600001)(54906003)(186003)(38100700002)(66476007)(66446008)(38070700005)(2906002)(31696002)(64756008)(91956017)(66556008)(7416002)(6486002)(76116006)(53546011)(8676002)(6506007)(316002)(122000001)(36756003)(86362001)(966005)(4326008)(31686004)(2616005)(5660300002)(71200400001)(83380400001)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUxYemVkV3NXTHEram9YWlZvRVlyY1I5QzBFWmpEUUZKaUk2MmRuSE9LVjVi?=
 =?utf-8?B?VkwxeldTRGFrelRPT3VReHFIa2QyNkszTVp2OExVakdMVkNSSkxKV2lXU3lX?=
 =?utf-8?B?OGF4ajh6M09KdGc4VzNKczBnTk9SS2xOaGgzNm8wbmdSU3IvTWJFQ0lFb1ps?=
 =?utf-8?B?a3Blc2ZGWmVjbHl5UnY5a0hkWkhYbkxmV21PTjJsendudlp2aGljbERWdXF5?=
 =?utf-8?B?ZkJKd05BWitsNGtXWnduR3FTSkpFRCtoWUhMWE8zTUw5Yk5ZdmhRVkdyWnVl?=
 =?utf-8?B?SnpqOUc0dFNtYm1QbERGdW4yRDlYSkFCV2w5UU9mRXdQTE93QWRWamlaRlVL?=
 =?utf-8?B?RVE0YTFwZWdHaDllOWErd1gwNnNDUk9KS1MrVFFhbjVmMXEyUDFqOEpNeUd2?=
 =?utf-8?B?ZW5Dd1ZVNmtKNXJiTnZIQnhXUnB4N0VWcjQwdmdEV202WHZESnVMMytybGlD?=
 =?utf-8?B?YmptOVIyOUVBSXdOUXlIdU9CVUplM09haGhVbEt2TU5JWTJOb1dNVjNpTTJL?=
 =?utf-8?B?YVVFWjBBaVF5WDU2K2l1STJBZ1ZBQlFScVNrZkZOd3ljODRuSmNyZVBLeTJ0?=
 =?utf-8?B?S0ZjTnZIQWwxbUF4WHM0K09odDZtL2RpaytrWFJNY1ZEZEtCY2hONm1mbWxO?=
 =?utf-8?B?TisyT01IdzlzN21kcW1JSldEZC9HNVJXSUpPUU1YSlA2d1c3N0ZuM3lYZXkz?=
 =?utf-8?B?NnlaL3lvQXV6UmlUb01YSnpOcnA4cSs3ZFE2c1VIME5qQWJRd21qNnEwQW1B?=
 =?utf-8?B?NHN6dExlN0xqdUd3RmRtQkZGNDVoOTZxc0J5ZS9RakMzSTFONlBzL0RnbWs4?=
 =?utf-8?B?djdJR1hRVE9ROTNSZkc3MjBRd3pRc2ltSUo1YUhIVXVvTzBXWHYwdHBxMnRJ?=
 =?utf-8?B?MXdwS0tUZkIvby9ldnl4L0tibUtwSkF5MTBuY3lmc3NCb0wyRWIyWDVFNHpl?=
 =?utf-8?B?Q2hEUTBVdXVwU2QveC9WOHIyVWFIR2o0MDF3NE9MUDRqZGtUcEEvY29Gb3NZ?=
 =?utf-8?B?OWdNYUtmQTFLZzdiN2N6L05XWUdNN0VEUDRUUWN2VHRWVGdZVklKZllJU0xp?=
 =?utf-8?B?eWQyOWZIMFJqRVVNRzhxOFhqcnFvK2gvVlVBYzRtNlRVSTR0UXFwSkFYVVc3?=
 =?utf-8?B?WHducDY2alhFblhCcGhzeVZQN3N2ODJEaHAwMXg4WllJSDB2OVdMM20wcWVy?=
 =?utf-8?B?ZVEyOWU0K0RwZXEybkVNbUI0NWJQWE9NOW05aHI3UVpoRUY5RzNEaFV4Z3NM?=
 =?utf-8?B?c0U0ejlhMzkrVFpVYndFR2FiZFR2R0kwK3pKaXBaM3RKOXZmSjRTOElaQ0ly?=
 =?utf-8?B?cFA2TW5pU1QxK1VvcTh3VEFFa3g2Njg0MWFhZ0dJUkdORUJLdzNnYlZoSHpU?=
 =?utf-8?B?SFhIeW12Zk4vNiswTU1pdUZ1UFVJcW5BT1ZuVUpKQ2lQdjdoOEVuTVZ1dXhm?=
 =?utf-8?B?WEtIY2VHeVFnRWUwTE13V1VaMVJaSGNWTEU0Z2JhM3FidkhKdUVsTlhHd2FF?=
 =?utf-8?B?eG52RjdVMXhoVWE0aTlHNFBQZVJoK1FQV3hLc044ZFVVNmlXVDBhUjJTY0VI?=
 =?utf-8?B?b0UvRmMrb2d6TDJKZ1hBTHBRSFo3ZmkyOHRtemtBeWJnL3dEU1lYUGkybTZl?=
 =?utf-8?B?VHM0YVF4Vk9TdVRlZTFzNWthSUNmZUtVNzJLdWJ2aGpvMFp2U1lvRlhQdklr?=
 =?utf-8?B?ZDVlYmlXZVRpU1FQNFNEL0NqdGJ5L2RCejR4dE1VK2o2WklDbXVUN2ZqNVpq?=
 =?utf-8?Q?+Tcvu++IkWHhQ60jYo=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <69580EFB51976C4F9B3807E202EBC664@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b70c1631-ac55-45d1-2a28-08d95c4cbe3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 22:18:12.7770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C12oF51qQo3rHY50D4+/pM9meDZC8QDzz/AC3B1959Td4ZUk3jH4UrPKBjavo/G5ejDUwk1uk2CWsyfuagsBk8IwEpFPDNgfbspaUKrzcnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2301
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8xMC8yMDIxIDM6MDYgUE0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBUdWUsIDEw
IEF1ZyAyMDIxIDIyOjAwOjUxICswMDAwIEtlbGxlciwgSmFjb2IgRSB3cm90ZToNCj4+Pj4gSmFr
ZSBkbyB5b3Uga25vdyB3aGF0IHRoZSB1c2UgY2FzZXMgZm9yIEludGVsIGFyZT8gQXJlIHRoZXkg
U0ZQLCBNQUMsDQo+Pj4+IG9yIE5DLVNJIHJlbGF0ZWQ/ICANCj4+Pg0KPj4+IEkgd2VudCB0aHJv
dWdoIGFsbCB0aGUgSW50ZWwgZHJpdmVycyB0aGF0IGltcGxlbWVudCB0aGVzZSBvcGVyYXRpb25z
IGFuZA0KPj4+IEkgYmVsaWV2ZSB5b3UgYXJlIHRhbGtpbmcgYWJvdXQgdGhlc2UgY29tbWl0czoN
Cj4+Pg0KPj4+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0
L3RvcnZhbGRzL2xpbnV4LmdpdC9jb21taXQvP2lkPWMzODgwYmQxNTlkNDMxZDA2YjY4N2IwYjVh
YjIyZTI0ZTZlZjAwNzANCj4+PiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pZD1kNWVjOWUyY2U0MWFjMTk4
ZGUyZWUxOGUwZTUyOWI3ZWJiYzY3NDA4DQo+Pj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L2NvbW1pdC8/aWQ9YWI0YWI3
M2ZjMWVjNmRlYzU0OGZhMzZjNWUzODNlZjVmYWE3YjRjMQ0KPj4+DQo+Pj4gVGhlcmUgaXNuJ3Qg
dG9vIG11Y2ggaW5mb3JtYXRpb24gYWJvdXQgdGhlIG1vdGl2YXRpb24sIGJ1dCBtYXliZSBpdCBo
YXMNCj4+PiBzb21ldGhpbmcgdG8gZG8gd2l0aCBtdWx0aS1ob3N0IGNvbnRyb2xsZXJzIHdoZXJl
IHlvdSB3YW50IHRvIHByZXZlbnQNCj4+PiBvbmUgaG9zdCBmcm9tIHRha2luZyB0aGUgcGh5c2lj
YWwgbGluayBkb3duIGZvciBhbGwgdGhlIG90aGVyIGhvc3RzDQo+Pj4gc2hhcmluZyBpdD8gSSBy
ZW1lbWJlciBzdWNoIGlzc3VlcyB3aXRoIG1seDUuDQo+Pj4gICANCj4+DQo+PiBPaywgSSBmb3Vu
ZCBzb21lIG1vcmUgaW5mb3JtYXRpb24gaGVyZS4gVGhlIHByaW1hcnkgbW90aXZhdGlvbiBvZiB0
aGUNCj4+IGNoYW5nZXMgaW4gdGhlIGk0MGUgYW5kIGljZSBkcml2ZXJzIGlzIGZyb20gY3VzdG9t
ZXIgcmVxdWVzdHMgYXNraW5nIHRvDQo+PiBoYXZlIHRoZSBsaW5rIGdvIGRvd24gd2hlbiB0aGUg
cG9ydCBpcyBhZG1pbmlzdHJhdGl2ZWx5IGRpc2FibGVkLiBUaGlzDQo+PiBpcyBiZWNhdXNlIGlm
IHRoZSBsaW5rIGlzIGRvd24gdGhlbiB0aGUgc3dpdGNoIG9uIHRoZSBvdGhlciBzaWRlIHdpbGwN
Cj4+IHNlZSB0aGUgcG9ydCBub3QgaGF2aW5nIGxpbmsgYW5kIHdpbGwgc3RvcCB0cnlpbmcgdG8g
c2VuZCB0cmFmZmljIHRvIGl0Lg0KPj4NCj4+IEFzIGZhciBhcyBJIGNhbiB0ZWxsLCB0aGUgcmVh
c29uIGl0cyBhIGZsYWcgaXMgYmVjYXVzZSBzb21lIHVzZXJzIHdhbnRlZA0KPj4gdGhlIGJlaGF2
aW9yIHRoZSBvdGhlciB3YXkuDQo+Pg0KPj4gSSdtIG5vdCBzdXJlIGl0J3MgcmVhbGx5IHJlbGF0
ZWQgdG8gdGhlIGJlaGF2aW9yIGhlcmUuDQo+Pg0KPj4gRm9yIHdoYXQgaXQncyB3b3J0aCwgSSdt
IGluIGZhdm9yIG9mIGNvbnRhaW5pbmcgdGhpbmdzIGxpa2UgdGhpcyBpbnRvDQo+PiBldGh0b29s
IGFzIHdlbGwuDQo+IA0KPiBJIHRoaW5rIHRoZSBxdWVzdGlvbiB3YXMgdGhlIGludmVyc2UgLSB3
aHkgbm90IGFsd2F5cyBzaHV0IGRvd24gdGhlDQo+IHBvcnQgaWYgdGhlIGludGVyZmFjZSBpcyBi
cm91Z2h0IGRvd24/DQo+IA0KDQpUaGF0Li4uIGlzIGEgYmV0dGVyIHF1ZXN0aW9uIHllcy4gVW5m
b3J0dW5hdGVseSBzbyBmYXIgSSBoYXZlbid0IGZvdW5kDQphbnkgYXJndW1lbnQgZm9yIG5vdCBk
b2luZyB0aGlzLiBPbmx5IGEgYml0IGFib3V0IG1hbnkgcmVxdWVzdHMgdG8gaGF2ZQ0KdGhpcyBi
ZWhhdmlvci4gSXQgbWlnaHQganVzdCBiZSBpbmVydGlhIHRvIG1haW50YWluIGN1cnJlbnQgYmVo
YXZpb3IgYnkNCmRlZmF1bHQuLi4NCg==
