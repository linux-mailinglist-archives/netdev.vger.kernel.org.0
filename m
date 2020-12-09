Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A652D38CB
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 03:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgLICYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 21:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgLICYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 21:24:52 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84354C0613D6
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 18:24:12 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id a109so807492otc.1
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 18:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IVhVAzVlHgf5EMTYAVFmdMVuP6gKcxWiSjMj/6sCke8=;
        b=cbl78jlbGfxrmwvvVR4XsCQW2VJ7oTVc/EkwDAfq6YbJLJzep2vJLX6wSDa29R6UI0
         cj6AEf4dUXmMTjFIkTgzvNihfdaHG0QKyTNW/BFR4ir7kFrH0Uspox+Z8FuiMWMpVWu0
         gI4TPdsf7TfHSx4hfHM6I6Z26Z7jdWE5lFtL4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IVhVAzVlHgf5EMTYAVFmdMVuP6gKcxWiSjMj/6sCke8=;
        b=uJkXDk0zcfjs9kKjR8XuTZJy9yCtrQIlSLy56Oi7fkl9trgnppKSDwN19VWP4c4D7k
         2Ffj1MJxVNci/uLySXhhy8Dmz6cL8SG7PHQdMgOUO+Bo/siv0Tefcuz6CZ+zKMUQbb1Q
         BRzKwPAQLG2UOA7FTwIJdpjsmvYiqkTTZmKIJpvo4Yenh2iDkp/w3QA5pQVvIw81hqf9
         HipbJOVQ2H8emTANJU8tCie3M2jx5MR35suESMlqmgLz1pjV5Jht1A4pEnpwpGOFMBhy
         eNdvA6hv8S5gtSaQ8TwkSsZVxQoGZUw9W712S8sY7wvbflv9MPDCKmNt8WRxoOem1kh6
         14fA==
X-Gm-Message-State: AOAM533ZJ+Xzs2/nqt2VA8t+4xXrySZx7O0z518ET5L1kACyQfvn+CUR
        9u6n6rumXxwlDb6hN1erZH/b3ik/ldAW5Q==
X-Google-Smtp-Source: ABdhPJwxnMOG1u4N8zYixyPnX6ZSHMQGLrrMN1VR8iGkY9aNC3z2q/HCaLlsZvzYXJbWik8B5qGzGw==
X-Received: by 2002:a9d:892:: with SMTP id 18mr43585otf.9.1607480651607;
        Tue, 08 Dec 2020 18:24:11 -0800 (PST)
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com. [209.85.167.179])
        by smtp.gmail.com with ESMTPSA id a25sm34746oos.23.2020.12.08.18.24.09
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 18:24:10 -0800 (PST)
Received: by mail-oi1-f179.google.com with SMTP id 15so144019oix.8
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 18:24:09 -0800 (PST)
X-Received: by 2002:aca:6502:: with SMTP id m2mr267037oim.105.1607480649316;
 Tue, 08 Dec 2020 18:24:09 -0800 (PST)
MIME-Version: 1.0
References: <20201203185732.9CFA5C433ED@smtp.codeaurora.org>
 <20201204111715.04d5b198@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <87tusxgar5.fsf@codeaurora.org> <CA+ASDXNT+uKLLhTV0Nr-wxGkM16_OkedUyoEwx5FgV3ML9SMsQ@mail.gmail.com>
 <20201207121029.77d48f2c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com> <bd5f9ded-e575-705b-a56b-a92f7765235f@gmail.com>
In-Reply-To: <bd5f9ded-e575-705b-a56b-a92f7765235f@gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 8 Dec 2020 18:23:57 -0800
X-Gmail-Original-Message-ID: <CA+ASDXMv1jhJP6PZar7-R5WMBe-h+4tRcZ_M1k7sZT9_XUXQLQ@mail.gmail.com>
Message-ID: <CA+ASDXMv1jhJP6PZar7-R5WMBe-h+4tRcZ_M1k7sZT9_XUXQLQ@mail.gmail.com>
Subject: Re: pull-request: wireless-drivers-next-2020-12-03
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 8, 2020 at 7:01 AM Edward Cree <ecree.xilinx@gmail.com> wrote:
> My understanding is that it's because users can have them in their
>  modprobe.conf, which causes breakage if an update removes the param.
>  I think the module insert fails if there are unrecognised parameters
>  there.

That's a nice understanding, but I believe it's an incorrect one:

# echo 'options rtw88_pci doesnotexist=helloworld' >> /etc/modprobe.d/rtw.conf
# modprobe rtw88_pci; echo $?
0

In fact, while I was already quite aware about the removal Jakub is
highlighting (in the rtw88 driver), I was a user of the parameter, and
was quite happy to see it die (because now the driver does the Right
Thing automatically). I still left the option in my modprobe.conf,
while I finished staging upgrades of all my systems. I ran into no
problems, and now that the migration is done, I killed the
modprobe.conf entry.

Brian
