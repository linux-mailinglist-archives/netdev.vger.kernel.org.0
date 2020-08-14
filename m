Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2317244F97
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 23:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgHNVjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 17:39:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:30560 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgHNVjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 17:39:19 -0400
IronPort-SDR: qTNn6aToTbaMcf0+EWzMbUgchHOrTO9IIOFJdKy181M+Mq/6ex8MjolGPlwPeOnWMEGAkg7mNe
 K3PAB4ojMT9w==
X-IronPort-AV: E=McAfee;i="6000,8403,9713"; a="155591355"
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="155591355"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 14:39:17 -0700
IronPort-SDR: 3Anm6s5mEyAv+c9xYKnRofwDa+UhbGMhckHR7aWgEELajxSj0Ce6WicvLYYQVFueukahPotZ/b
 6R+kOtTX+VBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="328019006"
Received: from unknown (HELO fmsmsx606.amr.corp.intel.com) ([10.18.84.216])
  by fmsmga002.fm.intel.com with ESMTP; 14 Aug 2020 14:39:17 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 14 Aug 2020 14:39:15 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 14 Aug 2020 14:39:15 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Fri, 14 Aug 2020 14:39:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSZQN7mM9NOWt+ZSF7Duy/jUPF5zZpe/CP3V8VrdstZgwMJAzg9C0vz0MyDsqY/hO5qvDmHkc550Lr2oNriQxg3MsbydPPjJZXlCBG8zRzZXy1BeZXGzbCOJsseSIIhZl3hmQJ54du3AfEo2uFLrQ18X0eCYdyV/jVID9NZ7BhxfL9bVz/GK5z/cb1cqlCW729GHcKBc+2uQwrw5lG4DJTIMs5Nbw6hL9Ad8bLs98G/ldygeq7LCxOWnAdq7Dz2NyNMRMF4TTn7es1DbdZh04YS4kLSxmwbRj1MAOA7t4huWi0y2LE3qfPJMaEq2gvm11gnWSOEZUMLbGLD2VzFyRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBMohEu4uq6atYXuQ5WHIJQp/JZw9LILo2WfyF+2/2w=;
 b=mkgkPHMtU7og92IWGzMBnAIKBfzXk4d/7eeEIPsOUMZ/AQus6CMxw9BaNUKvlHMuuKJ25l60OLxEAufhlTWAuo5GVs93teP4kiAs456r94e8qH5w69qtPZmTCbJXieXBtLu/Ug2KWmACQfF3x/yl+q7EmhU+gW1oj7lcOdu7totpuh67PFhqN6IwZUtF3bRJd2Cr5Az0xfD5fAD4+gjCmpzO8hsRx5vXitGzU3Rt7K/tdYfB5nxByd5PUgcyTnF9h40/5CNbbNxTKVG8gsMIrNMLnKy0CH5tb86mPe6LK26I9S2UqhZkp8vZALfBOVzhYVOV0hkaenEEyvy/euz5ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBMohEu4uq6atYXuQ5WHIJQp/JZw9LILo2WfyF+2/2w=;
 b=fxITvVTkE3/vC7cAKo2h6ZbLTYNcPaLRwgtni1tDVUcEvEzEhta0v5wZ/5+WTDAK3OvrHOhhLkCW/7PfICk1DJ/Vjyux47dlCmuJSMbbTLo+2v473q4wVgaFlx2r03BHqxp+2LaWAY65G4APmYtj/wRFmiL1kmQnPpvwJkTz96A=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4752.namprd11.prod.outlook.com (2603:10b6:806:99::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.20; Fri, 14 Aug
 2020 21:39:13 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::f8e7:739a:a6ef:ce3b]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::f8e7:739a:a6ef:ce3b%3]) with mapi id 15.20.3283.018; Fri, 14 Aug 2020
 21:39:13 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "Patynowski, PrzemyslawX" <przemyslawx.patynowski@intel.com>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Subject: Re: [net 2/3] i40e: Set RX_ONLY mode for unicast promiscuous on VLAN
Thread-Topic: [net 2/3] i40e: Set RX_ONLY mode for unicast promiscuous on VLAN
Thread-Index: AQHWcnqzypTOvD1uo0yuMdxhnAsmfqk4HDcAgAAFhgA=
Date:   Fri, 14 Aug 2020 21:39:13 +0000
Message-ID: <ca1af30ab7b50a4d1aa078a6400fdb6cf4bb84a8.camel@intel.com>
References: <20200814203643.186034-1-anthony.l.nguyen@intel.com>
         <20200814203643.186034-3-anthony.l.nguyen@intel.com>
         <20200814141926.3a728c78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200814141926.3a728c78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 011ab600-8d3e-4bc0-ccc5-08d8409a7cb1
