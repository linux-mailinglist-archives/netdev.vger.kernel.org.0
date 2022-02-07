Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910D24AC926
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 20:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238639AbiBGTDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 14:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbiBGTDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 14:03:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03AE0C0401DC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 11:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644260595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P75Jy9tSiJlIoMNeAc3/UeC3feublTkmRgYRBOQ76WE=;
        b=cY03deFS6ogVpOHaZQJcUXGLgc7jP7P1sWtqztuLLe8CBNftxsMXhc/b/gMVaaDYH2Uogz
        J8uT11lcVVSwWflTdac+3AYvEhT5xWT0RznMy4+gSCB2UvlDzB65N7UonAJDvLip7ImgJf
        Y+m3NRHjUXet2/CJz5mManlpS5Uql/4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-3463t094OsyqNLf_lqesag-1; Mon, 07 Feb 2022 14:03:14 -0500
X-MC-Unique: 3463t094OsyqNLf_lqesag-1
Received: by mail-ej1-f69.google.com with SMTP id r18-20020a17090609d200b006a6e943d09eso4694372eje.20
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 11:03:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=P75Jy9tSiJlIoMNeAc3/UeC3feublTkmRgYRBOQ76WE=;
        b=xe0hC1hFPm452CtLoeoshnC++Sh+U8pFnmiDsAZIOLk8rEmBslQ61tdID5JlRL8l0F
         rXlN0aZXfEAAqdeL0nfASJyuWABZV5nAuMXfX4liuIwGdENVGPWnKCHhsPZMlM4r6UHS
         zS2rdLF/vUfXjcn/vOtjMndhHauGSzLu+jha4XUj0DjfEZptZmMt2XcbCq9JxUSIlvMz
         95Z2+f2mJn6f/+LZD+z5b7oUF8CdzYG4mbR/XWuNLEMDhaIpS/KGN6TQzxSbahc3+T24
         oRfzoofqrU88WDsfMjRdChyrtMWi2wHsEF0/F8CD1bgN3LGMHWmtc0xa/EOquS9FPYu0
         XD8w==
X-Gm-Message-State: AOAM530w8Qj0Cza+rEjXDpICRaJuaUNc8/Zy8uLdpTNuWR9UPCF7Wk3s
        1Pi/HHvGR6YugfoSays7RUsNQ4ZT/VPZR4haA1bDBR2B9CZlmGyiOlVQ2oTf3SUFbURsQD5BtUI
        j3sUmELU4vXFhG3NJ
X-Received: by 2002:a05:6402:510b:: with SMTP id m11mr868906edd.203.1644260592586;
        Mon, 07 Feb 2022 11:03:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyqX/chLM/yp0TPZ2SIUHXk2J7y3H1JOCMLPpr+UFnl4YHPf8YUJBcRrAbFOaW75CiFSygeCA==
X-Received: by 2002:a05:6402:510b:: with SMTP id m11mr868864edd.203.1644260592070;
        Mon, 07 Feb 2022 11:03:12 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z6sm3963967ejd.35.2022.02.07.11.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 11:03:11 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 901A5102467; Mon,  7 Feb 2022 20:03:10 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Russell Strong <russell@strong.id.au>,
        Dave Taht <dave.taht@gmail.com>
Subject: Re: [PATCH net-next 0/4] inet: Separate DSCP from ECN bits using
 new dscp_t type
In-Reply-To: <cover.1643981839.git.gnault@redhat.com>
References: <cover.1643981839.git.gnault@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 07 Feb 2022 20:03:10 +0100
Message-ID: <87r18ea49d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guillaume Nault <gnault@redhat.com> writes:

> The networking stack currently doesn't clearly distinguish between DSCP
> and ECN bits. The entire DSCP+ECN bits are stored in u8 variables (or
> structure fields), and each part of the stack handles them in their own
> way, using different macros. This has created several bugs in the past
> and some uncommon code paths are still unfixed.
>
> Such bugs generally manifest by selecting invalid routes because of ECN
> bits interfering with FIB routes and rules lookups (more details in the
> LPC 2021 talk[1] and in the RFC of this series[2]).
>
> This patch series aims at preventing the introduction of such bugs (and
> detecting existing ones), by introducing a dscp_t type, representing
> "sanitised" DSCP values (that is, with no ECN information), as opposed
> to plain u8 values that contain both DSCP and ECN information. dscp_t
> makes it clear for the reader what we're working on, and Sparse can
> flag invalid interactions between dscp_t and plain u8.
>
> This series converts only a few variables and structures:
>
>   * Patch 1 converts the tclass field of struct fib6_rule. It
>     effectively forbids the use of ECN bits in the tos/dsfield option
>     of ip -6 rule. Rules now match packets solely based on their DSCP
>     bits, so ECN doesn't influence the result any more. This contrasts
>     with the previous behaviour where all 8 bits of the Traffic Class
>     field were used. It is believed that this change is acceptable as
>     matching ECN bits wasn't usable for IPv4, so only IPv6-only
>     deployments could be depending on it. Also the previous behaviour
>     made DSCP-based ip6-rules fail for packets with both a DSCP and an
>     ECN mark, which is another reason why any such deploy is unlikely.
>
>   * Patch 2 converts the tos field of struct fib4_rule. This one too
>     effectively forbids defining ECN bits, this time in ip -4 rule.
>     Before that, setting ECN bit 1 was accepted, while ECN bit 0 was
>     rejected. But even when accepted, the rule would never match, as
>     the packets would have their ECN bits cleared before doing the
>     rule lookup.
>
>   * Patch 3 converts the fc_tos field of struct fib_config. This is
>     equivalent to patch 2, but for IPv4 routes. Routes using a
>     tos/dsfield option with any ECN bit set is now rejected. Before
>     this patch, they were accepted but, as with ip4 rules, these routes
>     couldn't match any packet, since their ECN bits are cleared before
>     the lookup.
>
>   * Patch 4 converts the fa_tos field of struct fib_alias. This one is
>     pure internal u8 to dscp_t conversion. While patches 1-3 had user
>     facing consequences, this patch shouldn't have any side effect and
>     is there to give an overview of what future conversion patches will
>     look like. Conversions are quite mechanical, but imply some code
>     churn, which is the price for the extra clarity a possibility of
>     type checking.
>
> To summarise, all the behaviour changes required for the dscp_t type
> approach to work should be contained in patches 1-3. These changes are
> edge cases of ip-route and ip-rule that don't currently work properly.
> So they should be safe. Also, a kernel selftest is added for each of
> them.
>
> Finally, this work also paves the way for allowing the usage of the 3
> high order DSCP bits in IPv4 (a few call paths already handle them, but
> in general the stack clears them before IPv4 rule and route lookups).

LGTM; thanks again for doing this!

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

