Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5B64B67E
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 12:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731566AbfFSKvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 06:51:32 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:60374 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727068AbfFSKvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 06:51:32 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5JAlKOi012197;
        Wed, 19 Jun 2019 03:51:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=ozCHHAm89pQfm0G8+Xx5OX5e5r/H++9yR2BJ7/LQmYU=;
 b=HvyHFV+9N/DxiOr03XmKU/HqZVWCuNdRvgDL3s9SVOW1j9swnhA5lkJ1ctLX0JEcRiCI
 XxN364ZqVSGtgl8PNvOpf7mEoQjrUw/Owyy3/vf85UY5wz0s45ELUFQaeMbtY8oaNHGg
 CTbcLCNmvKvF4Ze/Lcq+6XKDAJ0o/Iyr2zXm2cMuJDa617Qi8zEp/rverEeOxZyLbUsR
 c+LdDSLzGGEfSoFk3ZI/b8RKKUE6WQTL4JuWNYXp1INDXxeLX5HmKgzCBD8861Z6Gc0L
 t/FqFG/GB6wrhg1UWOyLDeEKYgeZCH+bW6OYHsTJYiHmhZcBQPScdZMoWl0pApBHq09p FA== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2052.outbound.protection.outlook.com [104.47.45.52])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t7805axky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 19 Jun 2019 03:51:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozCHHAm89pQfm0G8+Xx5OX5e5r/H++9yR2BJ7/LQmYU=;
 b=l67GNdTo+NBaZVJ7d5bJRAJq5AXC1dyc8pYRnC4t05Za4XLCGFxOL2UQhBV2CVP3/f7K48Nwf3eYDJKnpJG1Tc2hnC080G7Krb0qhX+TeT26O8dAIYpN/zgQ6/vYNmhJ6Q3JjZMjA6LwfZ5ByLj49H0sIemS+y8pLIhIylp/FjQ=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2709.namprd07.prod.outlook.com (10.166.201.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Wed, 19 Jun 2019 10:51:17 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 10:51:17 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: RE: [PATCH v2 1/5] net: macb: add phylink support
Thread-Topic: [PATCH v2 1/5] net: macb: add phylink support
Thread-Index: AQHVJnqxSyv4aJ5aV0ete4tFFi/QV6ais/+AgAAOkpA=
Date:   Wed, 19 Jun 2019 10:51:16 +0000
Message-ID: <CO2PR07MB2469165566F5C46D1A35BF28C1E50@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1560933600-27626-1-git-send-email-pthombar@cadence.com>
 <1560933636-29684-1-git-send-email-pthombar@cadence.com>
 <20190619092213.32fpgehe74qhln5z@shell.armlinux.org.uk>
In-Reply-To: <20190619092213.32fpgehe74qhln5z@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy0yN2MzZmI4My05MjgwLTExZTktODRmOC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcMjdjM2ZiODQtOTI4MC0xMWU5LTg0ZjgtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSI0NjEyIiB0PSIxMzIwNTQxNTA3NDI1MTQ1NjAiIGg9IjltNE1lUGNuOGtYMWswcTYwaTM5RFN5SUhVVT0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed664232-5e0f-40c3-4941-08d6f4a40e47
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2709;
x-ms-traffictypediagnostic: CO2PR07MB2709:
x-microsoft-antispam-prvs: <CO2PR07MB2709289A6C6D127C73A46BF8C1E50@CO2PR07MB2709.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39860400002)(136003)(396003)(36092001)(189003)(199004)(6506007)(229853002)(74316002)(486006)(25786009)(8936002)(316002)(7736002)(71190400001)(3846002)(66066001)(14454004)(64756008)(73956011)(71200400001)(102836004)(476003)(305945005)(8676002)(5024004)(33656002)(256004)(14444005)(2906002)(6116002)(11346002)(81166006)(76116006)(52536014)(54906003)(5660300002)(66476007)(6436002)(55016002)(66446008)(66556008)(66946007)(4326008)(7696005)(78486014)(9686003)(186003)(6246003)(107886003)(81156014)(446003)(26005)(76176011)(508600001)(6916009)(99286004)(68736007)(53936002)(55236004)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2709;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +Cwmpxl/r/p1AN90XAbuk10Yry2tJ0cKbabWqGqqPk5y88Z4TqWtHWMZ0iOE7rcIvwdHurX7lljeGmLzbzohrBR1xL5yxYQQx7fNKr6ZE3XjhSTIQ3i/bexnurUVoh9JzmV6iiFTigbPLiFV39q+Bypw8euKtRd/rxtgti36Te9ctYgQ45sZD9YOWYg/ivAXuSdsoAPlMx65sL1KiyXR7VYElqCT46luth3YRznmLmg6HvNV3iEeiu7jojmz4fyhbd3CvVyOTJKW64sMoKT8Us5qePUZKUm89xz+l8vVVrmvLPdi0KZXWDDRtb3kv3sFJqrWS56ByvZ47H3pwmO9a0slztm89H7SMq9abVKp3A5tJHW8Yb+fwzatNFX1i5zQata3oJBM5QVjmJNsc/+CK2GG0jmhClGIWFymNB2K39s=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed664232-5e0f-40c3-4941-08d6f4a40e47
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 10:51:16.9699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2709
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906190090
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russel,

