Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AE75BA29D
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 00:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiIOWJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 18:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiIOWJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 18:09:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B846E1F614
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 15:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663279792; x=1694815792;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hsxFGI0fuaSF6MIJA11EMcyosOwNUUxb/iaz7S+d4So=;
  b=heHrc3O6hEl1HFBivFwWXLHtsdIPWBW1cuoaL47xkmYxrqnTZrITmxCE
   m7bKK8KeUrTLTs8j6giDxNlCqsKpWLU1IRPFrZp8xwqgVWAEX5skECMmP
   r/LTSh70KUkLlGRc51v3EHaNuYBHLWbGgYYiNExSbauWInqlyZ4Zm4N5x
   pbvesR5sQEfKbuy7egwUATiZM9+kmu5/uvHwyZclmrdy+4glXZYh7SHms
   24Tuhe+EIFmzdM9nUiTolkY5U/2ghOFBX8wxaOHjrXxYGFLB8D6evXe/Q
   txOFVHYVZlx5lkqIX9bZqMeGvyrxBU/DDYTmWWEev+Md1UPuJERqQXR/j
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="279233707"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="279233707"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 15:09:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="685902933"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 15 Sep 2022 15:09:46 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 15:09:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 15:09:45 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 15 Sep 2022 15:09:45 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 15 Sep 2022 15:09:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3CCR/9VsU82LeS6kxOxDx4jU2GquChphyP2lpPCtVWezR5sUlaVijQy0KotVuLDL28hM21ISCvKs9zXi4YdyCQD3ssWR/8IgFUASbDQBWcHZiSb6NY26nm36t/iawgIvI9DxAqLrKovv8tl/RhHMzko0tvqpSv7SlMmYNiaKq4qNwI/vJHL21iB/bXuPHgMinMnJDRtLNiAgnXVvMx7ypDLCiYz0GbzdQ5uwpCSFxyhpzPLl1nMgDnuim8pqpS5W8oqUutWU1H7Ob1qO9s6/RYcRF58Oa1Kh5HS7Nh9FD1rNs/IXPlyrRDe0J9BthhdKqQj8leyV0atqdZ6EYF9xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hsxFGI0fuaSF6MIJA11EMcyosOwNUUxb/iaz7S+d4So=;
 b=eYkXhS0dqxQVUKCOeGGJYJNnbKpjfJwPuW2LrkoHDPR9bQF3aqXhnDaciYutcQI7pRW5L/77BeRvBTDVPmlRYdE7gawHquTtVuPr8fFmZ3ACF8KoMGDwfEMdVhfDJL0Mdg4tVn8CFO8BKbBu/oQ8v4ASq8hFJTyiDGAQtMu+W+fJZrRtYfnnJ2C7DL64/6VTaYIfo2c8eU+R6txuBQdPvMRNFt/zr2Kq2MhBY9p8+zKfj+nB5InX/C1j3Z6j8nkVIaJ8lOqTeb9xulLTdfiVvKFYZ6e6DofFAoHE3XDDXizQoBXoyDZVeBsIl91/Pa1kyMQsZVFtABloWbnA5cMyxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by PH0PR11MB5048.namprd11.prod.outlook.com (2603:10b6:510:3d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Thu, 15 Sep
 2022 22:09:43 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::95e3:8cbb:2a7b:ae51]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::95e3:8cbb:2a7b:ae51%7]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 22:09:42 +0000
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
Thread-Index: AQHYwyBaPBOhs3BGO0uGs2JDALv3X63VqNIAgAEg6xCAAKXGgIAIw/vQgABz5ICAAFVfwA==
Date:   Thu, 15 Sep 2022 22:09:42 +0000
Message-ID: <MWHPR11MB1293DE4CD2757714FC469DECF1499@MWHPR11MB1293.namprd11.prod.outlook.com>
References: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
 <CAKgT0UcCrEAfiEi-EVkXAmZxdyD910yr2v54iYe3nzQdaX+6ng@mail.gmail.com>
 <MWHPR11MB12939CF44A137DD8349B1EB5F1439@MWHPR11MB1293.namprd11.prod.outlook.com>
 <CAKgT0UcierZArEiDZ2-8S8_gr2nwUZ3+3fJEAspGnbm13E_2Vw@mail.gmail.com>
 <MWHPR11MB1293428E17B99FBD3CBF4A87F1499@MWHPR11MB1293.namprd11.prod.outlook.com>
 <CAKgT0UdDk9em9h3MYDX=jzh7Bm9KWkTYx4raE=QuiszDoxf4Xw@mail.gmail.com>
