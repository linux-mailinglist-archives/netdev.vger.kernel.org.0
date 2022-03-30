Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC344EC60D
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 15:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346443AbiC3N6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 09:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346436AbiC3N6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 09:58:48 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910667DE3E
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 06:57:02 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id j21so18096415qta.0
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 06:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DfvJTlEY8U7rra0eOB4jSr3teV5G1+HBXZRLoOcm1Ys=;
        b=mjLfZ6UICPE4iHot6Ft1DhBnopoHKAN0JBk1FOc/MuPwOrJy1Stvy0GVGi0Q+fR9tq
         07OwRKo2kChON44WIX85CxEk/g6ZXG6ugpSeA/+PvwJBfkIBhqZTxe2iE0aZRwhQOZi9
         6l5apirhR8yrtb1BoRb8k4D71+N6Phgx6DI7JunT45g/p6e0hUmrYmGBoQbKUQ7s9rPp
         lNcRjJ/7ZBoRdUBdgdR2B2aqjROeAlOandhaySdcqZOXnyUtCpiGLhVzLuEzMJ2lbmPN
         FmqOhL7OrvpaJJvHXmK5jdSL3kd/T37DY6545pdWqa/iB7yqIPHiWraSy/OLiQ8cZRdK
         bQKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DfvJTlEY8U7rra0eOB4jSr3teV5G1+HBXZRLoOcm1Ys=;
        b=ITAqzCqv59FjFQ5Ux9ScXPSpmzPzrIVQ2nZ8zTcNP48cKn0bk0vhKCLUqeJbkIHqw1
         +I6llSCIEOrHpHLFoShWYQ4QkM47vfYjW+QIhxYMRdvMoMWP0WVdCp81lskR5yGwiuwU
         rw/eMwtoVVnQlQObpk61bJ5ZhTpQfS6XGWdZnJVUAoIbp5dhV554v3nzIYMtAsdDbzM7
         3gPvB4r04sPsGZSJ42zVFotbqTZWnKnZ0cnRTO3SQKBa0bvC/66xjWOdhBwdt/sWPi6C
         p4BMpbF6Ub/WuMaHyJ/L9xijBG+Hh2iDM0j+eC8BiUc92WHw6BsoBMB83AvRcoDP1ycj
         EvLA==
X-Gm-Message-State: AOAM532FYPgYSKXBjh1QW1Cwe5G/M0z2scRd/Mv0geVF0dD0wlnZxfyb
        Ag7+TfpHsdZ4rfgTBRABH+fjOppB8O7K9lFZbMhhZg==
X-Google-Smtp-Source: ABdhPJwhihrh627ejTmkR2/dwhhgRa9NCHMkD2bfquh9shcIyQ2M+CtQmIYPEpKXvc/K90YI61NwYWoUqc7IeP//fxs=
X-Received: by 2002:a05:622a:1743:b0:2e1:f657:a415 with SMTP id
 l3-20020a05622a174300b002e1f657a415mr32924295qtk.7.1648648621483; Wed, 30 Mar
 2022 06:57:01 -0700 (PDT)
MIME-Version: 1.0
References: <E1nZMdl-0006nG-0J@plastiekpoot> <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za> <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za>
In-Reply-To: <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 30 Mar 2022 09:56:45 -0400
Message-ID: <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP connections
To:     Jaco Kroon <jaco@uls.co.za>
Cc:     Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 2:22 AM Jaco Kroon <jaco@uls.co.za> wrote:
>
> Hi Eric,
>
> On 2022/03/30 05:48, Eric Dumazet wrote:
> > On Tue, Mar 29, 2022 at 7:58 PM Jaco Kroon <jaco@uls.co.za> wrote:
> >
> > I do not think this commit is related to the issue you have.
> >
> > I guess you could try a revert ?
> >
> > Then, if you think old linux versions were ok, start a bisection ?
> That'll be interesting, will see if I can reproduce on a non-production
> host.
> >
> > Thank you.
> >
> > (I do not see why a successful TFO would lead to a freeze after ~70 KB
> > of data has been sent)
>
> I do actually agree with this in that it makes no sense, but disabling
> TFO definitely resolved the issue for us.
>
> Kind Regards,
> Jaco

Thanks for the pcap trace! That's a pretty strange trace. I agree with
Eric's theory that this looks like one or more bugs in a firewall,
middlebox, or netfilter rule. From the trace it looks like the buggy
component is sometimes dropping packets and sometimes corrupting them
so that the client's TCP stack ignores them.

Interestingly, in that trace the client SYN has a TFO option and
cookie, but no data in the SYN.

The last packet that looks sane/normal is the ACK from the SMTP server
that looks like:

00:00:00.000010 IP6 2a00:1450:4013:c16::1a.25 >
2c0f:f720:0:3:d6ae:52ff:feb8:f27b.48590: . 6260:6260(0) ack 66263 win
774 <nop,nop,TS val 1206544341 ecr 331189186>

That's the first ACK that crosses past 2^16. Maybe that is a
coincidence, or maybe not. Perhaps the buggy firewall/middlebox/etc is
confused by the TFO option, corrupts its state, and thereafter behaves
incorrectly past the first 64 KBytes of data from the client.

In addition to checking for checksum failures, mentioned by Eric, you
could look for PAWS failures, something like:

  nstat -az | egrep  -i 'TcpInCsumError|PAWS'

best,
neal
