Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F7E5F1020
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbiI3QhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiI3QhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:37:15 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8979B1739F1
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:37:12 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id s125so5291813oie.4
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=yVtRc2hjiYcfxQL2KWKs/GoH/bmBCIIH5T8DAaY5O5U=;
        b=q3M4A4Wv2B0l4zS0APwjp6BcdRtAENOC64po+PAiJ1zc43V/YH6tzeXrUP36X5TDNj
         qr0lziUJSmGf/rEfavHxQTMXTMX2+dLTy/6T8x+A2ATFDTRWeGIng80UC31/VYAdXJE+
         maLPTXhCi0UpIhyeSDyMY+ZQR2nBZjMNyKTmzAr06x4ObJCeU620VPP9bi78GvfCBpow
         1Tpx5GTGw2i8vercx/0wVO/xShMJJPzK5KfqHjKXsxiAx6OmU0lRqtzVSqOahs/bjxed
         sNv3Bbbgw9MIpwg2IKt4w25pbMfU+6J31Cxxe5eSI385aYqimpr4Z4au0nuHj3CKhkwi
         irUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=yVtRc2hjiYcfxQL2KWKs/GoH/bmBCIIH5T8DAaY5O5U=;
        b=JqNPGW0JJbHxm81IJu/wRi96YN7Tj1JDZ8G7VQOpthDxwjGf7iU7ibfxFXY/rIV+tj
         xim71/8WIpT418b5WzpNwkk2ejvlfVHR+Coh0oEQ8F+xgRHg8itXAwpKqV6jgpFLxea+
         zl3oEwj0rDK9IUiMhbxmAB5MBOf6phmKujWuC53bST0wmWoNWYEN6PO+oq4gHoC4+GD5
         Tq3sss4J/n8+4RtRxSjiw/sIvGgE+n+if8/japEooEvhNJUzLpHniDfgZVjryQgjHbrM
         0ahc8o1G1JnLCoWckQiNienQ5fu6Nfm7mzyslEL4juI4T5FraI/B11EOrPnEvK3m2a7y
         dpBg==
X-Gm-Message-State: ACrzQf0OJIWURx4DRTWOvqkJFKTHKkZdVhPrRoj8ZfcPAIMAlGQNwdbK
        ECzXW1+M6LfaKkctR0iLVX+X8LPpxuREGc0MLmDviw==
X-Google-Smtp-Source: AMsMyM7bK2L1XzVYwx49tmVwysPEroUuaEN346QZoE52VMa0xKHK9U2U+FnWYv27bRLdqHBrxGSlBWJUCjAMSS1V2MM=
X-Received: by 2002:a05:6808:148d:b0:350:7858:63ce with SMTP id
 e13-20020a056808148d00b00350785863cemr4255200oiw.106.1664555831503; Fri, 30
 Sep 2022 09:37:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220927212306.823862-1-kuba@kernel.org> <a3dbb76a-5ee8-5445-26f1-c805a81c4b22@blackwall.org>
 <20220928072155.600569db@kernel.org> <CAM0EoMmWEme2avjNY88LTPLUSLqvt2L47zB-XnKnSdsarmZf-A@mail.gmail.com>
 <c3033346-100d-3ec6-0e89-c623fc7b742d@blackwall.org> <CAM0EoMnpSMydZvQgLXzoqAHTe0=xx6zPEaP1482qHhrTWGH_YQ@mail.gmail.com>
 <4f8b1dec-82c8-b63f-befe-b2179449042d@blackwall.org>
In-Reply-To: <4f8b1dec-82c8-b63f-befe-b2179449042d@blackwall.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 30 Sep 2022 12:36:59 -0400
Message-ID: <CAM0EoMn09qMjpHV5dHEaMDBCuRBVt6qbcTToXCeqCQ-+-7UJeQ@mail.gmail.com>
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage of
 Netlink flags
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Guillaume Nault <gnault@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        URI_NO_WWW_INFO_CGI autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 10:34 AM Nikolay Aleksandrov
<razor@blackwall.org> wrote:
>
> On 30/09/2022 17:24, Jamal Hadi Salim wrote:
> > On Fri, Sep 30, 2022 at 7:29 AM Nikolay Aleksandrov <razor@blackwall.org> wrote:

[..]

> >
> > I think what you are looking for is a way to either get or delete
> > selective objects
> > (dump and flush dont filter - they mean "everything"); iow, you send a filtering
>
> They must be able to flush everything, too. Filter matching all/empty filter, we need
> it for mdbs and possibly other object types would want that.

You only have one object type though per netlink request i.e you
dont have in the same message fdb and mdb objects?

> > expression and a get/del command alongside it. The filtering
> > expression is very specific
> > to the object and needs to be specified as such a TLV is appropriate.
> >
>
> Right, and that is what got implemented. The filtering TLVs are bridge and fdb-specific
> they don't affect any other subsystem. The BULK flag denotes the delete will
> affect multiple objects.
>

Isnt it sufficient to indicate what objects need to be deleted based on presence
of TLVs or the service header for that object?

> > Really NLM_F_ROOT and _MATCH are sufficient. The filtering expression is
> > the challenge.
>
> NLM_F_ROOT isn't usable for a DEL expression because its bit is already used by NLM_F_NONREC
> and it wouldn't be nice to change meaning of the bit based on the subsystem. NLM_F_MATCH's bit
> actually matches NLM_F_BULK :)
>

Ouch. Ok, it got messy over time i guess. We probably should have
spent more time
discussing NLM_F_NONREC since it has a single user with very specific
need and it
got imposed on all.
I get your point - i am still not sure if a global flag is the right answer.

>
> Sometime back I played with a different idea - expressing the filters with the existing TLV objects
> so whatever can be specified by user-space can also be used as a filter (also for filtering
> dump requests) with some introspection. The lua idea sounds nice though.

So what is the content of the TLV in that case?
I think ebpf may work with some acrobatics. We did try classical ebpf and it was
messy. Note for scaling, this is not just about Delete and Get but
also for generated
events, where one can send to the kernel a filter so they dont see a broadcast
of everything. See for example a use case here:
https://www.files.netdevconf.info/d/46fd7e152d1d4f6c88ac/files/?p=/LargeScaleTCPAnalytics.pdf

cheers,
jamal
