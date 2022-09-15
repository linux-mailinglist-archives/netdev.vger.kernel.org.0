Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132135B968F
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiIOIpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiIOIpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:45:53 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BFD8E0C8
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 01:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663231552; x=1694767552;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HrzkyhFBtKxz1cnf+vTBg5B7C321fu1BYTewgexLEYs=;
  b=BN4OhZeD8kFXZ8M0dB+jJPB/icVadMnzPkL2pQkgX2hZjqfdMxAMlofe
   vqxP2iXaw7kmaWvO+85CssogqfavRr3QqeSeUnAjNvDA/h2bIKk0ScCkN
   9naFeiARWMb4sK7Z25xHmEmvQXI4UCL1a+yQpKyEdG2ac2zUzoDkf5iqB
   tI39uz2+pdhCxg8Mq+Mvio1vp2WKh6jO2vzMm1BoC09kkwUHcBUdc66CY
   2gbtLrYFwfDHoY8IvxCLMPP5CFYp74mjcktILTk6cyJQaPl/6VOZ01qqv
   c4n/Zi/e6qvVp8upg1m20DVJ0IEHAyX+ZcaXJnxQEwnmSS6rllFi+RvE+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="298651403"
X-IronPort-AV: E=Sophos;i="5.93,317,1654585200"; 
   d="scan'208";a="298651403"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 01:45:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,317,1654585200"; 
   d="scan'208";a="720908977"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 15 Sep 2022 01:45:52 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 01:45:51 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 15 Sep 2022 01:45:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 15 Sep 2022 01:45:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOnpC2Np8N6y43QMfibqMY+KcNl6qvF+5wu5TmVFDmeHcqqcJLz78QoCxIE0Rb3ah5TY4Ls2MwwcYJ2tE7BW3zAaAYOVncNyy9bY1S20TaPZXTEbrMQmVFLfXI3UpIPkIWCwvWW9UGIAaLjNe3jm9ZbBoS9EQK7Or3yZvNxiFhAmBap0b/9GfW4tqmpiSYSnf7hzN7VFo/VzsNntJBOD4hN9BUH7+J42XpuAos+iSamE7+U8pASfNLyPvsrGG1LKMsFF7l3uS9+qw0mQSEGurQfWTGa/yyBK4nRKD2El6RwGf43dTJk8ItWzY/z/+fSV0bTHyv6razY3HfuFzquQhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HrzkyhFBtKxz1cnf+vTBg5B7C321fu1BYTewgexLEYs=;
 b=YawLXiFN6Nm/hPHKyfj/XokWrJxlAbDK/WNI7dHXzeA7gAKTEtWQ3d9bCk3GWbQIu+YMZ92+hvn4k65M0lrY120TWbLvEsTKoHDF+SCBcfK1ECoaNaJN9vGvorNhMmMKySRqzeuU9gFg+4joJK8CHWkUGtCBVYK2ZjO1lVXOmhKcxIDXXb/m25aFA/MlBmnVBup62Zz7oCC2UBtWISmPWEJunHxd5zEDSOJ0b5SjhSJ9hDW31C1Yu9mgAxq+Ov4WTmo9QJFxeqR1k4fKrOq7+3H73XFHGExa7RTjO6WnNOqoPKi22ToZ9cOlQTBlGVnuE3YByeIC+UDc/mr9ugkbWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 08:45:49 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::95e3:8cbb:2a7b:ae51]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::95e3:8cbb:2a7b:ae51%7]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 08:45:49 +0000
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next PATCH v2 0/4] Extend action skbedit to RX queue mapping
Thread-Topic: [net-next PATCH v2 0/4] Extend action skbedit to RX queue
 mapping
Thread-Index: AQHYwyBaPBOhs3BGO0uGs2JDALv3X63VqNIAgAEg6xCAAKXGgIAIw/vQ
Date:   Thu, 15 Sep 2022 08:45:49 +0000
Message-ID: <MWHPR11MB1293428E17B99FBD3CBF4A87F1499@MWHPR11MB1293.namprd11.prod.outlook.com>
References: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
 <CAKgT0UcCrEAfiEi-EVkXAmZxdyD910yr2v54iYe3nzQdaX+6ng@mail.gmail.com>
 <MWHPR11MB12939CF44A137DD8349B1EB5F1439@MWHPR11MB1293.namprd11.prod.outlook.com>
 <CAKgT0UcierZArEiDZ2-8S8_gr2nwUZ3+3fJEAspGnbm13E_2Vw@mail.gmail.com>
