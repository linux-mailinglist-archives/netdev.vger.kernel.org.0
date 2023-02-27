Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B98F6A499F
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjB0SYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjB0SYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:24:00 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E8A233E5
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:23:49 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id z2so7638023plf.12
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GDtqLJH3f5lA4TmQ3x9NmeWyaKQg7VQJDPnwWZS0UVo=;
        b=TZGBvnOjHwKmMcwKNEy3x+o9ZW23us+kXw1KbfRL5YQ2T+Kc9Chn7eHTAM6dmhYx/3
         Bnx565o6qDyv2n6Z3JB0EdqISzWnWuuH1BFXyV6SrMIN5ZIbT2Rw3LN512m1pb76pC1G
         6EF1ui2uSVVf1ora9C7w3S2QexGfk4NhpA3VjpTL9xXoBjl3FVAYSyjsdQs2KR8UFTjI
         JhVqKFMfyNYyJKh/p9CeVzyU42YZ2TObjc1c12VUNuztKEGu9bUfwwVoCThozOr87S3o
         4ZPbXyrPF+GRvJrlDppMMQLXlhs/2p0Iw+UncQrwhpnjV8/plyrIEjDHrM3CfI3PSKNv
         Aztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GDtqLJH3f5lA4TmQ3x9NmeWyaKQg7VQJDPnwWZS0UVo=;
        b=DLvwfkysTlmddEPD8iErD0VrjNhQmr4l6ZyvSC1KdhYnkUUnhWprJqyirQm0KIBlm+
         TRsv2Ti9UZXpKOsHjpZSlBJ//mBec60XmA8oXxcE7Qulu1sam6flEpeAwNN0raOK/g5v
         grP1kDCRCHIi81S9c8LQIo6jem9q0naXfGC9TVmHYmRVSX0f6lEe88fHc+4hWcEgUbeA
         rS8MKZwEepMIRau5/SmCT5sR64aMfLtG0SQVkm8laNeVUcjjutKMJtNGY3ZQLLU3aITG
         E/vXEP5xcl4UQOyUeSK3m0bCkY+DSFByfvcE5RzERxMDPfRyA6Fv7PTcPIFBFPpSKPnX
         GScQ==
X-Gm-Message-State: AO0yUKW+hmA2TeyPDORj3FMVgu7rr3Y9MVSMNMPxNeMIuWbjAgYc3Nzb
        Zrbt6QGXhZTXdlRNNDQuiZw=
X-Google-Smtp-Source: AK7set9TRFLB1upmuVcX5UjgtG1sxlrPoCIajLvEZGXfwgMb/kRAvf6cPmcK37D8PAH9ddmrM+87KA==
X-Received: by 2002:a17:90a:3ec7:b0:234:106a:3490 with SMTP id k65-20020a17090a3ec700b00234106a3490mr93173pjc.40.1677522229201;
        Mon, 27 Feb 2023 10:23:49 -0800 (PST)
Received: from [10.69.71.131] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j5-20020a17090ac48500b00213202d77d9sm4597768pjt.43.2023.02.27.10.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 10:23:48 -0800 (PST)
Message-ID: <07ee8ccb-96c2-eb74-5c8d-65934dc051db@gmail.com>
Date:   Mon, 27 Feb 2023 10:23:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net] bgmac: fix *initial* chip reset to support BCM5358
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jon Mason <jon.mason@broadcom.com>,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Jon Mason <jdmason@kudzu.us>
References: <20230227091156.19509-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230227091156.19509-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/27/2023 1:11 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> While bringing hardware up we should perform a full reset including the
> switch bit (BGMAC_BCMA_IOCTL_SW_RESET aka SICF_SWRST). It's what
> specification says and what reference driver does.
> 
> This seems to be critical for the BCM5358. Without this hardware doesn't
> get initialized properly and doesn't seem to transmit or receive any
> packets.
> 
> Originally bgmac was calling bgmac_chip_reset() before setting
> "has_robosw" property which resulted in expected behaviour. That has
> changed as a side effect of adding platform device support which
> regressed BCM5358 support.
> 
> Fixes: f6a95a24957a ("net: ethernet: bgmac: Add platform device support")
> Cc: Jon Mason <jdmason@kudzu.us>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
