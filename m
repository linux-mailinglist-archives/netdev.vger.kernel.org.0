Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2800C90750
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 19:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfHPR4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 13:56:44 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36548 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbfHPR4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 13:56:44 -0400
Received: by mail-qk1-f193.google.com with SMTP id d23so5484913qko.3
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 10:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mMaTuiPyKLM9tfCLZcB7Dek/W9Zw2QriOJBDcXfSjQ8=;
        b=pQZR2TNWrG26Y9jB/x9XjzoHpYgaG3BQIGAKjPUdsW3Ge1vrxVxyC3XbjpAHTlpUz3
         4HC7CraQcupeHBpge9VZHxM2vkVLVawnhiIxbYkDdd5lP2RszB1OISk96/UjsbIBlY8s
         Ah3FqiTn609CtBUAdj7VnSK1tr/9oP5use5bjDCn7Tlja1sBRxP3RmfTAa0qkJMva2K9
         dEbBckXSZjWRJUNGCK3yQP/D4HjGIH0Fpha05C5x6+wV8QUkJq0gTI+lo7HEePFpQyNP
         zJWwZfLxCpzAhKftwcKAPN6bn8RXT0AIaRKJYG9+v+9cbr89ZQByRdmy7eDkR8Hq5giS
         pdcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mMaTuiPyKLM9tfCLZcB7Dek/W9Zw2QriOJBDcXfSjQ8=;
        b=SIQ40yXisjVJgez1QShkWKpOxpqO4D0bo1qKo83a38JrJ/OzqVDOm9hRRYGpFvKb9x
         bKVwsQ1FQeqZcaui+xwTTF8MgVE4YZcOJbzR3s/b1jcVcb4BwvH87WZsblEE2OszyCV9
         rfuAbx/q9OKOa2Fbq/PeAIxtsJiajCEwrORUfhPCpSEzKr71aW7rjKXCHqw53A609598
         IR46xQTWHdU1i+rWFAvj8o0ld5K5rJp96fv98t8Y8n+PTIAyKKO1ec8jXad9i7z8R7a7
         Dt4KvfVTpEm02WC/fQC82uB3tcfAzGf2Jc93veEAnLIFBU1pc5pB5mj4vAOOdQZMw3VR
         4zmA==
X-Gm-Message-State: APjAAAX8Dhwdf73tAZXes3eoFXggh5ulIQH9XOggoHaXePcl6cNQFs7k
        fa38/F0QoHqMykZz8UZWr843wQ==
X-Google-Smtp-Source: APXvYqxgxMUn0Os7xzdLYkAtyUoCCk2KkYV1Lt1eDu/B49D4i+/3ZDwkfGjrtjynjQckySTiPVSNCw==
X-Received: by 2002:a37:ef0c:: with SMTP id j12mr8969221qkk.345.1565978203530;
        Fri, 16 Aug 2019 10:56:43 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z5sm3011473qti.80.2019.08.16.10.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 10:56:43 -0700 (PDT)
Date:   Fri, 16 Aug 2019 10:56:27 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     wenxu <wenxu@ucloud.cn>, David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v7 5/6] flow_offload: support get
 multi-subsystem block
Message-ID: <20190816105627.57c1c2aa@cakuba.netronome.com>
In-Reply-To: <vbfpnl55eyg.fsf@mellanox.com>
References: <1565140434-8109-1-git-send-email-wenxu@ucloud.cn>
        <1565140434-8109-6-git-send-email-wenxu@ucloud.cn>
        <vbfimr2o4ly.fsf@mellanox.com>
        <f28ddefe-a7d8-e5ad-e03e-08cfee4db147@ucloud.cn>
        <vbfpnl55eyg.fsf@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Aug 2019 15:04:44 +0000, Vlad Buslov wrote:
> >> [  401.511871] RSP: 002b:00007ffca2a9fad8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> >> [  401.511875] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fad892d30f8
> >> [  401.511878] RDX: 0000000000000002 RSI: 000055afeb072a90 RDI: 0000000000000001
> >> [  401.511881] RBP: 000055afeb072a90 R08: 00000000ffffffff R09: 000000000000000a
> >> [  401.511884] R10: 000055afeb058710 R11: 0000000000000246 R12: 0000000000000002
> >> [  401.511887] R13: 00007fad893a8780 R14: 0000000000000002 R15: 00007fad893a3740
> >>
> >> I don't think it is correct approach to try to call these callbacks with
> >> rcu protection because:
> >>
> >> - Cls API uses sleeping locks that cannot be used in rcu read section
> >>   (hence the included trace).
> >>
> >> - It assumes that all implementation of classifier ops reoffload() don't
> >>   sleep.
> >>
> >> - And that all driver offload callbacks (both block and classifier
> >>   setup) don't sleep, which is not the case.
> >>
> >> I don't see any straightforward way to fix this, besides using some
> >> other locking mechanism to protect block_ing_cb_list.
> >>
> >> Regards,
> >> Vlad  
> >
> > Maybe get the  mutex flow_indr_block_ing_cb_lock for both lookup, add, delete? 
> >
> > the callbacks_lists. the add and delete is work only on modules init case. So the
> >
> > lookup is also not frequently(ony [un]register) and can protect with the locks.  
> 
> That should do the job. I'll send the patch.

Hi Vlad! 

While looking into this, would you mind also add the missing
flow_block_cb_is_busy() calls in the indirect handlers in the drivers?

LMK if you're too busy, I don't want this to get forgotten :)
