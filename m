Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2997621D2E
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 20:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiKHTpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 14:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiKHTpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 14:45:18 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEA4623A9
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 11:45:17 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-3691e040abaso143299647b3.9
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 11:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Fc+E4R+7cUUkGZ7PCWTXzs7Qw6DNz7myIIZni5DsKGA=;
        b=W3iVyMAEv6yM0MwYKqtNe8LFE1zTLITgCUiaeBDOnN2fMVHS6g5mYv8HOlTqZzcXMw
         Lw3T9nFq6959LF6sNHrSGGuhkbNxdxVLMDZZc/W7po/QN5YXD5oxkUUE+bHh1YedRjdf
         nm+jPnjBbj7LDMWsNxtL3oJLpeXiM+PSDF7wOD/U/HYu1OD09AOkULQI06GS+XQitYIB
         SXa6Ru9D5gdiB8kJ5SiQ34B3nnAMYZYvMuRK3HSohW4gKf1XUtew6YPmS47RuT5cQVq9
         FlxZt5IPZe5lzlCdBvQjKqYIz437feqS31P19I5VZh25IyhQvNs64d8IoJ6M1XJWXKOE
         LdPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fc+E4R+7cUUkGZ7PCWTXzs7Qw6DNz7myIIZni5DsKGA=;
        b=KzOa1J6y5MzIHqFVjAxWgSwnlkpCKshTytUAfVtyXItOHQ5FFIciEDfObg76QjLOXl
         pB9R2htBmhqATG9s5ySWMUWf2cqFeiL9b6rW5fePZIa9MjfLEZmkhQLNOCPj3eDFpiUZ
         NJogGTUn1gZfCu5iUjsmsNe0FWrwvRdJ8Vpnj3+MQW6qq98oa53jNhssPmCejfcXH53s
         Js8GPS1xTahO7fUiBSJWZd/K8p1+uQMYzqqlNjCnf0rKRFokPxpqFvJrbgzDimP2NpvA
         RJkgRTmjrWAIEqEMlAVa6NAgI6R9EmEKCj7mOknF82a8DHGs0iNFBtkY1XKIfCpXmJKC
         /8dQ==
X-Gm-Message-State: ACrzQf0seEF4kDnpRN0uiDnhKvdIzQwZrEpRGb5c3Xe6TLdDdwAlCaPD
        lwfG3RUZCdSvN6L1Ta5FVmRXzccLgqTi4aY74cLptA==
X-Google-Smtp-Source: AMsMyM52J1Oid9I1EA4rtfVCdMgQ5Vllun7h5FSwnQGoDgz16yFB/ite3eYJTUMpNfi0LhC3yKXnEXIJT7EFJO1rQjA=
X-Received: by 2002:a81:6084:0:b0:370:10fa:c4ff with SMTP id
 u126-20020a816084000000b0037010fac4ffmr55887180ywb.255.1667936716100; Tue, 08
 Nov 2022 11:45:16 -0800 (PST)
MIME-Version: 1.0
References: <20221108140614.12968-1-yuehaibing@huawei.com> <febe8f20-626a-02d6-c8ed-f0dcf6cd607f@gmail.com>
In-Reply-To: <febe8f20-626a-02d6-c8ed-f0dcf6cd607f@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 8 Nov 2022 11:45:04 -0800
Message-ID: <CANn89iKqm9=uyoymd9OvASjnazQVKVW1kwOxhpazxv_FGaVpFg@mail.gmail.com>
Subject: Re: [PATCH v2] net/mlx5e: Use kvfree() in mlx5e_accel_fs_tcp_create()
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     YueHaibing <yuehaibing@huawei.com>, borisp@nvidia.com,
        saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, lkayal@nvidia.com,
        tariqt@nvidia.com, markzhang@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 8, 2022 at 9:58 AM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>
>
>
> On 11/8/2022 4:06 PM, YueHaibing wrote:
> > 'accel_tcp' is allocted by kvzalloc(), which should freed by kvfree().
> >
> > Fixes: f52f2faee581 ("net/mlx5e: Introduce flow steering API")
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---
> > v2: fix the same issue in mlx5e_accel_fs_tcp_destroy() and a commit log typo
> > ---
> >   drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> > index 285d32d2fd08..d7c020f72401 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> > @@ -365,7 +365,7 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
> >       for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
> >               accel_fs_tcp_destroy_table(fs, i);
> >
> > -     kfree(accel_tcp);
> > +     kvfree(accel_tcp);
> >       mlx5e_fs_set_accel_tcp(fs, NULL);
> >   }
> >
> > @@ -397,7 +397,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
> >   err_destroy_tables:
> >       while (--i >= 0)
> >               accel_fs_tcp_destroy_table(fs, i);
> > -     kfree(accel_tcp);
> > +     kvfree(accel_tcp);
> >       mlx5e_fs_set_accel_tcp(fs, NULL);
> >       return err;
> >   }
>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>
> Thanks for your patch.

Although this structure is 64 bytes... Not sure why kvmalloc() has
been used for this small chunk.
