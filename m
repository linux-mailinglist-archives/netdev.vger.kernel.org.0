Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F1F462BCD
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 05:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238258AbhK3ErI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 23:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbhK3ErI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 23:47:08 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F9DC061574;
        Mon, 29 Nov 2021 20:43:50 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id h16so19013738ila.4;
        Mon, 29 Nov 2021 20:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HeqaDzTbdMwSCdyiTp9W48kA5llr20ZDAs9jQ6aZ89A=;
        b=eSUyGpfQvdHvD4AaQu1B1O2V82sW/OvAWBRJQfAf6zDgkDp8Ajjmx6S0IMI8IT01fX
         ZsakYIazOvwX0HkfeJpREI0nQufVeMblUT4FKoiKVxnNHpc8YvaYl+1AIqKIlyoPfelV
         F1exsHYA2ktLF6JKGy8HAFn4PUEox413KfqqachmVr0stvceEfrNSVPTYeKxvmi4xJCN
         rFY7mJtRwE0Rx8Cn2i5v2mzWntWsa3uCgLsSkX4cONXOfICsuAjwt++DhNEqVOkxyq9d
         H5ttROTWZXxJrURrxSXH7eNyuSj25DTDvfdN3xxwULaIsnF3LNMkUjj3KpvEMe2NEcLC
         w9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HeqaDzTbdMwSCdyiTp9W48kA5llr20ZDAs9jQ6aZ89A=;
        b=mF24bQnKBctUj9vZdDVuFYFETQUcHDAdRbGRic6JTpVIPzOTN7GjAVMKR1R1C1q5Kr
         hrdIjpZhG2jBaYAAvrXlS9DrmzJbnHQGz701OCbhAY3bqRvUfOB0+z3VEGH8DuMgGEne
         mnDpg4IrHs8XhIaKuTHCG9sukmUPVFr3NGaz5HqUBiMAbvoFZAVPDwkHLkis81INMA56
         5qtYwcpK1jGehYuW4CM4CkSQR+isgymhoLficIogDu/6SryA+TSsCfGDVOM6shpOLmyQ
         HErtPsC8qJqdOyExAMAMODf9dGtLj720rY9IOFp5CpjFtdwETRyx131TQxf6O6Ufduf5
         BTlw==
X-Gm-Message-State: AOAM533CbtpXcdEgJPK6YqWCjq7W2VFSF7iSWyXZvLlR7m5gmsrcWSQ6
        kRcnrXw/UlDh1FS4vdeofO5xynsVhwJHvQ==
X-Google-Smtp-Source: ABdhPJzhhtgu2XRJWZgzRagGUWBq2vjFLVNXp82rfiCPflecReMfar8JHmTNVAUYxic5cgJPNUxJrA==
X-Received: by 2002:a05:6e02:1a6a:: with SMTP id w10mr50269233ilv.190.1638247429493;
        Mon, 29 Nov 2021 20:43:49 -0800 (PST)
Received: from cth-desktop-dorm.mad.wi.cth451.me ([2600:6c44:113f:8901:6f66:c6f8:91db:cfda])
        by smtp.gmail.com with ESMTPSA id x2sm8961216ilv.65.2021.11.29.20.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 20:43:49 -0800 (PST)
Date:   Mon, 29 Nov 2021 22:43:46 -0600
From:   Tianhao Chai <cth451@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Hector Martin <marcan@marcan.st>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>
Subject: Re: [PATCH] ethernet: aquantia: Try MAC address from device tree
Message-ID: <20211130044346.GB1416412@cth-desktop-dorm.mad.wi.cth451.me>
References: <20211128023733.GA466664@cth-desktop-dorm.mad.wi.cth451.me>
 <YaOvShya4kP4SRk7@lunn.ch>
 <37679b8b-7a81-5605-23af-e442f9e91816@marcan.st>
 <YaWNKiXwr/uHlNJD@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YaWNKiXwr/uHlNJD@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 03:32:10AM +0100, Andrew Lunn wrote:
> On Mon, Nov 29, 2021 at 02:08:28AM +0900, Hector Martin wrote:
> > On DT platforms, it is expected that the device tree MAC will override
> > whatever the device thinks is its MAC address.
> 
> Can you point to any documentation of that expectation?

Since other drivers will prefer DT provided MAC as well, I'd assume
this to be the case, though I'm not sure where this behavior is documented.
I'm new to embedded systems and maybe Hector knows better than I do.

I don't think this will cause regression on platforms that don't even use
DT, say amd64, but could be a change of behavior where DT and NIC both
report valid MACs on OF platforms.

> I'm assuming for Apple M1 Mac minis the order does not actually matter?

The order does not matter in this case. On my M1 mini the hardware
reports an all-zero MAC address. The MAC from DT matches the one printed
on the box, and we should use this one instead.

~cth451
