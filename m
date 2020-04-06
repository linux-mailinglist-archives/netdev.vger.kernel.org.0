Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8631819F32B
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 12:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgDFKB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 06:01:58 -0400
Received: from mail-eopbgr1400110.outbound.protection.outlook.com ([40.107.140.110]:6357
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726784AbgDFKB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 06:01:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKclT8SSW6xUw9or9LUyOec48tuwvzOnzubgTBKeiREX2o3rO+vzh3rvK4uVnDmXfzadUQYsW+KeV1zE1kYjwYKWRhxxUoTDJAfhu88LtKF1nhUUFGPweUpjEjGr+LfU5LieDwL6Vjbu27xpej9FHBTf3iWrv+Yki85gmv23pWkjAItt2nU/wRZbEhcWUcE3t9AU2o552sRYIcIawrjcu/Bm5vdeZrki2YLycNobM4jmh2eO+dMKGR89Sm99BMEMQE7Vvk9NRS9t6dxnHRG/mpjei/wpyiLnocV/xiV3J02tDFlbhqA0D8V+BX+cMrsZJUDlzwpbwMVPLAE2sqpXsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RuxuSojrTZ5mrYPsKKNEW1NuQt6W3hfYbPkPqQ6lCdM=;
 b=FMWlQn3fc1/5yiM9KM4PJ5h6lPSLGV2A0qSNtw0389Gdd/appHnB+W1nECv1zBptFWioYBuLsf/sK6XRXKCen9yQbizsp4qF5vVNCPXHzwQUSiDPSsEfhGAbpfvQmJA+xwwvfXlkSLzPbNJ6NJkLJDNeY8V/shJKqpk9S0sLcXykR80HFsxxvW1gQOs4dqqknlzB9iNyrUS8ti56qPZHQHNoLhrW1gECmYrB3Uyi35kMUTmYXFoTxSazavVAHrfPqfo8RcZ6id+tIMzXSEo9p+8sJQJo6FKoK4Z5n6m20al3jq/G10siFsLFFdcFFquIS29lHXvr/+52AeIM+biqJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RuxuSojrTZ5mrYPsKKNEW1NuQt6W3hfYbPkPqQ6lCdM=;
 b=KxaaQIbtQw9284Sw/VARVf/MUo4Irfa0/n3HzO6qYBgy7WMbY/ZSAY92ob7ew7ZjSPCHh+U9Rk4CClFpSz4PsZw4vzxHyxbPFNDpx27vnvQX4NWllM2iT0WQfCX6e5sGWYPTEzZkPv8YqCadHrHdVuhmuQeAVXkq/AS4bODcnRs=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB3856.jpnprd01.prod.outlook.com (20.178.140.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.17; Mon, 6 Apr 2020 10:01:54 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::ed7f:1268:55a9:fc06]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::ed7f:1268:55a9:fc06%4]) with mapi id 15.20.2878.017; Mon, 6 Apr 2020
 10:01:54 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: How to fix WARN from drivers/base/dd.c in next-20200401 if
 CONFIG_MODULES=y?
Thread-Topic: How to fix WARN from drivers/base/dd.c in next-20200401 if
 CONFIG_MODULES=y?
Thread-Index: AdYI1eHeE+d8Du49RZSXfyqelir+RgAPcQ+AACaCwgAAIpzUAABtUcqgAAMnEZA=
Date:   Mon, 6 Apr 2020 10:01:54 +0000
Message-ID: <TYAPR01MB45443FA43152C0091D6EBF9AD8C20@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <TYAPR01MB45443DF63B9EF29054F7C41FD8C60@TYAPR01MB4544.jpnprd01.prod.outlook.com>
 <CALAqxLWopjCkiM=NR868DTcX-apPc1MPnONJMppm1jzCboAheg@mail.gmail.com>
 <CAMuHMdVtHhq9Nef1pBtBUKfRU2L-KgDffiOv28VqhrewR_j1Dw@mail.gmail.com>
 <CALAqxLX2AEFJxqXXXKPs8SU7Su2FqNjwbSt5BxwmQJqYQuST9A@mail.gmail.com>
 <TYAPR01MB45447DFE9E81D77CA867DEC8D8C20@TYAPR01MB4544.jpnprd01.prod.outlook.com>
