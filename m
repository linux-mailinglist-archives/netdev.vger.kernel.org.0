Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CD85A0090
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 19:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240245AbiHXRkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 13:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiHXRkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 13:40:14 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E3532EDC
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 10:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661362813; x=1692898813;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TP3AifdRA+rPBavcKfJ2Wam0iJMfZSCtaZAsU+mAKKg=;
  b=L8orJ7E5d2kvTwmWexkxFLj5bi3lCty6uAgJj0D4loeIrF7Q4uF2CC1l
   kFZfyzpIVpZAeytUxICULyj72SSHboHGJw0J65RgbqX4yn4NSxBfhn8zp
   EUuNKuNNuAomxtcAx5n263CNY1KDv1hfRPx4mK2fmA5j0D5Cr2T6cxZGx
   ssSKwmCtSEhwFwgl8y8nV8ZnV9rwBIx8EgEIgeRXbc+E7mGP9kqq6XvVo
   QJ/V2rbdziuIDZSuWrBAy72yn5mYxAYnl1HAUjVKJcBJVWSF5PSh1Yvp4
   dX1ObthT3SQrcjEBCJ2fBRkf8WSOmFGGEXZ0RxkTg2dkFcawi5Zq3KS9t
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="355756916"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="355756916"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 10:40:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="678134131"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 24 Aug 2022 10:40:10 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 10:40:10 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 10:40:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 24 Aug 2022 10:40:10 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 24 Aug 2022 10:40:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgdHi79v7GFejDbkwjXxn7AnXsx0R2kzYsgSxVGYVxRg2UByfDcysS874UWcwKwdYbP5BcNbZwOplYIWV2xMBp+6hBtRMtirrcLNAahIUsHGjHJNg0y55qZJcbFr/WBUI0ZHfIU7RhXRr1JOPxi5EPZy+eM4W1xEsuRZCKeX4TxXU06CBp97SyJow77DMdosFfrbZzzj2gfghZysOz0OmpCAPJ4/2RzdWuZsXPxH6FuDREMIiiw9HPZlgL6XerZyKWqO+Xtrai6UpR1aXaKaj9FTO5bB3gIb3K1elKsNMNl/ud//gL7KtZ2dZLvcOW/AvD5hVx452wVVXkMmQMlJzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TP3AifdRA+rPBavcKfJ2Wam0iJMfZSCtaZAsU+mAKKg=;
 b=Q5k8JqIdzBxszxiFIBGCXB7NTqyDewz9zN4sH1o8knEoXYSJFNAWBlsqNRktXeaTBSM4TJrecvCC83A3mtEoZ0ilsXQ8jkxKwjDRRmWJezRD0MH14KXNOvmh88xbWDfgKPNwU7IlYKG/gAkefCAwhLeZYputcH3tOAzR8+clIXS3X7mbRKeI6nVzO8Ag7p/RgyF6midwrZXXSB0+DI5+650e/maeuAIRIRZJCfMJr0eXgHktYUOwmqjSjEXCuYVsqwsqPEnMr7muK/GphJhGXD0HG3MlOodlLdU3UnntWPSeq7SLAfD60GCOz5fj3xUpBjMknP+jh5j88pNNXIRZAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MN2PR11MB3549.namprd11.prod.outlook.com (2603:10b6:208:e9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 24 Aug
 2022 17:40:07 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5566.014; Wed, 24 Aug 2022
 17:40:07 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Gal Pressman <gal@nvidia.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 0/2] ice: support FEC automatic disable
Thread-Topic: [PATCH net-next 0/2] ice: support FEC automatic disable
Thread-Index: AQHYtwG+vEC+zxF9EUaLIV60VfCCNK2+DsqAgABCJ9A=
Date:   Wed, 24 Aug 2022 17:40:07 +0000
Message-ID: <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
 <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
