Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2634EB68E
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 01:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239757AbiC2XOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 19:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235262AbiC2XOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 19:14:53 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA2F19B08A
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 16:13:09 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id w7so32873410lfd.6
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 16:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lix+Cn9dLRv5V2E2a0f9nB/0OmFi21urXU4sSbZfBWU=;
        b=sZlEFLJPvaRLE0Rk3RMPGJKferH2Yz3zSwUzew6rdkAv4L0stLWlB/V6CTH0gRoaQS
         ZDYhZkrHmU8oTwVMdLuZ4n+d8ONA6gyWwrTQwJC4SbiGDxMerlEbjplV5lyVgK/Fr7cZ
         LBDJU2HsuC0mCfuCgcSw2KhfondlIVL7gnysBbSNFBnQDWiyIFxmZBcqgBzkl1Tvws/J
         GjCb6qL8nUObrCmsxVVtdQPI4TQlyDZJ5fjXfwagWSAlO3OnXFdVSqYwZpx7iBW/1HgP
         Mh84r7udN27JJB+YWlgq6++1hEFlx3fH1hkIdJO2uGluNjaTp8Nia71nTH3ZhnUrc3Am
         9ONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lix+Cn9dLRv5V2E2a0f9nB/0OmFi21urXU4sSbZfBWU=;
        b=ZLCzocy++mwyOUDwcHXN49Zz4Uu8s7eMYfefLhsptAxUJIdZBRRwgrmf9Cx5sPt0zW
         eqoeLMNCK9WqDFctQwJQrnHA/Y0a2UF5E86ceVi3mVTvWBNtw+C6s3F8zCVNSmJJmzWN
         uV5n1eXn5zYfKUucibGiIWNF/kxFDLco9DtAOqejnrqpU52sUWM7vujlnG6k+CmBrpfP
         hljQQXpvXb8wsf6SGazo8lA4bh2DqJYfncQ8RkvkoZHjmDKfMBIcya4EUtmvRJZlg+PW
         NsBof+bWyns6RkALhfsn5y11ZB1+m5QRVDckMZPLCrymqSEYADS/VhW7lh9dj+WW6Dzc
         A0TA==
X-Gm-Message-State: AOAM530HJ9rzhHyX5EbaXG7TXFO2C6DIQUXDS6zZInKK2M9IrAAKx3v+
        9CmTXm56Ba22mlRbzArNeh5CJ4n4q/kFudNw/sdYJw==
X-Google-Smtp-Source: ABdhPJwOZ3jcZwojGyojTgZxiJdEWLTpoM34ZLQKkLJD2E5imcrvKmtcCfFFNQKvBg/DEaUepLQmvQJzoCy+tY7Axlg=
X-Received: by 2002:a05:6512:b9e:b0:44a:10eb:9607 with SMTP id
 b30-20020a0565120b9e00b0044a10eb9607mr4583964lfv.626.1648595587152; Tue, 29
 Mar 2022 16:13:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOdmYzH91bzNus+RcZGSgCQGY8UKt0-2JvtqQAh=w+CeiuQ@mail.gmail.com>
 <20220329223956.486608-1-ndesaulniers@google.com> <20220329160137.0708b1ef@kernel.org>
In-Reply-To: <20220329160137.0708b1ef@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 29 Mar 2022 16:12:55 -0700
Message-ID: <CAKwvOdnNqHOvFSqzhS+0wrPfKVvrz2VymAkZatyFTBwRsQtQnw@mail.gmail.com>
Subject: Re: [PATCH v2] net, uapi: remove inclusion of arpa/inet.h
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 4:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 29 Mar 2022 15:39:56 -0700 Nick Desaulniers wrote:
> > Testing out CONFIG_UAPI_HEADER_TEST=y with a prebuilt Bionic sysroot
> > from Android's SDK, I encountered an error:
> >
> >   HDRTEST usr/include/linux/fsi.h
> > In file included from <built-in>:1:
> > In file included from ./usr/include/linux/tipc_config.h:46:
> > prebuilts/ndk/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/arpa/inet.h:39:1:
> > error: unknown type name 'in_addr_t'
> > in_addr_t inet_addr(const char* __s);
> > ^
> >
> > This is because Bionic has a bug in its inclusion chain. I sent a patch
> > to fix that, but looking closer at include/uapi/linux/tipc_config.h,
> > there's a comment that it includes arpa/inet.h for ntohs;
> > but ntohs is not defined in any UAPI header. For now, reuse the
> > definitions from include/linux/byteorder/generic.h, since the various
> > conversion functions do exist in UAPI headers:
> > include/uapi/linux/byteorder/big_endian.h
> > include/uapi/linux/byteorder/little_endian.h
> >
> > Link: https://android-review.googlesource.com/c/platform/bionic/+/2048127
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > ---
> >  include/uapi/linux/tipc_config.h | 32 ++++++++++++++++----------------
> >  1 file changed, 16 insertions(+), 16 deletions(-)
> >
> > diff --git a/include/uapi/linux/tipc_config.h b/include/uapi/linux/tipc_config.h
> > index 4dfc05651c98..2c494b7ae008 100644
> > --- a/include/uapi/linux/tipc_config.h
> > +++ b/include/uapi/linux/tipc_config.h
> > @@ -43,10 +43,6 @@
> >  #include <linux/tipc.h>
> >  #include <asm/byteorder.h>
> >
> > -#ifndef __KERNEL__
> > -#include <arpa/inet.h> /* for ntohs etc. */
> > -#endif
>
> Hm, how do we know no user space depends on this include?

Without the ability to scan all source code in existence, I guess I
can't prove or disprove that either way.

If this is a reference to "thou shall not break userspace," I don't
think that was in reference to UAPI headers, libc's, or inclusion
chains.

Worst case, someone might have to #include <arpa/inet.h> if they were
relying on transitive dependencies from <linux/tipc_config.h>.  I
don't think we should be helping people write bad code with such
transitive dependencies though.

>
> If nobody screams at us we can try, but then it needs to go into -next,
> and net-next is closed ATM, you'll need to repost once the merge window
> is over.

Ack.

>
> >  /*
> >   * Configuration
> >   *
> > @@ -257,6 +253,10 @@ struct tlv_desc {
> >  #define TLV_SPACE(datalen) (TLV_ALIGN(TLV_LENGTH(datalen)))
> >  #define TLV_DATA(tlv) ((void *)((char *)(tlv) + TLV_LENGTH(0)))
> >
> > +#define __htonl(x) __cpu_to_be32(x)
> > +#define __htons(x) __cpu_to_be16(x)
> > +#define __ntohs(x) __be16_to_cpu(x)
> > +
> >  static inline int TLV_OK(const void *tlv, __u16 space)
> >  {
> >       /*
> > @@ -269,33 +269,33 @@ static inline int TLV_OK(const void *tlv, __u16 space)
> >        */
> >
> >       return (space >= TLV_SPACE(0)) &&
> > -             (ntohs(((struct tlv_desc *)tlv)->tlv_len) <= space);
> > +             (__ntohs(((struct tlv_desc *)tlv)->tlv_len) <= space);
>
> Also why add the defines / macros?
> We could switch to __cpu_to_be16() etc. directly, it seems.

Sure, I thought they might be more readable, but whatever you all
prefer.  Will send a v3 once the merge window closes.
-- 
Thanks,
~Nick Desaulniers
