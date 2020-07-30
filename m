Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5902B232BA4
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 08:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgG3GD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 02:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgG3GD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 02:03:27 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C7CC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 23:03:26 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id z6so27126587iow.6
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 23:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EzK86ogG1LlFSmqELayrfBUVlWwcWPqZP4CsnshoBgw=;
        b=VGeEm2g4fY4eR7xj+A1XVOMxuWNmzVfI7ZLXBKyhWvDNV+gv2vdwjJEf2XQbhzXc+8
         ZD2oweLHGlUysUSUey2/SRXO4twV2WN36Po63ea59YOSdhL326ZXaukZ6eOZuI7AkI7R
         AbsCR8t0HnvEk/SxdF3VWwY+Tlb1CKPhn9WzurlL0/QHFWS2NpHNcfcgtN8iRC3HIiS0
         y0slS1vmGNeyXx/+VbqJB1rjt2+0zPvMr7FhmXsV9WWMwQ+VJGi5yFAJFxDlqmQpkKMC
         bTa0dtzNf03mNgscCz2hB+T+mK/wKMmdXr+cdHAf8ox/vsqzHdIu10S2G4esC67yg+4c
         XPdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EzK86ogG1LlFSmqELayrfBUVlWwcWPqZP4CsnshoBgw=;
        b=R7Ttft+djqs2loVeG8Fs1dNwroUo6ftg+3jITkxRsuhpZXxSipg/XBVa1nmPgH58n0
         j9H927/j31NMseTFq/dqMUhsYm7+cYeuljucH9FEHGvnbFIuc1uNMFGxyzwIR/TVHNFV
         /9N5x77xBy/+0stiNwYVKzB8JxYHVbgNlTeszjDp9NtCjtbiDAFpNWMXCmPlGmCEmh7G
         FhuTK05VZvi47XouVi8Ri85fsL0uiYC2hpxvcJzA1BJZJllVZY32WSqyCOY4XbH6u8+a
         K8NNR5rURrTY8+MVHZZCZHPPGcyrWknk5nED7VbMh6ihi/MKZb2GbEXEULJGxQgPuPwU
         w/5Q==
X-Gm-Message-State: AOAM5304iqLAuU/+shjTBPvvw0zATfxNfY2c4XRVzRTkgJiM9Cs0gcHF
        rQ9oqMkXdDhaSVAPjFKqZGhUnHj/9eMTgyT4C4Vaf9iq
X-Google-Smtp-Source: ABdhPJwhTCUhGHrkc5Jtxc+1U1+SP6Kiu1YQH/JZTM2Avh1L4peJP1hutl2Z3BDvLDupvYprtTAIpYgfEpiL7nOxZC8=
X-Received: by 2002:a6b:be81:: with SMTP id o123mr23565351iof.64.1596089005186;
 Wed, 29 Jul 2020 23:03:25 -0700 (PDT)
MIME-Version: 1.0
References: <1596019270-7437-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1596019270-7437-1-git-send-email-wenxu@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 29 Jul 2020 23:03:13 -0700
Message-ID: <CAM_iQpX89EE+zAc_hR9f=mw1bew5cMVMp1sC7i_fryUjegshnA@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_ct: fix miss set mru for ovs after
 defrag in act_ct
To:     wenxu <wenxu@ucloud.cn>
Cc:     Paul Blakey <paulb@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 3:41 AM <wenxu@ucloud.cn> wrote:
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index c510b03..45401d5 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -384,6 +384,7 @@ struct qdisc_skb_cb {
>         };
>  #define QDISC_CB_PRIV_LEN 20
>         unsigned char           data[QDISC_CB_PRIV_LEN];
> +       u16                     mru;
>  };

Hmm, can you put it in the anonymous struct before 'data'?

We validate this cb size and data size like blow:

static inline void qdisc_cb_private_validate(const struct sk_buff *skb, int sz)
{
        struct qdisc_skb_cb *qcb;

        BUILD_BUG_ON(sizeof(skb->cb) < offsetof(struct qdisc_skb_cb,
data) + sz);
        BUILD_BUG_ON(sizeof(qcb->data) < sz);
}

It _kinda_ expects ->data at the end.

The rest of your patch looks good to me, so feel free to add:
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
