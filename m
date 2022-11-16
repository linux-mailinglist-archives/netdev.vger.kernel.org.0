Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E5962B018
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 01:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiKPAg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 19:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiKPAgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 19:36:25 -0500
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B82F2B617;
        Tue, 15 Nov 2022 16:36:24 -0800 (PST)
Received: by mail-pg1-f176.google.com with SMTP id q1so15142385pgl.11;
        Tue, 15 Nov 2022 16:36:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VmjH6LSq2kE7ALavx/RIOD+BigRt6SH30zuIye218S4=;
        b=41lRKqpziXCTLEMh0pYpvCUisZb/Ea0jepwxuYBzmg8WXZUq3RAlZR6P/7doGiSR0V
         LK+PVVPn9iKXT7C5AT/negrFA89rJjTyyaMKcFFeY30Q7Eqs+3SOIdMCeWzci/3FR/2Q
         QtK2uyWPdcSmR0xx6UxLk4Q0cIr7PdE8CzUXz7vsGNjT3pjRnKNlgLRaCqEDn6ztwPO2
         I/roVTk5T2cYKyYli6kquLqDJwnLcoq43e+JOh3Xcf/01UvMBRosqcTUFGSEx+CWdk8Y
         d+KMJDqV6tLdwuSm5QMKX9hFDMOTTrWOMC90DnsOmrrY/UwOoCs3X+EbGCpo8Bb3MLd4
         raXw==
X-Gm-Message-State: ANoB5pnyjNNKOO478Gz/vhr8CTnZQct6XiJlrm3bx1GH9DI5O5+FrcQJ
        ST/rSv5aF+J6c/JKarsjJWpkYMNIcJMqpfActjc=
X-Google-Smtp-Source: AA0mqf5pZF3P1iggGMNnzHa5qJNDY/DOYNEqVkMraql04R+FNJU5fkgcx1aKGq1uj6LorAxOvvt8bVkwNIBtZkqGxcY=
X-Received: by 2002:a63:5b65:0:b0:46f:f740:3ff5 with SMTP id
 l37-20020a635b65000000b0046ff7403ff5mr18377519pgm.70.1668558983900; Tue, 15
 Nov 2022 16:36:23 -0800 (PST)
MIME-Version: 1.0
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221113040108.68249-1-mailhol.vincent@wanadoo.fr> <20221113040108.68249-3-mailhol.vincent@wanadoo.fr>
 <Y3QW/ufhuYnHWcli@x130.lan>
In-Reply-To: <Y3QW/ufhuYnHWcli@x130.lan>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 16 Nov 2022 09:36:12 +0900
Message-ID: <CAMZ6RqKUKLUf1Y6yL=J6n+N2Uz+JuFnHXdfVDXTZaDQ89=9DzQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] can: etas_es58x: export firmware, bootloader and
 hardware versions in sysfs
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 16 Nov. 2022 at 07:50, Saeed Mahameed <saeed@kernel.org> wrote:
> On 13 Nov 13:01, Vincent Mailhol wrote:
> >ES58x devices report below information in their usb product info
> >string:
> >
> >  * the firmware version
> >  * the bootloader version
> >  * the hardware revision
> >
> >Parse this string, store the results in struct es58x_dev and create
> >three new sysfs entries.
> >
>
> will this be the /sys/class/net/XXX sysfs  ?

I am dropping the idea of using sysfs and I am now considering using
devlink following Andrew's message:
https://lore.kernel.org/linux-can/Y3Ef4K5lbilY3EQT@lunn.ch/

> We try to avoid adding device specific entries in there,
>
> Couldn't you just squeeze the firmware and hw version into the
> ethtool->drvinfo->fw_version
>
> something like:
> fw_version: %3u.%3u.%3u (%c.%3u.%3u)

This looks like a hack. There is no way for the end user to know, just
from the ethtool output, what these in brackets values would mean.

> and bootloader into ethtool->drvinfo->erom_version:
>   * @erom_version: Expansion ROM version string; may be an empty string

Same. I considered doing this in the early draft of this series and
dropped the idea because an expansion ROM and a boot loader are two
things different.

I will continue to study devlink and only use the drvinfo only for the
firmware version.


Yours sincerely,
Vincent Mailhol
