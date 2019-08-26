Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D55509D779
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 22:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfHZUkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 16:40:13 -0400
Received: from mail-ed1-f45.google.com ([209.85.208.45]:41649 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfHZUkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 16:40:12 -0400
Received: by mail-ed1-f45.google.com with SMTP id w5so28221782edl.8
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 13:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ptnSffzuW8JtguqJ6YPEgDct2SPal9SRJmb4kOaExJ8=;
        b=D/99HLYJXE6sUunaLkC17A8oiaqdxxLs3BHWWwkQ7tjlAakqEvUhj2FlyOpVsHuu6l
         K21+YUwa8MumrPf0Oz8Zs3qRPUH6IjM597RG9OFh8yuA7Q3xUe0xEhIptwmBOn30obrT
         hOAmfIJ1Hhmgb3jugDKVrplUs9IOQbWjmOYZ/FgqnHScc+FYXgwzKa6RTGzKD5DpgeBG
         sUqoxIdhLk79FhqrcwDOo6OmgcMKoZRttrzgtWyFbEek9/yt/8V0Mh0AEdbWrXZUL3a+
         Rj/dAZJo3oLQxDNNPgoovDlzdFVnrWBAPP7F3Uw1hooSpeWzitW45yFa9Y3AZlbPeaX1
         Q+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ptnSffzuW8JtguqJ6YPEgDct2SPal9SRJmb4kOaExJ8=;
        b=JkBqeCk1hvWAZUhT4Yxuq+bxIB4jghxgU2tbOHFpJxZWYYdPHYj3KEDb8wF87mTK5n
         mhmAUB1gwbL+uPYGeGoaIxTygO0PysZhJlupVY4hk5Bt07IYTNq+8NEXzjm3px+Bwu0A
         w3ZTN0AzzP0ojSX6UzcApRTd3hfg+gF+CY3RPLIAR/MBLiPjet7CEL+SmYhyn8Kshvfh
         +MS0g8rrHvmsP9kYG2gUkDdEyNo8Rcjjc6pJLjCx2SvK+AyMkmlYk2KxHKWN+MChIpZk
         l14uscRbr4AJjbBwkE9syjoL2OTukxk7d51EJtS4hkEvRh+Y0GbjNC9GB0XpFmSPdnkS
         l4cw==
X-Gm-Message-State: APjAAAXo+UstYxRMT5Vs8CSRuEWm1zzlInrKiFqjL9CYcJSbWMwTyJut
        EQIoa8a81q1MAPjIBJwcHqVj7j68rns=
X-Google-Smtp-Source: APXvYqx2abthB0Jx1rGOPZYvBoXuxl31QjF9I4Vn6T9So5l559jSF11ifiZ1kWqFW9Xfqo0uXlrA0g==
X-Received: by 2002:a17:906:a452:: with SMTP id cb18mr18161705ejb.280.1566852010502;
        Mon, 26 Aug 2019 13:40:10 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s11sm1465263edh.60.2019.08.26.13.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 13:40:10 -0700 (PDT)
Date:   Mon, 26 Aug 2019 13:39:49 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [net-next 4/8] net/mlx5e: Add device out of buffer counter
Message-ID: <20190826133949.0691660c@cakuba.netronome.com>
In-Reply-To: <18abb6456fb4a2fba52f6f77373ac351651a62c6.camel@mellanox.com>
References: <20190822233514.31252-1-saeedm@mellanox.com>
        <20190822233514.31252-5-saeedm@mellanox.com>
        <20190822183324.79b74f7b@cakuba.netronome.com>
        <27f7cfa13d1b5e7717e2d75595ab453951b18a96.camel@mellanox.com>
        <20190823111601.012fabf4@cakuba.netronome.com>
        <18abb6456fb4a2fba52f6f77373ac351651a62c6.camel@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 20:14:47 +0000, Saeed Mahameed wrote:
> > I see thanks for the explanation and sorry for the delayed response.
> > Would it perhaps make sense to indicate the hairpin in the name?  
> 
> We had some internal discussion and we couldn't come up with the
> perfect name :)
> 
> hairpin is just an implementation detail, we don't want to exclusively
> bind this counter to hairpin only flows, the problem is not with
> hairpin, the actual problem is due to the use of internal RQs, for now
> it only happens with "hairpin like" flows, but tomorrow it can happen
> with a different scenario but same root cause (the use of internal
> RQs), we want to have one counter to count internal drops due to
> internal use of internal RQs.
> 
> so how about:
> dev_internal_rq_oob: Device Internal RQ out of buffer
> dev_internal_out_of_res: Device Internal out of resources (more generic
> ? too generic ?)

Maybe dev_internal_queue_oob? The use of 'internal' is a little
unfortunate, because it may be read as RQ run out of internal buffers.
Rather than special type of queue run out of buffers.
But not knowing the HW I don't really have any great suggestions :(
Either of the above would work as well.

> Any suggestion that you provide will be more than welcome.
> 
> > dev_out_of_buffer is quite a generic name, and there seems to be no
> > doc, nor does the commit message explains it as well as you have..  
> 
> Regarding documentation:
> All mlx5 ethool counters are documented here
> https://community.mellanox.com/s/article/understanding-mlx5-linux-counters-and-status-parameters
> 
> once we decide on the name, will add the new counter to the doc.

I see, thanks!
