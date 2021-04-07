Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02DE357215
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 18:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhDGQZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 12:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbhDGQZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 12:25:50 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AC6C061756;
        Wed,  7 Apr 2021 09:25:41 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id k25so13107793iob.6;
        Wed, 07 Apr 2021 09:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pqiCYkner6ZTxNFtdDpH2AHRS2ZxI0TvEOALrDZMWM8=;
        b=F8DAUtDvy2Y1CM+3PG+i6uVmIgwhb6Ap0hTHLqNtVUhEUxecdZsmGckJegT6PEBraX
         t/wDjgdowWYbxXu25KGwNpCmkfCIbN76M+u7VigfkG1h9xazMD7FPIoN4dwtDk8o/Hkc
         fwX9bOA8bOtdEWiWkiAu7Q6lEsPpj1dkHVrxVXaydz534llEwTaic6GAqqdGOY5hkvk0
         Jp/amcMxs0brLDQqkLOWg2Qjqaigwl+S2R0Ew8hJFrtuTwP7tyDKmqbq5FvRgTsAq2hK
         koR2cAnxjarSPDF9FDsDECysTSiepMTdlCMUcxSUdCJ7b9M4c1VlvI+68dopp2bdBj3t
         ZUrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pqiCYkner6ZTxNFtdDpH2AHRS2ZxI0TvEOALrDZMWM8=;
        b=ZOYmXW4CtYqiM3i8OY3mC7eeWf9H9JXvJuxMdX1MZ35cUgLxBtiMyfRZZ18Ygb/xBl
         5bEnF4TmWrWt5940LYFi9qVONgWH7V/k7nFfiXbSZRXN8dea5xR1LNYDMqk6lU4jdAGp
         bQdGnBvonPHjC86a9J5WxcaXnuNWS7yJzhK0f4r+ddQEMXc/UiWHrsLe5OSBTVJW1H9k
         Q00Xiq94MrowKISwzgCwsism1Qavq/+bVBDv/eGxMm4oeWlQVnZLFzVR7WASbFx8RrwU
         t0Y4YlZATbEgtibXhll7nljFdJP1xgWLGhgfjNIu83CIxe+a//rpotRnJDB0jzsHMG0E
         zVxA==
X-Gm-Message-State: AOAM531xjJbUbqmuov59cJn9Pq/6Bx/RiCnjOYlT6c66NLBLCkSXoIU2
        KT4aFQBejw6mM0O5m05pfTuZaOwTp7teanW6N+9HaWdQAWs=
X-Google-Smtp-Source: ABdhPJzmzLaJF4Sotf9VFZCX75ULTqB4tb9ZLVKroKizHCJhALSVb7AKGj+kS+HedLYZBjNhj5bzWEkFoxnaV9BDWYI=
X-Received: by 2002:a6b:f909:: with SMTP id j9mr3208715iog.138.1617812740182;
 Wed, 07 Apr 2021 09:25:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210406123619.rhvtr73xwwlbu2ll@spock.localdomain>
 <20210406114734.0e00cb2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210407060053.wyo75mqwcva6w6ci@spock.localdomain> <20210407083748.56b9c261@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210407083748.56b9c261@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 7 Apr 2021 09:25:28 -0700
Message-ID: <CAKgT0UfLLQycLsAZQ98ofBGYPwejA6zHbG6QsNrU92mizS7e0g@mail.gmail.com>
Subject: Re: [igb] netconsole triggers warning in netpoll_poll_dev
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 7, 2021 at 8:37 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 7 Apr 2021 08:00:53 +0200 Oleksandr Natalenko wrote:
> > Thanks for the effort, but reportedly [1] it made no difference,
> > unfortunately.
> >
> > [1] https://bugzilla.kernel.org/show_bug.cgi?id=212573#c8
>
> The only other option I see is that somehow the NAPI has no rings.
>
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index a45cd2b416c8..24568adc2fb1 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -7980,7 +7980,7 @@ static int igb_poll(struct napi_struct *napi, int budget)
>         struct igb_q_vector *q_vector = container_of(napi,
>                                                      struct igb_q_vector,
>                                                      napi);
> -       bool clean_complete = true;
> +       bool clean_complete = q_vector->tx.ring || q_vector->rx.ring;
>         int work_done = 0;
>
>  #ifdef CONFIG_IGB_DCA

It might make sense to just cast the work_done as a unsigned int, and
then on the end of igb_poll use:
  return min_t(unsigned int, work_done, budget - 1);
