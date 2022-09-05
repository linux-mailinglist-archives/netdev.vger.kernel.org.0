Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8D25AD9D9
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 21:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiIETrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 15:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiIETrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 15:47:19 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D28752FD4
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 12:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662407238; x=1693943238;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AFd89W24ZnGsKnVHAOWeNpp7A4+4wNrkqTILZB/EkXA=;
  b=FBwXkp0tizlLghGJiTh1ym7L9WiB2UunIIYbrpwwhWMviwdnzR2xIEwj
   tp9iGwiVx6YgjsTe/ZEBISheE0UlXD+apa3boYyesYfjtO757NsW0M3A+
   yXMXQAvmHTVBo7AupKCYQWN/eTDIz3vYb97tLi8D0elSHLJKlcnqH9rVS
   yrrny2iwceq1KzUOCCT/3DJLYTGqvwlMrp1r8MptFcDeLtrCQn2AVet2e
   jaK/cztSkcdZYRqvkUJQl6sRaNn3PnAyS9nhi6BELa7z+ghqL24a3KmsK
   S+CVlJDdVBJfZDqHh9sz9j8j0jNioPP6l9hosW4bEu/PaH1szrnxhPO3B
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="358161728"
X-IronPort-AV: E=Sophos;i="5.93,292,1654585200"; 
   d="scan'208";a="358161728"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 12:47:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,292,1654585200"; 
   d="scan'208";a="682153761"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 05 Sep 2022 12:47:17 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 12:47:17 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 12:47:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 5 Sep 2022 12:47:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 5 Sep 2022 12:47:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQavODtfwTwsaCWoDpHfsI7caoku01P2+hfM4L7Gy+RtsGcscxJ7SY4WHcDBBSpy2MHmrqsMugiUhtfRT0oIb0UuCwdX6KM1B4yJ98XmE8GXk6hu7x9+gZDGkGzEkejeGcIHXIvvO1+9VEs6lrdcbBwj0CYk1gzSQqFz1H1IQE1QZ8iMJ91d113NJtnpt4oL+gizewumVJI/P9wePRVQqANeOlrzLIZxKmBYcz344j/yTsxxexf8KYEdklSo4jwi8HeuXrstgQ1TS3C3qwCro/4M9d2CP6d9J4JHQBokSpUEVBL2U0qanFU+UHTwtgvDR0grsoXYZvcbYoxx1YlJew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AFd89W24ZnGsKnVHAOWeNpp7A4+4wNrkqTILZB/EkXA=;
 b=F9CLT3Bn7dKaRfQDaVw9ZC6uInTaVNh+tyhTWPnQZYdvyZ4JIdQPMR7BBonnphdTFWdPW9HZEPIyc3mV5Ouq65vHLQfeVRxN9zldjeYTSGYIYfvAYQbuL1K6FtXI9uQaBoXBc/tbbM+x8SMVvKYauEFnBoQGuomFiBr4jkv28Bl4P+1BI60nvKy2lpUBNidT/02vvFo6/AqLRnc/tbOlEU7qgyrFP9xzXYVhsONQzElONxzwov2aDlRUNg7JR1G4c4y8Qxr99ChUTc/G6Yn8gKoNMItXJda/9FBPhzG+8pzrwVSyO7d5tp/pYci8tIvHdJgHsxeej45dypPgqofYJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB4177.namprd11.prod.outlook.com (2603:10b6:405:83::31)
 by DM6PR11MB4281.namprd11.prod.outlook.com (2603:10b6:5:204::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Mon, 5 Sep
 2022 19:47:15 +0000
Received: from BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::40b5:32b6:ab73:3b8b]) by BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::40b5:32b6:ab73:3b8b%7]) with mapi id 15.20.5588.015; Mon, 5 Sep 2022
 19:47:15 +0000
From:   "Michalik, Michal" <michal.michalik@intel.com>
To:     Jiri Slaby <jirislaby@kernel.org>, Johan Hovold <johan@kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Thread-Topic: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Thread-Index: AQHYu/L55I/9qMiXWE+dtrk9hjKUpa3JkKOAgACUJACAAaKLAIAAM3GAgAVMpnA=
Date:   Mon, 5 Sep 2022 19:47:14 +0000
Message-ID: <BN6PR11MB4177F222B679682F697E986EE37F9@BN6PR11MB4177.namprd11.prod.outlook.com>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
 <20220829220049.333434-4-anthony.l.nguyen@intel.com>
 <20220831145439.2f268c34@kernel.org> <YxBU5AV4jfqaExaW@hovoldconsulting.com>
 <6a426c91-5c03-a328-d341-ef98bc3d8115@kernel.org>
 <b32ef683-e09c-522b-ffa7-ea09628e81db@kernel.org>
