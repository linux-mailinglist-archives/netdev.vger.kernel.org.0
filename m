Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEE51DC179
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 23:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgETVgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 17:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgETVgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 17:36:38 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583DBC061A0F
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 14:36:37 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a5so1926985pjh.2
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 14:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oEy3KONd3ADgphDGousWSyHD+5c1mt4Xvb33TZ3mihY=;
        b=LL290Z2h4Q1tCi+X3mjwmJ1EJl1P6WYPOnYCO1tGDHYNhhRCae0EGxIgn/Ddlcgey6
         zy5CrKXWGd84PkCwGgaFHH6SR+MP8CVFlTJsIaRFLWJT7UFUTR9aDQJHTgixsek0q+ow
         OL0Mx6F9+fuxUzKc7NlItIp9XEwV+1rmXHLhCh8CV1FLsUa5wbfho/hk9SW0VXjrI9HX
         s64r+evbEbD7dpow22lLX1xJOOTi05vI43bQrUeyf/lFKFJ+lIe/OznskVc9ETsH9SfK
         h/iqScJ/ZwVs7WSsV6Ji1gX2wqXDEpWa/vkwNUSCsJ8skVKudn4iiSci/Bn6qodpUOeL
         5fUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oEy3KONd3ADgphDGousWSyHD+5c1mt4Xvb33TZ3mihY=;
        b=OSjtxE0fpwn92O0NjFZwazZ8nZcYqmvkX6zid+lVgmOYRkrWs3GJN4FEFfPBPka0Yo
         eVXujRsywHn4ZVkbUleY+4vN1aEc+brN3qCGJFdT1dJcRXup/Z4SIPw94BC0JzS8yb0H
         KOxh6OzZ1q2kf3uE/NNTWr/u8uL4s3rgkcJiVB2xHbuUtu3POolDxZ2DsseIEQKhul+L
         TjfzKFgM/383EAV7Led1V+gFtYVnjpKNm2XGjSnjq/5zh59bKGLSlAbXmLrZBx5OTVAN
         Q3N0R5L0X5lnLTcnAmM+pwGnBTW4LJATB3vkOg224JstehPOOwCMikkx8J+5STzhsu/L
         fJmg==
X-Gm-Message-State: AOAM533NgRjmptqdFP91DU4CoTqinpIJLXqjqijeI4OdjCHB4TI9ag39
        BRjtCTPLZmlnyIztw0plWa3pzA==
X-Google-Smtp-Source: ABdhPJyUKHAVjK06yBDbJoW20J2Rnz9M38TfcrCfIdpul3TwxJgrhXMdsqq5oAddMtivbLswlTyHJA==
X-Received: by 2002:a17:902:bf02:: with SMTP id bi2mr6456658plb.330.1590010596676;
        Wed, 20 May 2020 14:36:36 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r31sm2942792pjg.2.2020.05.20.14.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 14:36:36 -0700 (PDT)
Date:   Wed, 20 May 2020 14:36:27 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     David Miller <davem@davemloft.net>, a.darwish@linutronix.de,
        peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        paulmck@kernel.org, bigeasy@linutronix.de, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1 01/25] net: core: device_rename: Use rwsem instead of
 a seqcount
Message-ID: <20200520143627.047a7eee@hermes.lan>
In-Reply-To: <87wo56v1nc.fsf@nanos.tec.linutronix.de>
References: <20200519.195722.1091264300612213554.davem@davemloft.net>
        <87wo56v1nc.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 21:37:11 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> David Miller <davem@davemloft.net> writes:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Wed, 20 May 2020 01:42:30 +0200  
> >>> Please try, it isn't that hard..
> >>>
> >>> # time for ((i=0;i<1000;i++)); do ip li add dev dummy$i type dummy; done
> >>>
> >>> real	0m17.002s
> >>> user	0m1.064s
> >>> sys	0m0.375s  
> >> 
> >> And that solves the incorrectness of the current code in which way?  
> >
> > You mentioned that there wasn't a test case, he gave you one to try.  
> 
> If it makes you happy to compare incorrrect code with correct code, here
> you go:
> 
> 5 runs of 1000 device add, 1000 device rename and 1000 device del
> 
> CONFIG_PREEMPT_NONE=y
> 
>          Base      rwsem
>  add     0:05.01   0:05.28
> 	 0:05.93   0:06.11
> 	 0:06.52   0:06.26
> 	 0:06.06   0:05.74
> 	 0:05.71   0:06.07
> 
>  rename  0:32.57   0:33.04
> 	 0:32.91   0:32.45
> 	 0:32.72   0:32.53
> 	 0:39.65   0:34.18
> 	 0:34.52   0:32.50
> 
>  delete  3:48.65   3:48.91
> 	 3:49.66   3:49.13
> 	 3:45.29   3:48.26
> 	 3:47.56   3:46.60
> 	 3:50.01   3:48.06
> 
>  -------------------------
> 
> CONFIG_PREEMPT_VOLUNTARY=y
> 
>          Base      rwsem
>  add     0:06.80   0:06.42
> 	 0:04.77   0:05.03
> 	 0:05.74   0:04.62
> 	 0:05.87   0:04.34
> 	 0:04.20   0:04.12
> 
>  rename  0:33.33   0:42.02
> 	 0:42.36   0:32.55
> 	 0:39.58   0:31.60
> 	 0:33.69   0:35.08
> 	 0:34.24   0:33.97
> 
>  delete  3:47.82   3:44.00
> 	 3:47.42   3:51.00
> 	 3:48.52   3:48.88
> 	 3:48.50   3:48.09
> 	 3:50.03   3:46.56
> 
>  -------------------------
> 
> CONFIG_PREEMPT=y
> 
>          Base      rwsem
> 
>  add     0:07.89   0:07.72
> 	 0:07.25   0:06.72
> 	 0:07.42   0:06.51
> 	 0:06.92   0:06.38
> 	 0:06.20   0:06.72
> 
>  rename  0:41.77   0:32.39
> 	 0:44.29   0:33.29
> 	 0:36.19   0:34.86
> 	 0:33.19   0:35.06
> 	 0:37.00   0:34.78
> 
>  delete  2:36.96   2:39.97
> 	 2:37.80   2:42.19
> 	 2:44.66   2:48.40
> 	 2:39.75   2:41.02
> 	 2:40.77   2:38.36
> 
> The runtime variation is rather large and when running the same in a VM
> I got complete random numbers for both base and rwsem. The most amazing
> was delete where the time varies from 30s to 6m20s.
> 
> Btw, Sebastian noticed that rename spams dmesg:
> 
>   netdev_info(dev, "renamed from %s\n", oldname);
> 
> which eats about 50% of the Rename run time.
> 
>          Base      netdev_info() removed
> 
> Rename   0:34.84   0:17.48
> 
> That number at least makes tons of sense
> 
> Thanks,
> 
>         tglx

Looks good thanks for following through.
