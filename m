Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C19895DA56
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbfGCBIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:08:54 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:55178 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbfGCBIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:08:54 -0400
Received: by mail-wm1-f52.google.com with SMTP id g135so413533wme.4
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 18:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kOfNnur0ev0jUVUts3AiBuCRtLvrbFXT2bQ+oOVFe3U=;
        b=DdTLbVPhpW+NBYniofrIZBaxQpyJac9F/PYSwRIHlUO62i33KnyeAvMfKIAcecag8m
         o12z9cVmkFOvcnKl6L71ar1vq5sfiyDfKNg7StfKkQq8j2TTwdGqEe62gCTGXodcxsvl
         Iyj4Y9Ht7kSrQG87fhE0qm7Hc0J44sqiBSXK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kOfNnur0ev0jUVUts3AiBuCRtLvrbFXT2bQ+oOVFe3U=;
        b=ieqwE0o3uGJEPi6Bsw54DnEBqrh9YNb1VzZOB/TN+7cUC5G/xt61EqCaqE0fNqQuTr
         PtKQSKH/3xs0dPQQrRoEca/Odalu3Y+Ewn/tLOc4MmiF2ZC2YDDtK18+PZ0H1iO376w9
         wOgd1qLJ/WOWAJuZjMcj39f3V758t7QMQTMVonoszji6bLgjyzlVg2/PvcPNW3UOSLea
         81LqSSvJG2fiL1EpsUmiJBNcPjChFanc+0vBRslkKxmmzyVZzp4NKVANZx+bWF48HyBW
         yhn19NQY3Yswswo81me+Ghb8rKEePBEbuXuw4BAQZopx1KataSWBP+wUxSrwUqX+EY7X
         BSUw==
X-Gm-Message-State: APjAAAUEzgs5nd1puYMiAV1ThYE6Wn7Ql3VLjPUYZYL/borCmUKcfWcf
        IxNr5dsb16RsKMu0TRQlstdnrm7kLkA=
X-Google-Smtp-Source: APXvYqyW42PkFPHU1o3WyBHVKVaaJQkE20AsGwBm4Z4Io2hzgdU2t+4r4QIn6OM50eK0nNJgzrmpzA==
X-Received: by 2002:a1c:988a:: with SMTP id a132mr4452829wme.165.1562102374032;
        Tue, 02 Jul 2019 14:19:34 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id d24sm148646wra.43.2019.07.02.14.19.32
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 14:19:33 -0700 (PDT)
Subject: Re: Validation of forward_delay seems wrong...
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org, netdev <netdev@vger.kernel.org>
References: <20190702204705.GC28471@lunn.ch>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <55f24bfb-4239-dda8-24f8-26b6b2fa9f9e@cumulusnetworks.com>
Date:   Wed, 3 Jul 2019 00:19:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190702204705.GC28471@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/07/2019 23:47, Andrew Lunn wrote:
> Hi Nikolay
> 
> The man page says that the bridge forward_delay is in units of
> seconds, and should be between 2 and 30.
> 
> I've tested on a couple of different kernel versions, and this appears
> to be not working correctly:
> 
> ip link set br0 type bridge forward_delay 2
> RTNETLINK answers: Numerical result out of range
> 
> ip link set br0 type bridge forward_delay 199
> RTNETLINK answers: Numerical result out of range
> 
> ip link set br0 type bridge forward_delay 200
> # 
> 
> ip link set br0 type bridge forward_delay 3000
> #
> 
> ip link set br0 type bridge forward_delay 3001
> RTNETLINK answers: Numerical result out of range
> 
> I've not checked what delay is actually being used here, but clearly
> something is mixed up.
> 
> grep HZ .config 
> CONFIG_HZ_PERIODIC=y
> # CONFIG_NO_HZ_IDLE is not set
> # CONFIG_NO_HZ_FULL is not set
> # CONFIG_NO_HZ is not set
> CONFIG_HZ_FIXED=0
> CONFIG_HZ_100=y
> # CONFIG_HZ_200 is not set
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_500 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=100
> 
> Thanks
> 	Andrew
> 

Hi Andrew,
The man page is wrong, these have been in USER_HZ scaled clock_t format from the beginning.
TBH a lot of the time/delay bridge config options are messed up like that.
We've been discussing adding special _ms versions in iproute2 to make them
more user-friendly and understandable. Will cook a patch for the man page.

Cheers,
 Nik


