Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1998681FBE
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 00:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjA3XfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 18:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjA3XfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 18:35:03 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6B32BEE3
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 15:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675121695; x=1706657695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FRRRDp0lA1eeeVFkWry5vnaGhJTqSS2mWRwYVosTMlY=;
  b=midfLtz++B8KUtOFuRiq2E4MSIhP3/HVQZHjtdWj08eBhGtoVaMtQPci
   EmloV7ojCJ1iX6dWsF1hs8zXyCSL/uoMbolXcD7sTt3/y8eK+1n2RbXxp
   /FMmkdGAm4hjJPAVl4kycF5iLiIg6D6DxQTCC5u7/7QzRA9SEW6yHmJvO
   8/dpoSLoSN3VAhy1QsdAvs7LHZV8u9v/l07AMdg/LULthfKw/nw15ln/U
   1v9TktnYu9HhoKJlqnmItCakdzyccJLhOQEU1oGDhhz+rLeJ7XBIKvPF1
   Kn/uzHmyC7rPodcX0KF6hhMKyatm76F89xdDlDqhTTA+SSIp4YHtZ8m/7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="355025621"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="355025621"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 15:34:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="772719505"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="772719505"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 30 Jan 2023 15:34:55 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 15:34:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 15:34:54 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 15:34:54 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 15:34:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQ7g6cR+lpy9uKOLA4V4dwHcrp3Yw06xaPF0ZN3kXy8+ICDf77tveE7bZsVMilxAwq1eD2NbkG3m9KX6DJj/u5eI5ctys5b21pQd2QOVfU4SjrYi9ehHafh5gHPONPgPcfs2tzi6tIpx3Ry4OcwXh7eTElD1PvArZdQucy5UrxGEbZ7OxK+VNUD8zFpcb7MQDJWOSTgZ45hEKB/p6WPKAoeoxADn9+/B/P/RPpcrb5wnT0yhZxRSFbW0OoToekfHWar1dkLtLRxUafJPk0E+JDmp1VqkEVzhQYp4Jfz58vvt2j92iKJW0gj20lf9C1aL+m3QIzMyXBDNFAFCHUW2xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRRRDp0lA1eeeVFkWry5vnaGhJTqSS2mWRwYVosTMlY=;
 b=CGvPhDZ2oV4lI9kfJK5IrdzQr4c7+MmQdPdaEPHypvwDW64DCqO2DcbkUvbbDILhQx6TXKJUE0rD2oniqqYPb3g5Q8nfGn1KzxCQEl+EoxNrC5Sn5ar3uP6KWCjZuDoncW8El48Jbtl91Er4uZgKqwU6w4ztwohbBS5r3ZYcNNIjOkX81aNpx3eRzyrXS+zf/qO4k+eQbrUdCY4TVVqXN52TXe2DWfvzUmwH716rFeI7S8/uHi8TTxKbg7SGrsCNSR1pfmJ80H19LHXR7Gl/0HERSXqowsNYUvqyxJiGX7eWNTShpUNzqYPOt04XqIHPD9WIA8O33j5lNAJmCYhbcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14)
 by CY8PR11MB7195.namprd11.prod.outlook.com (2603:10b6:930:93::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 23:34:50 +0000
Received: from PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::6e10:28f9:f32b:c0d3]) by PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::6e10:28f9:f32b:c0d3%3]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 23:34:50 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Dave.Ertman@intel.com" <Dave.Ertman@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>
CC:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 05/13] ice: Fix RDMA latency
 issue by allowing write-combining
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 05/13] ice: Fix RDMA
 latency issue by allowing write-combining
Thread-Index: AQHZK6PNhVnK46F5OE2o+5BNBxc2VK62zN8AgADg8WA=
Date:   Mon, 30 Jan 2023 23:34:50 +0000
Message-ID: <PH0PR11MB5095133D185FFC8E81B06558D6D39@PH0PR11MB5095.namprd11.prod.outlook.com>
References: <20230119011653.311675-1-jacob.e.keller@intel.com>
 <20230119011653.311675-6-jacob.e.keller@intel.com>
 <83d3f5c1-1f3f-a08e-1632-df8bc7b8ab7b@intel.com>
