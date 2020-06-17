Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0091FC601
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 08:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFQGG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 02:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgFQGG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 02:06:57 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13C0C061573;
        Tue, 16 Jun 2020 23:06:56 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id e11so1027930ilr.4;
        Tue, 16 Jun 2020 23:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=zHrUCO/oNUYjf/faAK30te3+V9lAT2QghuZ60eRR4As=;
        b=VJNBrhtlcmtvLVy7Df7Kntm1Boq7mhSqjSmqJX6yzEOIWerwbivWRvsrRj6ccFBVbt
         tX+bNkeN3vbUP8hQzatHW42WJwsU71wo6whxACPRZOxIuzLRkdnTovVfLsakRss5ngTj
         EypjF3eih9xiAPXROcrp3TTKIVC8lY30dU0QxwHjkNMESZvMb4mnk7cNKqWGXoR4RhQy
         sLFOa8QmpdsEBEbVkOYI38JPFT0kCJGGyNH4g1FIPNorcD8QsUcsZi+U12A2rY7W/GBv
         XKzMVVAHYX7aQReYRo21Cj5JiKFO21pGOYzxOs3NrK0GP/0hJwLzExXvR1/SmE3a+klh
         1qow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=zHrUCO/oNUYjf/faAK30te3+V9lAT2QghuZ60eRR4As=;
        b=Ei6Ea2PR6i0GbAaS79ZtQrYL/iNpIVXOyRujBaTNIEIUwm9c90xTb8WEFS885iVCk0
         ldMk19z+reNRlO2TsCa+LwfMiAeAs6tYkgT7LsDUV9Ug2q2eX1tO8ifgqwJmGZZD3Fec
         1iwIcg3DBlzhXvNzKZG02nFb6F/S3UP4p5XdbQRWKW7rs9mguS3nx2Rl6En5lCnU13Zc
         9LsIwseobqg7nPsMbEEE1lVBw+jc0CU3s1aDdM3BBtSwihYAV81iKspBPlPFf65UoxSj
         s17t/Uqh+/qpJFidGlTb7Fwb+V27VhPPtJzWcSkbFlQwtttfWMOKtRIfCt85MGQW/X9f
         52ew==
X-Gm-Message-State: AOAM5312oicNyCPwHODHutBI/1MWnPPuTBd1eURiJkpIyBYk4FkgzfMJ
        CdFD44lLnd6Fnv3RCCtNBrAx+GCNYsE=
X-Google-Smtp-Source: ABdhPJyQIvZ3w4ar6IQE38KodzX7Ihg/U46oKdBvZH4/YmjqpF519scjzhAGWkbWuS5cv4fvBcZx7A==
X-Received: by 2002:a05:6e02:13cd:: with SMTP id v13mr6670550ilj.93.1592374016195;
        Tue, 16 Jun 2020 23:06:56 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 2sm11433878ila.0.2020.06.16.23.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 23:06:55 -0700 (PDT)
Date:   Tue, 16 Jun 2020 23:06:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xiumei Mu <xmu@redhat.com>
Message-ID: <5ee9b2f6a7be2_1d4a2af9b18625c480@john-XPS-13-9370.notmuch>
In-Reply-To: <20200616142829.114173-1-toke@redhat.com>
References: <20200616142829.114173-1-toke@redhat.com>
Subject: RE: [PATCH bpf] devmap: use bpf_map_area_alloc() for allocating hash
 buckets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Syzkaller discovered that creating a hash of type devmap_hash with a la=
rge
> number of entries can hit the memory allocator limit for allocating
> contiguous memory regions. There's really no reason to use kmalloc_arra=
y()
> directly in the devmap code, so just switch it to the existing
> bpf_map_area_alloc() function that is used elsewhere.
> =

> Reported-by: Xiumei Mu <xmu@redhat.com>
> Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up devi=
ces by hashed index")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  kernel/bpf/devmap.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> =


Acked-by: John Fastabend <john.fastabend@gmail.com>=
