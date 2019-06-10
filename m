Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB1F3BDC9
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 22:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389691AbfFJUuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 16:50:03 -0400
Received: from mail-eopbgr60081.outbound.protection.outlook.com ([40.107.6.81]:34477
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389429AbfFJUuD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 16:50:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZ17w6KiquhG6fWhhZl398LFgYMwAjV/i9/BxYAExfE=;
 b=YFg4JsGlreztRJYlRK7jVCn8A2ssZ0kl4vfO//kSXRNljlRVXPBGsg3EoUMP0s1C/cHazOwh7KIFUbC+NPOrM+8XdLdeJg0UAJLbGLAg/TpoQholIiU73tK0//l3Cic95U3odi/BhEXKOTGAUuyb4DhX5lRc5BgohezZ96Rmt34=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2704.eurprd04.prod.outlook.com (10.175.23.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Mon, 10 Jun 2019 20:49:59 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 20:49:59 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     netdev <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: Deal with non-existing PHY/fixed-link
Thread-Topic: [PATCH net-next] net: dsa: Deal with non-existing PHY/fixed-link
Thread-Index: AQHVH8MsxSzXIT7T/0mW4aEu7RtYPg==
Date:   Mon, 10 Jun 2019 20:49:59 +0000
Message-ID: <VI1PR0402MB2800ED1A422B900F63561F9CE0130@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <20190610193150.22231-1-f.fainelli@gmail.com>
 <CA+h21hrcymxF7zk4yHFGhjxbLERTCU6WkfzLGQVoZ5Yxoo4xxw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [188.26.252.192]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0dc24dd-449b-432c-2d96-08d6ede533e1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2704;
x-ms-traffictypediagnostic: VI1PR0402MB2704:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB270430933DCBBF468F835A78E0130@VI1PR0402MB2704.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(376002)(396003)(136003)(346002)(189003)(199004)(110136005)(4326008)(2906002)(54906003)(5660300002)(26005)(66446008)(53936002)(73956011)(76116006)(186003)(66476007)(66556008)(52536014)(8936002)(66946007)(33656002)(66066001)(25786009)(229853002)(8676002)(44832011)(74316002)(64756008)(446003)(486006)(476003)(6306002)(86362001)(71200400001)(55016002)(305945005)(14454004)(9686003)(71190400001)(966005)(81166006)(99286004)(7736002)(6436002)(316002)(81156014)(6116002)(6246003)(102836004)(5024004)(478600001)(7696005)(6506007)(14444005)(256004)(68736007)(53546011)(76176011)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2704;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Z/UG3kVJ1C7NMc5VXRxwLrgoPhrIQG4BShjyFA1lkdBM3m4zcqzWC8GEyqDEUQkEbGGUOreKIh18kz3vw2+zycyP/5kPc7AtQFRQiL0Jj+R7hWpd2JabavAdZ2QNvpBhWHGFAJMnORzjo3PecgQIuXLsJ8hV3Jaytu7idYL2KgMO+qOeEWo8+h/53N/Hl6gNgkDeHxMUs1aLbg0hUr7TVh5/xuAebIlIBpeyn3bbCSVXysvcIr/5o5iJ3/yCSPSUiKxWp/xEm1+fdtaofYLw/CYbSdsDl0+Jfdo9CJfwh+yyzSsx5R2k5uJyrHWo9EZKGTJDZG8y1QL+WdUkwZvRv2ky53m90D7jbuuJqk8IUhZUq90TLOwhq/CxVp8eDapM4nFyTrPht5+JcS4wv+HtVswNvasuKmJuLyI1MtOuUxA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0dc24dd-449b-432c-2d96-08d6ede533e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 20:49:59.1741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2704
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/19 10:53 PM, Vladimir Oltean wrote:=0A=
> On Mon, 10 Jun 2019 at 22:31, Florian Fainelli <f.fainelli@gmail.com> wro=
te:=0A=
>>=0A=
>> We need to specifically deal with phylink_of_phy_connect() returning=0A=
>> -ENODEV, because this can happen when a CPU/DSA port does connect=0A=
>> neither to a PHY, nor has a fixed-link property. This is a valid use=0A=
>> case that is permitted by the binding and indicates to the switch:=0A=
>> auto-configure port with maximum capabilities.=0A=
>>=0A=
>> Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")=0A=
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>=0A=
>> ---=0A=
>>   net/dsa/port.c | 2 +-=0A=
>>   1 file changed, 1 insertion(+), 1 deletion(-)=0A=
>>=0A=
>> diff --git a/net/dsa/port.c b/net/dsa/port.c=0A=
>> index d74bc9df1359..dde3085ff065 100644=0A=
>> --- a/net/dsa/port.c=0A=
>> +++ b/net/dsa/port.c=0A=
>> @@ -622,7 +622,7 @@ static int dsa_port_phylink_register(struct dsa_port=
 *dp)=0A=
>>          }=0A=
>>=0A=
>>          err =3D phylink_of_phy_connect(dp->pl, port_dn, 0);=0A=
>> -       if (err) {=0A=
>> +       if (err && err !=3D -ENODEV) {=0A=
>>                  pr_err("could not attach to PHY: %d\n", err);=0A=
>>                  goto err_phy_connect;=0A=
>>          }=0A=
>> --=0A=
>> 2.17.1=0A=
>>=0A=
> =0A=
> Hi Florian,=0A=
> =0A=
> Can you give an example of when this is a valid use case, and why=0A=
> fixed-link is not appropriate?=0A=
> =0A=
> Regards,=0A=
> -Vladimir=0A=
> =0A=
=0A=
Hi,=0A=
=0A=
This reminds me of a previous discussion on what to do when the DSA CPU =0A=
port does not have a device_tree node at all: =0A=
https://www.spinics.net/lists/netdev/msg573554.html.=0A=
=0A=
This was the case of the dsa-loop driver that probes as a platform =0A=
device. I'm still not clear how the PHYLINK callbacks are supposed to =0A=
work in that case though.=0A=
=0A=
--=0A=
Ioana=0A=
=0A=
=0A=
