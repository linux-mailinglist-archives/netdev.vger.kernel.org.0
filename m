Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E29E2FA854
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436705AbhARSHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:07:00 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15769 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407462AbhARSEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 13:04:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6005cd8f0000>; Mon, 18 Jan 2021 10:03:59 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 18:03:58 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 18 Jan 2021 18:03:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDdJ0ipda071ldt3RsaEBVN1pbie8bajELkHjgg5T57AG69vs3ClOP6HZTLTJkvs0HETDzZr8Uhyt2Ad8Lk5a7jE2gL4wHeevPdwjBQltGtK0us7ZKsJvm3slxmSj3kqNjiXKOLI7ynzQKJ58pUypUj2MBk67g1Is/FRg7M0Hk0yEuD8he4cF6jvaUW+AxAHkOfz/xTB8Wv/Ti3TBoq2Lh2urDTyLGDUJO9JCzJkxPNOJ/jDbzt+jFGINaU/K8QrOpYKPrUF8URYYfhBBSbOP6xjvF7/I9nYUh/Wd1d/4ly5GclrBo0AS5u5ey0X6f048Fz4vRzEu4/3N4oN1Gd0LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/iOP/l4GpqXY6nDAMxJ++R+44+aQ03UyIOR0+7AABk=;
 b=nU0Y5e5R7YdlN4EQfwFVlxkyHYUoHUdWGfe4OVDuGMNnPfN1nVl88wGs+ZdVYK2jT/zIdDS09O+dTjpR8iCUoEBL722Zzykznx4r9z1RLNir/pEC21qFruQemlozpnSgPgx5oUL51ORH9QKlISZG/dAFSbmMekIuwVpo9Tg5vAPqwKV+MralXlFTPzEV6zK7nzhNgNqHJMX57XadKoDRqqirqBtVetOJOrw7a0tb7UbZnwuqikZHzNIwTr803wpG/vvh5CWWRJ7TrqciNbJ2zjbBTBNrFGOqyec6RUG9GUj8ZseOxBQUzuaNmhTM/0VpszshPqJkLxYQpX4cpddcGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3730.namprd12.prod.outlook.com (2603:10b6:a03:1ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Mon, 18 Jan
 2021 18:03:57 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%5]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 18:03:57 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-next v3 6/6] vdpa_sim_net: Add support for user
 supported devices
Thread-Topic: [PATCH linux-next v3 6/6] vdpa_sim_net: Add support for user
 supported devices
Thread-Index: AQHW404ZeuD1Nrf6EkKQQnhYNrY/9qoY6uQAgAAB4oCAAAVhgIAAAsjwgAAQXACAAoNJoIALCUSAgAAyM0CAAXa1gIAFhtvw
Date:   Mon, 18 Jan 2021 18:03:57 +0000
Message-ID: <BY5PR12MB432239B28EC63D80791E1459DCA40@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210105103203.82508-1-parav@nvidia.com>
 <20210105103203.82508-7-parav@nvidia.com>
 <20210105064707-mutt-send-email-mst@kernel.org>
 <BY5PR12MB4322E5E7CA71CB2EE0577706DCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210105071101-mutt-send-email-mst@kernel.org>
 <BY5PR12MB432235169D805760EC0CF7CEDCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210105082243-mutt-send-email-mst@kernel.org>
 <BY5PR12MB4322EC8D0AD648063C607E17DCAF0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <66dc44ac-52da-eaba-3f5e-69254e42d75b@redhat.com>
 <BY5PR12MB43225D83EA46004E3AF50D3ADCA80@BY5PR12MB4322.namprd12.prod.outlook.com>
 <01213588-d4af-820a-bcf8-c28b8a80c346@redhat.com>
