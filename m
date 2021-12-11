Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EF2470F47
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 01:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345391AbhLKAPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 19:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244259AbhLKAPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 19:15:05 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4631C061714;
        Fri, 10 Dec 2021 16:11:29 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso11235398otf.12;
        Fri, 10 Dec 2021 16:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=MQhuChz26lNCiQV4ejYtcR+pGZiwho3ig31rvDCyTeE=;
        b=EXOV4lihcnTt05vXpP1i+F3At+Vars4oZsssrCYBAyisQV2n3/u4qqZDbOhuT3PJGu
         zOvXZI1aEIFZU0IKUJ2/oPpndvOE9e8+H2fOGNIzxW966u2rxqXqzong1x7MRM12dWE0
         KOZxYwwOhhxB9IAaZNpOGoNqQbKWLg/y3BH5ZB6SEisYE/5/ZuIcNfCMbTxaey5SA4Oa
         ii+0K0DlKFbFmjoI93O9cbCuB2xYGSE5Yj97aT1E/kds+cATZTPdOYkt1o8yWZvak1e5
         q9OxB/lM4gNlM4HmrKpOFNCT9MpadMks+WrSOhguoCO91mv6HlKYkLJOSFW24vZ7UYJX
         KD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=MQhuChz26lNCiQV4ejYtcR+pGZiwho3ig31rvDCyTeE=;
        b=P05rDEjMMX2AHXWShHf7w7PvFlSYVTNEpLj4Mk4ybHn9ls0J8DQyglsObRvzXknDQI
         +2vUlRLbdViXQ1EgPGrjgnyNTEmZ1Nu7t4UhW4G63OC8M+8a+sYTePIvOXEszwOzlUt1
         geW8QqAgQg7kMICEjkX07U0K1JqX1WgfxdAkpQit2jnYkRaXvDSC372Y7RwfTDVPWBlj
         TJ5paCE9lSyaRgX5XUpJFWviLNWhznutCTWChkJ4Epr6v0SZsq/7x7B2C/E4KVv8Ao6n
         TbaJjetvSBaa2ITEvlclijyVp6o3z4bP8WOsxordEMXxulTw5h3JZ5zqXKqZ+ZWR+scC
         ISWg==
X-Gm-Message-State: AOAM532Yk+Ua2lIdipSnMNIWsWJITOm7yWxhdaqf6Hr1YwmkhwCbtK46
        lAG/57xHGvhki917gLu8SRg38j1sdvz3uw==
X-Google-Smtp-Source: ABdhPJznPGtDPdqyJanzGEIhR2eAH69BqqYAmSMOFU7pH4NSRbpdPtQ+NM4Jf68cvPoVfHMq6Kqjgw==
X-Received: by 2002:a9d:7459:: with SMTP id p25mr13288474otk.247.1639181489066;
        Fri, 10 Dec 2021 16:11:29 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id l23sm814228oti.16.2021.12.10.16.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 16:11:28 -0800 (PST)
Date:   Fri, 10 Dec 2021 16:11:19 -0800
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
Message-ID: <61b3eca7ab55d_2c4032085a@john.notmuch>
In-Reply-To: <87de8c17d783b1175c316ffc4d02cb485dde273e.1639162845.git.lorenzo@kernel.org>
References: <cover.1639162845.git.lorenzo@kernel.org>
 <87de8c17d783b1175c316ffc4d02cb485dde273e.1639162845.git.lorenzo@kernel.org>
Subject: RE: [PATCH v20 bpf-next 12/23] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> From: Eelco Chaudron <echaudro@redhat.com>
> 
> This change adds support for tail growing and shrinking for XDP multi-buff.
> 
> When called on a multi-buffer packet with a grow request, it will work
> on the last fragment of the packet. So the maximum grow size is the
> last fragments tailroom, i.e. no new buffer will be allocated.
> A XDP mb capable driver is expected to set frag_size in xdp_rxq_info data
> structure to notify the XDP core the fragment size. frag_size set to 0 is
> interpreted by the XDP core as tail growing is not allowed.
> Introduce __xdp_rxq_info_reg utility routine to initialize frag_size field.
> 
> When shrinking, it will work from the last fragment, all the way down to
> the base buffer depending on the shrinking size. It's important to mention
> that once you shrink down the fragment(s) are freed, so you can not grow
> again to the original size.
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
>  drivers/net/ethernet/marvell/mvneta.c |  3 +-
>  include/net/xdp.h                     | 16 ++++++-
>  net/core/filter.c                     | 65 +++++++++++++++++++++++++++
>  net/core/xdp.c                        | 12 ++---
>  4 files changed, 88 insertions(+), 8 deletions(-)
> 

LGTM

Acked-by: John Fastabend <john.fastabend@gmail.com>
