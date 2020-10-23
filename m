Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F968296D3E
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 13:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462628AbgJWLAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 07:00:01 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:45336 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S462528AbgJWLAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 07:00:00 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09NAtMLd006790;
        Fri, 23 Oct 2020 03:59:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=pu6njqF/MSq873WAUnvZbegm5gUB/82WzkLH/03rJkU=;
 b=Z2VM8HdUJHSF+O4bUJ7gPGuvVCOdu/tVSkZT6WRBAflXsw/75kJBhHSEFXbGsRCIii7a
 vLIOR0cCSxm9Hz+tRGChoKi34EhiJFa33KppzhxkkqMKs7ub0n/lT2PBUBAyD1QSA018
 PDI2cPGz/UJdRo44wNAxK95FlPwsRZo2xss9DcaReob1k01SklznYBSKk3QixPQ9NBfO
 UjZrxmOAartkFmBDcLcSYmxRH2KqxviEwyvYo6w74E51sYVSvbGqXMbW2FnHgUrLw4F8
 SxlJHyiSBGUfhhP9nwUn80NPADMhzbs0H/yUBd/suV+S+ElT4O2VS1k3dGdIcrdTHJKZ Eg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0b-0014ca01.pphosted.com with ESMTP id 347v6ys55h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Oct 2020 03:59:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fG3nFt4lX6kBnrvtgzL11+TQTyggpnE7J8GDV/5yEJ4MfRTxjrZ+D3zwHtSmVKyVjdGAFd2IKnDkW7SsJo3FHbIUQAzQ1f2hU9ViEIVe1yutr+6caqb5OMxc2aYbSTO/3eNZuLw9yahHfhDCJNalfYoLLTYGR/b4vtvpR3v4PAL/BFhJUAlSTUuBuUV3LgSexjhjeHGweQWCLHKowTslSoOZuhVWCUrgFfTs6BpaTJo3ic1fKvRqUj/MhXaI+5Mx+Oh8KTSSAlvbvJZfrFDk89LfPyvU9h0ZkFjzzg9GIg6JOk0wDAqaCSIhPjxBEuyyyxk75dzUx+k0Wbaykf7O5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pu6njqF/MSq873WAUnvZbegm5gUB/82WzkLH/03rJkU=;
 b=ag0bT/EUdedQDCRYZ+xW1FwNivyITCeUg9jdSleVRO8vALTDbwPvbYqqGbnLlCv1HB/+qj8aoCQWXKqGORpRVCcxwlTurFlxHTRIFX/maG3ZrrVKze6wyfcBs9iurvn1QD5SYP7pNl/SG/juWI61t2h2eJ2I5oa4FKaRLAMR9r79m7O8JOWZ3oAJgR2UU3XClI8bhMEkK10lf+CecfeTkS0riNKCJ/Q4xU6Sd8Qs1TudDq0FegfaTkrlDmJ4knIlk+wA5zE931+JrO6D5SioEVztNJ9be+rJx4YWjiDo6D2xbnyp5VzLOQrvxFgYjKGF6d2BoKtPcVJlCGoxHPsudQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pu6njqF/MSq873WAUnvZbegm5gUB/82WzkLH/03rJkU=;
 b=IywMrMwdn70PlruEzhCgyjuiTnHlspQbGhjPy153EiOUAAmlwmL2eRV2DQREqBX1RBijPD+XBrWi66KHEpLvWINPYu8DpGVrGRkIGrPO1GpfzPDzewoy5lMqJDzlxeJJbGHvWS74+iMskeV1kt+DlHeCjI7l8YhOblNnHIojCOM=
