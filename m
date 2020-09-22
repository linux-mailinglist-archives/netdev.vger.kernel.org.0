Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19AA5273B82
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbgIVHN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:13:26 -0400
Received: from mail-mw2nam10on2077.outbound.protection.outlook.com ([40.107.94.77]:9791
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728526AbgIVHNZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 03:13:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nSshHqcdTVj5EXjdgaq2EqCH6TiVqi5h7QNqsYRDgUN5OiFC55PMAfwZkrHZO6KPExcHsvYHNXQN6QWNp93+mNbWV0TbDfhbpAaU33NwMdjQIfu/G8ofygfELY3vMmj4UZGxXKuSlLPENu16KWfrLL9yhhZ6s4ZwuEasNVLdnicvu3kUqD63iXihByQZ2cmLeknLjvm5UCBPPvVhhgpAqvreQqrvEpO07jOHxnQLqqMbVS4EsVSAysqjdCKz4pJOK117xZ9QdNYcnNcv40/95dOeG/M+aBrw/qXCOIC/AsmfvD7JI6F38oSyV+DqiwtubGBBdH4mDdolPwlKOYzq1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhZ5Bby6cSbL9Ie1syzqNxQf/n8VGdxooLRWVbfFNlk=;
 b=DiwKOnFl0W38WSt2oFNhXpq5bIuq0Ekd4Ul/9wDcJy9Msgu5zgquIwTpheMQ8aNxouiIU6NZbK+X8Ij9xAxGXZKOa8r0cAHIKJPRhULak3evP/b+NcfkYZ4ebA+UVenVlFt4XXx+wguXgzD/L/nW2RBFNdaufff8voqdKolShdTCGsjM0fVQBsYKPvrBWhMATzP9t82gX2rNYxsL2RXlnpMSsOsrHcO42i1GGEPas9Shbw7l7yN0ftZkRUYezCWPKZySaLlDnxj5Yhp0s+SCKIS0rAQn2ssGwokLd8eFikcS7WehCH70YrWF5uTpt9sL8qcdttv85Z+3j6etf5It8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhZ5Bby6cSbL9Ie1syzqNxQf/n8VGdxooLRWVbfFNlk=;
 b=LMcurrL9mwAlD/pKvxWGXujzUw5kupZR5QdvMrM7mbHki50IDOGMqAbB1RRjXlYp63d8ejIauuxdqjPh3xYZcCjB2QB90ro37VUsD47d6GaJugQtk8HxVXpfRJnlXGNxKi8twGVEMFOETfKZZp+pVURwbhIpdOWIPS547m6DlKk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=windriver.com;
Received: from SN6PR11MB3360.namprd11.prod.outlook.com (2603:10b6:805:c8::30)
 by SN6PR11MB2557.namprd11.prod.outlook.com (2603:10b6:805:56::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Tue, 22 Sep
 2020 07:13:22 +0000
Received: from SN6PR11MB3360.namprd11.prod.outlook.com
 ([fe80::4dbe:2ab5:9b68:a966]) by SN6PR11MB3360.namprd11.prod.outlook.com
 ([fe80::4dbe:2ab5:9b68:a966%7]) with mapi id 15.20.3412.020; Tue, 22 Sep 2020
 07:13:22 +0000
Subject: Re: [PATCH] SUNRPC: Fix svc_flush_dcache()
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     linux-nfs@vger.kernel.org,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <160063136387.1537.11599713172507546412.stgit@klimt.1015granger.net>
From:   He Zhe <zhe.he@windriver.com>
Message-ID: <07c27f89-187b-69a3-fd40-f9beef29da40@windriver.com>
Date:   Tue, 22 Sep 2020 15:13:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <160063136387.1537.11599713172507546412.stgit@klimt.1015granger.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HKAPR03CA0006.apcprd03.prod.outlook.com
 (2603:1096:203:c8::11) To SN6PR11MB3360.namprd11.prod.outlook.com
 (2603:10b6:805:c8::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.175] (60.247.85.82) by HKAPR03CA0006.apcprd03.prod.outlook.com (2603:1096:203:c8::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.4 via Frontend Transport; Tue, 22 Sep 2020 07:13:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 262792d6-a33e-43d2-4e43-08d85ec6fd7b
X-MS-TrafficTypeDiagnostic: SN6PR11MB2557:
X-Microsoft-Antispam-PRVS: <SN6PR11MB2557BBA051337FB97448496B8F3B0@SN6PR11MB2557.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xdc85fTxM2Km4CVGkU7T7vuKQR5mDi0/j0wMptNA4M9cFYDmISkrV5Nsf+7CP3O1Ez08TiteLEAFwIhPUyvbXRGIFxZqfqRoSV6Sxtan02u1QMdh/L3NcLL+mq18+nWWOyM75r7eAWJbatXsLBnW/sSPBuw3jZ72cXub+fKo/ERbALkVyvuui142fB+WdqvwV9Zdmml26Kv7Q9bQMCFcUHmgq00jgrb6wx5A+sEbzbacCJ+P9f8VDC8qHqfdIgth2PatIEyVfiBZIF86TEpZXerO+vWgXxmzy2hQuLd3X1Iam5WWS1ksUrZY8oVOo1G3y1W1KTidTqDf+N3Y5JrWXmXMWgong2n9vghmHsGUaEq8Liqd01Ml1xm5GpSXT+mpJz5urYsVLG3FjtZRHN7HQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3360.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(136003)(39850400004)(396003)(6486002)(66476007)(66556008)(8676002)(5660300002)(66946007)(52116002)(83380400001)(31686004)(2906002)(6666004)(2616005)(478600001)(956004)(316002)(4326008)(6916009)(53546011)(186003)(6706004)(31696002)(16526019)(8936002)(36756003)(54906003)(26005)(86362001)(16576012)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: baw92ZpjURATg95nVpmsEXuLXuGosIjr+4msEdeipUJxXFkHhP2BeK5EDqdIdv9nj5eQsecHtcEmBPPY5eBQN/4wQv+CVf9UYXhVLx7ynxmX0cpLhqPTabYFMoJPG3BPGI48Fe1gPqBwR2p0JWeQDoPbEVjeoHy7N/fXZLbtTf0wHWzUQ722+d6Wr4mUCunyvLjLRH6PKkSETEpm6SdigoyH25IcDCpkBUjxIxVPOXsz4iGLM1HdYzihq7I0ZRe+ZKRuyObKejx8Bz0yNA2wDtlM5HNCpofJPUyyRlN+rsJCofGM7Y6iJQRJOx0taY53W16VVFhZGWDNNe5ZUme6J8VdO3CYpwHY3ApR1TKq1ZdtKfDYIsKtCy3ObmcGPRwYP7Q0kCYdYd7o8ljVdXiEaN8sXwupBIouNv03mQSCoHBeqkPJq02+mDLNE6z/UzIprWG+CEQC3qJptPAf87y39gQe13hLGUkDfoo5/te7iG/eBvYoIg2lPo+RJLOEcSYd560HSi5bD0zi+PKKpampl0s7lBK+FT8+B5+iJtkcUJ56O0LYH3vT/Gi73rfimPeAQjcPVtQBllIBllYGaWLOoUF4Wsx+zT6kDFbZEXpd4bzcZc/e/1izuqycX5Jdeu+5JiaEqHq1vZ/Z2lfEzu9f9w==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 262792d6-a33e-43d2-4e43-08d85ec6fd7b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3360.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 07:13:22.5705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bl11E+2hSa2UC/0O9G+l2ea2T0TFd7119jXqZTxW4gVlRRmIpHESDqE5g2ttxi44wy3hlFo8l0MLcka6Rflpbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2557
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/21/20 3:51 AM, Chuck Lever wrote:
> On platforms that implement flush_dcache_page(), a large NFS WRITE
> triggers the WARN_ONCE in bvec_iter_advance():
>
> Sep 20 14:01:05 klimt.1015granger.net kernel: Attempted to advance past end of bvec iter
> Sep 20 14:01:05 klimt.1015granger.net kernel: WARNING: CPU: 0 PID: 1032 at include/linux/bvec.h:101 bvec_iter_advance.isra.0+0xa7/0x158 [sunrpc]
>
> Sep 20 14:01:05 klimt.1015granger.net kernel: Call Trace:
> Sep 20 14:01:05 klimt.1015granger.net kernel:  svc_tcp_recvfrom+0x60c/0x12c7 [sunrpc]
> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? bvec_iter_advance.isra.0+0x158/0x158 [sunrpc]
> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? del_timer_sync+0x4b/0x55
> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? test_bit+0x1d/0x27 [sunrpc]
> Sep 20 14:01:05 klimt.1015granger.net kernel:  svc_recv+0x1193/0x15e4 [sunrpc]
> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? try_to_freeze.isra.0+0x6f/0x6f [sunrpc]
> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? refcount_sub_and_test.constprop.0+0x13/0x40 [sunrpc]
> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? svc_xprt_put+0x1e/0x29f [sunrpc]
> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? svc_send+0x39f/0x3c1 [sunrpc]
> Sep 20 14:01:05 klimt.1015granger.net kernel:  nfsd+0x282/0x345 [nfsd]
> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? __kthread_parkme+0x74/0xba
> Sep 20 14:01:05 klimt.1015granger.net kernel:  kthread+0x2ad/0x2bc
> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? nfsd_destroy+0x124/0x124 [nfsd]
> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? test_bit+0x1d/0x27
> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? kthread_mod_delayed_work+0x115/0x115
> Sep 20 14:01:05 klimt.1015granger.net kernel:  ret_from_fork+0x22/0x30
>
> Reported-by: He Zhe <zhe.he@windriver.com>
> Fixes: ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()")
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  net/sunrpc/svcsock.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Hi Zhe-
>
> If you confirm this fixes your issue and there are no other
> objections or regressions, I can submit this for v5.9-rc.

I don't quite get why we add "seek" to "size". It seems this action does not
reflect the actual scenario and forcedly neutralizes the WARN_ONCE check in
bvec_iter_advance, so that it may "advance past end of bvec iter" and thus
introduces overflow.

Why don't we avoid this problem at the very begginning like my v1? That is, call
svc_flush_bvec only when we have received more than we want to seek.

        len = sock_recvmsg(svsk->sk_sock, &msg, MSG_DONTWAIT);
-       if (len > 0)
+       if (len > 0 && (size_t)len > (seek & PAGE_MASK))
                svc_flush_bvec(bvec, len, seek);


Regards,
Zhe

>
>
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index d5805fa1d066..c2752e2b9ce3 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -228,7 +228,7 @@ static int svc_one_sock_name(struct svc_sock *svsk, char *buf, int remaining)
>  static void svc_flush_bvec(const struct bio_vec *bvec, size_t size, size_t seek)
>  {
>  	struct bvec_iter bi = {
> -		.bi_size	= size,
> +		.bi_size	= size + seek,
>  	};
>  	struct bio_vec bv;
>  
>
>
>

