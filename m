Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A688837E8
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732863AbfHFRbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:31:04 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42935 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729161AbfHFRbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:31:04 -0400
Received: by mail-qt1-f196.google.com with SMTP id h18so85393590qtm.9
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 10:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=jOF8HX7d3k1WX7dM1V9b8nyJlK40/ytZ9jNB9hmM9SA=;
        b=nQeImNQS/VMoOULddOgvO2gUqY92iC5CO3d+w6pi+0qtLRcFm1eXSgkuGvR7csDVMz
         S3a3kmBuRrpjSU+jKxgkpkhbQDWKt2Nsq9rnKIgxEnZeiCTC8ri/0NTgRPK8h0VDmSwN
         7an0UkF2/FatzfjzqPdaSHfozAUBfoBTZB1J8Q7Mgwb7/JIHdQnAr8RL0N85GMeZlbg8
         /rdMvJ5RICSWA2PiZolsxXISRyjGEmHrdBcbIidIC8CKRV/9WlUU4cNXnltNv3+NTkuO
         JQy85Sal00pbreUYzZHZMl+U2UiHTA6wP2KL/08ArrsT/6JUD2rkTvvDEl7ir+HhGf3Y
         zx1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=jOF8HX7d3k1WX7dM1V9b8nyJlK40/ytZ9jNB9hmM9SA=;
        b=DkiT+Id5qDazrY/8/rJw9/WBudvdcXT67lVgM1f5SzwZ+HhD/Yb9502MVj1p20LjWD
         1bdU99TTeKL4zeFpkWKeMgLg3kT6rSTEWikcFfl+/ayYSfZUSH2tuoNtOnLGB60D0k0i
         T9/gEeJSUvS7RXhOHtgSgfi41m+93vOPISy01kCQfJMzuXW89THtRBbdCnGozRBmZpRv
         /PyasWGRf8ktGZnG/0yxi4NY7gRk1ObUmd0HlAqJhU/ItVS3Ad7rTzYurfnrEMxDDPNn
         iGcCy3Vdu1MtGXyu+tIaYq/hHzczz9E77NPkDoFK4m2VKCE0Uiy8l3EAa8835vsZFyuy
         Zfzw==
X-Gm-Message-State: APjAAAVTnlc5yvF5/ESd0IDKdVxGF8l8bhdCUZmS/f+EIEuy2CZCx91p
        8Rq1LqDRlEEwGdfqnOVOkXXD7w==
X-Google-Smtp-Source: APXvYqydfNW6VQe3QJLlhVyMY7LD2VdLv18RznvBSPB+dUhBxuNiXXy+N60ZePa04UjZ6hpqlgPk1Q==
X-Received: by 2002:a0c:f5cc:: with SMTP id q12mr4143708qvm.79.1565112663672;
        Tue, 06 Aug 2019 10:31:03 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k25sm47224230qta.78.2019.08.06.10.31.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 10:31:03 -0700 (PDT)
Date:   Tue, 6 Aug 2019 10:30:35 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Edwin Peer <edwin.peer@netronome.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        oss-drivers@netronome.com
Subject: Re: [PATCH 08/17] nfp: no need to check return value of
 debugfs_create functions
Message-ID: <20190806103035.60bacd35@cakuba.netronome.com>
In-Reply-To: <20190806170049.GA12269@kroah.com>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org>
        <20190806161128.31232-9-gregkh@linuxfoundation.org>
        <20190806095008.57007f2f@cakuba.netronome.com>
        <20190806170049.GA12269@kroah.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Aug 2019 19:00:49 +0200, Greg Kroah-Hartman wrote:
> On Tue, Aug 06, 2019 at 09:50:08AM -0700, Jakub Kicinski wrote:
> > On Tue,  6 Aug 2019 18:11:19 +0200, Greg Kroah-Hartman wrote:  
> > > When calling debugfs functions, there is no need to ever check the
> > > return value.  The function can work or not, but the code logic should
> > > never do something different based on this.
> > > 
> > > Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Alexei Starovoitov <ast@kernel.org>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Edwin Peer <edwin.peer@netronome.com>
> > > Cc: Yangtao Li <tiny.windzz@gmail.com>
> > > Cc: Simon Horman <simon.horman@netronome.com>
> > > Cc: oss-drivers@netronome.com
> > > Cc: netdev@vger.kernel.org
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>  
> > 
> > Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > 
> > I take it this is the case since commit ff9fb72bc077 ("debugfs: return
> > error values, not NULL")? I.e. v5.0? It'd be useful to know for backport
> > purposes.  
> 
> You were always safe to ignore debugfs calls before that, but in 5.0 and
> then 5.2 we got a bit more "robust" with some internal debugfs logic to
> make it even easier.  These can be backported to 2.6.11+ if you really
> want to, no functionality should change.

Oh sorry! I meant vendor out-of-tree driver backport. We all maintain 
a tarball version of the drivers that compile on old kernels, I was
mostly wondering from that perspective.
 
> But why would you want to backport them?  This really isn't a "bugfix"
> for a stable kernel.  No one should ever noticed the difference except
> for less memory being used.

Right, it wouldn't really help to do an upstream backport.
