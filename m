Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B06422C591
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 14:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgGXMwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 08:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgGXMwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 08:52:12 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2566AC0619D3;
        Fri, 24 Jul 2020 05:52:11 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id h7so8449588qkk.7;
        Fri, 24 Jul 2020 05:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Teu0IY9+kag10y3xlhpKe2JfJfn1g/v5RRbpbPo78dQ=;
        b=KgY8teAEVZzsHFR/JoiHDp8le3lFUyWuah4VFrZayprbWAE5JxuMUXa9hFM7J/Ofbc
         sEQVwd9tGIQ5nXdP7XhApcyoBXxZjladdehBwW1494qdWw+kU2m/ekkwO6vHhQXGZNWH
         GgL0Ogn+8b5nbp7v2+0OWFxMiQSAf6wVUoBXgy2bsB125qlUQmmjGM7Sc99izuuo9inc
         tsYaQYp41OtKCNvt7hO0XlhC3RZFbDntE0t5FG6Tclbg4ZeKr4mRVgD5sqjEHOIP2LhJ
         /Bc3w2+4/qAgb1PLYZT0Ll2JYDvXAqAs5RMNEm6pByWz3trnBJgNtIdpyH5tJBPw02Sp
         6uiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Teu0IY9+kag10y3xlhpKe2JfJfn1g/v5RRbpbPo78dQ=;
        b=eQ1+vtRDO9vNBA5rqW2FlPRAHbD17oZUOioDJAvm4arBH1s2zjDEn2aJmQ6ZVqZRUV
         Id6BjUckkzsBGukHt01xhzlwFbpmRokbBgKc9wkST5+U+hxExcSfti2G+fO0gksJZMkK
         LM3FmG+1bnKPrMD7W1aPUVufvOVDA3OJlGbC1lFG3TERqS6dTkve+7eiqz/yo7OtZWn/
         4mAtzxrMWrG+zS465b+2fg5id18M3N/YjAutb1mNL9AKxIH1YdV0pQZstrVeZDeS+0LY
         uH3j3Sb4bHM8u124utYF0b+dtJVTi/n4YmiMJHidTJG7ObMKLzdF6DV4Wzb83lsyTn0u
         649Q==
X-Gm-Message-State: AOAM5336RgCLrm8gpQm/T7UWqct5CDBiDisfvDqKknPF3GdRbGx2/NNf
        iNUtOsGLqZLdH8LxBxcLJ34=
X-Google-Smtp-Source: ABdhPJwnEdAt4NMHfb0+oSARbeSbCHv/EzGtK9jHBrNZHr1x7AgX3KtSGHIRB/Z7AlPWwVG8q6aUfg==
X-Received: by 2002:a37:a292:: with SMTP id l140mr9517324qke.79.1595595130211;
        Fri, 24 Jul 2020 05:52:10 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:a4f2:f184:dd41:1f10:d998])
        by smtp.gmail.com with ESMTPSA id a28sm6027093qko.45.2020.07.24.05.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 05:52:09 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id E07F7C0EB8; Fri, 24 Jul 2020 09:52:06 -0300 (-03)
Date:   Fri, 24 Jul 2020 09:52:06 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     nhorman@tuxdriver.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 net-next] sctp: fix slab-out-of-bounds in
 SCTP_DELAYED_SACK processing
Message-ID: <20200724125206.GC3399@localhost.localdomain>
References: <20200724064855.132552-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724064855.132552-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 08:48:55AM +0200, Christoph Hellwig wrote:
> This sockopt accepts two kinds of parameters, using struct
> sctp_sack_info and struct sctp_assoc_value. The mentioned commit didn't
> notice an implicit cast from the smaller (latter) struct to the bigger
> one (former) when copying the data from the user space, which now leads
> to an attempt to write beyond the buffer (because it assumes the storing
> buffer is bigger than the parameter itself).
> 
> Fix it by allocating a sctp_sack_info on stack and filling it out based
> on the small struct for the compat case.
> 
> Changelog stole from an earlier patch from Marcelo Ricardo Leitner.
> 
> Fixes: ebb25defdc17 ("sctp: pass a kernel pointer to sctp_setsockopt_delayed_ack")
> Reported-by: syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks Christoph.
