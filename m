Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C704D8057
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 12:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238769AbiCNLEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 07:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238758AbiCNLEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 07:04:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1311C3A714;
        Mon, 14 Mar 2022 04:03:32 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EAnYqg018237;
        Mon, 14 Mar 2022 11:03:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=dDF6GVe1KvmA5kHCqUHqOFi6d0o8J/qKF0VPnBhLS4o=;
 b=xQnf8nu0pmH7Pgxy+WAX+hgfFOXY/hTIbPdK4yyUh90anNXIIpflkkLuy3JQirAzQxaM
 r2mMHdC9o1mLxWOTBjozuOegnH7T5J97KkL78Yu/uZ8Pc2O6q2nSBCnNpVUJLOctAGZx
 xm+qzHm4hGDqqzLX1iABX5wasdPhKkm3Wh9yQQ4YfR7LIys61Y2Xj4VIpGvKIJ9lbl2c
 VBqYNKP16wACVr5DZ4feelgD0452EBZo5BNdOtux3nU9T8iUtc0ozALf0y/hIgaOs139
 nEDq1/PXmItfLKrpxwNMxdddujFlRAqptDpBitJ3FlHIoWuUg6uxKJIkxkVST7z11E14 GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et49xg0sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 11:03:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22EB2QFX097427;
        Mon, 14 Mar 2022 11:03:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by userp3020.oracle.com with ESMTP id 3et4g001p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 11:03:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOFrTHFDfMzrxUX0+F0aXn2D3Ph4yMxRFC9nwReSAOg7SPFyXK4WjVEP7mCS3OvMTDg3+3xh7jkvLGaU0/SdBFS1a4ZoH9UytW0I6cV68Rf+KScG2oPzAQOKGVpOh1CaDOsBP5mMRyjM4pUAzf7rMdjQfl7pVSQ7JJ+DqPwrac6JdhZD1JQM9pFo6bNg5FnGxtOwFAB6fDlB2ZgYt1J+vGB3t3OmE0/cLB2AhgBF0iVaf48J4B5iULSGiDCyW4avstKD4F0mT4kYl/qqu0xPfQ5NifdqOuh++1gOm2FwH4vQ0A+KKopbNVmD+qemFMv7RHZGwBRSDuy9s5xUx4dqTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDF6GVe1KvmA5kHCqUHqOFi6d0o8J/qKF0VPnBhLS4o=;
 b=KrmaqyZvVY8vqs4aMhlV5kHebDKm7Sc9hZd9lJ+JmCW6d8i+ET3iPVoTxFcYO4gr2o5+ZneU2EFZKMQsk3UFpaWnZdlIuvM+QXFsgrgzdAwUvSEhTKEObuJxelJbYpROkGeMSsltBrhCpxMBuFagBvDDMpmE4ghY7n98X0C1YwaBEEtW4XWeaoYZulqQU4HgyOLp8X7tkULZr/1DY0J2kbKORZ0VNGGzu9LmbUeSZ0jPjpcbMRzp7obPQVFaXopQYsPaCVkXZrM/fAQ5+ohNcdaue3kSUV3l8gqHxI938w2pgksWJIVuyETv2r9GEio6iiad3kOi+u4gVzGGeYLk5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDF6GVe1KvmA5kHCqUHqOFi6d0o8J/qKF0VPnBhLS4o=;
 b=De+aHC01RX2nFuf5K9dRe6/LZw4VRDMWqpZvBmOtqNIyE36PEnX7c+XP5TlI+6AP2HoCnyzSaqYoiNkikriChEW9gicfaszOYU0U8Tu2HtL1kdZ+hFzVJUkwt84Ar7xtpNMvwAuvVF1C3S0qgUjtwy0zeBDiNQ8RcdJEc9h4gQU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CY4PR10MB1958.namprd10.prod.outlook.com
 (2603:10b6:903:124::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Mon, 14 Mar
 2022 11:03:13 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5061.022; Mon, 14 Mar 2022
 11:03:13 +0000
Date:   Mon, 14 Mar 2022 14:02:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     =?utf-8?B?5ZGo5aSa5piO?= <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jreuter@yaina.de, kuba@kernel.org,
        davem@davemloft.net, ralf@linux-mips.org
Subject: Re: Re: [PATCH V3] ax25: Fix refcount leaks caused by ax25_cb_del()
Message-ID: <20220314110256.GL3293@kadam>
References: <20220311014624.51117-1-duoming@zju.edu.cn>
 <20220311105344.GI3293@kadam>
 <4364e68e.77f.17f81875881.Coremail.duoming@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4364e68e.77f.17f81875881.Coremail.duoming@zju.edu.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0047.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::8)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 445fe32d-1919-48fc-1571-08da05aa3bb4
