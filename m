Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 154912A711
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 22:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfEYUrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 16:47:51 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44145 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfEYUru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 16:47:50 -0400
Received: by mail-pl1-f193.google.com with SMTP id c5so5514146pll.11
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 13:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XsXZTRyeWuLP6fK4F6hmWWRDqlIpu+fyRzG4Gw4fJtI=;
        b=LVMTPHC1vfnF/E6bbu+1zdXCceZS+5L0Kj75tIu2UUWMsT3K4u6ktGLSgRV0TpFgmF
         QwHGGEOoqB39Fb7KUZucVLUx+j29aZy1V4UCJPw+GVLwytFlZj2hOTDBGoJUJg+LwI5u
         eyzq8IPI4d20mVUNvKrNDqGVJH/kvSB5tYj94=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XsXZTRyeWuLP6fK4F6hmWWRDqlIpu+fyRzG4Gw4fJtI=;
        b=jIx1XY1Nu87wLN6zeHZrq5r01wGcuuLdWLbHoEMOW7EApyIDFxj8OS5uV8iIQtmMYF
         BN10UdvB4uHl+MHPysxqLnCr0HK89uYBCiMPdta5/RR+bKZGPDlETnsbgEC5Yw21fKKA
         fKnfMGqah0guoxD6VfrGmpFpKZVs6h53NplamXpH1JMkwrmbHJOmYjmlEIbSw2+XWiYV
         2WOvXIaPP0031eEJQ6nqbuEYGiCfqkF4hKRpXoWTKIj3UJdBhSCrXGq1J7pApRHVJhLi
         IOB64VQkGO2L9yU37UWHiABqCtGSW00xXJqXFjGoDkeUxgZM7mh7iOvQWCaEiyLbZUmJ
         cTlQ==
X-Gm-Message-State: APjAAAXGEhlTAyC3y2cElyMViRi/CvFu3GqtnI5DXOElKip15zRw14Gi
        mBCWI8nVRFJ1QiOvNBAX0h8T+v3xn0lTLO7m
X-Google-Smtp-Source: APXvYqw1rCjCeyK7XfWkj/GJIF7Vs7nWGODe+/juQ5iWPQxsPh/lhql/IToSXn005IZ436+zJKgV8g==
X-Received: by 2002:a17:902:29e6:: with SMTP id h93mr7617984plb.297.1558817270305;
        Sat, 25 May 2019 13:47:50 -0700 (PDT)
Received: from [10.0.1.19] (S010620c9d00fc332.vf.shawcable.net. [70.71.167.160])
        by smtp.gmail.com with ESMTPSA id i3sm5393413pju.15.2019.05.25.13.47.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 13:47:49 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH net 1/4] net/udp_gso: Allow TX timestamp with UDP GSO
From:   Fred Klassen <fklassen@appneta.com>
In-Reply-To: <CAF=yD-+4g-HjmCnDWaVfdsyruePXqYeUDJgnffz9ro+rgNGv1g@mail.gmail.com>
Date:   Sat, 25 May 2019 13:47:47 -0700
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4B6F9771-011B-4BEC-8454-4D324856DDF6@appneta.com>
References: <20190523210651.80902-1-fklassen@appneta.com>
 <20190523210651.80902-2-fklassen@appneta.com>
 <CAF=yD-+4g-HjmCnDWaVfdsyruePXqYeUDJgnffz9ro+rgNGv1g@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 23, 2019, at 2:59 PM, Willem de Bruijn =
<willemdebruijn.kernel@gmail.com> wrote:what exactly is the issue with =
IP_TOS?
>=20
> If I understand correctly, the issue here is that the new 'P' option
> that polls on the error queue times out. This is unrelated to
> specifying TOS bits? Without zerocopy or timestamps, no message is
> expected on the error queue.

Please disregard last message. I think I was chasing a non-issue with
TOS bits. I will remove all references to TOS.=
