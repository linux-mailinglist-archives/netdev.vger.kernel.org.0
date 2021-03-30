Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E3434DF1E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 05:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhC3DSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 23:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbhC3DRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 23:17:33 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CD0C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 20:17:33 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id i19so10956765qtv.7
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 20:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=rjPExMtYs1kqjt/CTaWBz7aoN1AIX0rSeL0R8pOiRiw=;
        b=TItwIoirGK+SHdG+Qx6NohvyLbkhBnPOZpneXQ08I2OL3Vfr1u9Iy2ZXnZZrAQbNVg
         yWQ+l9p3k+Y2i2rC+h6Y7EigVKUZAt4erNo9SEInYGrVhS9wYik7zxvT+wI7XKUupSoG
         DIjkdM/MSfKTZiZwJiodZjIVXCUTUAH9Q+ffE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=rjPExMtYs1kqjt/CTaWBz7aoN1AIX0rSeL0R8pOiRiw=;
        b=h0dYu6hXE6IDpbbZ114y9AcYe190/heLbJD1HVSppITGcChK+RNvl3xaSd/JUlvcEa
         BKLsGwQ8pYpSUFfH0xFZIyv8pZcivEsyUELXugIuIu4kBBvutAQQlZxmC1yrizCb4BN4
         wfLkY3a1fUcN5w6TYF5iZctwTVfO1hdnbdi0mjGH/YglAS7EEngxKVNyEC0dHdyBRBM8
         f2lv+PpkLonM5Nu9oKboAWF//fQT3JhaZa4Ews39R0Tim2rhIfGZhhUqyD3IsKTQ7YZg
         jkZE32DruH24VKK4T24Q3LPlJenSkHZizOU7wzEL+HiE+UJcUzSg6sbz96vhCC3E0Kwb
         UcVA==
X-Gm-Message-State: AOAM532XSk1NwkJ1C7+Fe4pCcvJL2wYooFIpLlLvwEFTHNSJ9Tho+nOF
        ubVCNY9r2G6M+qmTTB1M5kbn3Q==
X-Google-Smtp-Source: ABdhPJxxs7X6dCxb/vDWXMkOiyCanb6zOud7chyYZv+Kv+2yb3yktKcWguLLi8/qPM7uKa7eoG7yDA==
X-Received: by 2002:ac8:6f25:: with SMTP id i5mr26221392qtv.202.1617074252368;
        Mon, 29 Mar 2021 20:17:32 -0700 (PDT)
Received: from [192.168.1.33] (047-028-046-055.res.spectrum.com. [47.28.46.55])
        by smtp.googlemail.com with ESMTPSA id y1sm15015318qki.9.2021.03.29.20.17.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 20:17:32 -0700 (PDT)
From:   Doug Brown <doug@schmorgal.com>
To:     linux-firmware@kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC] (re)moving drivers/net/appletalk/cops_*.h firmware blobs
Message-ID: <6c62d7d5-5171-98a3-5287-ecb1df20f574@schmorgal.com>
Date:   Mon, 29 Mar 2021 20:17:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi there,

I've been recently looking at the (ancient) AppleTalk/LocalTalk drivers=20
because I've been working on a modern LocalTalk network adapter for=20
crazy vintage computer enthusiasts like myself. ;-) In the process, I=20
discovered the existence of cops_ffdrv.h and cops_ltdrv.h in the kernel=20
source tree (drivers/net/appletalk), which contain proprietary binary=20
blobs for old COPS LocalTalk ISA cards with pretty vague licensing in=20
terms of ability to redistribute:

> This material is licensed to you strictly for use in conjunction with
> the use of COPS LocalTalk adapters.
> There is no charge for this SDK. And no waranty express or implied
> about its fitness for any purpose. However, we will cheerefully
> refund every penny you paid for this SDK...
> Regards,
>
> Thomas F. Divine
> Chief Scientist

I was surprised that these blobs were still in the kernel source. I=20
think it would be nice to remove another set of nonfree blobs from the=20
kernel source tree. Sadly, Mr. Divine passed away in 2015, so we can't=20
get any further input from him. Is this license acceptable enough to=20
migrate these two firmware binaries to linux-firmware and change the=20
driver to use request_firmware? Following the process in the=20
linux-firmware README to a T is likely not 100% possible because there's =

nothing about permission to redistribute, and I won't be able to get a=20
Signed-off-by line. I've been experimenting in QEMU to convert the=20
driver to use request_firmware and have something working, but I wanted=20
to check before submitting a firmware pull request to start going=20
forward with this. Alternatively, if that's not acceptable, would it=20
make more sense to follow the route of other drivers like the iSight=20
camera driver (drivers/usb/misc/isight_firmware.c), and use=20
request_firmware, but supply instructions for extracting the firmware=20
binaries from the original source instead of including them in=20
linux-firmware? They are still available through archive.org's old=20
capture of the (now defunct) company's website, so instructions could be =

provided for downloading and extracting it yourself.

To be honest though -- the whole thing is probably a moot point given=20
that the driver in question is for an ISA card. Is there really someone=20
out there still using this driver? With that in mind, I suppose another=20
option would be to remove the driver altogether. I was hoping somebody=20
could provide some input on the correct way to handle this situation. I=20
would be happy to take care of it, but I'm unsure of the correct=20
approach. Any direction would be much appreciated!

Thanks,
Doug

