Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 461DAA118A
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfH2GHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:07:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59224 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727328AbfH2GHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:07:14 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7T638Px004626;
        Wed, 28 Aug 2019 23:06:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7T2foaqF6DKDpJZEI8X54WepIx3U3TdUdq5qGRXH56Y=;
 b=HbwKzsa9oBT66nNVC1Ax5qKUdI9uzT87JDf85hu1gLFClXEj2aHTCubrS2n8nvyUnAAP
 luJkWVhtJ7AWvksj/ZOUcCpKedJLp1vuka/PZbKGmQpoVY4uk3pszlBRCv28INxQShFZ
 mBTaMvwLMhcX+8fvienOQW6nW+K++7RLH8E= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2untb0kwrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 28 Aug 2019 23:06:37 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 28 Aug 2019 23:06:36 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 28 Aug 2019 23:06:36 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 28 Aug 2019 23:06:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUvD6ABrq/uWZb1uUfWrfxFW0fnwR1qV8NL2n5mWk/PtyLCqPUsyejV3/k7sSkcl5kiglHfY4K12v/RTbAw9GMGkoqFkzMOgryo4lirZ2jto0fqGvCPYbzpFqovDI2XVPyfe9nien2HoboloVe8r46bwHd0t9Tjxfe1L0J/geuVY3s5WiX9U6Yj9GCXdUnVe5bpOK5f6rTJVeoJk6hg+bMDoeo4fktewJlULmSyhqlaaRWhNVDM/A/nhorL0W326dJj8AYnBtaDdYenMWsV2CLwQ+kB69DPoVYouKXYi2scuUOdmj+KTplYtTQbJSHKpZe4OkLZk9iiXcd15Ym3ZWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7T2foaqF6DKDpJZEI8X54WepIx3U3TdUdq5qGRXH56Y=;
 b=ebFdkCVIUhTLp/UUo4mo/NwFEp9JZfOIbt5hAsCuTMOueqaLlC3ukEOlPHs7/n7J21T7XcE2LXULF1SI3LzqKjJ2/AbxGM1FKvxvHa45ln1ysL583ob5TDjRGoWqzyg0fntbzXqtznrQf/B+4Sc2y1+5Hfz5BvYbCVMLq/vj+7EjfEnoHoQCCcIVjXfKzmnssI2fAgiVYYhnu8ZRSG+yWq54hX/UgzuBJcts0rFVW6mk0Iexqu49E/lf+5mpXvdaLoIPfUvER2xKVefUQzoPmN+XqCy11aq/zRNCUbXD8WRZ9pKQP6diYAJD0ImMJK4j3JhRvXBWyejE8GHUpxGKMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7T2foaqF6DKDpJZEI8X54WepIx3U3TdUdq5qGRXH56Y=;
 b=CEj4UP6sx5QRFcqW00gY/vI6WPNNtlnlV/FJmiyEFzJmYoorCalxmQWaoIEihHdeLKyCKBEJKzgL9jz5mW6c7U0nK3ch3SIMGd6i2qwIDlc+s/iuh7zWJSc318U3HUrSQ9jU+jZk251MJ1Gh4URcC23Z2Mz4MtivA/ykLrTEwO4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Thu, 29 Aug 2019 06:06:21 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 06:06:21 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Andy Lutomirski <luto@amacapital.net>,
        "David S . Miller" <davem@davemloft.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/3] perf: implement CAP_TRACING
Thread-Topic: [PATCH v2 bpf-next 3/3] perf: implement CAP_TRACING
Thread-Index: AQHVXiiLdjGxgjWrC0Grj4RhiiTN5acRo28A
Date:   Thu, 29 Aug 2019 06:06:21 +0000
Message-ID: <BF2CED89-D33C-4363-85BB-F4EAD4A5DBDD@fb.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-3-ast@kernel.org>
In-Reply-To: <20190829051253.1927291-3-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::6d75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83110904-cd92-4347-2cb8-08d72c4703dc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1790;
x-ms-traffictypediagnostic: MWHPR15MB1790:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB179051CB37AA04CB6E602871B3A20@MWHPR15MB1790.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(366004)(136003)(376002)(346002)(199004)(189003)(99286004)(4326008)(50226002)(478600001)(6116002)(229853002)(25786009)(102836004)(46003)(305945005)(33656002)(81156014)(81166006)(316002)(8676002)(558084003)(76176011)(7736002)(14454004)(8936002)(54906003)(2616005)(66446008)(76116006)(53936002)(476003)(5660300002)(486006)(6436002)(186003)(36756003)(6512007)(2906002)(11346002)(446003)(71200400001)(71190400001)(6486002)(66946007)(57306001)(66556008)(64756008)(6246003)(86362001)(6506007)(256004)(53546011)(66476007)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1790;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vppdbtQlcIiDu8L9jtzv5Wlp8eOI2E0snTIAiOrUR3xefOMbT97xTR/l9TmfYkhp8W+1GA/6LPO1MS8GKXs33N5bOD+dBgJ5ujqkvhYPlduNgS3ncNlZ5t44AGcy0bMZFHTaPS66FRrSBks7fzer0BabeVnkh/yV7Lc2g1dHufGrUjGicbCS211eJB3iNFHiGnICs38vFPIY30rPCvUBPs8nFyNrwLmLBoqRxeauaB7mB3vWfi+ed3QMtBglh9BjLTTvQEGnuwao4lYxnJIq/ojSKO19KbI00+5FYA9geFltRwv6lNJy2kiTfyDJM91eDio+u7L86Bd+JlHWU3TjIiNgU1AvTR86233m7nAo2Aw7ZZZp9Byk955Df+MXE0WGydYJyUkRi3KqoLekKiqugbt5SbDyopxqqlnNy2EI/ak=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A7AAF2CEACC5C34BA909C5E7248576E5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 83110904-cd92-4347-2cb8-08d72c4703dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 06:06:21.3886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ARwSJg65mt88iXBmWwlTtRzRzSt1hQ/HmdNZ1vcP96sPjkMgtkGME08tbBpa56gHf2dOEpv3PiB9PKfp/wyHrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1790
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_04:2019-08-28,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 phishscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=833 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1908290067
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 28, 2019, at 10:12 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Implement permissions as stated in uapi/linux/capability.h
>=20
> Similar to CAP_BPF it's highly unlikely that s/CAP_SYS_ADMIN/CAP_TRACING/
> replacement will cause user breakage.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
