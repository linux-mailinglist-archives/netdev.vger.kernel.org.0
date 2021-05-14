Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26936380665
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 11:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbhENJmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 05:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhENJmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 05:42:24 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C12C061574;
        Fri, 14 May 2021 02:41:13 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2so42269004lft.4;
        Fri, 14 May 2021 02:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:message-id:in-reply-to
         :date:mime-version;
        bh=4hJ30fWm7RsO0kSIGl3Kayg5yiFXwH8nUEOvArTykrw=;
        b=JWfge9nV+InBvM/EqnUoT17zmBJrrcEYdUMZFuy2pBar94wt8pbm0ex0KHR5MGIdRb
         cG8C6+3RksoWIOxXX40Rm3cTQP9u0cmXjetTRRbG4WWLFTKIk3az5Zxn5Dtwc7T+JaGY
         A5s8hxucjaZux4/fKmhmeWxB8lPanTU4jIwlad8ugLPZYyjhPbZWlfhZnur9KDB+mn9J
         EROpLxxC29VFPLB3bOpWAhzOks40xm0u3pMy6yz2WZoI5TlGT2YudX6TwI5YvWGp47Lx
         0uJm/oMY4BUioBogl5H//2bRw2JGH1rurgfuoubI0xc2sdPCFGnURml4RY99b7DMfWSl
         eR4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :message-id:in-reply-to:date:mime-version;
        bh=4hJ30fWm7RsO0kSIGl3Kayg5yiFXwH8nUEOvArTykrw=;
        b=pGKWNNWa4uzWDBlfmAyPSij58UMRJAsix6iqKqNFhhwBRwt2SeRQJE9PJZOUQoHRRJ
         L91M1evqCQtsy4xfiBrfYMxMPx0syzL3fQoCyb7Jy2/UjZNQbZ8RN/sRHtfnLUyQlqBe
         uMM3NgADTxG/L6+Rm+C8nBxGId441OKwC5aXulASfzMS3cmjW/mNk+zprPU7I3Tl2KRj
         h9druBcK3cKYwUSDzEWMcrujluSMP/NWExG803L/P4q/qI0MIU9zlo77seQCdVy4lEVq
         RDd73YBnYIDaJRxCUpj2f528onlraFCx06+MjXEKKNeP1ur65PGLszi39uJbnfTV8/Fu
         KnCg==
X-Gm-Message-State: AOAM530E/zisWNl/tcbwPfxEuPtisM2gPwXmE2fgXQ92Pl2E9NnieWfn
        /yd4VBTOtsfYDhnKHAwm3iMVl2oGrMy75g==
X-Google-Smtp-Source: ABdhPJzGtR4iLxVX/JBgdp47GxPmPWYdSsrh2l3S0kd2tJNdcrJnTbBpfhlOamj1REe5h6B4Y3JBng==
X-Received: by 2002:a19:380e:: with SMTP id f14mr31332115lfa.538.1620985271237;
        Fri, 14 May 2021 02:41:11 -0700 (PDT)
Received: from razdolb ([85.249.34.38])
        by smtp.gmail.com with ESMTPSA id x25sm584799lfu.181.2021.05.14.02.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 02:41:10 -0700 (PDT)
References: <20210509233010.2477973-1-mike.rudenko@gmail.com>
 <d1bac6c3-aa52-5d76-1f2a-4af9edef71c5@broadcom.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Mikhail Rudenko <mike.rudenko@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Double Lo <double.lo@cypress.com>,
        Remi Depommier <rde@setrix.com>,
        Amar Shankar <amsr@cypress.com>,
        Saravanan Shanmugham <saravanan.shanmugham@cypress.com>,
        Frank Kao <frank.kao@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: use separate firmware for 43430 revision 2
Message-ID: <87a6oxpsn8.fsf@gmail.com>
In-reply-to: <d1bac6c3-aa52-5d76-1f2a-4af9edef71c5@broadcom.com>
Date:   Fri, 14 May 2021 12:41:08 +0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-05-10 at 11:06 MSK, Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
> On 5/10/2021 1:30 AM, Mikhail Rudenko wrote:
>> A separate firmware is needed for Broadcom 43430 revision 2.  This
>> chip can be found in e.g. certain revisions of Ampak AP6212 wireless
>> IC. Original firmware file from IC vendor is named
>> 'fw_bcm43436b0.bin', but brcmfmac and also btbcm drivers report chip
>
> That is bad naming. There already is a 43436 USB device.
>
>> id 43430, so requested firmware file name is
>> 'brcmfmac43430b0-sdio.bin' in line with other 43430 revisions.
>
> As always there is the question about who will be publishing this
> particular firmware file to linux-firmware.

The above mentioned file can be easily found by web search. Also, the
corresponding patch for the bluetooth part has just been accepted
[1]. Is it strictly necessary to have firmware file in linux-firmware in
order to have this patch accepted?

--
Regards,
Mikhail

[1] https://lore.kernel.org/linux-bluetooth/E8A21908-1D48-4B89-8A88-7E82A71E0DA4@holtmann.org/
