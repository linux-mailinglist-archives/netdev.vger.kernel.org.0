Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B77126CE2
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 20:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfLSSni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 13:43:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56346 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728849AbfLSSnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 13:43:37 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJIfnNe031477;
        Thu, 19 Dec 2019 10:43:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WpbJo3aKp/jVQQkBdNjJP/OGLGz9kg4pF0a8B6DRZKc=;
 b=DRWOZhBimVqj9VbjeOz5RWrcxTwwjJ3s/ujp6f2KelpTTMaYGwkmdt9m3IxSoOpG6V0f
 EkeeP3SkPW0Y6U9CGrxT+8Q3DGwejW7B/SeVT5ZqTMWuzegRVd4WnPTsyy7l6oBkolPv
 CRgvl7qMOeAehdSbDLkUQcj1xHcUzri7ToA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2x01dfufmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Dec 2019 10:43:34 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 19 Dec 2019 10:43:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fiMSksKyOF/Q3gKrWKFAj5GttajqQnXY69DCzYQjZkxFp5w1u3/f5ukxFmYT0/6q6BKrqjBIrTTvpAp5o7ctIDIkkw+7FLAtYA1mTXQKFxZVlsBqxkITWhf0/aQixH0LBEJSxCUD/NfR/fanQqS2n8Iiw4HcUvcrLdJEiB1OIKrv6ShTQCF2NDpxIP6IS0wKao/eL1GmNHdTwzWC56ElvwgOWH6ga8P3VPL8v9NxIT4rt4+BUfY/ObFoquELrvO9eMzXqOAQSEezA/Eqvn2bcPZmIx7NmweO7ocevbcPnzqsGbRK2UitYPtTTZA7ZNrJs7Y0WzufSXPcpedcDQOWOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WpbJo3aKp/jVQQkBdNjJP/OGLGz9kg4pF0a8B6DRZKc=;
 b=WNIw0VC00O6sv5m8SVgVYJEHFDeW/hYiNQVU3oI3aQyNr170rLuNFgGw1QCf/lpiS67xFjh6KYZG3CcSnXvBZO04+Cz3mLojaFtrwAnLAxYlHhSgKkG/oF3rLibPyEq+vMgGLNXAoxY1oJV7HakdNQVuKA+m3pznCe0qMFnAvtYrFlg7eQX1tkMzXfm2kptFDy8N0xu+vf7lu8SiIo/+7uregS3xr6VtqqQLothO0IqAzGcWnlQWuT3JPTkmjzQYF4tOfsl/VCictuuDffYF/iVN5hGgjtDm/ol1tlfYlYtsKurS17XdC9PEiYQaLtZsseZkdOlRC9vtodK+6BR2LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WpbJo3aKp/jVQQkBdNjJP/OGLGz9kg4pF0a8B6DRZKc=;
 b=TD4JoEGSwi6IgeK4rwgBMK42PvegHCG6y6/1Z8mDL2zt3ZQZgCd4iivDPNiMg/kpA5D2wJ9h/vIGvwBvgsVb3BDEvFwl+LMRxKI+LIqdrlNmQfncL4DvJ5PPprt8eGQ/lg5IzNxF76+YV9BcqYbNwkAv3LARi8nNsBuXd5yK1cg=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1929.namprd15.prod.outlook.com (10.174.247.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Thu, 19 Dec 2019 18:43:32 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Thu, 19 Dec 2019
 18:43:32 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v16 5/5] bpf_helpers_doc.py: Add struct bpf_pidns_info to
 known types
Thread-Topic: [PATCH v16 5/5] bpf_helpers_doc.py: Add struct bpf_pidns_info to
 known types
Thread-Index: AQHVtcoKRUIyI3Nr5E2tRRaFB/SKkqfBzNWA
Date:   Thu, 19 Dec 2019 18:43:32 +0000
Message-ID: <b27ad382-8af1-de61-cf10-5db1682012da@fb.com>
References: <20191218173827.20584-1-cneirabustos@gmail.com>
 <20191218173827.20584-6-cneirabustos@gmail.com>
In-Reply-To: <20191218173827.20584-6-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0051.namprd04.prod.outlook.com
 (2603:10b6:300:6c::13) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:442e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 593646c0-ce82-4ad5-87e1-08d784b35911
x-ms-traffictypediagnostic: DM5PR15MB1929:
x-microsoft-antispam-prvs: <DM5PR15MB1929410AE5CF755D92258F05D3520@DM5PR15MB1929.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:220;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(376002)(136003)(366004)(189003)(199004)(478600001)(36756003)(6506007)(6512007)(31686004)(2906002)(5660300002)(66476007)(71200400001)(2616005)(8936002)(86362001)(66446008)(66556008)(31696002)(64756008)(186003)(53546011)(316002)(54906003)(66946007)(110136005)(6486002)(4326008)(558084003)(81166006)(81156014)(8676002)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1929;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DB7Gtw8LPrbRiyBrMNjghbvEguFlX61VFNHzanxKTaNXiDHOvblVSnh16TWuuVISbFWg8hgdeOe9pMp4HkkWSxG8Hadmzn4E15Zlj0XH+I+kVlyO3R1pJIUt61N/wsjFXRCi6ily0pxbVYW3Ys+khdFOEgiwBwHHGja7DkDXUHkDPa32Rw5nq48k0sR8bQt9JD/fDCxYufLM5zKMAPZ8IHhIPfj2wVp09zLXYvvN6s79jxFvZ15EVNO8Cc2Kcykicf7qb8AgV/HVdEtuS8xy38H87VSPKMrAzzrC2jDroJGF77e9uBE0rFt2SHC/+WuQH6XR7wru/+Gj1TN6dhiwyeuPrry9lSmgfVyOgn1/8zQ5E3IWHZz9JZ5+VvBOdXhgzOeumFmgEoehe10DtcXlxBUrr2cE0q4BkdO+lFMhUSARdYYIvZSyce+julLY6QU0
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <13BF38E346B9C94CBE27C34798C7CF3E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 593646c0-ce82-4ad5-87e1-08d784b35911
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 18:43:32.6167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3apFe9F/M5+quHM2LMhwF1vqiPGKhehnkd1UV1vZyISKVRLvdm2gYneIggWM8cFh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1929
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_06:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 impostorscore=0 suspectscore=0 mlxlogscore=614
 malwarescore=0 clxscore=1011 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE4LzE5IDk6MzggQU0sIENhcmxvcyBOZWlyYSB3cm90ZToNCj4gQWRkIHN0cnVj
dCBicGZfcGlkbnNfaW5mbyB0byBrbm93biB0eXBlcw0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2Fy
bG9zIE5laXJhIDxjbmVpcmFidXN0b3NAZ21haWwuY29tPg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcg
U29uZyA8eWhzQGZiLmNvbT4NCg==
