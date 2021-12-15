Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91337475DDB
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 17:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239830AbhLOQsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 11:48:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49061 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245004AbhLOQse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 11:48:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639586913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H2PoDojIll4DRKu3kVtyz6pqodV49vpxONM7LsSXB5k=;
        b=Oje0JIa0tY0AA1HPNDEGEHaA51Kseq5nIcStAjRPORK//juV77S3jTfca+0oHxFNcXNxe0
        Tb6GxivXupDle8RUEyV2PKycvLUPfxe3anvXtpBnqG4UQ4K3yhODTvpOk8iOa3LgHajDs9
        4rfvF6yYfn+6XhVQT04eidw7zfVc4Kg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-PxG1MOJJN-aJYPpnE6qwgQ-1; Wed, 15 Dec 2021 11:48:30 -0500
X-MC-Unique: PxG1MOJJN-aJYPpnE6qwgQ-1
Received: by mail-wr1-f72.google.com with SMTP id q7-20020adff507000000b0017d160d35a8so6055093wro.4
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 08:48:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=H2PoDojIll4DRKu3kVtyz6pqodV49vpxONM7LsSXB5k=;
        b=44LbC/avlZL08L55WnACAeec/wKG67/smIPS0zO+qMdSowH2UzAX+H8ARtWWPNHM/i
         PG4EwZwpy66IBEwWFcaYVnBK1IBPlDwQ1cC1jSQghJB4yiI5Wxi9lpaLKC/UB7PLkyso
         FnySGPfPdi8Q4iaoXHSHw5RvWCKJAGnsUVf6AF1kVySAa6M3De1N44lneb1NtEwou4Ju
         UNIw06WaVnmkalVC4Vc6GM8ZjeXIlhKcBc7MVxgUJL5Sssl3wmZ+3/ZnupFSeo4FnAtR
         wkyGQm5AuUZQMUDOLYNI1IrfSDOhe8KQtfeh3wtDCdul5aci/EM/Cz3FJOToN3uxJhYX
         6Q1A==
X-Gm-Message-State: AOAM531ugEhGFeL2cyl+XD/EBz/5ANug7ENphrOTOovf3uddOyBrbFbw
        auhSdviS8UjiwZoSkiTFTHC+zbZzcceEkEAh6WCY4ZW2KSh3Ll8rI3I/gzTZSPQWoBIC99V9yYX
        uLqmC9B2jKP+9RRvx
X-Received: by 2002:a7b:c257:: with SMTP id b23mr726977wmj.67.1639586908902;
        Wed, 15 Dec 2021 08:48:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyy7xYyskZfOkYS57Nomzieq7s1f+O4325J51TIRIToPhF9/t/j75EQTIbT+pYD33lhW+6LUw==
X-Received: by 2002:a7b:c257:: with SMTP id b23mr726946wmj.67.1639586908621;
        Wed, 15 Dec 2021 08:48:28 -0800 (PST)
Received: from pc-1.home (2a01cb058d24940001d1c23ad2b4ba61.ipv6.abo.wanadoo.fr. [2a01:cb05:8d24:9400:1d1:c23a:d2b4:ba61])
        by smtp.gmail.com with ESMTPSA id n1sm3129232wrc.54.2021.12.15.08.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 08:48:28 -0800 (PST)
Date:   Wed, 15 Dec 2021 17:48:26 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Russell Strong <russell@strong.id.au>
Subject: Re: [PATCH net-next 0/4] inet: Separate DSCP from ECN bits using new
 dscp_t type
Message-ID: <20211215164826.GA3426@pc-1.home>
References: <cover.1638814614.git.gnault@redhat.com>
 <87k0g8yr9w.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k0g8yr9w.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 01:16:43AM +0100, Toke Høiland-Jørgensen wrote:
