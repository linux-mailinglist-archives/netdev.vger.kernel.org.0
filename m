Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BBC4FBCC3
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346351AbiDKNJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbiDKNJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:09:45 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70058.outbound.protection.outlook.com [40.107.7.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189692AE26;
        Mon, 11 Apr 2022 06:07:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0IihfWmZPYQcn4IA+AgQ2KYOHcjvnm9C+SKp/Ioo4osNG0TPCCiobSJYo/gueg+udDgD0ga7ohz5Ho1/njQ9Eqeda9sUd65+sRdsYpOS1GxVcCQyd3LGRrZKIy/p6A65CjD806KckclYbzrxgPHtATu7okeZghLAe8EAwsojW1oAp4FPPJDaYj/0mdPwZ3o75ER8DZwJc5KuqtVTeaLw0EHwyD1x1mjtb3OyvER1HBzJawfShLHuoZ6HzBF/kFJ8vsdJUsRNY00xur0PamGu0VYVKBQB4BsKFRM30Zd2NPmf+b5oIWxhfaxsW43kYF5w2YEQl2G+6ouyXQmqr5zoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pJ2YSeVKPRv1lqIPMxfBuVxLc+lWT6tigCQOHdFpXZQ=;
 b=nB37mLmm4/UIznnLVcec0+mzkY0F5Fj9IPCWdyWHl7zmY6BDanFhZ3tmRUwwHfwQgpYbc1RFPvuPW5NseajHGN7P2tlKB1nZ07WhIWNTKQg2VLPhuXfODmwmksA54CtR2RBCsugjnFDUH6Drae/+bBsgfLq16Qjzi85c0a3QZh6HttQNGKtdogZhX/QCj7YZe91DUdVGw9LUjDjDiY/7FJFgxzljjGzhecB1IwMylJ/n7qFKd1UtqNOdtpzlKad3oSSGJb8xpfaMSqc6dSio4XnFex1oFkV+0Czsi4oWrHHAHfEkOORyTf6YcXGukPb3HnwAOj9KVJ6K3Zgk4/YGww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=peak-system.com; dmarc=pass action=none
 header.from=peak-system.com; dkim=pass header.d=peak-system.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=itpeak.onmicrosoft.com; s=selector2-itpeak-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJ2YSeVKPRv1lqIPMxfBuVxLc+lWT6tigCQOHdFpXZQ=;
 b=cduNSBGtCowyVAoiPCiLkt8dJUTEDPcUYCXPs1cD86h+GoPiZ3M+dsvB8vYAlr9qZfD9p+jJLK+8bEu6hHWVewR2XrtdVEZ1fZpxWq0NxoxNvRzJzU2xVzEwg9K7F7kSS8Tip48yTX6aEGa1JLaUBTtGrGyZyO4j9/hqZy/CAX0=
Received: from DB6PR0301MB2518.eurprd03.prod.outlook.com (2603:10a6:4:61::9)
 by PAXPR03MB8115.eurprd03.prod.outlook.com (2603:10a6:102:229::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 13:07:25 +0000
Received: from DB6PR0301MB2518.eurprd03.prod.outlook.com
 ([fe80::b1c6:eb02:7f81:8e3a]) by DB6PR0301MB2518.eurprd03.prod.outlook.com
 ([fe80::b1c6:eb02:7f81:8e3a%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 13:07:24 +0000
From:   =?iso-8859-1?Q?St=E9phane_Grosjean?= <s.grosjean@peak-system.com>
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Paul Thomas <pthomas8589@gmail.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        PEAK-System support <support@peak-system.com>
Subject: RE: peak_usb: urb aborted
Thread-Topic: peak_usb: urb aborted
Thread-Index: AQHYS2jrY5s4vBY7Lk+LYv4om2VVRazmWrAAgARYVFU=
Date:   Mon, 11 Apr 2022 13:07:24 +0000
Message-ID: <DB6PR0301MB2518B82AEDB9FCE31A47E3E5D6EA9@DB6PR0301MB2518.eurprd03.prod.outlook.com>
References: <CAD56B7dMg073f56vfaxp38=dZiAFU0iCn6kmDGiNcNtCijyFoA@mail.gmail.com>
 <c2e2c7b0-cdfb-8eb0-9550-0fb59b5cd10c@hartkopp.net>
In-Reply-To: <c2e2c7b0-cdfb-8eb0-9550-0fb59b5cd10c@hartkopp.net>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=peak-system.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9146083-17af-46d7-2930-08da1bbc38f8
x-ms-traffictypediagnostic: PAXPR03MB8115:EE_
x-microsoft-antispam-prvs: <PAXPR03MB8115D60C3F5A4810CB6091B6D6EA9@PAXPR03MB8115.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eSD0u22yMxEHLFhYNwN3Ivj+/iQfO+nSUfXgcQaWjlpgBDpmWujDRrrCn/rC8Z8adtBdLbVsBVFFySuZmd9/OgGdpmUEMMfazn+HpGbQaU40mlMCB955dm2emMDYONwL6mAdqmAk8DdX1k1VCNMtaXuIKcE5XPiNHOp0It9nCZ7WT0ncnFiY8qhMEzskyGkFBs0ztaXIGbcKvpe4nlYY52UDx6+K8UE9Pf475SXSOMjTlJCQ8guccThjIsd2wWhMg1bokNf+fEZfPXtlP/T1FbjgGpU/0eEn9G3l5HVLVJP9+EnikvXjXm5RLSurAnBOPdn6yGvOwTbxoKD5dvgav3NeVQzCH0cuWlIwZbkF4aHI2VfrxXloullv9iOdwjviASv1dccFxIMONCL1cCcXMQFxem3XgqkOX2shW/NRoAWBVAHYnMo4nzGPy4zszvT8FIwWX7GdbWbejf06dZAJXLfZoVHL4/+zJz+Ez/f+BRnz97QtfWOueR/3CrsatFGGZedBtVpM1UMonwtp+gshRI9K0+ip7bICUM7J8LH++Ap8+XEMQxhmt65UojJcE7PN4lpcAX6qCtt6FSaHLzpWD89S03NmM2g3kcj1DrSQt7zU8ySoUTFrKYbyETIBH4wr+76BcE/sxjdHqmt92wFHpHm9C/RGOxp6l0xDBHsiRDmDtAsZ221Ytb1O7cxm+2kP5CMe6A1UWaycZlSipyU5/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0301MB2518.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(346002)(136003)(396003)(39840400004)(15974865002)(86362001)(5660300002)(66446008)(122000001)(66556008)(8676002)(66476007)(64756008)(38100700002)(38070700005)(55016003)(316002)(4326008)(76116006)(91956017)(71200400001)(54906003)(110136005)(52536014)(66574015)(2906002)(66946007)(26005)(8936002)(186003)(107886003)(83380400001)(508600001)(33656002)(9686003)(6506007)(53546011)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?4bazH9BlaWRl0WjsR6BWcX4/vwdR+YJ2sKGHyO8Ds1dDyG8MDwJl8w1RWv?=
 =?iso-8859-1?Q?+1SNUeOvXmBIKt7PTh6nCz7OT4DxDZvPNCBKbM4CT1Cf1qKziFexhSW9Jk?=
 =?iso-8859-1?Q?HI0Cq2RFSNFIU5TXNjCT1ciAr425L+nttQ0FTuDgYE2cJa/itBSMxjrzQt?=
 =?iso-8859-1?Q?SF0YOUwR1k6Iys2ESZ/4/GwRhYXt3zaTO6xwXkQlNR7dU+sa1vOvTnGbwX?=
 =?iso-8859-1?Q?patBbPuvcij12Z/j6LQfkxDAkLr4rNQ+5+HNmkrfX17w/v1WxDf3sur0m2?=
 =?iso-8859-1?Q?4VQIjlx8xa/BqTaxfwA4tHbpJxMzqnaGP39k9+9ls9AF/JWJKXCP+ZJ8se?=
 =?iso-8859-1?Q?MxHiP5PQhwVtbd6wdNHdPMQTVmE6SyB4UGyZp+Y6/1BfdVgBVvXcoWA2sg?=
 =?iso-8859-1?Q?0hhCGQdStXMMCUp8VhaucSk0LvUGnoIlcRkpImW+mD/Zf2s2CzkYN/LQ1j?=
 =?iso-8859-1?Q?2xSyXTSHTJMgwy1uhtSuVpxd0xTZxlgn5sf7x/45HH6kLpIDOG8z7rekhv?=
 =?iso-8859-1?Q?A/Awpfg0j8i1iX6HLWTtVoMv4A6yvoX1QgX0MuhzC1gcjzSxtoD56WGrGV?=
 =?iso-8859-1?Q?mT0uc42Tv4OqJocvQi5OTSZHVxEn7vuCzIg4wQ6osinentnE1nAH3kL5eG?=
 =?iso-8859-1?Q?Et3IcpGJqiYENjGM75qCxObJ3sONoxIneUhEyfMyKBQGdmVQiqkDiWQagI?=
 =?iso-8859-1?Q?TnAcHM3+thnRSO5RhvFDsAh3ILqtsF9o7UeLvUFCT3VbKbJYjf2T1ymzWu?=
 =?iso-8859-1?Q?ujwFaCnGQ761hRZXxAlpD1H1nh4mVybBFLpHsVze9UlxgiO0K9CkXQieI8?=
 =?iso-8859-1?Q?282+NM2GXuUH2klyrDDlWarpUzlre8qmZe68aXIcbthRPDaVkizOuHoZyn?=
 =?iso-8859-1?Q?u+AIJ/FIIX26Z82lBcYuU80Ng32UHQKuFIzYJgK00t+xe75HIUFw45usVK?=
 =?iso-8859-1?Q?AvNgq+syt3Rk22mqI7gHexbY784oOycKsWgk8oFP26sqif3aYI3hDrKDTR?=
 =?iso-8859-1?Q?NRZeaYMZheNxmo0Lh+aHEvkoUVQJQfYRajsj36DzMS9CT8nB5x3waET9Yl?=
 =?iso-8859-1?Q?bcVldbl6Kik5r+p90NEr9ENAR1prDV79m4UDS3ABdTWJufeLRnQ8//jJrm?=
 =?iso-8859-1?Q?kg3hqPRik63aln1nGrkdtLmVmVw4UCTF0jPiejOrRjFw1TGkS7E8U9TA+R?=
 =?iso-8859-1?Q?JVdzEvsCB6FPMynqgPiIauiIRt2cd+c5Z3hbzMAaO3Gxn7mR3Cytrm1AOi?=
 =?iso-8859-1?Q?PrqVOhMvKzCy2+dDF7wpQSAPUZxel12xxScyphj1AxADL+tWD7ZJ/dmwkp?=
 =?iso-8859-1?Q?DrVYj9D2eLh0I5jTrFcS9Uh4FmxCONVThA+khBGe5IJWZeSVSiT/iL2wc0?=
 =?iso-8859-1?Q?u9mpBUIUVOlTxvXxyLYQuFnMHdrfWaWqmiqnSunJ64xIYwAOBPyJeZJGUd?=
 =?iso-8859-1?Q?WdG6B+LLf+1UTmOzBkYXr9+oeY+ntYR6Jr8vEhspjoOrT2LFNkRJvtqt2K?=
 =?iso-8859-1?Q?pBLYvd+RhaaJp5eQSm8IbnCGKWcqIaRPmfEunh+vGJ4igDqAMlCo6vKqQv?=
 =?iso-8859-1?Q?4bWryJ8Yj6nbYEwsFc5XtoRA+XLFdZxzI5E31CUNV6VXil1Gd3CCX7joSA?=
 =?iso-8859-1?Q?aTQR+NjKvZZQp5EZonCeeRUoB9zLXL4nznEXVZQ2j23FHSKElsTwc22h2x?=
 =?iso-8859-1?Q?lY3gCl9hmE8LyjJAOKKLOo+Tnmc8lGE9QA7ErpYM+V2lQ5JXiL86qxramU?=
 =?iso-8859-1?Q?YZJ9xbzOKt0Zu1IApSMlHv4oB8kwlGW0Nhtd5IpSU89HUTGLe9Wv0bEL2a?=
 =?iso-8859-1?Q?KDonLpVQ6PAO7PVTDkWGdktk0oiptuk=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: peak-system.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB6PR0301MB2518.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9146083-17af-46d7-2930-08da1bbc38f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 13:07:24.8373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e31dcbd8-3f8b-4c5c-8e73-a066692b30a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MhNI9bR2JWrDK8br0OnqcVgfucVK8UsUUtuoZZnKUjcU7jVaSw0ZEDQSZbVJEEJglq/YNjjcm/2Li8CjrsECl6XMgvalkEIN3XuHoC8ET+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB8115
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you Oliver for taking care of this request.

These errors can also be caused by a lack of power being supplied to the de=
vice itself. Being connected to a USB hub with insufficient power can also =
be an explanation for these sporadic errors.

Regards,

-- Stephane


De : Oliver Hartkopp <socketcan@hartkopp.net>
Envoy=E9 : vendredi 8 avril 2022 20:45
=C0 : Paul Thomas <pthomas8589@gmail.com>; linux-can@vger.kernel.org <linux=
-can@vger.kernel.org>; St=E9phane Grosjean <s.grosjean@peak-system.com>
Cc : Wolfgang Grandegger <wg@grandegger.com>; Marc Kleine-Budde <mkl@pengut=
ronix.de>; David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kern=
el.org>; netdev@vger.kernel.org <netdev@vger.kernel.org>; linux-kernel <lin=
ux-kernel@vger.kernel.org>; PEAK-System support <support@peak-system.com>
Objet : Re: peak_usb: urb aborted



On 08.04.22 18:35, Paul Thomas wrote:
> Folks,
>
> I'm using a PCAN-USB adapter, and it seems to have a lot of trouble
> under medium load. I'm getting these urb aborted messages.
> [125054.082248] peak_usb 3-2.4.4:1.0 can0: Rx urb aborted (-71)
> [125077.886850] peak_usb 3-2.4.4:1.0 can0: Rx urb aborted (-32)

As I run the same hardware here it is very likely that you have a faulty
CAN bus setup with

- wrong bitrate setting / sample points / etc
- wrong or no termination
- missing or wrong configured (other) CAN nodes

I added the maintainer of the PEAK USB adapter (Stephane) to the
recipient list.

Having the linux-can mailing list and Stephane in the recipient list is
sufficient to answer the above details.

Regards,
Oliver

>
> Is there anything that can be done about this? This is very
> frustrating because it makes the USB adapter very difficult to use as
> a reliable partner of an embedded CAN device.
>
> I'm using Ubuntu with 5.4.0-107-generic. Any help would be appreciated.
>
> -Paul

--
PEAK-System Technik GmbH
Sitz der Gesellschaft Darmstadt - HRB 9183
Geschaeftsfuehrung: Alexander Gach / Uwe Wilhelm
Unsere Datenschutzerklaerung mit wichtigen Hinweisen
zur Behandlung personenbezogener Daten finden Sie unter
www.peak-system.com/Datenschutz.483.0.html
