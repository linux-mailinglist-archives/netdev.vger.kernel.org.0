Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D92475233
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235611AbhLOFhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:37:16 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:43391 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbhLOFhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:37:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639546635; x=1671082635;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=daqW/E6FDbFOs5qDBeicHDRBQLKQUMvEfPh1y+8lo8c=;
  b=Uno14IB5ZEcn9FgSIPy9pyVIcMp1Zyrriqmys5MYSYsfl5vERlTdVZTb
   BMiOTifZmmoqfOxAOtWlFbb4cQgQBAWGELO0uPqn6WLXs5qnXqBBKGU2o
   ieC3ZJCov1QiCYrNmVVfzcJksXVYbwiIiplszzJoOBkCCSCjCMOW8g9Zk
   ez6+YAEZeSpYdxgolkjDS7BOc6xgIwnAU5d4ewAkpAwFK6K1qHtijmo/W
   rRyOngIe3N3hRMca9olHr6b0XngJItYlOm65jOTl33cmqr27Xs2Qb3Njw
   kZHzc0HONh5x4iuivXl2VwUFT8IO7FsRdXyuIM/QSTCbD8Csaaq2f97L1
   g==;
IronPort-SDR: azrIFRwfy2Al7NI5qPBflTRHPushdsVttmSGCqHCigfy0S4Rj33Fg8lwPMR/HHs8dTL6ihycm0
 9cZ/yNMkUXkGLKt4VhMOHtf7kUz0Uqoips0Q5xL6NOqPoEvMelagXtuAADvmnwbFixIxkApVkv
 vQgtI1FxzRbQLjNEvUJq/NCzshMm6jp7qgemhwJBxqb4zmH3vU8zFUaFQlyvO4u4uHrK8SWeKs
 jUjtXioSEguV+SHLukwJw73oq7VkIaYxxmw80hjN9J0LTrXSPtc6kb38fCk3lQCwRxSo+WTA7h
 neIG03HYWFMLGqa4DwSy9Hcv
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="147273847"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Dec 2021 22:37:14 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 14 Dec 2021 22:37:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 14 Dec 2021 22:37:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anKiNboq1mVKNXw8Zgq5ngk0CzURtbCsc1ayvv7KMX+gNoWk75E/ahzndPHsY0jOZw7d9KWDFctZE9jLlVaW9daZOj9OEi322VEvBOb6UXQV1khnpd3IBeImTsa3EykgC4bRAcD/R5ZQQbD35BWu6HHtUJpcKwviosSer6s+9PWYaUlRkcwqkCGt3MR4fXYiXTd4H3aXz7WuOFJpSz0+hLQT0Xpbx0SyDb7cwayUCPMgy3Qk8kqTj4bZMTuSKBC1ssuWo/+Gjx+nSKvFScD8jdiG/ZosNZSZ8ASHeQ29Dl7tEpJZnmPoR+h2JXV7iGPsQ24tbKU8SGaWj9Cqk0TxBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daqW/E6FDbFOs5qDBeicHDRBQLKQUMvEfPh1y+8lo8c=;
 b=Px9yeaBIWNB9irdcsxi1IcrABlSwVvhHHs5spRONyzCAWaJtCvsWYo1QtICTEzyNMh4TDIoOHdJ1xAQ3Q2/Kl1r0BsAOFAqPmOCpyGA2UFL5/UHAaEfyYv1VlPfQVhSr3LLDcp33HOO4yjTtiIBuWwmzUIohiiwA2cAbzCFwpV02oZh8Qfy+baelZr9GsvsW3IuB0/JoAUjMPYkIE7gIEkbfqT39tet1//fdOWpFKh9zgVsazHYama9BMYcImoQvA/UbzRFqv4BCC+dQ4dm0J0Mc+upekIced3m5pfXD3Vn7bW4rlUvNTkkUc3bsOAxHVRqJ7PKkPJlMxdBeD6YthQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daqW/E6FDbFOs5qDBeicHDRBQLKQUMvEfPh1y+8lo8c=;
 b=cGqpqSN6r4WjlzUD5QCKFEBz/4TvDH+Owhi5E3gZbDttAu/8b8mUlZYrG3ZUpWd2wsAW4uqUfUFzhte4YjugK+nlyVUXneKRXCPKqr+M7CiPf8CJHsComW3wk7JK8pMOk4exoRXl33qW6NQszNKcrEje8sFh2i6eVKTa6XRf3WQ=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by MWHPR11MB1790.namprd11.prod.outlook.com (2603:10b6:300:10e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 05:37:02 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::bd93:cf07:ea77:3b50]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::bd93:cf07:ea77:3b50%7]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 05:37:02 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <davidm@egauge.net>, <Ajay.Kathat@microchip.com>
