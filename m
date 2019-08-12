Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43F0989C4F
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfHLLF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:05:58 -0400
Received: from mail-eopbgr820053.outbound.protection.outlook.com ([40.107.82.53]:31073
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727980AbfHLLF6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 07:05:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9I1JVB3IxqEueiu3W1zXK1XjOESmskvxxcQFkNmhsHzc4RYW7YTLTNKDPcW74n6SIF+xH9uBJ1cm6PCqhijFA39O8HY6iSVmJnxVRGaEqtSs1lyWgxUzPXZDwGnnKDlWzOULriLa6kub0YIfJvP10blziUXIiTFOyQmRviRPNcHnN2p23g+ptQyyB+QpkddKScUVNrWHA785VlHigHRToaoEkBpGlIUcx/CZLAEYDRAFPNWA8ciQ+EeXP0j+Mco7qy7ZjwFfQTnBRywZNx62yaL9AsonWiSceLZ7OHBG/cQdGJZ/9I6909+CZZdawIV2A4qSn/DJny/6TWbV250ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0yC7c27b03C8UOQUep5urDnwYrr1WM479GAlFkcZf4=;
 b=acvBeimMvLvRoC559x0170s9bxrQToWS0cNb93D0qCQNgvpjjmsuWtAfbbVBKe7f7+4Qu969d9F5ajJowsJJasZidvNXK/PCOvmJg+JLZmDyUbCY/TOF7PuGeMV8gf4U6AftAoaseyBjtRDGc5IWQ3DP3yU1o8Xm5SYkaSjEdlVUGMBIYlVrIlu7zs3lpFqwRQa/0oKb7/y7EbXdW36CncD2jmsje9bDRyzkfDNF2dBdZmkD2GMAur+0Ea/rTRBfxxWcEPLJ0bCb0YjtF2mCvw+oO2WycHQOhuSRIAkxqHpTqDqctE+yfxKcPuEKOmiKUJMFWJ3nroiay+MDkc95ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.100) smtp.rcpttodomain=pengutronix.de smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0yC7c27b03C8UOQUep5urDnwYrr1WM479GAlFkcZf4=;
 b=IaBMqPtz7mUfQtHzTbM6RucIfOg7vW1YV04pZ4INvhtZ/Zo+S3w5S0uTezimPjH49KoDItjRPNdyFExj0MG7riCdnljpWu35l6ToWYBnTmOqN/bJaTrKDh+n8H8oeTJiI63OVgPGdaRxXkajAtBw0Lw9P8hrERwlJof8B4jVokg=