In-Reply-To: <CAKgT0UcierZArEiDZ2-8S8_gr2nwUZ3+3fJEAspGnbm13E_2Vw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1293:EE_|IA1PR11MB6266:EE_
x-ms-office365-filtering-correlation-id: 2fa71058-8500-451b-d201-08da96f6b0ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dkaf6+OeSkdC+ei5bzwpITaKSuj+p5mRXDt4xQJgGbEc+WclrlAff9lFn9IretMc6ST+BkXEl8J9Vk9su6bPLOyg6GdlKNhfC8tjdfrX/OPaacMKIHjI1WHmOm+u8KubeFRXNmyDJDouQ5Tb6E9JsAkOUuv08dvfmaGemFLroPFiAS+r+q5bLUS6axu9FThuH0aCaosdmU5IXvDqaVVFVo0IfH8L8n+MfrnUIV4XJOOFKw4PIyudLUkMef/g+b80kn4QUnuCdUqnffaoyXRHiGJDwrYh176yo0tSaNlvlHozhQGQTykirTTDUa8+3yPtGwBBOGdjhivz4mpQV4/u8xc1+3IIFclTjtdJ751TUn7BuP1Hn0kV0prIh7egRwvA8skzMf2lDtCvSSuS0oHblurNL4yDYYEfOHGcFo9PiavTZiyXOIA/95Fqj7Z5pTsTL9VRoSFWGkxwRdbum2pP0olFoiL0BDan8sGYgkYu93LxV2hX0P+0jisHHv8pRejH68c1rgK07g5a7nVyMsVhK3M9I18RwSGz3TScM6SUIb7BspQAXGlpqqvL1Z545KTz1qebdWa0npoe0LP+m5n92MkqE9PzeETJdU62cCwhfwhutHQvZIC4uJd8lq52oc2kJaQMIZH3twYkn/c6+55XCvVy4jrGQEcrhieInSGLS8g0PKYp4MC81MnRhN5+uMb83MIwt9IxytIxdvImumX481V5eMGSQQsx9snyJ1usrLtuO86pHPYL2afTFbwO8qjtnkT5G90YNDQDfkbuYjR6V+p6WsmZqi7x4Zce7DlaI6VcVApjJHcyyX4DPIQX5AWeLDG8LUhswkoeHHdT29ynIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199015)(6916009)(2906002)(966005)(33656002)(5660300002)(66556008)(86362001)(107886003)(54906003)(8676002)(66446008)(478600001)(38070700005)(316002)(122000001)(55016003)(26005)(82960400001)(52536014)(4326008)(76116006)(8936002)(186003)(66476007)(71200400001)(41300700001)(9686003)(83380400001)(66946007)(53546011)(38100700002)(7696005)(64756008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUl2VHFic0daQVNSUmV1TS9iREZYbS9zL1MzelBmb1hWeWFRcjRGZzNTYTAx?=
 =?utf-8?B?YlFjdjZPekpYR3RZZ2l2TlpVRk1kdjJDZTRvM1lFZzl3T1RMWFFPMlBWZzRq?=
 =?utf-8?B?N0o4YXhSNmI4WnJrN1B5QkMvSGdwWElUMy9FbExISGxQU0JUOWV6TTRjeGZ4?=
 =?utf-8?B?L0dab2ZQeXRTdVk3Z01VQktWeTdqbURtTGJtSEJXdG4wL1VYZHdiTDhYNEFM?=
 =?utf-8?B?aUNRSkJRTnRUTXlKQ3VvM2U2cnhmMFJlZFNyemRNdUlleE5oQklEZWdnbXlY?=
 =?utf-8?B?VktEVmp5YXlIOEJ3N082QWdIYUw0OFdkekVaenFBdEY0T3h5dU9jZmRVNERT?=
 =?utf-8?B?M2FuZVg2N214eHQyL01YdHhIcHVlVFVpWFVla0xhVGhHN3Njb2xUeEcxVW5X?=
 =?utf-8?B?RHRCeDhqYTJyNTh2RzMrQkt5M2gzMGRiZmo4cE1ucU9lWlhSQWZKZzVCRVN5?=
 =?utf-8?B?YXJKMDdVVHZkUHhYSmlZTTNwTEoyMjNqR2FTZ2crYVhXNE51SG5ZUGM1ZFQ5?=
 =?utf-8?B?YkZXYlpicmwvemlmWEdJZEZHZUxKTWVjaUdOOU5IeDRVWndoVjBrSmZWaG8x?=
 =?utf-8?B?V0d4Y1RFTldJd0RrT1RoL1pTK3dkWE45NmRJTDhZQjluY2Z0REFlVlQrbUY5?=
 =?utf-8?B?VkFnN2JTY2Nvd3hnSGIvOFp3ZmcycWtLTHdoMmtCaE5Fa01zL2ZidXo5YTFi?=
 =?utf-8?B?dGlaSHY1LzJmNzRET05JZkNaaFVJVmVhS05wVVdneFpJWjhyQjBXRmE2MSs4?=
 =?utf-8?B?MmtSbmFsWmN4V3duK1VoSzg5Y3B6RHIrNTFPdDFLdUJBeVR3aVBtcTZ0UHFS?=
 =?utf-8?B?eDZZOUtXeGEzT1l2a0c1cFFza2J3RzBTYUtGZ24xcUZZY2UxWkN1cldUWEpz?=
 =?utf-8?B?RittQWRyaGMvOWJEem4xY3RXMGlaZDRUZjB0UGwvMkZobG1XUDlVT2RPbUNF?=
 =?utf-8?B?NGpUdk4yQnJXdFp5WTB4cHdHb0JlWVZjQWdkRGVWMUwyYkx2TlVOQVV6NytV?=
 =?utf-8?B?dnBMeDd6a1dIMEJBYTJINlhlQndOUWZXTno5NmJqY1dUREVWSmxpdFB0KzF6?=
 =?utf-8?B?SVp5ZS9SeUdqaWF6SklCdlpVcnNHZDkvOFR0dmFZQzRBNmV1L3NsU0R6QVUw?=
 =?utf-8?B?OU9xbVlST3lxVjQ5dGJ5UjlsaVoxOHU0VHE0ckQrOGVQZ2s5ckFpUjljQXBK?=
 =?utf-8?B?Yi9vaVErVTZEYjhVcXhLVXU1ODZKQ05LamtTbnFHZThXMTFyc2wvTDE5Snhl?=
 =?utf-8?B?NDN4Y0U2Z2FGazY5aUxzZ0kvcWRXUlhqY0Q2VVNzNERXTHlzL01UdlJDRU1h?=
 =?utf-8?B?OHVCNUd4RUFjNndCV0tGa050SDZzQldiOVZmR3E4N0tWaGoySTJQOU1WaVRt?=
 =?utf-8?B?clBaeGx1aWhxVkYwa1pWQjdORVNIakdna1BKUmZZVC9aVFdYaStDUXlwdXUz?=
 =?utf-8?B?V0gweDVFMVFGWkJMRXNqSlloQVQ2eGFoUWw0VHgrS2NEMSt4aUxoZ0h1UVZX?=
 =?utf-8?B?SG0yK0Y5bnYzTmN1WWZkVTh2Sk12emYxbU9yNFFYRVBBV243T1JLMFhoMjRa?=
 =?utf-8?B?OU5uRmhkajMyZmVRajJvRkxHOHNyaHpGMjR3Tlg4S2ttb1R3dXduNGZPcGw5?=
 =?utf-8?B?TjNpb1hLclVZZFFMVHJmY1FaeVpGdkFNbTA1ZUFTVXAvSHQ2VklqdmFQT05V?=
 =?utf-8?B?MUI3ZWhzcWlILys5cUZzZzN1NVJpczl1Mi8wcXdqNDJ2Mmg4UGtadEJqUWNU?=
 =?utf-8?B?c2ZZYzcwQUtnOTV6OWdGa2U0b2RPTlIwZ1B0Z2FFKzBERk0zVTA1T3Y4Y2Rp?=
 =?utf-8?B?STZUTVRsVk1PZWxHUm1ZZGYwbVlsRGZhMGFId3E0ZGlyOXlnSllrSlBOOFFz?=
 =?utf-8?B?VTZTdVVFSnk4Y3pkTnNsTUMvSUxqWkUwL3FNUjZZb2l2L29TaG9uSjkzbW1p?=
 =?utf-8?B?dzlPbnhaNGtXTzZDc1lYa3RsbWlaN1dteWZBYklvR1cvWHQ1L0xxRjlnQUxC?=
 =?utf-8?B?Z2FLcDBneE91bWhaTHZxNTNQZnRWbHBNNG1kKytURnBUTVZvYkI0S1FFYmo3?=
 =?utf-8?B?b2x6K0hwMGZUaHpVMDlWa05sbFF3MUJOVWtiM1VrVXZNbXBzSjdGSGFsYzh1?=
 =?utf-8?B?MTZrVXRRUGJUd3hSaVduRFpoaXVCakplZlVLSFA4WW1lL2tOMnBjVnRTMmVo?=
 =?utf-8?B?U0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa71058-8500-451b-d201-08da96f6b0ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 08:45:49.6205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vxkwwXs+99GU4gXuxeckteLGmFBDEHfBvSs5+hN0l+Bxghe1xeDGV6GnYtZCWylZ+l0wAb0EiO4U4j7MzNlTEBYDJ6L/Us6Uz/X/gmMdyjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6266
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGV4YW5kZXIgRHV5Y2sgPGFs
ZXhhbmRlci5kdXlja0BnbWFpbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgU2VwdGVtYmVyIDksIDIw
MjIgMTE6MzUgQU0NCj4gVG86IE5hbWJpYXIsIEFtcml0aGEgPGFtcml0aGEubmFtYmlhckBpbnRl
bC5jb20+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBrdWJhQGtlcm5lbC5vcmc7IGpo
c0Btb2phdGF0dS5jb207DQo+IGppcmlAcmVzbnVsbGkudXM7IHhpeW91Lndhbmdjb25nQGdtYWls
LmNvbTsgR29tZXMsIFZpbmljaXVzDQo+IDx2aW5pY2l1cy5nb21lc0BpbnRlbC5jb20+OyBTYW11
ZHJhbGEsIFNyaWRoYXINCj4gPHNyaWRoYXIuc2FtdWRyYWxhQGludGVsLmNvbT4NCj4gU3ViamVj
dDogUmU6IFtuZXQtbmV4dCBQQVRDSCB2MiAwLzRdIEV4dGVuZCBhY3Rpb24gc2tiZWRpdCB0byBS
WCBxdWV1ZQ0KPiBtYXBwaW5nDQo+IA0KPiBPbiBGcmksIFNlcCA5LCAyMDIyIGF0IDI6MTggQU0g
TmFtYmlhciwgQW1yaXRoYQ0KPiA8YW1yaXRoYS5uYW1iaWFyQGludGVsLmNvbT4gd3JvdGU6DQo+
ID4NCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBBbGV4YW5k
ZXIgRHV5Y2sgPGFsZXhhbmRlci5kdXlja0BnbWFpbC5jb20+DQo+ID4gPiBTZW50OiBUaHVyc2Rh
eSwgU2VwdGVtYmVyIDgsIDIwMjIgODoyOCBBTQ0KPiA+ID4gVG86IE5hbWJpYXIsIEFtcml0aGEg
PGFtcml0aGEubmFtYmlhckBpbnRlbC5jb20+DQo+ID4gPiBDYzogbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZzsga3ViYUBrZXJuZWwub3JnOyBqaHNAbW9qYXRhdHUuY29tOw0KPiA+ID4gamlyaUByZXNu
dWxsaS51czsgeGl5b3Uud2FuZ2NvbmdAZ21haWwuY29tOyBHb21lcywgVmluaWNpdXMNCj4gPiA+
IDx2aW5pY2l1cy5nb21lc0BpbnRlbC5jb20+OyBTYW11ZHJhbGEsIFNyaWRoYXINCj4gPiA+IDxz
cmlkaGFyLnNhbXVkcmFsYUBpbnRlbC5jb20+DQo+ID4gPiBTdWJqZWN0OiBSZTogW25ldC1uZXh0
IFBBVENIIHYyIDAvNF0gRXh0ZW5kIGFjdGlvbiBza2JlZGl0IHRvIFJYIHF1ZXVlDQo+ID4gPiBt
YXBwaW5nDQo+ID4gPg0KPiA+ID4gT24gV2VkLCBTZXAgNywgMjAyMiBhdCA2OjE0IFBNIEFtcml0
aGEgTmFtYmlhcg0KPiA+ID4gPGFtcml0aGEubmFtYmlhckBpbnRlbC5jb20+IHdyb3RlOg0KPiA+
ID4gPg0KPiA+ID4gPiBCYXNlZCBvbiB0aGUgZGlzY3Vzc2lvbiBvbg0KPiA+ID4gPg0KPiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMjA0MjkxNzE3MTcuNWIwYjJhODFAa2VybmVs
Lm9yZy8sDQo+ID4gPiA+IHRoZSBmb2xsb3dpbmcgc2VyaWVzIGV4dGVuZHMgc2tiZWRpdCB0YyBh
Y3Rpb24gdG8gUlggcXVldWUgbWFwcGluZy4NCj4gPiA+ID4gQ3VycmVudGx5LCBza2JlZGl0IGFj
dGlvbiBpbiB0YyBhbGxvd3Mgb3ZlcnJpZGluZyBvZiB0cmFuc21pdCBxdWV1ZS4NCj4gPiA+ID4g
RXh0ZW5kaW5nIHRoaXMgYWJpbGl0eSBvZiBza2VkaXQgYWN0aW9uIHN1cHBvcnRzIHRoZSBzZWxl
Y3Rpb24gb2YgcmVjZWl2ZQ0KPiA+ID4gPiBxdWV1ZSBmb3IgaW5jb21pbmcgcGFja2V0cy4gT2Zm
bG9hZGluZyB0aGlzIGFjdGlvbiBpcyBhZGRlZCBmb3IgcmVjZWl2ZQ0KPiA+ID4gPiBzaWRlLiBF
bmFibGVkIGljZSBkcml2ZXIgdG8gb2ZmbG9hZCB0aGlzIHR5cGUgb2YgZmlsdGVyIGludG8gdGhl
DQo+ID4gPiA+IGhhcmR3YXJlIGZvciBhY2NlcHRpbmcgcGFja2V0cyB0byB0aGUgZGV2aWNlJ3Mg
cmVjZWl2ZSBxdWV1ZS4NCj4gPiA+ID4NCj4gPiA+ID4gdjI6IEFkZGVkIGRvY3VtZW50YXRpb24g
aW4gRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nDQo+ID4gPiA+DQo+ID4gPiA+IC0tLQ0KPiA+ID4g
Pg0KPiA+ID4gPiBBbXJpdGhhIE5hbWJpYXIgKDQpOg0KPiA+ID4gPiAgICAgICBhY3Rfc2tiZWRp
dDogQWRkIHN1cHBvcnQgZm9yIGFjdGlvbiBza2JlZGl0IFJYIHF1ZXVlIG1hcHBpbmcNCj4gPiA+
ID4gICAgICAgYWN0X3NrYmVkaXQ6IE9mZmxvYWQgc2tiZWRpdCBxdWV1ZSBtYXBwaW5nIGZvciBy
ZWNlaXZlIHF1ZXVlDQo+ID4gPiA+ICAgICAgIGljZTogRW5hYmxlIFJYIHF1ZXVlIHNlbGVjdGlv
biB1c2luZyBza2JlZGl0IGFjdGlvbg0KPiA+ID4gPiAgICAgICBEb2N1bWVudGF0aW9uOiBuZXR3
b3JraW5nOiBUQyBxdWV1ZSBiYXNlZCBmaWx0ZXJpbmcNCj4gPiA+DQo+ID4gPiBJIGRvbid0IHRo
aW5rIHNrYmVkaXQgaXMgdGhlIHJpZ2h0IHRoaW5nIHRvIGJlIHVwZGF0aW5nIGZvciB0aGlzLiBJ
bg0KPiA+ID4gdGhlIGNhc2Ugb2YgVHggd2Ugd2VyZSB1c2luZyBpdCBiZWNhdXNlIGF0IHRoZSB0
aW1lIHdlIHN0b3JlZCB0aGUNCj4gPiA+IHNvY2tldHMgVHggcXVldWUgaW4gdGhlIHNrYiwgc28g
aXQgbWFkZSBzZW5zZSB0byBlZGl0IGl0IHRoZXJlIGlmIHdlDQo+ID4gPiB3YW50ZWQgdG8gdHdl
YWsgdGhpbmdzIGJlZm9yZSBpdCBnb3QgdG8gdGhlIHFkaXNjIGxheWVyLiBIb3dldmVyIGl0DQo+
ID4gPiBkaWRuJ3QgaGF2ZSBhIGRpcmVjdCBpbXBhY3Qgb24gdGhlIGhhcmR3YXJlIGFuZCBvbmx5
IHJlYWxseSBhZmZlY3RlZA0KPiA+ID4gdGhlIHNvZnR3YXJlIHJvdXRpbmcgaW4gdGhlIGRldmlj
ZSwgd2hpY2ggZXZlbnR1YWxseSByZXN1bHRlZCBpbiB3aGljaA0KPiA+ID4gaGFyZHdhcmUgcXVl
dWUgYW5kIHFkaXNjIHdhcyBzZWxlY3RlZC4NCj4gPiA+DQo+ID4gPiBUaGUgcHJvYmxlbSB3aXRo
IGVkaXRpbmcgdGhlIHJlY2VpdmUgcXVldWUgaXMgdGhhdCB0aGUgaGFyZHdhcmUNCj4gPiA+IG9m
ZmxvYWRlZCBjYXNlIHZlcnN1cyB0aGUgc29mdHdhcmUgb2ZmbG9hZGVkIGNhbiBoYXZlIHZlcnkg
ZGlmZmVyZW50DQo+ID4gPiBiZWhhdmlvcnMuIEkgd29uZGVyIGlmIHRoaXMgd291bGRuJ3QgYmUg
YmV0dGVyIHNlcnZlZCBieSBiZWluZyBhbg0KPiA+DQo+ID4gQ291bGQgeW91IHBsZWFzZSBleHBs
YWluIGhvdyB0aGUgaGFyZHdhcmUgb2ZmbG9hZCBhbmQgc29mdHdhcmUgY2FzZXMNCj4gPiBiZWhh
dmUgZGlmZmVyZW50bHkgaW4gdGhlIHNrYmVkaXQgY2FzZS4gRnJvbSBKYWt1YidzIHN1Z2dlc3Rp
b24gb24NCj4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMjA1MDMwODQ3MzIu
MzYzYjg5Y2NAa2VybmVsLm9yZy8sDQo+ID4gaXQgbG9va2VkIGxpa2UgdGhlIHNrYmVkaXQgYWN0
aW9uIGZpdHMgYmV0dGVyIHRvIGFsaWduIHRoZSBoYXJkd2FyZSBhbmQNCj4gPiBzb2Z0d2FyZSBk
ZXNjcmlwdGlvbiBvZiBSWCBxdWV1ZSBvZmZsb2FkIChjb25zaWRlcmluZyB0aGUgc2tiIG1ldGFk
YXRhDQo+ID4gcmVtYWlucyBzYW1lIGluIG9mZmxvYWQgdnMgbm8tb2ZmbG9hZCBjYXNlKS4NCj4g
DQo+IFNvIHNwZWNpZmljYWxseSBteSBjb25jZXJuIGlzIFJQUy4gVGhlIHByb2JsZW0gaXMgUlBT
IHRha2VzIHBsYWNlDQo+IGJlZm9yZSB5b3VyIFRDIHJ1bGUgd291bGQgYmUgYXBwbGllZCBpbiB0
aGUgc29mdHdhcmUgY2FzZSwgYnV0IGFmdGVyDQo+IGl0IGhhcyBiZWVuIGFwcGxpZWQgaW4gdGhl
IGhhcmR3YXJlIGNhc2UuIEFzIGEgcmVzdWx0IHRoZSBiZWhhdmlvcg0KPiB3aWxsIGJlIGRpZmZl
cmVudCBmb3Igb25lIHZlcnN1cyB0aGUgb3RoZXIuIFdpdGggdGhlIHJlZGlyZWN0IGFjdGlvbg0K
PiBpdCB3aWxsIHB1bGwgdGhlIHBhY2tldCBvdXQgb2YgdGhlIFJ4IHBpcGVsaW5lIGFuZCByZWlu
c2VydCBpdCBzbyB0aGF0DQo+IFJQUyB3aWxsIGJlIGFwcGxpZWQgdG8gdGhlIHBhY2tldCBhbmQg
aXQgd291bGQgYmUgcmVjZWl2ZWQgb24gdGhlIENQVXMNCj4gZXhwZWN0ZWQuDQo+IA0KDQpPa2F5
LCBzbyBJIHVuZGVyc3RhbmQgdGhhdCB3aXRob3V0IEhXIG9mZmxvYWQsIHRoZSBTVyBiZWhhdmlv
ciB3b3VsZA0Kbm90IGFsaWduIGZvciBSUFMsIGkuZS4sIFJQUyBDUFUgd291bGQgYmUgZnJvbSBh
IHF1ZXVlIChhbHJlYWR5IHNlbGVjdGVkDQpieSBIVywgUlNTIGV0Yy4pLCAgYW5kIG1heSBub3Qg
YWxpZ24gd2l0aCB0aGUgcXVldWUgc2VsZWN0ZWQgZnJvbQ0KdGhlIFNXIFRDIHJ1bGUuIEFuZCBJ
IHNlZSB5b3VyIHBvaW50LCB0aGUgc29sdXRpb24gdG8gdGhpcyB3b3VsZCBiZQ0KcmVpbnNlcnRp
bmcgdGhlIHBhY2tldCBhZnRlciB1cGRhdGluZyB0aGUgcXVldWUuIEJ1dCwgYXMgSSBsb29rIG1v
cmUgaW50bw0KdGhpcywgdGhlcmUgYXJlIHN0aWxsIHNvbWUgbW9yZSBjb25jZXJucyBJIGhhdmUu
DQoNCklJVUMsIHdlIG1heSBiZSBsb29raW5nIGF0IGEgcG90ZW50aWFsIFRDIHJ1bGUgYXMgYmVs
b3c6DQp0YyBmaWx0ZXIgYWRkIGRldiBldGhYIGluZ3Jlc3MgLi4uIFwNCmFjdGlvbiBtaXJyZWQg
aW5ncmVzcyByZWRpcmVjdCBkZXYgZXRoWCByeHF1ZXVlIDxyeF9xaWQ+DQoNCkl0IGxvb2tzIHRv
IG1lIHRoYXQgdGhpcyBjb25maWd1cmF0aW9uIGNvdWxkIHBvc3NpYmx5IHJlc3VsdCBpbiBsb29w
cw0KcmVjdXJzaXZlbHkgY2FsbGluZyBhY3RfbWlycmVkLiBTaW5jZSB0aGUgcmVkaXJlY3Rpb24g
aXMgZnJvbSBpbmdyZXNzDQp0byBpbmdyZXNzIG9uIHRoZSBzYW1lIGRldmljZSwgd2hlbiB0aGUg
cGFja2V0IGlzIHJlaW5zZXJ0ZWQgaW50byB0aGUNClJYIHBpcGVsaW5lIG9mIHRoZSBzYW1lIGRl
dmljZSwgUlBTIGFuZCB0YyBjbGFzc2lmaWNhdGlvbiBoYXBwZW5zIGFnYWluLA0KdGhlIHRjIGZp
bHRlciB3aXRoIGFjdCBtaXJyZWQgZXhlY3V0ZXMgcmVkaXJlY3RpbmcgYW5kIHJlaW5zZXJ0aW5n
IHRoZQ0KcGFja2V0IGFnYWluLiBhY3RfbWlycmVkIGtlZXBzIGEgQ1BVIGNvdW50ZXIgb2YgcmVj
dXJzaXZlIGNhbGxzIGZvciB0aGUNCmFjdGlvbiBhbmQgZHJvcHMgdGhlIHBhY2tldCB3aGVuIHRo
ZSBsaW1pdCBpcyByZWFjaGVkLiANCklmIHRoaXMgaXMgYSB2YWxpZCBjb25maWd1cmF0aW9uLCBJ
IGNhbm5vdCBmaW5kIGFueSBjb2RlIHRoYXQgcGVyaGFwcyB1c2VzDQphIGNvbWJpbmF0aW9uIG9m
IHNrYi0+cmVkaXJlY3QgYW5kIHNrYi0+ZnJvbV9pbmdyZXNzIHRvIGNoZWNrIGFuZA0KcHJldmVu
dCByZWN1cnNpdmUgY2xhc3NpZmljYXRpb24gKGZ1cnRoZXIgZXhlY3V0aW9uIG9mIFRDIG1pcnJl
ZCByZWRpcmVjdA0KYWN0aW9uKS4NCg0KQWxzbywgc2luY2UgcmVpbnNlcnRpbmcgdGhlIHBhY2tl
dCBhZnRlciB1cGRhdGluZyB0aGUgcXVldWUgd291bGQgZml4DQp0aGUgUlBTIGluY29uc2lzdGVu
Y3ksIGNhbiB0aGlzIGJlIGRvbmUgZnJvbSB0aGUgc2tiZWRpdCBhY3Rpb24gaW5zdGVhZA0Kb2Yg
bWlycmVkIHJlZGlyZWN0ID8gU28sIGlmIHNrYmVkaXQgYWN0aW9uIGlzIHVzZWQgZm9yIFJ4IHF1
ZXVlIHNlbGVjdGlvbiwNCm1heWJlIHRoaXMgc2VxdWVuY2UgaGVscHM6DQoNClJQUyBvbiBSWCBx
MSAtPiBUQyBhY3Rpb24gc2tiZWRpdCBSWCBxMiAtPiANCmFsd2F5cyByZWluc2VydCBpZiBhY3Rp
b24gc2tiZWRpdCBpcyBvbiBSWCAtPiBSUFMgb24gUlggcTIgLT4gDQpzdG9wIGZ1cnRoZXIgZXhl
Y3V0aW9uIG9mIFRDIGFjdGlvbiBSWCBza2JlZGl0DQoNCj4gPiA+IGV4dGVuc2lvbiBvZiB0aGUg
bWlycmVkIGluZ3Jlc3MgcmVkaXJlY3QgYWN0aW9uIHdoaWNoIGlzIGFscmVhZHkgdXNlZA0KPiA+
ID4gZm9yIG11bHRpcGxlIGhhcmR3YXJlIG9mZmxvYWRzIGFzIEkgcmVjYWxsLg0KPiA+ID4NCj4g
PiA+IEluIHRoaXMgY2FzZSB5b3Ugd291bGQgd2FudCB0byBiZSByZWRpcmVjdGluZyBwYWNrZXRz
IHJlY2VpdmVkIG9uIGENCj4gPiA+IHBvcnQgdG8gYmVpbmcgcmVjZWl2ZWQgb24gYSBzcGVjaWZp
YyBxdWV1ZSBvbiB0aGF0IHBvcnQuIEJ5IHVzaW5nIHRoZQ0KPiA+ID4gcmVkaXJlY3QgYWN0aW9u
IGl0IHdvdWxkIHRha2UgdGhlIHBhY2tldCBvdXQgb2YgdGhlIHJlY2VpdmUgcGF0aCBhbmQNCj4g
PiA+IHJlaW5zZXJ0IGl0LCBiZWluZyBhYmxlIHRvIGFjY291bnQgZm9yIGFueXRoaW5nIHN1Y2gg
YXMgdGhlIFJQUw0KPiA+ID4gY29uZmlndXJhdGlvbiBvbiB0aGUgZGV2aWNlIHNvIHRoZSBiZWhh
dmlvciB3b3VsZCBiZSBjbG9zZXIgdG8gd2hhdA0KPiA+ID4gdGhlIGhhcmR3YXJlIG9mZmxvYWRl
ZCBiZWhhdmlvciB3b3VsZCBiZS4NCj4gPg0KPiA+IFdvdWxkbid0IHRoaXMgYmUgYW4gb3Zlcmtp
bGwgYXMgd2Ugb25seSB3YW50IHRvIGFjY2VwdCBwYWNrZXRzIGludG8gYQ0KPiA+IHByZWRldGVy
bWluZWQgcXVldWU/IElJVUMsIHRoZSBtaXJyZWQgcmVkaXJlY3QgYWN0aW9uIHR5cGljYWxseSBt
b3Zlcw0KPiA+IHBhY2tldHMgZnJvbSBvbmUgaW50ZXJmYWNlIHRvIGFub3RoZXIsIHRoZSBmaWx0
ZXIgaXMgYWRkZWQgb24gaW50ZXJmYWNlDQo+ID4gZGlmZmVyZW50IGZyb20gdGhlIGRlc3RpbmF0
aW9uIGludGVyZmFjZS4gSW4gb3VyIGNhc2UsIHdpdGggdGhlDQo+ID4gZGVzdGluYXRpb24gaW50
ZXJmYWNlIGJlaW5nIHRoZSBzYW1lLCBJIGFtIG5vdCB1bmRlcnN0YW5kaW5nIHRoZSBuZWVkDQo+
ID4gZm9yIGEgbG9vcGJhY2suIEFsc28sIFdSVCB0byBSUFMsIG5vdCBzdXJlIEkgdW5kZXJzdGFu
ZCB0aGUgaW1wYWN0DQo+ID4gaGVyZS4gSW4gaGFyZHdhcmUsIG9uY2UgdGhlIG9mZmxvYWRlZCBm
aWx0ZXIgZXhlY3V0ZXMgdG8gc2VsZWN0IHRoZSBxdWV1ZSwNCj4gPiBSU1MgZG9lcyBub3QgcnVu
LiBJbiBzb2Z0d2FyZSwgaWYgUlBTIGV4ZWN1dGVzIGJlZm9yZQ0KPiA+IHNjaF9oYW5kbGVfaW5n
cmVzcygpLCB3b3VsZG4ndCBhbnkgdGMtYWN0aW9ucyAobWlycmVkIHJlZGlyZWN0IG9yIHNrYmVk
aXQNCj4gPiBvdmVycmlkaW5nIHRoZSBxdWV1ZSkgYmVoYXZlIGluIHNpbWlsYXIgd2F5ID8NCj4g
DQo+IFRoZSBwcm9ibGVtIGlzIHRoYXQgUlBTICE9IFJTUy4gWW91IGNhbiB1c2UgdGhlIHR3byB0
b2dldGhlciB0byBzcHJlYWQNCj4gd29yayBvdXQgb3ZlciBhIGdyZWF0ZXIgc2V0IG9mIHF1ZXVl
cy4gU28gZm9yIGV4YW1wbGUgaW4gYSBOVU1BIHN5c3RlbQ0KPiB3aXRoIG11bHRpcGxlIHNvY2tl
dHMvbm9kZXMgeW91IG1pZ2h0IHVzZSBSU1MgdG8gc3BsaXQgdGhlIHdvcmsgdXANCj4gaW50byBh
IHBlci1ub2RlIHF1ZXVlKHMpLCBhbmQgdGhlbiB1c2UgUlBTIHRvIHNwbGl0IHVwIHRoZSB3b3Jr
IGFjcm9zcw0KPiBDUFVzIHdpdGhpbiB0aGF0IG5vZGUuIElmIHlvdSBwaWNrIGEgcGFja2V0IHVw
IGZyb20gb25lIGRldmljZSBhbmQNCj4gcmVkaXJlY3QgaXQgdmlhIHRoZSBtaXJyZWQgYWN0aW9u
IHRoZSBSUFMgaXMgYXBwbGllZCBhcyB0aG91Z2ggdGhlDQo+IHBhY2tldCB3YXMgcmVjZWl2ZWQg
b24gdGhlIGRldmljZSBzbyB0aGUgUlBTIHF1ZXVlIHdvdWxkIGJlIGNvcnJlY3QNCj4gYXNzdW1p
bmcgeW91IHVwZGF0ZWQgdGhlIHF1ZXVlLiBUaGF0IGlzIHdoYXQgSSBhbSBsb29raW5nIGZvci4g
V2hhdA0KPiB0aGlzIHBhdGNoIGlzIGRvaW5nIGlzIGNyZWF0aW5nIGEgc2l0dWF0aW9uIHdoZXJl
IHRoZSBlZmZlY3QgaXMgdmVyeQ0KPiBkaWZmZXJlbnQgYmV0d2VlbiB0aGUgaGFyZHdhcmUgYW5k
IHNvZnR3YXJlIHZlcnNpb24gb2YgdGhpbmdzIHdoaWNoDQo+IHdvdWxkIGxpa2VseSBicmVhayB0
aGluZ3MgZm9yIGEgdXNlIGNhc2Ugc3VjaCBhcyB0aGlzLg0K
