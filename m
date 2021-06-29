Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0313B7351
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 15:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhF2Njk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 09:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhF2Nje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 09:39:34 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F39C061760;
        Tue, 29 Jun 2021 06:37:06 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id z4so1605747plg.8;
        Tue, 29 Jun 2021 06:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zio1lOhtG4EyFNe7HsOIIbxHd7wmDa19V1E41XFuv1o=;
        b=QKqCSEbf3r5/3ahfxkCWiGFGWMm2Gv2lEAIFmzvp6SohntKV+rz/kKv4TsSqFDMmqJ
         x2d29scCzZEI9dBPJCiS3U0tRQC12fdJbUAbL9LDs21f04ftV2mQ+DyY/ikZh0MCXsRS
         qO9MH9rpeiObY6b3ShJyUi+cNDTt3uKN6kxNg9SV5/+hM5pMuKqUTM3UTb+iEkeALkUV
         qdbIYUwIExxLXIhB/DbFu3T5EJ9MqgryNjGcJftUaN+eoSA4S7V5/XVT/6UNUsgzEKU5
         pAKiRaWwDJf6b8LWnFPcU0qOsc6EHAJ60+hZr+KkBZ6nwbWlb/9f0q0QWgIHW26V4+iL
         rPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zio1lOhtG4EyFNe7HsOIIbxHd7wmDa19V1E41XFuv1o=;
        b=RlicZLgu8Vf9J6bdz1HlAgVWzQnyM8FUp6565vFNa8QQd5ZelSIeW+WIBiV5xfpjtB
         MUF04PFaW6vYlb255BUd497i6YARCBROBSxXxcefgLiR026nm6AcJByDDkhUD3x00hka
         kPRzak9J2KWYWL1vp8Huml4DzXOqYnOZ2P0dax4JqbwVvHBvJo1TQQqVhCuLPkCgrHs2
         kWWjd0ugwZP33cuBXTopTbAqyfjbG/EHj3qmri1EXG4N2SUMFaLitKa32JWicCkJZj+j
         0XI+2fFCqvf9F3UJJrvS2ILaK4KuLyETvk74lPA8MMmKOPUsBWwLc3gDEGPcYGsTKvMz
         bmew==
X-Gm-Message-State: AOAM5303GdCX1pnsBXS9oesbzMRxtAe1zJX2V8xUx6igjGTVI7HwPXtJ
        u2+nknLhjSbnV986sUmCGIY=
X-Google-Smtp-Source: ABdhPJxT9XmVbs1wB+Pc8OCoEZk0cTF8wXN2v0ua6UfCpRvCCjvao0T2oxjaCqTrrcdWeD8WjxoTLw==
X-Received: by 2002:a17:902:ea0e:b029:128:ad9a:8c68 with SMTP id s14-20020a170902ea0eb0290128ad9a8c68mr17955940plg.68.1624973825988;
        Tue, 29 Jun 2021 06:37:05 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m2sm3549327pja.9.2021.06.29.06.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 06:37:05 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Tue, 29 Jun 2021 21:35:41 +0800
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 16/19] staging: qlge: remove deadcode in qlge_build_rx_skb
Message-ID: <20210629133541.2n3rr7vzglcoy56x@Rk>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-17-coiby.xu@gmail.com>
 <20210622072939.GL1861@kadam>
 <20210624112500.rhtqp7j3odq6b6bq@Rk>
 <20210624124926.GI1983@kadam>
 <20210627105349.pflw2r2b4qus64kf@Rk>
 <20210628064645.GK2040@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210628064645.GK2040@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 09:46:45AM +0300, Dan Carpenter wrote:
>On Sun, Jun 27, 2021 at 06:53:49PM +0800, Coiby Xu wrote:
>> On Thu, Jun 24, 2021 at 03:49:26PM +0300, Dan Carpenter wrote:
>> > On Thu, Jun 24, 2021 at 07:25:00PM +0800, Coiby Xu wrote:
>> > > On Tue, Jun 22, 2021 at 10:29:39AM +0300, Dan Carpenter wrote:
>> > > > On Mon, Jun 21, 2021 at 09:48:59PM +0800, Coiby Xu wrote:
>> > > > > This part of code is for the case that "the headers and data are in
>> > > > > a single large buffer". However, qlge_process_mac_split_rx_intr is for
>> > > > > handling packets that packets underwent head splitting. In reality, with
>> > > > > jumbo frame enabled, the part of code couldn't be reached regardless of
>> > > > > the packet size when ping the NIC.
>> > > > >
>> > > >
>> > > > This commit message is a bit confusing.  We're just deleting the else
>> > > > statement.  Once I knew that then it was easy enough to review
>> > > > qlge_process_mac_rx_intr() and see that if if
>> > > > ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL is set then
>> > > > ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV must be set.
>> > >
>> > > Do you suggest moving to upper if, i.e.
>> > >
>> > >         } else if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL && ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS) {
>> > >
>> > > and then deleting the else statement?
>> > >
>> >
>> > I have a rule that when people whinge about commit messages they should
>> > write a better one themselves, but I have violated my own rule.  Sorry.
>> > Here is my suggestion:
>> >
>> >    If the "ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL" condition is true
>> >    then we know that "ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS" must be
>> >    true as well.  Thus, we can remove that condition and delete the
>> >    else statement which is dead code.
>> >
>> >    (Originally this code was for the case that "the headers and data are
>> >    in a single large buffer". However, qlge_process_mac_split_rx_intr
>> >    is for handling packets that packets underwent head splitting).
>>
>> Thanks for sharing your commit message! Now I see what you mean. But I'm
>> not sure if "ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS" is true when
>> "ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL" is true.
>
>Well... It is true.  qlge_process_mac_split_rx_intr() is only called
>when "->flags4 & IB_MAC_IOCB_RSP_HS" is true or when
>"->flags3 & IB_MAC_IOCB_RSP_DL" is false.

Actually qlge_process_mac_rx_intr calls qlge_process_mac_split_rx_intr when 
"ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV" is true or in the last else,

     /* Process an inbound completion from an rx ring. */
     static unsigned long qlge_process_mac_rx_intr(struct qlge_adapter *qdev,
     					      struct rx_ring *rx_ring,
     					      struct qlge_ib_mac_iocb_rsp *ib_mac_rsp)
     {
         ...
     	if (ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV) {
     		/* The data and headers are split into
     		 * separate buffers.
     		 */
     		qlge_process_mac_split_rx_intr(qdev, rx_ring, ib_mac_rsp,
     					       vlan_id);
     	} else if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DS) {
             ...
     	} else {
     		/* Non-TCP/UDP large frames that span multiple buffers
     		 * can be processed corrrectly by the split frame logic.
     		 */
     		qlge_process_mac_split_rx_intr(qdev, rx_ring, ib_mac_rsp,
     					       vlan_id);
     	}

So I think we can't say that if "ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV" 
is true,  then "ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS" must be true. And 
I don't know how to reach the conclusion that the last else means 
"->flags3 & IB_MAC_IOCB_RSP_DL" is false.

>
>To me the fact that it's clearly dead code, helps me to verify that the
>patch doesn't change behavior.  Anyway, "this part of code" was a bit
>vague and it took me a while to figure out the patch deletes the else
>statement.
>
>regards,
>dan carpenter
>

-- 
Best regards,
Coiby
