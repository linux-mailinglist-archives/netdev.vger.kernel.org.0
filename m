Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8F86A69C2
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 10:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjCAJZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 04:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjCAJZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 04:25:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC63832E5F
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 01:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677662676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EjLBO2oSAz1qd2pyxymW7NNpmRhL/8rZkZFuY2z88lg=;
        b=WA6iYRnX5Xb/GiTIapqCJfjy1LLWSgstX19G6+sGOevMv2h8SyLPtGiyqScUoJaVQUx3QS
        Fpd4h8NvhH0UDy5kG1UPbqW08jV8MosFtUKIBTgl9Hhap4d+Q7kCoqNNEB+/UHWhFddTtn
        PezlZif7Jp1+nSREFu65zTXUQBNGZnw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-y6BwrYfuMfy1XckhSv52eQ-1; Wed, 01 Mar 2023 04:24:33 -0500
X-MC-Unique: y6BwrYfuMfy1XckhSv52eQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41D9A85CBE0;
        Wed,  1 Mar 2023 09:24:32 +0000 (UTC)
Received: from localhost (ovpn-13-180.pek2.redhat.com [10.72.13.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F07B52026D76;
        Wed,  1 Mar 2023 09:24:28 +0000 (UTC)
Date:   Wed, 1 Mar 2023 17:24:26 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>,
        Edward Cree <ecree.xilinx@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, arnd@arndb.de, christophe.leroy@csgroup.eu,
        hch@infradead.org, agordeev@linux.ibm.com,
        wangkefeng.wang@huawei.com, schnelle@linux.ibm.com,
        David.Laight@aculab.com, shorne@gmail.com,
        loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        x86@kernel.org, netdev@vger.kernel.org,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: Re: [PATCH v5 01/17] asm-generic/iomap.h: remove ARCH_HAS_IOREMAP_xx
 macros
Message-ID: <Y/8Zyjfuypg3EiDd@MiWiFi-R3L-srv>
References: <20230301034247.136007-1-bhe@redhat.com>
 <20230301034247.136007-2-bhe@redhat.com>
 <7bd6db48-ffb1-7eb1-decf-afa8be032970@gmail.com>
 <Y/7eceqZ+89iPm1C@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/7eceqZ+89iPm1C@casper.infradead.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/01/23 at 05:11am, Matthew Wilcox wrote:
> On Wed, Mar 01, 2023 at 04:38:10AM +0000, Edward Cree wrote:
> > On 01/03/2023 03:42, Baoquan He wrote:
> > > diff --git a/drivers/net/ethernet/sfc/io.h b/drivers/net/ethernet/sfc/io.h
> > > index 30439cc83a89..07f99ad14bf3 100644
> > > --- a/drivers/net/ethernet/sfc/io.h
> > > +++ b/drivers/net/ethernet/sfc/io.h
> > > @@ -70,7 +70,7 @@
> > >   */
> > >  #ifdef CONFIG_X86_64
> > >  /* PIO is a win only if write-combining is possible */
> > > -#ifdef ARCH_HAS_IOREMAP_WC
> > > +#ifdef ioremap_wc
> > >  #define EFX_USE_PIO 1
> > >  #endif
> > >  #endif
> > 
> > So I don't know how valid what we're doing here is...
> 
> Well, x86 defines ARCH_HAS_IOREMAP_WC unconditionally, so it doesn't
> affect you ... but you raise a good question about how a driver can
> determine if it's actually getting WC memory.

Yeah, this change doesn't affect sfc. Because ARCH_HAS_IOREMAP_WC is used to
make ioremap_wc defined in <asm/io.h> override the default one in
<asm-generic/iomap.h>, this patch has made code have the same effect.

Besides, I have a question still in my mind. Surely this is unrelated to
this patch.

In commit 38d9029a652c (parisc: Define ioremap_uc and ioremap_wc),
ioremap_wc definition was added in arch/parisc/include/asm/io.h, and it
didn't add ARCH_HAS_IOREMAP_WC definition. However, it won't cause
redefinition of ioremap_wc, even though there's "#include <asm-generic/iomap.h>"
at below. I could be dizzy on these io.h and iomap.h.

When I added ioremap_wt and ioremap_np to debug, ioremap_np will
cause redefinition, while ioremap_wt woundn't. Does anyone know what
I am missing?

diff --git a/arch/parisc/include/asm/io.h b/arch/parisc/include/asm/io.h
index c05e781be2f5..20d566eec3b3 100644
--- a/arch/parisc/include/asm/io.h
+++ b/arch/parisc/include/asm/io.h
@@ -127,6 +127,8 @@ static inline void gsc_writeq(unsigned long long val, unsigned long addr)
  */
 void __iomem *ioremap(unsigned long offset, unsigned long size);
 #define ioremap_wc                     ioremap
+#define ioremap_wt                     ioremap
+#define ioremap_np                     ioremap
 #define ioremap_uc                     ioremap
 #define pci_iounmap                    pci_iounmap

