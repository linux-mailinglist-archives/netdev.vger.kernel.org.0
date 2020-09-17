Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E1226E747
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 23:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgIQVUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 17:20:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:59296 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgIQVUy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 17:20:54 -0400
IronPort-SDR: KNRFKNW2TcQNa23DKx6tzHcvKYDGpluC9iH1acMYIM7aYV8apR6J4yOYG2QK+N9eE2rKOagTmU
 wJ7WT4zBFv3g==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="159853013"
X-IronPort-AV: E=Sophos;i="5.77,272,1596524400"; 
   d="scan'208";a="159853013"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 14:20:52 -0700
IronPort-SDR: V6bNbl/R/Kzi4nJdZIXsqITzStWANphWwct/m+CEU84viGUwwIXok9wq2rmQs/GPqe1HtRX0A/
 aQZd7nGWlcYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,272,1596524400"; 
   d="scan'208";a="307625960"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 17 Sep 2020 14:20:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 17 Sep 2020 14:09:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 17 Sep 2020 14:09:16 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 17 Sep 2020 14:09:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfc05HQO0X1E4absgejhsT+/iGYlen/M3pngJ3Z6VPxcVfp+Qrp3xwNJmr+HROwrn8amP/H+vKyd7I0vaLpAha2BMeuZNhxNWF1Ed/7QmmYYN74HyiWrBr+Vzr6uqWrFVh5b3xLZ1loa/Dn4STATQ4+Nw5cVUa8rvNkVKw5AbkF+Q6Kob9qwkUdEL6X9YkoCgdi9VWrhcwFJ8YHfNCqQ6s+Sw5zJwDijSQ2fwVKS59boUxezRGOVbwit8rwJXKDgq+cLN7ESph8q59B9Dfn3rwr0o6EisxVXK7c3SiMBHvUli6KJjaRp7n6j72ZcSQf0jejYcXYy8g9KojgmKaicIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ijifg0Sd5htssKBRvvqQ3rQIShWR+QHSvSLRqbTDEMY=;
 b=lA+aHISr2LIw3vStNMNAGXXod7o5b/qKiI5P/r8Ta/ldJwwO/qvsx+eT1GDO9mUWBpm6wjoaaPQXeq3hoEf4XvFuLFh2AlpmEgqmH1O2wrshhe2E+1F9RPBl8SzI8NHY1laFQo4xI4B4SM0k3QrTpOSf5smVQRoGOKY7J7N8f38UiJGrLxY5lOGsNipwT8S11sVu2cBc88HxgnbdT7TBoRjPQyWZRYXPeh07h1hY72i0AMhw6P6PD24ag5SdMdmgV2WmF0oEDFU19OIRNOg+pqoT8w8mLSRNGwU8zbL3Pss4CBFE8v1aMnZn0SElmWKH7y9NnEk8qa8n6/RPbsLhIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ijifg0Sd5htssKBRvvqQ3rQIShWR+QHSvSLRqbTDEMY=;
 b=vtNWhQ/CkQwLIhqrGzlPvX8iSon95NR4UoLtidZtzG1ZGYDd8WWbj5jwNJQf3fwuxnGjKGAuls2zJ4RSnKnY07C1t5GNc61Aeh90YNSrQMHsWq5KOLTsKvgHX6Kce3AsfGzZ4gWT0sdtpM9oi93jHwMeV43IJjEbh0KSpms64sA=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2800.namprd11.prod.outlook.com (2603:10b6:805:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Thu, 17 Sep
 2020 21:09:11 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7147:6b91:afe3:1579]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7147:6b91:afe3:1579%3]) with mapi id 15.20.3370.019; Thu, 17 Sep 2020
 21:09:11 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
