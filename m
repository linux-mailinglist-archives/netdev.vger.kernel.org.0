Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8BC3EBBC7
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 20:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhHMSAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 14:00:25 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:51246 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhHMSAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 14:00:23 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DHp2sU014126;
        Fri, 13 Aug 2021 17:59:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Vu3d5mb3oDlivA5XsSkl4doPRKTTird1VEI59mxVoM4=;
 b=Yt6t38uibs8PIUssZBn0tLhY3I+fUOrEKQ82FCYh4n09PDXoyj9JB6ZboyswRPA44HzM
 Fony2Zn29nfXqkWK1CTdUQM/44sCmpNzchKtZSXzWdAuRiJoxbJbhqqhrvnBNbOYVfrP
 7cvY9eqHBZ2rHhQ5znYiA1SFPOrolPrxa3LJYoVP+3hXKOGbhrRVzZmt6SL1I3thDZlw
 HVDysqKKq+FUd867H4x/Te7BDTV0/Hq9p0Wg7FLqXz5lZMp5uqkvqBREr+dSHfA/Dukc
 ee0jLmRQ1iu0f+rbq+l30evrwNsg1JtQJA0OWQ+ySPPQh6UevDlCGoKKLJqVvYkQU2Ep gg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Vu3d5mb3oDlivA5XsSkl4doPRKTTird1VEI59mxVoM4=;
 b=dlbRJOVPG68XlP4WQU/qeeqwWfzGyXRNYBT2LZpBSrcyKMIGESrjhASNHUymh1qfO5Pu
 06ZcQKIzhrM9WHchrU/AfotvC0XXretBsVgngN0V31xqyE/r6Rmv40K9hCn/USCKg8q2
 yNwhDKVZaSKYgNwnDPXXazACA+jQLOHxVsIYrAUW85mVmCPkBFwNptr/N5mcIoWTJyTV
 1bP7S7y4NR0GVpJ5142JL4gF/AIUc96e5mgbZ+Mg74ZvlKyk4hm5bI2+SAMluyXiEZXh
 luYwdlhFM39pZ+58Axh0bqzbqXcsMjkTC+SMG6tNAhD/n7bNBtHIqIx1WEaXu0G7HxCM SQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3acw9p40t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 17:59:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17DHoT0L053097;
        Fri, 13 Aug 2021 17:59:53 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 3adrmdj6dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 17:59:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjOaQ084RH+LTHaHQSA5CggMiLIr4u7N+a/mIlaBFUoRbQBEHAi7UOY7xqxhqA6TlWzKtKJTSQ1HWDBlq8dfLNRZi/tklCBNEy5WR7TwGnQhCQrppUuaPEuYJJuJCO5H9xakGzMy+JDjnN+G1KjG93q7mz1mFV99MRA9LGHxCQXX4CKRMnOdfOg3RkFWo3vPAuYacksPlntKhJDik2LEYDVOlp3Z9owj4KLOsDCtlvUs2Hb+WRVYXxnMxyS39SqbzUB4fdbVAzGHHLYqwjc2i9nqiNCzy3xN3qQV6Hwr5hBz5S00OQ5gEvA4RhfOArt9+u4gGRaZvTmjcniTiJLeXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vu3d5mb3oDlivA5XsSkl4doPRKTTird1VEI59mxVoM4=;
 b=SPETNawzM3bqDFXr16yHwNWk/qDRKAVGCQCQVJWhJnY+HdaQe2uOzYZu8bZMvWaYRUOhbQRdIuU2BOUfP9usnfQCLCVy/AkFlpfvHrrO+6nQ3YpSXiixnlRR/1Qo1mzg/rZhYiPpoOOnHLsqVzjTqrflb2FjH4oLP5WUmY6K0jFo24qfwZ8/oyGqyw+gTR1n8AbP0nJ8+nrM9+3nx0OyPWiAn/IU0bRI0THhhr682nFFHgIBP44wlIRiaZ5cAhGcr0NIUgiRoONaHA5Wsj/4MInFAlSdXwmQZojKDJr3O+LyzsYtRU5xz8FOm5ipu8AA12PaijZk6X1baahbH6dW/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vu3d5mb3oDlivA5XsSkl4doPRKTTird1VEI59mxVoM4=;
 b=QgJBs7kF+MNW7JC9hbmNNomdg6fEM1m3wcanBUuHxJuowfrkcIQuSLWX7YMdIarysyC+9AhCRI4waRjuVhIk/znqbJJ+JJbsMGLTmhiVgiorK9fD+cykdgScf0llDCIY7cQgwr65YK2aiG+zANisn5iqbOVlj7v09j7Mdv8fLko=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BYAPR10MB3413.namprd10.prod.outlook.com (2603:10b6:a03:150::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Fri, 13 Aug
 2021 17:59:51 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%4]) with mapi id 15.20.4415.020; Fri, 13 Aug 2021
 17:59:51 +0000
