Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27C8629DA4
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfEXR6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:58:34 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:46565 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfEXR6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:58:33 -0400
Received: by mail-vs1-f68.google.com with SMTP id x8so6394414vsx.13
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 10:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=jEljZyPKIaYsyiAwCilVbAEFbXpDr1M/HdiJLQ12y5g=;
        b=Tp1JTWedVQcvN4Orw3TPg0sp2mufefbYlVO3laSY3Savky1M83ZcpfMQ2U+B7p+VqT
         shjDljjBGnGW76PXE0ERRR4Od4gv8WXtDyB3ZlMQDhHVpI7wPTOsdbC/rFs/adhUqvNi
         RNX0b4HKhXe1/LaX/2nxx168Ta94axZ1+4OPyqDdLx/2xSvK10lfD2wSyR89MsJR4Db5
         MqwvA2BsyAaPvvx2nZ46GIdOjF+Rr1bv5OwQnOJ9bycRI08bKGnTtLVWa+r/J8KkJL28
         ywJ/3VIuRangUtsMQzEIgioEy+p/DFqjBwd2JJacydD7gYKRGb9rHC5e5RGH/mUbME9H
         /Yag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=jEljZyPKIaYsyiAwCilVbAEFbXpDr1M/HdiJLQ12y5g=;
        b=FpXYyU1Xz95wNqPklK+854Yyl25iEU9/M7EN9WdavK0g3j2m59M7WI3/vSg8cjye6i
         eZcK10P9jouA2Dt5uerpmxjxN0cy93BE1FBL6oyMVKFJsKCv0tiAGIihrjfoIL4urjv3
         czoI0+zHbCLfe18KaeMSjMaO/WJrmUh3df0/VbvowBbSc6I0dCrrGEaSmMejo9m2GI+D
         viuthgI5vyo3KQsgu54ddowSk4cOZVwbv9m3cXfLQNJT32Ik6fDnw9ccupMYKcSQZ4zz
         HglaASlYa8LEqTV4Nza5PF6tTKvwaJ1gay2SttOroPHNVxBIGq5X4boUKpTSRNE94jtf
         gyyA==
X-Gm-Message-State: APjAAAWle2/IeRT/DG0IOsuX5zIlYSXbOw7/7OW4Mg7i3ePxc+rPewll
        ug3JcWVYsHjclawo0r4oQBT00g==
X-Google-Smtp-Source: APXvYqzhC1aQoy8xsHpZl3MQiy/J8RMgekr7RqrXKOxU8vPcjT94qJLo5N/XttOB8DIQQsfXolKnvg==
X-Received: by 2002:a67:ee12:: with SMTP id f18mr39418914vsp.158.1558720712884;
        Fri, 24 May 2019 10:58:32 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n23sm2095873vsj.27.2019.05.24.10.58.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 24 May 2019 10:58:32 -0700 (PDT)
Date:   Fri, 24 May 2019 10:58:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v3 00/16] AF_XDP infrastructure improvements
 and mlx5e support
Message-ID: <20190524105828.665facc0@cakuba.netronome.com>
In-Reply-To: <8b0450c2-ad5e-ecaa-9958-df4da1dd6456@intel.com>
References: <20190524093431.20887-1-maximmi@mellanox.com>
        <8b0450c2-ad5e-ecaa-9958-df4da1dd6456@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 12:18:32 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> Maxim, this doesn't address the uapi concern we had on your v2.
> Please refer to Magnus' comment here [1].
>=20
> Please educate me why you cannot publish AF_XDP without the uapi change?
> It's an extension, right? If so, then existing XDP/AF_XDP program can
> use Mellanox ZC without your addition? It's great that Mellanox has a ZC
> capable driver, but the uapi change is a NAK.
>=20
> To reiterate; We'd like to get the queue setup/steering for AF_XDP
> correct. I, and Magnus, dislike this approach. It requires a more
> complicated XDP program, and is hard for regular users to understand.

+1
