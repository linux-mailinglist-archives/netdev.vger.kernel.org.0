Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1754B4B20E8
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348013AbiBKJDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:03:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346113AbiBKJDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:03:06 -0500
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40103.outbound.protection.outlook.com [40.107.4.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2B8B33
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 01:03:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oHYVuoTOln0AstzP+ZRiRGza4LpBU2ag2WnRlU8oqcF5qdndsOOC9muPYAQ8kANFrtlonllmt4I5Np9FcypnQQPn3YdwgXe7fqrSa2H0iGbBR+0cIRGDj+WUP40ncLFXedQh4ACdJTWTzD0TozUSdUVAreYM4jWPIps1ctU2rt5IW86SQQeFi97Z+oh+EWHMuaKbrtRyKke7pZphqxOVtnN4Qw3Mzi75urI2vXMNApH/v2HYWy/3JrI5h9R5LhzKqZIp7kfnf5zetH+DTU4gdT8wEQ5RIfiBDc2W8I0LpdvbaICRYIqXYiEjh8s02K7oI0KrzL2U6zv/EFIBfqzwyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nZlwIJKt1tyzwCMN6vQBOHq2cDUim0vEPiYhwWJM9gE=;
 b=KHF980v8O8Z2b25vEQVeODlmvJxN8zpE4m1yLCKFZHZyPsgshxHOINckB7zqVnzFzWVHsC+z4Ai0GnUsqw8sZmm24Y5HeTjhIe4jj8XKlg4xa+7gTeVlxja4U9E8bQJcZeAyOXY5pINOX5d/8mp7m8HIDjZSOI0ehfSjT61sMKrvxcnmQ/IcoLzI+VnEcbGPDQ8Y5ctqUvs3QmSBp+weL2JbJFOruRxpkGsSwU7k6onbF9+7m4nRJ5py4PtizFx7BIiUcsmK9XHZxD61khRHv/mFg9SjL75rtcvd8y46HkjIvr0sVd/3MWg4oxuYkioQV1htC6Z/B6WEObi0D0OusQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZlwIJKt1tyzwCMN6vQBOHq2cDUim0vEPiYhwWJM9gE=;
 b=l/TWfkQQ+gVUl/bxcYmj7Bcb2T8nHXqHU+j/WFOxTfRuwZwhuWBsGiN9A92F2y8R/ukU9euf73Qw3fO/2W3meP4tnm/9/bV6IrBJ9S66GMieBN6KiQfj4GdZvHoDY4eYWxd2Jnypc9BzIV5CLf+bVUTUn0j5jJ6CEVM+LjYQz8I=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by VI1PR0302MB2717.eurprd03.prod.outlook.com (2603:10a6:800:e1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Fri, 11 Feb
 2022 09:03:02 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7%4]) with mapi id 15.20.4975.015; Fri, 11 Feb 2022
 09:03:02 +0000
From:   =?windows-1254?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?windows-1254?Q?Ar=FDn=E7_=DCNAL?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: rtl8365mb: irq with
 realtek-mdio
Thread-Topic: [PATCH net-next] net: dsa: realtek: rtl8365mb: irq with
 realtek-mdio
Thread-Index: AQHYHgbWVDJfLkKf9Uu9wAYrnUi8JQ==
Date:   Fri, 11 Feb 2022 09:03:02 +0000
Message-ID: <87k0e1wzay.fsf@bang-olufsen.dk>
References: <20220209224538.9028-1-luizluca@gmail.com>
        <4b53b688-3769-c378-ec35-3286b3229303@gmail.com>
        <CAJq09z7QJ9qXteGMFCjYOVanu7iAP6aNO3=5a8cjYMAe+7TQfQ@mail.gmail.com>
        <878ruil1ud.fsf@bang-olufsen.dk>
        <CAJq09z7Hu-dswU41km=L2YFbKyHUJ9JkDjUGwQN5RQqowY0=1A@mail.gmail.com>
