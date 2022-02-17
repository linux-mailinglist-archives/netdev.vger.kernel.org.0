Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4999B4BA719
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 18:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243708AbiBQR2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 12:28:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbiBQR2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 12:28:35 -0500
X-Greylist: delayed 4194 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Feb 2022 09:28:20 PST
Received: from conssluserg-03.nifty.com (conssluserg-03.nifty.com [210.131.2.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63B1255798;
        Thu, 17 Feb 2022 09:28:19 -0800 (PST)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id 21HHRuww006618;
        Fri, 18 Feb 2022 02:27:57 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 21HHRuww006618
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1645118877;
        bh=l1TyzWfQ0jAdhokclSQdnzp8UboMTXXAhan3iI6BUk4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hvNZ4ikLbPjFV/y7ChTE5b8OQBL4g8ZAbtTOwQUZywEnlNF2G/aTi0H1hOhjyGN1C
         NHEvmztYFCF9Dc6V+hJ5X/wHyELb7nkaACM0wtDbd1+6U7R7+rDFLUXLtZq0w84U3W
         BVfybmzISX6N+vJbJd360lhJt+4BjRbSdwMcbxAFVXLN1dvr/KzBnHTTvkMEwi2rGw
         1F0F3DqlPQseUBPJmjskaAJFRh4BWjbcpSq8s9JNDIlKwAPaNXW3e3v/K/zuxd+7Vj
         l04cKXOH+QyAL/gsJtSNW0MqjhMRjyrIRZpPCWh9tKNIq0WeSu5TcRpw/ib8raCV+x
         uk3hly0CQ39pQ==
X-Nifty-SrcIP: [209.85.215.171]
Received: by mail-pg1-f171.google.com with SMTP id q132so5607076pgq.7;
        Thu, 17 Feb 2022 09:27:57 -0800 (PST)
X-Gm-Message-State: AOAM531kh4fpiuOKOs30sCiauRibhY7cr78lCmaAEcXo9f7aMZXkKJir
        g3WL8JHK2Mg4ZvUu6o6py3dA384kSBA95+sR4ik=
X-Google-Smtp-Source: ABdhPJxBWdwy+sIqV6zpRtht5DZ0OmlC41IapWVAe36IX2cFMRgSnZS9d19h+BtDYudfRbxf5PEvVUO6wlOp73L12Wo=
X-Received: by 2002:a05:6a00:a01:b0:4cc:61e5:c548 with SMTP id
 p1-20020a056a000a0100b004cc61e5c548mr4081108pfh.68.1645118876247; Thu, 17 Feb
 2022 09:27:56 -0800 (PST)
MIME-Version: 1.0
References: <978951d76d8cb84bab347c7623bc163e9a038452.1645100305.git.christophe.leroy@csgroup.eu>
 <35bcd5df0fb546008ff4043dbea68836@AcuMS.aculab.com> <d38e5e1c-29b6-8cc6-7409-d0bdd5772f23@csgroup.eu>
 <9b8ef186-c7fe-822c-35df-342c9e86cc88@csgroup.eu> <3c2b682a7d804b5e8749428b50342c82@AcuMS.aculab.com>
 <CAK7LNASWTJ-ax9u5yOwHV9vHCBAcQTazV-oXtqVFVFedOA0Eqw@mail.gmail.com> <2e38265880db45afa96cfb51223f7418@AcuMS.aculab.com>
In-Reply-To: <2e38265880db45afa96cfb51223f7418@AcuMS.aculab.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Fri, 18 Feb 2022 02:27:16 +0900
X-Gmail-Original-Message-ID: <CAK7LNASvBLLWMa+kb5eGJ6vpSqob_dBUxwCnpHZfL-spzRG7qA@mail.gmail.com>
Message-ID: <CAK7LNASvBLLWMa+kb5eGJ6vpSqob_dBUxwCnpHZfL-spzRG7qA@mail.gmail.com>
Subject: Re: [PATCH net v3] net: Force inlining of checksum functions in net/checksum.h
To:     David Laight <David.Laight@aculab.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 1:49 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Masahiro Yamada
> > Sent: 17 February 2022 16:17
> ...
> > No.  Not that one.
> >
> > The commit you presumably want to revert is:
> >
> > a771f2b82aa2 ("[PATCH] Add a section about inlining to
> > Documentation/CodingStyle")
> >
> > This is now referred to as "__always_inline disease", though.
>
> That description is largely fine.
>
> Inappropriate 'inline' ought to be removed.
> Then 'inline' means - 'really do inline this'.


You cannot change "static inline" to "static"
in header files.

If  "static inline" meant __always_inline,
there would be no way to negate it.
That's why we need both inline and __always_inline.




> Anyone remember massive 100+ line #defines being
> used to get code inlined 'to make it faster'.
> Sometimes being expanded several times in succession.
> May have helped a 68020, but likely to be a loss on
> modern cpu with large I-cache and slow memory.
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)


--
Best Regards
Masahiro Yamada
