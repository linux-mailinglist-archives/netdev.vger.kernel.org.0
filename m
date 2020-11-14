Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270982B2FEF
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgKNS7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 13:59:44 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23904 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgKNS7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 13:59:44 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AEIwGTw011516;
        Sat, 14 Nov 2020 10:59:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=8yjYgWSeuMpqkWO0mnUhbMSTfNA5f/9gSLRH7UcqwjM=;
 b=Y9NqViavbQBJtJw1nN42T+qzvaOPTMyrj5WFyP0avLKiVc4sK3vh0Juk9XRoNs4vmjLp
 EZ/OW7I5OyOd5utrhrwJ/lS2TFHPUhxTPbEf+zP1EXE5GzGNB2uc/kbXYUBdUBHZRaGt
 nRL8sXy0U1hBdrKsd4JeaclA8dxru/zjwDtnljjx53PrUamMdX3by6rEKUA8HavqSQEE
 9NlsdQcp8obU4wBn4//W2TfGTQSC7vtVEFxax9byj0AH7pLwz9O5vJz+vQ0skE0AQBTQ
 J/8OvYhiJCvMkD9WDMweypeAXQtM3uAXrMYYoXimKgbwKdRgWQgedPHu7tNmsYFg552F Bw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34tfms8mbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 10:59:39 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 10:59:37 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 14 Nov 2020 10:59:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kg/XjU7lzAZB3YL5J/tLu5quyT+0ZvPpgylj1fDnUwXgH2jhkRQtnJY93gmnQUv7uw/rQC6l0HrJQACMc0B5YtRAiW6YSirqTTwxAF8FP++TJ72SFsQ12AJjm4Sq2DLRm4TOFR8LJUbeG3mqkZeykGvq7OdGDMEaE2L4cx3mGinXfPZ7jqJ8UzuseEaAsSW80Fj4bJBAyjq37nZJpLcsFAJc3BNayLshTTtKC90INTudYFcj/REzA4UZ7Y+hhdIRQXdKVYYz9pIogqkEpOuvuJHegtGy7Vl8K/KEHW4XICfNJJzm8q4aCqgJbH62CZFD6+mWvYjQD54nHb1vTonc1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yjYgWSeuMpqkWO0mnUhbMSTfNA5f/9gSLRH7UcqwjM=;
 b=fsaSIe+3My/loKocqfmnUuHtmm1QT+u/UmmDJZCtm6Cvh88VoBoAi+ikVz3tc5a1YcK9QP9etnXvDexVDUYZPyHkdkMnpQHZkilgiNi0HnY6O3HaJnBtquRAhVrfOYzOFSr4JentNMdYSn9lGFL5NyBPQt4k3d4WKEHpesDy7ZZAFZyLaRvbkap2Q/Ox6d6F6LaZhAavp4NSzpfj0deUUC/IwrBnAYsvOqmmutuPj0Ku1Cxk2xEZBdf40WxdkFuNUpW0hTc95Ebl2TOWJsrA1gSyj27Nd6yJ+Gr9kEIfvoIbrfkYJeav+v2vXkcIPipPaFhWVl80Og2oDx3NCkACcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yjYgWSeuMpqkWO0mnUhbMSTfNA5f/9gSLRH7UcqwjM=;
 b=NwAV6CVbQJQFV9PuJQbkR1DlnLZ0uRr+g//RfzgC6wqB0gNkrUucFbnheKuUvXcQqJRJzX6a6BePKAZkTANfXtES3oPs/sZSuhehMXP3b2cImfcXm02x5H12g+uzUAk5TxQwz7WkuVolcP+bu1zNlm0FZTCnH5+PRMChWv9ksos=
Received: from DM6PR18MB3212.namprd18.prod.outlook.com (2603:10b6:5:14a::15)
 by DM6PR18MB2442.namprd18.prod.outlook.com (2603:10b6:5:181::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Sat, 14 Nov
 2020 18:59:36 +0000
Received: from DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef]) by DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef%7]) with mapi id 15.20.3541.025; Sat, 14 Nov 2020
 18:59:36 +0000
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "Linu Cherian" <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: RE: [EXT] Re: [PATCH v3 net-next 01/13] octeontx2-af: Modify default
 KEX profile to extract TX packet fields
Thread-Topic: [EXT] Re: [PATCH v3 net-next 01/13] octeontx2-af: Modify default
 KEX profile to extract TX packet fields
