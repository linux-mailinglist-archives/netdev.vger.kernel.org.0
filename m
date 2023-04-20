Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28F06E9814
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 17:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjDTPKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 11:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbjDTPKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 11:10:36 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2107.outbound.protection.outlook.com [40.107.223.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C57861A1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:10:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGfmQzrH54uQzR3MxNqWDh2aPBbjlUkjqgUAK130yVlZ4JP4BtI7omKccpAphDRGGc9YToROO+oXXYH5F5+FLnMo1Yv2HdiOFnMP/RvqCcugyuXivW5ArKXBacvSBOqEoCcb2ASA5LwgjT7bJn0pho7mULiIP+TV3G+wOD0uUW50sml8pFfjgN5CAf4wC69JNrN7T2Uhg7n8NqzGZKEh8/iACIxyymBDjzzCAoxNNlbSEJtMxE4UspNPRrkqbth3gxoq0aep0PQdfZJ/y34q9fcaIf0s5erTQrOUgiGyAMDbE0E/8oWgTwcFtzR4yf+qzGu+ShUf0DFi59vdxg6Xpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e85caA6jd7K9Pl1AYKxjlQhBpzELTu8VzHOiZ9KrgzA=;
 b=P7RUlMW9ooZUkX1vw4igPirA5W3FX2gyhj3EgOhr52PFZ/fEGDNBK5xLKemdwhavD5+UyVAxJvqpFtmsVYq7FrEsvSj5pJGwkloe4pt8+ZYuUpihfUdgETz0E0B5E+D56BBNK1CvLjV9R2nwWWbIQECtgyUoExwc2Z6LG1y6YDqm/PvpFllh0Iv49y5y+kO+cy09rcdPLzG5NfLSo8ppdmo9FKSPwYoxllfP0rr1KyDJ35FraJWOSj1SdEOXpj6EPe/+if3388wqUn+HbUBhBkJ/nadFihcRHInBuEm6Y3Jedklu3BLOKK7FpVGGsU1QlZ+gxz8aDLVI1Wgeu6ppHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e85caA6jd7K9Pl1AYKxjlQhBpzELTu8VzHOiZ9KrgzA=;
 b=ZBzhF2uvKoF2+qJjo6joJsDL4IvTr0Rfitqj4klE27rR8GyTB+9YH2KXh+T90af0rBIt+TXz4r9CKNfMj40H5dgk2zwcOwJefCOIpmvZqZyvxV4D2lAttIGgdzZh9BW3IVoeRxcaOD9cE9FcqQ8EfEK/3joO4gHdibBjg+1m8tE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5533.namprd13.prod.outlook.com (2603:10b6:303:190::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 15:10:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 15:10:23 +0000
Date:   Thu, 20 Apr 2023 17:10:16 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH xfrm 1/2] xfrm: release all offloaded policy memory
Message-ID: <ZEFV2GgKHfRShyXz@corigine.com>
References: <cover.1681906552.git.leon@kernel.org>
 <c84041b660cf6b0f0886488e740cd43b0f21c341.1681906552.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c84041b660cf6b0f0886488e740cd43b0f21c341.1681906552.git.leon@kernel.org>
X-ClientProxiedBy: AM0PR10CA0017.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5533:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e2a099d-afab-4bbd-b10f-08db41b15d42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LmmirVmwUZjoXoi4xq+iHKEiYlrNKK1e+S5BstxHCAMV5YJ4ZDNtp8JnF3uzaKS3g/cntH+djU+u8SA4c6k8sWtFk8Heajmcr08tVeEsRnRuYY0VoRiquL+SrZci43v/yZe9nrVWPSBwc5YOGkbFt9Mb5/2F9pjQ521ENiU69bxEb7IH5h3CeZFIVJPrsbHHgE4j+w/pkC2p91JeFcgK34BGju4N8DIlLzc5q4bEYtgK1A4sCuE2m5j8+japItW/uPLImZZkQaY7QgIWpjLO3RGRn4KJnM6vfHM+jlXkT9+6/Oa1Zct2x506K6l+wJzyWRsZ/dzcesrpnSZN3wEOf8jsiLsSnRu6hn9d4Qs8h7QiyFzzF0E+xdhcRfARfLiINwRnwb9B2q6NUCf3+xUSiVX2oW21m8mDvda6zdOjnBquGT97UaXzdByzL9oTK0i8LfrAbbwjq1CUxRo56N3hOUn/HpZKVzbVS7w5wybmbDOBcLhqar4zBh2XwwBt+0RjVZwYSHSn8agCA7onEgto2yDmUlvWFBX0+ckeKtidQOXxP/AyPpP8YBZLCBfAmp3j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(396003)(346002)(136003)(376002)(451199021)(2616005)(66556008)(4326008)(6916009)(66476007)(66946007)(83380400001)(54906003)(6486002)(478600001)(38100700002)(8676002)(8936002)(316002)(6666004)(41300700001)(7416002)(44832011)(5660300002)(2906002)(186003)(6506007)(6512007)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1FQbC6x0SRbl9AunvanI0aC5YL19Wk3l6DHO4K+lhSDvAEKNxQ7qSrIvLL0k?=
 =?us-ascii?Q?BlHeVYhqegyyk1z5C6IDWw6UuQ10yt9YPHhu7yG2bgopEP4ftoTg+iP6X3IW?=
 =?us-ascii?Q?Rij2XHNmANq6KPY+r2t2i5Iw/0VDeyCWNNe+8BJPnYXCzepPjY4jIM14uvLE?=
 =?us-ascii?Q?z5wOGLlvngS+9RU0YIGPvNiDldKwzkFcTfMXd5ZCcx+QJOoMonQ/8sOESoYc?=
 =?us-ascii?Q?NNJWXDJemsdt0vi0np4cIpNfyMIFB2+Rqu75578fLTvM5TrTvWhcCQ1CFPT/?=
 =?us-ascii?Q?OGGaVPVmJWsMjKNmAUgLTlCIELW4/+gdNaM2Qr5GENYznElbeJ2F2kebwLyO?=
 =?us-ascii?Q?Ik5ptFlgKtyM+509nRV1XNKu+IzHYqWKjCnuwR4+LCHqO+BgFGYJ6mVUKKHb?=
 =?us-ascii?Q?4mi1W5d1t824K9HxdQtiZMWDCbjBJ2uI1A6QfQAV4ucCqTqsE3X/PSfJQfe4?=
 =?us-ascii?Q?wv8Zl07K+Z9mNkGF40rFY3qmYWLLM0gwTl3KPLJLp+w78wV8FTe7bwAK8nTD?=
 =?us-ascii?Q?5jrhJo17QieTQplLfA6sAK5BKCVwl14jAmNqkKn/1GBeEaXoRVWOLWs7ffhL?=
 =?us-ascii?Q?30BSBQnLRKlUxIQmUUM4dIuPfxHf+wz5bqUWziw5plpAX+RhfaUQZlviKsN1?=
 =?us-ascii?Q?qoN7xB0JBtw0FgykMfPL4SU8DEqRO1IiWapzHDzkBgnXp3F4LLVTwwu/dM74?=
 =?us-ascii?Q?pk0iOmdaAHxrgyHS+JC/xm7r8UziDR3WOi5MxGuMft06IMNh3B1r7qhjrYIP?=
 =?us-ascii?Q?WdyyRKIa9FjXFf4XLOpqj6HAshRaYspk120zsrJDKpRiimyG6QhoUg/53+xk?=
 =?us-ascii?Q?gUcSnFiBROIGxL9ocpLYJggjH11EIP6gQr31tR5LQCpZ8U6h6XLc48AJ+5Ks?=
 =?us-ascii?Q?innYLoI5Vq9FIaiKqaHy1gFqMFNzHzQZjDyQjA1oNAqNEOQ0fcf3x4adoOC8?=
 =?us-ascii?Q?gUa6bjPUAVeYdRTOcUktchdA5OEPelFouNRvuNJtXaGd/Ufzp+V5Vn8/4QRI?=
 =?us-ascii?Q?qCi+vYKrmAwjUbb2bygZgwODltWaUOrsR7GGg/m46qxYTKoZbE2pagpxT7eL?=
 =?us-ascii?Q?zTpnc5KBL8aGWqbmtO+XacRyz2o3W+bQv3U5OSThQiKqIfKwQUuCVKpFHftN?=
 =?us-ascii?Q?nnRKRtdamHGCkzK7JUbNn1SBZwv+xLEBwqtrQWptdsbxnP28Jn28w8j4vrBv?=
 =?us-ascii?Q?aP0TUajZoTn3zLMICqxqF61jXHg27QKqsDtRa6trwVfUJT0IKNSEJmnN1tU6?=
 =?us-ascii?Q?VMxfyPET1ziZ3kkYMEDdniVs6JK12YqnomIjP7+ttHWORtVwpeGK8PsFGfji?=
 =?us-ascii?Q?LRlUrne0bYMnrK5++2BkYE/TGMpkjMQu9gxTmX00F8nyKKE18zclijKNJm8R?=
 =?us-ascii?Q?Tw7ZxzrfcREY5bELLwiIBsR4/7c4O7+VdM+ksJRm3TfnqVAbBD8EC5s/AAdq?=
 =?us-ascii?Q?YAh0SXaA7ClqE5OJ4Ecr0bB2HeD8pB/yc0Q5AWGgHZ8cWpaiRCs3pQnvwnte?=
 =?us-ascii?Q?shx+CVl7qT+Xdk9l49xlPoOD6zRhNDnEYaPIEMYEgn3Jbsb9xyj1usCpN1n9?=
 =?us-ascii?Q?qMvew/B8sTRoRV8F1xa2ypsAwB9yPy8cFfDPtEySipcwjnI1RXD6irgjrE4A?=
 =?us-ascii?Q?23oaV6mAameTkbYcUpFIT4FJeCw2R0TqOfmIsfiS7AlJDLzrlq4bXLhIHGsA?=
 =?us-ascii?Q?jA3r2w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e2a099d-afab-4bbd-b10f-08db41b15d42
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 15:10:23.6603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: urHYZ/fIFOIU26wjJSSiaaqBJhyHoZcBbvOs/iqyTRQQOd7G596p4r6MXP4YXg9jdqt3byd5ldgtrvgnOp0lnzrL0eaGmxx3k7xgXT9TbbQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5533
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 03:19:07PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Failure to add offloaded policy will cause to the following
> error once user will try to reload driver.
> 
> Unregister_netdevice: waiting for eth3 to become free. Usage count = 2
> 
> This was caused by xfrm_dev_policy_add() which increments reference
> to net_device. That reference was supposed to be decremented
> in xfrm_dev_policy_free(). However the latter wasn't called.
> 
>  unregister_netdevice: waiting for eth3 to become free. Usage count = 2
>  leaked reference.
>   xfrm_dev_policy_add+0xff/0x3d0
>   xfrm_policy_construct+0x352/0x420
>   xfrm_add_policy+0x179/0x320
>   xfrm_user_rcv_msg+0x1d2/0x3d0
>   netlink_rcv_skb+0xe0/0x210
>   xfrm_netlink_rcv+0x45/0x50
>   netlink_unicast+0x346/0x490
>   netlink_sendmsg+0x3b0/0x6c0
>   sock_sendmsg+0x73/0xc0
>   sock_write_iter+0x13b/0x1f0
>   vfs_write+0x528/0x5d0
>   ksys_write+0x120/0x150
>   do_syscall_64+0x3d/0x90
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

