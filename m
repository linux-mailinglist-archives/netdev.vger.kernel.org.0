Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72619608369
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 03:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiJVBwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 21:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiJVBwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 21:52:42 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCDD2CDEB
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 18:52:41 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id pq16so3874446pjb.2
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 18:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=afdPZP8v0TX/Zy/NVaOu1EQ1KzFRj9XO5sdt02N1QIw=;
        b=byBUNwzD8BfQT9gPd+UCau35i3Ec29XlEf03viviGcFtuMa8DoaRnaCDMKhdTiatp8
         5dQWKnm+fZbZN4Vmkd4XLd73XU6Vzb6AR5kS9QxTBuDw+YrG5xKFVjsWgwTFndV+RIZC
         Uf0XNfm4mPIBksl8MOtKh14ETZpxxZjKMiFoc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=afdPZP8v0TX/Zy/NVaOu1EQ1KzFRj9XO5sdt02N1QIw=;
        b=atsjo8bQ0FtxOMqIQAhNaQ5S3y4m+nR1uQb6nOUTIfD50/8p5h88DU6X23GpTHkg55
         zI7HyRc3jHKVCfGlH9Sz10Ch7DvjkykRnGgHcgmUBhRBAeuEmfOebfTkf2+Py8daoqKw
         NMvzTlFQu89kBOByXqk51y3UvjPM2D/SetJx7UWYCTlmJPK0SU/qE0OjgHutxs+S+ila
         b1z61oGVUEiFRlQKe4IxwL2jyiU0iMAQEWOvPACreQk0UqmfNx2nB8EqJt6ZzMCsgjsP
         tgn9ejWpGnRLWO81IUAsMwojvPSc9yDgW1c50rHO3quD6REiEte4WjOsUYWW9RtqZzK1
         zxgg==
X-Gm-Message-State: ACrzQf1+3rQ/z15H1wODpK5ihgopFcT0oIt4t6pFVgFtpYOFrwozAzsm
        1HqrzpRMsnsUCbeNlGIEsT+IqA==
X-Google-Smtp-Source: AMsMyM7l25D5mnCDMTSTKy8YeC1DWpS7hmUeK83OHYzC79a0fjn9W2pNlDjM9O49hOYPIB1DCr7NCw==
X-Received: by 2002:a17:902:d2ce:b0:185:3f05:acf4 with SMTP id n14-20020a170902d2ce00b001853f05acf4mr22427322plc.35.1666403561336;
        Fri, 21 Oct 2022 18:52:41 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id pf9-20020a17090b1d8900b00212cf2fe8c3sm3180998pjb.1.2022.10.21.18.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 18:52:40 -0700 (PDT)
Date:   Fri, 21 Oct 2022 18:52:39 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Dylan Yudaken <dylany@fb.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Petr Machata <petrm@nvidia.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Congyu Liu <liu3101@purdue.edu>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] net: dev: Convert sa_data to flexible array in
 struct sockaddr
Message-ID: <202210211841.031AB46@keescook>
References: <20221018095503.never.671-kees@kernel.org>
 <bd11473cd4e2a92c4ce2a32d370800522862ad4b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd11473cd4e2a92c4ce2a32d370800522862ad4b.camel@redhat.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 10:58:50AM +0200, Paolo Abeni wrote:
> On Tue, 2022-10-18 at 02:56 -0700, Kees Cook wrote:
> > [...]
> >  struct sockaddr {
> >  	sa_family_t	sa_family;	/* address family, AF_xxx	*/
> > -	char		sa_data[14];	/* 14 bytes of protocol address	*/
> > +	union {
> > +		char sa_data_min[14];		/* Minimum 14 bytes of protocol address	*/
> > +		DECLARE_FLEX_ARRAY(char, sa_data);
> 
> Any special reason to avoid preserving the old name for the array and
> e.g. using sa_data_flex for the new field, so we don't have to touch
> the sockaddr users?

Yes -- the reason is exactly to not touch the sockaddr users (who
generally treat sa_data as a fake flexible array). By switching it to a
flex-array the behavior will stay the same (especially under the coming
-fstrict-flex-arrays option), except that it breaks sizeof(). But the
broken sizeof() allows us to immediately find all the places where the
code explicitly depends on sa_data being 14 bytes. And for those cases,
we switch to sizeof(sa_data_min).

If we went the reverse route (and added -fstrict-flex-arrays) we might
end up adding a bunch of false positives all at once, because the places
that treated it as a flex-array would suddenly all begin behaving as a
14-byte array.

-- 
Kees Cook
