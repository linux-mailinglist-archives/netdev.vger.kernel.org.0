Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B534A2B0C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfH2XkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:40:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25296 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbfH2XkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:40:15 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7TNaoo6007922;
        Thu, 29 Aug 2019 16:39:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=W1OdtY7sJdpX8qV/4Wh54kHmMMllgaPFREY3QnKN3dQ=;
 b=EejqNlvlyATvOPH8j4idFZLs2Ogh2xu/UTgZwj5YpspETRItlhTp3G42a+2JgnlZWgUi
 p+RZVUSQAxEYZi205UNP7ZfciHwu9YF/p6zo3o4Bh8+c1+H2GmC8NZE5x6+pCpJyAe5i
 s3h0503vzu2KW50lq4PqLnpL4amfHjY+F2Q= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2upqya04mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 29 Aug 2019 16:39:54 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 29 Aug 2019 16:39:53 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 29 Aug 2019 16:39:52 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 29 Aug 2019 16:39:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxS7BaoqWZm3L9g9sFfTm+N9u7aIf4TE3cNF8h8VKMx+kV/yabsxGuyTTb1x73lCAMBeTESisZ7jwKxzrftFzN4jOWDXAafUuKykD/WdlAIu0xZfeXT80WGCfqW14riKntlaa5rY2Anv9RsbCcJGSodXXij+JTPJGeWyCKsx17+in/n4XgeGO2SZnjGYbIyeAXI5t7v568DFpN0JtkNYw0KopX7G/TpShQF8F7X3jWrvXT8RInKKHNFL5h1DcuMKS2W34eGlfQfpbMWx/KsrjILLswIpRBgYApeviECyuh8vhKWlqWrkGoA31FCrl17IaKls25iXxi0gOAoMCKJTgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1OdtY7sJdpX8qV/4Wh54kHmMMllgaPFREY3QnKN3dQ=;
 b=ZloeGygliq1QtXYTev3/P/alIKc1/UPZmxDJpBiVokyEQfjn8vCsugHwsid3mS/MOqPMWXWGariSfvU5by2L+XLPkwquHsTQ63uEkDptDlUz8drD4s5I0T6QOznHHnN0kjf1EAmDuOdqf2lqJpmfcAJEQR6jlFm4kZPaPfS76CGN6RsR+ujqhZxAi/DmOTcf4EyhM17hk2ZZfW1vi721aS2saExAlCJXG81y4XOxVmyIhFklCjEIHEvQb9DgwIZz4h+BV0f1rK8Bkz05C1X1/SQ2/oCMaV8nsxb3kq+t3ThvnpInRCa4kuSXETSTN9YwEyDoTvg6CgN+QRATjUHeZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1OdtY7sJdpX8qV/4Wh54kHmMMllgaPFREY3QnKN3dQ=;
 b=OQN1/Q/x843djo3+Jc+v9ndk0jBhUzc41z2JMdWMpbCvJu9k+Bi/ags6S3o7PwAiQS2HRXHHH/uEKJjbOBuZ3tkkTt0IK+FEEC6oMAmBUWzHfKAchkXtVB4gLcJN6+3GJ+HUcbNQO1SwoSulyeZP1A/WY7oipf/sxZpbf3QUnhI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1213.namprd15.prod.outlook.com (10.175.7.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Thu, 29 Aug 2019 23:39:51 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 23:39:51 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 04/13] bpf: refactor map_get_next_key()
Thread-Topic: [PATCH bpf-next 04/13] bpf: refactor map_get_next_key()
Thread-Index: AQHVXjVUOProZ/ylqEmaGuTN0JGos6cSya4A
Date:   Thu, 29 Aug 2019 23:39:51 +0000
Message-ID: <1A9FD1E2-E4AC-46AA-87C8-CEE8C96EA539@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829064506.2750717-1-yhs@fb.com>
In-Reply-To: <20190829064506.2750717-1-yhs@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:3161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05ea8ba3-ad26-4df7-06bc-08d72cda2fdc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1213;
x-ms-traffictypediagnostic: MWHPR15MB1213:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1213CF3EEC204A5E4F3887ACB3A20@MWHPR15MB1213.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(376002)(366004)(136003)(199004)(189003)(81166006)(99286004)(14454004)(7736002)(54906003)(486006)(305945005)(33656002)(14444005)(8676002)(558084003)(8936002)(37006003)(316002)(50226002)(6116002)(81156014)(478600001)(36756003)(229853002)(46003)(76176011)(71190400001)(71200400001)(4326008)(66476007)(66946007)(66446008)(64756008)(66556008)(76116006)(256004)(6246003)(2906002)(86362001)(6862004)(476003)(6512007)(6506007)(53936002)(446003)(6436002)(2616005)(6486002)(11346002)(5660300002)(57306001)(102836004)(53546011)(25786009)(6636002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1213;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 24UaIWLDFI2cF1zyj5j8j0QvylzzzmngMc6+8RqxNvI1sKooVsB4PA8YNRA5H7m1L9PJau3vdMpzgUeJoRGO2dEJm6cMl7OUvf8LuEjr8+zQHTe27RKb2UbCWcDThMIeDuV2zCXfAzQdkO95q5HRKtoKo6Lo29OGWj+MSp1/a+u73j3eLheqJwPiowJd682r3orMFzpjAHNn1AnUp/FHvA6NdRlu6PdWioFUbGrMaNVX/lbLSKkh+n1csAzl2hdI3tjIcBzIHaJIWQHj7FRX+Uc2J9TOEAppyPs8MonRUf2rFW7LrFa1vBor0V4wOXJmTOHZwyqscKhHS0uaHqo8QQGPwITUfr+/+pbS86yshWdKTVB1+F3MDEkgWTgc4+TUebmkHbrsQdKN394gQ+5l2zKzbE3yHqwanFoSKvGmrLY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0484F71E3B2F124F8405EBE19BAF7A13@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ea8ba3-ad26-4df7-06bc-08d72cda2fdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 23:39:51.2326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QlPQfoiSWdcOx2XvrOOApWl6v0OoaZbDIaeLD2g1MKuLsftEQfrOfizvfW5Ff7QKyhrPPgsH4eSTesstGPIqKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1213
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_09:2019-08-29,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=482
 malwarescore=0 suspectscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxscore=0 impostorscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908290236
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 28, 2019, at 11:45 PM, Yonghong Song <yhs@fb.com> wrote:
>=20
> Refactor function map_get_next_key() with a new helper
> bpf_map_get_next_key(), which will be used later
> for batched map lookup/lookup_and_delete/delete operations.
>=20
> Signed-off-by: Yonghong Song <yhs@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

