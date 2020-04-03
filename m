Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4ADA19DE39
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 20:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgDCS4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 14:56:01 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43940 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgDCS4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 14:56:01 -0400
Received: by mail-qk1-f193.google.com with SMTP id o10so9130364qki.10
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 11:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=KKJnKCK6y9DsupscYWX+JVOuCgFe+8mfh1r5Xtw9nwM=;
        b=CBbunnAIgDqbFO7BLXyAzsUB3AVOZ8eOmJDv/1MsWzXx6+qy8bJD2ojX4ww9x1LxXi
         WRQw27EpgBUqq8EFxHxMYPcdHtMSfVQzED/3fNmAXzi8H4uJAOqfvd9ZtHPCxKKfJPwQ
         +85baiVXHA+95y9y/YGNuqNNFdoOVaIbYzro1McDY5CeuKrgIZlox/T3r6c7PuYJdlYq
         w2vj2oIuo8JQ/TDpl5FmCrnAJetYHsbRKZv5yk/e9invlwhrrZ4DGEpqm7r2eI8YRfuw
         +3sZkP9M3IzilzilChsND3ysyUoAKfDHWkc05L+oIhNpVXwL8wOLTR7PABMVo1/sosPh
         J9Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=KKJnKCK6y9DsupscYWX+JVOuCgFe+8mfh1r5Xtw9nwM=;
        b=NsDz2mbMIFv9VJR91jcaV9tGwKRDYYK/WAhyPmyhYH3OHlo3/8idB94D0X2F08k6VH
         U55SE1OXue4bnyuz/rR3bc5Sj1FB3xWjxeSmY5oDSSuAfyAQ0XTENU1phPQ38FNy78Mt
         Lgd/trN8XekezkWY3XWNg6aTIeVpgTz2BEc7GRH6Wg2TMmpsrxOXBR5TcF+OrKk2c9Pg
         9zxzNCBd++dlXNAA+UHLUMB7gHhMt18085/cfpH7o3VazwfeyHwqa/TkDe/nMxAtT37J
         zxrptMMBmTD5yF8GYpwBByPia+oZdlSvM8FrVsW8vx6tgaiuWYDBdE/ggxx9UoHIidFz
         VNWg==
X-Gm-Message-State: AGi0PuaHgn8e4LLmvCET95PqJe/6e9cMJ0BR8QsMmgLKftKQXSGB17fZ
        HVuBH5bg9LZhxSIGqpWfSE3IYuyZi4TQrhdORVb2sP/3hT8=
X-Google-Smtp-Source: APiQypLE+Dzmy5ZBQcCnMUFMMHOK6f4amPEDE0TUjiu55Iq3S7VNmFy11Jtd5MgR1HuOvE1SiIMg6ju3Igz29l9FzQU=
X-Received: by 2002:a37:95c6:: with SMTP id x189mr10070730qkd.19.1585940159492;
 Fri, 03 Apr 2020 11:55:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAN_LGv1h8Ut4bGm7ZgYaGV_Tbdy3ABW+epb_p6jeX=TxnAvH1g@mail.gmail.com>
In-Reply-To: <CAN_LGv1h8Ut4bGm7ZgYaGV_Tbdy3ABW+epb_p6jeX=TxnAvH1g@mail.gmail.com>
From:   "Alexander E. Patrakov" <patrakov@gmail.com>
Date:   Fri, 3 Apr 2020 23:55:48 +0500
Message-ID: <CAN_LGv2ujqBWQv_f5Co0-hMtBedgCcqRRzpJ7mc1DMW+FaqhqA@mail.gmail.com>
Subject: Re: tc-cake(8) needs to explain a common mistake
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 3, 2020 at 11:44 PM Alexander E. Patrakov
<patrakov@gmail.com> wrote:
>
> Hello,
>
> there is a recurring cargo cult pattern in many forums (e.g. OpenWRT):
> people keep suggesting various overhead compensation parameters to
> tc-cake without checking what's the bottleneck. They just assume that
> it is always related to the link-layer technology of the connection.
>
> This assumption is mostly incorrect, and this needs to be explained in
> the manual page to stop the cargo cult. E.g., here in Russia, in the
> past year, I had a 1Gbit/s link (1000BASE-X) but they shaped my
> connection down to 500 Mbit/s because that's the bandwidth that I paid
> for. I.e. the link from my router to the ISP equipment was not the
> bottleneck, it was the ISP's shaper.
>
> How about the following addition to the tc-cake(8) manual page, just
> before "Manual Overhead Specification"? Feel free to edit.
>
> General considerations
> -------------------------------
>
> Do not blindly set the overhead compensation parameters to match the
> internet connection link type and protocols running on it. Doing so
> makes sense only if that link (and not something further in the path,
> like the ISP's shaper) is indeed the bottleneck.
>
> Example 1: the ADSL modem connects at 18 Mbit/s, but the ISP further
> throttles the speed to 15 Mbit/s because that's what the user pays
> for, and does so with a shaper that has bufferbloat. Then, the "adsl"
> keyword is likely not appropriate, because the ISP's shaper operates
> on the IP level. The bandwidth needs to be set slightly below 15
> Mbit/s.

Self-correction: there is no "adsl" keyword. Let's replace it with
"pppoe-llcsnap" (the most common setup), or: "ADSL overhead keywords
are likely not appropriate".


> Example 2: the ADSL modem connects at 18 Mbit/s, and the user pays for
> "as fast as the modem can get" connection. Then, the "adsl" keyword is
> relevant, and the bandwidth needs to be set to 18 Mbit/s.

Same here: "one of the ADSL overhead keywords is relevant".

> Example 3: the user has a 100BASE-TX Ethernet connection, and pays for
> the full 100 Mbit/s bandwidth (i.e. there is no shaper further up).
> Then, the "ethernet" keyword is relevant, and the bandwidth needs to
> be set to 100 Mbit/s.
>
> --
> Alexander E. Patrakov
> CV: http://pc.cd/PLz7



-- 
Alexander E. Patrakov
CV: http://pc.cd/PLz7
