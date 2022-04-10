Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD1C4FAE4C
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 16:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbiDJOoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 10:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiDJOom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 10:44:42 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21537A6
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 07:42:31 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id x9so9705959ilc.3
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 07:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=brVhrW6Zt58RQIATwXg8JtIQkyMKvwjqfkNUu7iHlbg=;
        b=Jkb9927/oQx0gGvYGSLgGEXObe+0cBxoB3wFdonwF0/JI08DRE7Ep6ggbWnQTefyI1
         qpuMYHAYo+2vcYlipPX+KwBiXGjVpg53m0FjWz4dn5YRdP8ZuNvNwz8yLkCIXPv77JJC
         d2f4Ne+d7B/TFVYwnXoYs1wRCyCosFa+3XJhfYJOxyRFdZ3FPMHq+7tceDlLgkR1NF1t
         1XpBeCCQlVYucv58lqiCjKB57K6KNqE/jUR12DmkhbNJU/sNXRbOGQgIj5DI9p3quIES
         DCTNlyTrUvPmiKS+sYBpchclGRsNuEDz+tyA1kZoQBEvq2blwqabV9i1n1+NNeye4XAx
         xjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=brVhrW6Zt58RQIATwXg8JtIQkyMKvwjqfkNUu7iHlbg=;
        b=xQiYev41xmOuC33oT42Zdu+Uv7jyzqWDj/5p0fcwjb/F1TKP6ODSiJBrZENyv9o2ad
         HRXlLlppMPfZ6gIeifaMzuKjjAn7r09hBEaN9sakOY3aGtH23ZH8YJCVJqG2hSk5Wkgc
         MBz1lJb/tzTSlNb5rpqd3Fa+BpRVovy3zr9VwqIKhjEdIQNY2GTdbsj6qQ9+FWaSoFMQ
         Jkuxkf6ARA8qM4b9fK6E22zW+bXUtyk8a1Nxv7D5K+jatE47LJJi2egUcF+KIuI4Roxn
         RtblAZ9JOEClq463FnyRYaJO73J0HdTwqlkH2Dwkm7Do5lvNi1J4aogaCG0aroP2Qnz7
         /h1g==
X-Gm-Message-State: AOAM53240CyxzvaUTZtNLnFVgjvTyD4Elx4vLO4U/JDLG8Alf9WauS3b
        OKOzftO9R5xVb6/OUqBA68XxOI8oJhB2nUcC/lPRFA==
X-Google-Smtp-Source: ABdhPJy0DlR705Ah0+fGAR1nXu6MtRzoDI9YVuzJ2py+sFJXiivlJe1cD+E7/rPK/Qxr22MYRwaDWsVs1Slx/xcEmq8=
X-Received: by 2002:a92:6012:0:b0:2bd:fb5f:d627 with SMTP id
 u18-20020a926012000000b002bdfb5fd627mr12057777ilb.86.1649601750444; Sun, 10
 Apr 2022 07:42:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
 <20220403175544.26556-5-gerhard@engleder-embedded.com> <20220410072930.GC212299@hoboy.vegasvil.org>
 <CANr-f5xhH31yF8UOmM=ktWULyUugBGDoHzOiYZggiDPZeTbdrw@mail.gmail.com> <20220410134215.GA258320@hoboy.vegasvil.org>
In-Reply-To: <20220410134215.GA258320@hoboy.vegasvil.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Sun, 10 Apr 2022 16:42:19 +0200
Message-ID: <CANr-f5xriLzQ+3xtM+iV8ahu=J1mA7ixbc49f0i2jxkySthTdQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/5] ptp: Support late timestamp determination
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, yangbo.lu@nxp.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > @@ -887,18 +885,28 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
> > > >       if (shhwtstamps &&
> > > >           (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
> > > >           !skb_is_swtx_tstamp(skb, false_tstamp)) {
> > > > +             rcu_read_lock();
> > > > +             orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
> > >
> > > __sock_recv_timestamp() is hot path.
> > >
> > > No need to call dev_get_by_napi_id() for the vast majority of cases
> > > using plain old MAC time stamping.
> >
> > Isn't dev_get_by_napi_id() called most of the time anyway in put_ts_pktinfo()?
>
> No.  Only when SOF_TIMESTAMPING_OPT_PKTINFO is requested.

You are right, my fault.

> > That's the reason for the removal of a separate flag, which signals the need to
> > timestamp determination based on address/cookie. I thought there is no need
> > for that flag, as netdev is already available later in the existing code.
> >
> > > Make this conditional on (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC).
> >
> > This flag tells netdev_get_tstamp() which timestamp is required. If it
> > is not set, then
> > netdev_get_tstamp() has to deliver the normal timestamp as always. But
> > this normal
> > timestamp is only available via address/cookie. So netdev_get_tstamp() must be
> > called.
>
> It should be this:
>
> - normal, non-vclock:   use hwtstamps->hwtstamp directly
> - vclock:               use slower path with lookup
>
> I don't see why you can't implement that.

I will try to implement it that way.

Thank you!

Gerhard
