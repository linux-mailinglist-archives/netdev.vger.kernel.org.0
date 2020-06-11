Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E4F1F6F97
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 23:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgFKVtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 17:49:20 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52350 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726506AbgFKVtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 17:49:20 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05BLdwKg030713;
        Thu, 11 Jun 2020 14:49:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=TgLiVXSSk0m057g0Cu2mypCqex4bbEhLMxhcMRre1pU=;
 b=muZAhpq5qswXvke7hFOL7+wGY1YsIbNbew3sCIrEaTQZ2yA0AusIKvqwmbvz5nqDmBo1
 z/DgBqkn49MFhFW+Z5FUHu4kGo4M7l5RcYyxFFliP89TAna7DYNAwY5HAFlm0F0kyzfI
 /pWxEl21CfR8qnsZRAfdQYNHT6AGBbwTIoYLijT8+NsmQfP7MHNkxfGluFaRHDy+FlSz
 oqLB0AcAEK/DzefTk1rRAkg9WKyU7agbaVQD9mxRpkkqBQMgdINz7TYUMX3bhudMS32I
 r9Mxzbu44otT5AEsKyqC31XhUeWWEEUbg9yDueaVCFIXjqGSCbsBqMtTcKhh7BVt1asp DQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 31gannmr72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Jun 2020 14:49:09 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Jun
 2020 14:49:07 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 11 Jun 2020 14:49:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXAbtxya7J2AYu4PIleX4G8T0PbArCYyxpj+Cs41qQ6o8nQ7Jh4oFsbYZdFMltqwBPQNDEka0/3iwR84K9TKmqrWjATO3pMBZ/qW8exM/JZhtoAsR5FvfH1jMkOc4yjtkTh5gHhsCwUvZtQH8oOG0AZ6sWL9cTZ7Q8lTdOFyrf1//YOPV37jOaPdOL+MjDT2XZxyFHX6CYJGtEdKLI7NuGLEAfK41b3FBQnUiErm4WN2PyO7fHOFj5j4pOPgb97RXzvXKhJlbsmcozEsXByQCCwiP+0R6LDzfPVjfvTOszXzddIscqBejvEnhSpH4f40P3ixRA82YpD677b8DgVsFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TgLiVXSSk0m057g0Cu2mypCqex4bbEhLMxhcMRre1pU=;
 b=nXGaI1veZsbyXtaTkFaWM7H2/+EnecrYekb5oyDB++zYrMarYu6fXrkaoRMM/s6SN+BAyhDKHgrtzqVYcMkrRDgDL/BbAPGmMU86M51int2+BDN79cjsuqbnfeomo5wGxSTDraX+mA+TePgz4RtWYgAF8EMJTUIaS5fAJFrC0w7yo5CrlFEHzzinipOR+yiqJcMzVkMY6MhdV5L6KHuFKZrwoW2g97Q9+KvUiou0y7J8cJ2p/f+SctU9pc941RJ5KXMup6y3AE+JzGkafqMKBAltzAcHQsEGgm4qMr9W00ACoVPcz7f7Qk76xanhT0Xl0miKNghZ2oj2MWkWSA12vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TgLiVXSSk0m057g0Cu2mypCqex4bbEhLMxhcMRre1pU=;
 b=sfCvKCJ99f+lw5cWMlYPmgfjsrkIGcBhXfOP5xuYCzw3Ctg9zKEKVc2UD+i0sMPSzW15eXftd1HdI4i7i65zzrkAnMRgeJRd3zwPRACK4KHrwPu7UALlptjsPmvrWBbw9dl0H+YmPGLHPkxi89V3z6fz2osawxJKxNoLqB9o1Wk=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by BY5PR18MB3201.namprd18.prod.outlook.com (2603:10b6:a03:196::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Thu, 11 Jun
 2020 21:49:06 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::bd3d:c142:5f78:975]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::bd3d:c142:5f78:975%7]) with mapi id 15.20.3066.023; Thu, 11 Jun 2020
 21:49:06 +0000
