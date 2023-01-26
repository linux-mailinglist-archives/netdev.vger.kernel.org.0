Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5744F67D773
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 22:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbjAZVMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 16:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbjAZVMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 16:12:39 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E3D61AC
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 13:12:38 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id g16so1343382ilr.1
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 13:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mQPwRIBKhjb6JhTfp5iOA/66mO6S7MMMqq8824Tk2b0=;
        b=HNU9PynKvAx2Imqc0jgm2uqETw6F54OUO0SSiTEIJebfso5A4bn9aZ+5oCUUMn25X/
         V0yHOqUa9bF4IC/tI0Zb/zxgNzutu2sU7/g4sOQf4FfXqwMNszdlOBr42qng17jrigHc
         e2rNCMsmuW+kgB1D2mg74e9vNEYTG9vqW5aAE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mQPwRIBKhjb6JhTfp5iOA/66mO6S7MMMqq8824Tk2b0=;
        b=DUwmmlo2+RrggSkrcy7ERcpzjCNKJNnJFimtt9rczBkFkz0QeCkFx0bv5t60wAkZXF
         nnA0URasWKiDrVTpN/afeDs96binldcOguAsQkxdWAXKKoHZRCnOD2kgy9w4BaYtAXJg
         q8DUOjJLwTHza314lyw+r5lJduj8nC2+Z0ild+D2Mefx3JeR/VcfeP+HdVPp0IecDWTR
         nm674cSIVK02DkQT++nDMtcN0d+Kin+RhEXEafj+Fw1MQpK1SP/IOEe3z0jFP2FpC0OW
         B/uWRJusUD9JXROIBJQ6d4fmdlTq6/1bcWwSQij4/Z6ZwHYI4KGTjOGoddAa5YxglwqH
         lFCg==
X-Gm-Message-State: AO0yUKWfGADtQJC599R0M/uKF2rG4JFrlNn1ZVQSPFb88f0e/745MpN2
        NhG7uhCesf7TdmcXXTHtQxnJ5A==
X-Google-Smtp-Source: AK7set/T2POVnIBDD3cCjQ6V6AuAcgZrmYFyZYwurwlKmZVmv5S1z9Nv09xWZAyt5AlNpv75YtZurA==
X-Received: by 2002:a05:6e02:18cb:b0:310:c6d3:f4de with SMTP id s11-20020a056e0218cb00b00310c6d3f4demr19111ilu.22.1674767558124;
        Thu, 26 Jan 2023 13:12:38 -0800 (PST)
Received: from localhost ([136.37.131.79])
        by smtp.gmail.com with ESMTPSA id i21-20020a02c615000000b0039e8f997ad6sm799222jan.32.2023.01.26.13.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 13:12:36 -0800 (PST)
Date:   Thu, 26 Jan 2023 15:12:35 -0600
From:   "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <Y9LswwnPAf+nOVFG@do-x1extreme>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9KyVKQk3eH+RRse@alley>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 06:03:16PM +0100, Petr Mladek wrote:
> On Fri 2023-01-20 16:12:20, Seth Forshee (DigitalOcean) wrote:
> > We've fairly regularaly seen liveptches which cannot transition within kpatch's
> > timeout period due to busy vhost worker kthreads.
> 
> I have missed this detail. Miroslav told me that we have solved
> something similar some time ago, see
> https://lore.kernel.org/all/20220507174628.2086373-1-song@kernel.org/

Interesting thread. I had thought about something along the lines of the
original patch, but there are some ideas in there that I hadn't
considered.

> Honestly, kpatch's timeout 1 minute looks incredible low to me. Note
> that the transition is tried only once per minute. It means that there
> are "only" 60 attempts.
> 
> Just by chance, does it help you to increase the timeout, please?

To be honest my test setup reproduces the problem well enough to make
KLP wait significant time due to vhost threads, but it seldom causes it
to hit kpatch's timeout.

Our system management software will try to load a patch tens of times in
a day, and we've seen real-world cases where patches couldn't load
within kpatch's timeout for multiple days. But I don't have such an
environment readily accessible for my own testing. I can try to refine
my test case and see if I can get it to that point.

> This low timeout might be useful for testing. But in practice, it does
> not matter when the transition is lasting one hour or even longer.
> It takes much longer time to prepare the livepatch.

Agreed. And to be clear, we cope with the fact that patches may take
hours or even days to get applied in some cases. The patches I sent are
just about improving the only case I've identified which has lead to
kpatch failing to load a patch for a day or longer.

Thanks,
Seth
