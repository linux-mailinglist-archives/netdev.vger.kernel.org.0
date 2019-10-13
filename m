Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63ECD5899
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 00:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbfJMWWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 18:22:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728762AbfJMWWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Oct 2019 18:22:37 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9D4E2C04B940
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 22:22:36 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id r21so3803629wme.5
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 15:22:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wczdf/4fSdwa4OFkIAn/TtpvT6XHwOtJAf+SdUmyze0=;
        b=cHShk2IHqDX3WG6gWd37Gcs97mwmqsJSnzUATzR+LpMu+tb7aEmo1q7QYTi18IfDe1
         GoG68Hvl0PUAPQ31LwCTNfaW7phdw6mGOd6hM3AIPGOf8jCaFMnyGT/lwnNvgJd/1wyS
         9hlktnC3ioj+lPb9dNioLg/AB2x/dPJARekaUdab0umjHT8JM8THkuNgerp8gvAP/ZR3
         6E9/hn+LvI4Lo7R8sb34CNa9n4r3DgmKVFjDKr6BtPcYK1haZRDuuSfsO1nTBgqnhdel
         0mANFdf9rE2CuIZKjS1P7B+ig7wI8WZh/0hDLAIVeJg6K04dJBCgtvVr+PaO208C1CNW
         tYlA==
X-Gm-Message-State: APjAAAVJvhQN0+FhsXSCLMvOwSOz6AmpJemPxZRCyMn1o3FLP9qQjLm1
        buR4TfUr2ieSD2NeaisPkg5eYENh9YmZRXWDWTu/mrFQXV8lyq4a5n9kZXwrPc02UIGnheZY/zs
        EgGpAP9QlQe94l3Og
X-Received: by 2002:a5d:46c6:: with SMTP id g6mr6892679wrs.331.1571005355379;
        Sun, 13 Oct 2019 15:22:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyHssWTLLT5HHTAk+NA640iffTQFPwDghRDACIlvOaUwvz4v51xvU7z8fPvLmb1lO7GiDxa3g==
X-Received: by 2002:a5d:46c6:: with SMTP id g6mr6892668wrs.331.1571005355180;
        Sun, 13 Oct 2019 15:22:35 -0700 (PDT)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id p85sm22358008wme.23.2019.10.13.15.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 15:22:34 -0700 (PDT)
Date:   Mon, 14 Oct 2019 00:22:31 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Jesse Gross <jesse@nicira.com>,
        Pravin B Shelar <pshelar@nicira.com>,
        Jiri Benc <jbenc@redhat.com>
Subject: Re: [RFC PATCH net] netns: fix GFP flags in rtnl_net_notifyid()
Message-ID: <20191013222231.GA4647@linux.home>
References: <41b3fbfe3aac5ca03f4af0f1c4e146ae67c20570.1570734410.git.gnault@redhat.com>
 <CAOrHB_Dfoy3hiVVWu7+4fgm_U+rcB_CPuRV58XqB7kKOBcGb1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_Dfoy3hiVVWu7+4fgm_U+rcB_CPuRV58XqB7kKOBcGb1w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 13, 2019 at 12:09:43PM -0700, Pravin Shelar wrote:
> On Thu, Oct 10, 2019 at 12:07 PM Guillaume Nault <gnault@redhat.com> wrote:
> >
> > In rtnl_net_notifyid(), we certainly can't pass a null GFP flag to
> > rtnl_notify(). A GFP_KERNEL flag would be fine in most circumstances,
> > but there are a few paths calling rtnl_net_notifyid() from atomic
> > context or from RCU critical section. The later also precludes the use
> > of gfp_any() as it wouldn't detect the RCU case. Also, the nlmsg_new()
> > call is wrong too, as it uses GFP_KERNEL unconditionally.
> >
> > Therefore, we need to pass the GFP flags as parameter. The problem then
> > propagates recursively to the callers until the proper flags can be
> > determined. The problematic call chains are:
> >
> >  * ovs_vport_cmd_fill_info -> peernet2id_alloc -> rtnl_net_notifyid
> >
> >  * rtnl_fill_ifinfo -> rtnl_fill_link_netnsid -> peernet2id_alloc
> >  -> rtnl_net_notifyid
> >
> > For openvswitch, ovs_vport_cmd_get() and ovs_vport_cmd_dump() prevent
> > ovs_vport_cmd_fill_info() from using GFP_KERNEL. It'd be nice to move
> > the call out of the RCU critical sections, but struct vport doesn't
> > have a reference counter, so that'd probably require taking the ovs
> > lock. Also, I don't get why ovs_vport_cmd_build_info() used GFP_ATOMIC
> > in nlmsg_new(). I've changed it to GFP_KERNEL for consistency, as this
> > functions seems to be allowed to sleep (as stated in the comment, it's
> > called from a workqueue, under the protection of a mutex).
> >
> It is safe to change GFP flags to GFP_KERNEL in ovs_vport_cmd_build_info().
> The patch looks good to me.
> 
Thanks for your feedback.

The point of my RFC is to know if it's possible to avoid all these
gfp_t flags, by allowing ovs_vport_cmd_fill_info() to sleep (at least
I'd like to figure out if it's worth spending time investigating this
path).

To do so, we'd requires moving the ovs_vport_cmd_fill_info() call of
ovs_vport_cmd_{get,dump}() out of RCU critical section. Since we have
no reference counter, I believe we'd have to protect these calls with
ovs_lock() instead of RCU. Is that acceptable? If not, is there any
other way?
