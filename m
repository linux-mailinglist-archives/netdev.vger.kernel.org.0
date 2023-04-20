Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4095F6E90F3
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 12:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjDTKuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 06:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235068AbjDTKsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 06:48:53 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171EC5B95
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 03:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681987640; x=1713523640;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zWGljulJAGQLDBKR5tyCTGE6LT21pq55+aRMSB+Op/E=;
  b=lqj/oWsCLZvcrLvBANeM7Vb/xhhZ/2Uu9JsIQeXWlG18b/VtHaSm1eYk
   bQana2HZaOUOYGehfkb8LLzHIvWjj7iw14hqUM1qwFghfa/S0dWmxqzsU
   DzIllvD6xaVlAyO1riQF6cMz/Dpg30aSzQwa1Ua5qmjB5OY2sUClMAstM
   z7auhSzUwz/qnEGSPfdCyHb6md2EsPs9pzbBl0TEx3wScJethi/bptOwk
   tjNiBBG/4bDJnNKl9YEFmINxlbWAUyagC3wt8vI48cnl4B9GumRcifavU
   xbR+ZF4uNpLLh7+fgF7uSCrAdC3T/KFIvij57X6ZHNuSSpnPgAWn7yf0/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="431978944"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="431978944"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 03:46:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="938014858"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="938014858"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 20 Apr 2023 03:46:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 03:46:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 03:46:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 03:46:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a87QEC1YOQ0JsOy8WL2L2PgrCt5z609x3Sh/pxWVwoqFg7K4qGPoQ38h6/9w2jmfxmalusI1WKNgZPqm+eBvb48vJ3jHvDXqGvhavA8QybhP4cjVBZ8gZnIS7qN3mckL0j/hjqyZ0iBzO/IretpCSt0dZUCiXIrjIen2RQf9+JUpoYJ8Yt5bLA/b2CzGclRcL6iZK3s2UKFNfXy3zWeoWyJSCQ+IVEw9wopurJj2GuTxES3taT9pn7vbqaaJmvN+ZeRmXl4iQYs7x96TsiJrxC3qRouR6ApqTJuNC1POQ3o3wD1r/NTdOCW5nVHJnVPpGhaAhfgjIL5nRf+2sbSgzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWGljulJAGQLDBKR5tyCTGE6LT21pq55+aRMSB+Op/E=;
 b=IL5SmWwMatV9mbgdZZvYuSZo0OPzIzx15QsfyVKscHmiUq2VP3cR2a6wgkFFtVAoFHMZ994EXs1/JmVXv9a7eD3y/tSYiSMv4+Bl64M8ag6DpXVPE9hfZO1ShE0aTb/pfU/KBvOiIG83idUXvEdeypZZeZ7btv6aVNz+6aDr4iDzvHbSjLuBjnsUFJF8oOxANyQ/rFOS1b7XDJ0oUrkpw8ODbExUSt86d/0a0V1rK1FlVyLu8tknGYIFditO9I45LCgvFaqCG/g7J3DBwENjD0SbqvYo3rcnjWieYMHsBN/VrRB0+sXZ7d2CvzAWPTkVHlQZENDd58BcPUGANyZRjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by BL1PR11MB5334.namprd11.prod.outlook.com (2603:10b6:208:312::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.21; Thu, 20 Apr
 2023 10:46:32 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0%6]) with mapi id 15.20.6298.045; Thu, 20 Apr 2023
 10:46:31 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     "Lobakin, Aleksander" <aleksander.lobakin@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
        "Chmielewski, Pawel" <pawel.chmielewski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [PATCH net-next 04/12] ice: Implement basic eswitch bridge setup
Thread-Topic: [PATCH net-next 04/12] ice: Implement basic eswitch bridge setup
Thread-Index: AQHZctMVsnGBKGKcRE2LRxEZIa88QK8z7OnwgAAWhCA=
Date:   Thu, 20 Apr 2023 10:46:31 +0000
Message-ID: <MW4PR11MB5776C243E4904E9A15E014A6FD639@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-5-wojciech.drewek@intel.com>
 <4a293c46-f112-e985-f9ad-19a41dd64f01@intel.com>
 <MW4PR11MB5776C7DDDB91DD98A960AD20FD639@MW4PR11MB5776.namprd11.prod.outlook.com>
