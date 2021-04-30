Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01ADA36F421
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 04:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhD3CsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 22:48:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhD3CsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 22:48:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619750838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hpEdYHozyLkSWC44kvxe4BWSv8TOzx/7mnztZneDEKc=;
        b=EY3tDJdJzx28HwYB095U8WhYBx8p71P7O2U7a/oCBP8iJV9ESFz2JRTMR/PVSGMTlu8JfP
        A6RXh+amWqIrKFVMu82Wh1ek462lVhBN8p/tYr+mCKX4hOTXyfGmio5Z01VZdIQc8KDHbw
        euH32DSctKCJh/h5G16EJ1NbPEEBNSY=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-WIeBaoRvOmOXn1pIl75HTg-1; Thu, 29 Apr 2021 22:47:16 -0400
X-MC-Unique: WIeBaoRvOmOXn1pIl75HTg-1
Received: by mail-lf1-f71.google.com with SMTP id s8-20020a1977080000b02901ae88fbe012so11720164lfc.7
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 19:47:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:mime-version:in-reply-to:date
         :message-id:subject:to:cc;
        bh=hpEdYHozyLkSWC44kvxe4BWSv8TOzx/7mnztZneDEKc=;
        b=QfyWop7nvMmzRz2vvmM4VHk7vTYyzWCiWiX54gxosmd8f9E4/qUarisqG1NP+H4uyg
         BbSkpUByjqkzsFdL8HZIKzarKYbtOE1YhmTeK/bOo9N2aHaff1jPpiagPxfApHbPZsap
         LVHaJk9OGpqN3TBAaxXgfj6N9zL9uVNIlyDiBKf+HUok3iswt0c8BBIQN0EDy4YX4HEo
         VXq7GQckRld+yri4Od74uzs3z+kwezFvjw06jPyArQb7qsP51+eOVW9FZEvK6f0jKn4v
         coIA/rr+4qUxoOZyck2+A9O2b5/BcYzAoyiRoFZqDP7RdWfRLi79zBbQTIsVmYtXsEuR
         0LAA==
X-Gm-Message-State: AOAM531PiLNen/XnQPNIOsJKVh7la6DrbXFTz13nmf10WFlmgTWPkMrt
        WG/7t+5i07RFZ4kND4mQlRTf8ful3ES6p3MmK980IiE8haQH1Bl1VZyRtik6oZFGaKolklon0DD
        +3gJ6VDORcRh9dk/ABsZuqORNHO5jZrgk
X-Received: by 2002:a19:ac44:: with SMTP id r4mr1687885lfc.438.1619750834964;
        Thu, 29 Apr 2021 19:47:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWKs6Pdr1iJCtP4FnP0ssobBLG83RYdmxz0DzkVqUGKe1bO+eTQGZxi/6xSNYlrj2fVDZ6i4o6KVPYO8vMfv8=
X-Received: by 2002:a19:ac44:: with SMTP id r4mr1687872lfc.438.1619750834817;
 Thu, 29 Apr 2021 19:47:14 -0700 (PDT)
Received: from 868169051519 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 29 Apr 2021 19:47:13 -0700
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20210429081014.28498-1-simon.horman@netronome.com>
MIME-Version: 1.0
In-Reply-To: <20210429081014.28498-1-simon.horman@netronome.com>
Date:   Thu, 29 Apr 2021 19:47:13 -0700
Message-ID: <CALnP8ZaZQAbvm1girLUSLcFZTKV5MvBMEtN67OiA55OAvsO_1Q@mail.gmail.com>
Subject: Re: [RFC net-next] net/flow_offload: allow user to offload tc action
 to net device
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>, dcaratti@redhat.com,
        ozsh@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 10:10:14AM +0200, Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
>
> Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
> tc actions independent of flows.
>
> The motivation for this work is to prepare for using TC police action
> instances to provide hardware offload of OVS metering feature - which calls
> for policers that may be used my multiple flows and whose lifecycle is
> independent of any flows that use them.

Makes sense to me.

>
> This patch includes basic changes to offload drivers to return EOPNOTSUPP
> if this feature is used - it is not yet supported by any driver.

I miss indications on whether the action is offloaded or not. That's
really useful for debugging. extacks are nice but they may not be
logged and are not present in dumps later on.

As the offloading is optional here (it will fill in the extack but not
error out), seems that it's up to the driver then to ensure that the
action is offloaded when offloading a flow that uses such action,
right? With that, all the skip_sw/skip_hw dealing is left to the
flow/classifier.

  Marcelo

