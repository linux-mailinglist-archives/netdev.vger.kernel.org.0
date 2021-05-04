Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF29C3730C7
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 21:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhEDT2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 15:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbhEDT2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 15:28:16 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E23C061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 12:27:21 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id x5so10584354wrv.13
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 12:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wb+vWEOFiIFM3Mz5o76OTH4EfZOujmuyz+elQMeqLQo=;
        b=VIToxAvOdFoaGs0bWVtPJA8LG0YIc1UGof+WH8l5f1enDaLVZjuAd746q45aa+cDKb
         CB/cCCkGA/ORk8DoTp6DH0MhtoxArvzmPLY2oy5NLSgX5K52XEIM2OBzW+IWnIqFbkdD
         CgsRAl0a+67YPGGw6JcF1ufeWKCdfjC+RoRziCWKEFpFeiIEk+5tk5lP4cWJdwSYOORF
         spPrAiXFey9re+QSgPk5GEC3ahmEEuLKHPV+f7sEu79+odWYFu43BdyEI4IjPMmyhpMT
         zrkNwwpYpuO+SiAEYJTkcl9Vw/IuboUFUTawFd1AjFIAZftQmAxK/C8c2uQPyUa51vaG
         qk/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wb+vWEOFiIFM3Mz5o76OTH4EfZOujmuyz+elQMeqLQo=;
        b=crvCosL9XJ6LXo5ktVPIKM3u2Q5ZOU+CUH0cnRVqpwQNb2o6hVUxWGmgEXL50f8i9J
         pIj93+fdUQ1WmmQNT6rCGAnjsraDZ3SAiyDKuNIRk0GipIR6tm7BL2LMDPaGUK6zZSk/
         bvzu8A1F4ODBhxRFpZuD+XEKpa/Rb1pa+AqCa1FdBxo9SFlGYUhY6fekOauGfRVyLUwE
         yVOid1hDt7STU6wxiYJZwXWUkHcjKP+lQX/JE/j9zqQ05XeZSXTkqMZFGVWLxS/QF4ID
         0EzHjujCyagDHV055RIbr0m6jBhv5jspR29X0ZLJ1BlA6FqZbS6yDEJUFL5YVMuxcFIB
         tztA==
X-Gm-Message-State: AOAM532VzD6ijSfVtDrVqGRvw2+5vC0kBDAqJrrY2yPZxhy3zbQb7HOj
        mAC8SG9r0GVptPckFrJDJs6rMIr1KmhrP2ijw29MU4eartE=
X-Google-Smtp-Source: ABdhPJz85Gj0al2t2XWZAUvciA1TddiCwl1LvqFr6ZKk4S5cteIVmH9r0CKOPCSb+UXqfyNSY1hSYwbDjCt6qIGGuRY=
X-Received: by 2002:a5d:64e4:: with SMTP id g4mr33792944wri.366.1620156439866;
 Tue, 04 May 2021 12:27:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210504191142.2872696-1-drt@linux.ibm.com>
In-Reply-To: <20210504191142.2872696-1-drt@linux.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Tue, 4 May 2021 14:27:09 -0500
Message-ID: <CAOhMmr5T_BLkqGspnzck=xtiX0rPABv8oX4=LCRbH00T8-B6qw@mail.gmail.com>
Subject: Re: [PATCH net v3] ibmvnic: Continue with reset if set link down failed
To:     Dany Madden <drt@linux.ibm.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 4, 2021 at 2:14 PM Dany Madden <drt@linux.ibm.com> wrote:
>
> When ibmvnic gets a FATAL error message from the vnicserver, it marks
> the Command Respond Queue (CRQ) inactive and resets the adapter. If this
> FATAL reset fails and a transmission timeout reset follows, the CRQ is
> still inactive, ibmvnic's attempt to set link down will also fail. If
> ibmvnic abandons the reset because of this failed set link down and this
> is the last reset in the workqueue, then this adapter will be left in an
> inoperable state.
>
> Instead, make the driver ignore this link down failure and continue to
> free and re-register CRQ so that the adapter has an opportunity to
> recover.
>
> Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> Signed-off-by: Dany Madden <drt@linux.ibm.com>
> Reviewed-by: Rick Lindsley <ricklind@linux.ibm.com>
> Reviewed-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> ---
> Changes in V2:
> - Update description to clarify background for the patch
> - Include Reviewed-by tags
> Changes in V3:
> - Add comment above the code change
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 5788bb956d73..9e005a08d43b 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2017,8 +2017,15 @@ static int do_reset(struct ibmvnic_adapter *adapter,
>                         rtnl_unlock();
>                         rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
>                         rtnl_lock();
> -                       if (rc)
> -                               goto out;
> +
> +                       /* Attempted to set the link down. It could fail if the
> +                        * vnicserver has already torn down the CRQ. We will
> +                        * note it and continue with reset to reinit the CRQ.
> +                        */
> +                       if (rc) {
> +                               netdev_dbg(netdev,
> +                                          "Setting link down failed rc=%d. Continue anyway\n", rc);
> +                       }

There are other places which check and rely on the return value of
this function. Your change makes that inconsistent. Can you stop
posting new versions and soliciting the maintainer to accept it before
there is material change? There are many ways to make reset
successful. I think this is the worst approach of all.


>
>                         if (adapter->state == VNIC_OPEN) {
>                                 /* When we dropped rtnl, ibmvnic_open() got
> --
> 2.18.2
>