Received: from BN6PR02CA0099.namprd02.prod.outlook.com (2603:10b6:405:60::40)
 by BL0PR02MB3795.namprd02.prod.outlook.com (2603:10b6:207:3e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Mon, 12 Aug
 2019 11:05:54 +0000
Received: from BL2NAM02FT062.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::200) by BN6PR02CA0099.outlook.office365.com
 (2603:10b6:405:60::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.15 via Frontend
 Transport; Mon, 12 Aug 2019 11:05:54 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 BL2NAM02FT062.mail.protection.outlook.com (10.152.77.57) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:05:54 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:40585 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1hx89B-0008Dg-Uq; Mon, 12 Aug 2019 04:05:53 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1hx896-0007np-Pg; Mon, 12 Aug 2019 04:05:48 -0700
Received: from xsj-pvapsmtp01 (xsj-pvapsmtp01.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x7CB5fqU020034;
        Mon, 12 Aug 2019 04:05:42 -0700
Received: from [172.30.17.116]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1hx88z-0007mq-IP; Mon, 12 Aug 2019 04:05:41 -0700
Subject: Re: [PATCH 0/5] can: xilinx_can: Bug fixes
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        wg@grandegger.com, davem@davemloft.net
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1565594914-18999-1-git-send-email-appana.durga.rao@xilinx.com>
 <7ecaa7df-3202-21d8-de93-5f6af3582964@pengutronix.de>
 <5571da8a-de1f-f420-f6b7-81c6d8932430@pengutronix.de>
 <f0e3360d-7c9a-a455-f63c-7fb584dfad2f@xilinx.com>
 <cb8f91b5-174f-79e5-d476-b01da2f3a65c@pengutronix.de>
 <c09ae89a-509d-55e7-a2d6-44ca2543f333@xilinx.com>
 <6b36bbcb-06e3-63aa-8861-c07c8840e25e@pengutronix.de>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <d8e17519-9cc4-cdf8-2acc-215592782625@xilinx.com>
Date:   Mon, 12 Aug 2019 13:05:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6b36bbcb-06e3-63aa-8861-c07c8840e25e@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(136003)(376002)(2980300002)(199004)(189003)(26005)(76176011)(2486003)(23676004)(230700001)(65806001)(336012)(426003)(53546011)(6246003)(446003)(11346002)(2616005)(476003)(126002)(486006)(36386004)(44832011)(50466002)(36756003)(47776003)(65956001)(229853002)(81166006)(8676002)(81156014)(52146003)(356004)(478600001)(4326008)(31696002)(63266004)(316002)(5660300002)(58126008)(2906002)(31686004)(64126003)(65826007)(305945005)(8936002)(9786002)(186003)(106002)(70206006)(110136005)(70586007)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR02MB3795;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:xapps1.xilinx.com,unknown-60-100.xilinx.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25f147a3-3701-4bee-5f9d-08d71f150ba9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BL0PR02MB3795;
X-MS-TrafficTypeDiagnostic: BL0PR02MB3795:
X-Microsoft-Antispam-PRVS: <BL0PR02MB37958907277BFC58CDC2A8E2C6D30@BL0PR02MB3795.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 6Oku2ovMeXoQRS3BnaQ7PjYzFH8h/SaF3+3Ac/2BwCC+KE70LJTe2dWgs58DyZa/DXGV3B7btuWrOVoxtzQF4od/mwxie4zOlV7Tm6ush1rE0B3Xpy/s30otNkld/QsuV0LshwlqVajuRCnrEpDzTi+tfksb5ay1Rogi2kJhQUkyHvlDOVkacJNM/AE+ZzTouDyP1VDPUk/pdXSVyhgL1Z6HVAvn9htSC5woMW9xcseef2D3TCmqI930YcoEE1Wk8VN2ZSvVKAroQB9ZoZPmomC99nRLyojFtIwPgR7rlDxmwhNMm9FPe1d5cpdmkZ+VRWcvf0bTJD9hdMrY8B91s3VqVVIoJ8MGHhnE4OVPse2f0t07COjr7sOW5E3cEiMCVFsb+gGP3/zBQ72QpBjz1ch0/LlWiXzNJ9vvi+CnpbE=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:05:54.4856
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25f147a3-3701-4bee-5f9d-08d71f150ba9
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB3795
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12. 08. 19 12:59, Marc Kleine-Budde wrote:
> On 8/12/19 12:57 PM, Michal Simek wrote:
>> On 12. 08. 19 12:47, Marc Kleine-Budde wrote:
>>> On 8/12/19 12:18 PM, Michal Simek wrote:
>>>> On 12. 08. 19 11:10, Marc Kleine-Budde wrote:
>>>>> On 8/12/19 11:05 AM, Marc Kleine-Budde wrote:
>>>>>> On 8/12/19 9:28 AM, Appana Durga Kedareswara rao wrote:
>>>>>>> This patch series fixes below issues
>>>>>>> --> Bugs in the driver w.r.to CANFD 2.0 IP support
>>>>>>> --> Defer the probe if clock is not found
>>>>>>>
>>>>>>> Appana Durga Kedareswara rao (3):
>>>>>>>   can: xilinx_can: Fix FSR register handling in the rx path
>>>>>>>   can: xilinx_can: Fix the data updation logic for CANFD FD frames
>>>>>>>   can: xilinx_can: Fix FSR register FL and RI mask values for canfd 2.0
>>>>>>>
>>>>>>> Srinivas Neeli (1):
>>>>>>>   can: xilinx_can: Fix the data phase btr1 calculation
>>>>>>>
>>>>>>> Venkatesh Yadav Abbarapu (1):
>>>>>>>   can: xilinx_can: defer the probe if clock is not found
>>>>>>
>>>>>> Please add your S-o-b to patches 4+5.
>>>>>>
>>>>>> As these all are bugfixes please add a reference to the commit it fixes:
>>>>>>
>>>>>>     Fixes: commitish ("description")
>>>>>
>>>>> Add this to your ~/.gitconfig:
>>>>>
>>>>> [alias]
>>>>>         lfixes = log --pretty=fixes
>>>>> [pretty]
>>>>>         fixes = Fixes: %h (\"%s\")
>>>>
>>>> This is understandable and I have this in my .gitconfig for quite a long
>>>> time. And this is just log
>>>>
>>>>> and then use $(git lfixes $commitish).
>>>>
>>>> But what do you mean by this? Are you able to add this to commit message
>>>> just with sha1?
>>>
>>> First identify the commit that this patch fixes then go to the command
>>> line and enter
>>>
>>>     git lfixes $committish
>>>
>>> and git will print out the line that you can copy directly to the commit
>>> message.
>>
>> ok. I thought you have any nice way to directly add it to commit message
>> without c&p.
> 
> You can insert the output from a console command in vim by adding a "!"
> in front of it in the command mode.

ok.
M


