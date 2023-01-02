Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5657465B5FE
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 18:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbjABRi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 12:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbjABRi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 12:38:28 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E735F626E;
        Mon,  2 Jan 2023 09:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672681106; x=1704217106;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l5r1Xmiw333/HSgR1ronuSj587yXjxTcC+QMnDqCj9g=;
  b=KLIlpVGY9Z6U2Nb5MqFIv6936VeYt1aFeGtRvSGw7s2CYz45oq8P6rhE
   RMJd86TbHIC2B0CRgsl9LVqK1eJCr1OgNvvkpYxmO5mQsPqQS+iBF+luq
   IQ7OlwCE8+WtTbUGE0tMpsv9myGTBCsEJu8NIkOGgFs6ExbqQ2SR/lxWe
   9mEybtA92o186XpowSQAM8C+0DWRXY0DUi4YlYfSa/QRX+EdqvpId7ugn
   QPhJOcF7r6dxi+Lkt7mhehjSanWqg6nKnRAvVDZOSSJV6TnGxT8n6CyBd
   SZ+bg7y7OFE/L6F1c983Iqyit+OnHJFITU0JY9P6TOmz0eEjj5hLAL+zq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10578"; a="322753390"
X-IronPort-AV: E=Sophos;i="5.96,294,1665471600"; 
   d="scan'208";a="322753390"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2023 09:38:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10578"; a="654540390"
X-IronPort-AV: E=Sophos;i="5.96,294,1665471600"; 
   d="scan'208";a="654540390"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 02 Jan 2023 09:38:24 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 2 Jan 2023 09:38:24 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 2 Jan 2023 09:38:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 2 Jan 2023 09:38:24 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 2 Jan 2023 09:38:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoLObATjtDQkAWI1bXmX0L3/nErB3MOwQum9wvY/g6burEmUgb8zkKQMuMFSNWNxbNbkgALOPff638kBbmQmv5FxyQsRky0NnLbaWT7UmaQz4R14ZFcbuneB1FX7DBX3un0yTc0JM3oxN3r/Hhu2VBKdgBQMUD+D5N3nfI0J8c8B++4LZcuguq+Uz7Mbi+ha4t8jMTvWNq/MK67bc6aoTs0nFjO5xCUNeu0tewA8jccsrRCGMouJVSAgsJpBh4K+Nw7Ta9sp7Utzuws0cNtiWABDQP22Kv7X5/S3S6fhl/aRd/i/YXUWHu9VBtoHfRgtbsiYPJgmlOv3BW4vHGwoRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5r1Xmiw333/HSgR1ronuSj587yXjxTcC+QMnDqCj9g=;
 b=fru3SqI5+HetivD1s1C7SxY3ukReQ30MUBEsLCIXirfRwjg5i0rn34+yyyOR0CWsYmbL0tveeQU3Egl5IeSud3MuVH5+XOzanaJCV8T65BI7GvhDQK4/vBdEOgQ9Tnus/GpHPEY2V4AfvRFNNqwpq2ui/fi4MSeuWa0x0pYZ2MlQ4Atz2ojLW1v0S2Jwn2Wz5fHgXfvQVn7JTV5/AxwVs/znBjxwHvjzZ/VkqZeADr2gxuxd4f5BYF7PzjCjtWHzgwStQE4W7zNwb1G7v6CK9Tv2IuYCkXMlhYdsG04nBUDb1fsfcu4sq1hNTDWPDDRYeFZ5Rai0imMxNleO6g+9Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4835.namprd11.prod.outlook.com (2603:10b6:303:9e::22)
 by DS0PR11MB7505.namprd11.prod.outlook.com (2603:10b6:8:153::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 2 Jan
 2023 17:38:20 +0000
Received: from CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::5455:63be:9d0d:914c]) by CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::5455:63be:9d0d:914c%5]) with mapi id 15.20.5944.019; Mon, 2 Jan 2023
 17:38:20 +0000
From:   "Khandelwal, Rajat" <rajat.khandelwal@intel.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Rajat Khandelwal <rajat.khandelwal@linux.intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] igc: Mask replay rollover/timeout
 errors in I225_LMVP
