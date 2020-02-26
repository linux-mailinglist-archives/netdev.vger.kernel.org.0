Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6935E1702D6
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 16:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgBZPlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 10:41:03 -0500
Received: from mail-pg1-f175.google.com ([209.85.215.175]:41945 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbgBZPlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 10:41:03 -0500
Received: by mail-pg1-f175.google.com with SMTP id b1so1266111pgm.8;
        Wed, 26 Feb 2020 07:41:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=E4d4isyeTN6TAq5pVSFeFaYqnhoLqeY2MfRvQ8HUnFg=;
        b=OjuPJz2UTQd89DfOcJw6UhPft4/2pGaUszDWmN4Y2Je4IGa/nerWIySFvCntejYInt
         A4bR0PMwbRoFJ+q6Mri8Yv+CtOuZUQDBUhUlb5yKRJXAxDizVwYy6iJ3P440S/3TZYeF
         m1sK6augOnwXUSM8JarfnEXcdVHTGCShlNG9JVXdUzacCd+saAsY43lxP3r1M5+8fVZK
         Zku0OebUWoZK6YisacxDTVfNmuy0lT+7WEVmr6BneGd+dn8db7gCFzXy3MCeUR72sLqL
         FXg/IcM9xagTW3iHjHRn8FljMvwPhirULXf+8vAHnOUVlHmB/PAwfqXyewfU7xVO/F16
         +f7A==
X-Gm-Message-State: APjAAAV0VGY723hYYxQ2Cgg8I/8tcawJgthg4Lyr5HZN2hzGmTVXZsAd
        YuIeBjexPMYwEGEZObDY/mxLsjOVB2/kew==
X-Google-Smtp-Source: APXvYqw8rO1Ms7t3wVERvy0HbERBs0SWzZsFW+p76pC+WaPKVHjPiMjYWDTPl3sNjugaAHfal6oJVA==
X-Received: by 2002:a63:f74a:: with SMTP id f10mr4375977pgk.360.1582731661428;
        Wed, 26 Feb 2020 07:41:01 -0800 (PST)
Received: from [192.168.43.48] (114-136-150-109.emome-ip.hinet.net. [114.136.150.109])
        by smtp.gmail.com with ESMTPSA id b1sm3436873pgs.27.2020.02.26.07.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 07:41:00 -0800 (PST)
Subject: Re: r8151: check disconnect status after long sleep
To:     Prashant Malani <pmalani@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Grant Grundler <grundler@chromium.org>,
        You-Sheng Yang <vicamo@gmail.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200224071541.117363-1-vicamo.yang@canonical.com>
 <20200224230240.GA9642@google.com>
From:   You-Sheng Yang <vicamo.yang@canonical.com>
Autocrypt: addr=vicamo.yang@canonical.com; keydata=
 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
 suzL+d2CSm1cCUYQeOxX/7MpmAIm
Message-ID: <7f20121e-46bf-9fd9-880a-e519f20afe4e@canonical.com>
Date:   Wed, 26 Feb 2020 23:40:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200224230240.GA9642@google.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="IbZuCOIdGHk6uGbJCfnuua7Fr3nlZqKFQ"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IbZuCOIdGHk6uGbJCfnuua7Fr3nlZqKFQ
Content-Type: multipart/mixed; boundary="p3sXBghPAIS8fNlfRngc7nj2WMAi1gWm7"

--p3sXBghPAIS8fNlfRngc7nj2WMAi1gWm7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-02-25 07:02, Prashant Malani wrote:
> nit: The commit message title tag should be "r8152", instead of "r8151"=
=2E

Thank you for reviewing. Also updated in v2.

You-Sheng Yang


--p3sXBghPAIS8fNlfRngc7nj2WMAi1gWm7--

--IbZuCOIdGHk6uGbJCfnuua7Fr3nlZqKFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEVhtdp+wXuXuqVL95S6BJ+2O0nE8FAl5WkYgACgkQS6BJ+2O0
nE8c+wf+PLcjjHbWbIXFi99rfIvpCKaYyyLdM/Y9WAOomEkDTx1QWTwCYbjl7q+q
5B6KVXmCZoqeo4e5JhiQGorZwM1mAnLRncMs+t5TnmfSmhgX5Je3symgJSIRDA0z
ch1kxlHvQjQi4fqiuam3ZrXXFdKjxHq1Qm1MtGyas2m6FIZnN5aDcYgVpKTftltQ
2U7t7X51CxeoulG2KD5HOvlT8mS1gcoSAe5QiXmi8SV3eXhmOHd+nEuDg5HdP1ei
G1U1ftfRArzf7FQSH/5hOQVY36u7sD38lTeWSw2kxGRDI86sufmAQp1zpYEEvOys
NUHXezLK4M5LKaYkHM7T2I8PQKwuHw==
=ZuAg
-----END PGP SIGNATURE-----

--IbZuCOIdGHk6uGbJCfnuua7Fr3nlZqKFQ--
