Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A61B2422D2
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 01:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgHKXZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 19:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgHKXZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 19:25:56 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7CAC06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 16:25:56 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id j8so659373ioe.9
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 16:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/cL8uvwj6kfaRLurGVWR7nteaAb3l+2id5zyTyaWv5Q=;
        b=Wl7l2llSBC1J2JAXghBkmRkcYI2lB/urkmHOR/5i+ZpbgE7FMcYszgKOfszRyMHrqI
         eMCtJFf2Bk8bNF1NjXpfmvD/6aP06Hgp67kiUrACJDMh4ITOTZVR8Wv4LkgHEK3mUVny
         vWNU/kyBqxAHKOLxyEh+ZK82HxSyTGGFb/ril5mr7KhB5O00dwSZbjtT784FdVx7Lwui
         zDU036BVZzJHeb0DXhPohPzam29oVJFbU3SYxaCS/WAxmDJyCnw5rDDN5VlkR4GD5QAL
         vSIXyIhqs5Z077wgeac+qtGYFoM7C9ok2wN/T1x2OmO7Wa5Jti8rMW4yA67aMPJWBOjF
         TnPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/cL8uvwj6kfaRLurGVWR7nteaAb3l+2id5zyTyaWv5Q=;
        b=j266Nf+UZ0xWChcQHUwzDNHPGiRz52qSSrOXz+qNOKPtwwz4LNaGQ9xgxAdYRVmeE4
         npvlw9UKR+9jhxUkkTU7vtJcwh0zlQp4XcoBHf+2UNDZ8YWRcBdTmxD/cU0Qd1SbKVXO
         hl0FGv+DSTkaGrKm6Dg8jv3u4f41TGImoUp1khloBiNyAf3YYfeJM8CxL7JcZi05gjLC
         WawEuhaC/RX1+O1nd/TAuLiKEVxVGKLLTzPlSRMKE+LbTyVjzSTrGO3XpkexnrfqKdL3
         6NxhtIzPrNSyrD/19kf7/dAqpP19951xifVaYV1aFJaERpK5t4IM7atQgilZMKbMFgAV
         KyOQ==
X-Gm-Message-State: AOAM530TYkeV0XN3F7ImhSG7g/haSDiTptwtyiRsTNyjIU/vMxPJRyPD
        Z72U0ZRBT3ShG2LQ4vrFwHS25pRZvw6Qk/GFkbrgTTti
X-Google-Smtp-Source: ABdhPJwX52gLseffNm0LoJZoePfayO/EOyTErKHiJDsJ1RnOZBArGgPIKqLcg6phWnSvlLl0sGm6X4dLP6Y8yefQY+A=
X-Received: by 2002:a05:6602:1d6:: with SMTP id w22mr9358637iot.64.1597188354122;
 Tue, 11 Aug 2020 16:25:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200807222816.18026-1-jhs@emojatatu.com> <CAM_iQpU6j2TVOu2uYFcFWhBdMj_nu1TuLWfnR3O+2F2CPG+Wzw@mail.gmail.com>
 <3ee54212-7830-8b07-4eed-a0ddc5adecab@mojatatu.com>
In-Reply-To: <3ee54212-7830-8b07-4eed-a0ddc5adecab@mojatatu.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 11 Aug 2020 16:25:43 -0700
Message-ID: <CAM_iQpU6KE4O6L1qAB5MjJGsc-zeQwx6x3HjgmevExaHntMyzA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net/sched: Introduce skb hash classifier
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ariel Levkovich <lariel@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 9, 2020 at 4:41 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> Interesting idea. Note: my experience is that typical setup is
> to have only one of those (from offload perspective). Ariel,
> are your use cases requiring say both fields?
>
>  From policy perspective, i think above will get more complex
> mostly because you have to deal with either mark or hash
> being optional. It also opens doors for more complex matching
> requirements. Example "match mark X AND hash Y" and
> "match mark X OR hash Y".
> The new classifier will have to deal with that semantic.
>
> With fw and hash being the complex/optional semantics are easy:
>
> "match mark X AND hash Y":
> $TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle X
> skbhash flowid 1:12 action continue
> $TC filter add dev $DEV1 parent ffff: protocol ip prio 4 handle Y fw
> flowid 1:12 action ok
>
> "match mark X OR hash Y":
> $TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle X
> skbhash flowid 1:12 action ok
> $TC filter add dev $DEV1 parent ffff: protocol ip prio 4 handle Y fw
> flowid 1:12 action ok

Not sure if I get you correctly, but with a combined implementation
you can do above too, right? Something like:

(AND case)
$TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle 1
skb hash Y mark X flowid 1:12 action ok

(OR case)
$TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle 1
skb hash Y flowid 1:12 action ok
$TC filter add dev $DEV1 parent ffff: protocol ip prio 4 handle 2
skb mark X flowid 1:12 action ok

Side note: you don't have to use handle as the value of hash/mark,
which gives people freedom to choose different handles.


>
> Then the question is how to implement? is it one hash table for
> both or two(one for mark and one for hash), etc.
>

Good question. I am not sure, maybe no hash table at all?
Unless there are a lot of filters, we do not have to organize
them in a hash table, do we?

Thanks.
