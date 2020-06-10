Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C741F58F9
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 18:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbgFJQYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 12:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728789AbgFJQYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 12:24:40 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE97DC03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 09:24:40 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x14so2982759wrp.2
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 09:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vhw/oGxvNGD7lKTQozqoLOGqfX4cCNC+SJwFgjZB/LQ=;
        b=h7e7wkAaxunIsaTo7AirYu5tuyDInw2PEBZQ5SKt/RouZy/1//qDTG+IGgkn5f8+zp
         louUeBvFK6zgN0dp3KVtU+hOfXofYlthrQ0Rspqhcf7Mte7FM2RLTwd03CovE6qnDCYn
         OU/xxnh4n3qlJyW5eAQwBCXxR9nVFUkcVH/kKpT3S+E9Z8u4bN41V0I8EH8o/8HqnkCu
         xKlU/9Y07AUYTFh5evt+UoTxNTsS6uzWdoA/DvPg3NqXUVMtvxE6Ec7vTtGSezCNqolT
         zANwo7r/c526B1LSz3BOL+eNKsu6nEUj1V5Bv7Fawr9abwoDOu+xQUnFFKwmTcN04X8N
         pCZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vhw/oGxvNGD7lKTQozqoLOGqfX4cCNC+SJwFgjZB/LQ=;
        b=ff6LrPPCxMuV4gHoDT1royAZVlJzc2B7kPkCapO8u0RGiYOG23WprDwo2SyQn/ftQh
         76AmAOZiycCUDKdYXn8Vpf8AVUu+ZZptMEmBIY1g+Xjcne8oSpnWwLzBktIrxWRBS6q7
         kJn1AoAMv3OjAH/z8xIUS1Cxzzar3koo2qi+wxc02NfS05PfqqNeG2a4TbZ0GPT2Ppns
         MX1cQ41/PnEz217mM5jPM/FqvRFQwEbSGWPmkVAbenwo2T5aPTvo6Gvq2MUQSv8sCA5m
         P/USiwIQRJozOgZRSzNNS3KrNEOHQaGDLWg0u5phmUuQydSdW2G0A5mf/uHBUaidFTQE
         TVvA==
X-Gm-Message-State: AOAM533PvPfvlJ2PPXFTvBj3lvJ3hwoYbngQrNFr5+XOPNJ6L9ceFSQr
        rXhsaEJ+QHAz4KItCH/+mExcK+fYJmxPrcz6wranL0GZD/w=
X-Google-Smtp-Source: ABdhPJxfjgJXs/bPY/aE8HMQ8QvpZV3IX+2Q+eH6h8D62o/czR+/4yQd66BOFYEkbubh/YInEIqtuuONovWGA7PcSVs=
X-Received: by 2002:adf:a34d:: with SMTP id d13mr4454262wrb.270.1591806279635;
 Wed, 10 Jun 2020 09:24:39 -0700 (PDT)
MIME-Version: 1.0
References: <7478dd2a6b6de5027ca96eaa93adae127e6c5894.1590386017.git.lucien.xin@gmail.com>
 <70458451-6ece-5222-c46f-87c708eee81e@strongswan.org> <CADvbK_cw0yeTdVuNfbc8MJ6+9+1RgnW7XGw1AgQQM7ybnbdaDQ@mail.gmail.com>
 <b93d9e68-c2da-bb1c-e1f9-21c81f740242@strongswan.org>
In-Reply-To: <b93d9e68-c2da-bb1c-e1f9-21c81f740242@strongswan.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 11 Jun 2020 00:32:46 +0800
Message-ID: <CADvbK_egkEe0Pw-Yy8eQggS-cfvndOnj7W2hqvpdNxS2xJ50xg@mail.gmail.com>
Subject: Re: [PATCHv2 ipsec] xfrm: fix a warning in xfrm_policy_insert_list
To:     Tobias Brunner <tobias@strongswan.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Yuehaibing <yuehaibing@huawei.com>,
        Andreas Steffen <andreas.steffen@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 9, 2020 at 10:18 PM Tobias Brunner <tobias@strongswan.org> wrote:
>
> Hi Xin,
>
> >> I guess we could workaround this issue in strongSwan by installing
> >> policies that share the same mark and selector with the same priority,
> >> so only one instance is ever installed in the kernel.  But the inability
> >> to address the exact policy when querying/deleting still looks like a
> >> problem to me in general.
> >>
> > For deleting, yes, but for querying, I think it makes sense not to pass
> > the priority, and always get the policy with the highest priority.
>
> While I agree it's less of a problem (at least for strongSwan),  it
> should be possible to query the exact policy one wants.  Because as far
> as I understand, the whole point of Steffen's original patch was that
> all duplicate policies could get used concurrently, depending on the
> marks and masks on them and the traffic, so all of them must be queryable.
>
> But I actually think the previous check that viewed policies with the
> exact same mark and value as duplicates made sense, because those will
> never be used concurrently.  It would at least fix the default behavior
> with strongSwan (users have to configure marks/masks manually).
>
> > We can separate the deleting path from the querying path when
> > XFRMA_PRIORITY attribute is set.
> >
> > Is that enough for your case to only fix for the policy deleting?
>
> While such an attribute could be part of a solution, it does not fix the
> regression your patch created.  The kernel behavior changed and a
> userland modification is required to get back to something resembling
> the previous behavior (without an additional kernel patch we'll actually
> not be able to restore the previous behavior, where we separated
> different types of policies into priority classes).  That is, current
> and old strongSwan versions could create lots of duplicate/lingering
> policies, which is not good.
>
> A problem with such an attribute is how userland would learn when to use
> it.  We could query the kernel version, but patches might get
> backported.  So how can we know the kernel will create duplicates when
> we update a policy and change the priority, which we then have to delete
> (or even can delete with such a new attribute)?  Do we have to do a
> runtime check (e.g. install two duplicate policies with different
> priorities and delete twice to see if the second attempt results in an
> error)?  With marks it's relatively easy as users have to configure them
> explicitly and they work or they don't depending on the kernel version.
>  But here it's not so easy as the IKE daemon uses priorities extensively
> already.
>
> Like the marks it might work somehow if the new attribute also had to be
> passed in the message that creates a policy (marks have to be passed
> with every message, including querying them).  While that's not super
> ideal as we'd have two priority values in these messages (and have to
> keep track of them in the kernel state), there is some precedent with
> the anti-replay config for SAs (which can be passed via xfrm_usersa_info
> struct or as separate attribute with more options for ESN).  Userland
> would still have to learn somehow that the kernel understands the new
> attribute and duplicate policies with different priorities are possible.
>  But if there was any advantage in using this, we could perhaps later
> add an option for users to enable it.  At least the current behavior
> would not change (i.e. older strongSwan versions would continue to run
> on newer kernels without modifications).
>
Now I can see some about how userland is using "priority". We probably
need to revert both this patch and 7cb8a93968e3 ("xfrm: Allow inserting
policies with matching mark and different priorities").

Thanks for the explanation, I will think more about it tomorrow.
