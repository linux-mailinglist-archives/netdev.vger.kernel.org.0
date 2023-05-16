Return-Path: <netdev+bounces-3109-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C147705852
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:06:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 126462812BF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A27A1DDE0;
	Tue, 16 May 2023 20:06:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075A4847E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 20:06:10 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAEE8695
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:06:02 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GK01pH031751;
	Tue, 16 May 2023 20:05:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=SgMu6BUjKhSSeaLFKRiowITn01u9mSzfh+crrxnTEQ4=;
 b=KmzlgWsVeDBNUyfkML0qxWF39H4MiQc57aEmOHLoyq76ygEC5Hos9vLOh4qQJHk99VKW
 E2VGAXcW+QXYDtDP9HDGOByjO7ZXme0AoFPFw1H7lh+KCHR/jP+h1dO9cDflyqPy3lvg
 R5T1XjAZfUKoGE5m7hEjlKNVNceGMHvMEeUfCmO+oNbvvBGsP2jQ6HHMjdd0U6Cu668f
 6xT2728icbzqGMcipyc1asY7aveQUCKDJgb66X5HKLbujA21vLCOWAxUw7uhWnZxL0ts
 3/2IhTnRFKwP4LwVU+3RGgCxLZitQm4WBL8SijuAV5rBeO0eMc3YwOYUp3GBWlT7t86h cw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj2eb3nbe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 May 2023 20:05:52 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34GIl5ds033869;
	Tue, 16 May 2023 20:05:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj1051f71-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 May 2023 20:05:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRaFJ/9feADx3CjZyewA1LqPBFgsPZb6p6mKwBqBwmVgp0NfhOvlYaHfclhi51W57UYR+2ds03515vX+69SfsD2FVah1rfc0nEynUs8qZqfbwpTQ4NiLGNlV90nuPHU57TXQzSv9GTqjPt7UvFYwrpeZodC9b+HQtdUTm0p2cBZ/lCJmw2GZg/R9XmZbITAmfZnjGTEny1ZYUWPojZPWqg402V+rPSl6I3dbRbsoBqSLvmQkmyHUbkcHtwzoSWodp8+eHlIbxV8HOkIPkOJM7rYlwKmctkAIvJslSTTN+YZOvymJlfqoQA0CeO11bc8BzBl8kiKe54O5cCqx6YzW1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SgMu6BUjKhSSeaLFKRiowITn01u9mSzfh+crrxnTEQ4=;
 b=nnRCS3Yq4OpO7qoH/yFWPd/TBZQHFz4Nut3vxQg7YU2MtGOYZro3N485jbvt3TlD/9EAfKWBdq+FiHVNrcpCtokTBVr44Mq8XvmXIaWal7f1bp81g69iGL/q/mTM2MCephpL8smdcgaVWkDlLWPYwMwTFo+b81VKeAAmSix6Jn/q784qIu3Vi7vUbg0LmGH1P9NumZAwCjC1efTCBfodG9Ut99CizFADLK4IbkLF92JkFvjJov0VaNfotHFwz+zKn4gMDxhmUcafekbRyRIljoXUiMWN2nd68oiLn021ogYM6bOF0ASMqPMzXxciHLieaNnBj8DC0W+TSx/98IxMxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SgMu6BUjKhSSeaLFKRiowITn01u9mSzfh+crrxnTEQ4=;
 b=qoJsZz3BgaJgrI4VHpfT6Fj2EcLOH/w2LoU6vS6b38/a4YMLuz33fnLUBjUt3DrH25bq3ErEsLUNBTpDCrvxwTC513/jyKhroQ0sxlP7R8zgVCS+PcOe/LYSYwToAXDnQP6UC8CiQJMYzUJoq57NzEKS9izdr1Sxhh4VenpYyUk=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 20:05:49 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6387.034; Tue, 16 May 2023
 20:05:49 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Paolo Abeni <pabeni@redhat.com>