Thread-Topic: [Intel-wired-lan] [PATCH] igc: Mask replay rollover/timeout
 errors in I225_LMVP
Thread-Index: AQHZG4DSWXQ0qgyaHEmR6M6uDCbaea6JYaEAgAIFxTA=
Date:   Mon, 2 Jan 2023 17:38:20 +0000
Message-ID: <CO1PR11MB483580BF9FF4BFA280A6F3F496F79@CO1PR11MB4835.namprd11.prod.outlook.com>
References: <20221229122640.239859-1-rajat.khandelwal@linux.intel.com>
 <eb5a9805-3e53-ec22-696e-21c6b8cf0bfc@molgen.mpg.de>
In-Reply-To: <eb5a9805-3e53-ec22-696e-21c6b8cf0bfc@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: sasha.neftin@intel.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4835:EE_|DS0PR11MB7505:EE_
x-ms-office365-filtering-correlation-id: 05362bf1-7907-41fa-bedc-08daece823b5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gp+gCo5LflXdVf7Mhsnh+w4dMbdm15xXvfZ/kUxNB/sqbnRh7utYA3/Awrc36W65hc6PguiavhyaAvilleV/XXaP4AgLTVi2lGobOjeM91mVUdWTn/UcqEAC0t42tdBvWs0IVELFyzPg0+C46DzaLldlg69HusQk0cZ+LT3MzxT6ypKstjNOw+Fai+tsXL73DYE4vx5MTa4/kUIqQPZeypZ3X5kNyz+d8zVvJml+0mt1Z1WLkZ51sN80YB0GMfO6CvMjnAPJE13duCLqVeFq18BIiqE54FSoRUzbbtYDyJpJIFA7DLaOs0+xXPGjRAFOtEoqiKP7drlWF/ia16UZTT9cFUxsn8VegoilemzqoesED7A+QnW2eQtIdEq0ocFCIqhAjh7Nknl/zPkUkWOw6E3c6z9Zr4KsOVTyDdT6rmcORRow5Z8uZDa21H7HhtXjNAQs15Rg7/ZWXxo1Moyhp7oNNGmtt8qsBpnb2LVabshvt9hramA+i/5YQCZEL0u4XJZfHxp65EuXajmt0Jhb5Qq7DM8hXTG4S5N2z2Pvx7/ipyZl0I068X6zJOh1V2qBn/HlE1TXhlaHTl0ehp5lmAIrKALmujlYz9tJn0iaU29O5fMUaT4Nw1zgmQQRwob7NjQg/hiQgjpXjOTQd53yZrRuy3PGONRz4dgA6NN8YUt+EH+qNH7NyiTwpwipcccQTuM116iVOMBTmfjrsbqoYofo0Lxw81KECuZ6NPMjuoYNpDVIU/lhJvR+tVXDzrOs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4835.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(376002)(366004)(451199015)(8676002)(66476007)(76116006)(4326008)(66556008)(64756008)(66446008)(66946007)(6506007)(966005)(86362001)(478600001)(38070700005)(53546011)(7696005)(110136005)(122000001)(38100700002)(316002)(82960400001)(54906003)(6636002)(7416002)(5660300002)(8936002)(52536014)(186003)(33656002)(9686003)(26005)(83380400001)(2906002)(55016003)(71200400001)(41300700001)(22166006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WkoyTGVzd0dpcVhzbDdHRlMrc3p3RFM0V3NUeW5hQXQyekwxMEt5RHlIc0pS?=
 =?utf-8?B?cFN4ZnVYeXZVVXVoSjZCbXB3WGF2OHVsTkphYSsxQ2dCYno0UmdmSHhUbU1I?=
 =?utf-8?B?ZUZQemw0WkMvVE9GdGVRSUMzSkRSOS9jOTROekdJMGkrdktZaVJyRkQ2Sm5v?=
 =?utf-8?B?UUR4R1RLalk0NWtaSDNVaHdVaVFIWU9kWDlCckZYby93dGNNMWpzeHBLbDJL?=
 =?utf-8?B?NitGeTdGeXNMMVdNaHFWWW5PZiszS0tWa3ZKRmh0enA1NWU0S21sb0l6czVL?=
 =?utf-8?B?VEhMTExxMEZCVXptTUM0R1VqNUkyd0RrQWtlcUkvejJhbFdoNEszMjBLZVBZ?=
 =?utf-8?B?M3BhU0cxaFloRjRIMHE0VXluM1JDUHcwSHVDTGFhV1pVQU1pRWMrcDlrWG9V?=
 =?utf-8?B?ajZHcXVjOGgyd3NHdS9ZSmpCOFV4WVJUNUsraGF3cjhRbnVPeVVieU1PeEIz?=
 =?utf-8?B?dnVLUU5FOXllTFZJVlFiN0tIcEZMWlB2UEVlbS9YalZrd2hrcmdxZS91Q0xT?=
 =?utf-8?B?ZUFFN0U3V2tibmpTa3N0b3pqT1VaRHlIY2dnNm04bHhUaWUxazlPeWlqc2t5?=
 =?utf-8?B?bVhWbGtYUURCYkZZazdTcHIvSEtJL3JiUDdCRGpENE1PZURpTWk1a01tU2Vv?=
 =?utf-8?B?Y2xiYlV4TzFaM2xjSFhwWjBIck42V1dHaGZZUHRrczIrbXk5dVZoZlFleXU2?=
 =?utf-8?B?VDhvRkNYN0UrWlRtdWdvaVBPVzlSNU1talNGbHJZWFg0YUgrd3Fpd1YxR3ND?=
 =?utf-8?B?NGM3Z2ZvNERpdSt5YlJZcEltV0VKQW9EL0E4VzQzMUN4UXdtQ1hncitBbWdR?=
 =?utf-8?B?dW0wWlptbk94OU1QU2NmbnFDYXJSSGQrLzFSZ2hyaUE4VDZ3N2lKeEx0V3Jv?=
 =?utf-8?B?QVp3bnlsbXVMZ0dUSlBxcXRydDB1WGZtU3h0Y1Zkenp3d3dxUncvWjhZcDdG?=
 =?utf-8?B?Y2k1UjZ3dHBVaDFtUm51YWF0amdlQ2dNVEdadlZuQWlkWFpEZStnY0xNVkln?=
 =?utf-8?B?TDh3Wll2VHV6dDBvNys5V1hXWVRZbXlRVXAyVjUvVmRKWGNCRUZuSjJsWld3?=
 =?utf-8?B?MkM4YTRMcWpyNGI2K3lCeThqTUk0aG9DY0Rybjh2VFAzOG1nd2FQekdxbUpG?=
 =?utf-8?B?QVprNHBZNmVFT2drYVJKT08ycFFtbmk1OGNGTlM2aTNtcU9tVzAvL1QrbXRB?=
 =?utf-8?B?WlE3eWZ3TzhwT01TOVZCTldzbGg5bDhEdUhYS1o3N0tXVEc3MVUyeG1sUU9Q?=
 =?utf-8?B?VzZCQzd0TWNyNGZjcndBMGUzM1FWQVpQQVY4YzdldzBIemxYb0ltVWVYTWpq?=
 =?utf-8?B?K1BtVUhVeUVESGxYMGUyWm1NZ3k4Q1k1YWFudHpKRlRvbkZSQWpGVmJZT0k2?=
 =?utf-8?B?aW1GUUNpUVNBQ3VRUE5SNHgxU3RqaW9nNmczU0pCU1g3dWIva0QyTU5VQ2h4?=
 =?utf-8?B?b2duZUQ3OGxtNFlWRW02QTVoU1NQSnpnTnk4TU5reE80QnBwRitlQUU3WXYz?=
 =?utf-8?B?dUlTMGNRTXgyaXBmSnl3Y20rOGlTZjl2YVlSS3g0OFN1NHNEajRvTEdnWmlV?=
 =?utf-8?B?bk1CdkpmK0Z3MEZjOUU1UmxibEh5RFRHdHRMM1RFYTFodEJYZ0haVlFodmUx?=
 =?utf-8?B?OWl5c0IxUUw0WmtMQ29BcllRK0ptbFpNUmJUYnVoNWVnbXJZTXNRc01valVW?=
 =?utf-8?B?a21lcncyMWhJcFNqSDNRamtvSU83RnNCdFZiLzR6eXAzU08wR1dVY0IxTTkr?=
 =?utf-8?B?MVJxWWtVMVBCeUlROFViYy9OcFdCM0Y0UEpLcXQvZmNjNWZMY0Z1d3d3ZG5t?=
 =?utf-8?B?NFVIUUN4endJeVFKOUxHaWk0bnVBbHFLYW02ZUUrcEsxMzJ0cWlGOXljZmxE?=
 =?utf-8?B?aUhmK3E4N0lWN1gyZVBhRjVKbnFyaTBwaFFMVVpXaENpNlJHbm10Ync5TnlW?=
 =?utf-8?B?Sno2czZuSGZoUUdTWG9SanEwTVA5V20zeXVCemJJK1NRQzZJc2VFdDZFZ2Zi?=
 =?utf-8?B?NC9idXRveU9pc3oxOGhSeURBZitKaklsakUzNXdqZVUvRE9WSGh2VjZCT2Ra?=
 =?utf-8?B?MFpWYjJTVmdPSDZwT09Tamg5RHVIL28rdkQzejlSQU9oRXlOR0M1MFpublZR?=
 =?utf-8?B?bnpsdEEwd09NaVZZMW52MUVZdHJiZ2hvVGdBbHFRLzRBTDhhUEJ6eWpwY0Zj?=
 =?utf-8?B?ZHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4835.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05362bf1-7907-41fa-bedc-08daece823b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jan 2023 17:38:20.1714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dzrlkr+TR7nkDCxGjHQ1MJiYH8v4N7kMnyyWaj2F8flnh+LNoWvZbqyZ/MSGgR+uJ8AmoLgLewkaP9wfuT2tQwQsoqxIkiSXWTrKPNjWKbo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7505
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGF1bCwgU2FzaGENClRoYW5rcyBmb3IgdGhlIGFja25vd2xlZGdlbWVudCENCg0KLT4gV2ls
bCBhZGQgdGhlIGV4YW1wbGUgbG9ncw0KLT4gRGV2aWNlOiBodHRwczovL3d3dy5ocC5jb20vdXMt
ZW4vbW9uaXRvcnMtYWNjZXNzb3JpZXMvY29tcHV0ZXItYWNjZXNzb3JpZXMvdGh1bmRlcmJvbHQt
RzQtZG9jay5odG1sDQotPiBjb3JyZWN0aWJsZSAtPiBjb3JyZWN0YWJsZQ0KLT4gSSBndWVzcyBh
Y2MgdG8gdGhlIGNvbnZlbnRpb24sIEkgc3RpbGwgaGF2ZSB0byB1c2UgI2lmZGVmIGZvciBteSBm
dW5jdGlvbiBzaW5jZSBpdA0KcmVmZXJlbmNlcyB2YXJpYWJsZXMgdGhhdCB3b24ndCBleGlzdCBp
ZiB0aGUgY29uZGl0aW9uIGlzIG5vdCBtZXQuDQpIb3dldmVyLCBJIGhhdmUgdXNlZCB0aGUgSVNf
RU5BQkxFRCBtYWNybyB0byBjYWxsIHRoZSBmdW5jdGlvbiBpbnNpZGUgaWdjX3Byb2JlKCkuDQpJ
IGhvcGUgdGhhdCdzIG9rYXkhIA0KDQotPiBPbmUgbGFzdCB0aGluZywgSSB3YXMgYWxzbyBza2Vw
dGljYWwgb24gdGhlIGxvY2F0aW9uIG9mIHRoaXMgZnVuY3Rpb24sIGJ1dCB0aGVuIEkgd2l0bmVz
c2VkDQpuZXR4ZW5fbWFza19hZXJfY29ycmVjdGFibGUoKSBmdW5jdGlvbiBpbnNpZGUgbmV0L2V0
aGVybmV0L3Fsb2dpYy9uZXR4ZW4vbmV0eGVuX25pY19tYWluLmMsDQp3aGljaCBtYXNrcyB0aGUg
Y29ycmVjdGFibGUgZXJyb3JzIGluIGl0cyBQQ0llIGRldmljZS4NCkFsc28sIEkgZG9u4oCZdCBz
ZWUgYSBDT05GSUdfUENJRUFFUiBtYWNybyBlbmFibGVkIGZ1bmN0aW9uIGluIHBjaS9xdWlya3Mu
YyENCkkgc3RpbGwgdGhpbmsgdG8ga2VlcCB0aGUgZnVuY3Rpb24gaW4gaWdjX21haW4uYywgYnV0
IEkgYW0gd2FpdGluZyBmb3IgeW91ciBqdWRnZW1lbnQuIA0KDQpATmVmdGluLCBTYXNoYSwgSSBh
bmQgbXkgdGVhbSBwcmVmZXIgbWFza2luZyB0aGVzZSBlcnJvcnMgcmF0aGVyIHRoYW4gZGVidWdn
aW5nIHRoZW0uDQpGaXJzdCwgdGhleSBhcmUgY29ycmVjdGFibGUgYW5kIG5vbi1mYXRhbC4gU2Vj
b25kLCB0aGVzZSBlcnJvcnMgYXJlIG9ic2VydmVkIGluIG1hbnkgb2YgdGhlIGRldmljZXMgSQ0K
aGF2ZSB3b3JrZWQgd2l0aCAoaS5lLiwgcmVwbGF5IGVycm9ycykuIE1heWJlIHRoZXJlIGlzIHNv
bWV0aGluZyB1bml2ZXJzYWwgd2hpY2ggaGFzIHRvIGJlIGRvbmUgZm9yIHRoZQ0KdGh1bmRlcmJv
bHQgZG9tYWluIHJlZ2FyZGluZyB0aGVzZSBzcGVjaWZpYyByZXBsYXkgZXJyb3JzIGluIHRoZSBs
b25nIHRlcm0/DQpBbnlob3csIHdlIHdvdWxkIGxpa2UgdG8gbWFzayB0aGVzZSBlcnJvcnMgZm9y
IG5vdyB0byBhdm9pZCBhbnkgY29uZnVzaW9ucyB3aGVuIGV0aGVybmV0IGdldHMNCmNvbm5lY3Rl
ZCB0byB0aGUgZG9jay4gSSBob3BlIHRoYXQgd2lsbCBiZSBva2F5PyBXYWl0aW5nIGZvciB5b3Vy
IGp1ZGdlbWVudCA6KQ0KDQpMZXQgbWUga25vdyBvbiBhbnkgbW9yZSBxdWVyaWVzIGFuZCBhbnkg
c3VnZ2VzdGlvbnMgdW50aWwgSSByb2xsIG91dCB2Mi4NCg0KVGhhbmtzDQpSYWphdA0KDQotLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogUGF1bCBNZW56ZWwgPHBtZW56ZWxAbW9sZ2Vu
Lm1wZy5kZT4gDQpTZW50OiBTdW5kYXksIEphbnVhcnkgMSwgMjAyMyA0OjAyIFBNDQpUbzogUmFq
YXQgS2hhbmRlbHdhbCA8cmFqYXQua2hhbmRlbHdhbEBsaW51eC5pbnRlbC5jb20+DQpDYzogQnJh
bmRlYnVyZywgSmVzc2UgPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsgTmd1eWVuLCBBbnRo
b255IEwgPGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsg
ZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsg
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc7
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IEtoYW5kZWx3YWwsIFJhamF0IDxyYWphdC5r
aGFuZGVsd2FsQGludGVsLmNvbT47IEJqb3JuIEhlbGdhYXMgPGJoZWxnYWFzQGdvb2dsZS5jb20+
OyBsaW51eC1wY2lAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBSZTogW0ludGVsLXdpcmVkLWxh
bl0gW1BBVENIXSBpZ2M6IE1hc2sgcmVwbGF5IHJvbGxvdmVyL3RpbWVvdXQgZXJyb3JzIGluIEky
MjVfTE1WUA0KDQpbQ2M6ICtCam9ybiwgK2xpbnV4LXBjaV0NCg0KDQpEZWFyIFJhamF0LA0KDQoN
ClRoYW5rIHlvdSBmb3IgeW91ciBwYXRjaC4NCg0KQW0gMjkuMTIuMjIgdW0gMTM6MjYgc2Nocmll
YiBSYWphdCBLaGFuZGVsd2FsOg0KPiBUaGUgQ1BVIGxvZ3MgZ2V0IGZsb29kZWQgd2l0aCByZXBs
YXkgcm9sbG92ZXIvdGltZW91dCBBRVIgZXJyb3JzIGluIA0KPiB0aGUgc3lzdGVtIHdpdGggaTIy
NV9sbXZwIGNvbm5lY3RlZCwgdXN1YWxseSBpbnNpZGUgdGh1bmRlcmJvbHQgZGV2aWNlcy4NCg0K
UGxlYXNlIGFkZCBvbmUgZXhhbXBsZSBsb2cgbWVzc2FnZSB0byB0aGUgY29tbWl0IG1lc3NhZ2Uu
DQoNCj4gT25lIG9mIHRoZSBwcm9taW5lbnQgVEJUNCBkb2NrcyB3ZSB1c2UgaXMgSFAgRzQgSG9v
azIsIHdoaWNoIA0KPiBpbmNvcnBvcmF0ZXMNCg0KSSBjb3VsZG7igJl0IGZpbmQgdGhhdCBkZXZp
Y2UuIElzIHRoYXQgdGhlIGNvcnJlY3QgbmFtZT8NCg0KPiBhbiBJbnRlbCBGb3h2aWxsZSBjaGlw
c2V0LCB3aGljaCB1c2VzIHRoZSBpZ2MgZHJpdmVyLg0KDQpQbGVhc2UgYWRkIGEgYmxhbmsgbGlu
ZSBiZXR3ZWVuIHBhcmFncmFwaHMuDQoNCj4gT24gY29ubmVjdGluZyBldGhlcm5ldCwgQ1BVIGxv
Z3MgZ2V0IGludW5kYXRlZCB3aXRoIHRoZXNlIGVycm9ycy4gVGhlIA0KPiBwb2ludCBpcyB3ZSBz
aG91bGRuJ3QgYmUgc3BhbW1pbmcgdGhlIGxvZ3Mgd2l0aCBzdWNoIGNvcnJlY3RpYmxlIA0KPiBl
cnJvcnMgYXMgaXQNCg0KY29ycmVjdGFibGUNCg0KPiBjb25mdXNlcyBvdGhlciBrZXJuZWwgZGV2
ZWxvcGVycyBsZXNzIGZhbWlsaWFyIHdpdGggUENJIGVycm9ycywgDQo+IHN1cHBvcnQgc3RhZmYs
IGFuZCB1c2VycyB3aG8gaGFwcGVuIHRvIGxvb2sgYXQgdGhlIGxvZ3MuDQoNClBsZWFzZSByZWZl
cmVuY2UgdGhlIGJ1ZyByZXBvcnRzIChidWcgdHJhY2tlciBhbmQgbWFpbGluZyBsaXN0KSwgeW91
IGtub3cgb2YsIHdoZXJlIHRoaXMgd2FzIHJlcG9ydGVkLg0KDQo+IFNpZ25lZC1vZmYtYnk6IFJh
amF0IEtoYW5kZWx3YWwgPHJhamF0LmtoYW5kZWx3YWxAbGludXguaW50ZWwuY29tPg0KPiAtLS0N
Cj4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjX21haW4uYyB8IDI4ICsrKysr
KysrKysrKysrKysrKysrKy0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKyks
IDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaWdjL2lnY19tYWluLmMgDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdj
L2lnY19tYWluLmMNCj4gaW5kZXggZWJmZjBlMDQwNDVkLi5hM2E2ZTgwODZjOGQgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfbWFpbi5jDQo+ICsrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfbWFpbi5jDQo+IEBAIC02MjAxLDYg
KzYyMDEsMjYgQEAgdTMyIGlnY19yZDMyKHN0cnVjdCBpZ2NfaHcgKmh3LCB1MzIgcmVnKQ0KPiAg
IAlyZXR1cm4gdmFsdWU7DQo+ICAgfQ0KPiAgIA0KPiArI2lmZGVmIENPTkZJR19QQ0lFQUVSDQo+
ICtzdGF0aWMgdm9pZCBpZ2NfbWFza19hZXJfcmVwbGF5X2NvcnJlY3RpYmxlKHN0cnVjdCBpZ2Nf
YWRhcHRlciANCj4gKyphZGFwdGVyKQ0KDQpjb3JyZWN0YWJsZQ0KDQo+ICt7DQo+ICsJc3RydWN0
IHBjaV9kZXYgKnBkZXYgPSBhZGFwdGVyLT5wZGV2Ow0KPiArCXUzMiBhZXJfcG9zLCBjb3JyX21h
c2s7DQoNCkluc3RlYWQgb2YgdXNpbmcgdGhlIHByZXByb2Nlc3NvciwgdXNlIGEgbm9ybWFsIEMg
Y29uZGl0aW9uYWwuIEZyb20NCmBEb2N1bWVudGF0aW9uL3Byb2Nlc3MvY29kaW5nLXN0eWxlLnJz
dGA6DQoNCj4gV2l0aGluIGNvZGUsIHdoZXJlIHBvc3NpYmxlLCB1c2UgdGhlIElTX0VOQUJMRUQg
bWFjcm8gdG8gY29udmVydCBhIA0KPiBLY29uZmlnIHN5bWJvbCBpbnRvIGEgQyBib29sZWFuIGV4
cHJlc3Npb24sIGFuZCB1c2UgaXQgaW4gYSBub3JtYWwgQyBjb25kaXRpb25hbDoNCj4gDQo+IC4u
IGNvZGUtYmxvY2s6OiBjICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICANCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgDQo+ICAgICAgICAgaWYgKElTX0VOQUJMRUQoQ09O
RklHX1NPTUVUSElORykpIHsNCj4gICAgICAgICAgICAgICAgIC4uLg0KPiAgICAgICAgIH0NCj4g
DQo+IFRoZSBjb21waWxlciB3aWxsIGNvbnN0YW50LWZvbGQgdGhlIGNvbmRpdGlvbmFsIGF3YXks
IGFuZCBpbmNsdWRlIG9yIA0KPiBleGNsdWRlIHRoZSBibG9jayBvZiBjb2RlIGp1c3QgYXMgd2l0
aCBhbiAjaWZkZWYsIHNvIHRoaXMgd2lsbCBub3QgYWRkIA0KPiBhbnkgcnVudGltZSBvdmVyaGVh
ZC4gIEhvd2V2ZXIsIHRoaXMgYXBwcm9hY2ggc3RpbGwgYWxsb3dzIHRoZSBDIA0KPiBjb21waWxl
ciB0byBzZWUgdGhlIGNvZGUgaW5zaWRlIHRoZSBibG9jaywgYW5kIGNoZWNrIGl0IGZvciANCj4g
Y29ycmVjdG5lc3MgKHN5bnRheCwgdHlwZXMsIHN5bWJvbCByZWZlcmVuY2VzLCBldGMpLiAgVGh1
cywgeW91IHN0aWxsIA0KPiBoYXZlIHRvIHVzZSBhbiAjaWZkZWYgaWYgdGhlIGNvZGUgaW5zaWRl
IHRoZSBibG9jayByZWZlcmVuY2VzIHN5bWJvbHMgdGhhdCB3aWxsIG5vdCBleGlzdCBpZiB0aGUg
Y29uZGl0aW9uIGlzIG5vdCBtZXQuDQoNCg0KPiArDQo+ICsJaWYgKHBkZXYtPmRldmljZSAhPSBJ
R0NfREVWX0lEX0kyMjVfTE1WUCkNCj4gKwkJcmV0dXJuOw0KPiArDQo+ICsJYWVyX3BvcyA9IHBj
aV9maW5kX2V4dF9jYXBhYmlsaXR5KHBkZXYsIFBDSV9FWFRfQ0FQX0lEX0VSUik7DQo+ICsJaWYg
KCFhZXJfcG9zKQ0KPiArCQlyZXR1cm47DQo+ICsNCj4gKwlwY2lfcmVhZF9jb25maWdfZHdvcmQo
cGRldiwgYWVyX3BvcyArIFBDSV9FUlJfQ09SX01BU0ssICZjb3JyX21hc2spOw0KPiArDQo+ICsJ
Y29ycl9tYXNrIHw9IFBDSV9FUlJfQ09SX1JFUF9ST0xMIHwgUENJX0VSUl9DT1JfUkVQX1RJTUVS
Ow0KPiArCXBjaV93cml0ZV9jb25maWdfZHdvcmQocGRldiwgYWVyX3BvcyArIFBDSV9FUlJfQ09S
X01BU0ssIGNvcnJfbWFzayk7IA0KPiArfSAjZW5kaWYNCj4gKw0KPiAgIC8qKg0KPiAgICAqIGln
Y19wcm9iZSAtIERldmljZSBJbml0aWFsaXphdGlvbiBSb3V0aW5lDQo+ICAgICogQHBkZXY6IFBD
SSBkZXZpY2UgaW5mb3JtYXRpb24gc3RydWN0IEBAIC02MjM2LDggKzYyNTYsNiBAQCBzdGF0aWMg
DQo+IGludCBpZ2NfcHJvYmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsDQo+ICAgCWlmIChlcnIpDQo+
ICAgCQlnb3RvIGVycl9wY2lfcmVnOw0KPiAgIA0KPiAtCXBjaV9lbmFibGVfcGNpZV9lcnJvcl9y
ZXBvcnRpbmcocGRldik7DQo+IC0NCj4gICAJZXJyID0gcGNpX2VuYWJsZV9wdG0ocGRldiwgTlVM
TCk7DQo+ICAgCWlmIChlcnIgPCAwKQ0KPiAgIAkJZGV2X2luZm8oJnBkZXYtPmRldiwgIlBDSWUg
UFRNIG5vdCBzdXBwb3J0ZWQgYnkgUENJZSANCj4gYnVzL2NvbnRyb2xsZXJcbiIpOyBAQCAtNjI3
Miw2ICs2MjkwLDEyIEBAIHN0YXRpYyBpbnQgaWdjX3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpwZGV2
LA0KPiAgIAlpZiAoIWFkYXB0ZXItPmlvX2FkZHIpDQo+ICAgCQlnb3RvIGVycl9pb3JlbWFwOw0K
PiAgIA0KPiArI2lmZGVmIENPTkZJR19QQ0lFQUVSDQo+ICsJaWdjX21hc2tfYWVyX3JlcGxheV9j
b3JyZWN0aWJsZShhZGFwdGVyKTsNCj4gKyNlbmRpZg0KPiArDQo+ICsJcGNpX2VuYWJsZV9wY2ll
X2Vycm9yX3JlcG9ydGluZyhwZGV2KTsNCj4gKw0KPiAgIAkvKiBody0+aHdfYWRkciBjYW4gYmUg
emVyb2VkLCBzbyB1c2UgYWRhcHRlci0+aW9fYWRkciBmb3IgdW5tYXAgKi8NCj4gICAJaHctPmh3
X2FkZHIgPSBhZGFwdGVyLT5pb19hZGRyOw0KPiAgIA0KDQoNCktpbmQgcmVnYXJkcywNCg0KUGF1
bA0K
