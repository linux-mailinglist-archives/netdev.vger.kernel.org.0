Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405A02A2BB8
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgKBNms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKBNmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 08:42:44 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4958BC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 05:42:44 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id b4so7459984vsd.4
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 05:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w7fhUV+6bBDwIWvWYWm4qzgc2Tgg6Ck17a0sKop4sS4=;
        b=Ic6XVrrBWhp30/aoiO7OZXxb0hU/e+26QEREmZFnngioZVXv0LNA2W+FFJpdfHDENo
         9EDGeWpnUqH8JyuOUsfoEmnK84AyYCCj9yRhQWbitjaGAN8zB3MrAnT1sqOXmvpDcIrt
         /7AbcI4p4vNJdTronx+CJ+PBALWtyRL0xcDNXHi904Ag0OlHm1PvFh/oNCA53Wo6259m
         Esz1sHfLuaC5SYWkTtYj8F8NstcHMuAvaToxr2adBsMOdaZnjCBmfaQXPrZZzpGb1FU9
         fTX9Eqf7wxxZYwJhqWspA/CIuV4MkTM8H2iY0SOoveRZZ4WlsgJXoKqaRFSYFGKHoC50
         JNTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w7fhUV+6bBDwIWvWYWm4qzgc2Tgg6Ck17a0sKop4sS4=;
        b=M8wBytuc/qZLLeeoPDIdOOfNLQCCmCM044nhgMSbiArtW1EheFuL5XWUyI0rWphjb0
         7pTqf601Z3uhxrd27BpbJNggtixDW2+4kGj/lpQRilIH9V2KBLEKr1nzba1zcwFhqpVb
         Nxa2J6BJme7VLmqtX3tjcl7kIWscOcLNeBB5tsXmNHcpywuO87/fQeY5CtW283hsjfrR
         4FQU0L9DIlYY4j/pxFcjVVbqVegGU6jequ3LYGw54it3JIdHKarSEhQegtgeZbRCnsVK
         OTcoEMH7lyhSV0BkS+sLdX2HPwosX1uiUdehjb+hckmmtiYPdOHdBQvQG4/GYYNXyUJp
         Y5Yw==
X-Gm-Message-State: AOAM5328OWbMlyIa3aaOE54VJAzxFDrf3/jFF0+EX1+Os+8/Dnl4AnkT
        5aWnk7TcABCWrao0u86QIEen5Z2RMX8=
X-Google-Smtp-Source: ABdhPJwyX1NSYcQmfuj4LUdbI8OnjvoO9V+6G5+RMHIDlrtb2iFvB5WumNVO76JnvxgSgm47AwMbbw==
X-Received: by 2002:a67:1101:: with SMTP id 1mr12826823vsr.57.1604324562619;
        Mon, 02 Nov 2020 05:42:42 -0800 (PST)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id b62sm2058889vsb.7.2020.11.02.05.42.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 05:42:40 -0800 (PST)
Received: by mail-vs1-f43.google.com with SMTP id b4so7459861vsd.4
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 05:42:40 -0800 (PST)
X-Received: by 2002:a67:c981:: with SMTP id y1mr13655657vsk.14.1604324559568;
 Mon, 02 Nov 2020 05:42:39 -0800 (PST)
MIME-Version: 1.0
References: <20201102050649.2188434-1-george.cherian@marvell.com> <20201102050649.2188434-3-george.cherian@marvell.com>
In-Reply-To: <20201102050649.2188434-3-george.cherian@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 2 Nov 2020 08:42:03 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfqUuw3zGPGBNJDWvQ615mQOKRcQZsyGXTGbWDbVEB8uw@mail.gmail.com>
Message-ID: <CA+FuTSfqUuw3zGPGBNJDWvQ615mQOKRcQZsyGXTGbWDbVEB8uw@mail.gmail.com>
Subject: Re: [net-next PATCH 2/3] octeontx2-af: Add devlink health reporters
 for NPA
To:     George Cherian <george.cherian@marvell.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, masahiroy@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 12:07 AM George Cherian
<george.cherian@marvell.com> wrote:
>
> Add health reporters for RVU NPA block.
> Only reporter dump is supported
>
> Output:
>  # devlink health
>  pci/0002:01:00.0:
>    reporter npa
>      state healthy error 0 recover 0
>  # devlink  health dump show pci/0002:01:00.0 reporter npa
>  NPA_AF_GENERAL:
>         Unmap PF Error: 0
>         Free Disabled for NIX0 RX: 0
>         Free Disabled for NIX0 TX: 0
>         Free Disabled for NIX1 RX: 0
>         Free Disabled for NIX1 TX: 0
>         Free Disabled for SSO: 0
>         Free Disabled for TIM: 0
>         Free Disabled for DPI: 0
>         Free Disabled for AURA: 0
>         Alloc Disabled for Resvd: 0
>   NPA_AF_ERR:
>         Memory Fault on NPA_AQ_INST_S read: 0
>         Memory Fault on NPA_AQ_RES_S write: 0
>         AQ Doorbell Error: 0
>         Poisoned data on NPA_AQ_INST_S read: 0
>         Poisoned data on NPA_AQ_RES_S write: 0
>         Poisoned data on HW context read: 0
>   NPA_AF_RVU:
>         Unmap Slot Error: 0
>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Jerin Jacob <jerinj@marvell.com>
> Signed-off-by: George Cherian <george.cherian@marvell.com>


