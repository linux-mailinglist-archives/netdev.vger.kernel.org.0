Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67FD050B5D3
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 13:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446816AbiDVLF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 07:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446800AbiDVLF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 07:05:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 442C65622C
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 04:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650625353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZyHAq8XvVGq2hZYkl/QwRkAUTtNiHFZTrfQAk4QcfNI=;
        b=KBQHAbGW+PLrkQ7yQa+5AJG9Y1cld2G9zqgyPcr6+BeU7VJYrD6aw9p0rXEAgiKizzXyPL
        x8o9d7tjr65+xZ0jIub+om3Sv1zT4wBGkFVvhgP7lwyWzy5VlRneo0u3JlowAxk8dXcAoy
        1/rA034FIqkdR5b6Wh5jfZZRcD+IF/I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-6t0hRrSdPzWpUrdsNqHs2A-1; Fri, 22 Apr 2022 07:02:32 -0400
X-MC-Unique: 6t0hRrSdPzWpUrdsNqHs2A-1
Received: by mail-wm1-f72.google.com with SMTP id v62-20020a1cac41000000b0038cfe6edf3fso5906096wme.5
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 04:02:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZyHAq8XvVGq2hZYkl/QwRkAUTtNiHFZTrfQAk4QcfNI=;
        b=q/JUmJ+pOkFR7vQ8L3EoVgwtw7WRWagVYez7i6ebiTaj2K+IKIiuD0enh8aVDFyntQ
         bmiMu754G3t1Rl9+xNxVRy+lhr72aD4i9U3XCl0Owc23wWs/1Z5bPv+aARck35VfP2o1
         fHQiYfbCL4b6jYx96L3OSWHllzUx4ddKnYejvpskhfdRRH+WfbulZdmvwqZM4AbkTqHn
         XUeuLDWvmZ4h5KZJ4RJqQUHGUXCgXJboJUWZRkL9fm1ScP914X8PaNZQxijTlUbzvb6d
         4kl2qXOjJy3Lq9SJ/CD9zSj+MmYEAr9wJKqlKL7jfWXyPdab91SVl6yDUKNGanGXycft
         1Lag==
X-Gm-Message-State: AOAM5318HvlpXmjBRRbkQl1/5MJhsXPdy5SRAnAc3SSC9Xvag9aYN0+k
        Lxgy9GQdHAFwhS/TAEJINJHAO323EzygbSoMtl6Ua5MWK6PT/0DsBxHgaHh6un1GfjZysYB6ICo
        tr/kGUWyJoVLOCc6F
X-Received: by 2002:a5d:4888:0:b0:207:ad8b:e534 with SMTP id g8-20020a5d4888000000b00207ad8be534mr3054351wrq.325.1650625351085;
        Fri, 22 Apr 2022 04:02:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5KDHAyqMTVOXlPYgdsFNWeD0RjDElwWKKy8+vAIVq0lSzAkGokyJMdVzf2Awq+RspMcySUg==
X-Received: by 2002:a5d:4888:0:b0:207:ad8b:e534 with SMTP id g8-20020a5d4888000000b00207ad8be534mr3054328wrq.325.1650625350805;
        Fri, 22 Apr 2022 04:02:30 -0700 (PDT)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id l6-20020a1c2506000000b0038e6fe8e8d8sm1740027wml.5.2022.04.22.04.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 04:02:30 -0700 (PDT)
Date:   Fri, 22 Apr 2022 13:02:28 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dccp@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] ipv4: First steps toward removing RTO_ONLINK
Message-ID: <20220422110228.GB15621@debian.home>
References: <cover.1650470610.git.gnault@redhat.com>
 <2ee8fb0d-aeb4-5010-bc8c-16cbd6e88eff@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ee8fb0d-aeb4-5010-bc8c-16cbd6e88eff@kernel.org>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 09:10:21PM -0600, David Ahern wrote:
> On 4/20/22 5:21 PM, Guillaume Nault wrote:
> > RTO_ONLINK is a flag that allows to reduce the scope of route lookups.
> > It's stored in a normally unused bit of the ->flowi4_tos field, in
> > struct flowi4. However it has several problems:
> > 
> >  * This bit is also used by ECN. Although ECN bits are supposed to be
> >    cleared before doing a route lookup, it happened that some code
> >    paths didn't properly sanitise their ->flowi4_tos. So this mechanism
> >    is fragile and we had bugs in the past where ECN bits slipped in and
> >    could end up being erroneously interpreted as RTO_ONLINK.
> > 
> >  * A dscp_t type was recently introduced to ensure ECN bits are cleared
> >    during route lookups. ->flowi4_tos is the most important structure
> >    field to convert, but RTO_ONLINK prevents such conversion, as dscp_t
> >    mandates that ECN bits (where RTO_ONLINK is stored) be zero.
> > 
> > Therefore we need to stop using RTO_ONLINK altogether. Fortunately
> > RTO_ONLINK isn't a necessity. Instead of passing a flag in ->flowi4_tos
> > to tell the route lookup function to restrict the scope, we can simply
> > initialise the scope correctly.
> > 
> 
> I believe the set looks ok. I think the fib test coverage in selftests
> could use more tests to cover tos.

Yes, this is on my todo list. I also plan to review existing tests that
cover route lookups with link scope, and extend them if necessary.

Thanks for the review.

