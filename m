Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE0022F212
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 16:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730303AbgG0OhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 10:37:13 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24150 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730284AbgG0OM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 10:12:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RE5SS0018033;
        Mon, 27 Jul 2020 07:12:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=j/2YbaL1mJYLGFue04EucGlo4sIe1qJEMeNPP2TJjX8=;
 b=GLvGeUrkl2j2kMQn0StS8UYocWYQMOpp5eiVQc/JbqW1eV5D9Mr7R6ZCw6lurh9ajiZw
 CKZe3x7JeaqF8iRTzLp43GqNQ5gBCvKCTdOkEGL7Wi0EfpDhIljuuoBLTiN6muRt4fc7
 qVMQty6hglM7+e8h6eCPCmYSwRxlqzgC0jlNt/6cbWyRvQuPsYYlk6LgvYj/zxk6E4qE
 ZwylKxgR3cNMhsdUgZ6TCjPcmB91PcCCsyZc+oOa6VKw1HUnI3YCvzG9vP5iEOgj8b99
 jJbJIAVmvSFp6AYkITcLj6Mkoj40h1dluHCJhOerKGF7AFiQdxb0IQAqMzPBT4fO/5+N 2Q== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3qqkq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 07:12:51 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 07:12:50 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 07:12:49 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 27 Jul 2020 07:12:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bwLDmkI+reAJ7Dy3xneMtUJ6uqRqUT63R+++ODW2PigElKKJT2L7JDWOC/6VUvc5GSaDcql0kmRgxHqDoXPlR9PBTnwrBT0fVuCGekdb0qJjY6Ns8b+i9NL7cw3pQWlalySrxJ8rI3AxZu5S980tE6TZNQBm/PXGsBkYoz6AI8RiIckHy96BAxQL2+QrNYSSSvqtCKSwbL8rNmRkLGI9pExnR5lqZDdHFAoUPGoJ0PFamDibbgH3xd+cBX0ouxy/KhZfd3Akk4nKc6+EwjBUrSV8j4IJXCKEuODUOCwc7/+6y73+oh85tua8vfI81yNrqgF6gknhPAihGCnIWcEJGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/2YbaL1mJYLGFue04EucGlo4sIe1qJEMeNPP2TJjX8=;
 b=MStCCUCZXuEyyVXsCn+DxWsWMs3otB83a6uR9uQPEQdPyYoYqhsV3SkSGjqwdtDAQXoFy3gXdhuKH+cndj5nB5D6LEZJMRs8viXzU92bHygaoSpEULhG9G4R8wXGzhXLP8aWFNYfQCuB+dm9s2T+nOUXMB+DeFFjUudgT86hTKL+Q3q06mzN0xxbOWTd57tajhUcARLPmV/4JV39AfcSoZUr11d+0UOSgmqmm9WY3P5euWQRrU3LQgVIqHpVw9EWVVA35WkZzYG5qkmRnGo4E8uimJs06I96mkkLIW8ke8Qqd5aclUrxKxe342VVpouC4tFbbo679jzWZhJZVplmsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/2YbaL1mJYLGFue04EucGlo4sIe1qJEMeNPP2TJjX8=;
 b=Q8pM1As2vUD6ceW55OihPoyFOd092UrRJvmf0Urqp7rkdtNa1qn6w15KciOvC754svQy/qy/SaXis0EFHY+sdXnwajus0dJVnSaJ8f7t28bbbX+P+Om68pJXv2mGCumRi2kTMe2B7MgOWwye6Pj/fQ2iCxQahe242NlwpUj2qUE=
