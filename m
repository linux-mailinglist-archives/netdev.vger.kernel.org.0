Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CC1326E5F
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 18:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhB0RU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 12:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbhB0RRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 12:17:30 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD30C061756
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 09:16:48 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id d5so10947388iln.6
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 09:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=gijZebkUadDk/rrUFgSEjO0CurEj4Iocej5zN8XOth4=;
        b=Q2H405szbD1wMlX9fbtzlFPL8j/LZIGv6ZRnEcJwr1lVFMGBHhUdfvIchpU7l88aPT
         XwbWK08LifMP9qeph4EYWSklMGNtG2fezLht76/4crYYkE5yHAszGeGHzh1+PAl1nB0m
         xO/OZhHcuxR12s4+pl6RmYL2hdTth+CqFL4tFco0kird+C4wCh8nazDWkSs9Nb2f1lKu
         aV2Dc9aVhOUTILLOZk7PtTnlQJpRWPXPoSbTzsx4SdPdFI0D9MBUcdOgdiDh/EnHZxMF
         HSDvjqamNR/5oa4SNOJnOlRgBeTEizA2TsTMexWJfCDQOIW3MTSFzmGi5Mp6SHWltlgE
         n/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=gijZebkUadDk/rrUFgSEjO0CurEj4Iocej5zN8XOth4=;
        b=QlqY8pyVzv9djzRmWAHYfu52vTLuymBUJieKVa3t0q9lTBJuAuc1iUTzJVmNHGYn6u
         Oxbep7fmxzZFUNNuphlaRO4NPalVp4lUUhfT3juiIOJAKXRstCfE1eUsgMtVs5MEdJV5
         rCix22rm9Ra6mJajI6e2uuT5Jkdr1zbjOYSZxfabPEe0gt1hxGDWo+5kusqj7150ytg3
         Y7muzxpS+AC67b6Uf+Q3z/2Tg6vaMHylovCw4kmkYe2tDCdnAlFmUfkuB8MW9hHVmwMK
         8OrQHLtLzspRH9IO6J2TA28IQGs8y4Va6L1d8eJGxhiA6JhGrmT+umqajutawwLuMFfP
         q2cg==
X-Gm-Message-State: AOAM530K0tmOMFF0Aw2TIg5QnmpJBprjCLBoqO2QxE91hYTvePk4YjF3
        aD6VBeOeeW1/Slik3fQFJXw=
X-Google-Smtp-Source: ABdhPJy6ADLOTSkTdZwo88RtK1xUDBmrQ6BKCjOyAB8/xoU+/rkRzq2g/kvciSkiX+RKse6ppy7pIA==
X-Received: by 2002:a92:d0c3:: with SMTP id y3mr6927881ila.303.1614446207716;
        Sat, 27 Feb 2021 09:16:47 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id s7sm1977635ioj.16.2021.02.27.09.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Feb 2021 09:16:47 -0800 (PST)
Date:   Sat, 27 Feb 2021 09:16:38 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>
Message-ID: <603a7e767e1a8_25e5d20864@john-XPS-13-9370.notmuch>
In-Reply-To: <CA+FuTSdn3zbynYOvuhLxZ02mmcDoRWQ5vUmBCbAgxeTa2X33YQ@mail.gmail.com>
References: <20210226212248.8300-1-daniel@iogearbox.net>
 <CA+FuTSdn3zbynYOvuhLxZ02mmcDoRWQ5vUmBCbAgxeTa2X33YQ@mail.gmail.com>
Subject: Re: [PATCH net] net: Fix gro aggregation for udp encaps with zero
 csum
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn wrote:
> On Fri, Feb 26, 2021 at 4:23 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > We noticed a GRO issue for UDP-based encaps such as vxlan/geneve when the
> > csum for the UDP header itself is 0. In that case, GRO aggregation does
> > not take place on the phys dev, but instead is deferred to the vxlan/geneve
> > driver (see trace below).
> >
> > The reason is essentially that GRO aggregation bails out in udp_gro_receive()
> > for such case when drivers marked the skb with CHECKSUM_UNNECESSARY (ice, i40e,
> > others) where for non-zero csums 2abb7cdc0dc8 ("udp: Add support for doing
> > checksum unnecessary conversion") promotes those skbs to CHECKSUM_COMPLETE
> > and napi context has csum_valid set. This is however not the case for zero
> > UDP csum (here: csum_cnt is still 0 and csum_valid continues to be false).
> >
> > At the same time 57c67ff4bd92 ("udp: additional GRO support") added matches
> > on !uh->check ^ !uh2->check as part to determine candidates for aggregation,
> > so it certainly is expected to handle zero csums in udp_gro_receive(). The
> > purpose of the check added via 662880f44203 ("net: Allow GRO to use and set
> > levels of checksum unnecessary") seems to catch bad csum and stop aggregation
> > right away.
> >
> > One way to fix aggregation in the zero case is to only perform the !csum_valid
> > check in udp_gro_receive() if uh->check is infact non-zero.
> >

[...]

> We cannot do checksum conversion with zero field, but that does not
> have to limit coalescing.
> 
> CHECKSUM_COMPLETE with a checksum validated by
> skb_gro_checksum_validate_zero_check implies csum_valid.
> 
> So the test
> 
> >             (skb->ip_summed != CHECKSUM_PARTIAL &&
> >              NAPI_GRO_CB(skb)->csum_cnt == 0 &&
> >              !NAPI_GRO_CB(skb)->csum_valid) ||
> 
> Basically matches
> 
> - CHECKSUM_NONE
> - CHECKSUM_UNNECESSARY which has already used up its valid state on a
> prior header
> - CHECKSUM_COMPLETE with bad checksum.
> 
> This change just refines to not drop for in the first two cases on a
> zero checksum field.

+1

> 
> Making this explicit in case anyone sees holes in the logic. Else,
> 
> Acked-by: Willem de Bruijn <willemb@google.com>

LGTM,

Acked-by: John Fastabend <john.fastabend@gmail.com>
