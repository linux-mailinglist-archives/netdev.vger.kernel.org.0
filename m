Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4300189B34
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfHLKTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:19:07 -0400
Received: from mail-eopbgr720068.outbound.protection.outlook.com ([40.107.72.68]:46879
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727667AbfHLKTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 06:19:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OyTeOXMC4wT2pCDiHjlLOH8ms2h7M2RG5Ev61NWM6h/YjL9P06jJq4hgeLLYGMX0shNIWiwYHCKndW5jsA0OeUdh14NrIYSPTdpzQgK8ePH/1EmYba8Ut4nflhaLNkrYwuvbA/4oyXicH7FYOHDpV/UDbzbljFUD9rq4haZ9t/tByy3iKgf64u/Z2XbPf9KqWDMT8iuuK+VLJS94NlmJ4aYADUogR7C+uFSSz/qtw+CZzLo8k1eBwv9b3nInLgxYdgioucLGHFyizzwvzl9QXmRjlYAH8kJKwVDQxn0E9bXE+jWlU1frvcEUq9xeNIT2wS+68tm3k6aGFFBjKZhtWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZeetDjJfYeeqnZS8zVT2wy9I0PQ5l09By7R2fVwFHE=;
 b=XW/3pOdIOGpa6ud8FczcHDJH6dNFho2IkL4w0Wq5aMZjxvcQ6nvp07m47TzQ1MQOoQVXDTXbIC57GOpehvKWUNg5VhVC+AwA/up5GGz+RMIKEEa5Qqu/9gP8tZtcac+f+ffqgxVJBSJkEWJFKYMeq6/whK8eqf4k4um/WHdwNQsOhC0/UcyzAn0PFUh36i485nftdC/kBVMe21M06gYFy/lPhKtnKngVai7Yuj+KwfQfQRN3OYDiPu9P94DIOPvxXsqPLdn1r7iluLELygwr4kWEjZ9zbH6A2rpgD0uvUKqwccAlbl1JS3ZgD75IHv3YWfw8T+muyL9XVCwxUs7PqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.100) smtp.rcpttodomain=pengutronix.de smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZeetDjJfYeeqnZS8zVT2wy9I0PQ5l09By7R2fVwFHE=;
 b=On9vVJySpD5OQ7THkQHIxvPUzwsTnogQ8OuCP8mpoGo74xcbot2XkXAbVmgXg8Fazd5GcAc543WNRS8dWr6C6+m0LXG2PwGya9KSPYzCemKa7a+FKB0A8bTx3wtIGCvaCQ0n5rHaq/WRQqUfpYRwl3jwyF43qrP3VKv956G54Ms=
