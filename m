Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D84371269C2
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 19:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbfLSSkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 13:40:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34934 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728433AbfLSSku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 13:40:50 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJIOWnv030655;
        Thu, 19 Dec 2019 10:40:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JLkr62kxaQ8Lhq+xeClwDTXJCp2ukT3Qs/q8Xh9vDkQ=;
 b=TRvyQJhsjQ1fGVnUDIiyIseWdXfK+GHu4IrwqIIKyl7KyVaC7D38dOVHvfLqv5MvdNQJ
 U1//rTS1XI7Qzw65RFuaV+ziCNQFf+Grj3SYdJ4dshjRUdTtEbpxWnR4w9k9y/CZPVTS
 un+jclEcuv5WUfEd0h5YaWDrQ5t974nSg+U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wypvwpm5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Dec 2019 10:40:48 -0800
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 19 Dec 2019 10:40:47 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 19 Dec 2019 10:40:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GA3U96GuWkq/wFSYk1d39JMX7E9jYa6wOuemBexGACjySKk+XEoMDMSfp7la0AtXH3EmJ2igv45+a90WZX6QHsuWo4evtrVz82ET/rlmbB9+gxOycf/cfuyXg6eMbUDWTHkg1IoyY8UsYhPTxJ14qShwSe8RVtxALMGoSYcxx7ZHUPgTPiJ3DNpv2pCmD7SUrMaTGYy5JPsCxvR6CjLLD9D8vT6pyEed/lu4hYFFOmSzvOkR94BAYrJBEEmWNek1xBqCluURslLsnuqwMSx3XavDftEk0X2vcYi/PiKJpz3Dski+kafK5g8/kHVDrPNY/P322ecPl1xNFLsQV0X6gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLkr62kxaQ8Lhq+xeClwDTXJCp2ukT3Qs/q8Xh9vDkQ=;
 b=AV898UK6kT3Zzp7AnuQEVE8hEICHNJQ39ttXIq/wRiQEWkNhR0m6WlqRaT7Qng8DUI1To/CQO0mY6DviZgrwRV8BkRvQ6MKdQ8347CHXi1GzeWf7xHCIETU4/g11zv+lyKq747UI77EslCA4qAZ4/8OAv7F8Omj63oY5XQYcxK3D1Hmba7npZTIia+G3VdFQq25QTiossiAJCfCj3YoBq98lLY2/Nt60tKYSQ2hs4QUTRU4eMDJQkoqxgmXOF18/y0T+WSEZP/Owy9iPD1MeczVSPuWDFob9YZozsQ8DexiT3lpOoTrU2NY8hOGcvKK62ZXPNqV71NOYvcN9S2H8zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLkr62kxaQ8Lhq+xeClwDTXJCp2ukT3Qs/q8Xh9vDkQ=;
 b=dc4a4usZHgIE8fLP/CUcwbwJ2u2ixbttqxw027odvYWX1YwPEZF5Ec/k3HUzVUc9JSMNQtCcNXws/x509DJfxRTsMpf0U4LLZSWUPgjAInKIkt+f3kq1CY82s617mg9rnfyGowNBfxeeQ18ETs/NPLKAfOKPdEeZNuNVct+up6A=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1929.namprd15.prod.outlook.com (10.174.247.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Thu, 19 Dec 2019 18:40:33 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Thu, 19 Dec 2019
 18:40:33 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v16 4/5] tools/testing/selftests/bpf: Add self-tests for
 new helper bpf_get_ns_current_pid_tgid.
Thread-Topic: [PATCH v16 4/5] tools/testing/selftests/bpf: Add self-tests for
 new helper bpf_get_ns_current_pid_tgid.
Thread-Index: AQHVtcoJC8S7Q2cLIUOzL2UrYW39AKfBy/oA
Date:   Thu, 19 Dec 2019 18:40:32 +0000
Message-ID: <cb835536-1c71-5892-0fd0-1cbaf1d28eae@fb.com>
References: <20191218173827.20584-1-cneirabustos@gmail.com>
 <20191218173827.20584-5-cneirabustos@gmail.com>
In-Reply-To: <20191218173827.20584-5-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0039.namprd20.prod.outlook.com
 (2603:10b6:300:ed::25) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:442e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3be7e9d1-a18c-4605-d0c4-08d784b2ee01
x-ms-traffictypediagnostic: DM5PR15MB1929:
x-microsoft-antispam-prvs: <DM5PR15MB1929427A74E006D4C1904DC2D3520@DM5PR15MB1929.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:538;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(346002)(39860400002)(396003)(199004)(189003)(66556008)(31696002)(64756008)(66446008)(53546011)(316002)(186003)(86362001)(8936002)(81166006)(81156014)(8676002)(558084003)(52116002)(54906003)(66946007)(6486002)(4326008)(110136005)(2906002)(31686004)(66476007)(5660300002)(36756003)(478600001)(6512007)(6506007)(2616005)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1929;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hC13F/wcKrszh3QFtOjXHKQH+2Kjgtc3VDGY/VNU31QzfCLFUoNxEw4MpWh0KOeAJ83Fj9mQhmlFNGeiTUzbupC91ln7J2GP4cru/VrzCayEHT10kNoKRc45Su8FgUkKE8kQ7kXEHnc/4HQ7MvW2/x7BfLgb5ALbpyi231I6eiyWjfE1MTV6nPH/oMyirba5HxELIMvzg34VCp42wm2/FBAMKSIDKBeSK7ht9EFzvbW5vYa7dDvXf4XIrQW218Tk6GRoY0/pZ1DefDhhl2XVZrju6hMZAG2yD7fYCMklNz4whZBQTnTjyH0BKuwYpQMmhxDdNp/7TLYrJHBQk6wLvKU/rztAUD3KyeoabPD+y3uRJ4Aq/RgU3wTX/CwmUHEZ/GxPv7+C+kKtCvkRIQYRNzMjqwL5Iu3BWMEDSwmdb4qLLwCMPI9Ba4iRZdGJy/wW
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A3F4A8302F78E4C86F9EC2EE177269F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3be7e9d1-a18c-4605-d0c4-08d784b2ee01
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 18:40:33.0005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9UJC/ESeAEaS9GEZ9jontd5pnTQGHHWdg6H6pKXn6OqRjgipvcFPB2vKjrdcdVmw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1929
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_06:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=603 malwarescore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190135
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE4LzE5IDk6MzggQU0sIENhcmxvcyBOZWlyYSB3cm90ZToNCj4gU2VsZiB0ZXN0
cyBhZGRlZCBmb3IgbmV3IGhlbHBlciBicGZfZ2V0X25zX2N1cnJlbnRfcGlkX3RnaWQNCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IENhcmxvcyBOZWlyYSA8Y25laXJhYnVzdG9zQGdtYWlsLmNvbT4NCg0K
QWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo=
