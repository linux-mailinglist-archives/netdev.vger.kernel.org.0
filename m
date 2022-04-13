Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4904D50008F
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 23:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237577AbiDMVHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 17:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238843AbiDMVHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 17:07:39 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7557A47AFA
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 14:05:17 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2ebebe631ccso36335287b3.4
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 14:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ccI+qHhkThI+cU6dT6fPgygWM09e43jwyjb8CLy4aNA=;
        b=gYURlV6Q49viSYolksGcJ8zO66Km2AIuIyrMTX/ULWnWfxM6mndIbmr+MIbEOYHRZC
         FLFbiTQQcJB+zaUhivfA7Y6asGwirjjAVf+k9YZ6++mfK5w5Dlh0sZ6ntYAyEm3Z1CRa
         wRW/YNzyQU2+iVZFpqlBXPFWLsoc2pkTAYbGr2L7cZGg82a26nUHjdpocL6YiNZAPJec
         JM6ENRcraCFBo6dAkIekAJLDK9eCOrVqzMr2BOqe8CltClg7MCqvApgm2xKRod8IrH9n
         ERPEx2pYYzITnMut2HbPshMWBhl5fjAnbSVmw97eLdEc/1HInr+GnosR+m5HZBUiL65f
         ZxeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ccI+qHhkThI+cU6dT6fPgygWM09e43jwyjb8CLy4aNA=;
        b=nTOFENzDqsbbJy0qkJnn8nD6Ni9GP+Ln31J9KDE5A5xvJcIaJIkjQ+8DuyIUHJf7hz
         15FOhMYhe/+RQVqOP9UX/WjdJ/hxxCQJZCRHEAJkBux08Dv2Sph5nLGRHEcm32RmU/tg
         T/J/AQkAwKYB3ArmS29vzVKUYB9lKAPeQtC5HpbpHOKS2kSrboW9SD1nImr8uC3FCDh6
         e71Ymcmfs6GhKcW3A2EzvZlh/AdXyKcWgi8+a17VNczxB8K94XnZKgBcEBgsO5tUHDPk
         U0X6cB6wcoweQmBfXqIOb37K2QcTx+rIZqTbszy3eqAi/5O8PWtyWaWp1qMyP/7S3yLF
         LPPw==
X-Gm-Message-State: AOAM531BweyBHJWFGHQFyTdTBMEzplMQzD0Nz1+aqF8f80Pj1olzdIxI
        f2fHohsGs1Rjxxl+xV6rycZguoY4wXrQh1xocUsjIA==
X-Google-Smtp-Source: ABdhPJwrceOUcQhJRLBguV8i8XsmPX70+m9RxD3/OIe8X9RmCAB3pUcHUrlksseQfQ5DRPH0e+7fwW5UGOHcby7pKwA=
X-Received: by 2002:a81:5409:0:b0:2eb:fea4:a240 with SMTP id
 i9-20020a815409000000b002ebfea4a240mr696206ywb.47.1649883916328; Wed, 13 Apr
 2022 14:05:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220412135852.466386-1-atenart@kernel.org>
In-Reply-To: <20220412135852.466386-1-atenart@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 13 Apr 2022 14:05:05 -0700
Message-ID: <CANn89iJ4DYssEJofLX=LQd1RnTJ0AB8pf50wUnncXxpm+c=hFA@mail.gmail.com>
Subject: Re: [PATCH net] tun: annotate access to queue->trans_start
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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

On Tue, Apr 12, 2022 at 6:59 AM Antoine Tenart <atenart@kernel.org> wrote:
>
> Commit 5337824f4dc4 ("net: annotate accesses to queue->trans_start")
> introduced a new helper, txq_trans_cond_update, to update
> queue->trans_start using WRITE_ONCE. One snippet in drivers/net/tun.c
> was missed, as it was introduced roughly at the same time.
>

LGTM, thanks.
Reviewed-by: Eric Dumazet <edumazet@google.com>
