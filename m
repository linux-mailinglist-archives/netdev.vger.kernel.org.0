Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE0F305BE2
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313680AbhAZWyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 17:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728754AbhAZE4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 23:56:45 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2DCC061793
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 20:56:04 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id x71so17274790oia.9
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 20:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NcZrONxYSmKxl+u1qnv2/o6viRhj5jn08YYDckIaIP8=;
        b=kehhMrFcKD4tdB+0hx2/JpWQDDskRrzWnQjtrnLiY1/fpz7o9KJu71RFD/AgiFxsMC
         0WJ4UIJqaLB5An7fdRhGEAV8Y1/NoRzD1imEfpXTGkQoUaWEetC4DTj+oeB3kv7xYtsh
         BtLu8XyOE0MOxVnFeRfEBlCgvBXzNWNDaKS6CiKmU+KI7SAKvQcYH5tjQLFAXjJwXRze
         zDUYvKZ9uaH08keZJzvyXuY3Ymj+Ul/zngsUHRG3bI7GjCV75JOT57TJOM2PA7VQinr2
         QJHLE5rCOB7GYDp7Ab0WY3zOBAAFUv/TS0NE4wB8aMoI1Kbtm4ojk5vLOuw4B0KdvPi0
         LKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NcZrONxYSmKxl+u1qnv2/o6viRhj5jn08YYDckIaIP8=;
        b=FE//SNl7yd7QIagTWe8D6lzo3WlXiV0vCFHfchmcm75EFl0e7+nhjJqiR3qvrLv9m3
         O7vgePQStmOsSXLWQBzQhQIMiiojfvwYe/TYn0T9yp12XigAw1Hv6NJawGLBqPj4qmKb
         dQQ4eYzVWyHGXkBbSVlZIE4VamzUQczj5PEdLS02QBlFFb2IEmAUZjt65gHczctBfM+8
         O4l/s9XTSwcHEPJjgck4st0EGS7gq3/xbY80gRYoJWIv0TZ3fobFpkCvkeY6D0U4L0yo
         hBMcgzatThgI1y8I2Wje8S2oMEQiaxsryWDBo7CcnVJ/ZAC5B+2X33CoW9Vvp7rvABh7
         SU3A==
X-Gm-Message-State: AOAM530PzVKypTh+LfF2I9VFMEsMhUgFn2LsWNIcgNI9mYulxTwZTr0U
        xq00PjttosdP/2YfULxzInEYXji+0ng=
X-Google-Smtp-Source: ABdhPJwxFu7ha/seJOpL8rF3DykEFFedJF1+3MYVOSaS9tYkKGLtWH6OXcuBBRvY7y89nUJguiwFag==
X-Received: by 2002:aca:40c:: with SMTP id 12mr2088558oie.172.1611636964450;
        Mon, 25 Jan 2021 20:56:04 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:f5f4:6dbf:d358:29ee])
        by smtp.googlemail.com with ESMTPSA id s123sm2617334oos.3.2021.01.25.20.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 20:56:03 -0800 (PST)
Subject: Re: [PATCH net-next 1/4] netlink: truncate overlength attribute list
 in nla_nest_end()
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
 <20210123045321.2797360-2-edwin.peer@broadcom.com>
 <1dc163b0-d4b0-8f6c-d047-7eae6dc918c4@gmail.com>
 <CAKOOJTwKK5AgTf+g5LS4MMwR_HwbdFS6U7SFH0jZe8FuJMgNgA@mail.gmail.com>
 <CAKOOJTzwdSdwBF=H-h5qJzXaFDiMoX=vjrMi_vKfZoLrkt4=Lg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <62a12b2c-c94e-8d89-0e75-f01dc6abbe92@gmail.com>
Date:   Mon, 25 Jan 2021 21:56:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAKOOJTzwdSdwBF=H-h5qJzXaFDiMoX=vjrMi_vKfZoLrkt4=Lg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/21 2:03 PM, Edwin Peer wrote:
> On Sat, Jan 23, 2021 at 12:42 PM Edwin Peer <edwin.peer@broadcom.com> wrote:
> 
>> Then, if nla_put() can detect nesting errors, there's the issue of
>> what to do in the case of errors. Case in point, the IFLA_VFINFO_LIST
>> scenario would now require explicit error handling in the generator
>> logic, because we can't fail hard at that point. We would need to be
>> sure we propagate all possible nesting errors up to a common location
>> (probably where the nest ends, which is where we're dealing with the
>> problem in this solution), set the truncated flag and carry on (for
>> the same net effect the trim in nla_nest_end() has).
> 
> Also, the unwind here turns out to be just as complicated, requiring a
> traversal from the start and a trim anyway, because the attribute that
> triggers the overflow may be deep inside the hierarchy. We can't
> simply truncate at this point. We should remove whole elements at the
> uppermost level, or risk having partially filled attribute trees
> rather than missing attributes at the level of the exceeded nest -
> which may be worse.
> 

I'm not a fan of the skb trim idea. I think it would be better to figure
out how to stop adding to the skb when an attr length is going to exceed
64kB. Not failing hard with an error (ip link sh needs to succeed), but
truncating the specific attribute of a message with a flag so userspace
knows it is short.
