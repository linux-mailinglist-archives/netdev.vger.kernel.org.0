Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2772F4E2EA3
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 18:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351547AbiCURBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 13:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348548AbiCURBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 13:01:46 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8AC72E32
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 10:00:20 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id t2so15957643pfj.10
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 10:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=re+ElXIzTQy5rCx63a7lonLbk/LZ9pkEiZiZ3EmVdPU=;
        b=ZQTHwvHwoLS2LZrT/qbrGqCVvtYIDbVN+QZ/CEj5heQn9DoiuHYkbDzUaTMCb3AJOD
         etj4PhQXrLDt2rIXLFPEHcXT0FOZnMZJVHvLEpm3zLr3O0MqgzIQ+0pQ45R9vh1JPUkJ
         Qtd39NNNRLY31TtYv4MtuToce3/ucogB4e7xhFbBuY9r2IYxQAusjYC4hffCj2zFsvzd
         O+jlk6fyLJ7dmWaY+U+XhOHR8Ra+yD408ZUakFxfkQ5vSBVjyo3nlcW9GatETneJzbFw
         zm7+hABDXabl2vE8eRZv0W0f35mmMUSxGkMA8V3pRDPWEVFGtTSy17FKw9g4KGF46/16
         Mz0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=re+ElXIzTQy5rCx63a7lonLbk/LZ9pkEiZiZ3EmVdPU=;
        b=EEymRhyubYi/6kGbDclu6JdCAfmw3U1qq89n6fJH8qIZpVgqI1pCv1i3gegcqR1Jj3
         9oS1eRpS8bYs5If3rki5AXZyPKEF4uHAiYi6+v/xOOnp8zO3ZE9sUSABIdjJPmcMszl6
         afqubMuiSq3mMPZzUr7hx5Run3ZXF3uyfnnd5h5+Y7td1b0jSDKg4/KlG4y7Yl9jqoV9
         RFouElLX98sARSOD5WKjP7oIaejmSHTs4YH7N8UkO72JL0yiG2V5zU+wsxEKnc+aw9HP
         MmjkjpJmBVYxqeQWlX6qHnD0hYYJKpqgyl3keTVeSAX+GR33AH3VvDwAZtgXyBPIclBg
         PHsA==
X-Gm-Message-State: AOAM530J+C1VgLqlE/lSUecid/Xunbxc7HO0zW9YsfQ9wJOJl9kbeZT6
        IxLhxcW2OsMNBo+fVGfc6RNQIw==
X-Google-Smtp-Source: ABdhPJzw9kRtLPxPsmRWaQmY/xve+Tjeo16MjgIwychWdjvqRkt743QRaDxiD2/PTth4uvKP0lcykA==
X-Received: by 2002:aa7:8256:0:b0:4e0:78ad:eb81 with SMTP id e22-20020aa78256000000b004e078adeb81mr25218291pfn.30.1647882018633;
        Mon, 21 Mar 2022 10:00:18 -0700 (PDT)
Received: from google.com (249.189.233.35.bc.googleusercontent.com. [35.233.189.249])
        by smtp.gmail.com with ESMTPSA id l9-20020a655609000000b0037589f4337dsm15217666pgs.78.2022.03.21.10.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 10:00:17 -0700 (PDT)
