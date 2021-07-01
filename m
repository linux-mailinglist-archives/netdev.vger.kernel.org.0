Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401043B97D0
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 22:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbhGAU5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 16:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbhGAU5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 16:57:03 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E29C061762;
        Thu,  1 Jul 2021 13:54:31 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e20so7383018pgg.0;
        Thu, 01 Jul 2021 13:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bejbpdzWWOIMJGxxaqncK4cvXUou7+0QN70+h87YgDs=;
        b=FlbdvNwkRM83irrFusIbAD3vMHujJ0igoZqXNyK1JXmd9EV4cPCbV4nNcFArau7k54
         ES4K2Ws3jtF0VUbsQefwJQ4KaeC3OWB010uwffflmnpjh9dZ060nav9OdKDePMIRq6ao
         moSESHAdDaK9lrB7rSF4E5PNIYRo2VnIquUHpxlWBCik1myVCVLgQFnh0saHPILs7BEP
         VV6x4GpIuY35G/cweGO/5ze0H5CGOuMkLaM5UNGaB0EtT9HR4c4h9VjpCce3nKyWODDj
         QP7x4Kriu0VD138elHi92qymPvQWV5e/o+glHgX+KaKdF7XBpQ2CwRQTKa0aK2C81D0m
         vvDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bejbpdzWWOIMJGxxaqncK4cvXUou7+0QN70+h87YgDs=;
        b=PB54J3dDMiETSHxQilG3uN/WfJwQx7uyHQU5um3zqDf6FxVudfJXx/AH9nlatyYWws
         mtXpsRCnWaL06N9QxFUBRik+BqlkgrAOlwZSxVeTqoofcfhMGoE04pkRPb2gcZRDNkP5
         HD19vV2/5INHGxB1PUhuipReVyo6j2MYKdZ1VHpMLwWF7JNAn6q/+qHL8Egtee2ovZ+7
         g7lnfSCPe8pTnfszbJ9MbvsJdMDDoYIDOp+neAG4CB+yVnaxJtWZnmZXKRhOeXDeBDcI
         CjgNMrnTPRdvn1GhG7V4CQu3L7iz9mX+0narq/1aGBktsQ8urKMU7FnDhvGbSusJJSlS
         WgeQ==
X-Gm-Message-State: AOAM532QpRvqOUWX8xEkqLRRVWW+rA9cXpvQvJ+grTmD0Y3kV2AiIK6P
        5buI4/IcxH8OH0/gsCAAqegkZSA4T0gzOB2ijFAJZvOc
X-Google-Smtp-Source: ABdhPJyPDlB+L3xy8R1qK6DR4obf/aFfKpiGOTeiTfYmOZlcnhsLr0IMAu0f5D4dvailNq75gWnkh4z2BtwXUEEK+QA=
X-Received: by 2002:a63:f65:: with SMTP id 37mr1393805pgp.367.1625172871084;
 Thu, 01 Jul 2021 13:54:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAHQn7pKcyC_jYmGyTcPCdk9xxATwW5QPNph=bsZV8d-HPwNsyA@mail.gmail.com>
 <a7f11cc2-7bef-4727-91b7-b51da218d2ee@nbd.name> <YNtdKb+2j02fxfJl@kroah.com> <872e3ea6-bbdf-f67c-58f9-4c2dafc2023a@nbd.name>
