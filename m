Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3173C5AE8
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbhGLKsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 06:48:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50121 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233095AbhGLKsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 06:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626086719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vD/7oIR83LoencqbZJUI7JRLQahbk/f1HBWavcAemOg=;
        b=HgPs7fR5kNKsNBARU9zcBQZCNALD51F1lhqpcdLat4l8rjZK1cPzXBld+CWeeSAIMPPW/L
        AucGIatnXu2oVojiUXeUoMAmS0TxjdgveMSavdwm8HVNfvE2IBiegMpD9syQKUxjBTHXDD
        +ZK155doe/CDH9ciGbdj3/W3Q463zbw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-4KMHC5ywPEGX6tuQ_8TO_w-1; Mon, 12 Jul 2021 06:45:15 -0400
X-MC-Unique: 4KMHC5ywPEGX6tuQ_8TO_w-1
Received: by mail-wr1-f71.google.com with SMTP id 32-20020adf82a30000b029013b21c75294so5758819wrc.14
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 03:45:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vD/7oIR83LoencqbZJUI7JRLQahbk/f1HBWavcAemOg=;
        b=INGCLamxuV8p+YXuVh9yMiTcfXUvkuoRsY+8FMbjkuJXnNeVezS2ODNErRxtJPE+iI
         In6cpxCjCTHHLYpZS1ek+2Y/7qt9fmbpoa9j7WzcvTNFrbMyMEeh5LblmAOUx1yY5kVw
         qarFq9ipu3t1LLQcQDXFCiivcyScFkDp2TbuEEzqHk+nMrFn4DouZDbC6zdc7cXgpxb4
         9Br7A/FTdf7IgYQsG15W9nHSGu1nxx7uSkm8Y49w5zMxVzUyTqm5272GDvQ94SHo3dvs
         LETvW7eizy7VBP1CvuMpVGvgGQzIt/ske0wO1+CiOYzcIgShI+njZX14qrYL3WygPDx8
         jR4Q==
X-Gm-Message-State: AOAM531PynEhOKJTZrQYv1PTT5xCrk3JziIpsOTLVDhgIUT9VPTM+515
        BDRm25RYad/Eh1P/ylbPUaZdScwsI/JwmUl9sVO2VPZCISF5XcFlIvR19+4NTfi127catoJc2c4
        znfKLK41r7uP3EqYS
X-Received: by 2002:a05:600c:17c3:: with SMTP id y3mr53350400wmo.40.1626086714719;
        Mon, 12 Jul 2021 03:45:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkcqstZrs7fO7b/Il4nlF1HkQIoPsKlDWfbXMwAe+89ztS9WSbUC8XPbhXsc1ZiaFv019Z/A==
X-Received: by 2002:a05:600c:17c3:: with SMTP id y3mr53350378wmo.40.1626086714525;
        Mon, 12 Jul 2021 03:45:14 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id n23sm4949382wmc.38.2021.07.12.03.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 03:45:14 -0700 (PDT)
Message-ID: <26432bbc3556fd23bd58f6d359395e5dfa2eaf8c.camel@redhat.com>
Subject: Re: [RFC PATCH 1/3] veth: implement support for set_channel ethtool
 op
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        toke@redhat.com
Date:   Mon, 12 Jul 2021 12:45:13 +0200
In-Reply-To: <f99875f7-c8c2-7a33-781c-a131d4b35273@gmail.com>
References: <cover.1625823139.git.pabeni@redhat.com>
         <681c32be3a9172e9468893a89fb928b46c5c5ee6.1625823139.git.pabeni@redhat.com>
         <20210709125431.3597a126@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <f99875f7-c8c2-7a33-781c-a131d4b35273@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, 2021-07-11 at 19:44 -0600, David Ahern wrote:
> On 7/9/21 1:54 PM, Jakub Kicinski wrote:
> > On Fri,  9 Jul 2021 11:39:48 +0200 Paolo Abeni wrote:
> > > +	/* accept changes only on rx/tx */
> > > +	if (ch->combined_count != min(dev->real_num_rx_queues, dev->real_num_tx_queues))
> > > +		return -EINVAL;
> > 
> > Ah damn, I must have missed the get_channels being added. I believe the
> > correct interpretation of the params is rx means NAPI with just Rx
> > queue(s), tx NAPI with just Tx queue(s) and combined has both.
> > IOW combined != min(rx, tx).
> > Instead real_rx = combined + rx; real_tx = combined + tx.
> > Can we still change this?
> 
> Is it not an 'either' / 'or' situation? ie., you can either control the
> number of Rx and Tx queues or you control the combined value but not
> both. That is what I recall from nics (e.g., ConnectX).

Thanks for the feedback. My understanding was quite alike what David
stated - and indeed that is what ConnectX enforces AFAICS. Anyhow the
core ethtool code allows for what Jackub said, so I guess I need to
deal with that.

@Jakub: if we are still on time about changing the veth_get_channel()
exposed behaviour, what about just showing nr combined == 0 and
enforcing comined_max == 0? that would both describe more closely the
veth architecture and will make the code simpler - beyond fixing the
current uncorrect nr channels report.

Thanks!

Paolo

