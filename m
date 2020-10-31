Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5392A1820
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 15:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgJaO0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 10:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgJaO0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 10:26:32 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84E5C0617A7
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 07:26:30 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id t15so2617824ual.6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 07:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SHI3Q2fOLLrmm4wKuaWbsYixW7vlYPYxYs2uwmG193g=;
        b=MQ+2Nno/5EgRdUUjWKkb0/1gLXIdbUJ/gLkqb3dmOj2il0PyPjQEUxrEJBQlxTAE4Z
         2d3FT2s30oFvxAfmmeNRPPyqaxWLDLiCLkI4I1xjKlJCM7zWwcb6YKAkw4bcD3tu7zX4
         J6SvjzGXzY04o41b+DYFOOC9j43eBhuGqTlGubzVBETwXFeu9icVjt1xsIP3nA2KJFzY
         hhbXVrprrpENg8f1xtlcjb7Dcotqp4WK2DPLhiGK1+Oj2SXLOjynEJZLvYEUkLB1peFe
         KhFXNCEp8FNCSZSmpcdJNasHFDWgZj/Ges8sINyHxIS5JeF4p8oXJN6XhfiQ9Nhpzbcy
         2LOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SHI3Q2fOLLrmm4wKuaWbsYixW7vlYPYxYs2uwmG193g=;
        b=GfpkUN+VuTco+ykeiuKIQZnZHE3AuqZQyfyKh940eaYS73yWiF3D0dg9FGD/51NZgj
         xImQN2W/S0xYli641xxHQhFdETqzTXTaXXccXAZux4Tpl+tw57MD03QwpdOdQnHAFBDd
         dUnahUSscAVudxS8gxQJqo1pzQayZIcQcIHH4j8PdHYh/D2d2zwl49XcK9zx3LOGVuFk
         eeKHkklAKIL/VLYk5B1eSXTp0g6R3+ree6aWqRbQ7gPYOEf8NytFl69hxyTyoipNM65W
         Qv+y0rEp2vANHVJTU8fQpsBxr4QkwPJSj0FaBHcPEAkzAZbYO0Jdah+1IQe4rvFR5mWr
         sOWg==
X-Gm-Message-State: AOAM531FMnsRwoSujgSlgqKL7KyvNJUhcqvHAht/3NVQ2daaFtmpcuDs
        8VB4ikE4Rj9M18YxfPtdlAfReHIW/2k=
X-Google-Smtp-Source: ABdhPJxFJmVEx8dvJprQnbYLPa1jEfwnnS/gHnpx9oHcl3P4nHGF6C1RdkJnu1Zr0nqISAaQ5UTHBg==
X-Received: by 2002:ab0:36ab:: with SMTP id v11mr4182865uat.5.1604154388917;
        Sat, 31 Oct 2020 07:26:28 -0700 (PDT)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id s6sm894672vkk.20.2020.10.31.07.26.27
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 07:26:27 -0700 (PDT)
Received: by mail-ua1-f52.google.com with SMTP id f15so2605262uaq.9
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 07:26:27 -0700 (PDT)
X-Received: by 2002:ab0:299a:: with SMTP id u26mr4227896uap.108.1604154387016;
 Sat, 31 Oct 2020 07:26:27 -0700 (PDT)
MIME-Version: 1.0
References: <20201031004918.463475-1-xie.he.0141@gmail.com> <20201031004918.463475-5-xie.he.0141@gmail.com>
In-Reply-To: <20201031004918.463475-5-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 31 Oct 2020 10:25:49 -0400
X-Gmail-Original-Message-ID: <CA+FuTScDa4NEo0xh1Uu+cB8QZ5mbVs6QvP0=xkritTzS9U7TYw@mail.gmail.com>
Message-ID: <CA+FuTScDa4NEo0xh1Uu+cB8QZ5mbVs6QvP0=xkritTzS9U7TYw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 4/5] net: hdlc_fr: Improve the initial checks
 when we receive an skb
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 8:49 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> 1.
> Change the skb->len check from "<= 4" to "< 4".
> At first we only need to ensure a 4-byte header is present. We indeed
> normally need the 5th byte, too, but it'd be more logical and cleaner
> to check its existence when we actually need it.
>
> 2.
> Add an fh->ea2 check to the initial checks in fr_rx. fh->ea2 == 1 means
> the second address byte is the final address byte. We only support the
> case where the address length is 2 bytes. If the address length is not
> 2 bytes, the control field and the protocol field would not be the 3rd
> and 4th byte as we assume. (Say it is 3 bytes, then the control field
> and the protocol field would be the 4th and 5th byte instead.)
>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>
