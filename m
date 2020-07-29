Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDBD231C55
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgG2Jxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:53:33 -0400
Received: from mail-bn7nam10on2076.outbound.protection.outlook.com ([40.107.92.76]:41601
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgG2Jxd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 05:53:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SeHsqlByvSX8flYRtjBoCJDIsd6yIq/CWPkHrKNXRLHBD/moTbRKtbppEQMyNllxkvrx+gQCuMYlfg1j0XDaS0bKr853dhEUCRPdn5Wyt/yBU6glGzPLzi2twXU6+xKwWi2Oi7OND49t5axWWp+1TrLNjeS7U3Bm+rk/j/Kl96NamWZQ0CG8EU+1qOeAPHn7gSjwEZKUCud4vnlPRj87eqzY6cHSnFwjxTcVDZOxgS9P3kwoZi/AwOd49Sxi8iVRwhHiJLcN9HGBb5IfjEwrxeK1x/dzwdPV3EU8Ke25W/Cby5hPhkznwRA9RJoR73zvwIYq8uF4bcGSItam+ohpPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ch/qpkYkYUHew5syPlUqLv6r3azsJvidhvJX3xZNSZM=;
 b=cJ93nBv1fpUWkEQmpiYxOOpVJt3V9rJGOx8w4+dyoAC+eFcsuxjgwswSbSIDtqSuRIWuCH8mXJrnmaeclWbfJtabsmdSoR4YMZ/sHeH3PCGIlpC7MAsdgexif7EwSfU0k6O0mg1wonXLa8AP+2lC2AlpxFu8VyPM9sqM8m/Q4zbCr1OzlVRsCia2NSHsU+FGI863wF9AJDpSD/fyo85sV07m3qivnxAn//yYohIyORcAuzdwqLDFjrMENFZnTiVkdZllxTcHjAZE+PYGUe2MEL8iNSuCqcr7P8utBAPl4TdF8Mrrjv7hgpOCpM5nWjNx8KGLigLnSLpbahcZdZ7WGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ch/qpkYkYUHew5syPlUqLv6r3azsJvidhvJX3xZNSZM=;
 b=WLoVAOKIkuvQEB2GVAxiMlyXafs+cdKFXmmscAEGDGbxK/WJSmrxE6zIMz+53Qu1KlVbpIihDx/edBmHIKdvVKdHGJobDPq1UTmbWiWyJ4GSU+GW2xKlA6jZcu4drayka+1bjZYNV2xn/hST4aVmYzyLo60k121S3MSCC1Tw3wA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by SJ0PR03MB5565.namprd03.prod.outlook.com (2603:10b6:a03:27a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Wed, 29 Jul
 2020 09:53:30 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c%4]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 09:53:30 +0000
Date:   Wed, 29 Jul 2020 17:53:12 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     David Miller <davem@davemloft.net>
Cc:     thomas.petazzoni@bootlin.com, kuba@kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-nex 2/2] net: mvneta: Don't speed down the PHY when
 changing mtu
