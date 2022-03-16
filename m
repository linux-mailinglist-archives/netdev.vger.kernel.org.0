Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B9D4DB523
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357315AbiCPPrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352264AbiCPPrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:47:04 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3694D6D1BA
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:45:49 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d7so3555432wrb.7
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wAgk6NoEkSGQYtklkyp/XBe3mmZFGzBwfiqA3+Hd+Uc=;
        b=UaDuw6uE+eA3eoFtbNNWGH31fmxdFNfCd+8KTwJiz+XVa67E6qGA7rnSF18inN9r7Y
         qagW0lhTrjPtdLbMts8uQresOtZcaucElVE6QTjJOHL4nHQiHmARLSAiHbxM+ilNC8I9
         0pB+mcIYzA8CpBXVvR2Muc6zTjci9aX7iOglulhiX/5PGxKANkvqyGmlBXTy1HgQZtZa
         dbiMZu3JglXKMidVnZzd7qJ7o28dPtoNgg2mpDLH8lwkr9ymuiri75xLap5GrnGWoiKM
         2YmMN97zjLq8pQYxfLoXbmyytnuWDrXDEPJT6p/AzVirsoxEYO2L+1VZIt0QeRwrV5A/
         a5Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wAgk6NoEkSGQYtklkyp/XBe3mmZFGzBwfiqA3+Hd+Uc=;
        b=6eaolX8MbhvgMwJz6hDMkMAqGoP4GCdzerpvR2ONVQofEJTUfMQKhhfq+7TdhFEXDB
         VRHU7kSTsrt2jxq2BD0k2hoUVZXpvhQJNutz1PkJF0cQfXaZwMxnhom0QcFVr0Ytl0dK
         6FQTU+359NFfIp/cXoK6UoedfB5DVso2xO9J2YVXBt+D3t/j8ko2Hah6QY51ytmV5RZO
         hOtJj/kWAkJAqQ48oXTDxhUr+0KMJBUS04yd/6b1HfoD8qgTyE2o0wOCKvaYpm4/KBeg
         bZ6gApPYAfFkcmKBcP8cQ6rC4YEeHbjSNJh5zOjyl6WHpYuovbdud+tmoAVz9suQy4sy
         Anmg==
X-Gm-Message-State: AOAM533AvKjcwiZo6ooKPFRxCCstxzx5QE/1Cq9KYCXHKbyyTsn1OPfN
        FwoIe6ViA7EEz7maomHjssH1sg==
X-Google-Smtp-Source: ABdhPJyMUpPUtVKC6CCFRGjl7Q7U86a/YVte8/m4ryk1rwUIF5Hpq9WZjwkjrrTrbJgh9LWKNGjfCg==
X-Received: by 2002:a5d:4cc1:0:b0:1f0:98e7:6af0 with SMTP id c1-20020a5d4cc1000000b001f098e76af0mr409578wrt.363.1647445547485;
        Wed, 16 Mar 2022 08:45:47 -0700 (PDT)
Received: from maple.lan (cpc141216-aztw34-2-0-cust174.18-1.cable.virginm.net. [80.7.220.175])
        by smtp.gmail.com with ESMTPSA id 11-20020a05600c26cb00b0037ff53511f2sm4927285wmv.31.2022.03.16.08.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:45:46 -0700 (PDT)
Date:   Wed, 16 Mar 2022 15:45:44 +0000
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Netdev <netdev@vger.kernel.org>,
        =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Subject: Re: [PATCH 2/6] list: add new MACROs to make iterator invisiable
 outside the loop
Message-ID: <20220316154544.bfewwi7zseyyja47@maple.lan>
References: <CAHk-=whJX52b1jNsmzXeVr6Z898R=9rBcSYx2oLt69XKDbqhOg@mail.gmail.com>
 <20220304025109.15501-1-xiam0nd.tong@gmail.com>
 <CAHk-=wjesxw9U6JvTw34FREFAsayEE196Fi=VHtJXL8_9wgi=A@mail.gmail.com>
 <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com>
 <20220311142754.a3jnnjqxpok75qgp@maple.lan>
 <CAHk-=wi58pvQhMX2sRt7nKqwHAFAmn27MrJg3XbeJgio6ONgdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wi58pvQhMX2sRt7nKqwHAFAmn27MrJg3XbeJgio6ONgdA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 10:41:06AM -0800, Linus Torvalds wrote:
> On Fri, Mar 11, 2022 at 6:27 AM Daniel Thompson
> <daniel.thompson@linaro.org> wrote:
> >
> > It is possible simply to use spelling to help uncover errors in
> > list_traverse()?
> 
> I'd love to, and thought that would be a lovely idea, but in another
> thread ("") Barnabás Pőcze pointed out that we actually have a fair
> number of cases where the list member entries are embedded in internal
> structures and have a '.' in them:
> 
>   https://lore.kernel.org/all/wKlkWvCGvBrBjshT6gHT23JY9kWImhFPmTKfZWtN5Bkv_OtIFHTy7thr5SAEL6sYDthMDth-rvFETX-gCZPPCb9t2bO1zilj0Q-OTTSbe00=@protonmail.com/
> 
> which means that you can't actually append the target_member name
> except in the simplest cases, because it wouldn't result in one single
> identifier.
> 
> Otherwise it would be a lovely idea.

When I prototyped this I did actually include a backdoor to cover
situations like this but I ended up (incorrectly at appears) editing it
out for simplicity.

Basically the union is free so we can have more than one type * member:

#define list_traversal_head(type, name, target_member) \
       union { \
               struct list_head name; \
               type *name##_traversal_type; \
               type *name##_traversal_mismatch_##target_member; \
       }

This allows that the single structure cases to be checked whilst nested
structures (and array which I noticed also crop up) have a trap door such
as list_traverse_unchecked().

I did a quick grep to estimate how many nested/array cases there are and
came up with around 2.5% (roughly ~200 in ~8500, counting only the single
line users of list_for_each_entry() ).

As you say, lovely idea but having to use special API 2.5% of the time
seems a bit on the high side.

BTW, a complete aside, but whilst I was looking for trouble I also
spotted code where the list head is an array which means we are not able
to lookup the travesral type correctly:
list_for_each_entry(modes[i], &connector->modes, head)
However I found only one instance of this so it
much more acceptable rate of special cases than the 2.5% above.


> > > [this bit used to quote the definition of LIST_HEAD() ;-) ]
> > For architectures without HAVE_LD_DEAD_CODE_DATA_ELIMINATION then the
> > "obvious" extension of list_traversal_head() ends up occupying bss
> > space. Even replacing the pointer with a zero length array is still
> > provoking gcc-11 (arm64) to allocate a byte from bss (often with a lot
> > of padding added).
> 
> I think compilers give objects at least one byte of space, so that two
> different objects get different addresses, and don't compare equal.
> 
> That said, I'm not seeing your issue. list_traversal_head() is a
> union, and always has that 'struct list_head' in it, and that's the
> biggest part of the union.

Perhaps its a bit overblown for the safe of a few kilobytes (even if
there were two traversal types members) but I was wondering if there is
any cunning trick for LIST_HEAD() since we cannot have an anonymous
union outside a struct. In short, is this the best we can do for
LIST_TRAVERSE_HEAD():

#define LIST_TRAVERSE_HEAD(type, name, target_member) \
	type * name##_traversal_type; \
	struct list_head name = LIST_HEAD_INIT(name)


#define STATIC_LIST_TRAVERSE_HEAD(type, name, target_member) \
	static type * name##_traversal_type; \
	static list_head name = LIST_HEAD_INIT(name)


Daniel.