From:   Derek Chickles <dchickles@marvell.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Satananda Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>
CC:     "frederic@kernel.org" <frederic@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: liquidio vs smp_call_function_single_async()
Thread-Topic: liquidio vs smp_call_function_single_async()
Thread-Index: AQHWPZVeTq5slv711k+l1VD5JH8To6jT9kwA
Date:   Thu, 11 Jun 2020 21:49:06 +0000
Message-ID: <BYAPR18MB2423B06D1366DB7D32A82C13AC800@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <20200608130430.GB2531@hirez.programming.kicks-ass.net>
In-Reply-To: <20200608130430.GB2531@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [76.103.165.83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d73b928-fde8-4b34-f998-08d80e5143cd
x-ms-traffictypediagnostic: BY5PR18MB3201:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB32015FF0371CCCB0A9E7949FAC800@BY5PR18MB3201.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0431F981D8
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8OQjSaY0g6VIXYe1OOl+XguSn/jlPCPdm/AwM19/RjLdmrdDny+qFBI3kAA/jXsowF6hVU1ECba6mlbs4FDjt4PegdYu9V9QLSXMMUfsz0wbgo3QKT90ks/dpxCBn5cPcNiBSZbjinBIk9QSwMMOyeLwWOo2Z0ccPiUyb3QyP5icxPo6Co16kRiwXGdlRXCVlQtavI4+hIoY/UfWERuOHJsEmjEPKdATnBZUJTOeULmAWIUU5iH2TlvEugsWgk9cose1BSoVM9AM/yOC5kYWZubweGsa6MGb2KeCEf4ZXXPNbLm1EQhzVP5625iCAHFONvD1nOypSdFQHt71+xQIiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(66946007)(8936002)(55016002)(66446008)(64756008)(71200400001)(66556008)(478600001)(66476007)(110136005)(6636002)(76116006)(33656002)(4326008)(186003)(86362001)(316002)(6506007)(52536014)(7696005)(26005)(7116003)(5660300002)(54906003)(2906002)(8676002)(53546011)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: BG28QFay0j3IjZWqnG43bZsNKILlAcZLGimSoWkQJE+vrrnwkabkVP7xhU8Mz9WYSlh2GK11jUDes3RL5pGQmxeDAIA3L7wbHcZeEvFpGoe/VLePnC658Vy4FVyuCqe+cbD25Xwcep8XIVgTwxn+F9dBRcXOS9pvrcF+yLv+HOtvwzdApPS3Scjva5HL4Z39VFgD6ecgOD3imFVh2W164IqLDxopxZwlS22RHlhAR6ic7aqZ/1sBu+Lb2Hq+VuWmn4b9mNC4SIbLHePvfwloF6qTxCDCB78pwsIKmsUoeM5ErMo533V9h5v60LtBtrLzKqZktZi4Jqb0keMrvBt+hnAHB0K3/6TTyriCtQnxUwXCxgeMeIko12DbaAZ4gAYOCqIOjiJNDU6mTWkWy3irI4yn03JeLJFTHcXRlndsxDRZMMyN+Q4n0gjJZ3EWGhsO8+Eei/ekWpTndWTPmoJyKKo2XV9uXdprQumPer35Ol70rJuh4qwkZ2/P9z4JgctD
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d73b928-fde8-4b34-f998-08d80e5143cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2020 21:49:06.4847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yn4SMhmvYlsh6113xYgwYpDiRwCQPvbCLNzXZ+zm7t7PcGNdvNZ0BB88C3n3H+VZwVac8HImwtFerDwEvSNC1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3201
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-11_23:2020-06-11,2020-06-11 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Monday, June 8, 2020 6:05 AM
> To: Derek Chickles <dchickles@marvell.com>; Satananda Burla
> <sburla@marvell.com>; Felix Manlunas <fmanlunas@marvell.com>
> Cc: frederic@kernel.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org
> Subject: liquidio vs smp_call_function_single_async()
>=20
> Hi,
>=20
> I'm going through the smp_call_function_single_async() users, and stumble=
d
> over your liquidio thingy. It does:
>=20
> 		call_single_data_t *csd =3D &droq->csd;
>=20
> 		csd->func =3D napi_schedule_wrapper;
> 		csd->info =3D &droq->napi;
> 		csd->flags =3D 0;
>=20
> 		smp_call_function_single_async(droq->cpu_id, csd);
>=20
> which is almost certainly a bug. What guarantees that csd is unused when
> you do this? What happens, if the remote CPU is already running RX and
> consumes the packets before the IPI lands, and then this CPU gets another
> interrupt.
>=20
> AFAICT you then call this thing again, causing list corruption.

Hi Peter,

I think you're right that this might be a functional bug, but it won't caus=
e list
corruption. We don't rely on the IPI to process packets; only to move NAPI
processing to another CPU. There are separate register counters that indica=
te
if and how many new packets have arrived, that will be re-read once it
executes.

I think a patch to check if NAPI is already scheduled would address the
unexpected rescheduling issue here. Otherwise, it can probably live as is,
as there is no harm.
=20
Thanks,
Derek

