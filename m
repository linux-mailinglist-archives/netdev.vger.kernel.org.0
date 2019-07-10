Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4249C64EAA
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 00:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfGJWSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 18:18:53 -0400
Received: from mail-io1-f51.google.com ([209.85.166.51]:42891 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbfGJWSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 18:18:52 -0400
Received: by mail-io1-f51.google.com with SMTP id u19so8162880ior.9
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 15:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cLG4PZhR39XFR9yumYuAQ/EARX/7vtOIPJEaHVKLfo8=;
        b=ZGgGzOWYoaKZnIJKxYYNaa1ZEqSUxgc29+umSvL9OIg+6EXrMdDVB6pmNoM9rq52dK
         zyeJ5HqCM7P9ooCZMCDQi4OnCfDK+USBV6xA+BbuPgxg/qOfWeAPjfq8ncgoKn4w4WBi
         Z2GIMid/Mc2ht1IZsK35A9/9kiAbV2duGYJi9xMgOqGsQ1BJn9XcPkfqwPVUd+z8X42a
         xX9gu3EOaOLFvf6OfBvSmQDiRF2Z9A/DOt/6AM2ZNWNQqEPUEHwpmmcJtbFhCd4iWrsX
         yrj8g3HgjZSS+PBWm/6Kned4UzPd+CtzyIx/Wp2eGtWl+XH15YQj6TTCCu2V/KL66QKi
         Jmnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cLG4PZhR39XFR9yumYuAQ/EARX/7vtOIPJEaHVKLfo8=;
        b=tfWH10o2ByaCCx+4DQHN3VYUaNrVEmv93FZdWJs2eY/oIvYnwplIawwSofEimDt0zc
         /QL7+tKXL4+9ig708z9IFJ76x+qd+ge8xsrtehvzLiJNmoFzZSQrhnmy+vEl0ojIs3bQ
         3LYN9VoX4BBK8aQZYjcY6Fge4yKyN+Rpj53m5t1Pu6xUQMv5cm2W01bVxV7hox5zTLfu
         fxoiWE1LAvOyOgu5H5HAeWOZ/DXU4d692Pp8awldGIvYBfivRRLsSiHgEAslyHLlhJsr
         j/9GwPSp47lDH3Xr8rUoz1cE9PeDohWEcMZjeojWVjb08yeyim/5U1yE91HWlittH1Eb
         u35w==
X-Gm-Message-State: APjAAAXiNveAJnnrIXGKmxZmzjs9ieD5SSXN4EbFDwSM4NV0RzaGmuP0
        dfnFAuvVr84wLGoSfTdh2bI=
X-Google-Smtp-Source: APXvYqwN9neMDAK+ZJ21YmDe9G+KJVmfdxeGjnmpmXdXPL/k9snSDYN8nf06BgoIByomSJ1a7/PbKg==
X-Received: by 2002:a02:4005:: with SMTP id n5mr534793jaa.73.1562797131511;
        Wed, 10 Jul 2019 15:18:51 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:3913:d4da:8ed6:bdf3? ([2601:282:800:fd80:3913:d4da:8ed6:bdf3])
        by smtp.googlemail.com with ESMTPSA id n22sm5780991iob.37.2019.07.10.15.18.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 15:18:50 -0700 (PDT)
Subject: Re: NEIGH: BUG, double timer add, state is 8
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Marek Majkowski <marek@cloudflare.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
References: <CAJPywTJWQ9ACrp0naDn0gikU4P5-xGcGrZ6ZOKUeeC3S-k9+MA@mail.gmail.com>
 <1f4be489-4369-01d1-41c6-1406006df9c5@gmail.com>
 <20190705173011.GA2882@localhost.localdomain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c383ea93-4257-f31c-e259-f71169f7baef@gmail.com>
Date:   Wed, 10 Jul 2019 16:18:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190705173011.GA2882@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/19 11:30 AM, Lorenzo Bianconi wrote:
> looking at the reproducer it seems to me the issue is due to the use of
> 'NTF_USE' from userspace.
> Should we unschedule the neigh timer if we are in IN_TIMER receiving this
> flag from userspace? (taking appropriate locking)

I think you are right. Do you want to send a patch?
