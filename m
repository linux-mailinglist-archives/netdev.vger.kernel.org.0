Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08D92F0F61
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 10:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbhAKJq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 04:46:56 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19060 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728256AbhAKJqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 04:46:55 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10B9VIxQ013271;
        Mon, 11 Jan 2021 01:46:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=S5ndZupT+KIcVf8SQc8RbC7gz8STwgbX1ub7fDtkNOk=;
 b=Zmxb92b3VtkBwUqFH1GBKZDEiwI/BQjwj7APBdaJ+4prs9nw+x9npHz/vSZvnnv+roSj
 IQ7bWG+eirxFDb6rSZngVUM3Sxylw6nBJ35DQ+YnA3WwBhYpGpA6g3yupowNji8WFvhz
 tVvYdZwWHsGAkQ79j9Zg8+T6U5NsyxZSy5UuiryR8UgJfHfoD2g+1GYbGij3D4lkp2c1
 h/91LcR3O/yFdVWzZ9/Ih4fdl4FANmNXk2jVU8Fwv2Zg/TRv6EVU63ooDMSKUmUcUBI2
 795YM5TrPeGESfmNPzWGZs9tqkuKap1muerDJ28OioNIXrkmbIjB9ScBYYOEajYZ/tE5 /w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvpkgx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 01:46:03 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 Jan
 2021 01:46:01 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 11 Jan 2021 01:46:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkyXBOdcZU/0LFjeIjRi695sgrf/D5n5X6ThFVgTD4KDm8EbVkKsegdEW+s0B5ZN1WuqtX+In9WRb6bBq6VIFkVeqTNnezehAMutncx/7ImO2liZ6bkBYF3bkhWlD7ydkAYMkYc0mpLFLYrYsHFLzFJ6jjeoZJrTAwicSP1DB0JnjvAIAtw3sa3d1BYfxSjYVefRDsYc9Dai125dOm7QOAbv9/WuVswsOQwJKsJpHRfjvAYYzXkkxmcMczJe77MG2ocB4TIlwLIK0gFHEMYaUPvtWsFJsDCZGz8auR8JQ0pTuxtI/2PMeU4/h8mc7Lx9atAB5uYybj7fDo+QEiIdUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5ndZupT+KIcVf8SQc8RbC7gz8STwgbX1ub7fDtkNOk=;
 b=iiZyyi58l2XwkL3lIybaL14nSJGVeGUKuwIGBCeSXdrvQF6kFcrtxAGqQGbK6/7VOLWJfUuWGsW6we1zcDZHiFSxebpi3E6nhZMERwwNzMjVRY0CkltVXXKCt37Jqw/lfdBDYnAv0NHT6TLGdxyrcrRJqmBxGAkrir66xJdh5qZqYmYisa6uij1v2fwK2qVY+D0sIQNrow+Im24xc6Sz8k11aEHXJkaa3Hq3TKxdNdmv3KT5SP8thrdG63sKs1pU8MP0JYQFp/Y02ZHne4AIti7e1/thtvbKjvNXRzQvMOyJT+AMRA06PsZOxJIYdWThsjWFAe+HOw/UwhsSQVvHEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5ndZupT+KIcVf8SQc8RbC7gz8STwgbX1ub7fDtkNOk=;
 b=ARB15r/0sBEvLBMkUwZuARZa+YNcGJ88qaYHsWeR8JkSpQ9QUI9j7Wr+xRXRAq2dh2HDG6mgADJKT6+CcIsLbzG/iSfvqLI1FXvMXDLmuPO2fQw0aVnNY6+dQvK+qufyCR9Z8y05hckK0BcvAqSDeF/zIQU/FcK+wczyJ+EI9Aw=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM5PR18MB2215.namprd18.prod.outlook.com (2603:10b6:4:b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.8; Mon, 11 Jan
 2021 09:46:00 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::201c:2fc9:faf8:16a9]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::201c:2fc9:faf8:16a9%6]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 09:46:00 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     YANG LI <abaci-bugfix@linux.alibaba.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH] scsi: qedf: style: Simplify bool comparison
