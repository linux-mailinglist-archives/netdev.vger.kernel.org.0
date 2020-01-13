Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B20139A9C
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 21:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgAMUPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 15:15:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3450 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726878AbgAMUPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 15:15:08 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00DKAnpf022355;
        Mon, 13 Jan 2020 12:15:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=yK011gqg2Xa4jCpgMCdQM3yemgz2G4m9cPuz3ChorIM=;
 b=Kjkm/lsjsNymioecuWmRx9WZhTqfoNhoGBdpTf1prtLEbxMeeky6pGHEIPWAlYv2ay9P
 lCPTsWMrC3uAdiyaZmbKxNrgoEMASsI4tOePf5sWIR/mq3HOTj1tmGSFALV0ImESz9H1
 bOgq0cis+1+4odny82sbb+tQgZsWFTqMYss= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xfydne808-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 13 Jan 2020 12:15:03 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 13 Jan 2020 12:15:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FwAzAVYf1UrbdM/fvr514qcP4hvs/3t2db/sTJw29KaGb5CH+CF68w3OOpsKJ3MDh0Bfp4Ovr0lBKodX4kIocfOODx7phExn0Gs+NOHm1bTyGxMLtATu2aSLw9ZkLFZdUC6dQt70bRBF+RpjyU2xrvTkHj1q1U4k21HSiKGUX6sBiByhH3CCngOqhl8jS2rWrDkNW94fh1K0FkSOrhI1qGrQbH36GydFq4Y3BqK2HJXUvTEcC0pRgOb/34T4mVBevexocVgRpFetoQkxgAHsjtvEeHIZDNWIoW2vp5CyzbpUrdosIRanxIRM3TSytf23iURb5w4mXow1DWr6Df5b8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yK011gqg2Xa4jCpgMCdQM3yemgz2G4m9cPuz3ChorIM=;
 b=FaxvRdRxKGu2M0JMKbIFc/Hh92vc3mZTreeq5QTJSVTbxyux8K4TDoyzJNjs+uYZnzQnY8M/xePluvKGGse6Ms071Q128+jnx3M0rtjDusA1Hi8mRrnCBVAxq6mg8Z3efkIeyBgtqfJsSLM8tTE6uafzc2NYULKxqB3rgazNAEM/YbN+DxGD98v9AijMESfhvDDEX9izl5vLlh3OfyfKdsnotnAzQtzFaNlCKzmD5Ew+VnN9OhcLeR3vqIoOeUNSQ9sbv1FvsxaMQPvkMGLak/qXOjG5PNaysCUyQxUfM1WBWM4MHhNJGQkvswmAO6AvKvBqbwmeGwpy/qIGl4KVTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yK011gqg2Xa4jCpgMCdQM3yemgz2G4m9cPuz3ChorIM=;
 b=LokofnzTKZJgUMIdIIBb4OyQc6opKxNO+93Ckjq9uMGQyxfnDNdm1M5M/S6G3d4TEIiwX7+24h0IYWTL06af4WQG4XZbNgclWs1kGR1lTDU+/tYJAT5fVNC3dJJKFzUbYCsCTiJHuA+U0IcxCKJJATam8Bhl6ehvUYBX6iUmJqE=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2783.namprd15.prod.outlook.com (20.179.145.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.15; Mon, 13 Jan 2020 20:15:01 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 20:15:01 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::1:34fe) by MWHPR10CA0011.namprd10.prod.outlook.com (2603:10b6:301::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.12 via Frontend Transport; Mon, 13 Jan 2020 20:14:59 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v2 03/11] net, sk_msg: Clear sk_user_data pointer
 on clone if tagged
Thread-Topic: [PATCH bpf-next v2 03/11] net, sk_msg: Clear sk_user_data
 pointer on clone if tagged
Thread-Index: AQHVx6PNoYuTANqsXU2uEYENNwDHMKfpDPcA
Date:   Mon, 13 Jan 2020 20:15:01 +0000
Message-ID: <20200113201456.t5apbcjdqdr6by5t@kafai-mbp.dhcp.thefacebook.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-4-jakub@cloudflare.com>
In-Reply-To: <20200110105027.257877-4-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR10CA0011.namprd10.prod.outlook.com (2603:10b6:301::21)
 To MN2PR15MB3213.namprd15.prod.outlook.com (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:34fe]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e1ffe99-058d-435a-101a-08d7986544c6
x-ms-traffictypediagnostic: MN2PR15MB2783:
x-microsoft-antispam-prvs: <MN2PR15MB2783552D6A283BBA130B0FDED5350@MN2PR15MB2783.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(39860400002)(396003)(346002)(136003)(189003)(199004)(52116002)(8936002)(9686003)(6666004)(16526019)(71200400001)(7696005)(186003)(86362001)(478600001)(66476007)(66556008)(81166006)(64756008)(66446008)(66946007)(8676002)(81156014)(5660300002)(6506007)(55016002)(1076003)(54906003)(4326008)(316002)(4744005)(6916009)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2783;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vbSEs57+VbUmBqlSeVgTT5wpj7aRU414z5cxk4AZC7dZYZOK4lY0ZZYV5zfcAKsigj6IEdk7SGvAqx+mTuJMEM0N1LFlivDcDf2ctwRP+C9pDtILrmprrRFxBe6zH77tOwrusjwEmW3+IL8ITw9Zi7oqJXA6rQmTZLIr+uK1qOw3nn8NZkBUpidHW2XW7G/A8Cv5tqkrNeSz5f89tKAsg3sj9NsglVhNd0HUAx4kxKr8UiBB4rTs4oQyBXbNPVInzwf5lyqhWZoj7P0FPQeAZPAskTtNiAPb+3Cq6RsjQFa16KOVQR0/IgMuUX6cowneBARoSCaJHrbcU/miOqeesktmE2J1igo/iypgOmF0igmAElRTCgi2ktS5E5DMobFa0o/SnxZJKiDyyGZZb+bMaJfjbWnRaKg2+cucRRhFRrzcjhbtiECUi4sgCgK3tbHq
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F89ED11D0836F54D89CCA5E324450517@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e1ffe99-058d-435a-101a-08d7986544c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 20:15:01.1053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /0/Quj86t6HHdAL1Iku3RMCxpwsTJg7NZVfX0520bu79QX3Nc1tKlH2wn5feHo8O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2783
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-13_06:2020-01-13,2020-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=606 spamscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001130164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 11:50:19AM +0100, Jakub Sitnicki wrote:
> sk_user_data can hold a pointer to an object that is not intended to be
> shared between the parent socket and the child that gets a pointer copy o=
n
> clone. This is the case when sk_user_data points at reference-counted
> object, like struct sk_psock.
>=20
> One way to resolve it is to tag the pointer with a no-copy flag by
> repurposing its lowest bit. Based on the bit-flag value we clear the chil=
d
> sk_user_data pointer after cloning the parent socket.
LGTM.  One nit, WARN_ON_ONCE should be enough for all the cases if they
would ever happen.  Having continuous splat on the same thing is not
necessary useful while it could be quite distributing for people
capture/log them.

Acked-by: Martin KaFai Lau <kafai@fb.com>
