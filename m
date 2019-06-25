Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F94522AF
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 07:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfFYFQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 01:16:27 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35040 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfFYFQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 01:16:27 -0400
Received: by mail-qk1-f193.google.com with SMTP id l128so11606519qke.2;
        Mon, 24 Jun 2019 22:16:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HKmnr8tbebS+Y2cbIt4jQ7wpNYHliuH9KnODpvuyZwQ=;
        b=uMg8F8MXN5O8msr106FWfABJSM+tiVnpydaOtgIm37fXTNdJQ4KGwxUIu7VSgi4G28
         9brvvkF9O/TbH2aXXYZ+kK4rKXpDRWjz5Tnwyu4fHPgFyCmE8n9fz8xgZBXgZ30Gr/PC
         jhjh1E1ta4t+FkxTr1kwxjaoFNx4AH7geIkvzmS17C7To8dBdfgVdDLojHvpDVeqTyna
         wVuAceLmSNDZopyH4YvOpR02/wOvyKzWO3BAGZbSIPHG3eAy0ExHSQGJAq8nwHmkDGQt
         tcWIEbNRJPVhMMj2L6Wp65IwbLLUClC4zHDvsnlnrxco7GiEO+r7Q82Yt+bpJ8r9TPTB
         tZuQ==
X-Gm-Message-State: APjAAAUwBg44jmJTdxABibrcLAO285+OVj08epzC9iduEgLAgSGs0jhx
        h5RY/kIh+o4gddj1x/LSF5dcCsM32W4GAMQy4Rc=
X-Google-Smtp-Source: APXvYqzTYYA75n0YLwuienF50B40Wr3591YiFWOieUjPgQwttLArWUJpXTHtOuxNs4UiLccljUnyFleu9HNZwtW0op4=
X-Received: by 2002:a05:620a:1256:: with SMTP id a22mr58234084qkl.96.1561439786450;
 Mon, 24 Jun 2019 22:16:26 -0700 (PDT)
MIME-Version: 1.0
References: <mhng-ac6d3a1f-07a8-40b5-a4ad-93e529ecc206@palmer-si-x1e> <8bf8f052-cb9e-a4a6-4a7f-584cbd20582d@microchip.com>
In-Reply-To: <8bf8f052-cb9e-a4a6-4a7f-584cbd20582d@microchip.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Tue, 25 Jun 2019 10:46:14 +0530
Message-ID: <CAFcVECLGSkjw-E-nF3z4gfxHYMUQgeVh=Y8t-DOpiLnL_UwDSw@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: macb: Fix compilation on systems without COMMON_CLK
To:     Nicolas Ferre <Nicolas.Ferre@microchip.com>
Cc:     palmer@sifive.com, Harini Katakam <harini.katakam@xilinx.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 4:17 AM <Nicolas.Ferre@microchip.com> wrote:
>
> On 24/06/2019 at 11:57, Palmer Dabbelt wrote:
> > External E-Mail
> >
> >
> > On Mon, 24 Jun 2019 02:40:21 PDT (-0700), Nicolas.Ferre@microchip.com wrote:
> >> On 24/06/2019 at 08:16, Palmer Dabbelt wrote:
> >>> External E-Mail
> >>>
> >>>
> >>> The patch to add support for the FU540-C000 added a dependency on
> >>> COMMON_CLK, but didn't express that via Kconfig.  This fixes the build
> >>> failure by adding CONFIG_MACB_FU540, which depends on COMMON_CLK and
> >>> conditionally enables the FU540-C000 support.
> >>
> >> Let's try to limit the use of  #ifdef's throughout the code. We are
> >> using them in this driver but only for the hot paths and things that
> >> have an impact on performance. I don't think it's the case here: so
> >> please find another option => NACK.
> >
> > OK.  Would you accept adding a Kconfig dependency of the generic MACB driver on
> > COMMON_CLK, as suggested in the cover letter?
>
> Yes: all users of this peripheral have COMMON_CLK set.
> You can remove it from the PCI wrapper then.
>

Yes, +1, both Zynq and ZynqMP have COMMON_CLK set, thanks.

Regards,
Harini