x-ms-traffictypediagnostic: SA0PR11MB4752:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4752BE73EA86A8CACE97691AC6400@SA0PR11MB4752.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k6u4tWbzsRN3PVWbBWk1Yle8KeYGT5JnWIUcew4uS7aWTJRWAXQTWIna9XKY4vPsq9z96J2uRZSSQEGOjUaYTwNrkICM4lfwHf7y90wSQUaP5De3P8sQc3zM16b1rHeuX2HJlSvcI3boMMq8vB68YIgMcWheP+w72U8Q5ZZ7+8j8FSR6AO3yjfFYL82s+yHW2Jgj6GDkUxB5s33iDUnml5/oVkwL3u9HfP7IziZWrJLuHsczl8SD19NZS98LXEG/CX/aHmpzrgQghEhtt3UttjYwijxMrWCMS2jWTPTIDz7xFh+BLl6R6eE6UeDQJZRCsIZjafOYBZoRkK9x4hM5yw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(6506007)(8936002)(4744005)(6486002)(66946007)(76116006)(91956017)(186003)(83380400001)(2906002)(26005)(6512007)(8676002)(478600001)(5660300002)(36756003)(66556008)(66446008)(64756008)(4326008)(54906003)(71200400001)(86362001)(107886003)(316002)(2616005)(6916009)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: R9W9INsIRBruwNAyFZckKaxyNbnnwjX7wxamWaBEoAGQ76sdD1bNbtk4G0C4yNydaJdj01V0bRmFlxlsb1aiuZz28PYw4Y56NcUPVHO8Dy5iOuOdQ/35aKwfrsGaU/XhE45Ti2eQlNEzMei0HCS5Nq9EvKokUIhqLApe/NIY6mSS3i8JN+eRVWjRjF7smSzDtuVw+3bRYQsKTEHKzFsLB2QZSE52VWxeDnL6uBFjyCv/ggry0W91xOWBYBQP9TZAj8UEhXhwxopz1UydC2fyv/G1rI3llM0Qr9pFTNmQN2QeH5rE6sKGAyPtwGTfw8BZ1lajWf08sETUliX+ICHRs4YEB5LNGuWPmm6iETUphEOs5atBNGbJWjhf4RflPsZO5e07V55Dqg/seft9y2ggtrannCVaH+ZxLNLLuXazFCMSyo4gPCNs7HeJ5U2U0LttakjjcGWC5ohFlZbCKRfhJXmipAQRqtUGfp9moBfr/Ny0vW0aho6jQ/Ja98lL9608bkuY5vpHegRF82XFRNbltcfsx073mjOl+MBmbty2ZuYA3OeGQGVJEbkja2ZvDEiY/nMqgoc5AETONTKkdVsrlNauVbayj7bnnwB+cTAFVwXjlANCHVm4awkP8E3tnEOEPssyaigF9p+JEOcSxcrVvQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9E846A65B94784DAF56AA94FA39CC19@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 011ab600-8d3e-4bc0-ccc5-08d8409a7cb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2020 21:39:13.2944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i2be2lYWZy/FW8oXjU/U2XZXV2Hbf9lj+epbaW7JF3B6OUZTGomC+mhItojDgoaRKtZRtpg15MESTgfbHm71Nc/d6GUFTwYa5AD9J/gtw9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4752
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA4LTE0IGF0IDE0OjE5IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAxNCBBdWcgMjAyMCAxMzozNjo0MiAtMDcwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiArICogQGh3OiBwb2ludGVyIHRvIHRoZSBodyBzdHJ1Y3QNCj4gPiArICogQG1hajogYXBp
IG1ham9yIHZhbHVlDQo+ID4gKyAqIEBtaW46IGFwaSBtaW5vciB2YWx1ZQ0KPiA+ICtzdGF0aWMg
Ym9vbCBpNDBlX2lzX2FxX2FwaV92ZXJfZ2Uoc3RydWN0IGk0MGVfYWRtaW5xX2luZm8gKmFxLCB1
MTYNCj4gPiBtYWosDQo+ID4gKwkJCQkgIHUxNiBtaW4pDQo+IA0KPiBodyB2cyBhcS4gUGxlYXNl
IGJ1aWxkIHRlc3QgdGhlIHBhdGNoZXMgd2l0aCBXPTEuDQoNCldpbGwgZml4IHRoaXMgYW5kIG1h
a2Ugc3VyZSB0byBydW4gVz0xIG9uIGFsbCB0aGUgcGF0Y2hlcy4NCg==
