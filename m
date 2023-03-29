Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D66C6CF141
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 19:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjC2Rl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 13:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2Rl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 13:41:26 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD5B4EC8
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 10:41:24 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id y35so9757649pgl.4
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 10:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680111684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0HLyYeKV3If5cAiJw/VAQ1aNDVNCtxxtUuMyZtuuZJs=;
        b=nQ50QFq2oQaeue7g99fWt3LYzim4DoP351259h+OjISIxFL0HSrYifEKZzXFuCp4kN
         zTW0fp74XQOcA+AdBe1zlS2XRP/dwwYuBxzYxeW0v82hYny2ieOa/OyagiJ5Ywv89bio
         XrdEWRYp4ly32ewX9Idj0Uco/qe5sPNgwQrJsvpE7biD19aa18AZbECJz9fxhUpVAIiF
         nNQb6rHy3NeYphBgnwH8GrUpjunTe2C903BYSgRvhfydQv993BSE1QofQ1mkyzJRL7Pp
         UmpH7UsQrajnVeY0Z6lmWgkUoPG6XgfuOxZxvkujKcRJ4dOrGb/yFEBixEW/+jkrPEZ5
         MTcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680111684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0HLyYeKV3If5cAiJw/VAQ1aNDVNCtxxtUuMyZtuuZJs=;
        b=KIXHUPGeLORgx7/1TvM0VYbR8dirNoZJoo/co+QR/9Axqs3Jmlwg74T8T5JHb2QmYH
         yU5FGQ/dTb0CUwLW3CC1sIwIdqS03QKn2cyzGbTbgdfujM3N95Os5y7IZ9mQQ1PR4s/T
         jPrb895BirvNrb+I9NcHJLSld5SSoBiD9H28shJWwo00MJ1ElnLMVOjC+504ZQohvfd+
         YkY4Ko9nq11Xw2NBkgxtOKFP9PJuang2Ml0UjU+k8oaUH9/6KJcwjyio1JmPEHfAthCH
         mFvoem4lWU7pewLfca0HMVU4Ru9d8aPn8C5hqqedN5Phxdvy0yWuJfV37nCm6tJrOmUT
         kxPA==
X-Gm-Message-State: AAQBX9fxBxM2S3q6iEBv84sTCmlOkE7uv2DTeGhCFxd4tj4UvonNw+bu
        J22ZhGwEDGe+6HxgrQ7liBfrPwFVB8XbRuv4Hp3tmg==
X-Google-Smtp-Source: AKy350abXbUxEEXq3i9xDxZykzGOBVliqLi4/3uqla2IzGu82Yr8XzrqWZiHLqLlPTBfgnN87bOKeaoqYkUT7RT3ee4=
X-Received: by 2002:a05:6a00:894:b0:606:a4bd:8dde with SMTP id
 q20-20020a056a00089400b00606a4bd8ddemr10983778pfj.4.1680111684131; Wed, 29
 Mar 2023 10:41:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230329-net-ethernet-ti-wformat-v1-1-83d0f799b553@kernel.org> <CAKwvOdmcpESfN-9X2pzuxyj5q0wkH=kFwhaAhbaEJHwatyQLQA@mail.gmail.com>
In-Reply-To: <CAKwvOdmcpESfN-9X2pzuxyj5q0wkH=kFwhaAhbaEJHwatyQLQA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 29 Mar 2023 10:41:13 -0700
Message-ID: <CAKwvOdk0wgGrMLrebTcHU078Kjtgb_xR3ghnEgQeS3PxgxNzag@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ethernet: ti: Fix format specifier in netcp_create_interface()
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, trix@redhat.com, razor@blackwall.org,
        kerneljasonxing@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 10:10=E2=80=AFAM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Because integer literals in C are signed, the cast is necessary to
> avoid the format specifier from warning about the wrong signedness.
> It would be preferable to have a `U` suffix on the literal value, then
> the cast would be unnecessary.
>
> Untested:
> ```
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 494a23a976b0..67cb6bfc4056 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -349,7 +349,7 @@ struct sk_buff;
>  # define CONFIG_MAX_SKB_FRAGS 17
>  #endif
>
> -#define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
> +#define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS ## U

Or rather this trick.
https://godbolt.org/z/81aPxf39b
I forget what that's called (it's not xmacros); we definitely have a
macro for that in the kernel.

--=20
Thanks,
~Nick Desaulniers
