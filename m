Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46977306A4B
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhA1BX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhA1BX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:23:26 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953D4C061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:22:39 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id d16so3776917wro.11
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OyRcSjYW4l9ShAcd26nl4mobrVXnPpuG7ueyXfxZRqM=;
        b=dhC3f0xzUrqN5TnqWf2/537izY8kBPgQCK32GOLrQYKCuc/3WjN/tUVUkLkXwhhfeV
         zJydIotSHjutbPHkiVmYt9+Qblg7e9S2VvFW3NZSq0o/hrfBguXDIR7Aucv1EpAcwjng
         wVLgvcdsAJLBzljzvqqnFXAKkMx8XNpHVsYT9YAOMlE3oy7FIKP+OvK7RhPe8q1ctJnw
         n8Jmn+b3Y8VXPTIcp6ShskSL+XFX5732KHRFLh2bvyr4vl6vdJWK8to079g9SGgc5fMD
         TG+5GyjwB/SQpXxY7NTuoOxk+35mxN1TpQD0+kur62bVhTKikiOn6CH8ct9P3iaS3EEe
         f4Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OyRcSjYW4l9ShAcd26nl4mobrVXnPpuG7ueyXfxZRqM=;
        b=p8lbaxuyByjE3zldLP7GPiShVJjINPFBVws4+80mBeMya0FLSz8llAX2e8xBNoWNOw
         fbsh6UFqUrL51ebMIRXL9tu6givCrBWoZ/Jcg2a/FbEh3Tn6W/SRTQyhRaTiyKKt4Cbl
         2/jI02kDALqQ/l7meK5KcLBKJNLu3aqx6S48AzKzcKR59bcDX7TxVV1IEtCiO3qtQLYs
         b4ABnHXOla6E4wFoaCW5CdaYiuV/Ee5fadYr/Urj0MBF44DtSpBcao7KJ2eavUceJT0N
         sHg6G4tTcQ/8E45DC6e9ZOlWoZd0y+ZzLUBYYGFh6KWn+d9s5YZjzPsMYaQMq19l82Ct
         aWBQ==
X-Gm-Message-State: AOAM531j068I/EAVeBlrR3LrS+fVqf4Ea3mxnzL6ZQ98PFwWFsNAc8QE
        ZH+U0IrKc3EO/1hAIfON7RQtLd03qV0P4jogUULYqFjaUpw=
X-Google-Smtp-Source: ABdhPJw3SDbtUt3MSKa+hn6VBNlFgBklopyh9uEgzwzveHT3jZN5Ve4LCv0Ot3eVxAuAogWersG4yfmVdVmKN7t3yqo=
X-Received: by 2002:adf:e80f:: with SMTP id o15mr13548114wrm.366.1611796958237;
 Wed, 27 Jan 2021 17:22:38 -0800 (PST)
MIME-Version: 1.0
References: <20210125232023.78649-1-ljp@linux.ibm.com> <20210127170105.011ebb9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210127170105.011ebb9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Wed, 27 Jan 2021 19:22:25 -0600
Message-ID: <CAOhMmr7B4T6XRiGbawsyGBg_Ysa+fBVVacHFPACM8_+4+yjs_g@mail.gmail.com>
Subject: Re: [PATCH net v2] ibmvnic: Ensure that CRQ entry read are correctly ordered
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 7:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 25 Jan 2021 17:20:23 -0600 Lijun Pan wrote:
> > Ensure that received Command-Response Queue (CRQ) entries are
> > properly read in order by the driver. dma_rmb barrier has
> > been added before accessing the CRQ descriptor to ensure
> > the entire descriptor is read before processing.
> >
> > Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
> > Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> > ---
> > v2: drop dma_wmb according to Jakub's opinion
> >
> >  drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> > index 9778c83150f1..d84369bd5fc9 100644
> > --- a/drivers/net/ethernet/ibm/ibmvnic.c
> > +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> > @@ -5084,6 +5084,14 @@ static void ibmvnic_tasklet(struct tasklet_struct *t)
> >       while (!done) {
> >               /* Pull all the valid messages off the CRQ */
> >               while ((crq = ibmvnic_next_crq(adapter)) != NULL) {
> > +                     /* Ensure that the entire CRQ descriptor queue->msgs
> > +                      * has been loaded before reading its contents.
>
> I still find this sentence confusing, maybe you mean to say stored
> instead of loaded?

The above 2 lines are the general description. The below 4 lines are
detailed explanations. If it is still confusing, we can delete the above
2 lines of comments.

>
> > +                      * This barrier makes sure ibmvnic_next_crq()'s
> > +                      * crq->generic.first & IBMVNIC_CRQ_CMD_RSP is loaded
> > +                      * before ibmvnic_handle_crq()'s
> > +                      * switch(gen_crq->first) and switch(gen_crq->cmd).
>
> Yup, that makes perfect sense. It's about ordering of the loads.
>
> > +                      */
> > +                     dma_rmb();
> >                       ibmvnic_handle_crq(crq, adapter);
> >                       crq->generic.first = 0;
> >               }
>
