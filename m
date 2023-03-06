Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4AD46ACE2E
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 20:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjCFTfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 14:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjCFTe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 14:34:57 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3774839B9E
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 11:34:49 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326HTWZj024995;
        Mon, 6 Mar 2023 19:34:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ugfOQQrqQ7NfPHFDIveugg9oy8dutAvFuSSAn0C+//Y=;
 b=VyqofNmOtWxg7Hv0L4vcmek0I3rI+CxfLnc62ef9COfrT5iyRnhU4WRtjywHCjxcN+3i
 587sYVRfD6etnN1u7Dd/MZbrBnhTgIghq82HDwc5hexMCFTbBq9wHVlktePkNzl6RfLZ
 yaMlb68mTJ4DO83nCxtaKkBWAgsKHTFyBMd2fkfetSw2qUk1t98ydzt2EgW+v/03Ha7B
 SokE68CrU1dQTCGdBtpYo6KzUtgLjvxaY9EMIS8Kpaer0f6N96PU4RR7NT8GLMK+hsBm
 9ii8vXuoDiwdy26DyEdiD+zD8N0fSFu/5z1sAJ9YDRrphS/98CciF5cqiOR5bpU0+MDy eg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p416wksqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 19:34:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 326J6LZ5009607;
        Mon, 6 Mar 2023 19:34:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u2gq6sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 19:34:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtp3a6uLicq9qbV/gSYEr8LxG6xVrA/B9FysoJyqld4tVSnhVGe6g6R6cPD8D1l+enbwmr6eY/fXsVhniOIse0msSPW5jcVDpnTVZZHfM7odRNDQIIY3zWpF7xlJK7O+a750WsIodHaai1G8UaI1lG1CNZJ38vpFSwadZL0+VYfUHJgMoS1OVRa2zgImJIjLXd7eZOjcAq/6zmPRBfsEyEB4j/ujYJGUZT96zkjsjpbtH9S5cspC6OmPgfWWMpyHQLI7bhCbUgGW+dKjKSyEzvD0onoUJE9Xd+wkeH2XPVJ0HhEDAbEJxBZ5ieE9NUtwaJsr4S4JNCM4KrcAgDpEqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugfOQQrqQ7NfPHFDIveugg9oy8dutAvFuSSAn0C+//Y=;
 b=gKuciyPPwzONzXSf26o0LgJHU8zdtd7/T2RrruJcoKuN60Mix1g6MHrQ7nTJdb52UcB8knwO4nglYIL4hy/UmFV/SN/rq/pvSg91tkuihUeKBvZv3SoV96nV6AwnRXba2QKrK33Rhu7ef1WqvsEbASMqlknDzGz2jqaTyrTqo1LT9FsfnUIWnTsKMGF5yHu30DAJtcFXQXcA3Gg5u3dZTh7A7kOeOCQUe3+p/8cqU9kJVQFQWMaahjtoOtuoITmb4hR5OtUe27Ut7KeCaO9XoE6SKiL/itZ3RyECbJe2e2v2pJ+ooPSmGgYIiXZkRc6ueP5/ClXxEWai5TIlY4zuuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugfOQQrqQ7NfPHFDIveugg9oy8dutAvFuSSAn0C+//Y=;
 b=f8VK1wToNcA6isEpq8pPMI71vMmP6uzvhhPbFOvpK06R5EoVkTH5bMFHKDwohxQuQgMtR5jCFLdI6ZF4WsJBzg5HmW8xiaYlm0q7iETED67A7lWQTWvJeqV8aF6fUjFMbpcdWH9dtHYGBrmCZhp7NMyINmnR62LHwuJ/XYKn7II=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CY8PR10MB6491.namprd10.prod.outlook.com (2603:10b6:930:5d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 19:34:31 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%6]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 19:34:31 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Chuck Lever <cel@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v6 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v6 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZTgEx5sDM5wq7q0GXZWBkY2YJz67p5A6AgAD8h4CAAAVfAIAAGZ8AgAAJGoCAAANvAIAABQOAgAAHUoCAAxDjAA==
Date:   Mon, 6 Mar 2023 19:34:31 +0000
Message-ID: <9E2B3905-08AF-4C18-BE1B-3F55B917276B@oracle.com>
References: <167786872946.7199.12490725847535629441.stgit@91.116.238.104.host.secureserver.net>
 <167786949141.7199.15896224944077004509.stgit@91.116.238.104.host.secureserver.net>
 <20230303182131.1d1dd4d8@kernel.org>
 <62D38E0F-DA0C-46F7-85D4-80FD61C55FD3@oracle.com>
 <83CDD55A-703B-4A61-837A-C98F1A28BE17@oracle.com>
 <20230304111616.1b11acea@kernel.org>
 <C236CECE-702B-4410-A509-9D33F51392C2@oracle.com>
 <20230304120108.05dd44c5@kernel.org>
 <0C0B6439-B3D0-46F3-8CD2-6AACD0DDE923@oracle.com>
 <20230304124517.394695e8@kernel.org>
