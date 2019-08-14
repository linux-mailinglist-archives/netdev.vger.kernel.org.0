Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912E58E040
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 00:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbfHNWBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 18:01:39 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41432 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728583AbfHNWBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 18:01:39 -0400
Received: by mail-qk1-f193.google.com with SMTP id g17so325855qkk.8
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 15:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=jnzlZ6m4MyBxiN6dXhfXGdbsyLhcPOPGv61CSnzfC+A=;
        b=r/fxvywngqCj51PhCj37ngMB4xdglQXrSEZWUwJQGToBavgm0YUXJH/dZZb3sRhMSa
         4XdBcej/gP8n2ywM/WYTbJQyhogVOj0HNnbJGWNegWHQHSpTynmdFvdMqwwALj4F1gp7
         0w1QKvqUMeLRhbFVXfob6wnOs2TsqdVdfUOECgdNykLDS1opGxonLPw41BqlwriC1gza
         jixtbKZoTs/K+iMJ4t8m+eQqqL7TwY6UBO3O7BbenB7+UvQRiDdDfaBAEjHgNVSR5ulZ
         l3McWlEvyI1bdjmQ0r7UEsIdcKbJCEJmBTTRjbFfmnFkZRdEcsVXpfDhfN4cXdkZYYmj
         Km8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=jnzlZ6m4MyBxiN6dXhfXGdbsyLhcPOPGv61CSnzfC+A=;
        b=ic76JpHvjUt+siJ4iMNCB6eB471B1O6eCJFRHU7X+3kUBPuQqa3DdeM+r3Rck9guwb
         AAfl5LhYE6I6ufrGePTI5++n6EwpqxK+uGbc2lEzPJvpfOJvCqdJ3bUoExvJuoAF7xGA
         yaY/ltkmpv9j0dh4wRxnWYP5Aq4lRKme08tvz149gDtyACPPSWanzYjP/9wto3prG5jS
         b/d93peVFrS5UJxHJrxq3RZpm5VpTANmiCzcfvdePKAjERb+sLYdYH2L+OZuUk6QP13Z
         JY9nuh+9W+vDYO5ud0ve7jv6+nqU/QXzvPISD5/+2x2JYB5Xr6UwmQM3pbdTRyXxw8x7
         7EJw==
X-Gm-Message-State: APjAAAU6kRfO6iCLSlCmlqjgdAhRQFJXVYpOFt32HUYQoiAbVZtzmRhB
        MbDo3Mw73uTY8LoI06HuChWoXQ==
X-Google-Smtp-Source: APXvYqyevbHlwujs+qIs2fF8/38hu1aCZhxdWs5ZHvmvdjmB2g6RzytsVXv5cXSc7L03g/nXtTIcqg==
X-Received: by 2002:a37:bcc:: with SMTP id 195mr1339307qkl.115.1565820098385;
        Wed, 14 Aug 2019 15:01:38 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p201sm511922qke.6.2019.08.14.15.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 15:01:38 -0700 (PDT)
Date:   Wed, 14 Aug 2019 15:01:23 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v2] net: Don't call XDP_SETUP_PROG when nothing
 is changed
Message-ID: <20190814150123.6b5124e8@cakuba.netronome.com>
In-Reply-To: <20190814143352.3759-1-maximmi@mellanox.com>
References: <5b123e9a-095f-1db4-da6e-5af6552430e1@iogearbox.net>
        <20190814143352.3759-1-maximmi@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Aug 2019 14:34:06 +0000, Maxim Mikityanskiy wrote:
> Don't uninstall an XDP program when none is installed, and don't install
> an XDP program that has the same ID as the one already installed.
> 
> dev_change_xdp_fd doesn't perform any checks in case it uninstalls an
> XDP program. It means that the driver's ndo_bpf can be called with
> XDP_SETUP_PROG asking to set it to NULL even if it's already NULL. This
> case happens if the user runs `ip link set eth0 xdp off` when there is
> no XDP program attached.
> 
> The symmetrical case is possible when the user tries to set the program
> that is already set.
> 
> The drivers typically perform some heavy operations on XDP_SETUP_PROG,
> so they all have to handle these cases internally to return early if
> they happen. This patch puts this check into the kernel code, so that
> all drivers will benefit from it.
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
