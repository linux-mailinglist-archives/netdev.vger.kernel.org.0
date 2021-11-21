Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3FE458686
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 22:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhKUVTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 16:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhKUVTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 16:19:51 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D3BC061574;
        Sun, 21 Nov 2021 13:16:46 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y12so67953815eda.12;
        Sun, 21 Nov 2021 13:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B4q70pTY89cGs15Hv5VpCBikru6wI5Q8HQLcS091NI0=;
        b=LhKl8FqQ5Y5wBgF7faDHsjfHEO7tB+tXkt2LPKJN89QAOG3hWmSgFlCrCBLlDNj6O7
         o6gWg7M3MJg1HOCwK6LufDZAftuOj0OspAill5ng0YHcP8BFK/JLJ2HCoYWaod65mFTS
         0OXEeZZSV180aWoBNM+TxNfkl9dfanbK/26135ySMSr12S/SJ2q7RgmfDdkhyi3ihmYc
         cEiUARenywL3r8RNx3zrMeElxPVSQBp1qzCLv9wU3Urcv2Ee3QMCvk+xmYWFXiwoNwy3
         HkN4ZPysGZEeuyCIKzCeeauYnKi1EhdFWQRjrewKIsN5CWIpluLjMBzls/eKn9enOzmW
         T/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B4q70pTY89cGs15Hv5VpCBikru6wI5Q8HQLcS091NI0=;
        b=VhEUEisYHFDAVRyv68fSjmN5NC/UBLIWIvj/reqwA1uXDu0gCFCpmtEosrEMMQCq8z
         leNSfkpMrjQpphYsB6lPbV9t0kpauu2MKX+45StgMGFNRn4vNtcNGXyqzEFhmoSJmwhb
         o7cBV29x5BfVubdnYE8RQwgfidIXPPSsxI45PwVo4eDmuxZq/jZujQowYSP8Zpq3AkCN
         RPxruRgbyDB2HdevGwPaskuJMOEqkpBmz6sC0+yNPaFN+QL1m5FVJDtO5tdgpqQ+dFgR
         NKd4J1imbKXqSsKBmN9Kw5N55tbob6qYftYpV2UQozoOOMGVCsQqBRZnNKRHkosDUksJ
         7B1Q==
X-Gm-Message-State: AOAM5304SUvXM4FSxLF9/BED8OtPSMr2+KD618nSExu1jBOcPCRNYJx7
        i3DT1+48g6bIpH3q2tYom7c5gROYe/KgnyZezOYniY8komQ=
X-Google-Smtp-Source: ABdhPJxQ/rjDsEQhZKv5AdPHqRy66HuXandz0Q3xxeGoncv874rtNgcziUkr3pCWS5ox/fH4LvlTxKTH4fz3BWz6K8Q=
X-Received: by 2002:a17:906:140b:: with SMTP id p11mr33911285ejc.116.1637529404454;
 Sun, 21 Nov 2021 13:16:44 -0800 (PST)
MIME-Version: 1.0
References: <DM6PR12MB45165BFF3AB84602238FA595D89B9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKgT0UfGvcGXAC5VBjXRpR5Y5uAPEPPCsYWjQR8RmW_1kw8TMQ@mail.gmail.com> <DM6PR12MB45162662DF7FAF82E7BD2207D89E9@DM6PR12MB4516.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB45162662DF7FAF82E7BD2207D89E9@DM6PR12MB4516.namprd12.prod.outlook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sun, 21 Nov 2021 13:16:33 -0800
Message-ID: <CAKgT0Uc5ggH24LuKCbSTubDSiTnD5UsLbrC5G6C73rj7ZEnTYQ@mail.gmail.com>
Subject: Re: [igb] netconsole triggers warning in netpoll_poll_dev
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 21, 2021 at 3:44 AM Danielle Ratson <danieller@nvidia.com> wrote:
>
> > > > >  drivers/net/ethernet/intel/igb/igb_main.c | 12 ++++++++----
> > > > >  1 file changed, 8 insertions(+), 4 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
> > > > > b/drivers/net/ethernet/intel/igb/igb_main.c
> > > > > index 0cd37ad81b4e..b0a9bed14071 100644
> > > > > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > > > > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > > > > @@ -7991,12 +7991,16 @@ static void igb_ring_irq_enable(struct
> > > > igb_q_vector *q_vector)
> > > > >   **/
> > > > >  static int igb_poll(struct napi_struct *napi, int budget)  {
> > > > > -       struct igb_q_vector *q_vector = container_of(napi,
> > > > > -                                                    struct igb_q_vector,
> > > > > -                                                    napi);
> > > > > -       bool clean_complete = true;
> > > > > +       struct igb_q_vector *q_vector;
> > > > > +       bool clean_complete;
> > > > >         int work_done = 0;
> > > > >
> > > > > +       /* if budget is zero, we have a special case for netconsole, so
> > > > > +        * make sure to set clean_complete to false in that case.
> > > > > +        */
> > > > > +       clean_complete = !!budget;
> > > > > +
> > > > > +       q_vector = container_of(napi, struct igb_q_vector, napi);
> > > > >  #ifdef CONFIG_IGB_DCA
> > > > >         if (q_vector->adapter->flags & IGB_FLAG_DCA_ENABLED)
> > > > >                 igb_update_dca(q_vector);
> > > >
> > > > I'm not a big fan of moving the q_vector init as a part of this
> > > > patch since it just means more backport work.
> > > >
> > > > That said the change itself should be harmless so I am good with it
> > > > either way.
> > > >
> > > > Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> > >
> > > Hi,
> > >
> > > I have lately added the netconsole module, and since then we see the
> > same warning constantly in the logs.
> > > I have tried to apply Jesse's patch but it didn't seem to solve the issue.
> > >
> > > Did anyone managed to solve the issue and can share with us?
> > >
> > > Thanks,
> > > Danielle
> >
> > The one issue I can see is that it basically leaves the igb_poll call stuck in
> > polling mode.
> >
> > The easiest fix for all of this in the in-kernel driver is to just get rid of the
> > "min" at the end and instead just "return work_done;". The extra
> > complication is only needed if you were to be polling multiple queues and
> > that isn't the case here so we should simplify it and get rid of the buggy
> > "budget - 1" return value.
>
> Thank you very much for your reply Alexander!
> It seems to work well!
>
> Are you planning to send it upstream?

No, I was just suggesting it as a possible solution. Feel free to put
together your own patch and submit it if it is working for you.

- Alex
