Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4363A6411A8
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 00:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbiLBXuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 18:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiLBXuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 18:50:02 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF32DFA44F
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 15:50:01 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id l15so7411424qtv.4
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 15:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eQkAr9mSx5+4OR8wvcltri5YQ2lS8vvtfycbVO8qMjw=;
        b=AfiGd+itfYPlAUA0pv80S+0+Twk32AeySLSZNLspwjQghf/PeNsAPMK66GWymVRMVw
         M8akmqKUNlbIgrS6LZeCF/awKSl862XgRH53qHLG60CmqWhPiordrKVpvfcs8Uq8flC9
         NRfnf0UDalk3u1SeBDqk1bPa6wxeXNkdJsUpw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eQkAr9mSx5+4OR8wvcltri5YQ2lS8vvtfycbVO8qMjw=;
        b=NLSy9hxhxspTJKVypPWJJjqu8n6MZTY1Hd1qZ42jbv5K3cquEt4Qh6I4pe5BoAdTsW
         hOvcpSV2heSULCg1tQRqdQb16ak3pnqICp9/tJHePpVsVx1vSDOGK2agC44SoH+jyZxR
         spg3ceJ34dj04TFqzdwfd728bxNwd1MlrCqWY4OTRXDSPZ+ElPiH0R9bJT3AXvpY3PkR
         z+Gb5wXuZkhrZr1CvS0xh3ltjm/G0D4ky8gUR9rmACcrtRgVqp9DPeUp+tVQs8H9b7HX
         +wh22VsSyFT6cFKh3WnhHPLBF1VGSeXjyAiIujGjWB9SyA6JqYM8nRSASonEZbq4nkII
         GXIw==
X-Gm-Message-State: ANoB5pnbl8Py2TNrVMX0YtMTyzMVJhK8ztmusxXkiWZ+HCK3CrQ+46oP
        YTHj5UJFOKZ/KuqUBhmKcJbuag==
X-Google-Smtp-Source: AA0mqf77fr4dtrt98HSRzD38Tz7lzrVmisOOx15QDM8oVzhBcIThqT/5W7R2jJkoaqqsJm1BNVupkw==
X-Received: by 2002:ae9:ef0a:0:b0:6fc:a689:204d with SMTP id d10-20020ae9ef0a000000b006fca689204dmr8522471qkg.467.1670025000746;
        Fri, 02 Dec 2022 15:50:00 -0800 (PST)
Received: from localhost (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id s18-20020a05620a29d200b006f9ddaaf01esm6919304qkp.102.2022.12.02.15.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 15:49:59 -0800 (PST)
Date:   Fri, 2 Dec 2022 23:49:59 +0000
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Dmitry Safonov <dima@arista.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH net-next] tcp: use 2-arg optimal variant of kfree_rcu()
Message-ID: <Y4qPJ89SBWACbbTr@google.com>
References: <20221202052847.2623997-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202052847.2623997-1-edumazet@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 05:28:47AM +0000, Eric Dumazet wrote:
> kfree_rcu(1-arg) should be avoided as much as possible,
> since this is only possible from sleepable contexts,
> and incurr extra rcu barriers.
> 
> I wish the 1-arg variant of kfree_rcu() would
> get a distinct name, like kfree_rcu_slow()
> to avoid it being abused.

Hi Eric,
Nice to see your patch.

Paul, all, regarding Eric's concern, would the following work to warn of
users? Credit to Paul/others for discussing the idea on another thread. One
thing to note here is, this debugging will only be in effect on preemptible
kernels, but should still help catch issues hopefully.

The other idea Paul mentioned is to introduce a new dedicated API for 1-arg
sleepable cases. My concern with that was that, that being effective depends
on the user using the right API in the first place.

I did not test it yet, but wanted to discuss a bit first.

Cheers,

- Joel

---8<-----------------------

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 9bc025aa79a3..112d230279ea 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -106,6 +106,11 @@ static inline void __kvfree_call_rcu(struct rcu_head *head, rcu_callback_t func)
 	}
 
 	// kvfree_rcu(one_arg) call.
+	if (IS_ENABLED(CONFIG_PREEMPT_COUNT) && preemptible() && !head) {
+		WARN_ONCE(1, "%s(): Please provide an rcu_head in preemptible"
+			  " contexts to avoid long waits!\n", __func__);
+	}
+
 	might_sleep();
 	synchronize_rcu();
 	kvfree((void *) func);
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 0ca21ac0f064..b29df1305a2e 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3324,6 +3324,11 @@ void kvfree_call_rcu(struct rcu_head *head, rcu_callback_t func)
 		 * only. For other places please embed an rcu_head to
 		 * your data.
 		 */
+		if (IS_ENABLED(CONFIG_PREEMPT_COUNT) && preemptible() && !head) {
+			WARN_ONCE(1, "%s(): Please provide an rcu_head in preemptible"
+				  " contexts to avoid long waits!\n", __func__);
+		}
+
 		might_sleep();
 		ptr = (unsigned long *) func;
 	}
