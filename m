Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058BD95C1C
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 12:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbfHTKRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 06:17:04 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:25089 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728545AbfHTKRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 06:17:03 -0400
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: ZGTbEEY+aI+WKlbYpD5ycmwultfFf1rrRGTTC0UOIvgUj1seW4d9QEPk9TqYl+ayAMqDmlA6MC
 T8mvev5nr298kzPbNSuD3pVGLUnQX9h/0IS6AX6//cZgxkT5OvHVOUSG2w79A+DxOYOV1/qR3t
 ZFViicjFTQ1g1HjJvSTsA07RLoHVpPCnGq1qNgcjYLUmgQ2AD/9QVswloOSZFRnz0XkBIE7sPu
 ckSWgeDieZcguyyxNCgPKkGvGK8kxhU892UwRTKeGNm9anO6I3QtNSyNgHznvRHUnUYwR2Uac6
 AWQ=
X-IronPort-AV: E=Sophos;i="5.64,408,1559545200"; 
   d="scan'208";a="44908227"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Aug 2019 03:17:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Aug 2019 03:17:00 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Aug 2019 03:17:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qg1vY2qsULAmh0y6Sa7UYKQ6gGnMcde7FvgwHjv6HGYfrcC8VEiukuPywMKS48x81xVWVh0jGwsUr+FVRDU9lqpOofezjHI5N6Pkz+iaLyyPhZ6WjcU/4rw+Ye4GhUmpvo93ObC+Tt/lIBOtN62SL/+/Vqg82+y4OLeLaHcUXHvFst/JwfDHHa1trGjoN+LCyqwNMtPT6DArGIV+VAtLQpsW27CP+ErqUcdKhDJoBLadHiMMKtMQ2Zcs2oRVXIhCuAcpgUsuM42SPQYZmdXnf6Ap6nstd5twTBRiyr44wEghJrk41Pe9S3uB+Wi5NDJmWLMk2KCaeOsqhEh+Uvx0KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aEIMYzzWkSSNcvtr2qol2Ykt2ssfx0bRv8oWR/ba6nA=;
 b=BZ92G/yApSHWuPX226xkBHPqkhtJCuw30lYngPPABt/OyfKDLyWdAm8x8cavQMEvM2wmolBAe/Yp+XVz96oXHWKpjLtDOFtH6EJtpTO4nY3r8vfXs56zvK0mKW9YU6TJvBmCzXdCAvgqfGtvztu9S2RFjaqceEC4UPZ+V82/R+uTw9v/3PrLCLQkoGab4R9y4vYcWRE5WsOiPZMSUKt0SxrXSHrmUkPn21RXAdbmFg8VT011c9t2ir5vA34ewFGX30eXBEswtTNwCzN2IeDE3bTgJcKt0eh0PS3QWC4+4W41t3E0KYLQDRd7xsmv0wLi823WCvJNLtnDw+OicyEnoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aEIMYzzWkSSNcvtr2qol2Ykt2ssfx0bRv8oWR/ba6nA=;
 b=uzVwJ0u/9k25vmfaHCkSDjAz/2kKIUNJ1Tk6NdjjdTQM3ZmrbLQn5+kqB0LEVTdqw7MSu3U7C7cjXUb5FED7oZPSxoBntKCEILa+R353RidbaFUDCeXAwJQsIL770kcFAAQtyBgY6RsWf/hK1H2FgyUlHXNP6TN9lF4HEtIOTXI=
Received: from MWHPR11MB1662.namprd11.prod.outlook.com (10.172.55.15) by
 MWHPR11MB1374.namprd11.prod.outlook.com (10.169.234.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 10:16:59 +0000
Received: from MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::410a:9d4b:b1df:2134]) by MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::410a:9d4b:b1df:2134%12]) with mapi id 15.20.2178.018; Tue, 20 Aug
 2019 10:16:59 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <schwab@suse.de>, <paul.walmsley@sifive.com>,
        <davem@davemloft.net>, <jakub.kicinski@netronome.com>
CC:     <yash.shah@sifive.com>, <robh+dt@kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <mark.rutland@arm.com>, <palmer@sifive.com>,
        <aou@eecs.berkeley.edu>, <ynezz@true.cz>, <sachin.ghadi@sifive.com>
Subject: Re: [PATCH 2/3] macb: Update compatibility string for SiFive
 FU540-C000
Thread-Topic: [PATCH 2/3] macb: Update compatibility string for SiFive
 FU540-C000
Thread-Index: AQHVPiKzEWVX87W+rUadJIz70Teg7KbR2FcAgDIZnv2AABKIAA==
Date:   Tue, 20 Aug 2019 10:16:58 +0000
Message-ID: <0b50622a-1145-3637-082f-c4edaccbbaa1@microchip.com>
References: <1563534631-15897-1-git-send-email-yash.shah@sifive.com>
 <1563534631-15897-2-git-send-email-yash.shah@sifive.com>
 <4075b955-a187-6fd7-a2e6-deb82b5d4fb6@microchip.com>
 <CAJ2_jOEHoh+D76VpAoVq3XnpAZEQxdQtaVX5eiKw5X4r+ypKVw@mail.gmail.com>
 <alpine.DEB.2.21.9999.1908131142150.5033@viisi.sifive.com>
 <mvm5zmskxs3.fsf@suse.de>
