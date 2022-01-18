Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EC5492B80
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 17:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346337AbiARQs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 11:48:58 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:54444 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346274AbiARQsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 11:48:51 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IF4UWg013801;
        Tue, 18 Jan 2022 16:48:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=IeYhmEYR8hhOMmuSaG3LS4VRjMUVwjADjlI1Rrielw8=;
 b=GNPcaVJJTWsdqkynTktF93HR47sR3VOuTrxYfVzVotaZwaxFq/fiflL7Kej7nMyNwTAQ
 zVFBJaoJdz0viiiM8sMjZmc0rgCBXz/WGSuSRgW3k6ptoro+oGh9Z6f9kZRGZ7ljSpOa
 LWJ/CWO7MWawPeSXNPHkWNv3qTKCHxTK+QM4/oitXHFi+cOEBG9NyHGg5Mz3l2ltBBln
 +MnMU5kqtBDXm/dvbupTfQC+KIbyhhbzp5m+9nRZo/aUPVYNXqbpH5jIebDW+UQNw3Dj
 IH6DOj5iRk+R4a0R+8JszPWe9ji9DNDuboA12ZUoiKB/YdJWFaTp+YbU1X63i4PJlaY1 9g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc52tf5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 16:48:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20IGUdjO048998;
        Tue, 18 Jan 2022 16:48:47 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by aserp3020.oracle.com with ESMTP id 3dkp34f3vf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 16:48:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ebdt2AV9EvPO/9ITt1Z6GyXakO8EMQtR/hdKAK8TMIyBDQjO7OzvhxDMRK3XxvbMoL29xGTC2IWY2tHLxgJ79m1t0qA/sYa6aQNRYqb3lflxezYfXKqXvI9pTOvlNJFEF0HBRp1jTn9If66Kt1keK1tOy3EmE5zAdcgPflHmFH06DN3/Hata1zhsF/lpzxBn5NJFv14uiNETMxPacpE7ENKHGL3j3nonekbu6bW16qbd49NSR+zdaNHngrCluwCwQAgPbe4mZkCkgOffyJl177vENNEBfwEAw5DQgc7qjENT+pQg6sehaTXyFlWLZclZCteFqEnKul/bDKvA+cklCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IeYhmEYR8hhOMmuSaG3LS4VRjMUVwjADjlI1Rrielw8=;
 b=RxQLCGPpmGmIE071gzG7tlYDjODEG85U5qX+yY2QL0L81+csFWWkHgYO4r0Yik3WAHAve9rydmbErrBhOtsWautACZuK6IU4of1/vsEfYhYKRTelwoPsEBq3HklLF+bhRroAGYbYOQ2h76IA7mTlMlpgq0QlHM9ftto0+gEmN4jXjqgj4a/NeisivRG7P1INbeV3gauRrJUe+CCbHfBMDu4RR0KYCtyo2Ob6kGilsb8O2vV61FKTOjDSXUcXeKXdPSTSvyWoW0jJ4Kp+bN+G15iYBoraT++Xow2EGCFrlQIQ4zQV7bGtj17dj3bsDw4a0+BAr7bOj6aI6Y6iyVd9Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IeYhmEYR8hhOMmuSaG3LS4VRjMUVwjADjlI1Rrielw8=;
 b=L6m7QM0zaQnDB/kdnZWtm2ww6WkoGx3b6Q5wscsn+XiKuw5s+CXj3dJmOIelI5e5JChsUiRCv+51TgxH8dMx7+AM7GtOzOuRGtuz7Z4mLABHQQpiXVaZ+SHNj/SVreNMxaziyy3qy2Bp+1q0ioYeGqg1hgO/Zc3anL56Jk4DnQo=
Received: from BYAPR10MB3270.namprd10.prod.outlook.com (2603:10b6:a03:159::25)
 by SJ0PR10MB5833.namprd10.prod.outlook.com (2603:10b6:a03:3ed::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Tue, 18 Jan
 2022 16:48:43 +0000
Received: from BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::a990:7ead:6a5f:7577]) by BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::a990:7ead:6a5f:7577%4]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 16:48:43 +0000
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     Praveen Kannoju <praveen.kannoju@oracle.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>
Subject: Re: [PATCH RFC] rds: ib: Reduce the contention caused by the
 asynchronous workers to flush the mr pool
Thread-Topic: [PATCH RFC] rds: ib: Reduce the contention caused by the
 asynchronous workers to flush the mr pool
