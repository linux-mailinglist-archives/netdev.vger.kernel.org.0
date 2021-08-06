Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BCB3E2F72
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 20:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243378AbhHFSqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 14:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbhHFSqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 14:46:35 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C1AC0613CF;
        Fri,  6 Aug 2021 11:46:18 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so20864357pji.5;
        Fri, 06 Aug 2021 11:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=lq+ZJabFR/aEqAVLWWQwRS+Bk30mmVgINsLo2QOd63g=;
        b=oPU85Ks4t/BD97TfUEBxq2w8KeO5d4b1Nvchn+Yv7kB9wyq/mf6St5MBYsxebm3xyK
         2TryVrMzKvdFR8lsNpJJvPTGVD4xpl+ayOSVdJa9rxZqEG8whTlQ9VyP8dlNEQrJJob9
         L1GJYfPOIitMNMopL09Z+xctxoFgA0e1jTOj55Hexm/8/2DIwLeTuQql2G/TkU9C3erd
         aqjtHdqEda9mrydWw7Nl7tQlscqzQhgaTkh3FsV8iPW0Y607/KxDgxiwjF79JrWcFsfS
         nD/+RPX0BYNASPKwyYxj4WgS75i+bpNHRnG/mqXLAaY3TvvGXIOmp2cf1T5bSsVeRVnR
         2OKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lq+ZJabFR/aEqAVLWWQwRS+Bk30mmVgINsLo2QOd63g=;
        b=DucPVjjs0ZsvWYowKi+0i2xiOpQfbZ6htuepHQYDtVV/xB/HOyWy+ZEUwaJBaj0E7T
         kqI8tS6Q/8ExE6mn69Knt+K0ZVfSFAjwkpHwH3RCwazvCphLC6UIVLj+Mb0gxQfjJMc7
         PmVoomIqHbYgxr/nGguyYDSLiflnRYfNcAbWrOdEZ7yUia+cTZyrKDKV7EB4UI9EabHj
         EUmf89xO0vXQB3iHCUXddkfov+Ym17e/RvZ9yiKdA4x7Z6jqPldTi+qhfyL7s4VbR1up
         J7yhgnB3TSS1Wm+k6fA5IWB6rZ0Aj0oA+K8hpr9UOPW9avLdg7XdL/BzYCAmh7/t4D/E
         RwbA==
X-Gm-Message-State: AOAM530kZahHgGV18PkCCoCHNrird3Zmbke3lYJzSsa6g40sQ1CheERm
        D2mu3sep3fbmrkoIGFsOfyI=
X-Google-Smtp-Source: ABdhPJzzMFSdpyMOk7GztnyuZ8fgTAmGVjar/iMG55IOe92tbJufWKgnV6AdQl2ufQFq5C/G1yNdUw==
X-Received: by 2002:a62:8f86:0:b029:32e:33d7:998b with SMTP id n128-20020a628f860000b029032e33d7998bmr12215091pfd.64.1628275577437;
        Fri, 06 Aug 2021 11:46:17 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:8873:2b2a:719c:18c7])
        by smtp.gmail.com with ESMTPSA id jz24sm10017062pjb.9.2021.08.06.11.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 11:46:16 -0700 (PDT)
Date:   Fri, 6 Aug 2021 11:46:13 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>, Corey Minyard <minyard@acm.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-parisc@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, kernel@pengutronix.de
Subject: Re: [PATCH] parisc: Make struct parisc_driver::remove() return void
Message-ID: <YQ2DdZG2tQuzM22U@google.com>
References: <20210806093938.1950990-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210806093938.1950990-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 11:39:38AM +0200, Uwe Kleine-König wrote:
> The caller of this function (parisc_driver_remove() in
> arch/parisc/kernel/drivers.c) ignores the return value, so better don't
> return any value at all to not wake wrong expectations in driver authors.
> 
> The only function that could return a non-zero value before was
> ipmi_parisc_remove() which returns the return value of
> ipmi_si_remove_by_dev(). Make this function return void, too, as for all
> other callers the value is ignored, too.
> 
> Also fold in a small checkpatch fix for:
> 
> WARNING: Unnecessary space before function pointer arguments
> +	void (*remove) (struct parisc_device *dev);
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---

...

>  drivers/input/keyboard/hilkbd.c          | 4 +---
>  drivers/input/serio/gscps2.c             | 3 +--

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks.

-- 
Dmitry
