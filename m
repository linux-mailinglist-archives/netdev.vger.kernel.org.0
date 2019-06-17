Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6507B4947B
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 23:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfFQVmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 17:42:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32914 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726001AbfFQVmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 17:42:14 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HLWrHV008381;
        Mon, 17 Jun 2019 14:41:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4wsZsjLvL1W/4XQskZZAHjn+Q0PyKR8DkquB9+r/iZ0=;
 b=gBgyXBx+ENyEHrOvj2goHtFnyPwWa1b6eSffe0nmgZ3qPsNY3sEcobA3jpquDy892yX8
 AjYIJtsU2usSNcuntfiHhIZKK+At9kLg08wb+ey78IISK6LTtTjUAVf7uXZmP22Xe+xv
 eNILbwOBct9V9SDoWRAPO3iPdAPGW/9EQS8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t6e8es50u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jun 2019 14:41:54 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 17 Jun 2019 14:41:53 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 17 Jun 2019 14:41:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wsZsjLvL1W/4XQskZZAHjn+Q0PyKR8DkquB9+r/iZ0=;
 b=TfXKR676tisSFa/LrVmBVJwJOEj8OTT6lBnY7/3UOClq/Konlc64TYOxOW0SbuY+TVrEeE6i61ER5y0demUb99nhDx63zxMKgO2C6cKE/+N207zDiax0pB5QCj9qlHU3hgwdvXLTAAoqy/PzmUbp8IrtcUyBvolsYmd99AHlULI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1584.namprd15.prod.outlook.com (10.173.234.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Mon, 17 Jun 2019 21:41:52 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 21:41:52 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 09/11] selftests/bpf: switch
 BPF_ANNOTATE_KV_PAIR tests to BTF-defined maps
Thread-Topic: [PATCH v2 bpf-next 09/11] selftests/bpf: switch
 BPF_ANNOTATE_KV_PAIR tests to BTF-defined maps
Thread-Index: AQHVJULBwojsUQVPmEWjcbGxlQ7y16agYGyA
Date:   Mon, 17 Jun 2019 21:41:52 +0000
Message-ID: <4DCC6EC0-9B6A-49D9-8664-ADC557C5DD36@fb.com>
References: <20190617192700.2313445-1-andriin@fb.com>
 <20190617192700.2313445-10-andriin@fb.com>
In-Reply-To: <20190617192700.2313445-10-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:da81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa92a336-a05d-4b10-5086-08d6f36c9c67
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1584;
x-ms-traffictypediagnostic: MWHPR15MB1584:
x-microsoft-antispam-prvs: <MWHPR15MB1584376C77E7DEF51EEDA317B3EB0@MWHPR15MB1584.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:862;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(396003)(346002)(366004)(199004)(189003)(71190400001)(229853002)(6246003)(478600001)(8936002)(57306001)(50226002)(6486002)(14454004)(2616005)(11346002)(73956011)(25786009)(53546011)(46003)(66946007)(186003)(68736007)(76116006)(476003)(446003)(99286004)(81166006)(66476007)(64756008)(66446008)(81156014)(8676002)(66556008)(256004)(558084003)(86362001)(6862004)(2906002)(6636002)(7736002)(305945005)(486006)(76176011)(102836004)(316002)(6512007)(5660300002)(6116002)(54906003)(4326008)(33656002)(36756003)(37006003)(53936002)(6436002)(6506007)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1584;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MKzA7IMjUMfD3TkU7vD2emPhfwH0pEVwhusPCLkCI4Kwpc/jbnDoUt2HXRWf+FZWM+StjtSNSXtu99TRMHzEsCzdAUru8tIi3jAyMyY41rq7pRP7hVj6QZnKzJwzzteZx7FHGMqtg+fQ4ikkJ7B+1Z9OLsuHddtmi4ZtqZRqNdtRcYeDrF5Z6seNAjnHuV9dDfjsAxSU1THhV9vTKca6E+JFNlHuR0MumVbw5vFZBlaV/hfG4Vm2Zbrhtu8kZY5btZ/ltAplOj+Xq99Mhfvr0F9eZAqVQMnvg+2GaK5EJEmcX/5+E5+kEOCBe22TbX1t1Qn84VXN5Ts0jCUc+cUcdzVUFkca1zFS2db6Mvv5IpS/7kxOo0tqXXmmdnPTkqL60nAS+10vMTHtZJlLYYSrXU5/D0LQsM1Yz10NjWmn1iI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1CED3324A74C734F825DB4B34B74F2B2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: aa92a336-a05d-4b10-5086-08d6f36c9c67
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 21:41:52.3816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1584
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=621 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 17, 2019, at 12:26 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Switch tests that already rely on BTF to BTF-defined map definitions.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>


For 09 to 11:

Acked-by: Song Liu <songliubraving@fb.com>