In-Reply-To: <mvm5zmskxs3.fsf@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR1PR01CA0003.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::16) To MWHPR11MB1662.namprd11.prod.outlook.com
 (2603:10b6:301:e::15)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.41.198.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 167aa7df-a634-4e92-2da0-08d725578907
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR11MB1374;
x-ms-traffictypediagnostic: MWHPR11MB1374:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MWHPR11MB1374FADB3A23A27432C3563FE0AB0@MWHPR11MB1374.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(6029001)(396003)(376002)(346002)(39860400002)(136003)(366004)(199004)(189003)(25786009)(54906003)(53546011)(386003)(36756003)(31686004)(53936002)(6116002)(3846002)(229853002)(81156014)(66446008)(2906002)(6512007)(6486002)(66476007)(4326008)(2501003)(81166006)(8676002)(6246003)(6306002)(6436002)(5660300002)(8936002)(15650500001)(966005)(14444005)(186003)(66066001)(52116002)(76176011)(256004)(14454004)(26005)(31696002)(7736002)(66946007)(305945005)(66556008)(71200400001)(64756008)(476003)(2616005)(486006)(478600001)(316002)(446003)(11346002)(102836004)(7416002)(110136005)(6506007)(71190400001)(99286004)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1374;H:MWHPR11MB1662.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KICwnLLISOxrOv/0JEy2xHyajJhufVGsGsO8qRvqnCCU10roIs47seYEi/V9BCptrrSyhNK6OIJRapeSIP67WY2h4e8TqVPnyn2Bro1otWx0ZJy6wgEeZXRXo05R3I7GY+sU+2fmvxIYxhkv3xMFWSxHb4mgXGYjDKkty0la0YVDKfxe03T46YxKdrejsZRCdIE9qRqEntk/Qtt6WzHonvfpjX0o0OBqb53d6rxoBNTuxVAVBUurJlw4r/HD69PI8J0GrozL7fFLOE38Xx3RDdztmmvQHWK5EltE3Y05thzl7q3ku/7m6sWLFPkTLwqm/1DOPkUEv2U6tMRPkXoQBTTYdStH87TqudadYOsnKOw9E+5496gp3Ns8ZRm+ni5iK0KtY9OWPVqws7+UCpTtp82YSlH7SfrnzflMLUF9ApM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <44B36E30E59D7841828B2F7738A2E610@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 167aa7df-a634-4e92-2da0-08d725578907
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 10:16:58.9305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 90njDbk/ipZduyIUYuv7+WpfMOHEdh/Xr6IZsEBclylYmtnHoEwc3ZIuznS/4mOV3/VmC/alzFLxzz7abWkQLSbPNArIbiZ8R8evW9J4KTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1374
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/08/2019 at 11:10, Andreas Schwab wrote:
> External E-Mail
>=20
>=20
> On Aug 13 2019, Paul Walmsley <paul.walmsley@sifive.com> wrote:
>=20
>> Dave, Nicolas,
>>
>> On Mon, 22 Jul 2019, Yash Shah wrote:
>>
>>> On Fri, Jul 19, 2019 at 5:36 PM <Nicolas.Ferre@microchip.com> wrote:
>>>>
>>>> On 19/07/2019 at 13:10, Yash Shah wrote:
>>>>> Update the compatibility string for SiFive FU540-C000 as per the new
>>>>> string updated in the binding doc.
>>>>> Reference: https://lkml.org/lkml/2019/7/17/200
>>>>
>>>> Maybe referring to lore.kernel.org is better:
>>>> https://lore.kernel.org/netdev/CAJ2_jOFEVZQat0Yprg4hem4jRrqkB72FKSeQj4=
p8P5KA-+rgww@mail.gmail.com/
>>>
>>> Sure. Will keep that in mind for future reference.
>>>
>>>>
>>>>> Signed-off-by: Yash Shah <yash.shah@sifive.com>
>>>>
>>>> Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
>>>
>>> Thanks.
>>
>> Am assuming you'll pick this up for the -net tree for v5.4-rc1 or earlie=
r.
>> If not, please let us know.
>=20
> This is still missing in v5.4-rc5, which means that networking is broken.

Andreas, Paul,

The patchwork state for the 2 first patches of this series is "Changes=20
Requested". It's probably due to my advice of using lore.kernel.org (or=20
something else).

I'm perfectly fine in accepting the patches are they are today but can't=20
change their patchwork state myself. We would need Dave or Jakub to take=20
them.

Dave, Jakub,

All tags are collected in patchwork and all should be fine on DT (Rob)=20
side as well.
Please tell me if you're waiting some sign from me.

Best regards,
--=20
Nicolas Ferre
