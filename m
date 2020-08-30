Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0365256F96
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 19:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgH3Rsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 13:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgH3Rsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 13:48:37 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1159C061573
        for <netdev@vger.kernel.org>; Sun, 30 Aug 2020 10:48:36 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d18so3747556iop.13
        for <netdev@vger.kernel.org>; Sun, 30 Aug 2020 10:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DCyVVOhaqk/SWkLzOUfwncRRJQH8E942zdnxxVV55ZM=;
        b=ndr1lRThrp55gKgbtSP1IwWSt0aQHZNBOawazrcVaRbHMJOuPzGsxr+FqCRmRf3iJG
         YwvNuV1JDTysmcPwZGj2p3GEBWHei1tvH/SlcHETX9rEFc+K2HCuCklkF+Ar+es4vMgR
         EX3QiuyUGLF2kEv19a5Hk3nbZdD6D3/zouiGsLvp9EIvlun6PLBEMLiTPygJVlOoEAcp
         UszecvcpJqLcwwVYUly865HahSt9WdLOrYTZlz95RS3FUORjVtXrXyheOpOxk3UdfQR+
         eKSgihh6OvgoM87/s46FFgf4EV9mgN6TbL+m6p2tCoEdGtIK1//OfQ9sMbQxnYKadxDD
         MhVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DCyVVOhaqk/SWkLzOUfwncRRJQH8E942zdnxxVV55ZM=;
        b=Y3Mjze6AHexA+DPkH1ebuR1Mkwg4o3XrKXvirtqPBcpH5lrGDKniMDCjoB1r6bETEX
         ro82TomOOqFklr0CSbVJP1wGyizJEnib/RsFlPq9dIh4XIXxxFAE1VZQi2m8qEJE4bDM
         5BIAa5uTR2uTd4ksKB5yxAYjuhhPi5sqiPbv37/9VIgNyhVdTwsvrIO4TbbdxB+OVeDC
         S3neMKK73jyyRVTsaIWZLETdg04CxgITgWXKmEPazGm/mVgfUPFgNgBC7CZpGPIkO8yO
         C2P5lbdW17YvUhPn0SNuxo18FjeLRPh+Z2Jt3jnqEqTcKh5Ko40tUOiYiwMqEE7k73ix
         2EEQ==
X-Gm-Message-State: AOAM532jcVXMyQs8PggGTJdJ+USLbVB+0uGEppYhQTGij3ZzeWWMH88b
        YhEyHLmGYphGWMxTeeB5mjoAf60LLBYGjyxUBvA=
X-Google-Smtp-Source: ABdhPJx1jF8eDVnb7Lsno3o0q9RIGSHp5kCpXbPZHoMAtU7oGxpz4bx3O1X6xG6T0sW0/LWzfaj+H1WVATXZUY946/o=
X-Received: by 2002:a05:6602:150:: with SMTP id v16mr5672353iot.80.1598809715736;
 Sun, 30 Aug 2020 10:48:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200828095223.21d07617@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200830140149.17949-1-yutaro.hayakawa@linecorp.com>
In-Reply-To: <20200830140149.17949-1-yutaro.hayakawa@linecorp.com>
From:   Yutaro Hayakawa <yhayakawa3720@gmail.com>
Date:   Mon, 31 Aug 2020 02:48:25 +0900
Message-ID: <CABTgxWF5vtQu4H6-_54QdMcM2mJW3h8Co254+Qb4q88k0He1dA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next] net/tls: Implement getsockopt SOL_TLS TLS_RX
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Michio Honda <michio.honda@ed.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apology. Kernel Test Robot just pointed out that the v2 patch has a
compilation error. My local compilation tests have passed because I
didn't enable the kTLS kernel option. Let me resubmit the fixed
version soon.

Yutaro

