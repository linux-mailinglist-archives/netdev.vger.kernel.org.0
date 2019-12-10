Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D01A9118615
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfLJLVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:21:15 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:4832 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726915AbfLJLVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:21:15 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBABJxpq003666;
        Tue, 10 Dec 2019 03:20:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=KhlpuN0gOXjq0+go7NF9VrQfM7JI74RK71Mx9tVwiww=;
 b=BBs3f4CHFtaFpQClOgO/uDi3yh7c5mT0U4/tIqLWkcKEac27Q5xUiw1wXj5qV/6XTwhF
 kRtUIjr/ikZL2Nwy7ELexU4kFITx5a2p18KtzVROTsoY4S3JbP9ZO7GvIvyEmSBgVkTb
 BWYwvVodGnOE3+o/oL+6iOX8VtpDGfUfpnUZosog2qdcYaJ1GQsUiRTp62/NZPc4hJWc
 i0UF8zLO20ckUzL30W9rdPFAXSMPS0TlAg7AWZpX1rS7F3SmzMDDhQab4S9OkCQhJ59c
 Y+A7NZpSeoiCwFWS8r0+rl0ZdtyZ+qBLnd6yY7lDd13KliOfVmHi9TcLwp3jr3w/1qRf Xg== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2wr9dfhkh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Dec 2019 03:20:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xwg5jwacKFgWvNSGj9DnawhGoZOA8VWX3bqXBRFR086ZY9ho5Iq6gJZhqCWPtwJQsRnQeTbebDMyfvyNMNOMd93upH0eSjIzDLcdRsMJGmUV5p7MV0V8+A06XwfA2skNjsVlZiiHvlsiVICL0N4hwCtSzY5+cIA4UDjPIQ99GiLlapAKmZ89tSTo/hbtqPYlTm3f9hpDyrHEcR5uJF8iwg1ID2pvCTn8XWjVjmYTPur1W5XD7JhifUTj6D0Y6yWHKoYNIoOGQjokii2ixykBq49aSl0je2p/rpw/jpnAzvta/L/uj/sWZQHGUVnWC8I7H3uPjS/ogf2KY97S8CMN7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhlpuN0gOXjq0+go7NF9VrQfM7JI74RK71Mx9tVwiww=;
 b=ZspR3MIEg1ZT9SOZGhRK/i9r27PQL9ein6a/2M6sEV3DCnSn/Uz8BVtO+QHwlGpMeQnpZmDZTHx6WSsF+VlvKHU9MhLCjtAT5xW0KFDpllUQvErkvRdh+V6kKvnqpXj2gNCvyQqih7hAmKx7B3q0WdKhlMB1Qqdj/l25VSU4afK5sq7JLF2A6s4DzAwH+R6YfZr9EfNnscWDFmGI9dy5n3V4f42DVaiuPxGEyArBHx91WWz4uAhBlebLksydizUPT+qE9WB32Dhq5efOibZMIzCajr8HieE81iOjaH2+36+M38tz4tW9B03dgodshb4TmjwlDU6vvT0F8FhVUyss8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhlpuN0gOXjq0+go7NF9VrQfM7JI74RK71Mx9tVwiww=;
 b=naCEvgoPtv6fpZ5zxo1/FGtch6NJgUkGlRbiqStUhewstzAmR4xuSd95U20H6XJkdRfaXOH+nE+l2KBYP7RKHVqLCXNDbdsY1cSC8oX2W3m5F673HOzNXhE2HsCuB88at0wN2St7qUzF+O8xWUOabcg2JmBRV5Wp0qvk1jbjl68=
Received: from BY5PR07MB6514.namprd07.prod.outlook.com (10.255.137.27) by
 BY5PR07MB6871.namprd07.prod.outlook.com (52.133.248.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Tue, 10 Dec 2019 11:20:38 +0000
Received: from BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7]) by BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7%5]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 11:20:38 +0000
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
Subject: RE: [PATCH 3/3] net: macb: add support for high speed interface
Thread-Topic: [PATCH 3/3] net: macb: add support for high speed interface
Thread-Index: AQHVroIXac2qRLU0l0+QWTJxCA7dLKexrKsAgAF+vXA=
Date:   Tue, 10 Dec 2019 11:20:38 +0000
Message-ID: <BY5PR07MB651448607BAF87DC9C60F2AFD35B0@BY5PR07MB6514.namprd07.prod.outlook.com>
References: <1575890033-23846-1-git-send-email-mparab@cadence.com>
 <1575890176-25630-1-git-send-email-mparab@cadence.com>
 <20191209113606.GF25745@shell.armlinux.org.uk>