Thanks for review comments.

>On Wed, Jun 19, 2019 at 09:40:36AM +0100, Parshuram Thombare wrote:
>

>> +	bitmap_and(supported, supported, mask,
>__ETHTOOL_LINK_MODE_MASK_NBITS);
>
>> +	bitmap_and(state->advertising, state->advertising, mask,
>
>> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
>
>
>
>Consider using linkmode_and() here.
>
Ok

>> +static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
>
>> +				      struct phylink_link_state *state)
>
>> +	state->speed =3D bp->speed;
>
>> +	state->duplex =3D bp->duplex;
>
>> +	state->link =3D bp->link;
>
>
>
>You can't read from the hardware what the actual MAC is doing?

As  mostly PHY mode was used in driver and this method is called only for
in band mode, I added this is just as place holder and used in next patch s=
et
where SGMII support is added. Should I remove it from this patch ?


>> +static void gem_mac_config(struct phylink_config *pl_config, unsigned i=
nt
>mode,
>> +			   const struct phylink_link_state *state)
>
>> +{
>> +	if (bp->speed !=3D state->speed ||
>
>> +	    bp->duplex !=3D state->duplex) {
>
>Please read the updated phylink documentation - state->{speed,duplex}
>are not always valid depending on the negotiation mode.

At least for PHY and FIXED mode I see mac_config is called after state is u=
pdated in phylink_resolve().
In case of IN BAND mode, I see mac_config may not get called after state is=
 updated in mac_link_state()
method. Are you suggesting to configure MAC here only for FIXED and PHY mod=
e ?


>> +	bp->pl_config.type =3D PHYLINK_NETDEV;
>
>> +	bp->pl =3D phylink_create(&bp->pl_config, of_fwnode_handle(np),
>
>> +				bp->phy_interface, &gem_phylink_ops);
>
>> +	if (IS_ERR(bp->pl)) {
>
>> +		netdev_err(dev,
>
>> +			   "error creating PHYLINK: %ld\n", PTR_ERR(bp->pl));
>
>> +		return PTR_ERR(bp->pl);
>
>>  	}
>
>At this point bp->pl can never be NULL.

phylink_create() does return failure also. I think this comment is not for =
above snippet.

>
>> -	if (!dev->phydev) {
>
>> +	if (!bp->pl) {
>
>
>
>So this check is unnecessary.
>

Ok, I will remove this check.

>> -	if (dev->phydev)
>
>> -		phy_stop(dev->phydev);
>
>> +	if (bp->pl)
>
>> +		phylink_stop(bp->pl);
>
>
>
>Ditto.

Ok, I will remove this redundant check.


>> +	if (!bp->pl)
>
>> +		return -ENOTSUPP;
>
>
>
>Ditto.

Ok, I will remove this redundant check.

>
>> +	if (!bp->pl)
>
>> +		return -ENOTSUPP;
>
>
>
>Ditto.

Ok, I will remove this redundant check.

>
>> +	if (!bp->pl)
>
>>  		return -ENODEV;
>
>
>
>Ditto.

Ok, I will remove this redundant check.


>> @@ -4183,13 +4219,12 @@ static int macb_probe(struct platform_device
>*pdev)
>
>>  	struct clk *tsu_clk =3D NULL;
>
>>  	unsigned int queue_mask, num_queues;
>> +	phy_mode =3D of_get_phy_mode(np);
>
>> +	if (phy_mode < 0)
>
>>  		/* not found in DT, MII by default */
>
>>  		bp->phy_interface =3D PHY_INTERFACE_MODE_MII;
>
>>  	else
>
>> -		bp->phy_interface =3D err;
>
>> +		bp->phy_interface =3D phy_mode;
>
>The phy interface mode is managed by phylink - and there are phys out
>there that dynamically change their link mode.  You may wish to update
>the link mode in your mac_config() implementation too.
>
Ok, I will modify mac_config to check phy_mode and program MAC accordingly.


>> +	if (dev->phydev)
>
>> +		phy_attached_info(dev->phydev);[]=20
>
>phylink already prints information about the attached phy, why do we
>need another print here?
>

Ok, I will remove this.

>> -		phy_stop(netdev->phydev);
>> -		phy_suspend(netdev->phydev);
>> +		phylink_stop(bp->pl);
>> +		if (netdev->phydev)
>> +			phy_suspend(netdev->phydev);
>
>When the attached phy is stopped, the state machine suspends the phy.
>Why do we need an explicit call to phy_suspend() here, bypassing
>phylink?
>

Here I am just trying to keep functionality unchanged, just replacing=20
Phylib API's with phylink API's.

>> -		phy_resume(netdev->phydev);
>
>> -		phy_init_hw(netdev->phydev);
>
>> -		phy_start(netdev->phydev);
>
>> +		if (netdev->phydev) {
>
>> +			phy_resume(netdev->phydev);
>
>> +			phy_init_hw(netdev->phydev);
>
>> +		}
>
>> +		phylink_start(bp->pl);
>
>
>
>When the phy is started, the phy state machine will resume the phy.
>Same question as above.
>

Here I am just trying to keep functionality unchanged, just replacing=20
Phylib API's with phylink API's.


Regards,
Parshuram Thombare
