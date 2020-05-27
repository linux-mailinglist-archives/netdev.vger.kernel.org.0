Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DE31E3E73
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgE0KCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:02:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52787 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725601AbgE0KCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:02:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590573751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MFxQEmnpo/yuk1k5Xq3mcNXwMoV0a75YzIq7oi6giio=;
        b=a9JSbkwmKTvZyDNMHWmKzOeTLF1TR1Wwb3Z7Ncg9MoIaDsP2Jc8z1Dixw6Yg+WIenwutrx
        0VeNeGoSOSDKixHS0MUavrWzfakkQ9uEKGcrPB8atmI6KnOBLfWCxxTapI6Qr7VzhGomaa
        S1qgkzE6Pape2nKDoiuq2vVvgeubg28=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-bPYn8yLrOHOqQB60r2ob5w-1; Wed, 27 May 2020 06:02:28 -0400
X-MC-Unique: bPYn8yLrOHOqQB60r2ob5w-1
Received: by mail-ej1-f71.google.com with SMTP id pw1so8625953ejb.8
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 03:02:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=MFxQEmnpo/yuk1k5Xq3mcNXwMoV0a75YzIq7oi6giio=;
        b=G+f7WrqvyI0hsN50heuv4YRiCB6a5PcFXy3iTFxZahA9+deGXhyCn1Qk+1mS3lTcN8
         JdFpGCJkdW37Zszj81R7eS8zCRaGKn8xk4gdjebyE4DAxRAB0s5wuKoYgHrRXb34Y2Dv
         P+b/WEjIAgAitq3fWKYqbXzDjVBoEko21UdJqGhvIdS+1qNNSdkz4i+GfRNmWJ6KnPBy
         KGYbJqEl0uzy1OwZufapGInGuOwknD/utCst4fXkLuYIGlbLYoNupgUALVnK9/ijJG6L
         8h/+Bt1cUxRhppSe8mnJvvYH6+PGtrk/XmxePjsbU2z2KWUUk/R52GjXljz4rNAu+Us4
         1vxQ==
X-Gm-Message-State: AOAM531WqM3i4EHdvykLXyqLK1Ps23Hb0+jRmuNxdGvAUSejc+ctdWMk
        AoHFXtqGXjUppQAYhP1yfVt72ND+L/U4c0G3VoT3P62uigTaYITw+NisBvlo7qZRYGr/3xbNkE5
        eBtjZraSMbeW8hpeH
X-Received: by 2002:a17:906:6c97:: with SMTP id s23mr3974491ejr.421.1590573747230;
        Wed, 27 May 2020 03:02:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvUT0ty8wleMn99I1zfcPYeL96dcuqJ9im3AgQsmOqU0JUkB4Q1ylWfUh/slmmLuNgbE834A==
X-Received: by 2002:a17:906:6c97:: with SMTP id s23mr3974470ejr.421.1590573747019;
        Wed, 27 May 2020 03:02:27 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k27sm2349345eji.18.2020.05.27.03.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 03:02:26 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 115D91804EB; Wed, 27 May 2020 12:02:26 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH bpf-next 4/5] bpftool: Add SEC name for xdp programs attached to device map
In-Reply-To: <20200527010905.48135-5-dsahern@kernel.org>
References: <20200527010905.48135-1-dsahern@kernel.org> <20200527010905.48135-5-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 27 May 2020 12:02:26 +0200
Message-ID: <87367l3dcd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> Support SEC("xdp_dm*") as a short cut for loading the program with
> type BPF_PROG_TYPE_XDP and expected attach type BPF_XDP_DEVMAP.

You're not using this in the selftest; shouldn't you be? Also, the
prefix should be libbpf: not bpftool:, no?

-Toke

