Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A335F188C
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 03:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiJAB5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 21:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJAB53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 21:57:29 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5BB176AF0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 18:57:28 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id j7so7210086ybb.8
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 18:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=PFBmNdy0U/TqKeQ0bZpsVpQbXV9SVzqdA+rQFLGFeMM=;
        b=BXPXMUdzFsVwKGY3GHH/TNdvb+tYgaECbHcbrW1cW+5GLY4WClsdqk9bMeK+eHLtW4
         RUPS+mf/ET2uF65e+4rpk49UPHex2aQRVdaJlaI6CQhKLPF1Yi+FGQP+LG5xoPoO6f80
         7MYr4cZxmTnRLwrUGx/ZprkMHfrF8ABwLyszi25QLuM0++KTG1bLfN+DZg6YFuxq8EQ5
         R6wPRVFq1B/vRXQu4IL9uJ585CD1nNrox+AD4+fvN7Y9JS9HplvGt7rIzs6IeHtZp7aN
         n+qi8cI4vNR4cRTUHB6B0eFF93YNxyThDW/WM8fQFD+ujpRYAWkuMthpef5R+ndv/pPS
         oeBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=PFBmNdy0U/TqKeQ0bZpsVpQbXV9SVzqdA+rQFLGFeMM=;
        b=Se5TUNuWOmFuZKqAbMZGDqoVV/XsnjFKCqoI4zLbdDXdjkFF9EFqXeVtCLs2shwPsi
         Im32bw/DZPLItMRUajjos88lA58EZy8sdnwy3vQdzEHDZHKdqROJjwHKn/+rDMPe2k+i
         gR1/TyCIpKOZ6NDTCMXTxp5o54akrcPHFvoHX1Xah5PYkGiBAjSJ05+kHl6e+k0aSwfd
         EGLYHZCQq3LYINGBRj/VWAmFuwCqSxku+nJ2IS3baX8PX99pSTComH4UGKlZunuXGi+4
         5oKjwZp3bcn6Fn4Sx9bl+VSYWick2h5rC40PL4Cx34ZUYKaLo652WIPDNouftj9tof3g
         a2mw==
X-Gm-Message-State: ACrzQf3lefZ3yKAk6spx9U7tJmwJ/kKjU5ck5kjhILcwAVkC5yI1kdzu
        nrvF0e65AVCTcpmBWbvpiJLuG1jE+1KWhsC+EUPdMg==
X-Google-Smtp-Source: AMsMyM59phq/c9M4JtZM9CGTKxt4rbHhVxvfXJGAU78vsJDBwsQvZQvykG0xxF2ugipMkKB1bE4glUmRGvCcuHxswe0=
X-Received: by 2002:a25:d103:0:b0:6bc:eae5:9b6d with SMTP id
 i3-20020a25d103000000b006bceae59b6dmr5411835ybg.407.1664589447104; Fri, 30
 Sep 2022 18:57:27 -0700 (PDT)
MIME-Version: 1.0
References: <20221001010039.269004-1-kevmitch@arista.com>
In-Reply-To: <20221001010039.269004-1-kevmitch@arista.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 30 Sep 2022 18:57:15 -0700
Message-ID: <CANn89iKtCjpDyEg3H97=YcvdBypLqTcuOV2Um4Lg7g1p+97PqQ@mail.gmail.com>
Subject: Re: [PATCH] netdevice: don't warn when capping txqueue 0
To:     Kevin Mitchell <kevmitch@arista.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 6:02 PM Kevin Mitchell <kevmitch@arista.com> wrote:
>
> With commit d7dac083414e ("net-sysfs: update the queue counts in the
> unregistration path"), we started seeing the following warning message
> during our stress test that streams packets out of a device while
> registering and unregistering it:
>
> et3_11_1 selects TX queue 0, but real number of TX queues is 0
>
> The issue is that remove_queue_kobjects() is setting real_num_tx_queues
> to 0 before the last few packets are queued. When netdev_cap_txqueue()
> is called to cap queue = 0, it emits this message.
>
> However, when queue == real_num_tx_queues == 0, this message doesn't
> make much sense because 0 is the fallback value returned
> anyway. Therefore, omit the warning when queue is already the fallback
> value of 0.

If there is no TX queue, I do not think we should select queue #0 ?

It seems we should fix the root cause, because
transmit should be prohibited first, then device can 'unregister'.

Something is definitely wrong with a driver, or a layer not properly
observing IFF_UP rules and/or rcu grace periods in device dismantles.


>
> Fixes: d7dac083414e ("net-sysfs: update the queue counts in the unregistration path")
> Link: https://lore.kernel.org/r/YzOjEqBMtF+Ib72v@chmeee/
> Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
> ---
>  include/linux/netdevice.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 05d6f3facd5a..3fd1e50b6bf5 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3493,7 +3493,7 @@ static inline void netdev_reset_queue(struct net_device *dev_queue)
>   */
>  static inline u16 netdev_cap_txqueue(struct net_device *dev, u16 queue_index)
>  {
> -       if (unlikely(queue_index >= dev->real_num_tx_queues)) {
> +       if (unlikely(queue_index > 0 && queue_index >= dev->real_num_tx_queues)) {
>                 net_warn_ratelimited("%s selects TX queue %d, but real number of TX queues is %d\n",
>                                      dev->name, queue_index,
>                                      dev->real_num_tx_queues);
> --
> 2.37.2
>
