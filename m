Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DBF699663
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 14:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjBPNxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 08:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBPNxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 08:53:38 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCC73B21C;
        Thu, 16 Feb 2023 05:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676555616; x=1708091616;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KOZV13x6YZKiZrSiNw2vSdBeEbA6Xi7NOi9ncUoTFcM=;
  b=NBhEZVw6BZ+Ea7Ql9Zy3SFbIJIoreuZVqt1H9jmOJaeMaSZahM+KWBnN
   1wn/ArRbXuhPrcG/uz0iVMbmtFFh7KUv7+wX02srDQm4dnHt1AoIedVKQ
   Ap3jHez5vt40kZIapO0HwlYvBMYAC9bfnLELYcsbXAVz1Lb1f6p+q2Vti
   +wHc2U0Cs7U4XkbiuzKXq9TjTZ+i8NBxdcydQA7RHuJG0Y+JyQG4ZdT8i
   34UXYsuejxmbL0DR84qBJHrZ7i8Rw06TcITh8v8rPUlzDtE5eyG+GTGNP
   hqYkzu7DsEWh4eR4wMNYGk+jYlY1NIqYdkRy89hxKlgrvKlOYI4I9MO6I
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="319784167"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="319784167"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 05:53:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="999037288"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="999037288"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 16 Feb 2023 05:53:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 05:53:35 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 05:53:35 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 05:53:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXBiMxoMCpy/DNpZDIu5u1o/eWAMxd2ac03Hi2JF6KETQLhZL9q4zI6XUe8UwKUSZAspVGkn/VJFvsr+9m7Ctbfd7JEQd+CEH0TxbJPbvrKTa6wh0CT6GktAYIl5ZJw06pB3Kz4p8OqDK5nWCbCdReMNTzhgflZe4QrwXGEo+X9XDHCWZLKGMLINiFP9fa/ULNZ2SfxFh+jDd8jZR7KyU4eNewaa5pA/7g92TrC7TZ+YMq7Ixdi8SufGK+WtM6YLsrNGFvsPiYtTBy6bhqWPDLwat6kU7o1vhAXCx9M+tM7UaDpZphUgMQGUYe4xTrwYbZd1fa3bx6mk4F1oreV/Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KOZV13x6YZKiZrSiNw2vSdBeEbA6Xi7NOi9ncUoTFcM=;
 b=aQTai7igMaSEuL6ROt5qctgVleA1MLxm5ETN5m0yj6U2lYAF2Iu1V+M40PC9yRKZyVziTtCQhajRlhWWystotmw4SBRj54LBR7zUUJQCN3AoZiizFzl5Uq9az27Bb6b/VAis/y70NynZrGb6UhDrARZ9CCbFNXFPWw7QkjvSurAEUom63KSgsTA2UQP7IqqJwbKh49KJxgyyxInz9RmP1ejcTTgBcB5H8bilqNbgF4j2heY6uRhp4AP6yjo1wumDJ2DaUq/49RHjhSP2seNMhF2Hdj7uapXOsk7KihPpnP/h95W3f6wt0hNULKnG3TWvKD3eyMLvZ3SMOa/dYBSTFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY4PR1101MB2360.namprd11.prod.outlook.com (2603:10b6:903:b9::9)
 by PH7PR11MB5863.namprd11.prod.outlook.com (2603:10b6:510:135::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Thu, 16 Feb
 2023 13:53:33 +0000
Received: from CY4PR1101MB2360.namprd11.prod.outlook.com
 ([fe80::ca4b:b3ce:b8a0:f0da]) by CY4PR1101MB2360.namprd11.prod.outlook.com
 ([fe80::ca4b:b3ce:b8a0:f0da%11]) with mapi id 15.20.6111.013; Thu, 16 Feb
 2023 13:53:33 +0000
From:   "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-next v4 4/8] i40e: Change size to
 truesize when using i40e_rx_buffer_flip()
Thread-Topic: [Intel-wired-lan] [PATCH intel-next v4 4/8] i40e: Change size to
 truesize when using i40e_rx_buffer_flip()
Thread-Index: AQHZQT0iuVE53y3z7063LHYW0nHR7K7RM/EAgAAJMzA=
Date:   Thu, 16 Feb 2023 13:53:33 +0000
Message-ID: <CY4PR1101MB236079E9F38995D113CBF3D790A09@CY4PR1101MB2360.namprd11.prod.outlook.com>
References: <20230215124305.76075-1-tirthendu.sarkar@intel.com>
 <20230215124305.76075-5-tirthendu.sarkar@intel.com>
 <10c0dcb4-f353-41a8-dfff-e99d2dca7fb2@molgen.mpg.de>
In-Reply-To: <10c0dcb4-f353-41a8-dfff-e99d2dca7fb2@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY4PR1101MB2360:EE_|PH7PR11MB5863:EE_
x-ms-office365-filtering-correlation-id: 2692a10c-85b9-4144-fe68-08db10253178
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mz508N2iey8L7C8h6MP+ac9AVbuTNKux06yWb0wfSVPiepx1tHsxDI5r1qnpl6chR9/sRuN2L5GbUYAEcMJc8V90NuLQO7chllUMALWU2HfrC9ArPjn7EW3h2i3SIMBk3DcMpO0uerloL/S60pgagiUoYD0NCKCrm5EIMYvnO9OhMWncaw9YqBe+fWNyAjjP7agjYUNQBERcN0orD17FJG8c+FhG9b4/xnRCOK9418II8sP3AcYOy3Zl8SX+vubGAQeGrh9kBk0zEztep6YKKHx/3S8ZfrbvOM/2yOzjZ5hrhSiq0RNDanzh2nx14SAhRdK4ZOepo2ewtjYbzA5Wo/lU9tmONxsZZTXOjtQZwMcl22e1fckaG/ox43i0k1FeGuqyVPKbw/Xhc2PoeJSMtJg2SfFuHNftJwp+9X+RU6H18pEINRsOej8p+LaT1roKTCUhp5QubUpuJrZgvS1kolCzdU4AyN137DNBJh34K2mW0K8GDQiJW2ysuo2qHuLSyuDqApt8Y3wWw2f7a7cMEC8rsDXL9bclX+YTR9STL+lQlcfAar2meCfY0L1fcH+cSxHoXs4MtohT9pQMOmcsY+J+rgOw1HT39MZOc5kYqyzeBwq3NSFJLaKK9+p8ADYv69EYt54xxK6ZwAcDK88xUeH3WIU2y0ICdDbwHd0z78/dzb4MOMIjkXoTQI0WMkUx7wmA679Q9X578XsHBr7uAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2360.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199018)(2906002)(66476007)(478600001)(41300700001)(6916009)(83380400001)(66446008)(64756008)(5660300002)(52536014)(66556008)(54906003)(8936002)(4326008)(8676002)(107886003)(186003)(66946007)(6506007)(76116006)(38070700005)(55016003)(71200400001)(9686003)(316002)(26005)(82960400001)(122000001)(7696005)(38100700002)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUp3dXJSOFRLU2FLQUFjZzNnSDdxeHBjUTV0bjd2em1lWTl2cWx1elRaZk1i?=
 =?utf-8?B?aThHSCtTTFZXV2ZwOTVpUmVlRE5ldEJKNFhWQ01BK2lTTU5waU0yT2wyNk53?=
 =?utf-8?B?NzFqbXFzVWc2UmkrV3k2NWhLYVBybkRDQ3hnUWZHYzA3am4rZERicVE0N05h?=
 =?utf-8?B?a2JvR0hzNWRUd0JTbDY5b0tFL0h4VmUyUnRVT3BSU0NTTklkYlJiZ2VuR3hX?=
 =?utf-8?B?ZEJtMGpHWkIzMk1oU3lpU0t0RFBHM2IvU1N6Y0d6eStLdENrZjl1RG4rV0V1?=
 =?utf-8?B?bWpjdW1jcmUyV0NTQWFwMmxya0NXc1c5WVZMR0tZN0kyZHJScUJydzVRWGpF?=
 =?utf-8?B?RFIxWVhucDBLRFVacjFuLzdsM01WcUFIeG80VnFWT2s5VjlCMC9kRnNLUXY1?=
 =?utf-8?B?dzJ4V015QnYvSC9OK2RxTVRGTXltazQvbVdkT0hmWVpDaUVRN3VYNnVlTk5I?=
 =?utf-8?B?Vm52aTRWdGREcEx0d3IvYStJVzFidTJPY2dRNTJaWC9hZldzdXlaQ01iZVRI?=
 =?utf-8?B?bGRkRU9VdExYOVFwMXBBNXRLcHU3WWFhS3oyNjlSOVhVR3Uwcy9YWnUxTzJM?=
 =?utf-8?B?d0g1RUptY05QNldmcmRwOUhQNTV4Z2xYZlRpWEdhT21KRWtodG11ditEak1h?=
 =?utf-8?B?Q2pleVVVZ2lSZHNvd1VhQU9Edkl3cVBNZHNoMnVvdVlvLzRNSFpYeXNPWWpv?=
 =?utf-8?B?VTBDYVlzWTFkZ1hISVdXWGtoUjVKckNQZVFjcmF6YmVDczdJczRkQ3BaR2tV?=
 =?utf-8?B?V0h4OGNpQnY2dll4eVMwNWxQVjdWVnhFaFpaMmRhZmtBUkltSUQyeU4rNTlU?=
 =?utf-8?B?NGwrTlRua0ZPV0VHVzE2WW5tNm51SU5RUHV1V25qbWwwRHU1RXo2K3pLQzRk?=
 =?utf-8?B?c1ZlRk1TNWlIektPdVByUFpmd1g1WFpYNktVRjR6YytoOFJKWW02UFM1REZn?=
 =?utf-8?B?QUJTQmx5R242dWJpc2RnY1RMQld2VmdFdlN2THFwMTlYU0g2b2kxbmdLeFNQ?=
 =?utf-8?B?cUlNa2txckIyTnl4a2prZFdORWlmZlJZZTRIMlV4RXA1dVpBMHU0VHgzWWMr?=
 =?utf-8?B?R0FpZDdaV3ZocXN2OVNJOTVZUVFXd3FWRDM2VXRWaWxkSVdxQlVtQUdHSHVX?=
 =?utf-8?B?dmNNVjNpTjY2aWlhUHFqcnRtQktMTnNtbUQvbWhzL1JjZHludmVuLzdPQ0l6?=
 =?utf-8?B?blJydmRza3p3TXRmdmJOdHEvcXJVOWlMTm1oTGMyaGxrNFpoMU0xNm5vVDVL?=
 =?utf-8?B?R2tMOWpidm9KbVU1dEV3WFhCM25SaFljVGh5cHFnRFlHUEZmc2VzZHdBSENa?=
 =?utf-8?B?a0JQejFrM2tZdXZKUk5Bc1hGcjEyS245bFh2bkF3RVIxZ1dBbHRhQnNhMHRZ?=
 =?utf-8?B?NURXTkkrc0JTNjZRZEZVWkRMSXFtdWFWWEFvNFJoWXNnb0NNNmRrTnRjS0tw?=
 =?utf-8?B?Rlp3TFdlRFZnWlFUTGRMRVZkK3loa0ZhZzM5Ung1SGp3N0E4NzBWN0IvL1dt?=
 =?utf-8?B?bUVWQU9XWFZ4OTE0eWpZTm82QlU2Zm8zUWx2TVhzR1QyODcxWGFxNjVGTCtQ?=
 =?utf-8?B?M0J1Q3BSdU8ydHJzQU1wTTQ3Sy9ubGxmeVlmRFhCWmE4ZWc3YTlWQU1HNG9m?=
 =?utf-8?B?cXlPdkNZWUpaYVhhRXRTSFg3MExvVWlZUlREL2ZzSUhTQ0ovb3krcHBwMitM?=
 =?utf-8?B?Z3ZWK2txRHc0WFZlUWpWa0RaSDhlS29UVGhRTWR5djVtc3BTaENNUURWQ0tH?=
 =?utf-8?B?WVBSZUhEdHEvejFIODBBbzJLaTdHOEVwdFhTU0N3Z25DMjNCclJYQk92aEIz?=
 =?utf-8?B?THZWZnl5NVNkTzBTYkpSZTRQRytFVnBuUFN3N1R2MFhhZ0VLVzVtVTZibW5q?=
 =?utf-8?B?UURqdThRdVNsZlNPRlpKek94SkFXY1BnMU9TNHpDS2hlRHlJQVVsVVlXMDBC?=
 =?utf-8?B?d3J3ZXVpdkRla00xTU44Z3VKdlE1TjQ0dTFnQmVQWUlCWmVWUEhPSTRuSktr?=
 =?utf-8?B?R1FSRC9aMzY4MU1WZVBDLzdYcEt4M3FhdXNyNm4zZjdJaE5IanJKQWFZSG51?=
 =?utf-8?B?Qng0NTJqcndrMHZ2Z0UyVmNjZXpHZkJobUU0U2hDMzBtNURwa05HcmxIZmxU?=
 =?utf-8?B?MkJ3VWhwbHRZeVFRMFpCeWJrUWdIRmNoOHRxVFREZXhCVFNYZ1NTSnBvdHJx?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2360.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2692a10c-85b9-4144-fe68-08db10253178
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 13:53:33.2279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Odvsq7VT/Elt1FM7gC3yYF9vDpwbLbjxsh1JIakciAp9GG3hMLiINiuUwFeK007TSlbLAJN4HMJ8ikzmQ1EFDBz8mjVdbfFUMQy32Es4myc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5863
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYXVsIE1lbnplbCA8cG1lbnpl
bEBtb2xnZW4ubXBnLmRlPg0KPiBTdWJqZWN0OiBSZTogW0ludGVsLXdpcmVkLWxhbl0gW1BBVENI
IGludGVsLW5leHQgdjQgNC84XSBpNDBlOiBDaGFuZ2Ugc2l6ZSB0bw0KPiB0cnVlc2l6ZSB3aGVu
IHVzaW5nIGk0MGVfcnhfYnVmZmVyX2ZsaXAoKQ0KPiBJbXBvcnRhbmNlOiBMb3cNCj4gDQo+IERl
YXIgVGlydGhlbmR1LA0KPiANCj4gDQo+IFRoYW5rIHlvdSBmb3IgeW91ciBwYXRjaC4NCj4gDQo+
IEFtIDE1LjAyLjIzIHVtIDEzOjQzIHNjaHJpZWIgVGlydGhlbmR1IFNhcmthcjoNCj4gPiBUcnVl
c2l6ZSBpcyBub3cgcGFzc2VkIGRpcmVjdGx5IHRvIGk0MGVfcnhfYnVmZmVyX2ZsaXAoKSBpbnN0
ZWFkIG9mIHNpemUNCj4gPiBzbyB0aGF0IGl0IGRvZXMgbm90IG5lZWQgdG8gcmVjYWxjdWxhdGUg
dHJ1ZXNpemUgZnJvbSBzaXplIHVzaW5nDQo+ID4gaTQwZV9yeF9mcmFtZV90cnVlc2l6ZSgpIGJl
Zm9yZSBhZGp1c3RpbmcgcGFnZSBvZmZzZXQuDQo+IA0KPiBEaWQgdGhlIGNvbXBpbGVyIG5vdCBv
cHRpbWl6ZSB0aGF0IHdlbGwgZW5vdWdoPw0KPiANCg0KRm9yIGZsaXBwaW5nIHRoZSBidWZmZXIs
IGRhdGEncyAndHJ1ZXNpemUnIGlzIG5lZWRlZC4gU28gaTQwZV9yeF9idWZmZXJfZmxpcCgpIG5l
ZWRlZCAgdG8gY2FsbCANCmk0MGVfcnhfZnJhbWVfdHJ1ZXNpemUoKSB0byBnZXQgdGhlICd0cnVl
c2l6ZScgc2luY2Ugb25seSAnc2l6ZScgd2FzIHBhc3NlZCB0byBpdC4gV2l0aCB0aGlzIA0KcGF0
Y2ggdGhlIGNhbGxlciBwcm92aWRlcyAndHJ1ZXNpemUnIGl0c2VsZiB0byBpNDBlX3J4X2J1ZmZl
cl9mbGlwKCkuDQoNCj4gPiBXaXRoIHRoZXNlIGNoYW5nZSB0aGUgZnVuY3Rpb24gY2FuIG5vdyBi
ZSB1c2VkIGR1cmluZyBza2IgYnVpbGRpbmcgYW5kDQo+ID4gYWRkaW5nIGZyYWdzLiBJbiBsYXRl
ciBwYXRjaGVzIGl0IHdpbGwgYWxzbyBiZSBlYXNpZXIgZm9yIGFkanVzdGluZw0KPiA+IHBhZ2Ug
b2Zmc2V0cyBmb3IgbXVsdGktYnVmZmVycy4NCj4gDQo+IFdoeSBjb3VsZG7igJl0IHRoZSBmdW5j
dGlvbiBiZSB1c2VkIGJlZm9yZT8NCj4gDQoNCmk0MGVfcnhfZnJhbWVfdHJ1c2l6ZSgpIGRvZXMg
bm90IGNvdmVyIGFsbCBjYXNlcyBmb3IgdHJ1ZXNpemUgY2FsY3VsYXRpb24gLCBmb3IgZS5nLiwg
Zm9yIGZyYWdzDQppbiBub24tbGVnYWN5LXJ4IG1vZGUuIFNpbmNlIGk0MGVfcnhfYnVmZmVyX2Zs
aXAoKSB3YXMgZGVwZW5kaW5nIG9uIGk0MGVfcnhfZnJhbWVfdHJ1c2l6ZSgpIA0KZm9yIHRydWVz
aXplLCBpdCBjb3VsZCBub3QgYmUgdXNlZCBmb3IgYWRkaW5nIGZyYWdzLg0KDQo+ID4gU2lnbmVk
LW9mZi1ieTogVGlydGhlbmR1IFNhcmthciA8dGlydGhlbmR1LnNhcmthckBpbnRlbC5jb20+DQo+
ID4gLS0tDQo+ID4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfdHhyeC5j
IHwgNTQgKysrKysrKystLS0tLS0tLS0tLS0tDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgMTkgaW5z
ZXJ0aW9ucygrKSwgMzUgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3R4cnguYw0KPiBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2ludGVsL2k0MGUvaTQwZV90eHJ4LmMNCj4gPiBpbmRleCBhN2ZiYTI5NGE4ZjQuLjAx
OWFiZDcyNzNhMiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9p
NDBlL2k0MGVfdHhyeC5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQw
ZS9pNDBlX3R4cnguYw0KPiA+IEBAIC0yMDE4LDYgKzIwMTgsMjEgQEAgc3RhdGljIGJvb2wgaTQw
ZV9jYW5fcmV1c2VfcnhfcGFnZShzdHJ1Y3QNCj4gaTQwZV9yeF9idWZmZXIgKnJ4X2J1ZmZlciwN
Cj4gPiAgIAlyZXR1cm4gdHJ1ZTsNCj4gPiAgIH0NCj4gPg0KPiA+ICsvKioNCj4gPiArICogaTQw
ZV9yeF9idWZmZXJfZmxpcCAtIGFkanVzdGVkIHJ4X2J1ZmZlciB0byBwb2ludCB0byBhbiB1bnVz
ZWQgcmVnaW9uDQo+ID4gKyAqIEByeF9idWZmZXI6IFJ4IGJ1ZmZlciB0byBhZGp1c3QNCj4gPiAr
ICogQHNpemU6IFNpemUgb2YgYWRqdXN0bWVudA0KPiA+ICsgKiovDQo+ID4gK3N0YXRpYyB2b2lk
IGk0MGVfcnhfYnVmZmVyX2ZsaXAoc3RydWN0IGk0MGVfcnhfYnVmZmVyICpyeF9idWZmZXIsDQo+
ID4gKwkJCQl1bnNpZ25lZCBpbnQgdHJ1ZXNpemUpDQo+ID4gK3sNCj4gPiArI2lmIChQQUdFX1NJ
WkUgPCA4MTkyKQ0KPiA+ICsJcnhfYnVmZmVyLT5wYWdlX29mZnNldCBePSB0cnVlc2l6ZTsNCj4g
PiArI2Vsc2UNCj4gPiArCXJ4X2J1ZmZlci0+cGFnZV9vZmZzZXQgKz0gdHJ1ZXNpemU7DQo+ID4g
KyNlbmRpZg0KPiANCj4gSXTigJlkIGJlIGdyZWF0IGlmIHlvdSBzZW50IGEgcGF0Y2ggb24gdG9w
LCBkb2luZyB0aGUgY2hlY2sgbm90IGluIHRoZQ0KPiBwcmVwcm9jZXNzb3IgYnV0IGluIG5hdGl2
ZSBDIGNvZGUuDQo+IA0KDQpXZSBkb27igJl0IHdhbnQgdG8gaW50cm9kdWNlIGJyYW5jaGVzLiBB
bHNvLCBub3RlIHRoaXMgcGFydCBvZiB0aGUgY29kZSBpcyBub3QNCm5ld2x5IGludHJvZHVjZWQg
aW4gdGhpcyBwYXRjaHNldC4NCg0KPiA+ICt9DQo+ID4gKw0KPiA+ICAgLyoqDQo+ID4gICAgKiBp
NDBlX2FkZF9yeF9mcmFnIC0gQWRkIGNvbnRlbnRzIG9mIFJ4IGJ1ZmZlciB0byBza19idWZmDQo+
ID4gICAgKiBAcnhfcmluZzogcnggZGVzY3JpcHRvciByaW5nIHRvIHRyYW5zYWN0IHBhY2tldHMg
b24NCj4gPiBAQCAtMjA0NSwxMSArMjA2MCw3IEBAIHN0YXRpYyB2b2lkIGk0MGVfYWRkX3J4X2Zy
YWcoc3RydWN0IGk0MGVfcmluZw0KPiAqcnhfcmluZywNCj4gPiAgIAkJCXJ4X2J1ZmZlci0+cGFn
ZV9vZmZzZXQsIHNpemUsIHRydWVzaXplKTsNCj4gPg0KPiA+ICAgCS8qIHBhZ2UgaXMgYmVpbmcg
dXNlZCBzbyB3ZSBtdXN0IHVwZGF0ZSB0aGUgcGFnZSBvZmZzZXQgKi8NCj4gPiAtI2lmIChQQUdF
X1NJWkUgPCA4MTkyKQ0KPiA+IC0JcnhfYnVmZmVyLT5wYWdlX29mZnNldCBePSB0cnVlc2l6ZTsN
Cj4gPiAtI2Vsc2UNCj4gPiAtCXJ4X2J1ZmZlci0+cGFnZV9vZmZzZXQgKz0gdHJ1ZXNpemU7DQo+
ID4gLSNlbmRpZg0KPiA+ICsJaTQwZV9yeF9idWZmZXJfZmxpcChyeF9idWZmZXIsIHRydWVzaXpl
KTsNCj4gPiAgIH0NCj4gPg0KPiA+ICAgLyoqDQo+ID4gQEAgLTIxNTQsMTEgKzIxNjUsNyBAQCBz
dGF0aWMgc3RydWN0IHNrX2J1ZmYgKmk0MGVfY29uc3RydWN0X3NrYihzdHJ1Y3QNCj4gaTQwZV9y
aW5nICpyeF9yaW5nLA0KPiA+ICAgCQkJCXNpemUsIHRydWVzaXplKTsNCj4gPg0KPiA+ICAgCQkv
KiBidWZmZXIgaXMgdXNlZCBieSBza2IsIHVwZGF0ZSBwYWdlX29mZnNldCAqLw0KPiA+IC0jaWYg
KFBBR0VfU0laRSA8IDgxOTIpDQo+ID4gLQkJcnhfYnVmZmVyLT5wYWdlX29mZnNldCBePSB0cnVl
c2l6ZTsNCj4gPiAtI2Vsc2UNCj4gPiAtCQlyeF9idWZmZXItPnBhZ2Vfb2Zmc2V0ICs9IHRydWVz
aXplOw0KPiA+IC0jZW5kaWYNCj4gPiArCQlpNDBlX3J4X2J1ZmZlcl9mbGlwKHJ4X2J1ZmZlciwg
dHJ1ZXNpemUpOw0KPiA+ICAgCX0gZWxzZSB7DQo+ID4gICAJCS8qIGJ1ZmZlciBpcyB1bnVzZWQs
IHJlc2V0IGJpYXMgYmFjayB0byByeF9idWZmZXIgKi8NCj4gPiAgIAkJcnhfYnVmZmVyLT5wYWdl
Y250X2JpYXMrKzsNCj4gPiBAQCAtMjIwOSwxMSArMjIxNiw3IEBAIHN0YXRpYyBzdHJ1Y3Qgc2tf
YnVmZiAqaTQwZV9idWlsZF9za2Ioc3RydWN0DQo+IGk0MGVfcmluZyAqcnhfcmluZywNCj4gPiAg
IAkJc2tiX21ldGFkYXRhX3NldChza2IsIG1ldGFzaXplKTsNCj4gPg0KPiA+ICAgCS8qIGJ1ZmZl
ciBpcyB1c2VkIGJ5IHNrYiwgdXBkYXRlIHBhZ2Vfb2Zmc2V0ICovDQo+ID4gLSNpZiAoUEFHRV9T
SVpFIDwgODE5MikNCj4gPiAtCXJ4X2J1ZmZlci0+cGFnZV9vZmZzZXQgXj0gdHJ1ZXNpemU7DQo+
ID4gLSNlbHNlDQo+ID4gLQlyeF9idWZmZXItPnBhZ2Vfb2Zmc2V0ICs9IHRydWVzaXplOw0KPiA+
IC0jZW5kaWYNCj4gPiArCWk0MGVfcnhfYnVmZmVyX2ZsaXAocnhfYnVmZmVyLCB0cnVlc2l6ZSk7
DQo+ID4NCj4gPiAgIAlyZXR1cm4gc2tiOw0KPiA+ICAgfQ0KPiA+IEBAIC0yMzI2LDI1ICsyMzI5
LDYgQEAgc3RhdGljIGludCBpNDBlX3J1bl94ZHAoc3RydWN0IGk0MGVfcmluZyAqcnhfcmluZywN
Cj4gc3RydWN0IHhkcF9idWZmICp4ZHAsIHN0cnVjdA0KPiA+ICAgCXJldHVybiByZXN1bHQ7DQo+
ID4gICB9DQo+ID4NCj4gPiAtLyoqDQo+ID4gLSAqIGk0MGVfcnhfYnVmZmVyX2ZsaXAgLSBhZGp1
c3RlZCByeF9idWZmZXIgdG8gcG9pbnQgdG8gYW4gdW51c2VkIHJlZ2lvbg0KPiA+IC0gKiBAcnhf
cmluZzogUnggcmluZw0KPiA+IC0gKiBAcnhfYnVmZmVyOiBSeCBidWZmZXIgdG8gYWRqdXN0DQo+
ID4gLSAqIEBzaXplOiBTaXplIG9mIGFkanVzdG1lbnQNCj4gPiAtICoqLw0KPiA+IC1zdGF0aWMg
dm9pZCBpNDBlX3J4X2J1ZmZlcl9mbGlwKHN0cnVjdCBpNDBlX3JpbmcgKnJ4X3JpbmcsDQo+ID4g
LQkJCQlzdHJ1Y3QgaTQwZV9yeF9idWZmZXIgKnJ4X2J1ZmZlciwNCj4gPiAtCQkJCXVuc2lnbmVk
IGludCBzaXplKQ0KPiA+IC17DQo+ID4gLQl1bnNpZ25lZCBpbnQgdHJ1ZXNpemUgPSBpNDBlX3J4
X2ZyYW1lX3RydWVzaXplKHJ4X3JpbmcsIHNpemUpOw0KPiA+IC0NCj4gPiAtI2lmIChQQUdFX1NJ
WkUgPCA4MTkyKQ0KPiA+IC0JcnhfYnVmZmVyLT5wYWdlX29mZnNldCBePSB0cnVlc2l6ZTsNCj4g
PiAtI2Vsc2UNCj4gPiAtCXJ4X2J1ZmZlci0+cGFnZV9vZmZzZXQgKz0gdHJ1ZXNpemU7DQo+ID4g
LSNlbmRpZg0KPiA+IC19DQo+ID4gLQ0KPiA+ICAgLyoqDQo+ID4gICAgKiBpNDBlX3hkcF9yaW5n
X3VwZGF0ZV90YWlsIC0gVXBkYXRlcyB0aGUgWERQIFR4IHJpbmcgdGFpbCByZWdpc3Rlcg0KPiA+
ICAgICogQHhkcF9yaW5nOiBYRFAgVHggcmluZw0KPiA+IEBAIC0yNTEzLDcgKzI0OTcsNyBAQCBz
dGF0aWMgaW50IGk0MGVfY2xlYW5fcnhfaXJxKHN0cnVjdCBpNDBlX3JpbmcNCj4gKnJ4X3Jpbmcs
IGludCBidWRnZXQsDQo+ID4gICAJCWlmICh4ZHBfcmVzKSB7DQo+ID4gICAJCQlpZiAoeGRwX3Jl
cyAmIChJNDBFX1hEUF9UWCB8IEk0MEVfWERQX1JFRElSKSkgew0KPiA+ICAgCQkJCXhkcF94bWl0
IHw9IHhkcF9yZXM7DQo+ID4gLQkJCQlpNDBlX3J4X2J1ZmZlcl9mbGlwKHJ4X3JpbmcsIHJ4X2J1
ZmZlciwgc2l6ZSk7DQo+ID4gKwkJCQlpNDBlX3J4X2J1ZmZlcl9mbGlwKHJ4X2J1ZmZlciwNCj4g
eGRwLmZyYW1lX3N6KTsNCj4gDQo+IFdoeSBpcyBgeGRwLmZyYW1lX3N6YCB0aGUgY29ycmVjdCBz
aXplIG5vdz8NCj4gDQoNCkFzIGV4cGxhaW5lZCBiZWZvcmUsIGVhcmxpZXIgaTQwZV9yeF9idWZm
ZXJfZmxpcCgpIHdhcyBjYWxjdWxhdGluZyAndHJ1ZXNpemUnDQppbnRlcm5hbGx5IGJ1dCBub3cg
ZGVwZW5kcyBvbiB0aGUgY2FsbGVyIGZvciBpdCB0byBiZSBwcm92aWRlZC4gJ3hkcC5mcmFtZV9z
eicNCmFjdHVhbGx5IGlzIHRoZSB0cnVlc2l6ZSBvZiB0aGUgYnVmZmVyLg0KDQo+ID4gICAJCQl9
IGVsc2Ugew0KPiA+ICAgCQkJCXJ4X2J1ZmZlci0+cGFnZWNudF9iaWFzKys7DQo+ID4gICAJCQl9
DQo+IA0KPiANCj4gS2luZCByZWdhcmRzLA0KPiANCj4gUGF1bA0KDQpUaGFua3MuDQo=
