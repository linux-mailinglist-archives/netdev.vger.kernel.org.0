Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C3C4EB675
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 01:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239435AbiC2XF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 19:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239344AbiC2XFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 19:05:55 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553465AEFC
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 16:04:11 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id u3so25473478ljd.0
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 16:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aV7bYKXOhFJMu6k5FXuul13yfeXxFkntHqAD2t+w5yg=;
        b=CJkmnCsJ9AGD+pl0V8nBCojZTCyw8e9iJy5XKL0P7rh1ZSykGTZYpsvzXHC7zh7r/u
         Uc8hRbh/caTjJFQTqQVPyqgIFac92sdgNo8WOuuWEXeM/IwzJEHcDUCwD2Mg2RpReV2P
         1NkFp4Bx5kED5TzzJMSZH+87hi+IO62KNp1jpbDREafeHczHaEEwX91NA/UprW6BvTK1
         BYl3u3DiTOa637U6v63WdLf+IwHuL+qS3NV4p+PLaAZRsdl+KHTrLl542O6H/+4hlT6g
         bCHBMDYZ0gkt9adaAlMED1RZBuFiXVexSR3RXeTfHxCFAA7f24V94lclMDMHiXtcNlBT
         9QAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aV7bYKXOhFJMu6k5FXuul13yfeXxFkntHqAD2t+w5yg=;
        b=VHv93BVnbyZLGiZv2nAcqd2zuetObGjb1Xd0oo08ED/r/xyW+EHwpMcoJSPQ30UXvb
         hdytrtUE4st7rHZt8zlKlnioGy3QaB4r/kU25W0PoS0N9Ts55p/WH3awPxvm5tAcMe+p
         e9nSWKV46n2LII+h/QfOu5STFvG6AwEpq+Fl8mS7+v2iQduiR5uBfrN1LWJicHa/POkN
         QNNIhZpB75pRkGS5J3ogqzmrU07d0Df9l+mOa+uonvRPDjUBKckK+Ld3NDzd9ww893Cd
         voA6u/hljSE7YQsk0y9B8sJxcWOCqvknmHsejq7ajlGbLi2oQfuTLz0P2RRhy1ktbNeV
         Ah/A==
X-Gm-Message-State: AOAM530o5GHHK1wJP+vdkStOmBzBcp4yN3sDLtpmgg4P7rjiyhwT+VsV
        aY/XN+X1l+PtSBwfrjCqSl9Eh0ziMLsg0EuHiHWTsA==
X-Google-Smtp-Source: ABdhPJx0I1Ld/2LwgEGvX7iZJMPdwA0nv3oOokgiFpErvc7ckacA6/4louyesMOYZwvDcBgiBEqgp/0KN+xEidKoAsI=
X-Received: by 2002:a2e:8692:0:b0:249:a0b1:3c77 with SMTP id
 l18-20020a2e8692000000b00249a0b13c77mr4524471lji.235.1648595048944; Tue, 29
 Mar 2022 16:04:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220329212946.2861648-1-ndesaulniers@google.com>
 <CAKwvOdmsnVsW46pTZYCNu-bx5c-aJ8ARMCOsYeMmQHpAw3PtPg@mail.gmail.com> <CAKwvOdnJB5u96fm1w-R-VUayvhq58EQeqZst32NDRscK17Z8pQ@mail.gmail.com>
