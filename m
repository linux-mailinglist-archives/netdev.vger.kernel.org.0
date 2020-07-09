Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200AE21A135
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgGINwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:52:25 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:7926
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726660AbgGINwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 09:52:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUezmG9seYnu1ZAB5mN2i9kToubSwxaPQhPVr91KftjBxKYyXMOzL6DDKRfHlrK1MfLw7Wsl9H1zbPIN1Erd/RKf2QbKxN2YiTeDmg8l0QHvHjUMmD8bGjd5vh3804zWUQYf46a6bI+d65j3U0PilvE4U/xM09O7lmfxnPtjldRI6vEVN+jJ0gwH/aXupTdnGBNEAEno5ggGTMTVcRcBuxcVqOxw5VLzGDeTN9sgu64cN1Bs15qP9+fEXstRKF3HkgIzKxLVTFcK7BFQVT2DSSdVC3W/z+ZUBIrf7uWEsUPGgHQmZ/Mdq0WBX0RXWZqCZQnfG7ojKrKIdoJSyQ1D5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3FsdOF+klRU3CJrhXMVMZ6V/mlYTQPZ49hReG+RI00=;
 b=bW3705rRG4UhZYvsR/IjqNGhKDQuJfTc6THTh06kVQfVOnnzVJZCdFNM4PaMRptb/edQhDmqFz0JKCjVSqBRRC/8RH04yufSklgpjs8wdbNQUj9YxE5PJaZ8yQ8GzZHnkmkbuJ5nXTSl9pb8NZRvStBydZ1s7u42KmXqPBn9BxwFyR2s6jeOAt0QTQgzqNPhtcBagJuvsavsedkUxK0BlDzN22ILyY45nfu9Jgy8NiQq+17AlWXWI0TthuSjlgxzmVYEJInOUpU3led3knPsHCJz04iSYihAwL3Hb+l2FEoV9NhJWVlCsX3p+yGMm9fDlL3ZOI983vsdzn/srCauOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3FsdOF+klRU3CJrhXMVMZ6V/mlYTQPZ49hReG+RI00=;
 b=An7HCyG+MKEQbf3k0ED0uaH3Fh567RBz807w5SxMDWOLuffT2FmmNjkngsQhnFD//WlYmwC79sNA8uE4LlF2Ei1K8NHMFffLU6ndBqxq4AG0Xs8unAewxhYPduvIGCSgnnFETGacOHKjMCNyEhfSmxjRC4h6wYl7CzUw6Vzk87M=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=mellanox.com;
