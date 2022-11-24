Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF984637E4F
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 18:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiKXRdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 12:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiKXRdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 12:33:47 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6643FC725;
        Thu, 24 Nov 2022 09:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669311222; x=1700847222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZCM/4ly0EXbLeD0JnnBx6nzlgR9hJc+rXDb4RHGHLN8=;
  b=FmiTa6NcLf1d2qYq6C8X6CADDBnf21tlCCp6xcKqNa3qsW1lT7gGqSJ9
   XVAzzrjcggPfHJiRJQ7/RF+sGNDsxhqozRQfTq2WPUnVmv00dFBLVABJo
   /9BGhtddsF1HNl+wqO6wXtiWNdYRs4JnoNg7AzmS1CpVN5L7ZCSmxPfUM
   b/pcwEBUXLfXRGYvdMtY4b8bEMADNzHYJGAjKtyKQNWjF+etZYoB3DGJ+
   xO8qdvHbdg1IrfySzprbJLAwnDtz2lWTJG6zPRlXO2S4TNKKM28Y3zS0o
   cian2SovaPTJ8SJYLljj5Bb2nfY22TBQyUviUlPUFXbD6R3vBZsgnIzx9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="301904767"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="301904767"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 09:33:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="620099752"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="620099752"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 24 Nov 2022 09:33:39 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AOHXc0g001196;
        Thu, 24 Nov 2022 17:33:38 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     wangchuanlei <wangchuanlei@inspur.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>, pabeni@redhat.com,
        echaudro@redhat.com, pshelar@ovn.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, wangpeihui@inspur.com,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [openvswitch v4] openvswitch: Add support to count upcall packets
Date:   Thu, 24 Nov 2022 18:33:27 +0100
Message-Id: <20221124173327.5015-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221124022416.4045660-1-wangchuanlei@inspur.com>
References: <20221123183834.489456-1-alexandr.lobakin@intel.com> <20221124022416.4045660-1-wangchuanlei@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wangchuanlei <wangchuanlei@inspur.com>
Date: Wed, 23 Nov 2022 21:24:16 -0500

> Hi,
>     Thank you for review! I will give a new verson of patch based on your comments,
> and i give a explanation on every comments from you, please see below!

Oh, just noticed, the subject prefix [openvswitch] is not correct,
please use [PATCH net-next v5] next time.

> 
> Best reagrds!
> wangchuanlei

[...]

> > +		const struct vport *p = OVS_CB(skb)->input_vport;
> > +		struct vport_upcall_stats_percpu *vport_stats;
> > +
> > +		vport_stats = this_cpu_ptr(p->vport_upcall_stats_percpu);
> 
> Why make a separate structure? You can just expand dp_stats_percpu, this function would then be just a couple lines in ovs_dp_upcall().
> -- emm, beacause of this statistics based on vport, so new structure should insert to "struct vport"

Ah, my bad. Didn't notice that :')

> 
> 
> > +		u64_stats_update_begin(&vport_stats->syncp);
> > +		if (upcall_success)
> > +			u64_stats_inc(&vport_stats->n_upcall_success);
> > +		else
> > +			u64_stats_inc(&vport_stats->n_upcall_fail);
> > +		u64_stats_update_end(&vport_stats->syncp);
> > +	}
> > +}
> > +
> >  void ovs_dp_detach_port(struct vport *p)  {
> >  	ASSERT_OVSL();
> > @@ -216,6 +235,9 @@ void ovs_dp_detach_port(struct vport *p)
> >  	/* First drop references to device. */
> >  	hlist_del_rcu(&p->dp_hash_node);
> >  
> > +	/* Free percpu memory */
> > +	free_percpu(p->vport_upcall_stats_percpu);
> > +
> >  	/* Then destroy it. */
> >  	ovs_vport_del(p);
> >  }
> > @@ -305,6 +327,8 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_buff *skb,
> >  		err = queue_userspace_packet(dp, skb, key, upcall_info, cutlen);
> >  	else
> >  		err = queue_gso_packets(dp, skb, key, upcall_info, cutlen);
> > +
> > +	ovs_vport_upcalls(skb, upcall_info, !err);
> >  	if (err)
> >  		goto err;
> 
> Also, as you may see, your ::upcall_fail counter will be always exactly the same as stats->n_lost. So there's no point introducing a new one.
> However, you can expand the structure dp_stats_percpu and add a new field there which would store the number of successfull upcalls.
> ...but I don't see a reason for this to be honest. From my PoV, it's better to count the number of successfully processed packets at the end of queue_userspace_packet() right before the 'out:'
> label[0]. But please make sure then you don't duplicate some other counter (I'm not deep into OvS, so can't say for sure if there's anything similar to what you want).
> --in ovs ， as stats->n_lost only count the sum of packets of all ports, not on individal port , so expand the structure dp_stats_percpu may be not suitable
> --and count upcall failed packets is useful beacuse no all of upcall packets are successfully sent。

Yes, I see now, thanks for the explanation! I think it's good idea
in general to introduce OvS per-vport stats. There are some, but
they're stored in net_device::dev_stats, which I'm not a fan of :D

> 
> >  
> > @@ -1825,6 +1849,13 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
> >  		goto err_destroy_portids;
> >  	}
> >  
> > +	vport->vport_upcall_stats_percpu =
> 
> This can be at least twice shorter, e.g. 'upcall_stats'. Don't try to describe every detail in symbol names.
> --yes!
> > +				netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> > +	if (!vport->vport_upcall_stats_percpu) {
> > +		err = -ENOMEM;
> > +		goto err_destroy_upcall_stats;
> 
> I know you followed the previous label logics, but you actually aren't destroying the stats under this label. Here you should have `goto err_destroy_portids` as that's what you're actually doing on that error path.
> --here is just keep format of code, and has no influence on function

Correct, so you can use the already existing label here.

> 
> > +	}
> > +
> >  	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
> >  				   info->snd_seq, 0, OVS_DP_CMD_NEW);
> >  	BUG_ON(err < 0);
> 
> [...]
> 
> > @@ -2278,6 +2321,14 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
> >  		goto exit_unlock_free;
> >  	}
> >  
> > +	vport->vport_upcall_stats_percpu =
> > +		netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> > +
> > +	if (!vport->vport_upcall_stats_percpu) {
> > +		err = -ENOMEM;
> > +		goto exit_unlock_free;
> > +	}
> 
> Why do you allocate them twice?
> -- here is in different code segment on in vport_cmd_new , the other is in dp_cmd_new, they are has no collisions

+ (resolved)

> 
> > +
> >  	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
> >  				      info->snd_portid, info->snd_seq, 0,
> >  				      OVS_VPORT_CMD_NEW, GFP_KERNEL);

[...]

> > --
> > 2.27.0
> 
> [0] https://elixir.bootlin.com/linux/v6.1-rc6/source/net/openvswitch/datapath.c#L557
> 
> Thanks,
> Olek

Thanks,
Olek
