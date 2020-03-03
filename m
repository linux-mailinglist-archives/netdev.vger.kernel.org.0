Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFDE41771B6
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 10:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgCCJAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 04:00:44 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34346 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbgCCJAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 04:00:43 -0500
Received: by mail-qt1-f193.google.com with SMTP id 59so1048228qtb.1
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 01:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=nqcxOzFK9KLUEURDKZJOixFynv1g2fNogwRWVoEz34I=;
        b=a6+TmqnrbBzjhlChER5WAV7JNs+5Mi4ySzjS+xZDSejgZ6rXf/hofYLMuh7ca7htwJ
         +evP4Ebqo4jTX538ctroZ8W9WRBQMV2SVmBpx9M28A8rsK14FVB7UTgJWXCYHfy9WisV
         91CK1sFm5d7zRoTtvEZkI5OlyHSyPZw6Vcs70ltVrTAu9bZ+Ws2OjGOscMy+PEeB1e/x
         YNgcaABaXnJRTjOyQcYtJhL/ELE3i5fTgMWVJeCThoTJTgxIZqAp412EbKS+FppYxgU9
         YaxwZo/tT45cU6H35Qlf/53Z27pY+xZxu1f6DGieDHMyS0hvYCYhChZnTuJlnpK81uR1
         PvYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=nqcxOzFK9KLUEURDKZJOixFynv1g2fNogwRWVoEz34I=;
        b=jms28Zt0W+Cs/be8Ijbmr/5rAJjbEDGNFzKVjFYNyqgHLnAM/cpJOolqRKMuVA8sPz
         sd6P4z5+I0eDmRuyAur/GWHmk2QZSDheOfMUe5JhakYK5i4yBwTKh0GJB4TgLuvri8zX
         dxFVe84B3OW4iKu/BjinpBtpV+ya5oqvd+6WBmumT08ssYrF/Vj3KdBNJj6zpPdocWNI
         a1k7g1pavnWJBMZBElT+EzTv3YPdA25q+H+1jpxrAj526YicMaY3cWwYFLVZXBFo8C6r
         ltjJG7E0nRuz0dhHb7gW97Cu2ckl3RbCuJMF7lPVFnLnOw1wtjhtMPd1hVMGbS+6ot3a
         CYCA==
X-Gm-Message-State: ANhLgQ09gTNG8zx4gRO1gYRnZ6YLoeUPSSQPVb/7sPZAVxqW9gggvP0m
        uBYCtKBHNvU41af/lmGfRxE=
X-Google-Smtp-Source: ADFU+vu9y4H6SMGMNV4IOlX0DoOGolUwTfTJ0dMVVB/eROBQmeb1/F7AiUJ7NxdHeYgOvqmidLV66A==
X-Received: by 2002:aed:27de:: with SMTP id m30mr3455357qtg.151.1583226042542;
        Tue, 03 Mar 2020 01:00:42 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i64sm9809771qke.56.2020.03.03.01.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 01:00:42 -0800 (PST)
Date:   Tue, 3 Mar 2020 17:00:35 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
Message-ID: <20200303090035.GV2159@dhcp-12-139.nay.redhat.com>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <b9d30209-7cc2-4515-f58a-f0dfe92fa0b6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b9d30209-7cc2-4515-f58a-f0dfe92fa0b6@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 07:16:44AM +0100, Rafał Miłecki wrote:
> It appears that every interface up & down sequence results in adding a
> new ff02::2 entry to the idev->mc_tomb. Doing that over and over will
> obviously result in running out of memory at some point. That list isn't
> cleared until removing an interface.

Thanks Rafał, this info is very useful. When we set interface up, we will
call ipv6_add_dev() and add in6addr_linklocal_allrouters to the mcast list.
But we only remove it in ipv6_mc_destroy_dev(). This make the link down save
the list and link up add a new one.

Maybe we should remove the list in ipv6_mc_down(). like:

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index eaa4c2cc2fbb..786352ff7704 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2533,6 +2533,18 @@ void ipv6_mc_down(struct inet6_dev *idev)
 {
        struct ifmcaddr6 *i;

+       /* Delete all-nodes address. */
+       /* We cannot call ipv6_dev_mc_dec() directly, our caller in
+        * addrconf.c has NULL'd out dev->ip6_ptr so in6_dev_get() will
+        * fail.
+        */
+       __ipv6_dev_mc_dec(idev, &in6addr_interfacelocal_allnodes);
+       __ipv6_dev_mc_dec(idev, &in6addr_linklocal_allnodes);
+
+       if (idev->cnf.forwarding)
+               __ipv6_dev_mc_dec(idev, &in6addr_linklocal_allrouters);
+
+
        /* Withdraw multicast list */

        read_lock_bh(&idev->lock);
@@ -2603,16 +2615,6 @@ void ipv6_mc_destroy_dev(struct inet6_dev *idev)
        ipv6_mc_down(idev);
        mld_clear_delrec(idev);

-       /* Delete all-nodes address. */
-       /* We cannot call ipv6_dev_mc_dec() directly, our caller in
-        * addrconf.c has NULL'd out dev->ip6_ptr so in6_dev_get() will
-        * fail.
-        */
-       __ipv6_dev_mc_dec(idev, &in6addr_linklocal_allnodes);
-
-       if (idev->cnf.forwarding)
-               __ipv6_dev_mc_dec(idev, &in6addr_linklocal_allrouters);
-
        write_lock_bh(&idev->lock);
        while ((i = idev->mc_list) != NULL) {
                idev->mc_list = i->next;


Thanks
Hangbin
