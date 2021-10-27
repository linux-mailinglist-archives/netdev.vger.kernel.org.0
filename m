Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6030643D29B
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236779AbhJ0UPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:15:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:45968 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240863AbhJ0UPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:15:19 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RJSdeG016773;
        Wed, 27 Oct 2021 20:12:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=2OKQ5MsVen57NfWO8ms7X2vGKNF3o5XqNHu4PyQcoMI=;
 b=q5vbY83RtrYFF7V7kO/eYMMRbq6uThtb9h/L0ZsIR8wWoZ+aGamLBQ2+t+bZEVwnWPkr
 1oJ47OXVA89QmXNzNgwGRuDaTzBB0sXd8DQ7YhpNnGiMNcPh1KEcMGqEZ96sHbs10vR0
 xopRr+nP+xVDuHvdppDr3VxSn5Fnvn6YZhGG5ptU4hA2o3JuIUJxlInAtox3l0+3KCf9
 Hc0XfqGbzwOoZaUtwcEPmT0pdXb8M+YWAHuFULQSnzv7SGdSSFQCg9mXM1teIvYR9Xv8
 djN9tlS3zupXYGu2Xdd7vVMG0kvCsM4yF3vPcnTbGaX7Zve/yTW4CWbZdbCs/gxXyN7k aA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fyn0y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 20:12:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19RKBwdA059962;
        Wed, 27 Oct 2021 20:12:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3020.oracle.com with ESMTP id 3bx4grnt7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 20:12:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lf2AJ6ZGOwPYbl4c8J9pXRkf/DuZATMPMS3DK27sm/iSoQ6/DKgjj2dR2NeFtbmRHTYDdBNLZyY5meeirZVpB0SjV4eLQ8YTZnsOuSBxQ88cV0ufCyvT+fV+fTeKbUVUSCHDqmaXIaa+x0UqusQeGgxX3w2O3QpKRqD1H/lDz1xkDi/WzpNYEbJFPzQzstfaNZ6lwBF3NJzWIfu1GAOv/adoEiDg1AZSUQ8g4LCy/a4O4F2OkadhpQMerr4JSvwu4dBoa7jP5O3t+74W7TCz/PPDfq+zXqN1/kuRXEMB6/Lj9W43dlUpoFTBafnLGR2YCajm5zG5dJb6wtBd3wArVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2OKQ5MsVen57NfWO8ms7X2vGKNF3o5XqNHu4PyQcoMI=;
 b=KJhXJBOuIcT1EY8K73ax1rkZp/dHkXV4cs66YtaPRZgVyYaYfsl1Ird1aUvkAN0bU1Z2TjHbUQrWOsJBr8N0+L9TIaXssTCE55hLt9gTeacsCeYFIPzf5NTEPUacMGxgwp0iBxRxhyPcQe73SaQywvotDPh9LJaVTd5IdwB8kcGAGIlyupBZ8PqgpIJFFDuNK+cvqMb96TkgfE17s0k+hp3wBttmf033j0lrrnOc41Kvf5n889WraSynG6OG9QWS2FXPUMHOfrWHM6YQpkG6+WKhmEufY3Flfh9UXs5cidmZ8B5aD3byFjC2Hi2//gbU3iYium/hozrzZcDA84R/lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OKQ5MsVen57NfWO8ms7X2vGKNF3o5XqNHu4PyQcoMI=;
 b=DGlzbOlmmHJTZHvaRSSZe6umcC4lFGICSPVmkCvxGE68ll8SlzOO3R/IWCR/BSIQ8+6okF2TiTjkZgSmh0mGolHYvkAderk3gFcwFIKIc7X9mPj3e3l7srZE8hxLeowy+WoTjuTmv4w4LmCaefSsIEMToMtnPLprIa+mAwi4rJs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4345.namprd10.prod.outlook.com (2603:10b6:5:21a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Wed, 27 Oct 2021 20:12:42 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 20:12:41 +0000
Message-ID: <da656ae0-eec3-88ea-9ed2-41740608c691@oracle.com>
Date:   Wed, 27 Oct 2021 15:12:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] vhost: Make use of the helper macro kthread_run()
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Cai Huoqing <caihuoqing@baidu.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211021084406.2660-1-caihuoqing@baidu.com>
 <20211027160010-mutt-send-email-mst@kernel.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20211027160010-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR19CA0036.namprd19.prod.outlook.com
 (2603:10b6:3:9a::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM5PR19CA0036.namprd19.prod.outlook.com (2603:10b6:3:9a::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 20:12:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 567454e5-59bb-445a-ef70-08d99986216e
X-MS-TrafficTypeDiagnostic: DM6PR10MB4345:
X-Microsoft-Antispam-PRVS: <DM6PR10MB434574907CFC192CDF666681F1859@DM6PR10MB4345.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /fsFHgOVXDBi46RmzixrasOtEPOEFMxYif09+SwtjPYVvWX2dH2WP67/E1L7YvGm1/u5TS0thaorEegc5wDW3JPMy4l4Q/xn8m9A3AhVad+bkwfpriRDtVshfuBl4SViqXDvzYPTVFtAMEcLUeJ8Cpd5Y4fchUe5xrdPXn9POlJ2K4M2Wvia4kDlmRGs5wpSmQO7LnCU43WoQwy57djexd6dOxGdbaPLVwiIeX46uHnZdpsSKEZcXqUn0B+po8f6HbfrbBTnjJV/gvS6gP7zNkYTaD1errU9BU/H0gFXpOogHgNKaXdu7TR6DidxVnrcbqbJA7l1vmTQnmClcIBFRDnItBAATZ1paCKJDSRbrSnjDirNzYuxSM7pIv79usdPiscrpJNLS0l3tWxEUcYVqlOpaGikysRos46OGnQHugtKF97iwKkqg+cZ76ofUD5YcWv+ji1I4wlPP7iIOSUmAkAVTkyMZYudxuSxBw4mxCoU5G8elVHfer3AvxBXiSTIuolRf1dcCMwlmgfFkpuWPiQEiEHqJSm1DOEf4xwgFbX5dUWm53doPyIUDXFH3AAT011hE2YIAkyA/ZT4zqRc0CI8RxKdsysn4gMCgFpS9DJLJwi3/Dn7bmg4Xo4VYiIRrm/Cz4GOo5Lp4GVm0OAJw+ja8BBwzBv3X8xvANswPEk4dICr5I8nr3CoTEYM/qdWd2qPszL/lwlGD6X32poJk5gwiNhZ9d6Wm71x7kMqouVu1/ny2t1oy+2ylUXknlLUCTI3ujUDuLOdwrJQvcIj8WwjTPS5DVfao/4aYJkUSi31xUcFM/J7aJwhmp4Gbo59Iz3d/tro1yGGOgbXnWtHUltzhHIJ560V69EtDlHYZTOqkf04JCJjO+I+Fy1MwVUK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(4744005)(508600001)(2616005)(186003)(8676002)(26005)(6706004)(36756003)(956004)(5660300002)(66476007)(16576012)(31696002)(316002)(66556008)(4326008)(53546011)(110136005)(38100700002)(31686004)(66946007)(8936002)(6486002)(2906002)(86362001)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V09WRkMzNVRZdjBwYTdjNmlVeGtBRVNXcmpoOWJ4SzJhUEV5ZWlkdEMwd0NX?=
 =?utf-8?B?R2pVbHZMWHIxc1VKYkhHeUZPT0EyUHVuaFhEYnFzTGcwNkhZa2hPRS9SVGtt?=
 =?utf-8?B?S3BzVENhai9GeDhHdjdCK3VLYm1hNVFVOXJsSW9ld2l4SmZrNkN6RzVtbkJm?=
 =?utf-8?B?MzM3TVlFQnU4NGFlR2VxbDRUK3JzSDRjMzRwNXlUZ2FTSUtQRTBsdk9EbWhO?=
 =?utf-8?B?R0w1bk0zYlJTZDNJN253MTFkc0w3VC9vTjVBaHBaV01GQmtxbm1YS1FUalFD?=
 =?utf-8?B?aUV3enVMaG5UV1VsWE5RTGZHaCtaYWU5Yml3R2FtWkhVYjYzY3RRNytKRUoz?=
 =?utf-8?B?ZjBRNlVPalB6TGs5N04yR3A5NE04dVRxRG5MZWp4dHYzOG5pbDQ0M1FxeEhM?=
 =?utf-8?B?SjBMcEd0VlNnejBaZi9Hb2gvWnQrSXpXR1JZT2VBQWRXdXAvNVpmRGdmY2FM?=
 =?utf-8?B?MWVvSSthWnRwcG1mTlZuY0tuR2lwK2xUcjRhandOa0o1TmxiZVlYWlZaMkdq?=
 =?utf-8?B?NlFuS1IzTC9YTS90bFdqM056RlB0RERwN2puOFIrK0xSSHUxNi9yYmZ2RUVl?=
 =?utf-8?B?clB6NTl1dXNPbk1od2dRUjBsM2FoUmN2d1M3WlQxM2dPQndmVnFMTDRYYm9p?=
 =?utf-8?B?UFlBaU4wN3pFZHU5QjQ3YThQYzNCMnZTaDB2ZWJsT2xncStZQm9NTDRmOTZE?=
 =?utf-8?B?bXc2UTNKWGd4NVlHZWFUNGRwQ2h4d1JCQ3M0cUhUUGxKenRhU055Zk9aNUN3?=
 =?utf-8?B?VW4xUmNIbjgxTEJiUi8yS0l6K2ZOaGoxVU1TNVNxUnpJcElzTG96d016aXBG?=
 =?utf-8?B?VElRbzhsbkk4OHZMNG9MSnRCaGQ3NlFoZHozS244a09SY0pLb3p1dUFVUTFt?=
 =?utf-8?B?Smx2dkJpbUplVy9jNXVGbkRZUVByQ1ZkMm5XRnpBODYvYTAreDQ4YnlOOHYy?=
 =?utf-8?B?RVNFbmpZTXViaHYvTXI3c00veUZJbHRBQ2FzOXpja3M1UXo3OUtCTCtaNUFn?=
 =?utf-8?B?cXRDQjRDZ1dwUFZoM0RJcjZwcnRkYTEwR2lDNEVyMGNMbE5HRG9PLzVKZVlo?=
 =?utf-8?B?TUpOa2JBeTFMbUptM2FWWDZQYU1kR3ZZckh4N1JSdXNlTTJCejhMRmlrVkll?=
 =?utf-8?B?U0JKclI4RGl0MmQzSjhDVGJvTHJnemg4UElGNFlTRkQ3RTZGYkZoaExzb2Qx?=
 =?utf-8?B?eWFLa3FHaEIraWhRbWVrZWJmVEdkMHZVbFBuRnV5YzViV0t6Sm9Mc1ZmZkw5?=
 =?utf-8?B?SjRlUlltdFVIWDM3NjkrMFg3UFRvbDdoUEpxZGRCd0VCVEMybkpSRFE4elR4?=
 =?utf-8?B?SU1qZDNnejU0bktMR29ZK2FrUVNWNXZUbStKaFpzYnRYdHQxemFVZDB3eGRM?=
 =?utf-8?B?TFRyZE8xTC9nYjhYUTZxbkVCbHBPcmkzRWZaSlc2MnNtMXgybUdaZjI4R1FM?=
 =?utf-8?B?T1pVemZJV3NSL21ScU04NmJlK2doL0Iwd25wOXRkM3NMcXRBV01WUHplMFBt?=
 =?utf-8?B?NVF2OFh1ZkZWMHlkMkZZZXZzaG9zL3dtQ0h3T3VlbFhQY3E5S2N0UlNRYlZH?=
 =?utf-8?B?eVh4VkFEemNBc25QdFNxSjIyZWMwSVp5cnMySytEejIzcnBsZTRuZ29GUG1t?=
 =?utf-8?B?aHhVQUdGbnBNLzhVek9DZXl5aGJxTUxGR2tNeUJxbDFVNC9xRGNGM0ZRcThi?=
 =?utf-8?B?OWNUVmxZRjNzcjRYMmtJRzNIbTFHOVZZRzZ3UTh5Kzh6cnh5QVQzMVdNVzVI?=
 =?utf-8?B?cm9Id0xQSWJoMGZkdHNGbFNsakZZOUpTSzV0OGVaNTVyRU1CZFdVM0VSdlB1?=
 =?utf-8?B?ajM3UTFpK0dDT0lnVnlCNXlPaFpMc0Yrc0MrNGRWaUJKaTRjdjl6NlZ1NUUx?=
 =?utf-8?B?V2Z4bnBXc3ZYVmNERzQ1SDV6ZDY1MFhMRGRlS1lMakpRQmMvUCt2TWllclhm?=
 =?utf-8?B?dXdCMHFXTUVMVThXMVNuRzVTYWx3dC9ES21kbVl4SHdzUGJRcFN6czBzYzFs?=
 =?utf-8?B?aklnSXI4OUNiQ2twaWxkTFBKWHpucGxwaFhXVllCbUZMSGVYS3JwSFNjOXR3?=
 =?utf-8?B?T0tSdXFMSEtaWVZaOC96OHF1bUNBaEtjbWc1eUEwa042Qm5nL3J3ZEhLKy9Q?=
 =?utf-8?B?dEp6NUVpY1daVkUxcXBsMmNtcVBkblhxMVdJQSswTUdVdzZ2NjFjeVQwT2k4?=
 =?utf-8?B?YTZmUUZxb0FzMnBWZXVsM01xM3ZGV1BoOXRtWG1oRFMyTnNOM1FJN2Y4QnRk?=
 =?utf-8?B?ZzdmUlAvVG8xdXQyQ1NORUlFaVFBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 567454e5-59bb-445a-ef70-08d99986216e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 20:12:41.6431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+3uZfFs6QP7/5rJEho4o68bS9o0Dzz4WvOQSHlkyxZXYTywVK719nKbJ1HIYxNcTQuxy6dqJ63ggBdmS+I4xbDji51yd4a3HZtmOwDju5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4345
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270115
X-Proofpoint-GUID: GIuE4L3ceFqamNQJhHvMzVwNJUODYVr9
X-Proofpoint-ORIG-GUID: GIuE4L3ceFqamNQJhHvMzVwNJUODYVr9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/21 3:02 PM, Michael S. Tsirkin wrote:
> On Thu, Oct 21, 2021 at 04:44:06PM +0800, Cai Huoqing wrote:
>> Repalce kthread_create/wake_up_process() with kthread_run()
>> to simplify the code.
>>
>> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> 
> Pls check how this interacts with Mike Christie's patches.
> Pls fix up the typo in the commit log.
> 

Hi Cai,

We probably don't need this patch since it's an API cleanup and
not fixing a bug. I'm replacing this code with the kernel_worker API
with this patch

https://lore.kernel.org/all/20211007214448.6282-9-michael.christie@oracle.com/

in this patchset;

https://lore.kernel.org/all/20211007214448.6282-1-michael.christie@oracle.com/

so the issue of using kthread_create + wake_up_process will be
gone shortly either way.