Date:   Mon, 21 Mar 2022 17:00:14 +0000
From:   William McVicker <willmcvicker@google.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "Cc: Android Kernel" <kernel-team@android.com>
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
Message-ID: <YjivHrPnzG7h2Sdf@google.com>
References: <0000000000009e9b7105da6d1779@google.com>
 <CABYd82Z=YXmZPTQhf0K1M4nS2wk3dPBSqx91D8SoUd59AUzpHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABYd82Z=YXmZPTQhf0K1M4nS2wk3dPBSqx91D8SoUd59AUzpHg@mail.gmail.com>
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/21/2022, Will McVicker wrote:
> On Thu, Mar 17, 2022 at 10:09 AM <willmcvicker@google.com> wrote:
> 
> > Hi,
> >
> > I wanted to report a deadlock that I'm hitting as a result of the upstream
> > commit a05829a7222e ("cfg80211: avoid holding the RTNL when calling the
> > driver"). I'm using the Pixel 6 with downstream version of the 5.15 kernel,
> > but I'm pretty sure this will happen on the upstream tip-of-tree kernel as
> > well.
> >
> > Basically, my wlan driver uses the wiphy_vendor_command ops to handle
> > a number of vendor specific operations. One of them in particular deletes
> > a cfg80211 interface. The deadlock happens when thread 1 tries to take the
> > RTNL lock before calling cfg80211_unregister_device() while thread 2 is
> > inside nl80211_pre_doit(), holding the RTNL lock, and waiting on
> > wiphy_lock().
> >
> > Here is the call flow:
> >
> > Thread 1:                         Thread 2:
> >
> > nl80211_pre_doit():
> >   -> rtnl_lock()
> >                                       nl80211_pre_doit():
> >                                        -> rtnl_lock()
> >                                        -> <blocked by Thread 1>
> >   -> wiphy_lock()
> >   -> rtnl_unlock()
> >   -> <unblock Thread 1>
> > exit nl80211_pre_doit()
> >                                        <Thread 2 got the RTNL lock>
> >                                        -> wiphy_lock()
> >                                        -> <blocked by Thread 1>
> > nl80211_doit()
> >   -> nl80211_vendor_cmd()
> >       -> rtnl_lock() <DEADLOCK>
> >       -> cfg80211_unregister_device()
> >       -> rtnl_unlock()
> >
> >
> > To be complete, here are the kernel call traces when the deadlock occurs:
> >
> > Thread 1 Call trace:
> >     <Take rtnl before calling cfg80211_unregister_device()>
> >     nl80211_vendor_cmd+0x210/0x218
> >     genl_rcv_msg+0x3ac/0x45c
> >     netlink_rcv_skb+0x130/0x168
> >     genl_rcv+0x38/0x54
> >     netlink_unicast_kernel+0xe4/0x1f4
> >     netlink_unicast+0x128/0x21c
> >     netlink_sendmsg+0x2d8/0x3d8
> >
> > Thread 2 Call trace:
> >     <Take wiphy_lock>
> >     nl80211_pre_doit+0x1b0/0x250
> >     genl_rcv_msg+0x37c/0x45c
> >     netlink_rcv_skb+0x130/0x168
> >     genl_rcv+0x38/0x54
> >     netlink_unicast_kernel+0xe4/0x1f4
> >     netlink_unicast+0x128/0x21c
> >     netlink_sendmsg+0x2d8/0x3d8
> >
> > I'm not an networking expert. So my main question is if I'm allowed to take
> > the RTNL lock inside the nl80211_vendor_cmd callbacks? If so, then
> > regardless of why I take it, we shouldn't be allowing this deadlock
> > situation, right?
> >
> > I hope that helps explain the issue. Let me know if you need any more
> > details.
> >
> > Thanks,
> > Will
> >
> 
> Sorry my CC list got dropped. Adding the following:
> 
> Kalle Valo <kvalo@codeaurora.org>
> "David S. Miller" <davem@davemloft.net>
> Jakub Kicinski <kuba@kernel.org>
> netdev@vger.kernel.org
> Amitkumar Karwar <amitkarwar@gmail.com>
> Ganapathi Bhat <ganapathi.bhat@nxp.com>
> Xinming Hu <huxinming820@gmail.com>
> kernel-team@android.com

Sorry for the noise. The lists bounced due to html. Resending with mutt to make
sure everyone gets this message.

As an update, I was able to fix the deadlock by updating nl80211_pre_doit() to
not hold the RTNL lock while waiting to get the wiphy_lock. This allows us to
take the RTNL lock within nl80211_doit() and have parallel calls to
nl80211_doit(). Below is the logic I tested. Please let me know if I'm heading
in the right direction.

Thanks,
Will

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 686a69381731..bb4ad746509b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -15227,7 +15227,24 @@ static int nl80211_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
 	}
 
 	if (rdev && !(ops->internal_flags & NL80211_FLAG_NO_WIPHY_MTX)) {
-		wiphy_lock(&rdev->wiphy);
+		while (!mutex_trylock(&rdev->wiphy.mtx)) {
+			/* Holding the RTNL lock while waiting for the wiphy lock can lead to
+			 * a deadlock within doit() ops that don't hold the RTNL in pre_doit. So
+			 * we need to release the RTNL lock first while we wait for the wiphy
+			 * lock.
+			 */
+			rtnl_unlock();
+			wiphy_lock(&rdev->wiphy);
+
+			/* Once we get the wiphy_lock, we need to grab the RTNL lock. If we can't
+			 * get it, then we need to unlock the wiphy to avoid a deadlock in
+			 * pre_doit and then retry taking the locks again. */
+			if (!rtnl_trylock()) {
+				wiphy_unlock(&rdev->wiphy);
+				rtnl_lock();
+			} else
+				break;
+		}
 		/* we keep the mutex locked until post_doit */
 		__release(&rdev->wiphy.mtx);
 	}
