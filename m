Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AEA311636
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 00:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhBEW5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:57:35 -0500
Received: from mail-am6eur05on2099.outbound.protection.outlook.com ([40.107.22.99]:1249
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231923AbhBEMcC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 07:32:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MruZej0/ZMefIzdVm/vbawgxpKe8yOV5fAV5TiC6dOPxYsrXtbbPX7RqrRubY4R0vW5s5KM84NpPj2X6m5g+BwMFDm8scgTtfUS2uNyGSEx6iPxaubDWHYzHnU7uTrT7d6d+FT8+5Brr/k4aayfCkmFDzZOgUwv8wPKIZvH54eLZBjnRiMdl019r4H6xjcnfVAlS+6HhR07+9i0PSKCw2WU5WeHUTlEgeepx7XWX26xyQKP6w/q5407519MztEDvmPgsZm627MoQ+glsxblXRXTDjkYairWqfVWVoiNc+fG+egw69MvExzby6zyLMjbPy8awIw40G3ZTQDKb+UHPYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Umi0OM7cgEp5EA6EJ4XSQ4zIm8lADURhrHDBevQaOBo=;
 b=nH3pLYdMdM6l2KUiTZIDXzMEmVjqRw35dvkixcb8JrhcfuAbqme7t8PBhW3B5A/9y4BKGr6QzWB6FqRc/abQdFoKejZF1jcJ7JOv4i157I2LKk/OQHAdePFM/wUA1kgbRzZCF+reRZQjRg3RXmWmhlQTWJCnj0C0wpoh17T0XRuGl2h7tesE1NldeLPiXBhAjNvMYfDSCEBCGpMcjWtq79Yczs6DaejMI9NJWNKBECh2wibPCRIerZcs3kJPIsei+iV8VeyrbQ1+KF4eUio7jzkfjN/l57P97rMW2+xUte+W6ptWMTdHsT5YudvbFSNxhBnpr4KyK2DzTxEUPhm+JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Umi0OM7cgEp5EA6EJ4XSQ4zIm8lADURhrHDBevQaOBo=;
 b=mXGFcjHq55mMXYcf0r6rpBF2BZNT2BcoGE7WUU3hvQxbmU5Tfao+VxlTFLKjoHHGQzOYDctu0+LOdaQ7Pnn5qwETlfVvMEtkRg9fxUZ3rvsXpVoB7OJ646qTS6hX7jqyjG+H3muwMaiwZ4xir/W2t53EEPtq4RrSEkx2hbNY/h8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0219.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:ce::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.24; Fri, 5 Feb 2021 12:31:10 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f%5]) with mapi id 15.20.3805.023; Fri, 5 Feb 2021
 12:31:10 +0000
Date:   Fri, 5 Feb 2021 14:31:07 +0200
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org, Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 7/7] net: marvell: prestera: fix port event
 handling on init
Message-ID: <20210205123107.GD19627@plvision.eu>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
 <20210203165458.28717-8-vadym.kochan@plvision.eu>
 <20210204211934.273e54bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204211934.273e54bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P194CA0059.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::36) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P194CA0059.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:84::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 12:31:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cb878b7-7983-4395-5fea-08d8c9d1eafe
