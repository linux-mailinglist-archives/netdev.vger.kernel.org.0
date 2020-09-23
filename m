Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE68627531F
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgIWIU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:20:59 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1908 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgIWIU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:20:59 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6b053c0001>; Wed, 23 Sep 2020 01:20:12 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 23 Sep
 2020 08:20:54 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 23 Sep 2020 08:20:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBp6VdefvtGzYLnN0gjIHMqtvKQmU/tb2RJTvFX7QHVTQjgfAsA01t6FiKYkYCrHYe/e8ggb3vxoDTvusAk6T4Otb/ycCjXidUdmHC4sZFtRZQJRzNHjZQZGZe8rg6VdzqaSB2dwi1EsI4pqt5ViIa3f7i+EqglhN/YwL60V1ZAbVZnbotlFlTrslh+Dy5ImLiL9LP7G6PhFyXWsYFWl8mOqdW9moDs81Uxj6scbzpcsCQ1ierwSnwEJlSM2VYwSozLTmx4/7HYUZT07EqgntUZACaClzRrQnM4gRDA/3zZr1VzUJ5bAEVO+ykcF7qV31+Pa8op2djG6DuHJhvnUVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KUuACMDD6PBH+dEKYhQbAwOejlM0Ktxx6YNK/MWDbo=;
 b=HHRAqsuUbEukob2CxQ7piqIVGx5r6bIiIhfvq946ZD69cnWcBO1wqRddT8EWZnX6xXOw9r2BLjLcSdM3wVaYwyXQixOcWqRT8X5VUidcCDzqdOzIx4bOeY2TrWRAbr3ilPsnmZsrbYO0qJUqxt0x9mcjARtHPVRLkO3hBovl+D8wNdXVQfvPcg5Ms8haSQ8caqo2Zh3Ves05AJDPE2uE7wDueT+pyLh+BDrbRoOKoxMiV4szq0OB3+Wturb9nwFXkCtA/noEUOXmmr9JH4vNpv4UyIX50MaV87Q3DDjh+w9ruyRy+rxMYx8vpPMboNHBzshFkV4xQxS0aihLydATqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BYAPR12MB2823.namprd12.prod.outlook.com (2603:10b6:a03:96::33)
 by BY5PR12MB4275.namprd12.prod.outlook.com (2603:10b6:a03:20a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 23 Sep
 2020 08:20:52 +0000
Received: from BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b]) by BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b%6]) with mapi id 15.20.3391.027; Wed, 23 Sep 2020
 08:20:52 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lkp@intel.com" <lkp@intel.com>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 12/16] net: bridge: mcast: install S,G entries
 automatically based on reports
Thread-Topic: [PATCH net-next v2 12/16] net: bridge: mcast: install S,G
 entries automatically based on reports
Thread-Index: AQHWkLJY7HGcSbvXrkyWm2Dfs8noZql14VYAgAACKoA=
Date:   Wed, 23 Sep 2020 08:20:52 +0000
Message-ID: <e3e9fec1ac857512ee37c6bbc8f67fa047778484.camel@nvidia.com>
References: <20200922073027.1196992-13-razor@blackwall.org>
         <202009231635.WjfHleMK%lkp@intel.com>
