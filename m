Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AE928B3F0
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 13:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388268AbgJLLit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 07:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388208AbgJLLis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 07:38:48 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D695C0613CE;
        Mon, 12 Oct 2020 04:38:48 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id p11so8419093pld.5;
        Mon, 12 Oct 2020 04:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uAr1u2AxKhyAhsPGz3HPtu7lWVnt+PlRnjUfOtRYD10=;
        b=eXjiSmybFzCfsLPApRdx4SqJd6Q3JXAdvU4MJPKZZ4ippGkNFfgFeYTZwyzfKdWC3N
         YY4Ee59ldzAAxxHe4aH1Td5dqVxdLDSGafdKsH+jgctwaG/tQBZccfYg2Xd7cpGdzQhy
         fkUUiKGWchxtaeuE8+U1v99g21gesrczOEHEht53nKBwa+fizLetc2lpleHUJ3jYOm1F
         QMF4HcPQ5uyXuV6Lge8N7UnvTP16iaUuhVuaaUhk4DU80tBdQTswwjokQViDioc3Pi/N
         0n448WWUK9jaxfz/5wTa5GytQaRD4Yb4oY0mKvyOFaUUdJ0ABranwTEq/UXc10SqAA6R
         y3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uAr1u2AxKhyAhsPGz3HPtu7lWVnt+PlRnjUfOtRYD10=;
        b=kS6ICuadiDeAngrKXdqbmKMsWnI/YfLA6DL8kKwPOGBytT4IZIZFYjl85o3PTmaJlJ
         FI2gfA5DwTQBGlzjFDPjYpzHEpvh2iN71kjNvyURgU4DNP1e8xCXGaS2uE0f3/CoLM2W
         0hEeSrwDjLQ551yUVWZsLiPU7UDISWaf5SQEtYK5k7n5US4I8pUlJYn65pomn1FLWPGY
         I0fzJkWLG/kD/Gx8EhW5WxeHIREdPdEc5a9MUO3oG5H2PVyYuMv/7Inc1UeTHA+5V3oP
         mjU5O/N3Kmm44QcGWuB+oIpfupZ4xJhixiuZdEHrP47XIQLMowFUzEJ82Zj01hClcJyw
         3HYw==
X-Gm-Message-State: AOAM530CrddpnBu81EdD1LoviOP84LLGiyooNSeJrjOI/F2oPmXpuHQr
        kFV76OszgepiiiL2zg85MhCQdDjYeW2hlD8U
X-Google-Smtp-Source: ABdhPJxHiPbCY6AwdU1NepgLndb4Cc4E+OU455e+aeQtaXWusCq2n76TGY06FvHVFDAGFlriW9lX4w==
X-Received: by 2002:a17:902:8698:b029:d3:b362:7342 with SMTP id g24-20020a1709028698b02900d3b3627342mr23245874plo.50.1602502728048;
        Mon, 12 Oct 2020 04:38:48 -0700 (PDT)
Received: from localhost ([160.16.113.140])
        by smtp.gmail.com with ESMTPSA id v20sm14861383pjh.5.2020.10.12.04.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 04:38:47 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Mon, 12 Oct 2020 19:29:14 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 5/6] staging: qlge: clean up debugging code in the
 QL_ALL_DUMP ifdef land
Message-ID: <20201012112914.xrkwi53gqvg5l6lw@Rk>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-6-coiby.xu@gmail.com>
 <20201010080126.GC14495@f3>
 <20201010100002.6v54yiojnscnuxqv@Rk>
 <20201010134055.GA18693@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201010134055.GA18693@f3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 10:40:55PM +0900, Benjamin Poirier wrote:
>On 2020-10-10 18:00 +0800, Coiby Xu wrote:
>[...]
>> >
>> > Please also update drivers/staging/qlge/TODO accordingly. There is still
>> > a lot of debugging code IMO (the netif_printk statements - kernel
>> > tracing can be used instead of those) but this patch is a substantial
>> > improvement.
>>
>> Thank you for the reminding! To move qlge out of staging tree would be
>> interesting exercise for me:)
>
>If you would like to work more on the driver, I would highly suggest
>getting one or two adapters to be able to test your changes. They can be
>had for relatively cheap on ebay. Just search for "qle8142".

Thank you for the info! Right now I don't have a desktop to install
this kind of adapter. I'll get one after settling the plan for a desktop.

--
Best regards,
Coiby
