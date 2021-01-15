Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84ED32F7181
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 05:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732855AbhAOEOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 23:14:33 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54850 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730587AbhAOEOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 23:14:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F43wEu022473;
        Fri, 15 Jan 2021 04:08:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=utqJ3OFh7zIH8ttpnNtnhZGZcNRU7waPt5+v1qsQg1c=;
 b=B66esj7XADaqBds23OknpEan7/Q7hb1mFmmQQPDfJ+54rRAsIagpq8DiyRMDwN129ZNS
 JczXxBKorTVboBC0VG9OZimAATgxPERJE/QvQhc3Jx/MA24NnM9nHQ2TyBLSwyHhrv7Z
 1axCYPS94uxvipWiCLcav6EU4FSzVoRTtx8jqymODI97cgB2mh6xUTxaAN599kj8YUBT
 040R8z6R7UqpeSvQW95MZopi8E5IJIliABRo4LEC5JnH7y6H1N+07PSv2c49fffaxdfD
 01F+q2wuHJFGyWIBvsYpFLxDyV5aPgVFai0Qtnr5ZRxRqSUZRb/sxjT31RcUEJNfzThW IQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 360kg2398f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F46eX3094901;
        Fri, 15 Jan 2021 04:08:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3020.oracle.com with ESMTP id 360kfagp6r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWNxIISVarqknut07uV2lQOkjZPxsI12y47ZtPgwRExAwHsC3vSoRqIvMpwqhF19r4PqRLXLIYhohHKFjDhUn/X7KmLzUaSacESsoTV7aT5J33FKAOv5tNWsSnZ4w58mgtEbmY/+JoT+buBOU+HRMCVEwuNzKK8aeLWAslBfmkXV/9TXUh1ai8HbuyZqV7EbO8rjaZBOJn8tXYpB30Xje8G3E3vFmdh7si9mGSriVwZKMV7cEj3lFyq4plqe3KE9mLedcI9RBDFQ8j5Gu0bAHzzQ0k7e3+dJTtTTXqsO+pKHAHlDIKOhahlrzG7QgcCgCQ5ZqvLcWaNOxInPupritg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utqJ3OFh7zIH8ttpnNtnhZGZcNRU7waPt5+v1qsQg1c=;
 b=VrBQ0ytL70dPnGyCYkxmrKtttxWwLLc4LFyBHvV7QNBBeB1xGvh5sc0aaQbxQ/uvfGllli01sbD13zIO0NVrFW+CyHza9BCdaqIPX63zfdvdbKAud9aZFhofK9ah92r6MISotidn51U/RHA1ulxJVSTcBp2PUdfMzTnBt5zf5IMm9llHuXL5/YtIRMqgNb/b5mLg7JyVVh7LqVb8hPfSpejlUb+S+7ieUaUNrhUGl2ugfqfXMsLBludRlhh38iHd3cJZzkkzvLGUphd0ZLMBxgUsG8vwmA2ietNDsf5Io44IEsjTmPkNwPb68F2DPRdaT36sO1KVKEadQKT5+qa7qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utqJ3OFh7zIH8ttpnNtnhZGZcNRU7waPt5+v1qsQg1c=;
 b=NploTwc8epstrt4CWvZac/E5zuTjeVbZ8+bRkigispQ1duSi3FQLxZ465zljzQp3Q+zeo4ha3jWEeqFIiRwV+aZjJB1YNrSofPQgi5WtNa9wqXkflO+3LLgnwBeejf9m8QvVRHe/x9awcbGy9femPzVmirln33UmcDCAHq8BEuY=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 04:08:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:08:37 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, YANG LI <abaci-bugfix@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux@armlinux.org.uk,
        jhasan@marvell.com, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        skashyap@marvell.com
