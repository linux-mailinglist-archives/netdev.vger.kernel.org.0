Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776B12023F0
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 15:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgFTNZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 09:25:58 -0400
Received: from mail-eopbgr70093.outbound.protection.outlook.com ([40.107.7.93]:35219
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728064AbgFTNZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jun 2020 09:25:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgbLfBMuJ5igu/iQNq9aVpXXBmByDKkzxUFGcbS8rFjfZDbXXAWDkRNMxfb4xZ+3+qTnllUL7v+5Cwh9HEjreCDLh5KfP1Rro8P8SdelDPFvYEaCdYeY5MWJEFK6U9tfsSzMklhaLKLtvnflwwOYyd2w/Jiy17mmlQoPRfb1BoT+J3WC1o9zExfrwUwUc/1ZpJRKGZ0luf6yOTOdsmibevfX0TD9HPVfY2Ujsx+rcO9xb5Yd2gL9l3eSaDnzSnwpfjW9wDkFY2hM2fQHdMCPE5QdVxANagXMzqTWmlNoX12pflU4yBNlyE1Q5IgBkEANBdg4SWHo0pql2CJ5FrtIgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Se9TsmnyJkQ9cszpYSqvX6S6+z8dILbml9phNCG9hBI=;
 b=BPRJaJqdzbiM85dKCCAcSAQR1J07uFCwm19dnBbdx7E4hI/GKUHUnWePm6Ds9LtS0iyMgNJB6s+SvA9T6MfFH75m8fEXGpRN7YMjFSQRm5ztsKNt4z4JKsJ5lNiLOBYvruzcwCj0udiHR/9eu2fajyKMjH7YW4EjUrRWGh86mR75dE1U8wKdWcBSfH1TUDguHUOBJhZ+YG7v0oNzi+UapB7o1uIoI6hDw/V8fii1ZjFGhXcfJk8X5zcCoG/FjfmvbLAKYNvzNogA6S0kyij/YEY9Z5Varjae1QGuES3/m9GJ7eEao76hraZtta4IWI5Q7bIhmOrrUrLOcFzA/sHsWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Se9TsmnyJkQ9cszpYSqvX6S6+z8dILbml9phNCG9hBI=;
 b=AR5UA7ORjSt+qVtsLEQqbj9xfOfVDysH/0ajLbSHN2uv4R6X3H+JTM11Js5gcc9sYsCrxYB00cwcAA7+3yP/XDz6xiWwGAUQzIPsqTuveRL1DCxrpL+uDSabImO2rwBunIN/TXv7mW/Bd85ZOiooIdNmzA+s+hFV0BR1FpQGd5A=
Authentication-Results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=plvision.eu;
Received: from AM4P190MB0052.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:5c::21)
 by AM4P190MB0148.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:63::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Sat, 20 Jun
 2020 13:25:51 +0000
Received: from AM4P190MB0052.EURP190.PROD.OUTLOOK.COM
 ([fe80::70db:92db:9750:5ae3]) by AM4P190MB0052.EURP190.PROD.OUTLOOK.COM
 ([fe80::70db:92db:9750:5ae3%7]) with mapi id 15.20.3109.025; Sat, 20 Jun 2020
 13:25:51 +0000
Date:   Sat, 20 Jun 2020 16:25:47 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next 0/6] net: marvell: prestera: Add Switchdev driver for
 Prestera family ASIC device 98DX326x (AC3x)
Message-ID: <20200620132547.GB6911@plvision.eu>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
 <20200530142928.GA1624759@splinter>
 <20200530145231.GB19411@plvision.eu>
 <20200530155429.GA1639307@splinter>
 <20200601062417.GC2282@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601062417.GC2282@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6P193CA0139.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::44) To AM4P190MB0052.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:5c::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P193CA0139.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Sat, 20 Jun 2020 13:25:49 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0aba7e4-eb36-4d0c-01a0-08d8151d7347
