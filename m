Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A775B149A
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 08:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiIHGYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 02:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiIHGX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 02:23:58 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F965CCD56;
        Wed,  7 Sep 2022 23:23:58 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7FCE83200708;
        Thu,  8 Sep 2022 02:23:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 08 Sep 2022 02:23:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1662618234; x=1662704634; bh=tQVYpCBZL3BsXXUIGuhHhn+GnF9r
        ZgFIWXrgHaQZMbY=; b=ewJMBlVaLQYFSExMsQK75AOZdcexluLL5bNUc2vWoTxh
        rgWjfNa5+R7tbzYKG2oUFXPDQVYLSkPhcgmtbm9bZ0LlzCnxI6fs/XXPGcUtNWl/
        4KTIMXd8rTSeGY1vCbJVWoANYNeO0mzG8NaHJEwfxwjwrOf9byNE+FKcOwqe4zWE
        +R7HRlcGpkofHCXUiaS2tQHxkOskppkTx9PZ/72AtOafBo9uIIK2OCrSsROttQZw
        1oswHQSwrvz4FtXJe9S639YmGu326indkySDFvPtm+voHxpGoIOAaZ9wvPKJkAyH
        v/Q5OJ/5Drtxe1cBd8U6s9CU/i3iD1HD6f+n0/q5fw==
X-ME-Sender: <xms:eYoZY45VwEC_og3CawJYOAhr4DK9_runwm6215wCONy0pIIGrDrDOw>
    <xme:eYoZY54doKlfEvYh3dFjXyH-C_jTMUWaBssAub3MM4NvjpeZRD5eoNXYGIaLYw3y2
    3Fl-cEdXhebJwk>
X-ME-Received: <xmr:eYoZY3fo0FyVb9UN9URtGDipJTsSOG8pes-MJOkk5UOvzqlI1wGdKWml2VQAGs7ZhUZJiYmPG8WGq8ISrqcYc_mBAjWgwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedtuddgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:eYoZY9JQZfqfXxqjwaEhpU2l7DyJYG2DKVyOPvnEF_QNc84tDPe31g>
    <xmx:eYoZY8LZm318XSdzurWKOtkgPmlZOOx2Ga8ovY-8ddKLNIjGWwe4ag>
    <xmx:eYoZY-yfvvx4-ZCHoPCwJkFyfQFOFOtfd3dMbSozdN06KLKtwtu8jg>
    <xmx:eooZY-D1Z1Huck6Q0HZ8HeqvfKXEjUEXz3jiS0C0rhd6fdLA8VQ5aA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Sep 2022 02:23:53 -0400 (EDT)
Date:   Thu, 8 Sep 2022 09:23:48 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     "Zhou, Jie2X" <jie2x.zhou@intel.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "mykolal@fb.com" <mykolal@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "martin.lau@linux.dev" <martin.lau@linux.dev>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Philip" <philip.li@intel.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: Re: test ./tools/testing/selftests/bpf/test_offload.py failed
Message-ID: <YxmKdBVkNCPF4Kob@shredder>
References: <20220907051657.55597-1-jie2x.zhou@intel.com>
 <Yxg9r37w1Wg3mvxy@shredder>
 <CY4PR11MB1320E553043DC1D67B5E7D56C5419@CY4PR11MB1320.namprd11.prod.outlook.com>
 <YxjB7RZvVrKxJ4ec@shredder>
 <CY4PR11MB132098D8E47E38FD945E6398C5409@CY4PR11MB1320.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR11MB132098D8E47E38FD945E6398C5409@CY4PR11MB1320.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 03:10:51AM +0000, Zhou, Jie2X wrote:
> My error is  "Exception: Command failed: cat /sys/kernel/debug/netdevsim/netdevsim0//ports/0/dev/hwstats/l3/disable_ifindex"

This one is solved by the netdevsim patch ([2]).

> Do you get [1]error, after patch [2]?

Yes. Maybe you do not see it because you have an older bpftool without
"libbpf_strict" feature:

$ bpftool --version
bpftool v6.8.0
using libbpf v0.8
features: libbfd, libbpf_strict, skeletons

> [1]
> # bpftool prog load /home/idosch/code/linux/tools/testing/selftests/bpf/sample_ret0.o /sys/fs/bpf/nooffload type xdp
> Error: object file doesn't contain any bpf program
> Warning: bpftool is now running in libbpf strict mode and has more stringent requirements about BPF programs.
> If it used to work for this object file but now doesn't, see --legacy option for more details.
> 
> [2]
> diff --git a/drivers/net/netdevsim/hwstats.c b/drivers/net/netdevsim/hwstats.c
> index 605a38e16db0..0e58aa7f0374 100644
> --- a/drivers/net/netdevsim/hwstats.c
> +++ b/drivers/net/netdevsim/hwstats.c
> @@ -433,11 +433,11 @@ int nsim_dev_hwstats_init(struct nsim_dev *nsim_dev)
>                 goto err_remove_hwstats_recursive;
>         }
> 
> -       debugfs_create_file("enable_ifindex", 0600, hwstats->l3_ddir, hwstats,
> +       debugfs_create_file("enable_ifindex", 0200, hwstats->l3_ddir, hwstats,
>                             &nsim_dev_hwstats_l3_enable_fops.fops);
> -       debugfs_create_file("disable_ifindex", 0600, hwstats->l3_ddir, hwstats,
> +       debugfs_create_file("disable_ifindex", 0200, hwstats->l3_ddir, hwstats,
>                             &nsim_dev_hwstats_l3_disable_fops.fops);
> -       debugfs_create_file("fail_next_enable", 0600, hwstats->l3_ddir, hwstats,
> +       debugfs_create_file("fail_next_enable", 0200, hwstats->l3_ddir, hwstats,
>                             &nsim_dev_hwstats_l3_fail_fops.fops);
> 
>         INIT_DELAYED_WORK(&hwstats->traffic_dw,
