Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95FF557E75
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 17:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiFWPKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 11:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiFWPKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 11:10:45 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F21C338B0
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 08:10:45 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id l24-20020a0568301d7800b0060c1ebc6438so15551026oti.9
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 08:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MeIF0ua+sHLHmItoHlkzTHYVdM1X4IcU8V21KxlP9JU=;
        b=Kac9361bMCWasikS/s6+IP6C0Rrb4HbQL+S4L3QR/A/TYsWrXU3Rfy50D0Z6gma8BH
         vK/1CmUi5XvNHZa8imgQywiBOMRkPNIOdr7G/boZrSUs4XWCb44zonI9wpjSjAv0vBaO
         Gp8Vt+gVRT5WBmLKEfjelBcnk9KPAgGB+51tw9flC3wsD5/S5mpFJd87DDtYzlrfTbG+
         2RXrGTC0rXJFHn8lrrInuYBA1OLVrSt4cc0eR62+/f6llIfbGZl87m7468cOpIujYQSD
         ssxgwHUZsaLtkDC938GkBUcTgAn5HcH4Ce0dmal8RLx6K/PlarjSOX4d2lM5s0Laxmb4
         WcXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MeIF0ua+sHLHmItoHlkzTHYVdM1X4IcU8V21KxlP9JU=;
        b=pv7iQKV/pQ27yStw/i6qwAxAhS2Rqpxh3MW4TBJLbpzrHvCnrTB2M62TLOnVNsVSAq
         bZHQ4xRdtGjDVmEnoR8pGmUKW07BNtdOe0TuJ8Uh+feRXHL5tyE31xTo9yvsGGdnWlcV
         zQ09oT774Uaa/6CpQQXJMhWej5mRzUTHlp2eBn40jwuLClTEgaU/+45u7r4GkuJdIzwQ
         pbdeap42tAFrdX2v8JaYaeKZlWcK4ss0D2pcEFJsD7o52XfIpqNsTQE+OY0atPQiV/Dz
         km35fZ03L12HTPFUdyE+/B3w0yfM9G9kim5pZMGJpocHARld+FDbEW/vU4jf/Wm46BuA
         Rt8w==
X-Gm-Message-State: AJIora8HK4vB87j+KChUkmAHlku6CHZUb4O4HZNG2sQzVuCIkxW21JcG
        UvnsY9NWBVQyxLEZGnWOTtcm8tCFbpX1subKupKeHsgVGOc=
X-Google-Smtp-Source: AGRyM1s4EF3qsFebQzd1g17/w+dPO+nY+TRZ7OVWbif1V8K0dPxpeQLzuDuLMn8ur+6qx/syJHjySlqzMOe9gDuBXW8=
X-Received: by 2002:a9d:554e:0:b0:60c:264c:f306 with SMTP id
 h14-20020a9d554e000000b0060c264cf306mr4140364oti.223.1655997044286; Thu, 23
 Jun 2022 08:10:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220623140742.684043-1-victor@mojatatu.com> <20220623140742.684043-2-victor@mojatatu.com>
In-Reply-To: <20220623140742.684043-2-victor@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 23 Jun 2022 11:10:33 -0400
Message-ID: <CAM0EoMmpP2V75BXZa0_-jKFARumoT4R_6p3_Bk0T90kNnxrVxg@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net/sched: act_api: Notify user space if any
 actions were flushed before error
To:     Victor Nogueira <victor@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 10:08 AM Victor Nogueira <victor@mojatatu.com> wrote:
>
> If during an action flush operation one of the actions is still being
> referenced, the flush operation is aborted and the kernel returns to
> user space with an error. However, if the kernel was able to flush, for
> example, 3 actions and failed on the fourth, the kernel will not notify
> user space that it deleted 3 actions before failing.
>
> This patch fixes that behaviour by notifying user space of how many
> actions were deleted before flush failed and by setting extack with a
> message describing what happened.
>
> Fixes: 55334a5db5cd ("net_sched: act: refuse to remove bound action outside")
>
> Signed-off-by: Victor Nogueira <victor@mojatatu.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
