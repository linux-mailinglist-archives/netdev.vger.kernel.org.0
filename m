Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E691453457
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbhKPOkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:40:14 -0500
Received: from mga18.intel.com ([134.134.136.126]:5919 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231127AbhKPOkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 09:40:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="220589052"
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="220589052"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 06:37:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="592707586"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga002.fm.intel.com with ESMTP; 16 Nov 2021 06:37:15 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 16 Nov 2021 06:37:14 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 16 Nov 2021 06:37:14 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 16 Nov 2021 06:37:14 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 16 Nov 2021 06:37:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lxvTnEi9IfJHWnVRzjUwnKSN/LpQpzeblWVG7+4CdjXJQjXiD9MMoLqaKqSy6uBv7tYrJPHM7vxtkbieYiN5IH76+tpcsrDZXzjycabBYW0dUDwKgKLOaGAbEkKO0C++waN4iqWRWLWqoo9aQrLbydzy+bwD8j52Oll5qSanB2wjFedNv4lNZ8uPegyjd6WZqR+Z93jdSq36WGXFQDuP1aMQu6KB3O0ldxhBLTfppmRDwip12dPEFTTwfdIQiByC2KTMZkZ/DfF67su1OsG4HmS65eqBnNHBlwy7V8Fe1bWYLLNlYOeVZrrQRJNLlIdzWVV0Weq29MylEGmQTjaJcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/s4w977s1eMQYNb52T+vCb6/viGUmhv6wCsMYVdJBTk=;
 b=d6liEFiOGgD8rDJqpyapkOc15r9xZtwMzaz9wf/7eiz4cALf5WJrBSS5v9/SdFAJm+rjoFSajl98YROAZXVjIa/cdBMDfEheZGFV1e+5PosCQbEBKWIsUSIaYHEKTIT7vruA0OBfAbXwtUq7MR/G0FeEWbGl58g2cCJwiy/WlzxeT2+QO6zDPNYS2gF6uO2VIWw1ETTq5mJLaWSudXSdJXrFuZIrHKQJmUbPi1nKaQm5kZJhV3U1Dx/arsHYiY6vct8OB7mqSFUXZ7csGOpuNkq1qXb0/gWO115e56c9dTeJvWonRIcIz9X2tfmpqxNUlK6JPMDXHmb3gA1HqPJjrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/s4w977s1eMQYNb52T+vCb6/viGUmhv6wCsMYVdJBTk=;
 b=E/Cu+JggT5sq+aht5L/6fYAxZ/Q6VHXrlS+GvblyceLENYWjnchI9NvxC6rX9qXqRne7hD/fQAtFdRkD6/6CbQ8WzG78VjEv004fv+QdZwLWqeymQr+cHo/P6IM4I90AtXow9ygk3U1RpYosESWj0K4anoa/MPRsiNdHjjjv/iA=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MWHPR11MB1727.namprd11.prod.outlook.com (2603:10b6:300:1f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 14:37:13 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9%7]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 14:37:13 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: RE: [PATCH v3 net-next 2/6] rtnetlink: Add new RTM_GETEECSTATE
 message to get SyncE status
Thread-Topic: [PATCH v3 net-next 2/6] rtnetlink: Add new RTM_GETEECSTATE
 message to get SyncE status
Thread-Index: AQHX1iqA5RlGiTEzKkqK25dIf+5Hpav+flEAgAfCi9A=
Date:   Tue, 16 Nov 2021 14:37:13 +0000
Message-ID: <MW5PR11MB581243EFB3A84BD2912ACBF8EA999@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211110114448.2792314-1-maciej.machnikowski@intel.com>
 <20211110114448.2792314-3-maciej.machnikowski@intel.com>
 <YY0+PmNU4MSGfgqA@hog>
In-Reply-To: <YY0+PmNU4MSGfgqA@hog>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6822d038-4bbf-41b1-6c95-08d9a90e9476
x-ms-traffictypediagnostic: MWHPR11MB1727:
x-microsoft-antispam-prvs: <MWHPR11MB1727D2C2A4B5BDD260F606B6EA999@MWHPR11MB1727.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h0WETBY+YimkYkPHQJmLgH27t2cmcyWW9mKQM3lb2/kwvVYWemuJfSmeirhoJcm4P02r5bOHiwshJjnd4t4gGO/ytDBynhz7AkcLVqCYnIvvdwDed06oB4alte+y9TUXocVEbmZKKUk16MsnZEBuTc578PSxVkxZCMPriqZuNxO+5dG7JnfDhP9CZvSPjWH0s0QyS6PGlkkUaVkf55nmaUFGbtjRJF8gC2zCgl9KXyXaI+jhqppfcntxc36hDrDb5mRIh8aw/V06EU6lIWuLJSp9ssPZJBnVycUvNNgjBBn3NmLDIhukSk5YclydI3hAqk5vUhlEfkrHCNXAQHNsPDtBHfYTRDA6To/eO8R/Q1T76olvs0Z3myUVbYMh0C0VEP+C46BIVZfxrGuNLcK2jFmoIZbywuLRtgLz/VhebhjgAhvXbTXPNvw2EuAS6P3PyqHNItUa+YtfgsfyLGHHI6UP1V6J/Ky4w1QSbMeswfh7+F/H/VsrtmTm7cT5LZLMraIEbYr+HTd/2Ut6vnl4dV8Fp8+v3+7ndi8UZadw18vSfwsT13/YpIktTKx5ajn+fhWZoN46o4GZ74s4KjCLvot4adrpmSAuum/9td9oowhSkJUBMPMnj4etHfdGtroTtjxtXndfr7cR5zlQHzjx8G337txAAa7QjDEU5zJvemHP1tcSfhujKKXNPN5LWHuBZMTKXlokvifBtPtHfUEzCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(54906003)(66446008)(53546011)(7416002)(6506007)(86362001)(5660300002)(38070700005)(508600001)(122000001)(83380400001)(8936002)(38100700002)(7696005)(8676002)(15650500001)(33656002)(26005)(52536014)(66476007)(66556008)(64756008)(71200400001)(66946007)(55016002)(76116006)(316002)(4001150100001)(186003)(6916009)(82960400001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmV2d0JFS3d0ZzhyUldOQTF0aVVLdFowaWVVbmM2WXhXUEtQMmIvTXNlNHVV?=
 =?utf-8?B?dm1Gd0RRNm1PdnBuK2c0QmEzUFdkTlZaYW0reVhwMW9qbGthWHBFNzBKcHMz?=
 =?utf-8?B?cDU1T3M1RktNM2toM3ZlRHZ4a0ZyT29SYXNndkVEclJKeWJOaXE5Wk85clhN?=
 =?utf-8?B?VUV5cDV5NTJKdWZ3SEN5UllXM0M1ZS9LVVR0OW9SOGt1cDcxdklzY1pnUUc1?=
 =?utf-8?B?WWNmbFBDVk92T3NyaWU5Mk1EL01DRUVDOEJOOU9rMWdXUnIzcjRvOXdxVy9R?=
 =?utf-8?B?WFdzRUt4TWt5YyttN0RqWGs4SU05ZmdaU05oMVBXOVY4V25qaW95Vlc2UDJF?=
 =?utf-8?B?MkR1ZnhFQldSRThZN0JQS1VodlFQV0RnQ0MzTGdkdmNXN2tmS3JqRlFpOFAy?=
 =?utf-8?B?NnY4UnFtc0tyVnc0K054Z2RqMzNwK1BRMFoyaG5XNXlJZW5xNlI2Wld0Rllk?=
 =?utf-8?B?aUdQbmVrajdiaklMRTAwSThkMVNRYWRLTnNrRmJzbVRHeWFlYmpGUDRyaHJm?=
 =?utf-8?B?NDNySjMrajlWRmVQTllVM0FJYUVLYkFzYTY2T2gxV251b1NqQWRwdGp3M1Vm?=
 =?utf-8?B?eWoyUGUxWWpFUUhOemZyK3RWZWNSYytuN04xNDQrSlNBK3VKQzZ2eHdoTCti?=
 =?utf-8?B?RW11WHpvV056Q0MrckxwbHF5akIvZlRzd25sNkZIRzhUQnZnRW9RME1xSVU2?=
 =?utf-8?B?MzRGR2kzbkhBV1RZRGlvS2tYckt6cjZCV1BBRjBIYzJiTFBxS1JDYmpDQklH?=
 =?utf-8?B?dEY4QitqNHI5ZXpQVlFBRUkwVkhDNUJmZHIwZUJzQnJoNTJITXlxSU03djVo?=
 =?utf-8?B?cGFBRWxEci9nOXFzc0s2STFIUE9FTllsdGZFd2ViZGhPNDAxNkVIbHVqTU83?=
 =?utf-8?B?WmJkTzVLalg2c093U3RNWUliODNnUnpjUm92ZkJQZEZSdmR0SlM4Vm9TZEtD?=
 =?utf-8?B?amptclVzc1FBZnNkNDd6UDkxdkFGMmUvdE9UTllFSFcySGFQbVo0NmNkMkU2?=
 =?utf-8?B?T3I3OUtMMjdLTkNlT2lXMk5WbFl6QVd0OThVdStEL1JhSG83WEhTT0NDVmFR?=
 =?utf-8?B?RkdmYVRZSkw2d1Z3QXoxYStXbUdHV1FRYUwyNHRNR0JyUnlLTGNSNzU3LzBZ?=
 =?utf-8?B?bVRhdXhheTFnWncxdVg2VitwdE1aWSt1bU1GZld6U29GUXlNYXB3ZG9ObURM?=
 =?utf-8?B?SDRyY3h2bHo5cTZNWGJ0RUFEOWNJVElIdHJybnlvbVpVZXZQeERzU0pGVlZL?=
 =?utf-8?B?ckFVTGhaNlhzeWZsTGRnZWx2RE52MDY3b3V3cE8xQTdhZkdud1BiclVuQ2cx?=
 =?utf-8?B?dU1PZ3hUSDRFaUNuWWZTSisrdmFRQVZDYkM0QVpTWVVmUDRCMlRjY1g3SEQw?=
 =?utf-8?B?TkVNNDk1ekNXL0ZEM25iYlNjallFY2ZKUHhIUXY1TUdyaDJlTCtqWkZBWEZ6?=
 =?utf-8?B?d1ZJMytvUUg5N1RKdHpXWC9JVzJQQ01ROXJYVHdGc2FNTDcwN3lkNXg5SGt6?=
 =?utf-8?B?UHcwcGpTV2ZRUTZBOElkRnFMRmxJb2hVZmhBNkRUcUJ1V0E5eGZuL3RjaWQ4?=
 =?utf-8?B?emNmck1yTDFQM3M1R1ZSSExLN21FWUljN0tDZUVCMGk1cWZFaXp1T28xQ2FJ?=
 =?utf-8?B?bHRHU2Fhd0Y1ZUgvQVVMT1k5VnFNWkNkeCttMzBObThxUzl4ZTZBWFlaZjQv?=
 =?utf-8?B?NzhXalJZQ0NQWTlBNDhVRkRKUXF4WU0xQ3prVnpjNVRNUms5TW02dGQ3YU1L?=
 =?utf-8?B?ZStzUDMwOFhTQjQ4dnQ5Vm5Ia3cvaUZEOE5ncGJGakYzdWg0MUdweDh6dFNz?=
 =?utf-8?B?VWk2OGRlVDdnSFRzU0c1N20yUGRzdE5WM085Z2U3NVFpK2E4TVhSUllMK0Nk?=
 =?utf-8?B?bWpJSlZNUERqajZMV0NaN1pMZ3BBWlVvMjBsSUt2TEFmSmdTam5IZkg3Misw?=
 =?utf-8?B?eC80c0tWOXlOczNYbktrSTVDa2NhbHd1QU9oRXVoK1d6blJSN1UrbnliYzBU?=
 =?utf-8?B?c1dNeUdWUU54MS9zM1hkWDlZT2xLaUNoQXp6OGdvZDFlL0dmTUY0QkJjSURL?=
 =?utf-8?B?RFl3OVI1eTM0UVdWN2VZM0JEcXhIOE42WWZSeXZFU2tyVytLeS9RQ012WHhn?=
 =?utf-8?B?clVyTjVPUm9OcytzRTd3WnZ3SWI3VXBzdWJ1OU4zakZhNDdQdkxCZUszT3Zl?=
 =?utf-8?B?NXdnQXdkY2lmK1BJeXFDVUdlS0RKSStONGZabkZzUWV0Sy9jR0w0UXBMWjhR?=
 =?utf-8?B?TUhJNUJwNUJ3TS9GV0hWTkFGbmRnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6822d038-4bbf-41b1-6c95-08d9a90e9476
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2021 14:37:13.3697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o4pyIsRzzJD2qEOP+fhh1ZgrYyjZF1r1GzDdkgYoOWM7QagQi2PjFLn6MjCa+LJlY3dgnlz+aObBHMegs2VMBPunLxgpE8L8TNU3pF3BBm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1727
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTYWJyaW5hIER1YnJvY2EgPHNk
QHF1ZWFzeXNuYWlsLm5ldD4NCj4gU2VudDogVGh1cnNkYXksIE5vdmVtYmVyIDExLCAyMDIxIDU6
MDEgUE0NCj4gVG86IE1hY2huaWtvd3NraSwgTWFjaWVqIDxtYWNpZWoubWFjaG5pa293c2tpQGlu
dGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MyBuZXQtbmV4dCAyLzZdIHJ0bmV0bGlu
azogQWRkIG5ldyBSVE1fR0VURUVDU1RBVEUNCj4gbWVzc2FnZSB0byBnZXQgU3luY0Ugc3RhdHVz
DQo+IA0KPiBIZWxsbyBNYWNpZWosDQo+IA0KPiAyMDIxLTExLTEwLCAxMjo0NDo0NCArMDEwMCwg
TWFjaWVqIE1hY2huaWtvd3NraSB3cm90ZToNCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBp
L2xpbnV4L3J0bmV0bGluay5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L3J0bmV0bGluay5oDQo+ID4g
aW5kZXggNTg4ODQ5MmE1MjU3Li4xZDg2NjJhZmQ2YmQgMTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVk
ZS91YXBpL2xpbnV4L3J0bmV0bGluay5oDQo+ID4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L3J0
bmV0bGluay5oDQo+ID4gQEAgLTE4NSw2ICsxODUsOSBAQCBlbnVtIHsNCj4gPiAgCVJUTV9HRVRO
RVhUSE9QQlVDS0VULA0KPiA+ICAjZGVmaW5lIFJUTV9HRVRORVhUSE9QQlVDS0VUCVJUTV9HRVRO
RVhUSE9QQlVDS0VUDQo+ID4NCj4gPiArCVJUTV9HRVRFRUNTVEFURSA9IDEyNCwNCj4gPiArI2Rl
ZmluZSBSVE1fR0VURUVDU1RBVEUJUlRNX0dFVEVFQ1NUQVRFDQo+IA0KPiBJJ20gbm90IHN1cmUg
YWJvdXQgdGhpcy4gQWxsIHRoZSBvdGhlciBSVE1fR0VUeHh4IGFyZSBzdWNoIHRoYXQNCj4gUlRN
X0dFVHh4eCAlIDQgPT0gMi4gRm9sbG93aW5nIHRoZSBjdXJyZW50IHBhdHRlcm4sIDEyNCBzaG91
bGQgYmUNCj4gcmVzZXJ2ZWQgZm9yIFJUTV9ORVd4eHgsIGFuZCBSVE1fR0VURUVDU1RBVEUgd291
bGQgYmUgMTI2Lg0KPiANCj4gQWxzbywgd2h5IGFyZSB5b3UgbGVhdmluZyBhIGdhcCAod2hpY2gg
eW91IGVuZCB1cCBmaWxsaW5nIGluIHBhdGNoDQo+IDQvNik/DQoNCkhtbW0gSSBtaXNzZWQgdGhh
dCAtIGlzIHRoZXJlIGFueSBndWlkZSBob3cgdG8gbnVtYmVyIHRoZW0/DQpJJ2QgYmUgaGFwcHkg
dG8gZm9sbG93IHRoZSBwYXR0ZXJuIHRoZXJlIC0gd2lsbCBmaXggaW4gbmV4dCByZXZpc2lvbi4N
Cg0KVGhlIGdhcCBpcyB0aGVyZSBhcyB0aGlzIHdhcyBkZXZlbG9wZWQgZmlyc3QgLSBidXQgbW9z
dCBsaWtlbHkgdGhpcyBwYXJ0DQpXaWxsIGJlIHJlbW92ZWQgaW4gbmV4dCByZXZpc2lvbiBpbiBm
YXZvciBvZiBEUExMIHN1YnN5c3RlbS4NCg0KPiA+ICsNCj4gPiAgCV9fUlRNX01BWCwNCj4gPiAg
I2RlZmluZSBSVE1fTUFYCQkoKChfX1JUTV9NQVggKyAzKSAmIH4zKSAtIDEpDQo+ID4gIH07DQo+
ID4gZGlmZiAtLWdpdCBhL25ldC9jb3JlL3J0bmV0bGluay5jIGIvbmV0L2NvcmUvcnRuZXRsaW5r
LmMNCj4gPiBpbmRleCAyYWY4YWVlYWRhZGYuLjAzYmM3NzNkMGU2OSAxMDA2NDQNCj4gPiAtLS0g
YS9uZXQvY29yZS9ydG5ldGxpbmsuYw0KPiA+ICsrKyBiL25ldC9jb3JlL3J0bmV0bGluay5jDQo+
ID4gQEAgLTU0NjcsNiArNTQ2Nyw4MyBAQCBzdGF0aWMgaW50IHJ0bmxfc3RhdHNfZHVtcChzdHJ1
Y3Qgc2tfYnVmZiAqc2tiLA0KPiBzdHJ1Y3QgbmV0bGlua19jYWxsYmFjayAqY2IpDQo+ID4gIAly
ZXR1cm4gc2tiLT5sZW47DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgaW50IHJ0bmxfZmlsbF9l
ZWNfc3RhdGUoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCj4g
PiArCQkJICAgICAgIHUzMiBwb3J0aWQsIHUzMiBzZXEsIHN0cnVjdCBuZXRsaW5rX2NhbGxiYWNr
ICpjYiwNCj4gPiArCQkJICAgICAgIGludCBmbGFncywgc3RydWN0IG5ldGxpbmtfZXh0X2FjayAq
ZXh0YWNrKQ0KPiA+ICt7DQo+IFsuLi5dDQo+ID4gKwlubGggPSBubG1zZ19wdXQoc2tiLCBwb3J0
aWQsIHNlcSwgUlRNX0dFVEVFQ1NUQVRFLA0KPiBzaXplb2YoKnN0YXRlX21zZyksDQo+ID4gKwkJ
CWZsYWdzKTsNCj4gPiArCWlmICghbmxoKQ0KPiA+ICsJCXJldHVybiAtRU1TR1NJWkU7DQo+ID4g
Kw0KPiA+ICsJc3RhdGVfbXNnID0gbmxtc2dfZGF0YShubGgpOw0KPiA+ICsJc3RhdGVfbXNnLT5p
ZmluZGV4ID0gZGV2LT5pZmluZGV4Ow0KPiANCj4gV2h5IHN0dWZmIHRoaXMgaW4gYSBzdHJ1Y3Qg
aW5zdGVhZCBvZiB1c2luZyBhbiBhdHRyaWJ1dGU/DQoNClNpbmNlIGl0J3MgdGhlIHJlcXVpcmVk
IHBhcmFtZXRlciB0byBpZGVudGlmeSB3aGF0IHBvcnQgaXMgaW4gcXVlc3Rpb24uDQogDQo+ID4g
Kw0KPiA+ICsJaWYgKG5sYV9wdXRfdTMyKHNrYiwgSUZMQV9FRUNfU1RBVEUsIHN0YXRlKSkNCj4g
PiArCQlyZXR1cm4gLUVNU0dTSVpFOw0KPiA+ICsNCj4gPiArCWlmICghb3BzLT5uZG9fZ2V0X2Vl
Y19zcmMpDQo+ID4gKwkJZ290byBlbmRfbXNnOw0KPiA+ICsNCj4gPiArCWVyciA9IG9wcy0+bmRv
X2dldF9lZWNfc3JjKGRldiwgJnNyY19pZHgsIGV4dGFjayk7DQo+ID4gKwlpZiAoZXJyKQ0KPiA+
ICsJCXJldHVybiBlcnI7DQo+ID4gKw0KPiA+ICsJaWYgKG5sYV9wdXRfdTMyKHNrYiwgSUZMQV9F
RUNfU1JDX0lEWCwgc3JjX2lkeCkpDQo+ID4gKwkJcmV0dXJuIC1FTVNHU0laRTsNCj4gPiArDQo+
ID4gK2VuZF9tc2c6DQo+ID4gKwlubG1zZ19lbmQoc2tiLCBubGgpOw0KPiA+ICsJcmV0dXJuIDA7
DQo+ID4gK30NCj4gPiArDQo+IA0KPiBUaGFua3MsDQo+IA0KPiAtLQ0KPiBTYWJyaW5hDQoNCg==
