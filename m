Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7271E26314F
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730802AbgIIQHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:07:13 -0400
Received: from mail-eopbgr30108.outbound.protection.outlook.com ([40.107.3.108]:7809
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730598AbgIIQF5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 12:05:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idAjydzgiJwtKCgnTe4TB1aeLNWQqh8r13G4zpXa814KkSj8BNL1KDLHFUJCsOzjXZ5TdAlYWA/BbVSpArYkepir3griEXyd9hxwSVvMUm7WNOaQl2CEzRwiaryP5LYpDmbO8eTyn3hm96qRFgGRu9Skq8B8f66/dxPpts/8o0YL8Pfb6JQ0A7niBzRuPm4xULFUZRGMzPGU+wyLdMZSA2TsBFATuIRq4nobfiLzfvdVydE1fz5DiYRPfKHCRmtixJXDCcsGrDwLZsI+bIBKP9N0kfHS66IyH+B+VGJseYlgJkiPxZKHJpDawRbERnPwTLKNlAfKHqvGxz18zX8YfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u87ni4YxxAfmvnx0VAhpFlFGI3GCwTIjqV8yr181+9o=;
 b=f70U82rmS7aCkK2yKLOPlCXQbZxgU1RQeFdYeLMtawmhMWQsmfKZUDmTHG5x8813ZhUrjgF/HSBypLYultSqdGLxPSrapUIg7bxpqsalviJ11q5Q91/iK1bFQRM3PhDl3FhYdXDDimWI24HRTnDoXIL7MZrmwOyEC3pDTxHXJ8QHLfL4bKors8OJUcrUC9Qn5G2nBr/1iK68ASEdo/IlONOhYD+7cI2VZvLwf9kVIyIk1qRHT2ZVjP9ZoMRKD/L3bFD2PRKI103n+sskYJw+0DHwAMHXnliYoxOekL4jhZN0SScVir2jYtvwHSnSzahWqs0GuwQyH81tJhYpXHQPhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u87ni4YxxAfmvnx0VAhpFlFGI3GCwTIjqV8yr181+9o=;
 b=HjT0hdFkzGN31PoaG1bJkkqlsqnw5hz+T3V9zGLISqsHPryR6EwvQU2XdGTJnqq+gfWBXhzoWqYLCcHEitjk93Vv3SedIxXPJ8HeGgcNlvhyRVu04Y/Uf4h3RtXDNj0+mWJpABkFk6jEf3IWuh6xT+F2DoEc02NsnBg8F7NaCeI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0121.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:c2::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Wed, 9 Sep 2020 14:17:15 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3348.019; Wed, 9 Sep 2020
 14:17:15 +0000
Date:   Wed, 9 Sep 2020 17:17:11 +0300
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
Subject: Re: [PATCH net-next v7 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200909141711.GC20411@plvision.eu>
References: <20200904165222.18444-1-vadym.kochan@plvision.eu>
 <20200904165222.18444-2-vadym.kochan@plvision.eu>
 <CAHp75Vc_MN-tD+iQNbUcB6fbYizyfKJSJnm1W7uXCT6JAvPauA@mail.gmail.com>
 <20200907073040.GA3562@plvision.eu>
 <CAHp75Ve_YJneS7qOY-CXtjB0QJKUBPMUi6nMkp93YMXkuYOfkw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Ve_YJneS7qOY-CXtjB0QJKUBPMUi6nMkp93YMXkuYOfkw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM5PR0601CA0078.eurprd06.prod.outlook.com
 (2603:10a6:206::43) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR0601CA0078.eurprd06.prod.outlook.com (2603:10a6:206::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 14:17:13 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ddabece-0da8-4650-7897-08d854cb0d4b
X-MS-TrafficTypeDiagnostic: HE1P190MB0121:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0121C8D7D8C1D3F109A732C195260@HE1P190MB0121.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XUUOOI3KJnfegyjgi7USJF0RimUCLrBUrQsr9kYpfqH7DOMDr2Hi74EjGCrwOltXvy//eFBqQsFID+yGQ6XqBEa0vYEsgp+bum2LSlwMyZ0Z+1PUnZ3XtRdhzG5xx4PRMpVa/YqYu4g5bZfFhOctbtcsWr+d17YnP2SVaQ8mCBzD6ble0qpv+6sX6Wz17ghFyzPEUZ1Oo7MhSk/SsCPykz9lAuikQDQfaDKQV513fwkRc3b8xu0qNfyq/1AEw2Bn8BM1SVChdEV+gHgWv3Bx7a56FVZoYGKosdnDCx99jtE3xPxvknWF4vGzAkACNDEy6EHcdQP7Sfd210RrLjfgPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(136003)(376002)(396003)(366004)(346002)(16526019)(33656002)(83380400001)(316002)(2616005)(956004)(2906002)(53546011)(478600001)(8936002)(36756003)(54906003)(1076003)(6916009)(86362001)(186003)(26005)(8676002)(52116002)(8886007)(7696005)(66556008)(44832011)(66476007)(5660300002)(4326008)(55016002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: DXQ5ur0SgjQp+mV+xkiNUvAvfweRtZFT1Pt7f3fdWuM/xxyJMzemu7ATqsh8r/tIfoZWw+8OW7lWAclEZ8TNMqsukYcviRCvHYsRuZgCoAlwHTyA9W9KnX4Cp/jZVVtXEVlceVUpmjYhk+NQk6DC3j+cmBmaSZ9Htwv7nyUzSp75cQOlsrJko6xOEMGw4+3/xwo4WGQ8zBdYbf+i5HPovwWobao40YPEu6uSSAdT0vc5ox6PwP+p3BNvfzlzBUHizt4Feys7mJ+4rHtHJKxNeManC1FgQmWeJTmvydNfgQBcsOwfqmyqjbg4GEzofn9xo/YXyfmQqopiRjkxASyMj2PKTaTwPWdKd3nr3kp7CbavL4oSITHm6r3rWMc510LxZRrZ5c9zDbTeU2Cz3wr4KDJWnUGR9s2tEMqqd+9C0wLhQqO1zlwJeji7vPv4ItyMhU21iw6JmOlRQT68W+MSJbJnNkMQWNx6Js68G19XP17d7vDntnHgWSnrmrZQYN7b4Id3K5sCTVicAE0CJ7mVp3/IeyEZRHfVGdVhpHE75+ri8k2FpA70j/RH6ascztzbz9eopgqzWSjmp72W+BlcS8a6T4mTEca1hyx82c2phpzTiRVTq44huDwb0mBvf+WiEveU7QmrFME5kGoJIpxi9g==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ddabece-0da8-4650-7897-08d854cb0d4b
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 14:17:15.2338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBgaHZc6w2Hp833kIwjkceKzlkzzV52TVQffVxe/4+188KztX0NBmBvzndgHgVvblrMX1g3vOpcw69kF9i/Zw3i4LgO4Es8l1u/VZJzCwIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0121
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 10:55:49AM +0300, Andy Shevchenko wrote:
> On Mon, Sep 7, 2020 at 10:30 AM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> > On Fri, Sep 04, 2020 at 10:12:07PM +0300, Andy Shevchenko wrote:
> > > On Fri, Sep 4, 2020 at 7:52 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> 
> I'm assuming that you agree on all non-commented.
> 
> ...
> 
> > > > +#define prestera_dev(sw)               ((sw)->dev->dev)
> > >
> > > The point of this is...? (What I see it's 2 characters longer)
> > >
> > > ...
> > It is not about the length but rather about easier semantics, so
> > the prestera_dev() is more easier to remember than sw->dev->dev.
> 
> It actually makes it opposite, now I have to go somewhere in the file,
> quite far from the place where it is used, and check what it is. Then
> I return to the code I'm reading and after a few more lines of code I
> will forget what that macro means.
> 
> ...

Here are my points why I'd like to keep this macro:

1) It hides accessing of the 'struct device * dev' which may help in
   the future if the 'dev' will move to other place or if there will
   some additional logic to get this.
   
   This is the main point.

2) I think that even by reading sw->dev->dev the developer will jump to the
   place where it is defined.
   
   This is not strong point and really by seen just sw->dev->dev at
   it is more understandable to see where 'dev' sits.

3) From the code-writing perspective it was easier for developer
   prestera_dev() instead of sw->dev->dev.

   This is how I felt during the writing the code.

> 
> > > > +       /* firmware requires that port's mac address consist of the first
> > > > +        * 5 bytes of base mac address
> > > > +        */
> > >
> > >
> > > > +       memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
> > >
> > > Can't you call above helper for that?
> >
> > Not sure if I got this right, but I assume that may be just use
> > ether_addr_copy() and then just perform the below assignment on the
> > last byte ?
> 
> No, I mean the function where you have the same comment and something
> else. I'm wondering if you may call it from here. Or refactor code to
> make it possible to call from here.
> 
> -- 
> With Best Regards,
> Andy Shevchenko