In-Reply-To: <872e3ea6-bbdf-f67c-58f9-4c2dafc2023a@nbd.name>
From:   Davis Mosenkovs <davikovs@gmail.com>
Date:   Thu, 1 Jul 2021 23:54:19 +0300
Message-ID: <CAHQn7pJY4Vv_eWpeCvuH_C6SHwAvKrSE2cQ=cTir72Ffcr9VXg@mail.gmail.com>
Subject: Re: Posible memory corruption from "mac80211: do not accept/forward
 invalid EAPOL frames"
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-30 at 21:01 Felix Fietkau (<nbd@nbd.name>) wrote:
>
> On 2021-06-29 19:49, Greg Kroah-Hartman wrote:
> > On Tue, Jun 29, 2021 at 07:26:03PM +0200, Felix Fietkau wrote:
> >>
> >> Hi,
> >>
> >> On 2021-06-29 06:48, Davis wrote:
> >> > Greetings!
> >> >
> >> > Could it be possible that
> >> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.12.13&id=a8c4d76a8dd4fb9666fc8919a703d85fb8f44ed8
> >> > or at least its backport to 4.4 has the potential for memory
> >> > corruption due to incorrect pointer calculation?
> >> > Shouldn't the line:
> >> >   struct ethhdr *ehdr = (void *)skb_mac_header(skb);
> >> > be:
> >> >   struct ethhdr *ehdr = (struct ethhdr *) skb->data;
> >> >
> >> > Later ehdr->h_dest is referenced, read and (when not equal to expected
> >> > value) written:
> >> >   if (unlikely(skb->protocol == sdata->control_port_protocol &&
> >> >       !ether_addr_equal(ehdr->h_dest, sdata->vif.addr)))
> >> >     ether_addr_copy(ehdr->h_dest, sdata->vif.addr);
> >> >
> >> > In my case after cherry-picking
> >> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.4.273&id=e3d4030498c304d7c36bccc6acdedacf55402387
> >> > to 4.4 kernel of an ARM device occasional memory corruption was observed.
> >> >
> >> > To investigate this issue logging was added - the pointer calculation
> >> > was expressed as:
> >> >   struct ethhdr *ehdr = (void *)skb_mac_header(skb);
> >> >   struct ethhdr *ehdr2 = (struct ethhdr *) skb->data;
> >> > and memory writing was replaced by logging:
> >> >   if (unlikely(skb->protocol == sdata->control_port_protocol &&
> >> >       (!ether_addr_equal(ehdr->h_dest, sdata->vif.addr) ||
> >> > !ether_addr_equal(ehdr2->h_dest, sdata->vif.addr))))
> >> >     printk(KERN_ERR "Matching1: %u, matching2: %u, addr1: %px, addr2:
> >> > %px", !ether_addr_equal(ehdr->h_dest, sdata->vif.addr),
> >> > !ether_addr_equal(ehdr2->h_dest, sdata->vif.addr), ehdr->h_dest,
> >> > ehdr2->h_dest);
> >> >
> >> > During normal use of wifi (in residential environment) logging was
> >> > triggered several times, in all cases matching1 was 1 and matching2
> >> > was 0.
> >> > This makes me think that normal control frames were received and
> >> > correctly validated by !ether_addr_equal(ehdr2->h_dest,
> >> > sdata->vif.addr), however !ether_addr_equal(ehdr->h_dest,
> >> > sdata->vif.addr) was checking incorrect buffer and identified the
> >> > frames as malformed/correctable.
> >> > This also explains memory corruption - offset difference between both
> >> > buffers (addr1 and addr2) was close to 64 KB in all cases, virtually
> >> > always a random memory location (around 64 KB away from the correct
> >> > buffer) will belong to something else, will have a value that differs
> >> > from the expected MAC address and will get overwritten by the
> >> > cherry-picked code.
> >> It seems that the 4.4 backport is broken. The problem is the fact that
> >> skb_mac_header is called before eth_type_trans(). This means that the
> >> mac header offset still has the default value of (u16)-1, resulting in
> >> the 64 KB memory offset that you observed.
> >>
> >> I think that for 4.4, the code should be changed to use skb->data
> >> instead of skb_mac_header. 4.9 looks broken in the same way.
> >> 5.4 seems fine, so newer kernels should be fine as well.
> >
> > Thanks for looking into this, can you submit a patch to fix this up in
> > the older kernel trees?
> Sorry, I don't have time to prepare and test the patches at the moment.
>
> - Felix
If testing procedure mentioned in my first email is sufficient (and
using skb->data is the correct solution in kernel trees where current
code doesn't work properly), I can make and test the patches.
Should I do that?

Br,
Davis
