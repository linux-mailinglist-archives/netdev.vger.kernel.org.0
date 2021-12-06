Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA65C468F8C
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 04:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235672AbhLFDNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 22:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235402AbhLFDNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 22:13:46 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A27C0613F8;
        Sun,  5 Dec 2021 19:10:18 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id a11so8875431ilj.6;
        Sun, 05 Dec 2021 19:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=TNk6I9zLVo4gBztAVUSoSqQRaZNVXPRbm1cPrqzCNcE=;
        b=gKS7Me2zyUxCEkLoxN6L2OTjrROWV7bgDsI31yFmdOCjHKxKUSXLCq6PzVsZg3PtL7
         k6IR23E8GlptIQ1vx+TGeqWB9xfcQHsu0a/MA/zgq4KS+rLzSCgXRJW1UWnBu6otWKNX
         RsBP8r7W+csqGHxj4LCw5uekg0/Q88LMkUD/okB9U8tFo92m4PhQ0ezDF/pYtDKcK+Fy
         UPzvVQBhS6WejBkXyAj+cSkhBjtH/KeHPCRlAEu/3NihlfV/u1WZyzj8JsNfcOA3nLxB
         aTwxmD/UIaxgffoX3ViY4q+C2uQ41IIlONSx6TLWv+nds8o0uqVCUlkKr5c7OQg9LJCd
         3o3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=TNk6I9zLVo4gBztAVUSoSqQRaZNVXPRbm1cPrqzCNcE=;
        b=FEpNzWlZJPqKpiMXfN2pmjXSwqPAnfsawNyP4Gojtn7jqrKJ+eFGWVvPqpc1anne8Y
         xV3TbCjdJKnTFsjLixOwOTHl7HAw4XLxbi9GBRudX/69pF5KXTPSXZ4qKf+ZHfg6S4iG
         awQJFpKGQ8nJN6Ky0ZwJ09mYLeqrcUFArCoaUjZTGyvxO5SXrVTuQ9oXYbXcr3ZBpBeZ
         2Om4G3iA1LYnmpGj+lm9fWYTkCF4pkiN65oTvKuLnaFsCubaSPKGaozeScB0xlcVq55k
         WP4Gmj11Co3o8k90bQ/ut/lKjhWTXODwBiX6G5Hfkc9guLO6sPCEKH8XxyCJ6o3ei+x7
         SOMw==
X-Gm-Message-State: AOAM532tNEx/ZZvjrY1WBjqwesMBuu7gwwkqoAN3rwzR3nAS2vhKR9jZ
        geM1dXjSdPyvtV6kUWjlKn0biKQ6dl9fRQ==
X-Google-Smtp-Source: ABdhPJxJ4h7D57ryc6e7j/o7CyWHEoaaAa5JG3uSqutercEV2sAD29B/yD74Qe86lqLa0B55499QIw==
X-Received: by 2002:a05:6e02:1845:: with SMTP id b5mr29467386ilv.266.1638760217763;
        Sun, 05 Dec 2021 19:10:17 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id w2sm6854034ilv.31.2021.12.05.19.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 19:10:17 -0800 (PST)
Date:   Sun, 05 Dec 2021 19:10:09 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <61ad7f11ecefd_444e2085d@john.notmuch>
In-Reply-To: <910d9f4270cea155f6283a99b697f89cbc39009f.1638272238.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <910d9f4270cea155f6283a99b697f89cbc39009f.1638272238.git.lorenzo@kernel.org>
Subject: RE: [PATCH v19 bpf-next 09/23] bpf: introduce BPF_F_XDP_MB flag in
 prog_flags loading the ebpf program
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Introduce BPF_F_XDP_MB and the related field in bpf_prog_aux in order to
> notify the driver the loaded program support xdp multi-buffer.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Sounds like a good plan to me.

Acked-by: John Fastabend <john.fastabend@gmail.com>
