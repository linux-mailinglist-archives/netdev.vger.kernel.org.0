Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B672245FD
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 23:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgGQVwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 17:52:49 -0400
Received: from alln-iport-5.cisco.com ([173.37.142.92]:36631 "EHLO
        alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbgGQVws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 17:52:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1560; q=dns/txt; s=iport;
  t=1595022767; x=1596232367;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LgloC1AS/Q4eQaTmbfY2cBQEqYFb4K/6Wua7hvQSsfM=;
  b=YBVhMNmEec+J4ZuEh2iYkKY3lF03ngOTBgIcNrobRxwBSa3DkUt23Bad
   Mjx9lUJOQieglRGTyc9PAH5H9y9Bgp+KZkOQ5Eq+phIVgQumu8YmiJO5g
   APm4Epnai5of+/dLQhiHFIcHYaFBpZwiwQi9hjv/sHlbld1sqCj0DH0Vo
   k=;
IronPort-PHdr: =?us-ascii?q?9a23=3Axr4ilB0le4FUUeWCsmDT+zVfbzU7u7jyIg8e44?=
 =?us-ascii?q?YmjLQLaKm44pD+JxWGvad2kUTEG47JuLpIiOvT5qbnX2FIoZOMq2sLf5EEUR?=
 =?us-ascii?q?gZwd4XkAotDI/gawX7IffmYjZ8EJFEU1lorGqmKkUTE9StL1HXq2e5uDgVHB?=
 =?us-ascii?q?i3PAFpJ+PzT4jVicn/1+2795DJJQtSgz/oarJpJxLwpgLU5cQ=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AYAAAEGxJf/5FdJa1gGwEBAQEBAQE?=
 =?us-ascii?q?BBQEBARIBAQEDAwEBAUCBNgYBAQELAYFRUQeBRy8shDODRgOEWIhumF6BLoE?=
 =?us-ascii?q?lA1ULAQEBDAEBLQIEAQGETAIXggICJDQJDgIDAQELAQEFAQEBAgEGBG2FWwE?=
 =?us-ascii?q?LhXABAQEDEhERDAEBNwEPAgEIGAICJgICAjAVEAIEDieFUAMuAZ9xAoE5iGF?=
 =?us-ascii?q?2gTKDAQEBBYULGIIOCYEOKgGCaYNVhjMagUE/g2w1PoQ9gxaCYJJRonEKgl2?=
 =?us-ascii?q?ZYyGfQy2RU55+AgQCBAUCDgEBBYFTOoFXcBWDJFAXAg2OHoNxilZ0NwIGCAE?=
 =?us-ascii?q?BAwl8jw0BAQ?=
X-IronPort-AV: E=Sophos;i="5.75,364,1589241600"; 
   d="scan'208";a="525562300"
Received: from rcdn-core-9.cisco.com ([173.37.93.145])
  by alln-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 17 Jul 2020 21:45:39 +0000
Received: from XCH-RCD-004.cisco.com (xch-rcd-004.cisco.com [173.37.102.14])
        by rcdn-core-9.cisco.com (8.15.2/8.15.2) with ESMTPS id 06HLjd0q024528
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Fri, 17 Jul 2020 21:45:39 GMT
Received: from xhs-aln-002.cisco.com (173.37.135.119) by XCH-RCD-004.cisco.com
 (173.37.102.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Jul
 2020 16:45:39 -0500
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xhs-aln-002.cisco.com
 (173.37.135.119) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Jul
 2020 16:45:38 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 17 Jul 2020 17:45:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XM5tPf1G8yO3FI+fp8ePv811EpQjdIf7zK1Q+x1UwJ3Xx+kYqxoIZTmx27o84pa47FCh1RTO1k5Oh+hfsYOE458QKWicSUG2bl6nZbEX1u2KPtkGKo3wHnCMKNIFcs4Umzzhdgdtvaus34dT0j2mwumqu1pyynmz3Tljj7cg9ESxg1xxnQNNeaUcxxEZJfvmQZynfFsOfrUsZZFDITNQlJgT4TM/FamfS6wtsFnWrFIWjo5ije+yC3b9tBOKGUmTmlqRYkL5M2YcGl2FL+EuLFZfvllYiZ+2/4XfFJRGBAefezuPBby7VhSqjXQgRF5NFwK7iDdq+TQiQhZy43bU8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgloC1AS/Q4eQaTmbfY2cBQEqYFb4K/6Wua7hvQSsfM=;
 b=Raq6DsM6XDtdTZVaNfTXaWwv98mTUG4vHg++IXVeAIMZl/lVu1uuhN4klWgwFaKkJfkbXD+i9WEAVcahDoliMm4JkvLqIKavvG+d3n8VzVpDXab3WvkxTMusJypAxGVklzSvBhwlZAYS4mqfCIRujb5qb6Bd3O2CiCV+fsQdiRD8Eo2VneE7I/NQSSZYWtm6ZfZSvVPfxl3J037+cAg2CIHKcFoOwIQ+Pzmqa78snSFJYCfGmWUQicUTuReYhMb9banD/OVXVkllXhTH6mLquKkPp87/8RWVpPSL2kstPmhYYJhvItF0Kuxpz1ImUS0K+d/hCYJzBB8TJngzgRapFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgloC1AS/Q4eQaTmbfY2cBQEqYFb4K/6Wua7hvQSsfM=;
 b=eSK4O9ZJQPFtf42uTpnIOvltI7/MTyDxzlE+glYwjHpRrpbK3AJ6rvY85bqC1wb6fc+sdBlsrrKMQDQgDZkszXQBaKBiliivmvYEKpD4CkSDZLMM2IV/wm3PX6AM/lMVW42M7ZF0bWJQdTtB1X0ElqzwFrJP0o92dl+NxvY55jA=
Received: from MN2PR11MB3711.namprd11.prod.outlook.com (2603:10b6:208:fa::26)
 by MN2PR11MB4127.namprd11.prod.outlook.com (2603:10b6:208:13e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Fri, 17 Jul
 2020 21:45:37 +0000
Received: from MN2PR11MB3711.namprd11.prod.outlook.com
 ([fe80::d880:f62c:56ba:9457]) by MN2PR11MB3711.namprd11.prod.outlook.com
 ([fe80::d880:f62c:56ba:9457%6]) with mapi id 15.20.3174.025; Fri, 17 Jul 2020
 21:45:37 +0000
From:   "Govindarajulu Varadarajan (gvaradar)" <gvaradar@cisco.com>
To:     "mkubecek@suse.cz" <mkubecek@suse.cz>
CC:     "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH ethtool 1/2] ethtool: add support for get/set
 ethtool_tunable
Thread-Topic: [PATCH ethtool 1/2] ethtool: add support for get/set
 ethtool_tunable
Thread-Index: AQHWPfbSDEj52QcbI0aKmSuyEIBk+Kj4LzuAgBRcDAA=
Date:   Fri, 17 Jul 2020 21:45:36 +0000
Message-ID: <8f7a077b0beadc4866ddd9c75ebaa42938cb9b45.camel@cisco.com>
References: <20200608175255.3353-1-gvaradar@cisco.com>
         <20200704225057.srqu6ylhhh2rnsqp@lion.mk-sys.cz>
In-Reply-To: <20200704225057.srqu6ylhhh2rnsqp@lion.mk-sys.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.4 
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2601:646:8100:c5c1:7a2d:2fe3:9ea3:2560]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d6dcaf6-ab3e-444f-03f6-08d82a9abde8
x-ms-traffictypediagnostic: MN2PR11MB4127:
x-microsoft-antispam-prvs: <MN2PR11MB4127FAF2C6FF988D75385815D47C0@MN2PR11MB4127.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FSKf86e4LgayLCLysvGd4vDMeAi4L4D+PAseoxC8/EQIJm6yndMU/tBH8yQ0YvESRq394adrBB3sRrt02xji8rmDeXWKWT2fr/7rzjJsm0ofiEJekEOGFXyVknIyV7/XdPT6+MZICIHBQtysdCUM3Dv/WlIsWUn7PL3k5+Kc/DYs/lENpOP1mlV14hVk/HPWSdEFGFpVtCSxFX2OaAXEw+PCYf1zehv3xEn7q7XEAICJE5oz7IGx0ZBBTLD8w0G9sGCa/YeP1KmK5VxXl9G21NMw2nIJfg9pYfV918G/69epLShdZ1jlV3rFUIbx13WcBpHck5HJZMbSUTVNUNMPqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3711.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(54906003)(36756003)(8936002)(71200400001)(66946007)(66476007)(4326008)(8676002)(66556008)(186003)(5660300002)(2906002)(83380400001)(66446008)(6512007)(91956017)(86362001)(2616005)(6486002)(6506007)(478600001)(316002)(64756008)(6916009)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: WpPpZz1WOZ+d/1eQa8dC4H+bRXn0xQoz7paOW18Oynv0DUkHK1RZWJ/iaO3aAwmCSE5D+BxiTHNhNxYj3RIPMtLQ+8oCbYe1ZVf50rzO3wqZuEsx+5ZSaCEyg1HkcIjYho2ADKhH2UxqpnhocpLV7TkdbTpmwBpJ+SvLs8LP47yZhbfoRJa7HDODi8rEjWm9Mdr7ggZN3egfCpt+fjg77klfkjkoH+imtmABL7IJfc5VUUfbhDlnVmO0ChE9XncuD9KxT338IGOiwmYfexW1SecnVyOG+fHQQdqT7pnoyvUkwXv1g5khbGlUOUQE1flknjURozapvXk8wWshaMD52Wgr6JwHXdCil8aMh9X33iW+wCQGY9zd1+g2nXi2sAgqa7ElAgcNnM1+7CBrhDUgJnkLjqNo7pzHF//iH98uNi1gShfp/2hsxpByA0gfO2nj1TBVb8iytcPht5B9QiqLi35DpwgZxRKrGajxRkkm4tf+3a039RjH6OKIFQ9sB3vd5MuntjzepZH2sOQwBoC+irdLYKkf424sikQ9RdZekuV4gSW9STj7Kmyxqnn7xUC8
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A5535884F22C7429C53A2E4E60D7E7A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3711.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6dcaf6-ab3e-444f-03f6-08d82a9abde8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2020 21:45:37.0715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oZntBaarn1VNiI5o+6ixAKMSpgWpJzC7HfEoL+cPdtgzdyn68RlNXYqpuJyUi1VUy27YJam+S/sQks8WsaI3KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4127
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.14, xch-rcd-004.cisco.com
X-Outbound-Node: rcdn-core-9.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTA3LTA1IGF0IDAwOjUwICswMjAwLCBNaWNoYWwgS3ViZWNlayB3cm90ZToN
Cj4gT24gTW9uLCBKdW4gMDgsIDIwMjAgYXQgMTA6NTI6NTRBTSAtMDcwMCwgR292aW5kYXJhanVs
dSBWYXJhZGFyYWphbiB3cm90ZToNCj4gPiBBZGQgc3VwcG9ydCBmb3IgRVRIVE9PTF9HVFVOQUJM
RSBhbmQgRVRIVE9PTF9TVFVOQUJMRSBvcHRpb25zLg0KPiA+IA0KPiA+IFRlc3RlZCByeC1jb3B5
YnJlYWsgb24gZW5pYyBkcml2ZXIuIFRlc3RlZCBFVEhUT09MX1RVTk5BQkxFX1NUUklORw0KPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFRVTkFC
TEUNCj4gPiBvcHRpb25zIHdpdGggdGVzdC9kZWJ1ZyBjaGFuZ2VzIGluIGtlcm5lbC4NCj4gDQo+
IFRoaXMgbWFrZXMgbWUgd29uZGVyIGhvdyBhcmUgc3RyaW5nIHR1bmFibGVzIHN1cHBvc2VkIHRv
IHdvcmsuDQo+IFVuZm9ydHVuYXRlbHkgdGhlcmUgaXMgbmVpdGhlciBkb2N1bWVudGF0aW9uIG5v
ciBjb2RlIG9uZSBjb3VsZCBsb29rIGF0Lg0KPiBJIHRyaWVkIHRvIHVuZGVyc3RhbmQgaXQgZnJv
bSB0aGlzIHBhdGNoIGJ1dCBpdCBkaWRuJ3QgaGVscCBtdWNoIGVpdGhlcjoNCj4gZG9fc3R1bmFi
bGUoKSB3aWxsIHBhc3MgYSBzdHJpbmcgb2YgYXJiaXRyYXJ5IHNpemUgdG8ga2VybmVsIGJ1dA0K
PiBkb19ndHVuYWJsZSgpIGFsbG9jYXRlcyBhIGJ1ZmZlciBvZiBmaXhlZCBzaXplIChmb3IgYSBn
aXZlbiB0dW5hYmxlKS4NCj4gSXMgdGhpcyBzdXBwb3NlZCB0byBiZSB0aGUgbWF4aW11bSB2YWx1
ZSBsZW5ndGg/IE9yIGlzIGtlcm5lbCBnb2luZyB0bw0KPiByZXR1cm4gYW4gZXJyb3IgaWYgdGhl
IGJ1ZmZlciBpcyBpbnN1ZmZpY2llbnQgYW5kIHVzZXJzcGFjZSByZXBlYXRzIHRoZQ0KPiByZXF1
ZXN0Pw0KDQpJIGRvIG5vdCBrbm93LiBzdHJpbmcgdHVuYWJsZSBpc24ndCBpbXBsZW1lbnRlZC9z
dXBwb3J0ZWQgaW4ga2VybmVsLg0KSSBhc3N1bWVkIGRyaXZlcidzIGdldC9zZXRfdHVuYWJsZSgp
IHJldHVybnMgZXJyb3IgaW4gY2FzZSBpbnN1ZmZpY2llbnQgc2l6ZS4NCg0KQWRkcmVzc2luZyB0
aGUgcmVzdCBvZiB0aGUgY29tbWVudHMgYW5kIHNlbmRpbmcgdjIuDQoNCi0tDQpHb3ZpbmQNCg==
