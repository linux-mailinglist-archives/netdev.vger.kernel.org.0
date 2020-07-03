Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6451521327B
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725784AbgGCECR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:02:17 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:58993 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgGCECQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 00:02:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1593748936; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=zEyHBMTalm0qzaNQgp3xZYhk4wfym4Jc9X03QcTfoOA=;
 b=sZZq56bnVs9qOte11bufJvxv5BsSApSm3rlosVRbks3aYzWQIARST7cS8lJEtdLn3pzz7/ER
 BXkyFoExex2LRsV5y1AoZp31fcGO3/TlYBBEg4RgUW6p2aHToS64+HJkXfvQoX8f4l2H/VWw
 YuuvEu0o7mht43DEWl/egt0VleA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n17.prod.us-west-2.postgun.com with SMTP id
 5efeada86f2ee827da4a4b58 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 03 Jul 2020 04:01:44
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 41F1AC433CA; Fri,  3 Jul 2020 04:01:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B5AE0C433C6;
        Fri,  3 Jul 2020 04:01:43 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 02 Jul 2020 22:01:43 -0600
From:   subashab@codeaurora.org
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, stranche@codeaurora.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: rmnet: fix interface leak for rmnet module
In-Reply-To: <20200702170737.10479-1-ap420073@gmail.com>
References: <20200702170737.10479-1-ap420073@gmail.com>
Message-ID: <73674e9e0936e664bb1787d233fa90b6@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-02 11:07, Taehee Yoo wrote:
> There are two problems in rmnet module that they occur the leak of
> a lower interface.
> The symptom is the same, which is the leak of a lower interface.
> But there are two different real problems.
> This patchset is to fix these real problems.
> 
> 1. Do not allow to have different two modes.
> As a lower interface of rmnet, there are two modes that they are VND
> and BRIDGE.
> One interface can have only one mode.
> But in the current rmnet, there is no code to prevent to have
> two modes in one lower interface.
> So, interface leak occurs.
> 
> 2. Do not allow to add multiple bridge interfaces.
> rmnet can have only two bridge interface.
> If an additional bridge interface is tried to be attached,
> rmnet should deny it.
> But there is no code to do that.
> So, interface leak occurs.
> 
> Taehee Yoo (2):
>   net: rmnet: fix lower interface leak
>   net: rmnet: do not allow to add multiple bridge interfaces
> 
>  .../net/ethernet/qualcomm/rmnet/rmnet_config.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)

Thanks Taehee. For the series-

Reviewed-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
