Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE53639325
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 02:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiKZBmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 20:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiKZBmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 20:42:17 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17051A072;
        Fri, 25 Nov 2022 17:42:15 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AQ1fuMK009717;
        Sat, 26 Nov 2022 01:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=message-id : date
 : subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=09488IC6aCs2LrpQBtMthIB3yZduw+ejGCYyrJOM62I=;
 b=BgodekIGENsrBbqil+YNIkq0vNQUi+OdzQCmq827gT4n3S421SxyBeALdrluz99imP48
 xn65hv5xgPJNdD0fynhttfpLVVYV+ZzzK813oJsvjveLIX2wP+8n69vufDkrEAyaclEk
 IrZX7xX06L4acTKy19RZJNyOBrX49q6cnkzqF8WESMRKno9QQc/z5rB2HcoMHTbhMaTW
 qa6Db6tJIi6kqhpIbG1i2SwsedrK4avKgzveY6Dpd8nmdMIg3LGxmI/iuuH755S3cFgA
 DymTZeB9U91qI8axVW6pm1QqjwHzmGwfY/Dacl6Eg+kaorLOmWfyEp0O74vhDs+3r1/k 6A== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3m3813014x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Nov 2022 01:41:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6abI5JR/7+CyT3eVO0Me1hj3SUZ8P//XIIhLkOFfLtL9s4esGlBjWF92x7s8ZzGelsr/VSFLeFKFbr0OOF6K1UBxlYn/DTxenA+cuigmSnDxITJQmcyEco6J685WFSG2K9BaPk+2O05QSMYh6EOotVEgGYN+MGy+Ee7L8pgqpLrHxOTxpPAs/o6QhEGKVk1fSOpC6rB0Cbj/kFoc91+jAVS2Np1pZytvE2H7nQITYyLZJ4oPMpJNAwsR96oJB9Fw9jKVTBaqWyKi8++l/SWEDXVX5/9qDQec67/27PU5nJayh9EZQ7lEknT2TSayCB10DjKfn1G8i0tU6W1uhERcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09488IC6aCs2LrpQBtMthIB3yZduw+ejGCYyrJOM62I=;
 b=evhlLH+qEBdvtBMpEzYLNuNT3oTK6VbEX4sFi4eqs8ocYr2vX4CQpQxjQJSexyVIf0SjA1PJqkTtpehNE4fTP5+6Z6lQr+7G/Zi89tJLCVf/DDfxeD2t6Qi1uHXOmTOOaVHNwaZ0jYV52zGdQjH1Fu2bDH9WLKAQ51T3Hi562r5a1q7mK6DG6Hxj4b7ZpI8hdWYyNdadDPj5/7toC0ro8m6SlFhUlkDAgaYrORnU7y5TOWPAKnp10ylwwCWnSVDFu71sfC5g5djJYvKMzFvsVwTBV/qL7NvfJkMhcEIFl1epGev4N+r1pSWV9Q1JCXPWY7qgt7p6Ws+AWTa6pRzL9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by MW4PR11MB5872.namprd11.prod.outlook.com (2603:10b6:303:169::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Sat, 26 Nov
 2022 01:41:54 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::601c:88b4:f579:677b]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::601c:88b4:f579:677b%3]) with mapi id 15.20.5857.018; Sat, 26 Nov 2022
 01:41:54 +0000
Message-ID: <6b50524f-4f24-d14e-9d3f-f03f25ca549b@windriver.com>
Date:   Sat, 26 Nov 2022 09:41:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [v2][PATCH 1/1] net: phy: Add link between phy dev and mac dev
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221125041206.1883833-1-xiaolei.wang@windriver.com>
 <20221125041206.1883833-2-xiaolei.wang@windriver.com>
 <Y4E3EOTXTE0PuY6B@lunn.ch>