Subject: Re: [PATCH] af_unix: fix holding spinlock in oob handling
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, viro@zeniv.linux.org.uk,
        edumazet@google.com
References: <20210811220652.567434-1-Rao.Shoaib@oracle.com>
 <20210813103243.51401dcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <22dabc0a-7a2a-db34-5727-f79503594850@oracle.com>
Date:   Fri, 13 Aug 2021 10:59:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210813103243.51401dcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SA9P223CA0026.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::31) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:7444:8000::7de] (2606:b400:8301:1010::16aa) by SA9P223CA0026.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17 via Frontend Transport; Fri, 13 Aug 2021 17:59:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3e57a64-cb92-4c0e-6919-08d95e84260c
X-MS-TrafficTypeDiagnostic: BYAPR10MB3413:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3413F0C24E2D67DB965B4267EFFA9@BYAPR10MB3413.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mI/+tHmcoTb6I8btYm9WoKwxkCnYkgyTeAQUpYpsmxO6GnZKB83IoIfDLsU9H5CgSk2Fagf1TT38CL0ehieTclMpZue/MY7giuS+h3a4lwln0+esgsFunASS6YrnlkRu4Qp1yHgKx/uEGLGw8Bq7qvhNSiUsO0fJnUlm2QjvXepf3x2GrGh37+u5l1pENHZKsP+vS2Wdx/u7L6HoAe7Qphbggk+BORkKkyhktMvdjl4d7j1Nb7ep+od0xdEeVAQRcIYMiDopFA0GYwfKUyq/UPRkc+PxdhNFO+ZZV94dABF0EkUW2QligA/TDAat5uuZaJ2hjnPgAfBEIcmd0PznHwUfsbkTtcgIqEeDci/OUmQtiO98nsnxqaV0YFlTL+md0S22njcdDYowvlGAgfWXM/m2zC46kGEc/AOYWjY6Wf0dbJtVaWE3xb8MaDzfeIzQD6s3K5b7gXe4023qBPa+qSke6HOoMGHiRKiTva3Yab8ZDMD1IxDc5RwlSVayymbNB6Fot0gmO7CFePjBk95whLLfTdvUqd8BJ6EDegTWy2Cjtk7IGfJRYWK2H8JT7Li9oZ7yTmoWDJtLM4RASgP+q1xZiA/Yniy5qaczk/VMpKNt+ELYPrenn5KdWVuqmHlk4Z5Ubxesdd1h6pWpu7oO9wh0SLKnT3sewII/cIM0R/urnWr3/oH8l6rSCRBi+TD5e6nSf5//4G0CGrpUR6/3yVL7hWGRSVa7BH6QtV5WlgehwTYf6Y+rmXuNZRu55KqR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(39860400002)(346002)(366004)(316002)(8936002)(4326008)(66476007)(83380400001)(53546011)(36756003)(4744005)(6916009)(66556008)(86362001)(31696002)(66946007)(2906002)(186003)(5660300002)(478600001)(6486002)(2616005)(31686004)(38100700002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDJ2b1Z1cXM4cHMyM2kyUUwwUzhFVHc3NGRnRG40RWxhV0dOdkhLd1poTlZa?=
 =?utf-8?B?UWxkUVExMU80VlpraStlaUJSdU1URzFSL2huRFJxVG9aM0JEVjhyOTJza0RV?=
 =?utf-8?B?MXJFK1lSbnpYbUlYOC82cHJabitjcjBRQmk5a29DT3Y2VitSbjQ0KzFxakhX?=
 =?utf-8?B?dktNUTNoWXMwR0pSUG9pQWxGN1I1VXl0WUVuTU9mY1FqODZncmZYMXZGb1pT?=
 =?utf-8?B?elRoRHlxVHF0cW5XOFpDakJlMEtTcHZhUWVIVTRUTzZ6UnlDSVVVV1RZdmhs?=
 =?utf-8?B?OE45ZUEwVUNWQ3FhUGZreXJOKy9sbGRYeDdQTldCaHBOQmI2dWppclprcG1X?=
 =?utf-8?B?ZFNFL2J6SnN4eFl3NGFxbFNYWVE2RVBIb2VIZlNPZXppY1BvVytkdit3SHMx?=
 =?utf-8?B?Rk14TC9zOCtXV3RHVytlT1cwdiszaU5xTytteEhMMUxZZktEUmtGZThLL05p?=
 =?utf-8?B?VUQvZVRtMmlQdWxabmRUZk5wb2JIVHV3c1M3OEhPUDFpeklFQ0g5cWtEWjBZ?=
 =?utf-8?B?Vk9QTndTR0EvOXF4dkxGSy9GT3Vwc2s4eUd6S2x1clZSLzYzUG1zRVNqUkdy?=
 =?utf-8?B?YjdaUWVUWnNJSXF5S3BQTk1pekJBak55TjJpc2JVclM2ZCtyb3dzVGlGdkpL?=
 =?utf-8?B?SHlCY01rOVVoNkNWZnVJVEV5UEJnTlZ6M2FKOVpoTHZKRGN5REZCQVRaTldI?=
 =?utf-8?B?OFVJclZqa2Z3RXlCdjZHWjd5WmdvZnA5ay9mSzIzOHc5L2pnb3lxNW1id0tP?=
 =?utf-8?B?VHVIdkJXZHdWTldQYVoyRHBHSHlBTjZZamZ2bDEwOUI2NDZSMld3MmhncTJT?=
 =?utf-8?B?cm44MVZDNUt5SWhWZVVMTFFhTFE1YVpzTmJmbld6MmErV0FRYnFBQVRkL2lX?=
 =?utf-8?B?ak5Cbld5YjdGNHl1R0pLelZzb0RpQjdTYm9qQ296WmcwVlBMYmdLMjNYMkZJ?=
 =?utf-8?B?TGROMmJFWWxneEFhMURaY0dQMmxmYkpvVTQwVmJwSy9lZlYyL29HWkY0NXNX?=
 =?utf-8?B?cTl0MFNkTWxLb09xb3pPaTdEM1ZHNThCQ3VjQ1J0UXBFb09PaUVYODBTSzJo?=
 =?utf-8?B?eWFEUUl5TnBNei95VzFtSmFDWnREZ1ZZM3pGU1FrQXYxVHRyVGNOeHVqRDA0?=
 =?utf-8?B?bGl0RFF1RG9uUWRFdjZmM3FodzJrZkdoNmxNamhoTE5qbExTZGI4cUJEaGZr?=
 =?utf-8?B?aE5CemU0MEFwbVkyME8xZjhQeUhRdUxCTkR3SG0zZmE4TkNUWFNnc0tWb3lH?=
 =?utf-8?B?cXJXbCtGVm9Kb2FNV29YQVVrMTJlTkZJRjlYMnhHQktpVzVKd2plNStPL3BM?=
 =?utf-8?B?VjhCV0huV1RPV3lzbmNDOEVRUERmZkhzVFVlZk1MUUFrajdKNXVLL0NRWnpN?=
 =?utf-8?B?TEluZ2IvZG1KVE5sUUVCellUNG04Wm8yYUVNMWFlQ3V6YURRcnhEUFVweG1z?=
 =?utf-8?B?QjBEZmFaNGRHVXBuRWNqQ3o0enVLVzAwNStCMUFKQ1ZzUk1mMHE1dEdsSm9t?=
 =?utf-8?B?cDdpM2V6Z2F3VFBkRmRoTmp4SWU1UDVJVk1RRU5oeDlKSnl6YTBRNXU4UlUw?=
 =?utf-8?B?MGU3L09Ub2NhZ1hlOXo3WFpVU3JrU2o1VzRiVFJ0OHlyeHpoZ0Q2dytudHdY?=
 =?utf-8?B?NFJkcXc2SEcwNzRtUlZRcHhsZjREbkZQcFlIczBrcUIwaldjbStxdy9hVVdB?=
 =?utf-8?B?cWNEaFBlM0pnQ25Nakd2SFVPQXo4aGRsM1FsNUFSRmpIOGlmdEtmSVNwWStD?=
 =?utf-8?B?MnQxRWI1VDhyaGpmSVV3MHBndEp2akJLY1h1TXo2eWlWWnBxOER6NkY0L3pV?=
 =?utf-8?Q?omh/hRaVEDgxK5cSRS/fbg8ixp5rbobJv+86E=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3e57a64-cb92-4c0e-6919-08d95e84260c
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 17:59:51.7812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ivD7ln4I2bmnmUVRguBL+bolBbozns7Ms1JVZpzEyKloTMuLC/43eW42UA7bxbOvYSpvStTsBMadf42+vcBNVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3413
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10075 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130106
X-Proofpoint-GUID: T1zSm_r1KmXdAgmlAr7OlzuDeo27uXdp
X-Proofpoint-ORIG-GUID: T1zSm_r1KmXdAgmlAr7OlzuDeo27uXdp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OH, I just sent you a combined patch. I will resend it with just the 
nits pointed out by Eric.

Shoaib

On 8/13/21 10:32 AM, Jakub Kicinski wrote:
> On Wed, 11 Aug 2021 15:06:52 -0700 Rao Shoaib wrote:
>> From: Rao Shoaib <rao.shoaib@oracle.com>
>>
>> syzkaller found that OOB code was holding spinlock
>> while calling a function in which it could sleep.
>>
>> Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
>>
>> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
>>
>> Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
> IIUC issues pointed out by Eric are separate so I removed the spacing
> between the tags and applied, thanks!
