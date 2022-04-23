Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F2250CDC2
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 23:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbiDWViX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 17:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235452AbiDWViV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 17:38:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2658183A7
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 14:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650749719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RUwpgSSUAur0EDC1NUIbYERR3lQ/safxN6o8dYkMA9A=;
        b=BYTIeR/YE+C4CLyMnOKe7ZBFu0869AmSQLmw0SuaZux2z7sLvoriM1X1XUREad+gIM8wlB
        SLnMcmIHEtLkDHJ0U/qtiYwaVnx07qFZ/2bfrFIYrGr3fLARMUB5k0+GPJMC1qLq8qylSh
        aNHGBlpSp2/0z75ag5tGWT47L4UVs64=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-UQ-EQaIUMjqiGuo56vz3CQ-1; Sat, 23 Apr 2022 17:35:18 -0400
X-MC-Unique: UQ-EQaIUMjqiGuo56vz3CQ-1
Received: by mail-ed1-f69.google.com with SMTP id cn27-20020a0564020cbb00b0041b5b91adb5so6720583edb.15
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 14:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=RUwpgSSUAur0EDC1NUIbYERR3lQ/safxN6o8dYkMA9A=;
        b=j5y09p98TNISLiGnMRplRKE+FH3cAV+6Sj3vn6Ikqzc9CEUDrOAjxF4rN6bfQOO6QO
         ZsKfR311Tp+JkvNBa9Gjk5U3PSbVEvzzNzW1OJeBR9Y7Bw02YnkBxI9EU3r2NzBNbcNE
         H1xStQWFdN1C39K/rln5ncmA+XPAZQRPFkf83tPHdYEK8jFUXUMkjz4tGQblHOpN4i1j
         yHjJdllHZLoKttXYpYWDXk6SiD7ZFAQYDgQAb7BtVwhnT3OFutkE5gFkkuc20nk5iEIi
         vlyt8benUe7+Gt24UxIWpo705hscATtXqkYtvAqBRAl6gUZEsssc652MNWzdO0qtC6lV
         Gt3w==
X-Gm-Message-State: AOAM533n9EqInR6ONYYfr7SB62e47yuoMv1nbRLBTUOohtW658z0DU4I
        6OGjT9ayfqMf5LOQYcf0JoNB4myGReOJv7v0PD6rRkx4eYwI9QV0UZw3eO/juCg63SggNOeQVJ/
        8iAxzZJsNB+PBDJlO
X-Received: by 2002:a17:907:1c8d:b0:6f2:eb2:1cd6 with SMTP id nb13-20020a1709071c8d00b006f20eb21cd6mr2502172ejc.568.1650749716304;
        Sat, 23 Apr 2022 14:35:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+MmJL9lcXIxyBtaS9YGexJ9aUydORgjK8/ZULrhYNJRQUyvU4bpt8M1LUOrr+dMYlask+Ow==
X-Received: by 2002:a17:907:1c8d:b0:6f2:eb2:1cd6 with SMTP id nb13-20020a1709071c8d00b006f20eb21cd6mr2502140ejc.568.1650749715567;
        Sat, 23 Apr 2022 14:35:15 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z3-20020a50cd03000000b00425d72fd0besm726334edi.97.2022.04.23.14.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 14:35:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9B6AA2D1FC5; Sat, 23 Apr 2022 23:35:14 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, haliu@redhat.com,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2-next 0/3] Address more libbpf deprecations
In-Reply-To: <20220423152300.16201-1-dsahern@kernel.org>
References: <20220423152300.16201-1-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 23 Apr 2022 23:35:14 +0200
Message-ID: <87v8uzbi0d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> Another round of changes to handle libbpf deprecations. Compiles are
> clean as of libbpf commit 533c7666eb72 ("Fix downloads formats").
>
> David Ahern (3):
>   libbpf: Use bpf_object__load instead of bpf_object__load_xattr
>   libbpf: Remove use of bpf_program__set_priv and bpf_program__priv
>   libbpf: Remove use of bpf_map_is_offload_neutral
>
>  lib/bpf_libbpf.c | 30 +++++++++++++++++-------------
>  1 file changed, 17 insertions(+), 13 deletions(-)

For the series:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

