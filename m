Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB874119F5
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 18:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbhITQmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 12:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhITQm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 12:42:29 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D768EC061574;
        Mon, 20 Sep 2021 09:41:02 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id dw14so12399370pjb.1;
        Mon, 20 Sep 2021 09:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KEDmOxfNqSruONAjh4gxVGfQT56fiwIrZ/VuCVq3uWo=;
        b=L6zGIciQNRMq9wW39wDcAe03bwHL2Iri+Yj6wJApKQ6kNbN9+imPRENDyvSsIbYVvz
         eesurN6wbGCqAwfylVK+dpX6ycBr/akzb8hpExftnuM7gQLukjFSat+VsADPTbQfNQfh
         vGwcxasbbBV3r/NE8F8NnJ0kLXGdV132608d+8SwqMITGSuFELFEUEfMFpBtnBgp7xF1
         AZ5lWHz549iN6FuRjNQdPOvSvPvh1ILeFvhiW/g1GJjUUxoqQDNDbBd+1jKNKY+Um6k/
         7m2+ffxIx/RhyIPN9u4YnMrUaZYF2l1djDXtVamLGjMuUVOmch5tyoeMEOXLyDkgS5CQ
         tLyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KEDmOxfNqSruONAjh4gxVGfQT56fiwIrZ/VuCVq3uWo=;
        b=Jsjf0aQeslqdofuNdtuyLdC/MbiZwtthoqUKn+bhtWhFBubropHRmhlVh+47p/sKyC
         z3wZ4N96CQn3LXOtb0ext/ViI/k+e/8DlSqRs4f0UBFp+5i1IqmBKRGIqY6T1eNFRITy
         TFuXCFLg5ZmkxT5lVRAqWsySzf9y33bw7x1u3IjhEsncHD+SjbacpvRYMrbMR562wW1e
         nX+1r50Rxw/tt2WZ+ULNlLTbOIxtswQCiV5aaWg0HoPr4cmCi7qf/pRtahcKx9c1GYpa
         KDTxelWZXT5SEqEdJWeEqeVNqnHA9qefSOyk7VZOIEgp/tBA5T4RSp6gCYqHDqwoOnM0
         Lihw==
X-Gm-Message-State: AOAM530q2iVOP/1vY52lrG1rxDqIeBr9QPgfDWl6ey4QT52BP8Qx242r
        RWg2Zm0reeIh1KJRGboiffOO7seGxTj9f6haYAY=
X-Google-Smtp-Source: ABdhPJwSM68veS6JA03qq2i7rlBNtFtTcJKvEWxTRXpXlRqGU0I34efG7oRdDGS2Sasr9HnbuHvXIsvPhKPxLbML1Oc=
X-Received: by 2002:a17:90b:4d07:: with SMTP id mw7mr37294424pjb.66.1632156062359;
 Mon, 20 Sep 2021 09:41:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210919154337.9243-1-stachecki.tyler@gmail.com>
 <CAM_iQpUeH7sOWRDfaAsER4HdRJQUuODB-ht0NyEZgnCXEmm2RQ@mail.gmail.com> <CAC6wqPVopqP=erynBazgRh2QkB7=Nh-cXxLS2ZvmTzb7E0Gvaw@mail.gmail.com>
In-Reply-To: <CAC6wqPVopqP=erynBazgRh2QkB7=Nh-cXxLS2ZvmTzb7E0Gvaw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 20 Sep 2021 09:40:51 -0700
Message-ID: <CAM_iQpX4hQc3AHgVvfydZ9us0Rt21p5za849z1kgt-sLXSnWTQ@mail.gmail.com>
Subject: Re: [PATCH] ovs: Only clear tstamp when changing namespaces
To:     Tyler Stachecki <stachecki.tyler@gmail.com>
Cc:     fankaixi.li@bytedance.com, xiexiaohui.xxh@bytedance.com,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        dev@openvswitch.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 19, 2021 at 10:44 PM Tyler Stachecki
<stachecki.tyler@gmail.com> wrote:
> Sorry if this is a no-op -- I'm admittedly not familiar with this part
> of the tree.  I had added this check based on this discussion on the
> OVS mailing list:
> https://mail.openvswitch.org/pipermail/ovs-discuss/2021-February/050966.html
>
> The motivation to add it was based on the fact that skb_scrub_packet
> is doing it conditionally as well, but you seem to indicate that
> skb_scrub_packet itself is already being done somewhere?

I mean, skb->tstamp has been cleared when crossing netns,
so: 1) you don't need to clear it again for this case; 2) clearly we
fix other cases with commit 01634047bf0d, so your patch break
it again.

Thanks.
