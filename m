Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BCE11A5C2
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 09:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfLKIW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 03:22:27 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:51332 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726983AbfLKIW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 03:22:27 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBB8KHdB009082;
        Wed, 11 Dec 2019 00:22:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=2zwg8GIBa344FI/Ikc8ncktWB1uASNMsJ7Y8WnWyT5c=;
 b=Ocgf/iRg4MfTWA7GSLkaRvbxNfheHPLfC0rWjbltJzjj2VK55p6z0dByFAMHBCwEtzvV
 OaaHBd2tKRFOSnOWQKeKU3qLCaRG/W8s5flHLhdjgZM87pfVLMi+odQ84x96+mD11pHt
 dNDH+zSLnaFzDWMi3LDnhltgmmMfERCCPz0kikyVDvH5ueJYUXY87D9V+t7mp1TQb+zb
 eG7pc6XIzcNTVDk3ThUJm4UOEopB99nlROrfVZJA1CA1YKa2x1nEqtSF5wa8TMZLX/2Y
 bfT/Q5u42yDobBm1scpwPakDK3WC/2pj/fy3OOhwRjNFIrs5hC7KOjmjfd4lF/Evf1S/ 4A== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2wr9dfndde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 00:22:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Na8ir+HW8o2/d8q77LAKbJ5fqoc3Nxt5Z4xBg2chbzuLZKXk86A6pcuRm6LcEq6UEOEbSKQQua5sntM+UR3g5eibpM+nxDXnQn3hiJc5q5di9wdtwO2dhWPa1hELVFVf3iKBVw/3s4lXlKFujpQj9li5qfzlYtbviv2hyCbWo3wSNajDCkmzDhb706+SfCKLqXHqFl+1LA4e7+ug1mcdlN3RrA1tOioB8G1REqAcCYRF9lVqZGanC/0y+tu3n1pE88P9lyX38Gc9fMvt9wfGxCvmYwC/vzp3LQuG3PwL6uo5M+wNzGfGmmO44uO7Jpr/fS8CXF9Ah6C/tSIRMacWEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zwg8GIBa344FI/Ikc8ncktWB1uASNMsJ7Y8WnWyT5c=;
 b=YN0Gls346dmlnWdGm9CYbNn5Vype3qq1wshMRec9umPH2QAc3Deucb1Tmm4g5R9Lk7czCpB3WaYfiFZuEj9Xpd07XWR1ILWpao1+m1R5QrLllQZ3YJHsQRHX7smuYFUZRyVME4dktc4dHt2SxRo9gS+jy7P3FQhZfFSuMvDQaDRowTmql9nKom1PH8bxaaaJwQtaQqd45tlpIcLrvvbZdvbpgn/unN65e2uJrp/wkv32R6QPk7NNHCCeJfwOWFPnO1s6Mq1QT2dCj2VD9MC7qUY4B6WNdTYPOl7m3IalRFU7fHBahBZpztRnmDItC5JEWsIxkBX+nkVFqpYuDCAUVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zwg8GIBa344FI/Ikc8ncktWB1uASNMsJ7Y8WnWyT5c=;
 b=Y4arcBwAZ2qr38DoVtH/RMBlE6rCdxFNYbZ+wh02H9+LTFK+1W3AIq0+TpI8GTVkmoey7oHXRD8e18/FUlDSXPZw1xK2pi54hFm2V8zBXJKuVB1c+T4gc6jjQRVPs4JeqIlqM3y2AetrS7x719yl7rsY0cSxSeHaOX02c1vlx30=
Received: from BY5PR07MB6514.namprd07.prod.outlook.com (10.255.137.27) by
 BY5PR07MB6756.namprd07.prod.outlook.com (10.255.138.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Wed, 11 Dec 2019 08:21:58 +0000
Received: from BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7]) by BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::e5b3:f11f:7907:d5e7%5]) with mapi id 15.20.2516.018; Wed, 11 Dec 2019
 08:21:58 +0000
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
Thread-Index: AQHVroHjmY6JAv/FqEGIQD/Y0ouad6exqeuAgAFq7JCAACrVAIABV/Kg
Date:   Wed, 11 Dec 2019 08:21:57 +0000
Message-ID: <BY5PR07MB6514DEE80FD0C24F9FD52ED1D35A0@BY5PR07MB6514.namprd07.prod.outlook.com>
References: <1575890033-23846-1-git-send-email-mparab@cadence.com>
 <1575890061-24250-1-git-send-email-mparab@cadence.com>
 <20191209112615.GE25745@shell.armlinux.org.uk>
 <BY5PR07MB6514923C4D3127F43C54FE5ED35B0@BY5PR07MB6514.namprd07.prod.outlook.com>
 <20191210113829.GT25745@shell.armlinux.org.uk>
