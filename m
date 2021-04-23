Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E776369162
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 13:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242306AbhDWLmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 07:42:20 -0400
Received: from mail-vi1eur05on2110.outbound.protection.outlook.com ([40.107.21.110]:30049
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229479AbhDWLmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 07:42:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGd6HfPkbWzu549Qprz+JDrLmlM+DErSJceQuvve6k6KZVCZJrRU7jELopd1c62wLpNbFbxvigLZrms+d12B/Lh36PGmgdKQqMNnZW7mgCDuHSjOFzr2ZYXAP4+hVFlBM9bG61/1+T/UIpjOpbSo2Aan3vFTh+BtBzwoBxgyBICS76HabSd5V7yWMbmuc52a/ePFcyXqsfGs0BzvtG5aAayQh17u+/zKit4ECDbp8OOwQY6F7HJgmJXQKf7lI7WtKgv143kvYqb7bKCZE050ISKBvZca0klCwwfdjD5ffF7NaFW4ai6EHv3YkmhG17hfDVJwOZ1esZsGl+VvBRzV3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23BYWjuizz7Qbf3rHn/k84ymODXi5mXma2uxYhafy9Y=;
 b=GVlPc7Q/TM7WT2/f/iCzA9+WWLR0UrzbdE+zQj36GDP3hvgWBkcos7A3fSzQCnxA0FfN6bEbcWM328AuxnejFG72NjIKwO/ugwXpIfgxaBu74DJFdP9v00EOX6lX/mHTLLqnV5Aahl9rqKtbVy02qbdY8WpYuwEOuFM0IB5SinFEqNjA8oqJ9EhKCY+wrWKHwEm1kTfQdf3Fjun+2r3rTm/enqBFB/XC2RoEv8USXr+8v1N+i0L8G4KaOSCKYlgiBudh9L37vb9Z0R+Sak9TA0jcXq69N8HnMP3T3XGS7xea+p00c/Q5g+L7KAQDZdbddymo7jFz9EGAcSd0zk67Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23BYWjuizz7Qbf3rHn/k84ymODXi5mXma2uxYhafy9Y=;
 b=luNSZTS1Z72Q1PmRIyVSX33VB+MMDDjkF9f+pyEdChgOzUqHDYOGPnS4q0hP7L2ET3zsp9nX/FLnW5cY6WplyMvUz+Wrk0e2nDs/blfIuiYYr0SA20ZIR7JZeFZtItO8D4yWKPVvVyT6BCnKAuc4TleZUZlS9W40UQeLq8iECNw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0506.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.23; Fri, 23 Apr 2021 11:41:41 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c%7]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 11:41:41 +0000
Date:   Fri, 23 Apr 2021 14:41:39 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     linux-firmware@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [GIT PULL v2] linux-firmware: mrvl: prestera: Add Marvell Prestera
 Switchdev firmware 3.0 version
