Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6232271F4
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 00:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgGTWDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 18:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgGTWDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 18:03:48 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1664DC061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 15:03:48 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d1so9344148plr.8
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 15:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V0iCeeBn/xMelvFGdtIIBtJ/o5/aaD9RE8EBgqxRkgA=;
        b=2Rf0bhhlUQW7lcvw2BhGFb24Z0q+GSPEmBcrloaWqV2XKjqi3MNXmxQGC2C8tvnGFi
         he8Wj3PuX7wH5i/cNJGvzpgDM92WEGdNur1uzLGdkDdqKdr5r6Dn/1I5yBlDWtg/B+da
         2Bl/oZzTrq+hE0MfDOIW9WTTy+Lc28h7nBLLoKCANLc1uurpH1ERqIKhvIDTma0T3lWs
         aT1wk3zkmIZeWKWUPmC2aJJM69Dd/JBlj1DDpY1flwXdcKjZzxntUMtjAoaXM5iTJ9Hr
         DlCRJGdLnxo6FVgGQTRDPqDvn1suDVewyuuW++NTDtBaaHzJhPGrNXsImeAGBJZOLeyG
         gBZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V0iCeeBn/xMelvFGdtIIBtJ/o5/aaD9RE8EBgqxRkgA=;
        b=P3Qj5Rrn8w0I+W5uOouF6vaWs7mZ9WReQahhGwYVIgwAQncTCJxDR7yqH1dYektUor
         AH/9OQbU6IYhGzpyAgsWiIV/CtSPI9DAkqIfdMEjkLEwatRgHwzHDTjMEfSZDynD4O+z
         6467S9H5hr/LOrngM4BQt5RGgUIdzozDqvgqleAQbLNudLx1BMgOWYob8i8uHKeNqAUi
         ZY0pPG8lbLq/wWBtc2EnvjjAHBk7JtArxKebPkq1bISMdLHEMvGKWrgKtxO4HK/WqvZK
         BoIx8e30YzIy6+VSupAsiLiFUrtMxEflyRW3WpdG+eAJYQfwPbmCxBxVnShJp5KdKn42
         4veA==
X-Gm-Message-State: AOAM530mQtZqX4+/5y6OqQdvX8Iu+CZYy4eKZbbVkEVnPFldJjtzDmDO
        NAYyMDpWOJLC60R/wRE3gVBStw==
X-Google-Smtp-Source: ABdhPJzewFnKnvI+s+d7y6HpfDRXSifUHEqqaaqW8XuhL1gMTKasYISMCGKsxfeBj/Z0shF+dZ/vdQ==
X-Received: by 2002:a17:90a:3523:: with SMTP id q32mr1298324pjb.185.1595282627317;
        Mon, 20 Jul 2020 15:03:47 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j3sm17309851pfe.102.2020.07.20.15.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 15:03:47 -0700 (PDT)
