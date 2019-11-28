Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6EAA10C419
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 07:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfK1Guy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 01:50:54 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:44758 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726436AbfK1Guy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 01:50:54 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAS6kvVl024234;
        Wed, 27 Nov 2019 22:50:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=bC11/uzu5Y03ln+FArk3FOLUy/SFAACTUG8OsRsKg68=;
 b=bw7HIToDa61jUT0T/8uYR+YZnu4yEfcvNI+3UhxM1yaIntTfba6dGAl/i/DwiknR/66j
 cBxS0iMyJ+BvGt419ggCpZRA2VVyGBLgvcs73o3mCGh+OjG2de1aApypLgQFEoJrQ7/s
 uwbNgavsv65psTXbS0r+CkOo3YeHKJlFLNksBp14bQqiXc4IYvwYSLGLctqI10docwxI
 sLUASHOMeyKm3bkzQWZSeFdmttrJ+6GofGkRHsqNcYyFbmNN4f1f3MYLD0nApbCsLI6V
 Y1/Xrz3Uzm+rZJD5A2adHlQAC7p1XpfYgg8YH5fLKpq1WNipkZ33f17xNIUASk/r/Jat jQ== 
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2054.outbound.protection.outlook.com [104.47.37.54])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2whcxgq6hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 22:50:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odbM5FmaGVtysjgOl5Gskh1FSH6txqtWznJsWQOiLPgc9ulALIBqpHDXXjJqXuPno/+AxJmltUr/5P5WwQfjYau6o4cEEg/194wgsTl/4N5kQJQzRbsiAfC6gRiQPdhmrMRrzGcVpEUXkMrLsz2nM6rhaX47AmegnvojVjWx/1eO7TxCTSFwgJ4QX8WFM5FYSCmqMu3SQwNaUr/z6cRaEHj9UMx8twT0xnIBM9GDllZXN59XHInkDxANMadvSic4LrH1fv/dr8VpfQCdvshszO66SCiRXkkBZureZof32YPgsN4hnMbkD0Qxxlx96B9srUGB7GfRAcsyihxUkvvxcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bC11/uzu5Y03ln+FArk3FOLUy/SFAACTUG8OsRsKg68=;
 b=A2zsf2163BrcWu/pT5BklLmqYNUpTu+3ROkw/TNIFKRKJ9bKw7Fd1rfUqWNLPE6xHDHNO/HOkjbJCqZ3p58W+N2cvirm2GpXPt8nV2751a7NHwQKeZWrMsPNeiAxf2mNAeyPuI/YfUR58FMbGi/N/fREp9uim8gKTrZ9urHS0V9hQcHZGb61DjU1DLcaaOhvxN8jWZHZKazqcD0kxv+G+I5Jf6Fds437rrUGB026tdkZgwEkHeWB4CO9NZoDcc+u1nW3tDtOBHHu2aFu7Xhe53xdSvneyou4BsyylahbGa05pAIOjzOlCLnDciMRS0a36y/iOurNnsmeHo+ocanYvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bC11/uzu5Y03ln+FArk3FOLUy/SFAACTUG8OsRsKg68=;
 b=3EI9AYVR4bKgm39SYioOgxuKK9Sp8GiDqQD0beO2xLjWN/BacYBFZg8GjlZff8YgxFJ7Wcp/r6XYaNoiTGFmsZYTIBMlDTXQuRx3dtAB2Eg3E4DeDLsoybpjnKQnKkk9fIT3gOD3Sk9Sc4cFjS8tHvTXDGccLWY4EWTAiZS1Mjo=
Received: from BY5PR07MB6514.namprd07.prod.outlook.com (10.255.137.27) by
 BY5PR07MB7174.namprd07.prod.outlook.com (52.133.250.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Thu, 28 Nov 2019 06:50:11 +0000
Received: from BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::fc51:186:dd82:f768]) by BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::fc51:186:dd82:f768%7]) with mapi id 15.20.2495.014; Thu, 28 Nov 2019
 06:50:11 +0000