In-Reply-To: <83d3f5c1-1f3f-a08e-1632-df8bc7b8ab7b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: anthony.l.nguyen@intel.com,Dave.Ertman@intel.com,shiraz.saleem@intel.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5095:EE_|CY8PR11MB7195:EE_
x-ms-office365-filtering-correlation-id: 61022472-92fd-49e7-aea0-08db031a9501
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4n/pIdZs6kbWc0cMZ7s8zl6xZD8fVFJv2vGRvkwRQxOz3vvsJpZwJWZH2ppkfWKWDigyn+qfuM20iQvpw0htFoELLoaHzhvhQVjYh+cxO7Hc7JVOmBse4dvbUSSI0InXDLYGd39euHEeKko7pT1x9S8e4k7mg1NGyUdtYTcGHior/n+Zk8lRykULUYIfJ1Jn2hxbmHz9nbKW8Trtl++3fjGvggyS+OXC1b0R6ZB+ZKdO86iln/S0tWWhCDkIfvH6rNVf7y3/WKHc779Vw/l7WAprH2fafWLg5YXQej7lDSXGmjUse3A5zsGPhFjiLjO3jPWgpiUPU6xDIlCfozCr2D2ZlY5A0tZSi+UKR70L4kXuCLuOXF20SAIK2n8WgFcEGBX+dv2D0BZFle8HwY9PAXUL3HJnQ/wczZVfh4qDOOCvaHOUPYfE/OQzEEqZxAagXXVHYxpqdpafib4YufCcz9K1zu3gGNgmfICbnE+XDVkcwrx7fpsqvjcZU6v/k4Wh5kwVNRSAb/d9cMH4FvCJB9CY/ewI/vM4L0UJNYYKaEnNr9YvrVKB5O9FSvERjR2z56NK9P8OYBdEZQN8EyTVdx/nFKilRpsV6bpNSzX8dPN78JdrduRnwmZDYyHp7bTj5qNYlWD1MEAM/PlB8pKCmiKnr2eIVNcWRYBcogKhFS+J/H05TBaGEiVlMGe4iV8y+no0fnVkBRO/nNjUo8GJ+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199018)(83380400001)(38070700005)(38100700002)(122000001)(82960400001)(86362001)(7696005)(2906002)(71200400001)(53546011)(6506007)(26005)(9686003)(186003)(478600001)(55016003)(33656002)(66946007)(8676002)(66556008)(66476007)(66446008)(64756008)(52536014)(8936002)(41300700001)(76116006)(4326008)(6636002)(54906003)(5660300002)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTFyOG1PWnlIN1hzaTRGSXNnKytmODFQeHFSYU8raDFsNGJjUnBoQUJwaDRX?=
 =?utf-8?B?d1ZCQmg3aDNTOUxyZC9yZnNWQmVWNzVBdWhLUUpGYmZEOHdnUVdLeTBDUDZ2?=
 =?utf-8?B?YmNjV1BndS9tTW9sWTRqODNqWEFoZkpramx5Qi9ST2tnOUIwMXdzV0FiVlVn?=
 =?utf-8?B?emcvdlY3cERURVk0N2RraGtHSFF5MXZBYk90NjBSNWVlS0VnS1FSemNLc2VI?=
 =?utf-8?B?ckpWMERqYytmR1RLMXZQVThGOGxFNXpPelJEN0VYbXM1M1ArNmJoZ0FiZnFh?=
 =?utf-8?B?SnVrOEFqRkVXWjJxbENKWTNZR0ROY2gySFFzVkhjaC9NRm0vanRtYUlDQlIz?=
 =?utf-8?B?U3BLU09jaEFuQloySEpDVVNhMTNsdjhNVWNnYnBZRy9oa0RKSzhPMFRQa2J1?=
 =?utf-8?B?QU9HcDFQV1gzSG5JMzBQTzF4T1NrdG5lbHVVTmhYcUFUd3FIcmFkWTRiYmxD?=
 =?utf-8?B?UlIyTkhKL2hqMEk1eDR1MEVWcWVYckFBUHl2eTBVQTV2MUVFTFFTNlhqZGt5?=
 =?utf-8?B?K1FCWDRNMUVibWh0YmxDMmFDRmVkeTJKSnEyaGdHdlZFV0x2WUZ6OWFwSVow?=
 =?utf-8?B?b0VhRFpqS3lEVjZoWXIyaTN3UWxXWGFDQzJtTnNlZTRDMkNPRkpyRVMvU0J4?=
 =?utf-8?B?RENnRklZd2xPaUVPdGovUHhlMTkyUnFFM0lRNFo2RFJLaWhsdjltZTRaMnlj?=
 =?utf-8?B?UmtaWUJDZmxnL3R5UDgwa3k2ZGF3SE45MVlXZmxOSzV3UnBncFJCbEdIR0NE?=
 =?utf-8?B?ejRCYjFvQkJqaEZnVk5MRDd5WWxZYkdDMGs2TGw4WHIyY09TV1QwUGZhUUU5?=
 =?utf-8?B?TXpIbXhCTWc3cUs2YlVUTWhId2JVdEVlVCt6b3dFOVN0d1JXS2Jtc3MzUTlI?=
 =?utf-8?B?ZU5jNTF3aldLbksvaExqdVZNRnlXUHllZk1OaCsxYnVwUXBLc1pFNVp3cVVM?=
 =?utf-8?B?UlBOVkhoWldESTh4S2F4MmVJQ25NUDRsT1JHRUU0bzY1V0hDWUhjckhzdWor?=
 =?utf-8?B?SjV6c3dCcWRPV2xFTmlJeTM3cXVpMHl3RnhEZ3dNb0IzWnB3WVErRm5YZFhE?=
 =?utf-8?B?NmhUUk40SkVRd29KbXRUcm4yK3ZmZXFYcVdmWTdZUitrSmNvZDJZNE5XN2Nn?=
 =?utf-8?B?VStvWUlya3NIZmZOVVZtc3BZOGVjeFIrQWNyT3lBbGQ4WEJYQ05Melpaa3JK?=
 =?utf-8?B?RmdWdjlyeU1VbWQ5T0t3WUQ0WFBSK2VrcE5YS0ZmYWFCUVhaNHpRZnUrcEwr?=
 =?utf-8?B?RUdKejNQUW9JMEpjVnd6a2U1WUJIU1E3RE1IdjVCSUtZZDZ1WG5FMGc2UTV2?=
 =?utf-8?B?SjlaNFZIRFRxdFJUMzdWb052ckQyMjVHVnQ5Q2o2UHVSdE9XUVZIOFRTeHRr?=
 =?utf-8?B?UXQ4V3A2bFp1bFFRQTFrdmtSa3pvbStDYlAvZm5Rb21DVDFWVExGODlmZkdH?=
 =?utf-8?B?c3AvbmdQaVd2ZytDZktZZGNNMjYrUkgySlRVZFhMZ1N4S3JJaU0xUlRMVC9t?=
 =?utf-8?B?eGtQczZoeDRqQmVveUxRbll0RCsrMEQxd0ovYWN3UXB5bnRCSUZlS29FMlRO?=
 =?utf-8?B?QUU1c2ZEWnF6cTJEMWlhMHhDSmJENWl4NGNubEZ3amVRejN1V1VOczVERnNQ?=
 =?utf-8?B?VzJjNVNrMzd3b2JaRGhIazU1NUhpbUxJanJuOXNrNldrYktXYkgyZ1JTZ09N?=
 =?utf-8?B?bmNWWTIrQmFyYzlqWTBQelVOWmF4d1g5SVJQdlBpUlRxVkI3SnRpdWRHb3pD?=
 =?utf-8?B?VXFyMHNIVGZDY1hJVDZERHdoQU5LVGV3bWVIUUVPQnlGQzdKbXYvLzMybWZn?=
 =?utf-8?B?bG5TRHp5NjJDb2trNFBnQVNGdjUwc1ZadVp4SG9XRFNha1ZqUmxxZWVyOW1Z?=
 =?utf-8?B?UzJDTHRWNFdLK1ZBdkczTDgvK2pJb2NCSG5iVE8xSnlYMUQxTE53OXBMWEZx?=
 =?utf-8?B?WXJxdWdhb3B4alViaU1HZnJWYTdwQVVGbUlxd2txVmFDS2VTQ3MzbzYveDdu?=
 =?utf-8?B?MVA1ODh2dllKanF4L25YN3p6MnZsQVVlUCtwQStSbVlUdWhOK2NBdHM3c0E3?=
 =?utf-8?B?ZlBtMzVmZTRmMzBwWkwyVmUyK2NtQmFqak5ENVFiZ0NZL2xJaUE2RFBlaGo0?=
 =?utf-8?Q?QqjENVlwi+UbDHhmDjXM0Bmlp?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61022472-92fd-49e7-aea0-08db031a9501
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 23:34:50.6693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7jrEs6aT8hSL/tCR5UqMinjucsHyF7ZP+4+ozGxyL1aaggmSD16uG8ftCLZnUptty7/zsKF6MjlAZdTd9k148zt+h6htN3zngDKlX+u288g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7195
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTG9iYWtpbiwgQWxleGFu
ZHIgPGFsZXhhbmRyLmxvYmFraW5AaW50ZWwuY29tPg0KPiBTZW50OiBNb25kYXksIEphbnVhcnkg
MzAsIDIwMjMgMjowMyBBTQ0KPiBUbzogS2VsbGVyLCBKYWNvYiBFIDxqYWNvYi5lLmtlbGxlckBp
bnRlbC5jb20+DQo+IENjOiBJbnRlbCBXaXJlZCBMQU4gPGludGVsLXdpcmVkLWxhbkBsaXN0cy5v
c3Vvc2wub3JnPjsgTmd1eWVuLCBBbnRob255IEwNCj4gPGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwu
Y29tPjsgTGluZ2EsIFBhdmFuIEt1bWFyDQo+IDxwYXZhbi5rdW1hci5saW5nYUBpbnRlbC5jb20+
OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbSW50ZWwtd2lyZWQtbGFu
XSBbUEFUQ0ggbmV0LW5leHQgdjIgMDUvMTNdIGljZTogRml4IFJETUEgbGF0ZW5jeQ0KPiBpc3N1
ZSBieSBhbGxvd2luZyB3cml0ZS1jb21iaW5pbmcNCj4gDQo+IEZyb206IEphY29iIEtlbGxlciA8
amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KPiBEYXRlOiBXZWQsIDE4IEphbiAyMDIzIDE3OjE2
OjQ1IC0wODAwDQo+IA0KPiA+IFRoZSBjdXJyZW50IG1ldGhvZCBvZiBtYXBwaW5nIHRoZSBlbnRp
cmUgQkFSIHJlZ2lvbiBhcyBhIHNpbmdsZSB1bmNhY2hlYWJsZQ0KPiA+IHJlZ2lvbiBkb2VzIG5v
dCBhbGxvdyBSRE1BIHRvIHVzZSB3cml0ZSBjb21iaW5pbmcgKFdDKS4gVGhpcyByZXN1bHRzIGlu
DQo+ID4gaW5jcmVhc2VkIGxhdGVuY3kgd2l0aCBSRE1BLg0KPiA+DQo+ID4gVG8gZml4IHRoaXMs
IHdlIGluaXRpYWxseSBwbGFubmVkIHRvIHJlZHVjZSB0aGUgc2l6ZSBvZiB0aGUgbWFwIG1hZGUg
YnkgdGhlDQo+ID4gUEYgZHJpdmVyIHRvIGluY2x1ZGUgb25seSB1cCB0byB0aGUgYmVnaW5uaW5n
IG9mIHRoZSBSRE1BIHNwYWNlLg0KPiA+IFVuZm9ydHVuYXRlbHkgdGhpcyB3aWxsIG5vdCB3b3Jr
IGluIHRoZSBmdXR1cmUgYXMgdGhlcmUgYXJlIHNvbWUgaGFyZHdhcmUNCj4gPiBmZWF0dXJlcyB3
aGljaCB1c2UgcmVnaXN0ZXJzIGJleW9uZCB0aGUgUkRNQSBhcmVhLiBUaGlzIGluY2x1ZGVzIFNj
YWxhYmxlDQo+ID4gSU9WLCBhIHZpcnR1YWxpemF0aW9uIGZlYXR1cmUgYmVpbmcgd29ya2VkIG9u
IGN1cnJlbnRseS4NCj4gPg0KPiA+IEluc3RlYWQgb2Ygc2ltcGx5IHJlZHVjaW5nIHRoZSBzaXpl
IG9mIHRoZSBtYXAsIHdlIG5lZWQgYSBzb2x1dGlvbiB3aGljaA0KPiA+IHdpbGwgYWxsb3cgYWNj
ZXNzIHRvIGFsbCBhcmVhcyBvZiB0aGUgYWRkcmVzcyBzcGFjZSB3aGlsZSBsZWF2aW5nIHRoZSBS
RE1BDQo+ID4gYXJlYSBvcGVuIHRvIGJlIG1hcHBlZCB3aXRoIHdyaXRlIGNvbWJpbmluZy4NCj4g
Pg0KPiA+IFRvIGFsbG93IGZvciB0aGlzLCBhbmQgZml4IHRoZSBSTURBIGxhdGVuY3kgaXNzdWUg
d2l0aG91dCBibG9ja2luZyB0aGUNCj4gPiBoaWdoZXIgYXJlYXMgb2YgdGhlIEJBUiwgd2UgbmVl
ZCB0byBjcmVhdGUgbXVsdGlwbGUgc2VwYXJhdGUgbWVtb3J5IG1hcHMuDQo+ID4gRG9pbmcgc28g
d2lsbCBjcmVhdGUgYSBzcGFyc2UgbWFwcGluZyByYXRoZXIgdGhhbiBhIGNvbnRpZ3VvdXMgc2lu
Z2xlIGFyZWEuDQo+ID4NCj4gPiBSZXBsYWNlIHRoZSB2b2lkICpod19hZGRyIHdpdGggYSBzcGVj
aWFsIGljZV9od19hZGRyIHN0cnVjdHVyZSB3aGljaA0KPiA+IHJlcHJlc2VudHMgdGhlIG11bHRp
cGxlIG1hcHBpbmdzIGFzIGEgZmxleGlibGUgYXJyYXkuDQo+ID4NCj4gPiBCYXNlZCBvbiB0aGUg
YXZhaWxhYmxlIEJBUiBzaXplLCBtYXAgdXAgdG8gMyByZWdpb25zOg0KPiA+DQo+ID4gICogVGhl
IHNwYWNlIGJlZm9yZSB0aGUgUkRNQSBzZWN0aW9uDQo+ID4gICogVGhlIFJETUEgc2VjdGlvbiB3
aGljaCB3YW50cyB3cml0ZSBjb21iaW5pbmcgYmVoYXZpb3INCj4gPiAgKiBUaGUgc3BhY2UgYWZ0
ZXIgdGhlIFJETUEgc2VjdGlvbg0KPiANCj4gUGxlYXNlIGRvbid0Lg0KPiANCj4gWW91IGhhdmVb
MF06DQo+IA0KPiAqIGlvX21hcHBpbmdfaW5pdF93YygpICgrIGlvX21hcHBpbmdfZmluaSgpKTsN
Cj4gKiBpb19tYXBwaW5nX2NyZWF0ZV93YygpICgrIGlvX21hcHBpbmdfZnJlZSgpKTsNCj4gDQo+
IF4gdGhleSBkbyB0aGUgc2FtZSAodGhlIHNlY29uZCBqdXN0IGFsbG9jYXRlcyBhIHN0cnVjdCBh
ZC1ob2MsIGJ1dCBpdA0KPiAgIGNhbiBiZSBhbGxvY2F0ZWQgbWFudWFsbHkgb3IgZW1iZWRkZWQg
aW50byBhIGRyaXZlciBzdHJ1Y3R1cmUpLA0KPiANCj4gKiBhcmNoX3BoeXNfd2NfYWRkKCkgKCsg
YXJjaF9waHlzX3djX2RlbCgpKVsxXTsNCj4gDQo+IF4gb3B0aW9uYWwgdG8gbWFrZSBNVFJSIGhh
cHB5DQo+IA0KPiAtLSBwcmVjaXNlbHkgZm9yIHRoZSBjYXNlIHdoZW4geW91IG5lZWQgdG8gcmVt
YXAgKmEgcGFydCogb2YgQkFSIGluIGENCj4gZGlmZmVyZW50IG1vZGUuDQo+IA0KPiBTcGxpdHRp
bmcgQkFScywgZHJvcHBpbmcgcGNpbV9pb21hcF9yZWdpb25zKCkgYW5kIHNvIG9uLCBpcyB2ZXJ5
IHdyb25nLg0KPiBOb3Qgc3BlYWtpbmcgb2YgdGhhdCBpdCdzIFBDSSBkcml2ZXIgd2hpY2ggbXVz
dCBvd24gYW5kIG1hcCBhbGwgdGhlDQo+IG1lbW9yeSB0aGUgZGV2aWNlIGFkdmVydGlzZXMgaW4g
aXRzIFBDSSBjb25maWcgc3BhY2UsIGFuZCBpbiBjYXNlIG9mDQo+IGljZSwgUENJIGRyaXZlciBp
cyBjb21iaW5lZCB3aXRoIEV0aGVybmV0LCBzbyBpdCdzIGljZSB3aGljaCBtdXN0IG93bg0KPiBh
bmQgbWFwIGFsbCB0aGUgbWVtb3J5Lg0KPiBOb3Qgc3BlYWtpbmcgb2YgdGhhdCB1c2luZyBhIHN0
cnVjdHVyZSB3aXRoIGEgZmxleCBhcnJheSBhbmQgY3JlYXRpbmcgYQ0KPiBzdGF0aWMgaW5saW5l
IHRvIGNhbGN1bGF0ZSB0aGUgcG9pbnRlciBlYWNoIHRpbWUgeW91IG5lZWQgdG8gcmVhZC93cml0
ZQ0KPiBhIHJlZ2lzdGVyLCBodXJ0cyBwZXJmb3JtYW5jZSBhbmQgbG9va3MgcHJvcGVybHkgdWds
eS4NCj4gDQo+IFRoZSBpbnRlcmZhY2VzIGFib3ZlIG11c3QgYmUgdXNlZCBieSB0aGUgUkRNQSBk
cml2ZXIsIHJpZ2h0IGJlZm9yZQ0KPiBtYXBwaW5nIGl0cyBwYXJ0IGluIFdDIG1vZGUuIFBDSSBk
cml2ZXIgaGFzIG5vIGlkZWEgdGhhdCBzb21lb25lIGVsc2UNCj4gd2FudHMgdG8gcmVtYXAgaXRz
IG1lbW9yeSBkaWZmZXJlbnRseSwgc28gdGhlIGNvZGUgZG9lc24ndCBiZWxvbmcgaGVyZS4NCj4g
SSdkIGRyb3AgdGhlIHBhdGNoIGFuZCBsZXQgdGhlIFJETUEgdGVhbSBmaXgvaW1wcm92ZSB0aGVp
ciBkcml2ZXIuDQo+IA0KDQpBcHByZWNpYXRlIHRoZSByZXZpZXchIEkgcHJvcG9zZWQgdGhpcyBv
cHRpb24gYWZ0ZXIgdGhlIG9yaWdpbmFsIGNoYW5nZSB3YXMgdG8gc2ltcGx5IHJlZHVjZSB0aGUg
aW5pdGlhbCBzaXplIG9mIG91ciBiYXIgbWFwcGluZywgcmVzdWx0aW5nIGluIGxvc2luZyBhY2Nl
c3MgdG8gdGhlIHJlZ2lzdGVycyBiZXlvbmQgdGhlIFJETUEgc2VjdGlvbiwgd2hpY2ggd2FzIGEg
bm9uLXN0YXJ0ZXIgZm9yIHVzIG9uY2Ugd2UgZmluaXNoIGltcGxlbWVudGluZyBTY2FsYWJsZSBJ
T1Ygc3VwcG9ydC4NCg0KU2VhcmNoaW5nIGZvciBpb19tYXBwaW5nX2luaXRfd2MgYW5kIGlvX21h
cHBpbmdfY3JlYXRlX3djIHRoZXJlIGFyZSBvbmx5IGEgaGFuZGZ1bCBvZiB1c2VycyBhbmQgbm90
IG11Y2ggZG9jdW1lbnRhdGlvbiBzbyBubyB3b25kZXIgSSBoYWQgdHJvdWJsZSBsb2NhdGluZyBp
dCEgVGhhbmtzIGZvciBoZWxwaW5nIG1lIGxlYXJuIGFib3V0IGl0Lg0KDQpARGF2ZS5FcnRtYW5A
aW50ZWwuY29tLCBAU2FsZWVtLCBTaGlyYXogaXQgbG9va3MgbGlrZSB3ZSBuZWVkIHRvIGRyb3Ag
dGhpcyBwYXRjaCBhbmQgbW9kaWZ5IHRoZSBpUkRNQSBkcml2ZXIncyBtZXRob2Qgb2YgcmVxdWVz
dGluZyB3cml0ZSBjb21iaW5lZCByZWdpb25zIHRvIHVzZSB0aGVzZSBuZXcgaW50ZXJmYWNlcy4N
Cg0KQE5ndXllbiwgQW50aG9ueSBMIENhbiB5b3UgZHJvcCB0aGlzIHBhdGNoIGZyb20gdGhlIHNl
cmllcyBvbiBJV0wgb3Igc2hvdWxkIEkgc2VuZCBhIHYzPw0KDQpUaGFua3MsDQpKYWtlIA0K
