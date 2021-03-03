Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9066732C3E1
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbhCDAIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:08:35 -0500
Received: from mga05.intel.com ([192.55.52.43]:28633 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355502AbhCCGq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 01:46:56 -0500
IronPort-SDR: BrIwU/q/mBa1hx8NpnCzy3i+O/ispCKIpZRs6nfaSlxpRepZSgQxef3Pk77NLTYBrui/4Cmi+V
 Rl8Lkuue2Wnw==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="272117886"
X-IronPort-AV: E=Sophos;i="5.81,219,1610438400"; 
   d="scan'208";a="272117886"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 22:45:23 -0800
IronPort-SDR: ip32McM8Q9RoG+UsbHOlBDzkuzonxEmJismZdRAf/8MEOgFH68GY4OE7+mexHkF6bwlaOKbev4
 6qKm68J0SMFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,219,1610438400"; 
   d="scan'208";a="383873352"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga002.jf.intel.com with ESMTP; 02 Mar 2021 22:45:22 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 2 Mar 2021 22:45:22 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 2 Mar 2021 22:45:22 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 2 Mar 2021 22:45:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EiKxCM5MS9LGiwpgybWwKtx2SRxCncnnwBUhXFXTUxkBw74WrH90aB4rTr49P8BTPqXJqu8hlrNjDmM1IJjabrPCvdq1DsL1KtRnKnZgFClb2jsiU0nF0xYOnqy6L6wu+CkoFWjLx9K2lsPT2hqSs3LFXcOwkUBr4R4PC/PBD+SXZ2u5GQdS3yCHtbIHY+UWxrfVZXH2KaRe/I+qTRTSb7BLNDMJGaz37ihJDaIB7brHMIg/8J78c/Tr8EacfUlBBHLpPvcdi1S5chn8Qtc3llA61bE4llvvy0TvQvtoijfIMePGWaOPVQUxwceRg5/pM9m39ALiXbJY03WjN5GHkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Az+jH9ySaNGWU22u0rCtnBTD+Hs5McdGnN2GV6KtrzI=;
 b=KZAUpyct3wrdn9qhHXzvtKq/NFn6DuHz+FC7yOokGYh3OHeOQnVDp/XLkgCmVB6zYNij7dlfo91Sy52aadqUCt/C9uBYH+rbmmkby7TOlW0YUDThtaykRVjkgmNmZ+TCujqLLcycxCKsBEqTvS5//Z2TdFFfGe1s4zMM6WkwpbLldhqBLMZsy/hDwPbdOZoZxMeyehXcviC4lp+S8sARq+xflhn3a90B8nQoylsv8gxSj0TKly1E9En7LYjKgs6kkb58AIYZq0+GJa6xSOZ7r0anxndg9G9DglEwMVzgETNkOMYZoRiCouRvGObbtZK4gR2QOjzN7WaVej1fL1IAiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Az+jH9ySaNGWU22u0rCtnBTD+Hs5McdGnN2GV6KtrzI=;
 b=hjWgMjahm1UvhwIHNWMQGNwhx2se/BHIU6DOjk75ZEbATv3i/4Ex+IlbPhcVDZNgX2OrQeZBrpZ28yFRewZiCoOcAWB2z4HQj/vTg7x3ps0sE/+SiXGnev+rMgsmP1AendjEakRE7vlyRW0MERv0ZdCtTcrsespdrBrjuBeDjRk=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BYAPR11MB3158.namprd11.prod.outlook.com (2603:10b6:a03:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.25; Wed, 3 Mar
 2021 06:45:18 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::c951:3ae4:1aca:9daf]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::c951:3ae4:1aca:9daf%3]) with mapi id 15.20.3890.030; Wed, 3 Mar 2021
 06:45:18 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "gil.adam@intel.com" <gil.adam@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hulkci@huawei.com" <hulkci@huawei.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "Goodstein, Mordechay" <mordechay.goodstein@intel.com>
Subject: Re: [PATCH] iwlwifi: mvm: add terminate entry for dmi_system_id
 tables
Thread-Topic: [PATCH] iwlwifi: mvm: add terminate entry for dmi_system_id
 tables
