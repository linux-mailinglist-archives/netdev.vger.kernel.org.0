Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96512CF6C5
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 23:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgLDWbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 17:31:17 -0500
Received: from mx0b-000eb902.pphosted.com ([205.220.177.212]:54618 "EHLO
        mx0b-000eb902.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbgLDWbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 17:31:16 -0500
Received: from pps.filterd (m0220299.ppops.net [127.0.0.1])
        by mx0a-000eb902.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B4MUStJ021631;
        Fri, 4 Dec 2020 16:30:28 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps1;
 bh=s9AwL8mZyEkWKFjJfD1YRSi+5QbLOdQkxOuRumwLvoo=;
 b=dN64vp8T7er3yN25aMzE19aHZWnXj2dfw9XVx+IWb793GtdCdxKUQ00QNu9xElgWyL4G
 +7n7AxA0IlasrPAl250oBkmceJygybdCZYt5p5hHMYxPa4s9cs69jtfd8M376TNZQuuh
 AOfTxpaoGZqT2zE74CQFUu13pCiJdLTV2TdNKRXeeBtQYimCbfDC23l0xQgxq1wmnvTl
 PqYulBvhPROW000l74JejmnviRYlvEmTv2Zw7dZWtgdgAbNReQLr98Zwcwpiwn3JerMP
 /xuRuKwrvqfo+QxQhYX9ZA4hL5eVkT6IQ2k5XZ/lonbEzWEqwSRwX0elarvDsZweKoXP Mw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-000eb902.pphosted.com with ESMTP id 355wbrd1v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 16:30:28 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIH6wRUs/XA9qxcxQj5MmVJqH/AUhb674uQ9WSUImkAUvzwyMlWPpUUqeKJTzrxRImbqfU/JLUga9hUOUQRCEo9HPkB2aTbXzXp/dHfZjdZTmQx44/yv2yPgXNghGAqJBzD8ovSc7iVj0YJyazDhynQFBHwje8LSBaMH/YABKHZffjGiPP+uIGosZv0P1T19Pl5AMqMPaYHjKYwxDtlRBWWbVg2hWzG1mQV0EZghbhYAjc/YyRzd2VM/e7E/QhAKKlqPo/gDXsr6D30BtGEQeXC3pKV29En3NOXfsvcYBchD+OgDXdpyC2sR96h8pnVlRNapp5/NjrCwfWTSi254HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9AwL8mZyEkWKFjJfD1YRSi+5QbLOdQkxOuRumwLvoo=;
 b=ndER5jvSSqGnCFazyB9+vvJUT/P8USTmswutW8qHDCQ/o2ZpbcKdTuOTDJoMaZo3PSXh3J8g5mbNf/O7ubWIY+Q6feylMqB4sjZuiCo8R8uw/EEcl2BAigD78kMTLgJ+Q/+0L+VzJmqXdYcbcJt01V1wpoSPdoqO5qBPBqpB/ioSfMB1mUOKu9XMLNNpIFq5l13Yj9MFu1XavnzcmWIeVQ+Ruk/AUQnX5REQnzWt7Nhu0Sfg+TqNMysx9YX6MG+jjdVAZqcqByfjt49Pb6TEBaRhG3Q2RJA8A/uefpiNn0pEy8yqE3Spfqs/wsNaD/yo0XQW6Gymgdd+IF1n5E7Rdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=nvidia.com smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=garmin.onmicrosoft.com; s=selector1-garmin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9AwL8mZyEkWKFjJfD1YRSi+5QbLOdQkxOuRumwLvoo=;
 b=1CIUKwf6UXlIa0pM3XStbxBvKG7GAsV0xHn1a1Ex2e8tqQv0cvwWG8WKrvfszv2hqVZtqt0QQtVMu1InXXHd0UGhbyj9XQ7czg6xnSuTuaqVIHrH20D4JBNdJkMZt1u48hJQI3PH9K+SqSnOdkAJd2ofyTaomuaGusCgpN3Q9ARdkuizt3BSiqyv8C8zkykdl4QM4aftIK0ixNg5vqKdG2gntfh65uCQNjZ53MwymmGffxeevrkf/S6Nu7MXdBmxPxuQl1yg8unP0Rjbx7d8Uj8N03ddJMA2XltxP/NzTGJsjtI5zcATIdJP7WerscCzVt5NeCHVThl7tVddMnNkQQ==
Received: from MWHPR04CA0035.namprd04.prod.outlook.com (2603:10b6:300:ee::21)
 by CH2PR04MB6805.namprd04.prod.outlook.com (2603:10b6:610:9c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 22:30:25 +0000
Received: from MW2NAM10FT043.eop-nam10.prod.protection.outlook.com
 (2603:10b6:300:ee:cafe::9a) by MWHPR04CA0035.outlook.office365.com
 (2603:10b6:300:ee::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend
 Transport; Fri, 4 Dec 2020 22:30:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 MW2NAM10FT043.mail.protection.outlook.com (10.13.155.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.20 via Frontend Transport; Fri, 4 Dec 2020 22:30:24 +0000
Received: from OLAWPA-EXMB2.ad.garmin.com (10.5.144.24) by
 olawpa-edge3.garmin.com (10.60.4.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Fri, 4 Dec 2020 16:30:22 -0600
Received: from OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) by
 OLAWPA-EXMB2.ad.garmin.com (10.5.144.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Fri, 4 Dec 2020 16:30:23 -0600
Received: from OLAWPA-EXMB4.ad.garmin.com ([fe80::d9c:e89c:1ef1:23c]) by
 OLAWPA-EXMB4.ad.garmin.com ([fe80::d9c:e89c:1ef1:23c%23]) with mapi id
 15.01.2106.004; Fri, 4 Dec 2020 16:30:22 -0600
From:   "Huang, Joseph" <Joseph.Huang@garmin.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] bridge: Fix a deadlock when enabling multicast
 snooping
Thread-Topic: [PATCH v2] bridge: Fix a deadlock when enabling multicast
 snooping
Thread-Index: AQHWyoX7oBuHLnFgYUumoQfWnBQaz6nn5HsA//+cZuY=
Date:   Fri, 4 Dec 2020 22:30:22 +0000
Message-ID: <977913cfd91b4c6d8fb2e25d8762aaee@garmin.com>
References: <20201201214047.128948-1-Joseph.Huang@garmin.com>
 <20201204213900.234913-1-Joseph.Huang@garmin.com>,<f771d272-3146-2d8c-391d-87d1db8b8e76@nvidia.com>
In-Reply-To: <f771d272-3146-2d8c-391d-87d1db8b8e76@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.50.4.7]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5db07108-2a70-4464-57f0-08d898a43195
X-MS-TrafficTypeDiagnostic: CH2PR04MB6805:
X-Microsoft-Antispam-PRVS: <CH2PR04MB6805E66BD9D6988ABD2F9D07FBF10@CH2PR04MB6805.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sj1Ienrifm3Lds4R3KuxzfLKgifdruF/xvqpa6p6kpPNRrzmuFfLln09peM5xkq+nbup7H+ylEZPt5NJBOfyxUbNvvHdNNsbEANGBLrLLEHa40uijXX3YS462h/UAsuDDIox4T6wMx8WkFEJ3hkcZKfe7MzmP2nOJ+DInTdY/dlUrWpfwholGfNEBbTRBvZdJvgjlNhKIOEs1qdfFq3NJ8nHt04UYcaFC5ZtI3kXtEy/SLV9USWzvhijUQEFf1SBdgWQzGyZ+Stm6pJzXNzr02mmaE2cQf0pvD+gTrB9jYbi1xwKgqvDpLA1HMRDT+9PLMdOh/Xd2Rg4RwZP6Q8R9v/q9bGFJ7kWtrmcrhc/qu+pLy5CMQ3wUEhc3/2h9FrzE3W+Zb6jG1rTySplIxaKXg==
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(136003)(46966005)(8676002)(336012)(2616005)(356005)(82310400003)(478600001)(108616005)(110136005)(26005)(47076004)(7696005)(316002)(36756003)(86362001)(24736004)(8936002)(2906002)(82740400003)(7636003)(186003)(70586007)(70206006)(5660300002)(4744005)(426003);DIR:OUT;SFP:1102;
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 22:30:24.5415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db07108-2a70-4464-57f0-08d898a43195
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM10FT043.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6805
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_12:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 phishscore=0 mlxlogscore=835
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040127
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +     if (join_snoopers)
> > +             br_multicast_join_snoopers(br);
> > +     else if (leave_snoopers)
> > +             br_multicast_leave_snoopers(br);
>=20
> If I'm not missing anything this can be just 1 bool like "change_snoopers=
" or
> something which if set to true will check BROPT_MULTICAST_ENABLED and
> act accordingly, i.e.
> if (change_snoopers) {
>     if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
>          br_multicast_join_snoopers(br);
>     else
>          br_multicast_leave_snoopers(br); }
>=20
> This is not really something critical, just an observation. Up to your
> preference if you decide to leave it with 2 bools. :-)
>=20
> Cheers,
>  Nik

I wasn't sure how expensive the call to br_opt_get is, so I used a bool for=
 each.

I just checked and it seems that br_opt_get is probably just as cheap as a =
bool,
so I'll change it according to what you suggested here.

Thanks for your comments!!

Thanks,
Joseph=
