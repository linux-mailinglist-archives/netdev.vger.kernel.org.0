Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0672848167B
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 20:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhL2T4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 14:56:30 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39088 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231419AbhL2T43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 14:56:29 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BTFcEXr030650;
        Wed, 29 Dec 2021 19:55:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Q5Q3HsfBAvglaKVCQUTubtatzfJSwpaDuR+t2tjgY8g=;
 b=av9IHXL+b68mJBnJqhAM6RLJJpuOSFJzUFeZLBp4mDHzPSq4Tr+r8KqYjSif8BI4Yw85
 /xSDHd/Ao8WqUpVh7HzB4earj/XNfBsjhLaTxLKQrCwIo3oCruXkigK37wG/G2+a8ZjH
 ne1L0wihnt12aWv0P758+XyiHU2Ln2o3fSJeiwrguVHoF8GHIC95WkLO5L5fK+UlZwbH
 95IZnFCvVR3stFyPMRtb2bNcPxfpP6rkVzlvJhBIpb0Z35kCORgc+arLvp/NVAdXewuh
 2lqIi2agDO/WrfJZDviXI4GBsg533mcvIWcAgILLoK4cG2N4c8+9BtGq1UAL+0CUJnzI hQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d7ght3mmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Dec 2021 19:55:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BTJpVGV143822;
        Wed, 29 Dec 2021 19:55:48 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3020.oracle.com with ESMTP id 3d5u452kys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Dec 2021 19:55:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQKEkDWw8KEBHbkxGBTtblzwofegHw8zlgdz8BfUOMRwI+skUkY2OvBWb0WUMxQj7Jo4LeBQ2CDuT/YmrnYs1ADUOomllFJQkfWRnAb9YJTTLhU5KCyrjrU/dN+zsGVqkhEJjYZlzohgjheRAd7nlv8uKwGJ7e0qmfA3eZ8wao9CrIqTabdT/xZ+9HuGr7xkcGzwi8DXtItuzQQe/+KsKBnzbLioENi++wWiGtcOcIkW5bBO0ZZyVTbOTZiII6wLk9FzQhbkU7on6mir+Z3tud8E7mwZoDeH/h3agpwJixSiGB9YY0LCZAr3EN/h+LPcgpquSFDQMT2S7xb/kpmUBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q5Q3HsfBAvglaKVCQUTubtatzfJSwpaDuR+t2tjgY8g=;
 b=Ms+C2aGU+itShACkdcCNW5wfsmqLWYV9zXQ87xUM8MGeVGt5VCdES9pNI4kcS9qcEToEKr+4UqJzBW38lkbu7ADLl2fopqYf875moOi0NsBLwgdgu6mYxJstQxuq9qam73GgHNJPOT71yIHzPO2TLolKNq+5m1MMfXMmdHM9LUk5fFCrnn6p1kSZswTKqhjvjJ2eJ+NJUa+V+c1AV0jibjcuwZHoKC8cMyaAzcmpl9P7ubPxLx9RVFTkbrb66/lpA4gr2eW5npem7A62L3YwmX5IYSLiFS370pHmV+u4dAR6r15FPYf0ILMLdzk7uMM+tNlccXy8WcZ0ilPKPlhKQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5Q3HsfBAvglaKVCQUTubtatzfJSwpaDuR+t2tjgY8g=;
 b=OJa7TiM4M+7ZmJyWEyP2n2Cc19rajcMVIDKftqwgs1C+CXXyEstOXoCEuttm89c2G3rOo9DA143Vww14So8p/H7NH6XEqKA7lzktql0HXja1hoCd4wEUU/DBgXs/ZQc1r/ff24QU71jEr7FqPq6cjV3qQql0I63yql2IIS1V8DQ=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB5423.namprd10.prod.outlook.com (2603:10b6:a03:301::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.23; Wed, 29 Dec
 2021 19:55:46 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::5d0a:ae15:7255:722c]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::5d0a:ae15:7255:722c%9]) with mapi id 15.20.4823.023; Wed, 29 Dec 2021
 19:55:46 +0000
Message-ID: <f09c4690-d3db-f935-4487-e2b262363622@oracle.com>
Date:   Wed, 29 Dec 2021 11:55:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [syzbot] WARNING in kvm_mmu_notifier_invalidate_range_start
Content-Language: en-US
To:     syzbot <syzbot+4e697fe80a31aa7efe21@syzkaller.appspotmail.com>,
        changbin.du@intel.com, christian.brauner@ubuntu.com,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        hkallweit1@gmail.com, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com,
        yajun.deng@linux.dev
