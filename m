Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 555681352D5
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 06:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgAIFrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 00:47:39 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3356 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725899AbgAIFrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 00:47:39 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0095jXtB018274;
        Wed, 8 Jan 2020 21:47:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ix3jf4375tnKpQQVWEwfibxO9QuAOeYczoMpZt0aFNc=;
 b=qCQr/BrRBlD/8stwENJZ9ZbiL9jOtz5JgvlaHD0KgA+4POdZ2W8L2rdtoi0z45FX94/4
 gcudDP6IitSq1k40vJJ+nkA8HZyvr+4u6yF3KDueZ4f9WUsFj+gX8Q1dt07Sg+YVIiQx
 xy3uM6c5mL0WhfxWzXNZbP1LPlB/Tqtu0AM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xdg1nc6v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 08 Jan 2020 21:47:20 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 8 Jan 2020 21:47:19 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 8 Jan 2020 21:47:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elw5aqS+yJ6bvWeKBpmZBHMQeNlQx8O/3kRKdOHrC9QJtsQuHMQoZvdku/K/9J8KWyKEnmITXFKM1QmJLk4KUtrimFn3FwvBU/S6Ig/Kc7UvCm3n/w4sYJtTb4GlYGLZskMm6UFh37owcEJmQocJw505VEmLym8eiBMuBYJ/140zaUsMqlThsc0X2sWPKVWWWZyCLB7VeCLHIsrxLG4yg6BGjZmJdyg8KgHNqYEUvcZ+/ofri5B7oqVwnwg6YDK0L1ws+7vCmDzJ41k/6ejudcLKy027LuQWlxswqRK3uLttGmZ/a6n70pco05R+1HwxlYlOYTctt02kny3AUUls9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ix3jf4375tnKpQQVWEwfibxO9QuAOeYczoMpZt0aFNc=;
 b=SJRAfqqvs3AjkyEs11aa36Nx7x4Luaiy7gsKyQkGb6hfxQvxAi3jAOJiKdZ9eODJnbFkfHMHV82iQnZzp5fdm1shI0hmuBqu9kl8BUJb6q0GdrjAJ0ZlLeJ42ntQZZPJJF/DLjJF+7vFP9+sACTcX8NhKWcCzOzNQA0LcD/AMVKyPUz1ggHwPc4Mi3lDlOuHWrtYxbdhCt/oidHjBJqPBWYJHvnzaV/Xres+zgOyRq3o5tPq6Z6/zMn0ItGOV7IYqwgQtwJXOY7ggd3LzxFimhcNlydtjNFvlI6apaJYn6k+zhbR9uVaI8wm6v+cTnri/ZffG2gL2P6SQkV8swoESw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ix3jf4375tnKpQQVWEwfibxO9QuAOeYczoMpZt0aFNc=;
 b=Tgcb2gL4RwQyKlJotPUpUBcDkDJiFx1fEODaevQ1/uSdqtCOORGOfYLi2GG72fG7Lp7dreOkEKyxZhdfFbI1BIzeuCbweFLs28Nj+HsBNibR4WZ/xDALymNjgkxxFXPkJcvWOBJeHnCXuik1gOxOqyFzMBBlfWbh4dj4FERBVHE=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2766.namprd15.prod.outlook.com (20.179.146.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.13; Thu, 9 Jan 2020 05:47:08 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.008; Thu, 9 Jan 2020
 05:47:07 +0000
Received: from kafai-mbp (2620:10d:c090:180::2b91) by CO2PR04CA0178.namprd04.prod.outlook.com (2603:10b6:104:4::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.8 via Frontend Transport; Thu, 9 Jan 2020 05:47:05 +0000
From:   Martin Lau <kafai@fb.com>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 01/11] bpf: Save PTR_TO_BTF_ID register state
 when spilling to stack
Thread-Topic: [PATCH bpf-next v4 01/11] bpf: Save PTR_TO_BTF_ID register state
 when spilling to stack
Thread-Index: AQHVxoX0L3acWFLRZkWKabPZ8GYIlKfhhREAgABOUIA=
Date:   Thu, 9 Jan 2020 05:47:06 +0000
Message-ID: <20200109054701.bog4btwk4724gwfw@kafai-mbp>
References: <20200109003453.3854769-1-kafai@fb.com>
 <20200109004424.3894196-1-kafai@fb.com>
 <9EC7DCC9-B219-4545-BA93-E2AC0569C843@kernel.org>
In-Reply-To: <9EC7DCC9-B219-4545-BA93-E2AC0569C843@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:104:4::32) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::2b91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82d14ea0-7708-4daf-5cff-08d794c75c21
x-ms-traffictypediagnostic: MN2PR15MB2766:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2766ECCA615C2EEBDF235A41D5390@MN2PR15MB2766.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02778BF158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(189003)(199004)(498600001)(1076003)(9686003)(33716001)(55016002)(66946007)(66446008)(66556008)(66476007)(64756008)(71200400001)(54906003)(6496006)(186003)(16526019)(52116002)(5660300002)(8676002)(4326008)(2906002)(86362001)(81166006)(8936002)(6916009)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2766;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UMiv0lXly18G6CglpdZZbsx/k7Mw7r8tWCbcxHW3V41jo0J4TeVWGzSXNXOLLxrTuzmBm+uhw1WUr3mgeRAbwo8HMfxKROFlN9v+Fn/mWrW2aH8MRai1oVY1Xm8PzKg98TXrnF40st8NWsNWtZK8FA5N9cspMfIcJjuFNQJ6CyQwRJon9AsrQyk34xckETQpkpaVWeds0fOH17K9frSt48bvxEi/fRN7GrskV2FZ2odunkBXiGL8jM1r9cu3SGVMOcgu115YwuUhT6vnnlTYe0ReyfHrUR+PKK8I4/IkQcit7r3y5rx0nFbmFH1S7oLXRntBoFpy737VMae7zNp9C00S1bTFsVaa5hmGJRta5XtdtahPNTlA9JgOa1zjdk60cDyyuYokM9ndsa64KjlDcDGdpprpwTDpX3aAyzDAAAaR5mD3O+mlcDY2HM0PZvNy
Content-Type: text/plain; charset="us-ascii"
Content-ID: <41A2A183A17D3243B0B31EDFD132CF2B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 82d14ea0-7708-4daf-5cff-08d794c75c21
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2020 05:47:07.3160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aifwuYxMMnK2FQhfG60ReQ+YL6lIV62uAuR2uEyyE+yTtG5i0B4H4G8R34knCOm/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2766
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_07:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=970 mlxscore=0 malwarescore=0 adultscore=0
 spamscore=0 bulkscore=0 suspectscore=0 clxscore=1011 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 10:06:44PM -0300, Arnaldo Carvalho de Melo wrote:
