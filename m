Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4937461438F
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 04:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiKADSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 23:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiKADSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 23:18:41 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F405F89;
        Mon, 31 Oct 2022 20:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667272719; x=1698808719;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LLGUqaqhbBSGpDbst31TdXt2wnYWwjRvX4qrN9P9vd8=;
  b=j2Nq/pxRh7SH5e7Gjxc4btHKRq2IZrf10cTCry3FkiRELz6ILgEi0PUH
   Kr55/TpGSx1SnjyBWDb9zYcjFePEjoq6pm6sBttqq3tr0rvkEfLkWsMjF
   k6cZkqowOvNRaVfyfnHgwVO7n+WmIKp6Piu9k4LJLZwo3Ppza3vWY1bPK
   RVExyRgXYr0Y7dD+4BKAHC3XNgFUzw2TojGybNQFKnuNOB8ezULVFRMXr
   f1/nzl4AlymNi7GLcim8s25BuxFDJXDmMHgha921Oms+sEj3+6Z+scxVF
   otU62LENQ3l+1scpln7+6ZOO7StEA+PHqAzSXaZyu9Q188EXN1TwHHF1u
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="395368869"
X-IronPort-AV: E=Sophos;i="5.95,229,1661842800"; 
   d="scan'208";a="395368869"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 20:18:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="808777330"
