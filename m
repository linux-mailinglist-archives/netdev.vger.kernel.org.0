Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD611B6484
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgDWTeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728308AbgDWTeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:34:07 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F79C09B043
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:34:06 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z1so1789796pfn.3
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9KGrEVcwlnmPKwT5aCT/vfJhRhAjFIEDID/2V1O/W6k=;
        b=Syoy3IVI7d+UMWGA1M+MTvFTeKmhg7K9j0dR1pyRH2lQTwZdG0/89uKprpNCzGBK8A
         bsVSTWbj2aGqYo6aJpJj5QcT8oCo0uP+xMyRKRvJnKq0G4OOEbXloxaLgaz/uIwQvmep
         ntliF4YgZEOQraOu+KVuqXVnyWU6yhA/0V6n/ULcjSWvgGLzkX/k1gwkn0GZNYhk62vU
         vdFwGv3LDUlnGy1xUm1B6UDDRqvwAOObTOdms0Lj/r73y5w0IB1SBhGZkpa3YiVNi5bB
         fcG03BA94rzhJO238B0LrZ43+Su3X93OaxPNsDlAs5ZgOo59ZvOKOkmLIll72iTPteZS
         7EDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9KGrEVcwlnmPKwT5aCT/vfJhRhAjFIEDID/2V1O/W6k=;
        b=krW1Q4vXuhEMxczBswb5s0CRvCSOksIuKB4cr5G6+KUC1dSqHl7Xm7SLZiebC/lL5M
         xk0d3YQHUpwCZDOByFvCO2/Xdcg4h4xkBRSHWI8ZcNf7twFsv8fSy7giffTYX1cgIywy
         s8nCs9TBmPySNYtr3/zlFzK1WsJyeKzrCHUh99v/TwFf5dU8wlDrUQb+HHwvoluJDxiJ
         k7+JyKmuEZOkO9la6Im2Fbcq7CACQHjFu+d9qs4wJIfqqWwoygVOa9G3l9PiVhQn+oPg
         1r5rxEJMvBbtzUm1krDytM97L6NDInTt2aVjlvOw5/1aQq2kKUOfRKUf9MmfQnhDF0Y9
         7fBw==
X-Gm-Message-State: AGi0PuZyJPB7xliN3DbCKzFJxARmqvtsX4IOvuU5B1l+yCNgNdy5nZGq
        UMV2sgOcQ25KpSiaMvchNQmYsw==
X-Google-Smtp-Source: APiQypLb4VafY6f/+t91uK4pQhSEJppTWd+UTbrpvy0xNJwYzRVC8LaJDnwLyUJ+H2g13i8os43q5w==
X-Received: by 2002:a63:4a59:: with SMTP id j25mr5318011pgl.336.1587670445851;
        Thu, 23 Apr 2020 12:34:05 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id c1sm3367595pfc.94.2020.04.23.12.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 12:34:05 -0700 (PDT)
Date:   Thu, 23 Apr 2020 12:33:56 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        ruxandra.radulescu@nxp.com, ioana.ciornei@nxp.com,
        nipun.gupta@nxp.com, shawnguo@kernel.org
Subject: Re: [PATCH net-next 2/2] dpaa2-eth: fix return codes used in
 ndo_setup_tc
Message-ID: <20200423123356.523264b4@hermes.lan>
In-Reply-To: <20200423173804.004fd0f6@carbon>
References: <158765382862.1613879.11444486146802159959.stgit@firesoul>
        <158765387082.1613879.14971732890635443222.stgit@firesoul>
        <20200423082804.6235b084@hermes.lan>
        <20200423173804.004fd0f6@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Apr 2020 17:38:04 +0200
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> On Thu, 23 Apr 2020 08:28:58 -0700
> Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
> > On Thu, 23 Apr 2020 16:57:50 +0200
> > Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> >   
> > > Drivers ndo_setup_tc call should return -EOPNOTSUPP, when it cannot
> > > support the qdisc type. Other return values will result in failing the
> > > qdisc setup.  This lead to qdisc noop getting assigned, which will
> > > drop all TX packets on the interface.
> > > 
> > > Fixes: ab1e6de2bd49 ("dpaa2-eth: Add mqprio support")
> > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>    
> > 
> > Would it be possible to use extack as well?  
> 
> That is what patch 1/2 already does.
> 
> > Putting errors in dmesg is unhelpful  
> 
> This patchset does not introduce any dmesg printk.
> 

I was thinking that this  
	if (num_tc  > dpaa2_eth_tc_count(priv)) {
 		netdev_err(net_dev, "Max %d traffic classes supported\n",
 			   dpaa2_eth_tc_count(priv));
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}

could be an extack message, but doing that would require a change
to the ndo_setup_tc hook to allow driver to return its own error message
as to why the setup failed.
