Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96412C86CF
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgK3Obo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:31:44 -0500
Received: from mail-eopbgr30117.outbound.protection.outlook.com ([40.107.3.117]:48258
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727429AbgK3Obo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 09:31:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXlLT8hynn3oLsHHDkFZXd2AlAwADmZG0ZHlSLJiFBpG+otX0BvMHWQQO5NjlmvpDbEjtakD5ljnojPpLXyexzj9BOOH2wwLf+cSFsKUGnaMQGgJswGAVZNFjrziY0HQGsokB2eHHXEeqkjbTvwm4fSRtbpBg9Cp+f/G1EqQyqCLU7Ai8+qBGqllQ5NFcdZU1vZUQWl5oMfGOx+kpAJlVP+9ENDosAVqvc9YPcgc/MJfozpcYzyU2f4gjAscUq1WRy/LGLOPwy+g2f/rFCmDY9B/WzLxAMUTbDMHSpPNWiwZK52hCokKjWFfUtmBD9ZBhOY67k/3cs/4v2Rz25rp9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7xNOZjLerg9n/DJmlEGRsTkrdRz0JN/w0dbhAQHuEY=;
 b=RDHD2zLPTGdQu42aNwIWEXU0RocZn8WyvU2PBwyuJ3sNrqn2RmgSSfCWxFivAoUIsXoVL3W8tDuwY5PDDcNpQypjcrqjSjjA+xFVy/fFCTwZ+6d9koBrVBSKRyfm2f/bkKsG8hxuJ3RKXAVxO/K5Fb2Dv1aw6BNilpKZapVB+DtRICrgtrMemp9+x+hsxkyuzfjRm0b82ONpKQgfNvF6l4+ccCkPpO+iNFW/bgT9B8c8kEDfSBznVTlGVrIfitg0w7/AIn+3cxN4KosZRWaawBMNjo04lsxbXzEfViwyvCl++88o0nYddngG1E4wwesLH3uQYFEX25hyWXYFcVWj8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7xNOZjLerg9n/DJmlEGRsTkrdRz0JN/w0dbhAQHuEY=;
 b=Ybn6A3REGIDqZAOKr5bWDNp92raV+9nBWjAJrZPI11TKpbREnvMec15e6lYz/I4arhToW0ivBLhfobuW2II8m6oYHYgUvKUs1Ze9tUkisg5qsvdVUAt/G94kOUQ4AaJ0lDKX59+beuXIsVcfbVm0Hh8M3vx2UlWZAeVAEzZYMoQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3332.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 30 Nov
 2020 14:30:51 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 14:30:51 +0000
To:     Network Development <netdev@vger.kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: warnings from MTU setting on switch ports
Message-ID: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
Date:   Mon, 30 Nov 2020 15:30:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6P194CA0021.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::34) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6P194CA0021.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Mon, 30 Nov 2020 14:30:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7645c6de-ee60-4c3a-c083-08d8953c89be
X-MS-TrafficTypeDiagnostic: AM0PR10MB3332:
X-Microsoft-Antispam-PRVS: <AM0PR10MB333202C257B8A3AC287FC58193F50@AM0PR10MB3332.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: grgdu/e+18h/vdnTqRlvEPBcf+VFuW24iR7ELz3HjeMEQLFaVlgeQg7gjBzISwQLqQWYxXh0peG3Y2t7bh25qRmUAWxccKQ5GKu8s/Sqd71uuQL6rNObdPg+Ev0dQYiorb8XxADBK5lXPYgU5NshEI4YBvUhCnZjTbRHhuknEPW0cMG2g+ql3+swpwY0M55fkNlv2/nVNmw0fw15+47vifLkgMKuvTh55yfpELFyTCxxaCFmg/7n0ir5387A64PtVOtibHy49sjtrIHsFGYiJwccGh7Ngb2zCEQiPd52aBerpnL2FuyNbLIcSk+DeNjlgh01T4V5FjHNbhkupkIL+wxMKwI+xP3q9I/XBykquO7ra94Dt8N2+bJCpDkcoLgqPZ1rRn98KLGmstodSrwEZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39850400004)(54906003)(16526019)(52116002)(4326008)(44832011)(2616005)(31686004)(31696002)(16576012)(26005)(186003)(956004)(316002)(478600001)(36756003)(8676002)(6486002)(5660300002)(4744005)(6916009)(83380400001)(66556008)(66476007)(2906002)(86362001)(8976002)(66946007)(8936002)(58493002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?NbMsya+7leB1JiywfZsDPPJVLqLs9yA/uX8bBma1M76zX+KBCLg1dQZr?=
 =?Windows-1252?Q?XoqhhyxF1Qcu9h4bvqVGhlSN874DcntIQ1E6e8j9Gs8rI9KhEyUaBJZJ?=
 =?Windows-1252?Q?f6OAK4gHMqg+45bjceT5hLpWBRiBAUKmLsWGQqcpvRpg3gUuc98Bd/W5?=
 =?Windows-1252?Q?7elS5EPmfqoz44pkMB6JorXslUAUtiys2+/g8uX/RWIqrU7w5K6JGVRn?=
 =?Windows-1252?Q?lQzqfHBpBmbwqzzNaqgxOWr27ZLJH1DEGU3ukpjgVkcF80MXQmpNpUQq?=
 =?Windows-1252?Q?Pm2PqHBjAWASTbg8HENnsntF+snDlUpPOCFH0Q+W8rh16af/Fp2kMYnF?=
 =?Windows-1252?Q?n+2G47gn7ilIO4edbAPrBLZ0muqbGiEI4wCE4fYldzzxY86Oxhx7OmD1?=
 =?Windows-1252?Q?kkYV1727pir/kG9aI7Cc7l0Ud9UN2gCdQp+7t3p9/XZjpUBQiajWP/TD?=
 =?Windows-1252?Q?y4H9TkJa+ncocO8k4P48nB5NrmHb5LjP7tLo3/eAX/cnZJMm75PRpK/Q?=
 =?Windows-1252?Q?Bc2BfzK42YsEm5e48mMiIrVHxhZHD5SBD+bkGx5V4f505lweCNII9K2V?=
 =?Windows-1252?Q?CFAFX83kbepGdPHlmQnJnA5OmEMunyH2qJA0BY70d7E5YRWcutQc5Fkk?=
 =?Windows-1252?Q?T51af03OnyAbp329U47WixKlY5xmcs+ayMh10peBUKx08RtdVA75XCfX?=
 =?Windows-1252?Q?cD3FRF3NoelhHPQv4JAUxDF0gNr/qbsSqZt/F8yf70l6d/TY0kFIaWnO?=
 =?Windows-1252?Q?OrTmzS+3bYesojVceKXqFvubBOcorbhKBKFYbCwuva/fGwmXr+pqN8Fq?=
 =?Windows-1252?Q?z1AA/VQY2SIVhalOZAkhC8Z48tCBinqklBxmlWeCul2qm3oMxcQHQLM8?=
 =?Windows-1252?Q?Myd2swuwQuUya5WjG3KgyQEO/3VqDwgSKJqiVCpbejsy3F/aVFmfHgRp?=
 =?Windows-1252?Q?OOxsukNTVCmzzivqBgAhy2XhXW7fOaHw0JOHAgUNoawcPsmw/ipFvfSG?=
 =?Windows-1252?Q?vBm+ImD3WW22ebH1yQyvSE4YI/W7F1JMHcBTGj7xNv1vXwwkIOoAyw6Q?=
 =?Windows-1252?Q?H+nDp2x4HWjCtrSk?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 7645c6de-ee60-4c3a-c083-08d8953c89be
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 14:30:51.6360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LHahzWKIedB23Yu2C5GU08mH7+IHCcQxn5Q2mgJgS9Nd+HZ35xvXM6P+BHK+UnF24MBAzGF4Yhk6c24vgNWMiFqewMxH2FvAF4zWoDwahdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3332
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Updating our mpc8309 board to 5.9, we're starting to get

[    0.709832] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting
MTU on port 0
[    0.720721] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting
MTU on port 1
[    0.731002] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting
MTU on port 2
[    0.741333] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting
MTU on port 3
[    0.752220] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting
MTU on port 4
[    0.764231] eth1: mtu greater than device maximum
[    0.769022] ucc_geth e0102000.ethernet eth1: error -22 setting MTU to
include DSA overhead

So it does say "nonfatal", but do we have to live with those warnings on
every boot going forward, or is there something that we could do to
silence it?

It's a mv88e6250 switch with cpu port connected to a ucc_geth interface;
the ucc_geth driver indeed does not implement ndo_change_mtu and has
->max_mtu set to the default of 1500.

Rasmus