X-IronPort-AV: E=Sophos;i="5.95,229,1661842800"; 
   d="scan'208";a="808777330"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 31 Oct 2022 20:18:38 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 20:18:37 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 31 Oct 2022 20:18:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 31 Oct 2022 20:18:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioPDt7ps1lGpQtyXXI5w4WYECgY6sXZk8n3H3uJjC5tBfCRInb9fsJ2wC1J4aEDRi1rhXDRWpaBrFNsBfrde0iqz/MD5gi/LdAi/X+JmWlChrRDmPm+pEda5PQ2VbCPt/Dfd+XoguZXoCmx7b7utxnK4bXvoZU1xDw9WBvUDhxL61FX+LpG1aatJ3ITz6F5OWwofCq3jVAdOj+5MdCNZuje9pW6PSXFUB+5jkHTCqgPpX32lhAO46rjiSB7Ofapl1jygc7oxl4i2RBEvgfGB7oC6lxe92v9sGEkNe/ldVX8Qiu43cmHkXqGgqo0Cq+esPCzjqS4X3pe8V/nB+FXSYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LLGUqaqhbBSGpDbst31TdXt2wnYWwjRvX4qrN9P9vd8=;
 b=bwIl0B/sYfdlrN99swOsTvcsCt2eKWysChCfkHX4m2R6cVWs8eCoThGXoDcY7ylsLwjJtvfqgzmh1SFBIVa5FymnG2c/ifQC4yyWbdj5YjKBax3LRELXWe3gH7JJXHtnUOghtBqnHkSNBOGY51BHR4rZXV9kGQx24AMQTssNGv/lwCBMwdvxeyCpeNiWf2rt8wLVOK7zXdjumoLBDwtyAxTKm8xPwuGBbhBU8zFAYxYhNY2PpH/dyyI1iAalgUUyCZakN2Y2Zv+EBjw6SQHMzjWuUdN4vWKu3W5506LZDNDYar3f2uUtw0D/r8uYaGzuzuvfN3YzKsu5N9BvEaFEjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5454.namprd11.prod.outlook.com (2603:10b6:5:399::22)
 by PH7PR11MB6380.namprd11.prod.outlook.com (2603:10b6:510:1f8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Tue, 1 Nov
 2022 03:18:35 +0000
Received: from DM4PR11MB5454.namprd11.prod.outlook.com
 ([fe80::d955:98eb:ec88:8154]) by DM4PR11MB5454.namprd11.prod.outlook.com
 ([fe80::d955:98eb:ec88:8154%4]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 03:18:34 +0000
From:   "Looi, Hong Aun" <hong.aun.looi@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
CC:     Vee Khee Wong <veekhee@apple.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Gan, Yi Fang" <yi.fang.gan@intel.com>,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>
Subject: RE: [PATCH net-next 1/1] stmmac: intel: Separate ADL-N and RPL-P
 device ID from TGL
Thread-Topic: [PATCH net-next 1/1] stmmac: intel: Separate ADL-N and RPL-P
 device ID from TGL
Thread-Index: AQHY6rPgEgDfUEMJ0UWR9lW6DQc0va4jnxUAgACMfoCABT3f8A==
Date:   Tue, 1 Nov 2022 03:18:34 +0000
Message-ID: <DM4PR11MB5454EA991FA941D68C7BDEF0BE369@DM4PR11MB5454.namprd11.prod.outlook.com>
References: <A23A7058-5598-46EB-8007-C401ADC33149@apple.com>
        <DM5PR11MB15935E3AF06794F523DB48C69D329@DM5PR11MB1593.namprd11.prod.outlook.com>
 <20221028120715.1dc12fc1@kernel.org>
In-Reply-To: <20221028120715.1dc12fc1@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5454:EE_|PH7PR11MB6380:EE_
x-ms-office365-filtering-correlation-id: 31b2aa40-0002-4a2b-0e87-08dabbb7c2a9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7cafnhLQfTSQl9oOgwhWs5xVWgy8ccvnIUiqSUEXG/g30XySgVrztORsSE+fwWYJaI5ByD9Fj//Fm0P12Qzlr3BqwV6voObSBDhPL+OhozVmeY+mSppnd0ar1aU4hdnjs8y6ubWB1hk0mkmQ39Yp9jkEAWzlKWHN6j4DOmNoz1F2d0eeB7lQ4Z9FLmlZOfZrfv5QIalWpXSqzi/ZfqOTq6UeBQoSg+T2XmNkh+GRNEBB9sCa6WGAJQ5xu3cJPhgd5DJfVk16XhbrPoMOiXiGY78GTW/A+vKPZm9Xk9IJyJODNa7KZyv+ru1IcleIEsdc2PhLEKYunZz1Scz+9ktAfh+khE/qR05cc+yxIZ4+q9wvzocyTRaz76Epdbeed7EHCd1I0eXc47snzCdUAY0GsJT/vfQtKTUvDde7mXIh7bBE557j0jHZMBOVKodUHJp4GeNJBKDYkKtEIN3n5KnIt591+5YKc0UzHD5d2cAxYdwHh3zRdrdBcL5U1tfDYkfAsbgIms0UJUuxvnywDU15uKbq+SfgX8ol8fh9IyTbGvNVOZlCKtT/euMHAGRajJXAOObMNqTJNlLbyoix8ZPDPLNtvI8bu3r2bMpdefyqWIyQGiIbJ3jhWWBb1K/Nlae2rPKq0CjPTfP1QXeki16+56R4TQ1s7eRMe7hoYsTa6Qc8K/0iLCyhk2EFPfTOM3oca/ZmLen6FxFVkm4klnBU3LuJJm2lcgxT01lxUXQnvECmwV7oiP9EQawuANUK59yLNpfqas7zSSrtKAPIxBQb9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5454.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199015)(71200400001)(107886003)(6506007)(7696005)(83380400001)(110136005)(66556008)(38070700005)(66946007)(66476007)(76116006)(66446008)(8676002)(82960400001)(55016003)(38100700002)(64756008)(4326008)(122000001)(33656002)(186003)(26005)(86362001)(9686003)(478600001)(316002)(54906003)(4744005)(8936002)(2906002)(52536014)(6636002)(7416002)(41300700001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0p0dVR5a2lPNWFJSlBGV2tXMHo4YTFPdVVrNDFPZzM2UnN2cUNjQTJpMGdt?=
 =?utf-8?B?cnZlcjQ3d0VneXdUTTNreVBnREswWURXeElsNmN4aWNmT2t2OFNnTDRDaFFm?=
 =?utf-8?B?QzEwSHFsMWhvMVh0MDl6ZjlXMnM0U2VoL05VTW5XT3MvQnorWGIzY21qRUd1?=
 =?utf-8?B?V1BUVmFSTFIxQjVXb3orOHBzTjdPb0ZIeWRjbm5aOGtiV2pTOCtCNXdGa3Nv?=
 =?utf-8?B?czV5dEc3OXF4a25NbEhxRDNJWFdmZnlQSUp3UWJzSGZzR01ickFSU3N4Q0tU?=
 =?utf-8?B?SVJQL0R4bFNGMTg2a3VpZ1hKaHFWUzBDTlpZNGwvQWswaXZoR0FtQnhRU0NU?=
 =?utf-8?B?V21uYlVXdnBJQjEyRFFVQ1R6cjgxbml2bnhlN1lLcnduOGFsVnhaQTd6Q1lr?=
 =?utf-8?B?UGpKb0xVZHlLbjRwQk9FMU81dUpIY1VldlpmVG53RUZ1Y0tpZU91a1ZKcWNM?=
 =?utf-8?B?TVVCMTM2SHNMMG42eU9jQ1ZKRGRlcG83UGxDT0h0aG9INjhhdXdOb0MyS1RZ?=
 =?utf-8?B?Wkc5cXdOcTVNV1JHTlQ1c2Nma1F5QlVFeDBNNFVsQ3hXcS9PeldoU2laMGFZ?=
 =?utf-8?B?blYwRnZkY0dwa3FIMThIQ3FPaXUyL0xYcm1hSkpScUFHRE92YXYrR2VOdXBR?=
 =?utf-8?B?SFRhcGJJY2JvS2pZeWVIME5OWGpEazVxaWNTdkx2aTVFRmUwbXZiNTdJSW1V?=
 =?utf-8?B?YkZCS3lKUDdxdElOekd2bFZJUUpyQWZFbEgxSEloZlpoNU5YTTJVdG5mVnV0?=
 =?utf-8?B?LytmdTJ0emhneGNrNjZ6Q01naGhudkhsejd6U0NpOE40bkt2bllDUThrVkUv?=
 =?utf-8?B?dFg0NHRqR2NCaFg3Y1RjajlESi93SGI1ZDhMcTlhVDZES0c4QkhQQ2c5bFlv?=
 =?utf-8?B?REtWMHl3d0MxVnE2MzN2dUF2aHhvaUJNdUx1SHJ2ZmRqVUxwVnRUdk9jcm1x?=
 =?utf-8?B?OEQ2c2tuMFNqbWNtSE9PazJIM0NmWVJ2Q01VZVNsSTYvaDlDSVBHem81NEsr?=
 =?utf-8?B?ZkFUdVpNcEtFRklwdVFtVkxyNThKa0tmUHVjcUhoRGFBaEVRY1pHVk1sMWtY?=
 =?utf-8?B?MGVEc3k3MFFoL0E1cUp6RmNzZFZmbGZZazZjUmhGaXFWZUhKVWM1dzNwcUJN?=
 =?utf-8?B?dGhiSFNKRVFMRWxla0NaZ1dXSWVMWmZDaFlJcThyZ0hzVmR4cEpsVmcxV3ZU?=
 =?utf-8?B?b0UvOTR4a3V5S2lpUURGS1lxKytMWWJKa0hYWVZKUE8xU2xXK1NnOVY1UERw?=
 =?utf-8?B?SGVIMGhKVkg1RmpGSU9HLzE0RnlUd0Nna3dNcUpNSHVtd0hTcktGYlcvYWtD?=
 =?utf-8?B?TmRseXEwWWtMRlhsY2Fqd3VuL0pURmd4UHZFL09hSjVpQVloOGhGL2pMaFVD?=
 =?utf-8?B?MjZUSUN3YmlGczJINklhTzdtN2lZdWdmajlkaDRyWHJmWTZEUGJDVjg4ZnVI?=
 =?utf-8?B?Z0pBSFBESDN0N3ZhZWVQZFd6b0hIem1HbUxQN0hmVWxhUWJUTERyZ0pJMXhT?=
 =?utf-8?B?MGNpbEZzeHIyUXR5Tm9iVTdyQ1RiK1N0dnV5d215SDFDYndWeExsTkdaWnNy?=
 =?utf-8?B?OWZvM05SeFhNeHBsTEhXeWxRM2xvVVdkU0ZQT091U2d3d09FV2xyYzNTNTBL?=
 =?utf-8?B?TXUwOWJnaUNWRXIrdmgra1dTVy9iZTdwb2tqN0JCL3VJWDNNWWlIZDVTdXNl?=
 =?utf-8?B?TnJGVjByU3JXejBXWGxkaURSalUxWlhMWG0wRGcxS0VUa0VzTDVaZzMyVDBO?=
 =?utf-8?B?SkxqbjJ3VlBJL2ZWT3diYUdpd3BMREtIZU5BK3pXdC9xbCtYVTZJaWVLUlY5?=
 =?utf-8?B?c2wwTFFBMEk5VjFiN2ZYbEltZUNGZlJlT3BkMnZER3pqMkFCTm52d002UE5j?=
 =?utf-8?B?cDZSRHhFRXF5RFBSbW5kNXpIc0duV1h6MzJaNmMxblR2LzdJam5pVUJiUjhV?=
 =?utf-8?B?dDR5dXQxVkluVEFRUEFkc2FYRGVVR3pBSUkzZGRxQnBJTzN3OC9uVFoveUhP?=
 =?utf-8?B?S2JpcHJIS1ZrLzQ4bXVWTmEvVlFVTmdBTUhmTXQ0MzNBUHMzRi9VdGwyTmth?=
 =?utf-8?B?SXVrVy9JUitzU2tEKzE5eWlxVFJSR1BDMnR0S2I1ZE1Fc1UxZVBzek4vUHJF?=
 =?utf-8?Q?Yk8mVPfGeDEb8F3u+IMzUlG/7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5454.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31b2aa40-0002-4a2b-0e87-08dabbb7c2a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 03:18:34.5458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dylivc5vArQknBPjccs+QldtA2qTLKNV584d+z+/ze6uuu34OGIANScKoqxVcByXjsucz/8UsEiKFX4z+F3UQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6380
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBGcmksIDI4IE9jdCAyMDIyIDEwOjQ0OjI0ICswMDAwIFNpdCwgTWljaGFlbCBXZWkgSG9u
ZyB3cm90ZToNCj4gPiBUaGlzIGlzIHRvIGFsbG93IGZpbmVyIGNvbnRyb2wgb24gcGxhdGZvcm0g
c3BlY2lmaWMgZmVhdHVyZXMgZm9yIEFETCBhbmQgUlBMLg0KPiA+IFRoZXJlIGFyZSBzb21lIGZl
YXR1cmVzIHRoYXQgQURMIGFuZCBSUEwgZG9lc27igJl0IHN1cHBvcnQgYW5kIFRHTA0KPiBzdXBw
b3J0cyB2aWNlIHZlcnNhLg0KPiANCj4gQnV0IGlmIHRoZXkgYXJlIHRoZSBzYW1lIF9yaWdodF8g
X25vd18gd2hhdCdzIHRoZSBwb2ludD8NCj4gUGxlYXNlIHJlcG9zdCBhcyBwYXJ0IG9mIGEgc2Vy
aWVzIHdoaWNoIGFjdHVhbGx5IG1vZGlmaWVzIHRoZSBjb250ZW50cy4NCj4gDQo+IFBsZWFzZSBy
ZW1lbWJlciBub3QgdG8gdG9wIHBvc3Qgb24gdGhlIE1MLg0KDQpOb3RlZC4gVGhhbmtzIFZlZSBL
aGVlIGFuZCBKYWt1YiBmb3IgdGhlIGNvbW1lbnRzLiBUaGVyZSBpcyBzb21lIHdvcmsgaW4gcHJv
Z3Jlc3MgYXMgcGFydCBvZiBBREwtTiBkZXZlbG9wbWVudC4gV2UnbGwgc3VibWl0IGEgY29tcGxl
dGUgcGF0Y2hzZXQgd2hlbiBpdCBpcyBjb21wbGV0ZWQgaW4gdGhlIGZ1dHVyZS4gTGV0J3MgY2xv
c2UgdGhlIHJldmlldyBmb3IgdGhpcyBwYXRjaCBmb3Igbm93Lg0K
