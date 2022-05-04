Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E287D519BF2
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 11:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345349AbiEDJih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 05:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347713AbiEDJi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 05:38:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3108428E17;
        Wed,  4 May 2022 02:34:24 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2448iEg4018740;
        Wed, 4 May 2022 09:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=pgIDFrs54Z5WFDPfKxd7eaM7t6U//WOGz4FF425C2+M=;
 b=oKkfik+WMuRKzopxoKYwSSpubdWLV85GK67Lj4jkcMkIGwTUtTSrdv2wLHnp/OJw3Orp
 +XATsZkDpc8RDMv17yk/DQU3PSZ23XHpBq1zbSkrMAsNjvpfzg26zLLK5qDcBy2M9taQ
 7E2LpN33qzApf9355aTxbjAR+NhtBOX494IEoaK5K5AWTAQis2r7neRP/USUFBn+dfR4
 zQjIcUdv+cZmvaESXk1wfTE+wwyp9GxMvh/c7V2JJ1in/P42vv3y+GVBTd2cQBbLqB4O
 ONLGo2d0/ssIEHQ/Ntcn/PgQE4dKkXG2IjK02JzvbiqVxaq3xphAiD7bZd+7FgstawJX Bw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frwnt7x7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 May 2022 09:34:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2449Vf7Y021366;
        Wed, 4 May 2022 09:34:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fsvbn696a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 May 2022 09:34:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I27pnPw7Mu3cIl+uxoVbzyP8+WlDWahmPBAc3om7EJzUulnNLvXzhh2EDOiShnASj3lSxWMZCUJzfL4EZ6RWhuk1CGPaIG7sBL7q6RGPGVLfP6b0uh0aVJVPOyS2zW97GcEizE7sMbd7rUwp4J3T8cjRqTMi7teLmh2qnUqK60YiYK/oudcHai5vx0N6vqOeTolGc1gaJT/NtvKhkoTXvnVZWlkabjo/+OM3kEi84mln2W7nhO+cQVYC1BU1YkGaAwCjhR5UqsTEjGuldBiuVQWQv7BTMC6XLtRuk6N8PQbBP0cS/P1diWlUwJCdfuW+hfGxPC1I+BntQcmaDxUTIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pgIDFrs54Z5WFDPfKxd7eaM7t6U//WOGz4FF425C2+M=;
 b=B0CfFLTyYJx2DDcrVX0bApFPH7i+1HE4S1JPw1o2cacEPSuOMNn5xJQrfXsD/HM2UheSdhQHMClKCaYiz6E923706vKRXONb3Dzwl5g2I8RBiApQMFrhshoNmWDlWWSMNNe3v+DtbTmjVqetsqYGMUE3I3i2iHgo5pe3uBZNTJSWLCUhHuEG1Y0Cq59VCEcLulBR4NBJV85HBgbOzcIEn88X1h7vpoCpYj6GMwDqzKgOwsi40p3RiLcAr8ZIup2RToXGUfZmW2ETUVvExBAsWt+ebZOPDrgwfv/yOgSu0xnUObilyAUQbjjancEeDWZd1Lz9/09A7m5iBt6nXplvmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgIDFrs54Z5WFDPfKxd7eaM7t6U//WOGz4FF425C2+M=;
 b=fvtI1J2pUM3mYV+RXxuFu+D4viOpxnkJ4TUhwGb6rtP4qFwMprxLwWD30ZMnSIvEX32nzXQwdlKtdYic1mzD8Kvph8zR0BIWvzKpnpq47WGM63J3x6q12o8Cf3WkuFPahxwgEPi7MUAJ2G6z5bEQj452/Dujin9cMeKrjcDZ11k=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB3834.namprd10.prod.outlook.com
 (2603:10b6:5:1d4::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 09:34:00 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87%5]) with mapi id 15.20.5164.025; Wed, 4 May 2022
 09:34:00 +0000
Date:   Wed, 4 May 2022 12:33:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jaehee <jhpark1013@gmail.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        Outreachy Linux Kernel <outreachy@lists.linux.dev>,
        Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH] wfx: use container_of() to get vif
Message-ID: <20220504093347.GB4009@kadam>
References: <20220418035110.GA937332@jaehee-ThinkPad-X1-Extreme>
 <87y200nf0a.fsf@kernel.org>
 <CAA1TwFCOEEwnayexnJin8T=Fc2HEgHC9jyfj5HxfiWybjUi9GA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1TwFCOEEwnayexnJin8T=Fc2HEgHC9jyfj5HxfiWybjUi9GA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0064.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3e::29) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9705d73e-e691-49ce-8976-08da2db137fb
