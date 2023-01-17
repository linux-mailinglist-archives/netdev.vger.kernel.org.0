Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D6166E4CB
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjAQRWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjAQRWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:22:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB964C6E9;
        Tue, 17 Jan 2023 09:21:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 114DFB81928;
        Tue, 17 Jan 2023 17:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E2CC433D2;
        Tue, 17 Jan 2023 17:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673976075;
        bh=skvQqBc/hwy9a+RMCgjlCVkjG/y6LmVz/zErbnp5Lc8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sdJmhwj6QVo0M9LgC8ByvkE7SKmZchZKL/UR8b7SRvTMUsbWup3siR35ELAIvWeLj
         Q2lauiIXU98vjbpakY7/TzlJcGYPwmN3lOS8bLLK9bdrZoOAxHl4PBHBT/gV0Eonaj
         HwuEPrz09kSA3gk4PAYMO8MPnaXrU9sU1T7qS1cWVZHb3D7BgVMnGfpOcuOZ97E8uA
         MwrFy5zysH7MaZIc84G9KSmSnL2O+gjMbiSeyK+fu0nV85rsM4lnyxL0DSdARR5WZF
         BLCAJMmgob6uAuvsTtH/Awl0R5/AfV6D5Venh81Mmkd844xRH6tDAa3dxZ65ArPT3w
         0zG/bcLxXYEWQ==
Date:   Tue, 17 Jan 2023 09:21:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: Re: [RFC PATCH v1 00/19] rtw88: Add SDIO support
Message-ID: <20230117092114.62ba2f66@kernel.org>
In-Reply-To: <87y1q28o5a.fsf@kernel.org>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
        <87y1q28o5a.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Jan 2023 18:01:05 +0200 Kalle Valo wrote:
> > - My understanding is that there's a discussion about the rtw88 Kconfig
> >   symbols. We're adding four new ones within this series. It's not
> >   clear to me what the conclusion is on this topic though.  
> 
> Yeah, there were no conclusions about that. Jakub, do you have any
> opinions? For example, do we keep per device Kconfig options (eg.
> CONFIG_RTW88_8822BS, RTW88_8822CS and so on) or should we have only one
> more bus level option (eg. CONFIG_RTW88_SDIO)? rtw88 now uses the former
> and IIRC so does mt76. ath10k/ath11k/ath12k again use the latter :)

No strong feelings. Larry (IIRC) provided a fair justification for 
the RTW symbols. If the module binary grows noticeably then having 
the kconfig does indeed make sense.
