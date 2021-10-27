Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0BC43CCD2
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242622AbhJ0O50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:57:26 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:33874 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237296AbhJ0O50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 10:57:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635346501; x=1666882501;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bj24C0PDYDsmX8qo+RYNRaqqOq80a6QCiy8Wl+peCnk=;
  b=bPh/0bdO84/3vFHG1FnAUwS4MvPf09JSBfA/XBwBjI19oBvdWVJhy8wZ
   xngvAhzxefaXIJyBcMLbSUooKUSdXAJL8L+aIJYB4r7YUSzsJgaQhmsdr
   JhRlVoSLZxXNqjWM9w8zD1tnvF7OpPuLwDYWs5QqOj3dntU+EgB/FM6WV
   lUjIA8bBQHcUBLJJdT+NdZTcItxldBggKnYI0mRedAW/XIubgaBz0rMf3
   LxLhXq3Zp5TZMbgHA3lqiO/LStd8K2eDXevTCnTPJ3YNPExbn8y+MpBx0
   hv6vBpQgnF2RnKQ9yyPX0stdwJ+tOVMpixS47I1g+WWnzsr5I46kKAhDZ
   g==;
IronPort-SDR: K1r9ugFZt7APh1XK9IATeWntC/b4+PA7mnLDaLsQ/B2jNQOHfd2TmdD9xMtr0jCmD0Pf+VT6uR
 Kn2JXV84+J26UWOH1ZT4QNXQAttk20ClMbMmafB4sMm46ussk9hDcu3JSpBn6Nmjkmz4CIfMZC
 Wh3QFlgu/rDa10L0yNfg2f6Tb1YeapKVwimdyHNxFBBXcULAfFHI/mCSh4txEzaW4jIjdNp1jD
 IgEKnmPCuZ1oCDpJ02vIY5nJ9VElmYxY+wohEOhP8svgUB6M95l/1y8emQzsbtAY1uuJB73wO1
 uWpg/o9HuBYC/XHi+44A0dXH
X-IronPort-AV: E=Sophos;i="5.87,187,1631602800"; 
   d="scan'208";a="137066143"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2021 07:55:00 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 27 Oct 2021 07:54:59 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14 via Frontend
 Transport; Wed, 27 Oct 2021 07:54:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jss5qmalDOnqrYuCqC4FGGbuTFuy8gYehW7Zd735QTKqwtvFdBTJDXb7lu2QwXiDNKH2kyA3R6FjytkAPjl5Y5AryqyD3KgGhVtJuIDpa62BznLF3Pq3e5xGbo65LCO7UO2TfD/0OU0ukzWzbaVVBF3kPtNj5JCOgPFyBKbaVtH9Neblq4Bpazzt84jUU6Z2Y34mURbOP/IZ3wl2m1U+yUgzUAX2ukyzu0LTPbGRJTObaWaM8LEA/n9HyPUyeF2YfMslKGLSRHrxhPt0xhrvJq7Y5fg9bsIiAue2O71YBlWYM9dWoOZ4klsDNCTbWl7wVIu8xxYwufOAgohU97qNOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xWHA5p3MrHzPuzY2rVu2oZyMxH+HVdlWtBMZ0UFsEdA=;
 b=oN7aSE0PNWGjRx90zmDLQKnE7m3dqJIoJg7Mzxj6cHFNDSCJH7AFQz7EEx2WAEgtvh+ZO1Bw8jJv/wkQO2vD4xDY8sRsf4+Uo/A0MI8uAQ14NRaZjxBa6tos/GG2xcoSqyGNyJZj4vVng9ibRmgYTC7USBvaDJX6N8QbrjOcezQpTWYUdxSjiixJwDlXnv24PMobne5haPcgw2KnXXkSGy88dl5mqyxCDED6qoGLx5ggDkyQ0UcuAYYregOHsvFLme0CnTpfyjGz11qRPkCyd3mYUyNI3+0fSprRdYKcZ60IP88LIYrla0cALMVnhYGxtDTER375BbtjV/ei3bUlDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xWHA5p3MrHzPuzY2rVu2oZyMxH+HVdlWtBMZ0UFsEdA=;
 b=sKILlciDWbfH3lqFs3MZHRjCXJvYN5Hj6PnPJIzaQ6EyR0AtMnSMXDWOe4xfFB/HUJ8TsYhH0qgc6bDEglxzFcGEySFZdkou+OtS8z5mFUvKFQPc73HZjy0xK9D+uCRlFU14WYnIILa9byN2ns+4+UJJtNDQStT1z8UcI4BaIN4=
Received: from CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8)
 by CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 14:54:49 +0000
Received: from CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::4907:3693:d51c:af7e]) by CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::4907:3693:d51c:af7e%9]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 14:54:49 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <Nisar.Sayed@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next] net: phy: microchip_t1: add cable test support
 for lan87xx phy
Thread-Topic: [PATCH net-next] net: phy: microchip_t1: add cable test support
 for lan87xx phy
