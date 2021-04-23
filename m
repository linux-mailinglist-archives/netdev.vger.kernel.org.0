Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6BD369127
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 13:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbhDWLgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 07:36:43 -0400
Received: from mail-eopbgr130097.outbound.protection.outlook.com ([40.107.13.97]:38978
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229957AbhDWLgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 07:36:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFPyPgFh7aceTk2LIdr3w3Zd1wGTDRWkAWByVtX47E6hz+5ysnmeCF9b88mYF6WMCO7b0I5zegKlMoClnWNiZcilx3glRA+8HwdKyJCeZiq8tPHGf5WTVohragPZNb1pBZCO5eioUwFHVjq3VUMRar3ZC4BOAqphR2DXh4iS6pLO6uPUoco+UTFWVVbUlfL8WFwY+zFk+0iXHDDaRX+ru4Jv4bu9ekgok7/yULww8QSD6c1Y0xVFdU5Jb+5R5c3cg83UtU8uay7LXMMBwPrspEHOkD4JrYO1AVhRFfGYWjAxSe0KvHzLMiPFbhNTZFd6Ll/6B7d6tOrmqLGAFbzAyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13E6iBKpcdBAp/jkziEhORAg+Yz7knkUKOs7rULr3wc=;
 b=naITchjn+yBK/bhB28nAViCP16xl/0XIdFtpcfmYmu1BmmW97x1G9txMBFmYyb42gxl/TIqnh+1WrpN2J7O23FLcjgofg6U3XCL57d5ecm5+lqWD+jB0SPqCsxcSXWd2gFLrVL2RNw1JiG6kll+R0MesavqmII1bfpD1Qwj76wJCQMiHJ8NRn0ti363BpYF6FLsb5OQ6VS4Lqp9HJVmosCSHAmRfBWrJ9yrktlSFcSjyABtvBOOcVGVY5gQqYHlgMVw9nxzRo83LLbdsqnTsdQRd82+dPANTNqU4DcTtGD6HWDnXleM+lfY8ShwwUWH6RNuKOeiFfiR8KIGGrB5aQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13E6iBKpcdBAp/jkziEhORAg+Yz7knkUKOs7rULr3wc=;
 b=yrWvBhpA2JkEGFtebtK8Gcn+WQW3I9vUM92+sfDdbfOlcvJzOCOScoBF2lAB2tkPLEj7evJ9jAIEN+WdQ/1bVn9jaQLf7O/hTmOrAgMa5NanbGGOtH7q9UB+uxQTuF8DciRZKZ+FqyprVoiCfhGvqizsR5km8QbrctYNVvBYu+M=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0570.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:55::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.23; Fri, 23 Apr 2021 11:36:03 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c%7]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 11:36:03 +0000
Date:   Fri, 23 Apr 2021 14:35:59 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Josh Boyer <jwboyer@kernel.org>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [GIT PULL] linux-firmware: mrvl: prestera: Add Marvell Prestera
 Switchdev firmware 3.0 version
Message-ID: <20210423113559.GA17656@plvision.eu>
References: <20210422082955.GA1864@plvision.eu>
 <CA+5PVA7z-8sUDPoypQBt61qzVmyU4G_wRg94795HsstSH_i=xQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA7z-8sUDPoypQBt61qzVmyU4G_wRg94795HsstSH_i=xQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: BE0P281CA0016.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::26) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by BE0P281CA0016.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Fri, 23 Apr 2021 11:36:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f91d017a-863a-4e63-d88d-08d9064bf981
