Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF8F3092D9
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhA3JFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbhA3E5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 23:57:08 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1A5C061788
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 18:00:41 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id hs11so15658892ejc.1
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 18:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cjb1S8yxTaBB/fVXC8WDs/FjomNiJfpzbUqKk+aM37U=;
        b=TECGYmsL/Lax7DccAyXrLjsdnUlxiMlJ+rk4K7pUY7Q+LzdaBzx8AFDzkEgiRKTXQE
         /4iIQuGcVGfPSuDJgr1amA/UwMmyVnbXNi2+wT4TwCi8kMNeWcerStmabwOs11x1zsxy
         jGHJovbMOevGQUUCfRU0reWJdvWNXSUG4baOL1IAcVSJvIOIJGeEU1J7f/R7kiaPmLTA
         XEEKuKz+yCfhOovarJ3rEbml1824HjvqcVVyA16PAcZtqj/74+wCox3uFpvZCHEjbuND
         lOwGGx/CKegAlHk8RidGIZQrKD0UE18Ji/oQY9nkV/nJEjAqyA07K9yLTcXjUX8kxL0n
         3YbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cjb1S8yxTaBB/fVXC8WDs/FjomNiJfpzbUqKk+aM37U=;
        b=cHLtXCdY897i8zD7+iyhH9bNmtM9XrJU7074TAbnkQPsOgNd+QTp2It2jqwXvRkuE+
         MIJ4YGzkb3vt3Widv5bUUvSUZHcbn1JpOvST/40ecDrrP7HC9tAMZncadf1jshop67Tq
         aWs1xya01uY/cbIkFcyiZv5wW8qN0hgNgrZFlq5mqeHMpiCCJQLwGO6jhqA/vA+H8uE3
         wjSorzRZQ5hGfv+X2o/xan+zJ0EbhtXKlK1eQAyJ5wAayiRVKJj9xE/HcrvBDOdNLVQS
         Sai3e8Ix8oWuJyPZCEQqTyqLnxOL5WEOYiI7qnCsrLolOslpSMhEbnzVUv5hpO+0A7uu
         8NtQ==
X-Gm-Message-State: AOAM5308mX+4sro2lnzpMG4dOWr6tMfY3f7P/VeMo4gLh3qfR4l4b2/7
        EzqJo0TO4yajNf1jAu3UGUBbJMHId4bT3SHhgRqXruyo
X-Google-Smtp-Source: ABdhPJx5ERFO6WjhK+97QrHkjsKQgUo5rs2i9SB7PAoJUmaKv9tdmXuuiSVoOu7GWfS7Wk3CKKjEQWqwG5LRPO4LuoY=
X-Received: by 2002:a17:906:3b16:: with SMTP id g22mr7036713ejf.504.1611972040303;
 Fri, 29 Jan 2021 18:00:40 -0800 (PST)
MIME-Version: 1.0
References: <20210128213851.2499012-1-anthony.l.nguyen@intel.com>
 <20210128213851.2499012-5-anthony.l.nguyen@intel.com> <CA+FuTScbEK+1NBUNCbHNnwOoSB0JtsEv3wEisYAbm082P+K0Rw@mail.gmail.com>
 <e27cb35b-a413-ccdd-fa42-d65e7162747f@intel.com>
In-Reply-To: <e27cb35b-a413-ccdd-fa42-d65e7162747f@intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 29 Jan 2021 21:00:02 -0500
Message-ID: <CAF=yD-+XoonTb5yYzDqLGmVyGcT0Jo6=5KoN4okKAkQL5dJ2YA@mail.gmail.com>
Subject: Re: [PATCH net 4/4] i40e: Revert "i40e: don't report link up for a VF
 who hasn't enabled queues"
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        sassmann@redhat.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 7:09 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
>
>
>
> On 1/29/2021 12:23 PM, Willem de Bruijn wrote:
> > On Thu, Jan 28, 2021 at 4:45 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
> >>
> >> From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> >>
> >> This reverts commit 2ad1274fa35ace5c6360762ba48d33b63da2396c
> >>
> >> VF queues were not brought up when PF was brought up after being
> >> downed if the VF driver disabled VFs queues during PF down.
> >> This could happen in some older or external VF driver implementations.
> >> The problem was that PF driver used vf->queues_enabled as a condition
> >> to decide what link-state it would send out which caused the issue.
> >>
> >> Remove the check for vf->queues_enabled in the VF link notify.
> >> Now VF will always be notified of the current link status.
> >> Also remove the queues_enabled member from i40e_vf structure as it is
> >> not used anymore. Otherwise VNF implementation was broken and caused
> >> a link flap.
> >>
> >> Fixes: 2ad1274fa35a ("i40e: don't report link up for a VF who hasn't enabled")
> >> Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> >> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> >> Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
> >> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> >
> > Doesn't this reintroduce the bug that the original patch aimed to solve?
> >
> > Commit 2ad1274fa35a itself was also a fix.
> >
>
> Yea this might re-introduce the issue described in that commit. However
> I believe the bug in question was due to very old versions of VF
> drivers, (including an ancient version of FreeBSD if I recall).
>
> Perhaps there is some better mechanism for handling this, but I think
> reverting this is ok given that it causes problems in certain situations
> where the link status wasn't reported properly.
>
> Maybe there is a solution for both cases? but I would worry less about
> an issue with the incredibly old VFs because we know that the issue is
> fixed in newer VF code and the real problem is that the VF driver is
> incorrectly assuming link up means it is ready to send.
>
> Thus, I am comfortable with this revert: It simplifies the state for
> both the PF and VF.
>
> I would be open to alternatives as long as the issue described here is
> also fixed.
>
> Caveat: I was not involved in the decision to revert this and wasn't
> aware of it until now, so I almost certainly have out of date information.

That's reasonable. The original patch is over three years old.

If it is considered safe to revert now, I would just articulate that
point in the commit.
