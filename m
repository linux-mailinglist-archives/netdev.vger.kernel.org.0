Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270E966A27E
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 20:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjAMTAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 14:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbjAMS7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 13:59:54 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C404551FC
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 10:59:50 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id s10-20020a4aa54a000000b004f240f120b3so1959602oom.1
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 10:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=landley-net.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bTIDomgS8mXkDJCvxm5Zm+LjWmMOagP4MCI8VhlfZ4M=;
        b=PS9bts8WEYUdHc2dq03MseWIdo5SmkGasWJ1IHK/82VNd2x1nauvFpnIRKJHReewV4
         qHgmemCtG+n4JzEug1j/TkXXGr7XuvlNF4IBzbNfnN6lagwFrOKhEymKlD3N/LDBaGvv
         sKYDqBaLKXsSv5VTvSWrpB1Ro6mV2B1zSTvwS3WrXPPhGJgdWKpIwnEsYL1x49CphPxG
         SL4YOgYdR5jGUY39ZZius3Ig7i4WfTYOC67k8Vh1lto4GbCgV9uKa97KEalM5EmLMGPn
         3yGQHE93+pmLVFjd1TlIZLJrfjBmFeNgyn5vD6/2wKe8LZIYKJC7joRnrftdzonfyS0K
         +t4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bTIDomgS8mXkDJCvxm5Zm+LjWmMOagP4MCI8VhlfZ4M=;
        b=JRPk/qHXaS9OiW61+ffKId09ZZnAdmAzDdBU+kkzd0+ar/hyajtkGatsOXAyqRcrWs
         DeM15YnKlKddhjhEU7ihC8cq72aTBy9Sn16/21xmii9uU0IJ8m5mQ9DxGhs3U6B8vE5s
         2ZXMJXdn8IMwOK62kWlUiPGzzZ+4x4oXbVqkr7VhKPfGDG5ET6NnsJRYz+0E4FDy88Gf
         NmxVhW2AmcMCrf2iwVbHrEAmUatLfdev80ZHkNYuq1iw+aDpH4EzDn+U4/38arvRsefn
         +WgxJd0DqFQrVDafsTVA0gNvuB1Ya3Es1g/+jCxDXTi39+DhtEiKqKKtEAOu+YXzO2Cj
         OwTg==
X-Gm-Message-State: AFqh2kot48aoG+W+0PBR1/qd/YelQkLSD5BuBCdYtOvta2+W2M+D2UlS
        zXUQLV3PorLvV98G2HDbfZxjWQ==
X-Google-Smtp-Source: AMrXdXvaOiO0G10Az4EGLc64Vx6N+KrZr3PuLGXv0M+M3iF7lrA3WUc8R2fIq6AYtp8ZC6Mk4E9lCQ==
X-Received: by 2002:a4a:c594:0:b0:4e7:5d43:a654 with SMTP id x20-20020a4ac594000000b004e75d43a654mr22358114oop.0.1673636389556;
        Fri, 13 Jan 2023 10:59:49 -0800 (PST)
Received: from [192.168.86.224] ([136.62.38.22])
        by smtp.gmail.com with ESMTPSA id bc31-20020a056820169f00b0049f8b4b2095sm10111163oob.44.2023.01.13.10.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 10:59:48 -0800 (PST)
Message-ID: <6891afb6-4190-6a52-0319-745b3f138d97@landley.net>
Date:   Fri, 13 Jan 2023 13:11:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: remove arch/sh
Content-Language: en-US
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
References: <20230113062339.1909087-1-hch@lst.de>
 <11e2e0a8-eabe-2d8c-d612-9cdd4bcc3648@physik.fu-berlin.de>
 <CAMuHMdUcnP6a9Ch5=_CMPq-io-YWK5pshkOT2nZmP1hvNcwBAg@mail.gmail.com>
 <142532fb-5997-bdc1-0811-a80ae33f4ba4@physik.fu-berlin.de>
From:   Rob Landley <rob@landley.net>
In-Reply-To: <142532fb-5997-bdc1-0811-a80ae33f4ba4@physik.fu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/13/23 02:52, John Paul Adrian Glaubitz wrote:
> Hi Geert!
> 
> On 1/13/23 09:26, Geert Uytterhoeven wrote:
>> Indeed.  The main issue is not the lack of people sending patches and
>> fixes, but those patches never being applied by the maintainers.
>> Perhaps someone is willing to stand up to take over maintainership?
> 
> I actually would be willing to do it but I'm a bit hesitant as I'm not 100%
> sure my skills are sufficient. Maybe if someone can assist me?

My skills aren't sufficient and I dunno how much time I have, but I can
certainly assist. I test sh4 regularlyish and it's in the list of architectures
I ship binaries and tiny VM images for, just refreshed tuesday:

https://landley.net/toybox/downloads/binaries/0.8.9/
https://landley.net/toybox/downloads/binaries/mkroot/0.8.9/

(The sh2eb isn't a VM, it's a physical board I have here...)

There is definitely interest in this architecture. I'm aware Rich hasn't been
the most responsive maintainer. (I'm told he's on vacation with his family at
the moment, according to the text I got about this issue from the J-core
hardware guys in Japan.)

The main reason we haven't converted everything to device tree is we only have
access to test hardware for a subset of the boards. Pruning the list of
supported boards and converting the rest to device tree might make sense. We can
always add/convert boards back later...

Rob
