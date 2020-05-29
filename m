Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A241E78F6
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 11:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgE2JDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 05:03:35 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:6129
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725790AbgE2JDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 05:03:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mW1nXJjirTyUvU3PaSkMA1sOiZgaT3UoxZT+r5k3tksKOJF5xP8EmXI/4Ti0DE/0bisnhV824MZnO9rRdQ9OZUO9TKBDzIuLRYMWtMQWZ5jlfC9sDexxlqREp6Hk3vO9WNeG3ASxZH1aOpF2a0dY9N5cY8aE82tw4Fp6Fq8EVCgyZ5e+8pdKHqfCzARztIkI63ymn9vzaYcimZ4xt6W+JXvRc43MyFmI51uaaNMP/wDqD+2BIP6E99VHlrlQrbTEAFE4CCClcM/x2BENPQ+o1KDcbv6D4PDcUYnCey3rqHAS0RNS07VgblMkjwD5s/j5X77CtwlIxUhJDTLwy1MJcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/CcqY2wSyqs49Q2mIJPiZwPjqlcpp60Xu75vq/uyEQ=;
 b=Saw3UcZaG7iWLzx0D2KG6V7V8GSp4hJMM95Qjg3mVeozFC2jb++GayHktgOcWmAR5eh5a0MQJYhCL5cDk2WyKj8TQKZAwmAtlDfCCqX6uNWt3dtwBbj2J8SvV2O5FwmW6LhBmafLlLljuFlftcP2WLErZL0loq7ODQgpokEO8AppT+V5RJ3QNsOGdKAmCDCQGKXp8iY7Zk1vtEH3ROu5c6TBUhOZfiSbT2b01CLnuuCuURz5JM0g0V7yRJSreHgwxyJnAHn1UuZk9y9T9/VOmE7gAsUuToDq1QXh6F/nMC1+Rjv7/JPRDuOFv7824xMKby98eA5E1SeVwbHYbMQzww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/CcqY2wSyqs49Q2mIJPiZwPjqlcpp60Xu75vq/uyEQ=;
 b=Fwlsch+zY/KzM+xJVZ69RXIswdqDjOx2lZP+U/6G3FfN7ZBhR6I3Kz8W6O6OqiKddSW0uWOLake3MWbWL3zV721Mvnff7hgz41+6Zwh8D4rqbiNFGyyFXKTQng6i4A+AlaB6Q/gk3nCqkQ4RVQQd5Efe5Rep85fGAOIc6A+edsU=
Authentication-Results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3484.eurprd05.prod.outlook.com (2603:10a6:7:2f::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3045.19; Fri, 29 May 2020 09:03:31 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 09:03:30 +0000
References: <AM0PR0502MB38261D4F4F7A3BB5E0FDCD10D7B10@AM0PR0502MB3826.eurprd05.prod.outlook.com> <20200527213843.GC818296@lunn.ch> <AM0PR0502MB38267B345D7829A00790285DD78E0@AM0PR0502MB3826.eurprd05.prod.outlook.com> <87zh9stocb.fsf@mellanox.com> <20200528154010.GD840827@lunn.ch> <87r1v4t2yn.fsf@mellanox.com> <20200528183703.GB849697@lunn.ch>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Amit Cohen <amitc@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "o.rempel\@pengutronix.de" <o.rempel@pengutronix.de>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: Link down reasons
In-reply-to: <20200528183703.GB849697@lunn.ch>
Date:   Fri, 29 May 2020 11:03:28 +0200
Message-ID: <87pnant8nz.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0089.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::30) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR06CA0089.eurprd06.prod.outlook.com (2603:10a6:208:fa::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Fri, 29 May 2020 09:03:30 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 61fd9bb2-7e1a-4402-526c-08d803af2866
X-MS-TrafficTypeDiagnostic: HE1PR05MB3484:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3484046FCD5CD4FA677D8F4CDB8F0@HE1PR05MB3484.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i5pCzbdWuMh4zZC1HDrdeqpRk4qTecFLHNDk0evwdA6BpReJkIkUuZLn0ddlMeauy5xwL+NE6qTzHw86rx/JfkE5vKhwmsHvIbBLmYQ+eg7oVmFPQhW7vU2Bizob7SzTc/vW2Lib2OE7TsQiypLVXWoVjVUBwB0PrGDHem4+ASvoSKxaVDfhW3VCpYda1bKGD+YUqnJxEPLTbsBo0yL5W40LajhEBsKJBthkAmTSuw9+7CXNqgX+J3xaJCWpV6AcTr/AgzLqmDg8F4WgvOkvmfouTF3se9wSz44hp6DR5qpUoU8oFSEy8PNBjgmrKfxK1ZiO6U+8yw9uTjh0Az++bnGnXir93Clhyihs0dpISt1xUdO5mLYGBcMNzNfFeCr+haTstFIfZcUaW2OwGaLIfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(478600001)(6496006)(52116002)(966005)(4326008)(54906003)(86362001)(36756003)(316002)(6916009)(5660300002)(2906002)(66946007)(3480700007)(26005)(7116003)(66476007)(66556008)(8936002)(16526019)(8676002)(956004)(186003)(4744005)(6486002)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GLcHX8c3zRkmv04u/h5htMajgjUXqo7Ntx6UahmegEq+gUNZPQweK6OP6VJhUD9JYXI6FoQTPjwjHBvL6BZfBxi+4fWHJfYMjxnFWsWLcJCSMTBZd2uov8SiFNSY6hsUF6XfRJXzgyvvjqN1iluk5806sxJ/pqzEUTE7FS3d02PYgMqQjpWbbZNjlgCXWOQ3oyGeV1UM2efjOqzkDtlJJdGxvtd9yENrF83vib2bZa5QYSitJBQl9lzxDSY+Eg1q5f7K+1KkFvl39Jk9x4vKM0jbkQCi2ZzKJ9whMMQue0caaqfOmDYGH8iEhsdoTtV7i0KaAnTyCal/nSc8QUWYdKAgdpfQQ8vNmmwUqoOLeJguUdYCdNhGi6MmVbEY/RewQghFIg8eaZF5448QgZgCGBaiW+5z+HBVGduGW+aBHj1EqVygK8pMPCDGIWGg17Wd1LJjKSRyF9azi45mWIBe98Td5vbMgrXLXkHvnTMUGcE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61fd9bb2-7e1a-4402-526c-08d803af2866
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 09:03:30.7578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xK8dTM183WzadZ/4GeM+uObvhhpa1f6t/crduNR22KyFnBi/LrHpP79sS3jsSfv1nNXwYA8F4rdLNTrUV8k7QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3484
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrew Lunn <andrew@lunn.ch> writes:

> It is called downshift. And we have support for it in the phylib core,
> if the PHY has the needed vendor register.
>
> https://elixir.bootlin.com/linux/v5.7-rc7/source/drivers/net/phy/phy-core.c#L341
> https://elixir.bootlin.com/linux/v5.7-rc7/source/drivers/net/phy/phy.c#L95

Thanks for the references.

> So in theory we could report:
>
> Link detected: yes (downshifted)
>
> Assuming your proposed API support a reason why it is up, not just a
> reason why it is down?

Michal Kubecek <mkubecek@suse.cz> writes:

> Perhaps we could use more general name than "link down reason", e.g.
> "extended state", and it could be reported even if the link is still up

All right, that makes sense to me. Let's make it extended state.

Thanks!