X-MS-TrafficTypeDiagnostic: CY4PR10MB1958:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB195891D983D2611EB98CE45F8E0F9@CY4PR10MB1958.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lku3yj6EwWoHkWfWJt7wO51UKdmq48kIYS+a3UTVobFfTeXrqC8FdT4qUmnRkaVjoDjtORn0uMG9ByPAC7CCIiLioJLhMLY+GmlddxS8GlfnaGun0j6RK9opsU9Blm3UFPOfieJeXaEYyAHEDhqS+PJ1PqPSDbQur9gtOAAXKOklbzmaaWIIfEUSr+5p8ZrpVkKQyWxukT0KtaKka6VXnRuIRS0dFGUMX0mSGjIDQNs9ijHxIA3N8Rbsztjbc4tb/BN/rqpf4nY0ePmQmo+tfUreBQsnliYquTYeJV5U/+p6iXS2FraB0w07Eh+GS5P8X/ajFcTkEd+56O+y0FOslUqbdTjR5Be2QXNWrxBdtFnCR616CjzyyndKIHHNG6RJ0l+5qP6A/ne9bFBiCorJtPwbfLYlYE0vr86qA+s9MxkJEZnfpTI8d9YoVBeH8Hql/rLismqyqbkqEXEkaSU+ASkf5Tz1gynzZjTxDHUbvwpluTmoSeYuTvrpwaRhJy/W+7EDSLZGSZtiYrsqSbVSqXZt4EiK6ET07BjyZ1ybwnwfYgulDKFCjh8lmP4jZxGu2U9h5lL/oJhqUVCDTgilPG7S1t+1zOFJ70dRJcjbMXPb8o8vV3docha5MMufEQ9t0QKnX6JDza77HVeFfzRVRHeKdgcCVfNCzBXGHUkvdDhMvFxuoSmgU0PaMhhpjqPjqyWvdl+rPwKqiEAM/zFu8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6506007)(8676002)(52116002)(33716001)(8936002)(86362001)(6486002)(6512007)(9686003)(66476007)(66556008)(4326008)(66946007)(44832011)(33656002)(316002)(4744005)(38350700002)(38100700002)(6916009)(5660300002)(2906002)(508600001)(26005)(1076003)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clBwS09MSi9HcytqbUlEZTJ3M21oZDl4NWhkekplYkJLaTBlTzZ3SW1tUWlN?=
 =?utf-8?B?cFlzZGtSeWFjMlZidDRsUndieE1SZFRNRFpjeDE4RjN2SmZ1amh0bW1qRnlQ?=
 =?utf-8?B?d044TFRIVTN2TW9uMUlnK0dyamlYS2hZQzVvYjJxSG9vWVpXWmxQbGdQRDB2?=
 =?utf-8?B?N0Y5elE1TXRibVVyM1hVUFliZjlhdGE3cFA2d3FPZ0lJNVBCbGROLzFJWll4?=
 =?utf-8?B?UFJsSXZvazhkWG9hd3NZalFhN0JiL003dEhRZWR0QnA0M1RwaEYyYjlqSzBW?=
 =?utf-8?B?OHdwNGkrTGt6a1lzTGthM3JIazV0OTAwd0I3SkNheStDWk9VeG1Ya3BBSk5B?=
 =?utf-8?B?U0cwZVZFTnBxamNyMzNnWGEyL2UwMmoyM3JCSU5kbmJWSjl0bHdydURDQVhE?=
 =?utf-8?B?ck1McGg0cVBGcmVwcVptcjZETVpJZlo1QWFtTVIrbDg3SHRocHJ5M1FtblN3?=
 =?utf-8?B?ODBUdmtOdStTOVY1MDFlYk9XTU1ZR0ZvNllxbDlkWmxocVNZU0lZOWswbFR0?=
 =?utf-8?B?elIvZ3pKdjdSUlVVYlc5cVlwcldLelBwclRzK3pGdzZrMFdob3dabW1hN2lX?=
 =?utf-8?B?ZVBGZTlQcWNHTDEzMXhTMThHWmRPbDZJY3NjSzh2WWlJOWFPK2tneTNvZEpQ?=
 =?utf-8?B?cTVHRnBFOXA0K2V0M1NoWi9Kb1NFWGNwY0JQSmpJem56NTZEdmp0WUtmd2h4?=
 =?utf-8?B?eHB6YTZzcVdrQ3NRSHBoTXNwMThCU1pwdTVkSFNkdVNVY0xVN0VMTHArRlJv?=
 =?utf-8?B?QmNoMGdob1BkbCtud01sZG9wbXA5QkxORW4yNjNsZ1N1aDN6bXhKSkJPbWFx?=
 =?utf-8?B?VHFVMzRzdEpJZXNNUGI2dGluUzJqbFIzdFFYY0ZjdFFTRCtpdU1TS002UEta?=
 =?utf-8?B?MWZQc2g2QU1CYm1SajlPTkdCU3lQQjBCTm1HOGhlN3lCaC9ObEVoRFdJLzdI?=
 =?utf-8?B?U3ZHaHljUW14dFdwYlAwZktmUXo2ZllGelFDSHJWSUtiT2c1R3UzRHZOdzhN?=
 =?utf-8?B?bVhIRzh6M2dwc0ErQ3RXalg4bXdGZm9TZXJXZUJaekc5L0lscUIydTlOb0pz?=
 =?utf-8?B?Z0ljaXQyMEdzVnFDOUpvVG1scHowbmx5blBaa3JFQUN3SksxMUU4UEE3dzVC?=
 =?utf-8?B?MDJ1a1l1UDVTZ0toN0dXUnFzWkd3NnFNSTZzNjFPWlZodnU3bCt3NVZtd25j?=
 =?utf-8?B?R2VUM2s5ZkVIZHZETTZwbTJDc2cxVWEvSXE0bkgxMlMvNVl0a3JiV0VBVEpG?=
 =?utf-8?B?RHJlNmlkaThvdGVxbG5XaWw1WjdzbmpMNU8rdWgxR0t1UnNTbEdzK0NTdW5H?=
 =?utf-8?B?akIwSkx0Yzc0RFg1WUpTRDZ3UGs3UWtuMmRndU4zMkhIV1Fub3BZU1kzTDZ3?=
 =?utf-8?B?OHhmdzViekhxaU9jazdvK3h0V0FjUThtVmxITUlpSFJFWmYvNG5YN0w4YXNv?=
 =?utf-8?B?dWhhR1oxQ3NBak1lV0xvb1BhK2xZM1hIV1plK01jZVRJZDRtMmp2S3VxVi9D?=
 =?utf-8?B?MGpOTzh4S2JzOThpR0xnWjV1NmpEMU5IalFOZktuYzUvSW1sSWQ3VkZoOXJr?=
 =?utf-8?B?czBlTkh0SUV6bUpmRHU0S1FHd0xWV1k5NzJBZmJFek1ZV05GL1M0TSs2RVZY?=
 =?utf-8?B?L3R1WG93TVJwSUxIc3AwNVNPVHRRMGlKZCtSazNhZzFFRnIreWtXTHU4N0tH?=
 =?utf-8?B?bm01SWlxNG02eFZ2WmhPbWRxZmRTc29VeTdIelE1US9ZTGZadFBGdHhtR01E?=
 =?utf-8?B?akJZMXl1RXB3Rk1SUDVLMzJrVENrYStuanB1TzA0WEIzeWtLUEtDVE1qR2hq?=
 =?utf-8?B?MjZvcyt2V2RNQVhkVXQvMXFTQVRBQklNdHVjYmRqMk5kRDNpWW5qR1VPbEhK?=
 =?utf-8?B?anZ1T0NjZkhpZVVJMTJEUDJPemJFVGh1TkN0Rml0MXk1SlZjU1ZlQmYwTTBy?=
 =?utf-8?B?VVZRYWw1Q2hPNUhsalpuVzlXU3JvVjFSL2RRbC80emJUMzVia2NodXlyTk5j?=
 =?utf-8?B?U0ZHcVl1RGhnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 445fe32d-1919-48fc-1571-08da05aa3bb4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 11:03:13.3551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mtNU/WLFpZ32tyP9sPINLBcq7Sb/rBg1xQlG2z27gQrFOloK8kOTOjKxPTVfukde+MGgLIepfEjjI8i4O881uR26YGZrcaBhLMdjIVRAh20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1958
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10285 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=866
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203140071
X-Proofpoint-ORIG-GUID: d9PkdMr6P9nnSlGMK0XdBEkvCzMdImCq
X-Proofpoint-GUID: d9PkdMr6P9nnSlGMK0XdBEkvCzMdImCq
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 13, 2022 at 12:26:45PM +0800, 周多明 wrote:
> Hello,
> 
> On Fri, Mar 11, 2022 Dan Carpen wrote:
> 
> > But even here, my instinct is that if the refcounting is were done in
> > the correct place we would not need any additional variables.  Is there
> > no simpler solution?
> 
> I sent "[PATCH net V2 1/2] ax25: Fix refcount leaks caused by ax25_cb_del()"
> on On Fri, Mar 11, 2022. Could this patch solve your question?

I had a bunch of questions...  You just ignored them, and sent a patch
called v2 instead of v4 so I was puzzled and confused. I guess the
answer is no, could you please answer the questions?

regards,
dan carpenter

