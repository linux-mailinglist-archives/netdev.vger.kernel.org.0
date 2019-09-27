Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73265C08B9
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 17:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbfI0PjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 11:39:00 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37359 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbfI0Pi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 11:38:59 -0400
Received: by mail-wr1-f66.google.com with SMTP id i1so3529434wro.4;
        Fri, 27 Sep 2019 08:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WqPr3BMmdkR12PG5X2wdgv7YTpsF0EmWkLgo4C5gGm8=;
        b=bMQzQjPTyXrKf1113+kG9uJO8Hd1tIflR8zyeoX13anoPf8nfo7xZktTt00/8etwVx
         f/86eU6y2vPTGWaqDrWTFBfeaUweWBKJVnSS5hkOwuSa1uodSyzGnITqsdwzp/EImrUr
         Hj1y7tmAXpfSH9RJ2v66esgn2iBI82gvW2A7NCSfd6BFvWq3nUFGTU29pv7n4CPB1umv
         pZH4xLWfX5teemBDnprRU+viEUq1AyriytkLocg5STufvSIFP3R4Hq5EwGeGFyaQKB1I
         GkHy2vxG6imthBzN7yzeYk4th90kYWiphjViudxatmJ3SO6oMbT54ZWWAEUKQsCXf6yS
         TD3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WqPr3BMmdkR12PG5X2wdgv7YTpsF0EmWkLgo4C5gGm8=;
        b=jbMmug2tGZ1MzYhC8iHjPPdUeVUfBXX05tvPJni/5knnuwv4lgK2pvT92FxjRLATzy
         /RvqnGcpjS+LGYyw1GRZ/W4e/m2X0hfqxlxKuNsrbjXHIRKHzaPVuGV3Mnxwg8nZV3ay
         dTOdPfWnyG3yk8n8FsgAOMCb3/jEtyssiR69ftDhtNp6tmO5BjBP25RVdlW9k7xWDsHQ
         +xu7DrIiOEUHdlhHlEVi1IjrFxuRMxAHpfZi9uWP+cK6e7jyJYlmXU4wWoZuU+0+rInd
         f2ty9uMbvzCN6DhwK84HKUwsxXBimngWjKZ8x+SJ4UbAKsn6+aMrF0IFMe9RmfQfa0Nn
         HgxA==
X-Gm-Message-State: APjAAAVwuIgCGMWBOO/jW38QPzGJITbBe0YFsuX/enIae4ylwr2Q40yX
        mPtSiisqy3P5TkvMT4SUbmM=
X-Google-Smtp-Source: APXvYqytcVLtWlyBJYAkuqwx6A2Onw/qBy8K4tRZvRbkGWY98IIBO5iTmei7P0b/bbu1gpKiddducg==
X-Received: by 2002:a7b:cbd6:: with SMTP id n22mr8198204wmi.39.1569598737528;
        Fri, 27 Sep 2019 08:38:57 -0700 (PDT)
Received: from scw-93ddc8.cloud.online.net ([2001:bc8:4400:2400::302d])
        by smtp.gmail.com with ESMTPSA id z1sm6009561wre.40.2019.09.27.08.38.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Sep 2019 08:38:56 -0700 (PDT)
Date:   Fri, 27 Sep 2019 15:38:43 +0000
From:   Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Cc:     stefanha@redhat.com, davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsock/virtio: add support for MSG_PEEK
Message-ID: <20190927153843.GA15350@scw-93ddc8.cloud.online.net>
References: <1569522214-28223-1-git-send-email-matiasevara@gmail.com>
 <f069a65d-33b9-1fa8-d26e-b76cc51fc7cb@gmail.com>
 <20190927085513.tdiofiisrpyehfe5@steredhat.homenet.telecomitalia.it>
 <a7a77f0b-a658-6e46-3381-3dfea55b14d1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7a77f0b-a658-6e46-3381-3dfea55b14d1@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 06:37:00AM -0700, Eric Dumazet wrote:
> 
> 
> On 9/27/19 1:55 AM, Stefano Garzarella wrote:
> 
> > Good catch!
> > 
> > Maybe we can solve in this way:
> > 
> > 	list_for_each_entry(pkt, &vvs->rx_queue, list) {
> > 		size_t off = pkt->off;
> > 
> > 		if (total == len)
> > 			break;
> > 
> > 		while (total < len && off < pkt->len) {
> > 			/* using 'off' instead of 'pkt->off' */
> > 			...
> > 
> > 			total += bytes;
> > 			off += bytes;
> > 		}
> > 	}
> > 
> > What do you think?
> >
> 
> Maybe, but I need to see a complete patch, evil is in the details :)
>

Thanks both for your comments, I will take them into account and submit
a second version. 

Matias