Message-ID: <20210423114139.GA26468@plvision.eu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6PR0202CA0058.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::35) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6PR0202CA0058.eurprd02.prod.outlook.com (2603:10a6:20b:3a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 11:41:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6c8d6e1-b6a0-4fca-2079-08d9064cc35b
X-MS-TrafficTypeDiagnostic: HE1P190MB0506:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0506A8EF5D73CC15F04CF8F495459@HE1P190MB0506.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:376;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mkom0EmMxKfowlQXd5FxFaR5MMGX+kei3jAZ9atZ7bhReIpWVM+53hnta+k3nWj/oV7CHHGj3ocq34j6ARrrBqZE7ffVVkdIAcNKBFj+NxUgPjztQP9RxcKyyTfmyMsGIts6nCx7aRx7GFaDWuOe5RFGD+6d/edQDAVMkZfN3K41cFzcGPxcfpMZQFVjJeKfBYPF1rZrB8c8hZXdEGTSp3QJ8Nr89LzLPZW+a/ZL7yqEIYWoFUGvcflDnDjohCwavVKwxnwdvV9i9XE/HfXv7FGK7ZtIy5h38qKU1TAF0pvcxDXUghjrwOYjutCqYV1jEiprqmDeVMqI9fWqcJN1VghXLyWIamth2VLZqmuMUTzAHMnpMIC6wqq20DkZethrZWxhR+zEDsOEpEm1RYYkgk5PrkzHgwMFXwBF/iT0rj2rbvAbHEwbLzZH9yXMeXBxfoFNMyeNvT5+Q6y3FT0f8ijQOetgTwK66elFLLTBOiCaU4CXjXKLXcTQGvUc9b8Dw48I+/O6nqzfZq3uZiq0O41iy+ltwE+hSfOtwsa7SifMEVkYYX/GN6KrYxCAgCqu7XPuhgFPZBtJyBRVIqdwyUR2IL0nL3dDB2bztx7JUV3pki8T4nDC7U5+TViMoLiJfVj0upCnyoXz1tsLmAHs5qvhgYPrDWoHH9Qr/dih3bG27DeIJZd4xwllgiy5oINTxQ1BtCXn2zQw1tlyGyBsySD+YV8nFWacOAQQnJy3DbI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(39830400003)(376002)(2616005)(1076003)(44832011)(5660300002)(956004)(186003)(86362001)(33656002)(36756003)(16526019)(2906002)(38350700002)(38100700002)(26005)(55016002)(4744005)(52116002)(7696005)(966005)(83380400001)(66556008)(66476007)(8886007)(54906003)(66946007)(8676002)(316002)(107886003)(4326008)(8936002)(478600001)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nXEm6BQz83uM6219V+HK1gTpTKT8LJp5daITJYK47qz00VWDYugMNNkRZxko?=
 =?us-ascii?Q?9TxYKkK1n2NQhqXFV1hhH0sCBqPPiPdqPK3Rgi8H2xlE0faJtaydUd68Hs8/?=
 =?us-ascii?Q?Ma90ACHLoHsGCYI/e7Rq8rqrJBOMVwNqP52Hn4TwLrXLnSNqH+mxJ/3FJ7Tj?=
 =?us-ascii?Q?pCpBIbXBTTnTr9oPCM2WH0X65HaXF8PIaMFu1AVXtOM73bNLB9E4zr9oIutU?=
 =?us-ascii?Q?+uclACNa12ohYeAG/WXnnod4ycfXps+bVyj/9J/9V6ipxk2XiywJiB1SQ1t1?=
 =?us-ascii?Q?k0Upj6L1zizD/Bb/DHwv4yK3nCaEJNvwXRna6B19/+zl1wTIyEwb4IPFhgxD?=
 =?us-ascii?Q?Yiw2eJZ7P/KsrCAGB84w43aNwTwU4O6cRk8gsSgtVJVYfKgOLnTbqWh25j1n?=
 =?us-ascii?Q?buMJbCq2wP8iqPsEt1YJtfbP61Ijv3lD4DrHUV7JTT7UsnCvC61yHPGJBJ2S?=
 =?us-ascii?Q?L/V96YFSDxJ1tfTmGzS5Wk3eLwXlDn8gKf5aNISr3Iu8oHCVF1bgsAvpbZiG?=
 =?us-ascii?Q?WO8m/11RH0Siz3SGRRGkTJ3aVfFA1tbbJoh5qDpwYZDI6xaO7XqgfnXDVqtF?=
 =?us-ascii?Q?1WAbCF3Tmo4KNogcqbYcNof6arrkZyjP0iX+W5oEorPy7xk69J0LqypuEvK1?=
 =?us-ascii?Q?tKKVWoNCejZfIL6ixVn+Iu4aA2BY8bqS9sbh+Tc6ZsQ0hPfFgXH32qK+SKA0?=
 =?us-ascii?Q?AoPqC++FjVyVlJXc3T+BYwrl8LRqjdEENmaFf2Ww9Se+U37GxMBD4gEEHFcA?=
 =?us-ascii?Q?gdifz2DF+6eS/teUaesqnIT+CqoH1J34o5ypB4G3lNEcDjR32TNiKBj1LLgh?=
 =?us-ascii?Q?95XtR8m8QKKlAOtEQqLudXRVC+IlnkF4kh1MSc0BXW5wthnlXrOyBx9/8n5r?=
 =?us-ascii?Q?c78M9chMESI2RQJ9UKxs+ses47WXX+ffW4q/1E2xG6Gn3YOM4tWrJNBpjwir?=
 =?us-ascii?Q?iIKAC7lVwAMbjDCwBmrZueeir77s4gz0LmSU7KG56PF2KcFftYfnRxhz54zn?=
 =?us-ascii?Q?lOiEayQnK3TJl0n4/I0npn9Et9gsj82jywbLprWkGJV2R5D4GccY/0EbDD4c?=
 =?us-ascii?Q?5ASIvKKKZkxpCLSUVZgBxMa583/JyYwmSBze2HZ8of9J7ejng5a5P7A2Fzti?=
 =?us-ascii?Q?LuKp/hDBYaVMBOn3wkrOoHv+5TQUEDGiRFuGHYZPSOUsBZ6o5yDE/u3zviSY?=
 =?us-ascii?Q?eyWq4s+8eqO45oyO7qzs0VTEo6RDxr4LED9jMuB4wE5ibLwmlHA5kTm4/55n?=
 =?us-ascii?Q?GFPLS/KyYjmdvUP1QZznHsnkiiLCrIlycxLJYTHvsnm7ztgRvzTri5DBGl64?=
 =?us-ascii?Q?NckR5G1sEqnKH0bJQUlUmGjo?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e6c8d6e1-b6a0-4fca-2079-08d9064cc35b
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 11:41:41.5305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fHMCtBxXewah+x4fDVhGVXI4WMEaR4xUWOcH8AzlUX8BGquXYwzI8r1CeG10ViXOBArJWBWQOpZTAk+4QxuO8Ziux5I/hYIezEAJajtkHms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0506
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following changes since commit bdf929da38adb269289a750b60004841a5c55479:

  rtw88: 8822c: Update normal firmware to v9.9.9 (2021-04-23 07:06:04 -0400)

are available in the Git repository at:

  https://github.com/PLVision/linux-firmware.git mrvl-prestera

for you to fetch changes up to 16052e4a41bd0d47793fa33eb718081df28efe11:

  mrvl: prestera: Add Marvell Prestera Switchdev firmware 3.0 version (2021-04-23 14:14:51 +0300)

----------------------------------------------------------------
v2:
    1) Add entry in WHENCE

Vadym Kochan (1):
      mrvl: prestera: Add Marvell Prestera Switchdev firmware 3.0 version

 WHENCE                                  |   1 +
 mrvl/prestera/mvsw_prestera_fw-v3.0.img | Bin 0 -> 13721584 bytes
 2 files changed, 1 insertion(+)
 create mode 100755 mrvl/prestera/mvsw_prestera_fw-v3.0.img