In-Reply-To: <MW4PR11MB5776C7DDDB91DD98A960AD20FD639@MW4PR11MB5776.namprd11.prod.outlook.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|BL1PR11MB5334:EE_
x-ms-office365-filtering-correlation-id: 13d2e700-b12c-41f1-c1a3-08db418c80ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3kFjXcLasJL3hWJJjq4d+jBvSdzWkkLk2Y6oE/GMa53lCgJQbQ2Jb1cxeeZ6Tc3xKQAnA/UBInyDXE0LzfDjpZzm7e2E6xQGmIcFXjeZMWglA1f4BCyfXcx1yNKPnoxfRBrKnspdUSs2IELc1Nrp9pShExtAo6VAWQeTVm7+jY/ZnRbrhBy0hl5ntWKqY7Tf1v+AoEBEFf+eEX1c1QKbDhe80HRozIqMdPveGooaXQWTd8QG9Ufk5I2gFD6hJr7MCUlbMBIPt/u2ZIqMehyHL7WJucJF3D/0pFkVH7rwfHdRdiBPtoKUWefNKhA6DJVlrzV7Zq2NQc9att8tyctEenb+zhzWCH+i+Jf95T4/cJe9B9/OP5SYnqI1DVkFAt1K7paQTxF+n5vAGGlcFpKlKgiRlsLij4ooKzsINzqCqgLEwsUB6cTcN4/mtq7vv05b0MeBSrsHW+fKlCPemnh1lkB3bMDsuq+7iYqQU13jFklPUlPP/t0ihjg2+BJpRSOIXBVDRp5PEsnOiN5uKc6Ylnzdy498ROcxnO291IhMkCOyrkm6yeKjNuCmhjvXqlUIMUh/mcldAUXxSnRME+imlgusBt67Eky9ttCiMlrW+ezBN8zrrLPhvN5Ffjok2ow4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199021)(82960400001)(38070700005)(122000001)(33656002)(6862004)(52536014)(83380400001)(5660300002)(2906002)(86362001)(8936002)(8676002)(53546011)(9686003)(6506007)(186003)(26005)(316002)(4326008)(66556008)(66446008)(66476007)(71200400001)(7696005)(2940100002)(66946007)(38100700002)(76116006)(55016003)(64756008)(41300700001)(478600001)(6636002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXl3MjBjM3ZZei81dmZoUC9kMlkvQ2ZNbStFYVlwdXV2cVd4T0ZSZFFvbHEz?=
 =?utf-8?B?Y1lrWWcrT1RBU09xMUNjV2xLOGRoSlc3aW9zUjRBd2krbWZCc1o4cDFWbWds?=
 =?utf-8?B?NTJYM08zTHpMdkdlQjQvZEZyYVJhaVVQaklGNTNFeHRzc1EyWVdaeTBFTDF4?=
 =?utf-8?B?cHdhNHJYSzNzd1MwSzcrQzhwRTExRTk2K3A4M0QrY0RMSjRBaXlpcHdybFFB?=
 =?utf-8?B?SkI4MTc2ckt1NllQQkY3eWE1TWxMeDJWVjJ3UDdMYUptR3gwU3d6TFpqcVhP?=
 =?utf-8?B?NmdnSE9ScjkyMWJpR1I3WElyeGpNTTFGdjlmbUZRdDk5SjZzK1dxdHJxNHpk?=
 =?utf-8?B?N04xNERiUnduanBYdGk2ZXFZb25rTERMNzhqOHArbUVxdWQ4YkhlWG9Mc2hE?=
 =?utf-8?B?MkFDaGc3M1M5OHhqZ29Nc1VCN2ZEdWNhMEhNL2NrSlF0Q0VFWEdiMktzS2Rj?=
 =?utf-8?B?UDdBZUc4TWZSa1c2VHZhQUNKMFBmVThNaFI1WVhsdHptYnBmenU5aXRZYkhu?=
 =?utf-8?B?Uzk0YVlSdWFESzNqck5QdUNDcUREQkkyMlcwS0NVYVhDOFhsbkh1bDhjbmpD?=
 =?utf-8?B?UWkrdmdTVFVvaGxiTGZRY2R1a29MT1kwTjMzN3d4UElYUUJrZ1FnYzAzQ0tt?=
 =?utf-8?B?WUd4VUJwUk5HQTRnMlY3LzYzS3BMWVhZZjYwY285Q2xPTnNQdG1mb0IweVlr?=
 =?utf-8?B?dlJkSTdEcGt1V1c4eVZ2dG83R1E4VzJxYlRuYlo2TnJWcXljSFM5cjBxK1dY?=
 =?utf-8?B?UW91b1Z6L3BHeW4xd04ycWJaZlJXUzlTTlI2Q0RHRUhmOHVQcC9xZHRTOEZ6?=
 =?utf-8?B?VzNjTXhKbmV2UmhxVG51emJQS0hKMzBVcy9DdXNFRTFubHFpYXRwYm4rR1Nx?=
 =?utf-8?B?R0RMalJRY2h0UnFDOUFwbjZ1ckQrRkJjQ1dRR2JMcER3WnpCTWk4cVhWZllS?=
 =?utf-8?B?Zi8xeWNIYkR5dEM4bmJueDRyNjdQdU8rWUU4eWxmZWFTU0hGTk9tMko2REF3?=
 =?utf-8?B?YVE4eWxrTmlrTXFZY1B6em5JR2NUbmxTbWJ4bklYQ1pNaTBlTEdUNjdSMUIz?=
 =?utf-8?B?bDFmbmtCank4LzRVb1poWG1YZ2ptSXlHSUkzSDZtNURHRVROU2xYb09GdmY0?=
 =?utf-8?B?bk1Nc2ExU1NYT28rSW9CeElCSEt5ajlxNWNIQXpqMXFVcGIxRXdyc3BtcmdK?=
 =?utf-8?B?ZWVCSnZ3eTdsenFzS3VhdnhFV0I4ZFVQaDFlQkxZLzZsRHpiWjJ2dklNMHF0?=
 =?utf-8?B?NE9iblFrU1RUOVVNbzdxZHRmMjY5WCtrQlhXYnFqZk94ZWRqcklMbW52Zm9O?=
 =?utf-8?B?U2w3NVlpdE9FWGNlcGNiN3B3RWpNN3I2ZEtod1puMDA2S055VlpEOHJ5TjlM?=
 =?utf-8?B?OUdNM0wrZTNuRXlvMmk4OWNwQXFIdityK0V2NjJZeHd0NjFlbkxxZ3VKd3k5?=
 =?utf-8?B?RzlQSC9EWE45V3FnWlhtdFdaZDlzZ0NTWmo3NDNqZzFTRnVpWnVsajgrcklT?=
 =?utf-8?B?ZnhmNWVJaXpJd004UkN1V2hWeFNxRkw0VEdTZTZnRmdOUDFYOFE1ZElEWFFZ?=
 =?utf-8?B?Q2lWb2FpWmxCSG9pYW9aazEyQncxOGxDYUlPcEhKTDVJR242WVUzZXU5eGFo?=
 =?utf-8?B?ZXo0VS9DUk1pUlNzYTlZOUZWdDBNaFdRTDhLeFhYWTkrbkdtV2JwOWpDSkw5?=
 =?utf-8?B?MWhBSzdxVTVzZll1SzBWV3pTZ2JCVUVhckNFVVBCNGR5YUI4RWlvbFNtS1Rs?=
 =?utf-8?B?dFZ6aU5TeFBxZFRBZDZXVFVqT2dTUysyb2lkRlFsTllMaDBnM3N4L3ljczRF?=
 =?utf-8?B?WjYxTVhCOEhxdnh3ZFNaVWxzSGZIQUdjaG1wR2hSR2JXRzN1NjNvc1ZueURU?=
 =?utf-8?B?NFBmVmVBVVhBRXIwSndEcHpVSm4raVRGdmtpM2dNQzZIeEgxUTlNOG9BaVBi?=
 =?utf-8?B?VEg1YXJQamZpTWY2eERBL1VlYkVXQ25GQkZselBLeEx2MTlQRVc1MHZubllR?=
 =?utf-8?B?WnE0NzhOYmp0STd4Y3k5eW1iUXlBcEE3S0Q1QU9UaXpqRnBOTll5MUFDS3N4?=
 =?utf-8?B?R2FhTmhPMTVwZlpEelNXckx2aDJKVEhIR25PRGtCTnhpQXpqUytZemVvK3B4?=
 =?utf-8?Q?tpYLqcV73cBJqpEG64GKGuQXN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13d2e700-b12c-41f1-c1a3-08db418c80ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 10:46:31.7016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H5i3Lm/TT8iFVcty88eZU6no5/dziqm3Mj9alL2YiO7GFgoQhKfDYamLE0YULdvtZ/PBNSd4NWBJ5mVkIJo6pJcyHVv8NrE5qMBg2drPSZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5334
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRHJld2VrLCBXb2pjaWVj
aA0KPiBTZW50OiBjendhcnRlaywgMjAga3dpZXRuaWEgMjAyMyAxMTo1NA0KPiBUbzogTG9iYWtp
biwgQWxla3NhbmRlciA8YWxla3NhbmRlci5sb2Jha2luQGludGVsLmNvbT4NCj4gQ2M6IGludGVs
LXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBFcnRt
YW4sIERhdmlkIE0gPGRhdmlkLm0uZXJ0bWFuQGludGVsLmNvbT47DQo+IG1pY2hhbC5zd2lhdGtv
d3NraUBsaW51eC5pbnRlbC5jb207IG1hcmNpbi5zenljaWtAbGludXguaW50ZWwuY29tOyBDaG1p
ZWxld3NraSwgUGF3ZWwgPHBhd2VsLmNobWllbGV3c2tpQGludGVsLmNvbT47DQo+IFNhbXVkcmFs
YSwgU3JpZGhhciA8c3JpZGhhci5zYW11ZHJhbGFAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSRTog
W1BBVENIIG5ldC1uZXh0IDA0LzEyXSBpY2U6IEltcGxlbWVudCBiYXNpYyBlc3dpdGNoIGJyaWRn
ZSBzZXR1cA0KPiANCj4gVGhhbmtzIGZvciByZXZpZXcgT2xlayENCj4gDQo+IE1vc3Qgb2YgdGhl
IGNvbW1lbnRzIHNvdW5kIHJlYXNvbmFibGUgdG8gbWUgKGFuZCBJIHdpbGwgaW5jbHVkZSB0aGVt
KSB3aXRoIHNvbWUgZXhjZXB0aW9ucy4NCj4gDQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQo+ID4gRnJvbTogTG9iYWtpbiwgQWxla3NhbmRlciA8YWxla3NhbmRlci5sb2Jha2lu
QGludGVsLmNvbT4NCj4gPiBTZW50OiDFm3JvZGEsIDE5IGt3aWV0bmlhIDIwMjMgMTc6MjQNCj4g
PiBUbzogRHJld2VrLCBXb2pjaWVjaCA8d29qY2llY2guZHJld2VrQGludGVsLmNvbT4NCj4gPiBD
YzogaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IEVydG1hbiwgRGF2aWQgTSA8ZGF2aWQubS5lcnRtYW5AaW50ZWwuY29tPjsNCj4gPiBtaWNo
YWwuc3dpYXRrb3dza2lAbGludXguaW50ZWwuY29tOyBtYXJjaW4uc3p5Y2lrQGxpbnV4LmludGVs
LmNvbTsgQ2htaWVsZXdza2ksIFBhd2VsIDxwYXdlbC5jaG1pZWxld3NraUBpbnRlbC5jb20+Ow0K
PiA+IFNhbXVkcmFsYSwgU3JpZGhhciA8c3JpZGhhci5zYW11ZHJhbGFAaW50ZWwuY29tPg0KPiA+
IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMDQvMTJdIGljZTogSW1wbGVtZW50IGJhc2lj
IGVzd2l0Y2ggYnJpZGdlIHNldHVwDQo+ID4NCj4gPiBGcm9tOiBXb2pjaWVjaCBEcmV3ZWsgPHdv
amNpZWNoLmRyZXdla0BpbnRlbC5jb20+DQo+ID4gRGF0ZTogTW9uLCAxNyBBcHIgMjAyMyAxMToz
NDowNCArMDIwMA0KPiA+DQo+ID4gPiBXaXRoIHRoaXMgcGF0Y2gsIGljZSBkcml2ZXIgaXMgYWJs
ZSB0byB0cmFjayBpZiB0aGUgcG9ydA0KPiA+ID4gcmVwcmVzZW50b3JzIG9yIHVwbGluayBwb3J0
IHdlcmUgYWRkZWQgdG8gdGhlIGxpbnV4IGJyaWRnZSBpbg0KPiA+ID4gc3dpdGNoZGV2IG1vZGUu
IExpc3RlbiBmb3IgTkVUREVWX0NIQU5HRVVQUEVSIGV2ZW50cyBpbiBvcmRlciB0bw0KPiA+ID4g
ZGV0ZWN0IHRoaXMuIGljZV9lc3dfYnIgZGF0YSBzdHJ1Y3R1cmUgcmVmbGVjdHMgdGhlIGxpbnV4
IGJyaWRnZQ0KPiA+ID4gYW5kIHN0b3JlcyBhbGwgdGhlIHBvcnRzIG9mIHRoZSBicmlkZ2UgKGlj
ZV9lc3dfYnJfcG9ydCkgaW4NCj4gPiA+IHhhcnJheSwgaXQncyBjcmVhdGVkIHdoZW4gdGhlIGZp
cnN0IHBvcnQgaXMgYWRkZWQgdG8gdGhlIGJyaWRnZSBhbmQNCj4gPiA+IGZyZWVkIG9uY2UgdGhl
IGxhc3QgcG9ydCBpcyByZW1vdmVkLiBOb3RlIHRoYXQgb25seSBvbmUgYnJpZGdlIGlzDQo+ID4g
PiBzdXBwb3J0ZWQgcGVyIGVzd2l0Y2guDQo+ID4NCj4gPiBbLi4uXQ0KPiA+DQo+ID4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZS5oIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZS5oDQo+ID4gPiBpbmRleCBhYzI5NzEwNzNmZGQuLjVi
MmFkZTU5MDhlOCAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2ljZS9pY2UuaA0KPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2lj
ZS5oDQo+ID4gPiBAQCAtNTExLDYgKzUxMSw3IEBAIHN0cnVjdCBpY2Vfc3dpdGNoZGV2X2luZm8g
ew0KPiA+ID4gIAlzdHJ1Y3QgaWNlX3ZzaSAqY29udHJvbF92c2k7DQo+ID4gPiAgCXN0cnVjdCBp
Y2VfdnNpICp1cGxpbmtfdnNpOw0KPiA+ID4gIAlib29sIGlzX3J1bm5pbmc7DQo+ID4gPiArCXN0
cnVjdCBpY2VfZXN3X2JyX29mZmxvYWRzICpicl9vZmZsb2FkczsNCj4gPg0KPiA+IDctYnl0ZSBo
b2xlIGhlcmUgdW5mb3J0dW5hdGVseSA9XCBBZnRlciA6OmlzX3J1bm5pbmcuIFlvdSBjYW4gcGxh
Y2UNCj4gPiA6OmJyX29mZmxvYWRzICpiZWZvcmUqIDo6aXNfcnVubmluZyB0byBhdm9pZCB0aGlz
ICh3ZWxsLCB5b3UnbGwgc3RpbGwNCj4gPiBoYXZlIGl0LCBidXQgYXMgcGFkZGluZyBhdCB0aGUg
ZW5kIG9mIHRoZSBzdHJ1Y3R1cmUpLg0KPiA+IC4uLm9yIGNoYW5nZSA6OmlzX3J1bm5pbmcgdG8g
InVuc2lnbmVkIGxvbmcgZmxhZ3MiIHRvIG5vdCB3YXN0ZSAxIGJ5dGUNCj4gPiBmb3IgMSBiaXQg
YW5kIGhhdmUgNjMgZnJlZSBmbGFncyBtb3JlIDpEDQo+ID4NCj4gPiA+ICB9Ow0KPiA+ID4NCj4g
PiA+ICBzdHJ1Y3QgaWNlX2FnZ19ub2RlIHsNCj4gPg0KPiA+IFsuLi5dDQo+ID4NCj4gPiA+ICtz
dGF0aWMgc3RydWN0IGljZV9lc3dfYnJfcG9ydCAqDQo+ID4gPiAraWNlX2Vzd2l0Y2hfYnJfbmV0
ZGV2X3RvX3BvcnQoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gPg0KPiA+IEFsc28gY29uc3Q/
DQoNClRoaXMgZnVuY3Rpb24gY2hhbmdlcyBhIGJpdCBpbiAiaWNlOiBBY2NlcHQgTEFHIG5ldGRl
dnMgaW4gYnJpZGdlIG9mZmxvYWRzIg0KV2l0aCB0aGUgY2hhbmdlcyBpbnRyb2R1Y2VkIGluIHRo
aXMgY29tbWl0LCBJIHRoaW5rIHRoYXQgQGRldiBhcyBjb25zdGFudCBpcyBub3QgYSBnb29kIG9w
dGlvbi4NCg0KPiA+DQo+ID4gPiArew0KPiA+ID4gKwlpZiAoaWNlX2lzX3BvcnRfcmVwcl9uZXRk
ZXYoZGV2KSkgew0KPiA+ID4gKwkJc3RydWN0IGljZV9yZXByICpyZXByID0gaWNlX25ldGRldl90
b19yZXByKGRldik7DQo+ID4gPiArDQo+ID4gPiArCQlyZXR1cm4gcmVwci0+YnJfcG9ydDsNCj4g
PiA+ICsJfSBlbHNlIGlmIChuZXRpZl9pc19pY2UoZGV2KSkgew0KPiA+ID4gKwkJc3RydWN0IGlj
ZV9wZiAqcGYgPSBpY2VfbmV0ZGV2X3RvX3BmKGRldik7DQo+ID4NCj4gPiBCb3RoIEByZXByIGFu
ZCBAcGYgY2FuIGFsc28gYmUgY29uc3QgOnANCg0KUmVwciBtYWtlcyBzZW5zZSB0byBtZSwgdGhl
IHNlY29uZCBwYXJ0IHdpbGwgY2hhbmdlIGxhdGVyIGFuZCBJIHRoaW5rIHRoYXQNCnRoZXJlIGlz
IG5vIHBvaW50IGluIG1ha2luZyBpdCBjb25zdA0KDQo+ID4NCj4gPiA+ICsNCj4gPiA+ICsJCXJl
dHVybiBwZi0+YnJfcG9ydDsNCj4gPiA+ICsJfQ0KPiA+ID4gKw0KPiA+ID4gKwlyZXR1cm4gTlVM
TDsNCj4gPiA+ICt9DQo+ID4NCj4gPiBbLi4uXQ0KPiA+DQo+ID4gPiArc3RhdGljIHN0cnVjdCBp
Y2VfZXN3X2JyX3BvcnQgKg0KPiA+ID4gK2ljZV9lc3dpdGNoX2JyX3BvcnRfaW5pdChzdHJ1Y3Qg
aWNlX2Vzd19iciAqYnJpZGdlKQ0KPiA+ID4gK3sNCj4gPiA+ICsJc3RydWN0IGljZV9lc3dfYnJf
cG9ydCAqYnJfcG9ydDsNCj4gPiA+ICsNCj4gPiA+ICsJYnJfcG9ydCA9IGt6YWxsb2Moc2l6ZW9m
KCpicl9wb3J0KSwgR0ZQX0tFUk5FTCk7DQo+ID4gPiArCWlmICghYnJfcG9ydCkNCj4gPiA+ICsJ
CXJldHVybiBFUlJfUFRSKC1FTk9NRU0pOw0KPiA+ID4gKw0KPiA+ID4gKwlicl9wb3J0LT5icmlk
Z2UgPSBicmlkZ2U7DQo+ID4NCj4gPiBTaW5jZSB5b3UgYWx3YXlzIHBhc3MgQGJyaWRnZSBmcm9t
IHRoZSBjYWxsIHNpdGUgZWl0aGVyIHdheSwgZG9lcyBpdA0KPiA+IG1ha2Ugc2Vuc2UgdG8gZG8g
dGhhdCBvciB5b3UgY291bGQganVzdCBhc3NpZ24gLT4gYnJpZGdlIG9uIHRoZSBjYWxsDQo+ID4g
c2l0ZXMgYWZ0ZXIgYSBzdWNjZXNzZnVsIGFsbG9jYXRpb24/DQo+IA0KPiBJIGNvdWxkIGRvIHRo
YXQgYnV0IEkgcHJlZmVyIHRvIGtlZXAgaXQgdGhpcyB3YXkuDQo+IFdlIGhhdmUgdHdvIHR5cGVz
IG9mIHBvcnRzIGFuZCB0aGlzIGZ1bmN0aW9uIGlzIGdlbmVyaWMsIEl0IHNldHVwcw0KPiB0aGlu
Z3MgY29tbW9uIGZvciBib3RoIHR5cGVzLCBpbmNsdWRpbmcgYnJpZGdlIHJlZi4NCj4gQXJlIHlv
dSBvayB3aXRoIGl0Pw0KPiANCj4gPg0KPiA+ID4gKw0KPiA+ID4gKwlyZXR1cm4gYnJfcG9ydDsN
Cj4gPiA+ICt9DQo+ID4NCj4gPiBbLi4uXQ0KPiA+DQo+ID4gPiArc3RhdGljIGludA0KPiA+ID4g
K2ljZV9lc3dpdGNoX2JyX3BvcnRfY2hhbmdldXBwZXIoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICpu
Yiwgdm9pZCAqcHRyKQ0KPiA+ID4gK3sNCj4gPiA+ICsJc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9
IG5ldGRldl9ub3RpZmllcl9pbmZvX3RvX2RldihwdHIpOw0KPiA+ID4gKwlzdHJ1Y3QgbmV0ZGV2
X25vdGlmaWVyX2NoYW5nZXVwcGVyX2luZm8gKmluZm8gPSBwdHI7DQo+ID4gPiArCXN0cnVjdCBp
Y2VfZXN3X2JyX29mZmxvYWRzICpicl9vZmZsb2FkcyA9DQo+ID4gPiArCQlpY2VfbmJfdG9fYnJf
b2ZmbG9hZHMobmIsIG5ldGRldl9uYik7DQo+ID4NCj4gPiBNYXliZSBhc3NpZ24gaXQgb3V0c2lk
ZSB0aGUgZGVjbGFyYXRpb24gYmxvY2sgdG8gYXZvaWQgbGluZSB3cmFwPw0KPiA+DQo+ID4gPiAr
CXN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjazsNCj4gPiA+ICsJc3RydWN0IG5ldF9kZXZp
Y2UgKnVwcGVyOw0KPiA+ID4gKw0KPiA+ID4gKwlpZiAoIWljZV9lc3dpdGNoX2JyX2lzX2Rldl92
YWxpZChkZXYpKQ0KPiA+ID4gKwkJcmV0dXJuIDA7DQo+ID4gPiArDQo+ID4gPiArCXVwcGVyID0g
aW5mby0+dXBwZXJfZGV2Ow0KPiA+ID4gKwlpZiAoIW5ldGlmX2lzX2JyaWRnZV9tYXN0ZXIodXBw
ZXIpKQ0KPiA+ID4gKwkJcmV0dXJuIDA7DQo+ID4gPiArDQo+ID4gPiArCWV4dGFjayA9IG5ldGRl
dl9ub3RpZmllcl9pbmZvX3RvX2V4dGFjaygmaW5mby0+aW5mbyk7DQo+ID4gPiArDQo+ID4gPiAr
CXJldHVybiBpbmZvLT5saW5raW5nID8NCj4gPiA+ICsJCWljZV9lc3dpdGNoX2JyX3BvcnRfbGlu
ayhicl9vZmZsb2FkcywgZGV2LCB1cHBlci0+aWZpbmRleCwNCj4gPiA+ICsJCQkJCSBleHRhY2sp
IDoNCj4gPiA+ICsJCWljZV9lc3dpdGNoX2JyX3BvcnRfdW5saW5rKGJyX29mZmxvYWRzLCBkZXYs
IHVwcGVyLT5pZmluZGV4LA0KPiA+ID4gKwkJCQkJICAgZXh0YWNrKTsNCj4gPg0KPiA+IEFuZCBo
ZXJlIGRvIHRoYXQgdmlhIGBpZiByZXR1cm4gZWxzZSByZXR1cm5gIHRvIGF2b2lkIG11bHRpLWxp
bmUgdGVybmFyeT8NCj4gPg0KPiA+ID4gK30NCj4gPiA+ICsNCj4gPiA+ICtzdGF0aWMgaW50DQo+
ID4gPiAraWNlX2Vzd2l0Y2hfYnJfcG9ydF9ldmVudChzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5i
LA0KPiA+ID4gKwkJCSAgdW5zaWduZWQgbG9uZyBldmVudCwgdm9pZCAqcHRyKQ0KPiA+DQo+ID4g
Wy4uLl0NCj4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2ljZS9pY2VfZXN3aXRjaF9ici5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2lj
ZV9lc3dpdGNoX2JyLmgNCj4gPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gPiBpbmRleCAw
MDAwMDAwMDAwMDAuLjUzZWEyOTU2OWMzNg0KPiA+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ID4gKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9lc3dpdGNoX2JyLmgNCj4gPiA+
IEBAIC0wLDAgKzEsNDIgQEANCj4gPiA+ICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BM
LTIuMCAqLw0KPiA+ID4gKy8qIENvcHlyaWdodCAoQykgMjAyMywgSW50ZWwgQ29ycG9yYXRpb24u
ICovDQo+ID4gPiArDQo+ID4gPiArI2lmbmRlZiBfSUNFX0VTV0lUQ0hfQlJfSF8NCj4gPiA+ICsj
ZGVmaW5lIF9JQ0VfRVNXSVRDSF9CUl9IXw0KPiA+ID4gKw0KPiA+ID4gK2VudW0gaWNlX2Vzd19i
cl9wb3J0X3R5cGUgew0KPiA+ID4gKwlJQ0VfRVNXSVRDSF9CUl9VUExJTktfUE9SVCA9IDAsDQo+
ID4gPiArCUlDRV9FU1dJVENIX0JSX1ZGX1JFUFJfUE9SVCA9IDEsDQo+ID4gPiArfTsNCj4gPiA+
ICsNCj4gPiA+ICtzdHJ1Y3QgaWNlX2Vzd19icl9wb3J0IHsNCj4gPiA+ICsJc3RydWN0IGljZV9l
c3dfYnIgKmJyaWRnZTsNCj4gPiA+ICsJZW51bSBpY2VfZXN3X2JyX3BvcnRfdHlwZSB0eXBlOw0K
PiA+DQo+ID4gQWxzbyBob2xlIDpzIEknZCBtb3ZlIGl0IG9uZSBsaW5lIGJlbG93Lg0KPiA+DQo+
ID4gPiArCXN0cnVjdCBpY2VfdnNpICp2c2k7DQo+ID4gPiArCXUxNiB2c2lfaWR4Ow0KPiA+ID4g
K307DQo+ID4gPiArDQo+ID4gPiArc3RydWN0IGljZV9lc3dfYnIgew0KPiA+ID4gKwlzdHJ1Y3Qg
aWNlX2Vzd19icl9vZmZsb2FkcyAqYnJfb2ZmbG9hZHM7DQo+ID4gPiArCWludCBpZmluZGV4Ow0K
PiA+ID4gKw0KPiA+ID4gKwlzdHJ1Y3QgeGFycmF5IHBvcnRzOw0KPiA+DQo+ID4gKG5vdCBzdXJl
IGFib3V0IHRoaXMgb25lLCBidXQgcG90ZW50aWFsbHkgdGhlcmUgY2FuIGJlIGEgaG9sZSBiZXR3
ZWVuDQo+ID4gIHRob3NlIHR3bykNCj4gDQo+IE1vdmUgaWZpbmRleCBhdCB0aGUgZW5kPw0KPiAN
Cj4gPg0KPiA+ID4gK307DQo+ID4gPiArDQo+ID4gPiArc3RydWN0IGljZV9lc3dfYnJfb2ZmbG9h
ZHMgew0KPiA+ID4gKwlzdHJ1Y3QgaWNlX3BmICpwZjsNCj4gPiA+ICsJc3RydWN0IGljZV9lc3df
YnIgKmJyaWRnZTsNCj4gPiA+ICsJc3RydWN0IG5vdGlmaWVyX2Jsb2NrIG5ldGRldl9uYjsNCj4g
PiA+ICt9Ow0KPiA+ID4gKw0KPiA+ID4gKyNkZWZpbmUgaWNlX25iX3RvX2JyX29mZmxvYWRzKG5i
LCBuYl9uYW1lKSBcDQo+ID4gPiArCWNvbnRhaW5lcl9vZihuYiwgXA0KPiA+ID4gKwkJICAgICBz
dHJ1Y3QgaWNlX2Vzd19icl9vZmZsb2FkcywgXA0KPiA+ID4gKwkJICAgICBuYl9uYW1lKQ0KPiA+
DQo+ID4gSG1tLCB5b3UgdXNlIGl0IG9ubHkgb25jZSBhbmQgb25seSB3aXRoIGBuZXRkZXZfbmJg
IGZpZWxkLiBEbyB5b3UgcGxhbg0KPiA+IHRvIGFkZCBtb3JlIGNhbGwgc2l0ZXMgb2YgdGhpcyBt
YWNybz8gT3RoZXJ3aXNlIHlvdSBjb3VsZCBlbWJlZCB0aGUNCj4gPiBzZWNvbmQgYXJndW1lbnQg
aW50byB0aGUgbWFjcm8gaXRzZWxmIChtZW50aW9uZWQgYG5ldGRldl9uYmApIG9yIGV2ZW4NCj4g
PiBqdXN0IG9wZW4tY29kZSB0aGUgd2hvbGUgbWFjcm8gaW4gdGhlIHNvbGUgY2FsbCBzaXRlLg0K
PiANCj4gSSB0aGUgbmV4dCBwYXRjaCBpdCBpcyB1c2VkIHdpdGggZGlmZmVyZW50IG5iX25hbWUg
KHN3aXRjaGRldl9uYikNCj4gDQo+ID4NCj4gPiA+ICsNCj4gPiA+ICt2b2lkDQo+ID4gPiAraWNl
X2Vzd2l0Y2hfYnJfb2ZmbG9hZHNfZGVpbml0KHN0cnVjdCBpY2VfcGYgKnBmKTsNCj4gPiA+ICtp
bnQNCj4gPiA+ICtpY2VfZXN3aXRjaF9icl9vZmZsb2Fkc19pbml0KHN0cnVjdCBpY2VfcGYgKnBm
KTsNCj4gPiA+ICsNCj4gPiA+ICsjZW5kaWYgLyogX0lDRV9FU1dJVENIX0JSX0hfICovDQo+ID4g
Wy4uLl0NCj4gPg0KPiA+IFRoYW5rcywNCj4gPiBPbGVrDQo=
