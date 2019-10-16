Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 679DCDA27F
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 01:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394901AbfJPXzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 19:55:42 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41195 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729939AbfJPXzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 19:55:41 -0400
Received: by mail-lj1-f196.google.com with SMTP id f5so521726ljg.8
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 16:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=uL6fp3k8sxcba+4hRLg6z3bVGUawFpouMPeEo11F1YA=;
        b=IZ665a5hkySLq/BiSDP56h7d2yw2MUJiNDcQBuLZkg8aDlEJu8wi4nh8TgDDKpUs98
         PbebXpIjWjcTMg0OdmVGkBhC1iQQfEEW6tQ5xh7qNnNUbzPhD4U+pYVyCnfgAlqnVboV
         4fA9d5U3XncRQPKEkBFkKhIjU/yKUgK4C2L7evqRKvhxTGA9zeDHA+R3IP3l/BMrGrX9
         6HPzIZaMvXxKp7RzmM3L+RzAfAdxG9f0dnWLqj5b64x+Omqds5LEAw2cFpvJbJ65ijYN
         b1UVfoFQr5aTaNffNqFs4VYnf5sb29O1qUFWG22wrKUknxFb17+lffMsG4eJjw72+Yck
         uoAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=uL6fp3k8sxcba+4hRLg6z3bVGUawFpouMPeEo11F1YA=;
        b=s1XETu+ql7YPkd6O9qR1bn4Izb3Yj79zGvyuFyWljlDKH9TY//DCpXsk5WwWvOFFB0
         pjUs7xQlZmDFfm7IptBgr4z7oRq16+2LqxA5yJn4uAUwfMDIAkvORX3FIKZJ7IqK97uv
         ETIuvzV6r4y3jy26pB1O+A2n8vizrdBVFhf3soOw6gTljX35JWP5DLW0G0Knv1wY4L17
         81/UBgy6xSbbKtBmWqGBHZzTDA+umpzQbIZZYg+leOjWLfXZ1NpPfDrkcGNQeTWY61IM
         zzD56ESjv+t5L6XIdlWbfxg1GDcaYmUowUxSsFdgWbS0lUKy5F6VJ+texPA/1FLwBRFn
         OB8g==
X-Gm-Message-State: APjAAAU6nFDV4RwN8w/zUIbP7qR6BN9eGmzXqnDGPfCuUaqV1WfCYE4R
        +APyePD7nlVK0WHG3qXcxVS1rw==
X-Google-Smtp-Source: APXvYqwGhBRjmKVYlwbCP/vEt1QxfqKD7/45X968rLo5ogY8/GIT9GWGoCfAMCepuOQdA/89tEfnkQ==
X-Received: by 2002:a2e:a179:: with SMTP id u25mr444028ljl.33.1571270139670;
        Wed, 16 Oct 2019 16:55:39 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h3sm127788lfc.26.2019.10.16.16.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 16:55:39 -0700 (PDT)
Date:   Wed, 16 Oct 2019 16:55:31 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Robert Beckett <bob.beckett@collabora.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net-next 2/7] igb: add rx drop enable attribute
Message-ID: <20191016165531.26854b0e@cakuba.netronome.com>
In-Reply-To: <20191016234711.21823-3-jeffrey.t.kirsher@intel.com>
References: <20191016234711.21823-1-jeffrey.t.kirsher@intel.com>
        <20191016234711.21823-3-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 16:47:06 -0700, Jeff Kirsher wrote:
> From: Robert Beckett <bob.beckett@collabora.com>
> 
> To allow userland to enable or disable dropping packets when descriptor
> ring is exhausted, add RX_DROP_EN private flag.
> 
> This can be used in conjunction with flow control to mitigate packet storms
> (e.g. due to network loop or DoS) by forcing the network adapter to send
> pause frames whenever the ring is close to exhaustion.
> 
> By default this will maintain previous behaviour of enabling dropping of
> packets during ring buffer exhaustion.
> Some use cases prefer to not drop packets upon exhaustion, but instead
> use flow control to limit ingress rates and ensure no dropped packets.
> This is useful when the host CPU cannot keep up with packet delivery,
> but data delivery is more important than throughput via multiple queues.
> 
> Userland can set this flag to 0 via ethtool to disable packet dropping.
> 
> Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

How is this different than enabling/disabling flow control..

ethtool -a/-A
