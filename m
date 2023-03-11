Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEEC6B6091
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 21:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjCKUfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 15:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjCKUfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 15:35:46 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10ECF20541;
        Sat, 11 Mar 2023 12:35:45 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id e13so8003870wro.10;
        Sat, 11 Mar 2023 12:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678566943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B9SEaDPKriAiDKyfkIslt2zjnxJG5SwQ9dwP0X6YQpw=;
        b=P17DKkJxPQ9l1ObzWD8RqtwNAAyx5Jclhvbf4ojZYLSUAqy6tM/Xb0kUCIUhD3eGCw
         u9kl6JCvWwxH5iWTMz4K0UaUzqMmfb+A7wtdWVP7d9vJnSCx8nqd43IADJsRgcmITOK9
         tIKibCilEyhns2bFJsilp+KpLRYhIboYUWBPVyd27Wu0pyBBMQ/Q60clpTp8g/CVxo+Y
         dXcgALHFby7wR0mM7oj8kvSODHZodutjTBxhMYDRyI6zxBdACNEe5JCT+gpuBHg/Iw4i
         zXHlTnoAtQjDizFQ51DvlYU7+PbhONhzpUuB9hTZfgXVh0klDjMMQi6dN8NTsFKvg5Va
         LByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678566943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B9SEaDPKriAiDKyfkIslt2zjnxJG5SwQ9dwP0X6YQpw=;
        b=RwdwIxyoPK93wRgEBh8w6Y92R1mwS/Ec4VNv1qbhQXCxT7dKGdUnup1LM7NBZbLOBb
         TqgHN4MjTSqk0BUb2waFDmNDP6+8tvE/rBlccN0rzST0RtNHMV13ur2pgWcaRv3Y4xpx
         XCE+wxxablIpWIwkMZlG5+xG8g9ofmcvNm6TWI5M8e1RLeoQYyz5J26fCNJD8uWTNFzR
         rMJ11RM3tmLeivxSfX8OK8SucnEDe3xsj9iTFxzp1qTs4wY5SgiTQQCRykufl3zsLQ/P
         6LkHGZIFygzcZQZjJ8sSOxKCKV38nOfosbAIUYqeN/hgK3YwfO6g0pv31RO3M8ReJcAI
         r9Dw==
X-Gm-Message-State: AO0yUKWifOzfGzDtaO3wxdfkPVKj85J32TxFaKGlqyDHxqmB4jE6wJqo
        uKujTBWU+cPvtn1BttBh6JiGolT11n3MEw==
X-Google-Smtp-Source: AK7set99MMxWgK/IQCvaGY4dgmRdox1pfzG2vmBzGe7HwmF6uoQMjL09Ni97QHEGy55MDtsIiuk9ow==
X-Received: by 2002:adf:edc8:0:b0:2c7:adb:db9 with SMTP id v8-20020adfedc8000000b002c70adb0db9mr18668917wro.63.1678566943294;
        Sat, 11 Mar 2023 12:35:43 -0800 (PST)
Received: from suse.localnet (host-79-35-102-94.retail.telecomitalia.it. [79.35.102.94])
        by smtp.gmail.com with ESMTPSA id z17-20020a5d44d1000000b002c5691f13eesm3232321wrr.50.2023.03.11.12.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 12:35:42 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     error27@gmail.com, Sumitra Sharma <sumitraartsy@gmail.com>
Cc:     GR-Linux-NIC-Dev@marvell.com, coiby.xu@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, manishc@marvell.com,
        netdev@vger.kernel.org, outreachy@lists.linux.dev
Subject: Re: [PATCH] Staging: qlge: Remove parenthesis around single condition
Date:   Sat, 11 Mar 2023 21:35:41 +0100
Message-ID: <1713523.QkHrqEjB74@suse>
In-Reply-To: <20230311144318.GC14247@ubuntu>
References: <20230311144318.GC14247@ubuntu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On sabato 11 marzo 2023 15:43:18 CET Sumitra Sharma wrote:
> Hi Dan,
> 
> Your suggestion for correcting the indentation to
> "[tab][tab][space][space][space][space](i ==." conflicts with the
> statement "Outside of comments, documentation and except in Kconfig,
> spaces are never used for indentation" written in
> https://elixir.bootlin.com/linux/latest/source/Documentation/process/coding-style.rst
>

I just saw that you use to read .rst files. Attention!
These are source files from which human readable documentation is made.

They may contain directives which don't show a large part of the content you 
are interested in, which is only included when you run "make html", "make pdf" 
and similar commands.

Obviously, I'm talking about something that is _not_ related to your patch or 
this thread. I'm just concerned that candidates won't be able to find the 
information they're looking for and thus miss out on important information 
that Ira and I have asked candidates to study (if they're interested in 
applying to our project). 

In any case, the study of a certain number of pages of the Kernel 
documentation is always necessary, whatever project one wishes to undertake.

To better understand what I'm talking about, take the Highmem documentation as 
an example and compare the .rst file and the .html file. You will understand 
why I am strongly encouraging you and all other applicants not to use 
elixir.bootlin.com for study.

Please compare the content (or at least the number of sections and lines) of 
following .rst file at

https://elixir.bootlin.com/linux/v6.3-rc1/source/Documentation/mm/highmem.rst

with the human readable counterpart at 

https://docs.kernel.org/mm/highmem.html

Can you see how many information you may miss by reading an .rst file without 
any knowledge of its syntax?

Thanks,

Fabio

PS: I don't know why you went to the documentation source files. I see no 
reason other than the need to work on patches for the source document.

I'd like to invite you to patch the style guide that Dan suggested to you in 
this same thread.

But I'm not asking you to spend time on that patch during this contribution 
period because you still have a lot to do before the period expires.

If you want, you could take care of that patch after the contribution period 
has ended and while you are waiting for the outcome of the selection. If so, 
study the syntax of the .rst format carefully.

In the "real" kernel (I mean anywhere outside of drivers/staging), you might 
not always get the custom help of the same kind you can count on here. 
However, those who intend to go further, regardless of the current project, 
sooner or later will have to face the world outside :-)

>
> However, If you still recommend to correct the indentation in the manner
> "[tab][tab][space][space][space][space](i ==." Should I create a
> patch for the same?
> 
> Regards,
> 
> Sumitra




