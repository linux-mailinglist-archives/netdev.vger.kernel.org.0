Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6459251A07A
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 15:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbiEDNN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 09:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiEDNNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 09:13:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C3402E9DF
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 06:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651669788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rFg6Pcf9hLC/bvNHZtgNSUoCpWVM5fZPOHRggK9KPBY=;
        b=JAfUtknEfYix2Ejnb+z5N26AN7Nzrq+nYdV27a7XeaC6eYdCOusyDbrx7qjQnA2puHp3ME
        MiM0hQW22BEk+wM2GyscXyJ7z+NdGP7J7rYodBtWS+p5vyzK8BjoUVLhVzNJ0WfcRziSH1
        SB1WB46NTYVV3QC0TPu2Ifn82gnemrk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-NYCf7VTGNx2HSeta3e3sAg-1; Wed, 04 May 2022 09:09:47 -0400
X-MC-Unique: NYCf7VTGNx2HSeta3e3sAg-1
Received: by mail-wr1-f70.google.com with SMTP id u26-20020adfb21a000000b0020ac48a9aa4so354033wra.5
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 06:09:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rFg6Pcf9hLC/bvNHZtgNSUoCpWVM5fZPOHRggK9KPBY=;
        b=cjvssP1PvCSuF8eGzXvZWWECzb5yM7SOTnPtX3nvFUH49oekEkjYIP8ZqZ6cHp4K8n
         Cq+vvTiji7GOdIpJN0sO6YdHW61bt3hr9fhxKhH5t+ivz581E2zdPrt/7PKXNVz0zRgi
         +eZBipqddgW+HfgjNmToAj5rpxr3Ihq4GMqEVNHiW78cnfOD4aCca6uasgL1FQ9eE0/w
         oEfFp3m6up2+MOMEH48yeW2MFQ31Ggo8ulVbMC7+06Iu6QVjNbzAupt8WRVoitTWoeLQ
         4MKUV7chkjSddOhnezv/xUcwiHj1vKObPN02tBevKx62TIyeSX1X5/zP/pdsaxfz9mLX
         S76w==
X-Gm-Message-State: AOAM533r1y4fO3x7Bn9tGrW8UUbtl5bxlVE2Fbaz+Bn7iP8eeZYuAve9
        u8qnfz816TQU2qdgP6dhQ03Uxv59RKc9qFF8YyipB4aJuT86b1hjYEVyjbP+aSm/sT5zfVFnYKS
        4/nsPMOO9xDRk2cyj
X-Received: by 2002:adf:eacf:0:b0:20a:c8c4:ac51 with SMTP id o15-20020adfeacf000000b0020ac8c4ac51mr16624116wrn.510.1651669785760;
        Wed, 04 May 2022 06:09:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfSUbwPLB6puSaYMJt/utbnn7soTRITSSpskar0giAb7st7IVHKLxkG9G6bKW9v7swgHwQwg==
X-Received: by 2002:adf:eacf:0:b0:20a:c8c4:ac51 with SMTP id o15-20020adfeacf000000b0020ac8c4ac51mr16624102wrn.510.1651669785550;
        Wed, 04 May 2022 06:09:45 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-66.dyn.eolo.it. [146.241.115.66])
        by smtp.gmail.com with ESMTPSA id c17-20020a7bc011000000b003942a244f40sm3974352wmb.25.2022.05.04.06.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 06:09:44 -0700 (PDT)
Message-ID: <d3d068eda5ef2d1ab818f01d7d07fab901363446.camel@redhat.com>
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        patchwork-bot+netdevbpf@kernel.org
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-rdma <linux-rdma@vger.kernel.org>
Date:   Wed, 04 May 2022 15:09:43 +0200
In-Reply-To: <CANn89iLHihonbBUQWkd0mjJPUuYBLMVoLCsRswtXmGjU3NKL5w@mail.gmail.com>
References: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
         <165157801106.17866.6764782659491020080.git-patchwork-notify@kernel.org>
         <CANn89iLHihonbBUQWkd0mjJPUuYBLMVoLCsRswtXmGjU3NKL5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-03 at 14:17 -0700, Eric Dumazet wrote:
> On Tue, May 3, 2022 at 4:40 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
> > 
> > Hello:
> > 
> > This patch was applied to netdev/net.git (master)
> > by Paolo Abeni <pabeni@redhat.com>:
> > 
> > On Mon, 2 May 2022 10:40:18 +0900 you wrote:
> > > syzbot is reporting use-after-free read in tcp_retransmit_timer() [1],
> > > for TCP socket used by RDS is accessing sock_net() without acquiring a
> > > refcount on net namespace. Since TCP's retransmission can happen after
> > > a process which created net namespace terminated, we need to explicitly
> > > acquire a refcount.
> > > 
> > > Link: https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed [1]
> > > Reported-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> > > Fixes: 26abe14379f8e2fa ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
> > > Fixes: 8a68173691f03661 ("net: sk_clone_lock() should only do get_net() if the parent is not a kernel socket")
> > > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > > Tested-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> > > 
> > > [...]
> > 
> > Here is the summary with links:
> >   - [v2] net: rds: acquire refcount on TCP sockets
> >     https://git.kernel.org/netdev/net/c/3a58f13a881e
> > 
> > You are awesome, thank you!
> > --
> > Deet-doot-dot, I am a bot.
> > https://korg.docs.kernel.org/patchwork/pwbot.html
> > 
> > 
> 
> I think we merged this patch too soon.

My fault.


> My question is : What prevents rds_tcp_conn_path_connect(), and thus
> rds_tcp_tune() to be called
> after the netns refcount already reached 0 ?
> 
> I guess we can wait for next syzbot report, but I think that get_net()
> should be replaced
> by maybe_get_net()
> 
Should we revert this patch before the next pull request, if a suitable
incremental fix is not available by then?

It looks like the window of opportunity for the race is roughly the
same?

Thanks!

Paolo