In-Reply-To: <20191210113829.GT25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbXBhcmFiXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctNGE2NzE3NTYtMWJlZi0xMWVhLWFlY2EtZDhmMmNhNGQyNWFhXGFtZS10ZXN0XDRhNjcxNzU3LTFiZWYtMTFlYS1hZWNhLWQ4ZjJjYTRkMjVhYWJvZHkudHh0IiBzej0iMzMyOSIgdD0iMTMyMjA1MjYxMTU3OTk0MzUwIiBoPSJpcit3dmQ2a0pXb2h6UHAyMHZKeU5LWEk0dFE9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54d6d1c7-c62d-4353-5942-08d77e13308c
x-ms-traffictypediagnostic: BY5PR07MB6756:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR07MB675670ADF0CDB05CA2A13894D35A0@BY5PR07MB6756.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(396003)(346002)(39860400002)(189003)(36092001)(199004)(76116006)(9686003)(86362001)(8676002)(66446008)(55236004)(64756008)(107886003)(8936002)(54906003)(66476007)(6916009)(81166006)(55016002)(66556008)(4326008)(81156014)(33656002)(66946007)(2906002)(7416002)(186003)(26005)(478600001)(5660300002)(6506007)(7696005)(52536014)(316002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB6756;H:BY5PR07MB6514.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J1KVCATluUsxbT+SGYQh2Phw8I0iCF4XnftdAW+7PP4WhU+jQuv42KxtR7Z9QJwUSIyBTQ+5s9yDtT4WJh6l00OlUMDoCAAtQAg1jzvIAo/8sVS9nMAwbwrum6pylOHenBFEmSaFrUX0e76VROE7d6UOxQiRYlp0qP9p8DV27YINEuAVxCSGTPlEJnl8kB+1qRAOB5/dyfFoefH13uYtiqcod+2JHrH1+COhicfLQJyZSmYFRBC2PtBk+ctvMaOln41jrnPaLg/SAruESWS396Voon0XtKfJSrB68oJHTSuqY6FB6/VkUPKXazoB9oos9WPR5w/mqhij1TS+rOl3TyxZ6ebC9hWhVP8MXWP9ls8hANbPc82oljfhtFWx8rNJr4uOXj+eF5uYktw0Hbh67+CG68MrkmG2ecTozTOJYS9s3l5ZLmyWOZ5Bf2Jcku8XwkExmUIiz20k8CD5YNuZZmY/iU5THOBzvS9iu6wamJC4BiVqHZC8AtnRMfp+bRwl
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d6d1c7-c62d-4353-5942-08d77e13308c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 08:21:57.8668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s9UfodVIgkmy5tutuiRA7NX+QiuCtuL0X96vYVnf+g5k2KV5rGFHaTuvrsIVmN2facob6+ZSphUXeQbz+FuHJG9KYgojyvIWo4or/eSsGPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB6756
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_01:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> >> +		ret =3D phylink_of_phy_connect(bp->phylink, dn, 0);
>> >> +
>> >> +	if (!dn || (ret && !of_parse_phandle(dn, "phy-handle", 0))) {
>> >
>> >Hi,
>> >If of_parse_phandle() returns non-null, the device_node it returns will
>> >have its reference count increased by one.  That reference needs to be
>> >put.
>> >
>>
>> Okay, as per your suggestion below addition will be okay to store the
>"phy_node" and then of_node_put(phy_node) on error
>>
>> phy_node =3D of_parse_phandle(dn, "phy-handle", 0);
>>         if (!dn || (ret && !phy_node)) {
>>                 phydev =3D phy_find_first(bp->mii_bus);
>...
>>         if (phy_node)
>>                 of_node_put(phy_node);
>
>As you're only interested in whether phy-handle exists or not, you
>could do this instead:
>
>	phy_node =3D of_parse_phandle(dn, "phy-handle", 0);
>	of_node_put(phy_node);
>	if (!dn || (ret && !phy_node)) {
>		...
>
>Yes, it looks a bit weird, but the only thing you're interested in
>here is whether of_parse_phandle() returned NULL or non-NULL. You're
>not interested in dereferencing the pointer.
>
>Some may raise some eye-brows at that, so it may be better to have
>this as a helper:
>
>static bool macb_phy_handle_exists(struct device_node *dn)
>{
>	dn =3D of_parse_phandle(dn, "phy-handle", 0);
>	of_node_put(dn);
>	return dn !=3D NULL;
>}
>
>and use it as:
>
>	if (!dn || (ret && !macb_phy_handle_exists(dn))) {
>
>which is more obvious what is going on.
>

This is good. I will put this in the revised patch.

>
>>
>>         return ret;
>>
>> >I assume you're trying to determine whether phylink_of_phy_connect()
>> >failed because of a missing phy-handle rather than of_phy_attach()
>> >failing?  Maybe those two failures ought to be distinguished by errno
>> >return value?
>>
>> Yes, PHY will be scanned only if phylink_of_phy_connect() returns error =
due to missing "phy-handle".
>> Currently, phylink_of_phy_connect() returns same error for missing "phy-=
handle" and of_phy_attach() failure.
>>
>> >of_phy_attach() may fail due to of_phy_find_device() failing to find
>> >the PHY, or phy_attach_direct() failing.  We could switch from using
>> >of_phy_attach(), to using of_phy_find_device() directly so we can then
>> >propagate phy_attach_direct()'s error code back, rather than losing it.
>> >That would then leave the case of of_phy_find_device() failure to be
>> >considered in terms of errno return value.
>
>Here's a patch I quickly knocked up that does this - may not apply to
>the kernel you're using as there's a whole bunch of work I have
>outstanding, but gives the outline idea.  Does this help?
>
>

Yes, this will help. Once available, we will adopt this change.

>8<=3D=3D=3D
>From: Russell King <rmk+kernel@armlinux.org.uk>
>Subject: [PATCH] net: phylink: avoid of_phy_attach()
>
>of_phy_attach() hides the return value of phy_attach_direct(), forcing
>us to return a "generic" ENODEV error code that is indistinguishable
>from the lack-of-phy-property case.
>Switch to using of_phy_find_device() to find the PHY device, and then
>propagating any phy_attach_direct() error back to the caller.
>
>
>Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>---
>

