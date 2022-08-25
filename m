Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8765A18AB
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240358AbiHYSUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236695AbiHYSUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:20:02 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEE326D1
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:20:00 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id m3so23628346lfg.10
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=LzcSMU79flsCFGsYwPA8jm006j9ntJHVrXRums+x4hg=;
        b=SYv3Q3AaGa03fEqdwIrUan3UK8SVmw9Z+8W0B7f1Bj2B8+vTNPtKhvy5T89n7XvozG
         NDgrl5LlirpCD9r3IS2kZBXYAE8dV6QP7j2D5koQYtr3nUg9jAbPihRKFqrhn5RwEcp7
         BZd5umqi6jfrO6Cx8Bgf7w4lG0lyQa4YV0Q/DkOpfm5hmLCPyrSHeF6USOHTKnb82axs
         UbqNS0wIZUyhVt9oIeAumA1MQ798CrLeXJrUDk7NUqGzWAQI6IfNL7t9zG0bFBciPxy1
         +Yq1LnHzDtJzsiTKE4JhDpzYlvm+dVVQN2UNFpkKFOEdD6wZ+Y0MP9sxzTcXJXAlNHDb
         gwcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=LzcSMU79flsCFGsYwPA8jm006j9ntJHVrXRums+x4hg=;
        b=EVlzEyjC8zMqvyv9EDES4RCyEx86SX2/AtlGan6JyiqYpwIQgg1tN2ZPaEBrPPhKDG
         OX1Lmi5+7LKu1jPbZS+4hpCmXR71aHMb2OSC3W714vtMpJJI4L4BGH7pdR0zjE2vwhFS
         0AA/++qlZ3XMUDgJpyGXzKyvNC2Vlto0+ObeGN4xk1MnG1K/D+6PVvYmcUFbPHbiFLgd
         ZrO5jPBWBChUlTo476ztqYWztk1N88TBlXo5huHF5jcUjaHpeHqKyjgaGWNA2L61HR3V
         X4x8sFjuzsg/p6K32g+jMJjAlDpSzGDL8dJiA4U+lgSNnkTwaEuovShW4H8dijx8kNzr
         aGSw==
X-Gm-Message-State: ACgBeo1MBuGDzKxzIEDr5+kXLtvJt7uZwmsf440sV9NqrVFgy9UsCK65
        2QhBepyz+zFatvmg66pOJZhhTjY3hvYosVfTu1RZ5g==
X-Google-Smtp-Source: AA6agR4DcOai/4bkoqgXsxN2AlpaLedM35dK8SSB6wQ+78buD9y4OrDy89oUbjQQpHxrnsnUIN+AQrnsjuDafmd1nR8=
X-Received: by 2002:a05:6512:158b:b0:48b:38:cff8 with SMTP id
 bp11-20020a056512158b00b0048b0038cff8mr1399470lfb.100.1661451598905; Thu, 25
 Aug 2022 11:19:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220825180607.2707947-1-nathan@kernel.org>
In-Reply-To: <20220825180607.2707947-1-nathan@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 25 Aug 2022 11:19:47 -0700
Message-ID: <CAKwvOdmNCT+USwe5Lui27Oa1jfNyy3NwP3jW=Q7JJi1R5ibRnw@mail.gmail.com>
Subject: Re: [PATCH net-next] net/mlx5e: Do not use err uninitialized in mlx5e_rep_add_meta_tunnel_rule()
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Tom Rix <trix@redhat.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        patches@lists.linux.dev
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

On Thu, Aug 25, 2022 at 11:06 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Clang warns:
>
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:481:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>           if (IS_ERR(flow_rule)) {
>               ^~~~~~~~~~~~~~~~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:489:9: note: uninitialized use occurs here
>           return err;
>                 ^~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:481:2: note: remove the 'if' if its condition is always true
>           if (IS_ERR(flow_rule)) {
>           ^~~~~~~~~~~~~~~~~~~~~~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:474:9: note: initialize the variable 'err' to silence this warning
>           int err;
>                 ^
>                   = 0
>   1 error generated.
>
> There is little reason to have the 'goto + error variable' construct in
> this function. Get rid of it and just return the PTR_ERR value in the if
> statement and 0 at the end.
>
> Fixes: 430e2d5e2a98 ("net/mlx5: E-Switch, Move send to vport meta rule creation")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1695
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the fix!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index c8617a62e542..a977804137a8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -471,22 +471,18 @@ mlx5e_rep_add_meta_tunnel_rule(struct mlx5e_priv *priv)
>         struct mlx5_eswitch_rep *rep = rpriv->rep;
>         struct mlx5_flow_handle *flow_rule;
>         struct mlx5_flow_group *g;
> -       int err;
>
>         g = esw->fdb_table.offloads.send_to_vport_meta_grp;
>         if (!g)
>                 return 0;
>
>         flow_rule = mlx5_eswitch_add_send_to_vport_meta_rule(esw, rep->vport);
> -       if (IS_ERR(flow_rule)) {
> -               err = PTR_ERR(flow_rule);
> -               goto out;
> -       }
> +       if (IS_ERR(flow_rule))
> +               return PTR_ERR(flow_rule);
>
>         rpriv->send_to_vport_meta_rule = flow_rule;
>
> -out:
> -       return err;
> +       return 0;
>  }
>
>  static void
>
> base-commit: c19d893fbf3f2f8fa864ae39652c7fee939edde2
> --
> 2.37.2
>


-- 
Thanks,
~Nick Desaulniers
