Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9E7130F44
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 10:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgAFJPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 04:15:22 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34739 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgAFJPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 04:15:22 -0500
Received: by mail-wm1-f65.google.com with SMTP id c127so11521294wme.1
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 01:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4VtkJOWxvkjDl+K0oCCQ8dR7Rria7UWd5+hg4tRr4LU=;
        b=EfDt+aq+RAtskK/m+3NPy/+0p+ZNKRvsMYWU16cbOog2c0qvwq7A9R3JLzBtiMefhB
         gtADG8jy5f0qoEGTzoQzTFVWECapVpKXt62VDK1e85y2bS1jkDWcMNqw+HgBlIu4W2vm
         oX20eRfdJ2n3UKlzQRZIgyLvinxAM9Ov3RqWM8qWD4+OQCUcyFAEsXnsJ68m+jStKHZ2
         1JfqJKg34mi06Y2BYXQVgh3z1cU4AD5XvHQjo8gGBDV376f01vPuc4v00n6R45/ydElX
         Q8bvxwodmHtricVWi/ZPNwyoq/ySjRXv/YSFvNyYol+41ikgV5B3MJTmHOoQ7Nm8I4wn
         C4Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4VtkJOWxvkjDl+K0oCCQ8dR7Rria7UWd5+hg4tRr4LU=;
        b=qRnQOLHpsgCXYiKQq/13fX94F+rmFvG1fi6TMevWPkUtsi7Dh86d4O0/HvV3eBdXZx
         C58v5LP/dgUyCKk/vUhMCqNB7bM7eHTwSglEs8X9H5XroQVCbGKH1X0ZX/Yk97hBstdx
         qmVpySbAgAFlc85j2Ia3+OoAQtGI5FQKtdOepycI5OyoPZ/6NCISJ/el8/cQuEk6JWQ4
         aUvraASl92RVdPeI0EQpzNruX4nim2cLVZuqNtBuYJE5GTLLEtFyKhVWumATohObLGzt
         hwuLSxclmyz0jYq9hEuCN7nLi20f9xx+mgOnuly5bjQsVQhgHQbkB//WbjtG4IW1m/8M
         iWDw==
X-Gm-Message-State: APjAAAVJgjm+T+BDDcvxZV83jCfDFFfOwUoM/4R2pK4qNRb/nUmAlbKB
        NfB5H97n1WfCvPWtftH8cec38FUexBo=
X-Google-Smtp-Source: APXvYqysTfH1gT1osyhLhpwZlULDuYwsDSy32rWbc05Vz+4i1QDNOgtm9+hv3oHKpBSsOxtbiT2wPg==
X-Received: by 2002:a1c:6404:: with SMTP id y4mr33755984wmb.143.1578302120644;
        Mon, 06 Jan 2020 01:15:20 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b17sm68953242wrx.15.2020.01.06.01.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 01:15:20 -0800 (PST)
Date:   Mon, 6 Jan 2020 10:15:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, saeedm@mellanox.com, leon@kernel.org,
        tariqt@mellanox.com, ayal@mellanox.com, vladbu@mellanox.com,
        michaelgur@mellanox.com, moshe@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 0/4] net: allow per-net notifier to follow
 netdev into namespace
Message-ID: <20200106091519.GB9150@nanopsycho.orion>
References: <20191220123542.26315-1-jiri@resnulli.us>
 <72587b16-d459-aa6e-b813-cf14b4118b0c@gmail.com>
 <20191221081406.GB2246@nanopsycho.orion>
 <e66fee63-ad27-c5e0-8321-76999e7d82c9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e66fee63-ad27-c5e0-8321-76999e7d82c9@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Dec 22, 2019 at 05:57:35AM CET, dsahern@gmail.com wrote:
>On 12/21/19 1:14 AM, Jiri Pirko wrote:
>> Fri, Dec 20, 2019 at 07:30:22PM CET, dsahern@gmail.com wrote:
>>> On 12/20/19 5:35 AM, Jiri Pirko wrote:
>>>> However if netdev can change namespace, per-net notifier cannot be used.
>>>> Introduce dev_net variant that is basically per-net notifier with an
>>>> extension that re-registers the per-net notifier upon netdev namespace
>>>> change. Basically the per-net notifier follows the netdev into
>>>> namespace.
>>>
>>> This is getting convoluted.
>>>
>>> If the driver wants notifications in a new namespace, then it should
>>> register for notifiers in the new namespace. The info for
>>> NETDEV_UNREGISTER event could indicate the device is getting moved to a
>>> new namespace and the driver register for notifications in the new
>> 
>> Yes, I considered this option. However, that would lead to having a pair
>> of notifier block struct for every registration and basically the same
>> tracking code would be implemented in every driver.
>> 
>> That is why i chose this implementation where there is still one
>> notifier block structure and the core takes care of the tracking for
>> all.
>> 
>
>This design has core code only handling half of the problem - automatic
>registration in new namespaces for a netdev but not dealing with drivers
>receiving notifications in namespaces they no longer care about. If a

I do not follow. This patchset assures that driver does not get
notification of namespace it does not care about. I'm not sure what do
you mean by "half of the problem".


>driver cares for granularity, it can deal with namespace changes on its
>own. If that's too much, use the global registration.
