Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7A25788AE
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbiGRRne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiGRRnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:43:32 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55532CC88
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:43:31 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id m8so2896489edd.9
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b+gmIONhiXxkz2QJGmvVZScE/IgGuCeLYBs+pSoO9pY=;
        b=RGPUIhfoMFuO8Nz6WNTx5S6fXzIrWaujiJ8+ZVTxL0UMEI1w8YjhuXZASMY/1PkOEf
         wrDuh+xkXq2veGdBhkHADlnD4KK3QudpUdUqUjmMlq/vBQKFdgpt1N1bySIrbFRiMqRp
         J4wVHKuRL13W3MVrXhJqtIAOdKm6cxzUE9NHXqi9vJYyBI2WiBMGPxXA2P5dO9iazDwA
         F3iog7f555bBhhktMA8gyzP9Wz3NVFS3Q93ZkRP9hbfl5Loq/B/du4XHpXhcMQbQmvMt
         ZAa/A57EtA/Hz2P8PJkHCI5B/Sf4YdG/SG+J/fMPknvUi8mjM8GKfDPYvzEdQc+XdD97
         oVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b+gmIONhiXxkz2QJGmvVZScE/IgGuCeLYBs+pSoO9pY=;
        b=WdGKWyuHBOYISUS/D8odMIlgtjKoQ77vmMz6EyiaGWGMv72sD56vpOSWXqswLcTLUF
         Zt/Ikh3wsGMOhDoa65WbyK0HCZy7M0nptBWN69FOzN7jcZ1JfWi1RlkD2olzsMZtz//C
         Vc7TcRHU1t2DQ9NRO8qmWEFO65ogRjBQxVc+aoASGnUZH0cBFaUt93yYbj+2nSWRkHrH
         MEWeh4tYIlQMhYPLL+fDTTfKZ4njGACnSLaos+b/fn2pQu6ao3znxwqJFORUQ6KJrlZq
         NyABhW9mFr9U9edIllXpuJ2gdnntdbVXDMxrBfbHU+TDmnp/xaSt93L7ZShrghw0M2D+
         n+5g==
X-Gm-Message-State: AJIora/ETci8lqhtO6dLVKPADUEeCa/MQg5EblUzEX/FgtcjKLL+L3lH
        5PlSUuw6ZFHlKmIwB5b8UadD8y9MaapW+J1kYPIMFg==
X-Google-Smtp-Source: AGRyM1vE21LyXnyQ/OrPc3rCfEUlrSagjLX1JjDE56Zzri+Os/07JIqlU6uqq/K10QqFVfs4y8jvMIl1/dbEDe2aMQs=
X-Received: by 2002:aa7:d9ce:0:b0:43a:6758:7652 with SMTP id
 v14-20020aa7d9ce000000b0043a67587652mr38817237eds.351.1658166210314; Mon, 18
 Jul 2022 10:43:30 -0700 (PDT)
MIME-Version: 1.0
References: <Ys3DwnYiF9eDwr2T@dev-arch.thelio-3990X> <20220712204900.660569-1-justinstitt@google.com>
In-Reply-To: <20220712204900.660569-1-justinstitt@google.com>
From:   Justin Stitt <justinstitt@google.com>
Date:   Mon, 18 Jul 2022 10:43:17 -0700
Message-ID: <CAFhGd8p2o45-mw50=4dPxmpKe5kZf2t_p=vpy7T5vZt3VUkYiA@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: xt_TPROXY: remove pr_debug invocations
To:     nathan@kernel.org
Cc:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, trix@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Any chance a maintainer could take a look at this patch? I am trying
to get it through this cycle and we are so close to enabling the
-Wformat option for Clang. There's only a handful of patches remaining
until the patch enabling this warning can be sent!
