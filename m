Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EF327896E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgIYNXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:23:17 -0400
Received: from mail-eopbgr20067.outbound.protection.outlook.com ([40.107.2.67]:40550
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728872AbgIYNXR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 09:23:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bTgwsuOPeNHl9PlpQsGNILyeqfgxCldCa9H2JA7efLw=;
 b=etE6KMuRZ85pnAya+bvtN++C4I8wbVgFkSps6kY0eGT6AWTcZTm3NWm+9pRaAy3BHVhWtnjHe+ixJX09Pyw20CmWbgcofSNf3nhFeXkwpvDPuj+6IXj5F3MMtLkM0vvIt7pNfdknzbGXt6H+Sh087gMYHvZ5tshv/nNOzeuEvVo=
Received: from AM6P192CA0071.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:82::48)
 by AM6PR08MB5542.eurprd08.prod.outlook.com (2603:10a6:20b:71::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Fri, 25 Sep
 2020 13:23:04 +0000
Received: from AM5EUR03FT029.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:82:cafe::99) by AM6P192CA0071.outlook.office365.com
 (2603:10a6:209:82::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend
 Transport; Fri, 25 Sep 2020 13:23:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT029.mail.protection.outlook.com (10.152.16.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.21 via Frontend Transport; Fri, 25 Sep 2020 13:23:04 +0000
Received: ("Tessian outbound 7161e0c2a082:v64"); Fri, 25 Sep 2020 13:23:04 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 6ad9d0d2c59c6b2b
X-CR-MTA-TID: 64aa7808
Received: from 297697a109ec.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 5799906F-3E4B-4A08-91DE-745B69FA69F9.1;
        Fri, 25 Sep 2020 13:22:58 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 297697a109ec.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 25 Sep 2020 13:22:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Im2lS9uOMEzAVa8p2XvNQH4GSotodbED99cuoYN+96EKXN7OZExwgpx7sewxqAvc9AfzSME5oUPi2S++E4q/jXuennffXZU56BX4BGxjlGyIu123atYDHhIdRuKNKBDGM1t0DoOIKqfY8JJh3Nnm67AboWldg5EigBCYFiwumEFihuoKhnuESlcl+h8YNw37oaKzQMyfirAv3uBnGC4fzUHqsE98P49fz6fpvB6fT69KtOMHOfY49G/T3IK541kxdVejZ83bTEDqLiJtwRSTLyqQr0GcsOpNzUzsSA2HyKyAlwPddzXkSpKlnj02xiHJtIbdmxtC3cDHpFKMGqzIbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bTgwsuOPeNHl9PlpQsGNILyeqfgxCldCa9H2JA7efLw=;
 b=fU9RAJN+PM2ZzQdH8iKDZeU9Ae3Q6gpdgk8kUvGhu3zYNY7FRQY7kYgaz2qAV4ZDdLFxsqcOn+QImzl/+mlYlHF19CqHGkDuRUE7cn2k4y0yKb7HSCWliNbxTxgI0OADInG25n1UVB1pUVVLLgqQbfEYwGm2uGGlYqVeBCvEhPTGSKpkMxyNBhfqaDR+L3fq6nHoc/fyMf2Yxgay4bXwlpT7GY+bU66pWGtxNlPVnShF9pMFSa36myFHfoR9ggNg8HQenEjLneFOWPSOXlioa2xwhUa24G6Eyimmo2RiFrZiFOocWdZra+eL9b3Nag9Qa/4C91NTzaUVJbVH+X+1mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bTgwsuOPeNHl9PlpQsGNILyeqfgxCldCa9H2JA7efLw=;
 b=etE6KMuRZ85pnAya+bvtN++C4I8wbVgFkSps6kY0eGT6AWTcZTm3NWm+9pRaAy3BHVhWtnjHe+ixJX09Pyw20CmWbgcofSNf3nhFeXkwpvDPuj+6IXj5F3MMtLkM0vvIt7pNfdknzbGXt6H+Sh087gMYHvZ5tshv/nNOzeuEvVo=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB4007.eurprd08.prod.outlook.com (2603:10a6:20b:a1::29)
 by AM6PR08MB4007.eurprd08.prod.outlook.com (2603:10a6:20b:a1::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Fri, 25 Sep
 2020 13:22:56 +0000
Received: from AM6PR08MB4007.eurprd08.prod.outlook.com
 ([fe80::9904:4b6c:dfa2:e49f]) by AM6PR08MB4007.eurprd08.prod.outlook.com
 ([fe80::9904:4b6c:dfa2:e49f%6]) with mapi id 15.20.3412.022; Fri, 25 Sep 2020
 13:22:56 +0000
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Dan Callaghan <dan.callaghan@opengear.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King <linux@armlinux.org.uk>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, "linux.cj" <linux.cj@gmail.com>,
        linux-acpi <linux-acpi@vger.kernel.org>, nd <nd@arm.com>,
        Rob Herring <Rob.Herring@arm.com>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch>
 <1595922651-sup-5323@galangal.danc.bne.opengear.com>
 <20200728204548.GC1748118@lunn.ch>
 <7d42152a-2df1-a26c-b619-b804001e0eac@gmail.com>
 <CAHp75VejnW23LEfyEO6Py8=e3_W0YMomk8jQ3JQeHqYcaeDitg@mail.gmail.com>
 <20200731151444.GI1712415@lunn.ch>
From:   Grant Likely <grant.likely@arm.com>
Message-ID: <e48957a9-b92a-f2d2-6157-39e8c225311d@arm.com>
Date:   Fri, 25 Sep 2020 14:22:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20200731151444.GI1712415@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0470.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::26) To AM6PR08MB4007.eurprd08.prod.outlook.com
 (2603:10a6:20b:a1::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.16.147] (188.28.154.24) by LO2P265CA0470.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 13:22:54 +0000
X-Originating-IP: [188.28.154.24]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2be5fe35-b9ce-41a8-abd1-08d86156229a
X-MS-TrafficTypeDiagnostic: AM6PR08MB4007:|AM6PR08MB5542:
X-LD-Processed: f34e5979-57d9-4aaa-ad4d-b122a662184d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB5542D8469CE07B23B983D8F295360@AM6PR08MB5542.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: oFmG6i07X85UrIomn0zfjsuqvTokMjXE3j4+3IXqYsqRP/Z98jadktfORwYmuqfQ50t3gv+m2hBx4JlLsxNnWK+rxwo8t9fYxMVic89cZmaX0MvWBgcxMAg4nsqJg1p8UMN5WlJiTBWnXFmjUikBTw6vVp46K8tgr295RpRi9aoaJ7oFWPMygYJpkdv7Fk0de3OOSgpVvmirLgnCdS4/9MXRWbBf9jm9MEiJ8KQ3btd6h+MHXGxPdC354mZI/BrefZQMcNT7i7cNYiCPCiywytXtpE/pkcCknHbhMbb0k5EYJsWY6EWWsE+gvQnG4Ng/p8KHUQ+mQ59qY9HazXXr3tcB09cwz+l9T0WF0oNe6PlPIJOgA41Qy8aV10TSlKG3SKzrkqo8fQ87GSf8GljIoFu8GHaAyse87EO+eXunCS4=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4007.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(86362001)(66946007)(5660300002)(44832011)(16576012)(54906003)(478600001)(7416002)(31696002)(316002)(110136005)(31686004)(8936002)(66556008)(2616005)(26005)(55236004)(186003)(6486002)(53546011)(52116002)(66476007)(956004)(4326008)(2906002)(8676002)(36756003)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AztizN6LRvcSgsXUfHoFnJP1D1wU8iXWOZU5Bu9gCUXQBEt6BEFpyk2ZKRLuhe4muLBNqQTchGFjEGD3ip8q4xlwGHjNQJ1zbi5mjZ7MY0aDfTMd+ad0S4/mAnPUY7VYMaB6Qtn8TDZkcLp8fPKluKIcC/DjmECq5oRa/rPKgu2LwuqqKDeF0DZUoq+2P2GOjogzXqPDnoASy3/6DQk2pe18WIe52qIfUqc/swj+itlktJ7yp4smYSVl67Hbj3eyML6UAsz8H/Fvl81UXwmFyuEgUtsfP8YP6erU7iieHqsT0nwwCt5eMIcqZtj9z+aPdgDysqpMRLqVBPZTZFkPPAHASgW7HGx5nG44NiZyGsz7Qs2nHYu6L2aUKz6eTcrJo7/ov4CFGpsk1Pz/jO3lT1PdEtxCddCXnYzP6oozlNXiSXTl54rv1DuL3IHm26PIPHle7MbTF3otQwwuglHzTEajXPm1VMkkkswpS4iUvndzL0Ff5AEog/Ent4BYJYf0gvdFRg8BNm/oq8+RUnZVcI51gt9EzVgdvLkDik7SFwADjCHxH1u3o/8OB68oWgTy6RT6rMO12kDwyoTmGbKWcW6x1iSthJ5lbJT6gePrb6+mdudC/AGtxuKb4tvW5zpegGiWpJFUv22YVRPeLVyvAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4007
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT029.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: de4484b8-5495-4bab-d72e-08d861561d5e
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KevtEz8ARb1rz2ejSFS9V7KYW4hzotLFAFCGm5HcPoEFHEmtMSmsyyIKJ0o9tdjpP7UjW0Zvr0o3vSKtB5cYC/67Wvqg9DIFXKM11YkPl5JYrbBmAr0Anr0cqUELFSUsQVnUIFySCE9iz1+9VwHXZmqzVtIV/kOqBJExt3jj8f4lQTHwTIoB/EHCMcEQNl+yonoOUR5C2d5oj6T3bVjYEbjTQA8W32f+fXbCB1gWgUie8UIXywAe1Vras78ELI+fHKgD7hLiWjWaaQEMzgvdvQpHZZXYCCtdsFcWqqjMfuiM/9+JS9TRTdrBdJ8ioxVvZ3ppwKcZ3KHBwgEaPXUSStgiEYb43LAXlph26G8PQwEYkKBn7jXuqeiniD1BPJ5ndz2kzQWtKf/VBMutwr5eAfooy+AScpT5ekx/Fq0fGtXZLVqxayiV5xWHoTGL7Th2jdWtoSmnFU70/GLx7Lnxm/VHXAhvmXqip5LndpzCXXQ=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(46966005)(54906003)(16576012)(70206006)(8936002)(316002)(5660300002)(82310400003)(81166007)(36906005)(86362001)(356005)(478600001)(8676002)(2906002)(31696002)(70586007)(26005)(336012)(450100002)(2616005)(31686004)(186003)(53546011)(16526019)(36756003)(82740400003)(44832011)(110136005)(47076004)(6486002)(956004)(4326008)(55236004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 13:23:04.7739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be5fe35-b9ce-41a8-abd1-08d86156229a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT029.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB5542
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31/07/2020 16:14, Andrew Lunn wrote:
>>>> DT can be used on x86, and i suspect it is a much easier path of least
>>>> resistance.
>>>
>>> And you can easily overlay Device Tree to an existing system by using
>>> either a full Device Tree overlay (dtbo) or using CONFIG_OF_DYNAMIC and
>>> creating nodes on the fly.
>>
>> Why do you need DT on a system that runs without it and Linux has all
>> means to extend to cover a lot of stuff DT provides for other types of
>> firmware nodes?
> 
> As i said, path of least resistance. It is here today, heavily used,
> well understood by lots of network developers, has a very active
> maintainer in the form of Rob Herring, and avoids 'showflakes' as
> Florian likes to call it, so we are all sharing the same code,
> providing a lot of testing and maintenance.
> 
> 	  Andrew

Hi Andrew,

I'm just coming into this thread now. With my alumni DT-maintainer had 
on I think that trying to use ACPI & DT on the same system is the worst 
of both worlds. Trying to do so makes the solution far more complicated 
than either an ACPI-only or DT-only approach. There is no good way for 
references between DT & ACPI nodes. I have serious doubts about the 
reliability of the dynamic DT code in the kernel. Perhaps most 
problematic is it excludes platform specific data from the ACPI 
description provided by firmware, which means platform-specific data 
needs to be shipped with the OS. Rather defeats the whole point of 
firmware providing the platform description. An ACPI solution is 
absolutely needed.

Regarding this specific series, I think it is approximately the right 
approach. I have some specific concerns that I've talked with Calvin 
about and I'm going to post as replies to the individual patches. My 
most significant concern is the reference from the ACPI MAC node to the 
MDIO node, which makes little sense. The MAC should have a reference to 
the PHY node.

There have been other issues raised in this thread. I'm going to go back 
and respond to a few of those points in separate emails, but as a larger 
issue I think there is a fair bit of misunderstanding on what ACPI does 
and does not do, and how much is expected to be standardized in ACPI 
specs. In the ACPI world the typical model is the firmware/platform 
vendor decides what data to put into the ACPI nodes that works for them, 
and then the OS just has to deal with it. Linux typically never gets a 
choice about what goes into ACPI nodes.

Already, threads like this one are setting the bar *far* higher on ACPI 
schema than has ever been done before. I do think it is right to be 
asking for a common data model for describing PHY connections. Lining 
the model up with the DT PHY model is also valuable because we can use 
common code. I also think as first through the door, what gets accepted 
(after review) for the layerscape platforms here should become the 
defacto standard that other vendors are expected to adopt, and I have 
very high confidence that it will be acceptable because it follow the 
pattern already used in devicetree.

Cheers,
g.
