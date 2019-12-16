Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99652121BEE
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 22:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbfLPVgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 16:36:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3606 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727902AbfLPVgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 16:36:35 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGLY7gF014106;
        Mon, 16 Dec 2019 13:36:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=VvCS/QtkUonuoTLpDaXXUOFCzCF+s2Zcdh3ukteshhU=;
 b=U/KwPXDmsDJXeiAWfFPmP8lz1S3G9oU6rmAZW/GbV6uXlckrh5Icw6JvARqgGtveAAew
 leaT5feG17GNTCfKX0lFncGsLUbOJICR+Q+8hwuwhvLe2ySkMRUz9kZV5UU7n8DyNbNC
 R3nnvvd9seHfKDwFqYBNt1LfpUSVhhUpvyY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wwgaypa9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 13:36:20 -0800
Received: from prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 16 Dec 2019 13:36:19 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 16 Dec 2019 13:36:19 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Dec 2019 13:36:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LokwF9v3vl4YsZx9Kiheac4zAoUVJRCVuaAzu3ZwLtrCm2l49WQFSZMGY13frbyYhM6DpcbOjaWsv40OPHUZazhkMXJRW/dkkh2hzep5JRJAfFWh+6JOVrK97O24C+mT59c/9z0D0F2Z+4wUYxtdfrQZjhcnrcSx0UaxaQJ7RdDoCV+XO/BHnBj6Zf9LCV8Ejcf4Jsfodjfb8Gb4MU2ZTuaYdt1Vpr53RvR2VPquFmhKkDmD9LOvyWKOkUaKhAYtrORbDGRToZdXxmXRLiiEBhhdO+z19Axw4oWdoWlMfEbuRy2H2XnXliD0aCWjm8Ou0suM7yUBpO/SzqPrAhkKPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VvCS/QtkUonuoTLpDaXXUOFCzCF+s2Zcdh3ukteshhU=;
 b=YNpScE4HWxPwackWz33nJbGWDrDKUDJ1v/lCuYe0hFPdsB53nNnuboaYFPh0uv8mT0l180LDYzrsnzo0jzUQfTsxSdiQQv909qkDMycRvj7iFV8qJwxD1U3XoJRvJ9Od2zMBrm5h9mJGJltpH9bWtZ+WoSIOYCnW+WXKX9+X5m1RXy91aUQ6RgNaUj+/J5fDwHiHwZeVr3k7xKEHVVjnNmhB3/Y8ZYPsl4YF1vn0UPFdFr590up330JWQsOVgiUmysvyTfTMl0zgZtjbBaAwnmOGtagtl6LpfOxV668aqXY6ImSWF6gHj5+3GWgVn/BcpxZuOyMia4IQkKKZ/wQRMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VvCS/QtkUonuoTLpDaXXUOFCzCF+s2Zcdh3ukteshhU=;
 b=G83u7TQzAs3eok6P5odXSxrFxEf9747wxoY2d2mezJxyRBWnfNBh2vMg3/vLf5q6+242OjwWMYo8s1pWsEU5wB7DeenqjBvNJFCSSwC/NM+2J4Yuwv7Qh3xVvIdITxIv/60uRAmXBEEURtyMuY1Ib4gBR3fZuCBeFAXnW6066o8=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1356.namprd15.prod.outlook.com (10.173.221.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 21:36:18 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 21:36:18 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Martin Lau <kafai@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 03/13] bpf: Add enum support to btf_ctx_access()
Thread-Topic: [PATCH bpf-next 03/13] bpf: Add enum support to btf_ctx_access()
Thread-Index: AQHVshgkSFXxH/dmdU2WpaaWZNVRWKe9TX+A
Date:   Mon, 16 Dec 2019 21:36:17 +0000
Message-ID: <47b4c496-1d5d-0733-7c63-41589021fae7@fb.com>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004744.1652395-1-kafai@fb.com>
In-Reply-To: <20191214004744.1652395-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0049.namprd08.prod.outlook.com
 (2603:10b6:300:c0::23) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::dd8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf6e19ab-a679-48c2-768a-08d7826ffc06
x-ms-traffictypediagnostic: DM5PR15MB1356:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB13567171DA4F3C37474429C4D3510@DM5PR15MB1356.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:466;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(376002)(396003)(346002)(199004)(189003)(53546011)(2906002)(52116002)(31696002)(6506007)(186003)(66946007)(4326008)(31686004)(6486002)(8676002)(6512007)(2616005)(8936002)(71200400001)(558084003)(81166006)(81156014)(478600001)(5660300002)(86362001)(316002)(110136005)(54906003)(66446008)(64756008)(66556008)(36756003)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1356;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GfMZYB5+2U8uU91KX5drkpkYm3rq5eIK1D4sXodBT2wWhG0oh99Lt4GE9dVwTeYOc37QKHh4fe5awwjiep1HEw25WK++7mXjTFEK4pkidrqdna9lRkskVRzAITMIU8HEtnMP9MLBDsqaT7e7IijLURuXr1NbnRB9FGhIDnr+xMO09oss8jueai0j4SIuxI7fePls+AEQ1J8ckKtMYkSWCMad1YymfVzsjMT5Kkmt/UtByqANlDuxhQcASJE1NvWMjG5Zvvu+w44OxyQqrCj7eCtHyb7uYagRIXtiFjBf4+1Gf2rhN0HcDzKjQdiLdmGJf5ofSosMu1Da+KXhohenAOYIPlDvQBHv9Ptc2lWe+wg3lSI8D3iG7a6hZVauA5DgQ7r3JseiyZcKB8EPa7LtTk8kDZbnvk0Mo0XTU+J0u26d+CJyoZyjxl47mePzJB3E
Content-Type: text/plain; charset="utf-8"
Content-ID: <B151EBEDAD284241859EE9B5B8FEDBB9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cf6e19ab-a679-48c2-768a-08d7826ffc06
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 21:36:17.9016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZuRglhestWbON8P3KYbfwUa/ugWeQyp/ZVYsOC9J94CnbMpdngG9LDnwBSOE74FH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1356
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 mlxlogscore=814 phishscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912160182
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzEzLzE5IDQ6NDcgUE0sIE1hcnRpbiBLYUZhaSBMYXUgd3JvdGU6DQo+IEl0IGFs
bG93cyBicGYgcHJvZyAoZS5nLiB0cmFjaW5nKSB0byBhdHRhY2gNCj4gdG8gYSBrZXJuZWwgZnVu
Y3Rpb24gdGhhdCB0YWtlcyBlbnVtIGFyZ3VtZW50Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTWFy
dGluIEthRmFpIExhdSA8a2FmYWlAZmIuY29tPg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8
eWhzQGZiLmNvbT4NCg==
