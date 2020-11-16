Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8192B4006
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgKPJlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgKPJlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:41:23 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D37EC0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 01:41:23 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id c20so13595158pfr.8
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 01:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6fzRGcF2f5tFoFwvys8VZBGWlajGvKg0DJjdpbzuzA0=;
        b=O0zaiLKi1+9kzKuXt6zMbdQp7SWpKVbP5X+apVBf1Ka0Sv193qIywfMTjjObYceO/x
         4TMxVq3CmbgKaS+TzuJ8VPZY/4QSz703OazPWQ0Utr9gXbGLgwrO2FKbHfhwmxO1yiEX
         +zZ1kIo8FczNcuSVIkPyfHJZLG7tGGNSenBpFgEYCCsEQ75gtMsVV3odtNArzljpXDAM
         NoNE2KEMAc4mZxyNqLKkP9r/AmH8ofDHWve8hw/S8GEgXcqIw1U5llg/5QdOSOn9Ivf9
         5u0ZPw7riMlWYPo50/1g3Ufft+U6OKw/b48035moyungQ2zDVcCdDzTehjdf9k05Ne17
         j+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6fzRGcF2f5tFoFwvys8VZBGWlajGvKg0DJjdpbzuzA0=;
        b=eJa1b890qNmVDB8nXGRnInBgS6uQWtY/eWyf16/Q+u469Tb2YbuIShpa97G2JcrZVG
         g2tQMasLn2QXMwV0Pu4NM2u50gQDAAa+WEz4Kv+PHHxI64R/M9WG5ZYl7P+iGNnyyVVd
         EaRN/KtG0Fxlgi/yoGJRRk0uGYtTIGPADir3SafQyVnkJySdHIpQfXvwR35thk81w213
         Gut7jvh8wFeCCNW5Te0FYaH6yKSs7UhNLsUs+jbLcss6pNBwmcHlcDF565pIMxtFHTSg
         Uj8Rg+BG3HfoJP+OSEZLT+/TbvEfmrmS4AcnQOyBXv5N7nTU2Uz6RrXsH4+VA7k51mZs
         BQBA==
X-Gm-Message-State: AOAM531dsGt8X9DLNB6Tu1/+7fu/Ho/GtT1Nr8v/kdVdqNN8hRTDeGku
        1FuFwGgwvQJG+OsuAAyFNx3M2dljyjthyxyXcSA=
X-Google-Smtp-Source: ABdhPJwLKgoLxaacjkG7SIPtuYJkviJKA9xPpSof+g1KvR10O+DaOAcWHUOjKYEXWTbI1BD4y+7CmXKaI5ipjoUk2n0=
X-Received: by 2002:a62:7bcc:0:b029:18b:5859:d5e1 with SMTP id
 w195-20020a627bcc0000b029018b5859d5e1mr12906812pfc.40.1605519682660; Mon, 16
 Nov 2020 01:41:22 -0800 (PST)
MIME-Version: 1.0
References: <20201112064005.349268-1-parav@nvidia.com>
In-Reply-To: <20201112064005.349268-1-parav@nvidia.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Mon, 16 Nov 2020 09:41:11 +0000
Message-ID: <CAJSP0QXN2VGgKwQ_qL3Fr0dAYDviZcFDgUrE8FhHZwBm9wpBoQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] Introduce vdpa management tool
To:     Parav Pandit <parav@nvidia.com>
Cc:     Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, elic@nvidia.com,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Great! A few questions and comments:

How are configuration parameters passed in during device creation
(e.g. MAC address, number of queues)?

Can configuration parameters be changed at runtime (e.g. link up/down)?

Does the configuration parameter interface distinguish between
standard and vendor-specific parameters? Are they namespaced to
prevent naming collisions?

How are software-only parent drivers supported? It's kind of a shame
to modprobe unconditionally if they won't be used. Does vdpatool have
some way of requesting loading a parent driver? That way software
drivers can be loaded on demand.

What is the benefit of making it part of iproute2? If there is not a
significant advantage like sharing code, then I suggest using a
separate repository and package so vdpatool can be installed
separately (e.g. even on AF_VSOCK-only guests without Ethernet).

Stefan
