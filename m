Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B1564C785
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 11:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238096AbiLNK5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 05:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237936AbiLNK5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 05:57:36 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A38223EB1
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 02:57:35 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id ja17so8025521wmb.3
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 02:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:cc:to:organization:subject:from
         :content-language:reply-to:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T8kO0cf+ecnpn7Ch0hIeRV7skrYRYjdX2x8vsgPWpzk=;
        b=KXKhH+RckKWRUK8MQHYMJnfQAbkMAJYgpY6wxuMaBqrx+vuRaRMiEme63OtSQVrPV/
         +H2ej5UlMV0XwQ3CrANoBj6mVTa0cLS8hrFUdsJe9eKJ2nDXj77W4u/raRrZLbsgA1CQ
         iGQ9q73GIxUoww9qIMd0NF8XLsMZwjRs3cARyWyokqqOzLPDbV7ZRKi4JfZBRv5mmKgo
         cRJC7wjIBO49ANyQPrY7Z+0MASKaPr6tKIIF4oRViBumuB4aC3jEMFqeLK3a0Zww5Zc7
         kkPwolvtA4Mv4KI76u0bWXTaD8iS67lHxQ50OiwptvFKc3zbm8qyeWYWbTjpgpkKMNNe
         L2Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:organization:subject:from
         :content-language:reply-to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T8kO0cf+ecnpn7Ch0hIeRV7skrYRYjdX2x8vsgPWpzk=;
        b=GtjysXSFeBYCWZHILa6cezQNjDbzLIbnGCKdW4xT2vJHNzavFiLbGbp23dE7VUGI9+
         ZW3K8ekw85xD4ITu0ACYqr2Y8BLww0udurMq0hZNoDW1xi0R0bezsH5TdF1y+zKe/udf
         jkhH+j2TgoA4l+YRwdW0Ixqh8oVbIXq81Ts2Kd9zhpy4pEkWDjKBD8dVO/YKbXERvYqn
         UHsSH3ssW8mS6MZNtawXDtQRp2WehQd1J3ZkYutidBa8YTX8v2fH+GZsTWRjnMiUleAG
         mc6GoA5b9V+mXYDGymHLPGm92vjBAT0TJQRjsU3ZFODQji2KE5nf1AjgmBviDe5w5mpR
         VrHA==
X-Gm-Message-State: ANoB5pmotn2nxrxgSG6DhUcwQZVeYiYsGW0BnIbRM+yVlXFJqwzjawWS
        jqI8T6Hzoc1UjhIRdpXN7Iy4NNOuFsGQsr5X
X-Google-Smtp-Source: AA0mqf6E4Bz9NkCcpXdciOkr+stdaRcbJsYa5zXeXqRR/JsD8DOBmeKUnBBlRTQywYmMPPFoZzhRHQ==
X-Received: by 2002:a05:600c:601c:b0:3cf:fc0b:3359 with SMTP id az28-20020a05600c601c00b003cffc0b3359mr18534475wmb.0.1671015453946;
        Wed, 14 Dec 2022 02:57:33 -0800 (PST)
Received: from ?IPV6:2a01:e0a:b41:c160:ec4b:78c8:feb3:5813? ([2a01:e0a:b41:c160:ec4b:78c8:feb3:5813])
        by smtp.gmail.com with ESMTPSA id p16-20020a1c5450000000b003d07de1698asm1958164wmi.46.2022.12.14.02.57.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Dec 2022 02:57:33 -0800 (PST)
Message-ID: <b5353d33-728e-db34-e65b-d94cddaf8547@6wind.com>
Date:   Wed, 14 Dec 2022 11:57:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Reply-To: nicolas.dichtel@6wind.com
Content-Language: en-US
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Request for "net: bpf: Allow TC programs to call
 BPF_FUNC_skb_change_head" in 5.4
Organization: 6WIND
To:     stable <stable@vger.kernel.org>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I would like to request for cherry-picking commit 6f3f65d80dac (linux v5.8) in
the linux-5.4.y branch.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6f3f65d80dac

This commit is trivial, the potential regressions are low. The cherry-pick is
straightforward.
The kernel 5.4 is used by a lot of vendors, having this patch will help
supporting standard ebpf programs.

Regards,
Nicolas