Message-ID: <20200729175312.6d6370cf@xhacker.debian>
In-Reply-To: <20200728.175202.598794850221205861.davem@davemloft.net>
References: <20200727195012.4bcd069d@xhacker.debian>
        <20200727195314.704dfaed@xhacker.debian>
        <20200728.175202.598794850221205861.davem@davemloft.net>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0058.jpnprd01.prod.outlook.com
 (2603:1096:404:2b::22) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYAPR01CA0058.jpnprd01.prod.outlook.com (2603:1096:404:2b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Wed, 29 Jul 2020 09:53:27 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26d3307a-2e24-42fd-b853-08d833a53f2e
X-MS-TrafficTypeDiagnostic: SJ0PR03MB5565:
X-Microsoft-Antispam-PRVS: <SJ0PR03MB55652D64D9EF5FA7A0825DA1ED700@SJ0PR03MB5565.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eWjIAYznvKZG6iNY163bSXjbPb5mds1H9Dj3To/thiw46L/v9U9WgW4KvE6VMy992bGrh6wC5GM2TvNx82CWpl0tkIR8uJMsmSeFeT8E4NYnY7DwPrKFLZ1P8Yw7eWMF2zXHPXq/N/XCLL4+binMVrAdDh/JHGEBwNvshuFlFoopVbq3pHGshatSrTfkRzM/OahF6D8UWTo6hvFvRY3wTBrzzPOIBoDLLBxANVQrBa9LkuR5mjkVxj9a1DsXM3YUdssZL4AK43BqQ3Dd0PP78Jg8VLM9ZrASmO43QtS7TdaLawB9autAfSWvFd9KKO7t0IGJt3Uep8ZR2mSY9mG6YA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(366004)(396003)(346002)(39850400004)(9686003)(83380400001)(66476007)(6916009)(956004)(86362001)(66556008)(5660300002)(66946007)(8676002)(26005)(55016002)(52116002)(186003)(478600001)(16526019)(2906002)(6666004)(316002)(8936002)(7696005)(6506007)(1076003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +q8r83WNqHk73cC+ZcXda14lX6HYMAhyTK5YE/kBcQNQdmj4bC+E9KIoejo6By4WrANu2Yoz+xTcc+IV+UYFTSoskKTxhMetl0E5tkIPRatpuk5LSzeyhaY//j1VSOvYsy3aeVaMTHIISLMYAY99K7GRCMvAs15h36P7kf0/3zxyNp9oW1TAf7PP1zQ/1bzc0aS5VsSzj84maw7G9Yca4DNDJkSCEs94EVKB7eWHURTaLBI4VA5lXBd6KdSkQpVqEK1F6Dj1qUWtp7g+9SO2OyuEmfvrMfvkF7pXyp9TgG4CZQUmVx4msZqZ4j2OaXjV/G2/dh3k66zM8UMq3PnDDZi6qMim2NYS01qpQd62nbf5S2Zl2XG+qeDiw/rtoPl6XDpuZRhsjQJckd2g3kVJ62bR6jB8OyN9PnZBKo+zPqpG3I1tkzTwa9UeGeycCy9/3R9/1JbbekDjrglA2k18CdKDo1tTGgsmoIdkkVSjDV4=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26d3307a-2e24-42fd-b853-08d833a53f2e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3573.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 09:53:29.8240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0mbzKxlYgTv+t4SYCEVCXESJmowZbFoqCRYPiQS1m0oM+ydhKZXKBa9/C99Qoof+oh3l96xCUCp5bz/LCe86Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB5565
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Tue, 28 Jul 2020 17:52:02 -0700 (PDT) David Miller wrote:

> 
> 
> > @@ -3651,7 +3651,8 @@ static void mvneta_stop_dev(struct mvneta_port *pp)
> >
> >       set_bit(__MVNETA_DOWN, &pp->state);
> >
> > -     if (device_may_wakeup(&pp->dev->dev))
> > +     if (device_may_wakeup(&pp->dev->dev) &&
> > +         pp->pkt_size == MVNETA_RX_PKT_SIZE(pp->dev->mtu))
> >               phylink_speed_down(pp->phylink, false);
> >  
> 
> This is too much for me.
> 
> You shouldn't have to shut down the entire device and take it back up
> again just to change the MTU.
> 
> Unfortunately, this is a common pattern in many drivers and it is very
> dangerous to take this lazy path of just doing "stop/start" around
> the MTU change.
> 
> It means you can't recover from partial failures properly,
> f.e. recovering from an inability to allocate queue resources for the
> new MTU.
> 
> To solve this properly, you must restructure the MTU change such that
> is specifically stops the necessary and only the units of the chip
> necessary to change the MTU.
> 
> It should next try to allocate the necessary resources to satisfy the
> MTU change, keeping the existing resources allocated in case of
> failure.
> 
> Then, only is all resources are successfully allocated, it should
> commit the MTU change fully and without errors.
> 
> Then none of these link flapping issues are even possible.

Thanks a lot for pointing out the correct direction. Refactoring change
mtu method needs more time(maybe for linux-5.10 is reasonable), so I
just drop patch2 in v2.
