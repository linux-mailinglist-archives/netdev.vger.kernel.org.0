Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099CA3C54FC
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 12:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346538AbhGLIIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 04:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354902AbhGLIEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 04:04:55 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F04C06127E
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 00:59:45 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id hr1so32896291ejc.1
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 00:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xqzLCAD8n6/TJxpcOzgSFurYcUcekLK3Sst5Bp4tPmE=;
        b=cBu3zPqUiLDekKNV9n8THvGT6qR+qYMwfJRfH/5vc9SdU2qmtbWG6TOdPoUxYmISIj
         lag6WWFjuZ0vzTiNaK6xmPbuMzVoy4Ku4yrqSWJwlZFc6oMfizUcgkg1CCZ0wJGjPn9e
         HH8pULJ8YPhGJNlE3G5EzyuVK7LVO/HnPXpPlStD+CIL7JAtMTVWnX9ElklU07fZUoB1
         8/96Nku0x1/o4BwyojLplE3vJ20yHnprIpF7eqjUlvO99BZQoxhJWltoTMFLasXAWBOQ
         3uSRWDWkH7lEHYRaBbSeyJpRynDUP3AIq+NI2ZnIIr8l0R5hSYa1V94GydTr6haF/LH0
         4ITA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xqzLCAD8n6/TJxpcOzgSFurYcUcekLK3Sst5Bp4tPmE=;
        b=WDXPQstRDTDnXBERgUfdvST43RVihpBGiym01t/OVQHQ2/675xb39bVyYD4viwSltT
         F8bEi6o+Ml4kkTH7N8lf0BkmlhkLb0BDMXUQzuFaNp+vVQf7THsL27S8wk/kRaHnRFM/
         Gh1ob2WqNT07t7IRcA3A8x74JxB9FY2d+OKPwpez4/zLls53xMpcj3u6N2lNacMNtFl/
         zXaWLOXesRruiaxuY/o6rtf8w0uAW5SVUmXPW3Qw/uXFX78MQKxt77omuk8PZYMJY4CI
         8ocXKcjX5Ww/+aGv36fmYtio1xRsR1M7D9w9fZMQen8Od/DFfSrRmVkD1Dh42JtA/z4/
         DZ9A==
X-Gm-Message-State: AOAM530+RAIsCWxb4h+Lajla+AXXXUIs2rrCnVCSWNrPTCM0sEWZ+oGt
        X1CGoMpWA4OcovbvpmLwUk4wqBEJizZOIA==
X-Google-Smtp-Source: ABdhPJwl1HkjH2HYl8DwaaerC+xgKRXlsucuQPILTe3u3+9CXDn7EBgc7LVIHhT59DhqUozVd+KHkA==
X-Received: by 2002:a17:906:6b1b:: with SMTP id q27mr50667395ejr.169.1626076784414;
        Mon, 12 Jul 2021 00:59:44 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id q11sm5712304eds.60.2021.07.12.00.59.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 00:59:43 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id a13so24271656wrf.10
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 00:59:43 -0700 (PDT)
X-Received: by 2002:adf:b605:: with SMTP id f5mr57402308wre.419.1626076782845;
 Mon, 12 Jul 2021 00:59:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210712005554.26948-1-vfedorenko@novek.ru> <20210712005554.26948-3-vfedorenko@novek.ru>
In-Reply-To: <20210712005554.26948-3-vfedorenko@novek.ru>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 12 Jul 2021 09:59:04 +0200
X-Gmail-Original-Message-ID: <CA+FuTSdCMqVqvUKfM3+3=B0k+2MQzB0+aNJJYQZP+d=k2dy34A@mail.gmail.com>
Message-ID: <CA+FuTSdCMqVqvUKfM3+3=B0k+2MQzB0+aNJJYQZP+d=k2dy34A@mail.gmail.com>
Subject: Re: [PATCH net 2/3] udp: check encap socket in __udp_lib_err
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     David Ahern <dsahern@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 2:56 AM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>
> Commit d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
> added checks for encapsulated sockets but it broke cases when there is
> no implementation of encap_err_lookup for encapsulation, i.e. ESP in
> UDP encapsulation. Fix it by calling encap_err_lookup only if socket
> implements this method otherwise treat it as legal socket.
>
> Fixes: d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>  net/ipv4/udp.c | 24 +++++++++++++++++++++++-
>  net/ipv6/udp.c | 22 ++++++++++++++++++++++
>  2 files changed, 45 insertions(+), 1 deletion(-)

This duplicates __udp4_lib_err_encap and __udp6_lib_err_encap.

Can we avoid open-coding that logic multiple times?
