Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AB4467CC6
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 18:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382417AbhLCRtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 12:49:07 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:13142 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343541AbhLCRtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 12:49:06 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GWimG018040;
        Fri, 3 Dec 2021 17:45:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jG050pNkX+5016388xUa1mqazp6HiQw7wT04TU/TrIg=;
 b=1AohdpEjSqV62J3n/ktuOhwfg3aXs5uqFofJHiq2qlHUohlJwuIjb5q6J1sH3s70X6YK
 7hxW2/M74YuS+li7Aaqbkiun4854AqbckeeFb7ursrJa7NJFBvxgg5Y/pmyQdiEegwKC
 hqadlD6VFxIiqRm9vWD9BpDNDkQUyWlYZQ+ekomCiMCKeYP2lD29IriLGrrjmuRL8kMF
 5E5YSXh9+r1lIFaoKd3DOgqmWEOt3tw/oiqh0A39oAo0Mc7AlC8WX/PEQBHU0r0B4hv6
 MpKICn79hmxjXRptpFsgQYEK4TyqRyVby5KYso15EUyf6whjrKVOl5HuPQ62Ps9QNS0h lA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cqgwmjfaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 17:45:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B3HeU8c088219;
        Fri, 3 Dec 2021 17:45:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by userp3020.oracle.com with ESMTP id 3cke4wmbh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 17:45:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4qnilgUwlkJWDAzbBJd/Em75zXym61PHhNsBW4nprkRf6WikEZsS9WAk8cQmtVj10rOtqkGlIYf3Jqkzhpnx/lYHboB4De7YO0BYQoMHt033O+k877jzxUgw1ur9UCkMoxpLmEHcEboJkKmMkF7FMzX6dEW/EBp3F7UCLOHMXMgE+GqhEOrmXTsf4CqvcAnJvH89vNkWGAOO+nAJQ5uyIHQ19rPr5XY5f4rE3OiYyKjdLDncP98yq/RcFkI7vid5WG53rFqdkaoM8ijR09GtvvzUV+VWWrj3wN031PJjBf29EcVE4MN2lrRl1/vr+N4RoNJljK+wwSYr4xiG7geow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jG050pNkX+5016388xUa1mqazp6HiQw7wT04TU/TrIg=;
 b=MRvQrrdB/TIljSiXWgG1UKKdBQ8kkx926DFseZvHK02mPFsB64DWGeLnx8xbtl6mUFbMcB0gKA9uPy+yqBZrwJF69wmvPVR1ygmp0zJdzjcZ8rGjw5GBr5tgcOjmX66HzMhsK/CplVuKGP3TCkZO4uh8YGyl8+UWNJqwRZnrN/9jGZ4FUbmh5Zy+Oz1D6wsu8ZQc7S99OoVj2WRoTheQq7l+fAbrvj4ZlsXn7gstIbC3+qFOIJeslNkPIsfrlI8Sn4ad+Bscp6E+Ljvcm6NW50RPewF0hXBJ1jZ81qRsQ569dKqAy3s/wZjB+wnYaJTIltqz9ofo6DBTjhI/rd5Ojw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jG050pNkX+5016388xUa1mqazp6HiQw7wT04TU/TrIg=;
 b=N6+ASdkFAu4BMkQytbhCFqtA4QsMxZqQ7HwvPGCKC6tGXWR9O7zBRvncaHMCnLtJSbBxkfsA/8XmysyG3ABF2q4I1GeFsK7FDcT6gIck1bY/HuO/1q4Nrbto08nHyguuR3kjOb4IZYpqK9+tfBI1DtfzlSo+UBBBkqmSm1C0Rhc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3882.namprd10.prod.outlook.com (2603:10b6:5:1d0::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Fri, 3 Dec 2021 17:45:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4734.024; Fri, 3 Dec 2021
 17:45:32 +0000
Message-ID: <3ed6c6b3-59c7-175a-4cfc-75e0516818aa@oracle.com>
Date:   Fri, 3 Dec 2021 11:45:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 1/6] vhost: get rid of vhost_poll_flush() wrapper
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Andrey Ryabinin <arbn@yandex-team.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211115153003.9140-1-arbn@yandex-team.com>
 <20211116143323.g7c27u2ho4vpp4cp@steredhat>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20211116143323.g7c27u2ho4vpp4cp@steredhat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0248.namprd03.prod.outlook.com
 (2603:10b6:610:e5::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by CH0PR03CA0248.namprd03.prod.outlook.com (2603:10b6:610:e5::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Fri, 3 Dec 2021 17:45:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 952a8bf0-e924-4f1c-583f-08d9b684b41d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3882:
X-Microsoft-Antispam-PRVS: <DM6PR10MB38826F553B1B6388ABEC6523F16A9@DM6PR10MB3882.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xD52640LgdJd4bnl9djFscWBDWX2ZQumlvoNKf9uO7veCft0Tzv5bOHJSZK8wTTSVq+6ZCluH3T1UOneZDnPd0VNqDhWoegDPzQUk+eZTmRXhsZH+Hy/dKDYP/fvFoNwFZA9+oCHRg1qd8P2/UKgxT41UcL30Br0tcdqOcIt+28CVepdvC+IuwyxIqH9iD42zbSb4hT6sIfqlb5YSnCDRRKnQFGX5/kg7/aG8OuUkpvl8FBFEjR5ZjzI+0Q7cBIXenQKdMJYmm1PP1cyKnlYxPGA9RMTcjT+U4kq7ImGqa80s+Yvp+srjkvhRyMxggWmFqFfOCJ7UG/0mhi2wduN9Gt43cpfETZ/NXKaGCvmoBirbxeY5KcPdfWmVK+IFecj2ZAvSaepNjQzZu1qbrfZuE1VUtGA7FhshaGzVoLd2FJnAZQJICJvk/qaPDXN++kt0xbCtf6MSppdSAK/X/ET+f+d98JdwAvGE2zsx8yG5JOMMeap2bVWnm/Is3rUsFhh+2RhiQyO9+MigJ0OK02eEGLwYx/z2xjkhwie1uzM8GpPZooQZq491DKKChRHJIFUwMsrpuOeI8qtTLBqbI1EK90MBfBsqZqeAVoQ2X9jlMwTI5CHWUhnTgPB9s1C6CSrdUIRo4MSt6f2ECWEySiBAFcDJHoeUYPP3fuwKG+9oBDIckcZ4zRshiUiZbBMqEg0B2+QvgbUGxInnro3KZoI+ZZTkmHRdYVkyE0i140aKKtl23Rxz9KeOv3Lwn1RUhwy6cobtm6VEdaBxZ9iHghg4LlXEmR4aKOR3zHpsO4Kd5o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(26005)(31686004)(956004)(54906003)(4326008)(16576012)(110136005)(316002)(186003)(38100700002)(83380400001)(53546011)(6706004)(8936002)(86362001)(508600001)(5660300002)(31696002)(66476007)(36756003)(8676002)(2616005)(66946007)(6486002)(66556008)(26583001)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WU1zd29uMitZNklkYkFER0ZWbkZpcnVkQkhQaUhDZ25lbzJUblkvTjNVd2FD?=
 =?utf-8?B?SGg0ZXhydThDYzdsRHlROGxtdDNLd0cyTDIwSTZxQWhCRVc1bGFtWGIxZHYy?=
 =?utf-8?B?SWtPZTh0bU41eU4zcnNXMHJFZlhsTzBXcmF3SnFFOHh4K0FoYmdSMVp4MmYv?=
 =?utf-8?B?K1I4Z1RQZnV1QjVDUURQc2JKVjc3WkxncDhMeTYzb2l0aWFYUEVDb3ovNkdp?=
 =?utf-8?B?RjEybE84MHk5VnF3MjBlVER6aXFJOFU3NlFFOXJqTUwyR1E0MTZydTZNRjhE?=
 =?utf-8?B?NElqVEsxdkpwQ3I0Qnk2QWlxTjNhUTJpUXFRUW0zMVE1cDQ4ditzelJobGI5?=
 =?utf-8?B?d0UxM0JlL2cvdERYVk9TU0ZFMXpYem82L29EY0c0cTVSMGhnbGhvZ2RlVnVi?=
 =?utf-8?B?K1lmdUxrcTRlVGtIWW1vZDQrckZvYzR5NE40dGtSUnF2WjJhR1FUR0J1d2F4?=
 =?utf-8?B?NHBpeHZsOU02VEIxSVZ2MS80bEl3VnUrMWJsbW9jNE4xRFlDQXByRTB0bjlT?=
 =?utf-8?B?akluOVhtVkVpNEJCSVFSV2lHLzFtNS9SVVM2ZTUxQjRzWW80ZXVialp0cGgz?=
 =?utf-8?B?RUZ6VFFvMkt1TWs1SHZ2SzJOTEh2QlY2aVVoSmVkaUIwcmpzTDdoSFBpbjBj?=
 =?utf-8?B?R3BsN2dDN1o4TGVxM0lpdElTUnFFSENFdmFpU2JvV1hDZTVVT2pPUGZSNWNy?=
 =?utf-8?B?SHV2RkRPeGwza3RrZ3FOd0E0NnozMk40RmMvRkw1eEVlS3ZQN1Z4RElETHBG?=
 =?utf-8?B?SlBpUS9WWHg1dVFNTFc3WkI2aHdoczFxYU5YQWthNjRKWkVCcldxOXFSOFd0?=
 =?utf-8?B?dmFyeEE0L2pIenVYQnNYdWh5ZTdxdGVTdlB1L3FSWVhrMWZreEluNm9sU2dP?=
 =?utf-8?B?WTBoam1SV0hvY0ZZUncxaUJ5Ylp6NHlkN1JzV3VKeFpZeDdGb2RzMDFQalVW?=
 =?utf-8?B?cFJWdWZncE1iM2o2ZXNyVitwc3RMREtXWm93RE8zOFRQQ0VwVGh1V0R5TEFS?=
 =?utf-8?B?YzNXTVB5eVVIVXV3MjZMcEVsMnJkU1Z2Y3orSVVTN1VqMGxJZEY5cjNyMnc4?=
 =?utf-8?B?dG4zekVleTd3RzYyMWR0TnYvM2FNTkhxS2lSZzBMZ3BYNnJFNFY0d1czREhR?=
 =?utf-8?B?bjZZVW9BVWpTVlkxRzUzU0wwNnNqazdKNHNETlBCcWpYZmRkVkM2b1hXd2Ur?=
 =?utf-8?B?Wkk2VDdMdTB3bzM1QlptQVJEa2RPOVZZRFBvZ0UrZldmaFd1ZXRBODBRa09X?=
 =?utf-8?B?QTdvMnNkUXF5ZXMzWDUrRWR6M2hpUklKdmJmRnlFWHR6TUVDampGc0Uyd2p4?=
 =?utf-8?B?Zm0vVm5RRHFDREl6NUd1L3hzZWtNOStWb2RuZHZzaHh5Wll1RjE1aGM3YzBI?=
 =?utf-8?B?ZlZPaDd4R3pmU2x5ZTR3NGhhQVc2NzlROWZscU9hNElqamlhSDFoVWpha2Nn?=
 =?utf-8?B?REhCMjVUVzZ0VVpwRk9teEd4UC9EUWtBYjhxRzBZQUhaeFBjSXI5MlBoZ3dU?=
 =?utf-8?B?QkNDWU43YWhQYlF1b1k4MitialNLdGxQZU9hS29tNW9DaWlJRkY1b012dWZT?=
 =?utf-8?B?eHQ2SzljMlNxZzJPUjlOMDFMWklzZW1taEFnZXJIMnNNbnJONnJ5UmJDYlV5?=
 =?utf-8?B?ek9SSXVCTDZhUEQwRjFBTkdCNjc4R3QzWjFXRkdmZTN1bDVWTGh0bW41MGsv?=
 =?utf-8?B?bVk1cHpQN2krTUIzMTlBV0FpZnNENDhGZ1dDbzZYdnVUdmx5MGR6cjBCNGR2?=
 =?utf-8?B?am9TNzZOdVBRMFhqL2toY1AwVUd5Y2VrWGNlRmdiZ1hNRzFzeFVWbTR4clBB?=
 =?utf-8?B?d0xWVk1HaWpldlpXUTRBOGh2TDRlaXlTSkNZOHc4TGdrb24vQ1pMWEpIWXB0?=
 =?utf-8?B?YjJ5ZWd1RGgxeGw3SkJ4ZUV2eVppTURGY2E5dUNKcVRCQk1FSERCTmNqT2ZV?=
 =?utf-8?B?UEFMQ0NKbitDSXRUYy9JeHRaNlRQbE5tM2FVbGd6SFRLVjhaR3Rva0RXZTM3?=
 =?utf-8?B?OGxOSE1wSGE1SnZnc2JXUk1JbUFyazAvQjJNSVhKUDhNcWZ2MTFTSk1jUW51?=
 =?utf-8?B?ajljYjVTWFRPTTYrT2tudWQxdmFyZXNaMFh6L0NoUldJUkhhS0t4VnlkMmN1?=
 =?utf-8?B?aUVOd1I3bElWcnBsOTI5WHdiVnNWTW9UcmMzQXU4bmdNczJ6U1dsSkZoZWlX?=
 =?utf-8?B?em4yNlpYTUNzNGpJV2VRSDdTbnZiSGNyVnBCcFBOUG1lVk9aNmJINGhEM3JZ?=
 =?utf-8?B?TjFxc1h1WWc1NWpuVDBNSmhLUktBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 952a8bf0-e924-4f1c-583f-08d9b684b41d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 17:45:32.5165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Et6DJ6DvUHOKT0IpiXgo1KvsmsgaEJaBI21EKRsP6FBOu57kFkHiL2s7/ZY5YaXvp4AasN7ZVDSmeueItUACOAcGousNd3oLh0dPrNJBUlY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3882
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10187 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=880
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030112
X-Proofpoint-GUID: MZTg71WgEkYDcwCfIPMcyncUzIDEdpkS
X-Proofpoint-ORIG-GUID: MZTg71WgEkYDcwCfIPMcyncUzIDEdpkS
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/21 8:33 AM, Stefano Garzarella wrote:
> On Mon, Nov 15, 2021 at 06:29:58PM +0300, Andrey Ryabinin wrote:
>> vhost_poll_flush() is a simple wrapper around vhost_work_dev_flush().
>> It gives wrong impression that we are doing some work over vhost_poll,
>> while in fact it flushes vhost_poll->dev.
>> It only complicate understanding of the code and leads to mistakes
>> like flushing the same vhost_dev several times in a row.
>>
>> Just remove vhost_poll_flush() and call vhost_work_dev_flush() directly.
>>
>> Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
>> ---
>> drivers/vhost/net.c   |  4 ++--
>> drivers/vhost/test.c  |  2 +-
>> drivers/vhost/vhost.c | 12 ++----------
>> drivers/vhost/vsock.c |  2 +-
>> 4 files changed, 6 insertions(+), 14 deletions(-)
> 
> Adding Mike since these changes could be relevant for "[PATCH V4 00/12] vhost: multiple worker support" [1] series.
> 
I reworked my patches to work with this set and it might make them
a little nicer, because I have less functions to port.

Andrey, please cc me when you repost and I'll send my patches over
your set, or if it's going to take you a while I can help you. I
handled the review comments for the flush related patches and I can
just post them.
