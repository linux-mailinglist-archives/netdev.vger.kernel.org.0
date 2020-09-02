Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F8F25A5A9
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 08:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgIBGlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 02:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgIBGlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 02:41:51 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E63C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 23:41:51 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t13so4045414ile.9
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 23:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R9alJcLxpOj2/b+OW0rD9lIgzwMWmTv7xLREP6LowXg=;
        b=jk32QlRXuHNp7AdRbckFjG1ANh6hTg743Gmw3wLi8sJSfQHh574V/eoO5+mihGHtaj
         4JEe/2CgQ1DwVkLrLvNt7nGomQ0H8snGefzzKIb8PuF/BEowUaKsaylJHu2mgK+ftap9
         HFTMv6u/hox1gw3oM4G37OKLPm9IjiJcg+QzK8YvLvY3ln4O35DA68I5naX8hMkxnsgz
         Eots825Kw8VxTRl0F5JJI/9i1Dg75WlJKkBB9H5PqrhA4JoZsElX8J2RBAk0pW+ABCTs
         fgA+VtTFWmcINH7DfnGACBn8jVq6jhTc5yIgT4nJeNe5DvKBaY1EYZU14MVpg7oDhDlh
         W6jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R9alJcLxpOj2/b+OW0rD9lIgzwMWmTv7xLREP6LowXg=;
        b=nrqFs/uhZuaz1wXAw4IXOl3SJo/EPhTqpAl9d39TcBpgtLhDmHA6wFB3/BRGEkD9sz
         aEdRG70+6vKgkD1Eb699VT5QXDnISEa3s2tkBk97529m51BvecIALVAkGTdPQpk/tWb0
         IvWjYm37pxZgb0BQEuiD01hYBzDPEyqLNJQb9nfhuQ6C5zqq0F0ohpigZnLEDHjolfiC
         0bNqHujp++dMSBIOvvA6gohfO9PdneJ/YPCWNlBOPGBiH9PWECWOvFAc1eqhOfVkUW+P
         /Jjl6wWJ+Bv8/t5oxr1tz83b80p9eaSu9woF9t6bYuRpS/JZZV5oF9IJNQpKoOwm+U5G
         ARAw==
X-Gm-Message-State: AOAM533yjER7Vmdqh7CTbfx12Xtirj/Tp3ulwbTNPI8anH4FzZ5JFOkh
        oh5dXtpBi5aBLTW2NYRKEjs3Xq2eL4lTdPOH8M/DTvBHIzyzkA==
X-Google-Smtp-Source: ABdhPJxPO9T8XGeWcOhIo49WItCUgYxTGqkm1WEwoAetvQJ7iYXG3j4g8CeHVyJbi90OomVOUB+CvNvNWvb4Er70O+4=
X-Received: by 2002:a92:9996:: with SMTP id t22mr2470017ilk.216.1599028910535;
 Tue, 01 Sep 2020 23:41:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200901212009.1314401-1-yyd@google.com> <20200901220200.GB3050651@lunn.ch>
 <CAPREpbaFi6Tqw+YKx=1c1nFRtUt9G2gRW2BT83siqojy=DOEmA@mail.gmail.com>
In-Reply-To: <CAPREpbaFi6Tqw+YKx=1c1nFRtUt9G2gRW2BT83siqojy=DOEmA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Sep 2020 08:41:38 +0200
Message-ID: <CANn89i+3SGKw8CruFrQx2LZXOW2SNphSZHxStFsCJxY2Z+ZtxA@mail.gmail.com>
Subject: Re: [PATCH ethtool] ethtool: add support show/set-hwtstamp
To:     Kevin Yang <yyd@google.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        Networking <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 2, 2020 at 2:36 AM Kevin Yang <yyd@google.com> wrote:
>
> Hi Andrew,
>
> They are pretty much the same, both use ioctl(SIOCSHWTSTAMP).
>
> Adding this to ethtool is because:
> - This time stamping policy is a hardware setting aligned with ethtool's purpose "query and control network device driver and hardware settings"
> - ethtool is widely used, system administrators don't need to install another binary to control this feature.
>


Absolutely. ethtool has -T support already, and is the facto tool for
things not covered by iproute2 suite.

Having to remember a myriad of binaries that basically use a single
ioctl() is time consuming.

> Kevin
>
> On Tue, Sep 1, 2020 at 6:02 PM Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> On Tue, Sep 01, 2020 at 05:20:09PM -0400, Kevin(Yudong) Yang wrote:
>> > Before this patch, ethtool has -T/--show-time-stamping that only
>> > shows the device's time stamping capabilities but not the time
>> > stamping policy that is used by the device.
>>
>> Hi Kavin
>>
>> How does this differ from hwstamp_ctl(1)?
>>
>>     Andrew