Thread-Index: AQHYDHpMvPL3laPFJ0aPHHi6FMrX76xo/YqA
Date:   Tue, 18 Jan 2022 16:48:43 +0000
Message-ID: <53D98F26-FC52-4F3E-9700-ED0312756785@oracle.com>
References: <1642517238-9912-1-git-send-email-praveen.kannoju@oracle.com>
In-Reply-To: <1642517238-9912-1-git-send-email-praveen.kannoju@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b81487a7-28af-49c7-7c25-08d9daa2634a
x-ms-traffictypediagnostic: SJ0PR10MB5833:EE_
x-microsoft-antispam-prvs: <SJ0PR10MB583331E872925899632B7A8D93589@SJ0PR10MB5833.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:612;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9xPfg/xTG2ReowUGUGOgJmfcxb36RVJvnluU5kN/oiYuzY49oTQy9EJ7zl1gkaIdOM3dVf9vg9KnrtHOup7vWo73mixHJNVyqXbPOcz9Ektc9BzRv3Xc7PPxBIhsPWQ/9w0NJ2iOLgunMmuhF2OW09uSZnL2A4ghEoL4tVVSSTpbD9o1Y1UXQO/yiPzylmdhskjkOhiuqN2PPZ2w+1xtGbmcfLbxuQoS++xVK8HqBMe12n36JR4Zcm+4Y16pRX78uUkpww7NnrWOp6QDVqLWGE6ZhmFB7j5nf/LjT2PF4W+F5OYDpe8mtTRxA6YH/XIs+R8bJFxBt51axWjMNlQ5rmG0cg1cL/cZ/+GfaobVzcSfjfphw757IhdGfkqtEib7bf5oPS4HZzMVQY6tMXENyeqovfI61TUp/qO/pQU/E50JrmWTuQfzCNE0ZlksP0ke/zZ4SRzGrbZoxngtqIEmccKDy7YuU7RwjZh+alSHXAf20u8lXwyOZYHQA6/o8cfsLcWyyZmaVa6eV+28UdwGWsJxOOyJPF0B/G33jIG/LuVdm9EBrGXHp/BL5LVTWlziIhuJK10U2o+ExyvVeweFJk5V8ZG4gQB4gzwavqUhRvMI8bsELx8v4G+aoolT961DsuHCJn0D2juVEXUWjddrVa61bf3uGxGP+6k73YaDdAzzO72M4tG5tyEV0Up/b1xI2EETHW3oLiF09pcQjA3yrUlSPMlLLI3bwfjJTU+zjZvenVEUWD/2zDkNdJT1bhyZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3270.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(38070700005)(36756003)(508600001)(186003)(83380400001)(33656002)(8936002)(8676002)(6636002)(5660300002)(86362001)(6506007)(4326008)(38100700002)(122000001)(54906003)(44832011)(37006003)(316002)(71200400001)(66476007)(66946007)(64756008)(66556008)(76116006)(6862004)(2906002)(26005)(107886003)(2616005)(66446008)(91956017)(6512007)(6486002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHQ1amd3RENtWHQ3a0d6bkNFeDZpRCtGMm9MeGVNMHBPU2xRSlZ6bnE1aGha?=
 =?utf-8?B?NVdMclV0eWtiZDIzeHV4WkNGUXFqVjVSc09jV1VCMGd4QjJaMS9xUUViOE5n?=
 =?utf-8?B?M1d4UEZhbzVoWmg2Yjc1eUdUN3JkbDluYlc3TmFMMTVkSjJ4SWhXdk1qNTgx?=
 =?utf-8?B?SjNjZzQwNU9RUVBmSEJ4S2lpcW5vS1RuNnpUWEduNStleWRJWWxKUjNNbkxk?=
 =?utf-8?B?RE5uci9xb2JMUHM2blpFbkozVksrcDJQN2JGMFBlRkkrVGFMU29TaEp4T2Zi?=
 =?utf-8?B?SExmWksxb0ZxU2pFTGFxQ2lCMjNRWnk0UWJhaER5NnVWUENkSmJpSExsREhC?=
 =?utf-8?B?Ym9KKy9RbmZxRDYybTdOeHNOMnkwWitQS1hoN3UxN3NGSUJmM282dmcrR1FF?=
 =?utf-8?B?R01seVA1VEJzQ1RlZzE2YTNhSWppYVBuRGpkNHNhMHhJN3FSYVdRazZLR2F1?=
 =?utf-8?B?LytQRVZxTmQ3ZTFUR3VNRVg1RHh5ZnZHa1lPWVNWZkF1YnFJbmFLQ2hvYXQ2?=
 =?utf-8?B?S3dyQUZqMEUwSlRzVFEvVk1Ha1ZVTFplSnhYUWdNNjBMQmRmR3JqOC9qMXF2?=
 =?utf-8?B?eHNMVnRLZGNJUVM4Y3VGL0Fud3BLRit6SWV5VU5rbEhPK2hrS0tTd0pobFFo?=
 =?utf-8?B?akl0dzZXUmRxTG9rM1VaN2dUSS8vS2U3R1BUdkt5Qld5MUZiNEZzcnZMSTFN?=
 =?utf-8?B?QmJuTDduSlhOT3RROWRUaHFzTzZoZmFXei96Rm52anhucjdtZDFtb2hoVlVw?=
 =?utf-8?B?SWQ2WnVEdVVqNGY4TDRnSCt5UjVQUzVibS9VSEJBcEtZc2FWL0doUE80Z3Zk?=
 =?utf-8?B?RHNWQ3VzNjlRSnN3bGUwQjNwM2x5SlJST2N1WndjMVB6TGNxSnpTLyttRVlv?=
 =?utf-8?B?LzdiY1EvZ3pNMkppc0FJalVKUXN6clQ4bWdqMlBhUnQ3VVlGWUFucUdKRFRh?=
 =?utf-8?B?T2xndENzNFNjMGY5MmdPUW93L1RXWHlCRzZQaTlqMmdraWlpK2duU09iVHBT?=
 =?utf-8?B?K0lpQTlaenExVUZhMDFaTlhGYnduaGdpOEJWQ3pRM2VSUy94dkFKQi9tQkNm?=
 =?utf-8?B?bVUxR1QrdkNQUXV0bUxzczk1bmtzWk5pU3VHR29QbnRpOEZsS3hLbFhCVndO?=
 =?utf-8?B?clhYLzB6WEdtK2dzUTdPMVFRT2VPL05OV1o3TTlYb2ZnVS8ySC9XMGhLdG1L?=
 =?utf-8?B?cGdKdjk0OHhsZVhwNDFudllrZnErSVp4VHBzWWdKMlJFSFdXMExnTHhCRFFu?=
 =?utf-8?B?RmZnaHVnMktQZk5PSDZkbEUyenJKWHBPM1ZRN2VwWUVCS29GWlZSUXRsbmJL?=
 =?utf-8?B?OUtYOG5qV3NnWTRyQmZNbjh2UUlLTjdldkljN3dxS29oS0Y3VkF5MTJvS2pp?=
 =?utf-8?B?SDVKaWF1Mzl1QUFWVDJMbjJVN1ZnOHVyMWJMRlhKazI4VDJqa3JGUVJuaGNR?=
 =?utf-8?B?aDNpSENjbFFhQmZaa2ZhMXA5azYwWm5xZnBiYWlxdlRiSzF5NmUvR2d6N2NU?=
 =?utf-8?B?dFpWYUprLys3aENOUUNpcDE4R3o5NWUzSTdETGJsM28wazV2TVUrZWE1SnEw?=
 =?utf-8?B?Y0t5cDZEOFU4R0cybThpc1Q2bE5PcFZRVHg3N3RIbWh4c2lmNWlnVE5LbjJB?=
 =?utf-8?B?YTNLZUF6SEgrNDdmQ3hTYjQxZmpkcGpvMDNpYit3a3AyQkRJSUdOalRIOFZ0?=
 =?utf-8?B?YXRXb2RoV29vWmVNVHB0ZElNOGRXL2hIdVVkQUF4TDZNZU1mbk82eFhwajFp?=
 =?utf-8?B?cFFOb2V5TG04SndaS0ZPVWovUE9JczhIYUVsVjlpbFBXTFNmTDBkQ1ZsNEo2?=
 =?utf-8?B?cXRDZEtyUEdoWVJzMGsyemtVNDNJNTZUNC9tM1ZyK3VJWGhnTDFQV1c1allq?=
 =?utf-8?B?WHZSczQxRUI1MXlaTXd5Y3ZpaDQrcmFRTW5SbENLMkRuZE01cTFLTHpwUGtQ?=
 =?utf-8?B?dTI4V2lSSDBpRmdocFpNS2h0RStJWlE2R3hpZ0VFUjA3N1pPMDFCU2xmcGtY?=
 =?utf-8?B?K1RtMFNJY0pTY2pIZzd6a3kwNnh4bStSYzM1cExUYldtM3MwWEdsWkQyY1FZ?=
 =?utf-8?B?djFYRS83MXpNaU81cmE2SDN5bGZTYlVvNEYvaDJ0ZVZIZlkyZng3akFNa2Ru?=
 =?utf-8?B?MnJzU2d4a2tRMVNZQ3ozTy9XWlVDWUtIUy9qQmErQVNObk51VDkrNnBPRlpV?=
 =?utf-8?B?cXNDQXN5YkN6MkV6bUpLbWQvWVZvMGoxenlERHZWQjJKcVVOb2dJWnNuZ2VV?=
 =?utf-8?Q?ZvNfW/fHwV/LBV/GBl6kWeSmztOkUnu66agowH94v0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0CDF9781753DAA48ADE001A6955E97D4@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3270.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b81487a7-28af-49c7-7c25-08d9daa2634a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2022 16:48:43.3456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a+doD1sfTqJpEr7R6au0kw2CepOXGhuvLt9ppLW8XOUhq+dFegEVUarSETJ1cBJbXAH5cL84nksbhYMo/NgKNRE8V6brn6ZNQy/T7ocNvdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5833
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10230 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180101
X-Proofpoint-GUID: LEharZz1umv5uNEprK-pxUkNfo4txKqS
X-Proofpoint-ORIG-GUID: LEharZz1umv5uNEprK-pxUkNfo4txKqS
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IE9uIEphbiAxOCwgMjAyMiwgYXQgNjo0NyBBTSwgUHJhdmVlbiBLYW5ub2p1IDxwcmF2ZWVu
Lmthbm5vanVAb3JhY2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBUaGlzIHBhdGNoIGFpbXMgdG8gcmVk
dWNlIHRoZSBudW1iZXIgb2YgYXN5bmNocm9ub3VzIHdvcmtlcnMgYmVpbmcgc3Bhd25lZA0KPiB0
byBleGVjdXRlIHRoZSBmdW5jdGlvbiAicmRzX2liX2ZsdXNoX21yX3Bvb2wiIGR1cmluZyB0aGUg
aGlnaCBJL08NCj4gc2l0dWF0aW9ucy4gU3luY2hyb25vdXMgY2FsbCBwYXRoJ3MgdG8gdGhpcyBm
dW5jdGlvbiAicmRzX2liX2ZsdXNoX21yX3Bvb2wiDQo+IHdpbGwgYmUgZXhlY3V0ZWQgd2l0aG91
dCBiZWluZyBkaXN0dXJiZWQuIEJ5IHJlZHVjaW5nIHRoZSBudW1iZXIgb2YNCj4gcHJvY2Vzc2Vz
IGNvbnRlbmRpbmcgdG8gZmx1c2ggdGhlIG1yIHBvb2wsIHRoZSB0b3RhbCBudW1iZXIgb2YgRCBz
dGF0ZQ0KPiBwcm9jZXNzZXMgd2FpdGluZyB0byBhY3F1aXJlIHRoZSBtdXRleCBsb2NrIHdpbGwg
YmUgZ3JlYXRseSByZWR1Y2VkLCB3aGljaA0KPiBvdGhlcndpc2Ugd2VyZSBjYXVzaW5nIERCIGlu
c3RhbmNlIGNyYXNoIGFzIHRoZSBjb3JyZXNwb25kaW5nIHByb2Nlc3Nlcw0KPiB3ZXJlIG5vdCBw
cm9ncmVzc2luZyB3aGlsZSB3YWl0aW5nIHRvIGFjcXVpcmUgdGhlIG11dGV4IGxvY2suDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBQcmF2ZWVuIEt1bWFyIEthbm5vanUgPHByYXZlZW4ua2Fubm9qdUBv
cmFjbGUuY29tPg0KPiDigJQNCj4gDQpb4oCmXQ0KDQo+IGRpZmYgLS1naXQgYS9uZXQvcmRzL2li
X3JkbWEuYyBiL25ldC9yZHMvaWJfcmRtYS5jDQo+IGluZGV4IDhmMDcwZWUuLjZiNjQwYjUgMTAw
NjQ0DQo+IC0tLSBhL25ldC9yZHMvaWJfcmRtYS5jDQo+ICsrKyBiL25ldC9yZHMvaWJfcmRtYS5j
DQo+IEBAIC0zOTMsNiArMzkzLDggQEAgaW50IHJkc19pYl9mbHVzaF9tcl9wb29sKHN0cnVjdCBy
ZHNfaWJfbXJfcG9vbCAqcG9vbCwNCj4gCSAqLw0KPiAJZGlydHlfdG9fY2xlYW4gPSBsbGlzdF9h
cHBlbmRfdG9fbGlzdCgmcG9vbC0+ZHJvcF9saXN0LCAmdW5tYXBfbGlzdCk7DQo+IAlkaXJ0eV90
b19jbGVhbiArPSBsbGlzdF9hcHBlbmRfdG9fbGlzdCgmcG9vbC0+ZnJlZV9saXN0LCAmdW5tYXBf
bGlzdCk7DQo+ICsJV1JJVEVfT05DRShwb29sLT5mbHVzaF9vbmdvaW5nLCB0cnVlKTsNCj4gKwlz
bXBfd21iKCk7DQo+IAlpZiAoZnJlZV9hbGwpIHsNCj4gCQl1bnNpZ25lZCBsb25nIGZsYWdzOw0K
PiANCj4gQEAgLTQzMCw2ICs0MzIsOCBAQCBpbnQgcmRzX2liX2ZsdXNoX21yX3Bvb2woc3RydWN0
IHJkc19pYl9tcl9wb29sICpwb29sLA0KPiAJYXRvbWljX3N1YihuZnJlZWQsICZwb29sLT5pdGVt
X2NvdW50KTsNCj4gDQo+IG91dDoNCj4gKwlXUklURV9PTkNFKHBvb2wtPmZsdXNoX29uZ29pbmcs
IGZhbHNlKTsNCj4gKwlzbXBfd21iKCk7DQo+IAltdXRleF91bmxvY2soJnBvb2wtPmZsdXNoX2xv
Y2spOw0KPiAJaWYgKHdhaXRxdWV1ZV9hY3RpdmUoJnBvb2wtPmZsdXNoX3dhaXQpKQ0KPiAJCXdh
a2VfdXAoJnBvb2wtPmZsdXNoX3dhaXQpOw0KPiBAQCAtNTA3LDggKzUxMSwxNyBAQCB2b2lkIHJk
c19pYl9mcmVlX21yKHZvaWQgKnRyYW5zX3ByaXZhdGUsIGludCBpbnZhbGlkYXRlKQ0KPiANCj4g
CS8qIElmIHdlJ3ZlIHBpbm5lZCB0b28gbWFueSBwYWdlcywgcmVxdWVzdCBhIGZsdXNoICovDQo+
IAlpZiAoYXRvbWljX3JlYWQoJnBvb2wtPmZyZWVfcGlubmVkKSA+PSBwb29sLT5tYXhfZnJlZV9w
aW5uZWQgfHwNCj4gLQkgICAgYXRvbWljX3JlYWQoJnBvb2wtPmRpcnR5X2NvdW50KSA+PSBwb29s
LT5tYXhfaXRlbXMgLyA1KQ0KPiAtCQlxdWV1ZV9kZWxheWVkX3dvcmsocmRzX2liX21yX3dxLCAm
cG9vbC0+Zmx1c2hfd29ya2VyLCAxMCk7DQo+ICsJICAgIGF0b21pY19yZWFkKCZwb29sLT5kaXJ0
eV9jb3VudCkgPj0gcG9vbC0+bWF4X2l0ZW1zIC8gNSkgew0KPiArCQlzbXBfcm1iKCk7DQpZb3Ug
d29u4oCZdCBuZWVkIHRoZXNlIGV4cGxpY2l0IGJhcnJpZXJzIHNpbmNlIGFib3ZlIGF0b21pYyBh
bmQgd3JpdGUgb25jZSBhbHJlYWR5DQppc3N1ZSB0aGVtLg0KDQpPdGhlciB0aGFuIHRoYXQsIGl0
IHNlZW1zIGEgZ29vZCBpZGVhIHRvIG1lLiBXaXRoIHRoYXQgZml4ZWQsIGZlZWwgZnJlZSB0byBh
ZGQgbXkNCmFjayBhbmQgcmVwb3N0Lg0KDQpSZWdhcmRzLA0KU2FudG9zaA==
