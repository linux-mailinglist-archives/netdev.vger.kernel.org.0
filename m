Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E5B358D4F
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 21:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhDHTN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 15:13:29 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:37334 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232804AbhDHTN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 15:13:28 -0400
Received: from localhost.localdomain (unknown [124.16.141.242])
        by APP-01 (Coremail) with SMTP id qwCowABnf7egVW9gQsQWAA--.23405S2;
        Fri, 09 Apr 2021 03:12:41 +0800 (CST)
From:   Jianmin Wang <jianmin@iscas.ac.cn>
To:     gregkh@linuxfoundation.org
Cc:     davem@davemloft.net, dzickus@redhat.com,
        herbert@gondor.apana.org.au, jianmin@iscas.ac.cn,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        omosnace@redhat.com, smueller@chronox.de, stable@vger.kernel.org,
        steffen.klassert@secunet.com
Subject: Re: Re: [PATCH] backports: crypto user - make NETLINK_CRYPTO work 
Date:   Thu,  8 Apr 2021 19:11:48 +0000
Message-Id: <20210408191148.51259-1-jianmin@iscas.ac.cn>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <YGs3Voq0codXCHbA@kroah.com>
References: <YGs3Voq0codXCHbA@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: qwCowABnf7egVW9gQsQWAA--.23405S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXFyDCrWxZr1kCF4DXFykAFb_yoW5AF4xpF
        yfKr4ayF45J3yxA3yxZr1Fq3sYg3yftr15G397W3y8ZF4UtryFvrZFvw15uryUGrs5WayY
        yFWUKw1fWw4DArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j6r
        4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_WwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
        1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
        IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF
        0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
        VjvjDU0xZFpf9x0JUfnYwUUUUU=
X-Originating-IP: [124.16.141.242]
X-CM-SenderInfo: xmld0z1lq6x2xfdvhtffof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 16:14 UTC, Greg KH wrote:
> On Mon, Apr 05, 2021 at 01:55:15PM +0000, Jianmin Wang wrote:
> > There is same problem found in linux 4.19.y as upstream commit. The 
> > changes of crypto_user_* and cryptouser.h files from upstream patch are merged into 
> > crypto/crypto_user.c for backporting.
> > 
> > Upstream commit:
> >     commit 91b05a7e7d8033a90a64f5fc0e3808db423e420a
> >     Author: Ondrej Mosnacek <omosnace@redhat.com>
> >     Date:   Tue,  9 Jul 2019 13:11:24 +0200
> > 
> >     Currently, NETLINK_CRYPTO works only in the init network namespace. It
> >     doesn't make much sense to cut it out of the other network namespaces,
> >     so do the minor plumbing work necessary to make it work in any network
> >     namespace. Code inspired by net/core/sock_diag.c.
> > 
> >     Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> >     Signed-off-by: default avatarHerbert Xu <herbert@gondor.apana.org.au>
> > 
> > Signed-off-by: Jianmin Wang <jianmin@iscas.ac.cn>
> > ---
> >  crypto/crypto_user.c        | 37 +++++++++++++++++++++++++------------
> >  include/net/net_namespace.h |  3 +++
> >  2 files changed, 28 insertions(+), 12 deletions(-)
> 
> How does this change fit with the stable kernel rules?  It looks to be a
> new feature, if you need this, why not just use a newer kernel version?
> What is preventing you from doing that?
> 

This problem was found when we deployed new services on our container cluster, 
while the new services need to invoke libkcapi in the container environment.

We have verified that the problem doesn't exist on newer kernel version. 
However, due to many services and the cluster running on many server machines 
whose host os are long-term linux distribution with linux 4.19 kernel, it will 
cost too much to migrate them to newer os with newer kernel version. This is 
why we need to fix the problem on linux 4.19.

Only when we run docker with param --net=host, the libkcapi can be invoked 
properly. Otherwise, almost all test cases in smuellerDD/libkcapi [1] will 
failed with same error as below:

    libkcapi - Error: Netlink error: sendmsg failed
    libkcapi - Error: Netlink error: sendmsg failed
    libkcapi - Error: NETLINK_CRYPTO: cannot obtain cipher information for 
      hmac(sha1) (is required crypto_user.c patch missing? see documentation)

The cause is same as statement in upstream commit 91b05a7e, which is that 
NETLINK_CRYPTO works only in the init network namespace.

In my opinion, there are still many linux distribution running with linux 4.19 
or similar version, such as Debian 10 with linux 4.19, CentOS 8 with linux 4.18
and also their derivatives. If other people want to use libkcapi in container 
environment, they will also be bothered by this problem. [2]

So I think this patch meet two rules in stable kernel rules: It must fix a real
bug that bothers people and the upstream commit 91b05a7e exists in Linus's tree
from linux 5.4.

Thanks for your review and reply.

--
Email: Jianmin Wang <jianmin@iscas.ac.cn>

