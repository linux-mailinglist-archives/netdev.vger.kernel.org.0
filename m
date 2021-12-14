Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60A2473972
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 01:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242866AbhLNAQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 19:16:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50529 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235953AbhLNAQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 19:16:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639441007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SgXjApH/GR18QkC9xRth0Zwediv3Ew+gsTN+82TIon8=;
        b=IfRlRrXk49E55weSW55fZyQbXxzwM8k3TNDp4CnA+FLYHLuoMKUuGdVtc2Rb9uFXdhl15q
        LgSWa+KVAwu9xjFIHTjCkAmwyX703k6XUYNTnuY/evE5syDAlJ832tC5nCtTVRva25Yy9H
        kIJShVJyUV8y37b0CTWa3FdaaRBirig=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-vfUX7962OWCNiSynEKprzQ-1; Mon, 13 Dec 2021 19:16:46 -0500
X-MC-Unique: vfUX7962OWCNiSynEKprzQ-1
Received: by mail-ed1-f69.google.com with SMTP id t9-20020aa7d709000000b003e83403a5cbso15418824edq.19
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 16:16:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SgXjApH/GR18QkC9xRth0Zwediv3Ew+gsTN+82TIon8=;
        b=ZvRPe7HFU8zmaAOonxaDoS52o26uanz3CGB7qwi3cH9ZNsQNB35es+g2UuykpkVsk2
         4LOFsK6kZYtBGoSFGvn8nNFyALxul9/s4yM5ATTiW5VsMlTXhycuOotYljcBnu8S2EHI
         WUnPHpEhRxIs4Mr5ADp1UO9xHKfcb0gSd+a8URvuiUlPtkYIz8pC25ygkwwKTASHOEHp
         I00GW2OzP1a433UOmZWKJAP4DB5+1nxmIWE2hMVCIBCWLL53Pd+VMDbYoOOCOzbIQD+G
         vAwKiDP4h9oxpZpsc7KadnPOKpmklXyvXk7tA1HGiMhKhk6EQGpc9h1LkLH/h3t5+rly
         j5+g==
X-Gm-Message-State: AOAM532H8tuGX1+NRbe0TupMfizSgZ0jrNoQWTIid4ybqtlwrHzHXBlt
        xkwEp9+u2KT6KU9eg5nSdxH7obaMKSimKP43DmUaHIac3mPI+LaM2jD9r1O3xKqN6eVNCzX0K+E
        qbYjeuDHZXSHnX03V
X-Received: by 2002:a17:907:78c4:: with SMTP id kv4mr1817109ejc.271.1639441005294;
        Mon, 13 Dec 2021 16:16:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxnMPHr1Wczlm++AKEHsRgrN1NaKWkKZHC0MRqwk5F4Ppky7CD3zdfwuN1DSMSCxM0lWSTudA==
X-Received: by 2002:a17:907:78c4:: with SMTP id kv4mr1817077ejc.271.1639441004937;
        Mon, 13 Dec 2021 16:16:44 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 9sm281247ejd.216.2021.12.13.16.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 16:16:44 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AD035183566; Tue, 14 Dec 2021 01:16:43 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Russell Strong <russell@strong.id.au>
Subject: Re: [PATCH net-next 0/4] inet: Separate DSCP from ECN bits using
 new dscp_t type
In-Reply-To: <cover.1638814614.git.gnault@redhat.com>
References: <cover.1638814614.git.gnault@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 14 Dec 2021 01:16:43 +0100
Message-ID: <87k0g8yr9w.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guillaume Nault <gnault@redhat.com> writes:

> Following my talk at LPC 2021 [1], here's a patch series whose
> objective is to start fixing the problems with how DSCP and ECN bits
> are handled in the kernel. This approach seemed to make consensus among
> the participants, although it implies a few behaviour changes for some
> corner cases of ip rule and ip route. Let's see if this consensus can
> survive a wider review :).

I like the approach, although I must admit to not being too familiar
with the parts of the code you're touching in this series. But I think
the typedefs make sense, and I (still) think it's a good idea to do the
conversion. I think the main thing to ensure from a backwards
compatibility PoV is that we don't silently change behaviour in a way
that is hard to detect. I.e., rejecting invalid configuration is fine
even if it was "allowed" before, but, say, changing the matching
behaviour so an existing rule set will still run unchanged but behave
differently is best avoided.

> Note, this patch series differs slightly from that of the original talk
> (slide 14 [2]). For the talk, I just cleared the ECN bits, while in
> this series, I do a bit-shift. This way dscp_t really represents DSCP
> values, as defined in RFCs. Also I've renamed the helper functions to
> replace "u8" by "dsfield", as I felt "u8" was ambiguous. Using
> "dsfield" makes it clear that dscp_t to u8 conversion isn't just a
> plain cast, but that a bit-shift happens and the result has the two ECN
> bits.

I like the names, but why do the bitshift? I get that it's conceptually
"cleaner", but AFAICT the shifted values are not actually used for
anything other than being shifted back again? In which case you're just
adding operations in the fast path for no reason...

> The new dscp_t type is then used to convert several field members:
>
>   * Patch 1 converts the tclass field of struct fib6_rule. It
>     effectively forbids the use of ECN bits in the tos/dsfield option
>     of ip -6 rule. Rules now match packets solely based on their DSCP
>     bits, so ECN doesn't influence the result anymore. This contrasts
>     with previous behaviour where all 8 bits of the Traffic Class field
>     was used. It is believed this change is acceptable as matching ECN
>     bits wasn't usable for IPv4, so only IPv6-only deployments could be
>     depending on it (that is, it's unlikely enough that a someone uses
>     ip6 rules matching ECN bits in production).

I think this is OK, cf the "break explicitly" thing I wrote above.

>   * Patch 2 converts the tos field of struct fib4_rule. This one too
>     effectively forbids defining ECN bits, this time in ip -4 rule.
>     Before that, setting ECN bit 1 was accepted, while ECN bit 0 was
>     rejected. But even when accepted, the rule wouldn't match as the
>     packets would normally have their ECN bits cleared while doing the
>     rule lookup.

As above.

>   * Patch 3 converts the fc_tos field of struct fib_config. This is
>     like patch 2, but for ip4 routes. Routes using a tos/dsfield option
>     with any ECN bit set is now rejected. Before this patch, they were
>     accepted but, as with ip4 rules, these routes couldn't match any
>     real packet, since callers were supposed to clear their ECN bits
>     beforehand.

Didn't work at all, so also fine.

>   * Patch 4 converts the fa_tos field of struct fib_alias. This one is
>     pure internal u8 to dscp_t conversion. While patches 1-3 dealed
>     with user facing consequences, this patch shouldn't have any side
>     effect and is just there to give an overview of what such
>     conversion patches will look like. These are quite mechanical, but
>     imply some code churn.

This is reasonable, and I think the code churn is worth the extra
clarity. You should probably spell out in the commit message that it's
not intended to change behaviour, though.

> Note that there's no equivalent of patch 3 for IPv6 (ip route), since
> the tos/dsfield option is silently ignored for IPv6 routes.

Shouldn't we just start rejecting them, like for v4?

-Toke

