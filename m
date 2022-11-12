Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D731626616
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 01:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbiKLAsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 19:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiKLAsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 19:48:33 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F93B7FE
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 16:48:31 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id i21so9749367edj.10
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 16:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8AkIeZRFNmcKZ925hxu6FZJvMaF1AQOEjDkNCD6fXPM=;
        b=UPUGJGfW+4y3reaya3Hbd7mj1ZxN1BTBvJLsqjV6RHcN6kAzdApbh2bkxKfJMRxBTJ
         e5wY+lvhFugt+VGCDF3AicZuH4mwy2sbNDGiwYscaD5QkyjyKQdp/hfyJzp4Eh+rbE40
         PkhXJnjEWv6E5aduo3ogWotcaB2arrOh/suW31tKpy7gjIalXUGPp5hc21aOxrAWEuT4
         sBGWvh1XrDYKQTIT6vQFwbpRGLRuYuMJ/D9dpMeXCoJmFCbHzVxOpuV/WKpjl5Wbzw41
         ulJyfZcnX317+FfhKyvM68ePgfsFKJY1+oFbk9BXX7nDGNxa16S8w/tHB7Sfai6OsM6G
         lSGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8AkIeZRFNmcKZ925hxu6FZJvMaF1AQOEjDkNCD6fXPM=;
        b=AUe+gbO3XSAaU8TzTWBTGhJ4eDQkMY7ZlSFSOlndSHqcO3/38HL/sBcq0JYjkrOhPP
         ajrPbwMxc0Kt750LkrRNbHAv1eWl/jnZA9aWOG/sIKUmRi0eljO8CuqyIZgHySsCQRWy
         NJNMZJ7/wbCu2koIc27ewgdqEN52vmvb/HSnjgnygk6UPcKdpSIMo5qNi+IVbBgBMgxu
         yfe1bisfnboT+4L3OyucvtE60lYCpKxnUGBHXBkrotv50irU3QxFhxISDdYOGJzcvXjy
         R5ndr23oMaEwlIiRIBMTLRz4tlq4SpnKbBD2rK8vCLRWGZbtPmvUA/3Efux8pwL2s8yY
         TjbA==
X-Gm-Message-State: ANoB5pmS+9jHJXwSR1j0W9WmbP0ySsRzpIs0EUiA3swlaFKMzmqXJ2M4
        lEiMMwxHrSmn36ypNT2+r6ZIt4z/v8vL+g==
X-Google-Smtp-Source: AA0mqf7xkzQPoC+LVqyuL2dMDSjK1c3w/8h5RLF4fwI4xPzs1F2COhi1zZsNu2skts8MX08QS5aTXw==
X-Received: by 2002:a05:6402:22f2:b0:467:60fa:b629 with SMTP id dn18-20020a05640222f200b0046760fab629mr3292780edb.281.1668214110190;
        Fri, 11 Nov 2022 16:48:30 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id g13-20020a50ec0d000000b0045b3853c4b7sm1698655edr.51.2022.11.11.16.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 16:48:29 -0800 (PST)
Date:   Sat, 12 Nov 2022 02:48:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: status of rate adaptation
Message-ID: <20221112004827.oy62fd7aah6alay2@skbuf>
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com>
 <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
 <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com>
 <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com>
 <CAJ+vNU2i3xm49PJkMnrzeEddywVxGSk4XOq3s9aFOKuZxDdM=A@mail.gmail.com>
 <b336155c-f96d-2ccb-fbfd-db6d454b3b10@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b336155c-f96d-2ccb-fbfd-db6d454b3b10@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 05:38:12PM -0500, Sean Anderson wrote:
> > Something interesting is that when I configured the xmdio node with an
> > interrupt I ended up in a mode where 5g,2.5g and 1g all worked for at
> > least 1 test. There was something wrong with my interrupt
> > configuration (i'm not clear if the AQR113C's interrupt should be
> > IRQ_TYPE_LEVEL_LOW, IRQ_TYPE_EDGE_FALLING or something different).
> 
> NXP use IRQ_TYPE_LEVEL_HIGH on the LS1046ARDB.

Partly true, but mostly false. What is described in fsl-ls1046a-rdb.dts as:

	interrupts = <0 131 4>;

should really have been described as:

	interrupts-extended = <&extirq 0 IRQ_TYPE_LEVEL_LOW>;

There's a polarity inverter which inverts the signal by default,
changing what the GIC sees. The first description bypasses it.
So that's not what the problem is in Tim's case.

As to LEVEL_LOW vs EDGE_FALLING, I suppose the only real difference is
if the interrupt line is shared with other peripherals?
