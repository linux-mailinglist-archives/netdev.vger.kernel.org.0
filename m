Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9362ACF61
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 07:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731355AbgKJGGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 01:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgKJGGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 01:06:20 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10372C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 22:06:20 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id h6so9252702pgk.4
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 22:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kTVUwuaKbs1NET+lVpJf5Xg+Kt5gcDEBsg8uwkJerSo=;
        b=X453nrIUvXiUwz+rMqts6F4GNyaX203HVg9GqknXD7IRGaNHU3s/6JJ7DXWzninCNc
         mJzQtTM/FvyE2HjPxNtNFRVarh2+vinHau8osU7sn/LYtxXdfXNKJskpzooz/cnplS2S
         ivTJkodOiMHgqLGkTvE60BPWL69alXLlT2BzOadSRwWqybDx2KrKSiWpAu1MKpuAq2vz
         VFfMoVgwMOBbjw0zWjIE9UgzD+sNNYzcGYDoIAeHx4AxldCjIxpYIQq7r2hPBix8toZf
         7CDakP2gYmrwIu1ZWe7gWBLEaVmM13YVyuxr2Cg+Tcxx+cEnlHvfyz0tmhyIAsqc9rZF
         Uxcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kTVUwuaKbs1NET+lVpJf5Xg+Kt5gcDEBsg8uwkJerSo=;
        b=OjLK/LzmakC9q+Ky0IPSPdvlUJBJOgYyE9Ex77wCzM/VnvY58XLmQLhzSkI843kIYe
         1DMnZzcVXQDCGw6p4q0TnzS392BUDfkJTg6liO7VRYEByFhmTFmEcjxwjQB7ktXks1dD
         yUNd+0zQ880Y3SvD3J3afl/p6rMrqr3RDikiK2sAQO8+htVT+si9yBgXrxOSTZtnwEuO
         t3W0fOBMqfjVWGqw5yYAGuIkAVzmAJjPauCwx/dsJ6qr6e4C/+0ejt/eU1SuyLc6jMOv
         l/r4oBtAdvv0LoGRVKIZaRzYSvZHIBMyGMltWUDv8YbdCzL3oGWaKVa5KQaWMYHfPrms
         PuGQ==
X-Gm-Message-State: AOAM531dwJQTU7cmkIJRvbhWzJcPw9Z+OMp7BWyUQWbuNleMZNM7/ZAA
        1Et944ZnbYleV8HaXehCfFpeOQ==
X-Google-Smtp-Source: ABdhPJz90xv9qcJZ+8Y9UyxjTplrsAJYAQre05f8vuWMRfZU3sNC/KJEQBTrVc+8J1Ifr0wZizohdA==
X-Received: by 2002:a65:66c8:: with SMTP id c8mr16300316pgw.410.1604988379447;
        Mon, 09 Nov 2020 22:06:19 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 38sm11463133pgx.43.2020.11.09.22.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 22:06:19 -0800 (PST)
Date:   Mon, 9 Nov 2020 22:06:16 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Mirko Lindner <mlindner@marvell.com>
Subject: Re: [PATCH net-next v2] drivers: net: sky2: Fix
 -Wstringop-truncation with W=1
Message-ID: <20201109220616.7c3ecf02@hermes.local>
In-Reply-To: <20201110023222.1479398-1-andrew@lunn.ch>
References: <20201110023222.1479398-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 03:32:22 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> In function =E2=80=98strncpy=E2=80=99,
>     inlined from =E2=80=98sky2_name=E2=80=99 at drivers/net/ethernet/marv=
ell/sky2.c:4903:3,
>     inlined from =E2=80=98sky2_probe=E2=80=99 at drivers/net/ethernet/mar=
vell/sky2.c:5049:2:
> ./include/linux/string.h:297:30: warning: =E2=80=98__builtin_strncpy=E2=
=80=99 specified bound 16 equals destination size [-Wstringop-truncation]
>=20
> None of the device names are 16 characters long, so it was never an
> issue. But replace the strncpy with an snprintf() to prevent the
> theoretical overflow.
>=20
> Suggested-by: Stephen Hemminger <stephen@networkplumber.org>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Acked-by: Stephen Hemminger <stephen@networkplumber.org>
