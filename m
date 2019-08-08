Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BABB86C16
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 23:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390202AbfHHVI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 17:08:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42457 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732609AbfHHVI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 17:08:29 -0400
Received: by mail-pg1-f194.google.com with SMTP id t132so44684202pgb.9
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 14:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W8919ktjzmuqwSKIG0s3FEbb7dmg7CXmeFbwYm0Jh+M=;
        b=tXPGsr1C5YDFRUIQccImdZ9OLV6P0I4GaPwEFH5hWW7Dh9hYdVrKZL0TzEW5Xaj6b1
         dFBQ2+zHVJY6MX//5wD9yzlNq94W6A6wzWao2B+XF/TXIuSjSYLGIWPQ0//BhpUhFxWz
         FbLSvW8T7YtkI3zgQHlU2B6mtUhab8GoR8KqIxIqKUToO1vNxZGggnQ8hk36f663+Egs
         nh6BII0yAbcewAQygWSyr/MFT2Ku8biMtj/IBIUPrI3EXb9Uni2WGUlHcRI4sRIvF/Aw
         V8WqN4q9aKE/vk3XYOVFaMSMXFBGloqQozKDHdmRmaqKCmi+2YP8SIuG8CNlkB3rpYdx
         k19Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W8919ktjzmuqwSKIG0s3FEbb7dmg7CXmeFbwYm0Jh+M=;
        b=GVI4rj/VH65Tn8Som5pPQ7q1hwnramaPjyNp5XS45O4yQcYMcZ/BFJOn7Dun05EKNH
         g7DBdv36uBxNKLlcEPfZxq3dZ9tJXo1e/z0/wxRcINuUg6WpmaqpenBM3uTfa/ECWWhZ
         oyKN5iaERfpBmKSm0jveRg1JMKbAPgW3KwVyDAcm3Aw8RfpvDZCpSvn/mP2L7/ybbeuu
         mhnJSZ3QjHPmIrKtRGHt/8kHkFAPK39gHYZhQXc0A89O/kI/veTWBFKn+BnQc6jx4nBL
         iByb1Fe+hD4jGCL1e+drUEoENVNH9/SLfvcSMd3+zOBy6Utd1HgsQ3kdevek1VYscTwo
         1EIA==
X-Gm-Message-State: APjAAAU99FsQkdlmkhREFPwu7OwOBnsUJYfZaOKFhR6Y4vRwtK6VRS+w
        jvp9hgD6SreetX1WEE2nSTk=
X-Google-Smtp-Source: APXvYqxZh+Kma4wINR1+kACpRiG/Zhely5+heYxiz0Vs+18ktaux6bqgxP3PtOkPAGzuYCLE40n85Q==
X-Received: by 2002:a65:4304:: with SMTP id j4mr14840883pgq.419.1565298508673;
        Thu, 08 Aug 2019 14:08:28 -0700 (PDT)
Received: from [172.27.227.216] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id l17sm20768956pgj.44.2019.08.08.14.08.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 14:08:27 -0700 (PDT)
Subject: Re: [PATCH net-next 00/10] drop_monitor: Capture dropped packets and
 metadata
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20190807103059.15270-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <745e5ab5-e254-ecd0-565a-371c5b6d0df0@gmail.com>
Date:   Thu, 8 Aug 2019 15:08:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190807103059.15270-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19 4:30 AM, Ido Schimmel wrote:
> Example usage with patched dropwatch [1] can be found here [2]. Example
> dissection of drop monitor netlink events with patched wireshark [3] can
> be found here [4]. I will submit both changes upstream after the kernel
> changes are accepted. Another change worth making is adding a dropmon
> pseudo interface to libpcap, similar to the nflog interface [5]. This
> will allow users to specifically listen on dropmon traffic instead of
> capturing all netlink packets via the nlmon netdev.

Nice work, Ido.

On top of your dropwatch changes I added the ability to print the
payload as hex. e.g.,

Issue Ctrl-C to stop monitoring
drop at: nf_hook_slow+0x59/0x98 (0xffffffff814ec532)
input port ifindex: 1
timestamp: Thu Aug  8 15:04:02 2019 360015026 nsec
length: 64
00 00 00 00 00 00 00 00  00 00 00 00 08 00 45 00      ........ ......E.
00 3c e7 50 40 00 40 06  55 69 7f 00 00 01 7f 00      .<.P@.@. Ui......
00 01 80 2c 30 39 74 b9  c7 4d 00 00 00 00 a0 02      ...,09t. .M......
ff d7 fe 30 00 00 02 04  ff d7 04 02 08 0a 53 79       ...0.... ......Sy
original length: 74


Seems like the skb protocol is also needed to properly parse the payload
- ie., to know it is an ethernet header, followed by ip and tcp.