In-Reply-To: <CAKgT0UdDk9em9h3MYDX=jzh7Bm9KWkTYx4raE=QuiszDoxf4Xw@mail.gmail.com>
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
x-ms-traffictypediagnostic: MWHPR11MB1293:EE_|PH0PR11MB5048:EE_
x-ms-office365-filtering-correlation-id: 78d4dda7-b329-41d2-2ad1-08da9766fdb1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /ooUoZJ93PQszlmZpWiy3xKA6cc8wd2c8Lh4ZcfFi83+O52OJ8KTBtVLCjayciNZw1bZiamIPyp6spa7hUr5F4UNDPU7vHAa9PL8EFDa5GbQSWBU7Gd8yoFBcypS9UqLh0+Q+Udg9kGRPHICQr43vlG2luuNZmcmseFX3ch8/PaLVetl7xKR4yqH2TFNtnlfQeU1ljwAN1ti88hvECTPxH0pIGuoLvulUjs5NN9GZ35ezhHGGec+1Oxp2XOJUHFUgwTlxs4RTxi+S/Ki+o11gdLfjQhPPnSadqoImm5Rgq2w2aHaWYjT/bNlG2+CCd1yh2m8Wd7RW35uS91ombvdPP3VxtScYNaw4FhmmMj8xf9MIesM6oYgtcCofek5b+O/AzHYf2kJjCoZt5c0Twi64e5atrYfU1PEfWcn7FEH9tHMGA4oKrNUAh/wjaKHFGkvbTXitxMFZ0qHhfT3tiE8biDcHZTqfQ3mE1sS5uVcodIEyRwEQku3qhGs/TyrlbDgKWsH+o51i8gRSEx1RkQ4UZTKaDlpBA90B1JcciZul01hRjKduIMf4Q5A7/SdVwOeN5599ZuPHeUKMolpaFqq9QvLhAmepPToI0L9drwCTB8r15yHoQJ29LkNc8LHghLVquWwxxlIHrrN5NZxHJq7+IJrLak76CG38/RQZ3D3O2YCm2zzWMZbwZLLivEQtt/NMKwzC6l23gEE0zqj9JuHOumGpR+7JSMx6GxQl95jdmjrCCKGtWC1OhEVoUlRH62x0ibXxyvjf1y81DindwHZMwEY6vIdqRY0lmi3qDWdBuEB7gn5PR7PUgVccTXhwtM25O+pHu+BE9AGc5xlsa+irQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(366004)(376002)(396003)(451199015)(86362001)(6916009)(54906003)(76116006)(33656002)(82960400001)(71200400001)(122000001)(38070700005)(83380400001)(186003)(38100700002)(9686003)(478600001)(966005)(66946007)(316002)(64756008)(8676002)(66446008)(107886003)(66476007)(66556008)(7696005)(6506007)(26005)(53546011)(41300700001)(8936002)(4326008)(5660300002)(2906002)(52536014)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWFQNmJ4Z0xITktVOUNkZnVrNE9UMHJSWDg1dUVkUDNrY29aV0lwVkJLZ1VF?=
 =?utf-8?B?WmJjSWdTNlpLY1ZOcGZIN1ZDSXpEdEZKNk1yVWZjK2dwaFNWa0lEcjBqZTVo?=
 =?utf-8?B?VmtYZnRVTHFSY1Rqb0xxYlBOclQwMDhaN3pVcFBmT2dHb0VuRTRhR1V3dmhC?=
 =?utf-8?B?MU53WUdIbWVHRFFOUUdLbitZYjRWZ0RYMnpRNHN6UDd5SFdUaDFOeDlWQzNB?=
 =?utf-8?B?aGgvN0htWkpqdVdMOGdwaXEzOTYwOXBuUzFMaEttQ3JsTXdFbXV6S0FLeGFX?=
 =?utf-8?B?TFdYdVgrRGFUT1Jtek5jRzNWM3c2NTdMODI4eTl2cnVoTGhYbEo1TVg2TSt3?=
 =?utf-8?B?Y2REcld3SGM0U2kxMjBQUWdRd3U4WXdmRmF5cVRxMzQ0MDUwR3QrcHRlUGdY?=
 =?utf-8?B?OGpjbmd5WFVDRzJzL1BWUWNGczNQdGVTUlFZdm0zV1YzRmxoOGJNV1RGT0hq?=
 =?utf-8?B?QUgzYzhhUE9Ec3EybEtoNFMrT1FoWWJPMm9GYVZTc2FXRkx6TmMzYjVOTDBW?=
 =?utf-8?B?SnFXM2I3SVU0RWh2V2tMSzBIblRMMUNSK0hESGJ4eFVubHpRWmpJSmVKWG96?=
 =?utf-8?B?RkVlT1VoTWRWbkEreVh5YVNJVEtjcURJenNYcVRVSjkveTNjbnluNHl5azFk?=
 =?utf-8?B?VHc1eWJWaFZyTVBXRy8yOGZKSXN4OE15elZJaEZjaFU3cEVzTmZtcWIxVkwv?=
 =?utf-8?B?RW1yY2FFVmdpbHkrZHU5UHYvb21NWlhQVWRtbXh2YXpvK1FQYm9KaDdZbWNI?=
 =?utf-8?B?eVhwMkw3NzFEbGRISHUrRE02c3hEV2VNVUhSSXdmb1dDTUVyR2hodC9FeElz?=
 =?utf-8?B?dHRtTE9rL3Bub0RDbmNtWGxIc0dhK3A0WjNUU2JFZUxKUnQ0ZTREMWJtSCtK?=
 =?utf-8?B?Sm5VTHk0TnVLN1ZSR2ltaGFQbXN3RUZudmczMkltaE5ac2gxNmplUGRLM1Ay?=
 =?utf-8?B?WE96SnZnLzY4a1U1NVpId3BlN3JFYTZ4OUhaMy9RamliWUtQTFAyZkcrUzR1?=
 =?utf-8?B?OTNNWWNWaWVUTU9oSXpBQmpFMmFLTy9Ea0hNZTVDMDBQYThLQWt5WENDQW9a?=
 =?utf-8?B?c1BlM21nVW9wSW00cXlJbnRTNTFEQjVSN2VkdUxzSHUwTktvQ2dxR202YW45?=
 =?utf-8?B?cHJMZFduVXM4ek9MczNvVUF1eUxTVENPOEN5VXhRM3hFLzdEWFNWdWtnSGMw?=
 =?utf-8?B?N3kvZDhoRFBUc0tvU1VLNmZkM1NIZ0lEZ0djZ3Z1cHAydmw3amNkNDNMVnZY?=
 =?utf-8?B?eXpxSmZ0MjlVZmcwUG1NNzFia2Q4UmVxWUhKQWpDUFk4dm5PSWE2QWdMS2dE?=
 =?utf-8?B?ZG5ma3BzSWlrV0tXT1BhbnhwRUoyZzEzTFRRanV2YTRrZDFZaEZjQnE1UEV6?=
 =?utf-8?B?YThwTzVPMjRTTmhUaGxBUTJNeGp2NDJURk9GUjc1M25NZm82UEhRcjdqVjAy?=
 =?utf-8?B?K3RTV21KRnhKck1oUUVyQWNUMnZ1Q0tmWGpWSTA0RnBOdkM5ckZhSkJMQ1lN?=
 =?utf-8?B?bkFoa2VEbkwxZEN6bHNMclQwMnRLQzZ6d2pYRHFtQzNsUm9KSnpqN3d3OWcv?=
 =?utf-8?B?OXVhNktZbmJUTVMyRGZuSW9xcVkwVHhmSUlyS2tsVGp6MEplRVljY3Fmc0U2?=
 =?utf-8?B?dkd5bjl4OGludEpOQjRzb2Zrd3hSVnB2SFlDd3NyczVlRkg5azhDMXdoNjg0?=
 =?utf-8?B?V2ovRHBFdFZpTVN4QmI3cjhMSVFDSnQ5TFdCNVJOa0JFU0RiVDYweS9lRVFr?=
 =?utf-8?B?NEpybWhyUG5Fc0U5dTJOSytHbTZZalI5aWFJYUNmOXk4ZXJndE5maEFRWTcv?=
 =?utf-8?B?d0hweThWZ2hHTzArei9kYzBmT05tZmQzMU1YV2hGazBmdnpkbzU5b3hKTWtS?=
 =?utf-8?B?czJBVHp3dnpVVGo2QTc5R0h5azU5Zy9sbnFlMjlvWElpdEY5QTBWY3lvTEtW?=
 =?utf-8?B?TEpGTEpjU0hQKzYwOWhraldjbmZWT2NRTE9uRHZtVmFqWUdLUzdKRjRONlM3?=
 =?utf-8?B?MjhjeVRKSUpZTVI2ZmpHeW5VZFEweVh3MVgwK3BGMUkvYWlySTNBK3JaRDcw?=
 =?utf-8?B?Y2xYaFlXeUxkRUNyREl2ZlBabEFIRE1vNUd6ZmFPYmMycUpMbTZJUGFtSFBu?=
 =?utf-8?B?UkhDdnNxMVFROGxFdCtSR3FzU21ob3ZqQUtScUNJZDRJZzF1NElwVm5hcThq?=
 =?utf-8?B?Mmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d4dda7-b329-41d2-2ad1-08da9766fdb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 22:09:42.4738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vnw1GXP7VhePdDD8aKwHdNTaDdM2WMCm1nnJmJYIOE798WizIXf51+id91I9KHlimpusnYpX29/hcuxBLRXWxVgvi1VtkPJQynh1zISPg60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5048
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGV4YW5kZXIgRHV5Y2sgPGFs
ZXhhbmRlci5kdXlja0BnbWFpbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBTZXB0ZW1iZXIgMTUs
IDIwMjIgODoyMSBBTQ0KPiBUbzogTmFtYmlhciwgQW1yaXRoYSA8YW1yaXRoYS5uYW1iaWFyQGlu
dGVsLmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGt1YmFAa2VybmVsLm9yZzsg
amhzQG1vamF0YXR1LmNvbTsNCj4gamlyaUByZXNudWxsaS51czsgeGl5b3Uud2FuZ2NvbmdAZ21h
aWwuY29tOyBHb21lcywgVmluaWNpdXMNCj4gPHZpbmljaXVzLmdvbWVzQGludGVsLmNvbT47IFNh
bXVkcmFsYSwgU3JpZGhhcg0KPiA8c3JpZGhhci5zYW11ZHJhbGFAaW50ZWwuY29tPg0KPiBTdWJq
ZWN0OiBSZTogW25ldC1uZXh0IFBBVENIIHYyIDAvNF0gRXh0ZW5kIGFjdGlvbiBza2JlZGl0IHRv
IFJYIHF1ZXVlDQo+IG1hcHBpbmcNCj4gDQo+IE9uIFRodSwgU2VwIDE1LCAyMDIyIGF0IDE6NDUg
QU0gTmFtYmlhciwgQW1yaXRoYQ0KPiA8YW1yaXRoYS5uYW1iaWFyQGludGVsLmNvbT4gd3JvdGU6
DQo+ID4NCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBBbGV4
YW5kZXIgRHV5Y2sgPGFsZXhhbmRlci5kdXlja0BnbWFpbC5jb20+DQo+ID4gPiBTZW50OiBGcmlk
YXksIFNlcHRlbWJlciA5LCAyMDIyIDExOjM1IEFNDQo+ID4gPiBUbzogTmFtYmlhciwgQW1yaXRo
YSA8YW1yaXRoYS5uYW1iaWFyQGludGVsLmNvbT4NCj4gPiA+IENjOiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBrdWJhQGtlcm5lbC5vcmc7IGpoc0Btb2phdGF0dS5jb207DQo+ID4gPiBqaXJpQHJl
c251bGxpLnVzOyB4aXlvdS53YW5nY29uZ0BnbWFpbC5jb207IEdvbWVzLCBWaW5pY2l1cw0KPiA+
ID4gPHZpbmljaXVzLmdvbWVzQGludGVsLmNvbT47IFNhbXVkcmFsYSwgU3JpZGhhcg0KPiA+ID4g
PHNyaWRoYXIuc2FtdWRyYWxhQGludGVsLmNvbT4NCj4gPiA+IFN1YmplY3Q6IFJlOiBbbmV0LW5l
eHQgUEFUQ0ggdjIgMC80XSBFeHRlbmQgYWN0aW9uIHNrYmVkaXQgdG8gUlggcXVldWUNCj4gPiA+
IG1hcHBpbmcNCj4gPiA+DQo+ID4gPiBPbiBGcmksIFNlcCA5LCAyMDIyIGF0IDI6MTggQU0gTmFt
YmlhciwgQW1yaXRoYQ0KPiA+ID4gPGFtcml0aGEubmFtYmlhckBpbnRlbC5jb20+IHdyb3RlOg0K
PiA+ID4gPg0KPiA+ID4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiA+ID4g
RnJvbTogQWxleGFuZGVyIER1eWNrIDxhbGV4YW5kZXIuZHV5Y2tAZ21haWwuY29tPg0KPiA+ID4g
PiA+IFNlbnQ6IFRodXJzZGF5LCBTZXB0ZW1iZXIgOCwgMjAyMiA4OjI4IEFNDQo+ID4gPiA+ID4g
VG86IE5hbWJpYXIsIEFtcml0aGEgPGFtcml0aGEubmFtYmlhckBpbnRlbC5jb20+DQo+ID4gPiA+
ID4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGt1YmFAa2VybmVsLm9yZzsgamhzQG1vamF0
YXR1LmNvbTsNCj4gPiA+ID4gPiBqaXJpQHJlc251bGxpLnVzOyB4aXlvdS53YW5nY29uZ0BnbWFp
bC5jb207IEdvbWVzLCBWaW5pY2l1cw0KPiA+ID4gPiA+IDx2aW5pY2l1cy5nb21lc0BpbnRlbC5j
b20+OyBTYW11ZHJhbGEsIFNyaWRoYXINCj4gPiA+ID4gPiA8c3JpZGhhci5zYW11ZHJhbGFAaW50
ZWwuY29tPg0KPiA+ID4gPiA+IFN1YmplY3Q6IFJlOiBbbmV0LW5leHQgUEFUQ0ggdjIgMC80XSBF
eHRlbmQgYWN0aW9uIHNrYmVkaXQgdG8gUlgNCj4gcXVldWUNCj4gPiA+ID4gPiBtYXBwaW5nDQo+
ID4gPiA+ID4NCj4gPiA+ID4gPiBPbiBXZWQsIFNlcCA3LCAyMDIyIGF0IDY6MTQgUE0gQW1yaXRo
YSBOYW1iaWFyDQo+ID4gPiA+ID4gPGFtcml0aGEubmFtYmlhckBpbnRlbC5jb20+IHdyb3RlOg0K
PiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEJhc2VkIG9uIHRoZSBkaXNjdXNzaW9uIG9uDQo+ID4g
PiA+ID4gPg0KPiA+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzIwMjIwNDI5MTcx
NzE3LjViMGIyYTgxQGtlcm5lbC5vcmcvLA0KPiA+ID4gPiA+ID4gdGhlIGZvbGxvd2luZyBzZXJp
ZXMgZXh0ZW5kcyBza2JlZGl0IHRjIGFjdGlvbiB0byBSWCBxdWV1ZSBtYXBwaW5nLg0KPiA+ID4g
PiA+ID4gQ3VycmVudGx5LCBza2JlZGl0IGFjdGlvbiBpbiB0YyBhbGxvd3Mgb3ZlcnJpZGluZyBv
ZiB0cmFuc21pdCBxdWV1ZS4NCj4gPiA+ID4gPiA+IEV4dGVuZGluZyB0aGlzIGFiaWxpdHkgb2Yg
c2tlZGl0IGFjdGlvbiBzdXBwb3J0cyB0aGUgc2VsZWN0aW9uIG9mDQo+IHJlY2VpdmUNCj4gPiA+
ID4gPiA+IHF1ZXVlIGZvciBpbmNvbWluZyBwYWNrZXRzLiBPZmZsb2FkaW5nIHRoaXMgYWN0aW9u
IGlzIGFkZGVkIGZvcg0KPiByZWNlaXZlDQo+ID4gPiA+ID4gPiBzaWRlLiBFbmFibGVkIGljZSBk
cml2ZXIgdG8gb2ZmbG9hZCB0aGlzIHR5cGUgb2YgZmlsdGVyIGludG8gdGhlDQo+ID4gPiA+ID4g
PiBoYXJkd2FyZSBmb3IgYWNjZXB0aW5nIHBhY2tldHMgdG8gdGhlIGRldmljZSdzIHJlY2VpdmUg
cXVldWUuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gdjI6IEFkZGVkIGRvY3VtZW50YXRpb24g
aW4gRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gLS0t
DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gQW1yaXRoYSBOYW1iaWFyICg0KToNCj4gPiA+ID4g
PiA+ICAgICAgIGFjdF9za2JlZGl0OiBBZGQgc3VwcG9ydCBmb3IgYWN0aW9uIHNrYmVkaXQgUlgg
cXVldWUgbWFwcGluZw0KPiA+ID4gPiA+ID4gICAgICAgYWN0X3NrYmVkaXQ6IE9mZmxvYWQgc2ti
ZWRpdCBxdWV1ZSBtYXBwaW5nIGZvciByZWNlaXZlIHF1ZXVlDQo+ID4gPiA+ID4gPiAgICAgICBp
Y2U6IEVuYWJsZSBSWCBxdWV1ZSBzZWxlY3Rpb24gdXNpbmcgc2tiZWRpdCBhY3Rpb24NCj4gPiA+
ID4gPiA+ICAgICAgIERvY3VtZW50YXRpb246IG5ldHdvcmtpbmc6IFRDIHF1ZXVlIGJhc2VkIGZp
bHRlcmluZw0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gSSBkb24ndCB0aGluayBza2JlZGl0IGlzIHRo
ZSByaWdodCB0aGluZyB0byBiZSB1cGRhdGluZyBmb3IgdGhpcy4gSW4NCj4gPiA+ID4gPiB0aGUg
Y2FzZSBvZiBUeCB3ZSB3ZXJlIHVzaW5nIGl0IGJlY2F1c2UgYXQgdGhlIHRpbWUgd2Ugc3RvcmVk
IHRoZQ0KPiA+ID4gPiA+IHNvY2tldHMgVHggcXVldWUgaW4gdGhlIHNrYiwgc28gaXQgbWFkZSBz
ZW5zZSB0byBlZGl0IGl0IHRoZXJlIGlmIHdlDQo+ID4gPiA+ID4gd2FudGVkIHRvIHR3ZWFrIHRo
aW5ncyBiZWZvcmUgaXQgZ290IHRvIHRoZSBxZGlzYyBsYXllci4gSG93ZXZlciBpdA0KPiA+ID4g
PiA+IGRpZG4ndCBoYXZlIGEgZGlyZWN0IGltcGFjdCBvbiB0aGUgaGFyZHdhcmUgYW5kIG9ubHkg
cmVhbGx5IGFmZmVjdGVkDQo+ID4gPiA+ID4gdGhlIHNvZnR3YXJlIHJvdXRpbmcgaW4gdGhlIGRl
dmljZSwgd2hpY2ggZXZlbnR1YWxseSByZXN1bHRlZCBpbiB3aGljaA0KPiA+ID4gPiA+IGhhcmR3
YXJlIHF1ZXVlIGFuZCBxZGlzYyB3YXMgc2VsZWN0ZWQuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBU
aGUgcHJvYmxlbSB3aXRoIGVkaXRpbmcgdGhlIHJlY2VpdmUgcXVldWUgaXMgdGhhdCB0aGUgaGFy
ZHdhcmUNCj4gPiA+ID4gPiBvZmZsb2FkZWQgY2FzZSB2ZXJzdXMgdGhlIHNvZnR3YXJlIG9mZmxv
YWRlZCBjYW4gaGF2ZSB2ZXJ5IGRpZmZlcmVudA0KPiA+ID4gPiA+IGJlaGF2aW9ycy4gSSB3b25k
ZXIgaWYgdGhpcyB3b3VsZG4ndCBiZSBiZXR0ZXIgc2VydmVkIGJ5IGJlaW5nIGFuDQo+ID4gPiA+
DQo+ID4gPiA+IENvdWxkIHlvdSBwbGVhc2UgZXhwbGFpbiBob3cgdGhlIGhhcmR3YXJlIG9mZmxv
YWQgYW5kIHNvZnR3YXJlIGNhc2VzDQo+ID4gPiA+IGJlaGF2ZSBkaWZmZXJlbnRseSBpbiB0aGUg
c2tiZWRpdCBjYXNlLiBGcm9tIEpha3ViJ3Mgc3VnZ2VzdGlvbiBvbg0KPiA+ID4gPg0KPiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMjA1MDMwODQ3MzIuMzYzYjg5Y2NAa2VybmVs
Lm9yZy8sDQo+ID4gPiA+IGl0IGxvb2tlZCBsaWtlIHRoZSBza2JlZGl0IGFjdGlvbiBmaXRzIGJl
dHRlciB0byBhbGlnbiB0aGUgaGFyZHdhcmUgYW5kDQo+ID4gPiA+IHNvZnR3YXJlIGRlc2NyaXB0
aW9uIG9mIFJYIHF1ZXVlIG9mZmxvYWQgKGNvbnNpZGVyaW5nIHRoZSBza2IgbWV0YWRhdGENCj4g
PiA+ID4gcmVtYWlucyBzYW1lIGluIG9mZmxvYWQgdnMgbm8tb2ZmbG9hZCBjYXNlKS4NCj4gPiA+
DQo+ID4gPiBTbyBzcGVjaWZpY2FsbHkgbXkgY29uY2VybiBpcyBSUFMuIFRoZSBwcm9ibGVtIGlz
IFJQUyB0YWtlcyBwbGFjZQ0KPiA+ID4gYmVmb3JlIHlvdXIgVEMgcnVsZSB3b3VsZCBiZSBhcHBs
aWVkIGluIHRoZSBzb2Z0d2FyZSBjYXNlLCBidXQgYWZ0ZXINCj4gPiA+IGl0IGhhcyBiZWVuIGFw
cGxpZWQgaW4gdGhlIGhhcmR3YXJlIGNhc2UuIEFzIGEgcmVzdWx0IHRoZSBiZWhhdmlvcg0KPiA+
ID4gd2lsbCBiZSBkaWZmZXJlbnQgZm9yIG9uZSB2ZXJzdXMgdGhlIG90aGVyLiBXaXRoIHRoZSBy
ZWRpcmVjdCBhY3Rpb24NCj4gPiA+IGl0IHdpbGwgcHVsbCB0aGUgcGFja2V0IG91dCBvZiB0aGUg
UnggcGlwZWxpbmUgYW5kIHJlaW5zZXJ0IGl0IHNvIHRoYXQNCj4gPiA+IFJQUyB3aWxsIGJlIGFw
cGxpZWQgdG8gdGhlIHBhY2tldCBhbmQgaXQgd291bGQgYmUgcmVjZWl2ZWQgb24gdGhlIENQVXMN
Cj4gPiA+IGV4cGVjdGVkLg0KPiA+ID4NCj4gPg0KPiA+IE9rYXksIHNvIEkgdW5kZXJzdGFuZCB0
aGF0IHdpdGhvdXQgSFcgb2ZmbG9hZCwgdGhlIFNXIGJlaGF2aW9yIHdvdWxkDQo+ID4gbm90IGFs
aWduIGZvciBSUFMsIGkuZS4sIFJQUyBDUFUgd291bGQgYmUgZnJvbSBhIHF1ZXVlIChhbHJlYWR5
IHNlbGVjdGVkDQo+ID4gYnkgSFcsIFJTUyBldGMuKSwgIGFuZCBtYXkgbm90IGFsaWduIHdpdGgg
dGhlIHF1ZXVlIHNlbGVjdGVkIGZyb20NCj4gPiB0aGUgU1cgVEMgcnVsZS4gQW5kIEkgc2VlIHlv
dXIgcG9pbnQsIHRoZSBzb2x1dGlvbiB0byB0aGlzIHdvdWxkIGJlDQo+ID4gcmVpbnNlcnRpbmcg
dGhlIHBhY2tldCBhZnRlciB1cGRhdGluZyB0aGUgcXVldWUuIEJ1dCwgYXMgSSBsb29rIG1vcmUg
aW50bw0KPiA+IHRoaXMsIHRoZXJlIGFyZSBzdGlsbCBzb21lIG1vcmUgY29uY2VybnMgSSBoYXZl
Lg0KPiA+DQo+ID4gSUlVQywgd2UgbWF5IGJlIGxvb2tpbmcgYXQgYSBwb3RlbnRpYWwgVEMgcnVs
ZSBhcyBiZWxvdzoNCj4gPiB0YyBmaWx0ZXIgYWRkIGRldiBldGhYIGluZ3Jlc3MgLi4uIFwNCj4g
PiBhY3Rpb24gbWlycmVkIGluZ3Jlc3MgcmVkaXJlY3QgZGV2IGV0aFggcnhxdWV1ZSA8cnhfcWlk
Pg0KPiA+DQo+ID4gSXQgbG9va3MgdG8gbWUgdGhhdCB0aGlzIGNvbmZpZ3VyYXRpb24gY291bGQg
cG9zc2libHkgcmVzdWx0IGluIGxvb3BzDQo+ID4gcmVjdXJzaXZlbHkgY2FsbGluZyBhY3RfbWly
cmVkLiBTaW5jZSB0aGUgcmVkaXJlY3Rpb24gaXMgZnJvbSBpbmdyZXNzDQo+ID4gdG8gaW5ncmVz
cyBvbiB0aGUgc2FtZSBkZXZpY2UsIHdoZW4gdGhlIHBhY2tldCBpcyByZWluc2VydGVkIGludG8g
dGhlDQo+ID4gUlggcGlwZWxpbmUgb2YgdGhlIHNhbWUgZGV2aWNlLCBSUFMgYW5kIHRjIGNsYXNz
aWZpY2F0aW9uIGhhcHBlbnMgYWdhaW4sDQo+ID4gdGhlIHRjIGZpbHRlciB3aXRoIGFjdCBtaXJy
ZWQgZXhlY3V0ZXMgcmVkaXJlY3RpbmcgYW5kIHJlaW5zZXJ0aW5nIHRoZQ0KPiA+IHBhY2tldCBh
Z2Fpbi4gYWN0X21pcnJlZCBrZWVwcyBhIENQVSBjb3VudGVyIG9mIHJlY3Vyc2l2ZSBjYWxscyBm
b3IgdGhlDQo+ID4gYWN0aW9uIGFuZCBkcm9wcyB0aGUgcGFja2V0IHdoZW4gdGhlIGxpbWl0IGlz
IHJlYWNoZWQuDQo+ID4gSWYgdGhpcyBpcyBhIHZhbGlkIGNvbmZpZ3VyYXRpb24sIEkgY2Fubm90
IGZpbmQgYW55IGNvZGUgdGhhdCBwZXJoYXBzIHVzZXMNCj4gPiBhIGNvbWJpbmF0aW9uIG9mIHNr
Yi0+cmVkaXJlY3QgYW5kIHNrYi0+ZnJvbV9pbmdyZXNzIHRvIGNoZWNrIGFuZA0KPiA+IHByZXZl
bnQgcmVjdXJzaXZlIGNsYXNzaWZpY2F0aW9uIChmdXJ0aGVyIGV4ZWN1dGlvbiBvZiBUQyBtaXJy
ZWQgcmVkaXJlY3QNCj4gPiBhY3Rpb24pLg0KPiANCj4gVGhlIHJlY3Vyc2lvbiBwcm9ibGVtIGlz
IGVhc2lseSBzb2x2ZWQgYnkgc2ltcGx5IG5vdCByZXF1ZXVlaW5nIGFnYWluDQo+IGlmIHRoZSBw
YWNrZXQgaXMgb24gdGhlIHF1ZXVlIGl0IGlzIHN1cHBvc2VkIHRvIGJlLiBJZiB5b3UgaGF2ZSBy
dWxlcw0KPiB0aGF0IGFyZSBib3VuY2luZyB0aGUgdHJhZmZpYyBiZXR3ZWVuIHR3byBxdWV1ZXMg
aXQgd291bGRuJ3QgYmUgYW55DQo+IGRpZmZlcmVudCB0aGFuIHRoZSBwb3RlbnRpYWwgaXNzdWUg
b2YgYm91bmNpbmcgdHJhZmZpYyBiZXR3ZWVuIHR3bw0KPiBuZXRkZXZzIHdoaWNoIGlzIHdoeSB0
aGUgcmVjdXJzaW9uIGNvdW50ZXJzIHdlcmUgYWRkZWQuDQo+IA0KDQpPa2F5LCBtYWtlcyBzZW5z
ZS4gU28sIHJlZGlyZWN0aW5nIChpbmdyZXNzIHRvIGluZ3Jlc3MpIG9uIHRoZSBzYW1lDQpkZXZp
Y2Ugd2l0aCB0aGUgcXVldWVfbWFwcGluZyBleHRlbnNpb24gd291bGQgbWFrZSBpdCBwb3NzaWJs
ZSB0bw0KdXBkYXRlIHRoZSBxdWV1ZS4gV2l0aG91dCB0aGUgcXVldWVfbWFwcGluZyBleHRlbnNp
b24sIGluZ3Jlc3MgdG8NCmluZ3Jlc3MgcmVkaXJlY3Qgb24gdGhlIHNhbWUgZGV2aWNlIHdvdWxk
IHNpbXBseSBib3VuY2UgdGhlIHBhY2tldHMgYW5kDQpldmVudHVhbGx5IGRyb3AgdGhlbSBvbmNl
IHRoZSByZWN1cnNpb24gbGltaXQgaXMgcmVhY2hlZC4NCg0KPiA+IEFsc28sIHNpbmNlIHJlaW5z
ZXJ0aW5nIHRoZSBwYWNrZXQgYWZ0ZXIgdXBkYXRpbmcgdGhlIHF1ZXVlIHdvdWxkIGZpeA0KPiA+
IHRoZSBSUFMgaW5jb25zaXN0ZW5jeSwgY2FuIHRoaXMgYmUgZG9uZSBmcm9tIHRoZSBza2JlZGl0
IGFjdGlvbiBpbnN0ZWFkDQo+ID4gb2YgbWlycmVkIHJlZGlyZWN0ID8gU28sIGlmIHNrYmVkaXQg
YWN0aW9uIGlzIHVzZWQgZm9yIFJ4IHF1ZXVlIHNlbGVjdGlvbiwNCj4gPiBtYXliZSB0aGlzIHNl
cXVlbmNlIGhlbHBzOg0KPiA+DQo+ID4gUlBTIG9uIFJYIHExIC0+IFRDIGFjdGlvbiBza2JlZGl0
IFJYIHEyIC0+DQo+ID4gYWx3YXlzIHJlaW5zZXJ0IGlmIGFjdGlvbiBza2JlZGl0IGlzIG9uIFJY
IC0+IFJQUyBvbiBSWCBxMiAtPg0KPiA+IHN0b3AgZnVydGhlciBleGVjdXRpb24gb2YgVEMgYWN0
aW9uIFJYIHNrYmVkaXQNCj4gDQo+IFRoYXQgaXMgY2hhbmdpbmcgdGhlIGZ1bmN0aW9uIG9mIHNr
YmVkaXQuIEluIGFkZGl0aW9uIHRoZSBza2JlZGl0DQo+IGFjdGlvbiBpc24ndCBtZWFudCB0byBi
ZSBvZmZsb2FkZWQuIFRoZSBza2JlZGl0IGFjdGlvbiBpcyBvbmx5IHJlYWxseQ0KPiBzdXBwb3Nl
ZCB0byBlZGl0IHNrYiBtZWRhdGFkYSwgaXQgaXNuJ3Qgc3VwcG9zZWQgdG8gdGFrZSBvdGhlciBh
Y3Rpb25zDQo+IG9uIHRoZSBmcmFtZS4gV2hhdCB3ZSB3YW50IHRvIGF2b2lkIGlzIG1ha2luZyBz
a2JlZGl0IGludG8gYW5vdGhlcg0KPiBtaXJyZWQuDQoNCk9rYXksIHNvIHNrYmVkaXQgY2hhbmdp
bmcgdGhlIHNrYiBtZXRhZGF0YSBhbmQgZG9pbmcgdGhlIGFkZGl0aW9uYWwNCmFjdGlvbiBoZXJl
IChyZWluc2VydGluZyB0aGUgcGFja2V0KSBpcyBub3QgcmlnaHQuIEJ1dCBpbiB0ZXJtcyBvZiBz
a2JlZGl0DQphY3Rpb24gbm90IG1lYW50IHRvIGJlIG9mZmxvYWRlZCwgSSBkbyBmaW5kIHRoYXQg
c2tiZWRpdCBhY3Rpb24gYWxsb3dzDQpvZmZsb2FkIG9mIGNlcnRhaW4gcGFyYW1ldGVycyBsaWtl
IG1hcmssIHB0eXBlIGFuZCBwcmlvcml0eS4NCg==
