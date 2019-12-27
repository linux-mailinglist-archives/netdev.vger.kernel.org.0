Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2686612B493
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 13:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfL0Mny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 07:43:54 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40327 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfL0Mny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 07:43:54 -0500
Received: by mail-ed1-f65.google.com with SMTP id b8so25170775edx.7
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 04:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=otLa74cqUjBqazQxxgofKCdKU7x6Zbr23o7cysD/scg=;
        b=tyn8jdiUVotaPkx9TGoFtdWlUkGNUs7ge3wTLk4soSSUT/VIMuWm9OpQk8ivEVC4CF
         q+E1T7SbAUb1Zh+jFxN8WvoliL5pyrIZSKfC0ncWtzn/nz0mG6V9EzwP4ItykRviccgX
         sOLI9SPbN1ue/x3r0O4fyNWiCiM6EH9I0VW7gu+JIQqF7eSJ0N+82T5j/cypzeRh8c4T
         Gk7YJ50uQNj9tjeW2soZ+8HXyO77beFSsZPOaED+w1ZOALHGShqzhkTCpGwa7/Eysw/M
         cln8G4d4mYMGhdWfqEaIM9kYGtQO57iFtXuSFuUByG4h64RsC/JgqC65gfRDQ/LT0vil
         3ROw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=otLa74cqUjBqazQxxgofKCdKU7x6Zbr23o7cysD/scg=;
        b=bpyYUu3xD75wL3i7vOaXgGKn0/Da/qA/YHqTTUJ/pS8WmL+cv0qE6ABdN/nh9hBJaX
         NlAL/a3Htf4YpIBJrL1Td1nQUsIMd2edB57kqSyaYhRWQKGXGK+ZroLLjlL88WDDMgNX
         LUYUPYZc7E9BCj/Vl6aceima+WfVkMZpj106JIhoCZoI1tBKr0nOROKEoEuqdKnoAaC9
         FBLXCZ5C8EYBraACf3Xkjb9miF/dTlmQX/jycC/pT3sI3BOpZKDIsHOaQUfPZNsEJ1Ey
         gd8gI9UPZ2TdETkrxvqUlDwRYV4UL8MOEnB10YGyxNiOI+DIqG+baq/NdwxNAMR0cAc6
         bI5A==
X-Gm-Message-State: APjAAAUhFJpf2IraA2t7OtOVFbXw8A0Nw1KfvDWki3KWjdYXhcd4pT07
        sebCf1PoPTjCTUR8xGU6/e6Wf54lW1ljuclPxx8=
X-Google-Smtp-Source: APXvYqx9H0lt2BW8hI8u8HvpajOYyZDt/aeigCjqXh8XL3FbBuTpQUp7oFWpT1nOXM/JBB8IJSzeGNrq1nGZjH57euI=
X-Received: by 2002:a17:906:390d:: with SMTP id f13mr52563950eje.151.1577450632706;
 Fri, 27 Dec 2019 04:43:52 -0800 (PST)
MIME-Version: 1.0
References: <20191227023750.12559-3-olteanv@gmail.com> <201912271337.0YA7eKUt%lkp@intel.com>
In-Reply-To: <201912271337.0YA7eKUt%lkp@intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 27 Dec 2019 14:43:41 +0200
Message-ID: <CA+h21hrebs5uvPtg0nRaKpZAq8G++3jFdXGp-BKUzp3FBV0nsQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: dsa: sja1105: Use PTP core's dedicated
 kernel thread for RX timestamping
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Dec 2019 at 07:28, kbuild test robot <lkp@intel.com> wrote:
>
> Hi Vladimir,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
> [also build test ERROR on net/master linus/master v5.5-rc3 next-20191220]
> [cannot apply to sparc-next/master]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
>
> url:    https://github.com/0day-ci/linux/commits/Vladimir-Oltean/Improvements-to-SJA1105-DSA-RX-timestamping/20191227-104228
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 0914d2bb11cc182039084ac3b961dc359b647468
> config: sparc64-randconfig-a001-20191226 (attached as .config)
> compiler: sparc64-linux-gcc (GCC) 7.5.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.5.0 make.cross ARCH=sparc64
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    drivers/net/dsa/sja1105/sja1105_ptp.c: In function 'sja1105_change_rxtstamping':
>    drivers/net/dsa/sja1105/sja1105_ptp.c:86:27: warning: unused variable 'ptp_data' [-Wunused-variable]
>      struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
>                               ^~~~~~~~

Oops, this should have been part of 3/3 not 2/3...

>    drivers/net/dsa/sja1105/sja1105_ptp.c: In function 'sja1105_ptp_clock_unregister':
> >> drivers/net/dsa/sja1105/sja1105_ptp.c:654:2: error: implicit declaration of function 'ptp_cancel_worker_sync'; did you mean 'cancel_work_sync'? [-Werror=implicit-function-declaration]

And the attached .config.gz says that the error here is on the case
where CONFIG_PTP_1588_CLOCK=n. Ok.

>      ptp_cancel_worker_sync(ptp_data->clock);
>      ^~~~~~~~~~~~~~~~~~~~~~
>      cancel_work_sync
>    cc1: some warnings being treated as errors
>
> vim +654 drivers/net/dsa/sja1105/sja1105_ptp.c
>
>    645
>    646  void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
>    647  {
>    648          struct sja1105_private *priv = ds->priv;
>    649          struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
>    650
>    651          if (IS_ERR_OR_NULL(ptp_data->clock))
>    652                  return;
>    653
>  > 654          ptp_cancel_worker_sync(ptp_data->clock);
>    655          skb_queue_purge(&ptp_data->skb_rxtstamp_queue);
>    656          ptp_clock_unregister(ptp_data->clock);
>    657          ptp_data->clock = NULL;
>    658  }
>    659
>
> ---
> 0-DAY kernel test infrastructure                 Open Source Technology Center
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

Will send out a v2.

Sorry,
-Vladimir
