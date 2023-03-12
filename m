Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147C76B67AF
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 16:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjCLPx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 11:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjCLPxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 11:53:25 -0400
X-Greylist: delayed 377 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Mar 2023 08:53:23 PDT
Received: from mail.manjaro.org (mail.manjaro.org [IPv6:2a01:4f8:c0c:51f3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B195426588;
        Sun, 12 Mar 2023 08:53:23 -0700 (PDT)
Message-ID: <de40d404-63ef-6561-f321-ffbe16ac7d5f@manjaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
        t=1678636021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YTnBYqy2JF+F2J796Km5GkcVKX0bGpttXtvOUqBezl8=;
        b=LPz0TF+kRpxZoZIFzwdba4yWMWatb5lF4eX8KDdybt2+GC7q37xebw0WnnnnzS6oFR93CH
        0N5KQt2Z0eesSW6zDSLFSFTl7l175Axye//yUNsQDLrijy5PMUsQ8OxBA8eJzJ6C6NuxVx
        kT9WaAzcXdMRktov9sOhC1u2vw+Y9ucDLf5dCIPjcbecdBwky7BXKWLzG7KxLuv4858QwE
        b3XfoCmJz/mwICW6skI/4UEbf9pXyVJJ/LqXsVPWPq2IPERIaQ705QLx7IvXQeiOwLws9R
        JaerhB/M5lgoD2jNCpUlQCmeJbplUefKu17iI7NeOUlWQjwTTs4UvNlYI3P5rg==
Date:   Sun, 12 Mar 2023 22:46:53 +0700
MIME-Version: 1.0
Subject: Re: [REGRESSION] Patch broke WPA auth: Re: [PATCH v2] wifi: cfg80211:
 Fix use after free for wext
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "support@manjaro.org" <support@manjaro.org>,
        Hector Martin <marcan@marcan.st>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1b393dfc-76be-9404-e7c9-a2f9fff215a8@manjaro.org>
 <ZA3m5s7yfTGMVthu@kroah.com>
 <5dc06a75-9913-8f47-a79e-38b0879808bb@manjaro.org>
 <ZA3xjPWtCHtE9pAQ@kroah.com>
From:   =?UTF-8?Q?Philip_M=c3=bcller?= <philm@manjaro.org>
Organization: Manjaro Community
In-Reply-To: <ZA3xjPWtCHtE9pAQ@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=philm@manjaro.org smtp.mailfrom=philm@manjaro.org
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ok, sorry forgot to add some CCs. Beside the reported affected kernels 
by Hector, who also provided the fix, it seems the appointed patch 
affects all stable releases as shown below.

On 12.03.23 22:36, Greg Kroah-Hartman wrote:
> On Sun, Mar 12, 2023 at 10:11:29PM +0700, Philip Müller wrote:
>> I see,
>>
>> however, seems we have a full house here:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/releases/4.14.308/wifi-cfg80211-fix-use-after-free-for-wext.patch
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/releases/4.19.276/wifi-cfg80211-fix-use-after-free-for-wext.patch
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/releases/5.4.235/wifi-cfg80211-fix-use-after-free-for-wext.patch
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/releases/5.10.173/wifi-cfg80211-fix-use-after-free-for-wext.patch
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/releases/5.15.99/wifi-cfg80211-fix-use-after-free-for-wext.patch
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/releases/6.1.16/wifi-cfg80211-fix-use-after-free-for-wext.patch
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/releases/6.2.3/wifi-cfg80211-fix-use-after-free-for-wext.patch
> 
> I do not understand, sorry.
> 
> Also, why is this a private message?  Kernel development is done in
> public please.
> 
> thanks,
> 
> greg k-h

-- 
Best, Philip

