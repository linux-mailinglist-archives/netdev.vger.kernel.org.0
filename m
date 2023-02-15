Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE2C697917
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 10:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjBOJgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 04:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjBOJgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 04:36:52 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC252100
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 01:36:50 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-52f1b1d08c2so129429267b3.5
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 01:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ry/pwDMP6a06bZZb+e750HV6pNAFAkXS08tqlUOls9E=;
        b=kNut+gixd+c31XydvPPw+L80vIdzH1bcHS8bDUVCG8TX3PXUmYN6D8vrtGAnZejlxB
         yAqZ0ccdjXNQeWdejeIhNurvTHKDTsaYbHTAWT5ZnqhpwAqa1n+FJQSXYvVIukQ7tSLa
         x4AfUyvW42HUJdaRe0z2brynpLdYT33yOEwpc2ULLhvLZzQ+SuylUl7Hv138EhnNbRKs
         gmagzRcxPKq69jKntdczh/dQg/8E/tuQiy4i7Ut4XFnq+DWeDJA9/XCNICd6Y9zx/Un8
         cUhAS9fGwrfwNvz02PcJLrM2jABh5gqLzMmxT25KyxzAS5APhVP2xydGp5AvMTgt241U
         8Ceg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ry/pwDMP6a06bZZb+e750HV6pNAFAkXS08tqlUOls9E=;
        b=tWOYYe0qVhJsP0p72Uc0gbwCyIrg2wpjSSZzRTFpXUxyPrKBK0lK28vapks2btWv3n
         PQ+2/pDNAhajZkt052l/iqP7keAXE+OZjmWFyQIQ1YaYbBsAsiuYp6FR8/GL4LzH4anS
         ql+u80mioSwQPeOZi+epdGhrrIU4lJbKqA/UL5sEUw3L31x5/SGRWIiXwyLQNkKRMHfF
         3sRtHJTdRY4Ae3ETACJr7/QrHRD0z4nY0wWMgZbxO0aN23KIZQEP2i7mDBcdWpUbSAaX
         mkUP4koUz+RBrCsLQqBlFJBD/JQx2VJ4yUCsON/U6veXG+ZwGcXyGja3J9RaNKkbilKE
         6kkw==
X-Gm-Message-State: AO0yUKWJ/hKywxh/eAt0GtrzYZa2d0fL1xsc0WSI5UfTf7Xb1cNP8oEG
        r5zHBGoCoqwq37cL6NAnK3525xAF7ERGqbaCCLixz8wlVrPl2+lDQRM=
X-Google-Smtp-Source: AK7set/Rvvfut1Z+olo6bGMEOxqde9qIih8EczCCujOTs/yxLfJFhkzPyiiTfHNQSXEWjksujDZNi4oW4wTjXsY96yE=
X-Received: by 2002:a81:6555:0:b0:52e:ca4a:746b with SMTP id
 z82-20020a816555000000b0052eca4a746bmr194305ywb.436.1676453809893; Wed, 15
 Feb 2023 01:36:49 -0800 (PST)
MIME-Version: 1.0
References: <20230214014729.648564-1-pctammela@mojatatu.com>
In-Reply-To: <20230214014729.648564-1-pctammela@mojatatu.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Feb 2023 10:36:38 +0100
Message-ID: <CANn89iKbvzS0VHa2oxrNQ5MgD1Sv_2wznYrjr+kc3Xq6X-npwA@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: tcindex: search key must be 16 bits
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
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

On Tue, Feb 14, 2023 at 2:47 AM Pedro Tammela <pctammela@mojatatu.com> wrote:
>
> Syzkaller found an issue where a handle greater than 16 bits would trigger
> a null-ptr-deref in the imperfect hash area update.
>
>
> Fixes: ee059170b1f7 ("net/sched: tcindex: update imperfect hash filters respecting rcu")
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>

> ---
>  net/sched/cls_tcindex.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> index ba7f22a49..6640e75ea 100644
> --- a/net/sched/cls_tcindex.c
> +++ b/net/sched/cls_tcindex.c
> @@ -503,7 +503,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>                 /* lookup the filter, guaranteed to exist */
>                 for (cf = rcu_dereference_bh_rtnl(*fp); cf;
>                      fp = &cf->next, cf = rcu_dereference_bh_rtnl(*fp))
> -                       if (cf->key == handle)
> +                       if (cf->key == (u16)handle)
>                                 break;
>
>                 f->next = cf->next;
> --
> 2.34.1
>
