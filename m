Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE6C1A88D1
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730702AbfIDOcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 10:32:33 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53266 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729809AbfIDOcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 10:32:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id q19so3584473wmc.3
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 07:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=THa8tcHpmGXEJKGCFwAm5Uk/uRFZwqU8Lnh8dAdqGFw=;
        b=qVJOu6386rZuyTtS1RXMfVDdnq3DajWXH/D2LyNgmy84Q0cYHVzcN3sxbDVpe0IviI
         9okn3vebMigGLU6vKsicy7dHYhtwJrkhg6JxEctN9o6LJlEZ0s4rezLGyatJp3MvdoWd
         DNQ5JM4hBAsGljbvQkVnAqUvhrnJ2npZnB89FzFIXN0f2mIehQs+J04zgAZQA33bOgY1
         pLu5AhaA72oEWk1KaumSvX80AckZJi4FBSO372g7EKeuGkUzYKYTx34r4W16GOMDy1/s
         /VgllY7E86rR1Nmv7udiEVU45+uNJ2L8DZ6DPQ5ABK97otpY+Nr4loZMz6PSlmHPhavX
         qbUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=THa8tcHpmGXEJKGCFwAm5Uk/uRFZwqU8Lnh8dAdqGFw=;
        b=AANgACXr3jeSOeLnyNeFlSUUQUZAFp3rugjxwlpD/ivd/8XHsHqHiOAmFMTVpIYF0F
         Y512JwwsPEbRrrD947PY6B1IVJC+xoRzYTTRjiOUB4opLWM6Ltj/8FUqkj+rebWne03+
         WKwdzBUz9WZ7U/LB6HZfj1PDTcFF/823lbE0RtjJALxM0NkchjGeZfrkIkk3e88e1tYf
         q+KU/9Fsa21Sye36kxtpxGWAGJfNywxLB+QapAg+ZELoY4i259rRyhuebzhLTa5FWQUw
         nBlUv9ImmSGP+Mfk5VZQVZK/E9hrm36jLUTaUuNzj8vGtGqE4QYjwWtSBVeobcDq5gt/
         /63g==
X-Gm-Message-State: APjAAAUBGa7IG456aU9eFp/9t03KOWP8aupwsTK/wYqN761H1OQ7QW5z
        /NA6ngKd3HJV0I+u9yqnqnQ=
X-Google-Smtp-Source: APXvYqzyw0MPGCNd++mOuBa8REAhRNC6dJpfnJfXHdFLYbnPFhu2UAYvHSYeUWoqOi/Su7m4WwZK2w==
X-Received: by 2002:a1c:f704:: with SMTP id v4mr4998945wmh.90.1567607549835;
        Wed, 04 Sep 2019 07:32:29 -0700 (PDT)
Received: from tycho (ipbcc09208.dynamic.kabel-deutschland.de. [188.192.146.8])
        by smtp.gmail.com with ESMTPSA id r28sm1016704wrr.94.2019.09.04.07.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 07:32:29 -0700 (PDT)
Date:   Wed, 4 Sep 2019 16:32:28 +0200
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     netdev@vger.kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jiri@resnulli.us, nikolay@cumulusnetworks.com,
        simon.horman@netronome.com, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org, jhs@mojatatu.com,
        dsahern@gmail.com, xiyou.wangcong@gmail.com,
        johannes@sipsolutions.net, alexei.starovoitov@gmail.com
Subject: Re: [Bridge] [PATCH v3 1/2] net: bridge: use mac_len in bridge
 forwarding
Message-ID: <20190904143227.5jpn2gnu3fed55wg@tycho>
References: <20190902181000.25638-1-zahari.doychev@linux.com>
 <76b7723b-68dd-0efc-9a93-0597e9d9b827@gmail.com>
 <20190903133635.siw6xcaqwk7m5a5a@tycho>
 <a9a093f2-1ec6-339c-b015-eb658618cf2b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9a093f2-1ec6-339c-b015-eb658618cf2b@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 04, 2019 at 04:14:28PM +0900, Toshiaki Makita wrote:
