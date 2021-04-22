Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5499C36894F
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 01:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbhDVX3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 19:29:02 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:59612 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235977AbhDVX3C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 19:29:02 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619134107; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=5otw7omBiCFqynsjT0aagj3xpb8pMiXtl1joNgN82cI=;
 b=i1+Sj53uw5N8rfeDUfxC3wteQLsJUWhm+HVOEuQtjXKWBFWvGeBCZ5r4n1ddocnj0gO1Ea/x
 xKnlsPJlTlzYznPohyKLi32RebcoEHGoSPYbGlmmPJMDluIKPGm4nyGJDKdXBqjc4ssftDQ4
 h73/SOfODezR2KEwZ6Po3ytoT0g=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 608206872cbba88980825f3f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 22 Apr 2021 23:28:07
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3B54DC43217; Thu, 22 Apr 2021 23:28:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 769B3C433F1;
        Thu, 22 Apr 2021 23:28:06 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 22 Apr 2021 17:28:06 -0600
From:   subashab@codeaurora.org
To:     Alex Elder <elder@linaro.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Loic Poulain <loic.poulain@linaro.org>
Subject: Re: [PATCH] net: qualcomm: rmnet: Allow partial updates of IFLA_FLAGS
In-Reply-To: <76db0c51-15be-2d27-00a7-c9f8dc234816@linaro.org>
References: <20210422182045.1040966-1-bjorn.andersson@linaro.org>
 <76db0c51-15be-2d27-00a7-c9f8dc234816@linaro.org>
Message-ID: <89526b9845cc86143da2221fc2445557@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-22 12:29, Alex Elder wrote:
> On 4/22/21 1:20 PM, Bjorn Andersson wrote:
>> The idiomatic way to handle the changelink flags/mask pair seems to be
>> allow partial updates of the driver's link flags. In contrast the 
>> rmnet
>> driver masks the incoming flags and then use that as the new flags.
>> 
>> Change the rmnet driver to follow the common scheme, before the
>> introduction of IFLA_RMNET_FLAGS handling in iproute2 et al.
> 
> I like this a lot.  It should have been implemented this way
> to begin with; there's not much point to have the mask if
> it's only applied to the passed-in value.
> 
> KS, are you aware of *any* existing user space code that
> would not work correctly if this were accepted?
> 
> I.e., the way it was (is), the value passed in *assigns*
> the data format flags.  But with Bjorn's changes, the
> data format flags would be *updated* (i.e., any bits not
> set in the mask field would remain with their previous
> value).
> 
> Reviewed-by: Alex Elder <elder@linaro.org>

What rmnet functionality which was broken without this change.
That doesnt seem to be listed in this patch commit text.

If this is an enhancement, then patch needs to be targeted to net-next
instead of net
