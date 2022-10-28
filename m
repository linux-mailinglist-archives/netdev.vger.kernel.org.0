Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6140611AD1
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 21:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiJ1TVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 15:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiJ1TVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 15:21:14 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5DD14EC43
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 12:21:13 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id z30so4072174qkz.13
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 12:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=95e0Mv0fzTKoZaFeL4la+K83s4mjby+mfcJYCUq+2is=;
        b=Laz+xSJTavAkajJ5tIHzwxD7bD9kS/fkFldOWdocdkjzvXglMaOAI1ndQhcbjdlD3g
         LROlnG2IbP4tfklaL+wuCSWqUlsaUmx+vNC4PaPGOhWeNFNTLdxlUNFGpKhCQdW7OIBG
         FupY6BjZHXGYvOFIYr/I9efiWen10MKdiXiG+QklQnByITh5Pd20u2d7GhcQw314WlnK
         rkDUCLpDVPfsVpRchFZNzBETBT+73MLJ4ThEz7AfRrAHsYJPdqhkSZAHbkkUKrfAcvrX
         O8JEPZvA5PhQBaUOag9PCT037h/w9l+vk9he6HjHlxgL0JVqzIsXgIRPWeaG5C7w1UA+
         NNuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=95e0Mv0fzTKoZaFeL4la+K83s4mjby+mfcJYCUq+2is=;
        b=RbHxMoKxfqqQCC/pdPHdTtuT8bBfd5QRhr0wzFCrRTL52cIHn7oC5HvZF56RjshK7K
         l74D5oGwyrOek7L6WQRSpsnXvC90BeqxfyhvE5lXJKeBf3YCBFxSm+qh+jRieN1Gp3Oh
         bOWe31xX6JxTr3qJBX/ml6xtWEn1kZW+wywdIoCzI73YUTIdX1w1Bhymd8cN2Yc/1zM9
         THCMsR0yFfDe9WhroxbP5OYDfew/HIbzubZ+xjwAAwAkgzSbtF/695QPyTFLTl5zBpuq
         A9EtUj0dRdC7HqhWSEVqi39s0vIbGF0V4dQNW6w1lS6OKrvqIU6rxWc5adA6BH34r2I1
         n/zg==
X-Gm-Message-State: ACrzQf1U/dE2on2pdzBWxcdeCXcacMXurR/aDkt/kJP4LDDVFPaVTPoC
        311cQG2aAxPzBMS9U5cOT2XxnxNC9pg=
X-Google-Smtp-Source: AMsMyM5OzQ7R5rAAgwDYZKZYyPp0ymdqbbFNJPqam2A51ufZLJmTbZSbQjMvW0qptJoBmtaZLqe+8w==
X-Received: by 2002:a05:620a:2496:b0:6ee:76ce:4b3e with SMTP id i22-20020a05620a249600b006ee76ce4b3emr681110qkn.370.1666984872513;
        Fri, 28 Oct 2022 12:21:12 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:309e:e758:a2c9:d68c])
        by smtp.gmail.com with ESMTPSA id ay19-20020a05620a179300b006cf9084f7d0sm3573960qkb.4.2022.10.28.12.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 12:21:12 -0700 (PDT)
Date:   Fri, 28 Oct 2022 12:21:11 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        shaozhengchao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Herbert <tom@herbertland.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net] kcm: fix a race condition in kcm_recvmsg()
Message-ID: <Y1wrp4pL4BmUL0LE@pop-os.localdomain>
References: <20221023023044.149357-1-xiyou.wangcong@gmail.com>
 <20221025160222.5902e899@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025160222.5902e899@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 04:02:22PM -0700, Jakub Kicinski wrote:
> On Sat, 22 Oct 2022 19:30:44 -0700 Cong Wang wrote:
> > +			spin_lock_bh(&mux->rx_lock);
> >  			KCM_STATS_INCR(kcm->stats.rx_msgs);
> >  			skb_unlink(skb, &sk->sk_receive_queue);
> > +			spin_unlock_bh(&mux->rx_lock);
> 
> Why not switch to __skb_unlink() at the same time?
> Abundance of caution?

What gain do we have? Since we have rx_lock, skb queue lock should never
be contended?

Thanks.
