Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4175711833F
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 10:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfLJJOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 04:14:48 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:44684 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726911AbfLJJOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 04:14:47 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBA9DMDl031529;
        Tue, 10 Dec 2019 01:14:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=Xw2BqGo06erCyWyTKU4c4ThwMo25WjfgWD3R3glqax4=;
 b=FjBGndlM8cKgq7fxWUzvS3tLYfbykn5iUatrWRZPuBIW7ibRe+azUytqPlrjG4iHl1nc
 L/qC/y1Y5AaWELmDZIOVuFqV9+ZNwtsse5LTa1YfBYDs2/4ajbz17tOvQHZ2TuAqKtL0
 zmlkKa5zwpJNSxbBWdC5sjfaCTXGYtTrVCD4Z0yklMOtaYVPJ8wib104K7v40yQzVNRO
 tVb3W+yMTI702xiL8S0Kr6g5WCgiPqimJIhZAJ01aopgMgZ0bKmmdzdwFpZyalOVUdt6
 ur6os00z2+9b1FoZBJXZ7oj0VU4r/2/ji0cnn5UXK33lZyNMhxKLsRyjRmgJ76NLg7ds xw== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2050.outbound.protection.outlook.com [104.47.36.50])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2wra7095s6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Dec 2019 01:14:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIvGzFIjb7ifz+zDJj8ZPccK/NnpIiMkebMvqlTw1D4ReZj0suAccORzSCSebXCPF9J/ZKPEdv2kEiGXaTgWlglVagRI1g5rbcDe2zQFXTjq+GHOv1rlgWjrhBgyjEnNfRrvcmwjE0hKUWdqtpHSX3XSit6bf5TFV341bpn1tTKh8FCVrFE9TZjmTPKODL6w+j7VDGGx/07rwxi9F4Kj6aJnbVA6/6jQbIiCaFY25R04yw5FfUPsiHcLCzSWfWYRd5nhHqSO97Dj1zIo7gBOZzO5JmYbi+tqC2h3ubZCsAaEA6MBUzp7pNwqUAWru6Vc9JcJEXORdif7BtFYwadnnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xw2BqGo06erCyWyTKU4c4ThwMo25WjfgWD3R3glqax4=;
 b=Fmkfg50oA3FLXkTX7nMTsSb8enhHuQPxad7uySbjLdGRCYLWlMGk0CMpJsYBOiJPJr2liN6dMim8xEROXf+ZD8UaQJ/ivTv7xV/49gPwgEuv6wqAbJF15W/OFoQAXmwqxVTg35EK3uajqbGBUNQtcZzWvy7BVDDBKB/F0NRateGInIMI1NG+wEakSMJXuGuYkD+vrQgqvgmr4xGXCYgogqNJv6GYonNTd0SITGkaNgKcyXIs57QUydQCHsSmQGl/60FldKdAqqszuFu6h45EIIMYATAkacgmLgVlBZdG3l+4EFgWwbU69rvZwDUjWvSwhS9Q3MP3+3Si4EXLJuupMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xw2BqGo06erCyWyTKU4c4ThwMo25WjfgWD3R3glqax4=;
 b=esFArWjYmenQWLfy/URdruAbPTMNhZMYAaipoLli5Rtx9ryhVZe6B542txN59BmKAqxSJaJqqXhVX3/u9qtkPTDe1vxmPd1xadI15ZYBIvUgwL+PAHymBO3avTlsi1FRRuz1gdm/3i0QKofwmFxoaYtYYhPPcbWZcxME+hF0+Pw=
Received: from BY5PR07MB6514.namprd07.prod.outlook.com (10.255.137.27) by
 BY5PR07MB6771.namprd07.prod.outlook.com (10.255.154.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Tue, 10 Dec 2019 09:14:14 +0000
Received: from BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7]) by BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7%5]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 09:14:13 +0000
From:   Milind Parab <mparab@cadence.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "nicolas.nerre@microchip.com" <nicolas.nerre@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dhananjay Vilasrao Kangude <dkangude@cadence.com>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "brad.mouring@ni.com" <brad.mouring@ni.com>,
        Parshuram Raju Thombare <pthombar@cadence.com>
