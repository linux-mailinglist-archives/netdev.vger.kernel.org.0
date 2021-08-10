Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC1C3E506E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 02:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236578AbhHJAvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 20:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbhHJAvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 20:51:44 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75A3C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 17:51:22 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id w5so8078222ejq.2
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 17:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tC+2pL7A0XZKlDAYl8kABHtI+EfJPJSK4RgvovU5ZXU=;
        b=dPdY7o/eAn/dJvjg/ik5koe9J/sb+x0tHa8MttQU7RP0pSQMabq1vAgQoRqxjJOHVG
         bJwoTyBkeRhWKbIs38sW2bJZ6IEyHePxqv0jeT1PJPJ3ucAnmQ8uADCehrAKtxq4Ueob
         vpFZCtyuoYPTmAAqL6cl14FGEolo2sm/qYzVxUT9uYIe0sf0EzHiv+3PgvhlrM9fNLJx
         EplB1w2XFLlHPI7WYX4QEDSb0XsGsBbtSMCRYrfAkw8iXK+adr0hdLNIYOXrKWVFVXGJ
         Cc2uewm6ASUIWSKhpYZEv3f+cc0uC9UtyXIarK/lRDDuobuH472F02AeT5UTL2yKrOxe
         IpOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tC+2pL7A0XZKlDAYl8kABHtI+EfJPJSK4RgvovU5ZXU=;
        b=pGh+UEoA26zwCKagq0s+F+cihyMFu6Nm82McLHy6OuMTy1Vsot8xAEllqP/x+ExTib
         DIPGDSyeCGsEwU3J57TtVk8Rj2GHPyFne0eHCloP5JeeBiK4zqNDp7KE8rq/+XOwIdc+
         ITj5iBs6VAdPNtl6EW/Z62cYDKJcYe6zvwxIPvl5/DWC8r/L1uNJgQ2L5RDXzmM/FlWd
         TWrZ1Txf+rLwRzu58j4bx244q+VtC+I8Td7Dl+naaBKXRR4gG+9dy8M1oiHgksYpWGaP
         hxu2kXNzFYMsydVUWMdgfhPhIcTrsipsvNWwzF786l44cJjyAT2yrZZ6qlSkf3p9nfE5
         msyA==
X-Gm-Message-State: AOAM530BFBNZ+WnFu+RByeDYCN5v7/BMTWhf++GxE/docE90cDc1YvEL
        3CT3pGwMBb8c8P1MlJfLYPj1vpJGiWU21AdT65s=
X-Google-Smtp-Source: ABdhPJzZK1i49osT6agtr9RuNSos0hMUVvzcubqimrT6eUej3bLXSsLTMtvn6ijRNJS+NWUtpgAgxS8fCQF5+R6G6Ww=
X-Received: by 2002:a17:907:1c9f:: with SMTP id nb31mr25964781ejc.114.1628556681488;
 Mon, 09 Aug 2021 17:51:21 -0700 (PDT)
MIME-Version: 1.0
References: <162855246915.98025.18251604658503765863.stgit@anambiarhost.jf.intel.com>
In-Reply-To: <162855246915.98025.18251604658503765863.stgit@anambiarhost.jf.intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 9 Aug 2021 17:51:10 -0700
Message-ID: <CAKgT0UfMqqSjF80VYNcax4Yer2F2u9f_cbm3DSLtdhz_JzWH-A@mail.gmail.com>
Subject: Re: [net-next PATCH] net: act_skbedit: Fix tc action skbedit queue_mapping
To:     Amritha Nambiar <amritha.nambiar@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 9, 2021 at 4:36 PM Amritha Nambiar
<amritha.nambiar@intel.com> wrote:
>
> For skbedit action queue_mapping to select the transmit queue,
> queue_mapping takes the value N for tx-N (where N is the actual
> queue number). However, current behavior is the following:
> 1. Queue selection is off by 1, tx queue N-1 is selected for
>    action skbedit queue_mapping N. (If the general syntax for queue
>    index is 1 based, i.e., action skbedit queue_mapping N would
>    transmit to tx queue N-1, where N >=1, then the last queue cannot
>    be used for transmit as this fails the upper bound check.)
> 2. Transmit to first queue of TCs other than TC0 selects the
>    next queue.
> 3. It is not possible to transmit to the first queue (tx-0) as
>    this fails the bounds check, in this case the fallback
>    mechanism for hash calculation is used.
>
> Fix the call to skb_set_queue_mapping(), the code retrieving the
> transmit queue uses skb_get_rx_queue() which subtracts the queue
> index by 1. This makes it so that "action skbedit queue_mapping N"
> will transmit to tx-N (including the first and last queue).
>
> Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> ---
>  net/sched/act_skbedit.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
> index e5f3fb8b00e3..a7bba15c74c4 100644
> --- a/net/sched/act_skbedit.c
> +++ b/net/sched/act_skbedit.c
> @@ -59,7 +59,7 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
>         }
>         if (params->flags & SKBEDIT_F_QUEUE_MAPPING &&
>             skb->dev->real_num_tx_queues > params->queue_mapping)
> -               skb_set_queue_mapping(skb, params->queue_mapping);
> +               skb_set_queue_mapping(skb, params->queue_mapping + 1);
>         if (params->flags & SKBEDIT_F_MARK) {
>                 skb->mark &= ~params->mask;
>                 skb->mark |= params->mark & params->mask;
>

I don't think this is correct. It is conflating the rx_queue_mapping
versus the Tx queue mapping. This is supposed to be setting the Tx
queue mapping which applies after we have dropped the Rx queue
mapping, not before. Specifically this is run at the qdisc enqueue
stage with a single locked qdisc, after netdev_pick_tx and skb_tx_hash
have already run. It is something that existed before mq and is meant
to work with the mutliq qdisc.

If you are wanting to add a seperate override to add support for
programming the Rx queue mapping you may want to submit that as a
different patch rather than trying to change the existing Tx queue
mapping feature. Either that or you would need to change this so that
it has a different behavior depending on where the hook is added since
the behavior would be different if this is called before skb_tx_hash.