In-Reply-To: <TYAPR01MB45447DFE9E81D77CA867DEC8D8C20@TYAPR01MB4544.jpnprd01.prod.outlook.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [124.210.22.195]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 04893ba5-4c5b-4ce4-c177-08d7da1188e1
x-ms-traffictypediagnostic: TYAPR01MB3856:
x-microsoft-antispam-prvs: <TYAPR01MB38563D264B942DA6C6B27FC0D8C20@TYAPR01MB3856.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0365C0E14B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(2940100002)(54906003)(2906002)(8936002)(7696005)(5660300002)(55016002)(66556008)(66476007)(64756008)(110136005)(66446008)(9686003)(52536014)(86362001)(33656002)(76116006)(4744005)(478600001)(66946007)(71200400001)(8676002)(81166006)(81156014)(6506007)(4326008)(316002)(186003)(55236004)(26005);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mlai7qN/Z0vAZR072P+hQbZnvEBxwrx/SNyOPurdKT6AR0CJuzhY4USEYzNITl0FEECdWNmNdz28Q46QCh17JSOqSKW5yzvXN9rOpMk1aWdgCGoavRvwKDDLAT/QhAFyoFhvfxhL/6rOvD3zhDKQs5dJ/LF81lB92WqxJL/MSh2gxoleBxyoyjXq0u+42+eWmhA3PWNzaumYTsr+hitC71evIiZMtZIU4ZSBWOXWrUbwGJAlF2bwfSad8k0DEQfFqco4o4WYXakk+AVJT5ZBK71mtHWnBjup50oZuEZPw6R8x3Utb9Cs4Wgggvcf/JCLdVFQ6/pwrRllhv5Naoq7nfZ1ENb1XG6z00jH6dEJADSDLSFoEpyNzUc3b0XzF3UzZUQDg7pfKRKgHKlvVfIquQJQkkFwMAbxhiCGvOs5rk9XCLupR+tJQmvSwfEkE1w1
x-ms-exchange-antispam-messagedata: syDBZF21Si1AS472cmz891iQdvDcJivLnEl0JTJvDbErvxiTkSLbApAYq6fG2e3nCDRb9lSOGfwXgmBh+8YeGodtaeiudl3LTxjMq8IaECOriiI5gxd3KnUDemeqNZmxeQUcePY+bvVAKdHw/vSfZA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04893ba5-4c5b-4ce4-c177-08d7da1188e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2020 10:01:54.0820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lSTa1cBryjOlJMrAhIT/X8bCGujjGH6hKb50T5ntCI5h8A62/PM93miU9XlonwhaCcr9tp4cZ+AXM/fXQO04IADZvHolxsOrec9e5b6UWvFLLPvaBkYHJQDEvB8StXXt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgYWdhaW4sDQoNCjxzbmlwPg0KPiBJJ20gZ3Vlc3Npbmcgd2Ugc2hvdWxkIGFkZCB0aGUgZm9s
bG93aW5nIGZsdXNoX3dvcmsgZm9yIGRlZmVycmVkX3Byb2JlX3RpbWVvdXRfd29yaygpLg0KPiAj
IFNvcnJ5LCBJIGRpZG4ndCB0ZXN0IHRoaXMgZm9yIHNvbWUgcmVhc29ucyB5ZXQgdGhvdWdoLi4u
DQo+IA0KPiArICAgICAgIC8qIHdhaXQgZm9yIHRoZSBkZWZlcnJlZCBwcm9iZSB0aW1lb3V0IHdv
cmtxdWV1ZSB0byBmaW5pc2ggKi8NCj4gKyAgICAgICBpZiAoZHJpdmVyX2RlZmVycmVkX3Byb2Jl
X3RpbWVvdXQgPiAwKQ0KPiArICAgICAgICAgICAgICAgZmx1c2hfd29yaygmZGVmZXJyZWRfcHJv
YmVfdGltZW91dF93b3JrKTsNCg0KSSdtIHNvcnJ5LiBUaGlzIGNvZGUgY2F1c2VkIGJ1aWxkIGVy
cm9yIGJlY2F1c2UgdGhlIGRlZmVycmVkX3Byb2JlX3RpbWVvdXRfd29yaw0KaXMgc3RydWN0IGRl
bGF5ZWRfd29yay4gQWxzbywgSSBkb24ndCB0aGluayB1c2luZyBmbHVzaF9kZWxheWVkX3dvcmso
KSBpcw0KbXkgZXhwZWN0YXRpb24gKHdhaXQgdW50aWwgdGhlIHRpbWVvdXQgb2YgZGVmZXJyZWQp
Li4uDQoNCkJlc3QgcmVnYXJkcywNCllvc2hpaGlybyBTaGltb2RhDQoNCg==