In-Reply-To: <20191209113606.GF25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbXBhcmFiXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctMTVlOTk1NTUtMWIzZi0xMWVhLWFlY2EtZDhmMmNhNGQyNWFhXGFtZS10ZXN0XDE1ZTk5NTU2LTFiM2YtMTFlYS1hZWNhLWQ4ZjJjYTRkMjVhYWJvZHkudHh0IiBzej0iMjIyNSIgdD0iMTMyMjA0NTA0MzYzMTI5MjQzIiBoPSJpQlZ4Tm1yb0xwQ3BnZkZnem5WZ2pDeGdtLzg9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3b3cda7-382f-466d-c3da-08d77d62fc48
x-ms-traffictypediagnostic: BY5PR07MB6871:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR07MB6871D69F945F5743CBB55BEAD35B0@BY5PR07MB6871.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(36092001)(199004)(189003)(33656002)(4326008)(81166006)(81156014)(107886003)(8676002)(9686003)(55016002)(7416002)(6916009)(8936002)(2906002)(64756008)(66446008)(66476007)(26005)(66946007)(186003)(5660300002)(66556008)(55236004)(6506007)(76116006)(86362001)(54906003)(478600001)(316002)(7696005)(52536014)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB6871;H:BY5PR07MB6514.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wsk4+mbXPLaAv1OxHc2MLKZnjhhdT+dRgZ5tbZPtZLa+F3Eqg8foVJclWjjHUk5w4WoIZt5t5M3W6OfQy6EzGyYtdbRwvVO/riugaIA2YZ9Akx2Tv+muV7uNdplRQRwtDbPBuwQPas1QdqVqCu15i8uNSVzycJnjHkyP83JTl9k+/8en/5RCcyBUiWTZ4J2Mfzk5n6NJ4AMZjgQEf13UEwK1ioxSRxYXHqM4BQXd2aQqWE7ypKER0mbICVZ7eYI2cVvv1D/CVAtR9H3qwXzR2PxrSqO6bT3c0+qJw2pUDvU+4ftKAv198LBE3xJMsE68RRcuo3nfeDX54OG1V5DoCtPKO0RQxeom9bur+a41J0vjGIUi52GRLGOZSjpEP0twuSzowxXZRgFpu5jj00uuVjzMl2MGQgTrGHsyDDh4zPp2Q6c0j/cJDLYyeyhFBWBzG/V5vSZr8quk6OQ4w9qmFOzhhrrNezpHGXgEcqqLM7cIaGCQuJMO7cw+tKF9Znyl
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3b3cda7-382f-466d-c3da-08d77d62fc48
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 11:20:38.8059
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r3pBSuWFnmBUXLOmIKkNgpcKENCNQ0yTDbvAP41iv/uZKbFklnusjSu9/vh6P/yQl2ZCkq8JpfGzEx99icfu+rDBwmiv6veQyVKM0gHkdm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB6871
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_02:2019-12-10,2019-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=986
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912100101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> This patch add support for high speed USXGMII PCS and 10G
>> speed in Cadence ethernet controller driver.
>
>How has this been tested?
>

This patch is tested in 10G fixed mode on SFP+ module.=20

In our own lab, we have various hardware test platforms supporting SGMII (t=
hrough a TI PHY and another build that connects to a Marvell 1G PHY), GMII =
(through a Marvell PHY), 10GBASE-R (direct connection to SFP+), USXGMII (cu=
rrently we can emulate this using an SFP+ connection from/to our own hardwa=
re)

>> @@ -81,6 +81,18 @@ struct sifive_fu540_macb_mgmt {
>>  #define MACB_WOL_HAS_MAGIC_PACKET	(0x1 << 0)
>>  #define MACB_WOL_ENABLED		(0x1 << 1)
>>
>> +enum {
>> +	HS_MAC_SPEED_100M,
>> +	HS_MAC_SPEED_1000M,
>> +	HS_MAC_SPEED_2500M,
>> +	HS_MAC_SPEED_5000M,
>> +	HS_MAC_SPEED_10000M,
>
>Are these chip register definitions?  Shouldn't you be relying on fixed
>values for these, rather than their position in an enumerated list?
>
Okay, yes it is safe to use fixed values instead of enum. I will change thi=
s.

>
>> +	gem_writel(bp, USX_CONTROL, config | GEM_BIT(TX_EN));
>> +	config =3D gem_readl(bp, USX_CONTROL);
>> +	gem_writel(bp, USX_CONTROL, config | GEM_BIT(SIGNAL_OK));
>> +	ret =3D readx_poll_timeout(GEM_READ_USX_STATUS, bp, val,
>> +				 val & GEM_BIT(USX_BLOCK_LOCK),
>> +				 1, MACB_USX_BLOCK_LOCK_TIMEOUT);
>
>What if there's no signal to lock on to?  That's treated as link down
>and is not a failure.
>
Yes, if there is no signal to lock on, that is treated as link down.
Is this okay or should there be some additional error handling needed?

>> +
>> +	switch (state->speed) {
>> +	case SPEED_10000:
>> +		speed =3D HS_MAC_SPEED_10000M;
>> +		break;
>> +	case SPEED_5000:
>> +		speed =3D HS_MAC_SPEED_5000M;
>> +		break;
>> +	case SPEED_2500:
>> +		speed =3D HS_MAC_SPEED_2500M;
>> +		break;
>> +	case SPEED_1000:
>> +		speed =3D HS_MAC_SPEED_1000M;
>> +		break;
>> +	default:
>> +	case SPEED_100:
>> +		speed =3D HS_MAC_SPEED_100M;
>> +		break;
>> +	}

>So you only support fixed-mode (phy and fixed links) and not in-band
>links here.
>
Yes, this is right.