Received: from BYAPR18MB2821.namprd18.prod.outlook.com (2603:10b6:a03:109::21)
 by BYAPR18MB2470.namprd18.prod.outlook.com (2603:10b6:a03:12e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Mon, 27 Jul
 2020 14:12:47 +0000
Received: from BYAPR18MB2821.namprd18.prod.outlook.com
 ([fe80::2589:74b3:1752:477e]) by BYAPR18MB2821.namprd18.prod.outlook.com
 ([fe80::2589:74b3:1752:477e%5]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 14:12:46 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     David Miller <davem@davemloft.net>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Suheil Chandran" <schandran@marvell.com>,
        Narayana Prasad Raju Athreya <pathreya@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: RE: [PATCH 2/4] drivers: crypto: add support for OCTEONTX2 CPT engine
Thread-Topic: [PATCH 2/4] drivers: crypto: add support for OCTEONTX2 CPT
 engine
Thread-Index: AQHWYbuTdqiJnfrk4kOmSd/Bv99WcakXoBSAgAOqvHA=
Date:   Mon, 27 Jul 2020 14:12:46 +0000
Message-ID: <BYAPR18MB2821DDBE4F651E423791C422A0720@BYAPR18MB2821.namprd18.prod.outlook.com>
References: <1595596084-29809-1-git-send-email-schalla@marvell.com>
        <1595596084-29809-3-git-send-email-schalla@marvell.com>
 <20200724.201457.2120372254880301593.davem@davemloft.net>
In-Reply-To: <20200724.201457.2120372254880301593.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.57.134.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d7931f1-199f-4885-cd1b-08d83237232a
x-ms-traffictypediagnostic: BYAPR18MB2470:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB24704FDCC3FF7D3AE808CB4BA0720@BYAPR18MB2470.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dBERgI7qnr0of5Jbiz7blKv12taZvPDJ2tfBSsxetiZcAPzsOE59Bb/+rb9HUxq6YDIkiN56lf/SCS+cvykzCJGGrkw9gYgm53khq3WugiTI9va7BzXzp5lxb91Ro62zfupn+3WGlJe8unOGBSzzEV5KXUEw41UicUllXofMTDE0/KJ4yBdIlL3BYnGdBTqYj7ujnhFux0V95Ty0kmTA8Ou8oBkmB7GW52Tn3SOp2uDsGZuef/ndji4s8ESDqZmjyWttbknGqJq6JcJm3/V8l/EbnPKCdi5jP7Gm51fwMDu0q+8jTwEKaeb6t0thpTsGRHjcx1HD9ZATCJaIO6Mlgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2821.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(6506007)(53546011)(76116006)(64756008)(107886003)(2906002)(55016002)(33656002)(5660300002)(66446008)(66946007)(7696005)(66476007)(66556008)(52536014)(8936002)(86362001)(9686003)(8676002)(186003)(83380400001)(26005)(71200400001)(54906003)(478600001)(4326008)(6916009)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: BvNCvk1YZd04XAB1zL4caJOXjGH9R5INMgcyfWBTSFEBTPncWerVgT9c/wSHigVCsqMsX+Hoy6yLvmqc58eqsTIelhGUIPK2HjBjHr1i5k807pTg9wyRb37vPNj8jf3SMZMX7/nCOBEwJV9YGEkJx/h5smSbJYMCgIQ5Vh2wngGHaTB5aFpWZ9uuTkptmVOv3KTdHcWsA+L11m2vSZXp/+87H7xf9p16LXuF/jwFTB6BPZeXNHwXuFjkycYDdtt5kS48ltthGp2UiORYPSNkQ2sgY4oq+2NJv/PifALExoWO6rCCbf2FGJb5Se/qBMTfBP6btVYfPTHmgNYNyef3UYF0TDYeGpFjxEBG2inZbSOCsc+lnSL758qqxsrTCCNktijnYtJY3HXQdrTBVFq23oSuaeMcwO45WSOhmAyM/jfq+UPx71VHFnlHk4m7q1EQV1Lz2NmUIF48MBuEwFq+YWwABx79oHilxNSL8k3JZQs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2821.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d7931f1-199f-4885-cd1b-08d83237232a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 14:12:46.5174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jcAOmBo63lyIWLD9v37iOQv+2p0aGaMYFj/MyPC2junYSHBUSZ9qcOefYrVyoMAp2tLZfvZ2rNevoobLWLNiJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2470
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_08:2020-07-27,2020-07-27 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-
> owner@vger.kernel.org> On Behalf Of David Miller
> Sent: Saturday, July 25, 2020 8:45 AM
> To: Srujana Challa <schalla@marvell.com>
> Cc: herbert@gondor.apana.org.au; netdev@vger.kernel.org; linux-
> crypto@vger.kernel.org; Suheil Chandran <schandran@marvell.com>; Narayana
> Prasad Raju Athreya <pathreya@marvell.com>; Sunil Kovvuri Goutham
> <sgoutham@marvell.com>
> Subject: Re: [PATCH 2/4] drivers: crypto: add support for OCTEONTX2 CPT e=
ngine
>=20
> From: Srujana Challa <schalla@marvell.com>
> Date: Fri, 24 Jul 2020 18:38:02 +0530
>=20
> > diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
> b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
> > new file mode 100644
> > index 0000000..00cd534
> > --- /dev/null
> > +++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
> > @@ -0,0 +1,53 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only
> > + * Copyright (C) 2020 Marvell.
> > + */
> > +
> > +#ifndef __OTX2_CPT_COMMON_H
> > +#define __OTX2_CPT_COMMON_H
> > +
> > +#include <linux/pci.h>
> > +#include <linux/types.h>
> > +#include <linux/module.h>
> > +#include <linux/delay.h>
> > +#include <linux/crypto.h>
> > +#include "otx2_cpt_hw_types.h"
> > +#include "rvu.h"
>=20
> How can this build?  "rvu.h" is in the "af/" subdirectory.
On our test setup, the build is always successful, as we are adding "af/" s=
ubdirectory in ccflags list ([PATCH 4/4] crypto: marvell: enable OcteonTX2 =
cpt options for build).

