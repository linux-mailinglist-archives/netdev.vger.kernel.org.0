Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98CE654238
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 14:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbiLVN5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 08:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiLVN5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 08:57:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2952913EA3;
        Thu, 22 Dec 2022 05:57:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6538B81DA5;
        Thu, 22 Dec 2022 13:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762F8C433D2;
        Thu, 22 Dec 2022 13:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671717458;
        bh=m4BhhoLs0SHSKY2sSWcAGIJSCilLlLfjaBNVjEGhwrk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=H0HmuXkswh4X+/si5WMZLDgC3liPMt970G+q2tQfnquI1pj+PPHnfQnODoFI7O6BU
         vCqid/QYSGzhb5O4oBz/AQveVeGK9eksEAtP5VacivcbqkBq1c+pG5JpGGI9ANkqyO
         Y/IVN9xYYunIt4P3S762X4yYZWCSoSCp5zOG9gXJAOBryZFrijM1ko6OTgSZEvZ0IK
         lXc4OorgtqD2fpkZaL15nj2mJXViNFK15QfrDiEUkO5IBN/MWhtoyd4NxoUw9ZRrFM
         OtqSElmmHoJ+oMFQVvATKrv0ym1/OI9G/C8TVgxE8bTAJWRmUYwVOGmdxpBlxWqeSc
         jvSalIjQT65Cw==
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
Date:   Thu, 22 Dec 2022 15:57:32 +0200
In-Reply-To: <CA+HBbNFCFtJwzN=6SCsWnDmAjPkmxE4guH1RrLc+-HByLcVVXA@mail.gmail.com>
        (Robert Marko's message of "Wed, 14 Dec 2022 13:02:42 +0100")
Message-ID: <87k02jzgkz.fsf@kernel.org>
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

> On Tue, Nov 22, 2022 at 12:26 PM Kalle Valo <kvalo@kernel.org> wrote:
>
>>
>> Kalle Valo <kvalo@kernel.org> writes:
>>
>> > Manivannan Sadhasivam <mani@kernel.org> writes:
>> >
>> >> On Sat, Nov 05, 2022 at 08:49:43PM +0100, Robert Marko wrote:
>> >>> Currently, trying to use AHB + PCI/MHI cards or multiple PCI/MHI cards
>> >>> will cause a clash in the QRTR instance node ID and prevent the driver
>> >>> from talking via QMI to the card and thus initializing it with:
>> >>> [    9.836329] ath11k c000000.wifi: host capability request failed: 1 90
>> >>> [    9.842047] ath11k c000000.wifi: failed to send qmi host cap: -22
>> >>>
>> >>
>> >> There is still an outstanding issue where you cannot connect two WLAN modules
>> >> with same node id.
>> >>
>> >>> So, in order to allow for this combination of cards, especially AHB + PCI
>> >>> cards like IPQ8074 + QCN9074 (Used by me and tested on) set the desired
>> >>> QRTR instance ID offset by calculating a unique one based on PCI domain
>> >>> and bus ID-s and writing it to bits 7-0 of BHI_ERRDBG2 MHI register by
>> >>> using the SBL state callback that is added as part of the series.
>> >>> We also have to make sure that new QRTR offset is added on top of the
>> >>> default QRTR instance ID-s that are currently used in the driver.
>> >>>
>> >>
>> >> Register BHI_ERRDBG2 is listed as Read only from Host as per the BHI spec.
>> >> So I'm not sure if this solution is going to work on all ath11k supported
>> >> chipsets.
>> >>
>> >> Kalle, can you confirm?
>> >
>> > I can't look at this in detail right now, but hopefully in few days.
>> > I'll get back to you.
>>
>> The solution we have been thinking internally would not use
>> MHI_CB_EE_SBL_MODE at all, it's not clear for me yet why the mode was
>> not needed in our solution. Maybe there are firmware modifications? I
>> think it's best that we submit our proposal as well, then we can then
>> compare implementations and see what is the best course of action.
>
> Kalle, any ETA when you will post your idea? I am constantly hitting
> this crazy limitation and my idea does not work on cards like QCA6390
> so it's not a viable workaround at all.

Really sorry, I just didn't manage to get this finalised due to other
stuff and now I'm leaving for a two week vacation :(

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
