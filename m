Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC888DB311
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 19:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440604AbfJQRNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 13:13:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54756 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728639AbfJQRNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 13:13:42 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9HHDCOS028122;
        Thu, 17 Oct 2019 10:13:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=pb6wQ58kECY1I+U6SSmxvdp0wbHKaREq/oGLxzF32HA=;
 b=IxyRXtmENCz15qtrHhiFEFj8w/fUxuaAtg6i8IiRIuz2p5m9GLhEXfJshKeVKBBXDqFa
 P9y7IPupWtFgwey7xs04YVDPNsnVfFTgFUxzeUm9XDdIXNJh+ZWx6bo5nG7td7Am1vCT
 OFsn/kXOLGQCbFgcIOTfY4vcLN7jeyyHjiE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vpj8rttsf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Oct 2019 10:13:13 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 17 Oct 2019 10:12:52 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 17 Oct 2019 10:12:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/7VgeXEz1DUbD72wEDe9JQM39K31sbs7wUwKXhEQubOuJMnxk0Qf+gy4zdd5sANTm+YtE5FAkIKhMYsa7vpq54qSuu2J1MAcu8ommccJepyQqXb81i3TgofS2r4RqJg9trLD8FK1shlYtOwn5Fu+RAdkrTWwm554tUDgvZMANGC7M0cro7scgd5YP3XxYDaDQRWpqcikDIZf+vXeCXGBE83oHUF7yPr6TEEsy4yHvTV2t6XSx+b5Fy9I+QhfuFYykxVBZrBCZsCPmtumB5XiNm2NOQNmeYKvFzyeguOlMqdv3RxH0Fyvb/PxmpWYJ1lnxivBX0HsQoGpTwWuEcFQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pb6wQ58kECY1I+U6SSmxvdp0wbHKaREq/oGLxzF32HA=;
 b=hkJKUxkUmn2kt5FvNnTVpNZGEItCni3U8/m1EdG2CmxrgnvNjEyQHpFteYSgzJ+yPIn2DmW1Xv5sGgqW5QqrBCg9FC8WDtRxfkFGDQJbnzn39vfyucfVb1jk07l3n1yPFc8hHnVSaUNqsQx38YuIHzhPV3fOrfASi7msg8/ks+0Q3mnPH8WikTg6jQ0/6kTn7PKjCpX7veUC1bivWgFUOpRSSszCd6YPr81de4RNU7A9vqiKFy9b20ZOENAJWOKv6uiaLzNmZ/js7eeFdL9LeCLzft53p+DYgoyb/l2doqXph3iKjdf90jh628Mrvc8inbdVyus6xBDxXyaMKH2RkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pb6wQ58kECY1I+U6SSmxvdp0wbHKaREq/oGLxzF32HA=;
 b=RetwhDemGZNhDNjR0/B9XO9pHbvHGDSgn0BArWmsFyFMBpAgwAp06QRkjS/AriEP43qSbE4cKI9TJQ/CkSpKq8FkMAN4KDK2T6+WgHDmBqIBAHDNIq3dJmbzScaKCH7IRhwufAirONpwDcc6/XLafL4D2ej98xpUwaVpNdddJdk=
