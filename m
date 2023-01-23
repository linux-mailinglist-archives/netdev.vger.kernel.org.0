Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D148F678694
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbjAWTlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbjAWTlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:41:17 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1920822DD9
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:41:16 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-4c131bede4bso187279147b3.5
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l4HNc2f2/MMS1lVgaLJfy0lWDOuaeooy9YHRuCd1zTU=;
        b=2dmzyEQiF3GjTSUPJ8hCXNYl1O32197q0MJjkDgMHCNwdJcSOMGezq8jomcrENLQf5
         sWsc/6k0lgx1M49R9Lr0NC1nS6nMV3liLo0Lsag1WplrtAycrk8XvWVKaI6NTR3ZgjLx
         tXZU0LF2e4MemfEE+kFzK9Nr8A80Ku1rrHllLV0m1RE3fzRx+xct3gML0fPi6ZM/T28e
         dgCbHOEBUyV9gNzMCiHOr6KDUT/pq4gCavnKKGm6I6JGiqpWn8KJoXl4sg4Y5n0guWBE
         nd0Siq5584Sge28P7R09RSf6vyVrImtAeuxcFS4NL+HmP6TJeLhU+EngDFGJYtBeG5A/
         0X3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l4HNc2f2/MMS1lVgaLJfy0lWDOuaeooy9YHRuCd1zTU=;
        b=fh7WlCe4YD0q3V84xzKCVEwnEmwklpQqRVDy09DvTD44Mx2+VcZ3c7WDsV4vlmqfoz
         pVSMlMrnNxuIbADyNwlbvCKdQ/tX+Mg2bpPjs5sjpatvgWVuO27bSFWtsKkEIuQCL5ed
         x3MO6SU5pX31cSESWO6P7vs4N4GI0H09mzHl9KuUqbNT8Bxo5B1cMCDmGRTvme9cdrmu
         OTgDFRYXs7SYDG7ivQ3WQfiM/wM3e3vHKOa4JRyRrBHIsniU+ajcfu0SQbWvoAhhSOVF
         dkHARjRszd0WFp4eK4IB90zR2D01UjuvbCqwF0Hxv2k44FcaYInKu5zzAKqAKj4/dNBh
         IudA==
X-Gm-Message-State: AFqh2kqJLs+PQwJE78CajPNk/PUJCDH2fReJ5HtWKjK3P7ICksziCM8L
        5ZTKAWjwPl6GSj5f5i7PmJbQXR+yEYW7LS50AkPeZw==
X-Google-Smtp-Source: AMrXdXt24Wo2WUvyxzQWxKOmWuqhOTR/4F7hZ1hGb7srKLM6rBPUuFvOGBT8WdWmp/SSdueXbZvE6ilGmzUBbgHXxlk=
X-Received: by 2002:a81:7c88:0:b0:4eb:2b95:a29e with SMTP id
 x130-20020a817c88000000b004eb2b95a29emr3088202ywc.241.1674502875335; Mon, 23
 Jan 2023 11:41:15 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674233458.git.dcaratti@redhat.com> <5fdd584d53f0807f743c07b1c0381cf5649495cd.1674233458.git.dcaratti@redhat.com>
 <Y87CY5aQwZAcVU1A@t14s.localdomain>
In-Reply-To: <Y87CY5aQwZAcVU1A@t14s.localdomain>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 23 Jan 2023 14:41:04 -0500
Message-ID: <CAM0EoMm-noMkXrbrP+ioDxd6HRMZNgLTqs7EV=CH104=d1WLpg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] act_mirred: use the backlog for nested calls
 to mirred ingress
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Davide Caratti <dcaratti@redhat.com>, jiri@resnulli.us,
        lucien.xin@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com,
        wizhao@redhat.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 12:22 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Fri, Jan 20, 2023 at 06:01:40PM +0100, Davide Caratti wrote:
> > William reports kernel soft-lockups on some OVS topologies when TC mirred
> > egress->ingress action is hit by local TCP traffic [1].
> > The same can also be reproduced with SCTP (thanks Xin for verifying), when
> > client and server reach themselves through mirred egress to ingress, and
> > one of the two peers sends a "heartbeat" packet (from within a timer).
> >
> > Enqueueing to backlog proved to fix this soft lockup; however, as Cong
> > noticed [2], we should preserve - when possible - the current mirred
> > behavior that counts as "overlimits" any eventual packet drop subsequent to
> > the mirred forwarding action [3]. A compromise solution might use the
> > backlog only when tcf_mirred_act() has a nest level greater than one:
> > change tcf_mirred_forward() accordingly.
> >
> > Also, add a kselftest that can reproduce the lockup and verifies TC mirred
> > ability to account for further packet drops after TC mirred egress->ingress
> > (when the nest level is 1).
> >
> >  [1] https://lore.kernel.org/netdev/33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com/
> >  [2] https://lore.kernel.org/netdev/Y0w%2FWWY60gqrtGLp@pop-os.localdomain/
> >  [3] such behavior is not guaranteed: for example, if RPS or skb RX
> >      timestamping is enabled on the mirred target device, the kernel
> >      can defer receiving the skb and return NET_RX_SUCCESS inside
> >      tcf_mirred_forward().
> >
> > Reported-by: William Zhao <wizhao@redhat.com>
> > CC: Xin Long <lucien.xin@gmail.com>
> > Signed-off-by: Davide Caratti <dcaratti@redhat.com>
>
> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
