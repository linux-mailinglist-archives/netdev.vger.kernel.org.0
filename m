Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 552A8AE198
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 02:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390280AbfIJAD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 20:03:57 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:32879 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389088AbfIJAD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 20:03:56 -0400
Received: by mail-qk1-f195.google.com with SMTP id x134so15148339qkb.0;
        Mon, 09 Sep 2019 17:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aB9EVrIftMY9d4zzs2nUSF4u+wkPMxFq1ux3d3JH2uM=;
        b=r/RYpEt02DdAd6YxwbhmRSU5FS0kEAFA1W/1/slEDbZT6JyB0F467YRAixhWQcM2wG
         1xcEEvUWRBuTeUnTgztTFgF4VKMvAREhyLUEEttgLiFbRUgOmSIq/Q2InQTlJfNVfLqw
         IN+eKY+k6rKj/piQMZ45eXfKaZqO3pUpjZHuwXK9yfiN1C+lWVhmQRC9FrcOvkX4uwly
         CwVgi3mgrHfMjiq22IWrL1GkmXzBcWm3vE7dgQv1nhZk5EZk4VJBaCxXmLKw0hHzTLHc
         i3U8Uii7C8R+xiMeVVqINiIJIYO4fwGDqcUychwxmon8VaZCFZuH/qwxuLa1YKQ+q1fI
         9UEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aB9EVrIftMY9d4zzs2nUSF4u+wkPMxFq1ux3d3JH2uM=;
        b=Iy2bh/0OrpycpOUKhFrtF9iTPlb/96iovBGwWwAB8ZzLtAUkHf9tJt01ihncIBMdsX
         tU/UxBIcfMUC4FCA3UdRZvD8hXuq/d/wfxbmBAW/1YqKQscPff8jlXr7vvgrUZYNlZ0q
         ikCNhKdrDGT9EcPJojmbOp1vDtSKZq/qqrrJPkWAQ7sHtLpCrtPlKELkk37aL/hypYbL
         BeETHqj2Tv4/8DGXvW00zS7pGfAQrMqdcFZrA7KXS2c2Ppu1Kb4LDakU0l6YsXxcwg08
         4aLf3wbMZSp0x+Y12yfRVAcTe831HyRuLlj7Wy5c96N1XhqRpiqeEsW7TGfQVOr3OCJv
         msoQ==
X-Gm-Message-State: APjAAAU7R+i/QTLL83IiZP4ECMkLIRO9uMdbjcMy0uQkHihnh5HACczy
        vg0plSNWgRvn5DfTRcnsEdQBEabEVHI=
X-Google-Smtp-Source: APXvYqzVwAe9QpzPIe++Mr36vHecLe/pVr91+7g9ql7Cf5Dwgwrxpet6HMMh6GQD7jI/iLA2twC9yA==
X-Received: by 2002:a37:4d16:: with SMTP id a22mr26632872qkb.482.1568073835862;
        Mon, 09 Sep 2019 17:03:55 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:e600:cd79:21fe:b069:7c04])
        by smtp.gmail.com with ESMTPSA id e14sm8526123qta.54.2019.09.09.17.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 17:03:55 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id A878DC0DB5; Mon,  9 Sep 2019 21:03:52 -0300 (-03)
Date:   Mon, 9 Sep 2019 21:03:52 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: fix the missing put_user when dumping
 transport thresholds
Message-ID: <20190910000352.GH3431@localhost.localdomain>
References: <3fa4f7700c93f06530c80bc666d1696cb7c077de.1568014409.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fa4f7700c93f06530c80bc666d1696cb7c077de.1568014409.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 09, 2019 at 03:33:29PM +0800, Xin Long wrote:
> This issue causes SCTP_PEER_ADDR_THLDS sockopt not to be able to dump
> a transport thresholds info.
> 
> Fix it by adding 'goto' put_user in sctp_getsockopt_paddr_thresholds.
> 
> Fixes: 8add543e369d ("sctp: add SCTP_FUTURE_ASSOC for SCTP_PEER_ADDR_THLDS sockopt")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
