Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3ED84421AB
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 21:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhKAUcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 16:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhKAUcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 16:32:24 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03806C061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 13:29:50 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v17so29846487wrv.9
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 13:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GevA1FIiFY3B9dq0O+D14rARZ0fGaF4OuQb3r18RqDo=;
        b=nL8rQZC04mSnuieiY+DAspcNzuqnQDlgke8Lg8B2f8DepyrdWHnvQF4XiL07Di3HxN
         VOt4PlDvNEZyCp1FMRSIbVKKiTH1lNndRTIak9CYZ7z3XsdsdrqzGgiRgtoMibJzALAV
         jC5wgpKcb1wndGG4GKiGarxHUl/2tKV0XGqHBTbhWKzPDA4PrXlk8TfS84pzoZFIYUgp
         3ZYtHSxe26sqqeiGB7bAOEQBBLKPYQkCRmrnyRfsEwqUieFmw/v8bJ2MIZ7NA5siRq9t
         pxeXlV0X3RqFknIMxAr8vipIx6f9QS9Lll6F247Y6n2q6WcojQDMbgaflCZQ243bn7md
         vShg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GevA1FIiFY3B9dq0O+D14rARZ0fGaF4OuQb3r18RqDo=;
        b=FqY1HIhWVBtrVrR2DTQfrY5V6juA6rNbfpsUy2VwURzuLhjVRlVfm/fO1q6U04VEdn
         tZHte1KGJv4ipMQST8UttgwrUxcqJ6eEa/qcPwYbM/uMCTRa7HQH9AjLWIE7M/we7c4Y
         0ADZ1v1xbL8SRZfqlVZ096/mZiaWyQiNtVMWbCHi5ZM5tkG7HLerXjEccz+cKpqYiM68
         cO3ybQrqjaCOsHEQRH7+I3+EDUMeTv4oEVDpg6doEPDHndSH0YEX90y17GnmJTid6wrS
         FhkXDPmuX0q7M42nLbQFTWr00rxld4epLKJOKzX0UplZoF9VX8NsSeTpdhjVddpKJc7P
         haYQ==
X-Gm-Message-State: AOAM533Siw15CvhNH5DEywSsSDC6TxKNSoTJqXlNAlyz9LG/4gQRvVvI
        jgvHzVZYGoxsR4P43mV17/L5Cauq2lzOKHUOibNbWNNtu26T9g==
X-Google-Smtp-Source: ABdhPJw3J5xaxk24NAFMRmVytgNsc1zYLMARV0JPUlE8nu7N5Bwg+xFWlmpEVJz1yRYfe/MIqBpb/Af2hi5S5TTFACw=
X-Received: by 2002:adf:8bc4:: with SMTP id w4mr40168899wra.36.1635798589470;
 Mon, 01 Nov 2021 13:29:49 -0700 (PDT)
MIME-Version: 1.0
References: <20211029200742.19605-1-gerhard@engleder-embedded.com>
 <20211029200742.19605-4-gerhard@engleder-embedded.com> <20211029212730.4742445b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANr-f5yBuKd0D4xppyRm+PUmLredFuGA=dM_BSQ9VkSPTfX2Lw@mail.gmail.com> <YX/igyj2u/Aen9za@lunn.ch>
In-Reply-To: <YX/igyj2u/Aen9za@lunn.ch>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Mon, 1 Nov 2021 21:29:37 +0100
Message-ID: <CANr-f5z-Mg9GbegqFPrk-uHExmXvh8Xq4N_S0UzNbdEVBf9+HQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/3] tsnep: Add TSN endpoint Ethernet MAC driver
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > About endian: I have not considered endian so far, as this driver is used
> > only for x86 and arm64. Is that ok?
>
> In most cases, there is little you need to do, so long as you use the
> correct methods to access the bus. PCI registers are always little
> endian for example, so easy to handle. Memory mapped structures are
> where you need to be careful, your receive and transmit descriptors.
> You need to use the correct __le32 or __be32 annotation, and then
> sparse will warn you if you access them without the needed conversion.

Thanks! Now I get those warnings. I'll fix them.

Gerhard