X-MS-TrafficTypeDiagnostic: DM6PR10MB3834:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3834F40528F5C102A8136D6C8EC39@DM6PR10MB3834.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KtVg3MYUqQWe2HJJhiygdl5IkNam2AZGZVggRbyNvUIMY64mr5YwN3y5i/vTTqcZq49/4TrYNNMMX53DTdO/iqfxm2f9m5E8f8ULUbT8fJcXCT3TzmZAXNHVVtSxiZGxAicWJa/LW/OLjW3DBbYuSb59DT+sTh2y41Ce827Qm2HqeK9FGjOov7gfiPD6gvXHo5SQfdkYj8AYpitLS9HwsLaZ666gWqB5gWJf7aG9cFaLWWQGiJh8SRbmXjF+l3V11NI/phrAck7sDmVix4PJRu2D9hIzeW3YF/OpW6F84brLHeRmgoP7koOxi5rScOzyQP39zIYWGJgIWCqbIUIyU4z9XBV50syxQ62jSdNYJoVtGgPOs4iAFSPreZccgNbDxRcAqV7mCn+7X3P/86FuWMZfOvXF/DBb/2EtJt+LCivxk6CtUBTJI7+/KJNQlAQOhKOcpSaAAD0dhjQkdDLl5ouUV2fhezOj7DlhpKkc+7ac2D4Hi5tl+82Tv6nRDPPLboTZykLYVbnBi3vblwY2IV6JXQkkPfLHJfchIB4klS1RbY5q9yIFCwr5ssfGKmf1N3ystsSUh9KviIahb7mGSXEUSW/VOhTKA01/aL2u5XYsU9v93SujC8yixfqbieI6sMaW1WNk0CStw4AGL8EBoUtmnsx6KcB64/hdnFwZVXY7mRDN7J8vPzcNNkW4xzCY8/+KblG3C3IKCfHz5Buudg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6916009)(54906003)(38350700002)(6486002)(508600001)(52116002)(2906002)(6666004)(38100700002)(6506007)(53546011)(316002)(33656002)(44832011)(26005)(6512007)(9686003)(33716001)(7416002)(8676002)(4326008)(5660300002)(1076003)(186003)(8936002)(66946007)(66556008)(83380400001)(86362001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkZnOVJWc3hCSnltaVlwUURKR2NwNE94Y1JLbGhyTHdtU00wZ0oxd25FQSs4?=
 =?utf-8?B?TE9XSUJxb2tETlFjcGFlVExHRUZGTFNGcy82QVlLZDhPZWhEQXF0SVBhY0Fv?=
 =?utf-8?B?bmNBNG9IbXBPbUk1Z1RtdmFWb3Fuc1hHMjB1Z2xZajFzRm4rZGlmdk5MaXdU?=
 =?utf-8?B?NWt5bDY3UC9TdVUvaDNjWmVEaWMrVFBiY3p1NXpFYytRU2lpSkVscVIxWFF1?=
 =?utf-8?B?Z0V2dTF2cm1YZUljZ2IxS2p6WmhONEdWdWtqOHdZUkJsalBKV2o5ZUpGVk04?=
 =?utf-8?B?b2FiN1hzN2NPQTcyenkvOEpBUlhoRmtGOFJKWlRvS2FUYUJHS2g2eDlmSjhz?=
 =?utf-8?B?K0F3eVRSeThWWitTcTliZ2lYWVFJSlpURFlvZy9JZ3d4WlMwK3BueGJFNzZm?=
 =?utf-8?B?Ny9wOG9tenNrUjFYa0dubWl3bEkrQWRPdUZabGtkakIxeVlhbTQxdUU4U1h0?=
 =?utf-8?B?WmVlNUVYd3FrYXg2UlBVZTg0UERkakVQTVZENWgvRHF4UG1KYXFSZEVyQmVx?=
 =?utf-8?B?KzdHWGxBVzVzSkpKYm1tWFltZ0d6emRpcjlYd1pBVVRyUzF0YmVKd0ZteHpp?=
 =?utf-8?B?REZyZDRMc3ZvWEg4dldvZFpJKzdGUnNieTJ0cWt2MUZ0SmppUE11b3lVS0hs?=
 =?utf-8?B?OGI4M095S0VMbHhxTndSb1BDR2U1cmtDRitwamxXVGRWaUl3eC9aWGdaTG5W?=
 =?utf-8?B?VU9lWSt0MnYrRE9HWnI2eklPR3pPU3hOVEVGbm5hT2xRa0JmUEJVV1dCUHYv?=
 =?utf-8?B?dU0rVEZtQlZzdGM4UFpoMm8wMWpUQnp0SHo4c0tibmFJUHlITWZvaXMzSmt3?=
 =?utf-8?B?eitMaWpXbTdWbC9vdWJiWUU1N0lRSC9KK0VoRGRSczhRK0UrcFZxZHl1SHRi?=
 =?utf-8?B?UVRFZTlRdHQ5RFlYK2hEQUtyVDZDOS9aOU1La2t3V016UUtqNTRldzNNbDlU?=
 =?utf-8?B?NzgrRnVPREp1ZGF1aTBId00rT3U4VWRWRFJLemY1bmk5UHpZVWc1OFNOa1dZ?=
 =?utf-8?B?T3VEcVZ4ZStOU2hkS0ErZ3VGaVE4QTZPbzZOZUJNL1kzNWliTVlDeC9YTkhx?=
 =?utf-8?B?VUxJNzdWQ2RiSjlhbFZYUFZJem94Rm9PcThtd3dUdzdkOHdZNVZzWTN2RnFN?=
 =?utf-8?B?cVMvTWFUZy9SUEN1L0Vsam00RlRHYWRQNTBtVzhZVUk5c0NiSnd2Z2RpN0Vu?=
 =?utf-8?B?VEhIL1dGTk80bmx0dnVuUmV4bTJkS01obm1EOStpdzZSdnY3cjBhR1htNzZ3?=
 =?utf-8?B?d2dWb3pIYU1KRGdvVHJMeWJBZzN3RGxwV0hPdDFuencvNmtWY3hPY2NOZngz?=
 =?utf-8?B?VmdVaGpNM1lLaTk2ZWE3VVRBazBYT3o3NFBudVdUbnhVOHFqVUowVGtTbm94?=
 =?utf-8?B?MFVjQ2Naa2NUcFZ4dmVjcDhFOEVxL0wvM3ZsOWZ3akhhMlBaWHZPMmdwZlhs?=
 =?utf-8?B?d254NENMS1NPVURTREV1NkJDRTk5bk9ZcDd6aEw1bUFkTzB1K25WQVQ4SW5m?=
 =?utf-8?B?S2RibXNpUFQyZjJxckswZTY1cm1DdHd3ZUZyMlkzTFZNLzlNU1c0OUpHY09T?=
 =?utf-8?B?V05TaWc3Z1RjaDNTL2dlWk5PaDFPYktTdlBadjUwaTcrQm5Sb1hnVVVaU2cy?=
 =?utf-8?B?cnhFaURmZUZtdThFYkExa2htYzI4eDdCck9rempFYnBtcG5BS0NselJ1Z3du?=
 =?utf-8?B?UlQ4MktMVTBQb1N6YjkxY0RMQU1vVHk0czU3dkRrSzR0dFlvbXR1dUJtdE1C?=
 =?utf-8?B?NkpkOWRHNEFqVG9WanF3WS92TkI0TDJuN1N4akdJQWovRnlRYW0xRkpzZXVL?=
 =?utf-8?B?ZHA5RlVoVkRSR3NEclZxK3Q4alZ0dndzanJvcW00R0QyQnhYMVhJVnM2UlFG?=
 =?utf-8?B?Zkg4QXNPczMxUzBXdk9oczE4NFMzUnlEa0xSTWpjdEpKd0tVODczT0VKSmJ3?=
 =?utf-8?B?VUpMM2x1MmxtbW5ZKzUrRnZNUWV5SDB6VzNBeGVLUkszWGV5SmpZWEJINUtT?=
 =?utf-8?B?WndTZnUzSHo2OUxpNVFtV0VEdkRqTElHWk9DREEreXhKRWlvenBSeUlGdVNZ?=
 =?utf-8?B?ZzZEWHFmbVU2K0xTcy96N3d6L21DK1g3SmFFajI3QUh3b2haU3F6aXQ0VlVn?=
 =?utf-8?B?M1RkVlNwM3E4aFgrNkdBYVp3VGIwdHI4dWtKbmVPM3I2bjAyN0VMNDRFRDda?=
 =?utf-8?B?cUNnL2tMM1FDemg5Vmw5NVN1STNRdkdRZGQ3Vnczc3RmNVpTUU1PQmZEZTll?=
 =?utf-8?B?ZGJlNmZGTjhIY3htYW9yTS9ndUxlWWZuUHpGdytkSTF2MXlleEJXck9HWE9h?=
 =?utf-8?B?RnBoaitSNFBDUDJLV1E4OUROYVAxMTBiNjdTVlo5eE9lK0lFKzNsRTAzMGZW?=
 =?utf-8?Q?XFQDPT4dI/fiwjY0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9705d73e-e691-49ce-8976-08da2db137fb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 09:34:00.3507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rffes3zVLj/RNKmjYSVi0nfrk4z7BCDIWlsJPaIdQ3lUG2Qx4esRE+bE3Docx5QrxOn5/ahw9rY6Ip5vQXLuVzMkdI0iRRLl6nkLPuMi1yw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3834
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-04_03:2022-05-02,2022-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205040063
X-Proofpoint-ORIG-GUID: 06-oWn5R3Jfwl1Qf_67eKQLe-kYsExD0
X-Proofpoint-GUID: 06-oWn5R3Jfwl1Qf_67eKQLe-kYsExD0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 02, 2022 at 02:10:07PM -0400, Jaehee wrote:
> On Wed, Apr 20, 2022 at 7:58 AM Kalle Valo <kvalo@kernel.org> wrote:
> >
> > Jaehee Park <jhpark1013@gmail.com> writes:
> >
> > > Currently, upon virtual interface creation, wfx_add_interface() stores
> > > a reference to the corresponding struct ieee80211_vif in private data,
> > > for later usage. This is not needed when using the container_of
> > > construct. This construct already has all the info it needs to retrieve
> > > the reference to the corresponding struct from the offset that is
> > > already available, inherent in container_of(), between its type and
> > > member inputs (struct ieee80211_vif and drv_priv, respectively).
> > > Remove vif (which was previously storing the reference to the struct
> > > ieee80211_vif) from the struct wfx_vif, define a function
> > > wvif_to_vif(wvif) for container_of(), and replace all wvif->vif with
> > > the newly defined container_of construct.
> > >
> > > Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> >
> > [...]
> >
> > > +static inline struct ieee80211_vif *wvif_to_vif(struct wfx_vif *wvif)
> > > +{
> > > +     return container_of((void *)wvif, struct ieee80211_vif, drv_priv);
> > > +}
> >
> > Why the void pointer cast? Avoid casts as much possible.
> >
> 
> Hi Kalle,
> 
> Sorry for the delay in getting back to you about why the void pointer
> cast was used.
> 
> In essence, I'm taking private data with a driver-specific pointer
> and that needs to be resolved back to a generic pointer.
> 
> The private data (drv_priv) is declared as a generic u8 array in struct
> ieee80211_vif, but wvif is a more specific type.
> 
> I wanted to also point to existing, reasonable examples such as:
> static void iwl_mvm_tcm_uapsd_nonagg_detected_wk(struct work_struct *wk)
> {
>         struct iwl_mvm *mvm;
>         struct iwl_mvm_vif *mvmvif;
>         struct ieee80211_vif *vif;
> 
>         mvmvif = container_of(wk, struct iwl_mvm_vif,
>                               uapsd_nonagg_detected_wk.work);
>         vif = container_of((void *)mvmvif, struct ieee80211_vif, drv_priv);
> 
> in drivers/net/wireless$ less intel/iwlwifi/mvm/utils.c, which does the
> same thing.
> 
> There are fifteen of them throughout:

The cast is fine, but this email is frustrating.

It sounds like you are saying that you copied it from other code and
that's not a good answer...  :/  It's easiest if you just copy and paste
the build error and we can figure out why the cast is need for our
selves...

drivers/net/wireless/silabs/wfx/data_rx.c: In function ‘wvif_to_vif’:
./include/linux/build_bug.h:78:41: error: static assertion failed: "pointer type mismatch in container_of()"
   78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
      |                                         ^~~~~~~~~~~~~~
./include/linux/build_bug.h:77:34: note: in expansion of macro ‘__static_assert’
   77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
      |                                  ^~~~~~~~~~~~~~~
./include/linux/container_of.h:19:9: note: in expansion of macro ‘static_assert’
   19 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
      |         ^~~~~~~~~~~~~
drivers/net/wireless/silabs/wfx/data_rx.c:20:16: note: in expansion of macro ‘container_of’
   20 |         return container_of(wvif, struct ieee80211_vif, drv_priv);
      |                ^~~~~~~~~~~~

regards,
dan carpenter

