Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9B7263E14
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730359AbgIJHIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:08:37 -0400
Received: from mail-eopbgr80115.outbound.protection.outlook.com ([40.107.8.115]:8065
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730158AbgIJHD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 03:03:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YStqwuH6W9Ov0VyXKx1tNIVCrh7UEjUA+NJ56vdVFGTxxSOBr8RNslukNGnp6SEGy21id1W4AFjI9sIfiNjYhW1p5r9sGlC9ZHapr/SxW+QRA4hl0PGZPjqPWDDDG4Yc4WkJp3hhHCDQixVgD711eQrTk/crTFTOm5NtezSu1dx3JmEfnrv2ABeafHKZ4lxrBh3mhg8CMQWgcXmXGpFrVm1Y6yB+Ol5h8ord89mjHeA1Zb6PbpRvStKYdS3x/NBDmE4lXWdx2CBKA7xGLDwaLSFHQKGNkQFU7y5Zcs9ETwhYga2dZ6iR2ajBgPuekqMxJ4VrcwLkmG82NgomnOh8AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWseOgFCfX29rWyS6ZPW69w915xwz3ljue4OzoQKh1w=;
 b=k+56o5DldfYjuS8dMgzEY+d0Wa4Y1ou3rsOT5g0fApP25UnyIbo7lbXD+oYiBXcNru7gao550++heDZP0YWyjiJQlqv7XpM+sNelggPEERSyUeadHcA+X6wlYhL8R2KOkrAHAt6cMsr3BUxl8RdQMAOEdeKV7L6PlLsVARWjmLUA3fXtzuVWXBo2Q2/rQGAY8bK/YR0IyC6uZTe9e7dixgCkHwRjfDyk7LfkS+ZwAT3ME4gf9iHxDtd1UeKGXnPWwCCzxdoYjvyCuRVM+UJrXCQxofVRZCYrlOKd7L3O5iRzhv1kQqfqEBxnHfjOLbO6V3sMTKAmdKZu2YSyf0ISLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWseOgFCfX29rWyS6ZPW69w915xwz3ljue4OzoQKh1w=;
 b=JDxkZPMf8gFfqcDgPeUqwedw9sW/UwLkXDZJpJhMz8mj/ISFV41Lp6VwxsxL7ah5O+bglBoJJiLCJwqjpZoo8ISEKTPhxdxiOGJgpVSdOGAamkneNFZ/uMvSq9OaV+Iie8do+A+u21+JIzUcJAxhy7++TRTWi1mojJdtymNHxUw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0265.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:55::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Thu, 10 Sep 2020 07:03:21 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3348.019; Thu, 10 Sep 2020
 07:03:20 +0000
Date:   Thu, 10 Sep 2020 10:03:16 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [PATCH net-next v7 5/6] net: marvell: prestera: Add Switchdev
 driver implementation
Message-ID: <20200910070316.GD20411@plvision.eu>
References: <20200904165222.18444-1-vadym.kochan@plvision.eu>
 <20200904165222.18444-6-vadym.kochan@plvision.eu>
 <CAHp75VedS=cnE-9KVMFS-CF9YwR_wrkGgwqHROhe0RD-G3O7YQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VedS=cnE-9KVMFS-CF9YwR_wrkGgwqHROhe0RD-G3O7YQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6PR10CA0076.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::17) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6PR10CA0076.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Thu, 10 Sep 2020 07:03:18 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6da5d6f-2918-4f19-5236-08d8555799aa
X-MS-TrafficTypeDiagnostic: HE1P190MB0265:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0265D35E5F7600154260297995270@HE1P190MB0265.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h4Mosdx2JsakMhrwup/Xhyo7g7xr48B0RcCTMLWqmuF5RnSlyQB4f4BEEcSdlE4NTCTqlck3FZ74x9UaIzCB6SF9SobTZLalPXak12dhkdZQPRWz1CtibjO1ePO/113H6exp+xEeNx/oqpW/fmzuP6s6D+Sc7+ucPn0XWgyMxEh0Ll+SXTgL1WRCwyxxuWVmF38/4AKT14a55McvWzBHfBooJrNhFj6zGgE8UxfC1BXmF60cV6pIDN8+akGw4kY/wYBOnwjS706+lf34rW0WzIECePPx7kDgo+Ge5ov0UfqFCw+ZivnOqOxxxXdUddvG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39830400003)(136003)(376002)(8676002)(53546011)(956004)(2906002)(66946007)(1076003)(5660300002)(16526019)(4326008)(54906003)(8936002)(52116002)(478600001)(8886007)(36756003)(26005)(55016002)(66556008)(2616005)(44832011)(66476007)(7696005)(86362001)(316002)(83380400001)(186003)(4744005)(33656002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: SJ/dLrXASUS56+2mbKhzOgZzp2wvxBa+CBoIS5rAkFBSABD+LZPuwOqwt4JAcx4RS+YvgmVAlM7GkmlqZB88ZwKFaDr4wm7FvwWycnmS0PJVBImS30vwaHFq+eyEsze1EjAhxVEBJXlsDXtdkhzRMeRULb1otslrauQ+Z7beI21zZAVYjQhCuJRnTf29IBbyYSHEp4AIK0lcwYwP9Qi41oWxXCkp246qxKnZcCK8XxPiEuYwM5ps+8Z9ECyc3F4nHZ7nW0IDUMNa3KOBylCMQRQ3SLSCz/sGZdHX6eEpmmIosM18iFwX0BwrhV0MSp7HD2w9IfUVZWXLh/WjISXUjp2XB2swr7kN2OIY88Vx1itlUx3LvDiKZyBd8c6xQuTf2wJE06zugKhAvcmEnaIgbI55XJo7fP19eezogilwBCdo/ESnAcfg6O0Ra8/Fce6+THHLzL3Kp8GL19RMu5HZNDxyiTAF9wnDprMzW5ziLr553U2B8WX47VIJtJZi4FdDOyqcQZTUTpiIXS8OVafn0pU/3YJacszjLY73hwPZ8U0yH1nm0/kaMo1nFLHaJn+qk2jJ7WrrWybs8dxzj6+rBGBOvz1MySR8/03KdgZ9/0wMY6tuS0El4VNG3Ye6oy2JG81ggzaBsrVoEfJm5hTm9g==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e6da5d6f-2918-4f19-5236-08d8555799aa
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 07:03:20.6314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fCs9gJIiFM6Qwp4V8mZBeyvsOv3h/rPV3LLI23wBbClazUg7E/Tc4zv9kyTy7G1Wxu1KSN9YRLHBdBOUEFn8PA8iis8BFAtbCileGw54y4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0265
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Fri, Sep 04, 2020 at 10:41:17PM +0300, Andy Shevchenko wrote:
> On Fri, Sep 4, 2020 at 7:52 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> >
> > The following features are supported:
> >
> >     - VLAN-aware bridge offloading
> >     - VLAN-unaware bridge offloading
> >     - FDB offloading (learning, ageing)
> >     - Switchport configuration
> >
> > Currently there are some limitations like:
> >
> >     - Only 1 VLAN-aware bridge instance supported
> >     - FDB ageing timeout parameter is set globally per device
> 
> Similar comments as per previous patches.
> 
> > +       struct list_head vlans_list;
> 
> How this container is being protected against races?
> 

It should be protected by rtnl lock from the Switchdev core:

    net/switchdev/switchdev.c:int switchdev_port_obj_add(...)

which is called by:

    net/bridge/br_switchdev.c:int br_switchdev_port_vlan_add(...)

> -- 
> With Best Regards,
> Andy Shevchenko
