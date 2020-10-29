Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C5E29F8C5
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgJ2W7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgJ2W7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 18:59:40 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C19C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 15:59:40 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id c5so2974239qtw.3
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 15:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=egQBVXCQHGSXGz3JZv1ILGvRL8HDR1+qO6KpVDRF5W4=;
        b=UF86bgEoQUtPlzptmY978uJCYcLbJ9X3P/0qfEHkFMw/34HPw8Q6fKI/i34CmAg7pY
         wtxn1kiXaVkaBWm1rHY2nxGP8YwqTAR//4RJB/t9XccFq8aO0Z2eDkZ6KPHR/an6UQYW
         ET/bVaFCgPB/jWJ0be9F8399XZgGZ8OyQYeUze5enHG+xGwnO9HAIisZ8Zo7DKFMQ681
         QeWgL9jdtqHtV9AKapHp0gVTyoQY7IpKsM9Tns1QVIGdp1tMDwLaDaZxxIYs/FI/eLCU
         RKBtTp0x4WI0WUnSL44+MTvQ9qDvPkdNlikRz1kAR1Au9oOB+fNl/miLj7pCDNO8gm2z
         /jWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=egQBVXCQHGSXGz3JZv1ILGvRL8HDR1+qO6KpVDRF5W4=;
        b=f24citOnsE8I1sb2CJd4rylrrSO7+hQUGd+tIrHT6sgQpRlxAgb978DTYDcjmM9tEG
         1H6aq8M8DiKXOMl2T9ciwGHfpk9zyyl7czkRGwkTk9UZsb3TxHnsCiodPztHyjqZvV71
         iPLT+Xin8x/NNpokarIMSKF+p+n8gwKSfW//w3sjWcrzM0vgW5heZvF7f2TlJoEhzdR/
         BRCl6o2bH4b1ERogs77kwImFA8LcQuLtCdawijnzLeVTdCepiVbeebcu7JT1Nkk4TJcd
         qDphUNeJ+3LoCZroXKKXKSw3VVWETmRNKrurCFGvihrkLJeyMpFsC2fiwEAmBh4O905S
         faBg==
X-Gm-Message-State: AOAM532FLzRfoI3C+83f1YDdDRLieP2xDJNXGHa9mq6t0BD5jcYOUP8H
        zBpIhhhr95/12hnXWV3jd7I=
X-Google-Smtp-Source: ABdhPJwNCwuFZfiwC5C0j+psh7PewpLXB006k+UiYFliaeEwp3bClVoE7T1MYQ5TvSNufSAPanccmg==
X-Received: by 2002:ac8:76d9:: with SMTP id q25mr6049491qtr.125.1604012379098;
        Thu, 29 Oct 2020 15:59:39 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:3996:7c32:c023:7030:e73a])
        by smtp.gmail.com with ESMTPSA id j5sm1807844qtv.91.2020.10.29.15.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 15:59:38 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 1FD3EC0DAB; Thu, 29 Oct 2020 19:59:36 -0300 (-03)
Date:   Thu, 29 Oct 2020 19:59:36 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>
Subject: Re: [resend] Solution for the problem conntrack in tc subsystem
Message-ID: <20201029225936.GM3837@localhost.localdomain>
References: <7821f3ae-0e71-0d8b-5ef9-81da69ac29dc@ucloud.cn>
 <435e4756-f36a-f0f5-0ac5-45bd5cacaff2@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <435e4756-f36a-f0f5-0ac5-45bd5cacaff2@ucloud.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc'ing Cong, Paul, Oz and Davide.

On Thu, Oct 29, 2020 at 10:22:04AM +0800, wenxu wrote:
> Only do gso for the reassembly big packet is also can't fix all the
> case such for icmp packet.

Good point. And as we can't know that a fragment was for an icmp
packet before defraging it, this is quite impactful.

> 
> So there are some proper solution for this problem. In the Internet
> we can't avoid the fragment packets.

I agree. One other idea is to add support for some hook to mirred,
that gets executed before xmiting the packet. Then, when act_ct (or
another specific act module, say act_frag, as act_ct might not be the
only one interested in defragging in the future) gets loaded, it
configs that hook.

So that mirred would something like:
if (xmit_hook)
	xmit_hook(skb, dev_queue_xmit);
else
	dev_queue_xmit(skb);
Even protect it with a static branch key.

This leaves mirred almost untouched, 0 performance penalty for those
that don't use act_ct, can even have a Kconfig knob, is not CT or
ipfrag specific code on mirred so it's reusable later on and solves
our problem here. Thoughts?

  Marcelo
