Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03FE24240D
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 04:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgHLC2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 22:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgHLC2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 22:28:40 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DE2C06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 19:28:40 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u128so251067pfb.6
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 19:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S9ZauU+MArtzbG+Sd73d7Cd6m9Q7FB+/474WYky2Mt0=;
        b=Ir57dIQjZ9P/kaDW47PxFHfXhKejFwHxDIiZBZX2X+1xPCXldbdikLiQjYxMWGJwe9
         9Jmf+o+2GcsSjoX9oz6B3dAXqsPR5KWv12r5j8KcE1kBleh1JzQ4c1GWHRhLc04dmIsr
         nXfJo68XG8ngX+bZYodRFV/rvQ2YMEhQf0uDlGGWb8bVAZTZe7WHgLbf1h8UD7qkAPOR
         WnDajY91XzYrYGRKo1ihVlOVUh1bvsPAOtUY15eI1syvmfqG7GI5pT1khtleUjy8ScjS
         3HYF8YV4ekniB69tYT2Vx5nAQcy7VR3rYHLMBU51rNyN/n//8bDIKN+kNzJzc5N7DoTS
         8/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S9ZauU+MArtzbG+Sd73d7Cd6m9Q7FB+/474WYky2Mt0=;
        b=r+8dAKPyOTuf0MHS/D4G7Et1iTEePADxkMH16Xh5XFqwME66LurL2FUwoxB/9DOwDD
         2W8hd6CKNiXQ/OjMmTAl/G7qGPTi6cgAhRcwg01Xg1B6qiGTPXqNtkzIlwV0ooJJb6Ek
         uJzJh6UTcANnStl62spUOSjNtDj9b0VfuqEs1rcRN8s41K2BSU/i8s2jV6+irYsbiMxp
         /tSmi/yHsHJZ2pnQKoyxNK8ECIk4dYcfjhfcgbfsUdUijDdGkoIhTn/ay3A1LD9EM4zQ
         FVzJllJlu+cQbHuHiTksT4Q9TCIUNvmwcurRtTKh4VyM5PUL/dybk7NHytbS+GSVUqLu
         Q+3w==
X-Gm-Message-State: AOAM531/wIMsp/CqrR0OM2kTjYengAV0rUo5op5wvUkREHEvNY9eCIyJ
        hXP8sBMfi/LlRLHztsY0uiI=
X-Google-Smtp-Source: ABdhPJylqwzEWtffaPjbjHIw+4D7jdtcMBs2yxPDB2ySmPUSaW4gonHF08sBnnhRNMrrnzgQuX9kfw==
X-Received: by 2002:a62:7705:: with SMTP id s5mr8675262pfc.52.1597199319809;
        Tue, 11 Aug 2020 19:28:39 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 124sm443604pfb.19.2020.08.11.19.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 19:28:39 -0700 (PDT)
Date:   Wed, 12 Aug 2020 10:28:29 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     gnault@redhat.com, netdev@vger.kernel.org, pmachata@gmail.com,
        roopa@cumulusnetworks.com, dsahern@kernel.org, akaris@redhat.com
Subject: Re: [PATCH net] Revert "vxlan: fix tos value before xmit"
Message-ID: <20200812022829.GP2531@dhcp-12-153.nay.redhat.com>
References: <20200805101807.GN2531@dhcp-12-153.nay.redhat.com>
 <20200805.121110.1918790855908756881.davem@davemloft.net>
 <20200806025241.GO2531@dhcp-12-153.nay.redhat.com>
 <20200811.170223.1397578654908672695.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811.170223.1397578654908672695.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 05:02:23PM -0700, David Miller wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> Date: Thu, 6 Aug 2020 10:52:41 +0800
> 
> > The rough steps are setting vxlan tunnel on OVS. set inner packet tos to
> > 1011 1010 (0xba) and outer vxlan to 1111 1100(0xfc). The outer packet's tos
> > should be 0xfe at latest as it inherit the inner ECN bit. But with RT_TOS(tos)
> > We actually got tos 0x1e as the first 3 bits are omitted.
> > 
> > Now here is detailed testing steps:
> 
> This explains why we need to revert the RT_TOS() change.
> 
> I'm asking what testing you did on the original change that added
> RT_TOS(), which we reverted, and which didn't fix anything.

Oh, I know what you mean now.
> 
> I want to know how we got into this situation in the first place,
> adding a change that only added negative effects.

The reason is still based on the definition of RT_TOS. I have a report
about the difference tos action between geneve and vxlan.

For geneve:

geneve_get_v4_rt()
  - fl4->flowi4_tos = RT_TOS(tos);
geneve_xmit_skb()
  - tos = ip_tunnel_ecn_encap(fl4.flowi4_tos, ip_hdr(skb), skb);

For vxlan:

vxlan_xmit_one()
  - tos = ip_tunnel_ecn_encap(tos, old_iph, skb);

So geneve will use RT_TOS(tos) when xmit, while vxlan will take all tos bits.
At that time I only read the code and thought we should obey the RT_TOS rule,
So I submit the previous patch.

Later Petr Machata remind me that we need to take care of DSCP fields. So I
asked you if we should change RT_TOS() to DSCP_TOS()[1]. You replied

"""
The RT_TOS() value elides the two lowest bits so that we can store other
pieces of binary state into those two lower bits.

So you can't just blindly change the RT_TOS() definition without breaking
a bunch of things.
"""

I'm sorry I didn't take more time to think about the your reply and just
give up my thoughts. Since we bring up this topic again. Would you please
help explain about what "The RT_TOS() value elides the two lowest bits"
means? I'm not sure if you are talking about ECN or not.

[1] https://www.spinics.net/lists/netdev/msg631249.html

Thanks
Hangbin
