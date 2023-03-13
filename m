Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F6D6B7629
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 12:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjCMLku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 07:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjCMLkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 07:40:47 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CF46230C
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 04:40:46 -0700 (PDT)
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com [209.85.219.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6C8283F201
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678707642;
        bh=ZpKDT5UhkfxeWMFELh9OL+VJzVqGM9pcXtrngfmlyoY=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=BYAo9fUEG/InImu7LoZmFZDZTnj+JPhIHkvOgqC/XcwXV2EWNd328Ndb/VTwM9NI+
         r6XhKJ8mU9r6ZXIbwV7JGjSSyHNusyLvsB4uOw6OK/G7aCzibhNf0Sf6r0XwGYLb26
         t8ArXBNGlmw5A++JgdSOMoLo0FPwVJV0RX4X7VXSI3DbeKdlnymMlNE0u2umXiYTtX
         EUywKCWMM4xvwf065xUF734A1lY3gFvQyuCcj/1m63bO+LP3iKvHpplbYLZPV4lTk8
         swrtikSuo/atCa/DvN2VX6rfliyWT+wZCTwimssUo0yCYaPkUFjibtu1cNFJvSlpJJ
         wEPXkNBG21QoQ==
Received: by mail-yb1-f198.google.com with SMTP id d7-20020a25adc7000000b00953ffdfbe1aso13418226ybe.23
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 04:40:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678707641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZpKDT5UhkfxeWMFELh9OL+VJzVqGM9pcXtrngfmlyoY=;
        b=0y3XBmWtKPjpPzWDzKXA4v44l1LNbAV72I/pcaJaFMrhJ9JmoppPzglEy1H4oa3Aoc
         ajB4iT8LShuTP4KgdkPbnKq0pagTUO/nn+DWZsoEr7Vow6+fo2w4LStHxAx2m2q+4//N
         lc8XICUjbdG99XtkqCzXynvRGVfBlpSvCVCa6nE/xXJqioedL7FVNKB7C9X5dsjNafsF
         TEjIMvaYs1nE+DoowlH4utUPUZgY5UbCY8K4cbLfxNBHMOECgNdITOSELZvqkMZOPB96
         84R85/BpH2xzkKpxDRl/y+YGfZL+AUOfr7RIz3tWuOBc+ybxFCdnBNEmlRrsMe7MC8L/
         4row==
X-Gm-Message-State: AO0yUKVdLzmS8SozORilzxqxBhjmhxbowZ86uiaFNLUPbKRnVahszWjs
        muZcrMP1AvmCdAeyVsqUCr4+/gvCs8qNddlX4Hi9Zd01BsBwHGF6CGZb28P4hUGyu9U/suWQE5h
        XIdb1ZrBlRfa9CZY8p1A8caislJv0cnD/Jf0mpa4hjwScoIoExQ==
X-Received: by 2002:a81:a9c6:0:b0:52e:f77c:315d with SMTP id g189-20020a81a9c6000000b0052ef77c315dmr7651893ywh.3.1678707639426;
        Mon, 13 Mar 2023 04:40:39 -0700 (PDT)
X-Google-Smtp-Source: AK7set9xTcOfifNRtlevrYEGkKSOHcLYPrM/Gt0PYujSr0kGtpKs5/tzQC1sIaHPxn+/G/yPzJ4x18CtQX0wTrbVPbM=
X-Received: by 2002:a81:a9c6:0:b0:52e:f77c:315d with SMTP id
 g189-20020a81a9c6000000b0052ef77c315dmr7651879ywh.3.1678707639208; Mon, 13
 Mar 2023 04:40:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230313113211.178010-1-aleksandr.mikhalitsyn@canonical.com>
In-Reply-To: <20230313113211.178010-1-aleksandr.mikhalitsyn@canonical.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Mon, 13 Mar 2023 12:40:28 +0100
Message-ID: <CAEivzxf630y_kjVLNM4m1vfQxnwyOBK+0wiCLW1T+8miPVC5Fg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] scm: fix MSG_CTRUNC setting condition for SO_PASSSEC
To:     davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>, paul@paul-moore.com,
        jmorris@namei.org, serge@hallyn.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+CC security subsystem folks

On Mon, Mar 13, 2023 at 12:32=E2=80=AFPM Alexander Mikhalitsyn
<aleksandr.mikhalitsyn@canonical.com> wrote:
>
> Currently, kernel would set MSG_CTRUNC flag if msg_control buffer
> wasn't provided and SO_PASSCRED was set or if there was pending SCM_RIGHT=
S.
>
> For some reason we have no corresponding check for SO_PASSSEC.
>
> In the recvmsg(2) doc we have:
>        MSG_CTRUNC
>               indicates that some control data was discarded due to lack
>               of space in the buffer for ancillary data.
>
> So, we need to set MSG_CTRUNC flag for all types of SCM.
>
> This change can break applications those don't check MSG_CTRUNC flag.
>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com=
>
>
> v2:
> - commit message was rewritten according to Eric's suggestion
> ---
>  include/net/scm.h | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/scm.h b/include/net/scm.h
> index 1ce365f4c256..585adc1346bd 100644
> --- a/include/net/scm.h
> +++ b/include/net/scm.h
> @@ -105,16 +105,27 @@ static inline void scm_passec(struct socket *sock, =
struct msghdr *msg, struct sc
>                 }
>         }
>  }
> +
> +static inline bool scm_has_secdata(struct socket *sock)
> +{
> +       return test_bit(SOCK_PASSSEC, &sock->flags);
> +}
>  #else
>  static inline void scm_passec(struct socket *sock, struct msghdr *msg, s=
truct scm_cookie *scm)
>  { }
> +
> +static inline bool scm_has_secdata(struct socket *sock)
> +{
> +       return false;
> +}
>  #endif /* CONFIG_SECURITY_NETWORK */
>
>  static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
>                                 struct scm_cookie *scm, int flags)
>  {
>         if (!msg->msg_control) {
> -               if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp)
> +               if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp ||
> +                   scm_has_secdata(sock))
>                         msg->msg_flags |=3D MSG_CTRUNC;
>                 scm_destroy(scm);
>                 return;
> --
> 2.34.1
>
