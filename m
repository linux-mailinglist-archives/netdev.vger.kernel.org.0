Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D222B88F4
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgKSAOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:14:15 -0500
Received: from outbound-ip24b.ess.barracuda.com ([209.222.82.221]:52638 "EHLO
        outbound-ip24b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726889AbgKSAOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 19:14:15 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170]) by mx6.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 19 Nov 2020 00:14:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hpdOOjygNzaUOhzw2ZvJbU0lj9NsTtSl9xm6inEbJ3tMWp0Sk3R+Q2tTb2Ny2l9mPX7mM18L1vIdB+hU6med3rw21Iv4PHWaunupSuL8lrqGJsWTIW9nbpl6UaIsRZwJf4mcUNrsOwipNRcjcJGyn2GSYXTSWbGMkspaXWnAFhdLeINcgpBUMGs5zx65NOwk9bkAJSEzEV/zUXGFTssbLGlNWeZYzFKLAgIC5ga4msH3RDyVmpAVS7r3GKP8oQB370/+BK1DxQmPTzgV4PZj+McDh38F9jGa9dPc6s7aju+AEABwjcbR5Yv19GFaPmevhkVQgQCMbt8A5a6WI4SQZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5BhYPpzPRl4JTlOBjQ84nGCL8iMbV3Q7P9dga1VmMC0=;
 b=BqUhfusBvnG/+1Tax29CgMzS6MD6kT5sGw8l5AEs6wu2j1sRTyirhkzheZatwdX0O/QczoaxZhS+U/ASxV72wLB5UZJ8oF9+OoST86eryjBssyNET1ZOuNxjcxHqc2RSJq+LkERg+3ehGbLt11HI+dl9dBzxxPd+IAYnvqSaQOANNl2E7Mxzz79t1gbnvl6jGmvl37x0nAyB640cYiSIMpYIu5MLHs77xqQZ7VnwWtuckc8GLwRE+3p/5rQUWT5T3nQJ0JNAJnqIPvip8oGOctF4krmBc+hN5lOrSJxkVTvezdsMypGUOuh3tRqrtjFVEkqbPwckGvz8QiDoTDSJEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5BhYPpzPRl4JTlOBjQ84nGCL8iMbV3Q7P9dga1VmMC0=;
 b=SgW0IrV0ltwIG/dWk5Rel1gdo5LSVeALoUQxh7Q8wSk+DiPQ2RdNPeaQvkEiyyofdUQXaoSYddWRBVCBfmOZK+RYRLVHuaLUJB8Mo3jHuADSVQNGm9+uhz3JABZFs5+pQAshaXdbRAj4TR+Kh+JIDXtyHIxUsT48ESe7WoK0UuI=
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 (2603:10b6:910:44::24) by CY4PR10MB1941.namprd10.prod.outlook.com
 (2603:10b6:903:11b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Thu, 19 Nov
 2020 00:14:05 +0000
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197]) by CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197%6]) with mapi id 15.20.3564.033; Thu, 19 Nov 2020
 00:14:05 +0000
