Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9D518D718
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 19:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgCTSes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 14:34:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23502 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727151AbgCTSes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 14:34:48 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02KISUvn004863;
        Fri, 20 Mar 2020 11:34:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=fGIsdNVIWwBAjXHczvKw1KrMK7d2nJTkgXva2Z4gcWs=;
 b=A9iJYj3RZ7uprlmhr6Au1akjwIWnpC1txItRdBBGntrgQSea6ptISZDCnFa0cCBeJFOs
 pjLvcdrXjKBSMjlOHzGKaaZr2IXPWAbzSGp+vUqMgQJMdPRlD9UjLe1I2sfECYpDCRTC
 z0tQrTxfryUzFPuqqFUiVm3K+DdPnIKql5o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2yu7ynyrxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Mar 2020 11:34:30 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 20 Mar 2020 11:34:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZqC6LdFWjs6QZ/g3TH+WH62L9/gTmNjs4bhUb4fQ6FGKSuKOLf0SAIdJQeiOysRp6Sx+couSEEnx3XnyBbooSsS8/s2XEXkkGOl0PIENdFwNo3yAvI5wTlE8vv9rnyL9Ojzt3xgz8bTkr79xd1sPaX0o78hR0FtfVzIvyV+AsakmXKvE7VtqQPUZnNGjF/A+MUc0PhS5eItMc/m1xzMwi+PnJyxXsecZlVlE9MtqSuD7MoErRUrjBA0X0SZYXbW3K6ZRzwBE+LbpOevKAhN6HrDCocARQvq2nWeCNiT/BSirdm1PLBRs48D3uDfBpeOn50mFtO8WX+Gd6nTxZLHYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGIsdNVIWwBAjXHczvKw1KrMK7d2nJTkgXva2Z4gcWs=;
 b=hpakoFrvgrr4O3va+cuR6pbcdyxm9Nlen88xBGGkj+BT/AWN3b6UYEhiyKIGXqPNXr4gT5de9iKxfVC2V4KxQY3X4hAUa5bvIX8M9TzhDlwGqr3KrJptz1TRmnzA+WKdmlBKA/y97lD6Mbp1nFUMl87bhpd7N8HNsqDDW8ByWdsskJFafey3JQtmNesfKUcnadqQzb4tp5VBXbtG3v38luaWJuJZpjX2h3jI54jmIZ3xVFIVhXXXNJEw+4gIdGPpB/Spl1phcTTRVfSGf0F6JDZuisj8xblcKYdBWbDzFIkCyDuV9C6oz5PL6xv+lTtO9Q4/omoOW5vKcFMYo+pstQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGIsdNVIWwBAjXHczvKw1KrMK7d2nJTkgXva2Z4gcWs=;
 b=ila7XhRIFPEQI7osDPR+wI73duelmocBoX2hisEwLvIv+CjEQkUIEi/FQf2wwD5nI3XgceCwB8jb512VYclymQtkFed98LY9N+cK6hzhUVs0ogf4hG/H2gRB8lkbSsbhVPhodGllU8eNLR11N+ZLamlTNAnHuUJqQorb6mKbCa8=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3818.namprd15.prod.outlook.com (2603:10b6:303:47::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19; Fri, 20 Mar
 2020 18:34:29 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 18:34:29 +0000
Subject: Re: [PATCH] bpf: explicitly memset some bpf info structures declared
 on the stack
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Alistair Delva <adelva@google.com>
References: <20200320094813.GA421650@kroah.com>
 <3bcf52da-0930-a27f-60f9-28a40e639949@iogearbox.net>
 <20200320154518.GA765793@kroah.com>
 <d55983b3-0f94-cc7f-2055-a0b4ab8075ed@iogearbox.net>
 <20200320161515.GA778529@kroah.com> <20200320162258.GA794295@kroah.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f7063856-8d52-8e29-9593-cdfa0d26799b@fb.com>
Date:   Fri, 20 Mar 2020 11:34:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200320162258.GA794295@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR22CA0024.namprd22.prod.outlook.com
 (2603:10b6:300:ef::34) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:a280) by MWHPR22CA0024.namprd22.prod.outlook.com (2603:10b6:300:ef::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21 via Frontend Transport; Fri, 20 Mar 2020 18:34:27 +0000
X-Originating-IP: [2620:10d:c090:400::5:a280]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8c30a4d-6526-4cc6-35d6-08d7ccfd52f6
X-MS-TrafficTypeDiagnostic: MW3PR15MB3818:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3818B8216054DA4B8E60EBD1D3F50@MW3PR15MB3818.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(136003)(376002)(346002)(396003)(199004)(81166006)(8936002)(81156014)(53546011)(6506007)(2906002)(31686004)(7416002)(36756003)(4744005)(110136005)(4326008)(54906003)(8676002)(52116002)(86362001)(2616005)(316002)(6486002)(186003)(16526019)(5660300002)(6666004)(31696002)(66556008)(66476007)(6512007)(478600001)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3818;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b8t+nlORG12gaTWKEihzgwvkBstUp5jSBl/sXHwb9dYIEULw0y8/f2YlM5FpHWvBYJzaY8kvEhioLjPiicRAwYvRiRvUlLwvLV0+3xfSmEItRMilrzFQXqWQTbFIlc2Kc+DaqERu0Gm+XCgoG0iYnN3S9sUlkkyZ0KOGVxJ46BBxochF7Y+51LLVmzzS/WfUP86xHDJSRYI+ZWqOgQXCRMXi6Ms5Od8i6Qi17kY7ytdqKG2Jn+2/CiU0FBpsoif6zYfvo/u3rPzgPieXkOXlUKkK/g+JhFe8/H5V4e9j13LwT23DeedpOWod3x9Owb9t4r8bB6vDmpNAcz/Y9b7BucUwYMUW+DAr6p9lqmrtShRCsk/AqC6iWf8+EvERrdl0HvZmRN4yICTSPZmkQPPSGPdC+FJrxcvVfmAK+hU/M7jQsxTLWv0CFOUDtU3Ylene
X-MS-Exchange-AntiSpam-MessageData: KWDyn2sThXDVsU5n6qEoqbmdqn/mjjd4gRUIvv5JQ2zPpoD419VIkqFpcy7RxOAULTuB9lwqPU7qXQMsmSSIyXPyMpWw8eKydZRTKI9RktcWMBb5rL+OiQgvRg9bZoihD62xjl+XlLmYXZiWfvTOPi99ZzrtND94gopggqWOemxwCbQftdn5o5un0UWzN4di
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c30a4d-6526-4cc6-35d6-08d7ccfd52f6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 18:34:28.8596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vYVLiaemsp9qmPHAgNidEZOubqBsQ94tf7Lba/Yhz4u+EdgQUdCvxRpeC9lx+ntC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3818
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_06:2020-03-20,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 adultscore=0 mlxlogscore=685
 clxscore=1015 mlxscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200074
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/20/20 9:22 AM, Greg Kroah-Hartman wrote:
> Trying to initialize a structure with "= {};" will not always clean out
> all padding locations in a structure.  So be explicit and call memset to
> initialize everything for a number of bpf information structures that
> are then copied from userspace, sometimes from smaller memory locations
> than the size of the structure.
> 
> Reported-by: Daniel Borkmann <daniel@iogearbox.net
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Yonghong Song <yhs@fb.com>
