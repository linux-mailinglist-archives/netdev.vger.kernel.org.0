Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B96F6B075C
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 13:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjCHMn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 07:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjCHMn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 07:43:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0EB5D8AE;
        Wed,  8 Mar 2023 04:43:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B9D96178F;
        Wed,  8 Mar 2023 12:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA996C433D2;
        Wed,  8 Mar 2023 12:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678279403;
        bh=DocI4dram1oaC2Qxu/FVDptKl4AwjtU4IjvD88IptJQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=S1OcYFQhrdN0g87cCs7ucc59mYtX+9rZx1K3co4u0/4mnfPQTJa0Htd86uTqQbJAd
         E32xrPsntaL2VE59IPZPYKNFWQCweqb132+OzEfgrwxY6/2lqs4OBaVUba0wiid4hV
         BFzc3w8ujd6hCct6aT3bFarUZh3vCioIQAChUi43k/slsd7Au3aa+10ug7n56GWSQh
         JBMrDULJzkmOv5CzRJ1pfbPTrpo6aGEkXsnb2okTd66UHBZ0Zvv4rWZm/kK94TZW+P
         E9BlraHJ4sayQuF7aGEo8bYma/UOlCWhJShBfMVy0wsZ/B+6D6N4tP+D4BQRWASw3O
         IgYdgx7wNCvkQ==
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
        <87358hyp3x.fsf@kernel.org>
        <CA+HBbNGdOrOiCxhSouZ6uRPRnZmsBSAL+wWpLkczMK9cO8Mczg@mail.gmail.com>
        <877cxsdrax.fsf@kernel.org>
        <CA+HBbNGbg88_3FDu+EZhqMj0UKb8Ja_vyYsxGtmJ_HGt4fNVBQ@mail.gmail.com>
        <87y1q8ccc4.fsf@kernel.org>
        <CA+HBbNH2fzr_knOE9EWD4bUi-guvRa07FAxc9WyCH0jK10BLvw@mail.gmail.com>
Date:   Wed, 08 Mar 2023 14:43:16 +0200
In-Reply-To: <CA+HBbNH2fzr_knOE9EWD4bUi-guvRa07FAxc9WyCH0jK10BLvw@mail.gmail.com>
        (Robert Marko's message of "Mon, 23 Jan 2023 20:21:08 +0100")
Message-ID: <87fsafpg63.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robert Marko <robert.marko@sartura.hr> writes:

> On Thu, Jan 12, 2023 at 10:49 AM Kalle Valo <kvalo@kernel.org> wrote:
>
>>
>> Robert Marko <robert.marko@sartura.hr> writes:
>>
>> > On Thu, Jan 12, 2023 at 10:40 AM Kalle Valo <kvalo@kernel.org> wrote:
>> >>
>> >> Robert Marko <robert.marko@sartura.hr> writes:
>> >>
>> >> > On Wed, Jan 11, 2023 at 6:10 PM Kalle Valo <kvalo@kernel.org> wrote:
>> >> >>
>> >> >> Robert Marko <robert.marko@sartura.hr> writes:
>> >> >>
>> >> >> >> Really sorry, I just didn't manage to get this finalised due to other
>> >> >> >> stuff and now I'm leaving for a two week vacation :(
>> >> >> >
>> >> >> > Any news regarding this, I have a PR for ipq807x support in OpenWrt
>> >> >> > and the current workaround for supporting AHB + PCI or multiple PCI
>> >> >> > cards is breaking cards like QCA6390 which are obviously really
>> >> >> > popular.
>> >> >>
>> >> >> Sorry, came back only on Monday and trying to catch up slowly. But I
>> >> >> submitted the RFC now:
>> >> >>
>> >> >> https://patchwork.kernel.org/project/linux-wireless/patch/20230111170033.32454-1-kvalo@kernel.org/
>> >> >
>> >> > Great, thanks for that.
>> >> >
>> >> > Does it depend on firmware-2 being available?
>> >>
>> >> The final solution for the users will require firmware-2.bin. But for a
>> >> quick test you can omit the feature bit test by replacing
>> >> "test_bit(ATH11K_FW_FEATURE_MULTI_QRTR_ID, ab->fw.fw_features)" with
>> >> "true". Just make sure that the firmware release you are using supports
>> >> this feature, I believe only recent QCN9074 releases do that.
>> >
>> > I was able to test on IPQ8074+QCN9074 yesterday by just bypassing the
>> > test and it worked.
>> >
>> > Sideffect is that until firmware-2.bin is available cards like QCA6390
>> > wont work like with my hack.
>>
>> Not following here, can you elaborate what won't work with QCA6390?
>
> Our downstream hack does not work with QCA6390,

Still not sure what you mean. Are you saying that this patch under
discussion ("wifi: ath11k: use unique QRTR instance ID") also works with
QCA6390 and it's possible to connect two QCA6390 devices on the same
host?

Or are you referring to some other hack? Or have I totally
misunderstood? :)

> so that is why its quite important for OpenWrt to have a generic
> solution that works on all cards.

I fully agree on importance of having a generic solution. It's just sad
that it seems people who designed this didn't consider about having
multiple devices on the same host. It looks like there's no easy way to
implement a generic solution, we have only bad choices to choose from.
Your solution[1] is racy and writing to a register which is marked as
read-only in the spec.

Qualcomm's solution[2] needs changes in firmware and it's uncertain if
I'm able to convince all firmware teams to implement the support.
(Currently only QCN9074 firmware supports this.)

Thoughts?

[1] https://patchwork.kernel.org/project/linux-wireless/patch/20221105194943.826847-2-robimarko@gmail.com/

[2] https://patchwork.kernel.org/project/linux-wireless/patch/20230111170033.32454-1-kvalo@kernel.org/

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
