Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB9D41E743
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 07:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352049AbhJAFjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 01:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhJAFjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 01:39:19 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28746C06176A;
        Thu, 30 Sep 2021 22:37:36 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d21so13516942wra.12;
        Thu, 30 Sep 2021 22:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ICvakysTnIcMlsFl1CajmrW7XSMIhF0mtzyN0yeCPvo=;
        b=NJpPde/VyrekEvNAM8op1urjweEjPHrjH5CR8QfKDwsFev6sl7t5yes/7W24Wu2Tld
         WLXmR7mGy9t9xTPN43xpuBLuREVQErKyRBCin6ylKAbap30p/zzIEBry2sG+Fyo40ajE
         GzVcW6A+G2N08JCjxP3ufzcarD41Ta1g2BB42mD3QjjJ1zAoTFgQUmLJdkv2KZ5a/VuG
         Ynns4JDo1XtypTX4jAHqLAMI+BZ6FLTD6GZLk8gSzOEa71+5hdOtxhqPgtHSbam7mSeT
         G0S10heB4TA2TwpC6Jh5pIo7s8679uersk289IeiPW8YSFTityTKUt+ZkKbKhx00tsy0
         qedw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ICvakysTnIcMlsFl1CajmrW7XSMIhF0mtzyN0yeCPvo=;
        b=VhcbkxlxmkJOnOhaZk72X7OgJeSVqnJwL7jd1V0hDQwjGu8y6Xl5JxDBWPRbhng1th
         57paU2tCMPaUpyKxShtwne/ejaL8/3Lahv0HZ9GTqq1jzmRdZ7QtCrpea8fVwHLRAyTw
         nKbt0bdaXxkWp43aHTqjKW9tadT/GOj9QRXV5Ub3VUprhcKO+X+uF6UhBM0cYWgsvbHS
         EbQ492MDeLAiiFwclOdF1d266o0Jx0p8XyW2pNL5P+37b5l067JbrB4kDoMrOpk7fVP3
         K474r6BLmvDD37ueGNRLaSFTcqenWSxlQumDF/XkpzkPcaNT+AMN4h3Q3DfDyYuPmggz
         pygA==
X-Gm-Message-State: AOAM530wULnHYZa3qEXY2d/3yxdCYsHa8vuzSzY6HJzvqoMeRe6m557H
        7ty1yipy50Jh/uHTeihoa6QobSY9V2nZ0Q==
X-Google-Smtp-Source: ABdhPJzCSpC43uIo4eNv23X7URdylmJhUbPDB+mdxVs4my1Bk1BoKfSEXlgv6lVwF5SrvvtVmiRcvA==
X-Received: by 2002:a5d:6d8e:: with SMTP id l14mr9988365wrs.270.1633066654667;
        Thu, 30 Sep 2021 22:37:34 -0700 (PDT)
Received: from [192.168.4.32] ([85.184.170.180])
        by smtp.gmail.com with ESMTPSA id g13sm4587316wmh.20.2021.09.30.22.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 22:37:34 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH v2] rtl8xxxu: Use lower tx rates for the ack packet
To:     Chris Chiu <chris.chiu@canonical.com>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211001040044.1028708-1-chris.chiu@canonical.com>
Message-ID: <e64de376-f765-fc55-0e82-84e269c4dc43@gmail.com>
Date:   Fri, 1 Oct 2021 01:37:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20211001040044.1028708-1-chris.chiu@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/1/21 12:00 AM, Chris Chiu wrote:
> According to the Realtek propritary driver and the rtw88 driver, the
> tx rates of the ack (includes block ack) are initialized with lower
> tx rates (no HT rates) which is set by the RRSR register value. In
> real cases, ack rate higher than current tx rate could lead to
> difficulty for the receiving end to receive management/control frames.
> The retransmission rate would be higher then expected when the driver
> is acting as receiver and the RSSI is not good.
> 
> Cross out higer rates for ack packet before implementing dynamic rrsr
> configuration like the commit 4830872685f8 ("rtw88: add dynamic rrsr
> configuration").
> 
> Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
> ---
> 
> Changelog:
>   v2:
>    - Specify the dynamic rrsr commit for reference
>    - Remove the unintentional twice reading of REG_RESPONSE_RATE_SET
> 
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 6 +++++-
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 2 ++
>  2 files changed, 7 insertions(+), 1 deletion(-)

Acked-by: Jes Sorensen <Jes.Sorensen@gmail.com>
