Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A252A8B53
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733062AbgKFAQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732854AbgKFAQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 19:16:07 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26597C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 16:16:07 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id p7so3680612ioo.6
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 16:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BspmPg4fxyEB4fnMALROyHJPoPVju7IkIVKuWMZnFlw=;
        b=mws5KH8LdFgy3LNbKUhIIOUPslo01r+fGG/w6/QRLLiAzFP1JFIubEllLVRBzQn3Kt
         TqJE15rFQZIDxKxIEBa8CAs9ktS+DIqzLxUiZXsL+RnFrEqTUqrLwsjikuCn77MCBxo2
         Fglb31l+rs2PpS0gyek0zMtcoLdTOl0/wpXNopcovNeM89lCQMVv/BPWJjCaAvrKlYM3
         VUUgqBVIGeGDhG13xi33DD7g0p7UUBNMzS4u0+DSuh3vNz8RYxwut+VpU/iYGEbMlSmg
         qm4hdh5LWBlKvf00nFr11XkhrL2TqKi75SA6m4/FamizRSKEEopPcv9ydiAU1KjulndB
         uJjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BspmPg4fxyEB4fnMALROyHJPoPVju7IkIVKuWMZnFlw=;
        b=uSUSlNnRPEah98XGu3yuB/SY1milsaPK1+G5F08fWf+DWCq6QSvibiCjVNhJ9B94KR
         yV5OYBIKoipA7eDXMvQvDZ5MCtqdAqo0bvDMBdsedGp0RrgOJASuI+oMvdejAzXcW2Ku
         FJqIkOxaAzojzBbdAnIx82NrRftGJKTfVyqlVTD+eS0TiGiGWvWeApyZ1h+XCMlTDuHc
         KyulbeWCf/zSt8jgJ30VJ0PCgRxpxFytPlwes3qNa9n6DooEXxsG8d0eDjx2xgCcVgHP
         5m/bi8Mp00eqUdusqcYKsV2X769YNwcks4EXpji/mPewKlhFd+HhRRetLf8uoAyfdkjW
         hl9w==
X-Gm-Message-State: AOAM532KSnM0qU8cDCCNlpGPaeeN5AyCZYmIHQJjKSDFR0zjR2QMptc9
        q761tQ3Z6E2/o1EvxaV4HE8=
X-Google-Smtp-Source: ABdhPJx3Uk6zUfWbUVXdm6ZAlZF6LPr2ev4Dqu13zcrszUk0ObGH9ZbmZbAw9SoVck5lkz1bDUv4qw==
X-Received: by 2002:a05:6602:21c2:: with SMTP id c2mr3753221ioc.184.1604621766486;
        Thu, 05 Nov 2020 16:16:06 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec52:e45a:6d93:a9c])
        by smtp.googlemail.com with ESMTPSA id o1sm1714797ior.26.2020.11.05.16.16.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 16:16:05 -0800 (PST)
Subject: Re: [net-next,v1,4/5] seg6: add support for the SRv6 End.DT4 behavior
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kbuild-all@lists.01.org, netdev@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20201103125242.11468-5-andrea.mayer@uniroma2.it>
 <202011040355.ljXTObZi-lkp@intel.com>
 <20201106005742.31985db8c30c89e0b0868170@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <13d1b683-de1c-2a6a-4197-e7ba42f6be78@gmail.com>
Date:   Thu, 5 Nov 2020 17:16:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201106005742.31985db8c30c89e0b0868170@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/20 4:57 PM, Andrea Mayer wrote:
> I spent some time figuring out what happened with this patch. It seems that the
> patchset was not applied by the kernel test robot in the correct order. In
> particular, patch 3 is missing from this build attempt.
> 
> I applied one patch after another in the correct order and, each time, I was
> able to compile the kernel (C=1 W=1) successfully with the .config file provided
> by the robot.

Given that, repost the patch set.

Jakub: if v2 with no changes triggers another build robot message, give
Andrea time to double check whether this problem happened again before
marking it in patchworks. Thanks,
