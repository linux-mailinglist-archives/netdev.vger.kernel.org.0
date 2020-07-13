Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A52621DB11
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbgGMQAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730258AbgGMQAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:00:38 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE214C061755;
        Mon, 13 Jul 2020 09:00:38 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b4so12647255qkn.11;
        Mon, 13 Jul 2020 09:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ojmtWuhoXE+10Oa37xZFid38Sh0C/r73ASNaf7SWHQ=;
        b=BcFsCnGYuhwgC0vVkdD/AnoRcC7YBT5Yjs0ZBhG9O2O/o2aF4ReqQps/ZfiOOvBgqA
         7TdbWPHptfqtgF9lXpYr4UxcFudH5gBaIH/lvw9V3sn3BS+xUBL02sVcjXSB2YuZKw4L
         Qg3Brl1eV+oFR0a/Suuw6b7G80waQicfv/86XRVeTZxW+RLHsvp0kR5BvFzhduGoQP4y
         DfgQ0jH1/4ZG5a8Rosa40+gmhV1/SyAP869DHnNzsAM6MKWO4WJlgqklInJV7BNe/yBt
         HaTlBYiY64hQcsMNoCWwXEJW8X72aeF7M4Dx9PXWA6r29kq2Of84dHw49ndrZklGetjK
         FQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ojmtWuhoXE+10Oa37xZFid38Sh0C/r73ASNaf7SWHQ=;
        b=sEHoXYHv084Pfzm1OaO/tPXb/S3puYfaR90/KmWbfABztkS5ZvUnUIIMlUvc9nvVMt
         XS+aPRgjYM9fvwabgwEq7/ckaLIWihTxqSsQ7LnjzOzjxnP3qkTSTBCEkUQP4Esoivc1
         VBGMp27D8ZnPVpWc8OWafBglZY6mmHAKI15wFQTcTQ9OUD82eqgFFgZwhesrfHm/Yz5p
         yY4WxlUpMPbA1xzUqUkHXqRwfOaMyp/SmXU52z2ujBo8FwM2BuQKP5XA9TFyMjpYAWAt
         uyZt2aALJ12xVKlRLeEXC+VxLHfkDgVNtIyr8wJQWMDieJwU32OJ4LWgYBLt41bXKanA
         T32w==
X-Gm-Message-State: AOAM5330HL44k6df1aB1NoqtVzW9ZIoZ8/k/wdWNakwC1V136TAAR4nl
        j2dxxm0G+YbHkDFM00JzpR8pGSMqg4eCwJrDZqw=
X-Google-Smtp-Source: ABdhPJwhM3ZE0lj3C9bvbV7DNY7AXaVeMAwiOMd7/7ldDQfk666wq76gTljckR5j86QwsbuotoGufWvliS8VdCV7FaY=
X-Received: by 2002:a05:620a:1674:: with SMTP id d20mr248343qko.131.1594656038015;
 Mon, 13 Jul 2020 09:00:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200705195110.405139-1-anarsoul@gmail.com> <20200705195110.405139-2-anarsoul@gmail.com>
 <DF6CC01A-0282-45E2-A437-2E3E58CC2883@holtmann.org> <CA+E=qVeYT41Wpp4wHgoVFMa9ty-FPsxxvUB-DJDnj07SpWhpjQ@mail.gmail.com>
 <70578F86-20D3-41C7-A968-83B0605D3526@holtmann.org>
In-Reply-To: <70578F86-20D3-41C7-A968-83B0605D3526@holtmann.org>
From:   Vasily Khoruzhick <anarsoul@gmail.com>
Date:   Mon, 13 Jul 2020 09:00:11 -0700
Message-ID: <CA+E=qVf_8-nXP=nSbtb49bF8SxF6P_A+5ntsUHKKmONccwkSwA@mail.gmail.com>
Subject: Re: [PATCH 1/3] Bluetooth: Add new quirk for broken local ext
 features max_page
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        arm-linux <linux-arm-kernel@lists.infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 12, 2020 at 11:28 PM Marcel Holtmann <marcel@holtmann.org> wrote:

Hi Marcel,

> maybe just the read sync train params command is broken? Can you change the init code and not send it and see if the rest of the init phase proceeds. I would rather have the secure connections actually tested before dismissing it altogether.

I don't think that I have any devices that support secure connections
to test, I've got only a bluetooth mouse and headphones, both are from
the 2.0 era.

FWIW unofficial recommendation from Realtek to Pine64 was to avoid
using any 4.1+ features on this chip. Unfortunately I don't have any
contacts with Realtek, so I can't confirm that.

> Mind you, there were broken Broadcom implementation of connectionless slave broadcast as well. Maybe this is similar.

I'd prefer to stick to what works unless there's some comprehensive
test that can figure out what's broken.

Regards,
Vasily
