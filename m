Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D909F5E9BD4
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbiIZIUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233756AbiIZITu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:19:50 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2103.outbound.protection.outlook.com [40.107.92.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B1FDF0C
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 01:19:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nn2oqc6BLb7XJ3IHGoIQ89/T8Jj6X778PEvXYl58wR2OVyP4koZLB4zhdTkir16Rp5PQNHWPcT9SiOzeACN4EWPiqioYudQdUZEgjTfPuB9jhIJLctrSClTznpdT6XmoDhVd0EjKK/llR4BV29CXPf+g3Nzq+bzZp9BxGwrYyB098jITP5tyus1Wu+6QeeJD8g5p9CfxiP44CbHwOu93HpN+/rJOIZq9GyvCG5JrySzUPPOfnReORyY5lEO5XkPpq8VSozLcIgC+m38b4QB73erqu9s/CVXa/DKxwE10kzk+f0+mOAHPJPBUnUFhLzNu69u+VI1IfzIixd+gdaEpwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8F1fb9QNfxQcbMN6VN0hnUuJOlzxkkm3CmHWC1gIhM8=;
 b=hM3JEAx74zbno3Y18rPgMv0FFVRpJyiW0PzAxDPvWOVK+QTptmsTtplmRsiWc0KSXM6PW75BoyHtCEixCaoW0qe7Tk3yhF543CneTweNU2QPzNfgSwPrqmxeFTL9vdECZCMfRaPNuKEIL+93wV+4JruutMpYomT8m1rA28Pq4IQGM727ftv1XreapwNFgyqNYo96UYFzkY6PNfb6g5EbjAQcANCMmmuOYIl3w/iDw8OCRrD4ldzYx7CtKQYEltA3HCSzK6kL8n7+UxVv/jErPniRBOY64G7bt7SPy5QLX8EBDFUE2zL7Fo5o7SHi4pGbAYlNXV+nKImuRbac8I174A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8F1fb9QNfxQcbMN6VN0hnUuJOlzxkkm3CmHWC1gIhM8=;
 b=D6e27ZKdf1C0uPGbqoFCn3fB85jMGYz7WSrwLD9+sO0ksu/QqoGwewPWDRpoAxkts7UtpeDiMq6JT6tCH7wznyUuaBxRLb6uQ0SpPLDy5boDgi7cOejV0qQ4Lun7YJRxwLGaNOO4DjGlS5aMgRkcskVRivXp9iWA56SrmHKyKoA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4963.namprd13.prod.outlook.com (2603:10b6:a03:361::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.14; Mon, 26 Sep
 2022 08:19:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Mon, 26 Sep 2022
 08:19:46 +0000
Date:   Mon, 26 Sep 2022 10:19:40 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, skhan@linuxfoundation.org
Subject: Re: [PATCH net-next 1/3] net: use netdev_unregistering instead of
 open code
Message-ID: <YzFgnIUFy49QX2b6@corigine.com>
References: <20220923160937.1912-1-claudiajkang@gmail.com>
 <YzFYYXcZaoPXcLz/@corigine.com>
 <CAK+SQuRj=caHiyrtVySVoxRrhNttfg_cSbNFjG2PL7Fc0_ObGg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK+SQuRj=caHiyrtVySVoxRrhNttfg_cSbNFjG2PL7Fc0_ObGg@mail.gmail.com>
X-ClientProxiedBy: AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: fd187cc5-7936-4ee5-b3e5-08da9f97df1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AX1GTHa4xNaRsEZenfv2b1TJxPTemuwENCHsP3Buu5DU65YTrqsZCpbv11bUpgNiiG9o6g8Etsa1uEVfegixWpYGyZB0sMc3VM0M2rEeTdB/1PBA22meqBWSetokmc2Khe4646McTuVpvaPCUiHUs+vqXRmhFC3j+FRhkj9+d23f5ufzYzvcxHCT2Wc2RNfPbORg+lNYftcvYeCKlD7vWwNly1iFZd9rx6Jw6y1N31ZGEZueaLhz4gW7sA/GprhjQnfGmEwa0hF4qY6fQCuIe4LBiYQQ7i0QW4E8p0kZa4AuzkHMr4iDly/TrUWHkPKan3dp2yTTy12UYdrsXKMcsmA8g42NiglQcbKRcgJPdfvz4Oc7aw4yz4Y3VYDpqAPTsxhFSReKoaiDMkWQSpBzKTaAfwNyoZKQfrAlB0BVkp3OBY+8bG3JDvCVwXKzxwrPOlstyevv/p9ACdiQUHz4yKKZ5EvfCz4C+UjxmbikZFE+mxNWgWgCiw+J6M71kwbdY+TM5ZTWaW0Jo/6wVwKw0DBZxhpSWJ2BSG+mUVEultu7Ak/Rc3ipy49YNkU+UhL6nLn+5xd400zrnIdpPR2zwhVXvsXkR2CiF8bOMrUPmdoYJpo3mUHDGFyfrwPfPZdDKITaCQq3obMOEV/eo/dh6XLG1yiUFSyIyU+cpiNywBhJ6A6TyC+46NNQIwUN1L1SzDTXwdjEH3x8CUWTMyQXD/0TVQ6XkN5VCX8jHS6IP6cI16pRN6yqud2ER6kKHPwx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39840400004)(136003)(346002)(366004)(451199015)(4744005)(6512007)(44832011)(36756003)(52116002)(5660300002)(2616005)(8936002)(2906002)(66476007)(66556008)(66946007)(8676002)(4326008)(6506007)(6666004)(41300700001)(38100700002)(86362001)(186003)(6916009)(316002)(83380400001)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tHrR/vszQunWPW66HYvX3r7B5Qts3Mxu6MV6qaRanpdP504CCP6vAgkDqSaS?=
 =?us-ascii?Q?qNawq2UjJnoyNuwX9/hkyMdCjRpnwRm837f6CC3wcO1EW+DO6mkeOoI/TTo/?=
 =?us-ascii?Q?oltHRsadP10PvFU6VxAOk1sXuisdFxYMDUlWBB6s29TUyNs0PIqqkcnjSksc?=
 =?us-ascii?Q?eT+xMWZZfOdrKf8RdoG6dvdpP+cnrNdSF437P2ZafGnndA1sFlhu3lNEsam2?=
 =?us-ascii?Q?576qVQFvL/TPIohHXXiIuEzcJ4XjAjAFM/640a15cvKJqXLczuSEPoNWlXTb?=
 =?us-ascii?Q?V8MoZLMPKyq/BTvtPq6HzVJjdDx/tiIXlHaWo90VuCWcWLoefhnrCH8gwhLw?=
 =?us-ascii?Q?+jwThSwlh1U3btwCa0DGVxab3cJ73P0kbWAAAdx45legRsailf2Z0rSj7kmU?=
 =?us-ascii?Q?WyYUvouHL/mRzWdK2i6CCGuu3W1GwJ9B/yeJmmmGoik2ByWVN1I333z99bUj?=
 =?us-ascii?Q?zW5vajq7Qmh89NOCLMQsprXySQgiNlREoDBwDb6BSKJZ58Wlj1yUl+6BRm1h?=
 =?us-ascii?Q?EkCT72WKGoj6iwbTVMDTmQ9h/27qEYAOkrYM7esJufxHZDkawMVF9onEHxap?=
 =?us-ascii?Q?dwE1mOVivuCXMic8R7yOqW+jh3UrhYp95SeIEfdM1uGqdkqn6EmHCG7RxNVG?=
 =?us-ascii?Q?+r3oF4wwn2zMvQKXGhcAB8B9PcOw2FBTKLs8s9jsSNU9WjhpdPpFajZ3deio?=
 =?us-ascii?Q?aAu6f7nJgUcScbAfwfXsRf+i5rZDA7Q8oaUHtPxIdxprsxD7nyEXPyyi/37e?=
 =?us-ascii?Q?nv/v9ZMtsytF9UBm1IPyFEn74R2CQKA5VaznVvbhMd+zlF7NQMutj5lLY95k?=
 =?us-ascii?Q?DzT5vm+x+Dhm6pXPtgHrlm2WOtBLonB83aVv5BLIriiUg85ly8uqFMwX52Bh?=
 =?us-ascii?Q?tCNHnqhUZwojSh0xSt9jVEntQY2r7wXrJI402sgzMu3uNGKOMCSvM4pInOh8?=
 =?us-ascii?Q?6pJgT/8FksPwX7PLeAGm5pKaQ6HDEollpTuWxEi9Q0Ru2/tfyG5fwRiS7Zh3?=
 =?us-ascii?Q?JYetqlIY1wdAzusMSYocVF0Sdx4HTUC6aRK/nN9STJBR//8T6LRB5mliRYwo?=
 =?us-ascii?Q?l2B6dxlsHWQP52QOUeI/Lvx3FLS9dYXveF+LbZgdkAqIci4kLZp38RHL22Nw?=
 =?us-ascii?Q?1AT/sL1LM9ODk+IbkG7vwcoMz7qtA1qt7PueEC14JWI2Q7gZl4JKhajsVmOj?=
 =?us-ascii?Q?LaUT/Yx5HQViXj09tfGliGFGV0FGp9GxttJQfk6ZZtYvru2iu5mB/sxhD6w2?=
 =?us-ascii?Q?xCP9/gI6X6djAt4n+CC1ATmOdIWyrQ7bhjjb9lA3QxFjUVu9tAyBYRYbLnMk?=
 =?us-ascii?Q?I/XbSEsFsMP45lJCn51cEPIWceLseigu3zJNbXvFYqGFt0yCnviCZB3WbjcJ?=
 =?us-ascii?Q?LVAQ70IGSEJzl/vQN/CrrKiW+ASwdxMUw6M48vFJIivsblCjmhVuKeTj/8vF?=
 =?us-ascii?Q?P/oErW92B+c8juO7CMjPoxb0wDxJg/mvbBZXgLOlF7U1nIK9rh0pPDW1yoO9?=
 =?us-ascii?Q?0DzfQDy3PoNa9LN+WWFVFo3jG71eMyT7hWpnz1JNE4EYCEj9qHEn9+fPyOBQ?=
 =?us-ascii?Q?eraWrnM7Aagk6dy1Skt7WOEyoLDrVtHoCnHTaOxE1ubqTe9l7G7yqcDjuSWS?=
 =?us-ascii?Q?VksazArryb7EY3Z3JgdnK45pRBdfgCMilc9Dsnu7E430HWZ8vkq5B0Hr4GIo?=
 =?us-ascii?Q?Q+T8jg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd187cc5-7936-4ee5-b3e5-08da9f97df1a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 08:19:45.9543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OkmDAExBsBQBWTNPymUT2PmtIp3YlHy7PsIIYtmnkCepq+8byn75ZKsnDzrY8gb45aQ6ph0Th4IjSqfQHH5EsPAmoc6az6YOrCl9DV1+BdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4963
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 05:05:08PM +0900, Juhee Kang wrote:
> Hi Simon,

...

> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index d66c73c1c734..f3f9394f0b5a 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -2886,8 +2886,7 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
> > >         if (txq < 1 || txq > dev->num_tx_queues)
> > >                 return -EINVAL;
> > >
> > > -       if (dev->reg_state == NETREG_REGISTERED ||
> > > -           dev->reg_state == NETREG_UNREGISTERING) {
> > > +       if (dev->reg_state == NETREG_REGISTERED || netdev_unregistering(dev)) {
> > >                 ASSERT_RTNL();
> > >
> > >                 rc = netdev_queue_update_kobjects(dev, dev->real_num_tx_queues,
> >
> > Is there any value in adding a netdev_registered() helper?
> >
> 
> The open code which is reg_state == NETREG_REGISTERED used 37 times on
> some codes related to the network. I think that the
> netdev_registered() helper is valuable.

Thanks, FWIIW, that seems likely to me too.
