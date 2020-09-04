Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C537825D533
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 11:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbgIDJfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 05:35:01 -0400
Received: from mail-eopbgr10118.outbound.protection.outlook.com ([40.107.1.118]:32373
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725812AbgIDJe7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 05:34:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HsOsglI+TMmxP+2/wyHrWpk8HlG+STlYHIEkbW+IL4kx8SJmWk6GYNQoj7fdOLde8Hok6dFQgrdSUiKUFZK7sxjgHVE3Yw2AdjodxNkhth3wPepFH/UDj1+DaIjMCOWbyDeO22z9GqPVw3jb+odSj2Ue2Kv8GlPBYRsjdm6uvFF6CYn4DOlfdnNt7Wr5cs9d8zRlxdPvwprCcaIDNG9BiGn8pr6IzrrRgCmxuxODb8GItUCouBoEDqW2HwmtxtNJBgI2NkAn4IwUvCChQ2GY2bLCkdx3szTN9jSPHT/CP/cm1z2S8UsGSaEzDgi4nqKj0kvk35cREAb4ReD6issUHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nCTOZ2dPtmkiz2hIM5WIjnJnsSkL/LGBsBqGTJBeMw=;
 b=LDFnroLkwAXvmfa3K9hhY323yBe8SNRW1YYDfEkYo2NgOVZsNF2F7hmcpOqr8D638FwJPa2niDf+xfnpFZn0FgCN0VGjJlFIFqBKknPJcXMrVjFl+jGDdHdGHpJNqcWpmMByOGG5dcFa4jNqlgyuWuBDQOweic1/Dgb2n7W2TPh656Ot/kxDbsBGD0JGF+jVvIGXHP57uaKDT7p9C2fzI1u1ehohcLfw4ThhVuAAJ9SbM+XN+nbRdwobEX2wlOMI1kCM9HyvPLCJG6C3XdIPmpAd9TJyuBu2oMluc1sgU/zVBhPYR5oj7oFm/JbnGGh9r2YX6pBl4Jl+0bFJETffWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nCTOZ2dPtmkiz2hIM5WIjnJnsSkL/LGBsBqGTJBeMw=;
 b=b+s4Rdcf59CAG19hnkoJyDC9FhTYkKh4uJOxSWie7RB7sItYUihpSEcGbvepUuPmGvv+Ttb6OuaIXGszAusLCKkiY+aDLPTwBz/s71Qp3PunAzPA/2qEW/krILv3FjBCN+vyMN8KQfK3lotS5b9nryZ3nqWDo+FFV97QXn3tmY0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0535.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:3e::26) by
 DB6P190MB0117.EURP190.PROD.OUTLOOK.COM (2603:10a6:4:87::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16; Fri, 4 Sep 2020 09:34:55 +0000
Received: from DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 ([fe80::9cbe:fafc:3c8a:3765]) by DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 ([fe80::9cbe:fafc:3c8a:3765%4]) with mapi id 15.20.3348.016; Fri, 4 Sep 2020
 09:34:55 +0000
Date:   Fri, 4 Sep 2020 12:34:51 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
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
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [PATCH net v6 5/6] net: marvell: prestera: Add Switchdev driver
 implementation
Message-ID: <20200904093451.GC10654@plvision.eu>
References: <20200902150442.2779-1-vadym.kochan@plvision.eu>
 <20200902150442.2779-6-vadym.kochan@plvision.eu>
 <CA+FuTSfNX0vYL2QmomVBrjXzmQ7WUUmOhtyM_9WfMkSQD1EuPw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfNX0vYL2QmomVBrjXzmQ7WUUmOhtyM_9WfMkSQD1EuPw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM5PR0202CA0022.eurprd02.prod.outlook.com
 (2603:10a6:203:69::32) To DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:3e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR0202CA0022.eurprd02.prod.outlook.com (2603:10a6:203:69::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Fri, 4 Sep 2020 09:34:53 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bcb82a0-2a5a-49c0-a134-08d850b5c841
X-MS-TrafficTypeDiagnostic: DB6P190MB0117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB01176E8A9969238012865358952D0@DB6P190MB0117.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:123;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQ1JnOBbr7XXEFSn/lqkXO4nsHDabcz1W5U2kcFnFl3/zTfv+U0s6bP3BBRXddUp6AWm18KTUB3N9PiLq6TR14BfNnqQh9tTaAIh06kJxovVi1KDOhsUMhOJ4wBnCv6uuqbcw9pHOLfXlgniGQeB4CZlb5Au0GktmljzZE5ethybe3MVv52p0VKYqWU6c20kmmKqQsiv4grSj7UdrdgBVLX1jk4UL8kLXMm4Kmf1VBO3qkc80vRzhmD0dkiZ3IDKV4uACxA0iw+9AqtuE8G4lsyiNfwjZ888NgA4T0zhwu1WLKI+Z8noXuKPHZ1ZSHZccQL+ApuIQU9oCB4QVDw2Jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0535.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(136003)(376002)(396003)(346002)(366004)(478600001)(186003)(54906003)(55016002)(316002)(1076003)(7416002)(6916009)(52116002)(8676002)(44832011)(83380400001)(956004)(7696005)(2616005)(8936002)(36756003)(86362001)(33656002)(53546011)(2906002)(4326008)(66476007)(16526019)(26005)(5660300002)(8886007)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: J5YnYIV5O+lHSabJ00ocq6hooSPtx0kTg1PxHu+bNFPEaq/tkqeLRXE3ojCFrGBPuTe3FBhCnfq63UZM+v9TIAdOV0AxXJ0lsGxNY+27ZuZbnqKir41zCdxe3jKZ8sb4Ze7t/nnrkI5VTIL+VNBWzQ9dQZLHdCLNBYMm0ziduiEzQmN0OMBJb1XnQVI/vi/FkrPJIiB/v3nCK+nvSoTKPPfH3AfVEHGPB8UR2T7BUPJx04md4Ly7cou+CrQ4glpUB7vikSZTmRg+P1qwVEgNM39QscLBZHHOQcuE27vTmEtaijBkMwvHnJnqktI79VKx1vAI+zS4WXzk8Onod2hdp7BGv3bRgd/B6VL8J7Tjp+Lz1ZjLslSA0kW0xGrYOg13KdpJwZSp2Gh2ptRZ0D2QDZFSqBqPauQX/inQjyeIaPcZAbNQHzYpvWESD+UDKROnUr9R46hnXuIXwA1ZtAsmJFHM/ckkpZSuSobyQhVez0ZmK/TTPmFCFnBd5NHm35K32x+Wd6pK3StsRNtLrqsK5CkOPWC+dOnT0SRTulB+YgKfmmoVF8aZV4Kig/KZj9ZjWusRMh5kS1gfca4vXY6OEKihNQk3+yUyXH/EbiGp8sMF03TJmEEgbQRvR55kfxyUPh1GY/5DH4RFTW2hvcZVcA==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bcb82a0-2a5a-49c0-a134-08d850b5c841
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0535.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2020 09:34:55.3351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sex/3yhgschhaX2oQIGCzVHmlRkIa0ZQpBvYRueVkw1hEZAL1OC8PCpNyTTgYO6NE8lu9ZAuoiSel2NWBBZg+ev1ICs/sjrndDxLLe9uG4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 07:18:59PM +0200, Willem de Bruijn wrote:
> On Wed, Sep 2, 2020 at 5:07 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
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
> >
> > Co-developed-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> > Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> > Co-developed-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> > Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> > Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
> > Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> > Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> 
> 
> > +int prestera_switchdev_init(struct prestera_switch *sw)
> > +{
> > +       struct prestera_switchdev *swdev;
> > +       int err;
> > +
> > +       swdev = kzalloc(sizeof(*swdev), GFP_KERNEL);
> > +       if (!swdev)
> > +               return -ENOMEM;
> > +
> > +       sw->swdev = swdev;
> > +       swdev->sw = sw;
> > +
> > +       INIT_LIST_HEAD(&swdev->bridge_list);
> > +
> > +       swdev_wq = alloc_ordered_workqueue("%s_ordered", 0, "prestera_br");
> > +       if (!swdev_wq) {
> > +               err = -ENOMEM;
> > +               goto err_alloc_wq;
> > +       }
> > +
> > +       err = prestera_switchdev_handler_init(swdev);
> > +       if (err)
> > +               goto err_swdev_init;
> > +
> > +       err = prestera_fdb_init(sw);
> > +       if (err)
> > +               goto err_fdb_init;
> > +
> > +       return 0;
> > +
> > +err_fdb_init:
> > +err_swdev_init:
> > +err_alloc_wq:
> > +       kfree(swdev);
> > +
> > +       return err;
> > +}
> > +
> > +void prestera_switchdev_fini(struct prestera_switch *sw)
> > +{
> > +       struct prestera_switchdev *swdev = sw->swdev;
> > +
> > +       prestera_fdb_fini(sw);
> > +       prestera_switchdev_handler_fini(swdev);
> > +       destroy_workqueue(swdev_wq);
> 
> this cleanup is also needed on the error path of prestera_switchdev_init
> 

Thanks! I will fix it.

> > +       kfree(swdev);
> > +}
