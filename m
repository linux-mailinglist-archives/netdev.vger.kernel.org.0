Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AE56E83C6
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 23:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbjDSVax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 17:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjDSVaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 17:30:52 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B813D93F7
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 14:30:41 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-54fa9da5e5bso19439627b3.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 14:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1681939841; x=1684531841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tvk3BDMxry1ipK9jIkb7whZPWk90UaY3lbkZAbRwP5Q=;
        b=MJW0SyZPFqwSZjSpPv9dsTF6Vb8IBzlx4kCKoI+Ken23d8y7osBgfVeL/Qm+3YiOPK
         m4W9yVN90fZAjji9fGn3dMJC+EOm0fJ/WjNIKl/iqvqmA+iepK2QRXQ9KBX4xIuMUUcT
         VxAGbINo/4eGu7Ks90qfdYfWEZN/Bqx0jVJ2DmhDQRqVRmRkIkwGvu0289zsG68oynkl
         8Y3heXBi+qjMMCj+ARwbHbwsgxHCaPlWX4wjzK6UXk6QW2C8hWwAa+3C3zdSQSMeHv+5
         AGXriFuyE6AnRXGKSbsDu8KbxIJ6iNyAlzdb37mZx7KXceZp4iY3+hbkzMTcHKkeSpci
         5RhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681939841; x=1684531841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tvk3BDMxry1ipK9jIkb7whZPWk90UaY3lbkZAbRwP5Q=;
        b=DQCSQbtN7fU4k5H0Y6g5/kYX0CaC7LnFsRBsPEe7Sxmr2s/6xSKUQ5Wvxg2mvas52p
         D4+WbTZ5ICLu9Sx70la1F2fVe8j8e2W861sBhGvLHJM6+JAuKvbUWmUZcZKy0kHcnzrB
         TaL3EzSm1TX8IHfvguMwVm/lsq6z+2PL124NPFmC0tOCjYmv1gS5/5o28ENkKeGKD4P/
         h90r/Z55o/aHyDOHyddTJMsE0iTt7PLoC13X7BpIRPJa++y3+tnENl4GkFuVyeFS0Gtd
         vL1u40BRXnl+r4aAGW3m2BwKkHRY58BawWBF3EOElpHiHVQ1wbbs+LatpVCOF2LPw17z
         dWWw==
X-Gm-Message-State: AAQBX9d9uPklijldqNe+y68/B4lkJCojiyHmLdVJB5C4l0Op5J9H8Llh
        u3OeqVc8jpftB5mC9YBOJ7Qbj38npawYbfCUm5Mg
X-Google-Smtp-Source: AKy350aiV7Ppniz441YlSZ2+c00+8FsnYukqiDdssbLd+Wxma6NYUlYGnP2cFtiWsz5nKfAvL/4d0Td0KowHt1ZypVE=
X-Received: by 2002:a0d:df06:0:b0:54f:e6a:5d10 with SMTP id
 i6-20020a0ddf06000000b0054f0e6a5d10mr4814428ywe.22.1681939840790; Wed, 19 Apr
 2023 14:30:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v1-0-9d4064cb0075@tessares.net>
 <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v1-2-9d4064cb0075@tessares.net>
In-Reply-To: <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v1-2-9d4064cb0075@tessares.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 19 Apr 2023 17:30:30 -0400
Message-ID: <CAHC9VhQz_ZUot1Sxa6zhzXh_ECz+rR=Nq3zzDEEL7GKvzYQziA@mail.gmail.com>
Subject: Re: [PATCH LSM 2/2] selinux: Implement mptcp_add_subflow hook
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 1:44=E2=80=AFPM Matthieu Baerts
<matthieu.baerts@tessares.net> wrote:
> From: Paolo Abeni <pabeni@redhat.com>
>
> Newly added subflows should inherit the LSM label from the associated
> msk socket regarless current context.

"... from the associated main MPTCP socket regardless of the current contex=
t."

Us SELinux folks may not always be able to make the jump from "msk" to
"main MPTCP socket" when we are looking through the git log in the
future, let's make it easier on us/me ;)

> This patch implements the above copying sid and class from the msk
> context, deleting the existing subflow label, if any, and then

"... from the main MPTCP socket context, deleting ..."

> re-creating a new one.
>
> The new helper reuses the selinux_netlbl_sk_security_free() function,
> and the latter can end-up being called multiple times with the same
> argument; we additionally need to make it idempotent.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> ---
>  security/selinux/hooks.c    | 16 ++++++++++++++++
>  security/selinux/netlabel.c |  8 ++++++--
>  2 files changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 9a5bdfc21314..53cfc1cb67d2 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -5476,6 +5476,21 @@ static void selinux_sctp_sk_clone(struct sctp_asso=
ciation *asoc, struct sock *sk
>         selinux_netlbl_sctp_sk_clone(sk, newsk);
>  }
>
> +static int selinux_mptcp_add_subflow(struct sock *sk, struct sock *ssk)
> +{
> +       struct sk_security_struct *ssksec =3D ssk->sk_security;
> +       struct sk_security_struct *sksec =3D sk->sk_security;
> +
> +       ssksec->sclass =3D sksec->sclass;
> +       ssksec->sid =3D sksec->sid;
> +
> +       /* replace the existing subflow label deleting the existing one
> +        * and re-recrating a new label using the current context

"... new label using the updated context"

Let's avoid the phrase "current context" as that could imply the
current task, which is exactly what we are trying not to do.

> +        */
> +       selinux_netlbl_sk_security_free(ssksec);
> +       return selinux_netlbl_socket_post_create(ssk, ssk->sk_family);
> +}
> +

--
paul-moore.com