Thread-Index: AQHXCesNOiAtSHfJpEaaXnkq3FBcxapq8rcAgACgUcSABX2QAIAACbuAgAAMi/6AAB8PgIAAl8eA
Date:   Wed, 3 Mar 2021 06:45:18 +0000
Message-ID: <0a5140a6158cded895b828d3e209efaff38a56de.camel@intel.com>
References: <20210223140039.1708534-1-weiyongjun1@huawei.com>
         <20210226210640.GA21320@MSI.localdomain> <87h7ly9fph.fsf@codeaurora.org>
         <bd1bd942bcccffb9b3453344b611a13876d0e565.camel@intel.com>
         <20210302110559.1809ceaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <877dmp8hdx.fsf@codeaurora.org>
         <20210302134203.4ee50efe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210302134203.4ee50efe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [91.156.6.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31b5141a-ddd7-4301-a5f9-08d8de0fe901
x-ms-traffictypediagnostic: BYAPR11MB3158:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB315831F1E93DE890A135770790989@BYAPR11MB3158.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dUFyomF+5b+PAlOCr7pzMcG9c+BIej2tvbvwcH/4GMrTQ125YIkk1vjnuC2zvfA4t0akSOfkTtmmQA4hiej4EhAz1Q8UDrdD+i3t4FLCmB9/j83YkTkD/Y+PiQCG3cYXD/lZPNfE0SDF4yoaFU7X3SBSkvPdJEP+3KyiqvxluyM5Oe4jCpOoC4q0rEPh/qAaFt82Hgw0oo5kpZxWP/DE7MtmbD2/TfdKDX0UyqX9hAq/TBfvqlJC6trILWbEaNS+ATp2ygPdX75xDGHv6qy+usfNWseAamBN1lt7mtBZNK5VoYUo70D8AeqmlBIzNNkQfDJKEpjEzv6JrhgdatWMCmtJ9d6I7WnyZEFh1LX/frJmfPztiO6BSjGGesKh78MXm5oTX0QTLQallerMyzRhinKb7LGemxGNfaDq4PRd/GCDEBFtobdf2KGRRQqbYu4N5/6KAGRQubcX1hMyfmorDMGwCEsfwyQX+Zz+qGZcTyr/v322RYNHbMNcxvewyd1QwVZp/MhVchd7kGoqq+Oq/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(346002)(376002)(186003)(36756003)(107886003)(110136005)(478600001)(2906002)(6506007)(66446008)(86362001)(66556008)(71200400001)(76116006)(2616005)(316002)(26005)(66476007)(6486002)(8936002)(4326008)(64756008)(91956017)(6512007)(4744005)(5660300002)(8676002)(66946007)(54906003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TVoyTXJkd0V3MmwyTVgrUGE5MzZHNE0zL1BGWXgrTlpMaTN6Y3htNG9nQ1lx?=
 =?utf-8?B?b2FBYkNLMTZlZTVaN0o3RG1rR24xSVNGaEJGazBsdFQ4TTVIUU9sRnR2OW5K?=
 =?utf-8?B?ZkFBUGFIREszNE42VzFPd24yY2VrRWxBL1BLRXI1YXIyVGRIYjdJWkFqSmRV?=
 =?utf-8?B?VHliMnhIL3gxMHhqOXZsMUdPRUJWdHVlVjA3V2FvMktNdStKV0EyVHdFeU56?=
 =?utf-8?B?R3JCcVFmeFJDMXNHTzJsb1pKeUFPK3JRSm1WenJIbWlBU0lMeW9pVkZsTXBP?=
 =?utf-8?B?eHZFZElNSUVBZ2ZSeWJDTUF3ODdaNHY5MmJnMHJJSjFQOUFNcm9hQnliSGRC?=
 =?utf-8?B?VGpMdXZTQnBKWFN2U2phbldVdEw1ejc3VkdLanpnS0ZpK1FwWXJCYWlMUUpJ?=
 =?utf-8?B?Y1p4Wk5aMXdFOU54MnAxemZqb20yS20weFZTcnVhOWtKT0hKcEczR3Zoci9J?=
 =?utf-8?B?UGZPTWM0emc5MFAxSlJRbDRjYXV5bmE5TFhrbGVIK0ZPeTBVL1ZINmpzZXQy?=
 =?utf-8?B?ZHE3YUpKYVVreElYV3E1U0pIdk5zQUcvR3djSnU2QWxIWlNIeUZkNllJQjZO?=
 =?utf-8?B?bFRaSVJWeE13ZElXaWlIbVRKcnRDbGU4cXNtaUUxaVRkckROcnFQM2ZOQzk0?=
 =?utf-8?B?NXNzZi9iYVJ3aGwyOUcvZW4vRkRreVBpdFJDek00bTVGN2FYbkp5NWltNnMw?=
 =?utf-8?B?NnRUenVWSjVCejNjaklwdHh3dWR0MHNLend3RjJoUUNpbC9vcWVXRmdxV2dK?=
 =?utf-8?B?cXJnbUtpbFJtcmVFa1gxME1PNFpxdk9WQk83bUY2MDJXNlRxOHUzTS9ZQ1c3?=
 =?utf-8?B?Ym9VYnJqbzNZR3pOTzZmekN6enVoci9kZzMzUHU3QXhJT29USDI0b3o4V0l4?=
 =?utf-8?B?NjFCdjlNOVIwV1NrZVloV28wK2g4N01EenR4cGtxT2RYL2Nub2xFcXFTV3o1?=
 =?utf-8?B?SG50cm13Z1JMSkdHOVVYeEY5ak1WZjJOeW9wNGs2cnJIMGp1STc1STZ4NlVF?=
 =?utf-8?B?ZEhEQlNXSHBMbVlyNnBHU21ZMXRLYklKNHZvd0ppSVdTVTQyUUJqQ3Fnb1JM?=
 =?utf-8?B?Z2pkNWRTdTIyU1VGRWYxL1JTREoxbm9FUGFxZ1gzL25WT3JUMk5XdG1ra2Y2?=
 =?utf-8?B?UkR3TVlCZFU3ZlZJTDdmRHIrUFBwN0JaRFlSYi9OSWZZYjI0eTgzNm9zRVFi?=
 =?utf-8?B?am5vTFRYa2hSSTA2ZUpFMDJsZm9uZ3JXVVdJbXE4ZEhzWi9mUzNSWHJxN3di?=
 =?utf-8?B?VTdxN1RxSVduUXc1Sm10dU5TWUlIelBTMTVXREJRREZ1enZJV2VNZC8vOWMw?=
 =?utf-8?B?b2Nwd1Rtd1Y2S2pmR1QxYVVOeUpoVHU2TXh5cXFLRllrKzZpWkFuRkp3b0pE?=
 =?utf-8?B?d0VaWWFNSzFpOFdxWlhKWmhsT29sL3UvOFZxM0xPb2dxMmgyQmtkVHcyTFcw?=
 =?utf-8?B?bS9HbVFYRGpiREQ5a1NoY0tITUc5VzRVWHpjRUFlcmFxaHQyRytMc3ZvekY4?=
 =?utf-8?B?YjEzRWJkNy9XVXpGbzJGUDBMYmtPVFpmWGdBY0ZLTHJtR2RjM3BCUlNFUjU1?=
 =?utf-8?B?dU8yTnZITERhNFBWc20zbGlKQjRaMVRZMGZHUkJFd1c5bnRYYyt0YWJWR3lo?=
 =?utf-8?B?Si9VWHkxQ1lVWWNKSlVEWktzckxVclJzYTFpZU96cTRpZGJsUU4zKzVkOFJD?=
 =?utf-8?B?SVhIQTMyeElpRElJNnpGUTJhb3pkMFE1c3VLc0pCN1BWZG92aGdPNnpWbmFl?=
 =?utf-8?Q?ce8rFJDfDww2UbbhsQt3pv2qz2O63OEamVIqnD3?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <293C380879E6854B909E119F62A4C929@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31b5141a-ddd7-4301-a5f9-08d8de0fe901
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 06:45:18.6760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ks1kiawbaoxRW89KpDfb/yA6QBrZgSZaGVRgGTuMTpj+ne0lvWDIvnO153RKr+ZkmIb424cLUSLRkOZb26TmsinwQKeDzH7rQRM6SbSd980=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3158
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAzLTAyIGF0IDEzOjQyIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAwMiBNYXIgMjAyMSAyMTo1MDoxOCArMDIwMCBLYWxsZSBWYWxvIHdyb3RlOg0K
PiA+ID4gaWYgV2VpIGRvZXNuJ3QgcmVzcG9uZCBjb3VsZCB5b3UgcGxlYXNlIHN0ZXAgaW4gdG8g
bWFrZSBzdXJlIHRoaXMNCj4gPiA+IGZpeCBpcyBwYXJ0IG9mIERhdmUncyBuZXh0IFBSIHRvIExp
bnVzPyAgDQo+ID4gDQo+ID4gV2lsbCBkby4gUmVsYXRlZCB0byB0aGlzLCB3aGF0J3MgeW91ciBw
dWxsIHJlcXVlc3Qgc2NoZWR1bGUgdG8gTGludXMNCj4gPiBub3dhZGF5cz8gRG8geW91IHN1Ym1p
dCBpdCBldmVyeSBUaHVyc2RheT8NCj4gDQo+IEZhaXIgcXVlc3Rpb24gOikgRGF2ZSBpcyBiYWNr
IGZ1bGwgdGltZSBub3csIHNvIEkgdGhpbmsgaXQgd2lsbCBiZSBtb3JlDQo+IG1lcml0IGJhc2Vk
IGFnYWluLg0KDQpHcmVhdCB0byBoZWFyISBXZWxjb21lIGJhY2sgRGF2ZSEgOikNCg0KLS0NCkNo
ZWVycywNCkx1Y2EuDQo=
