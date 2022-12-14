Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB22764D32B
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiLNXRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiLNXRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:17:49 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8CB49B49;
        Wed, 14 Dec 2022 15:17:46 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so916860pjp.1;
        Wed, 14 Dec 2022 15:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gIGH7Q/tUQ519IA4wcnkyGldKKnQTukjBHzEHHiHFbw=;
        b=i3WVs51zn+N+OffvOHIVd+M4i0ujqu/Cy9c3krFuZXIhJyIf56AzyLf6ffk+GjtMGo
         3gtFiIhj8vh8N9zfGOdUdLk6uK+5dki1qEvKQbPPnpUBlJ1RlKI4SaSx6KIX6V+Fs5DC
         f/Zv2NDBVJYocAD06d+xCELQZy/SVC+gWjcQ85EN9qP7ioVemzn9LbhJC/Da1//w4srP
         jzLbzCVtsMQ+J7JWBXJ32GRMDCwdYIHdi3I1evw9qgaSO5Bwe3/jKzfG7juyrNAinELu
         2jL3uWZLrwlURyu3gzUDwZndcnH3ZOFKgJ/71gIQsRow+L1pwMM90O37H4BNorooaAv7
         XOqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gIGH7Q/tUQ519IA4wcnkyGldKKnQTukjBHzEHHiHFbw=;
        b=LJnglBtFNUcaPWhISKG/xDpGf81eerZycuNZPs0/LdXRjvS7iw+q1t0riTkE0N+okU
         5fIEjXbgOSgUWRt99X28D0BSxS2+fgZR34QkJKjUTj3kcMKbp063h4W2GNCEGgf8e2Gm
         p8lsTc1ghN1pTQhqgWg6brUzhYeMpj2Vylq/fHTCoO4MSsh/4yOOkBgsKQH4+32uUo3j
         grni9EwDql3pmV0l4kwuP38h5kcjJALa34KJ/Hcg96mqK+WULP9C2HSLipcFUjGaUO3c
         hrhmlmG9z1VvPs4YWUYLCUhE+lZ5V6LkFduZmzhaJOIMDUzVpGnMtawdRUv8R/hMjT+e
         MQbg==
X-Gm-Message-State: ANoB5pms3H3xyuDnAM1vCeInyX+UyczcypLgsWf4FOyFC6ix1UAdiOVb
        oS0n25x0+ZPf6y/lMyeJE4e9IOW4RWk+bN+ppvI=
X-Google-Smtp-Source: AA0mqf5RagTfHbxJPy0nWx53AnnqIn9z0nCtM3YIC3fPyj8aX541gPdPw6c0U1mGn0rsDBmc+RqH9OCKq/bY2z3LK3Q=
X-Received: by 2002:a17:902:ce8e:b0:174:b537:266d with SMTP id
 f14-20020a170902ce8e00b00174b537266dmr78785131plg.144.1671059866194; Wed, 14
 Dec 2022 15:17:46 -0800 (PST)
MIME-Version: 1.0
References: <20221213074726.51756-1-lianglixuehao@126.com> <Y5l5pUKBW9DvHJAW@unreal>
 <20221214085106.42a88df1@kernel.org> <Y5obql8TVeYEsRw8@unreal>
 <20221214125016.5a23c32a@kernel.org> <4576ee79-1040-1998-6d91-7ef836ae123b@gmail.com>
In-Reply-To: <4576ee79-1040-1998-6d91-7ef836ae123b@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 14 Dec 2022 15:17:34 -0800
Message-ID: <CAKgT0UdZUmFD8qYdF6k47ZmRgB0jS-graOYgB5Se+y+4fKqW8w@mail.gmail.com>
Subject: Re: [PATCH v7] igb: Assign random MAC address instead of fail in case
 of invalid one
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Lixue Liang <lianglixuehao@126.com>,
        anthony.l.nguyen@intel.com, linux-kernel@vger.kernel.org,
        jesse.brandeburg@intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        lianglixue@greatwall.com.cn
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 1:43 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 14.12.2022 21:50, Jakub Kicinski wrote:
> > On Wed, 14 Dec 2022 20:53:30 +0200 Leon Romanovsky wrote:
> >> On Wed, Dec 14, 2022 at 08:51:06AM -0800, Jakub Kicinski wrote:
> >>> On Wed, 14 Dec 2022 09:22:13 +0200 Leon Romanovsky wrote:
> >>>> NAK to any module driver parameter. If it is applicable to all drivers,
> >>>> please find a way to configure it to more user-friendly. If it is not,
> >>>> try to do the same as other drivers do.
> >>>
> >>> I think this one may be fine. Configuration which has to be set before
> >>> device probing can't really be per-device.
> >>
> >> This configuration can be different between multiple devices
> >> which use same igb module. Module parameters doesn't allow such
> >> separation.
> >
> > Configuration of the device, sure, but this module param is more of
> > a system policy. BTW the name of the param is not great, we're allowing
> > the use of random address, not an invalid address.
> >
> >> Also, as a user, I despise random module parameters which I need
> >> to set after every HW update/replacement.
> >
> > Agreed, IIUC the concern was alerting users to incorrect EEPROM values.
> > I thought falling back to a random address was relatively common, but
> > I haven't done the research.
>
> My 2ct, because I once added the fallback to a random MAC address to r8169:
> Question is whether there's any scenario where you would prefer bailing out
> in case of invalid MAC address over assigning a random MAC address (that the
> user may manually change later) plus a warning.
> I'm not aware of such a scenario. Therefore I decided to hardcode this
> fallback in the driver.

I've seen issues with such a solution in the past. In addition it is
very easy for the user to miss the warning and when the EEPROM is
corrupted on the Intel NICs it has other side effects. That is one of
the reasons why the MAC address is used as a requirement for us to
spawn a netdev.

As far as the discussion for module parameter vs something else. The
problem with the driver is that it is monolithic so it isn't as if
there is a devlink interface to configure a per-network parameter
before the network portion is loaded. The module parameter is a
compromise that should only be used to enable the workaround so that
the driver can be loaded so that the EEPROM can then be edited. If
anything, tying the EEPROM to ethtool is the issue. If somebody wants
to look at providing an option to edit the EEPROM via devlink that
would solve the issue as then the driver could expose the devlink
interface to edit the EEPROM without having to allocate and register a
netdev.
