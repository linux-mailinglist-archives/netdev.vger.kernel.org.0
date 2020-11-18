Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250E92B84F6
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgKRTek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:34:40 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:26336 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgKRTek (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:34:40 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605728078; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=uGAvDjrAALRHrKRcKvLfwMGG8vXZ1b/VTGv+N6uE5Uo=; b=aviuk8Jjz1zdvq1cnTUM6loI6Epp+Oe9nlEL6lRiU1D6MMIpx9aBvdbjGS99VACczUF8woHd
 jSsLnAnU1KSNHVPhHv5pPHqNa+j+w4X6oARAD8S+vxTw25KS5HCHx67Ledgg2T4X2phaWzHg
 L6/CLoqJgYs+lKXKsP8Lxv6hPFk=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-west-2.postgun.com with SMTP id
 5fb57746a5a29b56a173f4e4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 18 Nov 2020 19:34:30
 GMT
Sender: jhugo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EC261C43460; Wed, 18 Nov 2020 19:34:29 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.226.59.216] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jhugo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 637DFC433C6;
        Wed, 18 Nov 2020 19:34:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 637DFC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jhugo@codeaurora.org
Subject: Re: [PATCH] net: qrtr: Unprepare MHI channels during remove
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Bhaumik Bhatt <bbhatt@codeaurora.org>, ath11k@lists.infradead.org,
        cjhuang@codeaurora.org, clew@codeaurora.org,
        hemantk@codeaurora.org, kvalo@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org
References: <1605723625-11206-1-git-send-email-bbhatt@codeaurora.org>
 <5e94c0be-9402-7309-5d65-857a27d1f491@codeaurora.org>
 <CAMZdPi_b0=qFNGi1yUke3Dip2bi-zW4ULTg8W4nbyPyEsE3D4w@mail.gmail.com>
From:   Jeffrey Hugo <jhugo@codeaurora.org>
Message-ID: <2019fe3c-55c5-61fe-758c-1e9952e1cb33@codeaurora.org>
Date:   Wed, 18 Nov 2020 12:34:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAMZdPi_b0=qFNGi1yUke3Dip2bi-zW4ULTg8W4nbyPyEsE3D4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/2020 12:14 PM, Loic Poulain wrote:
> 
> 
> Le mer. 18 nov. 2020 à 19:34, Jeffrey Hugo <jhugo@codeaurora.org 
> <mailto:jhugo@codeaurora.org>> a écrit :
> 
>     On 11/18/2020 11:20 AM, Bhaumik Bhatt wrote:
>      > Reset MHI device channels when driver remove is called due to
>      > module unload or any crash scenario. This will make sure that
>      > MHI channels no longer remain enabled for transfers since the
>      > MHI stack does not take care of this anymore after the auto-start
>      > channels feature was removed.
>      >
>      > Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org
>     <mailto:bbhatt@codeaurora.org>>
>      > ---
>      >   net/qrtr/mhi.c | 1 +
>      >   1 file changed, 1 insertion(+)
>      >
>      > diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
>      > index 7100f0b..2bf2b19 100644
>      > --- a/net/qrtr/mhi.c
>      > +++ b/net/qrtr/mhi.c
>      > @@ -104,6 +104,7 @@ static void qcom_mhi_qrtr_remove(struct
>     mhi_device *mhi_dev)
>      >       struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
>      >
>      >       qrtr_endpoint_unregister(&qdev->ep);
>      > +     mhi_unprepare_from_transfer(mhi_dev);
>      >       dev_set_drvdata(&mhi_dev->dev, NULL);
>      >   }
>      >
>      >
> 
>     I admit, I didn't pay much attention to the auto-start being removed,
>     but this seems odd to me.
> 
>     As a client, the MHI device is being removed, likely because of some
>     factor outside of my control, but I still need to clean it up?  This
>     really feels like something MHI should be handling.
> 
> 
> I think this is just about balancing operations, what is done in probe 
> should be undone in remove, so here channels are started in probe and 
> stopped/reset in remove.

I understand that perspective, but that doesn't quite match what is 
going on here.  Regardless of if the channel was started (prepared) in 
probe, it now needs to be stopped in remove.  That not balanced in all cases

Lets assume, in response to probe(), my client driver goes and creates 
some other object, maybe a socket.  In response to that socket being 
opened/activated by the client of my driver, I go and start the mhi 
channel.  Now, normally, when the socket is closed/deactivated, I stop 
the MHI channel.  In this case, stopping the MHI channel in remove() is 
unbalanced with respect to probe(), but is now a requirement.

Now you may argue, I should close the object in response to remove, 
which will then trigger the stop on the channel.  That doesn't apply to 
everything.  For example, you cannot close an open file in the kernel. 
You need to wait for userspace to close it.  By the time that happens, 
the mhi_dev is long gone I expect.

So if, somehow, the client driver is the one causing the remove to 
occur, then yes it should probably be the one doing the stop, but that's 
a narrow set of conditions, and I think having that requirement for all 
scenarios is limiting.


-- 
Jeffrey Hugo
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
