Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BE3690827
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 13:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjBIMEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 07:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjBIMDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 07:03:50 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A335EA1E
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 03:54:06 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id qw12so5616908ejc.2
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 03:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QUdDWGSEIPNHTkY1nLcTe4MvFdzuflifAIW9LpHZTGM=;
        b=ta2UpM5asl3Lm0W855qYewhrra7ru434Thf2k/DvVsxuPAXm8BGe+R1WPmsEC5MCK+
         Z/jX2V7q/SUuYXinBJb8709z8pUl5u0uuceBEDKdnJz+jGqzaHMjPyIT9smK9omPqroQ
         MqLmra1QwL/nVJlvYcHBfaumVfU+MkzA2qP74=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QUdDWGSEIPNHTkY1nLcTe4MvFdzuflifAIW9LpHZTGM=;
        b=Ic4hgy8YJjjhofDSRDAvUhgIgog0MMQrrTDDFKv3BZainFHO7Hvw4Dq+k6IqSDh07t
         PBicK3rL2ij2d+weoDmaiSwjpv44A2R/56fkRxhPYrq/2YUkS3GIhTXyHT6Ru64Mdn3R
         uwf6r3n8kG5ZQb+u97qXpNUhOw65Uupin372xTc2q+VH2d4rZvxpLoLsuq69iGyRewlv
         nfpYUJfg37qSVOpg3zJ9uvQ9FCBoHkICVKqpASKNhPZ2l8bUuVezmVuCKK9ljFfHK/vE
         DI/HKoeQUP9mBJOf8/I7aAiYLhuJ1mXlOiujuz+MRZxf+3qZtZWZ5UoUsVvTZPmwObFx
         FQFQ==
X-Gm-Message-State: AO0yUKXshopoLyZjQnHg3R9KZCVpuVG2UMxbEdsjayZrI99hZczTjMHv
        ZPmB+IR9HwzVaZu70suVXRkwz92sFgUhxozKLD9z2w==
X-Google-Smtp-Source: AK7set+N3QhY91uskzELT0cf+ZTUWUOYeughhVQDCr4yNOkf+25kcW5lGeKcAti7plBwPgpmGhsvh77FhmHiXClLh9M=
X-Received: by 2002:a17:906:37c2:b0:878:7bc7:958a with SMTP id
 o2-20020a17090637c200b008787bc7958amr2481252ejc.220.1675943644878; Thu, 09
 Feb 2023 03:54:04 -0800 (PST)
MIME-Version: 1.0
References: <20230208-sctp-filter-v1-1-84ae70d90091@diag.uniroma1.it> <CADvbK_ebZEmO_n9c3XDBF65W8AcXFXdUYjpsRDUin8T0devCYQ@mail.gmail.com>
In-Reply-To: <CADvbK_ebZEmO_n9c3XDBF65W8AcXFXdUYjpsRDUin8T0devCYQ@mail.gmail.com>
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Thu, 9 Feb 2023 12:53:54 +0100
Message-ID: <CAEih1qW6_YetJV4LB9=+P-TCd6Bw_YZ=cVaL+tOLxPk=qp1a6A@mail.gmail.com>
Subject: Re: [PATCH net-next] sctp: check ep asocs list before access
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Feb 2023 at 20:21, Xin Long <lucien.xin@gmail.com> wrote:
>
> [...]
> > We suspect a race condition between a connecting sctp socket
> > and the diag query.
> As it commented in sctp_transport_traverse_process():
>
> "asoc can be peeled off " before callinsctp_sock_filter(). Actually,

Ah, thank you for clarifying! I misunderstood the comment, and read it
like "we hold the ep, otherwise ascoc can be peeled off".

> the asoc can be peeled off from the ep anytime during it by another
> thread, and placing a list_empty(&ep->asocs) check and returning
> won't avoid it completely, as peeling off the asoc can happen after
> your check.
>
> We actually don't care about the asoc peeling off during the dump,
> as sctp diag can not work that accurately. There also shouldn't be

Agree. This makes a lot of sense.

> problems caused so far, as the "assoc" won't be used anywhere after
> that check.
>
> To avoid the "type confused pointer" thing,  maybe you can try to use
> list_is_first() there:
>
> -       struct sctp_association *assoc =
> -               list_entry(ep->asocs.next, struct sctp_association, asocs);
>
>         /* find the ep only once through the transports by this condition */
> -       if (tsp->asoc != assoc)
> +       if (!list_is_first(&tsp->asoc->asocs, &ep->asocs))
>                 return 0;
>

This is a very nice suggestion, which also avoids future issues in
case assoc would be used. I'll do that in v2. Thank you!

Best regards,
Pietro