Received: from DB6PR0501MB2648.eurprd05.prod.outlook.com (2603:10a6:4:80::18)
 by DB8PR05MB6666.eurprd05.prod.outlook.com (2603:10a6:10:141::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Thu, 9 Jul
 2020 13:52:18 +0000
Received: from DB6PR0501MB2648.eurprd05.prod.outlook.com
 ([fe80::4468:73d7:aecb:d08]) by DB6PR0501MB2648.eurprd05.prod.outlook.com
 ([fe80::4468:73d7:aecb:d08%7]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 13:52:18 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [PATCH net-next v2 0/3] ] TC datapath hash api
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20200701184719.8421-1-lariel@mellanox.com>
 <13b36fb1-f93e-dad7-9dba-575909197652@mojatatu.com>
 <8ea64f66-8966-0f19-e329-1c0e5dc4d6d4@mellanox.com>
 <7c673079-043d-927b-fba2-e7a27d05f3e2@mojatatu.com>
 <CAM_iQpXLBrJggTQU3+MpdHPh1zQcN4T-HCTmqiPaKd6Cda-_2g@mail.gmail.com>
Message-ID: <8d10f338-fd11-4033-f0e0-b6fca42a5495@mellanox.com>
Date:   Thu, 9 Jul 2020 09:52:07 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <CAM_iQpXLBrJggTQU3+MpdHPh1zQcN4T-HCTmqiPaKd6Cda-_2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0046.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::26) To DB6PR0501MB2648.eurprd05.prod.outlook.com
 (2603:10a6:4:80::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Ariels-iMac.local (2604:2000:1342:c20:592f:f956:e047:40d) by AM0PR10CA0046.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Thu, 9 Jul 2020 13:52:17 +0000
X-Originating-IP: [2604:2000:1342:c20:592f:f956:e047:40d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b728e50e-845c-404c-b2d9-08d8240f4b8c
X-MS-TrafficTypeDiagnostic: DB8PR05MB6666:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR05MB666628CE547A029D4623B91FBA640@DB8PR05MB6666.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SxNkGIEPkNe2bEJgs369SSp+IE9hMqD5vqOTFhXYF6QI/OCT+DZyoX3/OdGKvENY9HV/dBSKdGdxrJp7RoPLjfe1p1+fDb88HZ4kV16UUnsyhdU/yvIbT0PJi3/IOL9XTbVyJE1ZmLWXD1kEwyhY959/YpdlQtzGHliWNZqHJyUaHbc5ZJnM0Ch7fZHQINhoiE3A2r8f7n85HVmKTvWt26lKQGHvbB8n9+Wmj5khPbzlJK6xVL5tDic5uBPebq5inm4rMUUcYmeoJswU0WD5XiTYXnlKbqylAaTonc7uKpx5x7QQAkr94VYdVe8oyoXEEZwYAIktXmuRksepGjmJhnZBBfAL5I68x9UhvZO7ey+SvEoXuJLfwDKj84/VDEen
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0501MB2648.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(2616005)(86362001)(6486002)(110136005)(16526019)(4744005)(6666004)(6506007)(53546011)(52116002)(5660300002)(66476007)(66946007)(66556008)(36756003)(54906003)(31686004)(2906002)(4326008)(6512007)(316002)(478600001)(8936002)(186003)(8676002)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +mXyessqK4N724lxnSGDKZizWK0doxs/1AwXxGPks27JxyESLw/rmStMWmWAJFI+HMp5AmXnbXUFaG5j+c6nPDEQsR3SJgCp9vU3TgJnjaUtGxcW+CmX6vqkX/nc+JhPTnTeARNmYLktBm5CJftSdLEjsuOjZCO3CKZ+AZaO593z5TE7/8ceIX3922uRiTWIhtg4lx6uruLSzYyKtbA4wn0RYBeyqG72oGZ9nB8VzzMEyM1HcNAl6WxIalnj6LVZjKSLbMOxRtemz6NgxW7h6f8xGanCMna3hnCJtopmZzeNYON/ar6xjcRa6XG7KMtzeDF/nL8iBXVDlofKs/m+WgMI++N1O+fkwbmWkIHXnLbMgZWCGkd5nepFGL8Mxk8WXiSLvuPwcoaXJOai0QTcrO5mqMIdgNjzlulH+/DmimdchSQdrZGfNCdcW+iEividJa6YC+Pk4418PeE0zKD0EVJFzKSxkQuJOw4r1zw6o8dY23nu14GLXuf2kVHZc48kD08pTsiO56+0bxv0eDptf/1zjMihWPwDxaeTXVwOV/zFmIdky6eHwrjfgUqj7Kdp
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b728e50e-845c-404c-b2d9-08d8240f4b8c
X-MS-Exchange-CrossTenant-AuthSource: DB6PR0501MB2648.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 13:52:18.5785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dApwd7Z7r6XB1mlhnpCDKgpafQth4OhSDJMObHyC1QDVdLA2TczBIZiP1zvc1JrnjdGwORXa9BYjGZKEKRm+MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not sure it was sent so trying again...


On 7/5/20 8:28 PM, Cong Wang wrote:
> On Sun, Jul 5, 2020 at 2:50 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> BTW, nothing in skbedit is against computing what the new metadata
>> should be.
> Yup.
>
>> IMO: A good arguement to not make it part of skbedit is if it adds
>> unnecessary complexity to skbedit or policy definitions.
>>
> TCA_HASH_ALG_L4 literally has 4 lines of code, has no way
> to add any unnecessary complexity to skbedit. (The BPF algorithm
> does not belong to skbedit, obviously.)
>
> Thanks.

Moving TCA_HASH_ALG_L4 to skbedit is very simple, I agree.

However, supporting the bpf option via act_bpf is still problematic as 
it is not offloadable.

We need some kind of indication that this is a hash computation program 
and therefore

it requires specific identifier in the form of a new action.

Ariel