CC:     <adham.abozaeid@microchip.com>, <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, <kuba@kernel.org>,
        <kvalo@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>
Subject: Re: [PATCH v5 0/2] wilc1000: Add reset/enable GPIO support to SPI
 driver
Thread-Topic: [PATCH v5 0/2] wilc1000: Add reset/enable GPIO support to SPI
 driver
Thread-Index: AQHX8XXJtAFIKJMeMECxZ9XnkZfRHg==
Date:   Wed, 15 Dec 2021 05:37:02 +0000
Message-ID: <6f7ed239-a521-81f5-caaa-a24b537abcc0@microchip.com>
References: <20211215030501.3779911-1-davidm@egauge.net>
In-Reply-To: <20211215030501.3779911-1-davidm@egauge.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1772e530-552c-4b51-f591-08d9bf8cec18
x-ms-traffictypediagnostic: MWHPR11MB1790:EE_
x-microsoft-antispam-prvs: <MWHPR11MB1790116470ED273DA3CCB19687769@MWHPR11MB1790.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GZJalrHalGQEQR4WjQx8T5SKvuWuYJrdio77QziuwPH8BtxYJmTRGPrwYNPatn8KnZNNvb8etv4Eib5sOfRwqqGHJRKvMZQOXEpIKf2Sg4XgrCJCfWZ6qz81ereR6e9QEKbZRlW2HvR3aWv0c1/LtcgYqnmwUFL6aWSlByDtZarBFY/WNhEZUNFuu/bWn/S2UYsxgdj+nYsaT4Cbc7Z3KCquHKzcvWYhQRj39oO+sYyouiqj9EHaYWRau2rf8czmcQN6eesA6sGdttfMa5MscddXNCGpYT5+/xrr7Cv9t0fivv6lEDQhiknNyIlUiVJglwTSE9I/1xqo3Wg7EWj4sOquPhPDD/YYsuucfdjzggBvj2HA0hB/C9LOxx0AaO8NkunG1GFl+ZPYEr/Ss53XeEQR6zBMDw1G5pgBYMbDmFid2w6cHgUntF9cYNkf7SEcl0CkC0fpizjJxqnGo8xF4UPRULsEJ0TCEnldqPy18NVTU5ZMnJfF9LmL/eOS4SD5cv1OcI0i/h8RQSgG4ypFZn4yY/KdMBd4E+n13qQ4BEjgkUJfnZhZPZ7WlyitqZTP7C5ph84yBrxz/KR5defuQerVR4KqqiXoPuq1sNL246YMvOaEjJ9Yq71DqxDLwY09qcpihvGTBbz2fuDFbAJxpe1hcfA9FB8GX7hp7bGmlAyUvGjTIVfyhtsxvNXAsDHntOQXcwdgfDQlIymPcfBmf9Xq040E2Zd6EgIRP3qNxWK6HJrbcTqrZHixWz1gKPiec6QKkaCO7idL2TszUa+Qdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(6506007)(8676002)(53546011)(186003)(316002)(26005)(31696002)(54906003)(4326008)(8936002)(110136005)(76116006)(31686004)(6486002)(508600001)(38100700002)(4744005)(71200400001)(66556008)(64756008)(2906002)(66946007)(5660300002)(86362001)(66476007)(36756003)(66446008)(91956017)(2616005)(38070700005)(6512007)(122000001)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEdQRzhKV0RWSElGR1JDM1JOemdNODFucytYSW1wT2ZuZEhJRTNoZ2pkd1lP?=
 =?utf-8?B?NmJTQmp0dlVnZElNZlpJMUcvMkR2V3U5T3ZVMTh3clNpaWtrU28yRnl2TDlw?=
 =?utf-8?B?VUpXOTBiSDNqS2h2K29PbUM4Y2FJYWJHcjFIV2FBNkplUm93L0M3QnJqb0l2?=
 =?utf-8?B?UW41ZTRtanBUbStkUVpXRmNBcWF1cStUR2cyTThUbVIwOUVDRWlFRHlSbEl5?=
 =?utf-8?B?eDZIdmd3L3RKRkV3c0tXS1VkWTc5c3RISjJxbC9FcExJQzU1QWRLVndIVVlr?=
 =?utf-8?B?QkwrUml3MWZkRDVLYkFsNFN0Sm1HTkRibW55ODJlZE92RlJZa2d2dGovTjJt?=
 =?utf-8?B?eU1CV2NDbUFhbFRCb0dFNEZhR3AvOXdJZUZucnZ4djNtUWN0MVdrMFU0MG9K?=
 =?utf-8?B?SGVOWmU2aUZmRFRUZnNNZzdHcDZXTFRXWW1sT29CSFJyMlFpc09HcVBXUTQ3?=
 =?utf-8?B?MmtnODNQc28vZnMwc2doL0gvVXBMZW5jU016WGZ2QVptSXVVN3QrNitYREJG?=
 =?utf-8?B?akVoZGpIWGxoUDVteEJKVk5tZ0wzUFQ1QTA5M3h0Q3ZJUnBNSGpUenpGWGVD?=
 =?utf-8?B?eWQycGZPQTAwVTJCS0hNaTlVa2RySHpmMG5hVUpmdktJdDZkeWp5QzRCM2tW?=
 =?utf-8?B?VjBzTk03UGNyb0JsS2tEMVYxaHFZY0FZSmIwQ1dYczJhWTJFR01kUkZBUTJo?=
 =?utf-8?B?ai9CTkN5MmJTK2l3MUVtOTgxKzJQSDZyRmRTSXFFNkl4OVB5eFROa0xrYmNV?=
 =?utf-8?B?R1QvSmpnN2kwOUxESDZhdWxPVnFOREV3VTU1TCtlbVZvbGFkdUNxKzdUNHdL?=
 =?utf-8?B?VlZFS00yK2lDYkNMOXAvK3NINHliOXBHUG1VeGhma1NqRDF5VHlDUHpPSGpL?=
 =?utf-8?B?MW5VaG0xY2JKaTVuSXJBT3lzK0pUNWxGTWFVVlQvVkJYck8yL3NvWlFFNTRD?=
 =?utf-8?B?N3ZGeGRBQ0dwbTNHM0pXOGhyUktkTnlBcmYyNHA4Z2Q2SVBxc0FKaWF0VjhQ?=
 =?utf-8?B?TUxXNHJBelFkdW9KaUZvejFrMk11ZXZaZGNoVmNGQWtxVFRXM0VFSVdpZGUy?=
 =?utf-8?B?dEVhM1FBZzBlR3Y5ZThFWjBYanNmT082N3JFZTd5M051LzVYdGlXU3FKU3Vj?=
 =?utf-8?B?d1NuNDEveEZ0Tno1cHNiUElRYXQ5UExSVFJ5MWtLM1ErN2d3eWppVUg3ZzFI?=
 =?utf-8?B?NDRaQkoxVUpPbVJtNE9TYkVZRUtZdnR1djdITEovdWpjU1V2RytEWUwzTzNB?=
 =?utf-8?B?cEoxRGdib2hPL2FvN0RNbkUvSUNYbkNCRWduSi9JSXhtY0RaaTg0WnduSS9P?=
 =?utf-8?B?THRETy94TW5PQjdYUEgzN2RYN2FUVUVERFJmWnpBSXRPSXVzR0hWWmU5eXBz?=
 =?utf-8?B?TEtvd0hJdzhtck94NUF3bkw2RTJIR1EwbC9ndVhISjc2SmVLWjREd3g1a2Vo?=
 =?utf-8?B?MGEyTEFoSWFoQ09BT3dGU3V6WVBVZzNIeEtjcy9iTlo4blJ0L2N0NytjN1Mr?=
 =?utf-8?B?dHhsUURuSktSZlJaRCttNzZRM3c0bkpiN1UybldUZ1BOQXp4a1NwNXVNQnZK?=
 =?utf-8?B?MCtuTzE1djZmU0pSdjl0b3hsK3NBTFd3Y0lDMTllWGF2YU5FeFVPMEtBbFhr?=
 =?utf-8?B?MzhiT3k2aU9QLzNWUzY5cCt0dG9JY0JoNSs3a3pZM2dqMThrSE9UcGVqZHgw?=
 =?utf-8?B?QU5zU3Z0MzFZdHhqc2ppOGVPUWFBbWdsWGpaVDVLNTFYS2ZZUlJFMWlWQWd0?=
 =?utf-8?B?Yk11TDFJVVc2VkUwUTk3ckg2UysrdTR4RWZwTDdjT3kvcWl2OTNJTVo5S2tm?=
 =?utf-8?B?M2MvR0ZUeExSK2pPNUlzVUhHc2FxK1JDekRXaVUzTEduT1hRNXVxWk5GbEdM?=
 =?utf-8?B?ajZNRDJiTnhjRi9MdlpsMzlsYWxLU3JuTjFwcVBPTVNkVXdQbjlOaUJXQlQ0?=
 =?utf-8?B?a2k3RnJLUSt6ZU9oR0pJOGFoMUgxcGRHS3ZuRUc4NU53ZmZ3YkF2ZHgvRVJr?=
 =?utf-8?B?RUFjOThVanhlbCs5emhQTDZ1b045YjZENjZiRHgzMXBGd0szbEI1Tkxacmhk?=
 =?utf-8?B?MWk5Tmk4YkZkTTNEVlM1QytiaUs3OG1zajNzRk1KVU5ZUnBxK0ZPaDkyRkJW?=
 =?utf-8?B?UXJZdzdrQ2QzazJzK0Y5eFMycmZFVUt3ZmZuSXN6NnZIeFZLMWNHcFhnZWw5?=
 =?utf-8?B?ZVlMaGlKMEsrb3lYS1dpWU1Qcy9sVkxSY2poMndZZEdoYTdXTHdjbGhzRGFL?=
 =?utf-8?B?UTFDd1d5UTZpTHh4RnhXazRSRCt3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B3E01B665FB304FAB6955542505E859@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1772e530-552c-4b51-f591-08d9bf8cec18
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 05:37:02.5358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2iXxFW6hJzYeoTNSChaSP7xt21826aZSLGfe833IIKyAdkQxe1wdVOLKLEQk3fQLLBYnTBPDIvsjALB34Plka/1wQhix1rRzECtNYnddZ1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1790
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTUuMTIuMjAyMSAwNTowNSwgRGF2aWQgTW9zYmVyZ2VyLVRhbmcgd3JvdGU6DQo+IEVYVEVS
TkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3Mg
eW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gVGhlIG9ubHkgY2hhbmdlIGluIHRo
aXMgdmVyc2lvbiBpcyB0byBmaXggYSBkdF9iaW5kaW5nX2NoZWNrIGVycm9yIGJ5DQo+IGluY2x1
ZGluZyA8ZHQtYmluZGluZ3MvZ3Bpby9ncGlvLmg+IGluIG1pY3JvY2hpcCx3aWxjMTAwMC55YW1s
Lg0KDQpGb3IgZnV0dXJlIHBhdGNoZXMsIGhlcmUgeW91IHNob3VsZCBoYXZlIHRoZSBmdWxsIGNo
YW5nZWxvZyBiL3cgdmVyc2lvbiwNCnNvbWV0aGluZyBsaWtlOg0KDQpDaGFuZ2VzIGluIHY1Og0K
LSB0aGlzDQotIHRoYXQNCi0gZXRjDQoNCkNoYW5nZXMgaW4gdjQ6DQotIHRoaXMsIHRoYXQNCg0K
Li4uDQoNCkNoYW5nZXMgaW4gdjI6DQotIHRoaXMsIHRoYXQNCg0KPiANCj4gRGF2aWQgTW9zYmVy
Z2VyLVRhbmcgKDIpOg0KPiAgIHdpbGMxMDAwOiBBZGQgcmVzZXQvZW5hYmxlIEdQSU8gc3VwcG9y
dCB0byBTUEkgZHJpdmVyDQo+ICAgd2lsYzEwMDA6IERvY3VtZW50IGVuYWJsZS1ncGlvcyBhbmQg
cmVzZXQtZ3Bpb3MgcHJvcGVydGllcw0KPiANCj4gIC4uLi9uZXQvd2lyZWxlc3MvbWljcm9jaGlw
LHdpbGMxMDAwLnlhbWwgICAgICB8IDE5ICsrKysrKw0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3Mv
bWljcm9jaGlwL3dpbGMxMDAwL3NwaS5jIHwgNTggKysrKysrKysrKysrKysrKysrLQ0KPiAgLi4u
L25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvd2xhbi5jICAgIHwgIDIgKy0NCj4gIDMg
ZmlsZXMgY2hhbmdlZCwgNzUgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IC0t
DQo+IDIuMjUuMQ0KPiANCg0K
