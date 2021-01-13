Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42332F536C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbhAMTfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728108AbhAMTfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 14:35:40 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF944C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 11:34:59 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id x20so4451334lfe.12
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 11:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5x9peSoztZZwP3wRwUEonf3kp2KcQ+8lUkdq4yGVsyU=;
        b=dKHEpR8cis9PjPy0+s2wYpOJqK1jNlMC+AYrUDzd55sLM4EjSEbWjXCDMiHPNN4zdh
         2P193WmaFtrb6GOXbsiKGuG1Wloi2abeZNrFAXtpZZhUOExC5T4Y7XhFOH8g2JUDuMnr
         7QJY6Z40GpV8nHxvfUpsZW3+7c7FoTJPu26hvBTPXgk9p7lrw8JYrysx/Pf29BLn4Ty0
         Dpb5apB5yMbdw7ne2ezOVgWBtKfjA9ZjEpVGRlisyGCZ8Cmxlhu2O9RiI/lRFnLeCCOf
         lwBWTa7PnreEl+34r7HT3Tqu5FroOmAPNFcg2K+79LHu/GPJQHjGE8eCdAyPJW+rJsMh
         C7Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5x9peSoztZZwP3wRwUEonf3kp2KcQ+8lUkdq4yGVsyU=;
        b=Ts0GczbxdNI6MQKcQC0N7N8HgnycfVRILevk2Nxxxta3DuA7dJ0xKc4XduC58m+rlI
         yguKi0z/0M4ikH0L57Vo5lRXAkfQF3Y7f8sUhXGMzm5qo+gmwOuIFBs62zUCxbJQTEcu
         ajDP5xrUbJ/IEcuTzBj/a4l72tM687RdVuG66E/yD0z4OuzXp4fyOuntmQ31LYNOVNim
         BG55dbjvkkLQsLVqAynegcgwYP3Xpr4c+f+rurtbHBVic3wVa+JIly/Hhrl8IQs0eRkJ
         Vfavw2FCnwJ+G0ciHCOC0QXylnekKNprQuTxF2Ymed79XjeA6rG9fV49qcII1bbpHoLg
         ZjAA==
X-Gm-Message-State: AOAM531NnKl1lJb+d7VW1DC0jAjyRBw+uSTjT0Z52ENtkyqsnubSbup6
        gJZSDmA/YYUVgqWvYMVSkuXRCappBAtqmnzVDJCTdw==
X-Google-Smtp-Source: ABdhPJzgEk/DkNFqYOJv7Wp3xvz2mFJqsh5LD2B6QlApDjIaztQLZ1/D3AGlb0+PbTDL2rcNBlcg0ARxuR8CLhhhOiY=
X-Received: by 2002:a05:6512:32ad:: with SMTP id q13mr1443000lfe.83.1610566497883;
 Wed, 13 Jan 2021 11:34:57 -0800 (PST)
MIME-Version: 1.0
References: <20210112214105.1440932-1-shakeelb@google.com> <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com> <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
 <20210113184753.GB355124@carbon.dhcp.thefacebook.com>
In-Reply-To: <20210113184753.GB355124@carbon.dhcp.thefacebook.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 13 Jan 2021 11:34:46 -0800
Message-ID: <CALvZod57bG02rP7-Pyb_myssxDeROrU_+L6X9bwrrdEzQTxqYg@mail.gmail.com>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
To:     Roman Gushchin <guro@fb.com>
Cc:     Arjun Roy <arjunroy@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 10:48 AM Roman Gushchin <guro@fb.com> wrote:
>
[snip]
> > > Does it mean that a page can be accounted twice (even temporarily)?
> > >
> >
> > This was an actual consideration for this patchset that we went back
> > and forth on a little bit.
> > Short answer, for this patch in its current form: yes. We're calling
> > mem_cgroup_charge_sock_pages() immediately prior to vm_insert_pages();
> > and the skb isn't cleaned up until afterwards. Thus we have a period
> > of double charging.
> >
> > The pseudocode for the approach in this patch is:
> >
> > while skb = next skb in queue is not null:
> >     charge_skb_pages(skb.pages) // sets page.memcg for each page
> >     // at this point pages are double counted
> >     vm_insert_pages(skb.pages)
> >     free(skb) // unrefs the pages, no longer double counted
> >
> > An alternative version of this patch went the other way: have a short
> > period of undercharging.
> >
> > while skb = next skb in queue is not null:
> >     for page in skb.pages set page.memcg
> >     vm_insert_pages(skb.pages)
> >     free(skb) // unrefs the pages. pages are now undercounted
> > charge_skb_pages(nr_pages_mapped, FORCE_CHARGE) // count is now correct again
> > ret
>
> I have to think more, but at the first look the second approach is better.
> IMO forcing the charge is less of a problem than double accounting
> (we're forcing sock memory charging anyway). I'm afraid that even if the
> double counting is temporarily for each individual page, with a constant
> traffic it will create a permanent difference.
>

The double accounting behavior is a bit different in cgroup v1 vs v2
world as skmem is accounted in memory for v2 and a separate tcp
counter for v1. I am fine with either approaches mentioned by Arjun
but I would prefer to not add complexity by doing one approach for v1
and the other for v2.