Thread-Topic: [EXT] [PATCH] scsi: qedf: style: Simplify bool comparison
Thread-Index: AQHW5/xPMjaiGOa6EkWsr0V3Ozfr1aoiLLig
Date:   Mon, 11 Jan 2021 09:46:00 +0000
Message-ID: <DM6PR18MB303414DF7A9072E46A5B503BD2AB9@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <1610357368-62866-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1610357368-62866-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [103.103.215.17]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d26ddcbe-0a78-4286-7a59-08d8b615b43e
x-ms-traffictypediagnostic: DM5PR18MB2215:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB2215088A758D482ADDDFF211D2AB9@DM5PR18MB2215.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y3YrV7fcMXMYFTeahJUX7LWNkgOEsi8NQ3vH7OR0WM4D1JnqCzcenmKOInPXzTq0Qr7Q00crLd8n9uHcx02NZAETnc/obrV0EIVzoCHg5upGhUMmAdq/O524glqelKSPBGDYCUuh6vocYVcoIZ8pjnda1Zlt3cOD8KhaKhuFvMIU0mhb4TWqlRE+EyMp8SsClWKNO5gPL1DNhPyQH9/4DwIZChHr1YjzjRWxkTWM2CuUis7HwILqs1T0+x6NwH0SmcASkGexLbShtz0Qyi3Htc9lC07qrLeJTdsUPSJz+ClEUh/H5r1lv3I65toD1Keo7Fh7UEX6tqe81EJ5ZfHmaqM3tXNN6Br3DJSuZER81dwYUpuEtUN/hyilJmdyfLR5Z08lBvjuzOEJ5B+32aVDzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(55016002)(8936002)(83380400001)(54906003)(8676002)(86362001)(478600001)(186003)(26005)(9686003)(71200400001)(6506007)(53546011)(4326008)(2906002)(66446008)(52536014)(66556008)(5660300002)(76116006)(7696005)(66946007)(64756008)(110136005)(33656002)(316002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?jVt9wVrUKifzMFNIQzlslkduH92hivSX0q6x+u4mfbD5PBLUJS4Xp5geyvQo?=
 =?us-ascii?Q?2u3DaKBniiG11ascz2a4pa3ufDUJWbF+T5KVmLRvLBAew/fVrRgRZzSvW9iy?=
 =?us-ascii?Q?8pVbw/8BKr7SaT2NE+NDbNHu4VVOgs+I0MsL3Kl/6nGJcAgJFdim3NY6BTT8?=
 =?us-ascii?Q?gkC0hux+dru83sB92cyw6xnEP7rcpHyl1JawdLCWbXqchXW+/bddV20pmuiU?=
 =?us-ascii?Q?+zqEpVLX5gM5fn3Go8nlN4KDGq66LG4hTlMshQjapaUWZu+aE890Nl1ktwqR?=
 =?us-ascii?Q?Y/zQr+XrIwFEVDxtruZlpwQ/dKBpj5gEfBueGDGsoXPLiuxaT/K41xbKXej5?=
 =?us-ascii?Q?k2Q8ad/iNAVj74IG6lFZ1GtuTtwwKIG1jrcUhYaWnSD6tCdMGG0QP1zYEkya?=
 =?us-ascii?Q?dVQptmvxSB++7NbLFcif1rznISG252Z6VFRdsF9vF6FdozaBtoWuwz1mubDZ?=
 =?us-ascii?Q?Pn8gTN4KiYrodP4yQ/y7+Y8X8xk7bAeyg9tyLYE1qP4dOyJf0zQYQyTUl6Kr?=
 =?us-ascii?Q?1dR4450oAuOByo9RSidRUO/kKiZD9YPMKmzEXCvRALVdUQPUXrqapOuUpQKa?=
 =?us-ascii?Q?u7prM3e9O+J+J1BYIBouLxFeDX9lXk2qcnFulKElBL+zV9ADbigUq98IJPAg?=
 =?us-ascii?Q?gLKAsbJO2Zx7bxsHKAgFOqVU2wXASnAnvYRnPfvEQjmRU9WwxIX+U3qkmSvB?=
 =?us-ascii?Q?5vHAhzWY39UIOuo8Nceb4fJ37YECjIgomZkGUg4eR3fsTzhv6eC+r51q8W9F?=
 =?us-ascii?Q?SfgGtnGC0UVtCaDjvKa7ZfJJAQqCJjobRgJtDf+Tj/qh8sp8uf0lSyS+ZfF0?=
 =?us-ascii?Q?QOWZnXR4WxpIhdmdnsJGpGRgN/ZfcMm3GR5Oc5o1woOSKZHgOTPftuuxI9R8?=
 =?us-ascii?Q?QFOaN3IcxSDRzXqU7pAlEOiYbCQp+XCquNyPyBWlQJm9ZFHB9VzuH4gk9tXZ?=
 =?us-ascii?Q?WOPoZqbckfomVN9sYeXKlaXg1yrut1uRVx8hKQ4H0K4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d26ddcbe-0a78-4286-7a59-08d8b615b43e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 09:46:00.6257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fpRNXHJBLUANQl2tBsy6Q0nNj6g72xpDaFDmOPYdLl/OzWkpTdJi4jaN34rtWcJEnQbGE/DfrahkpJmeGp1/JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2215
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
Thanks for a patch.

> -----Original Message-----
> From: YANG LI <abaci-bugfix@linux.alibaba.com>
> Sent: Monday, January 11, 2021 2:59 PM
> To: jejb@linux.ibm.com
> Cc: martin.petersen@oracle.com; Saurav Kashyap <skashyap@marvell.com>;
> Javed Hasan <jhasan@marvell.com>; GR-QLogic-Storage-Upstream <GR-
> QLogic-Storage-Upstream@marvell.com>; linux@armlinux.org.uk; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org; netdev@vger.kernel.or=
g;
> YANG LI <abaci-bugfix@linux.alibaba.com>
> Subject: [EXT] [PATCH] scsi: qedf: style: Simplify bool comparison
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Fix the following coccicheck warning:
> ./drivers/scsi/qedf/qedf_main.c:3716:5-31: WARNING: Comparison to bool
>=20
> Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
> Reported-by: Abaci Robot<abaci@linux.alibaba.com>
> ---
>  drivers/scsi/qedf/qedf_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.=
c
> index 46d185c..cec27f2 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -3713,7 +3713,7 @@ static void __qedf_remove(struct pci_dev *pdev, int
> mode)
>  	else
>  		fc_fabric_logoff(qedf->lport);
>=20
> -	if (qedf_wait_for_upload(qedf) =3D=3D false)
> +	if (!qedf_wait_for_upload(qedf))
>  		QEDF_ERR(&qedf->dbg_ctx, "Could not upload all sessions.\n");
>=20
>  #ifdef CONFIG_DEBUG_FS
> --
> 1.8.3.1

Acked-by: Saurav Kashyap <skashyap@marvell.com>