Subject: Re: i4oe/XXV710 suspect tx_dropped stats
Thread-Topic: i4oe/XXV710 suspect tx_dropped stats
Thread-Index: AQHWi2M9+X8hkmtRSk+2rwiRjP4GhqltVswA
Date:   Thu, 17 Sep 2020 21:09:11 +0000
Message-ID: <55c3ab346c617027da96f5cc59410511ff94a092.camel@intel.com>
References: <81307012-3c76-51a9-95cb-2b14a7118467@mojatatu.com>
In-Reply-To: <81307012-3c76-51a9-95cb-2b14a7118467@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 290ca20d-f7c7-4d5c-16b9-08d85b4decb9
x-ms-traffictypediagnostic: SN6PR11MB2800:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB28003EBAF4B825D5F9FD0FCAC63E0@SN6PR11MB2800.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ANMX5HoN46OpKCmrctqz6u7puHGi64vMTFqKH12CA7OzZNmp2lHrbZcHBn+iMNkK/9vJc2IJ19VCJ8/uSYt6kx35Ae0/Kz1SwQN/+ecTJYzp2poFLRlLby3s8XbFkJyuSUPgvR3dyR9q9ue2PgvTxsTnyq/shKFwUE7CDfEr5jyshm3VxS5it6bi4R7eL1/uFimQdhbFYGpnJ7kFEkh7GMepXqpbUfFK3cWu+4jjC+mH0KncrKDuBeUPzsDE5ARZJfXgRNXi+RZITNTyMqAhn+cVv1VpblbcH0DFd1BN2qLdYbGrEKJlb+6d2QlsLHAzGItSJcOa2WBJsRkkM3JhT+FP0bHUpkWh3pppYcjA7ZvnkjJsJKrbMY7WPwP1nLJax6X/T/XkLpqcCVn5eVKX3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(316002)(6506007)(8936002)(6486002)(478600001)(6512007)(26005)(186003)(2906002)(36756003)(5660300002)(2616005)(86362001)(558084003)(8676002)(4326008)(107886003)(66946007)(110136005)(66446008)(64756008)(66476007)(66556008)(71200400001)(54906003)(91956017)(76116006)(99106002)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /UsiCPutNOoJEiPi2a7wxIaPF4gnS3DDULmhzuY8fNVzGTuPx84Zt/ur+B/2zMI8xaNslv3XLSvdWryLS0ffGbw5j04FPd0Jpn3/YmuafUiOG4qXZfgPOEwFrbJQXwgQQBxji7xf2XZNZJoDTcqMrMfZLqO922gs4qvQX9nTXjxvXpYPL3gm1tf3gpoLPslgNA+0gZnNBVvLRHZKLe2a+ydNAkDDeca8DBRBt+25vsBXTiklpzUBW/1l38R+CCI9slFFnnuG7HSYw8Mz5Fh/pTAqr3LuLvXlorKoz9isnx+KA3j+IwXt2f5phwUBxZYUtEFA56TvQmvrgN+PQeD/PQqOXf9UsN1+9DShN9lgWqOnPreBYn5fQYjoMGP9D3PTDumGxfvWvwDUpt4yKttdBxqk+5sf1q+3P4yzv4CBXRQZZxb/6qN0QtZ+CTv/r1MASmtbDJwswrlk/t3JrXWos72utGyVUkqnrCLU8F43iaEONGQ2IB5BLLhkYDaGHrhEWhXrOA9ibqUYd8ZvvWW9BVey1nDFHtDPx9P0gxQxk1ao2TXAdS5cjb8A3UB2bY0L9LTPt8AJb8KESrwzS4t28uFloxHyRVQyL9LJHUivq7JrF22FXdp52Pn11n+jqQ4sKUsMRu3fUC95I322hfYwIQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <70DEB1C6624A524CA47E226F8AE06F9A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 290ca20d-f7c7-4d5c-16b9-08d85b4decb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2020 21:09:11.1319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mPvoKJaeMn+zGFrTmwuuIa5pFsB6j1psK8/4M//v8QPHEvQhurnT1YFsRdDWir40V0PftVjODWtULsDQi/65blTDrPiEd+Fh8InGQn/55NU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2800
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA5LTE1IGF0IDA5OjIyIC0wNDAwLCBKYW1hbCBIYWRpIFNhbGltIHdyb3Rl
Og0KPiBFdGh0b29sIHJlcG9ydGluZyB6ZXJvLiBpcCAtcyByZXBvcnRpbmcgbm9uLXplcm8uDQo+
IFdoaWNoIGlzIHJpZ2h0PyBTZWUgYXR0YWNoZWQgZm9yIG1vcmUgZGV0YWlscy4NCj4gDQpJJ3Zl
IGFza2VkIHRoZSB0ZWFtIHJlc3BvbnNpYmxlIGZvciB0aGUgZHJpdmVyIHRvIGxvb2sgaW50byB0
aGlzIGlzc3VlLg0KSSB3aWxsIGxldCB5b3Uga25vdyB3aGF0IEkgaGVhciBiYWNrLg0KDQpUaGFu
a3MsDQpUb255DQo=
