Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FD7221B7E
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 06:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgGPEm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 00:42:28 -0400
Received: from mail-eopbgr1410107.outbound.protection.outlook.com ([40.107.141.107]:19595
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725844AbgGPEm0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 00:42:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIjgIw/++zk6fGfjfHjnVdbXDgM+cmAh4vG/wTAApGZLquU+42lwKEdgdRsrqqhjCBueLq/erWhX0IzePddeMwbSiEKt6q+JpPztSdJA3+ViBmJNvKmLkiUHZ+Rgk6eBvK929gwHyC5SD3krDq4Srjh9yQ/3AGIaGMgzIdXzxjTfMYqon1KQ9wvgGIuhHv4d+Q/oNJWOQMLullok+f+qhgJlp+JqVJY0veuB/QxboozvRCunWuMO37IaAJFWIPmlslx+XiV6n/CxuVbVPfRqUV1H3Zmvw6iJc46eJwXeyeA9TeQ6bwINo3R7N0hOPZuVCaADsx7Pv/pacRoNxOJldw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DVXuK7GGEsLWJlaOFlMVK7TjEgvAtSeGuZSvF7Sxeo=;
 b=fVUBFBXDvZ+zsperyvp9sRIkTCCLjcd1Tor9JQQ6j2T8WqjYcUcBQVLhzwImphhHR0dLOcGSRoxl3rVGPRiM8OLIzXlmzFTGs2rfsN7W37JYyhqWev4y68qAkSQvi4jrG/YYaz5vz4Q03eM7xGIDVrfC4LKjdH6d10jxBmG+m6tccNJ9jw9cEV7sPhERFQYO0I0OFajvs46p/2upeAu51pHdCkMxFeaFLUS9TCVrZshAUIDPvpmnm8YeTJSMC9zbp0azY8cZcUaaaagaCMh+a+VBCUCGuvzVTas/L8HeQEdHoPHUULpMfjXRy7x/QO/olMxAp1p8dNgCEZR75IzQkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DVXuK7GGEsLWJlaOFlMVK7TjEgvAtSeGuZSvF7Sxeo=;
 b=KEtm/NyGi5hK2HI9ojd+4gDXDjKMIKzBX9A6TTFPNS2MJFutbsUn8J1ixbc6kGNnXLoH1mg6zj/fzUEvgY6zidBeBv29UfIZ4n5HmLq8Q+Y7g0jsuLeLoed9tqcPP1v2fcqFAhzfR7+MT7OYuhkgvNSRcMIkF+6FCgkYKuIT8Hw=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TYAPR01MB2671.jpnprd01.prod.outlook.com (2603:1096:404:8d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 16 Jul
 2020 04:42:21 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3%6]) with mapi id 15.20.3195.017; Thu, 16 Jul 2020
 04:42:21 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        dmaengine <dmaengine@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/9] iommu/ipmmu-vmsa: Hook up R8A774E1 DT matching code
Thread-Topic: [PATCH 2/9] iommu/ipmmu-vmsa: Hook up R8A774E1 DT matching code
Thread-Index: AQHWWV2MbTXg+hkXBUeG2IKsFpTIWqkGuXGAgAAF1ACAAAM3gIAALMKggAAVtICAAp3DYA==
Date:   Thu, 16 Jul 2020 04:42:21 +0000
Message-ID: <TY2PR01MB3692CFA8B51F91FB9735026FD87F0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <CAMuHMdV4zzrk_=-2Cmgq8=PKTeU457iveJ58gYekJ-Z8SXqaCQ@mail.gmail.com>
 <CA+V-a8tB0mA17f51GMQQ-Cj_CUXze_JjTahrpoAtmwuOFHQV6g@mail.gmail.com>
 <CAMuHMdXM3qf266exJtJrN0XAogEsJoM-k3FON9CjX+stLpuMFA@mail.gmail.com>
 <TY2PR01MB3692A868DD4E67D770C610E3D8610@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <CAMuHMdUry12MnLvVgmd7NJ+Gv4mA86qKKfsQobP1o-ohzKm=RQ@mail.gmail.com>
