Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980686C9EE2
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 11:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbjC0JFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 05:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbjC0JFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 05:05:24 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B1259E8;
        Mon, 27 Mar 2023 02:04:35 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v1so7896725wrv.1;
        Mon, 27 Mar 2023 02:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679907875;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IeW3JOtl79P4h19QSrAjezOiQKqJvZ5XGjr/mFCgLF8=;
        b=KdPgUcOUttb4VuwP3TS2j+HxDR6qoeXv8hDgEMHfF8nKVpUKGv6KLG6rxR8dexRe4x
         bycDPB6vu67rXAgjz+Rt8/ovlklhiPBj6n4p+7iB2ERg1E/GFJsbuviHMjMAOLUR9EUf
         5J8Sa+5MqE73EnBceXFGBfcxY5Xt/TgOD7f4vNyEhoxYn/J18O4Ssw7C9uOEQP4Z4JM8
         IyRxsyOyr1iORBWFxDtRJf6UZeAJMz08DpzqaGK87bPVGsKq3lyzKsQ43IizJ36ERv2A
         YRrAmNHrdXWZNBxdZVq0rsdCnhXAzQRUY2ZCPMw+VfT1K9QFr+9KMHPccvRbU/8zAQMV
         9Q/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679907875;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IeW3JOtl79P4h19QSrAjezOiQKqJvZ5XGjr/mFCgLF8=;
        b=31EKEV+WCymb1rFcpRKNJi/20T02dYpbBzdJOspDm4cgWVDYF5zw6Gomc8Nl5Sa3Qr
         czsXghvscJiArh9WuUT16mXFUOEh0W1MF3nHD252lf+K6cdDRf6JFO2G+0wouk6uzLLo
         Rbsa/s5hv2Iwcuo4MombtV+U24pdT0x03oep3oBe8ad8A2A9KqsVSGpdzs07Kee+36g3
         Zpzdk98QqyaY62yGV2NOSeqqhTFtNbJdQU+X+++ppnToRoXo65ec5gwFwlCNN3LZj6mz
         i9/5oDsKA7f8GqzrDIoshAV9quCaw/hN22URMlwzuclzPeJB2RRi/xoBoK3pBkvyZ/ya
         +qnQ==
X-Gm-Message-State: AAQBX9erZB5gmqxG51s8KixKhnu/BXjnDQRh9W0VP1ieglVUBjK3GZm6
        keGhm8y/078tpcMuRNtHnlE5/1rYm05y4A==
X-Google-Smtp-Source: AKy350YNxkfy6IOA56E0WFYwIMXU7I9spsD1DLtgWxU5JCd/dMGUPvsMws1K0rdvEqgYxVdDzVDW+g==
X-Received: by 2002:adf:e484:0:b0:2ce:a938:ecc9 with SMTP id i4-20020adfe484000000b002cea938ecc9mr8877647wrm.69.1679907874447;
        Mon, 27 Mar 2023 02:04:34 -0700 (PDT)
Received: from [192.168.26.216] (54-240-197-230.amazon.com. [54.240.197.230])
        by smtp.gmail.com with ESMTPSA id h13-20020a5d430d000000b002d75ef32032sm17594498wrq.68.2023.03.27.02.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 02:04:34 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <990111ae-d2ba-5bfc-457d-bacb2b6ffb43@xen.org>
Date:   Mon, 27 Mar 2023 10:04:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Reply-To: paul@xen.org
Subject: Re: [PATCH 2/2] xen/netback: remove not needed test in
 xenvif_tx_build_gops()
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, Jan Beulich <jbeulich@suse.com>
References: <20230327083646.18690-1-jgross@suse.com>
 <20230327083646.18690-3-jgross@suse.com>
Organization: Xen Project
In-Reply-To: <20230327083646.18690-3-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/03/2023 09:36, Juergen Gross wrote:
> The tests for the number of grant mapping or copy operations reaching
> the array size of the operations buffer at the end of the main loop in
> xenvif_tx_build_gops() isn't needed.
> 
> The loop can handle at maximum MAX_PENDING_REQS transfer requests, as
> XEN_RING_NR_UNCONSUMED_REQUESTS() is taking unsent responses into
> consideration, too.
> 
> Remove the tests.
> 
> Suggested-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>   drivers/net/xen-netback/netback.c | 4 ----
>   1 file changed, 4 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

