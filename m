Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128994FC0DB
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346764AbiDKPf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243251AbiDKPfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:35:55 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F3D36B4D
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:33:37 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id v4so5422090edl.7
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=w25zbQyArzGNXfrTi7XJ3gPTAp9L9GfptZWplrYDEpQ=;
        b=aUiAh5v2+Vx0gTrSZWMFVPH+EIFKjL8Kh3kDd9+BdlE78xJfY1aXK0PoNIEnRBsbyQ
         SN8UHCc+PsF88oAMekfBL5szY2xj1uobSOpJfLucGwXUtupxFdzKS/YZEnUDNGYlYgSV
         QnH/LamXdIIOndQOy/mklTvOFcKXg8sMq8rJApSopIehcwWs7ambelsjSY7Kc2XF6gBo
         nSt6exOJNDRGd7EH+gRqmuU/bYyrufUu5srEndgG4spv3WndPUQIWVMRFnZRCjzSv2Rz
         aGzoHxtInzmIHmczHSiHxR2Bqb1P4RYQ2OiG376TFvDmZtRxkb9Z+tkxyyqX08p+AIJ9
         LI0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=w25zbQyArzGNXfrTi7XJ3gPTAp9L9GfptZWplrYDEpQ=;
        b=6Yv862X3vbK5B5vVs52tr2sn2BlzbBsNCMw8XuAdY073yuV4kk7FwB7tkWhKJPO+wQ
         KqkBvLD+dA0zUNfAWJcvcLs9OYCYOtI97Ash2rx4DZ4YxpHW1+P3s8lMUB33sv1Z8ije
         VGvyp7yPhRk+xqlm5nnQUMgqCwta5AGIgLQ0ll8AXcBwY7FAX7OHW2XFgljnfxxTDV9j
         J2lW8AOfFy3g2cPHqUaDZYDEbs3fgaPJzX3fIOfT2t03KKhI4j4QZqFNZhEZNf4C+5Zc
         v+mInv9rGmTxxWyhR+glodLV9r8FJVMt8pG/mxqivZzu9/I2kjeQvTKHgCq6aoYN4yHz
         xQyQ==
X-Gm-Message-State: AOAM532L+0CvVLzCqVnXi91samAOFtkhHmxr5l5eyFdClS8aq8eytE8S
        WM/raAXdCLZ1J3XswmJ2rO4=
X-Google-Smtp-Source: ABdhPJzBxRDT/C0CwyizMheFSMAyGvlUOAFDcZub4EJc+3uTLoAKWWVMXA5rLMJ/NuJAq1bawa7TAg==
X-Received: by 2002:a05:6402:207a:b0:41d:80c:45 with SMTP id bd26-20020a056402207a00b0041d080c0045mr22984896edb.248.1649691216257;
        Mon, 11 Apr 2022 08:33:36 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id f3-20020a056402004300b004162aa024c0sm15196194edu.76.2022.04.11.08.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 08:33:35 -0700 (PDT)
Date:   Mon, 11 Apr 2022 18:33:34 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: What is the purpose of dev->gflags?
Message-ID: <20220411153334.lpzilb57wddxlzml@skbuf>
References: <20220408183045.wpyx7tqcgcimfudu@skbuf>
 <20220408115054.7471233b@kernel.org>
 <20220408191757.dllq7ztaefdyb4i6@skbuf>
 <797f525b-9b85-9f86-2927-6dfb34e61c31@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <797f525b-9b85-9f86-2927-6dfb34e61c31@6wind.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 05:26:05PM +0200, Nicolas Dichtel wrote:
> Le 08/04/2022 à 21:17, Vladimir Oltean a écrit :
> > On Fri, Apr 08, 2022 at 11:50:54AM -0700, Jakub Kicinski wrote:
> >> On Fri, 8 Apr 2022 21:30:45 +0300 Vladimir Oltean wrote:
> >>> Hello,
> >>>
> >>> I am trying to understand why dev->gflags, which holds a mask of
> >>> IFF_PROMISC | IFF_ALLMULTI, exists independently of dev->flags.
> >>>
> >>> I do see that __dev_change_flags() (called from the ioctl/rtnetlink/sysfs
> >>> code paths) updates the IFF_PROMISC and IFF_ALLMULTI bits of
> >>> dev->gflags, while the direct calls to dev_set_promiscuity()/
> >>> dev_set_allmulti() don't.
> >>>
> >>> So at first I'd be tempted to say: IFF_PROMISC | IFF_ALLMULTI are
> >>> exposed to user space when set in dev->gflags, hidden otherwise.
> >>> This would be consistent with the implementation of dev_get_flags().
> >>>
> >>> [ side note: why is that even desirable? why does it matter who made an
> >>>   interface promiscuous as long as it's promiscuous? ]
> I think this was historical, I had the same questions a long time ago.
> 
> >>
> >> Isn't that just a mechanism to make sure user space gets one "refcount"
> >> on PROMISC and ALLMULTI, while in-kernel calls are tracked individually
> >> in dev->promiscuity? User space can request promisc while say bridge
> >> already put ifc into promisc mode, in that case we want promisc to stay
> >> up even if ifc is unbridged. But setting promisc from user space
> >> multiple times has no effect, since clear with remove it. Does that
> >> help? 
> > 
> > Yes, that helps to explain one side of it, thanks. But I guess I'm still
> > confused as to why should a promiscuity setting incremented by the
> > bridge be invisible to callers of dev_get_flags (SIOCGIFFLAGS,
> > ifinfomsg::ifi_flags [ *not* IFLA_PROMISCUITY ]).
> If I remember well, the goal was to advertise these flags to userspace only when
> they were set by a userspace app and not by a kernel module (bridge, bonding, etc).
> To avoid changing that behavior, IFLA_PROMISCUITY was introduced, thus userspace
> may know if promiscuity is enabled by dumping the interface. Notifications were
> fixed later, but maybe some are still missing.

Thanks.
Would you agree that the __dev_set_allmulti() -> __dev_notify_flags()
call path is dead code? If it is, is there any problem it should be
addressing which it isn't, or can we just delete it?
