Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4600730B185
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhBAUWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhBAUW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 15:22:29 -0500
Received: from mail.as397444.net (mail.as397444.net [IPv6:2620:6e:a000:dead:beef:15:bad:f00d])
        by lindbergh.monkeyblade.net (Postfix) with UTF8SMTPS id 0A587C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 12:21:48 -0800 (PST)
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id 0E37547C3B1;
        Mon,  1 Feb 2021 20:21:47 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bluematt.me;
        s=1612209662; t=1612210907;
        bh=aect8PShZE46N9WA+IGOwO8CytrHGKQpBzudjDAn4tw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=TxMMtGmLyFm0ZwjS4MyI5czW7PJjxDf702Dsv3wNCmnx3/tVQi6TaOBTxs8WsAADX
         U2lZegk82/tcnCqgxGnvvZ6Nxlm74b+l7osGXxw6UDOlbVdOY30KMMn9qE0aeH6tLl
         WG0mVU+xsuNeQg5S6mvFMkBXzMEi+qseafZ1iusiyWWeunAdklzm0M2y/5WtYOBKIW
         t+U97VfcSNm7jQfy5f/RuI0E6+d4h78ed2gXhx198CxPIwJOthTh5x9M6TQUNPlFlB
         GK5h5GSDEjOrZI9smoa9vk0ZWRreyzCXaqbAWMOO3knam+YhghECahNARLjBBzH3Y6
         5u4VbPcuAIXSg==
Subject: Re: [PATCH net] igb: Enable RSS for Intel I211 Ethernet Controller
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "linux-wired-list@bluematt.me" <linux-wired-list@bluematt.me>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "nick.lowe@gmail.com" <nick.lowe@gmail.com>
References: <20201221222502.1706-1-nick.lowe@gmail.com>
 <379d4ef3-02e5-f08a-1b04-21848e11a365@bluematt.me>
 <20210201084747.2cb64c3f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a7a89e90bf6c3f383fa236b1128db8d012223da0.camel@intel.com>
 <20210201114545.6278ae5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Matt Corallo <linux-wired-list@bluematt.me>
Message-ID: <69e92a09-d597-2385-2391-fee100464c59@bluematt.me>
Date:   Mon, 1 Feb 2021 15:21:46 -0500
MIME-Version: 1.0
In-Reply-To: <20210201114545.6278ae5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/1/21 2:45 PM, Jakub Kicinski wrote:
> Matt, would you mind clarifying if this is indeed a regression for i211?
> 

Admittedly, I didn't go all the way back to test that it is, indeed, a regression. The Fixes commit that it was tagged 
with on Tony's tree was something more recent than initial igb landing (its a refactor of RSS) and there are numerous 
posts online indicating common I211 hardware (eg PCEngines APU2) support RSS and properly load multiple cores, so I 
naively assumed that it is a regression of some form.

Did you test kernels odler than c883de9fd787, Nick?

Given that, and the non-invasive nature of the patch, I figured it was worth trying to land on LTS trees and going ahead 
with it for 5.11, but I don't feel strongly on how it ends up on LTS, it just seems a waste to not land it there.

Matt
