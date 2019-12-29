Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6AA12BFC5
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 01:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfL2AN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 19:13:28 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38739 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfL2AN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 19:13:27 -0500
Received: by mail-pg1-f194.google.com with SMTP id a33so16311074pgm.5
        for <netdev@vger.kernel.org>; Sat, 28 Dec 2019 16:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X87rhBd+UktpzxH/iAqEZuIOWe5HFUhDknwlJQzhfXU=;
        b=voTsJ8vp2x4p14ymxvo5Co8MeX/z1qhzp6bl/TohpgNFc9WxmCWAQwghIETMHTZUv2
         aBi+BnSePLkURSfUs0w3x8wB/1lGfEB85XpPg3VxQWxOiypONDGLPjgoRliHTozYJrjc
         yRoUyfLK9/nFxMJRoj16JyEdX717VnqfnWcLa4pdgO6s0z7uvQ34ZS6cJLF9nnZXTKL5
         3WhHb4l4wcG4r4KUXGcEFfwuinsNVKSd2ArSNHdyMf5JtCzACGd7ANp6hhW5aPt6r2+c
         H82PthKARn9iHUG3OFb5whwJdGYtXcDx2FkeQ/hwhMbq2vKDV1jz1rES31/Wk8D8bmA4
         pdfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X87rhBd+UktpzxH/iAqEZuIOWe5HFUhDknwlJQzhfXU=;
        b=HFw0s1iUZFYVwdLQPmvbDGrObWJcpiTpFqbVEj7Ywt76zQzbnojHUUXNrIpe6ZQ2xo
         v1KS8Wz8XCWesUPP85eO9w/FwTGC07dUj3udt2Zmvt0/k3wH9fWPoUkjDt/4v5BcHdXP
         GSZ7FXXTxUfv9Md5f9U3GHBB+LXrQUvpNAWp3YeGh1FFEtAUkkcxQO3qYWbsAauuujKZ
         YL6DGn+myWkR89OpO9Hy10WZkxDMkKCbqbHvr+QkBOW4pD37uv2JlW35VfYnzJyc/e0Y
         qVWMrZqfSJui/8N3qo6CZNQjH5KeA5zjNvQPA6x+tuB7qbZKI4AdmetJDXaJANNQ5UAJ
         +CzA==
X-Gm-Message-State: APjAAAVCqGXDoJEwqhUJC3/AVIzpxZYLri3KCHy3v1q/yWur2ZM6koEd
        eSZ2ZYHw4IWwcK1j0pm66PtjpQ==
X-Google-Smtp-Source: APXvYqxYpEanaEjAq3YfrtPVToWCHD2GjlB8uSTs6QmtEb5DIbUkXwnG3gWJgVXEwxnYGpMG3f/uJQ==
X-Received: by 2002:a62:e511:: with SMTP id n17mr19323713pff.187.1577578407183;
        Sat, 28 Dec 2019 16:13:27 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f81sm46502970pfa.118.2019.12.28.16.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 16:13:26 -0800 (PST)
Date:   Sat, 28 Dec 2019 16:13:18 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next, 3/3] hv_netvsc: Name NICs based on vmbus offer
 sequence and use async probe
Message-ID: <20191228161318.4501bb79@hermes.lan>
In-Reply-To: <1577576793-113222-4-git-send-email-haiyangz@microsoft.com>
References: <1577576793-113222-1-git-send-email-haiyangz@microsoft.com>
        <1577576793-113222-4-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Dec 2019 15:46:33 -0800
Haiyang Zhang <haiyangz@microsoft.com> wrote:

> -	net = alloc_etherdev_mq(sizeof(struct net_device_context),
> -				VRSS_CHANNEL_MAX);
> +	snprintf(name, IFNAMSIZ, "eth%d", dev->channel->dev_num);
> +	net = alloc_netdev_mqs(sizeof(struct net_device_context), name,
> +			       NET_NAME_ENUM, ether_setup,
> +			       VRSS_CHANNEL_MAX, VRSS_CHANNEL_MAX);
> +

Naming is a hard problem, and best left to userspace.
By choosing ethN as a naming policy, you potentially run into naming
conflicts with other non netvsc devices like those passed through or
SR-IOV devices.

Better to have udev use dev_num and use something like envN or something.
Udev also handles SRIOV devices in later versions.

Fighting against systemd, netplan, etc is not going to be make friends.
