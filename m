Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F55630AF73
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbhBASdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:33:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:41727 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232875AbhBASdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 13:33:39 -0500
IronPort-SDR: 08mti7TSu2uK5huygIrwTp16q8tr+Ze6IPbBOxAhTFUOkxrUaFHupDuZum7YM7BBJxWa19bc/M
 RBeD5HXKwsgg==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="180875402"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="180875402"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 10:32:56 -0800
IronPort-SDR: Y920E6Lb1jXxJfOMQPblbR202oEJrvXNkomeJ8Jh2lrPityKN1kAD4hyDQ//Sg0248ZuBTetz3
 fEzIlAnvbhgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="577913056"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 01 Feb 2021 10:32:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 1 Feb 2021 10:32:55 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 1 Feb 2021 10:32:55 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 1 Feb 2021 10:32:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caesuzC76JYRspFQ2+joHELUj7QzDDoTRXXhDFe8LHzOSzYjW8ho0uWPMPcp+A9BfDN6MDZOUeA6d0Fslz2nQhFDu2lM1ezsnap2bnYBbdll2lI0IKgx94bFxmCMab+WCXaFDFAahParHUEyI+ZZDkjBp0B+sReWKxmy94RSNYB2ELVftYvf6AZp+rOd2otmPHbNOfDS0WWhtSakGaR+wtHAF/+1Yiuw4ERcJqEJLE5GUzAx51PZ7Ai9NgZW+/g/QEWNgGLJPOCLGYfXJ4ME8tS9cmWJICZymyybipW7huM8Hy90ZbgvqglV2yuJdyLUjBJQdjecu9sL+ZR3RZuHvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHqPgp1Mb/J/aUQUfExlfK8WC9J3c+plpCQ3gRsKXNs=;
 b=XAvoDQctshttNu7ijEfLK1q1uOc/lSNM1U0rZ0UyjL7ySCh5JpAl//FSyDIJiT0CMv+uspEnl6OVKAS+Vy/Rabgr5eiZhAYUCTtUctmoszRpvwXU7zjqNgArUyHVzpaJI7KMoQEvPebLRC2UVccbjjrCY3ESNwBYCOLRJt2iN7fUTzOVX/gQejqZpRj1eU5MX59G0AygLhVO228O0/Kdo6ImOUlCWdmSZuxXmEQEl281iyfnzs3ATiFVMopTjvzNgEvuBIFCUQdTWd8e2Y450gz4UmtubZcpZtLz0+JFuAzn1nzokCOfpCundFNeB+bfrg/aedtb98jZSOcrz5ctSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHqPgp1Mb/J/aUQUfExlfK8WC9J3c+plpCQ3gRsKXNs=;
 b=HtmnJxoqxahTOYH7h02YAgKCLUXl3ZkKTe0JmAhvwgyuEpKBj/XJV93VHCdPIyZamFoLrxY2Y8Ub2EGT5191oJ9NSKfx55+rCftCGtxjgzkn6MV+O/xFP+H7p+gFG0BmNKF3PknkcXhCMg34a33xywf4LHGNiLHret90wM5vu8k=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4653.namprd11.prod.outlook.com (2603:10b6:806:94::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Mon, 1 Feb
 2021 18:32:51 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cccb:4e77:41e3:d02a]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cccb:4e77:41e3:d02a%5]) with mapi id 15.20.3805.027; Mon, 1 Feb 2021
 18:32:51 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "linux-wired-list@bluematt.me" <linux-wired-list@bluematt.me>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "nick.lowe@gmail.com" <nick.lowe@gmail.com>
Subject: Re: [PATCH net] igb: Enable RSS for Intel I211 Ethernet Controller
Thread-Topic: [PATCH net] igb: Enable RSS for Intel I211 Ethernet Controller
Thread-Index: AQHW1+hCNZ6n0zdIZ0qY5Sl1Dp6p3qpCnpeAgAEliICAAB1aAA==
Date:   Mon, 1 Feb 2021 18:32:50 +0000
Message-ID: <a7a89e90bf6c3f383fa236b1128db8d012223da0.camel@intel.com>
References: <20201221222502.1706-1-nick.lowe@gmail.com>
         <379d4ef3-02e5-f08a-1b04-21848e11a365@bluematt.me>
         <20210201084747.2cb64c3f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210201084747.2cb64c3f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83a54043-0022-409b-a30b-08d8c6dfc822