Thread-Index: AQHXx3OiBAiK8WCZ6kqAisnfUJKPX6vfbvYAgAd+HxCAAAbgAIAAAfVw
Date:   Wed, 27 Oct 2021 14:54:49 +0000
Message-ID: <CH0PR11MB5561557053129AC2BA1E5AFF8E859@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <20211022183632.8415-1-yuiko.oshino@microchip.com>
 <YXMXeuMUVvmR5Zrc@lunn.ch>
 <CH0PR11MB55619DF408C4EC0D729BC87F8E859@CH0PR11MB5561.namprd11.prod.outlook.com>
 <YXlmSByDhPo0ZwWb@lunn.ch>
In-Reply-To: <YXlmSByDhPo0ZwWb@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98f22171-23c4-4f35-a83e-08d99959b9ac
x-ms-traffictypediagnostic: CH0PR11MB5561:
x-microsoft-antispam-prvs: <CH0PR11MB5561D99B4C31FF7F9EB4B9158E859@CH0PR11MB5561.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cGM7RYTlyZPnETN3SskUsBown0plD9ebY9zPopOPWN7qo9pweMJg2rWDkMfpKH6dU6vxKiH/RVVgaPlVu8cKQ1Beq8xyccP0lV/lRRpBKM99BEP06C9lEo2Wf1J8OdHOiVouRUSG/JdEia5XOwIHT04ICMUDf8KgU3wbG6z6adeEqI/WdI3X2fDehI2VZ+b/jkGUNErTobziac7FlRd0706Tg+irUbswoq0udKuMUwpyypVH6K4CMhNnc52QmBRvF+JhpQDOVnLZhXcdHlNd769XtvDUSdKHeDND8wMg3OEs6R5wL0uRB1NTxMEr64+QOKx+CYmBuLwXmnsCta304Ei0sRQXExh/lyaoUDqbkQtBwyFdHq0LT5LSVirwjt+rBSo/o9zp/vsOcVdVY3k3CvRKxdueXhSRH/Flpc4kRP7T89+S3K08/e4FsaOrV0uKatcT6s8GETmvg1swnOQb0eunWHG3+AxaiDKUJELsCu1JX9WJQ+etzznh9EItz647FrqOUUKUsWOsoiKODNlzNS68QRGeX6XiApeYr2zpNGeMp8nWxeYxFqF/O46cBpusZ1EfRAfiKc5LJICjyIM0/AoG8G7WzmVrMEvmYS75Vbcy9IM+J80vJZO8MKiO4jMWaz9wJWo6JEqbt64MBBjMfHSqKEWkFV2gvv4F8Ppk0Lgowk8iiN7fNpoGGUqP2Qgcq6aEu0dGTEAR0qkgJWPTTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5561.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66446008)(83380400001)(76116006)(66476007)(64756008)(9686003)(38100700002)(55016002)(66556008)(66946007)(107886003)(38070700005)(122000001)(86362001)(54906003)(4326008)(6506007)(7696005)(52536014)(316002)(2906002)(8936002)(71200400001)(8676002)(6916009)(508600001)(186003)(5660300002)(26005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TsUs8Hxk1PrVSPb4INBr/K2WMq9eZ24AJHPNqycsWw1C0et4S69DyCoXnd4R?=
 =?us-ascii?Q?/ao1H7eCNggCc2h/DoEUuT+rxum7UM2KLn9IHkSXNwQEuShxAxQgS1F9QcLf?=
 =?us-ascii?Q?yLHJR+jit4uNLYzlu0hU32Fovo7ccrwpWQ5FkUn7NpxWYAQxGXoo092gkzd8?=
 =?us-ascii?Q?EVBGd8zLp86KLTsa67bZwHbGOIC3R5vrJ11mEXuG9nS1BVd8IANtFb3YQUx6?=
 =?us-ascii?Q?JlinSAtCfTd27MI/S0vGkYxHE0yXsgNdjsfKwsXfGjCTIU0SOjU+Ck9033Qm?=
 =?us-ascii?Q?yjy5UM5wT8RnRvn4Rt7h0Unr3mYIYNv19YJL2iCFP3HyQSBcQ0pgr8OE0DC3?=
 =?us-ascii?Q?PH1vhodwNGh67GlI7QP6HnL9p5DJRfvFH19eXW9MF4rWHZcC8GWUyWJ9kGts?=
 =?us-ascii?Q?UCuU0l1cJuPT0spFgDhSc+TZ5O0J2BCdK0kcGBnp8fMNlVFZYoTWAV+PeTws?=
 =?us-ascii?Q?dbkn0/ymJQhnYHQXSkRSFoz+aLQHZh2kKUdFzCU4Kl1ZtJBOU/bhqe55Vc3B?=
 =?us-ascii?Q?2pYZZwBaENMmM4rZBe0t3nfUy5krGMDt2UKobwg4CRLdBCcHiBgbsG59CQWL?=
 =?us-ascii?Q?RdcZvEbyifL2HPECCq0Z3gqJMf6yR+LTI5K1gDRjmvNXX13bEJoN6YKyTG/K?=
 =?us-ascii?Q?BAuFX8wvPyQaZaX4+CnHrQgR06y1RBR0wx/Be2Ec0vnmMsDig0EaVWj7HtOs?=
 =?us-ascii?Q?qXNkvYEPkfXFDJOcUz22z4TdOaEJ8bCaofXCs6ckOojIDCz8m+plM7SViLLG?=
 =?us-ascii?Q?/DgSyq8OPO7wqqTz0yNneCvaKhnJYb2NCAAWBJ4cxWYbb+I0NR75Ojm7N2C8?=
 =?us-ascii?Q?PLiKm8tWiUOaLeLqRC8kI2n8ejm76hy+KegIXERc2tmhj5eD471/1dbMqrZ7?=
 =?us-ascii?Q?XPLv+RPq7N8SjH4XyPK8N1+hRgZpEZwQf8a+yRqwm/yqVSiOIzmRsVkCgl0S?=
 =?us-ascii?Q?j7+wrDRfYbNVRr06iOao+7EJCmarKkxV+dYgjYpEE5W9qrzDcyoMU3GqN9TY?=
 =?us-ascii?Q?3EnWL0szSBvzBjut9pKrcTUnwPhTAMyctAv1icbvPt/Pu9PgxCyx2W9UKdsj?=
 =?us-ascii?Q?yJrTCtHKljjCpMkVniwiGF/XKh00OcWtRxIaMyBgq4lhNuBjmrGVIRWbZN8B?=
 =?us-ascii?Q?Mh6oJ5zAYSA2a8zmvwmRMYe6w0qOaAZZUGZcPazeB7qDpF+P6aRsjMppkBTP?=
 =?us-ascii?Q?FX5+JXGWxQHzkPturkDp1OQLXjSfrOy/AAjF/ktiQU6u/fdBfrUOSPRIyKuh?=
 =?us-ascii?Q?9+EjodHXaILxQkvV/dLcwfXb7XrES+FNWe870L3fbmGaYOgNMTPV3eALU3BR?=
 =?us-ascii?Q?OpKRodKqGHl3N+kp0saFkDZyEpHOKNgeOXtjaLMKMAV8Nddpppy5ljUUzObV?=
 =?us-ascii?Q?vLEQeMLbMQ2eiFHDi+wuu+qtueyqSFSp25y1f8EnUVdCsxbbwr0eRPhyaDBa?=
 =?us-ascii?Q?UM8LHXbFFCQ1OZOBqqmf3dDOePen4PRxmrXtH1YcNEbgNUNmM9rm8EX9BILu?=
 =?us-ascii?Q?dW+hwmnUpQi4smMJNDOeuxyDBicr2+IUT5OHsn+z/ZWpCYlspkyzX6rGFu4B?=
 =?us-ascii?Q?TodARi3oWVPp4f1GVIQPWFH6CMbTRb5t0a6SEtrdNNnQa5nrgMQmhj1/+KiO?=
 =?us-ascii?Q?OxoP75/WETxz0nHMVdI1H4NNyhTd1HqSsrlAf/SglFyU0vYnxEmekGEWYzRl?=
 =?us-ascii?Q?wiJL6A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5561.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98f22171-23c4-4f35-a83e-08d99959b9ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 14:54:49.4789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bbIoB4qYeD2i+Asj/ZGmfwzVoc+x2w9sfPIaU7PcJb3sjIdB1Bi4Sjk/6YDakZ+KZj263/s79JbDe12SuT2+cMfTn5MdfGP2eDWOXMoBocs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5561
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Wednesday, October 27, 2021 10:47 AM
>To: Yuiko Oshino - C18177 <Yuiko.Oshino@microchip.com>
>Cc: davem@davemloft.net; netdev@vger.kernel.org; Nisar Sayed - I17970
><Nisar.Sayed@microchip.com>; UNGLinuxDriver
><UNGLinuxDriver@microchip.com>
>Subject: Re: [PATCH net-next] net: phy: microchip_t1: add cable test suppo=
rt for
>lan87xx phy
>
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>content is safe
>
>> >> +     /* start cable diag */
>> >> +     /* check if part is alive - if not, return diagnostic error */
>> >> +     rc =3D access_ereg(phydev, PHYACC_ATTR_MODE_READ,
>> >PHYACC_ATTR_BANK_SMI,
>> >> +                      0x00, 0);
>> >> +     if (rc < 0)
>> >> +             return rc;
>> >> +
>> >> +     if (rc !=3D 0x2100)
>> >> +             return -ENODEV;
>> >
>> >What does this actually mean? Would -EOPNOTSUPP be better?
>>
>> This register should return the value of 0x2100. So if the return value =
is different,
>then I assume there is no device.
>
>If the device does not exist, can we have go this far? Would probe of the =
PHY
>failed? Or are you talking about a device within a device? Is cable test
>implemented using an optional component?
>
>      Andrew

You are right.
I will remove the two lines.
Thank you.
Yuiko
