Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D6E641F6D
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 21:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiLDUOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 15:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLDUOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 15:14:34 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AA73B8;
        Sun,  4 Dec 2022 12:14:33 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id n20so23355698ejh.0;
        Sun, 04 Dec 2022 12:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BD9By0sbbXx7eEv5KIzc2aW+ORKfInejUSsJnw8xnc8=;
        b=gETbXTd9kgtgL3naXxHYrPziiXr8yB+83dhdSKHjxNq50rNvJT9hdeHMmW2IygYZpW
         LUElxsQb/P7fkaLHplQvlzcCFWEXLDlkG6T9XJFRCVgMo0Kp2k9Qp3u3MpbtrGZf/R3g
         wGQaPvLVOqmn29Td+8pQCfMPEancFQjmPlF2Ro2MB9agm/t2Z+3KHsLsEQT6g7vl2spO
         8H+cb2OLcQYrPJOFL4EYAlKxqDL+ku5mRRjQfFSIDXM+Ge/kjjcxM97uhxZvhfr98X+R
         EA1Je7ofGTHbrvDDTch2Wyp1LIhOVl/xF6Vr0/CxKXr5qsRTHZqpWIaBiNZwbB8QWofZ
         eTfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BD9By0sbbXx7eEv5KIzc2aW+ORKfInejUSsJnw8xnc8=;
        b=7BGCgnPvlSUQPneVPEw2SotzRBtSZ1y8pFqHdGD9NlnJJe9tmO5UwxKvJKTUT5HiCq
         jLsu1KV4sjZJQHIVWN34kg67QmKj4B6WSy+czQFeftGb/8DB70JrFfAzn6yeKgquH2qB
         55zJZluqox7SM/RfQMeopcQctB5WLNaHqX5s+YTtm6I66Am9Oax+Kw2q9DIfUIpE0zrj
         NieVSy2230Ys5c4SAIyAU57tVpJfo86tqunS/LqejmWvb0lqwq6pXjE1kq6Dg8WokC6A
         zYTyIkUP2WcayLOQqzzvEDImOPBmeAEUTiWWdrH8cejMa1fV1ykp94AICVSKR8/b3G8n
         8W8w==
X-Gm-Message-State: ANoB5pm/NwE7Mj9T0DuEaQHflwbfckJBBGCJsNw28+RlB7385XMPHgVI
        jLcTajXuVK2QYfdv76KyGt0=
X-Google-Smtp-Source: AA0mqf669Db7y6J+1qS+v5b5UuWUfJQ4qMhIHtJHNxkV0j/Njo8QASBKvHLR0+2l8Mb3/j2Pt9ECOQ==
X-Received: by 2002:a17:906:3411:b0:7c0:d3e6:cce with SMTP id c17-20020a170906341100b007c0d3e60ccemr6376921ejb.742.1670184871710;
        Sun, 04 Dec 2022 12:14:31 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id e21-20020a170906315500b007bed316a6d9sm5472857eje.18.2022.12.04.12.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 12:14:31 -0800 (PST)
Date:   Sun, 4 Dec 2022 21:14:39 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 1/2] ethtool: update UAPI files
Message-ID: <Y4z/r7z2a0sDWgtf@gvm01>
References: <cover.1670121214.git.piergiorgio.beruto@gmail.com>
 <0f7042bc6bcd59b37969d10a40e65d705940bee0.1670121214.git.piergiorgio.beruto@gmail.com>
 <Y4zVMj7rOkyA12uA@shell.armlinux.org.uk>
 <Y4zduT5aHd4vxQZL@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4zduT5aHd4vxQZL@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 06:49:45PM +0100, Andrew Lunn wrote:
> On Sun, Dec 04, 2022 at 05:13:22PM +0000, Russell King (Oracle) wrote:
> > On Sun, Dec 04, 2022 at 03:38:37AM +0100, Piergiorgio Beruto wrote:
> > 
> > NAK. No description of changes.
> 
> Hi Piergiorgio
> 
> Look at the previous examples of this:
> 
> commit 41fddc0eb01fcd8c5a47b415d3faecd714652513
> Author: Michal Kubecek <mkubecek@suse.cz>
> Date:   Mon Jun 13 23:50:26 2022 +0200
> 
>     update UAPI header copies
>     
>     Update to kernel v5.18.
>     
>     Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> 
> > > diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
> > > index 944711cfa6f6..5f414deacf23 100644
> > > --- a/uapi/linux/ethtool.h
> > > +++ b/uapi/linux/ethtool.h
> > > @@ -11,14 +11,16 @@
> > >   * Portions Copyright (C) Sun Microsystems 2008
> > >   */
> > >  
> > > -#ifndef _LINUX_ETHTOOL_H
> > > -#define _LINUX_ETHTOOL_H
> > > +#ifndef _UAPI_LINUX_ETHTOOL_H
> > > +#define _UAPI_LINUX_ETHTOOL_H
> 
> Maybe ask Michal Kubecek how he does this. It does not appear to be a
> straight copy of the headers.
Yes, to be fully honest with you guys, I had this impression, however I
could not find any directive in how to do this, and it was blocking my
development. So I apologise, but I just made a raw copy, then I forgot
to look back into this.

Please, if anyone could help me understanding what's the right procedure
for "importing" the UAPI headers from the kernel, I would greatly
appreciate this.

Thanks,
Piergiorgio
