Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4EE4E7D89
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbiCYUxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 16:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbiCYUxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 16:53:32 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223DF4831D
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 13:51:57 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id h18so1440501ila.12
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 13:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DRcRYuggiZ2VUq7pyddJLrUfxMcOyqFLc4I53RuxR7U=;
        b=iL300HLgEpbCJuxfKoQp+3oDtei9aNMkDM16RTaYlRwRWm1INg0VJpbbJRmLZa49q0
         xrwSP9wgNLxkqkn/XhrSIRrjpggaH16NhSEGQr9tOYYVf8KsaHXdM86Wr456UqlNDu62
         UFv8LGgzZ+OMrcegYISRhrG9/BROVoErhc2wKN6QHQVkQWv+c/vpoAiotsB6hOat38ts
         dFg0fEqJRRloZb36si+qFlUawam8D9cBmwYJeKmDzt+8b8CANjnbmAIXtcX6pxsHeSFn
         ogi0xfe5ss+R9ils0eschTJ2mNjJPe9gPTk856xhn7ycacbFr/apUQjaKeXCGGLcCJuW
         JhjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DRcRYuggiZ2VUq7pyddJLrUfxMcOyqFLc4I53RuxR7U=;
        b=qj9s7w/wKHqSDM2SdBlEZcRxv/+/u5bKrvJhbfaxNxAQPuOfPJumDQprmhqbM9omDa
         ahxPf5OTR+wCygvreGt2bVln+v8i4kmuU6WQBLlufbm9n6lrwzVRF2XMWS8CUwA3Dxe8
         18cnGSkGOKuioQzO1vi+gGwCPaUr21t77zGMQW5gqI9nyCX6/d5kV/+cCfDkBCAwteiN
         8QTtusrBqHF48zU4NwS5AHN/AxzLiPxdK7hUZIqiTerRbH4xyZaCtVAj0/PIIZyfX+Zy
         7vWwSbmcd7g72OrY4KJLw2c5PcnBp3iQcCg9w6fN1SNXBJ51HXKFvpKq/UoRBDrWYyLx
         Q5TA==
X-Gm-Message-State: AOAM533I0Ch2Hmbj78NUepk7MkBlkqCOwTYS6/zofoxSNaT50WtirJmG
        sHIZw+Px+gPQ9W5AICiOpm7FinhDnXEh1t+/MiOfvQ==
X-Google-Smtp-Source: ABdhPJyxzRUYOwueRE67i23sa/QbiYz3Bco6iuMP6Avy2x8c5Ztc2lAzOMpsUePg9Ofd9ttnIxhBpWEpKotgswcO/Vg=
X-Received: by 2002:a92:6012:0:b0:2bd:fb5f:d627 with SMTP id
 u18-20020a926012000000b002bdfb5fd627mr323473ilb.86.1648241516439; Fri, 25 Mar
 2022 13:51:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
 <20220322210722.6405-6-gerhard@engleder-embedded.com> <20220324140117.GE27824@hoboy.vegasvil.org>
 <CANr-f5zW9J+1Z+Oe270xRpye4qtD2r97QAdoCrykOrk1SOuVag@mail.gmail.com>
 <20220325000432.GA18007@hoboy.vegasvil.org> <20220325000826.GB18007@hoboy.vegasvil.org>
In-Reply-To: <20220325000826.GB18007@hoboy.vegasvil.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Fri, 25 Mar 2022 21:51:45 +0100
Message-ID: <CANr-f5yY1WvzbHjG_mmHAemLSMQj2Jm5Qg3tXQUvUo4oeQQHbA@mail.gmail.com>
Subject: Re: [PATCH net-next v1 5/6] ptp: Support late timestamp determination
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
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

> > > > > diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> > > > > index 54b9f54ac0b2..b7a8cf27c349 100644
> > > > > --- a/drivers/ptp/ptp_clock.c
> > > > > +++ b/drivers/ptp/ptp_clock.c
> > > > > @@ -450,6 +450,33 @@ void ptp_cancel_worker_sync(struct ptp_clock *ptp)
> > > > >  }
> > > > >  EXPORT_SYMBOL(ptp_cancel_worker_sync);
> > > > >
> > > > > +ktime_t ptp_get_timestamp(int index,
> > > > > +                       const struct skb_shared_hwtstamps *hwtstamps,
> > > > > +                       bool cycles)
> > > > > +{
> > > > > +     char name[PTP_CLOCK_NAME_LEN] = "";
> > > > > +     struct ptp_clock *ptp;
> > > > > +     struct device *dev;
> > > > > +     ktime_t ts;
> > > > > +
> > > > > +     snprintf(name, PTP_CLOCK_NAME_LEN, "ptp%d", index);
> > > > > +     dev = class_find_device_by_name(ptp_class, name);
> > > >
> > > > This seems expensive for every single Rx frame in a busy PTP network.
> > > > Can't this be cached in the socket?
> > > I thought that PTP packages are rare and that bloating the socket is
> > > not welcome.
> >
> > Some PTP profiles use insanely high frame rates.  like G.8275.1 with
> > Sync and Delay Req at 16/sec each.  times the number of clients.
>
> times the number of vclocks/Domains.

Getting the physical clock in __sock_recv_timestamp() is the expensive path.
The network device is already available __sock_recv_timestamp(). Timestamp
determination based on address/cookie could be done by the network device
instead of the physical clock. In my opinion, that would be a good fit, because
timestamp generation is already a task of the network device and implementation
would be faster/simpler. What do you think?

Gerhard