Received: from DM6PR15MB3210.namprd15.prod.outlook.com (20.179.48.219) by
 DM6PR15MB3657.namprd15.prod.outlook.com (10.141.166.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Thu, 17 Oct 2019 17:12:50 +0000
Received: from DM6PR15MB3210.namprd15.prod.outlook.com
 ([fe80::cc98:c18d:1e80:b856]) by DM6PR15MB3210.namprd15.prod.outlook.com
 ([fe80::cc98:c18d:1e80:b856%7]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 17:12:50 +0000
From:   Martin Lau <kafai@fb.com>
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
CC:     "linux-kernel@lists.codethink.co.uk" 
        <linux-kernel@lists.codethink.co.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: bpf: type fixes for __be16/__be32
Thread-Topic: [PATCH] net: bpf: type fixes for __be16/__be32
Thread-Index: AQHVhBM2W//eT1DINk23xn+IqGSGKadfFAuA
Date:   Thu, 17 Oct 2019 17:12:50 +0000
Message-ID: <20191017171247.3yjbepx3jzs4zort@kafai-mbp.dhcp.thefacebook.com>
References: <20191016111635.20089-1-ben.dooks@codethink.co.uk>
In-Reply-To: <20191016111635.20089-1-ben.dooks@codethink.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1701CA0001.namprd17.prod.outlook.com
 (2603:10b6:301:14::11) To DM6PR15MB3210.namprd15.prod.outlook.com
 (2603:10b6:5:163::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:ee07]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e232720c-252e-4746-1ba8-08d753253d4c
x-ms-traffictypediagnostic: DM6PR15MB3657:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR15MB36574FAFF58A6DA9586733B5D56D0@DM6PR15MB3657.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:200;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(346002)(396003)(366004)(136003)(189003)(199004)(9686003)(54906003)(46003)(5660300002)(14444005)(6512007)(256004)(86362001)(316002)(99286004)(25786009)(6916009)(229853002)(446003)(476003)(52116002)(486006)(11346002)(478600001)(14454004)(6486002)(305945005)(7736002)(6436002)(76176011)(102836004)(66556008)(66476007)(64756008)(66446008)(6246003)(6116002)(66946007)(4326008)(1076003)(8676002)(81156014)(81166006)(71190400001)(71200400001)(8936002)(386003)(6506007)(186003)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3657;H:DM6PR15MB3210.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QvZzgJid9cvf7wkd9TQ3viHoIDLRfQiXUadJu6p8n81wHE1KhEwhNIytGs/vLKKinW0YXokHRM3roBd1k8N36pvo3N8MbtIH64Y7uuLuJUSfnW1VucY81QqdRcID2+oQf2kicMnhjDimWtVrejNBDAvDT5JYLYtG/mMvHZvawbVL6l8u57Aqcu/Nt0caXTMn1pya1mqDz6x9BpzFiAH7SxTNF6F5w01kJ+lloxL3cYFjGHX9mn8TeX1WY/+7PsVVF/3I62bgLLX0wtqAAf/Pna6jZES5M9xttMuHIqdBeeqQNTKT6Y/zUpwpayiVi6fB0Q0k0r6tUl5bi9A11kAxeCg9gdFYAUZk5ZeQOTGKkMj6RzzrjSracgS/Dtbup65CdQnMsUQXdILX2kvkmxFM5eXSaXNyFTApgHkeDtMDdm8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <45438FE95DB0104D83D9B560BE073214@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e232720c-252e-4746-1ba8-08d753253d4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 17:12:50.5736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hxKP3BNRiRRpNns/6kQO4pMPW8Ptt4Nv/Es9DS1c6EfZixQfXb/BlVv1sbKRqXXf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3657
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-17_05:2019-10-17,2019-10-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=628
 clxscore=1011 spamscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910170154
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 12:16:35PM +0100, Ben Dooks (Codethink) wrote:
> In bpf_skb_load_helper_8_no_cache and
> bpf_skb_load_helper_16_no_cache they
> read a u16/u32 where actually these
> are __be16 and __be32.
>=20
> Fix the following by making the types
> match:
>=20
> net/core/filter.c:215:32: warning: cast to restricted __be16
> net/core/filter.c:215:32: warning: cast to restricted __be16
> net/core/filter.c:215:32: warning: cast to restricted __be16
> net/core/filter.c:215:32: warning: cast to restricted __be16
> net/core/filter.c:215:32: warning: cast to restricted __be16
> net/core/filter.c:215:32: warning: cast to restricted __be16
> net/core/filter.c:215:32: warning: cast to restricted __be16
> net/core/filter.c:215:32: warning: cast to restricted __be16
> net/core/filter.c:242:32: warning: cast to restricted __be32
> net/core/filter.c:242:32: warning: cast to restricted __be32
> net/core/filter.c:242:32: warning: cast to restricted __be32
> net/core/filter.c:242:32: warning: cast to restricted __be32
> net/core/filter.c:242:32: warning: cast to restricted __be32
> net/core/filter.c:242:32: warning: cast to restricted __be32
> net/core/filter.c:242:32: warning: cast to restricted __be32
> net/core/filter.c:242:32: warning: cast to restricted __be32
> net/core/filter.c:242:32: warning: cast to restricted __be32
> net/core/filter.c:242:32: warning: cast to restricted __be32
> net/core/filter.c:242:32: warning: cast to restricted __be32
> net/core/filter.c:242:32: warning: cast to restricted __be32
Acked-by: Martin KaFai Lau <kafai@fb.com>
