Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102A2692C7D
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 02:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjBKBUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 20:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBKBUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 20:20:38 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E188F765E2
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 17:20:37 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id h24so8029705qtr.0
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 17:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R2Gg7p8hVGBYnA+IgS66YPkNuxpi7yhilYWI2x9lHcc=;
        b=OSzutwMDfk55Qv7+KU6m1Je6lrOM07i5NS37rk9aGB1QIMtu9wlQeREL7WOaVuyQvA
         ND70xE5pD+0PmeI+g/kizg/wO9keBoCM1NakQEb+wp9fhBAxZ3E0/ruADmd9EgreG2IO
         oHM8LnF1Q8lUM7pDHoWNrNujJBrrrnCg4s/zqvDz3YGZDvLqHfBOa6X8f3kHi9sfvrrH
         EEmAPfWMTuCXxVJBB7+4kaaQTPKDvoLJZ04+AvGKw9ulFaS/fNvcnbKQHfaD76dVrmRo
         NSwqSjXlRoLL/k0eOWiT5cw88NlcqV7TeiHGXZKmQ4CLUotbZqCrVRtc9wIXYiTU4bqM
         Yqbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2Gg7p8hVGBYnA+IgS66YPkNuxpi7yhilYWI2x9lHcc=;
        b=J3aBqyzG3KTwvUJygvVt+2kffQFjK9EALhWdrOrI1mIwlLgv7d2WIn6aZau+9BSQiL
         eVoABSJn3ppxNeo2EaqWZqzlLuZiVJH3elrhHXG78vrkfOlgnCjg0mo8YKRXHyvmRRdZ
         XhsSbv6qvC+6YN44Hw1Tslc2cMjJlv4IhiMCOG6jgfZb9JtU7BTl9KArjOxtqT5KbTHR
         ieI8UuS6wdXp3VF6agbAetrI3w0HbZQeUPPUFAalRUcT1SrJMHUMkPX2b4+QJdTmLqYX
         19lbSlM3EJXqEdHi26oNbYLbCqQyhXWrrancKBdzkhoUY1yj23y6ul+BOyMR5ehTQan7
         iJSA==
X-Gm-Message-State: AO0yUKXWRYpFztYrZ5Qv1SR6t92V2hWe+F80r1J4hUK7d3LY+WyztFvK
        6dYfz4p/RiWfFPBZR1A6evI=
X-Google-Smtp-Source: AK7set/YLR8sB7eAJ1jcLN4s3RTNA+UF7AZO/W2hNWQYMAeHdygd/tcmUXU45zFVbG/b2oPSyhLDYA==
X-Received: by 2002:ac8:5cce:0:b0:3b9:a777:3d9a with SMTP id s14-20020ac85cce000000b003b9a7773d9amr30836246qta.44.1676078436932;
        Fri, 10 Feb 2023 17:20:36 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id h19-20020ac87453000000b003b9a6d54b6csm4382288qtr.59.2023.02.10.17.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 17:20:36 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 6B8AC4C201B; Fri, 10 Feb 2023 17:20:35 -0800 (PST)
Date:   Fri, 10 Feb 2023 17:20:35 -0800
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, stephen@networkplumber.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH iproute2-next] tc: m_ct: add support for helper
Message-ID: <Y+btY0hReqhnviDK@t14s.localdomain>
References: <ab1e6bfbefff74b2b4fe230162b198c38cf5b394.1676065393.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab1e6bfbefff74b2b4fe230162b198c38cf5b394.1676065393.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 04:43:13PM -0500, Xin Long wrote:
> This patch is to add the setup and dump for helper in tc ct action
> in userspace, and the support in kernel was added in:
> 
>   https://lore.kernel.org/netdev/cover.1667766782.git.lucien.xin@gmail.com/
> 
> here is an example for usage:
> 
>   # ip link add dummy0 type dummy
>   # tc qdisc add dev dummy0 ingress
> 
>   # tc filter add dev dummy0 ingress proto ip flower ip_proto \
>     tcp ct_state -trk action ct helper ipv4-tcp-ftp

It is not wrong as is, but the example could limit it to port 21.

> 
>   # tc filter show dev dummy0 ingress
>     filter protocol ip pref 49152 flower chain 0 handle 0x1
>       eth_type ipv4
>       ip_proto tcp
>       ct_state -trk
>       not_in_hw
>         action order 1: ct zone 0 helper ipv4-tcp-ftp pipe
>         index 1 ref 1 bind
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
