Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309C42B6D16
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730771AbgKQSTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729115AbgKQSTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 13:19:35 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D846C0613CF;
        Tue, 17 Nov 2020 10:19:35 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id k7so10697637plk.3;
        Tue, 17 Nov 2020 10:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PFq6BuwaqMtWaqivH1hlWxEaD6bmqyH7wkNMgAsZWiI=;
        b=JeQZQdNGFQEvrnyuHqAQBpFXjtfCGjJMKqpGqNZ+Rq6IGqw89kw5ATBbpZ+anzLED6
         vrL5Cwr0b9gi2KIfRxci1D1j1K5DhI3e5COGXIpHWhjR/60HH6HAhalsLp2KvNS0CNYa
         gDjFOEQdCKUPEPXGlIislM49jVel77hdttQxJvXtzbBT13X9ZP7TSthnd4qNbjq9khGY
         4TL44CvTDRuZQD806gOE8OuYLSODzaMTivkOI7/oJGeFVl565BGNaQtb3zbjsXUNb3NK
         GLzaZaTclUMMgr8hc25VK/4uwJbDg45LJWc/IxPN/UdrObp2hBVQNfutm6IA4yL20/oB
         plDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PFq6BuwaqMtWaqivH1hlWxEaD6bmqyH7wkNMgAsZWiI=;
        b=oKwhD53dCEghg3bYF89+ZlX+nlXeMQWHxJyciidSdwokrWb9bzfHLnoboL2h69AhfO
         O8WKme9lZi4YWd1MNfkVU2wwo0u48x4GcqLV+DgFlr55h4qTyfEOs9mBa44CQn9nBxUu
         pMeCXuyg9cYQMBMyAKpUIjlU6sQbW8herFh9Qn8UGOXR9Fob56TO72OU3NTMMe3mqYKl
         87fsy1yE83Ljm5M5f7XmWDG8XaeNdohvEEDUdH9apP2Q1Dy39NdjuGRqHKj+LfF1+vbe
         rs+0vv69JOBN/0zCCxjijDhUz+6p0GwXyrcXL9VMcPuzUyZ/iRgxgnWNb/syEhsvpiCB
         4fVQ==
X-Gm-Message-State: AOAM531sP1dHnHRbNuFSzR3QAK++xrEzj8mKoXGBhc50QubTolHZtGxx
        RJCEsLFx1zsYtE4sTKZ8OitaAicULkY=
X-Google-Smtp-Source: ABdhPJxbYZkucW+PpT/ikB2rEXVzRPZxxgC/YkbNdhvKmsDw8hZK76aAWUtpn60JZUBvzdrzIALZmA==
X-Received: by 2002:a17:90a:d3d3:: with SMTP id d19mr360881pjw.0.1605637175028;
        Tue, 17 Nov 2020 10:19:35 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:8f57])
        by smtp.gmail.com with ESMTPSA id j19sm23926990pfd.189.2020.11.17.10.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 10:19:34 -0800 (PST)
Date:   Tue, 17 Nov 2020 10:19:31 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiri Benc <jbenc@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv5 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201117181931.4gcbp4ubs2dccw4k@ast-mbp>
References: <20201109070802.3638167-1-haliu@redhat.com>
 <20201116065305.1010651-1-haliu@redhat.com>
 <CAADnVQ+LNBYq5fdTSRUPy2ZexTdCcB6ErNH_T=r9bJ807UT=pQ@mail.gmail.com>
 <20201116155446.16fe46cf@carbon>
 <62d26815-60f8-ca9f-bdbf-d75070935f1d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62d26815-60f8-ca9f-bdbf-d75070935f1d@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 08:38:15PM -0700, David Ahern wrote:
> 
> As for the bigger problem, trying to force user space components to
> constantly chase latest and greatest S/W versions is not the right answer.

Your own nexthop enhancements in the kernel code follow 1-1 with iproute2
changes. So the users do chase the latest kernel and the latest iproute2
if they want the networking feature.
Yet you're arguing that for bpf features they shouldn't have such expectations
with iproute2 which will not support the latest kernel bpf features.
I sense a lot of bias here.

> The crux of the problem here is loading bpf object files and what will
> most likely be a never ending stream of enhancements that impact the
> proper loading of them.

Please stop this misinformation spread.
Multiple people explained numerous times that libbpf takes care of
backward compatibility.

> That said, the legacy bpf code in iproute2 has created some
> expectations, and iproute2 can not simply remove existing capabilities.

It certainly can remove them by moving to libbpf.

> iproute2 is a networking configuration tool, not a bpf management tool.
> Hangbin’s approach gives full flexibility to those who roll their own
> and for distributions who value stability, it allows iproute2 to use
> latest and greatest libbpf for those who want to chase the pot of gold
> at the end of the rainbow, or they can choose stability with an OS
> distro’s libbpf or legacy bpf. I believe this is the right compromise at
> this point in time.

In other words you're saying that upstream iproute2 is a kitchen sink
of untested combinations of libraries and distros suppose to do a ton
of extra work to provide their users a quality iproute2.