In-Reply-To: <b32ef683-e09c-522b-ffa7-ea09628e81db@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19b521fc-d853-4069-4c72-08da8f776edc
x-ms-traffictypediagnostic: DM6PR11MB4281:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fSOFrZV9D7C0WPOIaAYC/bJSVXyyP/al3k0vnvLz1HFMpW8nPZId/0K8tuTh599Cjj6He45Omhtmz3bpwJBwfLalrHPCByBjX0HgZv0ZHKLMp8kJESjQGe6CmtE3hqk0PrKLxvY39pdbpZ9ey5Hs7stFxIrmlnLlrpCQYpWILClWjEwlazNrAHIl0S85gXrIxJiqBOezVfMgDnnkEg2cso7hh/ryLNg90WxWG8E99jXaNFm1jzmm1spjTdYJYBjs92ML4er1EcJZNcrUwHOENn9c/IosTPq1VYi8h++3SQNnJV0XOGI+mE+s54VkPFCS1NQEUrMHfSEhrp2LhN2QA5Z736oGCARCmJy+ohgpWV2YRA6lJQCzzG+B4gWElDp2HdKb8tcpZbWjBDbGwxEgtD+2eX3baQ/4G1T/iUGMD+C0LUVqeV1iI/bjMn04HiAZq5uOaQ4lZlr6x4fwsO4R3IRbwDs7mxd3SFXkGLaIbnUb0UjITHk9JEGch6uIsr0gcrs9GBHMgeV8A3UDfZF/Zasxo1V4hnoEpMBXoBYXP3JVjX0/yvQMJCQhNDpIJqxf9cqp+YCYXnHuQvGnjIBsnzV6cboPWSEXY55aqo5lTBOipFR2l12zJKAKgjBXIZl9+ImpsSkeft9WuqOKHaqukg7tGH54+E5h5hLMkRbtqUFLyTOr65+rNP9xmMifNMVXW6oNQj462O6sd2Rhs3rUivaHA3XCfIgiJm1hHkON5h7bSgnngDThBVDJ93idbCJPSBRJQsHpmTY7JybJ7kYTLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4177.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(376002)(39860400002)(346002)(136003)(186003)(122000001)(38100700002)(82960400001)(8936002)(83380400001)(5660300002)(52536014)(64756008)(66476007)(66946007)(4326008)(66446008)(55016003)(66556008)(2906002)(71200400001)(8676002)(41300700001)(478600001)(6506007)(7696005)(26005)(9686003)(54906003)(110136005)(53546011)(6636002)(316002)(33656002)(76116006)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UndYbG92UEhTdHRLNWF0QUlDcXNoYS9pMlM3cFFCYVU1THFDcEROVnVXVlN1?=
 =?utf-8?B?dmM5amlGbWRaWFhJMnR5aDVVTGVhNUhNRE1XemNRQW5XZk9ydTBRVksxTUgv?=
 =?utf-8?B?bk41OThDSVdyVkY2dDZiMkE5SzdsRXJYQnRubk9wdjJVc3RoajRGRDlHNndQ?=
 =?utf-8?B?V1lMRGxaMitlY2FFcm8ySUM0SUM4RjVyRE9CK2xzZFJnTHg5eER5bFZCZDEz?=
 =?utf-8?B?RFJHTHQxTncvdHpsZnB6YUxyYk5ucFUxWmw4Tnhpdmdid29JRFZNTUZkcURJ?=
 =?utf-8?B?V2JYaGxkSkc2SmtpVWRyVWttSlV5VXVpVnpRR1ZjSzBHS0d3clY1b1ZzOFUx?=
 =?utf-8?B?Mk1SejZnVlpkNG5iUU1IdEtvdkkydXlnOVlod2FoSVovakVGTnV1SmxNaFli?=
 =?utf-8?B?R25ncnNYZ0NHZVlnLytkQUtSWmsra00rS3B1cDh3azhWQ2VZYjdpbWZmYTZK?=
 =?utf-8?B?UHRLZVMydUgrTm84Mk1pZ3NoRVJOOWxocXBUaXRrL3REWXhmOGQ0SWZmMTZW?=
 =?utf-8?B?RTdjbjZwL3l4MGcwcnVGOWk1dkVqT1Q0clBhSFByR25NZVF4bUI5SFdOSHp4?=
 =?utf-8?B?N1dQRVhXbGlJUlROeWQwVVU5RHhFczJGeGc3L3F6VGRwN3kwSkV3a3crRGhk?=
 =?utf-8?B?dm5YRmkrYmZ5RjZnUjJkeG05NE0va2REUG4zeHlkTGdqUUtMQ01WUG5Fbmky?=
 =?utf-8?B?eVd4RGVYdG95M0RKaWRWV2MxNUwwb3JoNGNUbHdLbTZBU2NtWlFlNHJDZnFE?=
 =?utf-8?B?eFBGQzhUakxSMnFVL0xEdGJDaFRJUlh2V2swV1NUdXdFNzhIMVlEcVFwWjlh?=
 =?utf-8?B?VndVZU9rZmlKTGphdEhDeTROMndrazYvb0RFK3RWMVNzR1ZXNUs2amgydERX?=
 =?utf-8?B?aHJUL1IzL2FvZkdSK1FUMkk0VlBZR0tWNWwxaW0rMjRKWkRFYjJHYmZwU013?=
 =?utf-8?B?aUltSitQVEN1eG5PTnZDdzBWdXdqS1l4aWNJWjZjUUo5aHBOY0Nna3VIMVRM?=
 =?utf-8?B?SUNYZFE1YUpQRnR6NWgvbGRRanY4Q3ZwK3BIdGMzSGxDQVcrc1FVM2Y1VHJx?=
 =?utf-8?B?a3p6WW5BeDJXQlpKRGRUTUZCR1ZpQlowaENWWkdDVVFhT1RGU2Y4SWRSbjRH?=
 =?utf-8?B?R0J6b3RxY2hkVnJrS25BeXlLMVJJcGpUQUovcVRrQWRyTkdXVHpSRk9aUVVi?=
 =?utf-8?B?OE1tanJGSUZmZDd0bmp1VWhjVDBvYzRwTGhISUkwRUNIWlpObHJjdm9kSW5o?=
 =?utf-8?B?b0ZsS1pyRi91WGtWZGNRU0o1MGYwZm5JRzRXZGZJN0svTmFRdUtZVHpEVi9o?=
 =?utf-8?B?NnZwVysvS3lKY2ZIWmJjZkQ3dWVuSjhyVUN4MEVOSGZMMVczNHlOWk9VQlM5?=
 =?utf-8?B?Nkl5SHBKWlhLVWlaVzUrVjY2bTl0VWhZUWZyV2NiM3QzNEpMa2svZXllRlZ3?=
 =?utf-8?B?WFd2Ujk5QlNDb2hzTzJrYnpTRHQ2RlFIWG1pRHdFOWNSZ0prYmx1djRnWWE4?=
 =?utf-8?B?ZmtRa2ExNnBURFROSUp5NEU5NXkwYVlYV2UxY0RMdUJoc0lrRWtna0Q0VnFP?=
 =?utf-8?B?WG1wcmlrV29vOU9pOXJ6cFltNVNTMllsZ0l6THRsNUpQdzRhd2lKWWt5RUw5?=
 =?utf-8?B?ZTZFbmM0S2ZZRkNIdzlrTGYydmgzNVN0Q1RXY05KNG53ZFg0RUhuRGtwL1pM?=
 =?utf-8?B?ekJTRVZUaitsOExldUhQSWt1cnNRMzRLNnlKZUs1OVdRQk1xS1U1S3QyUmFZ?=
 =?utf-8?B?S0dMNUtCUjcwL0xVN2tIQngybEowUkMxTktVOTZXNDJOMUVTYWsyYVYrN3R5?=
 =?utf-8?B?c0pqWTRERzkxczhCdGh2cE9GSzFSd25JTHNYSjB0OWRoTHRjYXFjd29rRWZN?=
 =?utf-8?B?eERZdGxhRnBITEhyR3p3c3l6RVYvQ2tYNit2Yk1hdng4eUM1WTFENXhOdVdu?=
 =?utf-8?B?dUU0ZlZOdDY5M2ZlNVNiUEJ3SGw5OWpCMnZPNDB0ZEJpbnI2dW5IdHJGSGw4?=
 =?utf-8?B?TjRabG54ZnEzRW9HbUdDSUp2MGhqdWsvaFVIYlVvWjh0Q0VZY3pZdGxKdWRZ?=
 =?utf-8?B?R2hFKzdEeWxOcXU0M2w0S2N0Z3NTcmtrT0hCY1l5QnEyNEtvR1NIZXJIbHlJ?=
 =?utf-8?B?UldteEQ0Z1JRcFdRUS80NzJFTG1Kbm1kYzNGQVIvVlptYkdUMUpEQUpXL1B1?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4177.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b521fc-d853-4069-4c72-08da8f776edc
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2022 19:47:15.0001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gIrD3UNGyEWum7sRZUeTD+AZyvrpfLfeh33DkCCM/lyhZgtk4X27jcgRM79Z1IReLQLulQII6W9LNspSKH88Mywv8+axaDj2Va4a3RTsbKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4281
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

