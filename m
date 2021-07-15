Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF9E3CA54C
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 20:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238017AbhGOSXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 14:23:32 -0400
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:19682 "EHLO
        rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbhGOSXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 14:23:32 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jul 2021 14:23:31 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=5548; q=dns/txt; s=iport;
  t=1626373238; x=1627582838;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VrQgU95OQaUHsEgYxhaBThTCKfIaKJjvrmzs/Vr8opQ=;
  b=B4AfEGEfCwZ2HMZ20KVX9KM4jNGxRfqP5tJKFUVAE+vSfRkfK46qy4RY
   kUfOjcY0O3u/NiDn8R0BI867BE0P1axuPYWWW+Hxn3q9iCasmcs+bslmr
   +gDVRy327CpMARxN4Leys2HCfjwgi/iu57X3st2gj2sKhfj6FbSOj2qsM
   8=;
IronPort-PHdr: =?us-ascii?q?A9a23=3AMFilSRYi4qqrrzqO47Cu+RL/LTAxhN3EVzX9o?=
 =?us-ascii?q?rIkhqhIf6Dl+I7tbwTT5vRo2VnOW4iTq/dJkPHfvK2oX2scqY2Av3YPfN0pN?=
 =?us-ascii?q?VcFhMwakhZmDJuDDkv2f/3ndSo3GIJFTlA2t32+OFJeTcD5YVCaq3au7DkUT?=
 =?us-ascii?q?xP4Mwc9Jun8FoPIycqt0OXn8JzIaAIOjz24MttP?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3ARWO5d65nRzvONmH5hgPXwZ6CI+orL9Y04l?=
 =?us-ascii?q?Q7vn2ZFiY1TiXIra6TdaoguiMc0AxhJ03Jmbi7Sc69qeu1z+833WBjB8bdYO?=
 =?us-ascii?q?CAghrrEGgC1/qj/9SEIU3DH4FmpNxdmsRFebjN5B1B/LrHCWqDYpMdKbu8gd?=
 =?us-ascii?q?qVbI7lph8HJ2wHGsIQjTuRSDzrb3GeLzM2Y6bRYaDsnvav0ADQAEj/AP7LYk?=
 =?us-ascii?q?UtbqzmnZnmhZjmaRkJC1oM8w+Vlw6l77b8Dlyxwgoeeykn+8ZnzUH11yjCoo?=
 =?us-ascii?q?mzufCyzRHRk0XJ6Y5NpdfnwtxfQOSRl8kuLCn2gArAXvUnZ1TChkFynAic0i?=
 =?us-ascii?q?dzrDD+mWZ6Ay210QKKQoiBm2q15+An6kdy15at8y7FvZKpm72JeNtzMbswuW?=
 =?us-ascii?q?seSGqH16Ll1+sMgZ6iGAmixsRq5Fr77VbAD5KjbWAYqmOk5XUliuIdlHpZTM?=
 =?us-ascii?q?8Xb6JQt5UW+AdPHI4HBz+S0vFpLABCNrCQ2B9tSyLXU5kZhBgn/PW8GnAoWh?=
 =?us-ascii?q?uWSEkLvcKYlzBQgXBi1kMdgMgShG0J+p4xQ4RNo72sCNUoqJheCssNKa5tDu?=
 =?us-ascii?q?YIRsW6TmTLXBLXKWqXZVDqDrsONX7Bo4P+pL81+OapcpoVy4ZaouWObHpI8W?=
 =?us-ascii?q?opP07+A8yH25NGthjLXWWmRDzojtpT4pBo04eMDoYD8RfzA2zGtvHQ1cn3Lv?=
 =?us-ascii?q?erL8pbCagmS8MLd1GebLqh9zeOLKVvFQ=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CCAABvevBg/51dJa1aHQEBAQEJARI?=
 =?us-ascii?q?BBQUBQIFFCAELAYFSUQeBUTcxhEiDSAOEWWCIVwOKVY9YgS6BJQNUCwEBAQ0?=
 =?us-ascii?q?BAUEEAQGEVAIXgmQCJTQJDgIEAQEBEgEBBQEBAQIBBgRxE4VoDYZFAQEBBBI?=
 =?us-ascii?q?REQwBATcBDwIBCBEDAQIDAiYCAgIfERUICAIEDgUigksEglYDLwGbIwGBOgK?=
 =?us-ascii?q?KH3qBMoEBggcBAQYEBIU3DQuCMgmBECoBgnqEDoZiJxyBSUSBFSccgjIwPoI?=
 =?us-ascii?q?gggYegxc2gi6CKy81AQyCNh0GJz4BAgglCjiRJS4NgksBRowbmwdbCoMkmFW?=
 =?us-ascii?q?FYQUmg2OSGpBepWqVJQIEAgQFAg4BAQaBWzsNLIEgcBVlAYI+UBkOjh8MFhW?=
 =?us-ascii?q?DOopeczgCBgEJAQEDCYwJAQE?=