From:   Milind Parab <mparab@cadence.com>
To:     "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dhananjay Vilasrao Kangude <dkangude@cadence.com>,
        Parshuram Raju Thombare <pthombar@cadence.com>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "brad.mouring@ni.com" <brad.mouring@ni.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>
Subject: RE: [PATCH 1/3] net: macb: fix for fixed-link mode
Thread-Topic: [PATCH 1/3] net: macb: fix for fixed-link mode
Thread-Index: AQHVpDlBnnMY4JNgZU2dTLIc6PgUU6efUTOAgADTG1A=
Date:   Thu, 28 Nov 2019 06:50:10 +0000
Message-ID: <BY5PR07MB65144B9F265EDF74FB7BB621D3470@BY5PR07MB6514.namprd07.prod.outlook.com>
References: <1574759354-102696-1-git-send-email-mparab@cadence.com>
 <1574759380-102986-1-git-send-email-mparab@cadence.com>
 <e53eb865-6886-e7b6-3f4e-1ec40d38c7de@microchip.com>
In-Reply-To: <e53eb865-6886-e7b6-3f4e-1ec40d38c7de@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbXBhcmFiXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctNTA1MmRmZTgtMTFhYi0xMWVhLWFlYzAtZDhmMmNhNGQyNWFhXGFtZS10ZXN0XDUwNTJkZmVhLTExYWItMTFlYS1hZWMwLWQ4ZjJjYTRkMjVhYWJvZHkudHh0IiBzej0iMzk1NSIgdD0iMTMyMTkzOTc0MDgzMDc5MjgyIiBoPSJIK0loenA0OEUzQXBaUUxyVThBYTFsUkZyeG89IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac69cf83-3461-4faa-82df-08d773cf36d0
x-ms-traffictypediagnostic: BY5PR07MB7174:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR07MB717448198813E15A7142A3B2D3470@BY5PR07MB7174.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0235CBE7D0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(39860400002)(366004)(376002)(396003)(36092001)(13464003)(189003)(199004)(2501003)(55236004)(76176011)(6506007)(7696005)(102836004)(186003)(446003)(11346002)(54906003)(26005)(110136005)(316002)(33656002)(99286004)(71190400001)(71200400001)(86362001)(2201001)(256004)(14444005)(5024004)(55016002)(9686003)(6436002)(6246003)(478600001)(229853002)(6116002)(3846002)(2906002)(8936002)(8676002)(81156014)(81166006)(4326008)(7416002)(74316002)(305945005)(7736002)(64756008)(5660300002)(25786009)(66556008)(76116006)(66946007)(52536014)(66066001)(14454004)(66476007)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB7174;H:BY5PR07MB6514.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NLSo4d7VqULiPlQI6NEGdTUSk2gTF7YVhZme9PBDMYvB4eY478gB5gCNH+ypr4nwdafUumveemHQlDnuBUT0+I2SaSNCfDUhs4AE8k5mZ2Nwwnog2CraM78cNBRenOW0mCsoyEGH4HTlk4zxpZNbZYdT44re9dGG1+AQakDTYr1OJi9OtWkAJkYwFoDmBm3zkWrXL/3MYxeamOwbWoRfURF2/s/KbNQxMyASa2MTVYeI/6QVffYAHk0e4wdOdG0pTJTlAirAxwbPE7p4M1QNN6wxvrBwJ45CSEgbxK9acvVSd5p86PObW6vhmPf+Y11jdRceoUhnxZ6Y0xAMWmqCvfGFKK4uX76939HLGIVgLHiYSXGzsKpF/FmHz31Afx+S/91YuplRUmekhVSgZbc022LOWBfJTuhBxGgaM1gOYdJUFHpweAFNX0byNXw19c/iQ7oMYN6PKt9kWmejc7rM2A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac69cf83-3461-4faa-82df-08d773cf36d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2019 06:50:11.0734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GtiypIYF3497kF78/SiM/ITFJ7Cs2wcZ9BKREQh7Jao2tdDh/ucI/WKExPG20v2FTqT7zmVp+scW6Eua/uNeLFsCZfNkExRgU0nl8LzdYFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB7174
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-27_07:2019-11-27,2019-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 clxscore=1011 impostorscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911280056
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>-----Original Message-----
>From: Nicolas.Ferre@microchip.com <Nicolas.Ferre@microchip.com>
>Sent: Wednesday, November 27, 2019 11:32 PM
>To: Milind Parab <mparab@cadence.com>; andrew@lunn.ch;
>antoine.tenart@bootlin.com; f.fainelli@gmail.com
>Cc: davem@davemloft.net; netdev@vger.kernel.org; hkallweit1@gmail.com;
>linux-kernel@vger.kernel.org; Dhananjay Vilasrao Kangude
><dkangude@cadence.com>; Parshuram Raju Thombare
><pthombar@cadence.com>; a.fatoum@pengutronix.de;
>brad.mouring@ni.com; rmk+kernel@armlinux.org.uk
>Subject: Re: [PATCH 1/3] net: macb: fix for fixed-link mode
>
>EXTERNAL MAIL
>
>
>On 26/11/2019 at 10:09, Milind Parab wrote:
>> This patch fix the issue with fixed link mode in macb.
>
>I would need more context here. What needs to be fixed?
>
>I think we had several attempts, at the phylib days, to have this part of =
the
>driver behave correctly, so providing us more insight will help understand
>what is going wrong now.
>For instance, is it related to the patch that converts the driver to the p=
hylink
>interface done by this patch in net-next "net: macb: convert to phylink"?
>
Yes, this is related to the patch that converts the driver to phylink
With phylink patch, in fixed-link the device open is failing. The reason fo=
r failure is because
here an attempt is made to search and connect to PHY even for the  fixed-li=
nk.
phylink_of_phy_connect() handles this case well, and for the fixed-link it =
just returns 0.=20
So, further steps to search and connect to PHY are not needed.=20
This patch solves this problem by allowing phylink_of_phy_connect() to take=
 this decision

