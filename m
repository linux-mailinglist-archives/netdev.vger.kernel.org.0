Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9E42977B5
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 21:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751102AbgJWTYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 15:24:33 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:44361 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbgJWTYd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 15:24:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603481072; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=lBoZniQkYO/mnF63FaYEaqqudsCX8eh303z2QHXuUWs=; b=idux4c8XMrHgehjHXs4HvcLH+2TAovNjtYaP0RNYJvFp0NTYOMAYOYCsL15PPjNCoA4BPnwf
 pAQ0e6ykgXbSq6PgVsyBLqoojfqnQkn2juLyZcNiYr1DtpbW62xgikpnrjX5WVM3fxF1VrdR
 /G1ibnggWGp++5BdWO5eFwe19fU=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5f932def8eea157089e81617 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 23 Oct 2020 19:24:31
 GMT
Sender: jhugo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C1E8DC433F0; Fri, 23 Oct 2020 19:24:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.226.59.216] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jhugo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C5160C433C9;
        Fri, 23 Oct 2020 19:24:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C5160C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jhugo@codeaurora.org
Subject: Re: [PATCH v6 1/2] bus: mhi: Add mhi_queue_is_full function
To:     Loic Poulain <loic.poulain@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>
References: <1602840007-27140-1-git-send-email-loic.poulain@linaro.org>
 <8c384f6a-df21-1a39-f586-6077da373c04@codeaurora.org>
 <CAMZdPi_NZ5PaONpePHHFOosiuQ50R0_o3bymwzKfp2DJ37BCig@mail.gmail.com>
From:   Jeffrey Hugo <jhugo@codeaurora.org>
Message-ID: <95c91cfd-cbf2-2496-4c0d-c8490591fd19@codeaurora.org>
Date:   Fri, 23 Oct 2020 13:24:26 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <CAMZdPi_NZ5PaONpePHHFOosiuQ50R0_o3bymwzKfp2DJ37BCig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/23/2020 1:11 PM, Loic Poulain wrote:
> Hi Hemant,
> 
> On Fri, 23 Oct 2020 at 05:06, Hemant Kumar <hemantk@codeaurora.org 
> <mailto:hemantk@codeaurora.org>> wrote:
> 
>     Hi Loic,
> 
>     On 10/16/20 2:20 AM, Loic Poulain wrote:
>      > This function can be used by client driver to determine whether it's
>      > possible to queue new elements in a channel ring.
>      >
>      > Signed-off-by: Loic Poulain <loic.poulain@linaro.org
>     <mailto:loic.poulain@linaro.org>>
>     [..]
>      > +static inline bool mhi_is_ring_full(struct mhi_controller
>     *mhi_cntrl,
>      > +                                 struct mhi_ring *ring)
>      >   {
>      >       void *tmp = ring->wp + ring->el_size;
>      >
>      > @@ -1173,6 +1173,17 @@ int mhi_queue_buf(struct mhi_device
>     *mhi_dev, enum dma_data_direction dir,
>      >   }
>      >   EXPORT_SYMBOL_GPL(mhi_queue_buf);
>      >
>      > +bool mhi_queue_is_full(struct mhi_device *mhi_dev, enum
>     dma_data_direction dir)
>      > +{
>      > +     struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
>      > +     struct mhi_chan *mhi_chan = (dir == DMA_TO_DEVICE) ?
>      > +                                     mhi_dev->ul_chan :
>     mhi_dev->dl_chan;
>      > +     struct mhi_ring *tre_ring = &mhi_chan->tre_ring;
>      > +
>      > +     return mhi_is_ring_full(mhi_cntrl, tre_ring);
>      > +}
>      > +EXPORT_SYMBOL_GPL(mhi_queue_is_full);
>      >
>     i was wondering if you can make use of mhi_get_free_desc() API (pushed
>     as part of MHI UCI - User Control Interface driver) here?
> 
> 
> I prefer not to depend on PR that is not yet merged to keep things 
> simple, though I could integrate it in my PR... I think this function is 
> good to have anyway for client drivers, and slightly faster since this 
> is just a pointer comparison.

Its a little bit more than that.  Frankly, unless you are counting 
assembly instructions for both methods, the difference is likely to be 
in the noise.

However, I wonder why core MHI changes were not copied to the proper 
list (namely linux-arm-msm)?

-- 
Jeffrey Hugo
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
