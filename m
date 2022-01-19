Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A2F4939D8
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 12:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbiASLqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 06:46:32 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52886 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233640AbiASLqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 06:46:31 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20J9WVhs012828;
        Wed, 19 Jan 2022 11:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=bXhn5w8hY3qm+vCoJr1fwvM0ewN9f/p90PNBsuefzL0=;
 b=q93wJ9aGpKsC6YzfCpzi9eMeD9Ems1ytXK/I0ikKLRwqSuKaYH20wvaZiRVEtlCajy0S
 +Fv7JStHxaMVHHjy3606cfGcaJJh3MX07MzXXzRWZwtexvtfECfb4Vp0Yr9kjwo2HJaF
 hdGWFzzYJghMx3udyKF+BceugsmxF5+xlveH91oSFkXASvKtEmjcTEoZjij6UuTCMq4d
 qH+SwayJmj2pKrDGSsSFi4IKSAgcWF9ZvnTQ/yT2lsdUJRfNf4KggJfoSJJPAmR8Epjp
 tNVHhSc96QUDcYEQQZAKMjlK0EpVVI3y5JNrvCkH3YbMLfv/+oOphVtnd+MO+cYZve7Y 9Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc4q4xcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 11:46:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20JBkPhF189035;
        Wed, 19 Jan 2022 11:46:25 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by aserp3020.oracle.com with ESMTP id 3dkp35rn8d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 11:46:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPydv/g5SI3c7XUI7OTv3DruezeMWOS/Lgl8N+CeNWKMBi0QEVdBI6JgSEvoLJ+LcTJ9qAFM9fwwiuPzehBIxIlUKzqcEJf7CCydH6VOg51d8dJa7gizgu3MoMleL6dN1Eae1nOWb5c89Phe4SlNmxpnzRg6BxQCTCwyM7Ve2UsIfLM87wCzul9vASCMxAB76PdJgQFiZHoq7KFeMabmuhdNRx5W5YRSBdCDZZBiR61374x8OfY+9lGc4fa44zvWQXwIqW21Z85iwwyyEL/qFFl4LLQIU4voRAmV5SIwsQvypUmrNrXBAVngrmkZ+m2sRLmp2MLENDgM3eFB27cHTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bXhn5w8hY3qm+vCoJr1fwvM0ewN9f/p90PNBsuefzL0=;
 b=YhQcJay2A13wROAZQ+g3raMhMk/rY6mz1V4s2dOYd7EWQw3S5IvjezQD7IVa3tWf0xwLE5HtXCZohFNEFi+VJR8W7eGCoySREJXjTjU9Botg9SFr7vM6IIDQ0YJ5U8QLbH1MWsYhMuVCtECY84J3lkFFiz7kk6gOkK0/muPnVdMQxWoGjIPAfWkb/+Yk6PCCSwAeiZMe5Ix8AgXTJF3iDADMM65CXv8V9lXhnBTENgLFIHHXHKZ7uYNBGoNZzSaE+os5fMQAxW6dmLJSk1KEfG3SIzr7HKz4bjX5Yu16SZkml/mOT/JHQa2HG1xqOc/Q+KqCMIg4JgJQZoDBnyQ1Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXhn5w8hY3qm+vCoJr1fwvM0ewN9f/p90PNBsuefzL0=;
 b=vM8cIqWYJ6VIrKPHX/K6eF0y1KlNmsOXNS3MGScOxqHyLnrfCQc/eRB6sO4RVBf9z7JJYw5lyAzLY4JUeNQiV485Zd9x0sxBvfpU0yLI59KON8GBz/Sv3A7x/4qXoVPZ+T9H28ib+iqcPo0hCAse2/U+jILRYHIMTehqYRVAmQA=
