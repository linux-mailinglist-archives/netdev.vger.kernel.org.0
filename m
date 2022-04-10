Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9514FAE10
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 15:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239313AbiDJNob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 09:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239311AbiDJNoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 09:44:30 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF48255214
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 06:42:19 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id h16so8359302wmd.0
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 06:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gYnzEH92zMAbcDob6wy1q7rnL6VqfMUOky6DRn2hyFo=;
        b=oHf6E2BS1r+Q0wp5C+HPgOoZW74McY57gI7F4i3Ua21bruagX7FhhJ6XmmMakcRS6b
         wzkR38WS6S5+1jWNCtq/lxJEUIO43izYoCOz6M8eVgZtigX/yx0M+qWTiU2ctCz/qAG1
         Z+D27ARK6Eug/hohFO+A7YA/k9W+Kc+H1V/nvabQUfocyv9FDc7gWwRcYHescvLItsyJ
         HIN5g+9AePAN/wL9WMCjqD9u6lIE6/Z6k/gqL8npnTw93V4pnQnVKtAEAs3XEZ/3iTuC
         Vx42md+w0GJ1YEYb717wUk/e6+oG1wp8HX2YzoAvSLgX+t1jFDIrWf2vOaaRyfEygk1N
         E5kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gYnzEH92zMAbcDob6wy1q7rnL6VqfMUOky6DRn2hyFo=;
        b=tv57eaqzIYF/iMfaXP/qXUEANSVGm5kiRIS2EA3hfnzDRlT0rBjynFL1fgSzF4JXyU
         tGyGAb7pCmMYX0wmUm1tIHtX5DiL0FsrTeWsUNCDHf2Gvz0NsBUrFbtDYieivmdj2Yxt
         Ly0I7/hzl5nYImBot1RM1j2QwLgTa2uW3ADef2M/yMuHr9oZgi1LdyRIiq5+bLtuwNy1
         tp+zIiEkBnAO5PRmleg3uvOWrRCRrBPSBNOV1x/6cpy8777JZ3ttuSlzslBY/dLoDhq2
         bpbgLksmFiPOBXgwPolFO4BOX5/w8V0Ir/5cK0+i7eohFrnpg10JjSaHysuuH8blgGw4
         4/ng==
X-Gm-Message-State: AOAM530FOAo9BgICn4PVyZpp14q0BcDyQJ7i+nKp9hqMQuj7zoZmU51L
        2iC7YBnebrCa0dCp50uWVI8=
X-Google-Smtp-Source: ABdhPJzwHLr8fCGziR6vsLD8fBMlPTiQtdPIZW7ajG+DZd2ARxd9ZmWiUYXlpMAr2VyyFfrkR9xnKg==
X-Received: by 2002:a05:600c:4f0f:b0:38c:c8f5:73e7 with SMTP id l15-20020a05600c4f0f00b0038cc8f573e7mr24759032wmq.201.1649598138296;
        Sun, 10 Apr 2022 06:42:18 -0700 (PDT)
Received: from hoboy.vegasvil.org (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id 61-20020adf8043000000b00205e1d92a41sm24732256wrk.74.2022.04.10.06.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 06:42:16 -0700 (PDT)
Date:   Sun, 10 Apr 2022 06:42:15 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, yangbo.lu@nxp.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/5] ptp: Support late timestamp determination
Message-ID: <20220410134215.GA258320@hoboy.vegasvil.org>
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
 <20220403175544.26556-5-gerhard@engleder-embedded.com>
 <20220410072930.GC212299@hoboy.vegasvil.org>
 <CANr-f5xhH31yF8UOmM=ktWULyUugBGDoHzOiYZggiDPZeTbdrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5xhH31yF8UOmM=ktWULyUugBGDoHzOiYZggiDPZeTbdrw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 10, 2022 at 02:54:36PM +0200, Gerhard Engleder wrote:
> > > @@ -887,18 +885,28 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
> > >       if (shhwtstamps &&
> > >           (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
> > >           !skb_is_swtx_tstamp(skb, false_tstamp)) {
> > > +             rcu_read_lock();
> > > +             orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
> >
> > __sock_recv_timestamp() is hot path.
> >
> > No need to call dev_get_by_napi_id() for the vast majority of cases
> > using plain old MAC time stamping.
> 
> Isn't dev_get_by_napi_id() called most of the time anyway in put_ts_pktinfo()?

No.  Only when SOF_TIMESTAMPING_OPT_PKTINFO is requested.

> That's the reason for the removal of a separate flag, which signals the need to
> timestamp determination based on address/cookie. I thought there is no need
> for that flag, as netdev is already available later in the existing code.
> 
> > Make this conditional on (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC).
> 
> This flag tells netdev_get_tstamp() which timestamp is required. If it
> is not set, then
> netdev_get_tstamp() has to deliver the normal timestamp as always. But
> this normal
> timestamp is only available via address/cookie. So netdev_get_tstamp() must be
> called.

It should be this:

- normal, non-vclock:	use hwtstamps->hwtstamp directly
- vclock:		use slower path with lookup

I don't see why you can't implement that.


Thanks,
Richard
