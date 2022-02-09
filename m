Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE284AF7FA
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 18:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238101AbiBIRXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 12:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234946AbiBIRXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 12:23:02 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9729FC0613C9;
        Wed,  9 Feb 2022 09:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644427384; x=1675963384;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=l3L8LFaE+q3XvFKv9Ix9ZJ1NLS/TjuDzKasWZIzIUG4=;
  b=IBnd339293y6WT5RYcQ5wO2Iuepg9lzdTyIJrN4tEO29aQDqXmPcymws
   HsU0bsTf8cBIzJmdXnzbTat+h7KRKB63/ea3LXF03sg9NXKy0c3f25ytT
   xwGTtPFskYVaaWrfhx0tNwdl3LzCmquLnw+TCxwNpsSdrNPmFtWMOSJgk
   QQewEzS8ls+MASB3F186GJRMllHeuBDhZgy8eRhh8vJVQsqScIOK3EpiQ
   X9sKtEZi9ecLx+/TZB76+WHCbGAIKfob2LtoxLwRgdEIcRwuBiOio0Qa3
   31HpSgBL7v2eSGStVc4pXNvd9BMJENhOaVim4XnZNjTHW/xsqvLNPCdCr
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="246843321"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="246843321"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 09:21:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="485319975"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 09 Feb 2022 09:21:04 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 9 Feb 2022 09:21:04 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 9 Feb 2022 09:21:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 9 Feb 2022 09:21:03 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 9 Feb 2022 09:21:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmd8+BNG1h6I18u3NM6Njy5OESjKHuo4msML3hPVT0uT0LlVQjpOqrLzziA2VKhq3q+GP9bLm0RFzGY3U/KFB2rVFbcRWg3uCOhHS20HpPDoGqQqRW5szw3MLO5xjwUvdYtdA6F2li3hnegHQxY8HebJAN8WRnF5x7HlC2jfnycq9C2iuzi8aFtu+5l813cEIY6/b5j/s62CdHffaWSZTvEMf/aJ48HFbHY3IXgg3jjxGuEBvlA8xmu4E6/oVCYa1eJCl0LmSb6OGSUESu5+Xm0x4P77ujVyaPPYsUFAv/1eRazQQAhYKVTwxcg4YJ0XOLl2t2Ib00cUUb1SpY0Xkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3L8LFaE+q3XvFKv9Ix9ZJ1NLS/TjuDzKasWZIzIUG4=;
 b=a466nqZRGCQMAD73LUVnOj9hlRVneojhv/uc8gOrNTSYtC/QiZ3Xwr6P9EEeNTZh65VdVL5I1nc6d2t+CFc9or5fbUcggor86AiHFXI+ZetZGf6/pNzEwBfIHsFyT1RKmYhUsCBUzviJCJE50aUCN/deFufGhK8CT38Zg50G73htwnekYzd1oh24T5K8c7N727f69SzOXSmmEUzNEsNyBk9APdSSidYjm+9uzz5jwMhGQiYPHhPaM04PyOTf42w51BrEJVlfmfOkF/oEyqEOf/d0mpiWVYHEAU/EQ7fBjqKkUm3CimxIuUulSuIIj+884Vmr+0Clod34zD0SqTA/WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by BN6PR11MB1249.namprd11.prod.outlook.com (2603:10b6:404:3e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 17:20:54 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bded:8c4b:271e:7c1]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bded:8c4b:271e:7c1%5]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 17:20:54 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kurt@linutronix.de" <kurt@linutronix.de>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "vinschen@redhat.com" <vinschen@redhat.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2][pull request] 1GbE Intel Wired LAN Driver
 Updates 2022-02-07
Thread-Topic: [PATCH net-next 0/2][pull request] 1GbE Intel Wired LAN Driver
 Updates 2022-02-07
Thread-Index: AQHYHHsTSnJrtK1NZEyF+LUY2IADx6yKrnmAgAAycACAAJjmgA==
Date:   Wed, 9 Feb 2022 17:20:53 +0000
Message-ID: <699b8636cafcfa82a99cf290e3cffbab91b6afbb.camel@intel.com>
References: <20220207233246.1172958-1-anthony.l.nguyen@intel.com>
         <20220208211305.47dc605f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <87sfssv4nj.fsf@kurt>
