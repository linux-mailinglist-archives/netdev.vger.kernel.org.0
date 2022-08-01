Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B2E5867E9
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 13:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbiHALIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 07:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiHALIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 07:08:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857D22983C;
        Mon,  1 Aug 2022 04:08:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1565E61204;
        Mon,  1 Aug 2022 11:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A43AC433C1;
        Mon,  1 Aug 2022 11:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659352087;
        bh=75+1KdzYHTZlyUsVC4eEsaQcWvYjN/ftK8fNS9CwJo4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dvsN422SbI+dAau1YpFgv73JplI7hOjbsGqMOtHj0bMp35vq2mpux0hheKo5hhs9N
         lHDUo6lORkbnscHTk1eqFDWozHyBZYmmIvVcfBDiA0tGnFp2PNxX+/ZU+5Kv/v8wpo
         HRbrsocCDikZ590IoG6e67ti1CQBCzn0ITxGNRVFAte9T+MJ4G2TzLFB2hpKhjtzns
         3SGw8rACjTe4WD6eK5gIuf3VFDj4HVwrNRz3KR2i/Nq4k+W3gD3qOFYwPihB/i+tbm
         M3OkATqNe2ZQrnrALC9E2KFoohOvNRypeOIgYKVgTOpzbXt22IwIIS2bqO3FJUJy0G
         GKveOCUUDgSRg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        ajay.kathat@microchip.com
Subject: Re: pull-request: wireless-next-2022-07-29
References: <20220729192832.A5011C433D6@smtp.kernel.org>
        <20220729193858.664c59f4@kernel.org>
Date:   Mon, 01 Aug 2022 14:08:01 +0300
In-Reply-To: <20220729193858.664c59f4@kernel.org> (Jakub Kicinski's message of
        "Fri, 29 Jul 2022 19:38:58 -0700")
Message-ID: <87y1w8mdbi.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 29 Jul 2022 19:28:32 +0000 (UTC) Kalle Valo wrote:
>> Hi,
>> 
>> here's a pull request to net-next tree, more info below. Please let me know if
>> there are any problems.
>
> Sparse complains about this spurious inline:
>
> +++ b/drivers/net/wireless/microchip/wilc1000/hif.h
> @@ -206,13 +206,14 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats);
>  void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length);
>  void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
>                                 struct cfg80211_crypto_settings *crypto);
>  int wilc_set_default_mgmt_key_index(struct wilc_vif *vif, u8 index);
> +inline void wilc_handle_disconnect(struct wilc_vif *vif);
>
> drivers/net/wireless/microchip/wilc1000/hif.h:218:35: error: marked inline, but without a definition

Sorry about that, I missed it during review. Fix submitted now:

https://patchwork.kernel.org/project/linux-wireless/patch/20220801110440.13144-1-kvalo@kernel.org/

You'll get it in the next pull request.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