> On 2019/09/03 22:36, Zahari Doychev wrote:
> > On Tue, Sep 03, 2019 at 08:37:36PM +0900, Toshiaki Makita wrote:
> > > Hi Zahari,
> > > 
> > > Sorry for reviewing this late.
> > > 
> > > On 2019/09/03 3:09, Zahari Doychev wrote:
> > > ...
> > > > @@ -466,13 +466,14 @@ static bool __allowed_ingress(const struct net_bridge *br,
> > > >    		/* Tagged frame */
> > > >    		if (skb->vlan_proto != br->vlan_proto) {
> > > >    			/* Protocol-mismatch, empty out vlan_tci for new tag */
> > > > -			skb_push(skb, ETH_HLEN);
> > > > +			skb_push(skb, skb->mac_len);
> > > >    			skb = vlan_insert_tag_set_proto(skb, skb->vlan_proto,
> > > >    							skb_vlan_tag_get(skb));
> > > 
> > > I think we should insert vlan at skb->data, i.e. mac_header + mac_len, while this
> > > function inserts the tag at mac_header + ETH_HLEN which is not always the correct
> > > offset.
> > 
> > Maybe I am misunderstanding the concern here but this should make sure that
> > the VLAN tag from the skb is move back in the payload as the outer most tag.
> > So it should follow the ethernet header. It looks like this e.g.,:
> > 
> > VLAN1 in skb:
> > +------+------+-------+
> > | DMAC | SMAC | ETYPE |
> > +------+------+-------+
> > 
> > VLAN1 moved to payload:
> > +------+------+-------+-------+
> > | DMAC | SMAC | VLAN1 | ETYPE |
> > +------+------+-------+-------+
> > 
> > VLAN2 in skb:
> > +------+------+-------+-------+
> > | DMAC | SMAC | VLAN1 | ETYPE |
> > +------+------+-------+-------+
> > 
> > VLAN2 moved to payload:
> > 
> > +------+------+-------+-------+
> > | DMAC | SMAC | VLAN2 | VLAN1 | ....
> > +------+------+-------+-------+
> > 
> > Doing the skb push with mac_len makes sure that VLAN tag is inserted in the
> > correct offset. For mac_len == ETH_HLEN this does not change the current
> > behaviour.
> 
> Reordering VLAN headers here does not look correct to me. If skb->data points to ETH+VLAN,
> then we should insert the vlan at the offset.
> Vlan devices with reorder_hdr disabled produce packets whose mac_len includes ETH+VLAN header,
> and they expects vlan insertion after the outer vlan header.

I see so in this case we should handle differently as it seems sometimes
we have to insert after or before the tag in the packet. I am not quite sure
if this is possible to be detected here. I was trying to do bridging with VLAN
devices with reorder_hdr disabled working but somehow I was not able to get
mac_len longer then ETH_HLEN in all cases that I tried. Can you provide some
example how can I try this out? It will really help me to understand the
problem better.

> 
> Also I'm not sure there is standard ethernet header in mac_len, as mac_len is not ETH_HLEN.
> E.g. tun devices can produce vlan packets without ehternet header.

How is the bridge forwarding decision done in this case when there are no
MAC addresses, vlan based only?

> 
> > 
> > > 
> > > >    			if (unlikely(!skb))
> > > >    				return false;
> > > >    			skb_pull(skb, ETH_HLEN);
> > > 
> > > Now skb->data is mac_header + ETH_HLEN which would be broken when mac_len is not
> > > ETH_HLEN?
> > 
> > I thought it would be better to point in this case to the outer tag as otherwise
> > if mac_len is used the skb->data will point to the next tag which I find somehow
> > inconsistent or do you see some case where this can cause problems?
> 
> Vlan devices with reorder_hdr off will break because it relies on skb->data offset
> as I described in the previous discussion.

I also see in vlan_do_receive that the VLAN tag is moved to the payload when
reorder_hdr is off and the vlan_dev is not a bridge port. So it seems that
I am misunderstanding the reorder_hdr option so if you can give me some more
details about how it is supposed to be used will be highly appreciated.

Thanks
Zahari

> 
> Toshiaki Makita
