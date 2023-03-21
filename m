Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145E26C27DB
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 03:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjCUCJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 22:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCUCJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 22:09:18 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE5D2B9E8;
        Mon, 20 Mar 2023 19:09:17 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id w9so54213447edc.3;
        Mon, 20 Mar 2023 19:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679364555;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rr/1PDkNgTI90sPUyrW/8K8Ga9e5P5xxGwc4p7uGABk=;
        b=AcCB8D4PCETXJDvcdKsoQR/sSksk1/nOG0UYsDKsyXrVTFWO7AjlbJS+i3L39D3fQ9
         Rba+sftdYGdv9VtESqfEp30a53Og9tdImABHtN41i/ezHFkuwrTqbS5K6iJ+5xrCYdtl
         UjaLelfjE0rGiND0796enjBdrxOb0BP75LlvIfct/6XSGm2BBnx2NZ7lLLuNvx9DZr+w
         E4ajt8/GyZhLiKsWRjUeYeYwCr7yc3YvNGvrTccLxGdGGJC7Ehhv1l3l6Y6bOwU/bU5G
         WN3M+rIwAeomWKzAra9p4xu/pgqxR4tSOEFBRssVl/PGZnOexCwyxwYinDezZiY1AkBA
         YyBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679364555;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rr/1PDkNgTI90sPUyrW/8K8Ga9e5P5xxGwc4p7uGABk=;
        b=FVuOS2sQd4hTYdQd536PmxN969WSXzf9cRuV6e2jqOZxP9jIWaCXT0U4AcnRVNMCJ0
         1qTgk5qEkjgkQuTvToNKuINZYbrOfxPn+dxeEU8b8l2886X9HZV3sNNjmv6bBX6BuAZh
         A51cRiLnQgCyeyS5alcsFIu+HES6Co/dFQVHS9otsI9Ztgai91SosZL9LeRI332Nb1h2
         0oufb4xyRZYk2yo8itm1nhjHvVqauUMq8t1O1bsgqEaM51xFezBjdBO5wVjL8ZA7lHrp
         2STAOYzstkjqTIFCm7xGaqhgVZaLaTrxv+jcqlCFALQKAAJTtig+mjlb9J4WcLs4mpuC
         KSSw==
X-Gm-Message-State: AO0yUKVw19Wn+P2QGViwYhXeWBVsmf9ACJH4Tw+qtbv9xm0TXxt8mAW0
        9rtIGPLOcAqIiekbgsvVnpjqV8fILlVBPWN13s8=
X-Google-Smtp-Source: AK7set+GAqU8sjZ8aoPHGyWK9wszKgkFLdT95xc63K6aycd2l+DhXNHBUfJX4BSfbMUsoc7H0FZIZujiwHKeczWn2qg=
X-Received: by 2002:a17:906:e85:b0:8b1:7569:b526 with SMTP id
 p5-20020a1709060e8500b008b17569b526mr485629ejf.11.1679364555506; Mon, 20 Mar
 2023 19:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
 <20230315092041.35482-3-kerneljasonxing@gmail.com> <20230316172020.5af40fe8@kernel.org>
 <CAL+tcoDNvMUenwNEH2QByEY7cS1qycTSw1TLFSnNKt4Q0dCJUw@mail.gmail.com>
 <20230316202648.1f8c2f80@kernel.org> <CAL+tcoD+BoXsEBS5T_kvuUzDTuF3N7kO1eLqwNP3Wy6hps+BBA@mail.gmail.com>
 <870ba7b7-c38b-f4af-2087-688e9ae5a15d@redhat.com>
In-Reply-To: <870ba7b7-c38b-f4af-2087-688e9ae5a15d@redhat.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 21 Mar 2023 10:08:39 +0800
Message-ID: <CAL+tcoCoS1h_iA4-O=teR0zbNK3QyAFh_wH+g22635Gc1_mTGg@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 2/2] net: introduce budget_squeeze to help us
 tune rx behavior
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, brouer@redhat.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, stephen@networkplumber.org,
        simon.horman@corigine.com, sinquersw@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 9:30=E2=80=AFPM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 17/03/2023 05.11, Jason Xing wrote:
> > On Fri, Mar 17, 2023 at 11:26=E2=80=AFAM Jakub Kicinski <kuba@kernel.or=
g> wrote:
> >>
> >> On Fri, 17 Mar 2023 10:27:11 +0800 Jason Xing wrote:
> >>>> That is the common case, and can be understood from the napi trace
> >>>
> >>> Thanks for your reply. It is commonly happening every day on many ser=
vers.
> >>
> >> Right but the common issue is the time squeeze, not budget squeeze,
> >
> > Most of them are about time, so yes.
> >
> >> and either way the budget squeeze doesn't really matter because
> >> the softirq loop will call us again soon, if softirq itself is
> >> not scheduled out.
> >>
>
[...]
> I agree, the budget squeeze count doesn't provide much value as it
> doesn't indicate something critical (softirq loop will call us again
> soon).  The time squeeze event is more critical and something that is
> worth monitoring.
>
> I see value in this patch, because it makes it possible monitor the time
> squeeze events.  Currently the counter is "polluted" by the budget
> squeeze, making it impossible to get a proper time squeeze signal.
> Thus, I see this patch as a fix to a old problem.
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks for your acknowledgement. As you said, I didn't add more
functional change or performance related change, but make a little
change to previous output which needs to be more accurate. Even though
I would like to get it merged, I have to drop this patch and resend
another one. If maintainers really think it matters, I hope it will be
picked someday :)

>
> That said (see below), besides monitoring time squeeze counter, I
> recommend adding some BPF monitoring to capture latency issues...
>
> >> So if you want to monitor a meaningful event in your fleet, I think
> >> a better event to monitor is the number of times ksoftirqd was woken
> >> up and latency of it getting onto the CPU.
> >
> > It's a good point. Thanks for your advice.
>
> I'm willing to help you out writing a BPF-based tool that can help you
> identify the issue Jakub describe above. Of high latency from when
> softIRQ is raised until softIRQ processing runs on the CPU.
>
> I have this bpftrace script[1] available that does just that:
>
>   [1]
> https://github.com/xdp-project/xdp-project/blob/master/areas/latency/soft=
irq_net_latency.bt
>

A few days ago, I did the same thing with bcc tools to handle those
complicated issues. Your bt script looks much more concise. Thanks
anyway.

> Perhaps you can take the latency historgrams and then plot a heatmap[2]
> in your monitoring platform.
>
>   [2] https://www.brendangregg.com/heatmaps.html
>
> --Jesper
>