Received: from BYAPR02CA0053.namprd02.prod.outlook.com (2603:10b6:a03:54::30)
 by SN4PR0201MB3631.namprd02.prod.outlook.com (2603:10b6:803:47::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14; Mon, 12 Aug
 2019 10:19:02 +0000
Received: from SN1NAM02FT014.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::204) by BYAPR02CA0053.outlook.office365.com
 (2603:10b6:a03:54::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Mon, 12 Aug 2019 10:19:02 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 SN1NAM02FT014.mail.protection.outlook.com (10.152.72.106) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 10:19:01 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:42417 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1hx7Pp-0007UK-5O; Mon, 12 Aug 2019 03:19:01 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1hx7Pj-0007is-Uo; Mon, 12 Aug 2019 03:18:55 -0700
Received: from xsj-pvapsmtp01 (xsj-pvapsmtp01.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x7CAIo2a008360;
        Mon, 12 Aug 2019 03:18:51 -0700
Received: from [172.30.17.116]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1hx7Pe-0007i2-Ig; Mon, 12 Aug 2019 03:18:50 -0700
Subject: Re: [PATCH 0/5] can: xilinx_can: Bug fixes
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        wg@grandegger.com, davem@davemloft.net, michal.simek@xilinx.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1565594914-18999-1-git-send-email-appana.durga.rao@xilinx.com>
 <7ecaa7df-3202-21d8-de93-5f6af3582964@pengutronix.de>
 <5571da8a-de1f-f420-f6b7-81c6d8932430@pengutronix.de>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <f0e3360d-7c9a-a455-f63c-7fb584dfad2f@xilinx.com>
Date:   Mon, 12 Aug 2019 12:18:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5571da8a-de1f-f420-f6b7-81c6d8932430@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(136003)(346002)(2980300002)(199004)(189003)(6246003)(8676002)(426003)(11346002)(63266004)(478600001)(81156014)(81166006)(446003)(2616005)(5660300002)(47776003)(229853002)(65956001)(65806001)(64126003)(106002)(316002)(58126008)(8936002)(2906002)(4326008)(110136005)(36386004)(486006)(31686004)(44832011)(70206006)(70586007)(126002)(336012)(476003)(31696002)(52146003)(23676004)(2486003)(36756003)(53546011)(65826007)(186003)(6666004)(9786002)(50466002)(356004)(305945005)(230700001)(76176011)(26005)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0201MB3631;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:xapps1.xilinx.com,unknown-60-100.xilinx.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1226778f-1e31-4776-0c0f-08d71f0e7f15
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:SN4PR0201MB3631;
X-MS-TrafficTypeDiagnostic: SN4PR0201MB3631:
X-Microsoft-Antispam-PRVS: <SN4PR0201MB36315EA5B34C3A85A782DCB4C6D30@SN4PR0201MB3631.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: PgUyL6alUg6T/p9pX/lkGiosEVpWCIGjvlLs6tcJuwiKxh8u1yANG6eSW36kw65Qw/qvMbQlKQMAoooQt5yQN3tGqG3MG8vERgnYloDxn0lUz5MmOkqdUBKRGDS99PpxSGGugd9lpB+KXzE4I8qeQ3k/tPOcVuh+428jDQokc28P5Hkl1j6EMxoKnsJ+ciGeZHyA+m69XUbow8GQU+IshhqKGT2ySnjUICCSsYdBpEQgwamzkIkG94Y7BhBCI+tVSv7qK0msG5yh2ZNgBrupKLzMEgGPeCm4D0uElfQmZRT1GgbBHaxOwFBeoDsMND8/rBN+Kzac1V4e/vNg6n7F/g5C+L35ozIaTUCSJqR9U4REp/KawtJFu0cR8oL1nPXmuSo88GwO0eLGW58IlqEiublM30MzxlEK6p9uK3ZajWs=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 10:19:01.5401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1226778f-1e31-4776-0c0f-08d71f0e7f15
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0201MB3631
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12. 08. 19 11:10, Marc Kleine-Budde wrote:
> On 8/12/19 11:05 AM, Marc Kleine-Budde wrote:
>> On 8/12/19 9:28 AM, Appana Durga Kedareswara rao wrote:
>>> This patch series fixes below issues
>>> --> Bugs in the driver w.r.to CANFD 2.0 IP support
>>> --> Defer the probe if clock is not found
>>>
>>> Appana Durga Kedareswara rao (3):
>>>   can: xilinx_can: Fix FSR register handling in the rx path
>>>   can: xilinx_can: Fix the data updation logic for CANFD FD frames
>>>   can: xilinx_can: Fix FSR register FL and RI mask values for canfd 2.0
>>>
>>> Srinivas Neeli (1):
>>>   can: xilinx_can: Fix the data phase btr1 calculation
>>>
>>> Venkatesh Yadav Abbarapu (1):
>>>   can: xilinx_can: defer the probe if clock is not found
>>
>> Please add your S-o-b to patches 4+5.
>>
>> As these all are bugfixes please add a reference to the commit it fixes:
>>
>>     Fixes: commitish ("description")
> 
> Add this to your ~/.gitconfig:
> 
> [alias]
>         lfixes = log --pretty=fixes
> [pretty]
>         fixes = Fixes: %h (\"%s\")

This is understandable and I have this in my .gitconfig for quite a long
time. And this is just log

> and then use $(git lfixes $commitish).

But what do you mean by this? Are you able to add this to commit message
just with sha1?

Thanks,
Michal



