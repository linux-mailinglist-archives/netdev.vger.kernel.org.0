Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214053AE6C5
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 12:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhFUKMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 06:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhFUKMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 06:12:07 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1ABDC061574;
        Mon, 21 Jun 2021 03:09:52 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id g20so27901739ejt.0;
        Mon, 21 Jun 2021 03:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V2jT8puV4OZ+wc+RksUsJy6W4hsyAu8hadDI4bSM4kU=;
        b=W7nafuh9jA62KgRgR7Wjc0nejRWPU7vEML5l2HooMPML4AapCl67GUv26t8KAv+GN2
         6G6U0cOnN1lrzYzcdSZLJzevqECliU7vBXjMhCLDhqUJ9FLzzRgPW0TktyEnnbf2RpgT
         Owvo6rbV1VH6hSZbzjYhSB+OQt+6X6os46H2SJFrj3Y1NSLmS8bv4r8T0voNPCW3fHP0
         j5WfxcQ+8n7owZladcEJDaMyzsIyZfeSkUM5QuXOGzXjokD1mM23Gdii8JF9CH4YpiR5
         z/N7c4Li79dhBpS/gIwSfYYhYnaJ8XcujHzpadbB2mVHrj7kXuR/T5v+19bXKrqe8wwQ
         kDhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V2jT8puV4OZ+wc+RksUsJy6W4hsyAu8hadDI4bSM4kU=;
        b=ZZOkSOq2p1e+ps+10XlmQPTDSNY4jyZP7swC18XWJyxVw37s7fIosziXllw9BHAKVz
         PDgiScSjiyslJqTDQx2UV2Rv3mzwJFTgRW/EruIHUNdtXVC9tBKz0pBgv+OFMkxak+xa
         0mTqTjUbwEKDVg1nAcrXv10MET9VKvbDACW0Cg26ilNG2Q/7pAvCIoTkN3l5f4miHLix
         cxCsizfH/nGgJVf6AGV5omOcMAtzkZvj8o2EF1S8vbzfW4iMGvi+YWIUuR6YcQjbLMtS
         5PUfKO2q+Xg2OYUgZVrdiKOyX+j+ooJtBW0NdM0Vv56/67hzT+H8Ym8/8MuW2vouQxoL
         DgKw==
X-Gm-Message-State: AOAM532YI1dk/1fq9AbOSi6l0vU6hzzDKnVUwwdh8m7s1U05cqhQn4EC
        hcB/LaUd4TLxtMS2OR/yw7I=
X-Google-Smtp-Source: ABdhPJwXLJxdw/bSmhd7bXasPlmlGlclSG869VfOgQKGJL68OYLxpK2tP26i7wl0orh56HPcjOjQQw==
X-Received: by 2002:a17:906:8a71:: with SMTP id hy17mr15688656ejc.79.1624270191547;
        Mon, 21 Jun 2021 03:09:51 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id o4sm10104074edc.94.2021.06.21.03.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 03:09:51 -0700 (PDT)
Date:   Mon, 21 Jun 2021 13:09:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiri@resnulli.us, idosch@idosch.org, ilya.lifshits@broadcom.com
Subject: Re: [PATCH net-next] net/sched: cls_flower: fix resetting of ether
 proto mask
Message-ID: <20210621100949.dkzvv4mdgopcenab@skbuf>
References: <20210617161435.8853-1-vadym.kochan@plvision.eu>
 <20210617164155.li3fct6ad45a6j7h@skbuf>
 <20210617195102.h3bg6khvaogc2vwh@skbuf>
 <20210621083037.GA9665@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621083037.GA9665@builder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 11:32:27AM +0300, Boris Sukholitko wrote:
> On Thu, Jun 17, 2021 at 10:51:02PM +0300, Vladimir Oltean wrote:
> > On Thu, Jun 17, 2021 at 07:41:55PM +0300, Vladimir Oltean wrote:
> > > On Thu, Jun 17, 2021 at 07:14:35PM +0300, Vadym Kochan wrote:
> 
> [snip excellent problem analysis]
> 
> > So maybe it is the flow dissector we need to fix, to make it give us an
> > additional pure EtherType if asked for, make tc-flower use that
> > dissector key instead, and then revert Jamal's user space patch, and we
> > should all install our tc filters as:
> > 
> > tc filter add dev sw1p0 ingress handle 11 protocol all flower eth_type 0x8864 skip_hw action drop
> > 
> > ?
> 
> I like this solution. To be more explicit, the plan becomes:
> 
> 1. Add FLOW_DISSECTOR_KEY_ETH_TYPE and struct flow_dissector_key_eth_type.
> 2. Have skb flow dissector use it.
> 3. Userspace does not set TCA_FLOWER_KEY_ETH_TYPE automagically
>    anymore. cls_flower takes basic.n_proto from struct tcf_proto.
> 4. Add eth_type to the userspace and use it to set TCA_FLOWER_KEY_ETH_TYPE
> 5. Existence of TCA_FLOWER_KEY_ETH_TYPE triggers new eth_type dissector.
> 
> IMHO this neatly solves non-vlan protocol match case.
> 
> What should we do with the VLANs then? Should we have vlan_pure_ethtype
> and cvlan_pure_ethtype as additional keys?

Yeah, I don't know about the "_pure_" part (the current name of the
options in tc user space seems fine), but the flow dissector should have
some parsing keys for the C-VLAN and S-VLAN EthType too, since the
FLOW_DISSECTOR_KEY_ETH_TYPE should match on, well, the EtherType.

> > 
> > Or maybe just be like you, say I don't care about any of that, I just
> > want it to behave as before, and simply revert Boris's patch. Ok, maybe
> 
> FTR I fully support reverting the patch. Please accept my apologies for
> breaking the HW offload and big thanks to Vadym for finding it.
> 
> I will send the revert shortly.
> 
> Thanks,
> Boris.

Thanks.

Please note that I haven't used tc for long enough to know what changes
are for its own good, so there is still place for expert feedback from
the maintainers, but this solution seems common sense to me.
