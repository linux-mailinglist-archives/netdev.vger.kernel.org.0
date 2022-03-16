Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4264DB855
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 20:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351608AbiCPTC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 15:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbiCPTC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 15:02:26 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80E66CA4F
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 12:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647457271; x=1678993271;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fnil0tPH5h84rpq644iNjAjytoOs6cN+GZO7IEwerpQ=;
  b=HwnknLwHo7ZuzcaVCkLZ6dFv5A9nlJBwPmLYDKGjZI4o/6SuZmbgIy17
   mScH6b9QKF+5yjolL1TZhtSA5Wn9aOIAXotnv99laUy0EO8m5x8+j/pJC
   sGi1sUpHdtHBGHP4u6CAZFp1TRqgMlE2xptRrznljKsOhsyjzHFB9g3ok
   8fboGuNQdexULpnlkjY9InVyNkSTOkg5kIpVKALkkmC1OjfZloMSWVCWq
   JuqWNm56Hxy3C/H+9pwP1QVNN8NDhicLamPH62an/TM6BQmiychJRpTrP
   xtL9E3JEPXTdDZzJ+nncIxOqNsxpIm/BlFtenlhyUQyPt16fverve19UX
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="254247876"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="254247876"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 12:01:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="714732533"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 16 Mar 2022 12:01:11 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 12:01:10 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 12:01:10 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 16 Mar 2022 12:01:10 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 16 Mar 2022 12:01:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V193+iJr/LkBdMcl/iNhN1AJPpy7EwxDKLtvouAgg0fpfbptCiKskU1906dCMsAB1cDJ2kZiGXBovszAWq2MBHAWCa8B+kOsrhGBTp6BzyxZSe075DVk990N/+76Lk5UIpCYY1xzOIpy/tYXzXHcWYR9DTmEpls8gQWLx0n3R5g3n47YR7MkyJh3FPJ5fVAof6VD3fweL/NXmSM5h/03nDB/tw9RY83exHnMBb+qEfoNsZSuA0lMpnA7TTHNl64SF266VG9dPE4P+rWwJegM5YMO0n6uhqZFV9KNoEGBqZ0fiNVaryt4XJzCOSv9E4Eh9ofXYdKq6Q/2E8St/prjgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fnil0tPH5h84rpq644iNjAjytoOs6cN+GZO7IEwerpQ=;
 b=lbuhGMLSHIgiz769/wzoZR6O4S6obiwmS6nm7UFej6YMgitaOePCVcj5iq4+2EHn1CJsrgF33Aw1aP5dGgK+xqtq9941anqWt906Vt0XiCm3DVUUzEzU07085pkXK7my2Pk8Az3tK6+r3p5lj1UKdfruJADrZOtrJkDthAYkJo5t8qZ8jTE0aRecRs5nhHHZ/0QLTvDwq/hH/gK5QgyC9NIP5og1Q+OjBR4/FSa9CMa0Kt3Bh1ZIPgrwF4X6L0RjxwpXIxRctJI7AWbEcX9hGpCAnh3ngJd757CaO9tEE/RryUmyJ1IN5z66UWge9jG6Xfw4Z8pA537HIf1Uz/Drgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Wed, 16 Mar
 2022 19:00:39 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81%6]) with mapi id 15.20.5061.028; Wed, 16 Mar 2022
 19:00:39 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     lkp <lkp@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 1/3] ice: fix NULL pointer dereference in
 ice_update_vsi_tx_ring_stats()
Thread-Topic: [PATCH net 1/3] ice: fix NULL pointer dereference in
 ice_update_vsi_tx_ring_stats()
Thread-Index: AQHYOLFWWvcenh9sPUaY9fq4sztmfKzBWsKAgAEEPgA=
Date:   Wed, 16 Mar 2022 19:00:39 +0000
Message-ID: <e0d1a5caf1714f303ae89c909dfa4d04ebdde3e4.camel@intel.com>
References: <20220315211225.2923496-1-anthony.l.nguyen@intel.com>
         <20220315211225.2923496-2-anthony.l.nguyen@intel.com>
         <20220315202941.64319c5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315202941.64319c5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f4bfda8-130c-4b66-f9c9-08da077f435e
