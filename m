Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8FB1CDAB3
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbgEKNDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:03:03 -0400
Received: from mail-eopbgr140122.outbound.protection.outlook.com ([40.107.14.122]:12310
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728046AbgEKNDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 09:03:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIl24oZHVPfJsS3gJObSIgMEglJTnkv1/fQRWoFsrSh9oaNWBUhFGGXstdNuUWsuBIP737M/LBrl2sVuTbYR5VwD/5SBS7+SysEwbwoj7wCaLT3omRY1m32HvgqWNs1XS2FUS75HMrAMCLnfmNXzop5qrCthJSurDwwkTBFJbhlVX2gWBE83WRFeiQLtfYTQ+qTyztxSnkA5Gw3Qb/A/Blc3rf1mKZT5n3o4CinMTOoENE71XRbASAsz1b24bqUAppqkc+bISephWhR5udzXljC8QwmrG/4wkPgiz1xgLqJEgufpHthp7sRs1Bl0Zks7ZxpvxmeO2KODdjmwzPGEyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+zB/DYqO6yAf4T0Au7j/kjNGUg11+zhULUuZK45qjU=;
 b=UgnY/Gr4KXt/jv0TAL2WGSPFZBiD+TKyZxYFeFpVZ1ggJFS1W5xbjISqkUtChMlIL4jDYyYQJcLec6PWeJLZhGCNeBZWmywkN8fZCevRFZB5LRt/RzDcrW0/gd9+4fJlIkuiwx4peMir0skTpS4Ho4zkhDaFc9Pw//RYBnMVI4He2MYgCtdqgWsUvn22GAyWjb1tr07cJYd0wV7Kn1SH7EKHighwVQ5K9rUTctgdskLzCT3Crzchuyc/vOoedhJ5QBYV1u3Gi2LhdEuw1kjfH0wbqAn/Avb5o+AMuAlNv7KNDeUWHp7q8I0zqR9Bami7dRPOmJBRSRIx2w9fV7dvng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+zB/DYqO6yAf4T0Au7j/kjNGUg11+zhULUuZK45qjU=;
 b=tuLS+u7mYjlH+t9UoEQZrPHHNBDvp6iUdEip3cFiXiC7793dCTuq1YL+mxQ6eWLLofzkSQKkjR5idbVWMjQ3YM1JBxxlR20dtcv86rvUjZA2jIJNRvqEAuOqxz10TtBiTFSMrLxBZHyFryJkgNXrcq+s5EE3NHg2AN9w4b8KUjI=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0703.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:124::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Mon, 11 May
 2020 13:02:58 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c%7]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 13:02:58 +0000
Date:   Mon, 11 May 2020 16:02:52 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 1/5] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200511130252.GE25096@plvision.eu>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511103222.GF2245@nanopsycho>
 <20200511111134.GD25096@plvision.eu>
 <20200511112905.GH2245@nanopsycho>
 <20200511124245.GA409897@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511124245.GA409897@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM5PR1001CA0033.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:2::46) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR1001CA0033.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:2::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Mon, 11 May 2020 13:02:55 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0e01951-bb2e-4c11-e368-08d7f5aba0be
X-MS-TrafficTypeDiagnostic: VI1P190MB0703:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB070363ACD234571B38D1D97195A10@VI1P190MB0703.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k2B4l7S1fdl3dnKA5h1PsRFHL390yABiFu92nmFa+52wXWR4D8+7JL9QZdXtOOfXAt4ZIT0bH+7JxpZ53TWSdueO+Aq2vvXyslBnB36rSSsbK6MOusbCkm0JjyGrvOpqauEntxoN5RPzzJiLkn5T/ZgbeO6vZkCDuV1U9jL4QaAKzcOCSm7zLTnh19nDQI76E4dDZke8Qhqg6nWbUZdZJdzc1VZbzKhSxs1xL2sYABvoxl8WKBv11lHvHQJPTcDWI9fPJbrLm+oGyLkfw9jN4MsM22AN5w/v1BYAQQ7LZlnUPqVAx8ZT2ltubkwwfiEFPFO2a0LTRiXYq0g2bccTpHkv6KuQWyJKiyZPnP7Q1rTSWmoeuU0rU/WUnHSFwn1p7uw3m/sgy1rn34ZiJC+VrdHr4jA76lnTpQKbAREWmFaqhEnRlaAJc2rRnWZWxpSA5/Kzozo2U9lzY4d6n5/wX4kiCQxcwQPSzbpGxGsd/wiORtC3j4xL1LV2mfiZStI2l2IBKof9LJKbAFAnQwptFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(366004)(346002)(136003)(39830400003)(33430700001)(956004)(8936002)(44832011)(2906002)(36756003)(2616005)(8676002)(6916009)(54906003)(66476007)(186003)(66556008)(66946007)(316002)(16526019)(26005)(7696005)(52116002)(55016002)(33656002)(508600001)(33440700001)(4326008)(8886007)(6666004)(1076003)(5660300002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: UrJ12qKQUvLTyQiypXWrV8u3MvpXJkZvVXZkRGpfHe6nIY14D5iFfMR9Em4bRY8K6rSEufyqn6U5DJwdZ45OxgGSFJuFiPp1MteSu3JKD95jvAKDFhQh+fnkm/db1RGwccQRdi82RiAIEahQVfrowRw+F0vDa+qHmp/tlA2mSDaLhpvGG/bUIuunUND9ktVQGlmpve72ed/HqRnHwb4nWQK+kXHxftobxY5QJttYuL77JFowJriC7OWQ7aS1A6EWA6wFj1u/msSJFTVIIQqVzT7FoQcYWKfRBKOIEwwTI+giUfto4OENM2b1Wsn4SeprIt+tfLzYteJ5MP6DxOiIf2kVA4l7hB7xjpiQAUz3va/KCsH4BCBWOr3DNdl2U8IA3Qu+MQxQrVbtMG7afOklOA/L7QnOUZOECBXX02+2ZehYoUsbrESMk5Tt1QUuhTPcIFkCFoSBxV9yqcmWyz42hOULiMq1GdnOF72RpEnex3U=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a0e01951-bb2e-4c11-e368-08d7f5aba0be
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 13:02:58.4599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uJOHEiWgqMQVPBYaWzgcG4XzX1c/fVEZgQGh2MpsTVfvH5U3zKknTtsLj92AFDTuW8r/YdbCuPHyDLeCusEABiQmT9K6k7YTOgAFHHHgpSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0703
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, May 11, 2020 at 02:42:45PM +0200, Andrew Lunn wrote:
> > >I understand this is not good, but currently this is simple solution to
> > >handle base MAC configuration for different boards which has this PP,
> > >otherwise it needs to by supported by platform drivers. Is there some
> > >generic way to handle this ?
> > 
> > If the HW is not capable holding the mac, I think that you can have it
> > in platform data. The usual way for such HW is to generate random mac.
> > module parameter is definitelly a no-go.
> 
> And i already suggested it should be a device tree property.
> 
>     Andrew
Looks like it might be hard for the board manufacturing? I mean each
board item need to have updated dtb file with base mac address, instead
to have common dtb for the board type.

And it sounds that platform data might be the way in case if the vendor
will implement platform device driver which will handle reading base mac
from eeprom (or other storage) depending on the board and put it to the
platform data which will be provided to prestera driver ?

Regards,
Vadym Kochan
