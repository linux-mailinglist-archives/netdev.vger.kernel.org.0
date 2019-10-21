Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D1DDF229
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 17:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbfJUP5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 11:57:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46458 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728044AbfJUP5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 11:57:20 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9LFsD0j029492;
        Mon, 21 Oct 2019 08:57:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=zIecJ3+N6Fis0LL4FkKii9emsPqe4v9KYWxj/SiV7wM=;
 b=ht2yZUEw7b9YnS1lb6HfHvPTRpK2CFAHiFRnCjSEmOpdKetAp1hfJCJkvX8CFAZS/BlT
 SVB2VRkehYwg2dK6cFDH1mIFW/KaL1NPx8ozkMEa3wH8qrvgvn0VnUtfof/clVe42F88
 akzZ13ZAb4jID5ipulH7sZtO5t3W3OCtz5w= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vqwyyfk3p-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 21 Oct 2019 08:57:00 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 21 Oct 2019 08:56:59 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 21 Oct 2019 08:56:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVsQy+Iiv/RCt1yY1qw9mJAMqEdNwCLssIsLbMpmSOp20XNLh2W4Fl+tkPACilWsOsLISawKcy1AmC86dkcYkEXYl9WtN0ikGACeIs6UD03ADaDTe3xEsqlhemXgGDIKT5rpqqGsJWs5nAnwnijO1NhUE4wrqcIFj7+IqjlO89GOSYZ+vBszSdvn5Senn8rMXFt/IckEnctSzx6bttkLgOm904AtRGBNRuoiXZTWACs+rN793Kx6gHEfDmEVC4jcHfB5PkF8wBz7SDEefwDH3fYRHC7S783wKsFMwETkfsBFsZigkLv4hQdn1g14znyVaYUPzqNs6VsXVbHsVftH5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIecJ3+N6Fis0LL4FkKii9emsPqe4v9KYWxj/SiV7wM=;
 b=GYIdtbOj2iY8e7aBabVLGtDczRste9ltuypmBXqBJLdHqCEolN0asC5B8xsMB+CHK5/ji09M0bAJpdSoEIkZX5JNC8ThvPu303cL7SxBF3JQ4u/ANzGBHtqPwJDJXU0g1mvFr17De7kpKtNUNvrc1Pa4vvzEutYgBs0DTi0Z/l9kHKvaWAg7aIEWWT4Zy7G1zb9uf45+Kg8Q1wVri0KU9ItSNZNR9j0bJ7yML3q4/tEAQMDf/2wcDl9+wa0ovTcPk+MFwILJD+gS5m1+LNYODNkKrRZQSezyBWbXB5h4azAr8gJv73esvGKKvdf6EcpWRXT3GjrXCuJCEYMSUdsgyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIecJ3+N6Fis0LL4FkKii9emsPqe4v9KYWxj/SiV7wM=;
 b=BqKP2h/D9ijzk4AUrhZgsMoRxtW2O/d6ZaoHAbRwmSh9M/mRmeSgQIbH0aDn7jJbAPgcyCYN/D3YlDeQiWjcRLWE6STxXUZTnHCtQ7fOTS7KxW4T+n1WXPq7+qe1cuU5U3zqP7SiYO22yaM9LqmmFRB9BKkk6ZnCYJCOQC7fi3g=
Received: from DM6PR15MB3210.namprd15.prod.outlook.com (20.179.48.219) by
 DM6PR15MB3209.namprd15.prod.outlook.com (20.179.48.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Mon, 21 Oct 2019 15:56:57 +0000
Received: from DM6PR15MB3210.namprd15.prod.outlook.com
 ([fe80::cc98:c18d:1e80:b856]) by DM6PR15MB3210.namprd15.prod.outlook.com
 ([fe80::cc98:c18d:1e80:b856%7]) with mapi id 15.20.2367.022; Mon, 21 Oct 2019
 15:56:57 +0000
From:   Martin Lau <kafai@fb.com>
To:     =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH bpf v4] xdp: Handle device unregister for devmap_hash map
 type
Thread-Topic: [PATCH bpf v4] xdp: Handle device unregister for devmap_hash map
 type
Thread-Index: AQHVhm8dsMSHvMcCd0SXksHiyyK26qdlQ2+A
Date:   Mon, 21 Oct 2019 15:56:57 +0000
Message-ID: <20191021155641.l44hz7hms5gvfrxe@kafai-mbp.dhcp.thefacebook.com>
References: <20191019111931.2981954-1-toke@redhat.com>
In-Reply-To: <20191019111931.2981954-1-toke@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0085.namprd02.prod.outlook.com
 (2603:10b6:301:75::26) To DM6PR15MB3210.namprd15.prod.outlook.com
 (2603:10b6:5:163::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3453]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c3f2cb5-885b-49a5-0677-08d7563f4cf0
x-ms-traffictypediagnostic: DM6PR15MB3209:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR15MB3209CDE0E5F2EB58DB4F4486D5690@DM6PR15MB3209.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(39860400002)(396003)(136003)(376002)(199004)(189003)(4326008)(8676002)(6486002)(54906003)(99286004)(6512007)(9686003)(229853002)(66946007)(6436002)(66476007)(66446008)(64756008)(66556008)(4744005)(6246003)(102836004)(6506007)(14454004)(186003)(81156014)(81166006)(386003)(8936002)(1076003)(478600001)(316002)(7736002)(11346002)(46003)(71190400001)(71200400001)(446003)(256004)(6116002)(25786009)(305945005)(486006)(76176011)(52116002)(5660300002)(476003)(6916009)(86362001)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3209;H:DM6PR15MB3210.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZUjM1Wv8IRTK8GIpbH0HoMwWOLi7iOD+fT120MG/KEywFJCesczc3zPSpttQ7r9pRv/m2zRcAwJVgH9OGFLw4fhKEyXJ5Mb8mZATVSDbojwjmDquXP2aoV7+fj+L+55F5nGZ8ptumPc2WmH3ifYhfXHZHldRlinkJ1eatkWzaXrb1vmHUceJzWFURmcP0wk5FuViP7HCGwCBkQp6lZY1Cpz0GDq0RovUo907aYfEQwTNme8/Qebj1Uy4oYhnwJfPTr3o15Q9DIqa+fn8iZLBGMVHiA4d0gt/o3H98GX8UHP4B1HuqAWUOSsAu1780VKwGDUy16XDUzgDlIZndOhHXkGRnEPl/2gzSZ1BZf8qzADnilCcZfxXefJs82il+b0IR19ysF0pWSCTAsmEkJoleVm+jyVvD9qd8urC7IWQBSA=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <940FD7F4C38F1E4BAB4A133CF37D0B15@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c3f2cb5-885b-49a5-0677-08d7563f4cf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 15:56:57.1360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3sjkmj/pxgPUU3mLPHUsmO/B0kakeIJ+oKSVAAe1T8z0qdjXCazmCpFOhcXMuc4C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3209
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-21_04:2019-10-21,2019-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=571 impostorscore=0
 spamscore=0 adultscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910210150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 19, 2019 at 01:19:31PM +0200, Toke H=F8iland-J=F8rgensen wrote:
> It seems I forgot to add handling of devmap_hash type maps to the device
> unregister hook for devmaps. This omission causes devices to not be
> properly released, which causes hangs.
>=20
> Fix this by adding the missing handler.
Acked-by: Martin KaFai Lau <kafai@fb.com>