X-MS-TrafficTypeDiagnostic: HE1P190MB0219:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0219B1F7DB869EC8BBFC568195B29@HE1P190MB0219.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GSvnW5MvSjRO8rkUFyJ/RTRvKBY+xKtorAPgSMeLP7wtmfy1434goSpzwGJl+N+zkX/2hLky/4dhpbkBSXZvOEEau6GB7GRGxertDDR60Yk74xXWKpkMjMT0J1cHUvqjQu+v1qe6uG6OCsFv8iMOKZRz4CsSiA0fBazybhmCwTIgTvj4WJj4Qic7LFnWP63Xt4TrxkY1EuGALiMmPvPnl/8t3E4JiKv01Hbu+OWEUxSBb7RQAGzdStsxF3XF92QF2c5HsvC1CXh9ltVdVxyGXgwUUjFYVnTlLFAcdfXtXkMD4CA3mu70ZwhIC4d24CMjNDaLH53grqPDXNkBuoQFobnDEKuuobOgWOwSm9etYY6VZpj68BEcTlfGCZ99fN2bT3cXcCnil8ieGpVVzn/n5WGiRcyo3Z05d7lA/UOPuUPDIIR0wyEPnxF591VoUxeguMli/HmlQ481vnG+raR3nODqgEuEA5ukDF7JJnSzFTfo+zPlwWOcdnRRdgI6nEj9QwyABMlmOVZcK2UNXxO23g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(39830400003)(346002)(396003)(366004)(136003)(86362001)(2616005)(186003)(956004)(44832011)(6916009)(54906003)(16526019)(83380400001)(316002)(478600001)(7696005)(66946007)(52116002)(8676002)(55016002)(26005)(36756003)(66476007)(66556008)(8886007)(33656002)(5660300002)(4326008)(2906002)(8936002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3k0sH1A4ymDeL6IjakHpsCqcYMQVnx96/U3eNHWDWvI8yT7n7OKYHxDLsog9?=
 =?us-ascii?Q?j2ngZo3CCf/LtPWBtOkLTkWcp/TliFQND44qAEvR1HQtGIvQZWAsTG3OsN68?=
 =?us-ascii?Q?KVG6SlKGDwRX+F5cxbW7OCj0TjfszJP8lObu7fT5x94TrzuqBafL3xwPNmgQ?=
 =?us-ascii?Q?fKw5iNf0ZRK7bAsUDe0A30wRCOxAGU9QKTC/2gzi7rkE5TwrO9qw/8uoBxyh?=
 =?us-ascii?Q?SND6CADkKaAjIuK0cBjvQws7xx3r2X51NAomkBV+LmVMdGv4Jei00YxRNXy6?=
 =?us-ascii?Q?kc07HxZ6rrIukm99dfDd7rBjqaIPfBfVqpymFBGX3g/8U59xBS1b6sAy6TQn?=
 =?us-ascii?Q?hOmFYQXSW5CNlB93p/i2PXNrWsM+c0IE9Hegi08/H7c5MT8g88fb0rM6aBUh?=
 =?us-ascii?Q?uaTjw+RxgreZ2APsi9/1X3WoaM+j8eIfk0fClUvF8rARJr+9RwrCE5+Dc/S7?=
 =?us-ascii?Q?cXRJW5fUsSp6Ho/7HAPDZxyztBpQB9cH2J0NPHwV90iP5VHDYh5MvJNqhPYf?=
 =?us-ascii?Q?FKT0MpQPw2Ptv1vtkATA6Ut1P81pQd3YwD1ZhbUrJkgRGhsWy/0NSR2zItAW?=
 =?us-ascii?Q?MNeyg3BOMOpEtpRVT8gZeovoSX/RKcWwFsTducilhmW1e4//S3wpx/KToTMe?=
 =?us-ascii?Q?jsa4OmroY2mGDlOkqEosfaxSDjrBmwgRWwWGyiP3Zqe6HsmI5MrB8+lP4KjZ?=
 =?us-ascii?Q?TjcICdSQjlFSnEC22vPVcXyva1FyJu2e/F4Pd9WsXNz0uYHvc8/NJJHbg72W?=
 =?us-ascii?Q?vCmnv9hI+SFCJSgZKv1wrDowzb1x4MG4DL7puGoeMCCPVHlzpUREWbxr/Ys+?=
 =?us-ascii?Q?ycSLKi1saIWJh7gqTpYWBA4UHNl3I4U3V+INaeo4P9RxUtfR9IoOqb22C58m?=
 =?us-ascii?Q?xiluhI7N4y2j3eTv5yqeUkql3la3jZpJnkZ94zzJzhLaFR+vC03fsVQn4w7+?=
 =?us-ascii?Q?nE2kM2cft2NnkKszFtMnmibf2Yi0/7ziveQWQOoNytlR6nO1jsnXIb+LYPLe?=
 =?us-ascii?Q?Ypk7EPTI4hU6MG2mnHG0TQjHmQ65KM8lXROnfrPrtdeZtUv6TaTJdwEjXwfL?=
 =?us-ascii?Q?VtwTdljnppsm2wCnskrlBjX14Ix41y8mg3t15iavS6JhOX7mNaOJzbMCDlwc?=
 =?us-ascii?Q?ghFbLbwsP9E+BJ2DPAif8sG7svI4HHhc4d/4m/b4zE8OzI+Rc1xAPfMuDUgO?=
 =?us-ascii?Q?gu/5cyvNVDKIHTdsP1O9JiKrS3YYACqP7nm8SzXalwmHOJfj+e61EW9zykEL?=
 =?us-ascii?Q?MYmXOaXtTKM6cLpo8w+A6l54dLgtwG5/IAN8xml8C3eGFwzu0T0DEEb2In0K?=
 =?us-ascii?Q?hfpsmTw2LfnzE/wJw+5ywYVV?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb878b7-7983-4395-5fea-08d8c9d1eafe
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 12:31:10.5329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uPhPkhZ9GioPSCMScB6jGDMIW9uKYHKomSd1duG1U7uDoa+VRDHU7e6TydlUCPh6ncnQlgY58zGoQLxQOxSDPXr7LiAw8rnXd97RtPXfHVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0219
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Thu, Feb 04, 2021 at 09:19:34PM -0800, Jakub Kicinski wrote:
> On Wed,  3 Feb 2021 18:54:58 +0200 Vadym Kochan wrote:
> > For some reason there might be a crash during ports creation if port
> > events are handling at the same time  because fw may send initial
> > port event with down state.
> > 
> > The crash points to cancel_delayed_work() which is called when port went
> > is down.  Currently I did not find out the real cause of the issue, so
> > fixed it by cancel port stats work only if previous port's state was up
> > & runnig.
> 
> Maybe you just need to move the DELAYED_WORK_INIT() earlier?
> Not sure why it's at the end of prestera_port_create(), it 
> just initializes some fields.
> 

Thanks for suggestion, but it does not help. Will try to find-out the
real root cause but this is the only fix I 'v came up.

> > [   28.489791] Call trace:
> > [   28.492259]  get_work_pool+0x48/0x60
> > [   28.495874]  cancel_delayed_work+0x38/0xb0
> > [   28.500011]  prestera_port_handle_event+0x90/0xa0 [prestera]
> > [   28.505743]  prestera_evt_recv+0x98/0xe0 [prestera]
> > [   28.510683]  prestera_fw_evt_work_fn+0x180/0x228 [prestera_pci]
> > [   28.516660]  process_one_work+0x1e8/0x360
> > [   28.520710]  worker_thread+0x44/0x480
> > [   28.524412]  kthread+0x154/0x160
> > [   28.527670]  ret_from_fork+0x10/0x38
> > [   28.531290] Code: a8c17bfd d50323bf d65f03c0 9278dc21 (f9400020)
> > [   28.537429] ---[ end trace 5eced933df3a080b ]---
> > 
> > Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> > ---
> >  drivers/net/ethernet/marvell/prestera/prestera_main.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> > index 39465e65d09b..122324dae47d 100644
> > --- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
> > +++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> > @@ -433,7 +433,8 @@ static void prestera_port_handle_event(struct prestera_switch *sw,
> >  			netif_carrier_on(port->dev);
> >  			if (!delayed_work_pending(caching_dw))
> >  				queue_delayed_work(prestera_wq, caching_dw, 0);
> > -		} else {
> > +		} else if (netif_running(port->dev) &&
> > +			   netif_carrier_ok(port->dev)) {
> >  			netif_carrier_off(port->dev);
> >  			if (delayed_work_pending(caching_dw))
> >  				cancel_delayed_work(caching_dw);
> 