x-ms-traffictypediagnostic: SA0PR11MB4653:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB46531B8FCD589F8CA7FC9245C6B69@SA0PR11MB4653.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EPvZOCZKIR/NHmSPsGkAYR8VUC3bA8bGsOqUSKOHK4n3B5C3E28rLYuu8rt3xK0KryGjUo8WDkQ8wZcifnDnn1xGQ2oDfMGUPym+X4ccDhsQySt4Ui74Eexeihc+kmSa79qBAv8lD48SG0tD1cxO9x3s/hwjqtsWHoYQG2p7460w5r4xpLTyKGI53hvdliD6Xy2SSMO20RtYjIm7FkGjDlzVMIqJpTDiiQ9LIFLKu8Kg+cVcz3uxhBcxEsd181zbSJr57yglFJpRtl2RUlRUXSRi+4OEGNF698Wa3vJEswUiRkabiym+a9VeM17rSkNTb8R/pNNUtgMhDUCObukcvlfYOOagJpdjLP9gHPHvpmEW3wNBAOZRNX+dkh6e2o822DbybFz6XOeOs3j457dQoCkmnVPBtQBLrIUGZm2VZpVXXf+kag1w7HAd+5Y2GCZUeX1Y79k0CjsuKxxhvq1k1ECyY8iWtUjxtpDMuKFMFEoF2AMhXrH3ftcxXHXcQwVuqA5uxsfG/TnjWSNoVqrwPnQsUZdA44ON79AS7Y10If2X7Rh0Ncim56K9oV8qd+No
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(36756003)(2906002)(86362001)(2616005)(5660300002)(71200400001)(4744005)(8936002)(316002)(186003)(8676002)(91956017)(66556008)(66476007)(6506007)(6512007)(26005)(66946007)(478600001)(6486002)(4326008)(76116006)(64756008)(66446008)(110136005)(54906003)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Sk5TcDdTU1ZsbnhUcEMvUXdzeElYeEEwRmoybFl4aG00VjdwdzZhZzdVQWVk?=
 =?utf-8?B?MTE5dXIzcHFnUGV0Wm9QNE5WVjNBb0Y2QkwxTk1XNUxvVnk3elJIeVRNSnQx?=
 =?utf-8?B?c2plY2M4NWtNZEtWdmMvbG1LRndNV1dTY2IrZE1HdXhneGpQcTlGcmZ5ZUk0?=
 =?utf-8?B?dS94YTNWVXNTWkxGU2d3cVVQSSsxVmU2SFp2Z0E4dWN6dGJXck9TcFljTU1N?=
 =?utf-8?B?Yjc5OSs3RkpTSUc2SEgzNWpIUGs0MXFZS0xST1BGU1oxcU9ZdE1sdWtybC8w?=
 =?utf-8?B?TlBDYjdKUktNdnN2djgzcUhSS1hMdk9UTHMvWkNIdjVlK1g4c25YYWE5WFlZ?=
 =?utf-8?B?MmZtTFNzRloyNDQzdkZ5YU16SVlQckNDTWNGdi9heStobHBib2lQNVhGWmI2?=
 =?utf-8?B?RVVCM2laZkt0TDVWWWRhdWJYY0hRc2tXUXl6M3NJZzYvbjRxRlg3eXFIMUhp?=
 =?utf-8?B?ekU4V3ByakcwbjNGVDRzaVlnWStzU2p5MkVxVUlKczFpaElzb1hKVFJQMDJm?=
 =?utf-8?B?cys2KzdPS0thQ1lwdTNUZGg4UGU1U0h5T1lPazhOQ2sxS1NwNmVlZGxRQXhz?=
 =?utf-8?B?cldQZ2k0alFsb2ExbmdKSkMvb0o3UE1qWTNrNk5VRFZlVFQvQ0JHV1FTTng5?=
 =?utf-8?B?alFac20yZFd0MTR1MEYzMlE2S3pWSk1iaXNISmJrSnRNTzlnQllFT05DMmY1?=
 =?utf-8?B?Q1I3QzgxazhKSlpJUU52VEZxVmRNWXphN3BTS24xOUVkQ3NMWUFGL2szZUdp?=
 =?utf-8?B?dnBGaW9mUW1URHdwK09IYWdId2o2bDM5YXFZbXh4cURsZWdOdWdrdFFLSkZw?=
 =?utf-8?B?S1diTXdVejZUbjR5S3pCN0JBKzBJaXhWdHE0RElKZHVFblI4THFMcXR2RURR?=
 =?utf-8?B?cTBVK3hTQUpWV1ZqTVcwYllZKzdkdjRxRHpCSWZ5aHU5bzlNSXU5dFE1dXd3?=
 =?utf-8?B?WkNFZmJBREZnTlF4MnB3dUd6cW5XUlJNZ0krNUtQb29lUG1QdmRhVFVYNXlS?=
 =?utf-8?B?OTkwQU1EdnZrRFBrTTNwT2w1VFo2U3FrWS82QUZER3VFVDh2V0NtS2NVSHY3?=
 =?utf-8?B?cFExZHRkM29rcWE2VkFCVFU3S0hPK3lLVjRlamVhcDNyVGRjWnJmb3hubFFJ?=
 =?utf-8?B?UG9uUEtWZHZVZ05KWlV2QWdLZTRIdGhDc0xhVUg1dGtNVlM3MlpxclhDTC9E?=
 =?utf-8?B?VVlNU0xtREgvUTBkeDk4OXlkTE5JTEt5NHdGYmRMV0ZDNmlUMDFUVVowazNJ?=
 =?utf-8?B?MERyM09lY0tYcHAyMVl0RWpYTCtSL1ROTTM5VTA1cnkyU1F3RHUrUmRVcnJt?=
 =?utf-8?B?Q0FKQ3kwUURSUUJsU1pua25hNGlUa3RGNkFXb1UyQ3J6WW5uZDd5VjJqM2t3?=
 =?utf-8?B?U1REd2lEY1pBS29veXVEak51QVJpVmxzRjdEQy82cnlhOWFWV25tM1k0dDFx?=
 =?utf-8?B?VWYzTERwUzhjT2RSVXh3QlZvZEgxQSsxTElTbDhBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E74AC254005EE74493AEE20FC666B66A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a54043-0022-409b-a30b-08d8c6dfc822
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 18:32:50.9725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RA6yx0w6HwbzyJERCOzXQ6lKH9Ftbr0wgVSAevCbeS7HO/hT3z5lf+Zt2yxEtiiJ1HkFjdXEAJKHCzPyCpSZuUN57aYdK4Lj1BBBNNQqjo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4653
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTAyLTAxIGF0IDA4OjQ3IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gU3VuLCAzMSBKYW4gMjAyMSAxODoxNzoxMSAtMDUwMCBNYXR0IENvcmFsbG8gd3JvdGU6
DQo+ID4gR2l2ZW4gdGhpcyBmaXhlcyBhIG1ham9yIChhbGJlaXQgYW5jaWVudCkgcGVyZm9ybWFu
Y2UgcmVncmVzc2lvbiwNCj4gPiBpcw0KPiA+IGl0IG5vdCBhIGNhbmRpZGF0ZSBmb3IgYmFja3Bv
cnQ/IEl0IGxhbmRlZCBvbiBUb255J3MgZGV2LXF1ZXVlDQo+ID4gYnJhbmNoDQo+ID4gd2l0aCBh
IEZpeGVzIHRhZyBidXQgbm8gc3RhYmxlIENDLg0KPiANCj4gVG9ueSdzIHRyZWUgbmVlZHMgdG8g
Z2V0IGZlZCBpbnRvIG5ldCwgdGhlbiBuZXQgaW50byBMaW51cydzIHRyZWUgYW5kDQo+IHRoZW4g
d2UgY2FuIGRvIHRoZSBiYWNrcG9ydCA6KA0KDQpUaGUgYmVoYXZpb3IgbG9va3MgdG8gaGF2ZSBh
bHdheXMgYmVlbiBzaW5jZSBzdXBwb3J0IHdhcyBpbnRyb2R1Y2VkDQp3aXRoIGY5NmE4YTBiNzg1
NCAoImlnYjogQWRkIFN1cHBvcnQgZm9yIG5ldyBpMjEwL2kyMTEgZGV2aWNlcy4iKS4gSQ0Kd2Fz
IHVuYWJsZSB0byBkZXRlcm1pbmUgdGhlIG9yaWdpbmFsIHJlYXNvbiBmb3IgZXhjbHVkaW5nIGl0
IHNvIEkgd2FzDQpwbGFubmluZyBvbiBzZW5kaW5nIHRocm91Z2ggbmV0LW5leHQgYXMgYWRkZWQg
ZnVuY3Rpb25hbGl0eSwgaG93ZXZlciwgSQ0Kd2lsbCBnbyBhaGVhZCBhbmQgc2VuZCB0aGlzIHRo
cm91Z2ggbmV0IGFuZCBhZGQgaXQgdG8gdGhlIGN1cnJlbnQNCnNlcmllcyB0aGF0IEkgbmVlZCB0
byBtYWtlIGNoYW5nZXMgdG8uDQoNClRoYW5rcywNClRvbnkNCg==
