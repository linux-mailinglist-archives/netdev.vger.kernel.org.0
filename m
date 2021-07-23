Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065793D3C2D
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbhGWO1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 10:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbhGWO1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 10:27:43 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2EAC061575;
        Fri, 23 Jul 2021 08:08:13 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id r17so2636964lfe.2;
        Fri, 23 Jul 2021 08:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ry9ClILUnukJVzAZ0gclK3iIRVnY0FQvfvVPEP1QkQs=;
        b=o4+ii2+yfQsTVRmy1j87kv3S6zaCmIjO9/qtDL5SXUEbqK14Rwim3jE7z+7nnR+Gds
         swLsVQpQTGCf7I0cDZ1fQoxp/iMRqemj6aPVbZ3zU16cvk7imJ1i2cYwUCbjTV5juv5O
         raX8a9d0ik7VvKyYtjMkAk7+J3BQG0LvNbEGbhrInqjC5EQbXWZ8eFbgKWKzjPheO2Mu
         bI8qTrL8FsVsAPoGMu4HOjiAJlMgsJ7U71kmg57F9w068rv1u8g24TTiWQxE0/Yaw7tz
         YNg/+NaYC8qLrXskcsX/4wgq3r/sJFn7jw9jlriJkjW0CUEJuZ1NQjvbH6qkYs5oZE48
         hKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ry9ClILUnukJVzAZ0gclK3iIRVnY0FQvfvVPEP1QkQs=;
        b=Jvbx069lBjlIqoLGD073dX9WZw4e9jzc1sONCbYzshcQjb6T8LwPp/scFlI/V4ndrR
         P6bpMShwcMlrVf8phUqw9XaBPBpVXI7xzlPtIheraQMbIpnKLyn+FmflqivLh1Sexq95
         QINWcqXxdLLd3xzNIBDLNyxcS+qiioAgOcNHpXi4+At3K8WJ1UpveKBgP7nMLoRWjIJM
         h/6u1Yoqi3s1st5loXa3S+j2R3IgitRm7nOG7W3xjkO3eZ8PzQpLXjkdIl3z+Rya56Dg
         asbjMD761T0mUfAqmeaF2ztpl8qey/52NuFOWN29r5+0r8ItPOpl62Xmcwh3s6XCOt2k
         yQDw==
X-Gm-Message-State: AOAM532ELHOTo1z3Vl3XXy2scLvRh7FPhAKkBh9XEeVIO8UXxCvDeUwR
        8XYnsj7WqItHN95zlHhFPkg=
X-Google-Smtp-Source: ABdhPJwsq45CeZ6RZ0YPzmhXnIpHPC/JFlRhdEshw1unMyw6hbFvkuzio/CVkJwyEs3OXuvzzHEOfw==
X-Received: by 2002:a05:6512:139a:: with SMTP id p26mr3251734lfa.376.1627052891059;
        Fri, 23 Jul 2021 08:08:11 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id f10sm2256789lfu.121.2021.07.23.08.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 08:08:10 -0700 (PDT)
Date:   Fri, 23 Jul 2021 18:08:05 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Manivannan Sadhasivam <mani@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        bjorn.andersson@sonymobile.com, courtney.cavin@sonymobile.com,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+35a511c72ea7356cdcf3@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: qrtr: fix memory leak in qrtr_local_enqueue
Message-ID: <20210723180805.0f961fbc@gmail.com>
In-Reply-To: <20210723122753.GA3739@thinkpad>
References: <20210722161625.6956-1-paskripkin@gmail.com>
        <20210723122753.GA3739@thinkpad>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Jul 2021 17:57:53 +0530
Manivannan Sadhasivam <mani@kernel.org> wrote:

> On Thu, Jul 22, 2021 at 07:16:25PM +0300, Pavel Skripkin wrote:
> > Syzbot reported memory leak in qrtr. The problem was in unputted
> > struct sock. qrtr_local_enqueue() function calls qrtr_port_lookup()
> > which takes sock reference if port was found. Then there is the
> > following check:
> > 
> > if (!ipc || &ipc->sk == skb->sk) {
> > 	...
> > 	return -ENODEV;
> > }
> > 
> > Since we should drop the reference before returning from this
> > function and ipc can be non-NULL inside this if, we should add
> > qrtr_port_put() inside this if.
> > 
> > Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
> > Reported-and-tested-by:
> > syzbot+35a511c72ea7356cdcf3@syzkaller.appspotmail.com
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> 
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> 
> It'd be good if this patch can be extended to fix one more corner
> case here:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/qrtr/qrtr.c#n522
> 
> Thanks,
> Mani

Hi, Manivannan!

I will fix leak there too in v2, thank you! 



With regards,
Pavel Skripkin

> 
> > ---
> >  net/qrtr/qrtr.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> > index e6f4a6202f82..d5ce428d0b25 100644
> > --- a/net/qrtr/qrtr.c
> > +++ b/net/qrtr/qrtr.c
> > @@ -839,6 +839,8 @@ static int qrtr_local_enqueue(struct qrtr_node
> > *node, struct sk_buff *skb, 
> >  	ipc = qrtr_port_lookup(to->sq_port);
> >  	if (!ipc || &ipc->sk == skb->sk) { /* do not send to self
> > */
> > +		if (ipc)
> > +			qrtr_port_put(ipc);
> >  		kfree_skb(skb);
> >  		return -ENODEV;
> >  	}
> > -- 
> > 2.32.0
> > 

