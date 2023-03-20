Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5506C0940
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 04:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCTDRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 23:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjCTDRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 23:17:45 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5701449B;
        Sun, 19 Mar 2023 20:17:44 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id k2so11066514pll.8;
        Sun, 19 Mar 2023 20:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679282264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9JRG63v/PU6iN9kUwJChfjBRC2zYHxpkDWhma0ZLQY=;
        b=LyU5qo1oH6ehJKbIQ1TMfNt44biZqTXeC/VgI1G6sNgQEnbyeBiu9uaKMME1o5MleE
         qdEK1fm39D15FhffnnufQODmW9+xilKGy0f/NAWr31bSr+zFEMhiTs/xD/Al0rcfhbUK
         TYHAZYu8ND8RT7mjE68Wrbc12nYkb/2bpx77MfrWmkagS25dFJ0daEhN92pJVTMpgsMv
         /6hslTWsa7U55AndBJ36lUb5WCNwLtByAOWWD9FR1yvK+t9ONO3CSjU+yBl3EfJj7ODZ
         AjYcYOXjEcp45dtzK+3UIZZqj69+WTrm6Nx/16u4fcXU2ISduxDT4qbnzY+P9bxl6Lrt
         dE1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679282264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z9JRG63v/PU6iN9kUwJChfjBRC2zYHxpkDWhma0ZLQY=;
        b=7ldtCx3WbdFS9nMRkmdPjPC0wOntc6FKGeyMseN+7rB0PsiiwHixxnoysuqkDn0JqH
         qWVDcYoAr7ZzAt3zhXmrBMHLNw9QHFnBa8bIeNruiUkNKlz6Q4abl2qqy0B/jIY68Awa
         CjP7c0iO0+AQffrptG9qWYJvfR9vKCldZh3Lv5MPBLROBtqQDqixitwZHcXKu8QEGNc9
         Csq+dqX6hyok6zAkvN/5BoVpDJLkzr9nAWZ+muKzZYBez3e7BRKywkVDi1FjtfNqON/a
         skC+7DqQMnqwAhtbEctUY3DWMsI3XHvDm2euKJLNghQULqNMn2pS3TyTF+ZfCOOEd8FL
         IYIg==
X-Gm-Message-State: AO0yUKXpUK2sgudUkIHZInE32TtXAgcWcBj3wkqKFBs+kzBGrn1UwRPq
        +H1ooYo0qm2N+otVHVe2VSZQOGUraHQ9UA==
X-Google-Smtp-Source: AK7set/jMPKlVxmLMFRs1CKqRNHOBxKkUJ6jc1WKzo2WxqLWGRRsPlQx/lCNiMwpmmLZgJqqt3JrRw==
X-Received: by 2002:a17:902:dacd:b0:1a1:cef2:acd4 with SMTP id q13-20020a170902dacd00b001a1cef2acd4mr2557396plx.21.1679282263629;
        Sun, 19 Mar 2023 20:17:43 -0700 (PDT)
Received: from debian.me (subs09a-223-255-225-67.three.co.id. [223.255.225.67])
        by smtp.gmail.com with ESMTPSA id g9-20020a170902934900b0019f1205bdcbsm5405191plp.147.2023.03.19.20.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 20:17:43 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id E058E106591; Mon, 20 Mar 2023 10:17:39 +0700 (WIB)
Date:   Mon, 20 Mar 2023 10:17:39 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Message-ID: <ZBfQU7LOxkRQV4MQ@debian.me>
References: <20230320100922.0f877bb9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="h1Qbk0+Cd9DCs4Ma"
Content-Disposition: inline
In-Reply-To: <20230320100922.0f877bb9@canb.auug.org.au>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--h1Qbk0+Cd9DCs4Ma
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 20, 2023 at 10:09:22AM +1100, Stephen Rothwell wrote:
> diff --cc Documentation/bpf/bpf_devel_QA.rst
> index 7403f81c995c,e151e61dff38..000000000000
> --- a/Documentation/bpf/bpf_devel_QA.rst
> +++ b/Documentation/bpf/bpf_devel_QA.rst
> @@@ -684,8 -689,11 +689,7 @@@ when
>  =20
>  =20
>   .. Links
> - .. _netdev-FAQ: https://www.kernel.org/doc/html/latest/process/maintain=
er-netdev.html
>  -.. _Documentation/process/: https://www.kernel.org/doc/html/latest/proc=
ess/
>   .. _selftests:
>      https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/t=
ree/tools/testing/selftests/bpf/
>  -.. _Documentation/dev-tools/kselftest.rst:
>  -   https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html
>  -.. _Documentation/bpf/btf.rst: btf.rst
>  =20
>   Happy BPF hacking!

The resolution LGTM, thanks!

--=20
An old man doll... just what I always wanted! - Clara

--h1Qbk0+Cd9DCs4Ma
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBfQTQAKCRD2uYlJVVFO
o6KmAQCAY/8MeWR7qg+k5E++QiSaM1Isczan4vcxY2KjXBlWigEAxG6ceXNRlneh
gpM1Fw3yrdgnmEIFbCUMXSbMvcPX2gs=
=z4iD
-----END PGP SIGNATURE-----

--h1Qbk0+Cd9DCs4Ma--