In-Reply-To: <01213588-d4af-820a-bcf8-c28b8a80c346@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd1111e6-6e3b-4ba8-7997-08d8bbdb6cf9
x-ms-traffictypediagnostic: BY5PR12MB3730:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB3730B90A9B798EF5EAF5F4D4DCA40@BY5PR12MB3730.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M1zPhIyb67s4o5vp0BwJfMZWuPOeCQ7PSyagXOXEdEkyqpU4FF/TfeUXXWOwvkiUDSOJO8io6Hf2Jdpq/vUjY190rEtTJysIUl7nk+4wgL1SNpGcAW593KhPzJ3xDFejKHtar2kvRX02vbSzbDlZnKyiYdbp3RzhaYPomgD6y/oNccxOKzSS5RWkqqYSH1YiPjuQgv02tG2RIowWcz7gyeC49jvAZS+Ka8oKRNfXwhTaWe9PnTdHAxFzn8Z1Cxq0FiNaDkmVyZi0wGiDGH3ENY9tZh1y626Al0m/XDi78n8ZSFiYGafumIpXybS37ef1XXrfYiOy+bVguwXEtKOgw5ITyfB2qLY+Xmcn2uo3LL3IF6G8IjHPaqPXl7BpmIi3NVf0+MksrNbIk9f/pkpMgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(478600001)(66556008)(71200400001)(6506007)(66946007)(64756008)(33656002)(4744005)(66446008)(5660300002)(76116006)(66476007)(86362001)(26005)(52536014)(186003)(4326008)(7696005)(8676002)(55016002)(9686003)(110136005)(54906003)(2906002)(316002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?d2pjcXJIOGZIek1ycytBbWZHTEdFWkZJalJ6Y2p0Tm1CRFFLejUvQktDRG9P?=
 =?utf-8?B?VFZGSVBqSzVPWEp6bEFRWktWMzN2alFPZEFkUXlWclZ4TkxwNU83MmVDbnlv?=
 =?utf-8?B?TStNWFhjVWR4SGhpUC9kMm51SUFKVFQycUhDMjBLazRJU2dzV2ZVQ0NFTTJX?=
 =?utf-8?B?b3IzZXNqejNFRVYvNm9Ya3I5Wk01Rlh3QVdTZHhBVWpEQkRINmRiWEwvSXl0?=
 =?utf-8?B?blNuaUw3eXhEWkVDdVdFVm9oc1ZHYUFDRGZNRkUxcGc3UDIrdityaVMrSnFj?=
 =?utf-8?B?ZERJRkZLMTlaNVRFeDJzVUkwR2tLUURUYW1rV3ZDRFR3MkJmd3JQMWJuRTlh?=
 =?utf-8?B?UkhQNm9lTUJhRTRZaktNcU9jdkFHU2szNkVubUVYNWFOMzBzbXUvUXlvWktH?=
 =?utf-8?B?aU1jMC8wRGJFajlFR1RyTDJsZ3lWQU9tMWRxYWtpbWh0L1JDcnJ4VjlSb09B?=
 =?utf-8?B?RDNlNDZxTHBjdGM5U1BkdDkrTEUwcG1NKytVMGpIVTMwRk5rSTZWV1VlSXNF?=
 =?utf-8?B?ZFl2QTdIdFYrUlM4bUxNdzRIcmRDdS8zSWRkTExZV2pEbUh1a2UrKy9JSExm?=
 =?utf-8?B?cHphVUNacFh2YnpCc2pRYVQ4UWRtTU5QWEFOTmVkcDg2eXEzTVAycnpGaXdm?=
 =?utf-8?B?aTRjK3dYM0tpRHYvUC9WU2RwVG1yL2lJVHRRRmRGaTRsakxZdThHblBsdFBw?=
 =?utf-8?B?WXFFa21xNVhGU2dGWUNObzJsSitTUzNyejJZd3lWaWlqTlM1V0NIUk1wVWhl?=
 =?utf-8?B?bmhNZ2hBdzM5VXNsRC9MZllnTjNWSFVYS0lXMXFlaEJZcUxBSGJ1QThCUnFC?=
 =?utf-8?B?SFg2czMyd2ZJdGRlWnhQNGEzZWVQSGNqZ3M3OUt5NzZIZDBPcEdFN2hOaFps?=
 =?utf-8?B?bjhseWJZSlc5T2JPMmxGRTVTazIyNlE4RExwQmQ5Q2tKUms4UXlkZVhRalEr?=
 =?utf-8?B?SnRrUHg4amFDMlIzRzBPdlpFeVdPUHZiVW10aUtBR2U2WEN0VGlyUTRoalVz?=
 =?utf-8?B?b2FseUNZUGNXMm83UXBrR1hRSXRQWEZaQkNEeUw1b2hVd3J1LzQyUHJnL2F5?=
 =?utf-8?B?UmpYT3pZcGxlNC8wWEdtZXUrN1BZaXFWUUE4MWdvQmxVdW4wNk9QZUFTdk5S?=
 =?utf-8?B?amxra2gybHBSbXQ2MGZ1OWlPRzVRcXpQb2UyeTYvNVo0ZnlhU0dvcVhMYVlJ?=
 =?utf-8?B?SWZQY0V0ZWVhS0pGSmtSWlZkZlEyWU83bGNrQk0wdUVPa1JIYzZabzRnRm5z?=
 =?utf-8?B?UkxYWDAxRXR5MERZaDFTZ3RGMGhDRjhydEI4TTZBenJnTm1YZTkydUM2bncw?=
 =?utf-8?Q?UQKv1LmwlgjEs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd1111e6-6e3b-4ba8-7997-08d8bbdb6cf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2021 18:03:57.2141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0mNmDGjsjnu2YuwJTA/RzppB2zC7zMt0zIISf1H3jMpxmmNm94WJEfIpPBIGKId9UNYviKkhz6N6TXHItjx9/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3730
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610993039; bh=g/iOP/l4GpqXY6nDAMxJ++R+44+aQ03UyIOR0+7AABk=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=rYsfiMdRZSSt+zXKwo9cY4WviYekJyUeuL+U5KvblN+XkW5S/ZNB+dzvGIUBzN7Yu
         w7eLsDGJTK8bUMzASv+MTsIXG75CpSRuLEeJSJnREp5zFefrnvb43HsQlWLbxlJuQ8
         hgYcYtw1V5KWLtkAYSLJ5TrCNXVsp2oe40crSOswrasHcuHx4EEm5kIa7Fn2TBGJHT
         FB9o3bGFk2kVgvqEelPfCflHlgOxqNBinnA4jeBJlMldgR7LNaYTwZXkuzjkUOT5DS
         D6LspVs41YH9pqppAk7dHsiqGHa4c0jneuy8VAUE6KJ2YL02xRGtXbPnRmGkA8iP3u
         Zd25gt9J21ClA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWljaGFlbCwgSmFzb24sDQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0
LmNvbT4NCj4gU2VudDogRnJpZGF5LCBKYW51YXJ5IDE1LCAyMDIxIDExOjA5IEFNDQo+IA0KPiAN
Cj4gVGhhbmtzIGZvciB0aGUgY2xhcmlmaWNhdGlvbi4gSSB0aGluayB3ZSdkIGJldHRlciBkb2N1
bWVudCB0aGUgYWJvdmUgaW4gdGhlDQo+IHBhdGNoIHRoYXQgaW50cm9kdWNlcyB0aGUgbWFjIHNl
dHRpbmcgZnJvbSBtYW5hZ2VtZW50IEFQSS4NCg0KQ2FuIHdlIHByb2NlZWQgd2l0aCB0aGlzIHBh
dGNoc2V0Pw0KV2UgbGlrZSB0byBwcm9ncmVzcyBuZXh0IHRvIGlwcm91dGUyL3ZkcGEsIG1hYyBh
bmQgb3RoZXIgZHJpdmVycyBwb3N0IHRoaXMgc2VyaWVzIGluIHRoaXMga2VybmVsIHZlcnNpb24u
DQo=
