Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E173A7CA5
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 13:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhFOLGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 07:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhFOLGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 07:06:20 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB26C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 04:04:14 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso13855261otu.10
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 04:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VguvAnrUhfE7fOOHBQBQeWQ7zRJfUj8WMDnRAb4RR3Q=;
        b=cPY4MbQ21sdVJP/MZwcfyJuNECCpFGVYhdthQTgZhQ/o5pSWw5CgERNo56ptrm6U68
         EQ3ISv9/vdhDSceYTKYMocTAL0TFK0cXPaFcY2YXISK5rOF5KH/EWAYZ+tOpkWxXTwkJ
         LFLWAYooe5MxFFH/VX0TDL09uV3SSdzRFaDerVmqNKYQ6VKnB423jrliq/oQ2wyIz511
         IWn8UzDGQIBrUMgSp8xnWIjcZcKFR3ZRDFGUjPrbpAYgqNt/yDAZwrlK5/2g6qiEZoZ9
         +9+0+JtAcXQ/1j1OlCu2ZLm73gGlKF0dkqbKRRJY0eslHuIIQ3p87bH+8HDnJoww69Lx
         7Gxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VguvAnrUhfE7fOOHBQBQeWQ7zRJfUj8WMDnRAb4RR3Q=;
        b=C3SIf626wNso2QJAQXk2on9N2Wjt0TJh3S4P/HIpF9tabOgciK+P/97vK4p5Sc/R/Z
         lOvCBqI4URXhrhJrtWpWz7bJhzdVXmfPpSs6ic3mlKYF1kI9osVsXQGG58RVrqqF3dfu
         REkQRiTfejKKK5TyLS3sR/l6KplG28gQLIp36xE0Dogag0Ce14/5eWkFqUItUpWWpYr4
         JDLfK07TzlR2JCRj5X0IHfnVgR8ckOkvcQIgiKs4DdHslLRlur3jUWF44IrKj3KgZ9/2
         r/KUgo8xi73JWidr4+utXJK/wQW/DKwjSb3ZBIr1Sz4+FSAvpBavNsBo+xfpEiEJ1gKx
         MZ8Q==
X-Gm-Message-State: AOAM5318ngD3OxN+pEEQldTcEdBonHyN2gvlSPQ8GaqGzjjWgmpQS981
        iEFRtqK4FwBWZ3HQGdWKbd16AeIDtIyA+GmZ4G0E3El/
X-Google-Smtp-Source: ABdhPJy5UaWd0dWz1lji0LDZweXbq6Mg1Oa8oicUMWymjLrKq8edJy0/ymjtUcy0JN286qIpExQbuGP0mcv9D7vWUoo=
X-Received: by 2002:a05:6830:154b:: with SMTP id l11mr17768417otp.66.1623755053574;
 Tue, 15 Jun 2021 04:04:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210614141849.3587683-1-kristian.evensen@gmail.com>
 <8735tky064.fsf@miraculix.mork.no> <20210614130530.7a422f27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKfDRXgQLvTpeowOe=17xLqYbVRcem9N2anJRSjMcQm6=OnH1A@mail.gmail.com>
 <877divwije.fsf@miraculix.mork.no> <CAKfDRXivs063y2sq0p8C1s1ayyt3b5DgxKH6smcvXucrGq=KHA@mail.gmail.com>
In-Reply-To: <CAKfDRXivs063y2sq0p8C1s1ayyt3b5DgxKH6smcvXucrGq=KHA@mail.gmail.com>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Tue, 15 Jun 2021 13:04:02 +0200
Message-ID: <CAKfDRXhraBRXwaDb6T3XMtGpwK=X2hd8+ONWLSmJhQjGurBMmw@mail.gmail.com>
Subject: Re: [PATCH net] qmi_wwan: Clone the skb when in pass-through mode
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        subashab@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jun 15, 2021 at 12:51 PM Kristian Evensen
<kristian.evensen@gmail.com> wrote:
> I think this would be a really nice solution. The same (at least
> FLAG_MULTI_PACKET + usbnet_skb_return) could be applied to pass
> through as well, giving us consistent handling of aggregated packets.
> While we might not save a huge number of lines, I believe the
> resulting code will be easier to understand.

Apologies for the noise. When I check the code again, I see that as
long as FLAG_MULTI_PACKET is set, then we end up with usbnet freeing
the skb (we will always jump to done in rx_process()). So for the
pass-through case, I believe your initial suggestion of having
rx_fixup return 1 is the way to go.

Kristian
