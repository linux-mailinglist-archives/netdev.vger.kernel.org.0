Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CC8612113
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 09:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJ2Hlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 03:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJ2Hlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 03:41:39 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A7D1C7D4E
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 00:41:37 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id fy4so17922062ejc.5
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 00:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9+EP6Afy57vEwE/0bUyPIlx5VULJdZKUsmEcRH1R91k=;
        b=keTumMq2/M0wJ7wH3+4+2ze3CyCA22HRJcCChYEpj7NnYFKAt6M1GXm8OLFzwBdO0R
         zypBg9cvTVXV8SrXYURTgLAXfGr0rgx7qtzXzIW76sef/iCrgx+u/Gfnlrh9kOB0jK7O
         XH9fDJkWUkrVUTGJyEKmydQ30qX54URaWqrgwuFADJMgDnIJuseV39pc7/HGFZQU+pkg
         SpS1py54pn5f+IdgBhTXUt+YvBSy2PdBX3lTbH76DbP5OHnsRnM61jKmGK69V0+eKhKA
         Fs0ve8jcRYhFyYYSED6tS7nVQzSmGnZE8gZHNtSXyyoskDMCx3RQbvz3DEsqeCg6HTFc
         4Diw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9+EP6Afy57vEwE/0bUyPIlx5VULJdZKUsmEcRH1R91k=;
        b=gkRDsdaRA7yXDQqol4D6FRi2ZbTP9+J8VBU9+XJybt1CMSt+Hfqkjo8Fy5H4otbh6a
         +irPE6jrYaaowMIWDpjabhbcwgTj1AmjRhSW2ncsURt6IARA6LA1QW14FXi6WxKqJzpY
         qkraytdPxuAAgRGpii/GIlLguBdj1bcoPGsPzKp6hvwgovtZySVouZA4iwHKMfkvMEOf
         vepCK7AFv0U7kVdIc/oGQ1q+m9bFEaEdjeIBBCgnSqZMF8Z0E7/x4oTeolW8Dwm28F+0
         po/y4zavrIYYjDhwFi/yWYQ9PZq62iXXDGlooVq0PnZBkY3o8Lcdxxofj9/i/0mRlQEZ
         yNIA==
X-Gm-Message-State: ACrzQf2iDbxrq1nwivNESfSrIgcF2yY/pBZNRv+oKh8eEbJHVJZkc8Kh
        phiQskBNx2d56r1Q80Ti2fU=
X-Google-Smtp-Source: AMsMyM5Nqoc4SU7YFvlqnaRfIVVvU1LCX+goGqXtKHDwLOqLAu30cHkZwsJ32mMLuqTJB0EmLbyKqg==
X-Received: by 2002:a17:907:62a7:b0:789:48ea:ddb0 with SMTP id nd39-20020a17090762a700b0078948eaddb0mr2736220ejc.575.1667029295907;
        Sat, 29 Oct 2022 00:41:35 -0700 (PDT)
Received: from blondie ([77.137.65.34])
        by smtp.gmail.com with ESMTPSA id kv3-20020a17090778c300b00780f6071b5dsm361844ejc.188.2022.10.29.00.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 00:41:35 -0700 (PDT)
Date:   Sat, 29 Oct 2022 10:41:31 +0300
From:   Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Jiri Benc <jbenc@redhat.com>, willemb@google.com
Cc:     netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tomas Hruby <tomas@tigera.io>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        alexanderduyck@meta.com, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net] net: gso: fix panic on frag_list with mixed head
 alloc types
Message-ID: <20221029104131.07fbc6cf@blondie>
In-Reply-To: <559cea869928e169240d74c386735f3f95beca32.1666858629.git.jbenc@redhat.com>
References: <559cea869928e169240d74c386735f3f95beca32.1666858629.git.jbenc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 10:20:56 +0200
Jiri Benc <jbenc@redhat.com> wrote:

> It turns out this assumption does not hold. We've seen BUG_ON being hit
> in skb_segment when skbs on the frag_list had differing head_frag. That
> particular case was with vmxnet3; looking at the driver, it indeed uses
> different skb allocation strategies based on the packet size. The last
> packet in frag_list can thus be kmalloced if it is sufficiently small.
> And there's nothing preventing drivers from mixing things even more
> freely.

Hi Jiri,

One of my early attempts to fix the original BUG was to also detect:

> - some frag in the frag_list has a linear part that is NOT head_frag,
>   or length not equal to the requested gso_size

See [0], see skb_is_nonlinear_equal_frags() there

(Note that your current suggestion implements the "some frag in the
 frag_list has a linear part that is NOT head_frag" condition, but not
 "length not equal to the requested gso_size")

As a response, Willem suggested:

> My suggestion only tested the first frag_skb length. If a list can be
> created where the first frag_skb is head_frag but a later one is not,
> it will fail short. I kind of doubt that.

See [1]

So we eventually concluded testing just
  !list_skb->head_frag && skb_headlen(list_skb)
and not every frag in frag_list.

Maybe Willem can elaborate on that.


[0] https://lore.kernel.org/netdev/20190903185121.56906d31@pixies/
[1] https://lore.kernel.org/netdev/CA+FuTScE=pyopY=3f5E4JGx1zyGqT+XS+8ss13UN4if4TZ2NbA@mail.gmail.com/
