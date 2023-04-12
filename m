Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A726DE88D
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 02:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjDLAlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 20:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDLAlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 20:41:35 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3D6269F
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 17:41:34 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o2-20020a17090a0a0200b00246da660bd2so2913312pjo.0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 17:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1681260093; x=1683852093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkqCicjx+smQyHGqjeONsCB7LILWCSvWQoUWdPfQHok=;
        b=xQ8LQU6kMNLscom96aiQD1J2xzd6Z71lGdShn954buKhBLeTmsl42i4kvOuncF/irr
         xq+SBVKT3kQWCyU85FgXF7styHJ+fLtKfO5PRQTHOyrGIJcrUFuWQrLMY5njy8aMsKXz
         GrrPJoZK85IKeVSQf1/5PoCaDbJRY3wELTgAx5o8q5Wad/xdf9hlpQe0wK5r+96BOPpH
         mUQgasZh/TMUJle8qhhukcUH3DlBB+1lbZiz0LmPuCcqXlkIWtoxSPJmp04ag5mnbHxh
         FdDQ8/votLWaHWnBc9Qh2tH5U1cLmZazZZYn8gsJuetkz7ZtwLZYAxwCCEsxJAtLA76X
         p4wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681260093; x=1683852093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pkqCicjx+smQyHGqjeONsCB7LILWCSvWQoUWdPfQHok=;
        b=PmFyl5ZhpvMPPxPGAdHZuhdInm3BNipqvUPWgLfoZdN05hi45D50FoIvt+oMhIn0RK
         VVX7xjDuGnd7PGhkyYsLQHh3/JY1QGxf8P73kgfDwepJB3AH4rNXJYN1B/jpbek7JrLY
         2wzIMjXAX5oB0Nq9ayAYpIKLLLVXYjYk5kIGHtY7/oPVl/DwwoFcnvu+aqq4sLEgxfcg
         EldJPDNKBwjFL91AS5OioB41OFeZPHBE2WsdMkLXEHRVlK3sCswUGsr74fesPnRQQcol
         DOZz0u/Jdbi4r+sEIjaEMGF5d/jzAQQJ49UIWyY2Fg6zNFGYdefnPKiEqHAMrEzGw6UB
         pFQQ==
X-Gm-Message-State: AAQBX9ctM3CwJUNlreqnEopLRBWbu8wTv1pMVVNp0wkR/v/hjiAt3gZX
        M+XvxeJQ3GAT+Gi62JxVJcCZ0g==
X-Google-Smtp-Source: AKy350bIL2yfrlVq2FOEL9kyVSkMELIKC/zeO80Jb3FFy1+wncCpDU/aSU9hqKlj0VlKAeIFlKbAPA==
X-Received: by 2002:a17:902:f394:b0:1a5:2da5:b1f9 with SMTP id f20-20020a170902f39400b001a52da5b1f9mr891046ple.26.1681260093492;
        Tue, 11 Apr 2023 17:41:33 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id iw22-20020a170903045600b001a1add0d616sm7550889plb.161.2023.04.11.17.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 17:41:33 -0700 (PDT)
Date:   Tue, 11 Apr 2023 17:41:31 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andy Roulin <aroulin@nvidia.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>, netdev@vger.kernel.org
Subject: Re: neighbour netlink notifications delivered in wrong order
Message-ID: <20230411174131.634e35d3@hermes.local>
In-Reply-To: <78825e0b-d157-5b26-4263-8fd367d2fb2c@nvidia.com>
References: <20220606230107.D70B55EC0B30@us226.sjc.aristanetworks.com>
        <ed6768c1-80b8-aee2-e545-b51661d49336@nvidia.com>
        <20220606201910.2da95056@hermes.local>
        <CA+HUmGidY4BwEJ0_ArRRUKY7BkERsKomYnOwjPEayNUaS8wv=w@mail.gmail.com>
        <20220607103218.532ff62c@hermes.local>
        <CA+HUmGjmq4bMOEg50nQYHN_R49aEJSofxUhpLbY+LG7vK2fUdw@mail.gmail.com>
        <78825e0b-d157-5b26-4263-8fd367d2fb2c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jun 2022 20:49:40 -0700
Andy Roulin <aroulin@nvidia.com> wrote:

> On 6/7/22 1:03 PM, Francesco Ruggeri wrote:
> > On Tue, Jun 7, 2022 at 10:32 AM Stephen Hemminger
> > <stephen@networkplumber.org> wrote:  
> >>
> >> On Tue, 7 Jun 2022 09:29:45 -0700
> >> Francesco Ruggeri <fruggeri@arista.com> wrote:
> >>  
> >>> On Mon, Jun 6, 2022 at 8:19 PM Stephen Hemminger
> >>> <stephen@networkplumber.org> wrote:  
> >>>>
> >>>> On Mon, 6 Jun 2022 19:07:04 -0700
> >>>> Andy Roulin <aroulin@nvidia.com> wrote:
> >>>>  
> >>>>> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> >>>>> index 54625287ee5b..a91dfcbfc01c 100644
> >>>>> --- a/net/core/neighbour.c
> >>>>> +++ b/net/core/neighbour.c
> >>>>> @@ -2531,23 +2531,19 @@ static int neigh_fill_info(struct sk_buff *skb,
> >>>>> struct neighbour *neigh,
> >>>>>        if (nla_put(skb, NDA_DST, neigh->tbl->key_len, neigh->primary_key))
> >>>>>                goto nla_put_failure;
> >>>>>
> >>>>> -     read_lock_bh(&neigh->lock);
> >>>>>        ndm->ndm_state   = neigh->nud_state;  
> >>>>
> >>>> Accessing neighbor state outside of lock is not safe.
> >>>>
> >>>> But you should be able to use RCU here??  
> >>>
> >>> I think the patch removes the lock from neigh_fill_info but it then uses it
> >>> to protect all calls to neigh_fill_info, so the access should still be safe.
> >>> In case of __neigh_notify the lock also extends to protect rtnl_notify,
> >>> guaranteeing that the state cannot be changed while the notification
> >>> is in progress (I assume all state changes are protected by the same lock).
> >>> Andy, is that the idea?  
> 
> Yes correct.
> 
> >>
> >> Neigh info is already protected by RCU, is per neighbour reader/writer lock
> >> still needed at all?  
> > 
> > The goal of the patch seems to be to make changing a neighbour's state and
> > delivering the corresponding notification atomic, in order to prevent
> > reordering of notifications. It uses the existing lock to do so.
> > Can reordering be prevented if the lock is replaced with rcu?  
> 
> Yes that's the goal of the patch. I'd have to look in more details if 
> there's a better solution with RCU.

But the patch would update ndm->ndm_state based on neigh, but there
is nothing ensuring that neigh is not going to be deleted or modified.