References: <000000000000ef6c6c05d437c830@google.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
In-Reply-To: <000000000000ef6c6c05d437c830@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO1PR15CA0113.namprd15.prod.outlook.com
 (2603:10b6:101:21::33) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2486962-b5dd-4d29-2db5-08d9cb05347c
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5423:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB54231EB27B27DB42A6D5DEBDE2449@SJ0PR10MB5423.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gkPew/Ap9+tyP3tRVkJZ8rVDvsfgkY6nbdDWHRoCIPSBXThVWubbvnoPfyHaUXnZK9CJnEpwq5quQ5UWHbudw83maxdar1v615AbJkIdjDcWkX9oR37Al0qQJwtCV3lK4mnCwtbbAn8Uo8gfFZqTr8OSUl8azsDM7Hb8SxJ8oreFMu4blg+QRI/1rtBWSBZY2YhMCwXY2r6Y8/G/r4L3961qoU/yAz6AkD7+VSfPe+4EfXNnp/Ks484NX3EKcNJIwh2r+GcHVvkFsiCMWAkrIMnnPn7TpuEE/Fv+aklBJjh8fjm3Fu1MXwQLJn4t/oNOq6zklygj70AxhZlw9zvkH+YffYxGeGr8igdrz81BeVUvWdCA0/0P2BeNU4uqfqobiXuzNcBdgNBOKo4PAYxYhUKLIjTOOqr0pMYWdRZnItQ7JoHd2LBt76u0LItzBUnZbT9y437erJ9q74ulgP/Yx+4UX9n/DqvFbNvCYXKVVIhPNKAAyJ3WKFYaDDBrb1aI3VJKL7olMhhcdhS29I1TupjBpMHV8bGz8MthUM5NXXBLKBraooj1EpUgdSheWZ3EKi1TDYdp7ZjmBN1u8bf2Drrn1nXnOypyxkz8xx9GLeLSiO3EbuJvR1QMQbEUpg0AwkVCjbXkqtmTjYuI3OlrE8M2EHnWIi21LW7ZH0g67KxRLlqNJ/yEZWdO6gBNa0nqrj5y9msvw0GvILTbqwXqo+V8TgUgHP9Ru/rruAPTNRvSB4WsfC/LNRaaF4bqmnbF++n3N5c2FEa6lqhvpc2O2ZRIAWyXB0I23edIU7R5lxJyFyBfGuws1kihWgp/bXkiu8sNoA6w+C2xa8poDMDNMwnW7y6nQaqL1CKJr+UeIQCfWGb9EmDxaKZeKbVZpEs4Pa13xa0QGolNTbLEDjWF/mqcGlO+rKgJvzkYBeLtEIE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(26005)(966005)(44832011)(5660300002)(38100700002)(316002)(66946007)(52116002)(6512007)(31696002)(38350700002)(36756003)(31686004)(53546011)(8676002)(8936002)(2906002)(508600001)(86362001)(6506007)(2616005)(921005)(83380400001)(6666004)(7416002)(6486002)(45080400002)(66476007)(66556008)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFBMZ0gyTlYzTW1UNzYvZmIyR2JOR1VGcVFobFVIMTZDMXBXWnNQU0o5TUJO?=
 =?utf-8?B?Q1FHMVZUWCtrMks2RzlUNjVDQ2wwbllUc2lZbnBhVFdvQnIrQW9oMVRtcFl0?=
 =?utf-8?B?K0dyVWF1aDZpVS9QMWR1Y2FrRG92VVF5OTBnNGU2V1g4RVNHNzJCSHN2R05X?=
 =?utf-8?B?K2NZNXhoZ0R4T1dGbXZ0N29weXVQcTR6SGZKaFc2Qm9TY3VBVkZqYjNvSXFB?=
 =?utf-8?B?QXpxakQwSkE3b2Z2TWtBTlZaeWJKWGc2am5SS3VndHEyalJUWnc3QzJBakM2?=
 =?utf-8?B?OWlKcVoxL0xzOXFZNEtqTkRReGtsUERYTUprV045ZnZBeXVrSUM2Wk4yZnll?=
 =?utf-8?B?TjlwdkVlRzg0aTEyUWNiUkNLbExaaHJycEpuN0RUZTZHbzZEWkVVVEVRdXFI?=
 =?utf-8?B?YUxiQXdBOWJBR1hEVlc5dWtuTjlVMTVpQTRkeHNRVWVYb3BzVTJNQ25ZdWVl?=
 =?utf-8?B?RDdHdVFDak9NWDVyODU0V0hyMWpUckd1MDU3RVhISmNCUzFERCtFMkxvaTl2?=
 =?utf-8?B?UFF2WnI0VUVPd3FWRDByK1RHVHdWVXhkZFJza0dkV2ptbDNiQkN5Ni9kU21q?=
 =?utf-8?B?ODhteDFpdk1ZdGI1WnVSNzQwSkdSbWdDM2poeC9QSGUrcEYwcjBhbzRjczlM?=
 =?utf-8?B?cjM1MGpqemprdjRtL0ZuM0U2YU9ha2xQYVJ3Ymp2VVArUjNOY2kvUVQ4dVhk?=
 =?utf-8?B?eDE2WEFaWU5XNFVkVlppRWw3S2RWZ0Z1SFF1Wk1RMjJuSUQ4UkYzZ2NQelh5?=
 =?utf-8?B?KzZ5UEU0YlB3c3JLOXcwRFF3cCt0bHI1bXo5ZXByaG9JS2RpbmNhS0YvUFR1?=
 =?utf-8?B?WDVPWjU2S1l2ZUlIaElxMzRRNi8vejVVdlhwL0VPUFY2UkI2S1BhVGc2ZU5z?=
 =?utf-8?B?bU4wZXNKUUYrVGIzaXNCb3M2VkF1OVNad2M0bVpXSFM1U1pSS3pqNHZxS3J2?=
 =?utf-8?B?OXR6V3A2cEVTUFFOS1R3aFVVYWhCZ05oYXBWUEZkbVZ4cUUyb0pFTUxCYUpk?=
 =?utf-8?B?UU1nUzd6U1p4OC9VZ1llSVZiU25CVDFKd2JMTHcyeXBOMGJ2TXl1UWw1KzRD?=
 =?utf-8?B?N3YraytqZEtXM0kvSzBjSEd4OElVUUdVOENGdDlNUXBRTEZKTVFuR1phMXJ4?=
 =?utf-8?B?dU1zZUpGMGprSG5rTFVFakp5V1kva05zS3VYK1lUU3FDcWFVS2RwR2hBSCs4?=
 =?utf-8?B?aUZ1amNjWTgxVmRFd3doQ3lZbFBubzdWM0pFQXNZVmNZMVM1Zlh2V2JuQ20v?=
 =?utf-8?B?N2J4cU45MG96enZHSlJYRFkyUUhhZWlqUFh2T3ZNQTBqbU5sK3d2ZjBjRktB?=
 =?utf-8?B?M1ViNVh6K0pmV0hsNXErbmRVVDBkZ0tUSEFHb0o4T3I2WmFZZXhsYVNGdTAv?=
 =?utf-8?B?cG1XNFpyN3R6TUlPUWhEUWQvZGR0V1VvSGMvSEpIcGNNbVlFcXVUQmdFUHVU?=
 =?utf-8?B?NmJhRWJzZWFFNGdUc1UvcEdsMVF5MmpoQU9sRXFESVhTdUhPRjhQWHR6S2p5?=
 =?utf-8?B?bW1QQ3Vwd1NzY2tYNVZoNGxTRDN6bE93Um10KzRadXdWZERGc21NVVh2VHM3?=
 =?utf-8?B?YlAwazQrdDUrNTNZeXg3WVI0QTdSVFZkNGgwRS9hUTJQc2xyWVBQSlZjRnZM?=
 =?utf-8?B?b2hOVFVYY1FHampTRGZsZVRTK3Q4RlRzeDBwSll1ODl6d3pBMEpjcTBxcHFZ?=
 =?utf-8?B?U0NGZ3RSaDN0L25LUVFxYi9BdG9CeTVKU0FVenNJSG1icVJTa21NcU9GN1BW?=
 =?utf-8?B?L2xIVFNJamlOeVlldUF3Mzd3V1U5V05oMkh2YVkwaVZWdHNyTTJVMTN0ck1L?=
 =?utf-8?B?Qms5TElNcjRURkFwSFlqL2M1OVYrZ1dwTVQxa2t0d2MveC9uUjdNaVFib1Y3?=
 =?utf-8?B?aW5SSDBUL0VtMWNnZ1VWVXlCN3lDQmQ4LzVtblUwYVd3Z3UwMWhPRGRQa0Fo?=
 =?utf-8?B?RW9WT05jMy8xT0dXWU94MUNROEk1WE42VU9MVDBFdmhqUTJPbHpocm5oNjVj?=
 =?utf-8?B?SVlkL0xlYzZJOFFYV1RLTVc4bGR6V3NNQXJrQ085VXQ1MEtPRWtNVEFhOEY5?=
 =?utf-8?B?ODhrVHVINWwwVkRrcmlia2pXR0d4aUtMc2hpUFl3SGt5ZTY2YTVDREVmREYv?=
 =?utf-8?B?NkZFakpxbW5iSFZ2QUJVL0R0T1ZXRVJjS0pIOHB2d1pzekhoUWU4eFNpWC9U?=
 =?utf-8?Q?mjNnCLw9NG03njIhPKmV6LE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2486962-b5dd-4d29-2db5-08d9cb05347c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 19:55:46.7807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74/QSJ58OrqcKl5+cKw6za+mki7rKc2myk10omv96KZ/UxeQ9MsWspCuDywExn9lO22UrP0RfQSdFQt45/qaUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5423
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10212 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112290107
X-Proofpoint-ORIG-GUID: -JCcgClRAQoiDg5WKdTfuF718UNw6041
X-Proofpoint-GUID: -JCcgClRAQoiDg5WKdTfuF718UNw6041
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/28/21 09:02, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ea586a076e8a Add linux-next specific files for 20211224
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=12418ea5b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a9c4e3dde2c568fb
> dashboard link: https://syzkaller.appspot.com/bug?extid=4e697fe80a31aa7efe21
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15724985b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12d1aedbb00000
> 
> The issue was bisected to:
> 
> commit e4b8954074f6d0db01c8c97d338a67f9389c042f
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Tue Dec 7 01:30:37 2021 +0000
> 
>     netlink: add net device refcount tracker to struct ethnl_req_info
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1640902db00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1540902db00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1140902db00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4e697fe80a31aa7efe21@syzkaller.appspotmail.com
> Fixes: e4b8954074f6 ("netlink: add net device refcount tracker to struct ethnl_req_info")
> 
> L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 3605 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:532 __kvm_handle_hva_range arch/x86/kvm/../../../virt/kvm/kvm_main.c:532 [inline]
> WARNING: CPU: 0 PID: 3605 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:532 kvm_mmu_notifier_invalidate_range_start+0x91b/0xa80 arch/x86/kvm/../../../virt/kvm/kvm_main.c:714
> Modules linked in:
> CPU: 0 PID: 3605 Comm: syz-executor402 Not tainted 5.16.0-rc6-next-20211224-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__kvm_handle_hva_range arch/x86/kvm/../../../virt/kvm/kvm_main.c:532 [inline]
> RIP: 0010:kvm_mmu_notifier_invalidate_range_start+0x91b/0xa80 arch/x86/kvm/../../../virt/kvm/kvm_main.c:714
> Code: 00 48 c7 c2 20 08 a2 89 be b9 01 00 00 48 c7 c7 c0 0b a2 89 c6 05 4c 4e 75 0c 01 e8 f3 22 09 08 e9 76 ff ff ff e8 25 e0 6e 00 <0f> 0b e9 8f fc ff ff e8 19 e0 6e 00 0f 0b e9 5f fc ff ff e8 0d e0
> RSP: 0018:ffffc900028bf5a0 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000020800000 RCX: 0000000000000000
> RDX: ffff88801ccc3a80 RSI: ffffffff8109245b RDI: 0000000000000003
> RBP: ffffc900029e0290 R08: 0000000020800000 R09: ffffc900029e0293
> R10: ffffffff81091d04 R11: 0000000000000001 R12: ffffc900029e9168
> R13: ffffc900029df000 R14: ffffc900028bf868 R15: 0000000020800000
> FS:  0000555555953300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd0eb9e48d0 CR3: 00000000749c0000 CR4: 00000000003526e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  mn_hlist_invalidate_range_start mm/mmu_notifier.c:493 [inline]
>  __mmu_notifier_invalidate_range_start+0x2ff/0x800 mm/mmu_notifier.c:548
>  mmu_notifier_invalidate_range_start include/linux/mmu_notifier.h:459 [inline]
>  __unmap_hugepage_range+0xdd3/0x1170 mm/hugetlb.c:4961
>  unmap_hugepage_range+0xa8/0x100 mm/hugetlb.c:5072
>  hugetlb_vmdelete_list+0x134/0x190 fs/hugetlbfs/inode.c:439
>  hugetlbfs_punch_hole fs/hugetlbfs/inode.c:616 [inline]
>  hugetlbfs_fallocate+0xf31/0x1550 fs/hugetlbfs/inode.c:646
>  vfs_fallocate+0x48d/0xe10 fs/open.c:308
>  madvise_remove mm/madvise.c:959 [inline]
>  madvise_vma_behavior+0x9ca/0x1fa0 mm/madvise.c:982
>  madvise_walk_vmas mm/madvise.c:1207 [inline]
>  do_madvise mm/madvise.c:1385 [inline]
>  do_madvise+0x3d6/0x660 mm/madvise.c:1343
>  __do_sys_madvise mm/madvise.c:1398 [inline]
>  __se_sys_madvise mm/madvise.c:1396 [inline]
>  __x64_sys_madvise+0xa6/0x110 mm/madvise.c:1396
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f64377bd039
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff39388f08 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f64377bd039
> RDX: 0000000000000009 RSI: 0000000000800000 RDI: 0000000020000000
> RBP: 00007f6437781020 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f64377810b0
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>

This should be fixed by,

https://lore.kernel.org/linux-mm/20211228234257.1926057-1-seanjc@google.com/

-- 
Mike Kravetz