In-Reply-To: <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65f1c35a-266b-413d-57da-08da85f7af9d
x-ms-traffictypediagnostic: MN2PR11MB3549:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NPUlr0MB7OYV0zC0aGysHsfE5zK+/NsH6baSdEoxds0vUwjHc9ixkBjxhH1LlP7rtjE+soEpmPbIQMCXgilna+QCJWexY60iasu2CwXO18KIh/pW5hFq9myyDSKMGSrhW7iihOGXK+hcNlK18I92Lmydex6KPsnXTojPQP3GwPllnVve8rQF6bO3iGdqc7iybkzZNFV/DSEgaZz6s+6hxjQELk5saslpXTS27le0LoJ4Zm/Dvh+nA3b37KJ89SB8EysxOC0F95rD8rcC/b8uktXtuRYbojiAejaFjM+QXhvOqxhnVZ9XrW6yaCjuOfBh47R4Z2ZTDZ12KCHuUINU2iN7f/ECFOxpm60s7ADtp3Rwv0mq8sqsD9wfLfrGvV+kr+acBwTiUNhsM/QWlohgIxlBp452BrC0F0whv8Zs07F91G7cA/B/jZBGiaAg5xWwzqbIVa8xqGbloAGud2sPKZJXycR9e/5s3e2kBYqLTGbLCDR6GdQfDMG8O49liiFlZAaF1gEHZhBY1E3oHvy2XFVHfee2MR8Tj5h00eFKuHZxc5FZTnjfa0/bv2GZZOlGujHrfaqyYwCjdfWWTuaqyfQn/iM4frFXvcFqEGGfayIIK/jvAHICjQzHJM1308jF6w/TWqwNOeCbgsoc/IWfb/+6Pp4lh64+hcC43v3RO+PpDdYEsNl8QQV4Tk7ZxA2sgK69767gJ0AcYjOvs3ynk8qpnu4TEQksWIlDEzpw/Qy/IcItCWQ8T1q5R/Tw83gCFongfGEMrJQ3spTODt6DWQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(346002)(39860400002)(366004)(136003)(8676002)(4326008)(54906003)(316002)(6916009)(66476007)(66446008)(66946007)(76116006)(55016003)(52536014)(66556008)(64756008)(8936002)(2906002)(5660300002)(38100700002)(122000001)(33656002)(86362001)(41300700001)(38070700005)(82960400001)(53546011)(26005)(7696005)(6506007)(9686003)(478600001)(71200400001)(83380400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dmdFWGJVMkZDa2tZY2V0ZUlHN1A2M2pLdXA5dUlrUHE1dDJxbmdBUWExbmQz?=
 =?utf-8?B?NTcxbU5Ccm5jWUVrdFlycHU1SzVmSnBpRWVLSDBlWFB4Rm1rKzd6UmsyZlY5?=
 =?utf-8?B?MXk2aWNUTnN4U0pxSXZaMEJDeUdVRXFhTHZqdHN6ZXcvckdVQ2IwYzB1b1F6?=
 =?utf-8?B?R2MvMGRTVTBjTGZHUWlPMHNzRU1jYzAyUCtSTFhtMVBzSVc4L0xNNXdPOTM5?=
 =?utf-8?B?YjdwMlZST2lzbnF2NlU4VnVHNURBU2RoTlhBZWp5SXFpbkdIRVRDdmZXUEVo?=
 =?utf-8?B?WHZZc3hSNnY5N3h3UURCTXJjTGI3RmZBMEswTGlXeEV5aFJGTTM4MmhVK28r?=
 =?utf-8?B?ZGFlelVXcjNPMXViQWZpT0wvNXFvS0JSOFQyWjN6U3ZhNnZRNktWdzl4bDhE?=
 =?utf-8?B?MC9aQm1XVEdRaWNRU3pmUitwenU4Zjl0eTNRdmJJNlRpN2l5UlJYTVJIY2ND?=
 =?utf-8?B?VlYwcFZkaTF5eWZUb0prVXh3N2EzU3FhVHcyQzBHUTc4bnN3ZmNsUitIUnh3?=
 =?utf-8?B?WmpOWXRiYWh5bmtzUWt0aFErQm9YYkRkVVEvMVR4L2d1Ylp6eHN0emw4SUNJ?=
 =?utf-8?B?bVdxYWlkV1lRTnhOQUVnb3JnWmFuODFvcFVkNCtrS0N0WVgrYXcwV1VpZVJT?=
 =?utf-8?B?OGlCQk5GZGhCckl5QXExQXU0bzdQMjNXdW9pR1RDL3h6VDQ0N1cwN2NNc0I5?=
 =?utf-8?B?WmVaT1pNSlZiNk9MczJHU3hWeWxkTlpUdWQvRWN3Myt0QTF2RlIzN3A2eVh4?=
 =?utf-8?B?ajlDNW94clkrYWFJMEdTaWRjdCtZWGhXZ3pjVFozRlZ1ZENJU2JOZjJhMXRQ?=
 =?utf-8?B?d2dhRTZnWWROODA3ZVRteFBKTyszL3FWUyt0MlFCbTU1VHBnRGc0YUlBakNX?=
 =?utf-8?B?QWpZT3JOUi8xTno3TnhUSFR0S2JTYVJ5VnBZVTl2MWRaUVpTWEljQXFLNHFk?=
 =?utf-8?B?M3FETjM4ODlSWm44bFgrd3hmTmt5b29vejVsU0ttOFE2ckx1ZGNWNjJCVVZt?=
 =?utf-8?B?d1UrTm9ZcXhvVnhsem5BbkM4Q0djOHg1NlowaXJqS3U4N2FaT3dyL01BcmxG?=
 =?utf-8?B?OEZLQnE0eldDcTI3R0lLdG9RVWNuWjcyT0JwQnNUNmRyTzcxSXdVK3VZcE1W?=
 =?utf-8?B?SWEwTmZNMGthOUM4M3BBL1gvK1BITDlZeVBNVTZoK1p6SDhqcXpBZTcvbmlp?=
 =?utf-8?B?WStIZVArbG50STNwcXcrZjVFenN6VjhhY2VSejVjMlJtUkFEYjM2ZmlUL2Iy?=
 =?utf-8?B?TG1lWFo4M1U3Tk5XM25ZazB4dTZVSzdTYk9LSVVGOTB4WEQxeVY5MTlOTnhw?=
 =?utf-8?B?ZEh3VWV0MHAyNFcwM1duTi90MzQ1WjlCbFY4d3ZjOW9CenlGdjZBUGtJTzZO?=
 =?utf-8?B?empYeXl6WENxUXZ1eVZ1aXE1WksrVVVaVDA3UFpFT0lZS1ExcGcveFhybGtu?=
 =?utf-8?B?S1E2WkZnS3Y4dXE2VVJ5NVl6TVJVY0VtS1c4bDJHVlhKTEw0TWpZTG5uRnR5?=
 =?utf-8?B?ODNGRXN5RWY2Z1V0MWY3Vy9jL3FYM3FzRGFMNVVhcEJvdCtsOGQweVluQ1Zi?=
 =?utf-8?B?NnRmNVhaMnRLaFcrNkV6cU5pNUc0NElwRkoxSWRVNzMyNzBvYnYzNEZVbjhi?=
 =?utf-8?B?VDV2UHR3TmdHMVhmejlYUENqNEY4Qkcvb3VDMjdwNGs1Z0VjWTV0NzVUenpr?=
 =?utf-8?B?SkIxTncyUkZ5STdJbG8yTDRKRGVxKzhOcWtoR0VIeUdwbS83b1JybUZ1SHJT?=
 =?utf-8?B?QVlDditRZFpadGdJalRrWW92cDl2Y3JTOURwWjF4WVI3Rm0vN3Naa1MxNGc2?=
 =?utf-8?B?ZFpnNzNIdDYwbXNSazZRL1dPZkR0SXpmWndBSUgvcWs3SzBsUzNiT245bDl6?=
 =?utf-8?B?eG95WkhPNi9FL1duNXNrcVF4MklkSDZaZFBhUHVXeXRTNnBDNFFyMzdlSXFa?=
 =?utf-8?B?b2gzTnhvUCtBbitTYWZsRlgxSnUxc1V2cFJzT0s5bkoySVZxK2h4c0lZYjVB?=
 =?utf-8?B?ODhQQWd1ajhaR2M3OUkvRXhHenhkd1ZhOWpXaTd5UmxvSmQ2cS85c2RuQ3Zh?=
 =?utf-8?B?Ums4S0tZZG5jZG1WWkZqQVVYNFFvN2FiU1gwKy9Ybkl5VUFITkdYUENNeTdL?=
 =?utf-8?Q?whykF4ZneWu/vFL2RfHWHbxgS?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f1c35a-266b-413d-57da-08da85f7af9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 17:40:07.5462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qEFhLojsQEDFQngICv6U8hdGQw1RaKbHMgnRtpn/yvkhffwJUMP0g7xlSN5AX9H4YUFszx2qsHLmzqMap7vPmPbqrDYlDLEIXreMDX8VtJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3549
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR2FsIFByZXNzbWFuIDxn
YWxAbnZpZGlhLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBBdWd1c3QgMjQsIDIwMjIgNjozNiBB
TQ0KPiBUbzogS2VsbGVyLCBKYWNvYiBFIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQo+IENj
OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG52aWRpYS5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMC8yXSBpY2U6IHN1cHBvcnQgRkVD
IGF1dG9tYXRpYyBkaXNhYmxlDQo+IA0KPiBPbiAyMy8wOC8yMDIyIDE4OjA0LCBKYWNvYiBLZWxs
ZXIgd3JvdGU6DQo+ID4gMikgYWx3YXlzIHRyZWF0IEVUSFRPT0xfRkVDX0FVVE8gYXMgImF1dG9t
YXRpYyArIGFsbG93IGRpc2FibGUiDQo+ID4NCj4gPiAgIFRoaXMgY291bGQgd29yaywgYnV0IGl0
IG1lYW5zIHRoYXQgYmVoYXZpb3Igd2lsbCBkaWZmZXIgZGVwZW5kaW5nIG9uIHRoZQ0KPiA+ICAg
ZmlybXdhcmUgdmVyc2lvbi4gVXNlcnMgaGF2ZSBubyB3YXkgdG8ga25vdyB0aGF0IGFuZCBtaWdo
dCBiZSBzdXJwcmlzZWQgdG8NCj4gPiAgIGZpbmQgdGhlIGJlaGF2aW9yIGRpZmZlciBhY3Jvc3Mg
ZGV2aWNlcyB3aGljaCBoYXZlIGRpZmZlcmVudCBmaXJtd2FyZQ0KPiA+ICAgd2hpY2ggZG8gb3Ig
ZG9uJ3Qgc3VwcG9ydCB0aGlzIHZhcmlhdGlvbiBvZiBhdXRvbWF0aWMgc2VsZWN0aW9uLg0KPiAN
Cj4gSGkgSmFjb2IsDQo+IFRoaXMgaXMgZXhhY3RseSBob3cgaXQncyBhbHJlYWR5IGltcGxlbWVu
dGVkIGluIG1seDUsIGFuZCBJIGRvbid0IHJlYWxseQ0KPiB1bmRlcnN0YW5kIGhvdyBmaXJtd2Fy
ZSB2ZXJzaW9uIGlzIHJlbGF0ZWQ/IElzIGl0IHNwZWNpZmljIHRvIHlvdXINCj4gZGV2aWNlIGZp
cm13YXJlPw0KPiBNYXliZSB5b3UgY2FuIHdvcmthcm91bmQgdGhhdCBpbiB0aGUgZHJpdmVyPw0K
DQpGb3IgaWNlLCB0aGUgb3JpZ2luYWwgImF1dG8iIGltcGxlbWVudGF0aW9uICh3aGljaCBpcyBo
YW5kbGVkIGJ5IGZpcm13YXJlKSB3aWxsIGF1dG9tYXRpY2FsbHkgc2VsZWN0IGFuIEZFQyBtb2Rl
IGJhc2VkIG9uIHRoZSBtZWRpYSB0eXBlIGFuZCB1c2luZyBhIHN0YXRlIG1hY2hpbmUgdG8gZ28g
dGhyb3VnaCBvcHRpb25zIHVudGlsIGl0IGZpbmRzIGEgdmFsaWQgbGluay4NCg0KVGhpcyBpbXBs
ZW1lbnRhdGlvbiB3b3VsZCBuZXZlciBzZWxlY3QgIk5vIEZFQyIgKGkuZS4gRkVDX09GRikgZm9y
IGNlcnRhaW4gbW9kdWxlIHR5cGVzIHdoaWNoIGRvIG5vdCBsaXN0ICJObyBGRUMiIGFzIHBhcnQg
b2YgdGhlaXIgYXV0byBuZWdvdGlhdGlvbiBzdXBwb3J0ZWQgbGlzdC4gKERlc3BpdGUgdGhpcyBu
b3QgYWN0dWFsbHkgYmVpbmcgYXV0byBuZWdvdGlhdGlvbikuIFNvbWUgb2Ygb3VyIGN1c3RvbWVy
cyB3ZXJlIHN1cnByaXNlZCBieSB0aGlzIGFuZCBhc2tlZCBpZiB3ZSBjb3VsZCBjaGFuZ2UgaXQs
IHNvIG5ldyBmaXJtd2FyZSBoYXMgYW4gb3B0aW9uIHRvIGFsbG93IGNob29zaW5nICJObyBGRUMi
LiBUaGlzIGlzIGFuICJvcHQtaW4iIHRoYXQgdGhlIGRyaXZlciBtdXN0IHRlbGwgZmlybXdhcmUg
d2hlbiBzZXR0aW5nIHVwIEZFQyBtb2RlLiBUaGlzIG9idmlvdXNseSBpcyBvbmx5IGF2YWlsYWJs
ZSBvbiBuZXdlciBmaXJtd2FyZS4gR29pbmcgd2l0aCBvcHRpb24gMiB3b3VsZCByZXN1bHQgaW4g
ZGlmZmVyaW5nIGJlaGF2aW9yIGRlcGVuZGluZyBvbiB3aGF0IGZpcm13YXJlIGFuZCBkcml2ZXIg
eW91J3JlIHVzaW5nLg0KDQpJIHRob3VnaHQgdGhhdCB3YXMgYSBiaXQgY29uZnVzaW5nIHNpbmNl
IHVzZXJzcGFjZS91c2VycyB3b3VsZCBub3Qga25vdyB3aGljaCB2YXJpYW50IGlzIGluIHVzZSwg
YW5kIG15IHVuZGVyc3RhbmRpbmcgZnJvbSBvdXIgY3VzdG9tZXIgZW5naW5lZXJzIGlzIHRoYXQg
d2UgZG9uJ3Qgd2FudCB0byBjaGFuZ2UgdGhlIGJlaGF2aW9yIHdpdGhvdXQgYW4gZXhwbGljaXQg
cmVxdWVzdCBvZiBzb21lIGtpbmQuIFRoYXQncyB3aGVyZSB0aGUgb3JpZ2luYWwgcHJpdmF0ZSBm
bGFnIGNhbWUgZnJvbS4NCg0KQXMgZm9yIHdvcmtpbmcgYXJvdW5kIHRoaXMgaW4gdGhlIGRyaXZl
ciwgSSBhbSBub3Qgc3VyZSBob3cgZmVhc2libGUgdGhhdCBpcy4NCg0KPiANCj4gSSBmZWVsIGxp
a2Ugd2UncmUgZ29pbmcgdGhlIHdyb25nIHdheSBoZXJlIGhhdmluZyBkaWZmZXJlbnQgZmxhZ3MN
Cj4gaW50ZXJwcmV0YXRpb25zIGJ5IGRpZmZlcmVudCBkcml2ZXJzLg0KDQpJIHdvdWxkIHByZWZl
ciB0byBhdm9pZCB0aGF0IGFzIHdlbGwNCg0KVGhhbmtzLA0KSmFrZSANCg==
