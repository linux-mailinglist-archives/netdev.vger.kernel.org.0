Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CBC22839C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 17:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgGUPWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 11:22:24 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38292 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgGUPWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 11:22:24 -0400
Received: by mail-wr1-f68.google.com with SMTP id a14so6751561wra.5;
        Tue, 21 Jul 2020 08:22:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=duJ2HBhio/BkAyiZCAkWbkTUg4rjmwr+3L6EYBWx3/g=;
        b=GOcMiiDPMp52fhoN2T9EH0DL81eoeamGtI/kisf0QKbuFL5pIgXINcfHXzwc5q5xcp
         O9Gv962HWVVWKVt55voGXYL+CBMtgadtLwJKDurzM/m7tXpp4lnKkGicFO7gKuQg1Fvj
         O5/uNg6eECMop6nM4EtQjKDPvLBcc6+YAKbuk3mlQJlzQqB3V7tp1yUUbCm+JrX5JWC4
         JWd+8TTzQRJf+pRuxuisgq0TKrV3mhJkEbUTkyzC1Cb5dWxYSdYCtNFdaqMRMPGFStYR
         IJzIMGBvGQESI5f/wEpcSP2D2PKjF1Dpzn2EoZOHm0BPiebGce+thXk1AafB2EtUfz1h
         ydoQ==
X-Gm-Message-State: AOAM530183MXGlZ88vJRhUVbp6ZcpERxjYfGfk44AQ1+7cqxD/i7xmGf
        6+5C6zJzaZAXQoLzAqrecoY=
X-Google-Smtp-Source: ABdhPJz/1xAiJ9wZTaqakzlijULHHXKAbAgEhVJRgxG7DXGUCbLqBvTyMCdI0jGdy3XiUAvxfI8cTg==
X-Received: by 2002:a5d:6681:: with SMTP id l1mr13710248wru.47.1595344941801;
        Tue, 21 Jul 2020 08:22:21 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id 207sm4276409wme.13.2020.07.21.08.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 08:22:20 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:22:18 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: [RFC 01/11] Drivers: hv: vmbus: Always use HV_HYP_PAGE_SIZE for
 gpadl
Message-ID: <20200721152218.ozpk2b4ymfdocu4p@liuwe-devbox-debian-v2>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
 <20200721014135.84140-2-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721014135.84140-2-boqun.feng@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 09:41:25AM +0800, Boqun Feng wrote:
> Since the hypervisor always uses 4K as its page size, the size of PFNs
> used for gpadl should be HV_HYP_PAGE_SIZE rather than PAGE_SIZE, so
> adjust this accordingly as the preparation for supporting 16K/64K page
> size guests.

It may be worth calling out there is no change on x86 because
HV_HYP_PAGE_SHIFT and PAGE_SHIFT are of the same value there.

Wei.