Received: from DM5PR07MB3196.namprd07.prod.outlook.com (2603:10b6:3:e4::16) by
 DM6PR07MB5564.namprd07.prod.outlook.com (2603:10b6:5:36::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.21; Fri, 23 Oct 2020 10:59:42 +0000
Received: from DM5PR07MB3196.namprd07.prod.outlook.com
 ([fe80::e183:a7f3:3bcd:fa64]) by DM5PR07MB3196.namprd07.prod.outlook.com
 ([fe80::e183:a7f3:3bcd:fa64%7]) with mapi id 15.20.3499.019; Fri, 23 Oct 2020
 10:59:42 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Milind Parab <mparab@cadence.com>
Subject: RE: [PATCH v3] net: macb: add support for high speed interface
Thread-Topic: [PATCH v3] net: macb: add support for high speed interface
Thread-Index: AQHWp9HS4UctazNdVUWuQbMULgmNwKmiZpMAgAEAG1CAAY/28A==
Date:   Fri, 23 Oct 2020 10:59:42 +0000
Message-ID: <DM5PR07MB3196723723F236F6113DDF9EC11A0@DM5PR07MB3196.namprd07.prod.outlook.com>
References: <1603302245-30654-1-git-send-email-pthombar@cadence.com>
 <20201021185056.GN1551@shell.armlinux.org.uk>
 <DM5PR07MB31961F14DD8A38B7FFA8DA24C11D0@DM5PR07MB3196.namprd07.prod.outlook.com>
In-Reply-To: <DM5PR07MB31961F14DD8A38B7FFA8DA24C11D0@DM5PR07MB3196.namprd07.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy1kNzhiZTQ2Ni0xNTFlLTExZWItODYwZi0wMDUwNTZjMDAwMDhcYW1lLXRlc3RcZDc4YmU0NjctMTUxZS0xMWViLTg2MGYtMDA1MDU2YzAwMDA4Ym9keS50eHQiIHN6PSIyNDQ1IiB0PSIxMzI0NzkyNDM3ODUyNTQ2MTgiIGg9InU3bDFYR1F0MWxEVVFJR1JHbHZFeHN6R2diOD0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=cadence.com;
x-originating-ip: [34.98.221.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 450d27ca-ebcf-4bd2-3821-08d87742bed4
x-ms-traffictypediagnostic: DM6PR07MB5564:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR07MB556419925D99E231F9C47842C11A0@DM6PR07MB5564.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nkcj3XtTL/jcqqjDa2475j8accWIV093seZZXhn0Sc143Xs4lAk1QRVKh/1n2QxaZe2E9eVqKL+iZabPPoqS8oFyrpH/34Qj67qLjK72thgtdM6aPlRpFv2RIka4b2lM5IiWMIFZs6JzGz3PjsstyLelffoWamhhTBiXParntCdQxQFNX4qrnOSQlj4s+b014PiYicsbeZOMfq7qAwGJWFnQItMyv0Ke38IoFajqFQRJqJKNLqUx6P3W8EKEdrCM4oPAxOHzSFGwqfdsy6eYw9IlGT5jC7p/HI7oZn9p6UQiLjikcCaFowNNsZICtE4HvfJoaYjbTfKUg61v3vW56JWl8l4yCvrTWVoa61MnEvsjLMT5yXS4MIP0PD1jj1jQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR07MB3196.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(36092001)(4326008)(107886003)(66446008)(66556008)(54906003)(7696005)(66946007)(64756008)(55016002)(76116006)(71200400001)(66476007)(9686003)(8936002)(186003)(26005)(5660300002)(316002)(6506007)(478600001)(8676002)(33656002)(83380400001)(6916009)(52536014)(2906002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: CPM76feRAKKCWZMslxe3svoaQnwttBj0oS5aKUPW8u1WJTxMnNd/rAVd8TYorkWPEIdiMGv9ZTminGuPXhtGDXqN3uBrcvdkOJCr5LV5PLPprAtQhrSXlle6IvfWan/m7uzC87p29eim/P9xZTVR06pCrjuZdjIX8fWovBKhegn7MmB5WhzRfszhPmxunQctTGaT9Fo7yWCo8qqGJAb0e/3XWShZ/Vg2mpyXcPjibCjc+8Ct/TtlOVQbZcbvPPJnBMud9/xMJhfQPAZwFfceyahTCyAv8cZiuFYRGlr2G/5xfXJA+tKTsyaQDrpug6L+V2AbeKYeiCNT+/k9J+lcvxeuIq2h4Ric9KvvZUjCMNs8VJmBHGkyKFXjLM8Y8/oSvTB5jOEr4xAiU1/O5sRVU+NqAXdWtxWkw4r+NRMdBmd7Rl31cKGJE7BnRwRygyxwjISgsALd82OOM0pcDqLEo4mCZYhVrVaKKea9hf/P/eqP5T3O2KUMj7dRipqLLlsWyxUqqWCJlLWHVjm5MPUPNT4ZDnSqzGP2CBviPXvJrQ52WukHkgelB/90tclvHNoHYZS4p1nm/hsn2l27pUea3kOboeIhxcOdj25R8BYbZNPglvr5cN+ZCwZkCWZc16IOQ94GBhsR02dl0kP8cAtJNQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR07MB3196.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 450d27ca-ebcf-4bd2-3821-08d87742bed4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2020 10:59:42.4781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qtoR4RCA/jbUdwFIUeZiM3U1HGMoSF+3kld6r7KKyiPBHqnxMo37zY3mqAbyOjBXrXx1CChfAU51u/TGzjm8Ge+eeQAiIVOXAaNXpL6trX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-23_04:2020-10-23,2020-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1015
 mlxlogscore=945 phishscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230077
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I was trying to find out any ethernet driver where this issue of selecting =
appropriate
pcs_ops due to phylink changing interface mode dynamically is handled.=20
But, apparently, so far only mvpp2 has adapted pcs_ops. And even in mvpp2, =
it is
not obvious how this case is handled.=20

Also, apart from interface mode changed due to SFPs with different types of=
 PHY
being used, it is not clear when phylink selects interface mode different t=
han it
initially requested to the ethernet driver.

>pcs_config and pcs_link_up passes "interface" as an argument, and in
>pcs_get_state call "state->interface" appeared to be populated just before
>calling it and hence should be valid.

It seems state->interface in pcs_get_state is not always valid when SFPs wi=
th
different types of PHY are used. =20
There is a chance of SFP with different type of PHY is inserted, eventually=
 invoking
phylink_resolve for interface mode different than phylink initially request=
ed,
and causing major reconfiguration.

However, pcs_get_state is called before major reconfiguration, where select=
ing
which pcs_ops and PCS to be used is difficult without correct interface mod=
e. =20

As struct phylink and hence phy_state is private to phylink layer, IMO this=
 need to be
handled at phylink level by passing appropriate interface mode to all neces=
sary
methods registered by drivers.

Something like

523 static void phylink_mac_pcs_get_state(struct phylink *pl,
 524                                       struct phylink_link_state *state=
)
 525 {
 526         linkmode_copy(state->advertising, pl->link_config.advertising)=
;
 527         linkmode_zero(state->lp_advertising);
 528         if (pl->phydev)
 529                 state->interface =3D pl->phy_state.interface;
 530         else
 531                 state->interface =3D pl->link_config.interface;
 532         state->an_enabled =3D pl->link_config.an_enabled;
 533         state->speed =3D SPEED_UNKNOWN;
 534         state->duplex =3D DUPLEX_UNKNOWN;
 535         state->pause =3D MLO_PAUSE_NONE;
 536         state->an_complete =3D 0;
 537         state->link =3D 1;
 538
 539         if (pl->pcs_ops)
 540                 pl->pcs_ops->pcs_get_state(pl->pcs, state);
 541         else
 542                 pl->mac_ops->mac_pcs_get_state(pl->config, state);


Regards,
Parshuram Thombare
