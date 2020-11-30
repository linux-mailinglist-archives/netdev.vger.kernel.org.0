Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A342C8F0F
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 21:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388446AbgK3UWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 15:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388439AbgK3UWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 15:22:30 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3FAC0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:21:44 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id x15so7129090pll.2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bVAL/0KHxhPmWrWql10z/ecLv3R1nEV27Wu012m5/DE=;
        b=MirysheBGpGwwcIylMjeuA0z2w4YcENJEwyRqBWg6IHZSop3eSl94Eajjn3rkracyr
         c38WSybhu1yLzjD2/zkxfcFO7UfP11G1LqZ8FpCtk5Sp/5wknNn0+RgjSrHHGZgXCCa8
         VAg3+/3YvBEm9dw1Feb1YzNgY3tQC6TEAZzU6jBLZYQLDg31hQ4pqQ15uUxgQPuQFY6X
         gkb9s6gwag/P0Us7x8diYocQRv1kYGgwizm0WafYqVp2EAxKTcSfRGuIl3zzsVCw/Dge
         txBubp1k5fj7fsUDp7EhBcGyplQWGB044KCDYRrjfeeKjoDScdL1Co0J+x2Bj+Omf4xy
         YDWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bVAL/0KHxhPmWrWql10z/ecLv3R1nEV27Wu012m5/DE=;
        b=GyS2vgCFXEa+oLM1Qs3xkNnSNm6wHb6pn8BdwbbhXSW0mlMo5fQNFjpGYPVT9plNw0
         mTKQxJ2snsOsVLz489BMgNmWB/SVYwI0ASbXqCjTS5OA9AvcwcaDSOt62tC3Lwn3nV+0
         nCiG+F/UgzsGU6KvMN+2tPZz/Sgx/hJi7hNM7tWxaKEJpmSmKhkZShncAnF1xWDqT9DA
         DXRUTFLmRPsZ0NH0SNtINNzeClzoJIFSH0PLgFiLt2hnSlJZM0+aQ+75czl4xXjX0M7i
         d/zpglU1DjWhpGar6JlDn0kMcPkDQu+0JTAHuDrhbv2DPEK+7Yup4dMfMbyRpWBtMokj
         R5Ew==
X-Gm-Message-State: AOAM530ewRI+1n3ueuaZarMluRqEYyJEfm8IxdqqS0O1mdD5F3Bz+3WP
        r06kQn2eMxlcUP66AP7oj+EimA==
X-Google-Smtp-Source: ABdhPJxMurDipXQqcGqSxe1gpLPKEk92H62vEB5df9y++5c2mMJ12gbtN6WGJdHerNPGtq3oF3WYJg==
X-Received: by 2002:a17:90b:110:: with SMTP id p16mr683344pjz.54.1606767704028;
        Mon, 30 Nov 2020 12:21:44 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f18sm17932668pfa.167.2020.11.30.12.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 12:21:43 -0800 (PST)
Date:   Mon, 30 Nov 2020 12:21:29 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <20201130122129.21f9a910@hermes.local>
In-Reply-To: <20201130194617.kzfltaqccbbfq6jr@skbuf>
References: <20201129182435.jgqfjbekqmmtaief@skbuf>
        <20201129205817.hti2l4hm2fbp2iwy@skbuf>
        <20201129211230.4d704931@hermes.local>
        <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
        <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201130184828.x56bwxxiwydsxt3k@skbuf>
        <b8136636-b729-a045-6266-6e93ba4b83f4@gmail.com>
        <20201130190348.ayg7yn5fieyr4ksy@skbuf>
        <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
        <20201130194617.kzfltaqccbbfq6jr@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 21:46:17 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Mon, Nov 30, 2020 at 08:22:01PM +0100, Eric Dumazet wrote:
> > And ?
> >
> > A bonding device can absolutely maintain a private list, ready for
> > bonding ndo_get_stats() use, regardless
> > of register/unregister logic.
> >
> > bond_for_each_slave() is simply a macro, you can replace it by something else.  
> 
> Also, coming to take the comment at face value.
> Can it really? How? Freeing a net_device at unregister time happens
> after an RCU grace period. So whatever the bonding driver does to keep a
> private list of slave devices, those pointers need to be under RCU
> protection. And that doesn't help with the sleepable context that we're
> looking for.

if device is in a private list (in bond device), the way to handle
this is to use dev_hold() to keep a ref count.
