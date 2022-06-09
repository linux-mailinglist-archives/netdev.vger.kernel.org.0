Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1A854504C
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241025AbiFIPL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236467AbiFIPL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:11:27 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04D7279E68
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 08:11:26 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id k5-20020a17090a404500b001e8875e6242so10522465pjg.5
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 08:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yU2liZBb1/R9zzlFduk1rfGjpCANCCvi9sD6MMV0JfM=;
        b=Q65ZJVoqNYl7ZmVhFsqtWLaqSnU21vy37feUhBivrwZjZTuPmACfsvRdWorG0fIgmn
         fjfYmdHEmM8zZ5B6Ylq664ga0I1OPChx3JrpWNRUn8N3UXnZ5wuFtUsmct7RPjq3CkZz
         6zcODL23pilG10PEKeXxkfqvSepvDit2qzlY+ymveJZqPFderWhFxT2ZEqh/OHsWNZ6n
         b5unLl3ZBk7SMwfq0HPaQMIO99Fw7BxTWeDJwyyB3zn4cZFcQncczW2DswcmEgtUIF6S
         r+r3EJVwqheFkfCmdPyQL3PBB+hiWNVN9D2l3pJzl63oBbYW2u+/eCooObenZWftyOa/
         yUAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yU2liZBb1/R9zzlFduk1rfGjpCANCCvi9sD6MMV0JfM=;
        b=U/iH2qFWyU+wkuwOrA4Xg2r/74LotoviWomuVqFMNY8GYMBxd5Wf3HNVFyhyogqdpw
         IZMbk2lXBVIVpJa5VZNrKPY+uT0pPDqd5J4aNrxATwXL7+zc8xaR0UsEcdNx+ki8fO52
         r3CQQvcPqhialmbF3NE9xHpxSuangbYUHq/pIKsi3qgdR8LPsMWMLBA4RDSUmy5vkLSE
         7kcaHzs+DpD5bWz+29PG6BCWk/eF898oB55YubjkgPfHO7tjCpKDEgHrnkna/vVGKxjk
         tJAJ57/FXoTxGviEvGmfuhz3CwEVkQUCSQaS6PWmMaGI4NKxZPMN45sLTQ3T0AKjTjzZ
         STFg==
X-Gm-Message-State: AOAM5301U15eAUa5jg9605yIavduJdfOPr71h6iKu43vGyj/b5IVLJUM
        8AyS6YZMuWc6tNEtcC6yVVcWTYi1wM2RLkqI2Ww5Jw==
X-Google-Smtp-Source: ABdhPJzLaOQLIHZTxI3HE3yWNOJwXDi/cV7ccWABoEtlr6JCMQNvWt0GjE1jj7l/eKHbHX0NZcoFo0o3+426rNUPoak=
X-Received: by 2002:a17:903:2cb:b0:14f:4fb6:2fb0 with SMTP id
 s11-20020a17090302cb00b0014f4fb62fb0mr39343698plk.172.1654787486109; Thu, 09
 Jun 2022 08:11:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com> <20220609063412.2205738-4-eric.dumazet@gmail.com>
In-Reply-To: <20220609063412.2205738-4-eric.dumazet@gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 9 Jun 2022 08:11:15 -0700
Message-ID: <CALvZod5pfJgcg0C=56aYpOe0KLfqoLNfoqv_=Eohd01=ZGqV-w@mail.gmail.com>
Subject: Re: [PATCH net-next 3/7] net: add per_cpu_fw_alloc field to struct proto
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 11:34 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Each protocol having a ->memory_allocated pointer gets a corresponding
> per-cpu reserve, that following patches will use.
>
> Instead of having reserved bytes per socket,
> we want to have per-cpu reserves.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