>
>> Signed-off-by: Milind Parab <mparab@cadence.com>
>> ---
>>   drivers/net/ethernet/cadence/macb_main.c | 12 ++++--------
>>   1 file changed, 4 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb_main.c
>> b/drivers/net/ethernet/cadence/macb_main.c
>> index d5ae2e1e0b0e..5e6d27d33d43 100644
>> --- a/drivers/net/ethernet/cadence/macb_main.c
>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>> @@ -617,15 +617,11 @@ static int macb_phylink_connect(struct macb *bp)
>>          struct phy_device *phydev;
>>          int ret;
>>
>> -       if (bp->pdev->dev.of_node &&
>> -           of_parse_phandle(bp->pdev->dev.of_node, "phy-handle", 0)) {
>
>You mean we don't need to parse this phandle anymore because it's better
>handled by phylink_of_phy_connect() below that takes care of the fixed-lin=
k
>case?
>If yes, then telling it in commit message is worth it...

Yes, this we will explain in the commit message

>
>> +       if (bp->pdev->dev.of_node)
>>                  ret =3D phylink_of_phy_connect(bp->phylink, bp->pdev-
>>dev.of_node,
>>                                               0);
>> -               if (ret) {
>> -                       netdev_err(dev, "Could not attach PHY (%d)\n", r=
et);
>> -                       return ret;
>> -               }
>> -       } else {
>> +
>> +       if ((!bp->pdev->dev.of_node || ret =3D=3D -ENODEV) && bp->mii_bu=
s)
>> + {
>>                  phydev =3D phy_find_first(bp->mii_bus);
>>                  if (!phydev) {
>>                          netdev_err(dev, "no PHY found\n"); @@ -635,7
>> +631,7 @@ static int macb_phylink_connect(struct macb *bp)
>>                  /* attach the mac to the phy */
>>                  ret =3D phylink_connect_phy(bp->phylink, phydev);
>>                  if (ret) {
>> -                       netdev_err(dev, "Could not attach to PHY (%d)\n"=
, ret);
>> +                       netdev_err(dev, "Could not attach to PHY\n");
>
>Why modifying this?

This is by mistake. This will be corrected in the revision patch

>
>>                          return ret;
>>                  }
>>          }
>> --
>> 2.17.1
>>
>
>Best regards,
>   Nicolas
>
>--
>Nicolas Ferre