Subject: RE: [PATCH 1/3] net: macb: fix for fixed-link mode
Thread-Topic: [PATCH 1/3] net: macb: fix for fixed-link mode
Thread-Index: AQHVroHjmY6JAv/FqEGIQD/Y0ouad6exqeuAgAFq7JA=
Date:   Tue, 10 Dec 2019 09:14:13 +0000
Message-ID: <BY5PR07MB6514923C4D3127F43C54FE5ED35B0@BY5PR07MB6514.namprd07.prod.outlook.com>
References: <1575890033-23846-1-git-send-email-mparab@cadence.com>
 <1575890061-24250-1-git-send-email-mparab@cadence.com>
 <20191209112615.GE25745@shell.armlinux.org.uk>
In-Reply-To: <20191209112615.GE25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbXBhcmFiXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctNmQwZmFiZjgtMWIyZC0xMWVhLWFlY2EtZDhmMmNhNGQyNWFhXGFtZS10ZXN0XDZkMGZhYmY5LTFiMmQtMTFlYS1hZWNhLWQ4ZjJjYTRkMjVhYWJvZHkudHh0IiBzej0iNDU2NCIgdD0iMTMyMjA0NDI4NTE1OTg2OTQ5IiBoPSJwcEU3Vk1QdUZsNkREWXZVVmxyemp0MWE2TUE9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b51cccc-61ed-4114-e050-08d77d515336
x-ms-traffictypediagnostic: BY5PR07MB6771:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR07MB677184E8069AEFA0EE736DC8D35B0@BY5PR07MB6771.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(36092001)(199004)(189003)(86362001)(64756008)(478600001)(966005)(4326008)(71190400001)(7696005)(229853002)(107886003)(9686003)(6916009)(81156014)(305945005)(8676002)(7416002)(71200400001)(54906003)(186003)(81166006)(33656002)(55016002)(5660300002)(52536014)(8936002)(66476007)(316002)(66946007)(66446008)(66556008)(6506007)(26005)(55236004)(76116006)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB6771;H:BY5PR07MB6514.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EyEHzDMwfBa3e6sh/os+if7ESnuLI6N/3bfZA8df4YlVplt9T20dBaOnusL3U4DF+pNi18lTzhhk6lWAQeeE13Ocmn/ZOkQdxD4x6EVoxXTsYTLJsRNNKEOeABq9RkJorA8LBjmmcs36cbr92xIG0tRqFDbsx/SqmkpraMf1IQWTZw3AdUQBWnV1QdehlISht9YZl9tk0jtEaJipuDPlpcXkZ5iKVNm2o+uo6mf2lzYC9J3wT6rg+fb1ergcZrVs+hf3sEnhdFuFkXhtySsXPS/l4racxMewB8aLNuZlBLWmp6PEVgICkcZwy/5A7uId8QoJj8eQ1vgclsQCcnQaalgLlzd47bKZTD6EJm3z47sjC1QwTmLzAhjm3kY5ihiMpKG1r+TJYdrAx0k91MkPH+e3UTGcfY+m0d5GHJ2sG43i4DIhQ7nbeZrXamTmbLQp8RWe307hSBGf2Pb6Ml31rW79OpI9PPQZh6GH2uF9LIp5BHLz6knzmmSw1fPM9Y/xUnp3Gho3YecV6SNFY9SDH6dd8tS/ofR/Y71irVN4t9M=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b51cccc-61ed-4114-e050-08d77d515336
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 09:14:13.5954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j3yHP2O2goyPMGOtVL5RtyvuOtN+GMii/rtoSyBv/BgfB9BzJxoaGdK/KPK4Ak5TSYsNOsnb3KMUXWnYZuQ5camzpscfD/w8itoxjcS55fY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB6771
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_01:2019-12-10,2019-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1011 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912100083
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> This patch fix the issue with fixed link. With fixed-link
>> device opening fails due to macb_phylink_connect not
>> handling fixed-link mode, in which case no MAC-PHY connection
>> is needed and phylink_connect return success (0), however
>> in current driver attempt is made to search and connect to
>> PHY even for fixed-link.
>>
>> Signed-off-by: Milind Parab <mparab@cadence.com>
>> ---
>>  drivers/net/ethernet/cadence/macb_main.c | 17 ++++++++---------
>>  1 file changed, 8 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethe=
rnet/cadence/macb_main.c
>> index 9c767ee252ac..6b68ef34ab19 100644
>> --- a/drivers/net/ethernet/cadence/macb_main.c
>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>> @@ -615,17 +615,13 @@ static int macb_phylink_connect(struct macb *bp)
>>  {
>>  	struct net_device *dev =3D bp->dev;
>>  	struct phy_device *phydev;
>> +	struct device_node *dn =3D bp->pdev->dev.of_node;
>>  	int ret;
>>
>> -	if (bp->pdev->dev.of_node &&
>> -	    of_parse_phandle(bp->pdev->dev.of_node, "phy-handle", 0)) {
>> -		ret =3D phylink_of_phy_connect(bp->phylink, bp->pdev-
>>dev.of_node,
>> -					     0);
>> -		if (ret) {
>> -			netdev_err(dev, "Could not attach PHY (%d)\n", ret);
>> -			return ret;
>> -		}
>> -	} else {
>> +	if (dn)
>> +		ret =3D phylink_of_phy_connect(bp->phylink, dn, 0);
>> +
>> +	if (!dn || (ret && !of_parse_phandle(dn, "phy-handle", 0))) {
>
>Hi,
>If of_parse_phandle() returns non-null, the device_node it returns will
>have its reference count increased by one.  That reference needs to be
>put.
>

Okay, as per your suggestion below addition will be okay to store the "phy_=
node" and then of_node_put(phy_node) on error

phy_node =3D of_parse_phandle(dn, "phy-handle", 0);
        if (!dn || (ret && !phy_node)) {
                phydev =3D phy_find_first(bp->mii_bus);
                if (!phydev) {
                        netdev_err(dev, "no PHY found\n");
                        ret =3D -ENXIO;
                        goto phylink_connect_err;
                }

                /* attach the mac to the phy */
                ret =3D phylink_connect_phy(bp->phylink, phydev);
                if (ret) {
                        netdev_err(dev, "Could not attach to PHY (%d)\n", r=
et);
                        goto phylink_connect_err;
                }
        } else if (ret) {
                netdev_err(dev, "Could not attach PHY (%d)\n", ret);
                goto phylink_connect_err;
        }

        phylink_start(bp->phylink);

phylink_connect_err:
        if (phy_node)
                of_node_put(phy_node);

        return ret;

>I assume you're trying to determine whether phylink_of_phy_connect()
>failed because of a missing phy-handle rather than of_phy_attach()
>failing?  Maybe those two failures ought to be distinguished by errno
>return value?

Yes, PHY will be scanned only if phylink_of_phy_connect() returns error due=
 to missing "phy-handle".=20
Currently, phylink_of_phy_connect() returns same error for missing "phy-han=
dle" and of_phy_attach() failure.

>of_phy_attach() may fail due to of_phy_find_device() failing to find
>the PHY, or phy_attach_direct() failing.  We could switch from using
>of_phy_attach(), to using of_phy_find_device() directly so we can then
>propagate phy_attach_direct()'s error code back, rather than losing it.
>That would then leave the case of of_phy_find_device() failure to be
>considered in terms of errno return value.

>>  		phydev =3D phy_find_first(bp->mii_bus);
>>  		if (!phydev) {
>>  			netdev_err(dev, "no PHY found\n");
>> @@ -638,6 +634,9 @@ static int macb_phylink_connect(struct macb *bp)
>>  			netdev_err(dev, "Could not attach to PHY (%d)\n",ret);
>>  			return ret;
>>  		}
>> +	} else if (ret) {
>> +		netdev_err(dev, "Could not attach PHY (%d)\n", ret);
>> +		return ret;
>>  	}
>>
>>  	phylink_start(bp->phylink);
>> --
>> 2.17.1
>>
>>
>--RMK's Patch system: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
>3A__www.armlinux.org.uk_developer_patches_&d=3DDwIBAg&c=3DaUq983L2pue
>2FqKFoP6PGHMJQyoJ7kl3s3GZ-
>_haXqY&r=3DBDdk1JtITE_JJ0519WwqU7IKF80Cw1i55lZOGqv2su8&m=3DblnuaRbic
>V2uF6XaoVuWN0U5yR5cFOzUSAs3ZPlxioU&s=3Drhp71ilc6R4_pmDsY07-
>kLPGbhyoyixXoHF0hMGu4Go&e=3D
>
>FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps
>up
>
>According to speedtest.net: 11.9Mbps down 500kbps up

