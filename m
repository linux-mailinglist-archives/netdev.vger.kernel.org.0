Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A580661642
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 16:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjAHPpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 10:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjAHPpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 10:45:21 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DFFFCE7
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 07:45:20 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id s9so5836415wru.13
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 07:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5lUNU/2LnxHy71s+RNzB8twooobGE4TdibjGwC5aGDo=;
        b=EQxeUB6SwYT20MUHkPhFiNw1Ugd+C3AXCmL6Y9PMbUA+kVOQY7VTFTXotaCv0vb1KD
         Rtrgczknqi6Qmc3kTY5rkco3pjhVjjEcjAKa7GmuD37yO8966+9i3atyaNJ5cujGcOPS
         qsBp0Ua9Yy9HFqsYrFMmKiVizPesgLUwFGtZ1RHtjF4n3RLL3H3xvwfBZpBw912QI+Dy
         qMkguuwKjMhcss7/IfF6/+HZL8Jff+Ebw3+5Fwwf4pqAGpsZueNHz7XldkvAOv+tm/vu
         Iy/oJjBICAX333j/5RookqlYoBPm3a0sq+XUun9JRimhll5jw7MYK2LkMTKNXVqLXBi+
         Hy5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5lUNU/2LnxHy71s+RNzB8twooobGE4TdibjGwC5aGDo=;
        b=dSAd6uvlWPvoeMRRbzHl4orczO+Q00lM5cKFVYSkhjAWQurZe1iw3aUOMcNzl4U7Ds
         VPFuMEWG1HudgIFrXFujB0ZWRPGY1sOUOAvWyUjo57hb0silWlmcnV+67lgh8gDR6c2P
         U+uTqGGmER8+Mrs3YhOOHMrvqyh/1ighlPqCbwInx3bvkhEpCW14OytvA+TlUbsP8xLX
         ENSnDGa+t9BUpfWhHwO32XnMo/kQSTinG3RgMFJv8XDt1EPkXp9SFCszKENZdYHR/RYJ
         hWzzPQmmCrwbiOO23Hsg8yA+lcCwuruTRl97RlBYFSQZ+ueX2UPsUKoevDnztu9SZyzy
         rFxA==
X-Gm-Message-State: AFqh2kovx3U2pXEgI/zQfIG9soQFDziSdeyyEZG9qQwWzu92twBAG8e2
        8dRyxPFZeOpvr/8yiFyDyrq15g==
X-Google-Smtp-Source: AMrXdXtOmd+GQD//e/TfxCoGLNQM9uN5kqGICNBqraIO9cvKT4s4gnNvl3ns/9B3NKuNeevxV32nOw==
X-Received: by 2002:a5d:4ac5:0:b0:273:bdf5:663a with SMTP id y5-20020a5d4ac5000000b00273bdf5663amr43555470wrs.26.1673192719027;
        Sun, 08 Jan 2023 07:45:19 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id s10-20020adfea8a000000b002421ed1d8c8sm6204660wrm.103.2023.01.08.07.45.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jan 2023 07:45:18 -0800 (PST)
Message-ID: <f02fc413-43e7-f405-ed86-13a96846a1a8@linaro.org>
Date:   Sun, 8 Jan 2023 16:45:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3] net: nfc: Fix use-after-free in local_cleanup()
Content-Language: en-US
To:     Jisoo Jang <jisoo.jang@yonsei.ac.kr>, pabeni@redhat.com,
        netdev@vger.kernel.org
Cc:     edumazet@google.com, kuba@kernel.org, dokyungs@yonsei.ac.kr,
        linuxlovemin@yonsei.ac.kr
References: <20230106063253.877394-1-jisoo.jang@yonsei.ac.kr>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230106063253.877394-1-jisoo.jang@yonsei.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/2023 07:32, Jisoo Jang wrote:
> Fix a use-after-free that occurs in kfree_skb() called from
> local_cleanup(). When detaching an nfc device, local_cleanup()
> called from nfc_llcp_unregister_device() frees local->rx_pending
> and cancels local->rx_work. So the socket allocated before
> unregister is not set null by nfc_llcp_rx_work().

How nfc_llcp_rx_work() is related to this case? It would if there was a
race condition to which your fix does nothing (so does not close any
race). If there is no race condition, drop the sentence, it is confusing.

If there is a race condition, this is not sufficient fix.

> local_cleanup() called from local_release() frees local->rx_pending
> again, which leads to the bug.
> 
> Set local->rx_pending to NULL in local_cleanup()
> 
> Found by a modified version of syzkaller.
> 
> BUG: KASAN: use-after-free in kfree_skb
> Call Trace:
>  kfree_skb
>  local_cleanup
>  nfc_llcp_local_put
>  llcp_sock_destruct
>  __sk_destruct
>  sk_destruct
>  __sk_free
>  sk_free
>  llcp_sock_release
>  __sock_release
>  sock_close
>  __fput
>  task_work_run
>  exit_to_user_mode_prepare
>  syscall_exit_to_user_mode
>  do_syscall_64
>  entry_SYSCALL_64_after_hwframe

decode_stacktrace.sh could be useful here.

Best regards,
Krzysztof