SGkgSmlyaSwNCg0KQWdyZWUgd2l0aCB5b3UsIHdlIHdpbGwgd29yayBvbiBhbGlnbmluZyB0byB0
aGUgR05TUyBzdWJzeXN0ZW0gaWYgdGhhdCB3b3VsZCBiZQ0KcG9zc2libGUgaW4gb3VyIGltcGxl
bWVudGF0aW9uIGFjY29yZGluZyB0byBKb2hhbiBzdWdnZXN0aW9uLg0KDQpXZSB3aWxsIGFsc28g
bWFrZSBzdXJlIHRvIG1ha2Ugb3VyIGNvZGUgbGVzcyAiaW50ZXJlc3RpbmciLCB3aGVuIGNvbWVz
IHRvIGNvbnN0cnVjdHMuDQoNClRoYW5rcyBhIGxvdCENCg0KQlIsDQpNXjINCg0KPiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKaXJpIFNsYWJ5IDxqaXJpc2xhYnlAa2VybmVs
Lm9yZz4gDQo+IFNlbnQ6IEZyaWRheSwgU2VwdGVtYmVyIDIsIDIwMjIgMTI6NDcgUE0NCj4gVG86
IEpvaGFuIEhvdm9sZCA8am9oYW5Aa2VybmVsLm9yZz47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtl
cm5lbC5vcmc+OyBOZ3V5ZW4sIEFudGhvbnkgTCA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+
DQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBwYWJlbmlAcmVkaGF0LmNvbTsgZWR1bWF6ZXRA
Z29vZ2xlLmNvbTsgTWljaGFsaWssIE1pY2hhbCA8bWljaGFsLm1pY2hhbGlrQGludGVsLmNvbT47
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbTsgRywgR3Vy
dWNoYXJhblggPGd1cnVjaGFyYW54LmdAaW50ZWwuY29tPjsgR3JlZyBLcm9haC1IYXJ0bWFuIDxn
cmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQgMy8z
XSBpY2U6IEFkZCBzZXRfdGVybWlvcyB0dHkgb3BlcmF0aW9ucyBoYW5kbGUgdG8gR05TUw0KPiAN
Cj4gT24gMDIuIDA5LiAyMiwgOTo0MiwgSmlyaSBTbGFieSB3cm90ZToNCj4gPiBPbiAwMS4gMDku
IDIyLCA4OjQ0LCBKb2hhbiBIb3ZvbGQgd3JvdGU6DQo+ID4+IExvb2tzIGxpa2UgdGhpcyB3YXMg
bWVyZ2VkIGluIDUuMTggd2l0aCA0MzExM2ZmNzM0NTMgKCJpY2U6IGFkZCBUVFkgZm9yDQo+ID4+
IEdOU1MgbW9kdWxlIGZvciBFODEwVCBkZXZpY2UiKSB3aXRob3V0IGFueSBpbnB1dCBmcm9tIHBl
b3BsZSBmYW1pbGlhcg0KPiA+PiB3aXRoIHR0eSBlaXRoZXIuDQo+ID4gDQo+ID4gRldJVyBkb2Vz
bid0IGl0IGNyYXNoIGluIGljZV9nbnNzX3R0eV93cml0ZSgpIG9uIHBhcmFsbGVsIHR0eSBvcGVu
cyBkdWUgdG86DQo+ID4gICAgICAgICAgIHR0eS0+ZHJpdmVyX2RhdGEgPSBOVUxMOw0KPiA+IGlu
IGljZV9nbnNzX3R0eV9vcGVuKCk/DQo+IA0KPiBPaCwgdGhlIGRyaXZlciBjaGVja3MgZm9yIHR0
eS0+ZHJpdmVyX2RhdGEgaW4gZXZlcnkgb3BlcmF0aW9uIChnZWUpLiBTbyANCj4gYXQgbGVhc3Qg
dGhhdCBjcmFzaCBpcyBtaXRpZ2F0ZWQuIFRoZSB1c2Vyc3BhY2Ugd2lsbCAib25seSIgcmVjZWl2
ZSANCj4gRUZBVUxUIGZyb20gdGltZSB0byB0aW1lLg0KPiANCj4gPiBUaGVyZSBhcmUgbWFueSAi
aW50ZXJlc3RpbmciIGNvbnN0cnVjdHMgaW4gdGhlIGRyaXZlci4uLg0KPiANCj4gVGhlIGNoZWNr
cyBiZWxvbmcgYW1vbmcgdGhpcyAiaW50ZXJlc3RpbmciIGNvbnN0cnVjdHMgdG9vLg0KPiANCj4g
PiB0aGFua3MsLS0gDQo+IGpzDQo+IHN1c2UgbGFicw0KPg0K
