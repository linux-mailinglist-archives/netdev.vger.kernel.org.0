Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2B5636364
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbiKWPZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235513AbiKWPZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:25:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EAA63B0
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669217045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W8COuTYzCMMUgyZ1K5b2bjOrRJxsKTmNhDCBqXX7KiI=;
        b=AyoHsLRkh+BQnURbgIQy0LuGboibIwoqVQ0tzF3KTMmxQetvJnJD6SUOGzCLDpoQEMa413
        lO8qS7VcMvXWXUNTI7/rxA2FUZiq7sPm4I1eMCOYZoR9i7mc+mVtpWki0E9n9v5zfCIZCn
        rhSYTbev4PMC9SH9dolQOjupR/t+xx4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-202-4YkuJuGSNaS_7ABWqCFLPA-1; Wed, 23 Nov 2022 10:24:04 -0500
X-MC-Unique: 4YkuJuGSNaS_7ABWqCFLPA-1
Received: by mail-wr1-f69.google.com with SMTP id e21-20020adfa455000000b00241daf5b9b2so2603515wra.18
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:24:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8COuTYzCMMUgyZ1K5b2bjOrRJxsKTmNhDCBqXX7KiI=;
        b=iOaAhQChkIkcSBYxlS4D6kRjoA9prqW8wwMZ/d6dt769NHLTIkxSqKFQI/mUyjoNUz
         YxnA7uVUmBZMl+bmxkZ3JudKHHSMkjqwaMxeHdkwyPiSpuMdPfW1urvjEHBIND+HVi5m
         2p5tpy2OAVjP9ahHbIf8yT8HW7DYd2FrVR+tIEdRvqjxdZgTGTZgfLPRHH2hXcWVdSOg
         Kbx6frg7w5NnW9KR8/+zlYrnqaB0BzzvXQfIiDoTfaDx2NBa3uAl5doZu7q4huRbehZS
         IvrnW8I0zaCkTrhunupRl6iA5k1YVD69RFntLO2BeD6wKURibZsGd8ktOSVZzAdg6YUM
         A7eQ==
X-Gm-Message-State: ANoB5pkxktvYFLdIkhzClE6rlCEYTGIZ+8SDnF7TkUJnWQWEOOAXrr+i
        XW+pnFMGkUJrQqiNl32TRk9ueyD3+61zFXYcjToS+VJGEbVAko5rsxBjHYa6PyUJYetmVyHvCQQ
        1lpuCeyCGB+bS3qmU
X-Received: by 2002:a7b:c8ce:0:b0:3c4:5806:104e with SMTP id f14-20020a7bc8ce000000b003c45806104emr20861891wml.42.1669217043520;
        Wed, 23 Nov 2022 07:24:03 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4YDuj5OG/pOhS4NWtl6cZGpgUr+Qbl+6eIl9klRKzP9v/Ge6u2pc9qVTWeVKQ6y2K3kVtgKQ==
X-Received: by 2002:a7b:c8ce:0:b0:3c4:5806:104e with SMTP id f14-20020a7bc8ce000000b003c45806104emr20861879wml.42.1669217043276;
        Wed, 23 Nov 2022 07:24:03 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id e19-20020a05600c219300b003c6bd12ac27sm2467566wme.37.2022.11.23.07.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 07:24:02 -0800 (PST)
Date:   Wed, 23 Nov 2022 16:24:00 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Parkin <tparkin@katalix.com>,
        syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com,
        syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com,
        syzbot+de987172bb74a381879b@syzkaller.appspotmail.com
Subject: Re: [PATCH net] l2tp: Don't sleep and disable BH under writer-side
 sk_callback_lock
Message-ID: <20221123152400.GA18177@pc-4.home>
References: <f8e54710-6889-5c27-2b3c-333537495ecd@I-love.SAKURA.ne.jp>
 <a850c224-f728-983c-45a0-96ebbaa943d7@I-love.SAKURA.ne.jp>
 <87wn7o7k7r.fsf@cloudflare.com>
 <ef09820a-ca97-0c50-e2d8-e1344137d473@I-love.SAKURA.ne.jp>
 <87fseb7vbm.fsf@cloudflare.com>
 <f2fdb53a-4727-278d-ac1b-d6dbdac8d307@I-love.SAKURA.ne.jp>
 <871qpvmfab.fsf@cloudflare.com>
 <a3b7d8cd-0c72-8e6b-78f2-71b92e70360f@I-love.SAKURA.ne.jp>
 <20221122141011.GA3303@pc-4.home>
 <c50bb326-7946-82b9-418a-95638818aa84@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c50bb326-7946-82b9-418a-95638818aa84@I-love.SAKURA.ne.jp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 11:28:45PM +0900, Tetsuo Handa wrote:
> On 2022/11/22 23:10, Guillaume Nault wrote:
> > User space uses this socket to send and receive L2TP control packets
> > (tunnel and session configuration, keep alive and tear down). Therefore
> > it absolutely needs to continue using this socket after the
> > registration phase.
> 
> Thank you for explanation.
> 
> >> If the userspace might continue using the socket, we would
> >>
> >>   create a new socket, copy required attributes (the source and destination addresses?) from
> >>   the socket fetched via sockfd_lookup(), and call replace_fd() like e.g. umh_pipe_setup() does
> >>
> >> inside l2tp_tunnel_register(). i-node number of the socket would change, but I assume that
> >> the process which called l2tp_tunnel_register() is not using that i-node number.
> >>
> >> Since the socket is a datagram socket, I think we can copy required attributes. But since
> >> I'm not familiar with networking code, I don't know what attributes need to be copied. Thus,
> >> I leave implementing it to netdev people.
> > 
> > That looks fragile to me. If the problem is that setup_udp_tunnel_sock()
> > can sleep, we can just drop the udp_tunnel_encap_enable() call from
> > setup_udp_tunnel_sock(), rename it __udp_tunnel_encap_enable() and make
> > make udp_tunnel_encap_enable() a wrapper around it that'd also call
> > udp_tunnel_encap_enable().
> > 
> 
> That's what I thought at https://lkml.kernel.org/r/c64284f4-2c2a-ecb9-a08e-9e49d49c720b@I-love.SAKURA.ne.jp .
> 
> But the problem is not that setup_udp_tunnel_sock() can sleep. The problem is that lockdep
> gets confused due to changing lockdep class after the socket is already published. We need
> to avoid calling lockdep_set_class_and_name() on a socket retrieved via sockfd_lookup().

This is a second problem. The problem of setting sk_user_data under
sk_callback_lock write protection (while still calling
udp_tunnel_encap_enable() from sleepable context) still remains.

For lockdep_set_class_and_name(), maybe we could store the necessary
socket information (addresses, ports and checksum configuration) in the
l2tp_tunnel structure, thus avoiding the need to read them from the
socket. This way, we could stop locking the user space socket in
l2tp_xmit_core() and drop the lockdep_set_class_and_name() call.
I think either you or Jakub proposed something like this in another
thread.

