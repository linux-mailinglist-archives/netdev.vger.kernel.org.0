Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEFE67E645
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 01:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbfHAXLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 19:11:48 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35344 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfHAXLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 19:11:48 -0400
Received: by mail-qt1-f193.google.com with SMTP id d23so72121455qto.2
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 16:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ztAu4QZGDIQMdZBWkY7E7Oa+ajrHbkMzVWaeIeGWy+c=;
        b=A9lhvsWXZkWPnMr3aru1wfNuTiEcH0uUEvNMFE60foNthE6agvJlfpDhsVN7tOQDjK
         cOscdGWjN/31oB6xchKWqH3ZSo7r2e4RdRJlQz2NVKdk7uYcgKRMNyDiYDBt3yC40gH5
         HxzbQ5RS1bn9v4epx7RpAUaeFgDqJNCEb0jMBv7WQ/DF6rzJuWy5x/UeDO3wHBbfeRrJ
         aWAGrfCzbJTcA1Gr0RMLCNWs8Xch1G8PYISnwfIhsQosgh2L90bnGglreWyWI1SD6YW9
         DMf1X4x1q1DWqI6xLvaQ09JLi4d3pGSyBO5Tx6gPhXu9Rj230/nEMvDpFDGQ2iauCa4X
         Fp7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ztAu4QZGDIQMdZBWkY7E7Oa+ajrHbkMzVWaeIeGWy+c=;
        b=hHVTmzoZg2sQfc/Ivz1En7fYy/Al2e4MBsZfrP77QMLTyQUdi52TgR3o64GpgWskMR
         wkw3zkz41WjBVV7yvlCL78+/GrxhmD1a4ag3nMjldEXcgA8Jx+5ckjkDuP9JohXdFnUB
         skWwMyDXWHQh4cP0RQG1YEaNFi4swK7sCHrK3KE1MaFIvum5E2mxMm3xncOFbsgZDa0E
         ZesU7dqcTDC0IAH/wgXDipnZuqO1BfUnFL+hv0CI+sLr8avm2kSluBuSuAxfsQN5jNla
         dVLk3nszGJV8HfTv5NOmbzRnSiHmypaK5X001LlB7s/AEnQ9+i9uh2E6Zmi4tSGBUOkk
         XfqA==
X-Gm-Message-State: APjAAAVHNCvvMeY9b2spnVtbdqwfdWHUMxsthRP2eKfUKgjCUD4v5WfI
        LeoYUShSmVJV47bw0Erj9pSwlLybVeE=
X-Google-Smtp-Source: APXvYqzIALNSgEi0ptpT9zrpQ6/XoXDwKdKZHriP7QHEszTr5F3EcGFq3Y7qbcJXt9Ay/wn0LB75Mw==
X-Received: by 2002:ac8:428f:: with SMTP id o15mr13908670qtl.210.1564701107392;
        Thu, 01 Aug 2019 16:11:47 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y194sm32944388qkb.111.2019.08.01.16.11.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 16:11:47 -0700 (PDT)
Date:   Thu, 1 Aug 2019 16:11:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu@ucloud.cn
Cc:     jiri@resnulli.us, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        John Hurley <john.hurley@netronome.com>
Subject: Re: [PATCH net-next v5 5/6] flow_offload: support get flow_block
 immediately
Message-ID: <20190801161129.25fee619@cakuba.netronome.com>
In-Reply-To: <1564628627-10021-6-git-send-email-wenxu@ucloud.cn>
References: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
        <1564628627-10021-6-git-send-email-wenxu@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Aug 2019 11:03:46 +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The new flow-indr-block can't get the tcf_block
> directly. It provide a callback list to find the flow_block immediately
> when the device register and contain a ingress block.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>

First of all thanks for splitting the series up into more patches, 
it is easier to follow the logic now!

> @@ -328,6 +348,7 @@ struct flow_indr_block_dev {
>  
>  	INIT_LIST_HEAD(&indr_dev->cb_list);
>  	indr_dev->dev = dev;
> +	flow_get_default_block(indr_dev);
>  	if (rhashtable_insert_fast(&indr_setup_block_ht, &indr_dev->ht_node,
>  				   flow_indr_setup_block_ht_params)) {
>  		kfree(indr_dev);

I wonder if it's still practical to keep the block information in the
indr_dev structure at all. The way this used to work was:


[hash table of devices]     --------------
                 |         |    netdev    |
                 |         |    refcnt    |
  indir_dev[tun0]|  ------ | cached block | ---- [ TC block ]
                 |         |   callbacks  | .
                 |          --------------   \__ [cb, cb_priv, cb_ident]
                 |                               [cb, cb_priv, cb_ident]
                 |          --------------
                 |         |    netdev    |
                 |         |    refcnt    |
  indir_dev[tun1]|  ------ | cached block | ---- [ TC block ]
                 |         |   callbacks  |.
-----------------           --------------   \__ [cb, cb_priv, cb_ident]
                                                 [cb, cb_priv, cb_ident]


In the example above we have two tunnels tun0 and tun1, each one has a
indr_dev structure allocated, and for each one of them two drivers
registered for callbacks (hence the callbacks list has two entries).

We used to cache the TC block in the indr_dev structure, but now that
there are multiple subsytems using the indr_dev we either have to have
a list of cached blocks (with entries for each subsystem) or just always
iterate over the subsystems :(

After all the same device may have both a TC block and a NFT block.

I think always iterating would be easier:

The indr_dev struct would no longer have the block pointer, instead
when new driver registers for the callback instead of:

	if (indr_dev->ing_cmd_cb)
		indr_dev->ing_cmd_cb(indr_dev->dev, indr_dev->flow_block,
				     indr_block_cb->cb, indr_block_cb->cb_priv,
				     FLOW_BLOCK_BIND);

We'd have something like the loop in flow_get_default_block():

	for each (subsystem)
		subsystem->handle_new_indir_cb(indr_dev, cb);

And then per-subsystem logic would actually call the cb. Or:

	for each (subsystem)
		block = get_default_block(indir_dev)
		indr_dev->ing_cmd_cb(...)

I hope this makes sense.


Also please double check nft unload logic has an RCU synchronization
point, I'm not 100% confident rcu_barrier() implies synchronize_rcu().
Perhaps someone more knowledgeable can chime in :)
