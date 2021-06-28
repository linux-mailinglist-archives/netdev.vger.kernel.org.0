Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404833B6717
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 18:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhF1Q4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 12:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbhF1Q4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 12:56:31 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF0BC061760;
        Mon, 28 Jun 2021 09:54:05 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y13so9265023plc.8;
        Mon, 28 Jun 2021 09:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tmxl8eIEOqRAiLGy7zngSLbmcyScWo7pKD8rcoN8hGo=;
        b=kT4H/2hw3tI/lAL796sbzQNk6AXJQgTHVsML+xKEVthO1mmWTmKGmrpSgacUt594tR
         tcM6XBrR/uoFXSp8W+exvviSc9V/BwJL9m20/Fg2HYF9u0/hOsdLvoG2z84oKm67NNna
         H/S094TaZJseaWyvsy+97FSX1+sKV0NMqeSgzyZZAN8tEu9GgzMdBcqd2u8JhjNt2asL
         meHLRWuDFlGS5nZuIq+U6riZhKrrdVSRqZH+4UP273VRRG2LZXgRwGkZqa8kENJGI0kE
         QnzRrFTeVUiJb1mNdYwNJ5/cFjOWfaco80J+kMSKKulyhsUBFm8gOcPnpbMxq+BA+79X
         CGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tmxl8eIEOqRAiLGy7zngSLbmcyScWo7pKD8rcoN8hGo=;
        b=cfK/CBzi8WcEb/orZOEWjKFVrwYWCp9a8K6xmyCYjcGYWFRn+visSpfI5yesVtgXtP
         fBhm+MN7dQVJlHO1ORuvoDKybpAScLVkQ5mlDoWz29fGpXTonJtIteyE0VcJFb4NrKY9
         nArtfQfAd7O5ENvrgo29/lgwAwjjabJuX/YIuSANhh3aGgOGUGAKYkpA7W+fx7WaaiHP
         I7CcNQeugldAaxQt+KFR5eWbhloOfoNIqriMRYmUfh9sIjSakt19+GbxPffqsIuW3FRl
         lg2eeZ/cnwBEY1+SqUg2rqjTYc9ntoabAAQGOEnD2lB+bgr9UHOMpordTTkvhndxNec0
         a8Cw==
X-Gm-Message-State: AOAM5319gObiSqakSOb6G9rYmmZb+VasGgphZB4bI8nuPHfTrp+vl/dB
        h/ZCLg5PEcOf6iZwk9r6RQUjNmwVjlKwqQ==
X-Google-Smtp-Source: ABdhPJwkPFh9x93+LTqrRPX1N5AF48M5F+/d5ZMRZI/Ej8+hpn4NEacRKbSS52G+kk5G9Hg6o21onQ==
X-Received: by 2002:a17:902:f282:b029:124:701f:2fe7 with SMTP id k2-20020a170902f282b0290124701f2fe7mr23306535plc.10.1624899244577;
        Mon, 28 Jun 2021 09:54:04 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f016:ff7f:d8af:5617:5a5c:1405])
        by smtp.gmail.com with ESMTPSA id u20sm15019012pfn.189.2021.06.28.09.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 09:54:04 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id DEB7FC08CB; Mon, 28 Jun 2021 13:54:01 -0300 (-03)
Date:   Mon, 28 Jun 2021 13:54:01 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org,
        David Laight <david.laight@aculab.com>
Subject: Re: [PATCHv2 net-next 0/2] sctp: make the PLPMTUD probe more
 effective and efficient
Message-ID: <YNn+qbI8gXLP7us/@horizon.localdomain>
References: <cover.1624675179.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1624675179.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 10:40:53PM -0400, Xin Long wrote:
> As David Laight noticed, it currently takes quite some time to find
> the optimal pmtu in the Search state, and also lacks the black hole
> detection in the Search Complete state. This patchset is to address
> them to mke the PLPMTUD probe more effective and efficient.
> 
> v1->v2:
>   - see Patch 1/2.
> 
> Xin Long (2):
>   sctp: do black hole detection in search complete state
>   sctp: send the next probe immediately once the last one is acked

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
