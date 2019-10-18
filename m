Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3DBDCC21
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 19:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505067AbfJRRBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 13:01:33 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44248 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502177AbfJRRBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 13:01:31 -0400
Received: by mail-pg1-f195.google.com with SMTP id e10so3683657pgd.11
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 10:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=IOez4AH3FAxesTF0200hHYoiJIV2V8NUCCJGXlYSsIw=;
        b=KzhFXzPgLEaLHhBO7ptqMUiewe2hpO3sKQrkBTIS2eSa/S2OQK8ED1Lh62fietylGI
         Qxc98BpQoE6+T6m85d+BX5F9OGCmvuJyKwHs5EvTb8bcOasDPEgd4sXfcyqdynDwOgmU
         f/zk4LYzxayvko1ULjUgZsXIIUE4bet0Tef1a8qXOogeM1rM7ra71MHZ0UE/EzH5Juvk
         HeZas9YAZzfTsICtbivvQ0oS99a0+O+oOeY8yjnxY2aS6AuMpX2CK+8W9HhOvDHzCUnh
         GscyJu3Y1GcOL89BM6kSeU9uPrLmTBgjFriQ+KSWPTCYntykbTKCnmXaDCZkGguf3b2c
         i8Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=IOez4AH3FAxesTF0200hHYoiJIV2V8NUCCJGXlYSsIw=;
        b=VYDrT4jrgwYSeyGlkvO5IRc7ZrE25R1L4orgNMyzE4ufIuf0EhUCdWsqe9msHTUjr2
         j+f6rytz9E6406IVZfa1PxeyrHoadqvC6WWHpnOKMdE9lqw2PDTrx811JHgeHkIapL4Z
         zUAhFzagaRlHB4qNSschBbtiI2PiwAm1s5/NB6vofnXVCxGemduvY+cEAJOAawCXeqxh
         +lLayyv0u0vgbVoQK8bk9zti3ViRX0ZcmxmG64bxhbfoEZe3nZ4ertjk0ssxsEBxWdZW
         sJNDa5YQYtWUROMJCM1PjuLHcOllWMozoJnsPoHu0qXdlXW1D4dUb5rI4hPtFxKZd03Y
         Qduw==
X-Gm-Message-State: APjAAAU5MIvO0R07LvDA/eNsxTVQbyDYju/AwDN4K9TGqbct2umwpgDh
        VZL7PB7wRChXwsq3z7CqOtJRWg==
X-Google-Smtp-Source: APXvYqwzevGKycLkBZbX4mzdTO0J3iEaO1hoIehHH68zRvsQumKhkkhbW3a/N3b0FbN81mCFnTDHDg==
X-Received: by 2002:aa7:98c9:: with SMTP id e9mr8125740pfm.142.1571418091182;
        Fri, 18 Oct 2019 10:01:31 -0700 (PDT)
Received: from cakuba.netronome.com (ip-184-250-188-81.sanjca.spcsdns.net. [184.250.188.81])
        by smtp.gmail.com with ESMTPSA id j26sm6489404pgl.38.2019.10.18.10.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 10:01:31 -0700 (PDT)
Date:   Fri, 18 Oct 2019 10:01:22 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>,
        =?UTF-8?B?UmFmYcWC?= =?UTF-8?B?IE1pxYJlY2tp?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tee-dev@lists.linaro.org, bcm-kernel-feedback-list@broadcom.com,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH V2 3/3] bnxt_en: Add support to collect crash dump via
 ethtool
Message-ID: <20191018100122.4cf12967@cakuba.netronome.com>
In-Reply-To: <CAACQVJrO_PN8LBY0ovwkdxGsyvW_gGN7C3MxnuW+jjdS_75Hhw@mail.gmail.com>
References: <1571313682-28900-1-git-send-email-sheetal.tigadoli@broadcom.com>
        <1571313682-28900-4-git-send-email-sheetal.tigadoli@broadcom.com>
        <20191017122156.4d5262ac@cakuba.netronome.com>
        <CAACQVJrO_PN8LBY0ovwkdxGsyvW_gGN7C3MxnuW+jjdS_75Hhw@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 12:04:35 +0530, Vasundhara Volam wrote:
> On Fri, Oct 18, 2019 at 12:52 AM Jakub Kicinski wrote:
> > On Thu, 17 Oct 2019 17:31:22 +0530, Sheetal Tigadoli wrote:  
> > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > index 51c1404..1596221 100644
> > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > @@ -3311,6 +3311,23 @@ static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
> > >       return rc;
> > >  }
> > >
> > > +static int bnxt_set_dump(struct net_device *dev, struct ethtool_dump *dump)
> > > +{
> > > +     struct bnxt *bp = netdev_priv(dev);
> > > +
> > > +#ifndef CONFIG_TEE_BNXT_FW
> > > +     return -EOPNOTSUPP;
> > > +#endif  
> >
> >         if (!IS_ENABLED(...))
> >                 return x;
> >
> > reads better IMHO  
> Okay.
> 
> >
> > But also you seem to be breaking live dump for systems with
> > CONFIG_TEE_BNXT_FW=n  
> Yes, we are supporting set_dump only if crash dump is supported.

It's wrong.

> > > +     if (dump->flag > BNXT_DUMP_CRASH) {
> > > +             netdev_err(dev, "Supports only Live(0) and Crash(1) dumps.\n");  
> >
> > more of an _info than _err, if at all  
> I made this err, as we are returning error on invalid flag value. I
> can modify the log to
> something like "Invalid dump flag. Supports only Live(0) and Crash(1)
> dumps.\n" to make
> it more like error log.

Not an error.
