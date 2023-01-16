Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980D166C38D
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 16:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbjAPPWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 10:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjAPPVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 10:21:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF4E22A1D;
        Mon, 16 Jan 2023 07:18:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A9A6B80FEE;
        Mon, 16 Jan 2023 15:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276E9C433F0;
        Mon, 16 Jan 2023 15:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673882319;
        bh=vmGFW004UDwsmgRU4Zufg89JY7mnDaECKq1b+4Q7dW8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=P7EsXdVtcWoVtSQUl+9hIOkc1Lqa6E2dCm9xSqlpzYBgAbdky9aRY85PjXEhRq8/Z
         Hay1qBB/3wovNYTx6blXLJNJBzIgX+nKzvNFMC66+r12zXg8d15cGd5pPMEZfiubi6
         u0Pg8Ba5SpFM1DiMV9ULRiCrTDFToS/SDUJd+ro+sVbjLt5CRgHUYvG36d/up89Mce
         ZViAQXOLasukY7nsYa4myRp4RCupUFW7CDYtsPl2ubaJPnFxRViYCSAKkLW3sYySNX
         yFh5T1/VHiF4wZmnCcIxoXy69RPTtkWCf5FiZ9EMof143ok8xRZ6O1+1YRbRcydrW0
         1hRjaPEpjZKyA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     yang.yang29@zte.com.cn, aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        sha-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.panda@zte.com.cn
Subject: Re: [PATCH net-next] brcm80211: use strscpy() to instead of strncpy()
References: <202212231037210142246@zte.com.cn>
        <167387451256.32134.6493247488948126794.kvalo@kernel.org>
        <Y8VRpzodki/YAcvC@unreal>
Date:   Mon, 16 Jan 2023 17:18:32 +0200
In-Reply-To: <Y8VRpzodki/YAcvC@unreal> (Leon Romanovsky's message of "Mon, 16
        Jan 2023 15:31:19 +0200")
Message-ID: <87y1q2y0c7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leon Romanovsky <leon@kernel.org> writes:

> On Mon, Jan 16, 2023 at 01:08:36PM +0000, Kalle Valo wrote:
>> <yang.yang29@zte.com.cn> wrote:
>> 
>> > From: Xu Panda <xu.panda@zte.com.cn>
>> > 
>> > The implementation of strscpy() is more robust and safer.
>> > That's now the recommended way to copy NUL-terminated strings.
>> > 
>> > Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
>> > Signed-off-by: Yang Yang <yang.yang29@zte.com>
>> 
>> Mismatch email in From and Signed-off-by lines:
>> 
>> From: <yang.yang29@zte.com.cn>
>> Signed-off-by: Yang Yang <yang.yang29@zte.com>
>> 
>> Patch set to Changes Requested.
>
> Kalle, please be aware of this response
> https://lore.kernel.org/netdev/20230113112817.623f58fa@kernel.org/
>
> "I don't trust that you know what you're doing. So please don't send
> any more strncpy() -> strscpy() conversions for networking."

Good to know, thanks.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
