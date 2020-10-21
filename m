Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2577C29549A
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 23:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502411AbgJUV5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 17:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440229AbgJUV5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 17:57:19 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201DAC0613CE;
        Wed, 21 Oct 2020 14:57:18 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id k1so3944330ilc.10;
        Wed, 21 Oct 2020 14:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QtI0HwOtWjpFIvL5eV0Yl3dBEdU6zRsbNR+Lgk37mPM=;
        b=AeV2jQtfEdB0ZHhat6YR3CYY9KDq7FWG/rj3xwHY68GDAiRbviZ3HorbwXOfZ5mORS
         EsRqjDRhcyYSM9yiEer6vK+n0qkIetAVIdRfMSnpWeuSTXzBpvYIhvCC+Ujg4f1U0dcC
         Up+1qhA2hec8ziexdxgy9P1Bd9YeSXZEN50bNVj8DH6qmRogwVnBrE20nmQxxduwJ7n2
         wifqHnl409+LjmOQnzze4LgAOovB1Q9l5lSTDt+5SdrbCNL8TrEM+iNaXrtJg4lWbICo
         hMiVH7DTbPthjjnVTFKpuJORcjNm9jB6HZ9GKjssaltU5SphKtPpN2ujx9RdOxKUuqvo
         4Jag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QtI0HwOtWjpFIvL5eV0Yl3dBEdU6zRsbNR+Lgk37mPM=;
        b=NmAeDFIbuywaVSJ0lOhVWnHQ+kcA1mfYj8q/mz5lCnPmNZRsTawIX2khRSzpbo7oRb
         Ky57XevRD1iIzrFjgjYncNnnh8xON4Dl8LPqleX7QJlkItCHn64CpZmKKzspggBi04yw
         fqGlfaZlBimYQRClrgBeAlCS6P5g1IYbhnCSzNy4ndCAOWLo9aZnYMGW8nLd1UIEU9cO
         KSsm5Qapk+RUxESlavGXbWgQsUrvYslFCTtQSsRo18/StRQNV5q+1zZELjLwGMj1SENj
         6ChrOQCbuydE9lddzufn21wpg0tRwV2wHfYl53QzOXjlrWIh15B/8fvcpHSzZoKeDKDT
         Hfgg==
X-Gm-Message-State: AOAM531z7a/42XWMuLKuVDZU/FV6V0xfMGNjLtk4b9zW6Lj+oZd2c98f
        fPETHWPi4XvUS6RZd946ALB8AIhn8iQ=
X-Google-Smtp-Source: ABdhPJwaTiZMxmAm800B+m5PGgWslij4sRdLRP87OGmej+Ju8MPJxCjMj2yHTMvKnLIqYVelHxyixw==
X-Received: by 2002:a92:d441:: with SMTP id r1mr4091501ilm.164.1603317437377;
        Wed, 21 Oct 2020 14:57:17 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e8b3:f32:310b:8617])
        by smtp.googlemail.com with ESMTPSA id c2sm1810917ioc.29.2020.10.21.14.57.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2020 14:57:16 -0700 (PDT)
Subject: Re: [PATCH bpf v3 1/2] bpf_redirect_neigh: Support supplying the
 nexthop as a helper parameter
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160322915507.32199.17907734403861652183.stgit@toke.dk>
 <160322915615.32199.1187570224032024535.stgit@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <af1f92db-5862-4fca-9338-ba9054f1b0ae@gmail.com>
Date:   Wed, 21 Oct 2020 15:57:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <160322915615.32199.1187570224032024535.stgit@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/20 3:25 PM, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> Based on the discussion in [0], update the bpf_redirect_neigh() helper to
> accept an optional parameter specifying the nexthop information. This makes
> it possible to combine bpf_fib_lookup() and bpf_redirect_neigh() without
> incurring a duplicate FIB lookup - since the FIB lookup helper will return
> the nexthop information even if no neighbour is present, this can simply be
> passed on to bpf_redirect_neigh() if bpf_fib_lookup() returns
> BPF_FIB_LKUP_RET_NO_NEIGH.
> 
> [0] https://lore.kernel.org/bpf/393e17fc-d187-3a8d-2f0d-a627c7c63fca@iogearbox.net/
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  include/linux/filter.h         |    9 ++
>  include/uapi/linux/bpf.h       |   22 +++++-
>  net/core/filter.c              |  159 +++++++++++++++++++++++++---------------
>  scripts/bpf_helpers_doc.py     |    1 
>  tools/include/uapi/linux/bpf.h |   22 +++++-
>  5 files changed, 145 insertions(+), 68 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>