Thread-Index: AQHWuS4KAKnfPF/ehUWoQjLlxRa0V6nH/dDg
Date:   Sat, 14 Nov 2020 18:59:36 +0000
Message-ID: <DM6PR18MB3212A41F2234A05C36F10DACA2E50@DM6PR18MB3212.namprd18.prod.outlook.com>
References: <20201111071404.29620-1-naveenm@marvell.com>
         <20201111071404.29620-2-naveenm@marvell.com>
 <87ee2a8c0353feebdca50d2ea999ddd965d000fd.camel@kernel.org>
In-Reply-To: <87ee2a8c0353feebdca50d2ea999ddd965d000fd.camel@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [49.206.46.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9241b867-1986-4162-e649-08d888cf6e57
x-ms-traffictypediagnostic: DM6PR18MB2442:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB244266C68A4747450B30D29AA2E50@DM6PR18MB2442.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hHvynP58Kb9RFVeFzU0novTxbVNX9nN7a3fwahXzNpZzVV9JMtVz0cRpkyR+Yft8KsXNd9kwjPqUovRpmG6Z6V8yq3XsM58dtYs6CAEdDvdhxI+XMXkq+15e+5Xjg4xJNtq5KPU8z2QYblb7W7w/sWpUunTxsI2m8OyTBdgDA+hCnq2H86zEDi4DAabVLZUzakR5KhVnSNeK2kdtxYfcXCfTn5+om3Zy4kfRGhIuSdenfm8Q+NXZPcUKzNFl3MpGX86FDz6UZF87tuQSAsAaRK5esjHdyz/hYQPqVhpnMjauk00yYeqxMnczzOFkNc/E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3212.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(366004)(39850400004)(376002)(55236004)(53546011)(186003)(55016002)(9686003)(6506007)(26005)(4001150100001)(33656002)(107886003)(316002)(5660300002)(8676002)(71200400001)(54906003)(110136005)(66446008)(83380400001)(8936002)(86362001)(478600001)(66556008)(2906002)(64756008)(66946007)(52536014)(66476007)(7696005)(76116006)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 8BFlSVl2S2h587U0mWqqjvIia8FZYA8IiIUmzUMs9VYwxfc4jH9GDJYncSDbX6dl8F9wN/xujYhMySH6izrtyIV4EzmNHSbXGxhQQs+EGeXf10twY7QCBjGc7nAsLlMB8dmSLQglfcQZds7bJM7DWFWpiFePcF8gEmLSMsj1LfINC1FFCHKeA+asglqqNrCuL+6BBR5t9x1nJFJbuDXjQiIJmhlv7CAKFrjtyMGs/5V5XNdqWn9NoSU78SPjT9CNMX4Ua2+Tww/4AjLjTrm2PuLCoDWvYF7d0DjSI6l1AvPB3LY+IxSAC9P+JpsDJilbG0T8npq03AvOYnWuUXaMF30FP56BGEueAPBf1PQkqfRdi2rPBP+fWvUJDWjLCeyE//x7xjpJcqYrtphJStaJTO3VjmX63nJx9e6QAhcLOR8kIJXXOD2Qnu2jjT1lO6I6ece1r600blnNtvlU+4QawVjVw+56lOf0/grYCfeJugy5e82tcgeQXtpy0NS/L9yCSwQ9NbIghG/aeWk7jVuMKUAqpsEVyFCUNepkb+z+ARmEJickZe8KqNU7VqxED4hX5sIatgSZm+5drwMf6ocd7SsI2vGUFBkz+okJORGKk/8EPIlxNcPNABN2Nv+ZMerS5Xd/7a8pu5LJeFjuoCqV7A==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3212.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9241b867-1986-4162-e649-08d888cf6e57
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2020 18:59:36.1968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2CDZJuzt69LG8kvHThj+kAzs/SHJCxb1eu21x9hDoOSLoIk4WPnvqc1suyBPEktf7mKRhceKV15ZWV1Hj9V7lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2442
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-14_07:2020-11-13,2020-11-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2FlZWQsDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCj4gRnJvbTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkQGtlcm5lbC5vcmc+DQo+IFNl
bnQ6IEZyaWRheSwgTm92ZW1iZXIgMTMsIDIwMjAgMToyNyBBTQ0KPiBUbzogTmF2ZWVuIE1hbWlu
ZGxhcGFsbGkgPG5hdmVlbm1AbWFydmVsbC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0K
PiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IENjOiBrdWJhQGtlcm5lbC5vcmc7IGRh
dmVtQGRhdmVtbG9mdC5uZXQ7IFN1bmlsIEtvdnZ1cmkgR291dGhhbQ0KPiA8c2dvdXRoYW1AbWFy
dmVsbC5jb20+OyBMaW51IENoZXJpYW4gPGxjaGVyaWFuQG1hcnZlbGwuY29tPjsNCj4gR2VldGhh
c293amFueWEgQWt1bGEgPGdha3VsYUBtYXJ2ZWxsLmNvbT47IEplcmluIEphY29iIEtvbGxhbnVr
a2FyYW4NCj4gPGplcmluakBtYXJ2ZWxsLmNvbT47IFN1YmJhcmF5YSBTdW5kZWVwIEJoYXR0YSA8
c2JoYXR0YUBtYXJ2ZWxsLmNvbT47DQo+IEhhcmlwcmFzYWQgS2VsYW0gPGhrZWxhbUBtYXJ2ZWxs
LmNvbT4NCj4gU3ViamVjdDogW0VYVF0gUmU6IFtQQVRDSCB2MyBuZXQtbmV4dCAwMS8xM10gb2N0
ZW9udHgyLWFmOiBNb2RpZnkgZGVmYXVsdCBLRVgNCj4gcHJvZmlsZSB0byBleHRyYWN0IFRYIHBh
Y2tldCBmaWVsZHMNCj4gDQo+IEV4dGVybmFsIEVtYWlsDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+
IE9uIFdlZCwgMjAyMC0xMS0xMSBhdCAxMjo0MyArMDUzMCwgTmF2ZWVuIE1hbWluZGxhcGFsbGkg
d3JvdGU6DQo+ID4gRnJvbTogU3RhbmlzbGF3IEthcmRhY2ggPHNrYXJkYWNoQG1hcnZlbGwuY29t
Pg0KPiA+DQo+ID4gVGhlIGN1cnJlbnQgZGVmYXVsdCBLZXkgRXh0cmFjdGlvbihLRVgpIHByb2Zp
bGUgY2FuIG9ubHkgdXNlIFJYIHBhY2tldA0KPiA+IGZpZWxkcyB3aGlsZSBnZW5lcmF0aW5nIHRo
ZSBNQ0FNIHNlYXJjaCBrZXkuIFRoZSBwcm9maWxlIGNhbid0IGJlIHVzZWQNCj4gPiBmb3IgbWF0
Y2hpbmcgVFggcGFja2V0IGZpZWxkcy4gVGhpcyBwYXRjaCBtb2RpZmllcyB0aGUgZGVmYXVsdCBL
RVgNCj4gPiBwcm9maWxlIHRvIGFkZCBzdXBwb3J0IGZvciBleHRyYWN0aW5nIFRYIHBhY2tldCBm
aWVsZHMgaW50byBNQ0FNDQo+ID4gc2VhcmNoIGtleS4gRW5hYmxlZCBUeCBLUFUgcGFja2V0IHBh
cnNpbmcgYnkgY29uZmlndXJpbmcgVFggUEtJTkQgaW4NCj4gPiB0eF9wYXJzZV9jZmcuDQo+ID4N
Cj4gPiBBbHNvIG1vZGlmaWVkIHRoZSBkZWZhdWx0IEtFWCBwcm9maWxlIHRvIGV4dHJhY3QgVkxB
TiBUQ0kgZnJvbSB0aGUNCj4gPiBMQl9QVFIgYW5kIGV4YWN0IGJ5dGUgb2Zmc2V0IG9mIFZMQU4g
aGVhZGVyLiBUaGUgTlBDIEtQVSBwYXJzZXIgd2FzDQo+ID4gbW9kaWZpZWQgdG8gcG9pbnQgTEJf
UFRSIHRvIHRoZSBzdGFydGluZyBieXRlIG9mZnNldCBvZiBWTEFOIGhlYWRlcg0KPiA+IHdoaWNo
IHBvaW50cyB0byB0aGUgdHBpZCBmaWVsZC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFN0YW5p
c2xhdyBLYXJkYWNoIDxza2FyZGFjaEBtYXJ2ZWxsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBT
dW5pbCBHb3V0aGFtIDxzZ291dGhhbUBtYXJ2ZWxsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBO
YXZlZW4gTWFtaW5kbGFwYWxsaSA8bmF2ZWVubUBtYXJ2ZWxsLmNvbT4NCj4gPg0KPiANCj4gUmV2
aWV3ZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbnZpZGlhLmNvbT4NCj4gDQoNCg==