2020=E5=B9=B48=E6=9C=8830=E6=97=A5(=E6=97=A5) 23:02 Yutaro Hayakawa <yhayak=
awa3720@gmail.com>:
>
> From: Yutaro Hayakawa <yhayakawa3720@gmail.com>
>
> Implement the getsockopt SOL_TLS TLS_RX which is currently missing. The
> primary usecase is to use it in conjunction with TCP_REPAIR to
> checkpoint/restore the TLS record layer state.
>
> TLS connection state usually exists on the user space library. So
> basically we can easily extract it from there, but when the TLS
> connections are delegated to the kTLS, it is not the case. We need to
> have a way to extract the TLS state from the kernel for both of TX and
> RX side.
>
> The new TLS_RX getsockopt copies the crypto_info to user in the same
> way as TLS_TX does.
>
> We have described use cases in our research work in Netdev 0x14
> Transport Workshop [1].
>
> Also, there is an TLS implementation called tlse [2] which supports
> TLS connection migration. They have support of kTLS and their code
> shows that they are expecting the future support of this option.
>
> [1] https://speakerdeck.com/yutarohayakawa/prism-proxies-without-the-pain
> [2] https://github.com/eduardsui/tlse
>
> Signed-off-by: Yutaro Hayakawa <yhayakawa3720@gmail.com>
> ---
> Changes in v2:
> - Remove duplicated memcpy for each cipher suites
>
> Thanks for your reply. Reflected the comments.
>
>  net/tls/tls_main.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
>
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index bbc52b0..0271441 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -330,12 +330,13 @@ static void tls_sk_proto_close(struct sock *sk, lon=
g timeout)
>                 tls_ctx_free(sk, ctx);
>  }
>
> -static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
> -                               int __user *optlen)
> +static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
> +                                 int __user *optlen, int tx)
>  {
>         int rc =3D 0;
>         struct tls_context *ctx =3D tls_get_ctx(sk);
>         struct tls_crypto_info *crypto_info;
> +       struct tls_cipher_context *cctx;
>         int len;
>
>         if (get_user(len, optlen))
> @@ -352,7 +353,13 @@ static int do_tls_getsockopt_tx(struct sock *sk, cha=
r __user *optval,
>         }
>
>         /* get user crypto info */
> -       crypto_info =3D &ctx->crypto_send.info;
> +       if (tx) {
> +               crypto_info =3D &ctx->crypto_send.info;
> +               cctx =3D &ctx->tx;
> +       } else {
> +               crypto_info =3D &ctx->crypto_recv.info;
> +               cctx =3D &ctx->rx;
> +       }
>
>         if (!TLS_CRYPTO_INFO_READY(crypto_info)) {
>                 rc =3D -EBUSY;
> @@ -379,9 +386,9 @@ static int do_tls_getsockopt_tx(struct sock *sk, char=
 __user *optval,
>                 }
>                 lock_sock(sk);
>                 memcpy(crypto_info_aes_gcm_128->iv,
> -                      ctx->tx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
> +                      cctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
>                        TLS_CIPHER_AES_GCM_128_IV_SIZE);
> -               memcpy(crypto_info_aes_gcm_128->rec_seq, ctx->tx.rec_seq,
> +               memcpy(crypto_info_aes_gcm_128->rec_seq, cctx->rec_seq,
>                        TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
>                 release_sock(sk);
>                 if (copy_to_user(optval,
> @@ -403,9 +410,9 @@ static int do_tls_getsockopt_tx(struct sock *sk, char=
 __user *optval,
>                 }
>                 lock_sock(sk);
>                 memcpy(crypto_info_aes_gcm_256->iv,
> -                      ctx->tx.iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
> +                      cctx->iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
>                        TLS_CIPHER_AES_GCM_256_IV_SIZE);
> -               memcpy(crypto_info_aes_gcm_256->rec_seq, ctx->tx.rec_seq,
> +               memcpy(crypto_info_aes_gcm_256->rec_seq, cctx->rec_seq,
>                        TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
>                 release_sock(sk);
>                 if (copy_to_user(optval,
> @@ -429,7 +436,9 @@ static int do_tls_getsockopt(struct sock *sk, int opt=
name,
>
>         switch (optname) {
>         case TLS_TX:
> -               rc =3D do_tls_getsockopt_tx(sk, optval, optlen);
> +       case TLS_RX:
> +               rc =3D do_tls_getsockopt_conf(sk, optval, optlen,
> +                                           optname =3D=3D TLS_TX);
>                 break;
>         default:
>                 rc =3D -ENOPROTOOPT;
> --
> 1.8.3.1
