Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E5F2D9568
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 10:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgLNJmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 04:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728222AbgLNJmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 04:42:06 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07194C0613CF
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 01:41:26 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id l11so28529622lfg.0
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 01:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=dyuccDsKOfMrxzp502AlkvY5Xfm4pb5LGNmsaWtkd7g=;
        b=nm2a634ax7wP3+ab5VOtE6xpZEVk2c2ounSVHzZjULC8J4d1meLLYqvBMPKyWCqBI1
         oyYJ37wa3Eh4hqwbsgzUo1AVD5VDHRHT9prdDAp9OS72NEZIDNhcHRDEYhNdfn9OsoNU
         Cpd817xICAJBQKumLfzLC4ZGLe6ZuB31RJPetXh9kYebsvwAvbVhLvthl4lJrFliZEHR
         UeTjLYiisto5eF+fgD0d7Mfl/FjdUkrBqUhFRWJB38jZc4ev5RiIn+ysxF+sqFAee4DR
         ZSBa5Sd9UrV30grraWPb8TVLnDZvUzVz9ZJOFG4+DlkUhw6jIi7RUf2/iFC9IIIcnRZ5
         4ayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dyuccDsKOfMrxzp502AlkvY5Xfm4pb5LGNmsaWtkd7g=;
        b=cBjuyw61XFoiev1+b6dmyO4dgvjAJrWUpcyRFFcKpuBa9rgzgjWBqYgeaNHqArbPQD
         aKtNxhW9fBl/nekmgRJVGqNxeEiX2qsJGfBIefqHKuBPcUuI9Fa5VIUFmkfojB0baKtI
         ASxvYZ3V+TLEAld/F1R0VPmwZm3RIqOZQpyny/neCdlOeVlrLbgg8eho0XU894WGPylK
         0r1+tx3nWCF+Hw71OW63XAt1mO9f835wZpT0v2tm05IIilFNMbUJ/f0gaz9WoOwlSG8n
         E/ypCDizjNrbxUzK41508f6i2VWBVpbA8nJZraQ/lGVWDwo+XfEjxN35+gBkq9r0oOXe
         T7vQ==
X-Gm-Message-State: AOAM531QvzqOln93RFxavML9tFbBjB8+0+coBHIVEgTA19Scml8F/O4E
        bSmneUNMlqCrI3f3PbimpdQVGIbwCEgTMr9q
X-Google-Smtp-Source: ABdhPJzVqykdz2bwQwPppKJFpthDT/nCNaSpSTin1WowBzajo357vZH0h5jYNkP9T2BZFCua5Aw7zA==
X-Received: by 2002:a19:f11e:: with SMTP id p30mr8909412lfh.395.1607938884110;
        Mon, 14 Dec 2020 01:41:24 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w20sm1494725lfe.93.2020.12.14.01.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 01:41:23 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <878sa1h0bg.fsf@waldekranz.com>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201208112350.kuvlaxqto37igczk@skbuf> <87a6uk5apb.fsf@waldekranz.com> <20201212142622.diijil65gjkxde4n@skbuf> <878sa1h0bg.fsf@waldekranz.com>
Date:   Mon, 14 Dec 2020 10:41:22 +0100
Message-ID: <875z54hghp.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 22:18, Tobias Waldekranz <tobias@waldekranz.com> wrote:
> On Sat, Dec 12, 2020 at 16:26, Vladimir Oltean <olteanv@gmail.com> wrote:
>> On Fri, Dec 11, 2020 at 09:50:24PM +0100, Tobias Waldekranz wrote:
>>> 2. The issue Vladimir mentioned above. This is also a straight forward
>>>    fix, I have patch for tag_dsa, making sure that offload_fwd_mark is
>>>    never set for ports in standalone mode.
>>>
>>>    I am not sure if I should solve it like that or if we should just
>>>    clear the mark in dsa_switch_rcv if the dp does not have a
>>>    bridge_dev. I know both Vladimir and I were leaning towards each
>>>    tagger solving it internally. But looking at the code, I get the
>>>    feeling that all taggers will end up copying the same block of code
>>>    anyway. What do you think?
>>
>> I am not sure what constitutes a good separation between DSA and taggers
>> here. We have many taggers that just set skb->offload_fwd_mark = 1. We
>> could have this as an opportunity to even let DSA take the decision
>> altogether. What do you say if we stop setting skb->offload_fwd_mark
>> from taggers, just add this:
>>
>> +#define DSA_SKB_TRAPPED	BIT(0)
>> +
>>  struct dsa_skb_cb {
>>  	struct sk_buff *clone;
>> +	unsigned long flags;
>>  };
>>
>> and basically just reverse the logic. Make taggers just assign this flag
>> for packets which are known to have reached software via data or control
>> traps. Don't make the taggers set skb->offload_fwd_mark = 1 if they
>> don't need to. Let DSA take that decision upon a more complex thought
>> process, which looks at DSA_SKB_CB(skb)->flags & DSA_SKB_TRAPPED too,
>> among other things.
>
> What would the benefit of this over using the OFM directly? Would the
> flag not carry the exact same bit of information, albeit inverted? Is it
> about not giving the taggers any illusions about having the final say on
> the OFM value?

On second thought, does this even matter if we solve the issue with
properly separating the different L2 domains? I.e. in this setup:

      br0
     /   \
  team0   \
   / \     \
swp0 swp1 swp2

If team0 is not offloaded, and our new fancy ndo were to relay that to
the bridge, then team0 and swp2 would no longer share OFM. In that case
traffic will flow between them indepent of OFM, just like it would
between ports from two different switchdevs.

With that in mind, I will leave this patch out of v4 as case (A) works
without it, and including it does not solve (B). I suppose there could
be other reasons to accurately convey the OFM in these cases, but I
think we can revisit that once everything else is in place.

>>> As for this series, my intention is to make sure that (A) works as
>>> intended, leaving (B) for another day. Does that seem reasonable?
>>>
>>> NOTE: In the offloaded case, (B) will of course also be supported.
>>
>> Yeah, ok, one can already tell that the way I've tested this setup was
>> by commenting out skb->offload_fwd_mark = 1 altogether. It seems ok to
>> postpone this a bit.
>>
>> For what it's worth, in the giant "RX filtering for DSA switches" fiasco
>> https://patchwork.ozlabs.org/project/netdev/patch/20200521211036.668624-11-olteanv@gmail.com/
>> we seemed to reach the conclusion that it would be ok to add a new NDO
>> answering the question "can this interface do forwarding in hardware
>> towards this other interface". We can probably start with the question
>> being asked for L2 forwarding only.
>
> Very interesting, though I did not completely understand the VXLAN
> scenario laid out in that thread. I understand that OFM can not be 0,
> because you might have successfully forwarded to some destinations. But
> setting it to 1 does not smell right either. OFM=1 means "this has
> already been forwarded according to your current configuration" which is
> not completely true in this case. This is something in the middle, more
> like skb->offload_fwd_mark = its_complicated;
>
> Anyway, so we are essentially talking about replacing the question "do
> you share a parent with this netdev?" with "do you share the same
> hardware bridging domain as this netdev?" when choosing the port's OFM
> in a bridge, correct? If so, great, that would also solve the software
> LAG case. This would also get us one step closer to selectively
> disabling bridge offloading on a switchdev port.