X-MS-TrafficTypeDiagnostic: AM4P190MB0148:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4P190MB0148AFA555210E14E1A46ECF95990@AM4P190MB0148.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0440AC9990
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aUYJ0Z+yorLYJNLSBmQdYRmhxtQUelJ4aOTfkCahetQxIkp/zIWMm1Zn3s2GyS6McCqNwsPJaZSujtheEoyt+6VtWlSq/9ZCYu31wWFuphxX//7dy6WQBZnAextfLaWeMJdFOPGSZnIEPZ91LszpqCW6ZiYpnm51KkS3EIXpY/KpaMALDgcz8JvootPi/gWghYUaTyc8OsdANdZEdPNvWrs5gAgI/0Tu5hdcnqXHE4yeept2fcxq8cQzW5Y3k7V/WPlbKOf0+moRJ45L+M4Q5TizDlil7rFH5wyI2Ed68GsxSdv1y1UI651AXdJnpVL1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4P190MB0052.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(136003)(39830400003)(396003)(346002)(7696005)(7416002)(8936002)(83380400001)(8676002)(44832011)(2906002)(5660300002)(6916009)(26005)(52116002)(66556008)(66476007)(66946007)(1076003)(8886007)(4744005)(2616005)(55016002)(33656002)(508600001)(54906003)(956004)(86362001)(4326008)(186003)(36756003)(16526019)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: eyu1UVTULygheklciCubWCiFTCPJK2wJy/5pJsK91zq+/xgKp9HoLN7twKtu1T6gaS/i3DUDPM+xw9WWTTy2V3ZqnmrqJdcILAErafRoZFMbK1xbaTEcaN1Jnhmv4a2PpZrI5PX0OE666eHV17BiVug2tfT3l30S7GvZ7Azhi93enYKiOsdrfMI3HKdKnBS6g5EEMb/npHtpybr3A2bGwQTvo+CbcCNOCHprRRS8ALtXCm8ftaoadjGV2NY9K658tU+GBflZWEbmfFQcGKBd+YMYsVEF7gbiCu+Xpukk4L8jERGNpppQlJXGfISt++xaItCwPZIRgpr3wObVifDT99YKdPqIkYK+c8O1Nt9wEFfO4FRv77liagEp908J1JNYQcpmXhsYxQIG/eI5ha+tExag864q44WzKbk9b2L6bv9FYWIHkPWBLM+pRLp3AwIfsOsZE1DV7Vhj1q/mKfC/ojDJXjiQgiPczcEshjrYmwM=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a0aba7e4-eb36-4d0c-01a0-08d8151d7347
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2020 13:25:51.1900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sO5cJR4AvkKC8CNetba0HzjX/BIgZ5yh2FxC2Z/bM3sWmFV/xEdjZ8TFgxQ/qNF3fAwQBuzBMA7KoTMsUADrItjCEtbHgvYl3CGdmDOjPxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri, Ido,

On Mon, Jun 01, 2020 at 08:24:17AM +0200, Jiri Pirko wrote:
> Sat, May 30, 2020 at 05:54:29PM CEST, idosch@idosch.org wrote:
> >On Sat, May 30, 2020 at 05:52:31PM +0300, Vadym Kochan wrote:
> 
> [...]
> 
> 
> >> > WARNING: do not add new typedefs
> >> > #1064: FILE: drivers/net/ethernet/marvell/prestera/prestera_hw.h:32:
> >> > +typedef void (*prestera_event_cb_t)
> >> I may be wrong, as I remember Jiri suggested it and looks like
> >> it makes sense. I really don't have strong opinion about this.
> >
> >OK, so I'll let Jiri comment when he is back at work.
> 
> I was not aware of this warning, but for function callbacks, I think it
> is very handy to have them as typedef instead of repeating the prototype
> over and over. For that, I don't think this warning makes sense.
> 
> [...]

As I said I have no strong opinion on this, but Jiri's suggestion makes
sense. It looks like typedef check was mostly about 'struct' and native
types definition.

Regards,
Vadym Kochan