CC: Leon Romanovsky <leon@kernel.org>, Chuck Lever <cel@kernel.org>,
        kernel-tls-handshake <kernel-tls-handshake@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: Re: [PATCH v2 2/6] net/handshake: Fix handshake_dup() ref counting
Thread-Topic: [PATCH v2 2/6] net/handshake: Fix handshake_dup() ref counting
Thread-Index: 
 AQHZf7QsoSIApHx1cEC5oKYOzkZtjK9Oe64AgAMN9ICAAHPmAIAABk2AgAAC6wCAC11oAA==
Date: Tue, 16 May 2023 20:05:49 +0000
Message-ID: <32775B32-E82E-4497-9B24-1983711EBD3D@oracle.com>
References: 
 <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
 <168333395123.7813.7077088598355438510.stgit@oracle-102.nfsv4bat.org>
 <20230507082556.GG525452@unreal>
 <80ebc863cd77158a964698f7a887b15dc88e4631.camel@redhat.com>
 <CD7ADFAB-137C-407C-93D4-4AF314FE0E52@oracle.com>
 <2e1fb95f613b6991b173d7947334927b22e49242.camel@redhat.com>
 <D02AD35E-E28E-4998-B1C5-9019F258F738@oracle.com>
In-Reply-To: <D02AD35E-E28E-4998-B1C5-9019F258F738@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SA2PR10MB4649:EE_
x-ms-office365-filtering-correlation-id: 3ea7d559-cfc5-423f-6b7f-08db5648f194
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 wfWk6We0GcRsslElqNTN8PeIFLWWQLlsM/V7D4flF9mrWVfm7Fga63OJCNmC5FrfGLOGuxf6fnrM2DUGb2E7igwnf2enkrlsTxtdmVtvFEebAQNkYmEA160Nu0c2O0ltbp+rFfZYj0Fr/8pnmkv5iYr5UkP9r0TOrFkJiLSYHQEvWCpD0u3PCBPXQDMsDJQzv1g+TjR0BDmFtr/oC41d6Z25Hw80sB/a4us+JgRZQZONnuCo2FJStuFn9a7rTF2PoOcywHUNy3fP1X24Dp7EbE8Kc1tMkrpNnhyG88BOYyetvKRkxAWexl+Z8DzZJSCjrdiIXkuf10eX985vTCHRXVqyu0dzStrOS78YR8HNO2mjMckwpp4sN6cVZdSyQS6GOnco/c7yxJocvjz4vwlmrj3AWlERcRiKROgW+2izu0ls50/a8fvZv0+B8ae2mugbA4PbMP3JBsSBRVe4aTJgu45urkyyspIXlcJNk/zrTOaJkHnc/wdoVz2EbTs20tSo9IxscdaHGFDKCvsoMJ9SuP8nkf4Te/hzSCcKBznEP7jwEHExWrhgHkiGDh+SSysLUPpQSpcr8A1ayts2AhsLeEBbUltBJr1dmpVFP8N/qaasaaRvNvzQRldWdEC96+MjWd9Pd/5JhNxvDoDCcFC6EQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199021)(6916009)(36756003)(4326008)(2906002)(8936002)(5660300002)(8676002)(41300700001)(91956017)(76116006)(66476007)(66446008)(64756008)(86362001)(316002)(66946007)(66556008)(478600001)(54906003)(71200400001)(33656002)(6486002)(26005)(6512007)(6506007)(53546011)(83380400001)(2616005)(186003)(38070700005)(38100700002)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?3xX9h6lYx9F9TqDFJC2Rms7cYYqEuDG0NbR57LmZ076mdE82qqZP2FJ5sMd9?=
 =?us-ascii?Q?WSYBwpN6yz9vKWgXD5BNJps3+L/T5ICjg3+6hcK9M7/rDhYu7w5iobjzZwEi?=
 =?us-ascii?Q?CgvcEq/eZD0+qO9bQ+k/jrZUqhy0KFU0URnlwktc0gHiCP8eXh8F+wIW1gJ2?=
 =?us-ascii?Q?qeUmcTxwUlTqHUPehkc1s/EdjJTXoSRBgdG0yzqUsjsm99cDrQBmu+jeEQcH?=
 =?us-ascii?Q?pyIkp71fU7fLqYyU1qGmpd41KL1jjKL6VY9k4QG3MdEUCtGpz5W7oAFnWdi1?=
 =?us-ascii?Q?PyUuru6FAXVaPqCogvhFTuSi3AbKuHa4WNrxpysJj3MMN5enk4JJAkQAzH9U?=
 =?us-ascii?Q?s9VHtX3CPNadZXNj/uriUxCe4X0XTGE3zD/ko+4IO8Zt9vlKQyhdLNyXb6BX?=
 =?us-ascii?Q?oQxuWaAstB89/4bm6KygF/9FM7TRXVd04JFLdwJySbYaFU4AiVoxufpCcsVa?=
 =?us-ascii?Q?FEjnBB9Xk6kQg37NacTd9hYiTXAcHeauS2b2Cn+cY4skfIB9H84yrCn7p4Th?=
 =?us-ascii?Q?b6HJGK2rCLGk/CpACFASMsC869ytgRdKcIAhgVQFVpRpDRfbw+7v3CyB5geC?=
 =?us-ascii?Q?10HJaxyA5C3O9/QgfCZJ4KBzmTcnJ7aepnnSxwVYdfCrPxLJa6t/XlG4j5ss?=
 =?us-ascii?Q?3YBCrPzZG/xJtVtJR8jMUoCn+gEJU0R5Z8XOWlmO5bRYYZdz4gqoro36oF9T?=
 =?us-ascii?Q?r+EgI7NyqTqZSBs9IQz4x/sLk/CVtWWv/7l5a1EsxgpLpH9v+SfSyt5ZiGeW?=
 =?us-ascii?Q?p2qJYiKyLSoeMX3HIpsrm2tw2Uv6dwi/CyvH4/2YUYLvtUpBYaeP5IFg/R1x?=
 =?us-ascii?Q?DYhMxWCsFusU1uzbc5RSvdCKAGsIwZ75URXeO2Xrjtf9cb7YmMSQagORGeUY?=
 =?us-ascii?Q?f0LcKHUN0Rg2KMV6CLzS1d62ASPFEdaEQFYIwIq85kI+DqVqoyU2oxRoJhKp?=
 =?us-ascii?Q?2WwMX4fWo/0J55HqC04iAXJx3Yq9DUVsSOZHItxX3nc2VEC7Z050GXDmK4Us?=
 =?us-ascii?Q?lAKTQmf6rjWsVM8WTFxZDvMnKcA3PnQ+Wdv8y9MjIovXqN+tMNWwaclx0Nu6?=
 =?us-ascii?Q?fVG3eqXvMtBPpt7BC0x7JmgAlW2yIzcrW0IJExkZXEkqfdEXHMcJ02MLtegR?=
 =?us-ascii?Q?lkfa6OKtj9gYOqX2/1xSeM9rPlwRcZal+4Lz423sI3oAR7YwKTqH10nQcjRp?=
 =?us-ascii?Q?gvVesCycvbfuZyIXXksMFPvVmHYZw7+ks5IVewA9V3XJjcJ2AXqRgz6ImYXB?=
 =?us-ascii?Q?5h+kdlVWIe/s4Ufb+JdX3XHApwxW22/7PWlXfg5SS9UfrUYsJ5enYe/oUsqc?=
 =?us-ascii?Q?xI/WhDGN/Eg+VTHzdhsXJo1CxZczyO6+Y7B4j7sw3qd7XcAuoOGEs/BbZ2o9?=
 =?us-ascii?Q?bVX4mfjOpu0EwxWLbA/Hran1kyJAp/y4cwWtRCcn/I0ezViEx1yDFVxdsIv/?=
 =?us-ascii?Q?FGiopiv021EIe62T+aKqT1VZmeDWQ/9fAh/+uNh/xODO3d25MVd0T8fjnZah?=
 =?us-ascii?Q?wYM+N4ujvzc/7XofhUo+3/WgC9q+sW1S9+XulFOk79TW93X6wswQoPvMMwAK?=
 =?us-ascii?Q?Z/eEvS92ZLwR3i1Xqd5p2UM7OdXtJFxv8YVJfDZonhEgXnuNtRpJzW3mYe4B?=
 =?us-ascii?Q?Aw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <67BCF480B7C69E41A88DB8545E724CE5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	3Bohy6/PSaKyJFLHXAby1AbYG/Hba9Py3QIigpxrO5kgh1HXC/bUEeco6W2K+wP2gU2xEtN9eSeQ3jDKBEen8CNMDDY72ty6wgrRLPQkZyKd2XoPK37mSYD3qK8GmHG9kCBgcQVFIDt+VWNYSkHraoIKFCFh7ivbkaQNb/GnrKsAifUBxrGBUSv4z+JkHZ202epPql9Etdsd3JpO3Zw8KkUA/nqycOQezKQRIB9miOYX5W8PU1nZWs9mQg4PhiRMYV8ypLYVlEf6Fu4if+M2Er4tpjNzUCz+te8XVUNZLRYWS7Iyx5v0hILMzKXDyEFYvI1OqZOTsyUzE6EmZ6/SvYt99W6jASj8KDSAKV5dU8KxDT9FoL3BTGwg/1xdDQm8gFy65oe/b0z+qLOnfILvL/RrG8NVLln9mJmQhrjYxw/aJy5HweUycYQFm/YSTLXW9p7aeDqK1X60ArrwFk5JG+r2fIBJFK+VzUqN6BJnMzGZ4/r1qudCRL1UfchdyNWL5Y8hs3WYct/Lp8ejhdDp/AG+bID7uKfS02dkNY01FgAl1WQVOp6CzICHYPDEe9vxp/oJW9eewUA39RJUxr0ZxFmcG6z4NDevO7CIr9ebyIxXqkhAGgmOalp0vFAdZLjXuuMMrQN4im+ul2HcCPmJW1N2yH14l6Xz3WY/bSvicmf1VBNxQwFekjjYobe+4sBZ13OBJNPc0GzMsubTepUN8hlIVPE7AeSfd95KrtcNdc9fF2CWXvdTm1THKdmqNs4wLwqx7+bAzu3p8USSfTbewLFxEvJq5AxhTe2KrLpZN9inv4yBDYjxYTqnOXd48S7I4Hhwh++7rUvoVDocMqmYKFwyljPYMjoq/YAYjjSk2T9JIthP7YCxYuefXcSNBTnVmiE31Nck9N1bAPKc9mEuFg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ea7d559-cfc5-423f-6b7f-08db5648f194
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2023 20:05:49.3251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZQ7SJwSNiQAxJC/aGMt49UqVxsPPw4uY8lcdWcmwHuZKyKOohbr4buXISHG4ZyPtlzQ/vlGH4z1uxTPxz1bIEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_12,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305160169
X-Proofpoint-GUID: 1ieS-xe54swmox5MzSfJ07MFafvBsskH
X-Proofpoint-ORIG-GUID: 1ieS-xe54swmox5MzSfJ07MFafvBsskH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 9, 2023, at 10:32 AM, Chuck Lever III <chuck.lever@oracle.com> wro=
te:
>=20
>=20
>=20
>> On May 9, 2023, at 7:22 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>>=20
>> On Tue, 2023-05-09 at 13:59 +0000, Chuck Lever III wrote:
>>>=20
>>>> On May 9, 2023, at 12:04 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>>>>=20
>>>> On Sun, 2023-05-07 at 11:25 +0300, Leon Romanovsky wrote:
>>>>> On Fri, May 05, 2023 at 08:46:01PM -0400, Chuck Lever wrote:
>>>>>> From: Chuck Lever <chuck.lever@oracle.com>
>>>>>>=20
>>>>>> If get_unused_fd_flags() fails, we ended up calling fput(sock->file)
>>>>>> twice.
>>>>>>=20
>>>>>> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
>>>>>> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for ha=
ndling handshake requests")
>>>>>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>>>>>> ---
>>>>>> net/handshake/netlink.c |    4 +---
>>>>>> 1 file changed, 1 insertion(+), 3 deletions(-)
>>>>>>=20
>>>>>> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
>>>>>> index 7ec8a76c3c8a..032d96152e2f 100644
>>>>>> --- a/net/handshake/netlink.c
>>>>>> +++ b/net/handshake/netlink.c
>>>>>> @@ -101,10 +101,8 @@ static int handshake_dup(struct socket *sock)
>>>>>>=20
>>>>>> file =3D get_file(sock->file);
>>>>>> newfd =3D get_unused_fd_flags(O_CLOEXEC);
>>>>>> - if (newfd < 0) {
>>>>>> - fput(file);
>>>>>> + if (newfd < 0)
>>>>>> return newfd;
>>>>>=20
>>>>> IMHO, the better way to fix it is to change handshake_nl_accept_doit(=
)
>>>>> do not call to fput(sock->file) in error case. It is not right thing
>>>>> to have a call to handshake_dup() and rely on elevated get_file()
>>>>> for failure too as it will be problematic for future extension of
>>>>> handshake_dup().
>>>>=20
>>>> I agree with the above: I think a failing helper should leave the
>>>> larger scope status unmodified. In this case a failing handshake_dup()
>>>> should not touch file refcount, and handshake_nl_accept_doit() should
>>>> be modified accordingly, something alike:
>>>>=20
>>>> ---
>>>> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
>>>> index e865fcf68433..8897a17189ad 100644
>>>> --- a/net/handshake/netlink.c
>>>> +++ b/net/handshake/netlink.c
>>>> @@ -138,14 +138,15 @@ int handshake_nl_accept_doit(struct sk_buff *skb=
, struct genl_info *info)
>>>> }
>>>> err =3D req->hr_proto->hp_accept(req, info, fd);
>>>> if (err)
>>>> - goto out_complete;
>>>> + goto out_put;
>>>>=20
>>>> trace_handshake_cmd_accept(net, req, req->hr_sk, fd);
>>>> return 0;
>>>>=20
>>>> +out_put:
>>>> + fput(sock->file);
>>>> out_complete:
>>>> handshake_complete(req, -EIO, NULL);
>>>> - fput(sock->file);
>>>> out_status:
>>>> trace_handshake_cmd_accept_err(net, req, NULL, err);
>>>> return err;
>>>=20
>>> I'm happy to accommodate these changes, but it's not clear to me
>>> whether you want this hunk applied /in addition to/ my fix or
>>> /instead of/.
>>=20
>> It's above (completely untested!) chunk is intended to be a replace for
>> patch 2/6
>>=20
>>>> ---
>>>>=20
>>>> Somewhat related: handshake_nl_done_doit() releases the file refcount
>>>> even if the req lookup fails.
>>>=20
>>> That's because sockfd_lookup() increments the file ref count.
>>=20
>> Ooops, I missed that.
>>=20
>> Then in the successful path handshake_nl_done_doit() should call
>> fput() twice ?!? 1 for the reference acquired by sockfd_lookup() and 1
>> for the reference owned by  'req' ?!? Otherwise a ref will be leaked.
>>=20
>>>> If that is caused by a concurrent
>>>> req_cancel - not sure if possible at all, possibly syzkaller could
>>>> guess if instructed about the API - such refcount will underflow, as i=
t
>>>> is rightfully decremented by req_cancel, too.
>>>=20
>>> More likely, req_cancel might take the file ref count to zero
>>> before sockfd_lookup can increment it, resulting in a UAF?
>>>=20
>>> Let me think about this.
>>=20
>> I now think this race is not possible, but I now fear the refcount leak
>> mentioned above.
>=20
> Not sure why I haven't seen evidence of a leak here. I'll have a closer l=
ook.

I added provisional trace points to report the value of f_count
before the fput() in done_doit and also where the RPC client
destroys the socket. The latter reports f_count is 1, as I would
expect, just before the final __fput_sync().


--
Chuck Lever



