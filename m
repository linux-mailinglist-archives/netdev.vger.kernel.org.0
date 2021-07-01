Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF45A3B9455
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbhGAP5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233239AbhGAP5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 11:57:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 328F261374;
        Thu,  1 Jul 2021 15:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625154888;
        bh=biaZmPwjsmMFVN6dqJjwTlpW7hiFygVWSCUeozEYnNs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Be/ePgAxVpr50fu8t3ihwmMbMc4RKUyUT0t/Hjp5+6nG5DhnJaqkbkz2QpnitZcLk
         XmdRVSTQVLr+1oeCCtvYVkdycobMUDXju+3MlwN0sT1+71KTC95P8l4cUrITPgjFPL
         pXQclArvEZF3FWqN7nBA3gQrXC+g0fF1U+E3DeqiLIT+jNFgEAQKIhknjPmG8ncs20
         QHuTCZ8K2RBAG2NFG47Iq6YfD6sipZ9bZ04GUUwyxMQgofeS2sTMfyewqRf7eLs7dw
         Ux0OsbIG1/i8fgmpJQ/L48QngO5LtUYXB3g+g6hwq67Uc4Tz8V6mUoeXZyGjVwYU9j
         YhDWnc9jspGpA==
Date:   Thu, 1 Jul 2021 08:54:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <lipeng321@huawei.com>
Subject: Re: [PATCH net-next 3/3] net: hns3: add support for link diagnosis
 info in debugfs
Message-ID: <20210701085447.2270b1df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <08395721-4ca1-9913-19fd-4d8ec7e41e4b@huawei.com>
References: <1624545405-37050-1-git-send-email-huangguangbin2@huawei.com>
        <1624545405-37050-4-git-send-email-huangguangbin2@huawei.com>
        <20210624122517.7c8cb329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <08395721-4ca1-9913-19fd-4d8ec7e41e4b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Jul 2021 17:03:32 +0800 huangguangbin (A) wrote:
> On 2021/6/25 3:25, Jakub Kicinski wrote:
> > On Thu, 24 Jun 2021 22:36:45 +0800 Guangbin Huang wrote:  
> >> In order to know reason why link down, add a debugfs file
> >> "link_diagnosis_info" to get link faults from firmware, and each bit
> >> represents one kind of fault.
> >>
> >> usage example:
> >> $ cat link_diagnosis_info
> >> Reference clock lost  
> > 
> > Please use ethtool->get_link_ext_state instead.
> > .
> >   
> Hi Jakub, I have a question to consult you.
> Some fault information in our patch are not existed in current ethtool extended
> link states, for examples:
> "Serdes reference clock lost"
> "Serdes analog loss of signal"
> "SFP tx is disabled"
> "PHY power down"

Why would the PHY be powered down if user requested port to be up?

> "Remote fault"

I think we do have remote fault:

    state: ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE
 substate: ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT

> Do you think these fault information can be added to ethtool extended link states?

Yes, would you mind categorizing them into state/substate and sharing
the proposed additions with Amit, Ido, Andrew and other PHY experts?
