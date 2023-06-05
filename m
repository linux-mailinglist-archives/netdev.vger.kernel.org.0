Return-Path: <netdev+bounces-8242-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C9377233B5
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 01:37:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 502192812EA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57B0828C14;
	Mon,  5 Jun 2023 23:37:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA6624133
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 23:37:40 +0000 (UTC)
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE035EC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 16:37:38 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-62884fa0e53so31584326d6.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 16:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686008258; x=1688600258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yxwkcNqLoiNaWtXicU0tKhRpoSpS+lalx+6E8ONZP9s=;
        b=XI/cowU7t/vm7Xq1xzMxF5ev9t1aY4dotxwCZK5uOTfc6J15588LkGwYh9l4MOaVX/
         AkEAP+nlaEk1qQRcV5oWCxYyLkX+OA8VXncXfxLdtjOZiAwd7WxmjczieXvibrdbIzCF
         jk+sm70N4FUus5+BSy7onwL8dBy378fGQiBxzT4xHuFjkseET4uhNP6+UYc2c7LO808i
         O4gWlgJT0qFlhcEMSIqv8Sj6MqNUDPGUgf1ZQ38AgG01cGjZ+paHbxDHj3PpVkH9k9pF
         UoArVYT2VNAp/0GdPstV2qW27dPVgqq8x7vNc0ELq66qwZNI3S9YKItXxZlxiU0aGidg
         jHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686008258; x=1688600258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yxwkcNqLoiNaWtXicU0tKhRpoSpS+lalx+6E8ONZP9s=;
        b=Zaq/cSdT5MH9B2wWCBk3/lE2kicGr3GhjfXNcmuYMkQQwlipK1ySQROhXs/3sQcRje
         Xbq2Rv1WmeuktULM2OwGcRCgAj26DwIQW7MpaWRs/lpU/Esvu0C2PCVgsNJVC540b6xP
         27pE71MG5FLp31tldwQ39swnDQoV92RjGgunq+aexkOH98QNDeKNDnZLKLj9YZG5d2+Q
         ePHYmgdyv6nrG4Pwytw+b3smdVfSBmcKy3ABrIT8yvl4l6izAS7D7K6Xd8Fkz1zDClL3
         thWDKrRYi6N/CXslMaY4ivw8zFD32NcrOKq+MGwiY5WcE34IZR88QbJACokjSgPHPffA
         mC1Q==
X-Gm-Message-State: AC+VfDzedsPr13tlELbcNHcQel36jD4fFZSsBboujLeZ2P77KXdD3q+W
	TZHUzUV3dXBQpU88CF0BXVZEUeYRDVkb1wJnx+V8og==
X-Google-Smtp-Source: ACHHUZ7Zcjpwai/muD3wsuLdxGgNQcUj260+9/+2uJFXVFxzu9vMEl1lRH8zdjfHJFuiVw6Kw5mxGwMWa6JXzXQcFZ8=
X-Received: by 2002:a05:6214:d4f:b0:625:aa48:e629 with SMTP id
 15-20020a0562140d4f00b00625aa48e629mr379451qvr.57.1686008257867; Mon, 05 Jun
 2023 16:37:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230605233257.843977-1-kuba@kernel.org>
In-Reply-To: <20230605233257.843977-1-kuba@kernel.org>
From: Stanislav Fomichev <sdf@google.com>
Date: Mon, 5 Jun 2023 16:37:26 -0700
Message-ID: <CAKH8qBtgrQG-skeScctazy84VV5YL69t7G8gfNTiGFVyFUXLtg@mail.gmail.com>
Subject: Re: [PATCH net] netlink: specs: ethtool: fix random typos
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

On Mon, Jun 5, 2023 at 4:33=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> Working on the code gen for C reveals typos in the ethtool spec
> as the compiler tries to find the names in the existing uAPI
> header. Fix the mistakes.
>
> Fixes: a353318ebf24 ("tools: ynl: populate most of the ethtool spec")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Stanislav Fomichev <sdf@google.com>

Ooopsie, thanks!

> ---
> CC: sdf@google.com
> ---
>  Documentation/netlink/specs/ethtool.yaml | 32 ++++++++++++------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/net=
link/specs/ethtool.yaml
> index 3abc576ff797..4846345bade4 100644
> --- a/Documentation/netlink/specs/ethtool.yaml
> +++ b/Documentation/netlink/specs/ethtool.yaml
> @@ -223,7 +223,7 @@ doc: Partial family for Ethtool Netlink.
>          name: tx-min-frag-size
>          type: u32
>        -
> -        name: tx-min-frag-size
> +        name: rx-min-frag-size
>          type: u32
>        -
>          name: verify-enabled
> @@ -294,7 +294,7 @@ doc: Partial family for Ethtool Netlink.
>          name: master-slave-state
>          type: u8
>        -
> -        name: master-slave-lanes
> +        name: lanes
>          type: u32
>        -
>          name: rate-matching
> @@ -322,7 +322,7 @@ doc: Partial family for Ethtool Netlink.
>          name: ext-substate
>          type: u8
>        -
> -        name: down-cnt
> +        name: ext-down-cnt
>          type: u32
>    -
>      name: debug
> @@ -577,7 +577,7 @@ doc: Partial family for Ethtool Netlink.
>          name: phc-index
>          type: u32
>    -

[..]

> -    name: cable-test-nft-nest-result
> +    name: cable-test-ntf-nest-result
>      attributes:
>        -
>          name: pair
> @@ -586,7 +586,7 @@ doc: Partial family for Ethtool Netlink.
>          name: code
>          type: u8
>    -
> -    name: cable-test-nft-nest-fault-length
> +    name: cable-test-ntf-nest-fault-length
>      attributes:
>        -
>          name: pair
> @@ -595,16 +595,16 @@ doc: Partial family for Ethtool Netlink.
>          name: cm
>          type: u32
>    -
> -    name: cable-test-nft-nest
> +    name: cable-test-ntf-nest
>      attributes:
>        -
>          name: result
>          type: nest
> -        nested-attributes: cable-test-nft-nest-result
> +        nested-attributes: cable-test-ntf-nest-result
>        -
>          name: fault-length
>          type: nest
> -        nested-attributes: cable-test-nft-nest-fault-length
> +        nested-attributes: cable-test-ntf-nest-fault-length
>    -
>      name: cable-test
>      attributes:
> @@ -618,7 +618,7 @@ doc: Partial family for Ethtool Netlink.
>        -
>          name: nest
>          type: nest
> -        nested-attributes: cable-test-nft-nest
> +        nested-attributes: cable-test-ntf-nest

So much NFTs! Long live NFTs :-D