In-Reply-To: <CAMuHMdUry12MnLvVgmd7NJ+Gv4mA86qKKfsQobP1o-ohzKm=RQ@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [240f:60:5f3e:1:999:df6f:dcad:bd95]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 86c67283-184a-47a2-e326-08d82942a0aa
x-ms-traffictypediagnostic: TYAPR01MB2671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TYAPR01MB26710915A5EDF2C69467A2FBD87F0@TYAPR01MB2671.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M4RkfSw2dSVC0Ylu4gbH8smqKZ1JZ5nYHnfx1DAInZC9j4sYADG5ObrAdZAMl3mtRkvB7OprMG3AJKRWYCSPyQ76yK9OCIEOOlbiYIOrq89jGyYAy/jhjFq2FXw0Y5HLUBvQcsPZ/mYMRGLiT46/sfCYFcll+3Gubt0TmwmaB2aGu/S0XpTlg0RhgJ7Rb1TdK3TI418OVdYSeJ5R8KucXEsBTBqlayvpdE+ZZoc7Qa8buA03KhcTTppzm2WnfGi5oXIg2sKr1F5lrMuvWH5v6V8zKkJ/WgfQt3E40jcDGXOz2iKZgN6XI6kqGMn78a3uE4d0EKM+7u+Z/+OOusn5GfT1zcfL5ijZuG/mREODedYd6NLBAdpzpma+L/m39peEmYPJaiub+wHgYbhjLKyW3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(316002)(6916009)(76116006)(86362001)(66946007)(66446008)(71200400001)(7416002)(2906002)(66556008)(9686003)(54906003)(55016002)(64756008)(66476007)(8676002)(7696005)(4326008)(33656002)(5660300002)(52536014)(6506007)(53546011)(186003)(8936002)(478600001)(52103002)(158003001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: BZQ062kPob81tYpmM06yPo4OBfHiNnEJ8giVl1UFBgDYuTwdu7M5YZDWvNT5KJeG6pXVCLn55g5mkAYx36RmQ7E3Gjx0OnEPMaRdS0prhfvpi0cgwdSaiEVWnAC4QTLXzKh26CxPzOli4cH3RtaNZdNwfe+npuKrsc06/RtMLsQR4kwvpf2toLSEOcDp5moi0OQtvgABmYWwofNEgMXYEF/oYpnzfV09YU9ZZEukQ6T/6g6iuHLIHt5QzMXKrLXpvmnTfQ8tN4am/H9U7lLW/hjrsdZV36OrXh4G0AcTPjUY5d/TPBjG2cgkknHTbITbejmpl82xQAXVtMSnMuQA3WiLE3bIFbixhQkOIzZu9POrgGan7bls5VRycI3Q4itPixUwerBT064vBVH33/bSjNMwhaX3LJFXuRihuu86Ugr+FoBp+MqV90ODVcSmB2p6PV0SqVX9n8xy6+xOWDIvAAgjJPP0AqjrKgMJ2aTEhjmriXq/GH+8rMFedIHReEj5RQV62ow+H7Q9pvp1xFO06bTOo1sRUn5qDkbQS6GdVTE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86c67283-184a-47a2-e326-08d82942a0aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2020 04:42:21.1420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7z1K7SMbli5BPYc4Xt56Di64XGWfm2KzcRHuABMz1c2N0cl7vXzA/k6lasM5dL9KvKFVlSeE6tSb//WFbZoNg66zzlUpdTVp/8P+GlxDkXtAc3LE6MB0kjUCd+65XFIQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2671
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQtc2FuLA0KDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiwgU2VudDogVHVlc2Rh
eSwgSnVseSAxNCwgMjAyMCA5OjQwIFBNDQo+IA0KPiBIaSBTaGltb2RhLXNhbiwNCj4gDQo+IE9u
IFR1ZSwgSnVsIDE0LCAyMDIwIGF0IDE6NDIgUE0gWW9zaGloaXJvIFNoaW1vZGENCj4gPHlvc2hp
aGlyby5zaGltb2RhLnVoQHJlbmVzYXMuY29tPiB3cm90ZToNCj4gPiA+IEZyb206IEdlZXJ0IFV5
dHRlcmhvZXZlbiwgU2VudDogVHVlc2RheSwgSnVseSAxNCwgMjAyMCA1OjQyIFBNDQo+ID4gPiBP
biBUdWUsIEp1bCAxNCwgMjAyMCBhdCAxMDozMCBBTSBMYWQsIFByYWJoYWthcg0KPiA+ID4gPHBy
YWJoYWthci5jc2VuZ2dAZ21haWwuY29tPiB3cm90ZToNCj4gPiA+ID4gT24gVHVlLCBKdWwgMTQs
IDIwMjAgYXQgOTowOSBBTSBHZWVydCBVeXR0ZXJob2V2ZW4gPGdlZXJ0QGxpbnV4LW02OGsub3Jn
PiB3cm90ZToNCj4gPiA+ID4gPiBPbiBNb24sIEp1bCAxMywgMjAyMCBhdCAxMTozNSBQTSBMYWQg
UHJhYmhha2FyDQo+ID4gPiA+IEFsc28gdGhlIHJlY2VudCBwYXRjaCB0byBhZGQNCj4gPiA+ID4g
InI4YTc3OTYxIiBqdXN0IGFkZHMgdG8gc29jX3JjYXJfZ2VuM193aGl0ZWxpc3QuDQo+ID4gPg0K
PiA+ID4gT29wcywgY29tbWl0IDE3ZmUxNjE4MTYzOTgwMWIgKCJpb21tdS9yZW5lc2FzOiBBZGQg
c3VwcG9ydCBmb3IgcjhhNzc5NjEiKQ0KPiA+ID4gZGlkIGl0IHdyb25nLCB0b28uDQo+ID4NCj4g
PiBUaGFuayB5b3UgZm9yIHRoZSBwb2ludCBpdCBvdXQuIFdlIHNob3VsZCBhZGQgcjhhNzc5NjEg
dG8gdGhlIHNvY19yY2FyX2dlbjNbXS4NCj4gPiBIb3dldmVyLCBJIGRvbid0IGtub3cgd2h5IEkg
Y291bGQgbm90IHJlYWxpemUgdGhpcyBpc3N1ZS4uLg0KPiA+IFNvLCBJIGludmVzdGlnYXRlZCB0
aGlzIGEgbGl0dGxlIGFuZCB0aGVuLCBJSVVDLCBnbG9iX21hdGNoKCkgd2hpY2gNCj4gPiBzb2Nf
ZGV2aWNlX21hdGNoKCkgdXNlcyBzZWVtcyB0byByZXR1cm4gdHJ1ZSwgaWYgKnBhdCA9ICJyOGE3
Nzk2IiBhbmQgKnN0ciA9ICJyOGE3Nzk2MSIuDQo+IA0KPiBBcmUgeW91IHN1cmUgYWJvdXQgdGhp
cz8NCg0KSSdtIHZlcnkgc29ycnkuIEkgY29tcGxldGVseSBtaXN1bmRlcnN0b29kIHRoZSBnbG9i
X21hdGNoKCkgYmVoYXZpb3IuDQpBbmQsIG5vdyBJIHVuZGVyc3Rvb2Qgd2h5IHRoZSBjdXJyZW50
IGNvZGUgY2FuIHVzZSBJUE1NVSBvbiByOGE3Nzk2MS4uLg0KIyBTaW5jZSB0aGUgZmlyc3Qgc29j
X2RldmljZV9tYXRjaCgpIHdpbGwgcmV0dXJuIGZhbHNlLCBpcG1tdV9zbGF2ZV93aGl0ZWxpc3Qo
KQ0KIyB3aWxsIHJldHVybiB0cnVlIGFuZCB0aGVuIHRoZSBpcG1tdV9vZl94bGF0ZSgpIHdpbGwg
YmUgc3VjY2VlZGVkLg0KDQo+IEkgZW5hYmxlZCBDT05GSUdfR0xPQl9TRUxGVEVTVCwgYW5kIGds
b2J0ZXN0IHN1Y2NlZWRlZC4NCj4gSXQgZG9lcyB0ZXN0IGdsb2JfbWF0Y2goImEiLCAiYWEiKSwg
d2hpY2ggaXMgYSBzaW1pbGFyIHRlc3QuDQo+IA0KPiBUbyBiZSAxMDAlIHN1cmUsIEkgYWRkZWQ6
DQo+IA0KPiAtLS0gYS9saWIvZ2xvYnRlc3QuYw0KPiArKysgYi9saWIvZ2xvYnRlc3QuYw0KPiBA
QCAtNTksNiArNTksNyBAQCBzdGF0aWMgY2hhciBjb25zdCBnbG9iX3Rlc3RzW10gX19pbml0Y29u
c3QgPQ0KPiAgICAgICAgICIxIiAiYVwwIiAiYVwwIg0KPiAgICAgICAgICIwIiAiYVwwIiAiYlww
Ig0KPiAgICAgICAgICIwIiAiYVwwIiAiYWFcMCINCj4gKyAgICAgICAiMCIgInI4YTc3OTZcMCIg
InI4YTc3OTYxXDAiDQo+ICAgICAgICAgIjAiICJhXDAiICJcMCINCj4gICAgICAgICAiMSIgIlww
IiAiXDAiDQo+ICAgICAgICAgIjAiICJcMCIgImFcMCINCj4gDQo+IGFuZCBpdCBzdGlsbCBzdWNj
ZWVkZWQuDQoNCkknbSB2ZXJ5IHNvcnJ5IHRvIHdhc3RlIHlvdXIgdGltZSBhYm91dCB0aGlzLi4u
DQoNCkJlc3QgcmVnYXJkcywNCllvc2hpaGlybyBTaGltb2RhDQoNCg==
