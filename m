Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E055274EE
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 04:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbiEOCQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 22:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233368AbiEOCQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 22:16:16 -0400
Received: from novek.ru (unknown [93.153.171.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BD113D56
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 19:16:14 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id B082550437F;
        Sun, 15 May 2022 05:15:19 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru B082550437F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1652580922; bh=lMc0pm8o/YRFoX/3CkM3mE46faXj7FcBFaZVX++BsEU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=m6kJ5hg+N94aFe4hQttSeycu0cgpQd7WrX+y6KA9Cf5JJk8tAUJ+XQbeX8QXHoPoJ
         Tv0jRNUrDRLWsHbuDexyjMrHijGYLWrTgHQxLHMJaLJQcVbysvYm/txOJjIlmydZ34
         Vo5+ffhxwa7ZNqEgnILA4+bBWOSURSpBv3DZXqnI=
Message-ID: <aacc11bb-64db-9402-ccc4-889954b034d7@novek.ru>
Date:   Sun, 15 May 2022 03:16:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net v2] ptp: ocp: have adjtime handle negative delta_ns
 correctly
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, kernel-team@fb.com
References: <20220513225231.1412-1-jonathan.lemon@gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220513225231.1412-1-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.05.2022 23:52, Jonathan Lemon wrote:
> delta_ns is a s64, but it was being passed ptp_ocp_adjtime_coarse
> as an u64.  Also, it turns out that timespec64_add_ns() only handles
> positive values, so perform the math with set_normalized_timespec().
> 
> Fixes: 90f8f4c0e3ce ("ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments")
> Suggested-by: Vadim Fedorenko <vfedorenko@novek.ru>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Acked-by: Vadim Fedorenko <vfedorenko@novek.ru>
