Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 688C3117E36
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 04:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfLJDhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 22:37:09 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43629 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfLJDhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 22:37:08 -0500
Received: by mail-pl1-f196.google.com with SMTP id q16so6684153plr.10
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 19:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CGQlTdqgOaDc+KYgMDXh2pB8hQnGtUbbHPNKlM2m9nY=;
        b=Mzsy9ktjd58+coyDOHSXQVYWjvNa9pLf2CjNIZc80QJoJyxmVdFqU/InpXoKFXwsBE
         nTw1mVgDlzpAdi9Qifb0OKTxT2hZmEk9xxowfZgprnvUaRzggDobYGwGPC8V/hFZ3w3B
         JyFLPO5LLAWUZnFH2cxZjDloeq0cxucFT4RbewS0dNNcrZ5kBmlC4erWVKfp1QSTVLyn
         aF4q5NwKUzFDLyQTrVrprQgvWg2g/NeMoEcCPrFLyzPA34vDeutxJnVSWxKkiqurlqVG
         G0995OJRezEzwVnZUVW1bybbgbffxo+NXGBA2/323KVMBceIDJRL+BsJiYNmdjNFAQsG
         npSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CGQlTdqgOaDc+KYgMDXh2pB8hQnGtUbbHPNKlM2m9nY=;
        b=CpT6NXgpJfm2HjbjvWU7Z7SMoZztVQI+AkovYXH+SkHYwSBEBgxcmKniRxk9ZArQyY
         esYShCgmgzAL6aiS3zR+dY/AUw62E2kNasV2vkSzPEimNWDaxCR9qbjxPTTH2gIKEMxl
         Kfz7xXciAyIJgPF+oqSiJp/HyOkba4mZ64v1WCByQElf3hNzyu5T81jhaV8SieLRd9nN
         ls+a+8x9TGH/Q0Zfc9Ze378toDXBS+e0C6xQbsfmTaqHFGh8xj3Hz9lHawd5T4wkTsTO
         T0tQ8gZ9wugSf165PPeZO82ViRKTVyBRfWSR8OYXyv3Cqmgg1FvXUfH7YZ+a2ErdZDzm
         5h2g==
X-Gm-Message-State: APjAAAWcYghVRayvawFKJOv+KCijiLIX4Zv+QdaFd6jmNdn4iEf8CifC
        NklPfylp3ENdZxmCPLaK54I=
X-Google-Smtp-Source: APXvYqzmggTfMl8cpM35mpoHJTem05dKfoWi6JbSIAobEq4fDHnxiMKpKv7DavRDDKZW9WkweQhRuA==
X-Received: by 2002:a17:902:744c:: with SMTP id e12mr34011396plt.14.1575949027502;
        Mon, 09 Dec 2019 19:37:07 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x4sm952874pfx.68.2019.12.09.19.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 19:37:06 -0800 (PST)
Date:   Tue, 10 Dec 2019 11:36:56 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, ja@ssi.bg, marcelo.leitner@gmail.com,
        dsahern@gmail.com, edumazet@google.com,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: [PATCHv2 net] ipv6/route: should not update neigh confirm time
 during PMTU update
Message-ID: <20191210033656.GM18865@dhcp-12-139.nay.redhat.com>
References: <20191202.184704.723174427717421022.davem@davemloft.net>
 <20191203101536.GJ18865@dhcp-12-139.nay.redhat.com>
 <20191203102534.GK18865@dhcp-12-139.nay.redhat.com>
 <20191203.115818.1902434596879929857.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203.115818.1902434596879929857.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Sorry for the late reply. Hope you still have impression for this discussion.
I discussed this issue with my colleagues offline and I still have some questions.
Please see comments below.

On Tue, Dec 03, 2019 at 11:58:18AM -0800, David Miller wrote:
> >> > That's not what I said.
> >> > 
> >> > I said that this interface is designed for situations where the neigh
> >> > update is appropriate, and that's what happens for most callers _except_
> >> > these tunnel cases.
> >> > 
> >> > The tunnel use is the exception and invoking the interface
> >> > inappropriately.
> >> > 
> >> > It is important to keep the neigh reachability fresh for TCP flows so
> >> > you cannot remove this dst_confirm_neigh() call.

The first is why IPv4 don't need this neigh update. I didn't
find dst_confirm_neigh() or ipv4_confirm_neigh() in ip_rt_update_pmtu()

> > 
> > I have one question here. Since we have the .confirm_neigh fuction in
> > struct dst_ops. How about do a dst->ops->confirm_neigh() separately after
> > dst->ops->update_pmtu()? Why should we mix the confirm_neigh() in
> > update_pmtu(), like ip6_rt_update_pmtu()?
> 
> Two indirect calls which have high cost due to spectre mitigation?

Guillaume pointed me that dst_confirm_neigh() is also a indriect call.
So it should take same cost to call dst_confirm_neigh() in or before
__ip6_rt_update_pmtu(). If they are the same cose, I think there would
have two fixes.

1. Add a new parameter 'bool confirm_neigh' to __ip6_rt_update_pmtu(),
update struct dst_ops.update_mtu and all functions who called it.

2. Move dst_confirm_neigh() out of __ip6_rt_update_pmtu() and only call it
   in fuctions who need it, like inet6_csk_update_pmtu().

What do you think? Please tell me if I missed something.

Regards
Hangbin
