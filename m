Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE5C2C6E3E
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 02:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbgK1Bm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 20:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730112AbgK1BlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 20:41:09 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3785DC0613D1;
        Fri, 27 Nov 2020 17:41:09 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id y4so7462774edy.5;
        Fri, 27 Nov 2020 17:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qGD9xnb8v5qrR9LK2TyNHXn3ImQC3Ik9wtWDyCz2wbo=;
        b=mpOItXd5ChwZlHQFKAnJ/MdmVNOgemxhczQHSgaVDt82Qi35d5fsH3hnnMrDrMrLHF
         Ud6eS8cYtQKiZYk/WiDXwd7JLfbowV9lq5YCew0cwaHt2J7CLXxkxqXmK5U72dxwqQgK
         2NjScAj6C5DTtcyCgkuWWn54et5X6YQhrpssHvL4FNAd+Qh0fXcpsx/5pHzBpShJKbEL
         XSQR7T/OLmG1IV3LKuZrLTTvzB5pE/1pnRd9BV8fT9MsyUlYUE29RwLhmIyXLxQAmBAG
         Bpbc68sgPhmeS+UbnB6xxpphf4ZkrAobV0B+v6y/LWi+6SX6SoF70TxTre/arkcDCLns
         k26g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qGD9xnb8v5qrR9LK2TyNHXn3ImQC3Ik9wtWDyCz2wbo=;
        b=pCzTBgyrapOvg2YOGa4N/CnGrddZEE/E/lnzABvLCEU1d57TDHzrusjIj3jioEuPFz
         yS/WQnn0ZSiw1L1pVkYcdXdo53Rmwxy++CmtfxxmiRoC2k/rgk03LrNuI2tQxQRpa88N
         IgAYZu4s2t+RhDESvVf0eORk07E4Fjo9b4BYeenzd/VnfAZp8LBDmJ8pQMgZlVhd7Uuf
         nKa//THLCQheqfbtP49M8fLskxWt3DsMNVf64tiVdEZHYbR525bm+MIMF20ZiwYCxD/+
         ZTNbxe8lIUW112a0traJvxDnr+eIuuD1QB6oDKkPC8TXrEfQULNOsed5wqJ6/D5kpDYS
         YH1g==
X-Gm-Message-State: AOAM533CbfnKWsybyCxUXUNJKREedl6DZI0DAuWwugsDbmnhOx6fNrFW
        nnloS6z417GsDAs3HoQ/hV60dHIGTCo=
X-Google-Smtp-Source: ABdhPJzeywY9JhPURSMrDkD3ZdZTJ+PY3XfIY+cZjq7hNXfuwOd1dyTDG+dPxihAADAgja2EPUuueg==
X-Received: by 2002:a50:d5dd:: with SMTP id g29mr11210380edj.344.1606527667876;
        Fri, 27 Nov 2020 17:41:07 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id y14sm5729154edi.16.2020.11.27.17.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 17:41:07 -0800 (PST)
Date:   Sat, 28 Nov 2020 03:41:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201128014106.lcqi6btkudbnj3mc@skbuf>
References: <20201126220500.av3clcxbbvogvde5@skbuf>
 <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAFSKS=MAdnR2jzmkQfTnSQZ7GY5x5KJE=oeqPCQdbZdf5n=4ZQ@mail.gmail.com>
 <20201127195057.ac56bimc6z3kpygs@skbuf>
 <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
 <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127233048.GB2073444@lunn.ch>
 <20201127233916.bmhvcep6sjs5so2e@skbuf>
 <20201128000234.hwd5zo2d4giiikjc@skbuf>
 <20201128003912.GA2191767@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201128003912.GA2191767@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 01:39:12AM +0100, Andrew Lunn wrote:
> > This means, as far as I understand, 2 things:
> > 1. call_netdevice_notifiers_info doesn't help, since our problem is the
> >    same
> > 2. I think that holding the RTNL should also be a valid way to iterate
> >    through the net devices in the current netns, and doing just that
> >    could be the simplest way out. It certainly worked when I tried it.
> >    But those could also be famous last words...
>
> DSA makes the assumption it can block in a notifier change event.  For
> example, NETDEV_CHANGEUPPER calls dsa_slave_changeupper() which calls
> into the driver. We have not seen any warnings about sleeping while
> atomic. So maybe see how NETDEV_CHANGEUPPER is issued.

Yes, this is in line with what I said. Even though we are pure readers,
it is still sufficient (albeit not necessary) to hold rtnl in order to
safely iterate through net->dev_base_head (or in this case, through its
hashmaps per name and per ifindex). However, rtnl is the only one that
offers sleepable context, since it is the only one that is a mutex.

So the patch could simply look like this, no notifiers needed:

-----------------------------[cut here]-----------------------------
diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index c714e6a9dad4..1429e8c066d8 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/netdevice.h>
 #include <linux/proc_fs.h>
+#include <linux/rtnetlink.h>
 #include <linux/seq_file.h>
 #include <net/wext.h>
 
@@ -21,7 +22,7 @@ static inline struct net_device *dev_from_same_bucket(struct seq_file *seq, loff
 	unsigned int count = 0, offset = get_offset(*pos);
 
 	h = &net->dev_index_head[get_bucket(*pos)];
-	hlist_for_each_entry_rcu(dev, h, index_hlist) {
+	hlist_for_each_entry(dev, h, index_hlist) {
 		if (++count == offset)
 			return dev;
 	}
@@ -51,9 +52,9 @@ static inline struct net_device *dev_from_bucket(struct seq_file *seq, loff_t *p
  *	in detail.
  */
 static void *dev_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(RCU)
+	__acquires(rtnl_mutex)
 {
-	rcu_read_lock();
+	rtnl_lock();
 	if (!*pos)
 		return SEQ_START_TOKEN;
 
@@ -70,9 +71,9 @@ static void *dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void dev_seq_stop(struct seq_file *seq, void *v)
-	__releases(RCU)
+	__releases(rtnl_mutex)
 {
-	rcu_read_unlock();
+	rtnl_unlock();
 }
 
 static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
-----------------------------[cut here]-----------------------------

The advantage is that it can now sleep.

The disadvantage is that now it can sleep. It is a writer, so other
writers can block it out, and it can block out other writers. More
contention. Speaking of, here's an interesting patch from someone who
seems to enjoy running ifconfig:

commit f04565ddf52e401880f8ba51de0dff8ba51c99fd
Author: Mihai Maruseac <mihai.maruseac@gmail.com>
Date:   Thu Oct 20 20:45:10 2011 +0000

    dev: use name hash for dev_seq_ops

    Instead of using the dev->next chain and trying to resync at each call to
    dev_seq_start, use the name hash, keeping the bucket and the offset in
    seq->private field.

    Tests revealed the following results for ifconfig > /dev/null
            * 1000 interfaces:
                    * 0.114s without patch
                    * 0.089s with patch
            * 3000 interfaces:
                    * 0.489s without patch
                    * 0.110s with patch
            * 5000 interfaces:
                    * 1.363s without patch
                    * 0.250s with patch
            * 128000 interfaces (other setup):
                    * ~100s without patch
                    * ~30s with patch

    Signed-off-by: Mihai Maruseac <mmaruseac@ixiacom.com>
    Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Jakub, I would like to hear more from you. I would still like to try
this patch out. You clearly have a lot more background with the code.
You said in an earlier reply that you should have also documented that
ndo_get_stats64 is one of the few NDOs that does not take the RTNL. Is
there a particular reason for that being so, and a reason why it can't
change?
