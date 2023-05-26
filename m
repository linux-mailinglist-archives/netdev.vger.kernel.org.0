Return-Path: <netdev+bounces-5828-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27BF0713044
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 01:15:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82AB91C210C0
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 23:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C389F2D251;
	Fri, 26 May 2023 23:15:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26AF15B7
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 23:15:23 +0000 (UTC)
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3AB13A
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:15:22 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1ae3ed1b08eso12742865ad.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685142921; x=1687734921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R9G/lyk6634/TxL0f2L7CcMKKgi9hjj1JSgK9DVwIKs=;
        b=P4nCDlXcfWQYk6p8TaYzogC+0MyUktAf9vAviAsQ+Mk1/2GHjdSEruCQizA9tlN28V
         o4azsrtL85ZrPGFMFTiKZ6gVYLUYkhgWBuTv5mO49EtxpAtOEsuEag+w0lUQlIvoYtSR
         MQd5+0FJ/l5KuOCPzCIpg+6d6EEOG9AgbAgsWAlJqs8cru5RzBDo5fazqTFu4dCd5LRy
         pFxMkg5nlT7b3YpJ/SFbLLKBg9L2ebL0f2nREudsyUynCZpZruSjFInPo8ZdrXnpL5Tf
         Pk02oNbqc1fkfOuoMLRARiIRnqs8JmqNixNhFB0laD3LaN1Jiql9A57ZnKF++LR/HmKK
         1Kbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685142921; x=1687734921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R9G/lyk6634/TxL0f2L7CcMKKgi9hjj1JSgK9DVwIKs=;
        b=Wx6OVLy9XPWM31zjz4+0dGzIqkC10dN8gr2FuQMd9VdaEOBaGwWyj6C1mnd4hs6v9h
         zgC0SbqZKmw3mgN12Y71EcM5bHyJlt9CgVmIOocp0u8o2HX+TytT27iGxcUKxacEiV+M
         BnhlGRaeXFNf3Aa5c0cLFrAYLjUyffdmlvPXpgojuokiNEdISpk7dK8on2fXaIeJ7dDZ
         8WPfi4Qx5cjH9Nnho0SWyUUPYdX1BWan0F7enQIjUpBHZbBpmM295wpoYwJbWxMMIQNh
         j1gsltvt35oaX3s7Jr+NiOydokEXcu0m3w5ReHaSImyhN8bU0HNKQiAp+IbNGFU6H8pl
         7AcQ==
X-Gm-Message-State: AC+VfDxO49l3QmXal8VVtDgWNehlVSp+mhQqkcarqbwv6KBvOvlgie4W
	cJOqJSjruHLWWpJRe2y2JwhZnusAyR9crrdzw8A5ZQ==
X-Google-Smtp-Source: ACHHUZ7ZnZhA1rbJwczkYbg08L2IGmNiu8FqOqkHli0tCAb7qJLrFrGLXvMCymCi43PZZynKRYWAH+hHbxMgb+ZTM6E=
X-Received: by 2002:a17:903:2448:b0:1a1:bf22:2b6e with SMTP id
 l8-20020a170903244800b001a1bf222b6emr4433171pls.43.1685142921309; Fri, 26 May
 2023 16:15:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526220653.65538-1-kuba@kernel.org>
In-Reply-To: <20230526220653.65538-1-kuba@kernel.org>
From: Stanislav Fomichev <sdf@google.com>
Date: Fri, 26 May 2023 16:15:10 -0700
Message-ID: <CAKH8qBtTDi+0dgrn=OfCDrbVSAKZN0ktcnSddS=sV518R-dx-w@mail.gmail.com>
Subject: Re: [PATCH net] netlink: specs: correct types of legacy arrays
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com, 
	pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 3:07=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> ethtool has some attrs which dump multiple scalars into
> an attribute. The spec currently expects one attr per entry.
>
> Fixes: a353318ebf24 ("tools: ynl: populate most of the ethtool spec")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Stanislav Fomichev <sdf@google.com>

> ---
> CC: sdf@google.com
> ---
>  Documentation/netlink/specs/ethtool.yaml | 32 ++++++------------------
>  1 file changed, 8 insertions(+), 24 deletions(-)
>
> diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/net=
link/specs/ethtool.yaml
> index 129f413ea349..3abc576ff797 100644
> --- a/Documentation/netlink/specs/ethtool.yaml
> +++ b/Documentation/netlink/specs/ethtool.yaml
> @@ -60,22 +60,6 @@ doc: Partial family for Ethtool Netlink.
>          type: nest
>          nested-attributes: bitset-bits
>
> -  -
> -    name: u64-array
> -    attributes:
> -      -
> -        name: u64
> -        type: nest
> -        multi-attr: true
> -        nested-attributes: u64
> -  -
> -    name: s32-array
> -    attributes:
> -      -
> -        name: s32
> -        type: nest
> -        multi-attr: true
> -        nested-attributes: s32
>    -
>      name: string
>      attributes:
> @@ -705,16 +689,16 @@ doc: Partial family for Ethtool Netlink.
>          type: u8
>        -
>          name: corrected
> -        type: nest
> -        nested-attributes: u64-array
> +        type: binary
> +        sub-type: u64
>        -
>          name: uncorr
> -        type: nest
> -        nested-attributes: u64-array
> +        type: binary
> +        sub-type: u64
>        -
>          name: corr-bits
> -        type: nest
> -        nested-attributes: u64-array
> +        type: binary
> +        sub-type: u64
>    -
>      name: fec
>      attributes:
> @@ -827,8 +811,8 @@ doc: Partial family for Ethtool Netlink.
>          type: u32
>        -
>          name: index
> -        type: nest
> -        nested-attributes: s32-array
> +        type: binary
> +        sub-type: s32
>    -
>      name: module
>      attributes:
> --
> 2.40.1
>

