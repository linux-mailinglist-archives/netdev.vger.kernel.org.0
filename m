Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3BD216F7E
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 16:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgGGO5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 10:57:44 -0400
Received: from mail-eopbgr60079.outbound.protection.outlook.com ([40.107.6.79]:52197
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727987AbgGGO5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 10:57:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYZWl9fj6I/YpBkSIiejc7gCfXUob6AiGwfygM3m51NoFeNaaZg7Bkecd+miuUpJtvm4nSfmMWHNH0drEgACQfVXpCuPi4YGbm+g7GGw6UTygmmQJ2NZAkrExTJInABCCncZUO5HHvC+J9werOQk9dim44rA2MNqNorwSBnSUfkbuhgrEhhhaLanl9WA1T8huS/EI4Y8TOrq7Wz9N8cqsQ2277Mz+Cb4bh4ywvP9UQSEBBt5mMk0GmVkoin9O3MuzAeVNpKXPW9kC92I4ey8tXQ6nhJZYG8CL2XRm918U2zdqe0smaiJsGOVCrHvUqsp4xE7fyOaP8ZrQ+6I9varDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bo/I0RVXfACF1kU2FcNObRNjEhJmcWdQTtnpkJuXK9w=;
 b=crR7fOq6RPfkMPx7BKgBph5Sx5r3JElzZrL3wU3sNDdDaTNdOclZAhMyCiGFJOJ0yRJhHmrvvHcuOEE48DKTAuDYNyRAV3AKyBSgnYRi5LDVeipoH9YLGbAJ7SV7wpcLAUubNQ7mP/yaOZJ2SV431q2/U1N1QgYHJzSRUapkasckXtg2x8WZyyDW/lR+/j8fnB0Pbh1ndNs9xXx8X/kzu1NedxwK4rBy+JgI/GI3/z65y3SW20O4lh3eufLYtnCRJL4JF8IkoXdxEIf51s40cH/EwQdLSxfZFKwcO56bylqm4oOqM2LAW2Cvedbdflmr7NOzAvGn7gVBTMdDEQkM1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bo/I0RVXfACF1kU2FcNObRNjEhJmcWdQTtnpkJuXK9w=;
 b=mV2ZdJ7BX+gk612mB/LezhxEHFROJq0Q8bA2VRkV9AOuJhXplOMPxMJoVN2uPkvrxNqExyx+il86MkCfeqpmPBKasuU4w8Rm65fjqIBUckO+syRJd+qFSIRcX/2k1Et1MDsMjR0OdsvmcT7EKWqmj7N0RlYDMO/kSz2e0Fn53kk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com (2603:10a6:208:b3::15)
 by AM0PR05MB4993.eurprd05.prod.outlook.com (2603:10a6:208:c0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.29; Tue, 7 Jul
 2020 14:57:41 +0000
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::e00a:324b:e95c:750f]) by AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::e00a:324b:e95c:750f%7]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 14:57:41 +0000
Date:   Tue, 7 Jul 2020 17:57:37 +0300
From:   Eli Cohen <eli@mellanox.com>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [net 05/11] net/mlx5e: Hold reference on mirred devices while
 accessing them