x-ms-traffictypediagnostic: DM4PR11MB5327:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM4PR11MB5327C520E804F0C422BC572EC6119@DM4PR11MB5327.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JqQ4ofymGT2lVPeh7I25EX1Wq4qKR4J3ho8/Lg29CqgGm6pgBhZpvTZD9At7CVNHJ5Jrhc+Pc7XQl8MoBR6FK+b6tNpc1Ob5TGsH32eC39DJxzZPpwkgGgUClsMGl5XRoHMFNZrpC1MxxITF6CLzV115ullQ/I29XJYbVDecwL8ykqIuOJuOWp3Wb9Mx0/039HUXPyCncWfe/d0aWs/fu+gppcrvGxvwoTCKv1I3SYl7i2Yh9hxuRq5MEAg9g/JtMHszRvGn0PWFrWFXiulozam588aP2bGF7VTN3EUktNnnavb9FzRKQ/l8zhWBytsLyjWaBfwMW9xzTm32VfOdFAliVPmeDYmVZIJ845E8VFqgEvG3E9DS2T8iSbWWG+K/o51jKdffSQsl15e8niUjcZglYEyAd4sveWpmyNNj0j9FejtMvOliaYqqulN7jDrFVaEyVnAvEvCRAhE4QkEHda4Vj72IF0Ov4GnQ8+eDHaWqYaxHXZ2u7yFo9ZbXXasbyKSMQ/L2ESBo1alRuz4L0yM9OvpIKISgyEeKAXs0MJNOw3mOGjJ4xE3ZtMb4Cuw8jnIL4dy1kxuBe7zwAVUoTd2dRtPW8asKnTWElMWr2R4/hpR6Cr2r0MJPB9SJFFw09mH+FPQtk/45Xf4zewNvGzl9eiZmMDPmiPP7M1dvxnNcw0vmW4kq5Nxwan5O7aGZj9rrzc3wz7ct2y2I0+VYg4t93QZr2+D+GhGSb0+Go9EaeYNoMTcNa8pEBHavLc6VtLcTQaM1t6zlTT2dLuMs1WCRCW5xFn7FSS5nyYnZTyY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(82960400001)(5660300002)(6506007)(8936002)(86362001)(38070700005)(71200400001)(83380400001)(54906003)(36756003)(110136005)(6486002)(66476007)(316002)(2906002)(508600001)(38100700002)(2616005)(107886003)(122000001)(76116006)(66946007)(91956017)(66556008)(966005)(64756008)(66446008)(6512007)(4326008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aFZaV0pWaE9TT0xGSndIa2RHQTU1d0VzK3JLa1h2ZHZHenZvanFMS1lzaVNj?=
 =?utf-8?B?OGQrSkNxeTlWYlBieE9udVlkODBmSjFpVVI5cy9Qcjd2bC9LTHQrd3o3N1BZ?=
 =?utf-8?B?ZHdJM3pxbGZvd3N5VUE5R2tVZzduUE9BRlFFRHRMcDBZSU9PWXJjRk9SZVB1?=
 =?utf-8?B?ejhNT2VTYk54ZG9xMUl5cWN3WDRVQ0crN05xWngrR3RlV09NMGMwdU9tS2JY?=
 =?utf-8?B?R3RIUUlhU1Q3VHI0WnBXWnk1dUlOVlB3QVU1SzdiaERVVWRMMUtEUHNESFVx?=
 =?utf-8?B?aEpJMmRIZ3pjdjBGbU5zVVEzNElSUm1nb0lBZmt5SUN4RDZGNktHdUs1RjRw?=
 =?utf-8?B?bWlYTzJvRnZndnhkNmhmVFZzQi9RUWRtb1ljNUlkbTRyNGdBdG9lUGtEd1lw?=
 =?utf-8?B?ZElSSVJEVG8vVkJuSzBiYkh2aXdhVG5tQ3VuTzN2dVBHNFM4M3ZkVjdDcjY5?=
 =?utf-8?B?ckFLQ0orK21SZHIxYThvckZheGNEb0RnYWZlczVCWnNxOEc1ZXY4bUU3WHk5?=
 =?utf-8?B?L3ZINVQ1UHlUNUROa2xIMDBhS3Rkb1pscXVpUWZvNTBlbEJNN1N4YmEwaGtX?=
 =?utf-8?B?dHpSOEIxbEVxNXFvSDdHN1EyUUdrL1k4N1d2Tm9VZExFVFNQTU1DUUw4aW5R?=
 =?utf-8?B?OW1KMjZRWDlvcFludVRUMjAzK3F5TitCbkxFaGxoL0Y5Q2JESDNiRTdDcWRy?=
 =?utf-8?B?SU9IK2t6RlpxYWhGSVdWMjRWeHhzRFl3emppL3V6OXVXbHFRVTJtMXh1M2JS?=
 =?utf-8?B?UXBUVUJVb0tTTzRvUnRRc2ZZUDljeHkzdXU5R2Q3MFBXUytpbHliMFFhYXRS?=
 =?utf-8?B?WkpHVWhVM01qcDc4cU9CbWxkbjRRVkJsbmFJL0M1WFloZ0x3STJYa1RkS3V5?=
 =?utf-8?B?STJ1U0JGYnlGQlFYSHZMZTFBV3hTUVVHVi81L3NKVm5xM1U4RXdONmJyRzV0?=
 =?utf-8?B?Um85dXdMdlhNbTh4QWFETUxiQUViTTNNTFJIOWZibWlXNkZwSVdjd3dONnE4?=
 =?utf-8?B?T3NBSTVZYVlvZFdHS1FlUTdWL01LNWZ2OGFDaDAyYzlaL2pFdmNzVDBRSFBM?=
 =?utf-8?B?bk9aMmVtd25HNHJJaFpEazdMME9abEdremdZbzVDVzBBZ0JFQzQ0WkhmYjV6?=
 =?utf-8?B?MUVyQnE3elhwbFNLS3dWK29UWFVSek43b2k2MWcyd2xrZlVvVHhiQXBOTTJm?=
 =?utf-8?B?bTdYV0JSUk9hbHRiSjNadE0wSTBueXZlMVpVSjdDQjRlVVJXaGJYcllxMUxW?=
 =?utf-8?B?blhlSDUyTWVNYkg3VFBsZzl2RnRuQWZsb1kvS1VTdU5oMGNIajA2QmZ1b1V2?=
 =?utf-8?B?dEtHeXVOYlE3ZkVnNEJXczBRaWR0QmxxWFlTdEF1R0NsS21SeHRidTRObUo0?=
 =?utf-8?B?ZzFwa2pXZktTdzhyL0ZsNFFyVVFnZWg4ZitvZ2lWVDlWUlp1aXZZV0FIWDFl?=
 =?utf-8?B?RTEzWTkwUXdCN0xtT0JQYW1vbnJtMUJuSCs5THpNRStEOC9HVEpVdi9tUTFv?=
 =?utf-8?B?TEwxeTE4b0NjRW43aVAxWlFTWUo3L3dvTGU5WEJiUEJ6bDJuSFVEN2lVdEcw?=
 =?utf-8?B?aFVHcCtZWkZKalZTaVk3c0d3NlZqZnd3NmpsSkZHejBVOWFoSWR6djlWcitH?=
 =?utf-8?B?ZFFNSlYzMlpyQjVuMnFsczJIdTNVZzBvOHNHU3d2ZEYxa3RqaDFGL2RKTHBR?=
 =?utf-8?B?MG9ZUWlmYi9RQWM2MnoxT3lHRDFFaTdYL0dRazBzUWZnUEdSTm9Lb3JnMjE2?=
 =?utf-8?B?dk9BSm9ucnlCYkJJYzFLbm1pNmN5SHFzRlFxRHl0QnZDV1dUQXdaM2ZRVExn?=
 =?utf-8?B?Y3FIMW56Tm1DRjVEZE5MK29XS3ZYRmtsK2xTd2xyNy9sSTZUQ2pTZjJxZzRP?=
 =?utf-8?B?VS9STEVkWVZiTG9CaTlsZ28rVk1seUtPQ25TTm11UlpjZWF0TXRSdTcyUHhT?=
 =?utf-8?B?dmU2aStRcURTdmpQTUw2UytoZEFrcmk0TVRndXRDZ3YzTVBwTFVRN2pYSEJR?=
 =?utf-8?Q?cuNOKdTtYMbBTi42Bt4tMkNOB5rUgQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3DA812B7A3C64438E539ADCD62948ED@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f4bfda8-130c-4b66-f9c9-08da077f435e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2022 19:00:39.7166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nFp4gZ/khScDZHKw7WPpIcAjex/PSnK5FfPnyLa9Poqqo6hfhunuxyHpYniMUUJF45qi3hQSC9MvmDdvm1E4uHJfxr67gQiSCKLd0ZuwE9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5327
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTAzLTE1IGF0IDIwOjI5IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAxNSBNYXIgMjAyMiAxNDoxMjoyMyAtMDcwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBGcm9tOiBNYWNpZWogRmlqYWxrb3dza2kgPG1hY2llai5maWphbGtvd3NraUBpbnRlbC5j
b20+DQo+ID4gDQo+ID4gSXQgaXMgcG9zc2libGUgdG8gZG8gTlVMTCBwb2ludGVyIGRlcmVmZXJl
bmNlIGluIHJvdXRpbmUgdGhhdA0KPiA+IHVwZGF0ZXMNCj4gPiBUeCByaW5nIHN0YXRzLiBDdXJy
ZW50bHkgb25seSBzdGF0cyBhbmQgYnl0ZXMgYXJlIHVwZGF0ZWQgd2hlbiByaW5nDQo+IA0KPiBz
L3N0YXRzL3BhY2tldHMvID8NCg0KV2lsbCBmaXguDQoNCj4gDQo+ID4gcG9pbnRlciBpcyB2YWxp
ZCwgYnV0IGxhdGVyIG9uIHJpbmcgaXMgYWNjZXNzZWQgdG8gcHJvcGFnYXRlDQo+ID4gZ2F0aGVy
ZWQgVHgNCj4gPiBzdGF0cyBvbnRvIFZTSSBzdGF0cy4NCj4gPiANCj4gPiBDaGFuZ2UgdGhlIGV4
aXN0aW5nIGxvZ2ljIHRvIG1vdmUgdG8gbmV4dCByaW5nIHdoZW4gcmluZyBpcyBOVUxMLg0KPiA+
IA0KPiA+IEZpeGVzOiBlNzJiYmEyMTM1NWQgKCJpY2U6IHNwbGl0IGljZV9yaW5nIG9udG8gVHgv
Unggc2VwYXJhdGUNCj4gPiBzdHJ1Y3RzIikNCj4gPiBSZXBvcnRlZC1ieToga2VybmVsIHRlc3Qg
cm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+ID4gUmVwb3J0ZWQtYnk6IERhbiBDYXJwZW50ZXIgPGRh
bi5jYXJwZW50ZXJAb3JhY2xlLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBNYWNpZWogRmlqYWxr
b3dza2kgPG1hY2llai5maWphbGtvd3NraUBpbnRlbC5jb20+DQo+ID4gQWNrZWQtYnk6IEFsZXhh
bmRlciBMb2Jha2luIDxhbGV4YW5kci5sb2Jha2luQGludGVsLmNvbT4NCj4gPiBUZXN0ZWQtYnk6
IEd1cnVjaGFyYW4gRyA8Z3VydWNoYXJhbnguZ0BpbnRlbC5jb20+IChBIENvbnRpbmdlbnQNCj4g
PiB3b3JrZXIgYXQgSW50ZWwpDQo+ID4gU2lnbmVkLW9mZi1ieTogVG9ueSBOZ3V5ZW4gPGFudGhv
bnkubC5uZ3V5ZW5AaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+IMKgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaWNlL2ljZV9tYWluLmMgfCA1ICsrKy0tDQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwg
MyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX21haW4uYw0KPiA+IGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9tYWluLmMNCj4gPiBpbmRleCA0OTM5NDJlOTEwYmUu
LmQ0YTdjMzlmZDA3OCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9pY2UvaWNlX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lj
ZS9pY2VfbWFpbi5jDQo+ID4gQEAgLTU5NjIsOCArNTk2Miw5IEBAIGljZV91cGRhdGVfdnNpX3R4
X3Jpbmdfc3RhdHMoc3RydWN0IGljZV92c2kNCj4gPiAqdnNpLA0KPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgdTY0IHBrdHMgPSAwLCBieXRlcyA9IDA7DQo+ID4gwqANCj4gPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJpbmcgPSBSRUFEX09OQ0UocmluZ3NbaV0p
Ow0KPiANCj4gTm90IHJlYWxseSByZWxhdGVkIHRvIHRoaXMgcGF0Y2ggYnV0IHdoeSBpcyB0aGVy
ZSBhIHJlYWRfb25jZSgpIGhlcmU/DQo+IEFyZW4ndCBzdGF0cyByZWFkIHVuZGVyIHJ0bmxfbG9j
az8gV2hhdCBpcyB0aGlzIHByb3RlY3RpbmcgYWdhaW5zdD8NCg0KSXQgbG9va3MgbGlrZSBpdCB3
YXMgYmFzZWQgb24gYSBwYXRjaCBmcm9tIGk0MGUgWzFdLiBGcm9tIHRoZSBjb21taXQsIEkNCmdh
dGhlciB0aGlzIGlzIHRoZSByZWFzb246DQoNCiJQcmV2aW91c2x5IHRoZSBzdGF0cyB3ZXJlIDY0
IGJpdCBidXQgaGlnaGx5IHJhY3kgZHVlIHRvIHRoZSBmYWN0IHRoYXQNCjY0IGJpdCB0cmFuc2Fj
dGlvbnMgYXJlIG5vdCBhdG9taWMgb24gMzIgYml0IHN5c3RlbXMuIg0KDQpUaGFua3MsDQoNClRv
bnkNCg0KWzFdDQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9uZXRkZXYvbmV0LW5leHQuZ2l0L2NvbW1pdC8/aWQ9OTgwZTliMTE4NjQyNGZhM2ViNzY2ZDU5
ZmM5MTAwM2QwZWQxZWQ2YQ0KDQoNCihSZXNlbmRpbmcgYXMgc29tZSBub24tdGV4dCBmb3JtYXR0
aW5nIHNudWNrIGluIHRvIG15IHJlcGx5LiBTb3JyeSBmb3INCnRoZSBzcGFtKQ0K
