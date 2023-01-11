Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35A8666172
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjAKRKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235478AbjAKRKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:10:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFD7F31;
        Wed, 11 Jan 2023 09:10:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E311B81C86;
        Wed, 11 Jan 2023 17:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69894C433D2;
        Wed, 11 Jan 2023 17:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673457001;
        bh=p719b2ISjyf+YPNA9dbKz3wlg67/k0ApyjDAH08j7Tk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RvVPbRKYjaAAQ4+jbd4dhglkOO2KoEjbiPasXy+VT3UOECxvA+EUs0oHChpG7w+FN
         tGllqFslZQFEea2+YyGnIhA8zOSYGPn2XlF3qwTH2X5AH6YVpVmSyr1uT6k35PwBQ2
         LnrnRQVwM/Gi5XHb0JBd5bZy3soTHaXRpUr9NUwRRK2xfoycaVWCGpRV+YZeE3BAXB
         UHtjeYT5+5OiwU2lP51va/W8N7W5cmeTJASFmwSjwtj8AxQReVIlnMnPxpQ4Bk7AGN
         wtTfPxDuRCaP4+wh5lzL/tj5kGx3LYDQhz5aqxLxx0bhvzy9oYRCtCQqfxz2z8VCz0
         vgg1FqSx2oscg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        Robert Marko <robimarko@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, elder@linaro.org,
        hemantk@codeaurora.org, quic_jhugo@quicinc.com,
        quic_qianyu@quicinc.com, bbhatt@codeaurora.org,
        mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, ansuelsmth@gmail.com
Subject: Re: [PATCH 2/2] wifi: ath11k: use unique QRTR instance ID
References: <20221105194943.826847-1-robimarko@gmail.com>
        <20221105194943.826847-2-robimarko@gmail.com>
        <20221107174727.GA7535@thinkpad> <87cz9xcqbd.fsf@kernel.org>
        <877czn8c2n.fsf@kernel.org>
        <CA+HBbNFCFtJwzN=6SCsWnDmAjPkmxE4guH1RrLc+-HByLcVVXA@mail.gmail.com>
        <87k02jzgkz.fsf@kernel.org>
        <CA+HBbNHi0zTeV0DRmwLjZu+XzUQEZQNnSpBMeQeUPiBu3v-2BQ@mail.gmail.com>
Date:   Wed, 11 Jan 2023 19:09:54 +0200
In-Reply-To: <CA+HBbNHi0zTeV0DRmwLjZu+XzUQEZQNnSpBMeQeUPiBu3v-2BQ@mail.gmail.com>
        (Robert Marko's message of "Wed, 11 Jan 2023 10:21:14 +0100")
Message-ID: <87358hyp3x.fsf@kernel.org>
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

Robert Marko <robert.marko@sartura.hr> writes:

>> Really sorry, I just didn't manage to get this finalised due to other
>> stuff and now I'm leaving for a two week vacation :(
>
> Any news regarding this, I have a PR for ipq807x support in OpenWrt
> and the current workaround for supporting AHB + PCI or multiple PCI
> cards is breaking cards like QCA6390 which are obviously really
> popular.

Sorry, came back only on Monday and trying to catch up slowly. But I
submitted the RFC now:

https://patchwork.kernel.org/project/linux-wireless/patch/20230111170033.32454-1-kvalo@kernel.org/

Please take a look and let me know what you think.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
