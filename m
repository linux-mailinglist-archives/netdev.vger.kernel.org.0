Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88962821B2
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 07:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725795AbgJCFyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 01:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgJCFyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 01:54:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3CAC0613D0;
        Fri,  2 Oct 2020 22:54:40 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id x2so2269486pjk.0;
        Fri, 02 Oct 2020 22:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=m4KS3848PrcvqXAzCFiimfxqlRCB/TpZjyjy6cihM+Q=;
        b=IO+9gt4yl9NCpu4sQPrBhRhiq5PV/m3qFdVc/+KFj2wzRA54BRBSYhOFP4yre5nL1Z
         IvyPI5DZJfh1pijkFXH987LFSnTBVMRjhchmXLXetC9o2ANdZw/k3XIL1n8iI/laaYEd
         8VSL/vFWvDG22QjOI2U4WEjNmvqd2LuXbmIwxXVH6mUqaKW1Rwq2cBPVeCVOt1DT8aKN
         bqjRNeYSkp14h2PoUGJ+ubwJdAK9o4emmXR1wjlAlqhfTob8AeeMy5V1H3A8vNYehaOV
         K3nSRxXhAWNzjNKYzK//SAKFxwVg+2LRaxusM0Rulwcp5k+sRWWLpq5hNKTG/DHmstLk
         +nqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=m4KS3848PrcvqXAzCFiimfxqlRCB/TpZjyjy6cihM+Q=;
        b=tbeUM60RlrCvJxPQZSUuXGYcxH/qLy4zx96SaRAPzciuVi4IP443DVNORPh6QWIwSy
         2y6PHBi5B33DtIlnRe3NZbgEtSLkD9k3TbDtXRMB6TgQHq0ZtsiCHS68YeWfWoafJV2g
         aYkNPtjeohRlGfW+cYAj/3wSRO7scXP3pSV6kGjt9hnLj8Ey51mUXkFnFgFNYLkmRkn0
         AWbyvePLiqJVauuHeaWtxubIP8+p1B2gsvNiQz6W9fBUpKj/8zzq/lQQJe4SiUD1hPt1
         zWxvz87lNzHr7SN40DKWHkaOaSKZxvM8TinmVxLKXhOg8QNfGrySxZDm0Ihzk6R7xa2p
         BKZQ==
X-Gm-Message-State: AOAM533yF20NA6g7LjfmfqPEcSWXkst9dkg/PtbXKmgi2Bbb7SzhFEjQ
        8r5O7+U4ZMi9/DvGGQDeh0jfe07O0+/OH0jeY6c=
X-Google-Smtp-Source: ABdhPJwH2hfwWWdulLEsYcNVwJzjU39Yd92fij21PqSuzUnMzFUBCn3JLuFtQAF1U5BbEiTcaEkSFA==
X-Received: by 2002:a17:90a:5588:: with SMTP id c8mr6110448pji.224.1601704479116;
        Fri, 02 Oct 2020 22:54:39 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.217.69])
        by smtp.gmail.com with ESMTPSA id j19sm4245113pfi.51.2020.10.02.22.54.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 22:54:38 -0700 (PDT)
Subject: Re: [PATCH v2] net: usb: rtl8150: prevent set_ethernet_addr from
 setting uninit address
To:     David Miller <davem@davemloft.net>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        petkan@nucleusys.com, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201001073221.239618-1-anant.thazhemadam@gmail.com>
 <20201001.191522.1749084221364678705.davem@davemloft.net>
 <83804e93-8f59-4d35-ec61-e9b5e6f00323@gmail.com>
 <20201002.153849.1212074263659708172.davem@davemloft.net>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <2e4f7bdb-76c0-9ee4-88bf-5d31ded17116@gmail.com>
Date:   Sat, 3 Oct 2020 11:24:34 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201002.153849.1212074263659708172.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 03-10-2020 04:08, David Miller wrote:
> From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> Date: Fri, 2 Oct 2020 17:04:13 +0530
>
>> But this patch is about ensuring that an uninitialized variable's
>> value (whatever that may be) is not set as the ethernet address
>> blindly (without any form of checking if get_registers() worked
>> as expected, or not).
> Right, and if you are going to check for errors then you have to
> handle the error properly.
>
> And the proper way to handle this error is to set a random ethernet
> address on the device.

Yes, I've understood that now.
I've prepared and tested a v3 accordingly, and will have it sent in soon enough.
Thank you so much for this!  :)

Thanks,
Anant

