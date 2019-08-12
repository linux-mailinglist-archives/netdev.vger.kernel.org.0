Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08D289C11
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfHLK5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:57:42 -0400
Received: from mail-eopbgr710057.outbound.protection.outlook.com ([40.107.71.57]:54940
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727691AbfHLK5l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 06:57:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dc4omFqfVWemhu9YDOMA+Mad+RpUkaiw2Ch36F9J+g46NYnh3ZOtoG13oCqLRnkpUkJHNAQqTALT6JDdrnyI8CPFwvhVVPqBl3MnIUWjQgT5dvCg2iWh/qwK7B9yLkf+s4HXeN1NSQXAdUs+vtQjpMs+1CdxScx++tZnuJq1lsOlm9x6Kb29qufY0MvySikj4LQ3I2RizLfeN4WDMblidqpWDw/z/c6iaUuRY9vTw2gM9yZQ0sUZEiY6oacVDIwp7Z4wyclRpxxMQBjCkfAq15CnLlvtaVk4bPIFtyTKc6BcDduXHW0ZK1g5PsLL/4ZK/40oascCVOdwpsPMuTBdmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVXssS5Rlu5MaHkDOGVKs8zgLGGbVVFyz18CZcsL+KQ=;
 b=XmyCYOQZdnpDbOZMjbXxrVqMUHDM7sxdYDxprP0FiFhYpJZK5saE6fM/S2TDgg84NgO0t7WzlbFsd6aIKJQVp5bRaXWAWmkrd4KCGUnRPDO6IL+ZwP6guoNmD9DG6uffqcrKO4N7dPA8NhmGcqCKfCvFb4+oZBwRGG4yH85agGLYsyqJdGJdhTR6d00l0H3Xrc2f61tp81ZTlYPxe0vrgfKSUQaRkdhPykelVlicAKyVg+oeVcdV52cQqBdbE2GE1o6Taup34+/mxvq6dbjPiJ1sXxnUUHm50Mt08nu5vh5YSO6iDqLJU/hH+9Xzmn4nD8Npw+1WiISOMfaOl+6r0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVXssS5Rlu5MaHkDOGVKs8zgLGGbVVFyz18CZcsL+KQ=;
 b=lQ50lKWsQDxwGdnQYR5S0DY6PX2OFceVEfsX0Hc0TOK0SR3f8lV52k5caRmSb00Fq6kYoaXlnp/BMAq2wAcIGonwC+yB0DpumqQEHCpTmL5FeaH4u2HHqZWpcgAY2J7kj9y5YPPUER+6eDz+V0nffBhX3RzgajVigv+XWsTs/vs=
Received: from CY4PR02CA0001.namprd02.prod.outlook.com (2603:10b6:903:18::11)
 by CY4PR0201MB3619.namprd02.prod.outlook.com (2603:10b6:910:8d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.21; Mon, 12 Aug
 2019 10:57:39 +0000
Received: from CY1NAM02FT059.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::208) by CY4PR02CA0001.outlook.office365.com
 (2603:10b6:903:18::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.13 via Frontend
 Transport; Mon, 12 Aug 2019 10:57:39 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT059.mail.protection.outlook.com (10.152.74.211) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 10:57:38 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1hx81C-0002XA-Ab; Mon, 12 Aug 2019 03:57:38 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1hx817-0004P4-58; Mon, 12 Aug 2019 03:57:33 -0700
Received: from [172.30.17.116]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1hx812-0004Op-VI; Mon, 12 Aug 2019 03:57:29 -0700
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
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <c09ae89a-509d-55e7-a2d6-44ca2543f333@xilinx.com>
Date:   Mon, 12 Aug 2019 12:57:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <cb8f91b5-174f-79e5-d476-b01da2f3a65c@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(39860400002)(376002)(2980300002)(189003)(199004)(70586007)(70206006)(31696002)(9786002)(486006)(126002)(8936002)(426003)(11346002)(476003)(446003)(2616005)(36756003)(230700001)(65826007)(44832011)(316002)(36386004)(58126008)(2906002)(5660300002)(356004)(6666004)(4326008)(50466002)(6246003)(336012)(64126003)(63266004)(31686004)(186003)(229853002)(76176011)(110136005)(478600001)(26005)(65806001)(65956001)(81156014)(81166006)(305945005)(106002)(47776003)(23676004)(8676002)(52146003)(2486003)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0201MB3619;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d54d0e06-de8a-436b-b760-08d71f13e463
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:CY4PR0201MB3619;
X-MS-TrafficTypeDiagnostic: CY4PR0201MB3619:
X-Microsoft-Antispam-PRVS: <CY4PR0201MB36194174467ADC4C1417D7DFC6D30@CY4PR0201MB3619.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: jY6xF4zyconLDR8q/JTXBH391unqrcPwN50zzTaFJZ77Mvu/w9E3jtXuDsyR5TS931EgGKggWQiUa7okgkjJPARplT+XVD+gGdXo05f0hDkb119r8ZhfDwFOaEf2QsdNm9E9m2hpj1UlHyFB0+QCB48d7yibA6+BOevRWB67QWQ452SURGTdoTxoTZ/6kpfaJiqq7aeN//zjlZ73mz1rbwxsytY50XdvyMSyFqsdiABfxbEZ4J4GPx0+hzPvAXiED+IAoSgmdsJkEr9OUR8Hsf/oqWxTPNQsZCaF97MO+cv9E1AyUXV4EkKB8LXuvP76TzEOamp2QMLsyiG7vGh6RmJ0px/XlqLaY+aD7uYzOTA/LnZMWsyy4+ayePwF8FBEncdG3eHXGCxywNDPOr1oXzxRvppxSHdhAHPVRhdeGtc=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 10:57:38.7910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d54d0e06-de8a-436b-b760-08d71f13e463
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0201MB3619
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12. 08. 19 12:47, Marc Kleine-Budde wrote:
> On 8/12/19 12:18 PM, Michal Simek wrote:
>> On 12. 08. 19 11:10, Marc Kleine-Budde wrote:
>>> On 8/12/19 11:05 AM, Marc Kleine-Budde wrote:
>>>> On 8/12/19 9:28 AM, Appana Durga Kedareswara rao wrote:
>>>>> This patch series fixes below issues
>>>>> --> Bugs in the driver w.r.to CANFD 2.0 IP support
>>>>> --> Defer the probe if clock is not found
>>>>>
>>>>> Appana Durga Kedareswara rao (3):
>>>>>   can: xilinx_can: Fix FSR register handling in the rx path
>>>>>   can: xilinx_can: Fix the data updation logic for CANFD FD frames
>>>>>   can: xilinx_can: Fix FSR register FL and RI mask values for canfd 2.0
>>>>>
>>>>> Srinivas Neeli (1):
>>>>>   can: xilinx_can: Fix the data phase btr1 calculation
>>>>>
>>>>> Venkatesh Yadav Abbarapu (1):
>>>>>   can: xilinx_can: defer the probe if clock is not found
>>>>
>>>> Please add your S-o-b to patches 4+5.
>>>>
>>>> As these all are bugfixes please add a reference to the commit it fixes:
>>>>
>>>>     Fixes: commitish ("description")
>>>
>>> Add this to your ~/.gitconfig:
>>>
>>> [alias]
>>>         lfixes = log --pretty=fixes
>>> [pretty]
>>>         fixes = Fixes: %h (\"%s\")
>>
>> This is understandable and I have this in my .gitconfig for quite a long
>> time. And this is just log
>>
>>> and then use $(git lfixes $commitish).
>>
>> But what do you mean by this? Are you able to add this to commit message
>> just with sha1?
> 
> First identify the commit that this patch fixes then go to the command
> line and enter
> 
>     git lfixes $committish
> 
> and git will print out the line that you can copy directly to the commit
> message.

ok. I thought you have any nice way to directly add it to commit message
without c&p.

Thanks,
Michal

