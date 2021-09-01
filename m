Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28ED53FD03A
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243237AbhIAAN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243219AbhIAAN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:13:28 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0B6C061575;
        Tue, 31 Aug 2021 17:12:32 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id x5so1571990ill.3;
        Tue, 31 Aug 2021 17:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=yzZpimZfjBgdwB+LxIZkkgrzCrMD/Qcp5j5rrYEeQ5E=;
        b=gXXkZlH9RdszMVzbTnFFXwogF1ogb2Q1f6NNDCbNosRjOX3epD8zPzbMVzfvTzrjpc
         cNbGq8/Oy7+3oItePzLPGYCkxebed/1Dm+J8gVFFUDUmr2PMFI7HmSax/FB8sBXYFyMM
         pIV3IBeAJmTLxXfAcFo0iQTfiXOzdbvERfYmQy5qjBQJsFoyZrw8PZ6UhFARukhWEPc0
         4LXm2B1U4mqUxQx/hGGP4aWjuRQnTdPZ5p0wFoc9qZfx/6j6ore456gDId+7B5+yKjB4
         CajHMU0is+dtuLd47qGUSt1nupxVqi5KGAcafqlzz+JZ1N4p1puu8Gi9vzG+h06QkUiF
         niDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=yzZpimZfjBgdwB+LxIZkkgrzCrMD/Qcp5j5rrYEeQ5E=;
        b=YmMA0qtfg3718KPLxHQB+R3Ehh/MBi2gKIyycm5pPeCYCbALdiE/d4bxabDayr5uSx
         X6IY63gmHUbtSFLGwRZy2ao+Lz34pD3+Ey0pSgCwqHNJl4m67vK+RWb1mAIaPOLB79Dy
         BIRadiIrGXl9/CG5dCQt7ixdMZulVVZxoUFZH5KscCr/gJcI+jdKeJhQ1eIWeU94OQAP
         Nw9b+ksbPSQ2YpmqS9ALj42L31Ej4L/niH5IuwgRpXz8BX2N+X25e6NGHqp8eotFLwyu
         P+lt1BNf0doH2Vj6ntVgq7APq/lRFlimtEm8cO9/7CWE1NVVwLYDaf7mhVxxlqwkUs6G
         jCwQ==
X-Gm-Message-State: AOAM532GVrAiZwqQ2YTRWuwXd4gCEl/unpraHlWAgQAI0kbsGsJmShNK
        88841KSX5c4UiTx/bms9ry0=
X-Google-Smtp-Source: ABdhPJw2eV5H/UXaqOhNhKW+6ToqREWtHb8by8aWHN9Pf9s4KixFcNA9KpRKIhk1jo7MU9A832VzrQ==
X-Received: by 2002:a05:6e02:1054:: with SMTP id p20mr22163173ilj.159.1630455151773;
        Tue, 31 Aug 2021 17:12:31 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id r18sm10962848ilo.38.2021.08.31.17.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 17:12:31 -0700 (PDT)
Date:   Tue, 31 Aug 2021 17:12:24 -0700
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
Message-ID: <612ec5681c87a_6b872088@john-XPS-13-9370.notmuch>
In-Reply-To: <330aa5c8bb21dc5967ef3a1eec300f71077c589c.1629473234.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
 <330aa5c8bb21dc5967ef3a1eec300f71077c589c.1629473234.git.lorenzo@kernel.org>
Subject: RE: [PATCH v12 bpf-next 11/18] bpf: introduce bpf_xdp_get_buff_len
 helper
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Introduce bpf_xdp_get_buff_len helper in order to return the xdp buffer
> total size (linear and paged area)
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
