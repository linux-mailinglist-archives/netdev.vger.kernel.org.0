Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFDE67F3BF
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjA1Bei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjA1Beg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:34:36 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3805E10A81
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674869675; x=1706405675;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B/+TGPPK/t6DslrskTEGUFgYeH1DPKZ/IsyC9s05dW4=;
  b=Op2I4Gbmy4k2BNmalVYYtBxY+Q/J9E3N7gvp1eJlWyjnm370hJFX1UNC
   lMDUVbbOqgz3/4VsusTcrR7/X/JZd9/gsu3oFx+htOcRnk4wdg1bza1Hw
   HUxo7xKAoB6/M4U/sFo62+fO7CGInEiIykTXdpapagfF8ffk0FPCABnyu
   9m891/TRRAcSXk+VNFDA0879ko6vVQ5nWPSl/cigU2T+GgchUvZCENdDx
   F1uKigu0nTc2FajUjcAP3Vc+U27b0j1RZJp6vvZVGh5SzNRmE2628nBgQ
   l3hYTGWQzufYDWQ8OgBoICVQsrzvG/opiOKlTeV20vMBk9KxCHpY9rDZr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="307589338"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="307589338"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 17:34:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="695724183"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="695724183"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 27 Jan 2023 17:34:33 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 17:34:33 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 17:34:32 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 17:34:32 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 27 Jan 2023 17:34:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSYiiymXqV3nOAyj8vS1miRjtnN+L1rAk4Wss5QOtgbDI3C4YTSMaR8RrfAj+V8RPohHULELB1wrq1EQV1J1gLrFyKIM0NXX7pk/yzUKgWe048s/5JMaFgV3G6UmWKz9gJQUMVTyjHw8TIAG79NQ2QCRmBXCmrwytS/9OtzbSICnnaF1xjOIITLpkzLUl553kNUpIHYX8k4R+AbEOKKNbQFGME4o+6KKd2b/siNHGnE86liVE1sQPUBfD54Or/9lhSdZoin0jlyCtdf5SLLMdPYaBnzFdqbTdNJrE7Y0dRO85ysa85FZ2BauxGrLh/I9o8tmPamY8NvbZ7cqaTauMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B/+TGPPK/t6DslrskTEGUFgYeH1DPKZ/IsyC9s05dW4=;
 b=WjgxFj/yRIxh5WLmBx2SHry6P1cdAAgU/QyxY7hdN1Yx2KH8GUJagF5t5Mu+nWO839ovrpwOUiGC9458yJnEZF48k/FnysnMf8F7S+FFQPfWMxjLra2xZYloYRIfS+9b9jZUnZde19XV4scokYs5wWesuNWzyAvXEi+Wq16NTmme+uJjeGwS8EwwgGBsjaHjUL2mSpPlUaRO3aWyBgwf+dppzX15M2eqdRBVKPdg6rZxx848Tgo7Jg0fEqZTIOLxxKW9Yz4jnR7n83Y2XmSvwXQpHjyhLHzVZfyQEnK2YKuAok6s+sb1AntexSc0krkTvZ76pksAINgAlbFFh8hdDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4993.namprd11.prod.outlook.com (2603:10b6:303:6c::23)
 by CY8PR11MB7797.namprd11.prod.outlook.com (2603:10b6:930:76::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Sat, 28 Jan
 2023 01:34:30 +0000
Received: from CO1PR11MB4993.namprd11.prod.outlook.com
 ([fe80::be4b:926b:fa65:b5dc]) by CO1PR11MB4993.namprd11.prod.outlook.com
 ([fe80::be4b:926b:fa65:b5dc%5]) with mapi id 15.20.6043.023; Sat, 28 Jan 2023
 01:34:30 +0000
From:   "Singhai, Anjali" <anjali.singhai@intel.com>
To:     Jamal Hadi Salim <hadi@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel@mojatatu.com" <kernel@mojatatu.com>,
        "Chatterjee, Deb" <deb.chatterjee@intel.com>,
        "Limaye, Namrata" <namrata.limaye@intel.com>,
        "khalidm@nvidia.com" <khalidm@nvidia.com>,
        "tom@sipanda.io" <tom@sipanda.io>,
        "pratyush@sipanda.io" <pratyush@sipanda.io>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "stefanc@marvell.com" <stefanc@marvell.com>,
        "seong.kim@amd.com" <seong.kim@amd.com>,
        "mattyk@nvidia.com" <mattyk@nvidia.com>,
        "Daly, Dan" <dan.daly@intel.com>,
        "Fingerhut, John Andy" <john.andy.fingerhut@intel.com>
Subject: RE: [PATCH net-next RFC 00/20] Introducing P4TC
Thread-Topic: [PATCH net-next RFC 00/20] Introducing P4TC
Thread-Index: AQHZMBXdBcJIqoJZykarKF/C1TEweK6xXCUAgADrnYCAAD7AgIAAKGMAgABd1SA=
Date:   Sat, 28 Jan 2023 01:34:29 +0000
Message-ID: <CO1PR11MB49933B0E4FC6752D8C439B3593CD9@CO1PR11MB4993.namprd11.prod.outlook.com>
References: <20230124170346.316866-1-jhs@mojatatu.com>
 <20230126153022.23bea5f2@kernel.org>
 <CAM0EoMnHcR9jFVtLt+L1FPRY5BK7_NgH3gsOZxQrXzEkaR1HYQ@mail.gmail.com>
 <20230127091815.3e066e43@kernel.org>
 <CAAFAkD80UtwX3PgmYsw3=_wmOEaEZEdui6uHf2FtG1OvDd5s4g@mail.gmail.com>
In-Reply-To: <CAAFAkD80UtwX3PgmYsw3=_wmOEaEZEdui6uHf2FtG1OvDd5s4g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4993:EE_|CY8PR11MB7797:EE_
x-ms-office365-filtering-correlation-id: a89209cd-9f3d-46e3-aac5-08db00cfccea
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3AiuVrJ8mdyB+WpAnsP4/sP+UR7alI9/gZiyufVWsaE2FVjYHWAW0PfgKBy/U9xjcc0qLSv+sMQ0vM1/sd1l0IGEHCMpsseQOdvz12fzUN5jy4ecZ2feBDiOPcKwCVGKZDEr/jUo+mtvCMgvR0ZjAi5d30K9to7YElxM2I5lVBqUFBBzBTdq44SUSK8JJAgNMQBaSvIpQHgHrCuqcBjeUv5iTVs+I5Yle8c9rxYGpWVHiFqs80weqNT4hzU9Dn6uy406hrnhCw/M7SwFo8XLpI7wJfhb2ymgt2PX4WJdxGzrT/QlpGgHmYcyjMzaKxueCkLLBJP7Spef/8iqTYUq1jMQiD7jiG0CA9ziaoX9a3ol85zJywGQrFGxXs3HpQAQl0xw9KI+T/B7zyCpXWME1CDtLRfbm4TRuvb/gfWltq49rCPSgbyRs2/HZNcYOjlqm9zWidl5QljKKFHQeQ9QVKlLifhVXWL4UhFP4QYkf+ccYpDuLG55ppuRFr5pHSLTzpwK9qgAsav7uWHX1UlPSXcATgIqL+kd8xFBXVWdUKG67GAOaG0E0dNLRSgGDVdB1lWjT3vjLEjxgfm+GGSFo3+d/qr4cYwzIJP7lDHNCqQmMh9BWNveSEN5Z/Wdh5uvw/5MeIfbzXQIkaCDHi4ukCvJ5RpuyqcPFgncPpMutcHRayrDjU0GyBiqF5AqxXquz/lbQC2vW72xlpGKbioD0aOypmhB7OjS7cubNXgZLPbttCM+2svHOF6iZ+Jbyup6OROAKgEzOI1XdeW5ifQRZq4qILCdxnd60hduULAN7bk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4993.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199018)(7416002)(66899018)(66446008)(2906002)(66946007)(122000001)(33656002)(38070700005)(7696005)(110136005)(54906003)(83380400001)(186003)(8936002)(53546011)(9686003)(966005)(6506007)(41300700001)(71200400001)(107886003)(26005)(8676002)(82960400001)(86362001)(478600001)(5660300002)(316002)(76116006)(38100700002)(64756008)(66476007)(4326008)(52536014)(66556008)(55016003)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UTFlblBJamNCOExveFJpZWFyc05sRWVsZmJJTS9Qd2gvcUM5S2tFb3gvQ2Jq?=
 =?utf-8?B?dHFNNHdRd3FhVTlQMC85a3JmUHVlNnB1VTZ1emhFRyt1bnhoeS9TQ0FoMHZs?=
 =?utf-8?B?OHdGV3E0THY1Q0NHRUNpYlRPTFRIMVkyK3FiTThpRzk3TTRUcWN2R2FqalZU?=
 =?utf-8?B?WlZLdGNUMXBtTG0zWGZDclU3aUszQ05zRW5LQ21QRjQ3dzlYaGJkU2owbXBJ?=
 =?utf-8?B?OXEydDVwUVZzWGYxU0JYUWlTbE9tMWpUL0JSamhwWWlHR1FNa1NjS3ZqeWZB?=
 =?utf-8?B?eWR0ekMvQjQzTDRRK2hNQWN0aVZJbVNSMFdUSjE4dnpDOHd5RXVVdjJNWnpP?=
 =?utf-8?B?RXI5K3BuOXljaitaeS9LdUJOVi9KQS8xSEpJUDdjYWlnK2g0M2xpM2ZoT21M?=
 =?utf-8?B?NzJhQU8xbzdUeUZUY0hkeFU0VXVUUHcxdmVzQVduS0RTWmJ2SFZQRUZOblIz?=
 =?utf-8?B?VGd6MDBZVmlrbFltaUR2bmlSVzVMSklCQjRzYzhqNVplMWJBRjFRVGFKV3lv?=
 =?utf-8?B?VmlyVkIrOHhUdVZxT2s3SFYvWWNySGhHaDlJek52ZmRoaDRsdURERGdnRlBz?=
 =?utf-8?B?TFpoMWlFRlo1L2VqSlUrV05WOHQwNzB4N2dsZ1UzdnA2RWNzd21DOFdkalhn?=
 =?utf-8?B?WFdacENkeEpTSlJGQU5rcE9qSmV2OU9EWkJTVHhDMllTLzY4a24yT1ZlTHQv?=
 =?utf-8?B?cG8yRkdLbEVPQ2IwZ21IZWQwc2pMTTFHM0pyb3k5UlBNMzlzdEJGTytFVDkz?=
 =?utf-8?B?cU9FNkVlOVVYd1Nqd2V4ZkdnYU1LZVpodDh4TE9RenJOenZWejE0WkJPVExt?=
 =?utf-8?B?bVZXWEt4bldMS3VBNkZJN0NLREh1SFEvRVVjd0NJb1V3TWlHYzljMy9iempv?=
 =?utf-8?B?VEZ0ZkpKSUFJRVhnVzBDSkRnQlkrdkdwYmlqWHRxdkl4SXlVQWxuOEFjNnZB?=
 =?utf-8?B?SmhoOS9xdkNFY2VIUEV4K1ZVSEZmTjRpZTMwdTBTQkg2M2hBNFNGTS9pMEd2?=
 =?utf-8?B?Zk13Q2ZtT0Fmc21ON254T0NNSmFvOUtMbUdLYTFvTkcrLzNXdWFLRlJjRmMz?=
 =?utf-8?B?dUo4bnV5R0lncHZaNHR1L0dsTXRIWkF4bWpIdEZtRjlQWmxENm9nS1RKMkVJ?=
 =?utf-8?B?cGlMZHZJYitNbmVYQjAwMWV6dU0vR2dGcUx0a1F1Q0oyMEhSa3FHUlkrWnZP?=
 =?utf-8?B?akFPVmgrdDlFbndKdUQyTytVVW5ZVjRTMGxqNWE4RTIwSVNBaHR6bk9RV0NH?=
 =?utf-8?B?MzNYTmFXTXNDaUlqUWkrOWVLWGZyOVI0c21zMHpnVDg1ZnJRN0syTEM3YXJt?=
 =?utf-8?B?Wk9EWmlXcXNsbHhMOW1reUE4NUgxYmNOUHdMNER6Z3RxN3lKN1lRNUh0cndz?=
 =?utf-8?B?Y25OUE5aeE9NRlhQREtGZXEyRVNLY1BidUh5em1pUmdzSjRUS3pDeFpTNkNj?=
 =?utf-8?B?N1V6RDBOQVJkdElrN25tVnhveUgxdTZRQy94dEtQL1dUdnhRbW1vQzI5TGo3?=
 =?utf-8?B?K25VdXI1MjNkaXlEOXBrR3l4UDVJV1AwaDZOamxQUHNVWjdyVU8zNWl0RUZ4?=
 =?utf-8?B?b1poWVdibEVEbFZSb2J0anhhbVpDeHkxSGpFd0FmNy9oRmRPdjVhay9RZDJC?=
 =?utf-8?B?RFpUMitDNkx3bnN0UXNaL2IrWC9zSy9BL0c5TVFiWTN2L0ZNVlBQRURhQlFG?=
 =?utf-8?B?WVlsSFFaUW1UVlRxbzlrdm10bUszenlvSU15U3d1SmR0QTh1d2JEYlVKRHJi?=
 =?utf-8?B?OEh1TTlFYkpUdDNwcFhsN3Ryc1BpcjlQaGQ4Skl5am1XVThBN01WaDdCUVFX?=
 =?utf-8?B?SkQxRFNrS0ZweTNQc283eHMzd29oZSthdzcyUFl1THNjbm16ek5mcXZyRk9V?=
 =?utf-8?B?V05xcTBLQzZ3U3NaQXBjUVBBSHd4MjMyNk9WZHk1ZytuaklISWsrN1NrR0Nm?=
 =?utf-8?B?UDhQUFk3eVcwcGtGVzdxa0xyUmptUGJteEJsN0tCSzJrc0tkZjkvL01hZnpo?=
 =?utf-8?B?cURpWnp5ZU1KbGsxSE1tb1RPS2U1Z1NWZTJGUEtFeWVYc0MvcEE4RTkzQ1Qy?=
 =?utf-8?B?a2l2OFQvVlhCMmJaSmpmdWFkOHhxNzVZbG5ucWJDZnE1MTZkbG9zRDRXbGJt?=
 =?utf-8?Q?fBT111Cbo8tvhaflO+HGl+GP+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4993.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a89209cd-9f3d-46e3-aac5-08db00cfccea
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2023 01:34:29.8749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +y6b8JT1X4+jIX/H0c/W8G9j2TCi5VWS1oYBmUsVT467zqNkHgcqF/VowQ1Th1opbSG6bb7cHAtkpkrzkQpyrPA4ovWPECRgWaAj0Ce4Juk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7797
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UDQgaXMgZGVmaW5pdGVseSB0aGUgbGFuZ3VhZ2Ugb2YgY2hvaWNlIGZvciBkZWZpbmluZyBhIERh
dGFwbGFuZSBpbiBIVyBmb3IgSVBVcy9EUFVzL0ZOSUNzIGFuZCBTd2l0Y2hlcy4gQXMgYSB2ZW5k
b3IgSSBjYW4gZGVmaW5pdGVseSBzYXkgdGhhdCB0aGUgc21hcnQgZGV2aWNlcyBpbXBsZW1lbnQg
YSB2ZXJ5IHByb2dyYW1tYWJsZSBBU0lDIGFzIGVhY2ggY3VzdG9tZXIgRGF0YXBsYW5lIGRlZmVy
cyBxdWl0ZSBhIGJpdCBhbmQgUDQgaXMgdGhlIGxhbmd1YWdlIG9mIGNob2ljZSBmb3Igc3BlY2lm
eWluZyB0aGUgRGF0YXBsYW5lIGRlZmluaXRpb25zLiBBIGxvdCBvZiBjdXN0b21lciBkZXBsb3kg
cHJvcHJpZXRhcnkgcHJvdG9jb2xzIHRoYXQgcnVuIGluIEhXIGFuZCB0aGVyZSBpcyBubyBnb29k
IHdheSByaWdodCBub3cgaW4ga2VybmVsIHRvIHN1cHBvcnQgdGhlc2UgcHJvcHJpZXRhcnkgcHJv
dGNvbHMuIElmIHdlIGVuYWJsZSB0aGVzZSBwcm90b2NvbCBpbiB0aGUga2VybmVsIGl0IHRha2Vz
IGEgaHVnZSBlZmZvcnQgYW5kIHRoZXkgZG9u4oCZdCBldm9sdmUgd2VsbC4NCkJlaW5nIGFibGUg
dG8gZGVmaW5lIGluIFA0IGFuZCBvZmZsb2FkIGludG8gSFcgdXNpbmcgdGMgbWVjaGFuaXNtIHJl
YWxseSBoZWxwcyBpbiBzdXBwb3J0aW5nIHRoZSBjdXN0b21lcidzIERhdGFwbGFuZSBhbmQgcHJv
dGNvbHMgd2l0aG91dCBoYXZpbmcgdG8gd2FpdCBtb250aHMgYW5kIHllYXJzIHRvIGdldCB0aGUg
a2VybmVsIHVwZGF0ZWQuIEhlcmUgaXMgYSBsaW5rIHRvIG91ciBJUFUgb2ZmZXJpbmcgdGhhdCBp
cyBQNCBwcm9ncmFtbWFibGUNCiBodHRwczovL3d3dy5pbnRlbC5jb20vY29udGVudC93d3cvdXMv
ZW4vcHJvZHVjdHMvZGV0YWlscy9uZXR3b3JrLWlvL2lwdS9lMjAwMC1hc2ljLmh0bWwNCkhlcmUg
YXJlIHNvbWUgb3RoZXIgdXNlZnVsIGxpbmtzDQpodHRwczovL2lwZGsuaW8vDQoNCkFuamFsaQ0K
DQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogSmFtYWwgSGFkaSBTYWxpbSA8aGFk
aUBtb2phdGF0dS5jb20+IA0KU2VudDogRnJpZGF5LCBKYW51YXJ5IDI3LCAyMDIzIDExOjQzIEFN
DQpUbzogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCkNjOiBKYW1hbCBIYWRpIFNh
bGltIDxqaHNAbW9qYXRhdHUuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsga2VybmVsQG1v
amF0YXR1LmNvbTsgQ2hhdHRlcmplZSwgRGViIDxkZWIuY2hhdHRlcmplZUBpbnRlbC5jb20+OyBT
aW5naGFpLCBBbmphbGkgPGFuamFsaS5zaW5naGFpQGludGVsLmNvbT47IExpbWF5ZSwgTmFtcmF0
YSA8bmFtcmF0YS5saW1heWVAaW50ZWwuY29tPjsga2hhbGlkbUBudmlkaWEuY29tOyB0b21Ac2lw
YW5kYS5pbzsgcHJhdHl1c2hAc2lwYW5kYS5pbzsgamlyaUByZXNudWxsaS51czsgeGl5b3Uud2Fu
Z2NvbmdAZ21haWwuY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUuY29t
OyBwYWJlbmlAcmVkaGF0LmNvbTsgdmxhZGJ1QG52aWRpYS5jb207IHNpbW9uLmhvcm1hbkBjb3Jp
Z2luZS5jb207IHN0ZWZhbmNAbWFydmVsbC5jb207IHNlb25nLmtpbUBhbWQuY29tOyBtYXR0eWtA
bnZpZGlhLmNvbTsgRGFseSwgRGFuIDxkYW4uZGFseUBpbnRlbC5jb20+OyBGaW5nZXJodXQsIEpv
aG4gQW5keSA8am9obi5hbmR5LmZpbmdlcmh1dEBpbnRlbC5jb20+DQpTdWJqZWN0OiBSZTogW1BB
VENIIG5ldC1uZXh0IFJGQyAwMC8yMF0gSW50cm9kdWNpbmcgUDRUQw0KDQpPbiBGcmksIEphbiAy
NywgMjAyMyBhdCAxMjoxOCBQTSBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPiB3cm90
ZToNCj4NCj4gT24gRnJpLCAyNyBKYW4gMjAyMyAwODozMzozOSAtMDUwMCBKYW1hbCBIYWRpIFNh
bGltIHdyb3RlOg0KPiA+IE9uIFRodSwgSmFuIDI2LCAyMDIzIGF0IDY6MzAgUE0gSmFrdWIgS2lj
aW5za2kgPGt1YmFAa2VybmVsLm9yZz4gd3JvdGU6DQo+ID4gPiBPbiBUdWUsIDI0IEphbiAyMDIz
IDEyOjAzOjQ2IC0wNTAwIEphbWFsIEhhZGkgU2FsaW0gd3JvdGU6DQoNClsuLl0NCj4gPiBOZXR3
b3JrIHByb2dyYW1tYWJpbGl0eSBpbnZvbHZpbmcgaGFyZHdhcmUgIC0gd2hlcmUgYXQgbWluaW1h
bCB0aGUgDQo+ID4gc3BlY2lmaWNhdGlvbiBvZiB0aGUgZGF0YXBhdGggaXMgaW4gUDQgYW5kIG9m
dGVuIHRoZSBpbXBsZW1lbnRhdGlvbiANCj4gPiBpcy4gRm9yIHNhbXBsZXMgb2Ygc3BlY2lmaWNh
dGlvbiB1c2luZyBQNCAodGhhdCBhcmUgcHVibGljKSBzZWUgZm9yIA0KPiA+IGV4YW1wbGUgTVMg
QXp1cmU6DQo+ID4gaHR0cHM6Ly9naXRodWIuY29tL3NvbmljLW5ldC9EQVNIL3RyZWUvbWFpbi9k
YXNoLXBpcGVsaW5lDQo+DQo+IFRoYXQncyBhbiBJUFUgdGhpbmc/DQo+DQoNClllcywgREFTSCBp
cyB4UFUuIEJ1dCB0aGUgd2hvbGUgU29uaWMvU0FJIHRoaW5nIGluY2x1ZGVzIHN3aXRjaGVzIGFu
ZCBQNCBwbGF5cyBhIHJvbGUgdGhlcmUuDQoNCj4gPiBJZiB5b3UgYXJlIGEgdmVuZG9yIGFuZCB3
YW50IHRvIHNlbGwgYSBOSUMgaW4gdGhhdCBzcGFjZSwgdGhlIHNwZWMgDQo+ID4geW91IGdldCBp
cyBpbiBQNC4NCj4NCj4gcy9OSUMvSVBVLyA/DQoNCkkgZG8gYmVsaWV2ZSB0aGF0IG9uZSBjYW4g
d3JpdGUgYSBQNCBwcm9ncmFtIHRvIGV4cHJlc3MgdGhpbmdzIGEgcmVndWxhciBOSUMgY291bGQg
ZXhwcmVzcyB0aGF0IG1heSBiZSBoYXJkZXIgdG8gZXhwb3NlIHdpdGggY3VycmVudCBpbnRlcmZh
Y2VzLg0KDQo+ID4gWW91ciB1bmRlcmx5aW5nIGhhcmR3YXJlDQo+ID4gZG9lc250IGhhdmUgdG8g
YmUgUDQgbmF0aXZlLCBidXQgYXQgbWluaW1hbCB0aGUgYWJzdHJhY3Rpb24gKGFzIHdlIA0KPiA+
IGFyZSB0cnlpbmcgdG8gcHJvdmlkZSB3aXRoIFA0VEMpIGhhcyB0byBiZSBhYmxlIHRvIGNvbnN1
bWUgdGhlIFA0IA0KPiA+IHNwZWNpZmljYXRpb24uDQo+DQo+IFA0IGlzIGNlcnRhaW5seSBhbiBv
cHRpb24sIGVzcGVjaWFsbHkgZm9yIHNwZWNzLCBidXQgSSBoYXZlbid0IHNlZW4gDQo+IG11Y2gg
YWRvcHRpb24gbXlzZWxmLg0KDQpUaGUgeFBVIG1hcmtldCBvdXRzaWRlIG9mIGh5cGVyLXNjYWxl
cnMgaXMgZW1lcmdpbmcgbm93LiBIeXBlcnNjYWxlcnMgbG9va2luZyBhdCB4UFVzIGFyZSBsb29r
aW5nIGF0IFA0IGFzIHRoZSBkYXRhcGF0aCBsYW5ndWFnZSAtIHRoYXQgc2V0cyB0aGUgdHJlbmQg
Zm9yd2FyZCB0byBsYXJnZSBlbnRlcnByaXNlcy4NClRoYXQncyBteSBleHBlcmllbmNlLg0KU29t
ZSBvZiB0aGUgdmVuZG9ycyBvbiB0aGUgQ2Mgc2hvdWxkIGJlIGFibGUgdG8gcG9pbnQgdG8gYWRv
cHRpb24uDQpBbmphbGk/IE1hdHR5Pw0KDQo+IFdoYXQncyB0aGUgYmVuZWZpdCAvIHVzZSBjYXNl
Pw0KDQpPZiBQNCBvciB4UFVzPw0KVW5pZmllZCBhcHByb2FjaCB0byBzdGFuZGFyZGl6ZSBob3cg
YSBkYXRhcGF0aCBpcyBkZWZpbmVkIGlzIGEgdmFsdWUgZm9yIFA0Lg0KUHJvdmlkaW5nIGEgc2lu
Z3VsYXIgYWJzdHJhY3Rpb24gdmlhIHRoZSBrZXJuZWwgKGFzIG9wcG9zZWQgdG8gZXZlcnkgdmVu
ZG9yIHBpdGNoaW5nIHRoZWlyIEFQSSkgaXMgd2hhdCB0aGUga2VybmVsIGJyaW5ncy4NCg0KPiA+
IEZvciBpbXBsZW1lbnRhdGlvbnMgd2hlcmUgUDQgaXMgaW4gdXNlLCB0aGVyZSBhcmUgbWFueSAt
IHNvbWUgcHVibGljIA0KPiA+IG90aGVycyBub3QsIHNhbXBsZSBzcGFjZToNCj4gPiBodHRwczov
L2Nsb3VkLmdvb2dsZS5jb20vYmxvZy9wcm9kdWN0cy9nY3AvZ29vZ2xlLWNsb3VkLXVzaW5nLXA0
cnVudA0KPiA+IGltZS10by1idWlsZC1zbWFydC1uZXR3b3Jrcw0KPg0KPiBIeXBlci1zY2FsZXIg
cHJvcHJpZXRhcnkuDQoNClRoZSBjb250cm9sIGFic3RyYWN0aW9uIChQNCBydW50aW1lKSBpcyBj
ZXJ0YWlubHkgbm90IHByb3ByaWV0YXJ5Lg0KVGhlIGRhdGFwYXRoIHRoYXQgaXMgdGFyZ2V0dGVk
IGJ5IHRoZSBydW50aW1lIGlzLg0KSG9wZWZ1bGx5IHdlIGNhbiBmaXggdGhhdCB3aXRoIFA0VEMu
DQpUaGUgbWFqb3JpdHkgb2YgdGhlIGRpc2N1c3Npb25zIGkgaGF2ZSB3aXRoIHNvbWUgb2YgdGhl
IGZvbGtzIHdobyBkbyBrZXJuZWwgYnlwYXNzIGhhdmUgb25lIHRoZW1lIGluIGNvbW1vbjoNClRo
ZSBrZXJuZWwgcHJvY2VzcyBpcyBqdXN0IHRvbyBsb25nLiBUcnlpbmcgdG8gYWRkIG9uZSBmZWF0
dXJlIHRvIGZsb3dlciBjb3VsZCB0YWtlIGFueXdoZXJlIGZyb20gNiBtb250aHMgdG8gMyB5ZWFy
cyB0byBmaW5hbGx5IHNob3cgdXAgaW4gc29tZSBzdXBwb3J0ZWQgZGlzdHJvLiBXaXRoIFA0VEMg
d2UgYXJlIHRha2luZyB0aGUgYXBwcm9hY2ggb2Ygc2NyaXB0YWJpbGl0eSB0byBhbGxvdyBmb3Ig
c3BlYWNpbGl6ZWQgZGF0YXBhdGhzICh3aGljaCBQNCBleGNlbHMgaW4pLiBUaGUgZ29vZ2xlIGRh
dGFwYXRoIG1heWJlIHByb3ByaWV0YXJ5IHdoaWxlIHRoZWlyIGhhcmR3YXJlIG1heSBldmVuKG9y
IG5vdCkgYmUgdXNpbmcgbmF0aXZlIFA0IC0gYnV0IHRoZSBpbXBvcnRhbnQgZGV0YWlsIGlzIHdl
IGhhdmUgX2Egd2F5XyB0byBhYnN0cmFjdCB0aG9zZSBkYXRhcGF0aHMuDQoNCj4gPiBUaGVyZSBh
cmUgTklDcyBhbmQgc3dpdGNoZXMgd2hpY2ggYXJlIFA0IG5hdGl2ZSBpbiB0aGUgbWFya2V0Lg0K
Pg0KPiBMaW5rIHRvIGRvY3M/DQo+DQoNCk9mZiB0b3Agb2YgbXkgaGVhZCBJbnRlbCBNb3VudCBF
dmFucywgUGVuc2FuZG8sIFhpbGlueCBGUEdBcywgZXRjLiBUaGUgcG9pbnQgaXMgdG8gYnJpbmcg
dGhlbSB0b2dldGhlciB1bmRlciB0aGUgbGludXggdW1icmVsbGEuDQoNCj4gPiBJT1csIHRoZXJl
IGlzIGJlYWNvdXAgJCBpbnZlc3RtZW50IGluIHRoaXMgc3BhY2UgdGhhdCBtYWtlcyBpdCB3b3J0
aCBwdXJzdWluZy4NCj4NCj4gUHVyc3VpbmcgJCBpcyBnb29kISBCdXQgdGhlIGNvbW11bml0eSBJ
TU8gc2hvdWxkIG1heGltaXplIGEgZGlmZmVyZW50IA0KPiBmdW5jdGlvbi4NCg0KV2hpbGUgSSBh
Z3JlZSAkIGlzIG5vdCB0aGUgcHJpbWFyeSBtb3RpdmF0b3IgaXQgaXMgYSBmYWN0b3IsIGl0IGlz
IGEgZ29vZCBpbmRpY2F0b3IuIE5vIGRpZmZlcmVudCB0aGFuIHRoZSBuZXR3b3JrIHN0YWNrIGJl
aW5nIHR3ZWFrZWQgdG8gZG8gY2VydGFpbiB0aGluZ3MgdGhhdCBjZXJ0YWluIGh5cGVyc2NhbGVy
cyBuZWVkIGJlY2F1c2UgdGhleSBpbnZlc3QgJC4NCkkgaGF2ZSBubyBwcm9ibGVtcyB3aXRoIGEg
bGFyZ2UgaGFybW9uaW91cyB0ZW50Lg0KDQpjaGVlcnMsDQpqYW1hbA0KDQo+ID4gVEMgaXMgdGhl
IGtlcm5lbCBvZmZsb2FkIG1lY2hhbmlzbSB0aGF0IGhhcyBnYXRoZXJlZCBkZXBsb3ltZW50IA0K
PiA+IGV4cGVyaWVuY2Ugb3ZlciBtYW55IHllYXJzIC0gaGVuY2UgUDRUQy4NCj4NCj4gSSBkb24n
dCB3YW5uYSBhcmd1ZS4gSSB0aG91Z2h0IGl0J2QgYmUgbW9yZSBmYWlyIHRvd2FyZHMgeW91IGlm
IEkgbWFkZSANCj4gbXkgbGFjayBvZiBjb252aWN0aW9uIGtub3duLCByYXRoZXIgdGhhbiBzaXQg
cXVpZXQgYW5kIGlnbm9yZSBpdCBzaW5jZSANCj4gaXQncyBqdXN0IGFuIFJGQy4NCg==