Subject: Re: [PATCH] scsi: qedf: style: Simplify bool comparison
Date:   Thu, 14 Jan 2021 23:08:20 -0500
Message-Id: <161068333184.18181.18276169069487451125.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1610357368-62866-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1610357368-62866-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN4PR0501CA0139.namprd05.prod.outlook.com
 (2603:10b6:803:2c::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN4PR0501CA0139.namprd05.prod.outlook.com (2603:10b6:803:2c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Fri, 15 Jan 2021 04:08:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6902877-97da-4f73-9da6-08d8b90b3bd5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4568FCA11289407AC36C58128EA70@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4qng4d6a/WrwEBID0y6WcSbIf86ccPGLgGTbUdSV4KDLuwf3NfXYYWkq2LayJwaz0hRo6iXIwdeulZ6pt2D9qRadRxudDiHfvxDRnGbJDWeUZR+y6aJf8KY5s6woDiwtNJ08Kvm3kFrOsmBh1SY/Qtrq87/aO2nbuBYUQQX310lImY3MHbFHdx9w0w11OSV0T4pLi8yCdaaBt+NM3NepSygerIfwIgFaVOO6GW/UePPjYUENjF8ostQlfevISvGCAFY9moZloY/+VmlNp+tQtameVQA9UzfzLADCzy4G553+n8XF8Qz9xYR8aBFXFhxGeqggthSSegTmwFHhjA5CA31ahTjiH8JHE/EuIjhdT0xAgT+SMjbNkOCkkd5OqJio4mpNGsuiX9VkI4xG8deOxcbKuTQPndq9yXoSOq0sb1iLDHvpOYDPWuTm7kgObCkPIdbb2dVZEwOy8kkLv/HZ4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39850400004)(36756003)(6666004)(316002)(4326008)(83380400001)(6486002)(8936002)(2906002)(86362001)(7696005)(52116002)(8676002)(103116003)(966005)(26005)(66946007)(4744005)(66556008)(478600001)(66476007)(186003)(5660300002)(16526019)(6916009)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OFNGaTloaG0zRnQ1UFY2NVJkUTVyNS9UV1Ywd255RUthck5Fdyt0ZDBFQ05X?=
 =?utf-8?B?K3JxbzBKU1JIRWltbUhaQTIyUE1oaE92WVNnYkp6dmIrMjBwUkx6NUhOQWNY?=
 =?utf-8?B?UEU1TU1iK3VIeGltWWVCWE1uMjVqdW1qSUNqUG1PN1pESEJ2bktNcnFLYStP?=
 =?utf-8?B?Z29YWFhhbDNyOE8xQmdweFppTlpBQkNJQ3p1RGpVZjlTVERSelVmM1ZVZVo2?=
 =?utf-8?B?Z3Vib0V2TStsa3JPdUlFNFZjdnA3Q013OVowRmFhZy9aSTk5Tk1jNHhvLzlR?=
 =?utf-8?B?OCtFVkdycjR0S1VzVk1zSGlxSnRvQzE0VDJ5Qk95a2gyeWhZdUczdVVpdHd4?=
 =?utf-8?B?OHJ4YUZaMDBzclRWcmhNVVlDK2FLUkM5c1k1WmFXVlBqVmJXR0pIZWVDSlNW?=
 =?utf-8?B?TCtDTVk2WnRCWTBxc29qcURJajRHRW5XSGdldHppOUdXYzBsbVRKdjhzdTRT?=
 =?utf-8?B?bGhzNFZzRXA0ZmRVOWhManJvcGhoMkN4c1NkMktwb21ncytlY25sUllMMG1k?=
 =?utf-8?B?RWFpUE5zbU1aUGJmQjFUK2VzSjQ2bUZhdThpYTRia2hNNzFYTGx6TWpDZXI0?=
 =?utf-8?B?VDQrZ2pCaDh5ZmlucFNIeEdBeW96R3grTDlqNGpwTk5wSENnZFJwRlJ1M0dR?=
 =?utf-8?B?bzJWS1hyckZJSkpvNFpDcVRSVzZ2UWlXYWFvbmUwQjdnMlpZMkZCRG5MTGdV?=
 =?utf-8?B?LzE4SEc5RnVEZ2Zzc0tRNFhTbmQ3VDNNaWhxN2dFOVQyWlc3eTZSeG56NGo0?=
 =?utf-8?B?YmlxNk1yalM1SDVxQXBRL2RuYkNuMGNVK3o0N0pqN1hjK1pZWnBSRUUwV2RG?=
 =?utf-8?B?aTBkSTRqR3RWZUE0RHM4UFhUWmVKZUpEcTJrcmFKcG5FVXlhdm4zSEFlK2JY?=
 =?utf-8?B?cGxCaEp3MjhYQ1BuQ1pYODM3Wi9MZnU4ZkFFMTFReDhyQUJ5TGkzS0VWM3hs?=
 =?utf-8?B?SFdtUGNycGhtRDlhK0ZySWxEZDJBZ2RqRkI2emhBY0tCcHREc3RCVHZaVUtr?=
 =?utf-8?B?NEI0TStpcTZrUTJheVV1MURsWnY5cnZGYVdjb2p6K2F2VWMyVVBndnFTS0E5?=
 =?utf-8?B?d1phWlBqR0RjeFI4RXcxdmdyRTZaQTN4dVMwZEpySVhQSlROaVorZVVZQ2xB?=
 =?utf-8?B?cVZSajZyeENsVjBsbTg1T2VlaWQ0QUJFbVlsM0ROVFQyeERZY0ZsYW9aNk92?=
 =?utf-8?B?ZXg1VDQvaG5IODRzWHp2MUVHd2dWVlZsZExRRVVTR2lLMGVJSU9pYW9RYllo?=
 =?utf-8?B?V0VGQnBCYjFaMTFnSkFkUFNhWjk5Vlh6amdrWHhwWENBaDE4VHAzUW9yY0xH?=
 =?utf-8?Q?3CplVsegoenIM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6902877-97da-4f73-9da6-08d8b90b3bd5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:08:37.6292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Kax6enY/cN5E9aykySCJfVHqVUB+57ykq+hDsv+vMS3bMWc2vvPs8Wj+WsLAEPGTIWfOfvL9KLLi9C4MyzxbiaSpXAoNivGSrTMCwf/Op0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150019
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 17:29:28 +0800, YANG LI wrote:

> Fix the following coccicheck warning:
> ./drivers/scsi/qedf/qedf_main.c:3716:5-31: WARNING: Comparison to bool

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: qedf: style: Simplify bool comparison
      https://git.kernel.org/mkp/scsi/c/ac341c2d2f1f

-- 
Martin K. Petersen	Oracle Linux Engineering