From:   "Wang, Xiaolei" <xiaolei.wang@windriver.com>
In-Reply-To: <Y4E3EOTXTE0PuY6B@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0130.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6::12) To MW5PR11MB5764.namprd11.prod.outlook.com
 (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5764:EE_|MW4PR11MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ab63dbb-ef6a-4850-d04b-08dacf4f65d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UcMc4Q1xCsq6d+EhC++Va1OdGOv9SpoqGt4kP5VQ791/9V0fNBuw8Udu22qSZcHTdPuzL/SxFVRYTyxDm1+08EAYPVC520SCtkVcJKeAHdRT6Konvept1KIO122ZHBTi2CnEnkA7MMZC6a6MeEeHo2DYXlgCgO6dXETr8sBtZMSS1OFN5klxz6PkUaUNRVD6tYUT6qhxcnR6XPO2M2/Enr+ynX1MfBnLIN9mDL73WqvqB/qCVQl1kwepw+SaJV1Jy+YcDNuslcolXto8Xgu8y6/wOX5jYOsElaytDN6LOyceD+vdlRlKE/OaQ/J46dTfKKZgHyWKSM44jK8IxKU42kUNMNAO2VXQ2jMf51RYQ4OUdU3nDJ7FfyGHccYGFA5QSC1o2GyPXJ3YcLNS7PVgsWChaEANUORT7raUAjJVYPKg+PjSb6W9uWW1r9d2dU7eeIA8wA5+lhUqRSgVS3ZpwNPm+U/xjMOE27asJtBwHRDEg2VD9teGTjZFzJEQ9iSKQ16llfAxBDF/bMGh7TyGSFC3JVeXJKJPjra8vmNm5wiPFsqmtQRYellHigGz6fsQNrgumkQjJfWMDWzUU2KQb+f4koJGQOm85XJ3NRvgv8w+2brG0HUzL1IpMCX/SzNqzfi6/nNQPET2h6nBZ8w9jkdY1+G29SnBqJ4jt68kGPHR0P88v/cs7JH36ueTdhnjDGQDsKUTzh24YFqWwU+ZvXMkQ06ixBs2hc3AGHOMlMHMFRevDU8Xz0I8RDkxXY+CgazkhFffiFpxSbmzjBUaWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39850400004)(376002)(136003)(346002)(366004)(451199015)(41300700001)(38350700002)(6512007)(36756003)(31686004)(26005)(45080400002)(4326008)(8676002)(110136005)(66556008)(66476007)(86362001)(38100700002)(31696002)(66946007)(2616005)(52116002)(186003)(53546011)(6666004)(6506007)(478600001)(83380400001)(316002)(8936002)(7416002)(2906002)(5660300002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUtiTkJTNk1QdnVzRlZDaUlRS2pTYmFzaWNHc0dSRlVTL3c2OTVGTENTdndv?=
 =?utf-8?B?MWZWdnl2aUIzdVIvVjU4c1dBcmJuWUhoMmdnWU9rRmV4ZDgyMks0ZG1KZHlw?=
 =?utf-8?B?dDJtcDkzdWlYeXd6Q0N4aTZydlNPWGFmSjlTT1NnZmhvdUMycy8vTHZTMkgx?=
 =?utf-8?B?dFY1QVBJSXJzME1qSFFSZjliK1AvaXRQQTgzSWxsTW1XMGZYUlJ0ZmpHUllv?=
 =?utf-8?B?RFR3Q0xVTDkvWmN6MWtqU2RMbCs5SUNQNHNJRktiSG5pM1crRFdHRVFzNS9H?=
 =?utf-8?B?aHlmMnNucU00UmZVbXlhTW52VU1jTy9GdnhRQk01OG5Jc1hwYzNVVjdySVpM?=
 =?utf-8?B?OTkrR2p0R1A4TFRPQkdieVlUZkdYTGUrOVptVE5pNkp0OVNVcXFOWkQvT0lV?=
 =?utf-8?B?enVPUWdvc3gvZU90UW9Zcms5NHh0d25YQWZ2WHNKMGphT3N0T0N6eUh2eWZ5?=
 =?utf-8?B?UkswTGlveGxscVZuR1V3Y2s4KzhURGNaQUJ1NnhMdmJ0bG4rWjJhQ2E5Z2p1?=
 =?utf-8?B?KzZyVm1wdTFWb0ZxM1I2aGdUV1phaGh4dHBQMHpNc282NzR1R3RjSVI1Y0FT?=
 =?utf-8?B?eTM5WVU4dk1UNVVrZTR4TjhDOXMyRmFwcDBTN0hSMklZTnNESXJ4N252YTNS?=
 =?utf-8?B?OUdHRWZySllLaEhYdXlaa1lSYXhyek5YQThwUXlGblB3Qjc0eXpzWWtwNGtN?=
 =?utf-8?B?SGRsbUhHQVhkZEtYZWlFaVhSV21CRlV6Zm9mRjloVmdtWDhyRjdBNWt1Tm9G?=
 =?utf-8?B?eS9NTFliVzduUGoyTTc4YzFpYnJuT1JHb0lBdGwvQW10RUZFTExvV3RVaEhV?=
 =?utf-8?B?TGFidlJMNGxMdHhZSWRqNmxTclZ5TUEvTzgzVCszYmhmNlBkdElHU08wdEtj?=
 =?utf-8?B?YlZYZWdtTWVpTEtjdnZ2c2lXa1QrWS9wY2dVTWxDWnNnSHJxSGRFVHR3ejRX?=
 =?utf-8?B?bStDYS9RS095SjMwL1NTN3hmUldNTlQ0MVdWZXNkNHN0azY3clVtNU0rM0ZO?=
 =?utf-8?B?dmpTOEJMQkRHQkRucy94YXVDd3pVWmNUeXl5elArMEtRZnlVb1FFQ3BFZTky?=
 =?utf-8?B?WEJFTksxWEZaVnh0Zy84OFJMVzkwNWZDSS9GSkhjNzV2VldmTWxva2tia3VO?=
 =?utf-8?B?USs5ZWprMU9KQXlTYlQxbWJNdUEvV09pRk9udndIT0VWRG9GRVQ3S2ZyVnpE?=
 =?utf-8?B?RVhoNUdXV3NDYmE1VzBYQ245dXRxeUdKWUU1ZW5jcFBzdXZNbjVkL1dkYkty?=
 =?utf-8?B?dkEvNXptSzNId215SnI2MjdiMFFPb3hRUVBOM0NqeDJlYmE0V2tOWXBCb1k5?=
 =?utf-8?B?L0FERWJ4NkJ2THBXZkhUaXhWSVY1V3plQ2dLK2ptM0dkM2pkUHVYckNQWUVw?=
 =?utf-8?B?Qzd3MElnSXpZdGxNenhYWWFZY1puK01sNFdaWGhyK2lZaE43Ny9nWTltSmYr?=
 =?utf-8?B?ZUl5ZDlBTXBNbHJxWkMzcmp2eTBxa3NhZlBFRnViTmFaaFFDV1UyVURiR1Vp?=
 =?utf-8?B?WHB6M3YwN0xIeEM1OElVT3gxQmJ6YXMzMzhjcjhtb1FtS3NSUENGbVZFNTRO?=
 =?utf-8?B?S2NRdUFSL0FNQURnT05QVXh2TDR0R2VwazNPQUlsWVU2OGlKZEpSaG54RmUr?=
 =?utf-8?B?b0lvSmwrVGxpZjRLSFJFVTdIYStnT1FTMU9vM2xyOUt0MjA0d2V0Ujk4ZzJQ?=
 =?utf-8?B?REZFOEJSY2IzTWJseTJTWnpabDBlQ3NEOFN6NTZJdUVZMzFYUkdQMjhmVVl5?=
 =?utf-8?B?L3BvYVVqeTNySjkvQXVqS1FyczcvQ0o5aFVGd0dZTWJNVXQ5ZzBMZ1pCUURm?=
 =?utf-8?B?aFc2aWlKdWNqVDBaUzAyc0c3U3NQWXFlOXY2ak9KcGw2QUlvYjZYOFZpNWRS?=
 =?utf-8?B?MnBFR3FKTWpwaTNXa29RdDRadVRCenNxNHdzbm14aE9yZDVTZ29WTTI4UmFK?=
 =?utf-8?B?V2lvdXVtbmhyZ0NuMXhiNCtYcjdWNWJMbUVJTEV5Nlg4eXgwbHo3LzhJcjcr?=
 =?utf-8?B?c3hVN1NqNlN5QVZmN28yeVk1eExSVzFNVUtyVWFUNWtXdnM3V1ROYXhhS3dP?=
 =?utf-8?B?QURUam1lTllFM1V2Q2R3L1pDZXlIdkFtd2UyZEVDU2JwbzZwc3N6eDM2aFNK?=
 =?utf-8?B?SHpvQkxaWXhXNE9vUU1CTlgyd2dUM0tZSjZBTmpLOGsraVpkRFoya2V0akpx?=
 =?utf-8?B?TkE9PQ==?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab63dbb-ef6a-4850-d04b-08dacf4f65d9
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 01:41:54.6673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jHW+unZSrsIoUSxkoVp+RsVEdRL9jafmgGvQzycxEfu+vH9NRPTbRve5oyeFbZfxZ2yX614Y+/3A7JYk2Y7VtkxYqcTePvMipTKOUi14xl0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5872
X-Proofpoint-GUID: mjmPl2V6OUO4fBtJJ3K8a5UxX9O4WOHC
X-Proofpoint-ORIG-GUID: mjmPl2V6OUO4fBtJJ3K8a5UxX9O4WOHC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-26_01,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=556 impostorscore=0 adultscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211260009
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add Florian

thanks

xiaolei

On 11/26/2022 5:43 AM, Andrew Lunn wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender and know the content is safe.
>
> On Fri, Nov 25, 2022 at 12:12:06PM +0800, Xiaolei Wang wrote:
>> If the external phy used by current mac interface is
>> managed by another mac interface, it means that this
>> network port cannot work independently, especially
>> when the system suspend and resume, the following
>> trace may appear, so we should create a device link
>> between phy dev and mac dev.
>>
>>    WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983 phy_error+0x20/0x68
>>    Modules linked in:
>>    CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
>>    Hardware name: Freescale i.MX6 SoloX (Device Tree)
>>    Workqueue: events_power_efficient phy_state_machine
>>    unwind_backtrace from show_stack+0x10/0x14
>>    show_stack from dump_stack_lvl+0x68/0x90
>>    dump_stack_lvl from __warn+0xb4/0x24c
>>    __warn from warn_slowpath_fmt+0x5c/0xd8
>>    warn_slowpath_fmt from phy_error+0x20/0x68
>>    phy_error from phy_state_machine+0x22c/0x23c
>>    phy_state_machine from process_one_work+0x288/0x744
>>    process_one_work from worker_thread+0x3c/0x500
>>    worker_thread from kthread+0xf0/0x114
>>    kthread from ret_from_fork+0x14/0x28
>>    Exception stack(0xf0951fb0 to 0xf0951ff8)
>>
>> Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
> This needs Florians review, since for v1 he thinks it will cause
> regressions.
>
>          Andrew
