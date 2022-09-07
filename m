Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7385AFCB9
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 08:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiIGGoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 02:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiIGGoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 02:44:08 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31B4395;
        Tue,  6 Sep 2022 23:44:07 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 616BA5C0111;
        Wed,  7 Sep 2022 02:44:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 07 Sep 2022 02:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1662533045; x=1662619445; bh=uxiqkYILFEE10SEls//zfdxclfvI
        YtJHN4wQcFOIvkg=; b=Uxb4gwtROIdhEyw7mFwSLtR5WDWlTWdH87vIJXNkjoR6
        DNeSkJ2GHkwqRH9I/tfQvc5eUKcCRoz/O3glVtC5WBg4rBB8XlXCDlAkW041TJWE
        SfvjS30mYnyJHQvT1eb7wH2XdFRbOiJ2KyllVZ02dFHz3kbKJk61v8afrRECdB3X
        hZSH4p304O12shHlvyVmqFTblSiXttpkbyz/thDFlJ71z5+5/BItWk8w5Na0FKBL
        FHlIiiATN6MFsoYjsjHHPIkEPTz4eOOuFVaJJWQ/SSvRnxXBSZoVt+PE6Rw5gMe3
        fYSBy+gPHR6ordnGP9nv1EKMRsJODpixR7WH9qBlrA==
X-ME-Sender: <xms:tD0YY5ZtClD4VEzqLuDM4MlZ3sX88YW8VT22RUHKOvg6BInRBuddPQ>
    <xme:tD0YYwaJI9VdokU2gZdWQNn-YG6vXbgEQpwrYF01Vp6ueGCucYG0QLjbQKfl7L47a
    ucHVVzO-OODIgM>
X-ME-Received: <xmr:tD0YY78TJSpLB2aNVE7qIBwyQi80KAkhDdiJ_EobdAq_w0MuSOTVzS8yAnyew5dCORWaqj9FYUqM04-nJnfANb6tpom94Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdelledguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpeefheffgeegffeuffehiedthfektdefleffffejgeettdffgeeijeejueet
    jeetveenucffohhmrghinhepohhffhhlohgrugdrphihnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhr
    gh
X-ME-Proxy: <xmx:tD0YY3puflwJsg40JZj-QAg6b7bB874oYekJBVIy93Cq1Ppsp7lRAA>
    <xmx:tD0YY0pq0tlB7goeK1uQdPQzGE_4h43v5kAXUHvEzvfOWxxx4Jv3lg>
    <xmx:tD0YY9RZNHPLRMuvPsXMxeCYY1ibrBUmGHEgiHYI1KGIUmml7Mn-aw>
    <xmx:tT0YY6gP5K1_23jqnL-vxdaCqNgP8gZNs-M9zrl_-3Vg78M904tT9A>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Sep 2022 02:44:04 -0400 (EDT)
Date:   Wed, 7 Sep 2022 09:43:59 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jie2x Zhou <jie2x.zhou@intel.com>
Cc:     andrii@kernel.org, mykolal@fb.com, ast@kernel.org,
        daniel@iogearbox.net, martin.lau@linux.dev, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Philip Li <philip.li@intel.com>,
        petrm@nvidia.com
Subject: Re: test ./tools/testing/selftests/bpf/test_offload.py failed
Message-ID: <Yxg9r37w1Wg3mvxy@shredder>
References: <20220907051657.55597-1-jie2x.zhou@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907051657.55597-1-jie2x.zhou@intel.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 01:16:57PM +0800, Jie2x Zhou wrote:
> I found that "disable_ifindex" file do not set read function, so return -EINVAL when do read.
> Is it a bug in test_offload.py?

Most likely a bug in netdevsim itself as it sets the mode of this file
as "rw" instead of "w". The test actually knows to skip such files:

            p = os.path.join(path, f)
            if not os.stat(p).st_mode & stat.S_IRUSR:
                continue

Can you test the following patch?

diff --git a/drivers/net/netdevsim/hwstats.c b/drivers/net/netdevsim/hwstats.c
index 605a38e16db0..0e58aa7f0374 100644
--- a/drivers/net/netdevsim/hwstats.c
+++ b/drivers/net/netdevsim/hwstats.c
@@ -433,11 +433,11 @@ int nsim_dev_hwstats_init(struct nsim_dev *nsim_dev)
                goto err_remove_hwstats_recursive;
        }
 
-       debugfs_create_file("enable_ifindex", 0600, hwstats->l3_ddir, hwstats,
+       debugfs_create_file("enable_ifindex", 0200, hwstats->l3_ddir, hwstats,
                            &nsim_dev_hwstats_l3_enable_fops.fops);
-       debugfs_create_file("disable_ifindex", 0600, hwstats->l3_ddir, hwstats,
+       debugfs_create_file("disable_ifindex", 0200, hwstats->l3_ddir, hwstats,
                            &nsim_dev_hwstats_l3_disable_fops.fops);
-       debugfs_create_file("fail_next_enable", 0600, hwstats->l3_ddir, hwstats,
+       debugfs_create_file("fail_next_enable", 0200, hwstats->l3_ddir, hwstats,
                            &nsim_dev_hwstats_l3_fail_fops.fops);
 
        INIT_DELAYED_WORK(&hwstats->traffic_dw,

> 
> test output:
>  selftests: bpf: test_offload.py
>  Test destruction of generic XDP...
> ......
>      raise Exception("Command failed: %s\n%s" % (proc.args, stderr))
>  Exception: Command failed: cat /sys/kernel/debug/netdevsim/netdevsim0//ports/0/dev/hwstats/l3/disable_ifindex
>  
>  cat: /sys/kernel/debug/netdevsim/netdevsim0//ports/0/dev/hwstats/l3/disable_ifindex: Invalid argument
>  not ok 20 selftests: bpf: test_offload.py # exit=1
