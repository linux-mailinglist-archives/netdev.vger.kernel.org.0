Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A6D5A356
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfF1SSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:18:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3134 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbfF1SSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:18:03 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SI8e0R003180;
        Fri, 28 Jun 2019 11:17:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cnF1WCZiv16SIn1EmMuCRbhqe/+SzJRNF7n3aFpV/Qw=;
 b=iFvZ46bJc1ekQsw75vQeYzYK59cxclCktiA0innp/Wd+MOGcZks08ScqmfjHpArZcskz
 rYCq9cp+hLOCDRKWZfVVpuSJooFrwHHhEAXF8n8Tkw3gq/fDNQ9+dsvtO1jSDhZM0Ool
 dKPxLgmrwQGRsENmQqPetvSU9IpYAx8oTus= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tdm8u0xsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 28 Jun 2019 11:17:44 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 28 Jun 2019 11:17:42 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 28 Jun 2019 11:17:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=GOeUPCi8KNTTTNLicFvqNFiE8AN5MCKsAXFFqq+g1XeEf9vsPaTmCIOKkQ8b04DOnslOmrljS5KjkvkPId0RIrYzheGZgCjfigFz8HK1+v6zXZbI8mOpqGwjulN+BKTmog2bmZ2hy80WsFAqDVWFwMRlJOZmnOR4ey7Gpw0ZJyk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cnF1WCZiv16SIn1EmMuCRbhqe/+SzJRNF7n3aFpV/Qw=;
 b=aFRnWCf3MEeHOloYZKIcaAk82NmR09WDR99KKa53IygTVtZAPUCJug4wRwlJRbRkAiK+EOpZWl0wC7qSO/Rxy0NMC2cxQNMyFj5ewDYKolBKJ/UCfFpIGWr8GTIn/UDKlqNUdx3/4bIpKxoS3PNkTte09tnAOkuIenCkD9Yzx8M=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cnF1WCZiv16SIn1EmMuCRbhqe/+SzJRNF7n3aFpV/Qw=;
 b=siohBwN6vdOi6qt05al7MlSG6vf+cGG3GqbL2XmKuzi745yJVR+mLunSTHhQpoDdA/JbE7/0UoT2wC/RAqiSJocY9Ox5Oe3A8w0Q8H7Al3GGKMRWMOPVlpP/mF2JAjL8qajWoqeRQ252rlKJKk1ivlw9GaZV+X3rcJ5uIC4DNfE=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1677.namprd15.prod.outlook.com (10.175.135.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 18:17:42 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Fri, 28 Jun 2019
 18:17:42 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 2/4] selftests/bpf: add __int and __type macro
 for BTF-defined maps
Thread-Topic: [PATCH v2 bpf-next 2/4] selftests/bpf: add __int and __type
 macro for BTF-defined maps
Thread-Index: AQHVLcXK6i2W4pbMLk62HxtxwSDzKKaxYACA
Date:   Fri, 28 Jun 2019 18:17:41 +0000
Message-ID: <A996B443-8D44-4438-8A08-37873AEE983F@fb.com>
References: <20190628152539.3014719-1-andriin@fb.com>
 <20190628152539.3014719-3-andriin@fb.com>
In-Reply-To: <20190628152539.3014719-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::2127]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9eecd636-ac98-4172-a7e1-08d6fbf4e916
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1677;
x-ms-traffictypediagnostic: MWHPR15MB1677:
x-microsoft-antispam-prvs: <MWHPR15MB167797BE078F40DE9D07E5C0B3FC0@MWHPR15MB1677.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(136003)(366004)(396003)(376002)(199004)(189003)(73956011)(71190400001)(36756003)(11346002)(6862004)(8936002)(81166006)(6506007)(86362001)(486006)(81156014)(8676002)(57306001)(446003)(5660300002)(478600001)(76176011)(99286004)(6246003)(102836004)(53546011)(68736007)(476003)(4326008)(6116002)(6636002)(46003)(2906002)(305945005)(14454004)(4744005)(7736002)(25786009)(229853002)(64756008)(66556008)(2616005)(186003)(66476007)(50226002)(6486002)(76116006)(6436002)(316002)(37006003)(66946007)(6512007)(256004)(71200400001)(33656002)(66446008)(53936002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1677;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dnnaNnRUh1Anvqk0w0l8xNzL3kcPJbHgX/RNRmA1bnk0kjrYISfa5ABd1YpU/10CoHU2jzgRxZXn55wUSNDVkQ4NoknX2uvIdgI5lxwAAbvgxpCPumEcMeOqS8c4DthkD7dYzlZJulNV6LcFi1USdgLvRP/aYXrETj0+AvX7w7JXmrze03RXi9Kos4xVXfsWBzfbPNiufBExPjp8dQnmy9YsAUEBZmFCD8zTwCxyu4o4H67tzlJ/xKL6AdhMNeTG5S3ObI5R0UH7Bs26Vt5lX8AwCoDvsOw/j0cpW6Ou4Deve1gb5JI9OiJgCo5RM1mKg98c8J4uK/wYE10yQLWT8m79JrYmJDMeyUQRZHX2tF6Ummwc8DvLJ1OXWpEMv4EiVSsOVOb+IqnoCwJ8P0BfMPiIdCoTguqcCuVgFmG3bWM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A79210166C84B348A57251F1EBCC2E99@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eecd636-ac98-4172-a7e1-08d6fbf4e916
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 18:17:41.8800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1677
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 28, 2019, at 8:25 AM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Add simple __int and __type macro that hide details of how type and
> integer values are captured in BTF-defined maps.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> tools/testing/selftests/bpf/bpf_helpers.h | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/se=
lftests/bpf/bpf_helpers.h
> index 1a5b1accf091..aa5ddf58c088 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -8,6 +8,9 @@
>  */
> #define SEC(NAME) __attribute__((section(NAME), used))
>=20
> +#define __int(name, val) int (*name)[val]
> +#define __type(name, val) val *name
> +
> /* helper macro to print out debug messages */
> #define bpf_printk(fmt, ...)				\
> ({							\
> --=20
> 2.17.1
>=20

