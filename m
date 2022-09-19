Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDBB5BCC0B
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 14:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiISMmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 08:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiISMmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 08:42:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1499B38A7;
        Mon, 19 Sep 2022 05:42:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5D8161BBC;
        Mon, 19 Sep 2022 12:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63C5C433C1;
        Mon, 19 Sep 2022 12:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663591366;
        bh=5YMfYGPidhjUcu5gKVhMTnepXT5HmE6p4KDzCeRUFzc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=qb2QCvRHFqWNN+1oerIA2AFGZicYV/jrd9RehDCxkmboD0qukgWcdTcS0BwIDsoxP
         W1qPA+EIVMs/TIs9uhfvjaXxb5ty/zWhAQt9tk2hrYr3926d84ztm9ksl+rAQSXrun
         AMMgix7f4z5etC2mdp2iWZ2fbLHbcvyeAEx3fiVqHF2WdTzyJ2w8yN/vQdev2gmlnU
         PassOVv7+NysUGgIK7qhonfZMIk/IyH81RT3dLIRk7+e1hn3bzaZBAXdagAVME82ye
         ZrGpQSUBdkP0dHxUW6QTGYTHxOIae2Be9djHlVPi1MRKNByIU4Ya4jgkCAonJ9hZbf
         nC8lZt76mJGUQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/1] wcn36xx: Add RX frame SNR as a source of system
 entropy
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220915004117.1562703-2-bryan.odonoghue@linaro.org>
References: <20220915004117.1562703-2-bryan.odonoghue@linaro.org>
To:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     loic.poulain@linaro.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        bryan.odonoghue@linaro.org, "Jason A . Donenfeld" <Jason@zx2c4.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166359136168.17652.16916114902781460375.kvalo@kernel.org>
Date:   Mon, 19 Sep 2022 12:42:43 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bryan O'Donoghue <bryan.odonoghue@linaro.org> wrote:

> The signal-to-noise-ratio SNR is returned by the wcn36xx firmware for each
> received frame. SNR represents all of the unwanted interference signal
> after filtering out the fundamental frequency and harmonics of the
> frequency.
> 
> Noise can come from various electromagnetic sources, from temperature
> affecting the performance hardware components or quantization effects
> converting from analog to digital domains.
> 
> The SNR value returned by the WiFi firmware then is a good source of
> entropy.
> 
> Other WiFi drivers offer up the noise component of the FFT as an entropy
> source for the random pool e.g.
> 
> commit 2aa56cca3571 ("ath9k: Mix the received FFT bins to the random pool")
> 
> I attended Jason's talk on sources of randomness at Plumbers and it
> occurred to me that SNR is a reasonable candidate to add.
> 
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

e1a6b5d3a971 wifi: wcn36xx: Add RX frame SNR as a source of system entropy

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220915004117.1562703-2-bryan.odonoghue@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

