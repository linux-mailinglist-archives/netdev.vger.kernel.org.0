Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19031E3346
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404568AbgEZW5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404359AbgEZW5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:57:03 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2FDC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:57:03 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id h10so23896865iob.10
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=xaptum-com.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YtL8/eg2MT8cQiuKB2qrDwBwNfWn/CnmlESE3JYE91s=;
        b=i4YRMYt3wmE9eclGKjc570k6pKgGnyXPzrYXwvtgVOot1sBvX8wTsQ6OCEC3uP7nmu
         gk+nRxEBjkZWspUOo7aod7xhB4CTKwSTExsDIaF/IErGGvey1+apkWrfbm06ViLrBFay
         2qaWzUXm1GLhlCJXklPCf9OwsWW+Bzr6RT6yRbGtDjGzHbgOHtAzNPnECp7vzqjxS/Ki
         Itq7ydPu4CriV2uYZL0pgqkYekSOGzXADZUQqAuQjYbeb5hcRMSd7WiQrSB4x+o5lgeP
         TwyhedRaAZEoiNuVPcGLEnBNGFE1S3l3OA2lZlSGcGF9x92JApobcT22hGvOZ0MduLHR
         OGKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YtL8/eg2MT8cQiuKB2qrDwBwNfWn/CnmlESE3JYE91s=;
        b=rLPwMffwPM1mPyTMjxKyuW7oTe/HqJZ+ljVOsoeEtWmwpBRh5Izxm0Jhm7vONiWtvs
         GJl9INQBfnz7F3ksL3uPSrx/1qoGFHv599/fO0ONtWTojbveo0MrGrYJtj8McKj9G2/Y
         MLt8p9w/FOnT0nB2UiV99klbn5TmMoASICPQiFmiFK19n1OM3LXTrGsKDtJHgQ2ge+/k
         7ZzMZR7YGiU46ZIzjQ9xrX3Q+S7wR7DaSuQ64pqn6LzSjGCgTKus2gGzb2CDMrqoEq14
         cfUZHZCAWA0m1Uz202dOVgw5bwXScsuJ3iEoizA71eoBVz6/x3kljad54CW1EblLIhtS
         6+cg==
X-Gm-Message-State: AOAM533EtknCHz+sYo0xuVOkpZQFmGkPa+D5z7TpUi9zBW6+1HpSOePj
        xVcNfYICPrcc2nZJ4h+fTXbNqs23sSvsZw==
X-Google-Smtp-Source: ABdhPJxd+0eO2Smu2SAJmMx1u5HndqrJKSvz0Pgs+iYIoHo7NhlMKQcFuLnjizIVDuUU4K1REZrCoQ==
X-Received: by 2002:a02:82cd:: with SMTP id u13mr3300681jag.32.1590533822575;
        Tue, 26 May 2020 15:57:02 -0700 (PDT)
Received: from [192.168.1.53] (c-67-175-55-220.hsd1.il.comcast.net. [67.175.55.220])
        by smtp.gmail.com with ESMTPSA id f15sm690049ill.58.2020.05.26.15.57.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 15:57:01 -0700 (PDT)
To:     netdev@vger.kernel.org
From:   Daniel Berliner <daniel.berliner@xaptum.com>
Subject: Writing a network protocol to communicate with a USB driver
Message-ID: <c55a880b-6463-db1b-7cad-b522a8dcdba7@xaptum.com>
Date:   Tue, 26 May 2020 17:57:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am writing a USB driver that allows small USB devices to use their 
hosts internet connection. This involves the creation of a new protocol 
so userspace apps can create a socket for reading and writing. Instead 
of sending the data over the normal network chain the sock forwards that 
data to a USB driver which sends passes the data around around and can 
write data back.

What I think needs to happen is the protocol packetizes the data to be 
sent to the host, add the packets to an SKB then have the USB driver 
pose as a transport device to receive the frames. Much like ECM and EEM 
present as an Ethernet device on the SKBs chain. Does this make any sense?

Right now I am statically linking -- the drivers just know eachothers 
functions and make direct calls. I know this is not good practice and 
need to move the project past a "proof of concept" state with a better 
design. I am inexperienced with the Linux network stack so any 
suggestions would be appreciated.


Thanks,
Dan
