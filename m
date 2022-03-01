Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77864C8DDB
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 15:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbiCAOfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 09:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbiCAOfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 09:35:45 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A33A1BD2
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 06:35:04 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2d07ae0b1c0so146785467b3.2
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 06:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CKcZyPVWgem/q2wgkerlI2WJZfGV9X0JJY38PEfUa38=;
        b=V/dxBuQ+DYr6W4MUZWNpysBANx4p7IKEWbYFddJ5mz1SmR4mP46PKmdo8znFLLBkrQ
         NxZWr5ir9YJDeGUbSV5Jzp+wZOnSBCFRQYOEnQcUw6ajOP3QIbovU/XRJP7gaRqi/zXQ
         hcL66zwfWi5HBDf2n7QGZnr5tX9iJvXAp6JQWlWLr4Dm5CM3FJVpZ7T39kuAdf+J/lbB
         U9pS6/VPAwAd6hXkeNAGJoTC0oqBODaAvP9KkPkwraRkxYTlY+iVBHbQMDxgMo5ozy2y
         X39GkxVZOMjswAaR8KnN3GNOoE4ELmEQwj7SUB2Zaiqwx+0mwzjbD1QHd11XPLlk98Pe
         LXaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CKcZyPVWgem/q2wgkerlI2WJZfGV9X0JJY38PEfUa38=;
        b=GWEyIJSwN5BZPNS9x+VYISU/9jy0u8YIX+N8dcLwH83nbxGbAqwA6OfPgXyCWfz/21
         V3RAHoeRYS+IY9hVfo0tp3yRhdkwsRDawkutyEjLTOlZqrxNsozELZRrw3XvBw3fQivw
         UUIRlz1zIGtnWTX/3c0oCHzSgh7beD9Y7iNZXymfHxz7WwG3Nh3L1c5c00Y0w9cLVPGE
         2wLBh3ptCCkoqzPHzbymppFvofv1q0gYKg7qrlBeDbvrCu+lwRX1qoqhLx+4YrdHtMWV
         bs7AhZacdH9PYF1AGVZ1knDUx642uD5uGKZditWmwf8RIF2NKmiAzxX/piZBpdE0hYa2
         i4Og==
X-Gm-Message-State: AOAM5310flW5bCf152Ufx5Ky5GCyEz5+rkNBgIUvxG1lt8RgXlK67E4K
        yk3CtYKRCevAM7qoxuUTaXgHWYh9Wyn0OEmyxdJmmjlC4xr16g==
X-Google-Smtp-Source: ABdhPJwakHl3m0TzO1uEubqhkWHLbteEZi3EYjy7TCZZe78UiWRRBJBpB/mJL++uen7YeCadKDnfGtYd+aNxArp4ZR4=
X-Received: by 2002:a0d:da45:0:b0:2d0:bd53:b39 with SMTP id
 c66-20020a0dda45000000b002d0bd530b39mr24540960ywe.463.1646145303733; Tue, 01
 Mar 2022 06:35:03 -0800 (PST)
MIME-Version: 1.0
References: <20220301131512.1303-1-kailueke@linux.microsoft.com>
 <CAHsH6Gtzaf2vhSv5sPpBBhBww9dy8_E7c0utoqMBORas2R+_zg@mail.gmail.com> <d5e58052-86df-7ffa-02a0-fc4db5a7bbdf@linux.microsoft.com>
In-Reply-To: <d5e58052-86df-7ffa-02a0-fc4db5a7bbdf@linux.microsoft.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 1 Mar 2022 16:34:52 +0200
Message-ID: <CAHsH6GsxaSgGkF9gkBKCcO9feSrsXsuNBdKRM_R8=Suih9oxSw@mail.gmail.com>
Subject: Re: [PATCH 1/2] Revert "xfrm: interface with if_id 0 should return error"
To:     =?UTF-8?B?S2FpIEzDvGtl?= <kailueke@linux.microsoft.com>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kai,

On Tue, Mar 1, 2022 at 4:17 PM Kai L=C3=BCke <kailueke@linux.microsoft.com>=
 wrote:
>
> Hi,
> > Whereas 8dce43919566 ("xfrm: interface with if_id 0 should return error=
")
> > involves xfrm interfaces which don't appear in the pull request.
> >
> > In which case, why should that commit be reverted?
>
> Correct me if I misunderstood this but reading the commit message it is
> explicitly labeled as a behavior change for userspace:
>
>     With this commit:
>      ip link add ipsec0  type xfrm dev lo  if_id 0
>      Error: if_id must be non zero.
>
> Changing behavior this way is from my understanding a regression because
> it breaks programs that happened to work before, even if they worked
> incorrect (cf. https://lwn.net/Articles/726021/ "The current process for
> Linux development says that kernel patches cannot break programs that
> rely on the ABI. That means a program that runs on the 4.0 kernel should
> be able to run on the 5.0 kernel, Levin said.").

Well to some extent, but the point was that xfrm interfaces with if_id=3D0
were already broken, so returning an error to userspace in such case
would be a better behavior.
So I'm not sure this is a regression but it's not up to me to decide these
things.

Eyal