> Guillaume Nault <gnault@redhat.com> writes:
> 
> > Following my talk at LPC 2021 [1], here's a patch series whose
> > objective is to start fixing the problems with how DSCP and ECN bits
> > are handled in the kernel. This approach seemed to make consensus among
> > the participants, although it implies a few behaviour changes for some
> > corner cases of ip rule and ip route. Let's see if this consensus can
> > survive a wider review :).
> 
> I like the approach, although I must admit to not being too familiar
> with the parts of the code you're touching in this series. But I think
> the typedefs make sense, and I (still) think it's a good idea to do the
> conversion. I think the main thing to ensure from a backwards
> compatibility PoV is that we don't silently change behaviour in a way
> that is hard to detect. I.e., rejecting invalid configuration is fine
> even if it was "allowed" before, but, say, changing the matching
> behaviour so an existing rule set will still run unchanged but behave
> differently is best avoided.
> 
> > Note, this patch series differs slightly from that of the original talk
> > (slide 14 [2]). For the talk, I just cleared the ECN bits, while in
> > this series, I do a bit-shift. This way dscp_t really represents DSCP
> > values, as defined in RFCs. Also I've renamed the helper functions to
> > replace "u8" by "dsfield", as I felt "u8" was ambiguous. Using
> > "dsfield" makes it clear that dscp_t to u8 conversion isn't just a
> > plain cast, but that a bit-shift happens and the result has the two ECN
> > bits.
> 
> I like the names, but why do the bitshift? I get that it's conceptually
> "cleaner", but AFAICT the shifted values are not actually used for
> anything other than being shifted back again? In which case you're just
> adding operations in the fast path for no reason...

That's right, the value is always shifted back again because all
current APIs work with the full dsfield (well all the ones I'm aware of
at least).

I switched to a bit shift when I tried writing down what dscp_t
was representing: I found it a bit clumsy to explain that it actually
wasn't exactly the DSCP. Also I didn't expect the bit shift to have any
mesurable impact.

Anyway, I don't mind reverting to a simple bit mask.

> > The new dscp_t type is then used to convert several field members:
> >
> >   * Patch 1 converts the tclass field of struct fib6_rule. It
> >     effectively forbids the use of ECN bits in the tos/dsfield option
> >     of ip -6 rule. Rules now match packets solely based on their DSCP
> >     bits, so ECN doesn't influence the result anymore. This contrasts
> >     with previous behaviour where all 8 bits of the Traffic Class field
> >     was used. It is believed this change is acceptable as matching ECN
> >     bits wasn't usable for IPv4, so only IPv6-only deployments could be
> >     depending on it (that is, it's unlikely enough that a someone uses
> >     ip6 rules matching ECN bits in production).
> 
> I think this is OK, cf the "break explicitly" thing I wrote above.
> 
> >   * Patch 2 converts the tos field of struct fib4_rule. This one too
> >     effectively forbids defining ECN bits, this time in ip -4 rule.
> >     Before that, setting ECN bit 1 was accepted, while ECN bit 0 was
> >     rejected. But even when accepted, the rule wouldn't match as the
> >     packets would normally have their ECN bits cleared while doing the
> >     rule lookup.
> 
> As above.
> 
> >   * Patch 3 converts the fc_tos field of struct fib_config. This is
> >     like patch 2, but for ip4 routes. Routes using a tos/dsfield option
> >     with any ECN bit set is now rejected. Before this patch, they were
> >     accepted but, as with ip4 rules, these routes couldn't match any
> >     real packet, since callers were supposed to clear their ECN bits
> >     beforehand.
> 
> Didn't work at all, so also fine.
> 
> >   * Patch 4 converts the fa_tos field of struct fib_alias. This one is
> >     pure internal u8 to dscp_t conversion. While patches 1-3 dealed
> >     with user facing consequences, this patch shouldn't have any side
> >     effect and is just there to give an overview of what such
> >     conversion patches will look like. These are quite mechanical, but
> >     imply some code churn.
> 
> This is reasonable, and I think the code churn is worth the extra
> clarity.

Thanks for these feedbacks. These are the main points I wanted to
discuss with this RFC.

> You should probably spell out in the commit message that it's
> not intended to change behaviour, though.

Will do.

> > Note that there's no equivalent of patch 3 for IPv6 (ip route), since
> > the tos/dsfield option is silently ignored for IPv6 routes.
> 
> Shouldn't we just start rejecting them, like for v4?

I had some thoughs about that, but didn't talk about them in the cover
letter since I felt there was already enough edge cases to discuss, and
this one wasn't directly related to this series (the problem is there
regardless of this RFC).

So, on the one hand, we have this old policy of ignoring unknown
netlink attributes, so it looks consistent to also ignore unused
structure fields.

On the other hand, ignoring rtm_tos leads to a different behaviour than
what was requested. So it certainly makes sense to at least warn the
user. But a hard fail may break existing programs that don't clear
rtm_tos by mistake.

I'm not too sure which approach is better.

> -Toke
> 

