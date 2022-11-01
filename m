Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6D36145EF
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 09:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiKAIq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 04:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiKAIqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 04:46:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DFE186DB;
        Tue,  1 Nov 2022 01:46:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 85038CE1AE5;
        Tue,  1 Nov 2022 08:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D0CC433B5;
        Tue,  1 Nov 2022 08:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667292363;
        bh=FpS71S38hnMEG7b0x8rTpo/7NG3z6UPDtnm8A5gut/c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KAiXBG6nPHNt2pYgB6pV6ZYv+3QBPsPPCJaZWFdELNuii6ARso75uFKAlFKhBn9jp
         En3G6T0mWzAC/cgwp5wLX3IytGYqgI+WiXbfyuAb2mLsJRcUcHTeDVbas8fmfYU6+r
         I+vcQ0IGqnHEoFlOyOqtf1H3su+Ln2t8JvvPSgrYBCvgGg27+fx7jBw8jVqLsYqx+L
         XKl3LjksH8ZGGob2SNT6Y4/X6qvsBy05G6ZjBurjU7cGketff8ls40XvrPjFPfqHoC
         mvwTMr2+/m63uOd8kfdBkdsqNgSSzFaIg0m1/KWHDRAKZ+2OjfVwj4troQWknS95XC
         6Mln+zkrIX8xA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        linux-kernel@vger.kernel.org, Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ath11k (gcc13): synchronize ath11k_mac_he_gi_to_nl80211_he_gi()'s return type
References: <20221031114341.10377-1-jirislaby@kernel.org>
        <55c4d139-0f22-e7ba-398a-e3e0d8919220@quicinc.com>
        <833c7f2f-c140-5a0b-1efc-b858348206ec@kernel.org>
Date:   Tue, 01 Nov 2022 10:45:56 +0200
In-Reply-To: <833c7f2f-c140-5a0b-1efc-b858348206ec@kernel.org> (Jiri Slaby's
        message of "Tue, 1 Nov 2022 06:49:25 +0100")
Message-ID: <87bkprgj0b.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Slaby <jirislaby@kernel.org> writes:

> On 31. 10. 22, 22:16, Jeff Johnson wrote:
>
>> On 10/31/2022 4:43 AM, Jiri Slaby (SUSE) wrote:
>>> ath11k_mac_he_gi_to_nl80211_he_gi() generates a valid warning with
>>> gcc-13:
>>> =C2=A0=C2=A0 drivers/net/wireless/ath/ath11k/mac.c:321:20: error: confl=
icting
>>> types for 'ath11k_mac_he_gi_to_nl80211_he_gi' due to enum/integer
>>> mismatch; have 'enum nl80211_he_gi(u8)'
>>> =C2=A0=C2=A0 drivers/net/wireless/ath/ath11k/mac.h:166:5: note: previous
>>> declaration of 'ath11k_mac_he_gi_to_nl80211_he_gi' with type
>>> 'u32(u8)'
>>>
>>> I.e. the type of the return value ath11k_mac_he_gi_to_nl80211_he_gi() in
>>> the declaration is u32, while the definition spells enum nl80211_he_gi.
>>> Synchronize them to the latter.
>>>
>>> Cc: Martin Liska <mliska@suse.cz>
>>> Cc: Kalle Valo <kvalo@kernel.org>
>>> Cc: "David S. Miller" <davem@davemloft.net>
>>> Cc: Eric Dumazet <edumazet@google.com>
>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>> Cc: Paolo Abeni <pabeni@redhat.com>
>>> Cc: ath11k@lists.infradead.org
>>> Cc: linux-wireless@vger.kernel.org
>>> Cc: netdev@vger.kernel.org
>>> Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
>>
>> Suggest the subject should be
>> wifi: ath11k: synchronize ath11k_mac_he_gi_to_nl80211_he_gi()'s return t=
ype
>
> FWIW I copied from:
> $ git log --format=3D%s  drivers/net/wireless/ath/ath11k/mac.h
> ath11k: Handle keepalive during WoWLAN suspend and resume
> ath11k: reduce the wait time of 11d scan and hw scan while add interface
> ath11k: Add basic WoW functionalities
> ath11k: add support for hardware rfkill for QCA6390
> ath11k: report tx bitrate for iw wlan station dump
> ath11k: add 11d scan offload support
> ath11k: fix read fail for htt_stats and htt_peer_stats for single pdev
> ath11k: add support for BSS color change
> ath11k: add support for 80P80 and 160 MHz bandwidth
> ath11k: Add support for STA to handle beacon miss
> ath11k: add support to configure spatial reuse parameter set
> ath11k: remove "ath11k_mac_get_ar_vdev_stop_status" references
> ath11k: Perform per-msdu rx processing
> ath11k: fix incorrect peer stats counters update
> ath11k: Move mac80211 hw allocation before wmi_init command
> ath11k: fix missed bw conversion in tx completion
> ath11k: driver for Qualcomm IEEE 802.11ax devices

Yeah, using "wifi:" is a new prefix we started using with wireless
patches this year.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
