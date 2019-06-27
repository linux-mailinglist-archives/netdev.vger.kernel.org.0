Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A261C58E18
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfF0Wnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:43:43 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40142 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfF0Wnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:43:43 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so1660022pgj.7
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=5O3kSJg9RVJ5T6uGFuCCgrilMbmqviMCndXtUJji4vw=;
        b=B8mtQdHT3xNN9IgfxdxrtUrOY1XziHn+4pMo1jVxIMWhrTPBtnPdul136qPoyGGaQz
         vumZ8FqIvIX6GfqvSiVytmon9oN+KFfJFOZgilP3HZPPNzZ2PLQkIyL8CcWlzzrc9MPL
         8AfxZVkKV3Nk79HIExQjLk4JRQigjUBPmUgHNJV3HBxVdJZoMVPYTNei4sSMRYtDGCgM
         NS88+J5OrHN1fYj6DT3W9cbJ+z9IGR3yETEI37Q5utlODfWZkRi2bpBxLXBQmylyi5Lg
         myNav7RdaB4ujVmVPtRtdOasOFMHTpsw3Wg5vTPRBBnhZIm9aw+H1JTMhEvWI9k2lYXT
         FJkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=5O3kSJg9RVJ5T6uGFuCCgrilMbmqviMCndXtUJji4vw=;
        b=C032eafLn/DCq8s/qzKnrSkfqVhGDPXqUg1mhODGBPBRbBwlSokoblE094nedjQjhj
         CyRc51QLUQOkRRCrDxyvOJnLZx7qAYcnzMfyqMP3Rmfh03swYajUrojtOdNzKWcOHlnv
         THhaKulfQlqo007i1uiWSMbh8YZlQLRTAS6/YkGcNaV5q1H8mjUlFu5+IhwizKycaKej
         Eg4W/NGvRXqBQsubOWl27ASTHp361MzXsicAUcrHa6RveS33zoKB1mBq1Zn/7x7vVhPq
         CTfcZZKPP8K1n3SUi75KLpAcG61SpcI2d7aMgWh8k5jW7afhCMxjyb3wuEIqF3a6IXRR
         uCbw==
X-Gm-Message-State: APjAAAV9XKhGTHvV+f9bXhp7QgaT+HaJr1c8M81v4HeB8JZzD4VTJ/w4
        6Pdefb6UjWAio4DfBw32Yr9mJA==
X-Google-Smtp-Source: APXvYqxgcsd7rTT42Fj/pLmmVylW+Fy/z04PBovQ9xKn9aHTqVP/bfFi+Pp0ulkWB5I0e6sTI3KP/A==
X-Received: by 2002:a65:6495:: with SMTP id e21mr5912028pgv.383.1561675422744;
        Thu, 27 Jun 2019 15:43:42 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id l44sm222112pje.29.2019.06.27.15.43.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 15:43:42 -0700 (PDT)
Date:   Thu, 27 Jun 2019 15:43:41 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [PATCH bpf-next v9 0/9] bpf: getsockopt and setsockopt hooks
Message-ID: <20190627224341.GE4866@mini-arch>
References: <20190627203855.10515-1-sdf@google.com>
 <20190627223147.vkkmbtdcvjzas2ej@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190627223147.vkkmbtdcvjzas2ej@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/27, Alexei Starovoitov wrote:
> On Thu, Jun 27, 2019 at 01:38:46PM -0700, Stanislav Fomichev wrote:
> > This series implements two new per-cgroup hooks: getsockopt and
> > setsockopt along with a new sockopt program type. The idea is pretty
> > similar to recently introduced cgroup sysctl hooks, but
> > implementation is simpler (no need to convert to/from strings).
> > 
> > What this can be applied to:
> > * move business logic of what tos/priority/etc can be set by
> >   containers (either pass or reject)
> > * handle existing options (or introduce new ones) differently by
> >   propagating some information in cgroup/socket local storage
> > 
> > Compared to a simple syscall/{g,s}etsockopt tracepoint, those
> > hooks are context aware. Meaning, they can access underlying socket
> > and use cgroup and socket local storage.
> > 
> > v9:
> > * allow overwriting setsocktop arguments (Alexei Starovoitov)
> >   (see individual changes for more changelog details)
> 
> Applied. Thanks.
Great, thanks for all the reviews!

> There is a build warning though:
> test_sockopt_sk.c: In function ‘getsetsockopt’:
> test_sockopt_sk.c:115:2: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
>   if (*(__u32 *)buf != 0x55AA*2) {
>   ^~
> test_sockopt_sk.c:116:3: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
>    log_err("Unexpected getsockopt(SO_SNDBUF) 0x%x != 0x55AA*2",
>    ^~~~~~~
> 
> Pls fix it in the follow up.
Sure, but I can't reproduce it with gcc7 nor with clang9 :-/
Presumably, a switch to __get_unaligned_cpu32 should help,
I'll try to play with compilers a bit before sending a fix.
