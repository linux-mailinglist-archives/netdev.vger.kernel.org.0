Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F322924A850
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 23:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgHSVQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 17:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbgHSVQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 17:16:46 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1014CC061757;
        Wed, 19 Aug 2020 14:16:45 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id b30so12806701lfj.12;
        Wed, 19 Aug 2020 14:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xg5qNlyjDK4H9Bsa0SxjBV5q9nAUK79Dx84r0nHodF4=;
        b=DkyFs4wxFzSvzO4KjO65oA/ou2mXckXka5g3fyo0dbU9Vr/+/dDyHO26PGm+ml2ntA
         GBNoxFHh+7q4p0nEysDmUqICgy1Q7zm/3QuTWU9ehTGesdI0KXYSWGtzprLuJnmtYmpB
         DjZ9EoGtZtYpThn8JxUG/fLDCNWQcayQp+oHSIwKjFuEaDAIPp8+loSp6wOLwrEVS4zc
         kKVNHg0dd/TngzHF19ba3/r4vH982TrZSppzaRLw1xPpo9f7XHsxZ0TmrQRijsptKBAu
         Za9nHvu+NGKsW2ueisNClpaQVTlQIaGb+XdoiygCwYItOje/uT65x7TMmkLGve0982a7
         yMMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xg5qNlyjDK4H9Bsa0SxjBV5q9nAUK79Dx84r0nHodF4=;
        b=QBhsvokYhtUdHMwAwjdR+Gi1Apc1rVE3qIcfMiGxF+OHQdsShwd9qttWuvRqRb+LUm
         NHnNTd20isYaw6+5YTXwKVDFoAnplQbyJz9xy3dJux2A95iR8w5Dy6JoNA0s+wTQp12L
         1oVkO3ll4QzSDbHjU6EkqedECZXytKqZ8sc2onhfVPP8JQzfdQhzAJQ2xAY7NDN6rIXB
         9qG8dgNpvjgDsX6ua1hRE+HzBa0SfN3rmrGHRFJtBuoptrErylQ4TWdMcpHW/w4ZDwI7
         t4a1/ZWJLWFLehIkoxe/5bbNA7iRtD2Ra/ZZnXiY3BdFegER1mp2NCanhRe1uo6EeOnH
         899g==
X-Gm-Message-State: AOAM533E8jE83PKmzTBorVRWPfMdQb8eijBKLw2Pc23GzV4ODobcSz8W
        NSAzSCBb7vxQAaWwN+Q2pLoerbmNmZvakkoEXFQ=
X-Google-Smtp-Source: ABdhPJyGmgefAqX2JVKjpv6UI6kte9JS0c2dIxSnfGOXva/YnJe0UhsHDjklh9MQ3Vc9JxT2knWW4DConUyKAXVFI3o=
X-Received: by 2002:a19:cc3:: with SMTP id 186mr27554lfm.134.1597871802486;
 Wed, 19 Aug 2020 14:16:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200819020027.4072288-1-zenczykowski@gmail.com>
In-Reply-To: <20200819020027.4072288-1-zenczykowski@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 19 Aug 2020 14:16:30 -0700
Message-ID: <CAADnVQLAmaAcEnozc76DykkmbUA4Lc0-hcBAyCgroRzCwevmcg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] net-veth: add type safety to veth_xdp_to_ptr()
 and veth_ptr_to_xdp()
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 7:00 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> This reduces likelihood of incorrect use.
>
> Test: builds

I kept this in the commit log though it's a pointless comment.
Please reconsider for the future.
If you want to mention how you've tested it, please say so after "---" line=
.

> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>

Applied. Thanks.
