Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62AF1D5ED9
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 07:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgEPFO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 01:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725803AbgEPFO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 01:14:59 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A42C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 22:14:58 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id a4so3537851lfh.12
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 22:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6yyioxex56ifLrIATV/+tinyrRUIOpOG6/3b8f+yQzI=;
        b=MBV0Sp00vxFqoTFfdMoeBeQBUbIWRxaofSRVlVC7INt4Cymx5p3ugLfLYZEoqysjtK
         7Wk3VCC2jsM/9bMy2BKUi9ACtjEmNdCE1HZosAPIK6jLliGHrY1Nw/YvpIP+4GU2jANw
         CNLlDSVgcF9LvRDYWbqszyvzKwNFYwwmKzJmw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6yyioxex56ifLrIATV/+tinyrRUIOpOG6/3b8f+yQzI=;
        b=GulywEPzRKrU4iJrvIu7GL8KxV2uhLZlmnDuwcqjoJWfjtmEwmTWnz8QtWZV7pb2L8
         9xq45kmUbuVX89z712Begwh4bRjyf/8AfvcDAA2OJJWQeLmAyYFfAv18M45Lj46oz+Z+
         EOvBR8jDBhvmQZkDeKs+Pnc3aZYcW1EtbGO/WbmH5dHa/sG4cGG+qLLXUjQu46mUcyrR
         4CPvxW5RsH9ndsbutNDKkTXZ62s/eDg1euaCzZ4rb+nABS9cU14EOSju0ktoLC2nZXCW
         smYFWeGN2jQV9byLTz3sYneIj87k0bkmIhrTOPs0hteqnZKzWyZ50v79rneokUd9JM/C
         uBmw==
X-Gm-Message-State: AOAM533vRJlB2gsLT5gBUYzR52/rhNgwtS+aBSqBQ/n4SxjyxOh2RIWk
        kNTpW/vIV249gG+ng6wceYrNrb+bpk+PBPRws3CjcQ==
X-Google-Smtp-Source: ABdhPJwp5Z5xg3pc41LQaQPFFnH9hrWzxZe6QMOCu6k4UFVsSXHSGVE2NTnaqkx31KATxz2kcGXDvVP6KvqFHclQXTs=
X-Received: by 2002:a19:5f04:: with SMTP id t4mr4663539lfb.208.1589606096583;
 Fri, 15 May 2020 22:14:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200515212846.1347-1-mcgrof@kernel.org> <20200515212846.1347-5-mcgrof@kernel.org>
In-Reply-To: <20200515212846.1347-5-mcgrof@kernel.org>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Sat, 16 May 2020 10:44:45 +0530
Message-ID: <CAACQVJpqSnTfcb7yvH8vb+L5QzigieQoV=a=1QmH3X8ZEKxBQA@mail.gmail.com>
Subject: Re: [PATCH v2 04/15] bnxt: use new module_firmware_crashed()
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     jeyu@kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        rostedt@goodmis.org, mingo@redhat.com, aquini@redhat.com,
        cai@lca.pw, dyoung@redhat.com, bhe@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, gpiccoli@canonical.com,
        pmladek@suse.com, tiwai@suse.de, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 3:00 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
>
> Using a taint flag allows us to annotate when this happens clearly.
>
> Cc: Michael Chan <michael.chan@broadcom.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index dd0c3f227009..5ba1bd0734e9 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -3503,6 +3503,7 @@ static int bnxt_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
>
>         dump->flag = bp->dump_flag;
>         if (dump->flag == BNXT_DUMP_CRASH) {
> +               module_firmware_crashed();
This is not the right place to annotate the taint flag.

Here the driver is just copying the dump after error recovery which is collected
by firmware to DDR, when firmware detects fatal conditions. Driver and firmware
will be healthy when the user calls this command.

Also, users can call this command a thousand times when there is no crash.

I will propose a patch to use this wrapper in the error recovery path,
where the driver
may not be able to recover.

>  #ifdef CONFIG_TEE_BNXT_FW
>                 return tee_bnxt_copy_coredump(buf, 0, dump->len);
>  #endif
> --
> 2.26.2
>
Nacked-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
