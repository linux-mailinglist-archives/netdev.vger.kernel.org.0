Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC53AFDA4
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 15:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbfIKNWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 09:22:02 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42847 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbfIKNWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 09:22:01 -0400
Received: by mail-lj1-f196.google.com with SMTP id y23so19955131lje.9
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 06:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PCyL2xtvyQdLdW6FJFwSDs6+Mxk/HA5bYPmnFS87ufs=;
        b=LzrvAgM9OQYbI9TUU3c/HZDniGCL2JHzdTV2dek9I5BeMfC8fagkSditS2/3sSLF15
         gapZp7Kvj5gPYxhHqMfEeUugXZBIcmPhU8ZG6uq7NMNhdKrtFoebT8k6wftDA+V6Myqy
         31HyzHH8rPW0ntcQNOG6w8RJaSfugWER2fT5Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PCyL2xtvyQdLdW6FJFwSDs6+Mxk/HA5bYPmnFS87ufs=;
        b=cCKZ4mfnaLLF6DEsTkQbVF39BOc7ypoJVgvK/0EKz6ApcbKjjdqdDc05EAC1/CLhIy
         7sCA1gx/+aXbwwNfLYBo7EzBWqdQWStLpIteeKSOY4+5oi7KHUEStvanQi0dW4JsXVub
         dKUYsDDsbCVCX9M+qoRM7jn6ylI1TfI652wysULwqPQLT2V4oGnb6lpAH+zgVPFZ+Pt1
         ngZgdh4hc/p+2M/ezrgb3RN1o3eDwuyOF4CwC21PZQtQpApyOm4EYqSnF9gG7fvMe9CP
         H7KOHIqpEHtRBr0bzz4JwoWJHQ3lP9L4xJAQWGOwJ55T6dnewh8NYaSKKqe1TODonkK0
         ohZA==
X-Gm-Message-State: APjAAAVRPvpp4OlMpzklK5/ScvWq/h1Y+BrLbNRbdV68whzizOYOkvpx
        HtTkyf9F8uoZCK+l4I6a1QlbVp2H/CHAXQ==
X-Google-Smtp-Source: APXvYqxYIYfhzfg6dFE5978N+b04gyOmC1neOijz59ksRdplb4eP0TLWrMSy2G+FBYu0wzwfgFCwGA==
X-Received: by 2002:a2e:8910:: with SMTP id d16mr8117666lji.12.1568208117254;
        Wed, 11 Sep 2019 06:21:57 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id t24sm5062315lfq.13.2019.09.11.06.21.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 06:21:56 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id c195so1565481lfg.9
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 06:21:56 -0700 (PDT)
X-Received: by 2002:ac2:5c11:: with SMTP id r17mr24534839lfp.61.1568208115902;
 Wed, 11 Sep 2019 06:21:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wgBuu8PiYpD7uWgxTSY8aUOJj6NJ=ivNQPYjAKO=cRinA@mail.gmail.com>
 <feecebfcceba521703f13c8ee7f5bb9016924cb6.camel@sipsolutions.net>
 <CAHk-=wj_jneK+UYzHhjwsH0XxP0knM+2o2OeFVEz-FjuQ77-ow@mail.gmail.com>
 <30679d3f86731475943856196478677e70a349a9.camel@sipsolutions.net> <2d673d55-eb27-8573-b8ae-a493335723cf@candelatech.com>
In-Reply-To: <2d673d55-eb27-8573-b8ae-a493335723cf@candelatech.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 11 Sep 2019 14:21:39 +0100
X-Gmail-Original-Message-ID: <CAHk-=wgAXAw=U_kthB9mG+MBocpawxCzo=6WDrbGgOUr+ac3CA@mail.gmail.com>
Message-ID: <CAHk-=wgAXAw=U_kthB9mG+MBocpawxCzo=6WDrbGgOUr+ac3CA@mail.gmail.com>
Subject: Re: WARNING at net/mac80211/sta_info.c:1057 (__sta_info_destroy_part2())
To:     Ben Greear <greearb@candelatech.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 2:03 PM Ben Greear <greearb@candelatech.com> wrote:
>
> Out of curiosity, I'm interested to know what ath10k NIC chipset this is from.

It's a Dell XPS 13 9380, with

  02:00.0 Network controller: Qualcomm Atheros QCA6174 802.11ac
Wireless Network Adapter (rev 32)
        Subsystem: Bigfoot Networks, Inc. Killer 1435 Wireless-AC

(numeric PCI ID 168c:003e, subsystem 1a56:143a).

The ath10k driver says

    qca6174 hw3.2 target 0x05030000 chip_id 0x00340aff sub 1a56:143a
    firmware ver WLAN.RM.4.4.1-00140-QCARMSWPZ-1 api 6 features
wowlan,ignore-otp,mfp crc32 29eb8ca1
    board_file api 2 bmi_id N/A crc32 4ed3569e

if that tells you anything more.

              Linus
