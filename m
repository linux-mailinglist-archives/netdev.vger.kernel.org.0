Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C722B79E3
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 14:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390443AbfISM4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 08:56:03 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:35990 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390440AbfISM4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 08:56:03 -0400
Received: by mail-yb1-f195.google.com with SMTP id p23so1289760yba.3
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 05:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RMhKFFhgfwYx83zY6Jd0u64gOJvt2kr6rD9TDcH0gmY=;
        b=Lg4abc2POwrfTKw98vsQapqmpZQI3JlrjDUErzmJddO/Hi7ElbcjqHA6eO3GjMn7+u
         4MQ8VHUuFrrLLByuVCiy12y3UJMtoer3enYgMN18zdvnFX9POlVDwshgXzrBULj2/lOv
         0ehK4jvp6MkrgQm+qbAcoWsIqD3nr8YMveZkEiMfHv8fMRMy/L4bG8lZ2MAJat34QVKr
         mPPKX48aO5fqO4EEEEOG09ny+yGyBQmujG94h7Q+bm0NggiiMq3guJhflEuCROnqJFKU
         Z/U3NGWP1qYFX4Jg51mJ+lNfBfbyJQ8q5t9bc3YeNZguXcW+delUnsDpBaq4uN6s29BF
         BtKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RMhKFFhgfwYx83zY6Jd0u64gOJvt2kr6rD9TDcH0gmY=;
        b=lB+3LMes9FTLE04UOyxXNHVRLvy34GPNgRza8hYUyB9iLZy9u0cuJEXP7Zwnjmzdyz
         t/Ok34ZWwk3Z2lPlD59pAkGITeUYRWFSbMHN5KgMqloh2lgQWEmOvQxp6ize2Cag3Zcd
         NRp+RUzIWMN4wsq26beWfkGz824+VLgjsR4f8B1982y4q1wSqgqBD93Cz6K9BdC0p4vm
         be2RcgNgJ8yXXP0JO7KgqbnSqWg89U7EvboHUb+W3khfMqo+AGYQGyg3GuNSRzowRqJM
         3qf+AQGomQke6DU9odn6Wnn8EugaAdPQE1Jt0TS+bsKn3x4mwAI0NPMu2A84l/TIrDpS
         2QJg==
X-Gm-Message-State: APjAAAXccZ5WsmuQDqjPjTC41wcK365tFP8VPj3FHqmTziFr8Cocx/m8
        sp92v8SQj6M3j/ULYFhJYsbaGavs
X-Google-Smtp-Source: APXvYqwgdr1AXQpogyUq30vVv2wFQbzpqcvXgXUha1RRlHoC8SCg0UPVHxxvFhSMhGL4l/g02t5IDw==
X-Received: by 2002:a25:902:: with SMTP id 2mr6114618ybj.99.1568897760626;
        Thu, 19 Sep 2019 05:56:00 -0700 (PDT)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id o11sm1844264ywc.42.2019.09.19.05.55.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2019 05:55:59 -0700 (PDT)
Received: by mail-yb1-f170.google.com with SMTP id y6so1267975ybq.12
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 05:55:59 -0700 (PDT)
X-Received: by 2002:a25:a1c2:: with SMTP id a60mr5752520ybi.46.1568897759162;
 Thu, 19 Sep 2019 05:55:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
 <CA+FuTSdVFguDHXYPJBRrLhzPWBaykd+7PRqEmGf_eOFC3iHpAg@mail.gmail.com> <20190918165817.GA3431@localhost.localdomain>
In-Reply-To: <20190918165817.GA3431@localhost.localdomain>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 19 Sep 2019 08:55:22 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf0N9uhOM3r8xvXiVj0xhx0KqL6-rV9EGhBJ=d8oGaxyg@mail.gmail.com>
Message-ID: <CA+FuTSf0N9uhOM3r8xvXiVj0xhx0KqL6-rV9EGhBJ=d8oGaxyg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 0/5] Support fraglist GRO/GSO
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 12:58 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, Sep 18, 2019 at 12:17:08PM -0400, Willem de Bruijn wrote:
> > On Wed, Sep 18, 2019 at 3:25 AM Steffen Klassert
> > <steffen.klassert@secunet.com> wrote:
> > >
> > > This patchset adds support to do GRO/GSO by chaining packets
> > > of the same flow at the SKB frag_list pointer. This avoids
> > > the overhead to merge payloads into one big packet, and
> > > on the other end, if GSO is needed it avoids the overhead
> > > of splitting the big packet back to the native form.
> > >
> > > Patch 1 Enables UDP GRO by default.
> > >
> > > Patch 2 adds a netdev feature flag to enable listifyed GRO,
> > > this implements one of the configuration options discussed
> > > at netconf 2019.
> > >
> > > Patch 3 adds a netdev software feature set that defaults to off
> > > and assigns the new listifyed GRO feature flag to it.
> > >
> > > Patch 4 adds the core infrastructure to do fraglist GRO/GSO.
> > >
> > > Patch 5 enables UDP to use fraglist GRO/GSO if configured and no
> > > GRO supported socket is found.
> >
> > Very nice feature, Steffen. Aside from questions around performance,
> > my only question is really how this relates to GSO_BY_FRAGS.
>
> They do the exact same thing AFAICT: they GSO according to a
> pre-formatted list of fragments/packets, and not to a specific size
> (such as MSS).
>
> >
> > More specifically, whether we can remove that in favor of using your
> > new skb_segment_list. That would actually be a big first step in
> > simplifying skb_segment back to something manageable.
>
> The main issue (that I know) on obsoleting GSO_BY_FRAGS is that
> dealing with frags instead of frag_list was considered easier to be
> offloaded, if ever attempted.  So this would be a step back on that
> aspect.  Other than this, it should be doable.

But GSO_BY_FRAGS also uses frag_list, not frags?

And list_skb->len for mss.
