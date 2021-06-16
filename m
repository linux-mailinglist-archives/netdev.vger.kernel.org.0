Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503443AA7A0
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 01:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbhFPXpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 19:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbhFPXpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 19:45:13 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4ADC061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 16:43:05 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id f10so1076962iok.6
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 16:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=4LU80oMEiWGdL7h3hxPHgBx1jGQmejRdGmgCBlERjqI=;
        b=Qz4PogTpyWF4qSeykyyhbgCCi/Fc/OI1d9iGgMfz3epvfKEYnsaQQNeH17d18Adrrr
         6sfU1Pds8ZCXVY177aLywULZ9DZQ3ogI8c3UaGS3cO6WwiWc3ivgFAdN2sE4dakWlva6
         bYGv1Zmv0jmkMdnJj71kGd8LQn75E9A2+/CyA1S6heNc38B726gQ/X54rq1C59/Qp/HG
         ehWLL6oUmgL7EAflnfODZake0Zow0/A6DCccTJHT56JPk3z2h0KEyRq2Z6U27VjOKNnf
         Lt+XH4woQhSG8dM9CBOWVUA+CLlz2o0cl3KwKL1OdwhiaXt7nUrwePQTDZmWt5vhm/yD
         g2uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=4LU80oMEiWGdL7h3hxPHgBx1jGQmejRdGmgCBlERjqI=;
        b=En6lPyEzjJyTKBh458Jo9iTwLmOAKupE4nk/ExyprSc1wJVWbbEqCu8/kuvlJ20qpr
         6NAviiMelvr68MmdaOPFdx2KVTkjoo6mhfPUbVNP4kx4YzFgvOxl00Z6SATf0qmI+MSu
         +GE+T+LLuBoMvoiaprZoCjckvzCnc0ugRzulNUxUzKV2v9HOhnivm4SHqLFqVdWF4SYD
         fz7gMnFiNWsuSYjnzxUTvEd/NfldddPnhe9jrGBWCeUHkk74rhcCnaXzUsRDCaiDQ5gG
         zIJ+qcMSPrs1lx79u42lN32n7LlOagRwK76miUD0lVLrwCHPClBhyuHJvRpL/JCryg0w
         F4/A==
X-Gm-Message-State: AOAM531Dkhc5oA1kmh0Mm3I7O2NPxWzWveaqIN3BFBug1tJmLw9mmGP4
        Saq1iokVe3IyfX8yfFhCc0Q=
X-Google-Smtp-Source: ABdhPJx0oewxSkAXbSBUfumwPtlaLgVEptgKQSacdnLvdoLBdqLUYj8jsdDoz08maxBuY5RZU/m2BA==
X-Received: by 2002:a02:3318:: with SMTP id c24mr1655649jae.112.1623886985327;
        Wed, 16 Jun 2021 16:43:05 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id r14sm2100320iod.41.2021.06.16.16.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 16:43:04 -0700 (PDT)
Date:   Wed, 16 Jun 2021 16:42:57 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        maciej.fijalkowski@intel.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        netdev@vger.kernel.org
Message-ID: <60ca8c81708a9_26dfd2081e@john-XPS-13-9370.notmuch>
In-Reply-To: <162388411986.151936.3914295553899556046.stgit@john-XPS-13-9370>
References: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
 <162388411986.151936.3914295553899556046.stgit@john-XPS-13-9370>
Subject: RE: [PATCH bpf v2 2/4] bpf: map_poke_descriptor is being called with
 an unstable poke_tab[]
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> When populating poke_tab[] of a subprog we call map_poke_track() after
> doing bpf_jit_add_poke_descriptor(). But, bpf_jit_add_poke_descriptor()
> may, likely will, realloc the poke_tab[] structure and free the old
> one. So that prog->aux->poke_tab is not stable. However, the aux pointer
> is referenced from bpf_array_aux and poke_tab[] is used to 'track'
> prog<->map link. This way when progs are released the entry in the
> map is dropped and vice versa when the map is released we don't drop
> it too soon if a prog is in the process of calling it.
> 
> I wasn't able to trigger any errors here, for example having map_poke_run
> run with a poke_tab[] pointer that was free'd from
> bpf_jit_add_poke_descriptor(), but it looks possible and at very least
> is very fragile.
> 
> This patch moves poke_track call out of loop that is calling add_poke
> so that we only ever add stable aux->poke_tab pointers to the map's
> bpf_array_aux struct. Further, we need this in the next patch to fix
> a real bug where progs are not 'untracked'.
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Needs a fixes tag,

Fixes: a748c6975dea3 ("bpf: propagate poke descriptors to subprograms")