Message-ID: <20200707145737.GA10261@mtl-vdi-166.wap.labs.mlnx>
References: <20200702221923.650779-1-saeedm@mellanox.com>
 <20200702221923.650779-6-saeedm@mellanox.com>
 <CAJ3xEMgjLDrHh5a97PTodG7UKbxTRoQtMXxdYDUKBo9qGzdcrA@mail.gmail.com>
 <20200705071911.GA148399@mtl-vdi-166.wap.labs.mlnx>
 <CAJ3xEMje5d_Ffn05jDfY--jwNb9QZn8yS8MJcmy8zdxWzyc=FQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ3xEMje5d_Ffn05jDfY--jwNb9QZn8yS8MJcmy8zdxWzyc=FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: AM4PR0701CA0034.eurprd07.prod.outlook.com
 (2603:10a6:200:42::44) To AM0PR05MB4786.eurprd05.prod.outlook.com
 (2603:10a6:208:b3::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mtl-vdi-166.wap.labs.mlnx (94.188.199.18) by AM4PR0701CA0034.eurprd07.prod.outlook.com (2603:10a6:200:42::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.17 via Frontend Transport; Tue, 7 Jul 2020 14:57:40 +0000
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bbb42511-2079-426e-5528-08d8228618d3
X-MS-TrafficTypeDiagnostic: AM0PR05MB4993:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB4993ED666ED3A9F239336FA4C5660@AM0PR05MB4993.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0457F11EAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 97rQh57qCkToXKwC8m3FTnebpQ5aYSp9jQny3WO1ruOTBrhZifFOojLq22/kcvPCCN9lucITP64lXvMpCQ3hUIOUccBOcLCtJV2jFZTNg0RVN0Pxf+2V1NZItFgY6kNGpMkcwuSz8HzviSkkLzEtXLYShao6n0Ps5IGCLXdipwqXzXNXYczbTB1X95EfTPcrpboJvxCe1ZoabJM/Gcg1XIt8nuT86EW1sx7ElgchiL7c4zy6agSvANyYZL9ZwumnjUApKO+OvsXswOj05+V/RAA4zDT5EkI0W/ZQiyyy26+KDPuWNlRrtdZ4Md7KKnXufJrE3NlAHbyJjgO4lsdY9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4786.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(2906002)(6666004)(186003)(16526019)(26005)(33656002)(6916009)(8676002)(8936002)(66556008)(54906003)(66476007)(83380400001)(4326008)(66946007)(498600001)(86362001)(6506007)(53546011)(5660300002)(107886003)(52116002)(7696005)(1076003)(956004)(9686003)(55016002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vofxNmFZL7EiOm9ycEYOZGvtujWpANL7zfFBY2fE1jrcuYYc2ELggLGwD9qbbHnSz7jo68fdxQRpeD1Wqzh2PJ5NnolCwyzUSbhjaFg9wnhg0kInqdF/cJdKJvUqpZLeD9M3a6ZhGPQsIfQ4HbvfZ2Xe6PLLnoBCxpJTwp8RDbRyFL0HiVg9FTW+3PXcSqCoSs5viPnIhiZbESWVXt19uVTYXeB/XBXo4H/i5S8CrU3LswlKR/Ag9ZE/JmF/J0q9FBax2l0D5RC07Y+62E+n+iySDriaHtlBTZPcrWsQxl3Xsuz1x27WJp0CB51AttSCp4J8DyHTkY0BR+Aa/TeVp2uA1R8jeYjOFWLBB09RPqJSY4Xt7qEA9bIkAnEGcrtyXNDcq6+xLJYsBjpt10ULlPWBpoJFWdu5t5rSHi++QTWxZeVEnn/pKZCvHZgUqCKBYhcaBMOmALVelUueOCbafe1iJzPC7g0YUkVj2Iwlks4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb42511-2079-426e-5528-08d8228618d3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4786.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2020 14:57:41.2159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cPLuGjGixUkvueJ4MnYWVAQGACOrLFdHe8s8LZFjr8czvSaiGmO5nX93fPj/6WxploFS5yfEAPpsDybocQsCow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4993
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 09:13:06AM +0300, Or Gerlitz wrote:
> On Sun, Jul 5, 2020 at 10:19 AM Eli Cohen <eli@mellanox.com> wrote:
> 
> so what are we protecting here against? someone removing the device
> while the tc rule is being added?
>
Not necessairly. In case of ecmp, the rule may be copied to another
eswitch. At this time, if the mirred device does not exsist anymore, we
will crash.

I saw this problem at a customer's machine and this solved the problem.
It was an older kernel but I think we have the same issue here as well.
All you have is the ifindex of the mirred device so what I did here is
required.

