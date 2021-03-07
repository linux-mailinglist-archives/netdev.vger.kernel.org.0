Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA07632FFFD
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 10:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhCGJvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 04:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhCGJvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 04:51:23 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA1BC06174A
        for <netdev@vger.kernel.org>; Sun,  7 Mar 2021 01:51:23 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id x4so7764910lfu.7
        for <netdev@vger.kernel.org>; Sun, 07 Mar 2021 01:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=iXzCcfJI+V0GoPv6zkms2CVGugyfsxFLJoq7lUMNJeY=;
        b=E51LvZaoXj+veHYJPIAfbOP86/B0x7H182y2AjIWAxlhpwU7nM+8unlyAZ/6PaKiyM
         P1oRezfti/bb3sYZP/lrAqXkJbF9CG+tBgc4syYSSODgUzKzAx6jR01uPSFhPeo98YZ4
         n6uS6TRWCS0MnK3JRXMtJieRPKCmXoUTBQ2u2E/+tMZszHpxfm5PrdJ+r8shn4tWdcxo
         3eaqQhMorwbLcUFj9gCl6xgMWfAELo6ANym0+TTMDadMqfRcdE7wNrTsl4uTLMZ+Gait
         r2ONJPuPBwEE/f3qhBKUN+LP+qVG1rBJTYSwEA2cilpnfVrWeamhSKwaE6XX+purJWDx
         BY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=iXzCcfJI+V0GoPv6zkms2CVGugyfsxFLJoq7lUMNJeY=;
        b=tjgrifRr9dzbsKmlFW5pPyV7NbAmFxF62B/uHS1gNXUE4xG8MUTSiGvwYKktP3DRZq
         rnsSyxTrM0WAuZrqDUUI7Zlmfd4VzBnrJu/Ne44kme8UExAEq3hOeDyMWB+SRX+dw8Zx
         9nFOTaLmoI6EWr3AEKCLp1F7YmRxLd/QXGxXd+BwEtfZ2RBKE/ibXxbyyQgQaW+zESnw
         hNqH4oin5KBy6N/c7uLs9uQj6uw0YG1gry5aSD7VxVRiKyi0xSCtzWIN999x3Nq5zlwp
         DkNCyBAIXByagmdOdccb3v0AcDHwjhdT5GTLj63X5AUd74B538lSlutKqoVZ0WtYiqQa
         zNOA==
X-Gm-Message-State: AOAM5317bb02N7ljrKzpPFX4zANu+Q5N0Gkjr9ALQ51U/qdv1chTDnwu
        YG8BsthkmjFWxYU4KdfztM5sVE7dUw+KwA==
X-Google-Smtp-Source: ABdhPJzSlB2cVDRO9J9GtksMhbULp7FesLmiMV+t91jDDtHWBhhwnJcVUFtkdkuKE2b8bMsaWeIPWQ==
X-Received: by 2002:a05:6512:2016:: with SMTP id a22mr11073593lfb.645.1615110680425;
        Sun, 07 Mar 2021 01:51:20 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id d7sm943938lfg.303.2021.03.07.01.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 01:51:19 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: dsa: Always react to global bridge attribute changes
In-Reply-To: <20210307005826.mj6jqyov4kzhqsti@skbuf>
References: <20210306002455.1582593-1-tobias@waldekranz.com> <20210306002455.1582593-3-tobias@waldekranz.com> <20210306140033.axpbtqamaruzzzew@skbuf> <20210306140440.3uwmyji4smxdpgpm@skbuf> <87czwcqh96.fsf@waldekranz.com> <20210307005826.mj6jqyov4kzhqsti@skbuf>
Date:   Sun, 07 Mar 2021 10:51:18 +0100
Message-ID: <877dmjqokp.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 02:58, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Sat, Mar 06, 2021 at 07:17:09PM +0100, Tobias Waldekranz wrote:
>> On Sat, Mar 06, 2021 at 16:04, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Sat, Mar 06, 2021 at 04:00:33PM +0200, Vladimir Oltean wrote:
>> >> Hi Tobias,
>> >>
>> >> On Sat, Mar 06, 2021 at 01:24:55AM +0100, Tobias Waldekranz wrote:
>> >> > This is the second attempt to provide a fix for the issue described in
>> >> > 99b8202b179f, which was reverted in the previous commit.
>> >> >
>> >> > When a change is made to some global bridge attribute, such as VLAN
>> >> > filtering, accept events where orig_dev is the bridge master netdev.
>> >> >
>> >> > Separate the validation of orig_dev based on whether the attribute in
>> >> > question is global or per-port.
>> >> >
>> >> > Fixes: 5696c8aedfcc ("net: dsa: Don't offload port attributes on standalone ports")
>> >> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> >> > ---
>> >>
>> >> What do you think about this alternative?
>> >
>> > Ah, wait, this won't work when offloading objects/attributes on a LAG.
>> > Let me actually test your patch.
>> 
>> Right. But you made me realize that my v1 is also flawed, because it
>> does not guard against trying to apply attributes to non-offloaded
>> ports. ...the original issue :facepalm:
>> 
>> I have a version ready which reuses the exact predicate that you
>> previously added to dsa_port_offloads_netdev:
>> 
>> -               if (netif_is_bridge_master(attr->orig_dev))
>> +               if (dp->bridge_dev == attr->orig_dev)
>> 
>> Do you think anything else needs to be changed, or should I send that as
>> v2?
>
> Sorry, I just get a blank stare when I look at that blob of code you've
> added at the beginning of dsa_slave_port_attr_set, it might as well be
> correct but I'm not smart enough to process it and say "yes it is".
>
> What do you think about this one? At least for me it's easier to
> understand what's going on, and would leave a lot more room for further
> fixups if needed.

I like the approach of having to explicitly state the supported orig_dev
per attribute or object. I think we should go with your fix.