In-Reply-To: <CAKwvOdnJB5u96fm1w-R-VUayvhq58EQeqZst32NDRscK17Z8pQ@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 29 Mar 2022 16:03:57 -0700
Message-ID: <CAKwvOdn-riuzXJWTL08J+qbQkYVzCgBG=XGM9G2TSmA_Kg=hWQ@mail.gmail.com>
Subject: Re: [PATCH] net, uapi: remove inclusion of arpa/inet.h
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        David Howells <dhowells@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jmaloy@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 3:09 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Tue, Mar 29, 2022 at 2:50 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > On Tue, Mar 29, 2022 at 2:29 PM Nick Desaulniers
> > <ndesaulniers@google.com> wrote:
> > >
> > > Testing out CONFIG_UAPI_HEADER_TEST=y with a prebuilt Bionic sysroot
> > > from Android's SDK, I encountered an error:
> > >
> > >   HDRTEST usr/include/linux/fsi.h
> > > In file included from <built-in>:1:
> > > In file included from ./usr/include/linux/tipc_config.h:46:
> > > prebuilts/ndk/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/arpa/inet.h:39:1:
> > > error: unknown type name 'in_addr_t'
> > > in_addr_t inet_addr(const char* __s);
> > > ^
> >
> > Oh, this might not quite be the correct fix for this particular issue.
> >
> > Cherry picking this diff back into my Android kernel tree, I now observe:
> >   HDRTEST usr/include/linux/tipc_config.h
> > In file included from <built-in>:1:
> > ./usr/include/linux/tipc_config.h:268:4: error: implicit declaration
> > of function 'ntohs' [-Werror,-Wimplicit-function-declaration]
> >                 (ntohs(((struct tlv_desc *)tlv)->tlv_len) <= space);
> >                  ^
> >
> > Is there more than one byteorder.h? Oh, I see what I did; ntohs is defined in
> > linux/byteorder/generic.h
> > not
> > usr/include/asm/byteorder.h
> > Sorry, I saw `byteorder` and mixed up the path with the filename.
> >
> > So rather than just remove the latter, I should additionally be adding
> > the former. Though that then produces
> >
> > common/include/linux/byteorder/generic.h:146:9: error: implicit
> > declaration of function '__cpu_to_le16'
> > [-Werror,-Wimplicit-function-declaration]
> >         *var = cpu_to_le16(le16_to_cpu(*var) + val);
> >                ^
> >
> > Oh?
>
> Should there be a definition of ntohs (and friends) under
> include/uapi/linux/ somewhere, rather than have the kernel header
> include/uapi/linux/tipc_config.h depend on the libc header
> arpa/inet.h?
>
> It looks like we already have
> include/uapi/linux/byteorder/{big|little}_endian.h to define
> __be16_to_cpu and friends, just no definition of ntohs under
> include/uapi/linux/.
>
> Also, it looks like include/uapi/linux/ has definitions for
> __constant_ntohs in
> include/uapi/linux/byteorder/{big|little}_endian.h.  Should those 2
> headers also define ntohs (and friends) unprefixed, i.e. the versions
> that don't depend on constant expressions?
>
> (I wish there was an entry in MAINTAINERS for UAPI questions like this...)

I also think that Documentation/kbuild/headers_install.rst should
probably include text from
https://lore.kernel.org/all/Pine.LNX.4.58.0411281710490.22796@ppc970.osdl.org/
or something along the lines of "kernel headers MUST NOT depend on
userspace headers; any instance of that in tree is a bug that should
be fixed."

For people I just cc'ed, here's the lore link to this thread:
https://lore.kernel.org/lkml/20220329212946.2861648-1-ndesaulniers@google.com/

>
> >
> > >
> > > This is because Bionic has a bug in its inclusion chain. I sent a patch
> > > to fix that, but looking closer at include/uapi/linux/tipc_config.h,
> > > there's a comment that it includes arpa/inet.h for ntohs; but ntohs is
> > > already defined in include/linux/byteorder/generic.h which is already
> > > included in include/uapi/linux/tipc_config.h. There are no __KERNEL__
> > > guards on include/linux/byteorder/generic.h's definition of ntohs. So
> > > besides fixing Bionic, it looks like we can additionally remove this
> > > unnecessary header inclusion.
> > >
> > > Link: https://android-review.googlesource.com/c/platform/bionic/+/2048127
> > > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > > ---
> > >  include/uapi/linux/tipc_config.h | 4 ----
> > >  1 file changed, 4 deletions(-)
> > >
> > > diff --git a/include/uapi/linux/tipc_config.h b/include/uapi/linux/tipc_config.h
> > > index 4dfc05651c98..b38374d5f192 100644
> > > --- a/include/uapi/linux/tipc_config.h
> > > +++ b/include/uapi/linux/tipc_config.h
> > > @@ -43,10 +43,6 @@
> > >  #include <linux/tipc.h>
> > >  #include <asm/byteorder.h>
> > >
> > > -#ifndef __KERNEL__
> > > -#include <arpa/inet.h> /* for ntohs etc. */
> > > -#endif
> > > -
> > >  /*
> > >   * Configuration
> > >   *
> > >
> > > base-commit: 5efabdadcf4a5b9a37847ecc85ba71cf2eff0fcf
> > > prerequisite-patch-id: 0c2abf2af8051f4b37a70ef11b7d2fc2a3ec7181
> > > --
> > > 2.35.1.1021.g381101b075-goog
> > >
> >
> >
> > --
> > Thanks,
> > ~Nick Desaulniers
>
>
>
> --
> Thanks,
> ~Nick Desaulniers



-- 
Thanks,
~Nick Desaulniers
