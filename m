Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01112AFB68
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 23:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgKKWfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 17:35:17 -0500
Received: from mga07.intel.com ([134.134.136.100]:38045 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbgKKWcz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 17:32:55 -0500
IronPort-SDR: QK2aNPJRKvrAAg9qrAStemsyd3Y5vvzYaKWUryy5sMiNYY1aPz+URbWdOMXRQ8wYTLZp0xxUl+
 GxYWCXzEPj7w==
X-IronPort-AV: E=McAfee;i="6000,8403,9802"; a="234392905"
X-IronPort-AV: E=Sophos;i="5.77,470,1596524400"; 
   d="scan'208";a="234392905"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 14:30:42 -0800
IronPort-SDR: 8lB1M2G9eeWXjV7EOYnupqW4cscopIIXNPUO48V6+L2eVb0ItlD2NVQN5W5BpmiKAkJ8fnvz3c
 NQ7Kg3dlJCIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,470,1596524400"; 
   d="scan'208";a="354996713"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 11 Nov 2020 14:30:42 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 11 Nov 2020 14:30:36 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 11 Nov 2020 14:30:36 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 11 Nov 2020 14:30:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSG9w4qywsFMYd/LmFBq8DQ5UmPRAppVUIYqrOJ7I04JzNK8C4YMFpzn4zWrxEG0MpaYJt7ZIZxKN5OcxvneCjkmtekxQ6KtWJmlrpIrNK5MdUr4HwXW1jjulcOUfYQqoEA82MZ+X/7nAPXdHURQnziYzlo8KwzqmmWpALewK2nfJmqLj3dqeZr91YccVR6dd6DL0S8oRnE+U5U5LFj0Sj3geucu5/o7RVLHB0xOV1RyjjwSLNvDpV+XkZV/vhkU1K65dF1krQWwdqSIDDGwUhdFe+qscWmbO2V7uYJm6Nq6ax+lUntxPbREdHs4yjXVO4yaOLzBF8YgQ/5fq1XSSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvnjhGeyqlrFQe3OC+94bgnh4xjaDGK6a6xfEA+oqAE=;
 b=YHfmg1Pk6eUj1/3xS3J+uGoCsxb0yAn+fvcVZ8hM2f08kbH3X0qVkoL+db1kFc7SVsYp0/QCcq+V3ScQhaVPVFrqnBODIaPXLROZMnsE9mrFyLU3xK8vK/e8eyhIBdn7e4Ipvxwv38N/3Zyd5b9zei7QQUOyd8vUajHBRdRgS0dpDlluhhx2rMO4fYdMTJODJEGaP5pfKHdXxO0MctenNH5mu3qFc+VrbPl+X2CYVKHdACXA4zQNUdSxUIhSFuCTVwL33wA3kjoiiN581hELbGczKDDG7rkJz8jz8BewgJLNGFmC4QENfpg2XdPYLxxR9AQeU2JALaBIP1i4BjbqLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvnjhGeyqlrFQe3OC+94bgnh4xjaDGK6a6xfEA+oqAE=;
 b=vBN6Xiiwx3g+7KREScA+Wu4NHgaHWx8EpubWJzfM6XNm0yZGvh6B5tEKLX5fDXOOE6B9Qhmm63CTWqPodCPcnAR22Wczzubz5GTN1Ga7iNzV74Fhlg9RHwJeQox6nU99bopEXKBot96Yyp0c4p/X6pYomuw5kjy78WW36gII0X8=
Received: from MWHPR1101MB2207.namprd11.prod.outlook.com (2603:10b6:301:58::7)
 by MWHPR11MB0061.namprd11.prod.outlook.com (2603:10b6:301:65::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Wed, 11 Nov
 2020 22:30:33 +0000
Received: from MWHPR1101MB2207.namprd11.prod.outlook.com
 ([fe80::f15b:19a7:98ba:8b02]) by MWHPR1101MB2207.namprd11.prod.outlook.com
 ([fe80::f15b:19a7:98ba:8b02%8]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 22:30:33 +0000
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "Saeed Mahameed" <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Guedes, Andre" <andre.guedes@intel.com>
Subject: Re: Hardware time stamping support for AF_XDP applications
Thread-Topic: Hardware time stamping support for AF_XDP applications
Thread-Index: AQHWt7MCSEaDlO58DE6scAsur7MQZanCBAaAgAAGAoCAAPtMgIAAf80A
Date:   Wed, 11 Nov 2020 22:30:33 +0000
Message-ID: <FDABA0E4-C606-4C53-ACD7-9C1E78F98E97@intel.com>
References: <7299CEB5-9777-4FE4-8DEE-32EF61F6DA29@intel.com>
 <6af7754d5bcba7a7f7d92dc43e1f4206ce470c79.camel@kernel.org>
 <65418F25-1795-4FF7-AB04-8DE78F0C8BF5@intel.com>
 <20201111155307.4d0171a5@carbon>
In-Reply-To: <20201111155307.4d0171a5@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.96.95.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 766d6b6c-86aa-4f31-e9ea-08d88691676d
x-ms-traffictypediagnostic: MWHPR11MB0061:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB00612DD33ABD7C105F4FD78C92E80@MWHPR11MB0061.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qB2O3CSBQDKuPLoL9BC+l3uyTNyl1MMbWHTyfD9DIr+95tR8xUAoU4oYp5tmpOlWq2LUa3y+yXB1NrHSiJZl5uHr+5d0XOnD4hnbkv5BQjUpTJf7s0TtjxlA/y5sVrf1Sw7J0lROj4ENX99M2jesj4SY39eSYJnyqeV98I6xPCGM399c8O2gbF9xiV/sr7MuUGhVQcltQ/Lqxmvi3VIxnHTFm96oEZWJABxfFvsS5iv1VsJ+tUKlc9IvE79ET2m/H829GwztXBCL/qgfxl+SptJUTRycwgIGBqLkKtOl0fMIfw7PR4IjdbePjhdRP6fhZ3Bc29LhCHOBCHZ63zG7Ew17vFQLGIzXufcf7Pjqj+Xg4Np8xZx/e97LC2DPzJYX5tuA4LX+l4VzXTHeuQ920MlF41rfOhHh6vjk4gq4Su59bGrSUJmBPwbLRqbzhIWA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(4001150100001)(186003)(76116006)(966005)(316002)(71200400001)(53546011)(107886003)(16799955002)(2616005)(26005)(6916009)(4326008)(36756003)(66556008)(64756008)(8936002)(54906003)(66446008)(6506007)(5660300002)(83380400001)(66946007)(86362001)(6486002)(478600001)(8676002)(33656002)(45080400002)(2906002)(6512007)(66476007)(6606295002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: TQv0qkYr3tFCf1wm2gNUMVlsz9RUisI+SzTLzcCRmiTpYEWNrZ+vCwmxgFJ4WMFktG46J+5uryk5QrrFBbwdiUvLlJ/CdYnZCQcCtS1QpYjQamoWpfFtzSTp4Vtzh0w3irLTSI9B+IgAtiD4WZDHImdWPZfI1/bDrZrKSlqJKqkps+CttexGceJQQonfnqYMZ57j/a5mPECGaCFZjCMcIfP5QDOMceMFmgbCCVZNxbzFtMuAlzNDqr+kAuJte4zmX8uRm0J4RrKzxjisPC0lXScDmtWQz4RmpIEH4r9qGflkKPjZodQh54xX66yMXu/RJOc8sDAUZV5xzbKwb+D6alvWOLrBbi07vaD0+4wowdE6kLnERBtrkaAWLGtMmJWSLlDNAv1EoR4M2fS3h6CNuUEAQc1yBx3nGF2ovPqt2ZRw1Wo6D76ecrEKqPHWFfqU7LKxOkXIbA+1HSiolZ1TJgv1IKjYDcgFpX/O8RQQHdFAkiWVhGSJvMdi524ybDsXevYD8BGWVRdLzd8FLJkifP6R2Ncn//nX2yFbu7XF3ixcnH2ZCrupjLenYtId/7+ax8VbJA3MgWB5K2IWqwPh19j8H1ny4bObEz/ZHDjcmDjMpt0BdP2UvCp7qSlUEPoEhDIA134z0wk7Us56ZkaaMQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <9462D84A6FA132409CAB027FD4DA5200@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 766d6b6c-86aa-4f31-e9ea-08d88691676d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2020 22:30:33.5472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zkH/fpleiBvHX+bLkytULExbTMTqk+3bugc/M4Stko/1ByOjBJEGlriNUK7TTyYbREKoLg0bPx0EO3f7z8CWeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0061
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W0xvb2tzIGxpa2UgZm9ybWF0IHNldHRpbmdzIGZvciBteSBtYWlsIGNsaWVudCB3ZXJlIG5vdCBw
ZXJzaXN0ZW50IGFuZCBJIHNlbnQgb3V0IEhUTUwgbWVzc2FnZSBhZ2FpbiBieSBtaXN0YWtlLiBI
b3BlZnVsbHkgaXTigJlzIGZpeGVkIG5vdy4gU29ycnkgZm9yIHRoZSBzcGFtLiA6KCBdDQoNCkhp
IEplc3BlciwgDQoNClRoYW5rcyBmb3IgYWxsIHRoZSBpbnB1dHMuIE15IFJlc3BvbnNlcyBpbmxp
bmU6DQoNCj4gT24gTm92IDExLCAyMDIwLCBhdCA2OjUzIEFNLCBKZXNwZXIgRGFuZ2FhcmQgQnJv
dWVyIDxicm91ZXJAcmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIDEwIE5vdiAyMDIw
IDIzOjUzOjQxICswMDAwDQo+ICJQYXRlbCwgVmVkYW5nIiA8dmVkYW5nLnBhdGVsQGludGVsLmNv
bT4gd3JvdGU6DQo+IA0KPj4gSGkgU2FlZWQsIA0KPj4gDQo+Pj4gT24gTm92IDEwLCAyMDIwLCBh
dCAzOjMyIFBNLCBTYWVlZCBNYWhhbWVlZCA8c2FlZWRAa2VybmVsLm9yZz4gd3JvdGU6DQo+Pj4g
DQo+Pj4gT24gVHVlLCAyMDIwLTExLTEwIGF0IDIyOjQ0ICswMDAwLCBQYXRlbCwgVmVkYW5nIHdy
b3RlOiAgDQo+Pj4+IFtTb3JyeSBpZiB5b3UgZ290IHRoZSBlbWFpbCB0d2ljZS4gUmVzZW5kaW5n
IGJlY2F1c2UgaXQgd2FzIHJlamVjdGVkDQo+Pj4+IGJ5IG5ldGRldiBmb3IgY29udGFpbmluZyBI
VE1MXQ0KPj4+PiANCj4+Pj4gSGkgU2FlZWQvSmVzcGVyLCANCj4+Pj4gDQo+Pj4+IEkgYW0gd29y
a2luZyBpbiB0aGUgVGltZSBTZW5zaXRpdmUgTmV0d29ya2luZyB0ZWFtIGF0IEludGVsLiBXZSB3
b3JrDQo+Pj4+IG9uIGltcGxlbWVudGluZyBhbmQgdXBzdHJlYW1pbmcgc3VwcG9ydCBmb3IgVFNO
IHJlbGF0ZWQgZmVhdHVyZXMgZm9yDQo+Pj4+IGludGVsIGJhc2VkIE5JQ3MuIFJlY2VudGx5IHdl
IGhhdmUgYmVlbiBhZGRpbmcgc3VwcG9ydCBmb3IgWERQIGluDQo+Pj4+IGkyMjUuIE9uZSBvZiB0
aGUgZmVhdHVyZXMgd2hpY2ggd2Ugd2FudCB0byBhZGQgc3VwcG9ydCBmb3IgaXMgcGFzc2luZw0K
Pj4+PiB0aGUgaGFyZHdhcmUgdGltZXN0YW1wIGluZm9ybWF0aW9uIHRvIHRoZSB1c2Vyc3BhY2Ug
YXBwbGljYXRpb24NCj4+Pj4gcnVubmluZyBBRl9YRFAgc29ja2V0cyAoZm9yIGJvdGggVHggYW5k
IFJ4KS4gSSBjYW1lIGFjcm9zcyB0aGUgWERQDQo+Pj4+IFdvcmtzaG9wWzFdIGNvbmR1Y3RlZCBp
biBKdWx5IDIwMjAgYW5kIHRoZXJlIHlvdSBzdGF0ZWQgdGhhdCB5b3UgYXJlDQo+Pj4+IGFscmVh
ZHkgd29ya2luZyBvbiBhZGRpbmcgc3VwcG9ydCBmb3IgQlRGIGJhc2VkIG1ldGFkYXRhIHRvIHBh
c3MNCj4+Pj4gaGFyZHdhcmUgaGludHMgZm9yIFhEUCBQcm9ncmFtcy4gTXkgdW5kZXJzdGFuZGlu
ZyAoYWxvbmcgd2l0aCBhIGZldw0KPj4+PiBxdWVzdGlvbnMpIG9mIHRoZSBjdXJyZW50IHN0YXRl
IGlzOiAgDQo+IA0KPiBIYXZlIHRoZSBpMjI1IFhEUCBzdXBwb3J0IGJlZW4gdXBzdHJlYW1lZD8N
CkFuZHJlIChDQ+KAmWQgaGVyZSkgaXMgd29ya2luZyBvbiBhZGRpbmcgc3VwcG9ydC4gVGhlIGZp
cnN0IHNlcmllcyBbMV0ganVzdCBnb3QgbWVyZ2VkIGludG8gZGV2IHF1ZXVlLiBIZSBpcyB3b3Jr
aW5nIG9uIGFkZGluZyBaZXJvIENvcHkgYW5kIFVNRU0gc3VwcG9ydC4NCg0KWzFdIC0gaHR0cHM6
Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9wcm9qZWN0L2ludGVsLXdpcmVkLWxhbi9jb3Zlci8yMDIw
MTEwNDAzMTIxMC4yNzc3Mi0xLWFuZHJlLmd1ZWRlc0BpbnRlbC5jb20vDQo+IA0KPiBDYW4gSSBi
dXkgYSBpMjU1IE5JQyBmb3IgbXkgc2VydmVyLCBvciBpcyB0aGlzIGVtYmVkZGVkIE5JQ3M/DQpZ
ZXMsIGkyMjUgTklDcyBhcmUgYXZhaWxhYmxlIGluIGRpc2NyZXRlIGZvcm0gZmFjdG9yLiBPbmUg
b2YgdGhlIGxpbmtzIHdoZXJlIGl04oCZcyBwdWJsaWNseSBhdmFpbGFibGUgaXM6DQpodHRwczov
L3Nob3AucW5hcC5jb20vaW5kZXgucGhwP3JvdXRlPXByb2R1Y3QvcHJvZHVjdCZwcm9kdWN0X2lk
PTM4OA0KDQo+IA0KPiBJbGlhcyBoYXZlIHBsYXllZCB3aXRoIFBvQyBmb3IgVFNOIChvbiBBUk0p
IGhlcmU6DQo+IGh0dHBzOi8vZ2l0aHViLmNvbS94ZHAtcHJvamVjdC94ZHAtcHJvamVjdC9ibG9i
L21hc3Rlci9hcmVhcy9hcm02NC94ZHBfZm9yX3Rzbi5vcmcNCk91ciBhaW0gaXMgdG8gdXNlIHRo
ZSBhcHByb2FjaCBkZXNjcmliZWQgaW4gdGhlIGxhc3QgcGFyYWdyYXBoIHRvIGdhdGhlciBlbmQt
dG8tZW5kIGxhdGVuY3kuDQo+IA0KPj4+IEhpIFBhdGVsLA0KPj4+IA0KPj4+PiAqIFRoaXMgZmVh
dHVyZSBpcyBjdXJyZW50bHkgYmVpbmcgbWFpbnRhaW5lZCBvdXQgb2YgdHJlZS4gSSBmb3VuZA0K
Pj4+PiB0aGF0IGFuIFJGQyBTZXJpZXNbMl0gd2FzIHBvc3RlZCBpbiBKdW5lIDIwMTguIEFyZSB5
b3UgcGxhbm5pbmcgdG8NCj4+Pj4gcG9zdCBhbiB1cGRhdGVkIHZlcnNpb24gdG8gYmUgbWVyZ2Vk
IGluIHRoZSBtYWlubGluZSBhbnl0aW1lIHNvb24/ICAgDQo+Pj4gDQo+Pj4gWWVzIGhvcGVmdWxs
eSBpbiB0aGUgY29taW5nIGNvdXBsZSBvZiB3ZWVrcy4NCj4+PiANCj4+IA0KPj4gU3VyZSEgSSB3
aWxsIHN0YXJ0IHRlc3RpbmcvZGV2ZWxvcGluZyBvbiB0b3Agb2YgeW91ciBicmFuY2ggbWVudGlv
bmVkDQo+PiBiZWxvdyBmb3Igbm93Lg0KPiANCj4gSSd2ZSBhbHNvIHNpZ25lZCB1cCBmb3IgaGVs
cGluZyBvdXQgb24gdGhpcyBlZmZvcnQuICBOb3RpY2UgQW5kcmlpIChjYykNCj4gaGF2ZSBhbHJl
YWR5IHBvaW50ZWQgb3V0IHNvbWV0aGluZyB0aGF0IGNhbiBiZSBpbXByb3ZlZCwgYW5kIGV2ZW4g
bWFkZQ0KPiBlYXNpZXIuDQpUaGF04oCZcyBncmVhdCEgQ2FuIHlvdSBwb2ludCBtZSB0byB0aGUg
aW1wcm92ZW1lbnQgQW5kcmlpIG1lbnRpb25lZD8NCj4gDQo+IA0KPj4+PiAqIEkgYW0gZ3Vlc3Np
bmcgaGFyZHdhcmUgdGltZXN0YW1wIGlzIG9uZSBvZiB0aGUgbWV0YWRhdGEgZmllbGRzDQo+Pj4+
IHdoaWNoIHdpbGwgYmUgZXZlbnR1YWxseSBzdXBwb3J0ZWQ/IFszXSAgDQo+Pj4gDQo+Pj4gV2l0
aCBCVEYgZm9ybWF0dGVkIG1ldGFkYXRhIGl0IGlzIHVwIHRvIHRoZSBkcml2ZXIgdG8gYWR2ZXJ0
aXNlDQo+Pj4gd2hhdGV2ZXIgaXQgY2FuL3dhbnQgOikNCj4+PiBzbyB5ZXMuICANCj4+IA0KPj4g
SSBoYXZlIGEgdmVyeSBiYXNpYyBxdWVzdGlvbiBoZXJlLiBGcm9tIHdoYXQgSSB1bmRlcnN0YW5k
IGFib3V0IEJURiwNCj4+IEkgY2FuIGdlbmVyYXRlIGEgaGVhZGVyIGZpbGUgKHVzaW5nIGJwZnRv
b2w/KSBjb250YWluaW5nIHRoZSBCVEYgZGF0YQ0KPj4gZm9ybWF0IHByb3ZpZGVkIGJ5IHRoZSBk
cml2ZXIuIElmIHNvLCBob3cgY2FuIEkgZGVzaWduIGFuIGFwcGxpY2F0aW9uDQo+PiB3aGljaCBj
YW4gd29yayB3aXRoIG11bHRpcGxlIE5JQ3MgZHJpdmVycyB3aXRob3V0IHJlY29tcGlsYXRpb24/
IEkgYW0NCj4+IGd1ZXNzaW5nIHRoZXJlIGlzIHNvbWUgc29ydCBvZiDigJxtYXN0ZXIgbGlzdOKA
nSBvZiBIVyBoaW50cyB0aGUgZHJpdmVycw0KPj4gd2lsbCBhZ3JlZSB1cG9uPw0KPiANCj4gSSBy
ZWNvbW1lbmQgdGhhdCB5b3UgcmVhZCBBbmRyaWkncyBibG9ncG9zdDoNCj4gaHR0cHM6Ly9mYWNl
Ym9va21pY3Jvc2l0ZXMuZ2l0aHViLmlvL2JwZi9ibG9nLzIwMjAvMDIvMTkvYnBmLXBvcnRhYmls
aXR5LWFuZC1jby1yZS5odG1sDQpUaGlzIGlzIHF1aXRlIGluc2lnaHRmdWwhDQo+IA0KPiBJIG5l
ZWQgdG8gbGVhcm4gbW9yZSBhYm91dCBCVEYgbXlzZWxmLCBidXQgdGhlIHdheSBJIHVuZGVyc3Rh
bmQgdGhpczoNCj4gV2UgbmVlZCB0byBhZ3JlZSBvbiB0aGUgbWVhbmluZyBvZiBzdHJ1Y3QgbWVt
YmVyIG5hbWVzIChlLmcuIHJ4aGFzaDMyKS4NCj4gVGhlbiB5b3UgY29tcGlsZSBCUEYgd2l0aCBh
IEJURiBzdHJ1Y3QgdGhhdCBoYXZlIHRoaXMgcnhoYXNoMzIgbWVtYmVyDQo+IG5hbWUsIGFuZCBh
dCBCUEYgbG9hZC10aW1lIHRoZSBrZXJuZWwgQ08tUkUgaW5mcmEgd2lsbCByZW1hcCB0aGUgb2Zm
c2V0DQo+IHRvIHRoZSByeGhhc2gzMiBvZmZzZXQgdXNlZCBieSB0aGUgc3BlY2lmaWMgZHJpdmVy
Lg0KPiANCj4+PiANCj4+Pj4gKiBUaGUgTWV0YWRhdGEgc3VwcG9ydCB3aWxsIGJlIGV4dGVuZGVk
IHRvIHBhc3Mgb24gdGhlIGhhcmR3YXJlIGhpbnRzDQo+Pj4+IHRvIEFGX1hEUCBzb2NrZXRzLiBB
cmUgdGhlcmUgYW55IHJvdWdoIHBsYW5zIG9uIHdoYXQgbWV0YWRhdGEgd2lsbCBiZQ0KPj4+PiB0
cmFuc2ZlcnJlZD8gIA0KPj4+IA0KPj4+IEFGX1hEUCBpcyBub3QgcGFydCBvZiBteSBzZXJpZXMs
IGJ1dCBzdXBwb3J0aW5nIEFGX1hEUCB3aXRoIG1ldGFkYXRhDQo+Pj4gb2ZmbGFvZCBpcyB1cCB0
byB0aGUgZHJpdmVyIHRvIGltcGxlbWVudCwgc2hvdWxkIGJlIHN0cmFpZ2h0IGZvcndhcmQNCj4+
PiBhbmQgaWRlbnRpY2FsIHRvIFhEUC4NCj4gDQo+IFRoZSBYRFAgZGF0YV9tZXRhIGFyZWEgaXMg
YWxzbyB0cmFuc2ZlcnJlZCBpbnRvIHRoZSBBRl9YRFAgZnJhbWUsIGFsc28NCj4gaW4gdGhlIGNv
cHktbW9kZSB2ZXJzaW9uIG9mIEFGX1hEUC4NCj4gDQo+IA0KPj4+IHdoYXQgbWV0YSBkYXRhIHRv
IHBhc3MgaXMgdXAgdG8gdGhlIGRyaXZlci4gIA0KPj4gDQo+PiBBbHJpZ2h0LCBsZXQgbWUgdGFr
ZSBhIGNsb3NlciBsb29rIGF0IHlvdXIgbGF0ZXN0IGNvZGUuIEkgd2lsbCBjb21lDQo+PiBiYWNr
IHdpbGwgcXVlc3Rpb25zIGlmIEkgaGF2ZSBhbnkuDQo+Pj4gDQo+Pj4gDQo+Pj4+ICogVGhlIGN1
cnJlbnQgcGxhbiBmb3IgVHggc2lkZSBvbmx5IGluY2x1ZGVzIHBhc3NpbmcgZGF0YSBmcm9tIHRo
ZQ0KPj4+PiBhcHBsaWNhdGlvbiB0byB0aGUgZHJpdmVyLiBBcmUgdGhlcmUgYW55IHBsYW5zIHRv
IHN1cHBvcnQgcGFzc2luZw0KPj4+PiBpbmZvcm1hdGlvbiAobGlrZSBIVyBUWCB0aW1lc3RhbXAp
IGZyb20gZHJpdmVyIHRvIHRoZSBBcHBsaWNhdGlvbj8NCj4+Pj4gDQo+Pj4gDQo+Pj4geW91IG1l
YW4gZm9yIEFGX1hEUCA/IGkgYWN0dWFsbHkgaGF2ZW4ndCB0aG91Z2h0IGFib3V0IHRoaXMsIA0K
Pj4+IGJ1dCB3ZSBjb3VsZCB1c2UgVFggdW1lbSBwYWNrZXQgYnVmZmVyIGhlYWRyb29tIHRvIHBh
c3MgVFggY29tcGxldGlvbg0KPj4+IG1ldGFkYXRhIHRvIEFGX1hEUCBhcHAsIG9yIGV4dGVuZCB0
aGUgY29tcGxldGlvbiBxdWV1ZSBlbnRyaWVzIHRvIGhvc3QNCj4+PiBtZXRhZGF0YSwgaSBhbSBz
dXJlIHRoYXQgdGhlIDFzdCBhcHByb2FjaCBpcyBwcmVmZXJyZWQsIGJ1dCBpIGFtIG5vdA0KPj4+
IHBsYW5pbmcgdG8gc3VwcG9ydCB0aGlzIGluIG15IGluaXRpYWwgc2VyaWVzLiANCj4+PiANCj4+
IFllYWgsIEkgd2FzIHRoaW5raW5nIG9mIHVzaW5nIGFwcHJvYWNoIDEgYXMgd2VsbCBmb3IgdGhp
cy4gTGV0IG1lDQo+PiBmaXJzdCB3b3JrIG9uIHRoZSBSeCBzaWRlLiBUaGVuIHdlIGNhbiBzY29w
ZSB0aGlzIG9uZSBvdXQuDQo+PiANCj4+Pj4gRmluYWxseSwgaXMgdGhlcmUgYW55IHdheSBJIGNh
biBoZWxwIGluIGV4cGVkaXRpbmcgdGhlIGRldmVsb3BtZW50DQo+Pj4+IGFuZCB1cHN0cmVhbWlu
ZyBvZiB0aGlzIGZlYXR1cmU/IEkgaGF2ZSBiZWVuIHdvcmtpbmcgb24gc3R1ZHlpbmcgaG93DQo+
Pj4+IFhEUCB3b3JrcyBhbmQgY2FuIHdvcmsgb24gaW1wbGVtZW50aW5nIHNvbWUgcGFydCBvZiB0
aGlzIGZlYXR1cmUgaWYNCj4+Pj4geW91IHdvdWxkIGxpa2UuDQo+Pj4+IA0KPj4+IA0KPj4+IFN1
cmUsDQo+Pj4gUGxlYXNlIGZlZWwgZnJlZSB0byBjbG9uZSBhbmQgdGVzdCB0aGUgZm9sbG93aW5n
IGJyYW5jaCBpZiB5b3UgYWRkDQo+Pj4gc3VwcG9ydCB0byAgeW91ciBkcml2ZXIgYW5kIGltcGxl
bWVudCBvZmZsb2FkcyBmb3IgQUZfWERQIHRoYXQgd291bGQgYmUNCj4+PiBhd2Vzb21lLCBhbmQg
aSB3aWxsIGFwcGVuZCB5b3VyIHBhdGNoZXMgdG8gbXkgc2VyaWVzIGJlZm9yZSBzdWJtaXNzaW9u
Lg0KPj4+IA0KPj4+IGl0IGlzIGFsd2F5cyBncmVhdCB0byBzZW5kIG5ldyBmZWF0dXJlcyB3aXRo
IG11bHRpcGxlIHVzZSBjYXNlcyBhbmQNCj4+PiBtdWx0aSB2ZW5kb3Igc3VwcG9ydCwgdGhpcyB3
aWxsIGRpZmZlcmVudGx5IGV4cGVkaXRlIHN1Ym1pc3Npb24gYW5kDQo+Pj4gYWNjZXB0YW5jZQ0K
Pj4+IA0KPj4+IE15IExhdGVzdCB3b3JrIGNhbiBiZSBmb3VuZCBhdDoNCj4+PiANCj4+PiBodHRw
czovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zYWVlZC9saW51eC5n
aXQvbG9nLz9oPXRvcGljL3hkcF9tZXRhZGF0YTMNCj4+PiANCj4+PiBQbGVhc2UgZmVlbCBmcmVl
IHRvIHNlbmQgbWUgYW55IHF1ZXN0aW9ucyBhYm91dCB0aGUgY29kZSBpbiBwcml2YXRlIG9yDQo+
Pj4gcHVibGljLg0KPj4gDQo+PiBUaGFua3MgU2FlZWQgZm9yIGFsbCB0aGUgaW5mb3JtYXRpb24h
IFRoaXMgaXMgcmVhbGx5IGhlbHBmdWwuIDopDQo+Pj4gDQo+Pj4gVGhhbmtzLA0KPj4+IFNhZWVk
Lg0KPj4+IA0KPj4+PiBUaGFua3MsDQo+Pj4+IFZlZGFuZyBQYXRlbA0KPj4+PiBTb2Z0d2FyZSBF
bmdpbmVlcg0KPj4+PiBJbnRlbCBDb3Jwb3JhdGlvbg0KPj4+PiANCj4+Pj4gWzFdIC0gaHR0cHM6
Ly9uZXRkZXZjb25mLmluZm8vMHgxNC9zZXNzaW9uLmh0bWw/d29ya3Nob3AtWERQDQo+Pj4+IFsy
XSAtIA0KPj4+PiBodHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3Byb2plY3QvbmV0ZGV2L2Nv
dmVyLzIwMTgwNjI3MDI0NjE1LjE3ODU2LTEtc2FlZWRtQG1lbGxhbm94LmNvbS8NCj4+Pj4gWzNd
IC0gDQo+Pj4+IGh0dHBzOi8veGRwLXByb2plY3QubmV0LyNvdXRsaW5lLWNvbnRhaW5lci1JbXBv
cnRhbnQtbWVkaXVtLXRlcm0tdGFza3MgIA0KPj4gDQo+IA0KPiANCj4gDQo+IC0tIA0KPiBCZXN0
IHJlZ2FyZHMsDQo+ICBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyDQo+ICBNU2MuQ1MsIFByaW5jaXBh
bCBLZXJuZWwgRW5naW5lZXIgYXQgUmVkIEhhdA0KPiAgTGlua2VkSW46IGh0dHA6Ly93d3cubGlu
a2VkaW4uY29tL2luL2Jyb3Vlcg0K
