Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9E05424D3
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbiFHEkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 00:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234596AbiFHEjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 00:39:37 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E436E40526D;
        Tue,  7 Jun 2022 19:31:33 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id c14so17591294pgu.13;
        Tue, 07 Jun 2022 19:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WQvQY+ADLGT2QDH70b+ZWh3UHUjombhATOznDP82LSo=;
        b=Rpju3qHcdktw3PMpD8A6ZKaFhlg1gB3Gtg97W/kqWJ5nJPUPzDDtEFo1pmDglljD6k
         dLd2+tLbNEO18a2tavZDzNlPNMlH1ZpA6YSE84mRz9hBZYtcMxI1Vh+WPoDbdWjc100K
         mLOmuu+KwaiEgbFrSNtfsXxoxYrshVLNM0fqxuqKWFEM78WOS0GAR3uOfWZLflkZKCpV
         kD35UuMSWMrC3yiX6ee1DgSeG3rNbSU4x7yticKnuqpQeF4KUb+zQ1fk42/j1NfCFL4B
         PgxDUyMKtcxYqfZDNpcRFD/6vAW2rJqYKC+lzyScFmG+U2a4t9sgfrU5dsVB6yJNUwSz
         VBUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WQvQY+ADLGT2QDH70b+ZWh3UHUjombhATOznDP82LSo=;
        b=lmj/Zpz0nedL6S1Ny5LFiz6mvgw+1yZ/ikUjm9zjIv90KFC5tLCt86F29KdOAWsDAV
         6fEtlVKdrjOkBP303Sx/mDOOIsmRWU/uWf40ETSA1xWf2OjFYEeRc/bLFrHN/m+LuU8w
         94YdpMKjaWkmq7+pwJgvNklbxXld3jkaUzBDva1dbns/uD6chsl/EkpPHuh/jQ3+Pf6S
         IFiQQNTdb6Ki0/bpXzueves1RRZ4Qe3WlvDVWVdB7pshM2iuwZaf5O/W/M0BjviNaZo+
         Drb/SRb9zgf7hF9SUl1QxeolKY6Y/54JXdYgsQemGkc6vF+JHy0oU//y4Tz/BNgNlF+T
         4sGQ==
X-Gm-Message-State: AOAM530GbL+Kt+h6EnRlosMuj9sZU0VBogTBBRy7B1t83AhkIPaMT/0J
        sxIP9rrOnpoCLaA079Zh0Tg=
X-Google-Smtp-Source: ABdhPJyf581BY03EAX1U/cMXItUsWEKvpexvxdCH9iuV/UNPQJkQ9Knw/ayTsyYNuPsUKpVmXIm7wA==
X-Received: by 2002:aa7:8d11:0:b0:51c:4f6d:1562 with SMTP id j17-20020aa78d11000000b0051c4f6d1562mr2423956pfe.14.1654655490220;
        Tue, 07 Jun 2022 19:31:30 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l5-20020a622505000000b0051c1b445094sm4905282pfl.7.2022.06.07.19.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 19:31:29 -0700 (PDT)
Date:   Wed, 8 Jun 2022 10:31:20 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH bpf-next 0/3] move AF_XDP APIs to libxdp
Message-ID: <YqAJ+N/ULcRf6ad2@Laptop-X1>
References: <20220607084003.898387-1-liuhangbin@gmail.com>
 <87tu8w6cqa.fsf@toke.dk>
 <CAEf4BzYegArxq+apR+GZ+cYNQtAnnxaZWKOAKd+3tnqpKdq3ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYegArxq+apR+GZ+cYNQtAnnxaZWKOAKd+3tnqpKdq3ng@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 04:28:36PM -0700, Andrii Nakryiko wrote:
> > Kartikeya started working on moving some of the XDP-related samples into
> > the xdp-tools repo[0]; maybe it's better to just include these AF_XDP
> > programs into that instead of adding a build-dep on libxdp to the kernel
> > samples?
> >
> 
> Agree. Meanwhile it's probably better to make samples/bpf just compile
> and use xsk.{c,h} from selftests/bpf.

Hi Andrii,

I didn't find xsk.{c,h} in selftests/bpf. Do you mean xsk.{c,h} in
tools/lib/bpf? Should I add

TPROGS_CFLAGS += -I$(srctree)/tools/lib/

in samples/bpf/Makefile?

Thanks
Hangbin
