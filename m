Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187E33020D9
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 04:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbhAYDbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 22:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbhAYDbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 22:31:20 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5784C061573;
        Sun, 24 Jan 2021 19:30:39 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id lw17so8524028pjb.0;
        Sun, 24 Jan 2021 19:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=u6/r5npCt7ZfnHb6JkAdXtFPfu4l3rDNuEo40yaNlnQ=;
        b=PD9Yr4I14AfrM+TNrerkEYlNV7BI6+vc9JVaexum/U47l62aaDYUzPtgHuMOgDxhhZ
         +t51z+MZAwbFn4WggA0FQUsaiLLihXCrhXop7joi6UbFHqkCCDuR8wXuwHVhKwD6Lbg8
         g6hbNodrhN7E7RtuYoBXQhtF7XNiMnooUlxngo07fmRgf8ZJIYkznOrQO9X9y4xWXTQi
         +PsgRrTZYtDftobEVAW3/kBNa1aGcuZksFgA7VWO2g+oskEt1uH1VGmSZoxLDZKLrR+N
         LcPOLr3WmJ5+n+Zp0D+qCkm9QAu8dDvk12oU33TV8JMmvq+evGdO0iHdGnGgLYWlt6BV
         Guyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=u6/r5npCt7ZfnHb6JkAdXtFPfu4l3rDNuEo40yaNlnQ=;
        b=FG3OdGN0PIjxw5iYWMKzwVl/eCuC0ofzpXd2vhzlrjIZVZOkF4yyVU9trqQahOC6tW
         KAssIlWVfIhc6r18WVRvihSigrEtfySszmkBHogm/5J7qpuJ1c9o7+Vtfqgvqoxhik/K
         HRDEKVM8NX7+RUQSkJ452EDFfKq2WpsSmy6GhWrVkBa4cqIgDGlfVH5V5J1IoKPDfyqr
         lAKxOVJgTFIs/I76bJ8NYbChDpfjCM5DepICGzU4d3fJWdbO0meAKSCZAUoqQJQRHaD3
         1g9T1dg34S4tdSwU77ffanVBuRXFhYMA3RwDB7tV1LqxYDNWmYmeIbEyWogFPCeCKFYt
         2tXQ==
X-Gm-Message-State: AOAM532xIW34oMBQ9qfMR5ibopUK0dWrT3LhrXX2VQI1gCAB1ojk4oa0
        mbxV+gc8RyvTCw7ci1YzdCM=
X-Google-Smtp-Source: ABdhPJyZaHqk3ivZj7oQkO9QBQGs0dY2z9G6/xzgMBFwqE66HMoInN4Vmc/C98847aSk0VrhErj58w==
X-Received: by 2002:a17:90b:4a03:: with SMTP id kk3mr1332814pjb.206.1611545439441;
        Sun, 24 Jan 2021 19:30:39 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d128sm4834847pga.87.2021.01.24.19.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 19:30:38 -0800 (PST)
Date:   Mon, 25 Jan 2021 11:30:25 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCHv16 bpf-next 1/6] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
Message-ID: <20210125033025.GL1421720@Leo-laptop-t470s>
References: <20210120022514.2862872-1-liuhangbin@gmail.com>
 <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210122074652.2981711-2-liuhangbin@gmail.com>
 <20210122105043.GB52373@ranger.igk.intel.com>
 <871red6qhr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <871red6qhr.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 02:38:40PM +0100, Toke Høiland-Jørgensen wrote:
> >>  out:
> >> +	drops = cnt - sent;
> >>  	bq->count = 0;
> >>  
> >>  	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
> >>  	bq->dev_rx = NULL;
> >> +	bq->xdp_prog = NULL;
> >
> > One more question, do you really have to do that per each bq_xmit_all
> > call? Couldn't you clear it in __dev_flush ?
> >
> > Or IOW - what's the rationale behind storing xdp_prog in
> > xdp_dev_bulk_queue. Why can't you propagate the dst->xdp_prog and rely on
> > that without that local pointer?
> >
> > You probably have an answer for that, so maybe include it in commit
> > message.
> >
> > BTW same question for clearing dev_rx. To me this will be the same for all
> > bq_xmit_all() calls that will happen within same napi.
> 
> I think you're right: When bq_xmit_all() is called from bq_enqueue(),
> another packet will always be enqueued immediately after, so clearing
> out all of those things in bq_xmit_all() is redundant. This also
> includes the list_del on bq->flush_node, BTW.
> 
> And while we're getting into e micro-optimisations: In bq_enqueue() we
> have two checks:
> 
> 	if (!bq->dev_rx)
> 		bq->dev_rx = dev_rx;
> 
> 	bq->q[bq->count++] = xdpf;
> 
> 	if (!bq->flush_node.prev)
> 		list_add(&bq->flush_node, flush_list);
> 
> 
> those two if() checks can be collapsed into one, since the list and the
> dev_rx field are only ever modified together. This will also be the case
> for bq->xdp_prog, so putting all three under the same check in
> bq_enqueue() and only clearing them in __dev_flush() would be a win, I
> suppose - nice catch! :)

Thanks for the advice, so how about modify it like:

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index bc38f7193149..217e09533097 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -413,9 +413,6 @@ static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 	bq->count = 0;
 
 	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
-	bq->dev_rx = NULL;
-	bq->xdp_prog = NULL;
-	__list_del_clearprev(&bq->flush_node);
 	return;
 }
 
@@ -434,8 +431,12 @@ void __dev_flush(void)
 	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
 	struct xdp_dev_bulk_queue *bq, *tmp;
 
-	list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
+	list_for_each_entry_safe(bq, tmp, flush_list, flush_node) {
 		bq_xmit_all(bq, XDP_XMIT_FLUSH);
+		bq->dev_rx = NULL;
+		bq->xdp_prog = NULL;
+		__list_del_clearprev(&bq->flush_node);
+	}
 }
 
 /* rcu_read_lock (from syscall and BPF contexts) ensures that if a delete and/or
@@ -469,22 +470,17 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 	/* Ingress dev_rx will be the same for all xdp_frame's in
 	 * bulk_queue, because bq stored per-CPU and must be flushed
 	 * from net_device drivers NAPI func end.
+	 *
+	 * Do the same with xdp_prog and flush_list since these fields
+	 * are modified together.
 	 */
-	if (!bq->dev_rx)
+	if (!bq->dev_rx) {
 		bq->dev_rx = dev_rx;
-
-	/* Store (potential) xdp_prog that run before egress to dev as
-	 * part of bulk_queue.  This will be same xdp_prog for all
-	 * xdp_frame's in bulk_queue, because this per-CPU store must
-	 * be flushed from net_device drivers NAPI func end.
-	 */
-	if (!bq->xdp_prog)
 		bq->xdp_prog = xdp_prog;
+		list_add(&bq->flush_node, flush_list);
+	}
 
 	bq->q[bq->count++] = xdpf;
-
-	if (!bq->flush_node.prev)
-		list_add(&bq->flush_node, flush_list);
 }
 
 static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
