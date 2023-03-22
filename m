Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCD86C4AB4
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 13:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjCVMeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 08:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCVMeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 08:34:22 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1FC52F7B;
        Wed, 22 Mar 2023 05:34:21 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q23so5166627pfs.2;
        Wed, 22 Mar 2023 05:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679488461;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i5V9xwXeXLLD+KrCDhZHNlARjVnQzbrA2drRGNTtvTM=;
        b=CDVrPbquHqM6HszFxuFUX2B3vFLX7cGGnLlzfIXA9zqINFHXAUX5B+u28t/1ETgD5R
         3vSi6wpz1ys/mGkAntVqxg1ARpmJv+WgcckV7eE0GHqspgLihaH0YU4Xgy/v4hD4ZslS
         Baa7r/FR4OlY7SXjweixs0l2H6uf3IKdKOnYctTpB65NUohQ+7qRHMoBqzQqzxYuo0pJ
         5BHh8jE+OszzoW7tR9gseN4sJG6ia4Co/um2Lg4SzHGF3HMm2LVlzQpOY6mpGG6leV8N
         l13+6azf0a2F2vwpZCO9TkY5LA1uMuvzs3NhP4rhyk5xAxbAj0mAEj/oex9MEq3cKtms
         QNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679488461;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i5V9xwXeXLLD+KrCDhZHNlARjVnQzbrA2drRGNTtvTM=;
        b=eQUEuHVsUbAix8ECTQ4KT+LqkSa9CzNYxlqW+Eu1gW0bE/Tlwu14NXu38kIHhDzQ1S
         5OUluSyy652E+HdLm7WfdBvu+JW6wGkCQAZJDnN24ZnFgemppOST6adbHgj1KqbjwRhu
         mmPWWjzcSyU4r9zQBk92JHu++S4lC9bKTgvtqCzfIk8Mplf9unp2HHOGdeQ7CDavNtV8
         qZTNoSmjTG/VHrDjBQfH40IcUhPRlxUeh6BLJycD4LgCnZgRdrX0GVeIb4eQf2yxtog7
         oV86vX1PCOmugGwJWhhgJbwKpGax9XetwVCmjNAs97H9dJLV5Gw7BEE7WSqVOU1sJxtr
         Pf9g==
X-Gm-Message-State: AO0yUKVaPPZ4TEZHU+kxJube2G7wpXr534eaJyHPPiE6j5FMJ68YpXam
        bHl7I+RtWsz3PnnZNQQ5WV4=
X-Google-Smtp-Source: AK7set+SjG5SfufUMJ0PRkkAShlqktMKpQsqeCGtZJxdP7AhsNBXop2LwGx6eAvpMjdX7Qk4ANsA+w==
X-Received: by 2002:a62:2581:0:b0:622:ec07:c6bc with SMTP id l123-20020a622581000000b00622ec07c6bcmr2946097pfl.15.1679488460857;
        Wed, 22 Mar 2023 05:34:20 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-12.three.co.id. [180.214.232.12])
        by smtp.gmail.com with ESMTPSA id b11-20020aa7870b000000b005ac419804d5sm1038423pfo.98.2023.03.22.05.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 05:34:20 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id D6A611065AA; Wed, 22 Mar 2023 19:34:16 +0700 (WIB)
Date:   Wed, 22 Mar 2023 19:34:16 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>, corbet@lwn.net,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, shuah@kernel.org, brauner@kernel.org
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, ebiederm@xmission.com,
        mcgrof@kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [PATCH 5/5] doc: Add documentation for the User Mode Driver
 management library
Message-ID: <ZBr1yGQtNIXsgRYS@debian.me>
References: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
 <20230317145240.363908-6-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="n/OawJ+UwZzJM60M"
Content-Disposition: inline
In-Reply-To: <20230317145240.363908-6-roberto.sassu@huaweicloud.com>
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--n/OawJ+UwZzJM60M
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 17, 2023 at 03:52:40PM +0100, Roberto Sassu wrote:
> +The `UMD Manager` is the frontend interface to any user or
> +kernel-originated request. It invokes the `UMD Loader` to start the
> +`UMD Handler`, and communicates with the latter to satisfy the request.
> +
> +The `UMD Loader` is merely responsible to extract the `user binary` from
> +the kernel module, copy it to a tmpfs filesystem, fork the current proce=
ss,
> +start the `UMD Handler`, and create a pipe for the communication between
> +the `UMD Manager` and the `UMD Handler`.
> +
> +The `UMD Handler` reads requests from the `UMD Manager`, processes them
> +internally, and sends the response to it.

I think you can write out the full forms (UMD manager, UMD loader, and
UMD handler) once and for subsequent mentions of these, UMD can be
omitted, since the manager/loader/handler will obviously refers to the
UMD one.

Otherwise LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--n/OawJ+UwZzJM60M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBr1wwAKCRD2uYlJVVFO
o2XjAP98cKjwFVj5tKztgFgnpo2hMzFfJttUJXQOZJllxh9/PAEAziMVaUg2INAl
TElZ2NEmhAMWDKyYC7XmwIioKYn8HAI=
=kqxF
-----END PGP SIGNATURE-----

--n/OawJ+UwZzJM60M--
