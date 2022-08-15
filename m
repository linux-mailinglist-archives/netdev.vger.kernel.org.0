Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BF95951BD
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 07:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbiHPFNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 01:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbiHPFNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 01:13:20 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E10F9953;
        Mon, 15 Aug 2022 14:28:44 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id CFB323200488;
        Mon, 15 Aug 2022 17:28:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 15 Aug 2022 17:28:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1660598921; x=1660685321; bh=TG6h01Br37
        C4F3jMCzgHNyxb/LAU3CF9cYEYzRCIsQI=; b=yvn6DXBfwxjXrtC+Te4D/kWHmC
        8tpQP1Oy6qo8wuY0MkPzKpaF7EClUYOUG59BtsYm9ZfRvBSquvXdy5mfZHcYhbmZ
        dP6H7EkjwhjI6HakI4aJmwyyc9vuDFCKPp3yQwLJbhvTR6BhjHIDdcIcNpxVbSyn
        0JNdwCzxF2sFLbKdcBtr/yHOSgOmVMVhE43sTlhYdEMAdz6Y3M03RmOJ2I1VUs3e
        oTWR8JQxIMFyIK5Ksn7hSfygYEwXjhcbrHkXQQ/n+IREXnT6LDfA6hqL3xuf8SHY
        +vHBwry8olWA8pGFxTPSq7htrRf4309y7TiZbBg5oqkJXhp1suGpdKndWyPg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660598921; x=1660685321; bh=TG6h01Br37C4F3jMCzgHNyxb/LAU
        3CF9cYEYzRCIsQI=; b=aL+giPBMZwPuKrh+P+nNenINh0up9FTNUwrC7DJ+9PoQ
        MY1M4lduN925t5IqjR1tllocqr3tgPgU2k8W1s//wroofSSjFq7moupvxizJ6R2k
        tZ+ZOSlm+Bb0E8xvjVx+FsicYw8+GtNNNpkKCfU/NSmxuvA0w/arFA8pMS5JZHZI
        FNG8FzBvE9Md5MJDSloBFcjrY7GSgttKQ01G4TLUNKtFFclR35+4LtvwLntizBb7
        PP3fWCE+T/x+JgvYCvWqdjY6NH/WLrNoQ2U8MD/J6cxUy7j2JJkzX67dCYURTtWc
        uYtxpCx6mvy2LSmxrsD5EZCCdFbQ69TD5nYgRhX5aQ==
X-ME-Sender: <xms:iLr6Yg2uEn8EOWZu5l2Bn_cu_LbsPMC8ffavd88zftdvJb_yoF5vxQ>
    <xme:iLr6YrHlReUxZmOT2ApQD-MciDV-BpW6pIASajOYBuLPd54kSv_-iBV91pYPjqU8B
    _w2mK2MBeI12BkWhA>
X-ME-Received: <xmr:iLr6Yo4qrJ88Us5p4mkQflTVPm7FxxgbW646IEXYOWWXCRq0rwTHc_yGYIfYaNnmdKKww-45Pfbgc7IsU3RtPf_p4_fbAxQx6iAWoxoW4JeB9HyCeEV58aiTCLuO>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehvddgudeifecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgu
    rhgvshcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtf
    frrghtthgvrhhnpedvffefvefhteevffegieetfefhtddvffejvefhueetgeeludehteev
    udeitedtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:iLr6Yp0eVU7NJnUaOkwKOG7xyKFFsYMmfMCXZCuua0Az-YFL6n-8vw>
    <xmx:iLr6YjHbvm6TWLpU6LIOqcwtEt2dTTPvg5uBsCyjcQXJo6KmPEZagQ>
    <xmx:iLr6Yi_2Q7BtpolFX4o5wGQD6pwhUfS-dotaJo39PY8Ln9UfYRRKnQ>
    <xmx:ibr6YtECLURIjGEkwZ2IMpYCf9iR1YGYoQninic5ysNhbiJCLqT8Bg>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 17:28:40 -0400 (EDT)
Date:   Mon, 15 Aug 2022 14:28:39 -0700
From:   Andres Freund <andres@anarazel.de>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, c@redhat.com
Subject: Re: [PATCH] virtio_net: Revert "virtio_net: set the default max ring
 size by find_vqs()"
Message-ID: <20220815212839.aop6wwx4fkngihbf@awork3.anarazel.de>
References: <20220815090521.127607-1-mst@redhat.com>
 <20220815203426.GA509309@roeck-us.net>
 <20220815164013-mutt-send-email-mst@kernel.org>
 <20220815205053.GD509309@roeck-us.net>
 <20220815165608-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815165608-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022-08-15 17:04:10 -0400, Michael S. Tsirkin wrote:
> So virtio has a queue_size register. When read, it will give you
> originally the maximum queue size. Normally we just read it and
> use it as queue size.
> 
> However, when queue memory allocation fails, and unconditionally with a
> network device with the problematic patch, driver is asking the
> hypervisor to make the ring smaller by writing a smaller value into this
> register.
> 
> I suspect that what happens is hypervisor still uses the original value
> somewhere.

It looks more like the host is never told about the changed size for legacy
devices...

Indeed, adding a vp_legacy_set_queue_size() & call to it to setup_vq(), makes
5.19 + restricting queue sizes to 1024 boot again.  I'd bet that it also would
fix 6.0rc1, but I'm running out of time to test that.

Greetings,

Andres Freund
