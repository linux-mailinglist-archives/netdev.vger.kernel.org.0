Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812E7342E1C
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 17:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCTQBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 12:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhCTQBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 12:01:22 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C28C061574
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 09:01:22 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id r193so9366001ior.9
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 09:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=LfvIIwwLMgvwoVyTmNPDNz2X4Cjemn3ViiYOKxC2xtQ=;
        b=CJMYXxjmY2rThwz2Fu/NxW3pUsk6Rtx6JoYeAwenhXdLnor7yeMpUAOXpTOxew81k4
         dksVUF14OAIiKnBedwjrHBIjvvzd2Tj53NCQ+I6CeDTE8NY0b854ZGPd98s3d6z2/ujV
         fi066Fx3ZwZuuBtaMRuZrLAssjTvp9nmQKGLo2xw5O2iNNo2HCJAJLBQJ6/hAh/ZBpWp
         IYX+diMUL/KdUhkZeExLRVpJ2+In2NUBteMF7DxTyPODoKmwpd1pisf96al8DIGiEIcz
         8aGR//jmt5eLvdteuTMUNdW6cRYUF5rpaGvIZ5PuJ+AAWThBeidIilqHCW6Pp9E6KFBp
         4LhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=LfvIIwwLMgvwoVyTmNPDNz2X4Cjemn3ViiYOKxC2xtQ=;
        b=s5qPomxHwzZ2jTtnS9hlVp0sFU8HQ+5GlE3MYyB/zE50ZNnKG/6cHqB7kCgfszcDkc
         XdLoOaIoqt5E3DZh6fQjdvj5RV6HcoHKdZUGImiI+6MB+6qoAvmWpiZ2KzVESN/NX3b1
         wH5gwzMhQ9juWLGbRrIMlVX3DbKxoXcID/iSOZKYD6BMkRlajnZ8NI8iI82j9WlNcaNr
         JTU8tMT0S3Qs+CvmfsplJgyEvimF9Cy4pOVn9rdu8H7EEAitH8ywxzg+/HbWbdPQRcQ+
         gDB8d6aTzMWo3eBaXeQno/KQ3giKoxEUGnuXcfziRAIPOjO/a/hHQZoI1E8OHITESVV/
         iFFw==
X-Gm-Message-State: AOAM5317x1bghPMX35p0U0NriWM5poTJAXnDP3L9UxwP5KEhHYQGX73E
        Ger8vVq7X6fWzxF6jnewnOU=
X-Google-Smtp-Source: ABdhPJwAXk/9SjZBuJT3e7CiebFDM5zgniyys4sJceqOD+AHhRrXJBWJ6a0RPuX/Xx+2ppQCLXoh8g==
X-Received: by 2002:a02:cb4b:: with SMTP id k11mr5481649jap.144.1616256081777;
        Sat, 20 Mar 2021 09:01:21 -0700 (PDT)
Received: from ?IPv6:2601:681:8800:baf9:1ee4:d363:8fe6:b64f? ([2601:681:8800:baf9:1ee4:d363:8fe6:b64f])
        by smtp.gmail.com with ESMTPSA id h1sm4583916ilo.64.2021.03.20.09.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 09:01:21 -0700 (PDT)
Message-ID: <26d502c2efecf3ea1ffdd8784590697d02907e7a.camel@gmail.com>
Subject: Re: [PATCH V4 net-next 5/5] icmp: add response to RFC 8335 PROBE
 messages
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     David Ahern <dsahern@gmail.com>, David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dsahern@kernel.org
Date:   Sat, 20 Mar 2021 11:01:20 -0500
In-Reply-To: <34107111-5293-2119-cfc7-8156c43ae555@gmail.com>
References: <a30d45c43a24f7b65febe51929e6fe990a904805.1615738432.git.andreas.a.roeseler@gmail.com>
         <202103150433.OwOTmI15-lkp@intel.com>
         <72c4ccfc219c830f1d289c3d4c8a43aec6e94877.camel@gmail.com>
         <20210317.201948.1069484608502867994.davem@davemloft.net>
         <34107111-5293-2119-cfc7-8156c43ae555@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-03-17 at 21:24 -0600, David Ahern wrote:
> On 3/17/21 9:19 PM, David Miller wrote:
> > From: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> > Date: Wed, 17 Mar 2021 22:11:47 -0500
> > 
> > > On Mon, 2021-03-15 at 04:35 +0800, kernel test robot wrote:
> > > Is there something that I'm not understanding about compiling
> > > kernel
> > > components modularly? How do I avoid this error?
> > 
> > > 
> > You cannot reference module exported symbols from statically linked
> > code.
> > y
> > 
> 
> Look at ipv6_stub to see how it exports IPv6 functions for v4 code.
> There are a few examples under net/ipv4.

Thanks for the advice. I've been able to make some progress but I still
have some questions that I have been unable to find online.

What steps are required to include a function into the ipv6_stub
struct? I've added the declaration of the function to the struct, but
when I attempt to call it using <ipv6_stub->ipv6_dev_find()> the kernel
locks up. Additionally, a typo in the declaration isn't flagged during
compilation. Are there other places where I need to edit the ipv6_stub
struct or include various headers? The examples I have looked at are
<fib_semantics.c>, <nexthop.c>, and <udp.c> in the <net/ipv4> folder
and they don't seem to do anything on the caller side of ipv6_stub, so
I think I am not adding the function to ipv6_stub properly. I have been
able to call other functions that currently exist in ipv6_stub, but not
the one I  am attempting to add, so am I missing a step?

I've noticed that some functions such as <ipv6_route_input> aren't
exported using EXPORT_SYMBOL when it is defined in
<net/ipv6/af_inet6.c>, but it is still loaded into ipv6_stub. How can
this be? Is there a different way to include symbols into ipv6_stub
based on whether or not they are explicitly exported using
EXPORT_SYMBOL?

