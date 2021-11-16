Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8435945367C
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238634AbhKPP6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:58:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238750AbhKPP6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 10:58:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637078124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L1td5N7CmLUqifKOF7jmRnrLLO0MGYzWNKCojjnGUr0=;
        b=EldbetMDrkATuxD/8s8Fg44vwJVgPQ/4aTZzQ7EpXUc47ANO8y9kDix96OedbF2oLDaN87
        NkonoEmwRZX1x74lsub+SOCpQwjHeJmHHTF6Oy/w94e+qYRq+jZM7Y1AmVFBqgBq4i+Uh2
        xlD1zk8yV4tZ9Q1vbIp3mB2PSURQgAI=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-1AMeMpTYP7eJfYcZMN_Ehg-1; Tue, 16 Nov 2021 10:55:20 -0500
X-MC-Unique: 1AMeMpTYP7eJfYcZMN_Ehg-1
Received: by mail-il1-f197.google.com with SMTP id c17-20020a92b751000000b0027392cd873aso13137507ilm.0
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 07:55:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:references:mime-version:in-reply-to:date
         :message-id:subject:to:cc;
        bh=L1td5N7CmLUqifKOF7jmRnrLLO0MGYzWNKCojjnGUr0=;
        b=fQtkQT+b3vMaOm6gnaeya1r6Y6GphaQXegRiffCk/RS9sCwBxfrK2siB/77dkHIaVK
         vdoITmPwOV6mDHKR3w6BETqc02X0FO8aBpn/tanyBqW0s3X9XBQ2NaJsO3trAvEgwHXv
         4xzkBOnKYSeqf1VxHWHJTirUm8z08r0YhEAAkMCtaHuoPU6j/Q+iM3BOhyvRwK/mLast
         enQ3OabZDbc5DUO4DV1By1kbPWKdBMB53Dcob/ttEHE3cbyqcMtdhVwv0ijftGIn4yrI
         63YDwaVoUiutjSjNcIbSjEAPA7iWF5c0PpfK7TYhtAzgvWJYNMSRr+NaE6r7CYpPBxez
         V+8g==
X-Gm-Message-State: AOAM532Z65/xSxyFWvMhrSHrHmSlFdr6vWj+uT39Nugz96Qtb47dx1rO
        7jO39j9fnQj8thjP27isVBvrLbeKa0w+mKU2fcuC+2bNG8ZJ6P1CGSfjgGb1Z6HdEbAN13L640m
        YpXkmTglvqNFnBmUgDy5z7swHVDJMXyc7
X-Received: by 2002:a92:d843:: with SMTP id h3mr5280285ilq.91.1637078120300;
        Tue, 16 Nov 2021 07:55:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwEbCxRs2cPgZXHn8YNc/5vA1It+LFrRCVge/8nZkg4VHtHaTtxI7cspCsEc59wnIBMvVUKWuxFGklA9+eA2Gg=
X-Received: by 2002:a92:d843:: with SMTP id h3mr5280271ilq.91.1637078120072;
 Tue, 16 Nov 2021 07:55:20 -0800 (PST)
Received: from 868169051519 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 16 Nov 2021 09:55:19 -0600
From:   mleitner@redhat.com
References: <cover.1636734751.git.lucien.xin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <cover.1636734751.git.lucien.xin@gmail.com>
Date:   Tue, 16 Nov 2021 09:55:19 -0600
Message-ID: <CALnP8ZYU67P2+ne+BM9OCNzGfOj7M+qRzHP8UtNO68_O3KjQhw@mail.gmail.com>
Subject: Re: [PATCH net 0/2] net: fix the mirred packet drop due to the
 incorrect dst
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 11:33:10AM -0500, Xin Long wrote:
> This issue was found when using OVS HWOL on OVN-k8s. These packets
> dropped on rx path were seen with output dst, which should've been
> dropped from the skbs when redirecting them.
>
> The 1st patch is to the fix and the 2nd is a selftest to reproduce
> and verify it.

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

