Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7C763C635
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbiK2RMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236436AbiK2RMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:12:41 -0500
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1425E63;
        Tue, 29 Nov 2022 09:12:39 -0800 (PST)
Received: by mail-pf1-f173.google.com with SMTP id 130so14286907pfu.8;
        Tue, 29 Nov 2022 09:12:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gbYAVcz0mxyKN98GkPCLeSplQYrU3jgnryNfmo+3ZmU=;
        b=lmnpM6zjwdGHRXrMK5UGRKe/D4cxVsMT4HHK4LpYMDWF3cycxhSUjxOkbNeEWjG0Hz
         H8PhAPuh9q7vosa4YMk2aDKLPHZFtsAp1kRSsKus88lUk7/amQ/5hImGm2zY5FJFNddz
         FOSmmfYy5lqTbOT7lWG2i+lYHXsQ7z9mQkJg/jgpd4E1OMt2eZhlLYeoj5juGXKFZL7B
         jqDJnMK4tks+1H1DsEGr+Zm4Vr3qqDtfGTsHMh+BQtqLlU493I6uf5DOsQQrEoAmOYdA
         ijiTR+TPrbF8kL+E2SbbBUrurOC7F1D0J4a251MCdDofxuhHPvBl8vnADvThYUvldEq7
         YpqQ==
X-Gm-Message-State: ANoB5pm0eWQ1n0hWE024JZd0Ei2f7KB/sM9L14zNh8N8qy22HazA5jIi
        DVGdehaAq0dKolTr5e++GRC79F8p4odEX8R4vJU=
X-Google-Smtp-Source: AA0mqf6sW7S2q6k6Z8gOVKR3pcqvyOJk+4ckrNujXKrxJEyqNqlvRF1cQCMKGIY1aqBauXhDHWejhFnCFo30vjjc/UQ=
X-Received: by 2002:a62:1a8b:0:b0:572:7c58:540 with SMTP id
 a133-20020a621a8b000000b005727c580540mr39438867pfa.69.1669741959106; Tue, 29
 Nov 2022 09:12:39 -0800 (PST)
MIME-Version: 1.0
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr> <20221126162211.93322-6-mailhol.vincent@wanadoo.fr>
 <20221128142857.07cb5d88@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20221128142857.07cb5d88@kicinski-fedora-PC1C0HJN>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 30 Nov 2022 02:12:27 +0900
Message-ID: <CAMZ6RqJU5hm=HniJ59aGvHyaWboa7ZHv+9nSbzGxoY-cCfxMag@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] can: etas_es58x: report the firmware version
 through ethtool
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 29 Nov. 2022 at 07:29, Jakub Kicinski <kuba@kernel.org> wrote:
> On Sun, 27 Nov 2022 01:22:10 +0900 Vincent Mailhol wrote:
> > Implement ethtool_ops::get_drvinfo() in order to report the firmware
> > version.
> >
> > Firmware version 0.0.0 has a special meaning and just means that we
> > could not parse the product information string. In such case, do
> > nothing (i.e. leave the .fw_version string empty).
>
> devlink_compat_running_version() does not work?

I was not aware of this one. Thank you for pointing this out.
If I correctly understand, devlink_compat_running_version() is
supposed to allow ethtool to retrieve the firmware version from
devlink, right?

Currently it does not work. I guess it is because I am not using
SET_NETDEV_DEVLINK_PORT()? I initially thought that this was optional.
I will continue to investigate and see if it is possible to completely
remove the .get_drvinfo() callback.


Yours sincerely,
Vincent Mailhol
