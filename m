Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049CB34B863
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 18:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhC0RCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 13:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhC0RCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 13:02:05 -0400
X-Greylist: delayed 153 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 27 Mar 2021 10:02:04 PDT
Received: from resqmta-ch2-05v.sys.comcast.net (resqmta-ch2-05v.sys.comcast.net [IPv6:2001:558:fe21:29:69:252:207:37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5437C0613B1
        for <netdev@vger.kernel.org>; Sat, 27 Mar 2021 10:02:04 -0700 (PDT)
Received: from resomta-ch2-03v.sys.comcast.net ([69.252.207.99])
        by resqmta-ch2-05v.sys.comcast.net with ESMTP
        id QBFWlV5txK3eXQCHalAmtv; Sat, 27 Mar 2021 16:59:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20180828_2048; t=1616864370;
        bh=Vq9h3IRaKwNNdJxyEDdfX3GGmEeffAswDMFaOLkHRqY=;
        h=Received:Received:Reply-To:To:From:Subject:Message-ID:Date:
         MIME-Version:Content-Type;
        b=WEAHxEjIkvkZuhD+quSct0NC3Hfhf3m2PA2g9hAkQidCnt/edtD9u23q2bvd3mVFd
         K+A2eznPSDWMvWEdRxWJWoir1MAeDqm9mv+1qpbvvSeHTRE1gJADxA/KCah0A9WH94
         umWePclphnFftsY+FIcbfvR3KUTjR8oZjS8hWja9I2KIJA9hIE7LW+KB92m4nJcrwK
         nUNCmNUk7ftOwP4M+uy8CvIAJi5AI54hyetVZHQiCEiLncicSva8Usei3wEvLTo3Rg
         dPC0TDogdvrl4qUx978vcKmnkyzWjwusCl64Mm8V6SltgcLi+DXuKBMi2fkB2YUItm
         YMcntUV8vOu6w==
Received: from [IPv6:2001:558:6040:22:2171:426f:b27e:296d]
 ([IPv6:2001:558:6040:22:2171:426f:b27e:296d])
        by resomta-ch2-03v.sys.comcast.net with ESMTPSA
        id QCHZlDklgM6HJQCHZlwAID; Sat, 27 Mar 2021 16:59:30 +0000
X-Xfinity-VMeta: sc=-100.00;st=legit
Reply-To: james@nurealm.net
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
From:   James Feeney <james@nurealm.net>
Cc:     netdev@vger.kernel.org
Subject: Upgrade from linux-lts-5.10.25 to linux-lts 5.10.26 breaks bonding.
Message-ID: <69e1d825-db19-3d05-5406-b1c2774528f7@nurealm.net>
Date:   Sat, 27 Mar 2021 10:59:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arch linux-lts-5.10.25-1 to linux-lts 5.10.26-1

This is on a wireless bonding setup with fallback to wired ethernet.  Everything with the interfaces looks fine, except, for instance, ping returns the error message "ping: sendmsg: Invalid argument".  Of course, networking becomes unusable.

Removing the bonding interface, and adding an IP address directly to either wired or wireless interface, networking works normally.

This is not to do with the linux-firmware package, where downgrading linux-firmware makes no difference.

Downgrading the kernel resolves the problem, but I don't see any bonding commits between linux-lts-5.10.25 and linux-lts 5.10.26.

Any thoughts, shy of performing a full bisect, would be appreciated.

James
