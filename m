Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B50AFD1C82
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 01:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732559AbfJIXKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 19:10:34 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35027 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732199AbfJIXKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 19:10:33 -0400
Received: by mail-qk1-f195.google.com with SMTP id w2so3864665qkf.2
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 16:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=PnjQOHepBuv9rYKnDUFewaU2wDCjjihpShjTxB7TXsk=;
        b=RsKHCYwlEK2MnPGOLw3WfXus/DDmivqcNdxalAOy3hlZ/qAQSBLq1JTB/kxeHQl1W3
         fEwIP+vV4b7VINYF3fxCLVX+ZDMkWBpk33nzXxBQmUpj4mWuG2L1jy25vxDQhUPJNWnI
         OLb2oVqDMOyZgZQyDg6NrudDbB/NlkOEj+xKnjOlzXp1VGahGeHGqixJ8EuWEWwbe/id
         YlS1JRQZpPp/HilLmm9nFyT5AF3dNB/7dQo58dqWYl5hSu2X7bxBDOVqcajUu1Et5uAU
         UjiSceUeTP8BfdtMBu2nPvkOfXRv/+k5TJe551yvWspUt8b5fhRsLOf6cs+3Uwk4mvNl
         hK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=PnjQOHepBuv9rYKnDUFewaU2wDCjjihpShjTxB7TXsk=;
        b=fEvxhMaGEf0gf0YWh1xUP/qBtRJZDo7IX0bALX8Mvf6zKvvYfEFVeA4COu087m+6DA
         2n4e0JskkLP1qI8VqEKBtl7TBAuY1HAOAGGVpmaOYsUA2YL3jES39FAWK9xYVLG29Lz6
         bURWEJ4RwPLCleNf2A7hQMOju9hB4ZuXrtWQ3U6oJDiyDy5KlpJmGBJSTXk1wgmz4pbs
         reZ79ZV5JwTm0By35U+5FSsJ1AOa2UAQn0xqkx2zofoEPGAebpNdBPozjCmuKF86a5P3
         4ilTqpMExuO4ul4K9pi+HBGuyRwgQkEb3rQGXzI/6fbigArLIjWOyAqf0BPH/XuJ/h6L
         cmZQ==
X-Gm-Message-State: APjAAAUHTccVtWziUcGmNqcjzYIfr6A0HJjfCzw8M4sJUnZB/24Yn9YK
        UUfi529BHeTXpIvbtCDgrXaeKQ==
X-Google-Smtp-Source: APXvYqzDsg7VvPjwvTLuHucNP0B1UJPXSz1g9Ec4z5pbH0OhF3aJ6PEN0n9s/5rnpedoNj2WEr1nyw==
X-Received: by 2002:a05:620a:1355:: with SMTP id c21mr6444676qkl.288.1570662632760;
        Wed, 09 Oct 2019 16:10:32 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m186sm1709799qkb.88.2019.10.09.16.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 16:10:32 -0700 (PDT)
Date:   Wed, 9 Oct 2019 16:10:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Antonio Borneo <antonio.borneo@st.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: stmmac: fix length of PTP clock's name string
Message-ID: <20191009161018.3b4919cd@cakuba.netronome.com>
In-Reply-To: <20191007154306.95827-3-antonio.borneo@st.com>
References: <20191007154306.95827-1-antonio.borneo@st.com>
        <20191007154306.95827-3-antonio.borneo@st.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Oct 2019 17:43:04 +0200, Antonio Borneo wrote:
> The field "name" in struct ptp_clock_info has a fixed size of 16
> chars and is used as zero terminated string by clock_name_show()
> in drivers/ptp/ptp_sysfs.c
> The current initialization value requires 17 chars to fit also the
> null termination, and this causes overflow to the next bytes in
> the struct when the string is read as null terminated:
> 	hexdump -C /sys/class/ptp/ptp0/clock_name
> 	00000000  73 74 6d 6d 61 63 5f 70  74 70 5f 63 6c 6f 63 6b  |stmmac_ptp_clock|
> 	00000010  a0 ac b9 03 0a                                    |.....|
> where the extra 4 bytes (excluding the newline) after the string
> represent the integer 0x03b9aca0 = 62500000 assigned to the field
> "max_adj" that follows "name" in the same struct.
> 
> There is no strict requirement for the "name" content and in the
> comment in ptp_clock_kernel.h it's reported it should just be 'A
> short "friendly name" to identify the clock'.
> Replace it with "stmmac ptp".
> 
> Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
> Fixes: 92ba6888510c ("stmmac: add the support for PTP hw clock driver")

Applied to net, queued for stable.

For future submissions please indicate the target tree. Networking fixes
should go to the net tree and have [PATCH net] in the subject, while
normal patches such as new features and clean ups should be tagged as
[PATCH net-next].
