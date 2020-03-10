Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE391804A3
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgCJRTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:19:37 -0400
Received: from mail-il1-f182.google.com ([209.85.166.182]:41091 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgCJRTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:19:36 -0400
Received: by mail-il1-f182.google.com with SMTP id l14so6863870ilj.8
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 10:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FCcIWv3vdGhCDB7Fx4WoX0Pzsosk07tk1IQ/8aVdXvQ=;
        b=plc5vvq2LV5e7n2mzDRlznqVfsfaTxITY1zs+LIAiDhVjKUIGUKmrHzZyV4CjwmNj9
         f05F4M6v2sGoMf3yY3eQTPW1FHyKevg0p9ALUUJ+D1mfPr2MHAIeOK5HDeYgtE4LrUKZ
         GgRUOTjmJJDlykh7cviz5D2Fbw96K7GXjbW7fheuSjWc3v3E8jhs3bZjX+Tn45+YJxA2
         JxmUaiUexygG7X9BmxMX0JinlHA83zN676SVHoS4pbK3patSRsg9WnBkOBy5Y7ufdU18
         nG75pKbCwFtCZJl8W9j4WeUL+It7A/OjXd1fHa9n3dpNCIvPRJNk0dxQ0/0G0LVsS83J
         A+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FCcIWv3vdGhCDB7Fx4WoX0Pzsosk07tk1IQ/8aVdXvQ=;
        b=TV7vHy1pO5WtpGDPmpoAzuswfoKEFrv65wp6LurVhzo5osynS121xpvGaf37PCZdNP
         9KG+yhQlzfIPoegfZlB29xPMscragt+RDx6h02JtKAjCnD2qZkVrphvE4aCLJRNriCAf
         +WAIblQgqUIfhPLHpcKgzySA2c1swB2Zb+dJwg1AAdV0g4KCN1D1+l9wQ6oaA6gBtiuv
         gyFOphV0NQ1XMdswFh9w7cawUzJ4hAX/u6QA88887ppCZuLEK+5Uv7WI/o6zuE7OYzDp
         YYGTMPPle7NI5ZfRyZTgS2To+xGqUmWGb4S1919NOd0AiVnZk71J7R5RN49XHLvLa3Ij
         t7CQ==
X-Gm-Message-State: ANhLgQ2lv7duf17eNDBuR3Frl6/5P/qjSm+fnpPNdjItZmUSmSt6+uYM
        34VY9jjfCvXk2a1DgTf/R6rjG48l0i60hZHrio0=
X-Google-Smtp-Source: ADFU+vv6fI9eIdE3EACuO/xJfdRyAaRRGhwDwPw6UMJQxwRtHYJkOkspnCoac7uJEb7soA8yC2Sfj1zpdFRrXu0kaZs=
X-Received: by 2002:a92:d30b:: with SMTP id x11mr20198838ila.64.1583860775935;
 Tue, 10 Mar 2020 10:19:35 -0700 (PDT)
MIME-Version: 1.0
References: <CADvbK_evghCnfNkePFkkLbaamXPaCOu-mSsSDKXuGSt65DSivw@mail.gmail.com>
 <1441d64c-c334-8c54-39e8-7a06a530089d@gmail.com> <CAKgT0UcbycqgrfviqUmvS9S7+F6q-gMzrz-KKQuEb77ruZZLRQ@mail.gmail.com>
 <20200310155630.GA7102@pc-3.home> <20200310160133.GA7670@pc-3.home>
In-Reply-To: <20200310160133.GA7670@pc-3.home>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 10 Mar 2020 10:19:24 -0700
Message-ID: <CAKgT0Ucc2gHxR0TZUZN7LmzFg9xfeA+kC_jQcwVOTY8sUnaijA@mail.gmail.com>
Subject: Re: route: an issue caused by local and main table's merge
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, mmhatre@redhat.com,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 9:01 AM Guillaume Nault <gnault@redhat.com> wrote:
>
> On Tue, Mar 10, 2020 at 04:56:32PM +0100, Guillaume Nault wrote:
> > On Mon, Mar 09, 2020 at 08:53:53AM -0700, Alexander Duyck wrote:
> > > Also, is it really a valid configuration to have the same address
> > > configured as both a broadcast and unicast address? I couldn't find
> > > anything that said it wasn't, but at the same time I haven't found
> > > anything saying it is an acceptable practice to configure an IP
> > > address as both a broadcast and unicast destination. Everything I saw
> > > seemed to imply that a subnet should be at least a /30 to guarantee a
> > > pair of IPs and support for broadcast addresses with all 1's and 0 for
> > > the host identifier. As such 192.168.122.1 would never really be a
> > > valid broadcast address since it implies a /31 subnet mask.
> > >
> > RFC 3031 explicitly allows /31 subnets for point to point links.
> That RFC 3021, sorry :/
>

So from what I can tell the configuration as provided doesn't apply to
RFC 3021. Specifically RFC 3021 calls out that you are not supposed to
use the { <network-prefix>, -1 } which is what is being done here. In
addition the prefix is technically a /24 as configured here since a
prefix length wasn't specified so it defaults to a class C.

Looking over the Linux kernel code it normally doesn't add such a
broadcast if using a /31 address:
https://elixir.bootlin.com/linux/v5.6-rc5/source/net/ipv4/fib_frontend.c#L1122

- Alex
