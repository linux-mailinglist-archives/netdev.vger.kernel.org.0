Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2605A077C
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiHYCxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiHYCxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:53:06 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F439CCD2;
        Wed, 24 Aug 2022 19:53:06 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r69so16697173pgr.2;
        Wed, 24 Aug 2022 19:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=ZBRn3glusYyDDS6wNhVu2goiaQqoWM1kcfMmuuxqfeo=;
        b=MPAY3R16cIl2HRQO0QjpATwvz0RbCN/3Oxj+pPn5MM8V8xA2H4ipSi8OnNAnaswXlT
         E4rI3X57BYoJeGQ9kQ2JDf4Ci0JVCQoYjfHG/lgQjwiWv+9x8YdxzeHawlD8QxC/8qBq
         EGPYi8hgbB3Yy+M7wvDqpiIiGnrNC4bMz6TKpIbNvAMFJNFywMw2SiSTY+Vu6sNkN8ZD
         igO2r+RUqlQ19SlqFs4QEwN+msWM39iffaA/ttpZk0cBOqz6TcF6zaWzOl0+FFlmBty6
         1GrNnZ2UEF6DIMiQw+lvkxuV9jPR5VS0QYNCy4GA1d4vkctOUFbv3hQfaxplYJwPJwOD
         nsMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ZBRn3glusYyDDS6wNhVu2goiaQqoWM1kcfMmuuxqfeo=;
        b=PiG/FXj0DfEK65Jgw0PJlkQGjFcnccA9nfbBAID/DASLs66EREIKRvJXvZ1m0h13JA
         PBN/UgGBQ4XcLs0yakpw48FzvJkBLkvYt/vmV6EjTdG5AnYmyoRgEIXdeTxTJymfNU9c
         HDGpBRsGIJStzGj9OWSHpmzweOibNE/B3YqxgS8qTSoRKelWR61sTf/td1pMOp+wppGF
         IZDACT3be2eDuxt3E3GLM73cTJEJKu0ayxBiLYR1YMI5pfLlltmXaFK6LW4lIjYULnlB
         E3YIbd6xA5mN4PDcX3uWfAyR7OP6wLXNFR1FGyIGVOaa9p4gZx0ZY0mt+CNTZqwgtrc4
         kA1w==
X-Gm-Message-State: ACgBeo39xET9po7cldyGjZ9EwUOHdGw5Z73RFZjDOpgW+SVwXX7ylYUh
        fTtxIa/HVv4BQlnM8YqyTSU=
X-Google-Smtp-Source: AA6agR5Q0ST3Yu6ZCFGqnW+CQmNOuUqjcWQ4lT5jynnps9v76ptvuDUKqgDW5F7Vj338dAtgMAQa3Q==
X-Received: by 2002:a65:6b8e:0:b0:42a:162c:e3a0 with SMTP id d14-20020a656b8e000000b0042a162ce3a0mr1539015pgw.464.1661395985677;
        Wed, 24 Aug 2022 19:53:05 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-33.three.co.id. [116.206.28.33])
        by smtp.gmail.com with ESMTPSA id qi3-20020a17090b274300b001f3162e4e55sm2170817pjb.35.2022.08.24.19.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 19:53:05 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 8E1C9103C07; Thu, 25 Aug 2022 09:53:00 +0700 (WIB)
Date:   Thu, 25 Aug 2022 09:52:59 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH bpf-next v7 24/24] Documentation: add HID-BPF docs
Message-ID: <YwbkC9v83gk0Eq/d@debian.me>
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
 <20220721153625.1282007-25-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fd9AMyEzaCZxSJic"
Content-Disposition: inline
In-Reply-To: <20220721153625.1282007-25-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fd9AMyEzaCZxSJic
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 21, 2022 at 05:36:25PM +0200, Benjamin Tissoires wrote:
> +When (and why) to use HID-BPF
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +
> +We can enumerate several use cases for when using HID-BPF is better than
> +using a standard kernel driver fix:
> +

Better say "There are several use cases when using HID-BPF is better
than standard kernel driver fix:"

> +When a BPF program needs to emit input events, it needs to talk HID, and=
 rely
> +on the HID kernel processing to translate the HID data into input events.
> +

talk to HID?

Otherwise the documentation LGTM (no new warnings caused by the doc).

--=20
An old man doll... just what I always wanted! - Clara

--fd9AMyEzaCZxSJic
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYwbkBwAKCRD2uYlJVVFO
oz3rAQCgczCdX57yjfzPE8zpu9jiwd33nPbcTmawxaCDNeO/owEAgYmMVll2dF0j
zQo9yKz4+kiQWQNTPR3m6sXcj3WDsQU=
=Ww1R
-----END PGP SIGNATURE-----

--fd9AMyEzaCZxSJic--