In-Reply-To: <202009231635.WjfHleMK%lkp@intel.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 473f164e-a953-4492-f6b7-08d85f99963c
x-ms-traffictypediagnostic: BY5PR12MB4275:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4275E93CF4FA843F8A584118DF380@BY5PR12MB4275.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L2UunSWO6RLDt2CWKvne/phomyyMMq+wpVz3xW+I6ld8O8HrLWqfoHH8+TqARTOrO5r7KcBxKvofsNLyN04ASbkjNkPTcBU3ZgWFeVf297yIgyaY0r5+8QCYcDJ2GSyh24YckVHqa3DjRhO+cmPCo4zAko0DNVerjf5/Vkj3zEn29dQFEepKH+Nm8ydL/wsoP4eUjycRsYPu/3o4cSbnhCKJxCH3TyvtvffIUcnNplWxgrHA+Nay6d/H5M0FeWRt0QgqpSVYlD3/8fMsypyRVjuHB5xnzNQOML9GZGfM5s1XSFI+fBP6x2WbPEbHRLHvCyn6/MNgEYZ1jsW8sZ11jKLwR7mRPe1L99yuqgIkU7vyNb2Nk5PIdyXOtqlFIpeNP21F+7AZ875MzjUBZX8xPqcAtX0Zy9sOWJX4Lwck08Dg5Z/7kzuu0D5RcBJynJTomK7vlus1Z2TEnaV+jzasGztowxNUfH1evdfcQg+fPasjJtqFZNQRZl3h8X7wLL6i
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2823.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(966005)(5660300002)(3450700001)(478600001)(6512007)(36756003)(186003)(66446008)(64756008)(66556008)(66476007)(2616005)(8676002)(86362001)(76116006)(91956017)(6506007)(71200400001)(26005)(66946007)(2906002)(6486002)(8936002)(4326008)(54906003)(110136005)(316002)(83380400001)(142933001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: FsUgYL7Q92PJVDDIEJbTEYXY7lGcxrQQ87oD/44b7Uu/pEUkMrAxsm4Ybsb6XekObIs5jcXmYIKPPm161ufAjZYNA4CUzYTo6UaktIL5s4XU8S8YOCe5DwzI3f3jp0CH47vMtKVIEMANrCSis7IGR0ghd/xAvcUv97WgEkXxZRF2Z/jtVACk3R4PGwfHFuV0kRZbq0iZciYU+xfIl2pjKZOcBXKo/IYNd4WZEJsjZ6QuK7TzyLM4HDf+0k56rLk/v9tqoJlsYDcOGG/IEBJ2VtUaE2EtzKgE3RMph7s36GaArQO3Hg5N/Aqvo6WPIcOlLu1Kt66qHvz3gRl8tLIRAn17Jy4zv9Y/Xel+qHlpl+93tmIMLluCnQWGKX/wDOWOZ2Pz9pdg1qcO1lhXQWFwr4t860je+fC5QQmaB8FvMGcwFski3/rsns6o/yRvfYzcHsk+iXcQq6c1fSIjjGFrtXmbXr9W80luWypNvr6ROwvC+7Zav/TKflyAk8ldkJzewYLSnLptLHVHpjqxkacjnGFr99mjiP4+rr5COmXSRzAcCT+kibbpcLRBeQjQtNvlBY3g7SQaD5SlNZrsIRBXxhbhFfe5lqq6ubTjic6UIvlhdTekUBOOmO7trcxYB5jzzo7i7enA76PXTVrODm1rsA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <332771DE6537A64D8F3A0CECE32C4953@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2823.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 473f164e-a953-4492-f6b7-08d85f99963c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 08:20:52.6046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WSTTUjJw46+kq2qAPCIi/BO+obE+A4nJR9829IS3rdpJRpGfDCWbCaqqixLaJG8TKDmHtjP1tVKwpEPMNjdwww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4275
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600849212; bh=4KUuACMDD6PBH+dEKYhQbAwOejlM0Ktxx6YNK/MWDbo=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Reply-To:Accept-Language:Content-Language:
         X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=mwx3Qmeg9Pq/UONgjxlfF1YFpiv0QOz2OmMPXwwGoaSRIHRnNk9s8YxnWHB3XhbD4
         E1i+pyGIf0N/paeKw3O7GO5tZprBBzwguP2oEV4j9jkOFDrpQFpxmMXdIkkmZwJxvv
         v9yLimDOLiGMQ1L+eb+vWrk8D9ZN95M2lsTsuoMqoSXmsznew/IiLo8+ZR8GwAVyXZ
         yHc2ERN1FAsh7M/Uk4mU23qLOQ74uPLpMRtDAIZIKM2JD0HPlnejCJzcEE2v7O9rck
         UiwbX+fczQXoqyAH/cZ5Lcm9Wt73hCyJgSD9fIRn8KLrbs21+v4CpDUV82jr2J3g2C
         wnSel6YKGwokQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA5LTIzIGF0IDE2OjEzICswODAwLCBrZXJuZWwgdGVzdCByb2JvdCB3cm90
ZToNCj4gSGkgTmlrb2xheSwNCj4gDQo+IEkgbG92ZSB5b3VyIHBhdGNoISBQZXJoYXBzIHNvbWV0
aGluZyB0byBpbXByb3ZlOg0KPiANCj4gW2F1dG8gYnVpbGQgdGVzdCBXQVJOSU5HIG9uIG5ldC1u
ZXh0L21hc3Rlcl0NCj4gDQo+IHVybDogICAgaHR0cHM6Ly9naXRodWIuY29tLzBkYXktY2kvbGlu
dXgvY29tbWl0cy9OaWtvbGF5LUFsZWtzYW5kcm92L25ldC1icmlkZ2UtbWNhc3QtSUdNUHYzLU1M
RHYyLWZhc3QtcGF0aC1wYXJ0LTIvMjAyMDA5MjItMTUzMzIxDQo+IGJhc2U6ICAgaHR0cHM6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGF2ZW0vbmV0LW5leHQuZ2l0
IDkyZWM4MDRmM2RiZjBkOTg2ZjhlMTA4NTBiZmZmMTRmMzE2ZDdhYWYNCj4gY29uZmlnOiBpMzg2
LXJhbmRjb25maWctbTAyMS0yMDIwMDkyMyAoYXR0YWNoZWQgYXMgLmNvbmZpZykNCj4gY29tcGls
ZXI6IGdjYy05IChEZWJpYW4gOS4zLjAtMTUpIDkuMy4wDQo+IA0KPiBJZiB5b3UgZml4IHRoZSBp
c3N1ZSwga2luZGx5IGFkZCBmb2xsb3dpbmcgdGFnIGFzIGFwcHJvcHJpYXRlDQo+IFJlcG9ydGVk
LWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4NCj4gDQo+IE5ldyBzbWF0Y2gg
d2FybmluZ3M6DQo+IG5ldC9icmlkZ2UvYnJfbXVsdGljYXN0LmM6OTgwIF9fYnJfbXVsdGljYXN0
X2FkZF9ncm91cCgpIGVycm9yOiBwb3RlbnRpYWwgbnVsbCBkZXJlZmVyZW5jZSAnbXAnLiAgKGJy
X211bHRpY2FzdF9uZXdfZ3JvdXAgcmV0dXJucyBudWxsKQ0KPiANCj4gT2xkIHNtYXRjaCB3YXJu
aW5nczoNCj4gaW5jbHVkZS9saW51eC91NjRfc3RhdHNfc3luYy5oOjEyOCB1NjRfc3RhdHNfdXBk
YXRlX2JlZ2luKCkgd2Fybjogc3RhdGVtZW50IGhhcyBubyBlZmZlY3QgMzENCj4gDQoNClRoaXMg
cmVwb3J0IGlzIHdyb25nLCBicl9tdWx0aWNhc3RfbmV3X2dyb3VwKCkgY2Fubm90IHJldHVybiBO
VUxMLg0KSXQgYWx3YXlzIHJldHVybnMgRVJSX1BUUigpIG9mIHdoYXRldmVyIGVycm9yIGhhcHBl
bmVkIGFuZCB0aGVyZQ0KaXMgYW4gSVNfRVJSKCkgY2hlY2sgYWZ0ZXJ3YXJkcy4NCg0KVGhhbmtz
Lg0KDQo=
