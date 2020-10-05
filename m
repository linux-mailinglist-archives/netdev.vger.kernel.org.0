Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93799283202
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 10:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgJEI3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 04:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgJEI3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 04:29:16 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC335C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 01:29:15 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id 77so9840235lfj.0
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 01:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Ku0CokxAPcst30HPlsG0+0mZ1rLT+0c4rE2SQM2emg=;
        b=nzPE5xCPfWSXPq2fGOc7Wd6+C/3EW1UTdEEw2+pUcLvC/7R8Q3/HkYSkTpjsknel9R
         jlIg4PCRD7z+k9uyALFy+7qeYc4oEpXUj/PdgiEH0SN6hDLuofF6OC8lqejMZxGgG+yK
         xErZPkex2WpKX8ymjUGX+ZeHBzvzIY+bDyAvfCyjXNy0qCNdEGIeDaroT3uk5FYAxsXa
         6fKLiWOaF6ISat0V75Sed29/oly1bk77hZqWLyObnVPrt8cIgg94SPplMseo0aMiuGru
         xS9PQH39pU4Woq2AsQ4XZ1rBG5Bpmku0cwzMOtMeEvJTeuAnP+RjOnk+DG0IsG+NGy46
         FuVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1Ku0CokxAPcst30HPlsG0+0mZ1rLT+0c4rE2SQM2emg=;
        b=mGM3R7jGQBo1gg7LHSJ5CNTiaHpw8Saz5DydPJJ0cYSF822gId1rR9h/SOB0gbvUDp
         FBxNdzpBkb9XP9kqEJmR8z7o+JlXjs8V0lB07alemdrbLUHjBKn3vjuieIPRh/oQywmq
         WBHpUByCMLL+C8+wCvrO7PUzE8JCFgs6QX8SRObpRJtoL3pIsUzJ4oop9F5MbP1BUCFh
         jcrxh2sBWBl05MUCDYmP0RW36PeZeH2JQVD/PpH/zWzyiq0AtJ1FrkmaOg7oMdBRh0sz
         91BlfJJyULxN2e/J8SX2oTexiEBLEMzL+hBqJlW0vHeexv6XkoI26eVlX7R3VjsRWVpG
         A5qw==
X-Gm-Message-State: AOAM533bcX0w39wawtxc5R9QA72gv+fmtQJaUKeWu9QWjRTAvZ43looj
        9QMZqou++X4dhFTNZ4CynRQjGs/ODi/1ng==
X-Google-Smtp-Source: ABdhPJxm5NDaHc/XmpxDlzBmpSGY3z5xZZpSjDOAOg3hS7dnlBaybROCPHX5wyfQTTNUsa82WA5XmA==
X-Received: by 2002:ac2:58e2:: with SMTP id v2mr5557725lfo.95.1601886553656;
        Mon, 05 Oct 2020 01:29:13 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:4243:cb6e:511a:3b1e:4724:c779? ([2a00:1fa0:4243:cb6e:511a:3b1e:4724:c779])
        by smtp.gmail.com with ESMTPSA id g16sm1435129lfd.59.2020.10.05.01.29.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 01:29:13 -0700 (PDT)
Subject: Re: ravb ethernet failures in 4.19.148 and -cip kernels
To:     Pavel Machek <pavel@denx.de>, ashiduka@fujitsu.com,
        davem@davemloft.net, yoshihiro.shimoda.uh@renesas.com,
        damm+renesas@opensource.se, tho.vu.wh@rvc.renesas.com,
        kazuya.mizuguchi.ks@renesas.com, horms+renesas@verge.net.au,
        fabrizio.castro@bp.renesas.com, netdev@vger.kernel.org
Cc:     Chris.Paterson2@renesas.com
References: <20201004212412.GA12452@duo.ucw.cz>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <1de9715e-345d-ebcd-5268-8b4e20bcb38c@gmail.com>
Date:   Mon, 5 Oct 2020 11:29:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201004212412.GA12452@duo.ucw.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 05.10.2020 0:24, Pavel Machek wrote:

> It seems
> 
> commit fb3a780e7a76cf8efb055f8322ec039923cee41f
> Author: Yuusuke Ashizuka <ashiduka@fujitsu.com>
> Date:   Thu Aug 20 18:43:07 2020 +0900
> 
>      ravb: Fixed to be able to unload modules
> 
> causes problems in at least -cip-rt kernels. (I'd have to verify it is
> present in -cip and plain -stable). Symptoms are like this:
> 
> [    2.798301] [drm] Cannot find any crtc or sizes
> [    2.805866] hctosys: unable to open rtc device (rtc0)
> [    2.811937] libphy: ravb_mii: probed
> [    2.821001] RTL8211E Gigabit Ethernet e6800000.ethernet-ffffffff:00: attached PHY driver [RTL8211E Gigabit Ethernet] (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=190)
> [    2.838052] RTL8211E Gigabit Ethernet e6800000.ethernet-ffffffff:00: Master/Slave resolution failed, maybe conflicting manual settings?
> [   12.841484] Waiting up to 110 more seconds for network.
> [   22.853482] Waiting up to 100 more seconds for network.
> [   32.865482] Waiting up to 90 more seconds for network.
> [   42.877482] Waiting up to 80 more seconds for network.
> [   52.889482] Waiting up to 70 more seconds for network.
> [   62.901482] Waiting up to 60 more seconds for network.
> [   72.913482] Waiting up to 50 more seconds for network.
> [   82.925482] Waiting up to 40 more seconds for network.
> [   92.937482] Waiting up to 30 more seconds for network.
> [  102.949482] Waiting up to 20 more seconds for network.
> [  112.961482] Waiting up to 10 more seconds for network.
> [  122.861490] Sending DHCP requests ...... timed out!
> [  209.890289] IP-Config: Retrying forever (NFS root)...
> [  209.895535] libphy: ravb_mii: probed
> [  209.899386] mdio_bus e6800000.ethernet-ffffffff: MDIO device at address 0 is missing.
> [  209.910604] ravb e6800000.ethernet eth0: failed to connect PHY
> [  209.916705] IP-Config: Failed to open eth0
> [  219.925483] Waiting up to 110 more seconds for network.
> [  229.937481] Waiting up to 100 more seconds for network.
> [  239.949481] Waiting up to 90 more seconds for network.
> [  249.961481] Waiting up to 80 more seconds for network.
> 
> Full log is available at
> https://lava.ciplatform.org/scheduler/job/56398 .
> 
> Reverting the above patch fixes the problems.

    Geert has already reverted that patch:

https://patchwork.ozlabs.org/project/netdev/patch/20200922072931.2148-1-geert+renesas@glider.be/

> If you have any ideas what could be going on there, let me know.

    Unfortunately, I'm unfamiliar with the Realtek PHY driver...

> Best regards,
> 									Pavel

MBR, Sergei