X-IronPort-AV: E=Sophos;i="5.84,243,1620691200"; 
   d="scan'208";a="885851810"
Received: from rcdn-core-6.cisco.com ([173.37.93.157])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 15 Jul 2021 18:13:30 +0000
Received: from mail.cisco.com (xbe-aln-004.cisco.com [173.36.7.19])
        by rcdn-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id 16FIDULa023577
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 15 Jul 2021 18:13:30 GMT
Received: from xfe-aln-004.cisco.com (173.37.135.124) by xbe-aln-004.cisco.com
 (173.36.7.19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15; Thu, 15 Jul
 2021 13:12:27 -0500
Received: from xfe-rtp-001.cisco.com (64.101.210.231) by xfe-aln-004.cisco.com
 (173.37.135.124) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15; Thu, 15 Jul
 2021 13:12:26 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (64.101.32.56) by
 xfe-rtp-001.cisco.com (64.101.210.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15
 via Frontend Transport; Thu, 15 Jul 2021 14:12:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/vLAceUEM+R/G2XfXTpNvN02mhPcqKDNik/WCwKP7MNCsQ5sVfYfEaRcrEBMIi/1XFRmSad4ARuWM2ViBuAhpvpYin8K5huyLQkVeb8qxadvNcVZ3iXWaCX2LwWNdBXQ8ZOlF4AtYI4qXT0xumuAHNoctZd9Eel9iZRQ0LWqzGPSJIQDz0rp67G5NR6FaEWy3vEZk5tLXe1ZZi0WlRQVKNFOQHofKLpZsh9mINM5m/JCoe9DcKGylRSPm+jz3VF1ObUsZoRuqC/3NwWyfNQc2tfA8Rc6M/XVB8dM0BR7+fv4Cq08ubTJmfyNkf0YxjBkYBPTOGy13yxHeYn7sH3+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrQgU95OQaUHsEgYxhaBThTCKfIaKJjvrmzs/Vr8opQ=;
 b=JzJS97hkA3SzpjlWc4LLXXDwHZSnOPVB+W/cKFEYD9KdxOuPN/kyXYHS2thiD3DpNL/S9qrE78EOTslUM6wK6gL2RK58tGskV0jFIfkQ0CNMJ3QIQW12rGNc9ctXdesAqncn3vRrtcf4ucU4HRsyhvFFnBCuoVt5EYMl7lSR4HOTOIwikiNvww//cldpwzfPNTnZbm0kMRb7TCR975cJafZ8SB4gxGb2YMtj6F+/gT8mTUgcp5wqkYWdqfw8TiFyN79UwqmTomATcXR/eg1t40QswA13PNd2nb48DDPsZmW2mVVAU7CWVkkeMVgfGM68RXIzP+G5b8Io5Xe0CPKItw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrQgU95OQaUHsEgYxhaBThTCKfIaKJjvrmzs/Vr8opQ=;
 b=Zlt4WcDw9MDO8iL7vNR3Xb7gaXmRATAsc00lg6/fKLb/8sTFwQ4uJkkMWd9cdhYUudscF7HvzSSADqeYCKAUNHhCW8YaCo082ZtuloFTWBPkaDkgMko56iyi1inSo6JNV5Y561XUqvganqYc7OkTVy/VJEQ16l1f22VyPZP4F9c=
Received: from BYAPR11MB3527.namprd11.prod.outlook.com (2603:10b6:a03:8b::26)
 by BY5PR11MB4117.namprd11.prod.outlook.com (2603:10b6:a03:18a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Thu, 15 Jul
 2021 18:12:25 +0000
Received: from BYAPR11MB3527.namprd11.prod.outlook.com
 ([fe80::8805:aed5:fbfa:e02a]) by BYAPR11MB3527.namprd11.prod.outlook.com
 ([fe80::8805:aed5:fbfa:e02a%4]) with mapi id 15.20.4308.027; Thu, 15 Jul 2021
 18:12:25 +0000
From:   "Billie Alsup (balsup)" <balsup@cisco.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Guohan Lu <lguohan@gmail.com>,
        "Madhava Reddy Siddareddygari (msiddare)" <msiddare@cisco.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sergey Miroshnichenko <s.miroshnichenko@yadro.com>
Subject: Re: [RFC][PATCH] PCI: Reserve address space for powered-off devices
 behind PCIe bridges
Thread-Topic: [RFC][PATCH] PCI: Reserve address space for powered-off devices
 behind PCIe bridges
Thread-Index: AQHXeYB6FVfPjF670EajPRVp4GveDatEEn+AgAATp8qAACBqAP//mwIA
Date:   Thu, 15 Jul 2021 18:12:25 +0000
Message-ID: <545AA576-42A5-47A7-A08A-062582B1569A@cisco.com>
References: <BYAPR11MB3527AEB1E4969C0833D1697ED9129@BYAPR11MB3527.namprd11.prod.outlook.com>
 <20210715171352.GA1974727@bjorn-Precision-5520>
In-Reply-To: <20210715171352.GA1974727@bjorn-Precision-5520>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.51.21071101
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=cisco.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a1dd4f7-a8fe-48a5-1a64-08d947bc1953
x-ms-traffictypediagnostic: BY5PR11MB4117:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB411763EA6F0EAB97F7BC789AD9129@BY5PR11MB4117.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p1I61EsAe+AL1Bnkb+y4tIYTXX8t35XM6k33byAjY79KmoT7a+vpsrrPv6QYr72LGjQ3YlxBLXrEFKac4R1n+4a7Q89MhfVS81RASOa7LNtwxcRIDlXQhM2jH2vSYX+MDdp31dd5KpceNbcYwtcvDO5AMeQ7lwSzEBGlemG4dayVFHVl5sCa5VF2NNq6hKrV6r9K6AXnfBzB0tt4AiwJtDKjWJbt7UwSgNphekredxOPuvzVSaE9ljh4XPdhAu7quakX+sEQLcpTIn/iovGlGpL5qQyQHdplytSffileGUyE1K5vHU9FfqZc6r59WYD8Slazf4BVS/GPG8IuwCXGntHtXFehfIA67sH4NHAe6rHoxi3qKJ0+LprAZbpNboaEbCJ5AST294Ng0ww7Zf89fEp+o2AqIX4oCACE5E2y7apk/m+LLi1KE4RciMtu1+K9YqO+ym9bwMcbwh1TQMGVtf7ReUODZkVBHxLNfx5a8ckIVHFrLNXEoOSTPQ8hIueLWpFgIdLTSMC9Jh7J4z7p3DkuL9Jp0zHLjHXkD2Ek1m963LRmsG/7uQLPeXCyfJhN8PSjCJlSOQcaVyZquM3M1jKX7fljL+hFr0gHGTKZNJ9VNdlLBwXL0cFn5Hvtzf+3yEI1VkhCv8KHa2qowzzcfBaEuXo+JxHqyCZkF9EkK8rMavhZZeE5+ht/1KkeyH4FeZyzqsshlrb/CzYGq3iFc8AgWGrmH8aFLJWmjZuG+tcjvF3oI/HzAq2gYKXYYASg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3527.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(26005)(52230400001)(2616005)(71200400001)(6916009)(122000001)(45080400002)(53546011)(38100700002)(7416002)(54906003)(316002)(478600001)(6506007)(83380400001)(8676002)(33656002)(66946007)(6512007)(186003)(66446008)(66476007)(66556008)(2906002)(64756008)(4326008)(36756003)(6486002)(76116006)(5660300002)(8936002)(45980500001)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bDR2L0RRZjByZVR2ZGRmN1hqL0hMbExOaU55VnUveDFvRkcvTjAxRHFmNXEz?=
 =?utf-8?B?NGpDbDJrQVdZVnFaYUV0eUkzZ3hwREs0clNPbzRBVi9aZmwxNjJwMDduclN6?=
 =?utf-8?B?OEFzd2lSSXpQZnpnSExPN3pyMnM0eXJjTW9TZWtmdUJzVkwzb3h2ODhIMitG?=
 =?utf-8?B?VUErejR1WkFHMEY5VHJUUlovbUh4dzZDVE52RiswZ2JaaEpvdjdMUkJ0Qk5r?=
 =?utf-8?B?QlVNSUdXbVM0cC9PbldTSVVkWEU4OFVnTFZSQ2kzQmQxU2dCN1dNUHhua2dr?=
 =?utf-8?B?OHQxQmFEeHg4ZjBMSitPZitnaEo5amgvdEVvZzRkaUsra0psUm1iNmRZRFY4?=
 =?utf-8?B?eTY0Y1FxQXdkNnFkQXhWb01rczRRamtwUFNsNng0enkrenVGSDM2OEdwZTBV?=
 =?utf-8?B?enI0MjN6OXdtRFpVajZBMHJ6TGFGOGxPQ1JkUUVzU3lDSktMZGhzM2dEVWo2?=
 =?utf-8?B?cEFVcHNHa2xzeDlKZ1VSSDZyNXUrN2NBN1dkRGh6T2lITHc2ZjZDZGpzY01M?=
 =?utf-8?B?NWR5YkdrRUtlNlFsWlpUNjVscklSOEE2ZnB2MzN3QWVNOWR6NHRRR0QwcEVx?=
 =?utf-8?B?ZHVRbFRiMm5xeTZ2bzRWcEJ5ckFQTmN4S0tJaWg5MVh6N2k4c0VIMUVSbHA5?=
 =?utf-8?B?RDdmeVZ6VTZBNTEyeXVHRmVLTm94bnRmVkJJQytOWWxKbm5hKy93UytQZXFK?=
 =?utf-8?B?N1BYMHE5YU5SMThwL1VEQVVvWnQyN3pCNnhZNVE0eXN5d0k5ZzM5WkVzNUQ2?=
 =?utf-8?B?akRFVjYvMlBPRlhWdFQ4RUkxQ3dZTFlRZkR2N0lKcGs3OEErMmlkZlpmbkgw?=
 =?utf-8?B?N3lraFVNVkErZTVIZUM1SGRJSDVBbkpYU3ZpbnpHa0VYeVpOTG83WXRGSlhO?=
 =?utf-8?B?R1pWTGs2NWUwQ3B0cURDUWxzcnBxRDFJQ2UrSFhnUXRPcXprSy9jRTBTNHRW?=
 =?utf-8?B?d3NoK1VGa3pheDBwN0xmMUs0SHJ1NTFRWW5JNUlEcUY4K0VNc2V1a1dGeDA5?=
 =?utf-8?B?M3RFS0JEMGZ1WW5NbzBpSDhGM0hDNXF5dmJ3MkpxZnJZdlN5OHpBZGtYRE9a?=
 =?utf-8?B?QStYWldzd1RmSUVDU0lsbkQ0eC9IVjFSOVg4WnJQQU1DdGFGVmp6ZlJqVXRU?=
 =?utf-8?B?VzVlNGpvVUI2OVdTaDJqb1QxR3JjaUg3ZVNBWjl3UWlDa2owb05Bdlk4aloz?=
 =?utf-8?B?cmhsakVaVWkvN0Z4Z3VXLy9XWG1CVVVueHAxRStKenN0bVdwZ0VvQk1KOWFp?=
 =?utf-8?B?bmFsNkQzNmUySFZKbytKSUc4cEZoSU02cHRYT2pVVm9oWTF1TEcyRDhVcHVx?=
 =?utf-8?B?b0pFUHBoTU5GRmppMnd4bTRjeDRnMW9hY2htVXdVelRzek55Y1hWR0s2QmYx?=
 =?utf-8?B?RE14VlkzMHY5Rm1VK2cvWkZkbDZYOUc4aFNEZHdiK2JMcnAyYy9RVys5M2FH?=
 =?utf-8?B?cHZwdTBHcHRGVEdKT2ZuSVI2dGJqOXRCRXN6NGtURHVrbC9zMFVsUkVNSDkx?=
 =?utf-8?B?WXFmalhTbXkwcXlHWUV4U1pMTEYrYW9DSVhnMkNwNDlRTkVKWlhkRldsVkQ0?=
 =?utf-8?B?ZEVYN3RlUzdVUHhGaTFCQWJMMFk1dTFDaE8xV3hhVU14SjZJRGtXdTJFL1pk?=
 =?utf-8?B?c1hEVFI3cFBKMHluMmIza0poRlQ0OEZyYVp1MEpoSmRVL2tuakFyTEg0bXZS?=
 =?utf-8?B?TEVjYUthNDdMR2c2NlhESlM4VVFXNFhxK3N3NWloVlhMaElnUkkwYURvYmRj?=
 =?utf-8?B?TGlJV211ckdkMDJyNVIvNjZMOWNqZXRaczAwODArS0ZmSUoxMDJxNW5ueHJp?=
 =?utf-8?B?d29IRHM4WVZDREMrS2Rrdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E2EABE3302A68459AC54101DDC8074C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3527.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a1dd4f7-a8fe-48a5-1a64-08d947bc1953
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2021 18:12:25.3146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9oYSncJ0fMp6JAHKiShTOsEHrKLkus4CIwzvAFOuAvLz0cnzvAPK49akhFLK6dlJVtsi3962TYAuR75Nv4GuaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4117
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.19, xbe-aln-004.cisco.com
X-Outbound-Node: rcdn-core-6.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SXQgdG9vayBtZSBhIHdoaWxlIHRvIGZpZ3VyZSBvdXQgdGhhdCB0aGUgIk5ldyBPdXRsb29rIiBv
cHRpb24gZG9lc24ndCBhY3R1YWxseSBhbGxvdyBzZW5kaW5nIHBsYWluIHRleHQsIHNvIEkgaGF2
ZSB0byBzd2l0Y2ggdG8gIk9sZCBPdXRsb29rIiBtb2RlLg0KDQpJdCBpcyBub3QgY2xlYXIgYXMg
dG8gd2hhdCBwYXJhbWV0ZXJzIExpbnV4IHdvdWxkIHVzZSB0byBjb25zaWRlciBhIHdpbmRvdyBi
cm9rZW4uICBCdXQgaWYgdGhlIGtlcm5lbCBwcmVzZXJ2ZXMgc29tZSBicmlkZ2Ugd2luZG93IGFz
c2lnbm1lbnQsIHRoZW4gaXQgc2VlbXMgZmVhc2libGUgZm9yIG91ciBCSU9TIHRvIHJ1biB0aGlz
IHNhbWUgYWxnb3JpdGhtIChyZWFkaW5nIFBMWCBwZXJzaXN0ZW50IHNjcmF0Y2ggcmVnaXN0ZXJz
IHRvIGRldGVybWluZSB3aW5kb3cgc2l6ZXMpLiAgSSB3aWxsIHJhaXNlIHRoaXMgcG9zc2liaWxp
dHkgd2l0aCBvdXIgb3duIGtlcm5lbCB0ZWFtIHRvIGRpc2N1c3Mgd2l0aCB0aGUgYmlvcyB0ZWFt
LiAgV2UgY2FuIGFsc28gbG9vayBtb3JlIGNsb3NlbHkgYXQgdGhlIHJlc291cmNlX2FsaWdubWVu
dCBvcHRpb25zIHRvIHNlZSBpZiB0aGF0IG1pZ2h0IHN1ZmZpY2UuIFRoYW5rcyBmb3IgdGhlIGlu
Zm9ybWF0aW9uIQ0KDQoNCkZyb206IEJqb3JuIEhlbGdhYXMgPGhlbGdhYXNAa2VybmVsLm9yZz4N
CkRhdGU6IFRodXJzZGF5LCBKdWx5IDE1LCAyMDIxIGF0IDEwOjE0IEFNDQpUbzogIkJpbGxpZSBB
bHN1cCAoYmFsc3VwKSIgPGJhbHN1cEBjaXNjby5jb20+DQpDYzogUGF1bCBNZW56ZWwgPHBtZW56
ZWxAbW9sZ2VuLm1wZy5kZT4sIEJqb3JuIEhlbGdhYXMgPGJoZWxnYWFzQGdvb2dsZS5jb20+LCBH
dW9oYW4gTHUgPGxndW9oYW5AZ21haWwuY29tPiwgIk1hZGhhdmEgUmVkZHkgU2lkZGFyZWRkeWdh
cmkgKG1zaWRkYXJlKSIgPG1zaWRkYXJlQGNpc2NvLmNvbT4sICJsaW51eC1wY2lAdmdlci5rZXJu
ZWwub3JnIiA8bGludXgtcGNpQHZnZXIua2VybmVsLm9yZz4sICJsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnIiA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz4sICJEYXZpZCBTLiBNaWxs
ZXIiIDxkYXZlbUBkYXZlbWxvZnQubmV0PiwgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9y
Zz4sICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz4sIFNl
cmdleSBNaXJvc2huaWNoZW5rbyA8cy5taXJvc2huaWNoZW5rb0B5YWRyby5jb20+DQpTdWJqZWN0
OiBSZTogW1JGQ11bUEFUQ0hdIFBDSTogUmVzZXJ2ZSBhZGRyZXNzIHNwYWNlIGZvciBwb3dlcmVk
LW9mZiBkZXZpY2VzIGJlaGluZCBQQ0llIGJyaWRnZXMNCg0KT24gVGh1LCBKdWwgMTUsIDIwMjEg
YXQgMDQ6NTI6MjZQTSArMDAwMCwgQmlsbGllIEFsc3VwIChiYWxzdXApIHdyb3RlOg0KV2UgYXJl
IGF3YXJlIG9mIGhvdyBDaXNjbyBkZXZpY2Ugc3BlY2lmaWMgdGhpcyBjb2RlIGlzLCBhbmQgaGFk
bid0DQppbnRlbmRlZCB0byB1cHN0cmVhbSBpdC7CoMKgVGhpcyBjb2RlIHdhcyBvcmlnaW5hbGx5
IHdyaXR0ZW4gZm9yIGFuDQpvbGRlciBrZXJuZWwgdmVyc2lvbiAoNC44LjI4LVdSOS4wLjAuMjZf
Y2dsKS7CoMKgSSBhbSBub3QgdGhlIG9yaWdpbmFsDQphdXRob3I7IEkganVzdCBwb3J0ZWQgaXQg
aW50byB2YXJpb3VzIFNPTmlDIGxpbnV4IGtlcm5lbHMuwqDCoFdlIHVzZQ0KQUNQSSB3aXRoIFNP
TmlDIChhbHRob3VnaCBub3Qgb24gb3VyIG5vbi1TT05pQyBwcm9kdWN0cyksIHNvIEkNCnRob3Vn
aHQgSSBtaWdodCBiZSBhYmxlIHRvIGRlZmluZSBzdWNoIHdpbmRvd3Mgd2l0aGluIHRoZSBBQ1BJ
IHRyZWUNCmFuZCBoYXZlIHNvbWUgZ2VuZXJpYyBjb2RlIHRvIHJlYWQgc3VjaCBjb25maWd1cmF0
aW9uIGluZm9ybWF0aW9uDQpmcm9tIHRoZSBBQ1BJIHRhYmxlcywuIEhvd2V2ZXIsIGluaXRpYWwg
YXR0ZW1wdHMgZmFpbGVkIHNvIEkgd2VudA0Kd2l0aCB0aGUgZXhpc3RpbmcgYXBwcm9hY2guwqDC
oEkgYmVsaWV2ZSB3ZSBkaWQgbG9vayBhdCB0aGUgaHBtbWlvc2l6ZQ0KcGFyYW1ldGVyLCBidXQg
aWlyYyBpdCBhcHBsaWVkIHRvIGVhY2ggYnJpZGdlLCByYXRoZXIgdGhhbiBiZWluZyBhDQpwb29s
IG9mIGFkZHJlc3Mgc3BhY2UgdG8gZHluYW1pY2FsbHkgcGFyY2VsIG91dCBhcyBuZWNlc3Nhcnku
DQoNClJpZ2h0LsKgwqBJIG1lbnRpb25lZCAicGNpPXJlc291cmNlX2FsaWdubWVudD0iIGJlY2F1
c2UgaXQgY2xhaW1zIHRvIGJlDQphYmxlIHRvIHNwZWNpZnkgd2luZG93IHNpemVzIGZvciBzcGVj
aWZpYyBicmlkZ2VzLsKgwqBCdXQgSSBoYXZlbid0DQpleGVyY2lzZWQgdGhhdCBteXNlbGYuDQoN
ClRoZXJlIGFyZSBtdWx0aXBsZSBicmlkZ2VzIGludm9sdmVkIGluIHRoZSBoYXJkd2FyZSAodGhl
cmUgYXJlIDgNCmhvdC1wbHVnIGZhYnJpYyBjYXJkcywgZWFjaCB3aXRoIG11bHRpcGxlIFBDSSBk
ZXZpY2VzKS7CoMKgRGV2aWNlcyBvbg0KdGhlIGNhcmQgYXJlIGluIG11bHRpcGxlIHBvd2VyIHpv
bmVzLCBzbyBhbGwgZGV2aWNlcyBhcmUgbm90DQppbW1lZGlhdGVseSB2aXNpYmxlIHRvIHRoZSBw
Y2kgc2Nhbm5pbmcgY29kZS7CoMKgVGhlIHRvcCBsZXZlbCBicmlkZ2UNCnJlc2VydmVzIGNsb3Nl
IHRvIDVHLsKgwqBUaGUgMm5kIGxldmVsICh0b3dhcmRzIHRoZSBmYWJyaWMgY2FyZHMpDQpyZXNl
cnZlIDQuNUcuwqDCoFRoZSAzcmQgbGV2ZWwgaGFzIDkgYnJpZGdlcyBlYWNoIHJlc2VydmluZyA1
MTJNLsKgwqBUaGUNCjR0aCBsZXZlbCByZXNlcnZlcyAzODRNICh3aXRoIGEgNTEyTSBhbGlnbm1l
bnQgcmVzdHJpY3Rpb24gaWlyYykuDQpUaGUgNXRoIGxldmVsIHJlc2VydmVzIDM4NE0gKGFnYWlu
IHdpdGggYW4gYWxpZ25tZW50IHJlc3RyaWN0aW9uKS4NClRoYXQgZGVmaW5lcyB0aGUgYnJpZGdl
IGhpZXJhcmNoeSB2aXNpYmxlIGF0IGJvb3QuwqDCoFRoaW5ncyBiZWhpbmQNCnRoYXQgNXRoIGxl
dmVsIGFyZSBob3QtcGx1Z2dlZCB3aGVyZSB0aGVyZSBhcmUgdHdvIG1vcmUgYnJpZGdlDQpsZXZl
bHMgYW5kIDUgZGV2aWNlcyAoMSByZXF1aXJpbmcgMng2NE0gYmxvY2tzIGFuZCA0IHJlcXVpcmlu
Zw0KMXg2NE0pLg0KDQpJJ20gbm90IHN1cmUgaWYgdGhlIENpc2NvIGtlcm5lbCB0ZWFtIGhhcyBy
ZXZpc2l0ZWQgdGhlIGhwbW1pb3NpemUNCmFuZCByZXNvdXJjZV9hbGlnbm1lbnQgcGFyYW1ldGVy
cyBzaW5jZSB0aGlzIGluaXRpYWwgaW1wbGVtZW50YXRpb24uDQpSZWFkaW5nIHRoZSBkZXNjcmlw
dGlvbiBvZiBTZXJnZXkncyBwYXRjaGVzLCBoZSBzZWVtcyB0byBiZQ0KYXBwcm9hY2hpbmcgdGhl
IHNhbWUgcHJvYmxlbSBmcm9tIGEgZGlmZmVyZW50IGRpcmVjdGlvbi7CoMKgIEl0IGlzDQp1bmNs
ZWFyIGlmIHN1Y2ggYW4gYXBwcm9hY2ggaXMgcHJhY3RpY2FsIGZvciBvdXIgZW52aXJvbm1lbnQu
wqDCoCBJdA0Kd291bGQgcmVxdWlyZSB1cGRhdGVzIHRvIGFsbCBvZiBvdXIgU09OaUMgZHJpdmVy
cyB0byBzdXBwb3J0DQpzdG9wcGluZy9yZW1hcHBpbmcvcmVzdGFydGluZywgYW5kIGl0IGlzIHVu
Y2xlYXIgaWYgdGhhdCBpcw0KYWNjZXB0YWJsZS7CoMKgSXQgaXMgY2VydGFpbmx5IGxlc3MgcHJl
ZmVyYWJsZSB0byBwcmUtcmVzZXJ2aW5nIHRoZQ0KcmVxdWlyZWQgc3BhY2UuwqDCoEZvciBvdXIg
ZW1iZWRkZWQgcHJvZHVjdCwgd2Uga25vdyBleGFjdGx5IHdoYXQNCmRldmljZXMgd2lsbCBiZSBw
bHVnZ2VkIGluLCBhbmQgYWxsb3dpbmcgdGhhdCB0byBiZSBwcmUtcHJvZ3JhbW1lZA0KaW50byB0
aGUgUExYIGVlcHJvbSBnaXZlcyB1cyB0aGUgZmxleGliaWxpdHkgd2UgbmVlZC7CoMKgDQoNCklm
IHlvdSBrbm93IHVwIGZyb250IHdoYXQgZGV2aWNlcyBhcmUgcG9zc2libGUgYW5kIGhvdyBtdWNo
IHNwYWNlIHRoZXkNCm5lZWQsIHBvc3NpYmx5IHlvdXIgZmlybXdhcmUgY291bGQgYXNzaWduIHRo
ZSBicmlkZ2Ugd2luZG93cyB5b3UgbmVlZC4NCkxpbnV4IGdlbmVyYWxseSBkb2VzIG5vdCBjaGFu
Z2Ugd2luZG93IGFzc2lnbm1lbnRzIHVubGVzcyB0aGV5IGFyZQ0KYnJva2VuLg0KDQpCam9ybg0K
DQoNCg==
