Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99F83D8579
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 03:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhG1Bhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 21:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbhG1Bhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 21:37:51 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE46C061760
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 18:37:50 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id m38-20020a05600c3b26b02902161fccabf1so3167686wms.2
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 18:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dNawNorpn3/ehRW9KZSQYGcu+t9pcL5tKP9IjSkZ/ic=;
        b=cIFaLdm5pLV2s8UfdlKSzTILToy3SXyMJYCr43IQZLoLGD6voXarNaaAobYCR0NSto
         6UVYPaoKMp0/tVjgzo7d1I552/CEwGhM1jaOcC7tZZS8fZa1q8RalmdMk7ksBt7mE3hZ
         8xv7yF3sgQjarEmBeuyXeMMHN/8DcYIWknYI8xH6ATt/lS9UIVgwjAxvgn7MsVhogBQs
         Kq8RgoQmmjDa3Cg+eAgtzOTvRpLRxLco+HtiorB5OeVpry1fVLDeWeokbXNB5yFZe4ga
         /kyGLrCMEuvbKrla/IbGr3VsF19dcsSaojASfm53Y5bUSQYPT9eVZYjhEsJrSODZRsSS
         NWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dNawNorpn3/ehRW9KZSQYGcu+t9pcL5tKP9IjSkZ/ic=;
        b=M912TFWPEq3fHZlgGmsLdCuIojjnPgQmq/nb/z9c3avjftAcsp2I93GQA5mmSUPacD
         uRaV8j+Xobam4xkdzmWZxYoRyIF9zL9NFbCaw2vj8P51Z2CcogGyYZvrwgE7XqMFHtvc
         OU5uVBsYNuy/AmYTOuRdczKb29yf38p2RAqF44vqKkNRcHC00IB7PGnGSEf1BKBwow9S
         PP0HEXfJrjDv/5xoL/utin8AsFgEFGoOPeYj7ERcyFmtori2Dk0bmjCrPukJWcvn3b+y
         NMSbmQixB344NdgWs1ZoCicOgp+k6WbYYE5Xx1OK3bj8u8qoh5YoXjEeA7iQTcfwHJw/
         85yA==
X-Gm-Message-State: AOAM5327PHKhtWxBLy+7IvlrUTee2tJOTHzVfbk3J84Jw1CaxJxyBhFz
        Qem43GzRMwBPhvgeVzxaFiYGErejPC+BJGdxoZN7XQ==
X-Google-Smtp-Source: ABdhPJyWfMUtr8sZgDmkqE6QprjlNcFVWYt6wQrjN3jdJ8XBOZoJjOjEpYzrry7Ibz2p3AZXcOwnI6IB8yXnuJQiPPE=
X-Received: by 2002:a1c:1dcf:: with SMTP id d198mr6723188wmd.103.1627436269179;
 Tue, 27 Jul 2021 18:37:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210727225847.22185-1-jjoseaquiless@gmail.com>
In-Reply-To: <20210727225847.22185-1-jjoseaquiless@gmail.com>
From:   David Gow <davidgow@google.com>
Date:   Wed, 28 Jul 2021 09:37:38 +0800
Message-ID: <CABVgOSkT5_R3jWLnwftGHHWQKaPOMySXWhCx_=SCK6BKX4w_qw@mail.gmail.com>
Subject: Re: [PATCH] lib: use of kunit in test_parman.c
To:     =?UTF-8?Q?Jos=C3=A9_Aquiles_Guedes_de_Rezende?= 
        <jjoseaquiless@gmail.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Daniel Latypov <dlatypov@google.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, ~lkcamp/patches@lists.sr.ht,
        Matheus Henrique de Souza Silva 
        <matheushenriquedesouzasilva@protonmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 7:04 AM Jos=C3=A9 Aquiles Guedes de Rezende
<jjoseaquiless@gmail.com> wrote:
>
> Convert the parman test module to use the KUnit test framework.
> This makes thetest clearer by leveraging KUnit's assertion macros
> and test case definitions,as well as helps standardize on a testing frame=
work.
>
> Co-developed-by: Matheus Henrique de Souza Silva <matheushenriquedesouzas=
ilva@protonmail.com>
> Signed-off-by: Matheus Henrique de Souza Silva <matheushenriquedesouzasil=
va@protonmail.com>
> Signed-off-by: Jos=C3=A9 Aquiles Guedes de Rezende <jjoseaquiless@gmail.c=
om>
> ---

Thanks for porting this! A few more notes from the KUnit side.

>  lib/test_parman.c | 145 +++++++++++++++++++---------------------------
>  1 file changed, 60 insertions(+), 85 deletions(-)

This seems to be missing changes to lib/Kconfig.debug: you'll want to
modify the TEST_PARMAN config item to
- depend on KUNIT
- only appear if !KUNIT_ALL_TESTS
- default KUNIT_ALL_TESTS

It might also be nice to:
- select PARMAN (it's otherwise extremely unlikely a config will
actually pick up the test)
- maybe rename TEST_PARMAN to PARMAN_KUNIT_TEST (this is optional,
since this is a port of an existing test, but does make it clearer, so
it really depends on what existing usage looks like)

>
> diff --git a/lib/test_parman.c b/lib/test_parman.c
> index 35e32243693c..bd5010f0a412 100644
> --- a/lib/test_parman.c
> +++ b/lib/test_parman.c

The rest of this looks okay to me, but you should check out Daniel's
comments in his email, too.

Cheers,
-- David
