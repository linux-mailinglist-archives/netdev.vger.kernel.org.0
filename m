Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7157A41F19
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 10:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437144AbfFLIbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 04:31:23 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36388 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436884AbfFLIbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 04:31:22 -0400
Received: by mail-qk1-f196.google.com with SMTP id g18so9555246qkl.3;
        Wed, 12 Jun 2019 01:31:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=amZ8LRkQPQSX4K2c2VzVofPEOqqTn0oph48teP/8EWw=;
        b=VD5qLWTYWv+L7e6yfJW8Kaz9zQdZRP/sMVMq06ZM8Zh2G3apPD4RIILtqYyikGaHv1
         X3PtEeZ/fcnTSsk82rDWx9RtuB5yDPBk57JTtaMWt+/kfD5tMwPuCotZnmW/ZFOlfY0X
         zj0i7b4slxmGVo2VsOP7MzTnFmTqleFhdilUe89oIYSVc1hh5TbahMQkXJhuIWTYKtPR
         +FKGf1IPWpaF6i8Ds6CWoU9HqhZL8XEK5xjorY+qbTNQajRI6txkWy9+N9MEFqJc1qrw
         iP5DQs3MZz7CSttsimkQd/mqu9ltO4pzcm83F0HyDp8wjvn8NLCLRiI/lm0BexOuB4If
         3E8A==
X-Gm-Message-State: APjAAAX5tpD6Dn4obJQ9j41caeywxH7voSnQIFi0tlRrGo/G5XH/jWqx
        rCl7xxxTtnOK8ANhNXiglIGfH3wSP5NuYMyQ2Sg=
X-Google-Smtp-Source: APXvYqw8M9NVS5FWEo9c/CfCQavp0lk2HRFD2/V+fVHJmBJioytq8q6qxeJpvv/aHiDmMVt0v3DO6nTZszcSwl8ZWJY=
X-Received: by 2002:a05:620a:35e:: with SMTP id t30mr64863407qkm.14.1560328281195;
 Wed, 12 Jun 2019 01:31:21 -0700 (PDT)
MIME-Version: 1.0
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
 <36bca57c999f611353fd9741c55bb2a7@codeaurora.org> <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
In-Reply-To: <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 12 Jun 2019 10:31:04 +0200
Message-ID: <CAK8P3a2Y+tcL1-V57dtypWHndNT3eDJdcKj29c_v+k8o1HHQig@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Dan Williams <dcbw@redhat.com>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alex Elder <elder@linaro.org>, abhishek.esse@gmail.com,
        Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        syadagir@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 7:23 PM Dan Williams <dcbw@redhat.com> wrote:
> On Tue, 2019-06-11 at 10:52 -0600, Subash Abhinov Kasiviswanathan wrote:
>
> rmnet should handle muxing the QMAP, QoS, and aggregation and pass the
> resulting packet to the lower layer. That lower layer could be IPA or
> qmi_wwan, which in turn passes that QMAP packet to USB or GSI or
> whatever. This is typically how Linux handles clean abstractions
> between different protocol layers in drivers.
>
> Similar to some WiFi drivers (drivers/net/wireless/marvell/libertas for
> example) where the same firmware interface can be accessed via PCI,
> SDIO, USB, SPI, etc. The bus-specific code is self-contained and does
> not creep into the upper more generic parts.

Yes, I think that is a good model. In case of libertas, we have multiple
layers inheritence from the basic device (slightly different in the
implementation,
but that is how it should be):

struct if_cs_card { /* pcmcia specific */
     struct lbs_private {  /* libertas specific */
           struct wireless_dev { /* 802.11 specific */
                  struct net_device {
                        struct device {
                              ...
                        };
                        ...
                  };
                  ...
           };
           ...
      };
      ...
};

The outer structure gets allocated when probing the hardware specific
driver, and everything below it is implemented as direct function calls
into the more generic code, or as function pointers into the more specific
code.

The current rmnet model is different in that by design the upper layer
(rmnet) and the lower layer (qmi_wwan, ipa, ...) are kept independent in
both directions, i.e. ipa has (almost) no knowledge of rmnet, and just
has pointers to the other net_device:

       ipa_device
           net_device

       rmnet_port
           net_device

I understand that the rmnet model was intended to provide a cleaner
abstraction, but it's not how we normally structure subsystems in
Linux, and moving to a model more like how wireless_dev works
would improve both readability and performance, as you describe
it, it would be more like (ignoring for now the need for multiple
connections):

   ipa_dev
        rmnet_dev
               wwan_dev
                      net_device

Where each layer is a specialization of the next. Note: this is a
common change when moving from proprietary code to upstream
code. If a driver module is designed to live out of tree, there
is a strong incentive to limit the number of interfaces it uses,
but when it gets merged, it becomes much more flexible, as
an internal interface between wwan_dev and the hardware driver(s)
can be easily changed by modifying all drivers at once.

       Arnd
