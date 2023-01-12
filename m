Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E45667212
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 13:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjALMZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 07:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjALMY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 07:24:58 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8EDE038
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 04:24:57 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-4b6255ce5baso236013117b3.11
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 04:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=To/fWMco7mtSO0rPD0QrnwD0JdcgRwrUmfslM6Z+91g=;
        b=DDSkbz+eeMwqM4VPIXzMbB3hcBrwB0ANARsNDrAWrqlRKZgFZJgUhK3ASmLQRGgacO
         P9NFCr2EdGrGWgKPTM8X2rgWofkkXJPNeKJrtt8q+3P/0eMqkWL+8U7o7E5oqHyB7hUl
         cT1YgL4MfyoEA545i66oQYq7Nej/c1wxfU9R8qmVoq5OkLlSSH3YMRASyHtAAwMIjI+4
         9rOdA6T/p1yQXzvrpf/yuuu0kzvwBfB1xLigUNiKLPiDTYk73z6LQ+Q+xsGwknM60Qbc
         fGIQZ6btM66bC/BytNkxUChatlZDtC94SLAaSPpMm/GVC+0RyHMoVFfc/POaBABNB8Dx
         kd6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=To/fWMco7mtSO0rPD0QrnwD0JdcgRwrUmfslM6Z+91g=;
        b=jDPwchSxK3Fru16nKdbNxJTqKfwaASlJl1/3OeKW9lQP1D5y6gIQ/twG6EZhfRqxok
         eIxDrVBj6BGoNUBd1GAjT/77DF03PH3IbhSLG09RsarcYqgitn32U8vFpSkqkQylUB9t
         BMN0YpREkflO/N3XYordnGdirn13P7sLDpOu1KCB+yuwtSj8uG4ReiQXCgW0J6cyBomK
         BVfiNJbf2nYZRBKIjltEvFjNtQ8LzQsI7TgIqctNwckBXkJcAUAXlVyFyaEeN9BSBxpD
         TKIXoZvarTHuAUFUIUQJ9SIuPJl+MNWDC8FTQoLUlRehPpmZ/YzG+FDdselZqHroIHOW
         23XA==
X-Gm-Message-State: AFqh2krJLxlCbTrOkUbGzlnaUQDqRYHEFyjjrjlShkIoHbr0J/TP4n5w
        L3m1IV9L1fdrA83/s2pY8Jswne9PgE98X7RtgoL8mQ==
X-Google-Smtp-Source: AMrXdXs5RIc9w1pokBK+an7ybeex22O+HdIYu/Os4hrB+/Xs2x3ulD16WMBpR3CZcPOhWzIIP1G1xNMTPwS+xUssoAU=
X-Received: by 2002:a05:690c:a88:b0:4dc:1d4b:620a with SMTP id
 ci8-20020a05690c0a8800b004dc1d4b620amr39212ywb.360.1673526297136; Thu, 12 Jan
 2023 04:24:57 -0800 (PST)
MIME-Version: 1.0
References: <20230112105905.1738-1-paulb@nvidia.com>
In-Reply-To: <20230112105905.1738-1-paulb@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 12 Jan 2023 07:24:45 -0500
Message-ID: <CAM0EoMm046Ur8o6g3FwMCKB-_p246rpqfDYgWnRsuXHBhruDpg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net/sched: cls_api: Support hardware miss to
 tc action
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 5:59 AM Paul Blakey <paulb@nvidia.com> wrote:
>
> Hi,
>
> This series adds support for hardware miss to a specific tc action
> instance on a filter's action list. The mlx5 driver patch (besides
> the refactors) shows its usage instead of using just chain restore.
>
> This miss to action supports partial offload of a filter's action list,
> and and let software continue processing where hardware left off.
>
> Example is the CT action, where new connections need to be handled in
> software. And if there is a packet modifying action before the CT action,
> then restoring only the chain on misses might cause the rule to not
> re-execute the relevant filter in software.
>
> Consider the following scenario:
>
> $ tc filter add dev dev1 ingress chain 0 proto ip flower \
>   ct_state -trk dst_mac fe:50:56:26:13:7d \
>   action pedit ex munge eth dst aa:bb:cc:dd:ee:01 \
>   action ct \
>   action goto chain 1
> $ tc filter add dev dev1 ingress chain 1 proto ip flower \
>   ct_state +trk+est \
>   action mirred egress redirect dev ...
> $ tc filter add dev dev1 ingress chain 1 proto ip flower \
>   ct_state +trk+new \
>   action ct commit \
>   action mirred egress redirect dev dev2
>
> $ tc filter add dev dev2 ingress chain 0 proto ip flower \
>   action ct \
>   action mirred egress redirect dev dev1
>
> A packet doing the pedit in hardware (setting dst_mac to aa:bb:cc:dd:ee:01),
> missing in the ct action, and restarting in chain 0 in software will fail
> matching the original dst_mac in the flower filter on chain 0.


I had to read that a couple of times and didnt get it until i went and
started looking at the patches and i am not 100% sure still.. IIUC, you have
something like:
match X action A action B action C
You do action A in HW and then you want to continue with B and C in SW.
If that is correct then the cover letter would be an easier read if it
is laid out as
follows:

-"consider the following scenario" (with examples you had above)....
Actually those example were not clear, i think the reader is meant to
assume lack of skip_sw means they are available both in hw and sw.

-Explain your goals and why it wont work (I think you did that well above)

-"and now with the changes in this patchset, the issue can be resolved
with rearranging the policy setup as follows"...

Having said that: Would this have been equally achieved with using skbmark?
The advantage is removing the need to change the cls sw datapath.
The HW doesnt have to support skb mark setting, just driver transform.
i.e the driver can keep track of the action mapping and set the mark when
it receives the packet from hw.
You rearrange your rules to use cls fw and have action B and C  match
an skb mark.

> The above scenario is supported in mlx5 driver by reordering the actions
> so ct will be done in hardware before the pedit action, but some packet
> modifications can't be reordered in regards to the ct action. An example
> of that is a modification to the tuple fields (e.g action pedit ex munge ip
> dst 1.1.1.1) since it affects the ct action's result (as it does lookup based
> on ip).

Also above text wasnt clear. It sounded like the driver would magically
know that it has to continue action B and C in s/w because it knows the
hardware wont be able to exec them?

cheers,
jamal