Date:   Mon, 20 Jul 2020 15:03:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "Sriram Krishnan (srirakr2)" <srirakr2@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "Malcolm Bumgardner (mbumgard)" <mbumgard@cisco.com>
Subject: Re: [PATCH v2] AF_PACKET doesnt strip VLAN information
Message-ID: <20200720150338.35e5e70e@hermes.lan>
In-Reply-To: <CA+FuTScwyB_xo0q+ZfihnQCfyVYy_zibg7Kx-QYEVbnauykKDQ@mail.gmail.com>
References: <20200718091732.8761-1-srirakr2@cisco.com>
        <CA+FuTSdfvctFD3AVMHzQV9efQERcKVE1TcYVD_T84eSgq9x4OA@mail.gmail.com>
        <CY4PR1101MB21013DCD55B754E29AF4A838907B0@CY4PR1101MB2101.namprd11.prod.outlook.com>
        <CAF=yD-+gCkPVkXwcH6KiKYGV77TvpZiDo=3YyXeuGFk=TR2dcw@mail.gmail.com>
        <20200720135650.1939665b@hermes.lan>
        <CA+FuTScwyB_xo0q+ZfihnQCfyVYy_zibg7Kx-QYEVbnauykKDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jul 2020 17:22:49 -0400
Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> On Mon, Jul 20, 2020 at 4:57 PM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Mon, 20 Jul 2020 09:52:27 -0400
> > Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> >  
> > > On Mon, Jul 20, 2020 at 12:27 AM Sriram Krishnan (srirakr2)
> > > <srirakr2@cisco.com> wrote:  
> > > >
> > > > +Stephen Hemminger
> > > >
> > > > Hi Willem,
> > > > Thanks for looking into the code, I understand that this is more of a generic problem wherein many of the filtering functions assume the vlan tag to be in the skb rather than in the packet. Hence we moved the fix from the driver to the common AF packet that our solution uses.
> > > >
> > > > I recall from the v1 of the patch you had mentioned other common areas where this fix might be relevant (such as tap/tun), but I'm afraid I cant comprehensively test those patches out. Please let me know your thoughts  
> > >
> > > Please use plain text to respond. HTML replies do not reach the list.
> > >
> > > Can you be more precise in which other code besides the hyper-v driver
> > > is affected? Do you have an example?
> > >
> > > This is a resubmit of the original patch. My previous
> > > questions/concerns remain valid:
> > >
> > > - if the function can now fail, all callers must be updated to detect
> > > and handle that
> > >
> > > - any solution should probably address all inputs into the tx path:
> > > packet sockets, tuntap, virtio-net
> > >
> > > - this only addresses packet sockets with ETH_P_ALL/ETH_P_NONE. Not
> > > sockets that set ETH_P_8021Q
> > >
> > > - which code in the transmit stack requires the tag to be in the skb,
> > > and does this problem after this patch still persist for Q-in-Q?  
> >
> > It matters because the problem is generic, not just to the netvsc driver.
> > For example, BPF programs and netfilter rules will see different packets
> > when send is through AF_PACKET than they would see for sends from the
> > kernel stack.
> >
> > Presenting uniform data to the lower layers makes sense.  
> 
> Are all forwarded and locally generated packets guaranteed to always
> have VLAN information in the tag (so that this is indeed only an issue
> with input from userspace, through tuntap, virtio and packet sockets)?
> 
> I guess the first might be assured due to this in __netif_receive_skb_core:
> 
>         if (skb->protocol == cpu_to_be16(ETH_P_8021Q) ||
>             skb->protocol == cpu_to_be16(ETH_P_8021AD)) {
>                 skb = skb_vlan_untag(skb);
>                 if (unlikely(!skb))
>                         goto out;
>         }
> 
> and the second by this in vlan_dev_hard_start_xmit:
> 
>         if (veth->h_vlan_proto != vlan->vlan_proto ||
>             vlan->flags & VLAN_FLAG_REORDER_HDR) {
>                 u16 vlan_tci;
>                 vlan_tci = vlan->vlan_id;
>                 vlan_tci |= vlan_dev_get_egress_qos_mask(dev, skb->priority);
>                 __vlan_hwaccel_put_tag(skb, vlan->vlan_proto, vlan_tci);
>         }
> 
> But I don't know this code very well, so that is based on a very
> cursory glance only. Might well be missing other paths. (update: I
> think pktgen is another example.)
> 
> Netfilter and BPF still need to handle tags in the packet for Q-in-Q,
> right? So does this actually simplify their logic?
> 
> If the above holds and Q-in-Q is not a problem, then doing the same on
> ingress from userspace may make sense. I don't know the kind of BPF
> or netfilter programs what would be affected, and how.
> 
> Then it would be good to all those inputs at once to really plug the hole.
> See also virtio_net_hdr_to_skb for another example of code that
> applies to all of tuntap, virtio, pf_packet and uml.


Older versions of Linux used to handle outer VLAN differentl
based on what the driver supported. It was a mess.
Some drivers and code paths would strip and put in meta-data, some
would leave it in skb data. But in recent (like 5 yrs), the kernel
has tried to be more uniform and only have vlan as skb tag.
It looks like AF_PACKET was overlooked at that time.
