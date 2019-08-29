Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83764A2B01
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfH2Xhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:37:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54988 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbfH2Xhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:37:50 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7TNamFk007859;
        Thu, 29 Aug 2019 16:37:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=yWYMl81FHh1P21JibVbLoblnVoWc71kwKQHUOuBkI7U=;
 b=qdWaR83tZnqPEa6lSJ42Q5zhj4fA0ZtKmgcUciCqcXOiTx20SVsxH/v8+FOYvKBZOz+r
 DbHTa8grXMeo0CIIpuaKvbhsxlPpD/m6IzJRsjpvi/1GNb+u99vq3wlBUiiLSp22PW4Z
 yl3onBJrqdRMMq0tyGVxVeakTrRSVLZc4Zg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2upqya04cy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Aug 2019 16:37:28 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Aug 2019 16:37:27 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 29 Aug 2019 16:37:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYHma7/ljYc74Q6D0oaxz1RI1fuLry6I4i7BfT7f7WIIrVHULvwohW5Rd9b5sZOEdyptFHG/g/oLEo1SAxk3i8eMjWaRHLNwukleHSvzM3yot/GPtIksRbtetwxCDva+BTmheT3mL/Jq5wBnXk6yQktyeoOI9UVvjhajNzfuBMEvkiAvvSuxAUd6cB5NeBhkuuazLBefPmUgHzx+yQtf6oHfvhlu4Sz2tnzhNkm/w4Sgfb+Fzw0c+d/wms16LJCAnk6lHIl0JZ7F26ozcNhWVTdb1Gw9FXfc36MV8/fpHoIaLD+kCFED0hsjWrKHG3Hzf48ZkNMnNqdCxipaQKz/9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWYMl81FHh1P21JibVbLoblnVoWc71kwKQHUOuBkI7U=;
 b=GCdrFvvcEks77jNT4QSrdoLsG5sd5evlnitHknDxU3JE2IgoNY7rIJN8TjMuZBEK7Wuco2HLohU933uSOidXbm/j7qs6Pj7aDbSL/5SsgbAkgm+SWRt0ANwrqh7VatXHpEjsrxlfp4erL6QaIJoGaFmnk+1LcewjOr1N6qr02weQDfMtc0aT64fD8kGilMdZGTk2XfwnQFJxEQ/MWbnp1cngFP0n6E72bSEGZzEPLFT9hjOZLKVgalCatMfhulWdgFlTM/Fpdd5dNvvcep7jGvb+egbC5ErVSpxk0nEJNoYpESaKFNDVFMBdh8xvJew7WlcLZfqd8zbv8TzBZ1zP2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWYMl81FHh1P21JibVbLoblnVoWc71kwKQHUOuBkI7U=;
 b=Cy2oclzTi8oq1RuEZv67kYBVEyLYyinRRLQ7ZkrazhmS8eU7VZgKVXRkqMi7Ma/GxRJRUIDyBmk2CgE9/nSYe+KE9Lc9M82dZRp5bo3omtKRDhpJinINWHLX/IrilWckSo2zeAM/xJQHZXE5vyAnktb5kzL2Yd51IAbRo2MOwmU=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1213.namprd15.prod.outlook.com (10.175.7.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Thu, 29 Aug 2019 23:37:25 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 23:37:25 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 02/13] bpf: refactor map_update_elem()
Thread-Topic: [PATCH bpf-next 02/13] bpf: refactor map_update_elem()
Thread-Index: AQHVXjVmgAruU9LJZESuvh4uY0KbPqcSyQGA
Date:   Thu, 29 Aug 2019 23:37:25 +0000
Message-ID: <146453E4-083F-4ABC-B55E-F6F260EAD333@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829064504.2750444-1-yhs@fb.com>
In-Reply-To: <20190829064504.2750444-1-yhs@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:3161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3423b0c5-d9fc-4798-94be-08d72cd9d904
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1213;
x-ms-traffictypediagnostic: MWHPR15MB1213:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1213106D1C9A665363359025B3A20@MWHPR15MB1213.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(376002)(366004)(136003)(199004)(189003)(81166006)(99286004)(14454004)(7736002)(54906003)(486006)(305945005)(33656002)(14444005)(8676002)(8936002)(37006003)(316002)(50226002)(6116002)(81156014)(478600001)(36756003)(229853002)(46003)(76176011)(71190400001)(71200400001)(4326008)(66476007)(66946007)(66446008)(64756008)(66556008)(76116006)(256004)(6246003)(2906002)(86362001)(6862004)(476003)(6512007)(6506007)(4744005)(53936002)(446003)(6436002)(2616005)(6486002)(11346002)(5660300002)(57306001)(102836004)(53546011)(25786009)(6636002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1213;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OpNehS+ofd24QBb72Z4IZ42v9nTE8GrMzrqN1opYbc4WobxAD1p7jFfpWO8RX5LhZu+iQyRnrN8KJYwdSPK3y1/CVoaD6VLKL1HE1ZbJlt3/p13poaIw62k4K4J5uLDq7uf8TNJ4QvAUa8R3Nls/PvYeC7knmmjO/0/s1vrOPw2zJ471HfzBzw1VcFcqMV3AsGqR+7EcuVjHnfnL1TXBoNhlGr1t+BTMTA9T0YXwoTuT1Y2j72i6sSonFvexBRof7Q4aGnBjbOdcgXr8GqG6Rqkr/bPC5fByfrPoOCMqqykw4xcRZhWvw//bWs6fSJ4CiVCqAaKHzi66i2jxfXnQ7AriJObNp8WP7dmQMP0ukd+WrEctqLRvbypwPNtA0jNWsSSLNi2iHBWKvcz5Aq0ELSpUKzkdEw5vS0pxUuZ6pcU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6108C377C6DCD24BA076A62D6B9739BC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3423b0c5-d9fc-4798-94be-08d72cd9d904
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 23:37:25.4666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ygb44KMlC4CvmVfh8Kb4jv3eeJafQSKYK6JXsiV3xENFpXHYzChi4YM5/rNYOnIpyy6CR+5A6UK4J/vnQ4eFOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1213
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_09:2019-08-29,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=589
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
> Refactor function map_update_elem() by creating a
> helper function bpf_map_update_elem() which will be
> used later by batched map update operation.
>=20
> Also reuse function bpf_map_value_size()
> in map_update_elem().
>=20
> Signed-off-by: Yonghong Song <yhs@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

