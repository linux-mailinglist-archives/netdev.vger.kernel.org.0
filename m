Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40B560DC22
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 09:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbiJZHcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 03:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJZHcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 03:32:20 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F96DFD31;
        Wed, 26 Oct 2022 00:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=a3GBx/1SEU4nlgFOr1WH1Nhc3cu82Haw2GQSxs/IRPE=; b=N3xz1IF1GuT5qIXni60fN5NV/M
        DY2iml2OichCv/namBi8VhhKAqZTHW7QI/g5LSozDIBop3cQLqO+9Zcv1bKSK4p/eFRaBBj0iQUX7
        e7M5aYv0R96rJLCz7PVdjhZv05dduKUYgRoUQp82kMz/BU1TvwZA1VPnikPvPnEJlL6sk3pTTjieO
        NUUyR8oGIYf/xFcIFtCz9H49Mr48YLOgoR7odEJa1R8/ThJ/RmBH+SGr9OBUjWFM5VqRkes7IpKXu
        T9fo75aNFNE3+hm0F/yGjutnn1PTdpvvzXSLcJj+x9yXKzZkCdLrcZx1eIslmycVcmQSPKy8E1JD6
        ufR+feQg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1onasu-006Wd7-Lb; Wed, 26 Oct 2022 07:31:34 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 99B323000DD;
        Wed, 26 Oct 2022 09:31:31 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 475ED2C259E96; Wed, 26 Oct 2022 09:31:31 +0200 (CEST)
Date:   Wed, 26 Oct 2022 09:31:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        scott.d.constable@intel.com, daniel.sneddon@linux.intel.com,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Paolo Abeni <pabeni@redhat.com>,
        antonio.gomez.iglesias@linux.intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, gregkh@linuxfoundation.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Branch Target Injection (BTI) gadget in minstrel
Message-ID: <Y1jiUzw8QbXUW/+V@hirez.programming.kicks-ass.net>
References: <cover.1666651511.git.pawan.kumar.gupta@linux.intel.com>
 <Y1fDiJtxTe8mtBF8@hirez.programming.kicks-ass.net>
 <b4a64b97-32d2-d83d-9146-ebc9a4cc9ff6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4a64b97-32d2-d83d-9146-ebc9a4cc9ff6@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 03:00:35PM -0700, Dave Hansen wrote:
> On 10/25/22 04:07, Peter Zijlstra wrote:
> > I think the focus should be on finding the source sites, not protecting
> > the target sites. Where can an attacker control the register content and
> > have an indirect jump/call.
> 
> How would this work with something like 'struct file_operations' which
> provide a rich set of indirect calls that frequently have fully
> user-controlled values in registers?
> 
> It certainly wouldn't *hurt* to be zeroing out the registers that are
> unused at indirect call sites.  But, the majority of gadgets in this
> case used rdi and rsi, which are the least likely to be able to be
> zapped at call sites.

Right; so FineIBT will limit the targets to the right set of functions,
and those functions must already assume the values are user controlled
and take appropriate measures.

If you really truly care about the old hardware, then one solution would
be to de-virtualize the call using LTO or something (yes, it will need
some compiler work and you might need to annotate the code a bit and
even have a fixed/predetermined set of loadable modules, but meh).

Barring that, you could perhaps put {min,max} range information next to
the function pointer such that you can impose value ranges before doing
the indirect call.

But given this is all theoretical and FineIBT solves a lot of it I can't
find myself to care too much.
