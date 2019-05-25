Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86DCC2A704
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 22:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfEYUqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 16:46:09 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39352 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfEYUqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 16:46:09 -0400
Received: by mail-pg1-f196.google.com with SMTP id w22so6914574pgi.6
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 13:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qo8JrOOZqi12jkLNvRxgMvVScnv0tXvVQTmMYH0OKSE=;
        b=thWHGLVr4cU7dJKLdMWPO72IcwgIUO6hCDtvYPNJxvRmFABU5gDC/mRGcgxLAmjdFO
         Oh0yt+kdymYu11rdgIzECutsKWeYt5hzZggVnh7yjPN3iKgtTUaDX71jipxAXNjnZwdU
         9zm0rBy9oCa+p5uezRtBcDS0eb+z8ywJ1Cy3c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qo8JrOOZqi12jkLNvRxgMvVScnv0tXvVQTmMYH0OKSE=;
        b=iHa6RNLbkO9wL8xAa22JUR+eAl3eR0U9P8XHjDQBiuSdmDH4JjqvtV6d4adc7CBBKx
         CIYGSu/BQu4u8ptf2WFl8IUFvYdZ4d8DehNdZPL0QqzQk63yt9+0T/QpkVXE6vnKmELC
         6KQOItOVSe9ZJsTSzLI+NBNl4FEGScSOe8eSM6tV2jqjFGhbDth/0aIgtddv8qi5Z8KK
         /Yj6zVgDp1sfq3UzD+ZAWlfNOSmNvh+OZ9NY/1RbMKMoW4Oq7THorasDccES4C0CI8Yq
         33/NX4maOfVYAleIm1M5Ie3Vprm2LZwsAW5stTZbipzQG8Ejbqf/ngkh8KVBxuYT08Qs
         rVjQ==
X-Gm-Message-State: APjAAAXxbZq1Bjw+980MaeSbO1DlYgOtHebQHvaiJLWdrSZ9jlWlwD6S
        ItSZDbf4yWbvxwOdzgL99+3G1g==
X-Google-Smtp-Source: APXvYqzPaHFWQxMwohp9Yc0Omohint92w9s29CVWXD2wQWQNWaD5UzsOvqltGy2QkyvJLRqj3EN7KA==
X-Received: by 2002:a62:5653:: with SMTP id k80mr121841807pfb.144.1558817168926;
        Sat, 25 May 2019 13:46:08 -0700 (PDT)
Received: from [10.0.1.19] (S010620c9d00fc332.vf.shawcable.net. [70.71.167.160])
        by smtp.gmail.com with ESMTPSA id p16sm6510085pff.35.2019.05.25.13.46.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 13:46:08 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH net 1/4] net/udp_gso: Allow TX timestamp with UDP GSO
From:   Fred Klassen <fklassen@appneta.com>
In-Reply-To: <CAF=yD-Jf95De=z_nx9WFkGDa6+nRUqM_1PqGkjwaFPzOe+PfXg@mail.gmail.com>
Date:   Sat, 25 May 2019 13:46:07 -0700
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7FB4B2F6-A7F3-4565-8D53-CF0E5A3EEFA4@appneta.com>
References: <20190523210651.80902-1-fklassen@appneta.com>
 <20190523210651.80902-2-fklassen@appneta.com>
 <CAF=yD-Jf95De=z_nx9WFkGDa6+nRUqM_1PqGkjwaFPzOe+PfXg@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 23, 2019, at 2:39 PM, Willem de Bruijn =
<willemdebruijn.kernel@gmail.com> wrote:
> Zerocopy notification reference count is managed in skb_segment. That
> should work.
>=20

I=E2=80=99m trying to understand the context of reference counting in =
skb_segment. I assume that
there is an opportunity to optimize the count of outstanding zerocopy =
buffers, but I=20
can=E2=80=99t see it. Please clarify.