> On January 8, 2020 9:44:24 PM GMT-03:00, Martin KaFai Lau <kafai@fb.com> =
wrote:
> >This patch makes the verifier save the PTR_TO_BTF_ID register state
> >when
> >spilling to the stack.
>=20
> You say what it does, but not why that is needed :-/
It is the same as other existing bpf_reg_type (i.e. the above switch
cases in is_spillable_regtype()).

When a register spills to the stack, the verifier decides if the reg's
state can be saved (i.e. what the is_spillable_regtype() is checking).
If the state is not saved, the verifier cannot recognize its state
later.

>=20
> - Arnaldo
> >
> >Acked-by: Yonghong Song <yhs@fb.com>
> >Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> >---
> > kernel/bpf/verifier.c | 1 +
> > 1 file changed, 1 insertion(+)
> >
> >diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >index 6f63ae7a370c..d433d70022fd 100644
> >--- a/kernel/bpf/verifier.c
> >+++ b/kernel/bpf/verifier.c
> >@@ -1916,6 +1916,7 @@ static bool is_spillable_regtype(enum
> >bpf_reg_type type)
> > 	case PTR_TO_TCP_SOCK:
> > 	case PTR_TO_TCP_SOCK_OR_NULL:
> > 	case PTR_TO_XDP_SOCK:
> >+	case PTR_TO_BTF_ID:
> > 		return true;
> > 	default:
> > 		return false;
>=20
