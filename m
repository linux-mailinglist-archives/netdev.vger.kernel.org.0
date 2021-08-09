Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DD13E3EC8
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 06:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbhHIET7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 00:19:59 -0400
Received: from mail-ed1-f45.google.com ([209.85.208.45]:36405 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhHIET7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 00:19:59 -0400
Received: by mail-ed1-f45.google.com with SMTP id b7so22642278edu.3;
        Sun, 08 Aug 2021 21:19:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5hPnLfQOdhJ9VmhjHCFa74vmYcG7vey0A+Y6VMqc53E=;
        b=o5PGXIZWnReQszCos4kWlfLBt0BR2K+i/ixajhAC0ytTL+YgV8pwCUSwODB7AK4Orr
         LBvPtAqCZYIbNdEc4vemBXGCfiFDb0TWVKOKrXRLmhVeVya4oGnaLkpoa99coPcK0ycO
         yCD+b+RubYjEXdoIy6QH+G1jv7YhNOZhJ03Q7EZCLLhMAgY5+hsgpHdEgrDnM4jZBSsi
         8qxUqy2W8UZrr151UCS7CQq/2KfKpQLguObnqFSdFanXSwSKKCV8+iCcLfFtpWeEss6U
         Jj+59B3m1vjkJCTZwOmmGRLoIi/b+02G4Wm0kUZ3YVy4Wdk3HgjXqDoF6Jp8UWPC+9ch
         B8fA==
X-Gm-Message-State: AOAM530zpLhmZx5pZ+t/qf7hxsTGnv/3Fj+Se6yxwE+K5fCKtXA1HXSn
        snRSjh4UdEJ7Cy8lqWZVAJc=
X-Google-Smtp-Source: ABdhPJxLBa4EXTSLKfWMi4nEZ8Wk8PrT9QK9XE4M+ir2fnBq9dIuQxK16aytPtIw8dDJgnbvoCv0Eg==
X-Received: by 2002:a05:6402:5251:: with SMTP id t17mr22730430edd.157.1628482776972;
        Sun, 08 Aug 2021 21:19:36 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id z70sm3240588ede.76.2021.08.08.21.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Aug 2021 21:19:36 -0700 (PDT)
Subject: Re: [PATCH v2] parisc: Make struct parisc_driver::remove() return
 void
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>
Cc:     kernel@pengutronix.de, alsa-devel@alsa-project.org,
        Corey Minyard <minyard@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-input@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        openipmi-developer@lists.sourceforge.net,
        Jaroslav Kysela <perex@perex.cz>,
        "David S. Miller" <davem@davemloft.net>
References: <20210807091927.1974404-1-u.kleine-koenig@pengutronix.de>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <bef58281-91b3-b2d6-ace8-afe0d08221e1@kernel.org>
Date:   Mon, 9 Aug 2021 06:19:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210807091927.1974404-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07. 08. 21, 11:19, Uwe Kleine-König wrote:
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
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com> (for drivers/input)
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> changes since v1 sent with Message-Id:
> 20210806093938.1950990-1-u.kleine-koenig@pengutronix.de:
> 
>   - Fix a compiler error noticed by the kernel test robot
>   - Add Ack for Dmitry
> 
>   arch/parisc/include/asm/parisc-device.h  | 4 ++--
>   drivers/char/ipmi/ipmi_si.h              | 2 +-
>   drivers/char/ipmi/ipmi_si_intf.c         | 6 +-----
>   drivers/char/ipmi/ipmi_si_parisc.c       | 4 ++--
>   drivers/char/ipmi/ipmi_si_platform.c     | 4 +++-
>   drivers/input/keyboard/hilkbd.c          | 4 +---
>   drivers/input/serio/gscps2.c             | 3 +--
>   drivers/net/ethernet/i825xx/lasi_82596.c | 3 +--
>   drivers/parport/parport_gsc.c            | 3 +--
>   drivers/scsi/lasi700.c                   | 4 +---
>   drivers/scsi/zalon.c                     | 4 +---
>   drivers/tty/serial/mux.c                 | 3 +--

For the TTY piece:
Acked-by: Jiri Slaby <jirislaby@kernel.org>

thanks,
-- 
-- 
js
suse labs
