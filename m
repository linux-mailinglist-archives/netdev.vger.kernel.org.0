Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1E25FE602
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 01:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiJMX65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 19:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJMX64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 19:58:56 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8B0196098;
        Thu, 13 Oct 2022 16:58:56 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id mx8so2304932qvb.8;
        Thu, 13 Oct 2022 16:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MiDM1Ur9wKVH8uTJRLiD3vd+Ahk5i+FlC9x1RK17rGY=;
        b=mwpQUOraeclVwkWl8hPqkPrO8q/ZMxbafqOOH10hnWZcgccZAxGypSzjYtNNM015dI
         2vuWhDBuMa257ElQBFlP0LpaVgIrUwQWH5ld7zch4hVQ0uI1GOQPaZNc0KA2HGSpvQWL
         QuzaoMg4NiJS+7+5RAe6rYjwPFJ/+ktMdAbFLxzaSgtAMOF5/nd/NIKU6Q6caPg3sSe8
         u/Qm683wBScjolQvwLbBc4C5iysUdZ8SjaK7WJmB0yBtSE4hsqOvlgRXsGUP9IHYjmsa
         iu1x7qmp+3sEHAZ6fWrhtghlYjRDg5W/w8ySFeisBtFKkSrGVWRC09jnc/VoefRuUsCY
         SC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MiDM1Ur9wKVH8uTJRLiD3vd+Ahk5i+FlC9x1RK17rGY=;
        b=AmlD5aoVg04/ufpG0DVJzkCDYweqBFNyuETs/+c3gfGF6/aVdmzsuId2n4laL2N1lu
         A23xJ3vFBNLN12oI10xtAOFJb4dFRIn34toZnsa3vhogVI8FMDhNEysIhGd5psLCJwEB
         AmvhUqCX0pkIX9FSVFAh+raqKleOKQp6Kl+3wKtZYsk55eNFSMab2aHtJL1+2l6QesOV
         uLtDUzbLL8B3di/x64PQlmdhsr6LBuOodoA6hyTbk/jflpmpsfEwezpsdrA6olm9Twu+
         casFAj1CCRyr18Vbk1mwJ50q84hvsjfLbYkoODIwFCnG5Gce1QFaMe6Nzr0pf6Sy2ULi
         hzfw==
X-Gm-Message-State: ACrzQf2ks3BGi0M1lBSvn6VZrr0Miay5R3/yBomLL5fHBSnRgtKAb56F
        FMRhV/ZP49/FCH5eL5UMyQ==
X-Google-Smtp-Source: AMsMyM5YKoSnH55Y4igr5ka5BRBfvi0TKqgr7wm7aiLrZU906iYVxxSyAfQ3K3hRTTdO9pH6KpXm9g==
X-Received: by 2002:a05:6214:1c4d:b0:4b1:7a21:e26f with SMTP id if13-20020a0562141c4d00b004b17a21e26fmr2175619qvb.81.1665705535337;
        Thu, 13 Oct 2022 16:58:55 -0700 (PDT)
Received: from bytedance ([130.44.212.155])
        by smtp.gmail.com with ESMTPSA id o16-20020a05620a2a1000b006e6a7c2a269sm1137419qkp.22.2022.10.13.16.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 16:58:54 -0700 (PDT)
Date:   Thu, 13 Oct 2022 16:58:51 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4] net/sock: Introduce trace_sk_data_ready()
Message-ID: <20221013235851.GA29973@bytedance>
References: <20221011195856.13691-1-yepeilin.cs@gmail.com>
 <20221012232121.27374-1-yepeilin.cs@gmail.com>
 <Y0fdwSkyoFI2SDuw@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0fdwSkyoFI2SDuw@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 12:43:29PM +0300, Leon Romanovsky wrote:
> On Wed, Oct 12, 2022 at 04:21:21PM -0700, Peilin Ye wrote:
> > From: Peilin Ye <peilin.ye@bytedance.com>
> > 
> > As suggested by Cong, introduce a tracepoint for all ->sk_data_ready()
> > callback implementations.  For example:
> > 
> > <...>
> >   ksoftirqd/0-16  [000] ..s..  99.784482: sk_data_ready: family=10 protocol=58 func=sock_def_readable
> >   ksoftirqd/0-16  [000] ..s..  99.784819: sk_data_ready: family=10 protocol=58 func=sock_def_readable
> > <...>
> > 
> > Suggested-by: Cong Wang <cong.wang@bytedance.com>
> > Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> > ---
> > changes since v3:
> >   - Avoid using __func__ everywhere (Leon Romanovsky)
> >   - No need to trace iscsi_target_sk_data_ready() (Leon Romanovsky)
> 
> I meant no need both trace point and debug print and suggested to remove
> debug print.

Ah, I see.  I will clean up redundant debug prints in
iscsi_target_sk_data_ready(), rds_tcp_listen_data_ready() and
rds_tcp_data_ready() in separate patches.

Thanks,
Peilin Ye