In-Reply-To: <20230304124517.394695e8@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CY8PR10MB6491:EE_
x-ms-office365-filtering-correlation-id: 8bd99bb8-0c92-438b-9f6d-08db1e79ceeb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tmj/z/oFKDQku3nNEiLxOwPvvKyMrp5bb5J6jyk38bwGODh2GPzaFjBQLVfxuC6qf8BQge7zKQ+Tmy8y7pLkGJ6c9Qf82Oc5J7AB71eT6dHw3qhvUa52xH7zas/TZ8QmoFHXbv0nar15IaqBCTIJ0FAMPiQKrsmcxZSWrEwkLi3vzUs3eBifFiGXCjk8FwW41agjbInhQdAPqFjx5nFpAJHQdygd9KVSPpwxGSIF053iVJZBwBcXeR1teceRxcgkxKLPOFvwxds5X6wrg/4No2ek129fgScsdZNis0pdvC28kgTaE+sD40ngjEEVWbqKzw8rnx0SM+QeZDYx06fv+NuliFDlBKmLb1rpu7izrhHuKukuAQ9getyezbsrqM5+L4rgf95G+Y7ny4pU6px1flKwp9okzpnaTN9sNGq+WJEhSigJ/o7iaAAyfDAP6ISZiK7jR1DD25sSIN1qhm4eXCFsGhSk/LiomYqLLYG2ynnQn30sQ9q+pW96+lJlaPSe7mgO4nhKmZfhGvaNxbA6D6FuVwTVBz0FyK9N7NFGwrE59nTvtfFwsWuEW6iH0vSFqJtMUKoX+2fQ4ZLx0W0oeUjHnqn2irbWcHi3bSJNMoFOhqKQxzX6Z7vDcU4BP0wR/gOD0uDLZ4VEz5KyBGnmOIcc6mxC7FMe3nzRtpOyn5++hbvNn46+PjJ4Hc0s4Hu0nYoA1MGmYGa/c3dkFSi4tCZGqlDPj49GFZcoU1wQmJVh3gg+ZUjymH7gqqBOWJX2alJq8KFGqvxhRL1xxNkHp9qtXA57/hPUeQ3zV8mWhnc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(39860400002)(376002)(136003)(366004)(451199018)(6506007)(107886003)(2906002)(4326008)(8676002)(66476007)(6916009)(66446008)(66556008)(64756008)(91956017)(41300700001)(76116006)(66946007)(86362001)(316002)(8936002)(38070700005)(5660300002)(38100700002)(478600001)(33656002)(6486002)(36756003)(122000001)(71200400001)(54906003)(2616005)(6512007)(186003)(26005)(53546011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HXXPI3Tpk7VLfuMY09tmrnA0DTlA2xENHDvK9n/0ZSeHSIxnDtX/8x30E21H?=
 =?us-ascii?Q?Hzeobz1VCWGRUNuPIyAYOK/Q72m1HUw7HAa1buc4sZGlVDzgFVp7JLnHlwzK?=
 =?us-ascii?Q?GCzCCcIutjGynCu5rmhOX11M6GMcJ01bqVyO1/4iFpfYvdcZ7SAV3JClCEi5?=
 =?us-ascii?Q?LTxZgehq9MdleRbtSJiNs1gJCzMOiaqHltAZdpEM3JKWlrA9JC0zsn6741bg?=
 =?us-ascii?Q?d0v4C2luGFrIxj1emA8h5D5iC+I7kqcFpNVaunqwToDpVO/ANbkaO6D62vZE?=
 =?us-ascii?Q?8Vp+YMVsyLoqcWCCZjdvPHij+wJiBArlThhXokbnXcxinRVlufkBHz7Y/4DU?=
 =?us-ascii?Q?PLBtpUEr9aK4RffUSlqQ4Sud+a+END12eowzDMrxeWZtE7BS2IuKSNiU/+PI?=
 =?us-ascii?Q?Bxj9uAXneRLVn6p+bijJG1uEWathdtfjmJMYYiniIo3ekw4PYATV5iN14HO8?=
 =?us-ascii?Q?0wlKc/gvzUDd0bvmDIzQ6ajycumE39j7i7Yb7DhKWy+0tCnt+cZhoV4ZTEWv?=
 =?us-ascii?Q?bt2B+FxippQAUmWrUW35FGfJk7KnQhwPhkQw9Ol9usWVQ9+ApYFCmVT7tAoX?=
 =?us-ascii?Q?+S+Ze3XIo1/IuJYrGktSITuOHWiPdgmT+ZMiuvzVpP2mwKHIHr09jhQoTkNp?=
 =?us-ascii?Q?J0ck/82cxDmBuh/UOuGEMu1jY4e3loC7RT8q5Y4C5jWWyqePBzPCGbIyJH+c?=
 =?us-ascii?Q?3ltRx2Fj8NuEga9jVmmYH/xTS3otiNjReSLMdYqQdnc1mxdc60OpNZC22B3R?=
 =?us-ascii?Q?rLTB1SEVr8ccYYM6fckYTTYGgH9QbXWXLWRS0a6sUpejY0EiOo2gOhxiS4W4?=
 =?us-ascii?Q?32icz3v5mmCavJbcvaoCn43OlpRlbFZEcHhpFkJ00Yv6dQaTd6sNQmVlQWI4?=
 =?us-ascii?Q?kbjjIechoPpMXGKpCrj3yQi953dPRzUDBFqHRIDBwhiN85zYdCVQtRpaOuAy?=
 =?us-ascii?Q?kcCUqiHFMwyJbBIIlCXsEzm6mHxmB9AOXVv6hjDQdb1ayXV1lfrzuDKN7tHp?=
 =?us-ascii?Q?qWai3R0yEnJRX7l+zCTLIdIJniThS91ivztGYuxv9ZtV0h7VHGTy+O7EDTrc?=
 =?us-ascii?Q?9q9LHlTnNs6qwGsbAqM++4HELnqBH/TfEpWlvQEglcZNkacVFvPdXbPHHYiF?=
 =?us-ascii?Q?FmvHXDO8UQ+mSzfoiHguOAKdNb8B+Xi0Z7wgGuhZsqP7BrneqY+v9nA3T9+L?=
 =?us-ascii?Q?wPRGpLwT7XKk3ovZpuMoXVin1nPRpPPvsx2OAO8VrsRupPXCuKCvNE7TTphJ?=
 =?us-ascii?Q?UIIzqoGily3NvrKZS0SMNgdLx2K8H3BL/K+TQg8LnZVQ82+zQyzYGgTbT5b+?=
 =?us-ascii?Q?NN0/GwUmq03hJwLSSZsGMD2DVdIf4XXoNiedmvO7B7uRskTS8NqNemqLTSYY?=
 =?us-ascii?Q?0siBYQ3Cm+gd0XVOBFFSJ8DPArfMchEUA9QymjUuEl+UNr3XYONT0lDT5kWd?=
 =?us-ascii?Q?owE9uLhJyr3n+WTCFWDpF7jfHB6wZ35Zz7CabyCwKfvXcFFj/lNJ65NYbx9p?=
 =?us-ascii?Q?yNVBq/FaOpX/BSfUfK7pKvBP+1gllRaWqM5unB4FuRI3YjdY0NBVNPCW1OZR?=
 =?us-ascii?Q?dOUCvvxlEWyAxk/yqBueuoslc2sBym3VIVUs2kQmZOwtLT7HNOPJagfIDDSr?=
 =?us-ascii?Q?Fw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A74F4B76B6820D429D19A9B396D30875@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bngwhgnEzZZT2ubr4Rp6p9Ij8rMUmSOK0o+y0wb1dWsZIXTd9aZndchJrwVCxdwv/r/EBE3fZDcIfwrEPaNpzofkPqVxA4TvNBIbfPkrXFgBNkaL12xQEclJdGZWJL2tmwTMIeD+1RY1dxAn/63SOzEsXOWuFqfr8SPuVRhfcc4HSX5GkbvvRpmy4k2uh27ZkGgOetzZYhHIacYDnRSGuuEEjHIkgjG2hlCKTjm1I56lxHq7RJ18ewZBbL/pleyiSGOYaoGS/eEb3rsNwS/eeEsU5HsB2Vq4QQZVaTfJLdU2K4V7CrGC//QQ35PDtjBhHFKBel+A+SoZ0x1q6PI1Ojn1hDFTIhW2bfJ/kGsJ7FdI4tP86tR/wVrmVxsh3/yAN+LTYdaphAppatcjLLfcbKNk57kk8gYF7X04yHInd5x5dhgTxRynKw0iMxu1mmooP4anyoNSJxyNWgly+/S3hCDAA6luL7mLCQB5iinI9+8tU1CoE0PBF08PbVa1AgZ07Aqk8XjXRCSCDRJ+N2ExC4fb9Bsh9yfO1qWU+czYf6wCRISwVF+HGRv944DVj+6uOPs4IjHLkudR8AoxsnKBNZy6k2bHEvKDa8oRpoEmSeSaNXKxBP5Dhi00XDHK+u9w3F8r4oH5vzaygsY8gadsJDIHbf/pL6D1Xy2JfAxt8uCaU8dpUduOeqpsXgLUj+vOMHJeHZdqoX+5lJsTP1ytDSVY4VQ+8dkMAPvDxEBdDtPPpBXY9Z7syxyTI08B8jDFjoXU9QyLekJN+lrOvAKK/9QM4WBFchSgKHWA3Jq4s5iHfjeZnXTM0FKCWVP0XuxRXNt9Js/Ofmr5WBx76rk7SVEYsZ30sOSUKs3ClA7NSH0/MvT734630FgtpzcXVcjW/sTDuyoltBDbc4pIABJX8w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd99bb8-0c92-438b-9f6d-08db1e79ceeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 19:34:31.4013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bXhpucVSRP0jRhFNZgEfWeANmcxiWezJ+vq7AY4jqwcyVPXohkmSMQmZtfERKhMEUOEC1cn38nJgJicj35mzGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6491
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_12,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060171
X-Proofpoint-GUID: MBUB5DuKYYQbBJUxtCoBzgzVk-Vx6IOh
X-Proofpoint-ORIG-GUID: MBUB5DuKYYQbBJUxtCoBzgzVk-Vx6IOh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 4, 2023, at 3:45 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Sat, 4 Mar 2023 20:19:06 +0000 Chuck Lever III wrote:
>>>> Sorry to make trouble -- hopefully this discussion is also
>>>> keeping you out of trouble too. =20
>>>=20
>>> I was hoping choice of BSD would keep me out of trouble :)
>>> My second choice was to make them public domain.. but lawyers should
>>> like BSD-3-clause more because of the warranty statement. =20
>>=20
>> The issue is that the GPL forces our hand. Derived code
>> is under GPL if the spec is under GPL. The 3 existing
>> specs in Documentation/netlink/specs are unlabeled, and
>> therefore I think would be subsumed under the blanket
>> license that other kernel source falls under.
>=20
> Understood.
>=20
>> I don't think you can simply choose a license for
>> the derived code. The only way to fix this so that the
>> generated code is under BSD-3-clause is to explicitly
>> re-license the specs under Documentation/netlink/specs/
>> as BSD-3-clause. (which is as easy as asking the authors
>> for permission to do that - I assume this stuff is new
>> enough that it won't be difficult to track them down).
>=20
> Fair point. I'll relicense, they are all written by me.
> The two other people who touched them should be easy to
> get hold of.
>=20
>> Again, it would be convenient for contributors in this
>> area to specify the spec and code license in the YAML
>> spec. Anyone can contribute under BSD-3-clause or GPL,
>> but the code and spec licenses have to match, IMO.
>=20
> Yes, I'll clean the existing specs up. The only outstanding
> question AFAICT is whether we really need the GPL or you can=20
> get an exception for yourself and use BSD?

I'm told that without even getting an exception, I am permitted
to contribute the handshake spec as GPL-2.0 OR BSD-2-Clause.

I don't yet have a resolution on whether the code generated
by ynl-gen-c.py is considered a derivative work.


> I care more about the downstream users than kernel devs on this,
> I'd really prefer for the users not to have to worry about=20
> licensing. There may be a codegen for some funky new language=20
> which requires a specific license which may not be compatible
> with GPL.
>=20
> For normal C this is covered by the "uAPI note" but I doubt
> that will cover generated code. And frankly would prefer not=20
> to have to ask :( So let's try BSD?
>=20
> FWIW I always thought that companies which have an explicit
> "can contribute to the kernel in GPL" policy do it because
> one needs an exception _for_GPL_, not for the kernel.
> Logically the answer to BSD-3-Clause to be "oh, yea, we=20
> don't care"... I said "logically", you can make the obvious
> joke yourself :)

So I'm wondering why not dual-license all the specs? That is
the usual way to provide a permissive license that can be
used outside of Linux environments. The output files might
then carry a dual license as well.


--
Chuck Lever


