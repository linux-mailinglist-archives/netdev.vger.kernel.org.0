Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05757430D4
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387935AbfFLUKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:10:23 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46895 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfFLUKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:10:23 -0400
Received: by mail-qt1-f196.google.com with SMTP id h21so19888610qtn.13
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 13:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=tjcULuVIIshCojU2HNorZY/2Ib3Oc3G9ImchPaHSWX4=;
        b=QA8N9ere1/+Mso9/7ufj4qBFF3laWlzveSLuc5+FSpNkPoNIPp53nMi8xn4esyn7xe
         aRl30Cy0+xrMzeaApq65qBUpIw4YP2lS4ZPhdJc/wkJSrhm3ID6lCOtzIolTGPwM0DQL
         w/GI0hSmyQtf2pvZmUmjpjK6s40sP8WFVAvwMqX6uFVAAnyINoYbRHgQqFThZgCMZGHT
         Mut09KMzs3xZEklu/T2ggTjp8EwmsKsyl+S1/meBtuSoHHWcc1L8rpWggAGffGOIycBu
         mMk085AjcUAwl2RrDt5jw6Q909wd2TnOoHSEDCjlZglET6ZuFVOzPdf8kIjIzboLqkTJ
         bPXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=tjcULuVIIshCojU2HNorZY/2Ib3Oc3G9ImchPaHSWX4=;
        b=C9Hwzbp33oWHmmutKYXlevJvMAHxPL9OFTOqMmsJI9FUFxjtSl0kIZ2z8iZMwEpyou
         tXqeCqglDrnS+3kvbmDnHaYwxq4y2+sQ4MPnoUW/0pZAjwDVF++DpcHv4Ep3N9FGgqax
         /wFe+riC5lDbDJUOm+oIVls6nv9m4JdtLgUfBdwBNfqFQKVZvNQ9h32o8nVyTXczw8/N
         yBgJDNbbW8KSgVb5+32226wURDTJXUDXBSMvppso2o07+BB7JCMXFELlZdC7axgXcXZk
         mUIhyt+1aPf9PoENN1pgUgC+7/MagJRuZM8i6/QHtCTMLOjdT4h/F3YyOyGsap2CzE9Q
         XIlQ==
X-Gm-Message-State: APjAAAXUqCXqDpFEA+6w1gr/TQ/FFdz7qMHuJpHFinzcOkIiz+6GL5en
        vNbIiZsqYrQVLHIUYpLUBg5CjQ==
X-Google-Smtp-Source: APXvYqydVI7I1cvD7d9ucXZgBk6TNKvV1oANHC0Q1FJZO0S2+Lo+l8cNY68dY2ybu7CfEuj4CfNlgw==
X-Received: by 2002:a0c:942c:: with SMTP id h41mr336156qvh.146.1560370222383;
        Wed, 12 Jun 2019 13:10:22 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z57sm512762qta.62.2019.06.12.13.10.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 13:10:22 -0700 (PDT)
Date:   Wed, 12 Jun 2019 13:10:17 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
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
Subject: Re: [PATCH bpf-next v4 05/17] xsk: Change the default frame size to
 4096 and allow controlling it
Message-ID: <20190612131017.766b4e82@cakuba.netronome.com>
In-Reply-To: <20190612155605.22450-6-maximmi@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
        <20190612155605.22450-6-maximmi@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 15:56:43 +0000, Maxim Mikityanskiy wrote:
> The typical XDP memory scheme is one packet per page. Change the AF_XDP
> frame size in libbpf to 4096, which is the page size on x86, to allow
> libbpf to be used with the drivers with the packet-per-page scheme.

This is slightly surprising.  Why does the driver care about the bufsz?

You're not supposed to so page operations on UMEM pages, anyway.
And the RX size filter should be configured according to MTU regardless
of XDP state.

Can you explain?

> Add a command line option -f to xdpsock to allow to specify a custom
> frame size.
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
