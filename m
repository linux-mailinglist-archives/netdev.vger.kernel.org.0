Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54DC359FA6
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 15:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhDINQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 09:16:21 -0400
Received: from smtp25.cstnet.cn ([159.226.251.25]:38168 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231127AbhDINQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 09:16:16 -0400
Received: from localhost.localdomain (unknown [124.16.141.242])
        by APP-05 (Coremail) with SMTP id zQCowADX31ttU3BgsuQdAA--.25000S2;
        Fri, 09 Apr 2021 21:15:33 +0800 (CST)
From:   Jianmin Wang <jianmin@iscas.ac.cn>
To:     gregkh@linuxfoundation.org
Cc:     davem@davemloft.net, dzickus@redhat.com,
        herbert@gondor.apana.org.au, jianmin@iscas.ac.cn,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        omosnace@redhat.com, smueller@chronox.de, stable@vger.kernel.org,
        steffen.klassert@secunet.com
Subject: Re: Re: [PATCH] backports: crypto user - make NETLINK_CRYPTO work
Date:   Fri,  9 Apr 2021 13:14:57 +0000
Message-Id: <20210409131457.51384-1-jianmin@iscas.ac.cn>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <YG/11xcauoPY0sn+@kroah.com>
References: <YG/11xcauoPY0sn+@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowADX31ttU3BgsuQdAA--.25000S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XFWDAFW8AFyDXrW7CFyUJrb_yoWDJrgEgF
        yktr95C3sxuFZYkFn8Gr90vas0gFWFgry0q34jqrW5ZryDJasxZ3WrCr9ag3sxGw1rGrnI
        kF12qa92ka429jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbxkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
        0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
        IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
        AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_
        Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb
        0D73UUUUU==
X-Originating-IP: [124.16.141.242]
X-CM-SenderInfo: xmld0z1lq6x2xfdvhtffof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 08:36:07 +0200, Greg KH
> On Thu, Apr 08, 2021 at 07:11:48PM +0000, Jianmin Wang wrote:
> > while the new services need to invoke libkcapi in the container environment.
> > 
> > We have verified that the problem doesn't exist on newer kernel version. 
> > However, due to many services and the cluster running on many server machines 
> > whose host os are long-term linux distribution with linux 4.19 kernel, it will 
> > cost too much to migrate them to newer os with newer kernel version. This is 
> > why we need to fix the problem on linux 4.19.
>
> But this is not a regression, but rather a "resolve an issue that has
> never worked for new hardware", right?
> 
> And for that, moving to a new kernel seems like a wise thing to do to
> me because we do not like backporting new features.  Distro kernel are
> of course, free to do that if they wish.
> 
> thanks,
> 
> greg k-h

I understand. Thank you for your review and response.
--
Email: Jianmin Wang <jianmin@iscas.ac.cn>

