Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD5DBA05E
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 05:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfIVDSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 23:18:47 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38338 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbfIVDSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 23:18:47 -0400
Received: by mail-pg1-f195.google.com with SMTP id x10so5981175pgi.5
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 20:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=TFGjXXhKmjkAZP/tz+ArFN/SlKTThcfB37x7Td165fE=;
        b=uOa4XPmdMjEBXva+d+0v4ob182ddJrJVWcfSYiJ5oEr8CoojhpLY7lXAnOJWa4EnsL
         i7c/lJ6mWxzeZpsy/xLNKdUE5EQVOCiyo1Ues8Xri59h6IG+JRkjWTvQmKGQu3330slX
         EgZOraN56Jy75t2xbGqzfhpb+P3rlqUN+7HeBKnoUgTAwqRd77KhNgEm8Cwb7Dx11bDt
         n5HZhsporrJrpDiLqE0xb7N4x4AAVC3tGEzt5IE1NQVIiynG7m1ykH+4IVTYKIb1jiCr
         wytUqzTtWv8dqAoyq2nb4VNl9e3Tte4g/96gnMJp8PsCUuATXg71q+Z44waoulitkZO4
         DHmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=TFGjXXhKmjkAZP/tz+ArFN/SlKTThcfB37x7Td165fE=;
        b=rRMH4Ukmra4eqZZI5KUkjis6Y8FEPB28BKxn6VxErOS4lry1R4k/bfXDGGgH3wgMff
         gzSu5KsZJd1+Uz3lLq8GCFfYCz6VDfKkcDZ3Nrqko0fjhqnrrvGyMG01ZgNGgb/9ciC2
         GS//VVAixBfXcMtvyaZGFkICcXXfeVrlhR5Qe0zvXq4Q4i2PsGjTUiaYQa2Ljnb7jcBl
         KVz20xvfNEh9rMducs+pgyR/0XdHTp3MltCCULeSHtoY+Cs4FyYRti6ZoXCHBUdrXlfm
         Pqvg03kk7KSgfOhch1rkbanqU3PWzdzR1OcMgkoX9DQ2Lr5x4+J3rOykKfJ0vGlxA8pU
         e0wQ==
X-Gm-Message-State: APjAAAWfl7Cw3k1+MALoZeIR8JO9tF+0tbRnnAkfq2iwh9ZIjIe0oQUU
        za2bakgRLZlVckwWScsPo+J9hQ==
X-Google-Smtp-Source: APXvYqxbBIkVgVFuicYvZV3pC7tph8zkTryWFhQebJpOhb1a4nS5KNsvCOsm8J3i//GSjmtAcRsV3g==
X-Received: by 2002:a65:6716:: with SMTP id u22mr22794378pgf.192.1569122326740;
        Sat, 21 Sep 2019 20:18:46 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id o9sm10479549pfp.67.2019.09.21.20.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2019 20:18:46 -0700 (PDT)
Date:   Sat, 21 Sep 2019 20:18:43 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] qede: qede_fp: simplify a bit 'qede_rx_build_skb()'
Message-ID: <20190921201843.12d21abf@cakuba.netronome.com>
In-Reply-To: <20190920045656.3725-1-christophe.jaillet@wanadoo.fr>
References: <20190920045656.3725-1-christophe.jaillet@wanadoo.fr>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Sep 2019 06:56:56 +0200, Christophe JAILLET wrote:
> Use 'skb_put_data()' instead of rewritting it.
> This improves readability.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied, thank you.
