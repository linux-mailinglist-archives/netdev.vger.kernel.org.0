Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B50B280129
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732413AbgJAOUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:20:42 -0400
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:23332 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732213AbgJAOUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:20:42 -0400
Received: from pps.filterd (m0170397.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091EHKgb024738
        for <netdev@vger.kernel.org>; Thu, 1 Oct 2020 10:20:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=smtpout1; bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
 b=pZV9w2XyMIJ7EnO1OeV2Wh2XGhr2Szlmju1tCpCYJFLuDyPmS7f7pQ7+6mEFYqfaBGDt
 jjL9pRLyTcmnvatwWWDkmZNasQ3MZLhPvEIggidWJMU99CitsY60XJetTl+xr2p24Ln2
 F1q//PhN9CccNe9ie5cGBFT4g7YSBNgxBR+R8d090f1x+iNYu1AnarwFmlyNWKoceBhm
 PaC+O/7c08qoivvuwGttzOMmo4rZA3W4lJIT2PxAK3jGa0+jYcAKJ+PF6zxEEeqi4Jbm
 2fAiYliALrjT+T5M1iCpyrRYnn+82KPhCh62r8Sg0Pk5/63tlbqcmwBJ4Dm3ONcjtN/5 Fg== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0b-00154904.pphosted.com with ESMTP id 33sxquj59x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 10:20:40 -0400
Received: from pps.filterd (m0142693.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091EH0ue113025
        for <netdev@vger.kernel.org>; Thu, 1 Oct 2020 10:20:39 -0400
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by mx0a-00154901.pphosted.com with ESMTP id 33w8sey4k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 10:20:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXfbIbKwzmmyL6onJ+BEJ2QZnuc19QAu/Ztyv0sZ3ijGSe+e4/DZ7yMw2WhlamC2T611Mrr8QYuJhZGYGQUETrRmoc/efpVVvQ6GDCkQBAkV7wteavBuPBQfvuNx7m1y/Z70NTX2WrTWIB6r+fGJGeIMoFAiDa2TIu4w2PAU+0EoH12ZGot9jmI8xtTvYQiYQrdSX58I0wJ0AXm3defh/mJMXiIlMGqo39qJBkrR/PYeAfTPXkDpmuy7W4wg9ufdHSUMG65z26JPa+KmLoTMiehoFJvKmSidbrQwSBjfXRsbDguVZqF9vHaWMaqc/o7OgY40HELj41R/Vwjst4uEPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
 b=J2yM4G/CpXL0wl9OLwwr0yRSdbiaLCWEvO4p3xZuWZ3rMgSqX49L4tOPExmaHQtLSCs0ej6vWR/43mY7nPt1u+VePa83qRpId08sE692KGP4NYIGa/GgaqgrpoxAA7rHld47AtfV7u9Ccgi7iQbYfZai0EyvePv1VWiQ0Q/lZ5jt6OmHEP0utT3u0yZeoV8wVjRopvWqaHejIGi57E42WgpZKKJNFFTLOMpzxeINhKay18w7/3yfDk/TeBHfza5PN6CE1jklkJG9om6uIUtJb171/kkGlLLrnc9OprVsgn6U6/+KBTPlor4OGT1NGYdmEEA02J3EhpJ9oH99wFF+bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Dell.onmicrosoft.com;
 s=selector1-Dell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
 b=cZl9icOO5g4ok3M+42BZiFqmuPzc7yXRjw3HoWLilNBPBKFAPtfqRoWTaRnGWp++m9bpvzyfmIDJ68qv7xAb+YilvwwJROBuWgtsOKPKp3D8icojg379EUKQRLZQ/Qz1iaad+tT9ZhL+cPrtV9ZLmflwpwHjNuUQaj7Zfqqui88=
Received: from MWHPR19MB1072.namprd19.prod.outlook.com (2603:10b6:300:a0::20)
 by MW3PR19MB4234.namprd19.prod.outlook.com (2603:10b6:303:44::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Thu, 1 Oct
 2020 14:20:35 +0000
Received: from MWHPR19MB1072.namprd19.prod.outlook.com
 ([fe80::9ced:3456:2d53:2d20]) by MWHPR19MB1072.namprd19.prod.outlook.com
 ([fe80::9ced:3456:2d53:2d20%10]) with mapi id 15.20.3433.032; Thu, 1 Oct 2020
 14:20:35 +0000
From:   "Keiser, Chris" <Chris.Keiser@dell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: 
Thread-Index: AdaX/gXO3yFmojjGTuOaLz6Didh+Jg==
Date:   Thu, 1 Oct 2020 14:20:35 +0000
Message-ID: <MWHPR19MB107213A4C93DDFAFE430FD068B300@MWHPR19MB1072.namprd19.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Chris_Keiser@DELL.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2020-10-01T14:20:26.2488319Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_ActionId=4dbe7f9c-759a-4888-85e7-91d3e592841e;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=DELL.com;
x-originating-ip: [67.4.35.45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90eff08d-050c-4146-6f2a-08d866152a0c
x-ms-traffictypediagnostic: MW3PR19MB4234:
x-microsoft-antispam-prvs: <MW3PR19MB42343B1B237A4F842C1A094D8B300@MW3PR19MB4234.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j/Oe6lnpQlKYYPrPKXRDpz1bszsk9AjlCHXkhrHJfqkuBZUaJUVVcGcfv0KlWN5AuYANO9v88GcZM5aFu1RmBsS82zVKaj2uYnMPbO55rnfTn6W/PYz7K0cu+yHYT876HRU/0dEgZu8+0p4tImJ92UMpqB5JzG0Tr/5hUGAxh3o6rmsNnURHAYjRpz/yWfpr/kmzj55VKoXqDorgBFeXrhEAXtDJIETIdrGmZ2dBjF6Q61HtSBAEikO1sywuI2ZPruUkh6Eef39ITEoAoXEIy0eRrBEHAZzSlv8SCmFIydeL3J+Ve3dMiCmFdw0Pzs4InRPGhKrPdV1Ao3El4JSV4it4sFH8UgG+CFAO+Hx6sAs95M2/CatB2XmqLEupDBxpecikFT0vXfNV32leLWSrngoI8oMkREn11wFA7WYo1XSLs/KeQN+cnRDuqctp/Mab
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB1072.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(366004)(39860400002)(2906002)(52536014)(26005)(558084003)(7696005)(186003)(76116006)(6506007)(71200400001)(8936002)(55016002)(86362001)(33656002)(478600001)(19618925003)(66946007)(64756008)(316002)(66476007)(66446008)(9686003)(786003)(66556008)(6916009)(5406001)(239884005)(425394004)(19559445001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: djk2iRuWrl91AlLUlcPPUsBn1E//EBa3q7l3dOZMGKd9Vl0XvJ2LobTl7t2Q9oEIHBA3IZq5n2hsT0h9E43rN7gGFNvbPzlbvS3YMc/5K3RNKSXRyIhNbq05j3DuVDCiTbAdTELkg4lo7B0rLajTeqKLUPkSkhz0Y7TyEM0W9q/6M9SQxvH5PUsXuAE/eRrskWS51u1rfswZ8P5+UYm4Of+EueAyJ3XvEqECn+gVqUWJf6IztalBUtlQNMDsBHd9se/68t9F3gcG2HZRZP02Zat8kZGzSGHOp3KhUeI75+OhXRAaDGdXaTZt5o//HowP/VGXaeMM3IZJaEch7Sf1D30X4pxvEFsd5IVm9pRAkVzVFfa78cehBIvgWnBDDTxEsvvb65ypQIaRKk8gHTlMRb6MV6koVeTapvdSY2j7MJEJu1aF90EwpCF1H2jd9quQQt4P/tMtgUXjriZA4/YnRe97HN2QiN1nkzWww/mt00zvPuXYwIzmd0/pY6XnQlvggOeHfQgMWf41mTcnoEbdrG0zkThj9opd/VNVTrymS0zvMT4vPBQIE68GKK1+k2UW7tZlIId9XgqQAvrL48QkJ30jKYXRTVnLrxb/Vu6ZYGf8KiVnXl2HXaaVtobxLWa0D3DRCQkODgcOyLhvtLojXQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB1072.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90eff08d-050c-4146-6f2a-08d866152a0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2020 14:20:35.7520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mPv1jizmQeWe59jzm643kL7jOCcZ021lCA3bud/mxwtZyUq5aQ8hNQhlZezw5hv487itMFBXA6FOnjzFU6fQ9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR19MB4234
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_04:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 mlxscore=0 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=292 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010123
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=399 phishscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

unsubscribe
