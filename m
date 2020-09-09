Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB2D26314D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730729AbgIIQGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:06:46 -0400
Received: from mail-eopbgr80098.outbound.protection.outlook.com ([40.107.8.98]:37285
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730783AbgIIQFz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 12:05:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMXCQBXTQ8Tq8sib0VgAlgVT4IcBPN5WoTWNB9dxiuqY3NCEEz9/Y3Bc//q28s5ZudzYFKu5WqNHmhoq7ryytGj/l5FRAYb1A0O8RMSfsPVPPNrLSZpbBleAScxx9v1+haRRQRSvzbvANW8dnTH/7SHr1UWvmOcwoPxmCInXBPHAP4WX7xqKAlpVE4C6pHt/sZs0hkGclaS4o7w55lx5E49NTVlgGrV8+9H9TGLsoqKtSTbSFVmDJiD6GxlQAJJw4pYZfUCB6FXZ1zBnRFACEjRtHZI2NzEZ1MbVkcEFZkeLFOD6o+doOXPzzhirdV0MhsB4QAfmGRZScyi+qdV+wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2NmK+5p4KI/tlORuyjsqrfE1ovHIPVVw4dIt6qs1yQ=;
 b=mpi9gKeqKo31t4HsMg6EHK+GF4eaAZOhFXWYhAqGbrPzRFX2owQOcsc9P11T4ipn/2nzWr0IDS3dHdk/apIiIrTCDpwIGYWkTBWxnIQtgsEl1Z5qnyzvk8DCjaFZAUA7aHXZVpWVfEbgBVXfCMCOrodChlhYESvwZZ+5aVLAY+7sZLZ4B234JP/kS+kLaUfsulsR7XmCqgS7ekIEjReK2DOaMarpTu/r6lOChm5VK0axKc7PxzKtVYC+iIV8iPKFysj5V5LwsQmaEJ8F1k9KE/3MuMJN5RoNe4W1sU5a/3whNxdGtwwZbEO+Khc47QxrinDL0Oala85NobsKJpeoVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2NmK+5p4KI/tlORuyjsqrfE1ovHIPVVw4dIt6qs1yQ=;
 b=Q5qQiZ2fV2BB/RpK3ReoPv8jLl/BS5nXvyo8r6wQxs11Uk6O4fhnenxcVclQ3yEuVNOr2SJ60Nhtk23dr1cC96PsdiYXD19qcwic8IfhHw7ret+mKKJIkitjieJyaZXxVqNua23Yk4uF5PpdQAWhnufy6gecV5xfBDEqqrAvHD8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0059.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:ce::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Wed, 9 Sep 2020 14:00:47 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3348.019; Wed, 9 Sep 2020
 14:00:47 +0000
Date:   Wed, 9 Sep 2020 17:00:43 +0300
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
Message-ID: <20200909140043.GB20411@plvision.eu>
References: <20200904165222.18444-1-vadym.kochan@plvision.eu>
 <20200904165222.18444-2-vadym.kochan@plvision.eu>
 <CAHp75Vc_MN-tD+iQNbUcB6fbYizyfKJSJnm1W7uXCT6JAvPauA@mail.gmail.com>
 <20200908083514.GB3562@plvision.eu>
 <CAHp75VdyahsNyOK9_7mFGHFg_O47jVQWro-mhU0n=1K17Eeg8Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdyahsNyOK9_7mFGHFg_O47jVQWro-mhU0n=1K17Eeg8Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM5PR0201CA0007.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::17) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR0201CA0007.eurprd02.prod.outlook.com (2603:10a6:203:3d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 14:00:45 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e26e3780-f98a-4951-cc36-08d854c8c04f
X-MS-TrafficTypeDiagnostic: HE1P190MB0059:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0059F7F841712AE6BF56DC8995260@HE1P190MB0059.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nXJ+mXZkBYipXM9gFlf/qbpizvjjaB+Zx85PHUn+5wwomthwy0/D3kPTCGwx1IWU21p8eSidDiWmQJVOwBHQ5vuqu2AsOC/nEe25yTep3FazXVmnu85bcta6jUCafJHGvVMOjDmqrKDT5J42EPIf+TBI7h7gXGSdR6IenBDY6ZB6DKCrlBW+EgkwlSj10Sizg6WG1oqz7+sz2qPCS4hS5wR6JeLUVqyCjJUo2dCyNX7ssOFFcNq07iaQaeDeFa0h2nB54uFe1ypOWcCgj6K+HQ5gSXzwIvzStvycb/CHtoH/pE6ZFq7UYc0rumLJe37Gg3sThSAYaQz6cG9PyNmuwVKzWjZlKV+6koyd3zd4X+Wn7fI/ctylPJWLXIyPib5+txA9TGc1TgqMKZCJs1XRwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(39830400003)(136003)(366004)(396003)(376002)(66476007)(66556008)(53546011)(55016002)(8936002)(36756003)(8886007)(1076003)(316002)(956004)(966005)(2616005)(8676002)(7696005)(16526019)(52116002)(66946007)(86362001)(478600001)(5660300002)(33656002)(6916009)(2906002)(186003)(26005)(54906003)(44832011)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: R8UcvbE1T/gzi1ibcaiwh0enwQepoTKqPwoBetJPbM5s6TBWDZ0Gk/cpjwMq08KfU5MA65BzlktuAZRHONcr9EecM1QtUTMLaq4tdRtrokbhB6JItzOLl/zRseS15fHlxBLodLiTPbpGWbz3FwSz5ACHY+qm7P4XgxgZNnp3pGrURpZtlqY/EjrzQuj43vKKsuEiIdXuNMqK+5+HLCdNSwLGkrYDyLfBsSCtFAUx8H0qPYlccDD8sEr5a25Et/tLZtygCoVUq69f1hWkHHptuHsxSDqOEkqCyA2pSh+dPIprIW5diRuAbybQTy2k2NzHqzMHO4f2cwP3j+2pUPEteAN2uld4PQDYNT4/Y/SXv19fuSQ7jEmUnliRQjVjaiJcHbGgwbFEiu0F2egK2o0LzFYzrZ0UnAz9E6kvnUs/VmlwT21Gnk5Xn4MibbnSIfo8Bg1B5AghBeiKYxEJrIHa4V89jALaSPUZNZ6uo+7IHDrGSMywJ/OLcGyr61pbR+mMWr7nUXQY548oRdLeUNudTf0sEgStLzWSo1G16HbgLp1EWQhblMgi2BFsq1N/ZOVA66H4OPwbp//oYLJYNnkbltlVTqnJXzKqERoEp9jVRgX4CxRwO65VkJtfWNWD1PW2y8eZTe4NkhWr2tibRiQUCg==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e26e3780-f98a-4951-cc36-08d854c8c04f
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 14:00:47.3710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SkIo3YEmC0LT7SNrlysh9k6mAlsOE4ffv1iQFYFr9i42ZsqRLcgKH2Gym+FtVz5/NsbtHkEAkbv/v+ZwQ3dnoSRYaXsT07V0Yqg0NBrA6wU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0059
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Tue, Sep 08, 2020 at 12:38:04PM +0300, Andy Shevchenko wrote:
> On Tue, Sep 8, 2020 at 11:35 AM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> > On Fri, Sep 04, 2020 at 10:12:07PM +0300, Andy Shevchenko wrote:
> > > On Fri, Sep 4, 2020 at 7:52 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> 
> ...
> 
> > > > +       words[3] |= FIELD_PREP(PRESTERA_W3_HW_DEV_NUM, (dsa->hw_dev_num >> 5));
> > >
> > > Ditto.
> > >
> > I am not sure 5 needs to be defined as macro as it just moves
> > hw_dev_num's higher bits into the last word.
> 
> And why 5? I want 6, for example!
> 
> ...

Actually this shifting is conceptually not right and should be mirrored
with PRESTERA_DSA_DEV_NUM genmask from prestera_dsa_parse(), so instead I
did this:

...
u32 dev_num = dsa->hw_dev_num;
...
dev_num = FIELD_GET(PRESTERA_DSA_DEV_NUM, dev_num);
words[3] |= FIELD_PREP(PRESTERA_DSA_W3_DEV_NUM, dev_num);
...

> 
> > > > +       err = prestera_switch_init(sw);
> > > > +       if (err) {
> > > > +               kfree(sw);
> > >
> > > > +               return err;
> > > > +       }
> > > > +
> > > > +       return 0;
> > >
> > > return err;
> > >
> > why not keep 'return 0' as indication of success point ?
> 
> Simple longer, but I'm not insisting. Your choice.
> 
> ...
> 
> > > > +                       if (b == 0)
> > > > +                               continue;
> > > > +
> > > > +                       prestera_sdma_rx_desc_set_next(sdma,
> > > > +                                                      ring->bufs[b - 1].desc,
> > > > +                                                      buf->desc_dma);
> > > > +
> > > > +                       if (b == PRESTERA_SDMA_RX_DESC_PER_Q - 1)
> > > > +                               prestera_sdma_rx_desc_set_next(sdma, buf->desc,
> > > > +                                                              head->desc_dma);
> > >
> > > I guess knowing what the allowed range of bnum the above can be optimized.
> > >
> > You mean to replace PRESTERA_SDMA_RX_DESC_PER_Q by bnum ?
> 
> I don't know what you meant in above. It might be a bug, it might be
> that bnum is redundant and this definition may be used everywhere...
> But I believe there is room for improvement when I see pattern like
> 
>   for (i < X) {
>     ...
>     if (i == 0) {
>       ...
>     } else if (i == X - 1) {
>       ...
>     }
>   }
> 
> Either it can be while-loop (or do-while) with better semantics for
> the first and last item to handle or something else.
> Example from another review [1] in case you wonder how changes can be
> made. Just think about it.
> 
> [1]: https://www.spinics.net/lists/linux-pci/msg60826.html (before)
> https://www.spinics.net/lists/linux-pci/msg62043.html (after)
> 

I came up with the following approach which works:

-------------->8------------------------------------------------
tail = &ring->bufs[bnum - 1];
head = &ring->bufs[0];
next = head;
prev = next;
ring->next_rx = 0;

do {
	err = prestera_sdma_buf_init(sdma, next);
	if (err)
		return err;

	err = prestera_sdma_rx_skb_alloc(sdma, next);
	if (err)
		return err;

	prestera_sdma_rx_desc_init(sdma, next->desc, next->buf_dma);

	prestera_sdma_rx_desc_set_next(sdma, prev->desc, next->desc_dma);

	prev = next;
	next++;
} while (prev != tail);

/* make a circular list */
prestera_sdma_rx_desc_set_next(sdma, tail->desc, head->desc_dma);
--------------8<------------------------------------------------

Now it looks more list-oriented cyclic logic.

> -- 
> With Best Regards,
> Andy Shevchenko

Thanks!
