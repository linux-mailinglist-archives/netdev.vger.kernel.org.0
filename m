Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F1628220D
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 09:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbgJCHjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 03:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCHjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 03:39:12 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507F2C0613D0;
        Sat,  3 Oct 2020 00:39:12 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id o5so4146358wrn.13;
        Sat, 03 Oct 2020 00:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9eDbUUTM4/Se82Nj6NAcUtOVBY0yBb+Lgqq10mMozO8=;
        b=GTzEyYxVD+/KcPpeARr1vRRmfin5Mp7ZnGNdB+VhkZt4OFvkOZNI24McZhTVJiTUah
         5CQ6kiIqsk9iuJt1EzGK8JYGNM82jLEKoCALTWEWEgepEtNw4qz9c9q98w30t3SbXwM/
         ii5321Ok4yM9wVC+4BIcjzD8yMGZbdksY7jyrNnVGLHS9QjTGgbBXPRsEnyGglP9f1fF
         GSAIFqPs5A/NAf/mfEV1666zWrIwTeM9DqcFURM/1ANyHQovkxNzp0fYaRjL1Mawr9bl
         GbzjrHRKWuU46NMdpWfCeBkDw7dR/PjaK56A9SrPekjcfQxMAhhF9l8NRLzZd/UtJh6e
         HuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9eDbUUTM4/Se82Nj6NAcUtOVBY0yBb+Lgqq10mMozO8=;
        b=HRv8yp89LIqDYbNWpaPs3TeVLmJJuDAW2OFZ3085rIBeglNProCxdan3Xu9k7IFoVL
         Hcl2yL1OzIlrg3OoK531lNKqHb/94h8UmCjqmlyVfM/ZWAtzvrCDQ4cB8vyTq9M1Uut1
         alSWrCwfLIRU4o8KfaSMJoiaHWF8hizwqB4k3OrorD4rdHhzL5d6UKFnEh9uBciD/Cff
         qsIUUwmfWRV0sfiG6MWUse6O1shEGJUxx9ZhtfCkxA79V5PwhkLQe7E/FeczLhsWio1v
         rD0xu3GjWfpJWROOI5FeCbIp87xRtrcFuOH5QvtSvTvLhafk+wNUPsfpxIR5YH7TNWC6
         3YFw==
X-Gm-Message-State: AOAM530gvCjAkp2IXUJUZ4QU3SuAJp+smesqxv+qlCR2x0jGKKsSu10n
        +KeWDzRdre7bh5VlssLFmEvgnCmqhcu5gIhG9Opl1HE6+NY=
X-Google-Smtp-Source: ABdhPJy26JcArIjbQXvKK9tpViuR71XLiNCiut00I3+IkUUIjMPrpEiHFLnj2K5AdQjRYXpG9yfn7C6ZZjTvumXh9v8=
X-Received: by 2002:adf:82ce:: with SMTP id 72mr6922829wrc.404.1601710750858;
 Sat, 03 Oct 2020 00:39:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1601387231.git.lucien.xin@gmail.com> <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
 <20201003040729.GF70998@localhost.localdomain>
In-Reply-To: <20201003040729.GF70998@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 3 Oct 2020 15:54:37 +0800
Message-ID: <CADvbK_fL77CJ1JTj5idnEGt2Je-OdHTaJqH3Utu-WkweeYMFQQ@mail.gmail.com>
Subject: Re: [PATCH net-next 11/15] sctp: add udphdr to overhead when udp_port
 is set
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 3, 2020 at 12:07 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 09:49:03PM +0800, Xin Long wrote:
> > sctp_mtu_payload() is for calculating the frag size before making
> > chunks from a msg. So we should only add udphdr size to overhead
> > when udp socks are listening, as only then sctp can handling the
>                                                "handle"   ^^^^
right. :D
> > incoming sctp over udp packets and outgoing sctp over udp packets
> > will be possible.
> >
> > Note that we can't do this according to transport->encap_port, as
> > different transports may be set to different values, while the
> > chunks were made before choosing the transport, we could not be
> > able to meet all rfc6951#section-5.6 requires.
>
> I don't follow this last part. I guess you're referring to the fact
> that it won't grow back the PMTU if it is not encapsulating anymore.
> If that's it, then changelog should be different here.  As is, it
> seems it is not abiding by the RFC, but it is, as that's a 'SHOULD'.
>
> Maybe s/requires\.$/recommends./ ?
Yes, it's a "should".

What the code can only do is "the Path MTU SHOULD be increased by
the size of the UDP header" when udp listening port is disabled.