In-Reply-To: <CAJq09z7Hu-dswU41km=L2YFbKyHUJ9JkDjUGwQN5RQqowY0=1A@mail.gmail.com>       (Luiz
 Angelo Daros de Luca's message of "Fri, 11 Feb 2022 01:51:16   -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d46994f8-9442-498c-b898-08d9ed3d4f05
x-ms-traffictypediagnostic: VI1PR0302MB2717:EE_
x-microsoft-antispam-prvs: <VI1PR0302MB271738513C0EBBB0DCFD270B83309@VI1PR0302MB2717.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JAmDTWVOHDydIeR+zfE9B6IfOG4sAK8skfsUoy5r0WKBy8NYp713+ORU30hMmcug7ScD8w3H4YDvKvxmozMkgmJK4jxwtVmOVVpaCI1ONt9/LfufkI69dJpz0vULcWi8A+H4DYRqwnQu7ZQ4WSTfOm29YcL+Vu/dwEyRAN3Y1M9WykUP0xIOvlVa5McNBe5ReHa9cY5Dm80w3AGe8e1UNNb2guhBohUNN7kfu7FMld5Cl8caahrobv43SlzhjEJLIabUDawRV4PECpsE01ffY2kRUQiQ4UPX2EF8JRk5yVN0zRlJoGXCXb4HvdoKxre04WMuf7qZCpyNJ02BDrdMXDm4PPRS8xQYMupDn27XFkPliuUKyA0r2q/OrTfxXZVSYHNbC4nL33tqgqKVxnzw+s8lEWnAmuuI38msTdHCTXpyk3q4eja6+cZf7+STOYQ4xIK0e59a93wBSgmNVkq1kAKS1Fbnyz0HTjyQXpBqMSsfVscRfo0P6sKR8523i7YOZ1D4mDwEEpAZW0Pn1lOAmbLzJiUXrXQ61AkCKmoFu2g6+jYtYB822Vu+SEWLbDhM+TaKXtKXhgkM4vuJenjlOaNfgW/9rtLb+2MYMuQ6l2rPsBHzMDoIRB4BhFnF3RmHNrXuVvcZib/HFWbQA9vOFOD6EA4wJhc5gcJL7PpLLX3NN3/6x532PoSwkpfuvdPbtjipvatd+HwaaUm5XaEZkA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(91956017)(8936002)(76116006)(508600001)(36756003)(316002)(38100700002)(66946007)(8976002)(66556008)(6506007)(54906003)(6916009)(71200400001)(5660300002)(6486002)(66476007)(66446008)(64756008)(8676002)(122000001)(4326008)(7416002)(2906002)(6512007)(2616005)(83380400001)(86362001)(26005)(186003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?windows-1254?Q?UDHeLIdbyKJ+t0TKTs+iB/9fFZ6szHYlnZ/sHOCl4PF7vF1hkhUcqUB/?=
 =?windows-1254?Q?dBzp2WJXSHunYgSOxDB6RtR5cyQ65z+lRcIcvQKh2oES6ISXdNu7cs3m?=
 =?windows-1254?Q?q3NZoOFEAakd9gwhiJcKR/oq6Vy4UQ0yPQiahhJ/pqdK+FA3ogcL3+9G?=
 =?windows-1254?Q?AcvSvHmOW9hZQVcbKsnJv2dooUP3mNbEeSATnrlHtN4alOfCxYA6bVlc?=
 =?windows-1254?Q?vUJTi4dN5A93vHVxtaM8zoR/QphwCwwq2KEdjg3OayeD/e1bqyGiOrWJ?=
 =?windows-1254?Q?UR9Y7LLhY46/CW2odEEFGzppmdg2LDnQJR71nLQD5PGugwY+ea1nTH2N?=
 =?windows-1254?Q?Ad5dAY+028sTSV8MUr+UA3w7IFql1lBVGlJay/2KFhEJlIwj4z/pqeZH?=
 =?windows-1254?Q?+2kkVzjA1c0nccFS/Sqh0Bzp9F9ZFQDDRwqK60HoFen2SkApCasq1DM9?=
 =?windows-1254?Q?XOaKfz2xK+TYqa6pD6WAKH8Q5T3+ziaDsHdkxxjAxoW1kPpTbNCxtXZM?=
 =?windows-1254?Q?tCw3QMLHZDcVKJbKF/XGvDNiuTMkyMP/YnG+rltsKyEtYPEquc+SQAPD?=
 =?windows-1254?Q?FtJ1h4gEsgCJYcooNbJw2x7aAuKXuR53ayjJNbUyfEBXZ7uzNMUsS1L0?=
 =?windows-1254?Q?it7iY/PHiELlkPnhq1s79grnvOu076E+01x571puxCb874lsAcIqyuh9?=
 =?windows-1254?Q?93r71t3FSpxNb+EegbVPCs2NFZXQQNIHOzDccIQajDRPEsd2Zi9tr9F1?=
 =?windows-1254?Q?/cc8c4LbvIqhGCroY5Co1Zoi33zzclPcAVT5ECD0zrbK/X+Slj75X3a/?=
 =?windows-1254?Q?XxUTPaaVHQ1foVw9t6k1sBPkAyTIp8CbEnRuZ/A5MBbBDJKr6eTDMYOc?=
 =?windows-1254?Q?mbGl3pTB4LhKDLU/ioTzz80sBk7UJeVwB8+HcT5UKiyiBnAkdsW+drLX?=
 =?windows-1254?Q?yhF8aEZdjGRAKilbqjM8oFFh2I11Kc5RFHAk8sY5ZPYuSQIo4kymkN7s?=
 =?windows-1254?Q?XCQYTyW3zUQOI2YT0jo6t2qw0hmE1y76/VMdkigLe6Lgh+bMndYO2SPK?=
 =?windows-1254?Q?VHowWYzBH5ywlSXuiHb+KVYHRFTi/VCz2Mh+TgvXwKAHXzCoOPHEmqLq?=
 =?windows-1254?Q?a5/jZT1VTJUi7mxxE+zdoWZMZ3sibKYhBQo2S2PjrX2b2u+2kMtHcZKH?=
 =?windows-1254?Q?jnsuatoRseZ+h4jYBu3F/Us90NE3Zzv9fG7s9iIPCKyJd+hsoNVr3xN+?=
 =?windows-1254?Q?hwBufp81t1vVolO2pNolLl49DiL5nzpM33Vpw3GwknJRM7F6+PP5XFYS?=
 =?windows-1254?Q?HZ1NuJCiM923j2wIFqL+ajHtQiqWYkD7Bj/BBxBxhNSmtmvNXxK/App7?=
 =?windows-1254?Q?3CRADchgDTZ/FtXA0i3SePMrUm3xb16G4XP4eCxCTXzUvoLOMjQ7fN/z?=
 =?windows-1254?Q?QEr6QOtq+hqZoZDIaHQAv2d64XbkJR66FCung/MnWbdlXdB12WuV63lv?=
 =?windows-1254?Q?E9alSO36RKJ5mDxc7vHUBKcqHLOHLzkvr1j4xiNXg0ERf5xTpMoMXey1?=
 =?windows-1254?Q?7LFO4VcfXFt7b0CGAHJ7/7GrgdvDtdrYa53TLUKBtRHLrAXv04XAKxUO?=
 =?windows-1254?Q?9RPWLGfa4Zxa7HNaVidHCfQYCOlw7iH8VB+Xyvo/+TXgxFiDwolPjWeG?=
 =?windows-1254?Q?jHh6iTeNXPoY7f3xu4Mvvl3boYEXgx5SbfxT9ICATadyrEyvvpw7nbin?=
 =?windows-1254?Q?tE8HVz5hEFSobET/yqs=3D?=
Content-Type: text/plain; charset="windows-1254"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d46994f8-9442-498c-b898-08d9ed3d4f05
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 09:03:02.3261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +HcnRUjKIUKx4Gud6MFZa9gUPKSHszqQ8yVW8fQVGLZe4DDr7b8Of3c638eCcK+8Ie/pQjx1XUmetyoL6DDB5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2717
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

Luiz Angelo Daros de Luca <luizluca@gmail.com> writes:

> Thanks Alvin,
>
>> > As far as I know, for supported models, yes. I'm not sure about models
>> > rtl8363nb and rtl8364nb because they have only 2 user ports at 1 and
>> > 3.
>> > Anyway, they are not supported yet.
>>
>> I think the port number as defined in the device tree is always going to
>> be the same as its PHY address on the internal bus. I had a look at the
>> Realtek code and this seems to be the assumption there too.
>
> One of the realtek-smi.txt examples (that I also copied to
> realtek.yaml) does not respect that:
>
> phy4: phy@4 {
>    reg =3D <4>;
>    interrupt-parent =3D <&switch_intc>;
>    interrupts =3D <12>;
> };
>
> I don't know if 12 is a typo here.

Oh sorry, I thought we were talking about the rtl8365mb driver and the
family it supports. I did not check datasheets for RTL8366RB and
such. My statement was only regarding switches supported by the '65mb
driver, where I still believe this is the case based on my reading of
the Realtek vendor code.

>
> It would only matter if I do create a default association when the
> specific device tree-entry is missing. It wasn't supposed to
> completely remove the device-tree declaration but to make it optional.
> For now, I'll put this option aside.
>
>> >> We could also change the DSA framework's way of creating the
>> >> MDIO bus so as to be OF-aware.
>
> It worked like a charm. I'll send it in reply to this email. I still
> have some questions about it.
>
>> We are not the only ones doing this. mv88e6xxx is another example. So
>> Florian's suggestion seems like a good one, but we should be careful to
>> maintain compatibility with older device trees. In some cases it is
>> based on child node name (e.g. "mdio"), in others it is based on the
>> child node compatible string (e.g. "realtek,smi-mdio",
>> "marvell,mv88e6xxx-mdio-external").
>
> The name "mdio" seems to be the de facto name. I'll use it. However,
> it might be confusing with mdio-connected switches as you'll have an
> mdio inside a switch inside another mdio. But it is exactly what it
> is.
>
> It would not affect drivers that are already allocating slave_mii_bus
> by themselves. If the driver is fine with that, that's the end of the
> case.
>
> However, if a driver doesn't need any special properties inside the
> mdio node, it might want to migrate to the default dsa slave_mii_bus.
> For those already using "mdio" node name, they just need to drop their
> code and move phy_read/write to dsa_switch_ops. Now, those using
> different node names (like when they check the compatible strings)
> will have a little more job. I believe we cannot rename a node "on the
> fly". So, if the matched node name is not mdio, they still need to
> allocate the slave_mii_bus. They will also need a different
> dsa_switch_ops for each case because dsa_switch_ops->phy_read cannot
> coexist with an externally allocated slave_mii_bus. Each driver needs
> to plan their own migration path if they want to migrate.
>
> For realtek-smi, the code does not require the node to be named "mdio"
> but doc "realtek-smi.txt" and my new "realtek.yaml" does require it.

The fact that the required property is documented as "mdio" probably
lets us do away with the compatible string parsing and switch to a
generic implementation in the realtek drivers - although I'm no device
tree lawyer, so I could be wrong here. I agree with your analysis.

> If I assume that, I could simply drop the code and migrate to
> read/write to dsa_switch_ops.
> If not, we need to maintain both code paths and warn the user for a
> couple of releases until we drop the compatible string match.
>
>> > If possible, I would like to define safe default values (like assuming
>> > 1:1 mapping between the port number and its PHY address) for this
>> > driver when interrupt-controller is present but
>> > slave_mii_bus node is missing.
>>
>> You could just require the phy nodes to be described in the device
>> tree. Then you don't need this extra port_setup code. Seems better IMO,
>> or am I missing something?
>
> Upstream devs seem to prefer more code than more device-tree confs. I
> just wanted to reduce some device-tree copy/paste. I'm ok with using a
> device-tree node.

Do you have an example of such a statement from an upstream dev? I am
asking for my own education :-)

If we require an mdio node to begin with it also obviates the whole
discussion about 1:1 mapping between DSA port number and PHY address.

Kind regards,
Alvin=
