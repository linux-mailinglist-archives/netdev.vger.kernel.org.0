Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410D92183FB
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 11:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgGHJk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 05:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbgGHJkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 05:40:25 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820DAC08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 02:40:25 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id s9so53333942ljm.11
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 02:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BgK2oERkS87fizOvSp8og/hQrsSt24BjxvtZPq/UjzI=;
        b=U0KchNzadA9gQl6yP3b6FcMOlkx5Hw1p8aIDH+gNXIpitzBb79bjTmm/CuOwlsICrQ
         HqmPF+kTsgAkto2VKVSY0dbx/Qgn3E/3QqGEmcWJSCfZrEudUZ6fB83bo569cospJdlK
         sNPufWPZ16Vk2GKDaOUlr5vIj/d6NkpcUoSN0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BgK2oERkS87fizOvSp8og/hQrsSt24BjxvtZPq/UjzI=;
        b=nirPCzJJO7L5zuJA/VVhuZ7Hlnty3f+JpZ16p8ySDGdRmyhEQ41uzTDmeGE0QJnakP
         KXEgqZwV25pm7gwy8LIjqAstqjZ4DClvdY28Ie9EROL/twpEMTe6Zdr/6RZFgAJWZkpu
         AdpeLqJhp+aJSp37MQemIM7eu+TD7A3vnPEpo9WAsAtJ2Tf2i+D2QxjAU0DWvuKgtLKm
         rt3OoIdPp0nckYjISCyJMYrBlHok8dTqZLsHmFjJsXlwmwAdyObmXJA0Z2utpbpR1R+z
         blGBlGWem/w3yAbyQu/80j/AtcXj0K3f2OHxrMzg58WQ5hYKT/EW7XKq0hR6IhuBFim0
         usuA==
X-Gm-Message-State: AOAM532+PrXsJ9kVV/Eq8qz+We3dLcC5t//jp7ZnySeCD2S2jB/oRJDd
        UvCWnNKcnbA/KphAutpGTcmf1cnAOoHqWP1Oid0ieg==
X-Google-Smtp-Source: ABdhPJz3acrdo6YOqq/+1pcpMjX2xrZzg9n8xFDl9jIPpuKWY64a3YU8nMuIGZ7unZz6/kzaRewUb0xLk9PXl0ubiGk=
X-Received: by 2002:a05:651c:32c:: with SMTP id b12mr33452799ljp.326.1594201223722;
 Wed, 08 Jul 2020 02:40:23 -0700 (PDT)
MIME-Version: 1.0
References: <1593416584-24145-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200705110301.20baf5c2@hermes.lan>
In-Reply-To: <20200705110301.20baf5c2@hermes.lan>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Wed, 8 Jul 2020 15:10:12 +0530
Message-ID: <CAACQVJogqmNG_jb0W-gV23uWTcpitrx=TF9asZ9s0kfrjbB2ZA@mail.gmail.com>
Subject: Re: [PATCH v2 iproute2-next] devlink: Add board.serial_number to info subcommand.
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Netdev <netdev@vger.kernel.org>, dsahern@gmail.com,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 5, 2020 at 11:33 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 29 Jun 2020 13:13:04 +0530
> Vasundhara Volam <vasundhara-v.volam@broadcom.com> wrote:
>
> > Add support for reading board serial_number to devlink info
> > subcommand. Example:
> >
> > $ devlink dev info pci/0000:af:00.0 -jp
> > {
> >     "info": {
> >         "pci/0000:af:00.0": {
> >             "driver": "bnxt_en",
> >             "serial_number": "00-10-18-FF-FE-AD-1A-00",
> >             "board.serial_number": "433551F+172300000",
> >             "versions": {
> >                 "fixed": {
> >                     "board.id": "7339763 Rev 0.",
> >                     "asic.id": "16D7",
> >                     "asic.rev": "1"
> >                 },
> >                 "running": {
> >                     "fw": "216.1.216.0",
> >                     "fw.psid": "0.0.0",
> >                     "fw.mgmt": "216.1.192.0",
> >                     "fw.mgmt.api": "1.10.1",
> >                     "fw.ncsi": "0.0.0.0",
> >                     "fw.roce": "216.1.16.0"
> >                 }
> >             }
> >         }
> >     }
> > }
>
> Although this is valid JSON, many JSON style guides do not allow
> for periods in property names. This is done so libraries can use
> dot notation to reference objects.
Okay, I will modify the name to board_serial_number and resend the
patch. Thanks.

>
> Also the encoding of PCI is problematic
>
>
