Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D102A39ED
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgKCBfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:35:38 -0500
Received: from outbound-ip24b.ess.barracuda.com ([209.222.82.221]:55026 "EHLO
        outbound-ip24b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbgKCBfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 20:35:37 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49]) by mx2.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 03 Nov 2020 01:35:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcwNasTgQ0SNbzNoIMC67B2lS2bH5SVt8DiMI2Qb6diHsEJRHmAZK4tEO80QDr5p1torwXCnCuSgvpOQMrYdHWpWD7YX65Hg1TZMp56NDTxl2mN0XVWT9wHkciuFRTC7FtEJfAZIN1v7CZyRgm+Wwjm4m/4LrYrLeb+pC2go1qiHeW8FCW/dJqX8c+kRPr9R5ojw1khuEU2KRiq5Mi/mlL6HxRf1hxIvvajWW/ZINOO1NoI+0QLaqlPe0H+hBPVTD1Ppcr+Ut1M42JPYQezl9XIXBudZf4h05z5u70uorBRtr/uLw3flFF+7+B0O/uT/144z3xO6FNFY1iq8XrfzzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBNrhECvJH0CD0aj9qlHgrIYc+VXyAZ29dD+CgnQqtI=;
 b=kVfyGI0W4/Ic7E8OuXBPJB+9FCYLEMROCnuJXuyluTY+OB44i0rw+nxaOeut5rYPDyuSK7NfwQ9UDtFUccX93GXHfWQIjCUBuukmclf8bYBU1b6mhjljMCXOS3PbNUkszJ5Hp40BHkJPrVucrN99Pp81xFcLNMp/SL0tavwi8c5yssX5RzbV8wd7mBVxKwC//NQl7d9oI3GBfIlTaYioDZCavyXSwwmpZACYjVQOw+PoZBcOxbOihbktLP7c8do4HzRfVU3XEfiIRFyhp0FC6A0DHXBqhlcYCwAywwdxVCuxltm1fMTg51HC8QLWhA0FzNkdIcJ++7Yxicmqd/IJJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBNrhECvJH0CD0aj9qlHgrIYc+VXyAZ29dD+CgnQqtI=;
 b=C98GfrrejvVfGbukPyotvg2ikapCfuz+qj1lqx9qNsW3hghFonMT+cKy4oPQ3j3/H065MHREdSfn7985gBQqXLDRkYioMX2WDkit1P4HFMzl4tSh0Ay3+yYk7bWMhZyOyk+Dfxs3WYCuqP4QmeZ72p73RCY9iCANesWx+Rlz8HQ=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by BL0PR10MB2881.namprd10.prod.outlook.com (2603:10b6:208:78::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 01:35:24 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 01:35:23 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     andrew@lunn.ch
Cc:     ashkan.boldaji@digi.com, davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com
Subject: [PATCH v7 2/4] net: phy: Add 5GBASER interface mode
Date:   Tue,  3 Nov 2020 11:34:46 +1000
Message-Id: <20201103013446.1220-1-pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201102130905.GE1109407@lunn.ch>
References: <20201102130905.GE1109407@lunn.ch>
Content-Type: text/plain
X-Originating-IP: [210.185.118.55]
X-ClientProxiedBy: SY4P282CA0011.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:a0::21) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (210.185.118.55) by SY4P282CA0011.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:a0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 3 Nov 2020 01:35:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 216822cd-df42-4c6e-9ef0-08d87f98bb9c
X-MS-TrafficTypeDiagnostic: BL0PR10MB2881:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR10MB28813A79CED3CCF2458FF41C95110@BL0PR10MB2881.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PQqgHlkf6kb5R7nucO/19uN/ZdUOmOa3o4Ts++k2Yhmr3PjkIhjyrbBirhwJrUnQ5tI2vm2JEz92BmzOe9UZwRMUaOKaUXnVPQr5tvkA9gS5iw6C11bddkljuzHEWNIIOzd7tPV2eePfoZBJgLfyDcvzplasw3i3Qksh59TVVyNDoa5kC8qFW9yArMa6tF70Rdfw8vb0BoH4/3WIWS88sZ1O5U16vfPSbm6ZDmLgOyOonB+d8qACYP9XgNudQeoL3jjCR4Cx5b02lgzhavMz+6d/hMKo2kVIL7C8C0CHS9diNz1wODrWzyOiPxlxdJ0kAhi8iWW4WYEcazGkyoy+x1Qwm1Ie7pcF47AU7zSlTdM80zCI2tLb971twb95K7gu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(376002)(396003)(346002)(136003)(52116002)(956004)(69590400008)(86362001)(6506007)(4326008)(1076003)(6666004)(6512007)(36756003)(6486002)(66556008)(478600001)(6916009)(316002)(2616005)(66946007)(26005)(66476007)(2906002)(5660300002)(558084003)(44832011)(8676002)(8936002)(186003)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: F02aBOGUDu0yXXggXBM9MrEQt02tAdkJf8qyxjYAYWTdP5x5xtfwCldRirqSo/wVcRhdZ3JlgvEpMZUejuwKePsVCJduQduEXZADsh/uFfn/jua6WXs00IueWq+ovIzQxZ1wCr4oz9TnFykCmcsver2+VKjhxDXl+eZ37UE0Mtyg374+ucmloUCOoyW2VfTlnXxandes56TEqXUpSPtkqaZY8KyVhXraZ591IJIcVCpwa+KXhCKWFeoZnwdNNYfu2DMJlQ94RAtt/Gd8iBq80ESYRK+5SDu87EnQ1nlOaw2YZde0gPCygyuDPq424hzehXsoo1GoZX9w6VF4MjK7Y7JcDx9oF9az3jLi69DDU4SNDMnQL/+BgM3qVWLFFAslyk23E9AzK6+glCoC0fNR15iaPZaQupW6QLv4C4iyvAaF8O08ysvlj9rDBZEZbqX0dVX+rKg2QvWUwbem66qmThWZvlIvqjndQ2njG62Zi62eWELW6sKGhfFFEPoscgIM5I1OxrKcEB8H/eIOopcODMdbEWyMF2WlAKzKtDI6JzOTxQTJT/PCSHakAB5oYZ/2o3tD66jHvlDNDiAFw+g4EpMLa9y0MfMuVUE/XArYzYBJqUeMLVYomypuedgIzQPbo5VnqLqbTXzYp57Z2eJI9Q==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 216822cd-df42-4c6e-9ef0-08d87f98bb9c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 01:35:23.6342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BydFsd8NbKPXswpBsZqxC/lFUvD/oo2DHWzv3/7AoEYW/kNL13MTgf10pE5/D8yL6vu3zQzbSE17WZkRMfxr8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2881
X-BESS-ID: 1604367324-893003-5190-648216-1
X-BESS-VER: 2019.1_20201026.1928
X-BESS-Apparent-Source-IP: 104.47.73.49
X-BESS-Outbound-Spam-Score: 1.20
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227927 [from 
        cloudscan14-113.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        1.20 SORTED_RECIPS          HEADER: Recipient list is sorted by address 
X-BESS-Outbound-Spam-Status: SCORE=1.20 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, MSGID_FROM_MTA_HEADER, SORTED_RECIPS
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> How many times have i asked for you to add kerneldoc for this new
> value? How many times have you not done so?

I have added kerneldoc comment for the new value added.

> NACK.

> If you don't understand a comment, please ask.

Ok, explain what do you expect by that comment.