Received: from PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7)
 by BN8PR10MB3330.namprd10.prod.outlook.com (2603:10b6:408:c1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Wed, 19 Jan
 2022 11:46:17 +0000
Received: from PH0PR10MB5515.namprd10.prod.outlook.com
 ([fe80::edcf:c580:da6f:4a5]) by PH0PR10MB5515.namprd10.prod.outlook.com
 ([fe80::edcf:c580:da6f:4a5%6]) with mapi id 15.20.4909.008; Wed, 19 Jan 2022
 11:46:17 +0000
From:   Praveen Kannoju <praveen.kannoju@oracle.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
        "David S . Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>
Subject: RE: [PATCH RFC] rds: ib: Reduce the contention caused by the
 asynchronous workers to flush the mr pool
Thread-Topic: [PATCH RFC] rds: ib: Reduce the contention caused by the
 asynchronous workers to flush the mr pool
Thread-Index: AQHYDHpMX8JHvK1k8kSJh1x30qsksqxo/YyAgAAprgCAAAb9AIAAvOYAgABQL4A=
Date:   Wed, 19 Jan 2022 11:46:16 +0000
Message-ID: <PH0PR10MB5515E99CA5DF423BDEBB038E8C599@PH0PR10MB5515.namprd10.prod.outlook.com>
References: <1642517238-9912-1-git-send-email-praveen.kannoju@oracle.com>
 <53D98F26-FC52-4F3E-9700-ED0312756785@oracle.com>
 <20220118191754.GG8034@ziepe.ca>
 <CEFD48B4-3360-4040-B41A-49B8046D28E8@oracle.com> <Yee2tMJBd4kC8axv@unreal>
In-Reply-To: <Yee2tMJBd4kC8axv@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5598ab7c-b73a-4dfe-2d4c-08d9db414d9f
x-ms-traffictypediagnostic: BN8PR10MB3330:EE_
x-microsoft-antispam-prvs: <BN8PR10MB3330E20ACF0640249F5F53258C599@BN8PR10MB3330.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fL7hAYJ/rx43PztacJ2PSGZsnllJurr9th35fHelZ2Eo36IFW2FIwcHb79uBp5nU73JjhIzFHZxm6v33tmuhPkZWTbxvp8xu2BN1WCjIrHZQ15/wlGArDIia2oiTGo6hmZzB4ZYKYh5NLNxj8NydyLO7eb4K5pOwQ/FSC9JwOaRvvuxRGF5kgq6+Q81cXb/GVrNTOVoPyiZfFk47j5aEPGcZkhXEcEx3NJHfLAe/KxqK3cN/eMo4I97/Cnmsp5bm+qprwQgN+Cauu7P4h1eWP2PzzL/zaM40ZhonO67ha0JO/6pCPs7cyGfR+OJMX4yuMvnH9GOdlGm/QoUB3uwUY4pWBRE3218JAUEIbX7JBw6Aq5+1q1P7Wu8Sy/f2JQljZoKe+JRlwQDG2jcQxJnBGji9wvmy9mrRvPZEjyGGekB/fgf4XWqUi1zq5w69YPZ7sL9Znz4+1c+KUa97Pbod7mugMzGeU1ZI5j1Zg4rA+a5aSppY4RFsLXEZq3d0ge/Z1/BkNx9Iwva0mFFPNnc7z+WE4k7xCGLPf93REiaUbrSO+IYz9jkILtw/H4tpITaGQKPsSpzGEYtorBlIteDdVNRPthCd9ts9pRysktfyJoARcEy+bpohYU/+/W9qtlndPD+OjXKTb6shoH494se2M1fDYtHCEpH6FvvQuEm99b0v2s+c/jvpCiWcsjpmMBQbZ5w4p2AQYrKbXbHgS6KHiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5515.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(5660300002)(6636002)(86362001)(9686003)(44832011)(33656002)(107886003)(508600001)(55016003)(4326008)(83380400001)(66556008)(66446008)(66476007)(71200400001)(110136005)(54906003)(64756008)(316002)(7696005)(38070700005)(38100700002)(66946007)(2906002)(6506007)(26005)(8676002)(8936002)(186003)(122000001)(53546011)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlB0cmQwdis2dWVleUJVdGJLeDVKNWdGNzc3UFR3MnZPSERqa0VHNDg0KytD?=
 =?utf-8?B?emxvNmptUEVjVHdWZXVVc2FXa3ZIc05KT2ZNclFwUmVtVzcwWjhvdnd4Yk5H?=
 =?utf-8?B?SHhVbzdTMnNSUDFIc004ak5TMnFSUGxDb05UcXN1UFZ5d0NyMFIxMEN1bnhU?=
 =?utf-8?B?a1lXcUtaS1VLT3BtVFNCeXhvcU05d3pHVCtyVGJkRldMenZIUHR2U0kyVWZa?=
 =?utf-8?B?T01QRk9tZTRTdTF6a3BSV2YxRFhvS00raDNhMzByNTlTUWNXeHBsWE9wUVVp?=
 =?utf-8?B?bTl3dXpaekN6T1pmb1U4NkJEKzQ4TGkvRElVall4eXg2RmJrc2d6TVVsdmZC?=
 =?utf-8?B?OTNOTFk5dEFhREFrRWxxaThPYSt3SnBYQkJIZ1JUTVVmUU5naExjTHFvQjJy?=
 =?utf-8?B?OUkwcXZqUjVxMTgzc0NGWStRREMxeDVDdVBnck51R2NKaHJaSGcwUGI5UDRG?=
 =?utf-8?B?L3JBL0lnTmV3QnRyTmROR1JwSXZVVzhmbnVCNGc0NWE2ZUhvTGlLRXVnRXhX?=
 =?utf-8?B?eTV0RVdCS29pUzA5RU5MeWU4V0xCMkZzcldvaVgyMDI5NTVCbjZldTJVTnZW?=
 =?utf-8?B?azdLazhKOGlyNnowVVphVWNPbERxSmhxMUE1VW1oZ2RpQ29JUXhuNS9EZnNI?=
 =?utf-8?B?MndoRmcyT1lGYVhFUHNoZkV1Ym85Q1JoOTIwVlN6TFdVM1BnZytSWjl3QnVR?=
 =?utf-8?B?WEpFSzF1RmwzN1hEcytTUUtWS0prY3lQUzY1OVpKaVl5Z3hhYnlZUmNKMkVI?=
 =?utf-8?B?cXZmVml4M09WQSt6YmJaeW93TUJOWkwwUktJeThSQXV1bVArQjR0b1FwUXFJ?=
 =?utf-8?B?ODB4QTFFeStnaDl4R2JMK29aYUUzZXRHbXJycG5FcTVsQ3dwb2Z6REl6a1BU?=
 =?utf-8?B?cDhNblNzK3dLM1o1Mm1LRSt1aEllQ3BiSVhQdVUvbXVRK1loNjBuaFQ2bmpk?=
 =?utf-8?B?SVdITkJHNEtjM3JMQndKZ0VsWTNmQVRMdDZ1UUFKcmxTdkhyK1Qxb0MvUC9K?=
 =?utf-8?B?WW9PTnAyY25TUTl3d0tCY1M2VU0rU0dkcWtJaFlFQXYraWl4dThPTzZsTVht?=
 =?utf-8?B?b2g1MzJFYStPWXBMU0dHRHA1aXNVUzZuRnpWNnV0SVpMMzJmeThNZmkrZS9v?=
 =?utf-8?B?QWdmWUlRbFBIZEwwSitjaVRLTWpaU3ZFMW9LL1NtY2pIUHA4YVUrOW9oWVR2?=
 =?utf-8?B?TmZOODJDemdhVXh0L0piSEtzVCtLNTlqN055SG4rRVI1YzNGaTBEY0srRXFG?=
 =?utf-8?B?bk5oZVBleWhXRFdyL1lWUW9WbVFVcTZQOWFJbGVaK0prZjdsWnUrcGp5a1lQ?=
 =?utf-8?B?cXhheU5OOWZXd3VaTytKRERPWWdSaTZPR1RsTFBJMTYraUlwV0o2eDUzc0pk?=
 =?utf-8?B?VjNlSkh0ejYybGxxQUx5a2tvNng1cnFxNVRQT1pCaGorV2JVVDMxcm1wb29N?=
 =?utf-8?B?VXArMGhsLytmMmRnZjhkNHhmcGtOUE1WQzU5aHgxNHV1TmVpYzZTL1J0T1RC?=
 =?utf-8?B?dVZ6d0FTYS9NekZSYUcxdjltM3V6ZStPQ2h4dFpXeCt2WmJjK3doQ0pPTWY0?=
 =?utf-8?B?bHRtMURFYUxvSGRUaXNUQmFmM3hwS1Y2c0tUeml5M1oySXB4WktpVkZKTTVW?=
 =?utf-8?B?RHVUWDd1RjhSL1piODZMZ2RhNzljcW9RVW9WNmhYQkdkYzE0OXlteFVmNys2?=
 =?utf-8?B?Z3lONGlMTm1PMWRCVjVSeUlFYUptSGp2aUxXVHRnTXdneEs2RGQva1VxaTJS?=
 =?utf-8?B?ZzBCM082dExzUVBBK2hJVW1QZXE2Nk4xQW01V3FzV2czWE95VFlVUWptM3kx?=
 =?utf-8?B?TFFxVFRWb2lXTVhybTJPVlJKRE5ncjVURGVieGRLNmxhT0Vwa1VFQks0TFg5?=
 =?utf-8?B?MzNCTUQ0bENTWnFrODFxb1FSQ2NkMXNYaGo1KzQyZkdDdlB6eUN5MWtqK2Zn?=
 =?utf-8?B?Q2VoajlUOTYwR2ZUWUxHa1htZVdITThjaWwrQUVxcXdyUU1rckxlMXVsVkIx?=
 =?utf-8?B?TTBmalJoa2NCQ0ZJdkFES1VjZ1ZndEdPQmFaRkY5RjJsU0M1bFIzWHJ1eEZ3?=
 =?utf-8?B?amJYNEdFRlVCL3VzVXBzTkxXdHVnTE8raTJkL3RlRkZDSW9IS1RaNFplQzR4?=
 =?utf-8?B?WVA2VGhDQUhMTkRyWUpzS1lLNXYrNkpMYkxiYlkzdm9lSW9KL3NjWTEwSk9C?=
 =?utf-8?Q?pr3qV4AL7Q/1BuIqWsQed2kR8P56tXP18myyOQlZlb1j?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5515.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5598ab7c-b73a-4dfe-2d4c-08d9db414d9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2022 11:46:17.0176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BkuRAK3gwldEC5Mz9kQDsKjFT7zzhaeIw3qsmiOEsP8rqpDt4kpRo+3ARQTlmWSMSqxvDKfwwiH6fBvxJ/6eVj0ZPZqFb79Ru9lmL72clPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3330
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190067
X-Proofpoint-GUID: QgjE9k6O43SCHRRF0Sg6Yani_3ympLhz
X-Proofpoint-ORIG-GUID: QgjE9k6O43SCHRRF0Sg6Yani_3ympLhz
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IExlb24gUm9tYW5vdnNreSBbbWFpbHRv
Omxlb25Aa2VybmVsLm9yZ10gDQpTZW50OiAxOSBKYW51YXJ5IDIwMjIgMTI6MjkgUE0NClRvOiBT
YW50b3NoIFNoaWxpbWthciA8c2FudG9zaC5zaGlsaW1rYXJAb3JhY2xlLmNvbT4NCkNjOiBKYXNv
biBHdW50aG9ycGUgPGpnZ0B6aWVwZS5jYT47IFByYXZlZW4gS2Fubm9qdSA8cHJhdmVlbi5rYW5u
b2p1QG9yYWNsZS5jb20+OyBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pjsg
a3ViYUBrZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1yZG1hQHZnZXIu
a2VybmVsLm9yZzsgcmRzLWRldmVsQG9zcy5vcmFjbGUuY29tOyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnOyBSYW1hIE5pY2hhbmFtYXRsdSA8cmFtYS5uaWNoYW5hbWF0bHVAb3JhY2xlLmNv
bT47IFJhamVzaCBTaXZhcmFtYXN1YnJhbWFuaW9tIDxyYWplc2guc2l2YXJhbWFzdWJyYW1hbmlv
bUBvcmFjbGUuY29tPg0KU3ViamVjdDogUmU6IFtQQVRDSCBSRkNdIHJkczogaWI6IFJlZHVjZSB0
aGUgY29udGVudGlvbiBjYXVzZWQgYnkgdGhlIGFzeW5jaHJvbm91cyB3b3JrZXJzIHRvIGZsdXNo
IHRoZSBtciBwb29sDQoNCk9uIFR1ZSwgSmFuIDE4LCAyMDIyIGF0IDA3OjQyOjU0UE0gKzAwMDAs
IFNhbnRvc2ggU2hpbGlta2FyIHdyb3RlOg0KPiBPbiBKYW4gMTgsIDIwMjIsIGF0IDExOjE3IEFN
LCBKYXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5jYT4gd3JvdGU6DQo+ID4gDQo+ID4gT24gVHVl
LCBKYW4gMTgsIDIwMjIgYXQgMDQ6NDg6NDNQTSArMDAwMCwgU2FudG9zaCBTaGlsaW1rYXIgd3Jv
dGU6DQo+ID4+IA0KPiA+Pj4gT24gSmFuIDE4LCAyMDIyLCBhdCA2OjQ3IEFNLCBQcmF2ZWVuIEth
bm5vanUgPHByYXZlZW4ua2Fubm9qdUBvcmFjbGUuY29tPiB3cm90ZToNCj4gPj4+IA0KPiA+Pj4g
VGhpcyBwYXRjaCBhaW1zIHRvIHJlZHVjZSB0aGUgbnVtYmVyIG9mIGFzeW5jaHJvbm91cyB3b3Jr
ZXJzIGJlaW5nIA0KPiA+Pj4gc3Bhd25lZCB0byBleGVjdXRlIHRoZSBmdW5jdGlvbiAicmRzX2li
X2ZsdXNoX21yX3Bvb2wiIGR1cmluZyB0aGUgDQo+ID4+PiBoaWdoIEkvTyBzaXR1YXRpb25zLiBT
eW5jaHJvbm91cyBjYWxsIHBhdGgncyB0byB0aGlzIGZ1bmN0aW9uICJyZHNfaWJfZmx1c2hfbXJf
cG9vbCINCj4gPj4+IHdpbGwgYmUgZXhlY3V0ZWQgd2l0aG91dCBiZWluZyBkaXN0dXJiZWQuIEJ5
IHJlZHVjaW5nIHRoZSBudW1iZXIgDQo+ID4+PiBvZiBwcm9jZXNzZXMgY29udGVuZGluZyB0byBm
bHVzaCB0aGUgbXIgcG9vbCwgdGhlIHRvdGFsIG51bWJlciBvZiANCj4gPj4+IEQgc3RhdGUgcHJv
Y2Vzc2VzIHdhaXRpbmcgdG8gYWNxdWlyZSB0aGUgbXV0ZXggbG9jayB3aWxsIGJlIA0KPiA+Pj4g
Z3JlYXRseSByZWR1Y2VkLCB3aGljaCBvdGhlcndpc2Ugd2VyZSBjYXVzaW5nIERCIGluc3RhbmNl
IGNyYXNoIGFzIA0KPiA+Pj4gdGhlIGNvcnJlc3BvbmRpbmcgcHJvY2Vzc2VzIHdlcmUgbm90IHBy
b2dyZXNzaW5nIHdoaWxlIHdhaXRpbmcgdG8gYWNxdWlyZSB0aGUgbXV0ZXggbG9jay4NCj4gPj4+
IA0KPiA+Pj4gU2lnbmVkLW9mZi1ieTogUHJhdmVlbiBLdW1hciBLYW5ub2p1IDxwcmF2ZWVuLmth
bm5vanVAb3JhY2xlLmNvbT4gDQo+ID4+PiDigJQNCj4gPj4+IA0KPiA+PiBb4oCmXQ0KPiA+PiAN
Cj4gPj4+IGRpZmYgLS1naXQgYS9uZXQvcmRzL2liX3JkbWEuYyBiL25ldC9yZHMvaWJfcmRtYS5j
IGluZGV4IA0KPiA+Pj4gOGYwNzBlZS4uNmI2NDBiNSAxMDA2NDQNCj4gPj4+ICsrKyBiL25ldC9y
ZHMvaWJfcmRtYS5jDQo+ID4+PiBAQCAtMzkzLDYgKzM5Myw4IEBAIGludCByZHNfaWJfZmx1c2hf
bXJfcG9vbChzdHJ1Y3QgcmRzX2liX21yX3Bvb2wgKnBvb2wsDQo+ID4+PiAJICovDQo+ID4+PiAJ
ZGlydHlfdG9fY2xlYW4gPSBsbGlzdF9hcHBlbmRfdG9fbGlzdCgmcG9vbC0+ZHJvcF9saXN0LCAm
dW5tYXBfbGlzdCk7DQo+ID4+PiAJZGlydHlfdG9fY2xlYW4gKz0gbGxpc3RfYXBwZW5kX3RvX2xp
c3QoJnBvb2wtPmZyZWVfbGlzdCwgDQo+ID4+PiAmdW5tYXBfbGlzdCk7DQo+ID4+PiArCVdSSVRF
X09OQ0UocG9vbC0+Zmx1c2hfb25nb2luZywgdHJ1ZSk7DQo+ID4+PiArCXNtcF93bWIoKTsNCj4g
Pj4+IAlpZiAoZnJlZV9hbGwpIHsNCj4gPj4+IAkJdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gPj4+
IA0KPiA+Pj4gQEAgLTQzMCw2ICs0MzIsOCBAQCBpbnQgcmRzX2liX2ZsdXNoX21yX3Bvb2woc3Ry
dWN0IHJkc19pYl9tcl9wb29sICpwb29sLA0KPiA+Pj4gCWF0b21pY19zdWIobmZyZWVkLCAmcG9v
bC0+aXRlbV9jb3VudCk7DQo+ID4+PiANCj4gPj4+IG91dDoNCj4gPj4+ICsJV1JJVEVfT05DRShw
b29sLT5mbHVzaF9vbmdvaW5nLCBmYWxzZSk7DQo+ID4+PiArCXNtcF93bWIoKTsNCj4gPj4+IAlt
dXRleF91bmxvY2soJnBvb2wtPmZsdXNoX2xvY2spOw0KPiA+Pj4gCWlmICh3YWl0cXVldWVfYWN0
aXZlKCZwb29sLT5mbHVzaF93YWl0KSkNCj4gPj4+IAkJd2FrZV91cCgmcG9vbC0+Zmx1c2hfd2Fp
dCk7DQo+ID4+PiBAQCAtNTA3LDggKzUxMSwxNyBAQCB2b2lkIHJkc19pYl9mcmVlX21yKHZvaWQg
KnRyYW5zX3ByaXZhdGUsIGludCANCj4gPj4+IGludmFsaWRhdGUpDQo+ID4+PiANCj4gPj4+IAkv
KiBJZiB3ZSd2ZSBwaW5uZWQgdG9vIG1hbnkgcGFnZXMsIHJlcXVlc3QgYSBmbHVzaCAqLw0KPiA+
Pj4gCWlmIChhdG9taWNfcmVhZCgmcG9vbC0+ZnJlZV9waW5uZWQpID49IHBvb2wtPm1heF9mcmVl
X3Bpbm5lZCB8fA0KPiA+Pj4gLQkgICAgYXRvbWljX3JlYWQoJnBvb2wtPmRpcnR5X2NvdW50KSA+
PSBwb29sLT5tYXhfaXRlbXMgLyA1KQ0KPiA+Pj4gLQkJcXVldWVfZGVsYXllZF93b3JrKHJkc19p
Yl9tcl93cSwgJnBvb2wtPmZsdXNoX3dvcmtlciwgMTApOw0KPiA+Pj4gKwkgICAgYXRvbWljX3Jl
YWQoJnBvb2wtPmRpcnR5X2NvdW50KSA+PSBwb29sLT5tYXhfaXRlbXMgLyA1KSB7DQo+ID4+PiAr
CQlzbXBfcm1iKCk7DQo+ID4+IFlvdSB3b27igJl0IG5lZWQgdGhlc2UgZXhwbGljaXQgYmFycmll
cnMgc2luY2UgYWJvdmUgYXRvbWljIGFuZCB3cml0ZSANCj4gPj4gb25jZSBhbHJlYWR5IGlzc3Vl
IHRoZW0uDQo+ID4gDQo+ID4gTm8sIHRoZXkgZG9uJ3QuIFVzZSBzbXBfc3RvcmVfcmVsZWFzZSgp
IGFuZCBzbXBfbG9hZF9hY3F1aXJlIGlmIHlvdSANCj4gPiB3YW50IHRvIGRvIHNvbWV0aGluZyBs
aWtlIHRoaXMsIGJ1dCBJIHN0aWxsIGNhbid0IHF1aXRlIGZpZ3VyZSBvdXQgDQo+ID4gaWYgdGhp
cyB1c2FnZSBvZiB1bmxvY2tlZCBtZW1vcnkgYWNjZXNzZXMgbWFrZXMgYW55IHNlbnNlIGF0IGFs
bC4NCj4gPiANCj4gSW5kZWVkLCBJIHNlZSB0aGF0IG5vdywgdGhhbmtzLiBZZWFoLCB0aGVzZSBt
dWx0aSB2YXJpYWJsZSBjaGVja3MgY2FuIA0KPiBpbmRlZWQgYmUgcmFjeSBidXQgdGhleSBhcmUg
dW5kZXIgbG9jayBhdCBsZWFzdCBmb3IgdGhpcyBjb2RlIHBhdGguIA0KPiBCdXQgdGhlcmUgYXJl
IGZldyBob3QgcGF0aCBwbGFjZXMgd2hlcmUgc2luZ2xlIHZhcmlhYmxlIHN0YXRlcyBhcmUgDQo+
IGV2YWx1YXRlZCBhdG9taWNhbGx5IGluc3RlYWQgb2YgaGVhdnkgbG9jay4NCg0KQXQgbGVhc3Qg
cG9vbC0+ZGlydHlfY291bnQgaXMgbm90IGxvY2tlZCBpbiByZHNfaWJfZnJlZV9tcigpIGF0IGFs
bC4NCg0KVGhhbmtzDQoNCj4gDQo+IFJlZ2FyZHMsDQo+IFNhbnRvc2gNCj4gDQoNClRoYW5rIHlv
dSBTYW50b3NoLCBMZW9uIGFuZCBKYXNvbiBmb3IgcmV2aWV3aW5nIHRoZSBQYXRjaC4NCg0KMS4g
TGVvbiwgdGhlIGJvb2wgdmFyaWFibGUgImZsdXNoX29uZ29pbmcgIiBpbnRyb2R1Y2VkIHRocm91
Z2ggdGhlIHBhdGNoIGhhcyB0byBiZSBhY2Nlc3NlZCBvbmx5IGFmdGVyIGFjcXVpcmluZyB0aGUg
bXV0ZXggbG9jay4gSGVuY2UgaXQgaXMgd2VsbCBwcm90ZWN0ZWQuDQoNCjIuIEFzIHRoZSBjb21t
aXQgbWVzc2FnZSBhbHJlYWR5IGNvbnZleXMgdGhlIHJlYXNvbiwgdGhlIGNoZWNrIGJlaW5nIG1h
ZGUgaW4gdGhlIGZ1bmN0aW9uICJyZHNfaWJfZnJlZV9tciIgaXMgb25seSB0byBhdm9pZCB0aGUg
cmVkdW5kYW50IGFzeW5jaHJvbm91cyB3b3JrZXJzIGZyb20gYmVpbmcgc3Bhd25lZC4NCg0KMy4g
VGhlIHN5bmNocm9ub3VzIGZsdXNoIHBhdGgncyB0aHJvdWdoIHRoZSBmdW5jdGlvbiAicmRzX2Zy
ZWVfbXIiIHdpdGggZWl0aGVyIGNvb2tpZT0wIG9yICJpbnZhbGlkYXRlIiBmbGFnIGJlaW5nIHNl
dCwgaGF2ZSB0byBiZSBob25vdXJlZCBhcyBwZXIgdGhlIHNlbWFudGljcyBhbmQgaGVuY2UgdGhl
c2UgcGF0aHMgaGF2ZSB0byBleGVjdXRlIHRoZSBmdW5jdGlvbiAicmRzX2liX2ZsdXNoX21yX3Bv
b2wiIHVuY29uZGl0aW9uYWxseS4NCg0KNC4gSXQgY29tcGxpY2F0ZXMgdGhlIHBhdGNoIHRvIGlk
ZW50aWZ5LCB3aGVyZSBmcm9tIHRoZSBmdW5jdGlvbiAicmRzX2liX2ZsdXNoX21yX3Bvb2wiLCBo
YXMgYmVlbiBjYWxsZWQuIEFuZCBoZW5jZSwgdGhpcyBwYXRjaCB1c2VzIHRoZSBzdGF0ZSBvZiB0
aGUgYm9vbCB2YXJpYWJsZSB0byBzdG9wIHRoZSBhc3luY2hyb25vdXMgd29ya2Vycy4NCg0KNS4g
V2Uga25ldyB0aGF0ICJxdWV1ZV9kZWxheWVkX3dvcmsiIHdpbGwgZW5zdXJlcyBvbmx5IG9uZSB3
b3JrIGlzIHJ1bm5pbmcsIGJ1dCBhdm9pZGluZyB0aGVzZSBhc3luYyB3b3JrZXJzIGR1cmluZyBo
aWdoIGxvYWQgc2l0dWF0aW9ucywgbWFkZSB3YXkgZm9yIHRoZSBhbGxvY2F0aW9uIGFuZCBzeW5j
aHJvbm91cyBjYWxsZXJzIHdoaWNoIHdvdWxkIG90aGVyd2lzZSBiZSB3YWl0aW5nIGxvbmcgZm9y
IHRoZSBmbHVzaCB0byBoYXBwZW4uIEdyZWF0IHJlZHVjdGlvbiBpbiB0aGUgbnVtYmVyIG9mIGNh
bGxzIHRvIHRoZSBmdW5jdGlvbiAicmRzX2liX2ZsdXNoX21yX3Bvb2wiIGhhcyBiZWVuIG9ic2Vy
dmVkIHdpdGggdGhpcyBwYXRjaC4gDQoNCjYuIEphc29uLCB0aGUgb25seSBmdW5jdGlvbiAicmRz
X2liX2ZyZWVfbXIiIHdoaWNoIGFjY2Vzc2VzIHRoZSBpbnRyb2R1Y2VkIGJvb2wgdmFyaWFibGUg
ImZsdXNoX29uZ29pbmciIHRvIHNwYXduIGEgZmx1c2ggd29ya2VyIGRvZXMgbm90IGNydWNpYWxs
eSBpbXBhY3QgdGhlIGF2YWlsYWJpbGl0eSBvZiBNUidzLCBiZWNhdXNlIHRoZSBmbHVzaCBoYXBw
ZW5zIGZyb20gYWxsb2NhdGlvbiBwYXRoIGFzIHdlbGwgd2hlbiBuZWNlc3NhcnkuICAgSGVuY2Ug
dGhlIExvYWQtc3RvcmUgb3JkZXJpbmcgaXMgbm90IGVzc2VudGlhbGx5IG5lZWRlZCBoZXJlLCBi
ZWNhdXNlIG9mIHdoaWNoIHdlIGNob3NlIHNtcF9ybWIoKSBhbmQgc21wX3dtYigpIG92ZXIgc21w
X2xvYWRfYWNxdWlyZSgpIGFuZCBzbXBfc3RvcmVfcmVsZWFzZSgpLg0KDQpSZWdhcmRzLA0KUHJh
dmVlbi4NCg==