X-MS-TrafficTypeDiagnostic: HE1P190MB0570:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB05706488916831E0381F6C3395459@HE1P190MB0570.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N9G33uq2wtvtRkksQf0353wbYNhDqC4uMiuu6Ab2fwSoC8HrF3jjafMeYnHITuA5ppC9qSlVIBuRDC97wicQELLmeV+NWOq23jgGw1KxCuJ15BxEaFmjoVF3kNUDgFbV/4vDis6aKcCazjYX7jcd5tCnFVuMn3RWGGYLtYNrmMNkoJSacH2XV+5rmvU4/tfESR5NnNsnMxRgDhDdEO+0C/uimwtIcn3aQ59CNxI3v51zLsSL6yyITBm1PGiEUpcP1xTph5ya1uaHYKtN4XHR2JZDqFiba2GRxOyvEkZZUNkHU4KjZ1hVOZdQsLGrvgH4e8uIDluBGvhlHMizJdR6pZfuvaxixxaeqZFETfSCKxQq+HWfIO9/4+JKgacbyN4Lh4ycvf2cglw89hLmD6AhqT3h+ViNT4zLA1Q6IvMWDQysDmJpk3g7hhOImwQY2qdlUFRNNNI4QHhVgj03999xecFfgTYv39Hn1TWg27uHe0UzL8wcsvKtgVXgI4ytmKCBCAU6E7N96MuMLcgtxaKuVAoJz5G3WoeMqKrtrWlu/bD9M4VcfnBLMtEeqWX5t0u4bG3nrfDiahcaFbkHzbvieGj4FN2tKoLfUbtv957jz5JKlOOf+VdTyYLjNw2eJeH1Qcc0pqjI3wvPWyvEqwjeAfGO7oE738Rruv9+2rT3DCYDu6dKnq2DuFaZ5Ky1udnIsuut8KZUBAklG8LInRYniKpn+As1ZgE58b9KVmtjxwM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(39830400003)(376002)(346002)(33656002)(8936002)(44832011)(4326008)(316002)(54906003)(83380400001)(2616005)(1076003)(5660300002)(8676002)(36756003)(6916009)(86362001)(26005)(6666004)(7696005)(66556008)(66476007)(956004)(38350700002)(38100700002)(966005)(66946007)(53546011)(16526019)(2906002)(478600001)(8886007)(52116002)(55016002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wR2HwMPZhxaREUlfHUxK8g8jedAMXaTfcFaoqrLG6zDIFBL/wWPmznalXIfx?=
 =?us-ascii?Q?stLIu8mXQRLd9AfmcDqYMzUlAPDTwBbWS61ZGByz5BokbxyH9yxw+Rez+KQv?=
 =?us-ascii?Q?mydIyteulgO6qC/T1jzSGcTc8600bua6tzlC8xbGeF+eDw5CoWokZyNKcORR?=
 =?us-ascii?Q?cElEp+oOS5klBJhuIEvHLjmmsGlIHeIPBc5E6J1vpc509rBQiy32jQT5gTKj?=
 =?us-ascii?Q?DrxtEcHVwGTqiVFGKlKxdu9R6NYe/0LtAGoBX9hAT3dqcEn+gna5EV5Q7w5X?=
 =?us-ascii?Q?kMaHvWkEPgckM7VcLZw4XunbN4axax+qLWzit0DrOFfZUX/KqfK1mE3d4HWr?=
 =?us-ascii?Q?Pudx38MbeYoBgAQX/sKomheRpI2/byySaqaarfWUF0ESv4iCFfcmHAZ0lebS?=
 =?us-ascii?Q?xb/GeTvCQpUeQ865ApNVyOAwz1zxS7yIOTotkxOvTLlpO8v7+EsGW4tTmV9+?=
 =?us-ascii?Q?5E2DGmlt2hbRi/9X8nxd6jv2eYF7NYL3I5oASCrlPQh/z9kfddsdFPYOSJb/?=
 =?us-ascii?Q?fdRFZqx93VQQOU2r+1n9FTXgT8cVWIbyWnQvIrJ4AhznP+SUISHldtMOqCoN?=
 =?us-ascii?Q?pwK8JLsd5Yj5NAVTd+Fk3qQMfDvFttvx7Tba7ciSG7W6/NlecFRRHE24mJoc?=
 =?us-ascii?Q?Gga/H50t1gE6tsYtlrWpwcienjiqndt5zfX/qYGgHoeIWA38zOkCrRRqVZTM?=
 =?us-ascii?Q?LVao+SbwN299ZOFxzjuoxP07UtbTKnofhmZLG1X3jMEHRsO67l4aFTIg4MZf?=
 =?us-ascii?Q?CDtUJvEpBeg5kVk0xWD0MP8/vTC8p4SQMPyvjZHiLjF7Ajmcc68ogJ1JRvDx?=
 =?us-ascii?Q?K9pkZSiJEUUu2ueaf65D9nXqgtyoPBJr08NbyWNARPgqW6xiSWhJeEBu+xq9?=
 =?us-ascii?Q?kw+Q7ksQAT1Y65qVmep43RS9bEd5SRSvFUw+aBzdKk9Gn3gUFpPIlAYW0uL/?=
 =?us-ascii?Q?HYREsJryyqD0VvdpLwRRO7EkA/Raxjk2PmGNJndmV+TWZ+CqiG4EWKUkdOf+?=
 =?us-ascii?Q?XmGo2+LuSNw4wEFnd6AQZ7hSflB3RbXN6IHwgJoIwRuYsRQKCb48lc8pFQhM?=
 =?us-ascii?Q?EFLIEkzVizgh1+y2gTmSG73OR8VkPQBdaMXezXwIJzLsmwYw9cfgutDov26L?=
 =?us-ascii?Q?PqaVaJSuREFNo56aUjQzXKKQID3360ASTCC+inPbBBQLTRMfgBwmmMZbISrk?=
 =?us-ascii?Q?7/f5imnmlOA8uhUh7qmA/8lOSd4FHCUOH6ALEkS6oxPJalVuPD4EhSvFPThJ?=
 =?us-ascii?Q?Dun0HochBQbqW13upcW4cIME9Y9wqwjiwWhYAnO8KssHb5235s7VO6SYQbzx?=
 =?us-ascii?Q?+eymrU37+FY4msLjeJheGMvK?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f91d017a-863a-4e63-d88d-08d9064bf981
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 11:36:02.9854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vK/HCOrl+YibPBsMb1RlsO3c7Q5xCyi3RJWhJrWJBz/ljJvdKKdQtn/h3kbybXfyaRd8uPWHjUQAKug6Vi/wlzWOfaj+NAFLF0UazK3FoJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0570
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Josh,

On Fri, Apr 23, 2021 at 07:03:50AM -0400, Josh Boyer wrote:
> On Thu, Apr 22, 2021 at 4:30 AM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> >
> > The following changes since commit cfa004c7d82e1903cc88a918ee9b270fb8f47b28:
> >
> >   amdgpu: update arcturus firmware from 21.10 (2021-04-21 07:09:48 -0400)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/PLVision/linux-firmware.git mrvl-prestera
> >
> > for you to fetch changes up to 50d16db2e77332e0e89ec0f9604ab0bb2fbc3c02:
> >
> >   mrvl: prestera: Add Marvell Prestera Switchdev firmware 3.0 version (2021-04-22 11:23:24 +0300)
> 
> This adds a new file but doesn't add it to WHENCE.  Can you please fix that up?
> 
> josh

Sure, sorry about that, just realized there is a chech-whence.py script for
that.

> 
> >
> > ----------------------------------------------------------------
> > Vadym Kochan (1):
> >       mrvl: prestera: Add Marvell Prestera Switchdev firmware 3.0 version
> >
> >  mrvl/prestera/mvsw_prestera_fw-v3.0.img | Bin 0 -> 13721584 bytes
> >  1 file changed, 0 insertions(+), 0 deletions(-)
> >  create mode 100755 mrvl/prestera/mvsw_prestera_fw-v3.0.img

Regards,
