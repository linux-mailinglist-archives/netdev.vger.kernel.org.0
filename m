Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49F559897F
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345174AbiHRQ7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345167AbiHRQ7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:59:04 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6775425E96;
        Thu, 18 Aug 2022 09:59:03 -0700 (PDT)
Date:   Thu, 18 Aug 2022 18:59:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660841942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T4wwW0MLtrOoCaxMt8oNlrLLbMl3hjwlkmohhSSpTBw=;
        b=vL+EINgm0k7R7rsqqNBOS559ITgsuAX5QMAzn84T9MVqRrkbHzuepYdwCkhIDL/tIrEA2A
        u34rd0NvyVDsh/8VKO7kPbMZcLoOFFqlkJjFv3SXC5FJ9TyNcdNIWRfVTS29N1dNchsi36
        f602+x7XJJYspohPgfUALLXzU7Olm+klF5UadLSt3jzy8PB5vBNy2N32RY3DOX2+C9l3pQ
        pwCXdRO6Qo2H4Ty3VvDiKo2bEx7KSbTDlxGQ7tLBiQIp+rMU1vP6yt08ilAqB5R9CnUoc5
        ZQfg6/0kIaSIr+AEX8JcnQsNVNpnpI6jxQC/TZrTK62ucE9lnF27mNUSmUX+Hg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660841942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T4wwW0MLtrOoCaxMt8oNlrLLbMl3hjwlkmohhSSpTBw=;
        b=HxTRyfnDTJ5xRvH9zA8rcAgledSkRhOCu2DCLXgEXISuIF21WLQYzPKbXCgOyOsY7iILrD
        V9fHZqFEjVYvExDg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 9/9] u64_stat: Remove the obsolete fetch_irq() variants
Message-ID: <Yv5v1E6mfpcxjnLV@linutronix.de>
References: <20220817162703.728679-1-bigeasy@linutronix.de>
 <20220817162703.728679-10-bigeasy@linutronix.de>
 <20220817112745.4efd8217@kernel.org>
 <Yv5aSquR9S2KxUr2@linutronix.de>
 <20220818090200.4c6889f2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220818090200.4c6889f2@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-18 09:02:00 [-0700], Jakub Kicinski wrote:
> On Thu, 18 Aug 2022 17:27:06 +0200 Sebastian Andrzej Siewior wrote:
> > On 2022-08-17 11:27:45 [-0700], Jakub Kicinski wrote:
> > > What's the thinking on merging? 8 and 9 will get reposted separately 
> > > for net-next once the discussions are over?  
> > 
> > It depends on 2/9. So either it gets routed via -tip with your blessing
> > or a feature branch containing 2/9 on top of -rc1 so you can pull that
> > change and apply 8+9.
> > Just say what works best for you and I let tglx know ;)
> 
> Heh, I saw a message from Greg politely and informatively explaining 
> to someone how they have to structure their refactoring to avoid
> conflicts in linux-next. I should have saved it cause my oratorical
> skills are weak.

No need to explains, just say that you want to see the networking bits
only ;)

> No ack, I'd much rather you waited for after the next merge window 
> and queued this refactoring to net-next. Patch 9 is changing 70
> files in networking. Unless I'm missing something and this is time
> sensitive.

It started with the clean up of the mess that has been made in the merge
and then it went on a little.

Any opinion on 8/9? It could wait for the next merge window if you want
to avoid a feature branch to pull from.

Regarding 9/9. This is a clean up, which is possible after 8/9. It can
definitely be applied later.
I assume you want only see the networking bits so I would split the
other subsystem out. I guess instead the big net patch I split them on
per driver vendor basis + net/ subsys?

Sebastian