> +static bool rvu_npa_af_request_irq(struct rvu *rvu, int blkaddr, int offset,
> +                                  const char *name, irq_handler_t fn)
> +{
> +       struct rvu_devlink *rvu_dl = rvu->rvu_dl;
> +       int rc;
> +
> +       WARN_ON(rvu->irq_allocated[offset]);

Please use WARN_ON sparingly for important unrecoverable events. This
seems like a basic precondition. If it can happen at all, can probably
catch in a normal branch with a netdev_err. The stacktrace in the oops
is not likely to point at the source of the non-zero value, anyway.

> +       rvu->irq_allocated[offset] = false;

Why initialize this here? Are these fields not zeroed on alloc? Is
this here only to safely call rvu_npa_unregister_interrupts on partial
alloc? Then it might be simpler to just have jump labels in this
function to free the successfully requested irqs.

> +       sprintf(&rvu->irq_name[offset * NAME_SIZE], name);
> +       rc = request_irq(pci_irq_vector(rvu->pdev, offset), fn, 0,
> +                        &rvu->irq_name[offset * NAME_SIZE], rvu_dl);
> +       if (rc)
> +               dev_warn(rvu->dev, "Failed to register %s irq\n", name);
> +       else
> +               rvu->irq_allocated[offset] = true;
> +
> +       return rvu->irq_allocated[offset];
> +}

> +static int rvu_npa_health_reporters_create(struct rvu_devlink *rvu_dl)
> +{
> +       struct devlink_health_reporter *rvu_npa_health_reporter;
> +       struct rvu_npa_event_cnt *npa_event_count;
> +       struct rvu *rvu = rvu_dl->rvu;
> +
> +       npa_event_count = kzalloc(sizeof(*npa_event_count), GFP_KERNEL);
> +       if (!npa_event_count)
> +               return -ENOMEM;
> +
> +       rvu_dl->npa_event_cnt = npa_event_count;
> +       rvu_npa_health_reporter = devlink_health_reporter_create(rvu_dl->dl,
> +                                                                &rvu_npa_hw_fault_reporter_ops,
> +                                                                0, rvu);
> +       if (IS_ERR(rvu_npa_health_reporter)) {
> +               dev_warn(rvu->dev, "Failed to create npa reporter, err =%ld\n",
> +                        PTR_ERR(rvu_npa_health_reporter));
> +               return PTR_ERR(rvu_npa_health_reporter);
> +       }
> +
> +       rvu_dl->rvu_npa_health_reporter = rvu_npa_health_reporter;
> +       return 0;
> +}
> +
> +static void rvu_npa_health_reporters_destroy(struct rvu_devlink *rvu_dl)
> +{
> +       if (!rvu_dl->rvu_npa_health_reporter)
> +               return;
> +
> +       devlink_health_reporter_destroy(rvu_dl->rvu_npa_health_reporter);
> +}
> +
> +static int rvu_health_reporters_create(struct rvu *rvu)
> +{
> +       struct rvu_devlink *rvu_dl;
> +
> +       if (!rvu->rvu_dl)
> +               return -EINVAL;
> +
> +       rvu_dl = rvu->rvu_dl;
> +       return rvu_npa_health_reporters_create(rvu_dl);

No need for local var rvu_dl. Here and below.

Without that, the entire helper is probably not needed.

> +}
> +
> +static void rvu_health_reporters_destroy(struct rvu *rvu)
> +{
> +       struct rvu_devlink *rvu_dl;
> +
> +       if (!rvu->rvu_dl)
> +               return;
> +
> +       rvu_dl = rvu->rvu_dl;
> +       rvu_npa_health_reporters_destroy(rvu_dl);
> +}
> +
>  static int rvu_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
>                                 struct netlink_ext_ack *extack)
>  {
> @@ -53,7 +483,8 @@ int rvu_register_dl(struct rvu *rvu)
>         rvu_dl->dl = dl;
>         rvu_dl->rvu = rvu;
>         rvu->rvu_dl = rvu_dl;
> -       return 0;
> +
> +       return rvu_health_reporters_create(rvu);

when would this be called with rvu->rvu_dl == NULL?