In-Reply-To: <87sfssv4nj.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ef0b559-2df9-4537-ffc5-08d9ebf0870e
x-ms-traffictypediagnostic: BN6PR11MB1249:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB1249D6CE855BE38F0CA7837CC62E9@BN6PR11MB1249.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VIoi2cvF2HmGPLXZj+fizwaaDya7m0Mq46ROI1UYN6HF/7X/u8Ncsvvy/iIVeGx1CK7wS5DLANvztdS5S+I3Jw2UZFOCwoa4JCte+pfQGOlI2Vm9N7PpE8VF/p8ylyi+1fII9EKnc7xdk3OT+rCefDLzZR1rCEPrH+gn+aazR3Fek1R+7X3AeokqB8EBTo7fD4XAsUChNJOETGrKAyQxNUmMTXzHA72ppZ8yUwCoSGVC5P/y5PSEmp9Rr53Y/BhipDncXA7wW3FxQX770/SsWRYYxm5qqqSRu6gzqNsX946StKgpcR+8+4Y48R64VOZy23VD2OHv4q30hzgmpGzo1O19DM4gOjhfSFq6bcOyHphD/6/DeZdm8cWawZPYY8wU9YV90vnlLq/Y9df0dGUNEIUADc007hQ9GA73iJ3hOGfE8fswN793GmYQ7zUtjJnh9ZC/7GgwHtnHlilqqWCSJW+/bLnSdQVD2uYLzkBNOGvDRJ3Z2YC5grOQmZEdHehS1Vs36RBNKweQYbTij+xE52kutBYFdyYyInyXqDPXqM5gCUHlUOOBdllTLbc5xffMsYhukzxLA9czX4pn/ZN3lbomlv+RrNqlEP01MF41OvRShI8sN2/BcA8XngEA3O5FTPKA0N/sqDK0qjX7pImJE314TCp5lk50vWOB7nQ6PoAUH7B11s5XcU0JNAMUhfMVVG/bs0n5lVC4pFLbf23iGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(2616005)(5660300002)(26005)(82960400001)(7416002)(38070700005)(2906002)(508600001)(36756003)(38100700002)(122000001)(6486002)(110136005)(76116006)(91956017)(64756008)(4326008)(316002)(66946007)(71200400001)(6512007)(66446008)(8676002)(8936002)(66476007)(6506007)(54906003)(83380400001)(86362001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkVrbzMzK1VtVFAyQUtiVHZQMUFwNFE2QW1nYWRFazh5RTZrNmxRN2ROWi9I?=
 =?utf-8?B?bEJTcEtiNW5YaUs2WGQrR0IwZHE2cnBMM21tK0ZCc1ZpQWNrVkJueFBDM1Nm?=
 =?utf-8?B?SUlZbjRQQm95TkxaMXBVbEs4QWdOTE90aFZRZHdhaVlGcnArdlQ4TkdhdkpX?=
 =?utf-8?B?RFV5dXUyV3RNeGtTRS9wZCt0eHh2NExLcUxUVnNIYkc4UTM4dXM5R0ZCTHBV?=
 =?utf-8?B?Q0xPd0hSYlhnaWtNbXFTK2dUanlWZXBRVnIzWmM1cnpDNnNBU2pha1N3TW05?=
 =?utf-8?B?TmJxaCtldmxib2Nkb2VXZjZyT0M3YmhDQ20xeERHWTNleXlrMmlQSEZ2MkJT?=
 =?utf-8?B?bFJKbzN0NVlXRkJRVW9wc2dOdWdsc1lTSUFxSDFtc2RuOEcyQUtoMnBpN1NZ?=
 =?utf-8?B?SXEwdGFKcG9HSzdxbWpKbG8ydjF5WWFidGVSVXdhcVlBeHhCamhTUU9iajhO?=
 =?utf-8?B?Q1B6VXlJYW9MMkJOZkNiNGdlc2RheEFaMkhTTzlEZlZEQW05OSt5QXhyend6?=
 =?utf-8?B?M0RFR013YU50N0JXdXhoTS9nMjRmdVhMR2VkOEtVSUU3NHBBMkF5NVR1NnZo?=
 =?utf-8?B?TWZsOWpjdFJlc016alc3dUZFZk9IYTZqRUdKa1FwZUZJTlJuUCsxU1pLbXZL?=
 =?utf-8?B?NUx0Tm05a2lDbU12SElOeEJwZ2Y0UWFHQ3prZFBNRkwvK29ma0EwUDdSbTB4?=
 =?utf-8?B?UW0rTksxOVdaL2F6VXZvOVFmSlEvYnIvUVVINzJhUjU5b0tyUEgzSnA0MGZZ?=
 =?utf-8?B?VDV5dVIvUXNHWGhNdkZ2OVBzWWJBMzVneG1UMHBEbHc5UEdhM2ppTVRiV1ZI?=
 =?utf-8?B?WkpCVW5oM1ZIbCtlVjFEZVltYXovNE5pRloxaUk5dENhS1l0SG1LWE4vVVg2?=
 =?utf-8?B?dUtKUEcvN2ttdXZTbWh1RE1xZ0FhV0Q1N01BOHl0azljbTVMakpOcnd2OVpx?=
 =?utf-8?B?ZGFUVjFJbFlmbGE1ellMZEpCTDlTbWJwRzVOSFpnemx0U09vS25IcTZBdGNZ?=
 =?utf-8?B?R05nRmg1anU4VFpMTjAvNjNjQ05kNlpkdElzMzZxUWM3S3IwYlpMeUFXVFJW?=
 =?utf-8?B?aVlReEdyNm8waUFQL0txRmg4WUJNZk5RQXRlUVB5ZUpnRnRrVEorZTdBNHRZ?=
 =?utf-8?B?ZDgyaEVDM3pJazFvbXBuWkZJODFLOFl0b2k0RHlMc25DU2I3dVMvREF0Sktv?=
 =?utf-8?B?NStFSGNEZytldVVDZWVWUmtxajRjR2VaYldQMDFCR01iaHJMaklDRzRDL2tJ?=
 =?utf-8?B?ckk0MXBLZFZwTUgxSzlhNnRmNzV4VUtNcVVGOEZtd0VaWHNEbFV3YU1ib0Qy?=
 =?utf-8?B?OS9HbWM2VmViYUtkTTZpdzNCRU9WSTA5VGh4ZzQ2Uk05NVJHTVNEUVpsdlgv?=
 =?utf-8?B?VEJFTjg2a0RhcjUwckROa1FGNjFlREZ6cFUxWTVNZmJQVWR5OXQvTzA2MTU0?=
 =?utf-8?B?OWVoMk9GUU5hY0wycENuOHVTOXQ1bXR5R2FaaHJQL2dSWHVIWXg4enBlREV3?=
 =?utf-8?B?MXZJa3Q1K2ZzN0hRSm84c0FFNUlSSE1iS3Q1aGdJSkc5L2RkTUEzVDZFUWxt?=
 =?utf-8?B?WFhYbHBIU2tVMjg0UnFkZ1ZvYUhvQzRxa1pBNEo1Uml0dFV3NmNiSmpDdXdY?=
 =?utf-8?B?dXVPTkNVL2dVY2c4YU5SUzlWRUV1eFlOM254TjQ4M3c1dlRiZFUxMzh5aXoy?=
 =?utf-8?B?Sm1nYTdEd0NnYzMzd0dEVklWcWlCSjBFeEhTOEN2YTh5REZld3Z1SVdpZHB4?=
 =?utf-8?B?VGdHa3hnSUR6VkNDckRBUmpINVhuTDVuV2dBaDc0Yk5ISmNMS1M0SE93OExJ?=
 =?utf-8?B?NGNhN1BWeGxJT3g1UWE5N2N3SjA1TmloSlo0WUtEQURacDlkWHJnalJEZnU4?=
 =?utf-8?B?aVkwQ21IMlE3cytVMGFBeG56Y2tGUWJVQkpVTDAyUTd1WWdzeERmSHpQaEpo?=
 =?utf-8?B?VmZCTnhLWWRTZ3VBT3orZVlrOW5UM1NKYXFRYUxFYzNGdnYxVXQwemhvR1ox?=
 =?utf-8?B?RXFONUFOVDgzaUtVaWNBc3ZYYmplMlA1LzJUdEFzRHF2RUJaMkI1bW96YzBD?=
 =?utf-8?B?QjJIOE1OSFhhUTlYaGFEMHdNYVVlTU15Z25YcDRvZWVVQzA0R3VWNzZqVmNR?=
 =?utf-8?B?R1hqVng3TGM4MVJHNElHK1pmN0RoKzVrc3QrSnRDaWNqdnJPWFMzejhpdTB5?=
 =?utf-8?B?NXZCMXphMEJOWjRWWUFIeFBzTW1pU2VyUStrVWZHSFdsSThSc0xzUUJueXpS?=
 =?utf-8?Q?SvXxZULC/mLxdNGYliji2hflrB0DVO0/EiccczJ3YQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <442BDC3B10433646AD1ECF85CDB3C2F7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ef0b559-2df9-4537-ffc5-08d9ebf0870e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 17:20:53.9127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +ZGTXex28dAgQ+EklJ8moww1Re/xwIFpJ/r1ShHNetMXmFtTGz6+AbfNLcAMYMb/TtNcg6XJ98/BwBUvdmUasa6EqyF2EjIvjyy8KmfeohA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1249
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTAyLTA5IGF0IDA5OjEzICswMTAwLCBLdXJ0IEthbnplbmJhY2ggd3JvdGU6
DQo+IEhpIFRvbnksDQo+IA0KPiBPbiBUdWUgRmViIDA4IDIwMjIsIEpha3ViIEtpY2luc2tpIHdy
b3RlOg0KPiA+IE9uIE1vbizCoCA3IEZlYiAyMDIyIDE1OjMyOjQ0IC0wODAwIFRvbnkgTmd1eWVu
IHdyb3RlOg0KPiA+ID4gQ29yaW5uYSBWaW5zY2hlbiBzYXlzOg0KPiA+ID4gDQo+ID4gPiBGaXgg
dGhlIGtlcm5lbCB3YXJuaW5nICJNaXNzaW5nIHVucmVnaXN0ZXIsIGhhbmRsZWQgYnV0IGZpeA0K
PiA+ID4gZHJpdmVyIg0KPiA+ID4gd2hlbiBydW5uaW5nLCBlLmcuLA0KPiA+ID4gDQo+ID4gPiDC
oCAkIGV0aHRvb2wgLUcgZXRoMCByeCAxMDI0DQo+ID4gPiANCj4gPiA+IG9uIGlnYy7CoCBSZW1v
dmUgbWVtc2V0IGhhY2sgZnJvbSBpZ2IgYW5kIGFsaWduIGlnYiBjb2RlIHRvIGlnYy4NCj4gPiAN
Cj4gPiBXaHkgLW5leHQ/DQoNCkFzIHRoZSBvcmlnaW5hbCBzdWJtaXNzaW9uIHdhcyB0YXJnZXRp
bmcgLW5leHQsIEkgY2FycmllZCB0aGF0IGZvcndhcmQuDQpTaW5jZSB0aGUgd2FybmluZyBzYWlk
IGl0IHdhcyBoYW5kbGVkLCBJIHRob3VnaHQgaXQgd2FzIG9rIHRvIGdvIHRoZXJlLg0KDQo+IENh
biB3ZSBnZXQgdGhlc2UgcGF0Y2hlcyBpbnRvIG5ldCwgcGxlYXNlPyBUaGUgbWVudGlvbmVkIGln
YyBwcm9ibGVtDQo+IGV4aXN0cyBvbiB2NS4xNS1MVFMgdG9vLg0KDQpJJ2xsIGZvbGxvdyB0aGUg
aWdjIHBhdGNoIGFuZCBzdWJtaXQgYSByZXF1ZXN0IHRvIHN0YWJsZSB3aGVuIGl0IGhpdHMNCkxp
bnVzJyB0cmVlLiBGb3IgaWdiLCBhcyBpdCBzb3VuZHMgbGlrZSB0aGluZ3MgYXJlIHdvcmtpbmcs
IGp1c3Qgbm90DQp3aXRoIHRoZSBwcmVmZXJyZWQgbWV0aG9kLCBzbyBJIGRvbid0IHBsYW4gb24g
c2VuZGluZyB0aGF0IHRvIHN0YWJsZS4NCk9yIGlzIHRoZXJlIGFuIGlzc3VlIHRoZXJlIHRoYXQg
dGhpcyBwYXRjaCBuZWVkcyB0byBnbyB0byBzdGFibGUgYXMNCndlbGw/DQoNClRoYW5rcywNClRv
bnkNCg0KPiBGV0lXLCBUZXN0ZWQtYnk6IEt1cnQgS2FuemVuYmFjaCA8a3VydEBsaW51dHJvbml4
LmRlPg0KPiANCj4gVGhhbmtzLA0KPiBLdXJ0DQoNCg==
