Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE9259B625
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 20:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390317AbfHWSQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 14:16:15 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36269 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388081AbfHWSQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 14:16:15 -0400
Received: by mail-qk1-f194.google.com with SMTP id d23so8995266qko.3
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 11:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=pOwvP+o982g3eCm0o0emleh55/c7Om3ik93q4vjlvS4=;
        b=qyVGuq996Q9Q1M3/ZFkdRGomTJuORxFfJ4iw8JFCENxSlae29+P1AW5hXWLXn/X+Uf
         terlZkQ/g/9VAZqzENhfdtF5ZEh9OaJzOhrg1rjXHeFtMAYCLtMlu2x2EyGjMnzh2rma
         4sxYwbGFI5fc4fNVeEKKbdrq5LOAGL7NdgiAQO8s9+J8ubY4ap8cVr2x02Ay++6xGSgS
         nfFIwFWC5DRFTeu652hfLPH3B5NmXI+P/w2p5IG4KWioo2T5LsnJoXVooAiS4amZrTPn
         /rTgcQ1B2s48IIyutag0AE6+ogVq46POxkFGXP35vJfROTe7bj79UpkZ7HlfksvZCoE9
         nAdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pOwvP+o982g3eCm0o0emleh55/c7Om3ik93q4vjlvS4=;
        b=EI8lffuXLZ6ot2tUwVRFdHhbuUrY9UjmlFXLrw5iTbgZpYvhj5JCkhtHIiXXT3T7PK
         38jZf7Hv3gjte3Sbt3phY8k+PC8DiI82QWey64bS8jaGnvT0sE8wiJcqa34Arn79KNHn
         Si0Pnj/dM1ZHBBxe7ZkI9YQxCcnR6X1tcj0h8xzzESkOd7JgD4NG85uDQF0a6Sh3Ofze
         dLCD7macbPi44r7q8i/xGf6L2IkVo4PJY+iKXtz8YliMcl5w2nrIGWMEw6WaZ+4fEABD
         IQlNF3G19lwUysUJcjF6ezz1nn5RaRd316uj7QZNw5Fo/YJkTbX4KMyyC6UewzJHN8TP
         7Hvg==
X-Gm-Message-State: APjAAAWURfnmKOkpp2wVRCZh9CKBIhQnZ47svsNCJtUZd0KzHwTQT4Pi
        YbHOllndW32cAAji238PhHbY8w==
X-Google-Smtp-Source: APXvYqyHdhYe+DPjJOlLu2DwNVaPRY5k5IIzfW7wRseyxNRBaQVBZu74fkXp3XVQsuY8HSNxIBT6lQ==
X-Received: by 2002:a37:a702:: with SMTP id q2mr5432770qke.213.1566584174215;
        Fri, 23 Aug 2019 11:16:14 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m38sm1947229qta.43.2019.08.23.11.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 11:16:13 -0700 (PDT)
Date:   Fri, 23 Aug 2019 11:16:01 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [net-next 4/8] net/mlx5e: Add device out of buffer counter
Message-ID: <20190823111601.012fabf4@cakuba.netronome.com>
In-Reply-To: <27f7cfa13d1b5e7717e2d75595ab453951b18a96.camel@mellanox.com>
References: <20190822233514.31252-1-saeedm@mellanox.com>
        <20190822233514.31252-5-saeedm@mellanox.com>
        <20190822183324.79b74f7b@cakuba.netronome.com>
        <27f7cfa13d1b5e7717e2d75595ab453951b18a96.camel@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Aug 2019 06:00:45 +0000, Saeed Mahameed wrote:
> On Thu, 2019-08-22 at 18:33 -0700, Jakub Kicinski wrote:
> > On Thu, 22 Aug 2019 23:35:52 +0000, Saeed Mahameed wrote:  
> > > From: Moshe Shemesh <moshe@mellanox.com>
> > > 
> > > Added the following packets drop counter:
> > > Device out of buffer - counts packets which were dropped due to
> > > full
> > > device internal receive queue.
> > > This counter will be shown on ethtool as a new counter called
> > > dev_out_of_buffer.
> > > The counter is read from FW by command QUERY_VNIC_ENV.
> > > 
> > > Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>  
> > 
> > Sounds like rx_fifo_errors, no? Doesn't rx_fifo_errors count RX
> > overruns?  
> 
> No, that is port buffer you are looking for and we got that fully
> covered in mlx5. this is different.
> 
> This new counter is deep into the HW data path pipeline and it covers
> very rare and complex scenarios that got only recently introduced with
> swichdev mode and "some" lately added tunnels offloads that are routed
> between VFs/PFs.
> 
> Normally the HW is lossless once the packet passes port buffers into
> the data plane pipeline, let's call that "fast lane", BUT for sriov
> configurations with switchdev mode enabled and some special hand
> crafted tc tunnel offloads that requires hairpin between VFs/PFs, the
> hw might decide to send some traffic to a "service lane" which is still
> fast path but unlike the "fast lane" it handles traffic through "HW
> internal" receive and send queues (just like we do with hairpin) that
> might drop packets. the whole thing is transparent to driver and it is
> HW implementation specific.

I see thanks for the explanation and sorry for the delayed response.
Would it perhaps make sense to indicate the hairpin in the name?
dev_out_of_buffer is quite a generic name, and there seems to be no
doc, nor does the commit message explains it as well as you have..
