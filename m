Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7086F23B211
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgHDBBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHDBBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:01:53 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E39BC06174A;
        Mon,  3 Aug 2020 18:01:53 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id f68so10891489ilh.12;
        Mon, 03 Aug 2020 18:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=1/GTRGlv3vA8y7chSWtD+31u5r99BV3UFVtnhE5MkUk=;
        b=hjBDCquzhtTvEgqmVITzwTgSQVeVX9QfEcNZUTyWtbuN3/DC/42rzpkRqGDOlFG5zp
         e1cDoxZOofqGEp8Uu9kF4M8enqU2GNtPHxk5BdaLdtKdCQ1KI6CQiM62ZOUAFI5apgxQ
         llAZ6lM6ASVhqdJRFLxut6ZNpt+3C9Wepzn0/pu59rXcZGrzJLQw/1trD7Hvpc5zeJkp
         o0RiHTLl54aXCPXsEtPtMevZrNm04HW9ny8wa1MeYzSpt/Uj+QqPV1M7p/VxBB/m+xeD
         wUXvtm/Jj3oif7giCsiGGhTobntI4u7Vv9O1rHpGBJw9Bx0UUKLxSzgQ87jaZgV/Eyqk
         uYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=1/GTRGlv3vA8y7chSWtD+31u5r99BV3UFVtnhE5MkUk=;
        b=XrCL0JcG/k9J+TVfS9AvmZ0ytdRAuQlFQ/tu35x2d5319G/lDfp9TbTXP32iG+OSIc
         zo2+BJTV4B4VNPU0R3icKNM2+Zw0r1aGWKiCZEphTdM7IYxSo0h3gm8WXCqJswcXX7wl
         DNDGICKXmqSBGLtXCkX4EUyTtGGpSWUzucqXswi0K+251hvJl4TmgmsjMvU+WDDaly4M
         WauCzFCj8xj1M36gFz2EjnakLq61UVMj1BQYsrQjnq4eoOrR0N5/VEyXhKBS1a+PPcD3
         CosdWWQwZExDilrmc+828MfHA7sXoJIcTaNrcMfU60zbm9m+EU55GRCAk0bsdkVZ2pd0
         Yzhw==
X-Gm-Message-State: AOAM533BLYcS2sQv8MNTJ6RRg1unFYfxQskFPc7yjFTptRnHcw59SApI
        kRQffE2ISl1HSljZR13eDQo=
X-Google-Smtp-Source: ABdhPJyPSlzfXEbeVvF99fPft1MP8PvgVICogCUfRvj2CDhRx4PHP5gUIWnosZggh5XKDoCA9ofWig==
X-Received: by 2002:a05:6e02:e82:: with SMTP id t2mr2245752ilj.161.1596502913016;
        Mon, 03 Aug 2020 18:01:53 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w7sm11808577iov.1.2020.08.03.18.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 18:01:52 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:01:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, kernel-team@fb.com,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>
Message-ID: <5f28b37a23387_62272b02d7c945b4c7@john-XPS-13-9370.notmuch>
In-Reply-To: <20200803231033.2682401-1-kafai@fb.com>
References: <20200803231013.2681560-1-kafai@fb.com>
 <20200803231033.2682401-1-kafai@fb.com>
Subject: RE: [RFC PATCH v4 bpf-next 03/12] tcp: bpf: Add TCP_BPF_RTO_MIN for
 bpf_setsockopt
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau wrote:
> This patch adds bpf_setsockopt(TCP_BPF_RTO_MIN) to allow bpf prog
> to set the min rto of a connection.  It could be used together
> with the earlier patch which has added bpf_setsockopt(TCP_BPF_DELACK_MAX).
> 
> A later selftest patch will communicate the max delay ack in a
> bpf tcp header option and then the receiving side can use
> bpf_setsockopt(TCP_BPF_RTO_MIN) to set a shorter rto.
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: John Fastabend <john.fastabend@gmail.com>