From:   "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [EXT] [PATCH] aquantia: Reserve space when allocating an SKB
Thread-Topic: [EXT] [PATCH] aquantia: Reserve space when allocating an SKB
Thread-Index: AQHWvUcksksVLDpkhU+MIoNHoOO3dKnN7HCAgACGx0E=
Date:   Thu, 19 Nov 2020 00:14:05 +0000
Message-ID: <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>,<2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
In-Reply-To: <2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
Accept-Language: en-AU, en-US
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=digi.com;
x-originating-ip: [158.140.192.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01fdda09-59c4-4db1-2959-08d88c2006cb
x-ms-traffictypediagnostic: CY4PR10MB1941:
x-microsoft-antispam-prvs: <CY4PR10MB19411223FA821FAE4DEA8501E8E00@CY4PR10MB1941.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ess8M4d2QjOvm9fSP2YYOGCIPyL8Bgm91CcsRNrraldG3IINykOKcyq1HS+EwxfMUkOw4rztmb/2uMxJCG0rt3RssQSXEtU8JLTpaYath0EuY5I9cH63cD3NYdELv/nJSWo3ip4HMm2k1WxeDzf4njP1m31Q+NLfjJRJvrXHmGIN+9cECdAxFmSTXCroZlZ4OdzDA8OFvIoc4IlvXqgeZTk+A8+7mBHLPqrfRu/ZUkuwmp8thCucgFD0E254XYA8OObsEAAHN0yVjWc3XL3TQi+aAUEEQ3fgnvC3EpPk6w5xuiqx23eTS15x0GG1+IIVXl+HhXu5cKhIT2lul+T8YQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2311.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(366004)(396003)(136003)(376002)(7696005)(66946007)(66556008)(2906002)(478600001)(5660300002)(26005)(6506007)(33656002)(76116006)(52536014)(186003)(66446008)(64756008)(66476007)(8936002)(91956017)(71200400001)(83380400001)(86362001)(55016002)(110136005)(9686003)(316002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: IImZ1I8F/oPG5rh/JCOCPfNZWVwvBw8QqMmYRFydWJP9V8UpKK7Qfo7xp6C7TLng/SW8UFCol8kXg9QuKEIAnkXouivNjlYoYgAC+wRvIGMJCFt5hDlixqeKaKURmxY7AiyuMJqz4DkflF2q9X6TBigpBQ+REhcAXeU0RcbYukvYpa2FDi3G2ILGjl9wCLbEbsNMxepckknp6Oypd3+AbI5OhE8ZOcBsntmipJWI4QGcl3tbkfwUZrDY62Px7HrhQuQCqLNfoYGRon3cam1rAvRzK8+Tu9qYOoLGebhR0hmmVdZUNNnopDRSAGtl9LtARw088mxJga0Razd81jDH5C00LGsXDxwfBjIHW0hyTaZZa3G6164oB4WUcR2121WWB4NuIwo6CdHZbxV0+8iX2pj1T+KuToYM7ffNhjFSLEpbLEqd6Pk67AfLKhXruId4gWKn7kcTTza7zmHo/L5O1EsSccyHC+PJluMYkqazLzJELCBKoVSmVY19KAVR8AbHU7hh/YeJ1Q0MX6iUGXP/NEPZep8ev0xeDWUMTnPlsRkADG1/0lnpOWJLJC+DNRAP3nbyoDg8bPI7O/DLRL7C8f5WKH8vToxe7CEs1jcIBDJvB0XToORIdDAAcvD4UZYSyE0K9IygpUqEDFLaULgZVuuNLCkrsuZIbbe7j7Yt3RCPLLAcL4Ysm1P/ERs736mP85Dxc4FvntOpSAZDvRjhuE+VZegiM+OdrzdMejJAW6Dwg8VLTcnQ6vdMNmMlmaxGdiW/9IYew0Ag0GHR6O6DUgqLXn7RD8TMmR9Msg8WCZp1poTl1hgf35Eip7BEsHo65clC6tUH+AOjFaCiHmKM+gSYOfp+03o2/V6ZTXMiLW3Ab7N5MzCg7hDoYuQD6PyhpmX9O3VZnJaFFKRvzp6iPQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2311.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01fdda09-59c4-4db1-2959-08d88c2006cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 00:14:05.2535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NpY9CRuCw4EdQN0ERg+L76Xc+A9Rrocz5sE2i4Hs3HueLEhAskKrEP5v8+nUauPWo0rHZhT4bINA2orAh/EymA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1941
X-BESS-ID: 1605744846-893011-16821-16350-1
X-BESS-VER: 2019.1_20201118.2036
X-BESS-Apparent-Source-IP: 104.47.58.170
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228287 [from 
        cloudscan12-80.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Igor,=0A=
=0A=
> Here I understand your intention. You are trying to "offset" the placemen=
t of=0A=
> the packet data, and the restore it back when construction SKB.=0A=
=0A=
Originally, I just added the skb_reserve call, but that broke everything. W=
hen I looked at what the igb driver was doing, this approach seemed reasona=
ble but I wasn't sure it'd work.=0A=
=0A=
> The problem however is that hardware is being programmed with fixed descr=
iptor=0A=
> size for placement. And its equal to AQ_CFG_RX_FRAME_MAX (2K by default).=
=0A=
> =0A=
> This means, HW will do writes of up to 2K packet data into a single=0A=
> descriptor, and then (if not enough), will go for next descriptor data.=
=0A=
> =0A=
> With your solution, packets of size (AQ_CFG_RX_FRAME_MAX - AQ_SKB_PAD) up=
 to=0A=
> size of AQ_CFG_RX_FRAME_MAX will overwrite the area of page they designat=
ed=0A=
> to. Ultimately, HW will do a memory corruption of next page.=0A=
=0A=
Yeah... this is the kind of thing I was worried about. It seemed to me that=
 the SKB was being built around a hardware buffer rather than around heap-a=
llocated memory. I just hoped that the rx_off value would somehow make it w=
ork.=0A=
=0A=
The code in aq_get_rxpages seems to suggest that multiple frames can fit in=
 a rxpage, so maybe the logic there prevents overwriting? (at the expense o=
f not fitting as many frames into the page before it has to get a new one?)=
=0A=
=0A=
I didn't notice any issues when I was testing, but apart from port forwardi=
ng ssh (which is tiny) and some copying of files on (probably not even clos=
e to saturating the link) there's not a huge network load placed on the dev=
ice. I guess it's entirely possible that an overwrite problem would only sh=
ow up under heavy load? (ie. more, and larger amounts of data in flight thr=
ough the kernel at once)=0A=
=0A=
> I think the only acceptable solution here would be removing that optimize=
d=0A=
> path of build_skb, and keep only napi_alloc_skb. Or, we can think of keep=
ing=0A=
> it under some configuration condition (which is also not good).=0A=
=0A=
I'll attempt to confirm that this works too, at least for our tests :)=0A=
=0A=
Lincoln=0A=
