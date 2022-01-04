Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA01C4846F9
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbiADR1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiADR1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 12:27:31 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C84C061761;
        Tue,  4 Jan 2022 09:27:31 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id j11so81475296lfg.3;
        Tue, 04 Jan 2022 09:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oEpnYAm67CBx/UycGy4K6PJ7NPnBfxvjloHj5Duq34Q=;
        b=nVw2UAiB6xthSU977wls63qlOy/xOCnv8ZomXUTgIWL3zEdNoc6OyFtMlm/cOvg6r1
         dLEi7/HHba0k9iYS016eh5ZjvBEzd7vqYDI0vg97d/IuEHhun7CJF7zRZBJ6RRuXl9He
         QtaqH8xW++i7QlRATLPVS2VQq7QfjMYfdQvYQr1b11Dr4w+DL3vt7qrr1QSfCAMBd5FO
         Lkf25fOMuhaHgUE3Q7i/sz56iBYNGxqk22eIcATQiWvZMFoCExIuJjef8YH2DwKu/x+1
         FGaYiigyNFSMXgC239AE/mXgjfV9OOZHiuWxw5gwVR4iR5k9RWc7HXclCkOKMqCRX7ZI
         nszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oEpnYAm67CBx/UycGy4K6PJ7NPnBfxvjloHj5Duq34Q=;
        b=gbOc14JDbv2BQEyYNAFoO09Dw8mPEsnnRiQXZ8b6OpC6jgraAYVEsVAezaR2vNiVdA
         Y8G+Fom0roYxyJHMa7m/qkUCDCoK1EtkcrydvaXuZD0Sud32hmx0B/uAGCn43KymCaWR
         WTkDbp3B4QzkkFL0fm2M5jWMIkCxaWKWJyWaQti8GLZdB92jtoDcvOub1W8yAtOUt5Ho
         H1l+J2oJQn+J/iHysRSTKDqfaOjRfjCwA3Ii2h5GaQi3xr4HMa82Gl9rYiJzvoFjaPvm
         hjP6mdMVQFFavIrTtJAchWb7IWPtSRgz0Xl0UNHfcqpNptS0D0ezEb8eNrYXdhmDmjDa
         QUqw==
X-Gm-Message-State: AOAM531oymOJnrBwUfRzE9LF96/Fc7hR8BuDqspHhbmReHJOVwN9NR7Z
        rLyp55og+9Jkcwh2D23Qi0s=
X-Google-Smtp-Source: ABdhPJzcTWddpB4EQvW94F90YPyJtOXWx2ZegvKevNmhAZzYtRfDTtyzybQXGcnD+0YnfK/2who+zg==
X-Received: by 2002:a05:6512:3056:: with SMTP id b22mr41917697lfb.142.1641317249615;
        Tue, 04 Jan 2022 09:27:29 -0800 (PST)
Received: from [192.168.1.11] ([94.103.235.38])
        by smtp.gmail.com with ESMTPSA id br34sm3949699lfb.305.2022.01.04.09.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 09:27:29 -0800 (PST)
Message-ID: <5b0b8dc6-f038-bfaa-550c-dc23636f0497@gmail.com>
Date:   Tue, 4 Jan 2022 20:27:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v2] ieee802154: atusb: fix uninit value in
 atusb_set_extended_addr
Content-Language: en-US
To:     Stefan Schmidt <stefan@datenfreihafen.org>, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Potapenko <glider@google.com>
References: <CAB_54W50xKFCWZ5vYuDG2p4ijpd63cSutRrV4MLs9oasLmKgzQ@mail.gmail.com>
 <20220103120925.25207-1-paskripkin@gmail.com>
 <ed39cbe6-0885-a3ab-fc30-7c292e1acc53@datenfreihafen.org>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <ed39cbe6-0885-a3ab-fc30-7c292e1acc53@datenfreihafen.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/4/22 18:40, Stefan Schmidt wrote:
> 
> It compiles, but does not work on the real hardware.
> 
> [    1.114698] usb 1-1: new full-speed USB device number 2 using uhci_hcd
> [    1.261691] usb 1-1: New USB device found, idVendor=20b7,
> idProduct=1540, bcdDevice= 0.01
> [    1.263421] usb 1-1: New USB device strings: Mfr=0, Product=0,
> SerialNumber=1
> [    1.264952] usb 1-1: SerialNumber: 4630333438371502231a
> [    1.278042] usb 1-1: ATUSB: AT86RF231 version 2
> [    1.281087] usb 1-1: Firmware: major: 0, minor: 3, hardware type:
> ATUSB (2)
> [    1.285191] usb 1-1: atusb_control_msg: req 0x01 val 0x0 idx 0x0,
> error -61
> [    1.286903] usb 1-1: failed to fetch extended address, random address set
> [    1.288757] usb 1-1: atusb_probe: initialization failed, error = -61
> [    1.290922] atusb: probe of 1-1:1.0 failed with error -61
> 
> 
> Without your patch it works as expected:
> 
> [    1.091925] usb 1-1: new full-speed USB device number 2 using uhci_hcd
> [    1.237743] usb 1-1: New USB device found, idVendor=20b7,
> idProduct=1540, bcdDevice= 0.01
> [    1.239788] usb 1-1: New USB device strings: Mfr=0, Product=0,
> SerialNumber=1
> [    1.241432] usb 1-1: SerialNumber: 4630333438371502231a
> [    1.255012] usb 1-1: ATUSB: AT86RF231 version 2
> [    1.258073] usb 1-1: Firmware: major: 0, minor: 3, hardware type:
> ATUSB (2)
> [    1.262170] usb 1-1: Firmware: build #132 Mo 28. Nov 16:20:35 CET 2016
> [    1.266195] usb 1-1: Read permanent extended address
> 10:e2:d5:ff:ff:00:02:e8 from device
> 

Hi Stefan,

thanks for testing on real hw.

It looks like there is corner case, that Greg mentioned in this thread. 
atusb_get_and_show_build() reads firmware build info, which may have 
various length.

Maybe we can change atusb_control_msg() to usb_control_msg() in 
atusb_get_and_show_build(), since other callers do not have this problem



With regards,
Pavel Skripkin
