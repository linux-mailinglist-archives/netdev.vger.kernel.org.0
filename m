Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22390148B66
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388992AbgAXPpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 10:45:40 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46948 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388035AbgAXPpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 10:45:40 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00OFdRgJ010037;
        Fri, 24 Jan 2020 07:45:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=yyPbqB8Jp4kVpuC/32J3q0U4uTutYYgxtE8+fpUOQp4=;
 b=TMxMinODTLzqYa4kArMdGDomk+ndiqypyfivFPxVnLaNh/8rD7k/oxqGxY+947IgPyrC
 NjcG+v7P/kwqsL0LpLeQF9cHrxh8DYPX8dzIwJt8nRZQA2vTfXD8xM2WRo43ISRZOEDf
 i9Ue9zFndAhZNy/LyP1c4bJneO+Hg8hQO+8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xq49c7k1r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 24 Jan 2020 07:45:25 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 24 Jan 2020 07:45:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+FLEGduIpb2as18m6zGyeKZAQdSMbDI3tDXwDAFb8zP/OBbENMcaVwdbV6pT1sWH1fbybA7PCZ+N8klHP00aTf1Htnzu6SYawtLBpgJUYWHXFyxxKQMWxIofNXuOeRU+zk3AFF3Q5ecjfk5okaTrw1tr9EQJ9L+DXQBaCMnPNZg0WSKJBTqFOvU5hzLeAezTmeiTadnQ4ZiiMP9c00CVnxs0en1T2vWqnCJEBeca3EIjGQiF+4Bnh9NG4DdFN0vQhIqQl7iuk1GwHGZOlFqMo4XczQVvxfzfEgxI7Io7XhkoaSVHN8N3YtJfZ4k6BbDQ/MMJgo5HhDGlMBoa6BNQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yyPbqB8Jp4kVpuC/32J3q0U4uTutYYgxtE8+fpUOQp4=;
 b=nFPPcqMF72mBXBntcZqO/tfVVePEjxsK0X4fjEAfb5ydItXKP9RDkCKNyBZFWiMnvJxjzMgcL/+Mwvfzt8wbYm3qFglgx9xhygWAbjfOzTpa03L/pUjaAu4b5jZd29dwfew5opujsWvHCXzpE2ogQwi7fI/BGiibGIVluv4sVzrOrDOvzTmcYByYnblxpwKXK1Sk0Kkm1cg8vyZvw3LVeP70qk5oInuqRytFK7N2jvaUTbmJmUiY+cnPpv3jD/qgBU1z/jKQEp4QO2FSc2P8hzZsKlX5SuhT7mN9ifzgob2nUNaIrWm9Y0PRoZ0LKbFgSz/JMmSJPi9IlzCaxuiibw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yyPbqB8Jp4kVpuC/32J3q0U4uTutYYgxtE8+fpUOQp4=;
 b=cU6dWQ+NFyZKWOuwczTRiT48SMff5WdRqr2lhMjJmCV37y2GG2uUKOXIZQqPWH2ApOHWnyexgvKsXjAbgUMwlbZCXR8aPxkHEUZeZLTb2DDqX3Xg9n+OYgEojcoMkhN5/arG2JOZXJiatGJT+IRYeRgSYJw81vHoy2ADbQRBmXo=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3101.namprd15.prod.outlook.com (20.178.254.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Fri, 24 Jan 2020 15:45:22 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.028; Fri, 24 Jan 2020
 15:45:22 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::2bd0) by MWHPR17CA0092.namprd17.prod.outlook.com (2603:10b6:300:c2::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Fri, 24 Jan 2020 15:45:20 +0000
From:   Martin Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 0/4] Various fixes for sockmap and reuseport
 tests
Thread-Topic: [PATCH bpf-next v2 0/4] Various fixes for sockmap and reuseport
 tests
Thread-Index: AQHV0qmhNrxd2IGebUCvpqCYOUn3Xqf59TmA
Date:   Fri, 24 Jan 2020 15:45:22 +0000
Message-ID: <20200124154517.lqm2vhkdiirtoaut@kafai-mbp.dhcp.thefacebook.com>
References: <20200123165934.9584-1-lmb@cloudflare.com>
 <20200124112754.19664-1-lmb@cloudflare.com>
In-Reply-To: <20200124112754.19664-1-lmb@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0092.namprd17.prod.outlook.com
 (2603:10b6:300:c2::30) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::2bd0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5e7dc8f-019f-4ea0-0bbb-08d7a0e46c06
x-ms-traffictypediagnostic: MN2PR15MB3101:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB3101989E61A06BA9A0F46581D50E0@MN2PR15MB3101.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:294;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(39860400002)(376002)(136003)(199004)(189003)(54906003)(16526019)(186003)(316002)(71200400001)(1076003)(9686003)(2906002)(6916009)(6506007)(478600001)(81156014)(4326008)(7696005)(52116002)(5660300002)(8936002)(81166006)(8676002)(66476007)(66946007)(66556008)(558084003)(64756008)(66446008)(86362001)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3101;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RG0CxPvthVbgCHHMwUzJVd70Q+TlSk/xhTnacEvAuopxwjYzlfQOVUj4Xdn0k6IffgH9MSYld7NX800D8DHPwPdzagIc2FAtdHog4xWoA70ToPZH7coTqQEYA04DqOqZ8vYkCbaWQHW7okrtKU39JP5qIDnV8BxYAJ7NT2rt1TaZ8lqIuyU/9U4zjDK8kjKV5QY75u/VVwC8G4GOaG+69dDXw5xDXdCtxYPl2iyYk0RgqFtDiui4Gk56s02EyYqfZj2qCHbYmp1wb85h7uGozMrwifYBpSe4sdb2pn6pMcNW03Y7N8j8TBPe4Jm6cLtidoo7me22KCbyDWDMSFCTrkJmAFvR16beaPcA7c70/J+o86ebITXX0IccWaliDIRYHWejKzp4t6PMlTySxIeN/A9iUmKtYnDp7jqqsreCvl8fQy6qPVr5E/MUA05k12JS
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8B09ADA04E455D44A53C58F4B78E538F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a5e7dc8f-019f-4ea0-0bbb-08d7a0e46c06
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 15:45:22.4096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pc/NkHOFqWUkya2fW5lCPQLHHF5GM7QDfuEfREUUVTb9hHTJdSdAbm8Dy2lGsJ4z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3101
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_05:2020-01-24,2020-01-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=506
 impostorscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001240127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 11:27:50AM +0000, Lorenz Bauer wrote:
> I've fixed the commit messages, added Fixes tags and am submitting to bpf=
-next instead
> of the bpf tree.
Acked-by: Martin KaFai Lau <kafai@fb.com>
