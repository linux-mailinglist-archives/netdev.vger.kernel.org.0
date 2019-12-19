Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465F4126919
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 19:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfLSScC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 13:32:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22034 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726797AbfLSScB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 13:32:01 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJIOR5q011719;
        Thu, 19 Dec 2019 10:31:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kbPEZRkNVd2u/BEMFPOT62Hg6ewgM3PyyCnt5wEjaGk=;
 b=SfKlT2LBdzAQTeBIE76TiWay9kqB0GE7bROu1WmekolDNDddtsIEEXfJcI3d8MTZl9NF
 CQ8XjmZTSgNNcxb4HyKcpbwLHFYzyZM5BlZKPp/cHnK/3tDBRrSP9WMf08NPfCC51U5j
 PVfrkcYfHhxiuxw+gdV1BH+SV4PgMXs/iPo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wyqmcp9s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Dec 2019 10:31:59 -0800
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 19 Dec 2019 10:31:58 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 19 Dec 2019 10:31:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itcKSQCHongnYG8UkVqDiXCU+nXTYZdTtW6mSMWtP01UAocdFu3g4OFM5XILLGZgPzihmiupJ8e7Ua2OyyQMCEE2bMsHRiKTTCFGL5ixmR5oWmVlFHkgApGulLRC9jwS1l7wLtGgB1nCiUElNZB1K0XJikTDNyp1TwU0nYbrd4cgpZmcCKoH68SjKfvLOdaUme7rSAVNuvhlrjmig/R0wFbS/WEevxC/VwBLVUMq2h5QRcxA8H9wtv095+JtVDPfHxkw4SHNm6kJ5BQtTR1nRC9PDe4l0iZk97wo6gIzU+gxM4kJOMVuCz+KFvb0k0sNg9z8AUAVOgZ01NU0G2E5JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbPEZRkNVd2u/BEMFPOT62Hg6ewgM3PyyCnt5wEjaGk=;
 b=MkUmQ9TL/YE5t7BU5XFL/0u/4oDlBU2aHfuZgl54AzL8gu3YmS6B5Zk82Dne9BysS8xzo8jaHtVJL1QZtB9vR2/xH0mWUPr5/dQqIhEEis4bUntRvYnyt6GNKzLIrPNdRTGhR5H4UnZYXkxtV3AioleFWAdo5VpfBjuHXpmKUzJEzW307PdCRCUAlcNDN2DDPFEo1xG3vvpBYKxhfL3oPhW2lZMzsn+bwdk0cfYgxlUR3hWzD8z9yKrUhGZpKL6ta//EAEQNcgnmHnhk9k6TQCDl1U+9JqjEmA8wXWp0wcIazIuaVy0QwDDBznJQ/dEeCUSFTNxjUakRBTsE64XdcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbPEZRkNVd2u/BEMFPOT62Hg6ewgM3PyyCnt5wEjaGk=;
 b=VstXdLgXpP3YFYQFKpc4AgSMvJKP7c+kZpqZK+lQX5mAsu/WMwQQ39z39nVSH6MVyJnddqGfdtNMBfiJg618SQPVM6App23tjdYCAtXmZK0T8zvgevEyCKNi9pl1qs94LLfhCXQ8k8zQOrnSs26OwkOSNBXGI5hsYdxVHdfSQJs=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1354.namprd15.prod.outlook.com (10.173.220.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Thu, 19 Dec 2019 18:31:57 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Thu, 19 Dec 2019
 18:31:57 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v16 3/5] tools: Added bpf_get_ns_current_pid_tgid helper
Thread-Topic: [PATCH v16 3/5] tools: Added bpf_get_ns_current_pid_tgid helper
Thread-Index: AQHVtcoFayAJqQOPykuoZQTZSGWDXafByZgA
Date:   Thu, 19 Dec 2019 18:31:57 +0000
Message-ID: <6e51b1b6-29f3-27da-7a75-27bf25e9510f@fb.com>
References: <20191218173827.20584-1-cneirabustos@gmail.com>
 <20191218173827.20584-4-cneirabustos@gmail.com>
In-Reply-To: <20191218173827.20584-4-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0017.namprd22.prod.outlook.com
 (2603:10b6:300:ef::27) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:442e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe7bfaad-4748-4ba8-5b7f-08d784b1ba85
x-ms-traffictypediagnostic: DM5PR15MB1354:
x-microsoft-antispam-prvs: <DM5PR15MB1354FB567F5A67EE5EB24A76D3520@DM5PR15MB1354.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:220;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(346002)(136003)(39860400002)(366004)(189003)(199004)(53546011)(36756003)(316002)(54906003)(4326008)(5660300002)(110136005)(8936002)(86362001)(64756008)(558084003)(478600001)(31696002)(66556008)(66476007)(52116002)(71200400001)(6512007)(81166006)(186003)(81156014)(6506007)(66446008)(6486002)(2616005)(66946007)(2906002)(31686004)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1354;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lBLefycE6+BK8rd7VIo9OojEzQ08dIcRB2t3vxVkDCOZrvYwW0M1e3bUUgjgZp/lCr9eZRoci9+Xr9o0eciNHFL/B/rtdc9HwNDnHydgwRscNS6ShvWrhMRp8ZnTnH42LvmhglZYsgg+iQd6vJlJ1frzFOjRQegBiMXVldkiEgNuDgrRMcuBjMSADT57i9mpPocn1h8C5YUZnW6fsZqLPnh7es6ZzigNiGHtShVGb+sSgnmnWyZ0n7B7zoy43bCB/F8gxxjh9rngThL3DCtjJSG7XH3wjJfEvE0VYBnq5CYzJ+wtRgUDaftQR2C/DKVhkhOsOZ7r1PUeKSvi3FLJ2Z+vINQtKrVg+rdbxVCT+J4K2wetxL6D2Cx7V6yVOYsenGLuCvkr6Rf1k/S4e3kuQ3d9qBYeMcQHOxKqxGU8UNtV8HYA47zucamfY4hhNKWW
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <06A906D14DFBD54294ABEFAA1109155F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fe7bfaad-4748-4ba8-5b7f-08d784b1ba85
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 18:31:57.1473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T4e8aYJroiq3h1b6uiUWy3mLw0hQRRWyvXfpiSuYDzUCzXqrE8FdLUNb8BgGeWW6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1354
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_06:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=562 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190135
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE4LzE5IDk6MzggQU0sIENhcmxvcyBOZWlyYSB3cm90ZToNCj4gc3luYyB0b29s
cy9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggdG8gaW5jbHVkZSBuZXcgaGVscGVyLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQ2FybG9zIE5laXJhIDxjbmVpcmFidXN0b3NAZ21haWwuY29tPg0KDQpB
Y2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCg==
