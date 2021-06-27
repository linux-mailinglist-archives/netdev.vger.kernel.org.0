Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4665C3B52E6
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 12:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhF0K6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 06:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhF0K6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 06:58:01 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A17DC061574;
        Sun, 27 Jun 2021 03:55:37 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so10879727pjs.2;
        Sun, 27 Jun 2021 03:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OTJ1NO07HNnACsF5RWcDESNgsRO3wvb+PZzX4HjSjnw=;
        b=KCm3VqgskcingaWtbsnZG9chsg4cQ1QYsovkMIJ+ZNGv2l9esiIzgcU8iUT60LMLIq
         LTF4sp1vrO6oejsWPbOIUju5gXebwU2LDqSh5JOMOl9Zq+MTs0+BqJyYYrhP9NFekMLN
         VQDXFvZGhOnhQdtQTGcQhTMg3wQqxqQsJe6x2mFBFnBJDPQloSW8Jw6q76VD+A9MJAwI
         mU4APBstR8ZjLnheuNV4q7HcPVsuS/h7FIku2L6qcpS+IGCLhMLkSUt9GFfWeSrvrr77
         QXMXn0aLCrz0rep0I8WSTIW43KHCO2CN1x8rTTHAbH8CkVKo+3bhUA+gtAIH0TNd/m7y
         RwTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OTJ1NO07HNnACsF5RWcDESNgsRO3wvb+PZzX4HjSjnw=;
        b=oOAxh2U0bSIKOZzD1pWiX1LTtAEqqunNESEO2bNhAtoNLlAW7f3NMun22sCUlJ33Cb
         tScD84h0px0P4XRisHbcdmxdKbjr8ohlYlkiSDYJYUYnwWfdn7xgbDHEVI0GAiw3j4Jj
         7lpjzjH9V3ZsWqKe2zFveEKK/G8qQJfOU3UTFImez+EX0h5xIRX40KUHY4vIykzmUdiF
         3Ug4UePMviLXQAPNSqoMpWSc/dO/R1r7KPpusEMJTYOtkIawtin0XMNhsBOWQJBgxEkT
         uBDxlnnnH4XK/4l5t+0Z2SkyooTcZAgupAUuuUslGvGCp/4GNueu/8Dq0hGY+b2TA4r2
         7G1g==
X-Gm-Message-State: AOAM5336lHMgHvqbvIUzHyslEasWyrH79eVt0ff3TDUJT42OSMYJCaqV
        Fr22/Qgn40kyS1PVm2e4TBA=
X-Google-Smtp-Source: ABdhPJyoAqqdQI6nCf5DwSsMDJ1tR+2j3CL/LsKDgT2QZ1D6i4T2kP+gH2GrvyRS3odioM6XG7kNrQ==
X-Received: by 2002:a17:90a:7d06:: with SMTP id g6mr21452434pjl.91.1624791336506;
        Sun, 27 Jun 2021 03:55:36 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y18sm6469925pgh.52.2021.06.27.03.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 03:55:35 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sun, 27 Jun 2021 18:53:49 +0800
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
Message-ID: <20210627105349.pflw2r2b4qus64kf@Rk>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-17-coiby.xu@gmail.com>
 <20210622072939.GL1861@kadam>
 <20210624112500.rhtqp7j3odq6b6bq@Rk>
 <20210624124926.GI1983@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210624124926.GI1983@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 03:49:26PM +0300, Dan Carpenter wrote:
>On Thu, Jun 24, 2021 at 07:25:00PM +0800, Coiby Xu wrote:
>> On Tue, Jun 22, 2021 at 10:29:39AM +0300, Dan Carpenter wrote:
>> > On Mon, Jun 21, 2021 at 09:48:59PM +0800, Coiby Xu wrote:
>> > > This part of code is for the case that "the headers and data are in
>> > > a single large buffer". However, qlge_process_mac_split_rx_intr is for
>> > > handling packets that packets underwent head splitting. In reality, with
>> > > jumbo frame enabled, the part of code couldn't be reached regardless of
>> > > the packet size when ping the NIC.
>> > >
>> >
>> > This commit message is a bit confusing.  We're just deleting the else
>> > statement.  Once I knew that then it was easy enough to review
>> > qlge_process_mac_rx_intr() and see that if if
>> > ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL is set then
>> > ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV must be set.
>>
>> Do you suggest moving to upper if, i.e.
>>
>>         } else if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL && ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS) {
>>
>> and then deleting the else statement?
>>
>
>I have a rule that when people whinge about commit messages they should
>write a better one themselves, but I have violated my own rule.  Sorry.
>Here is my suggestion:
>
>    If the "ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL" condition is true
>    then we know that "ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS" must be
>    true as well.  Thus, we can remove that condition and delete the
>    else statement which is dead code.
>
>    (Originally this code was for the case that "the headers and data are
>    in a single large buffer". However, qlge_process_mac_split_rx_intr
>    is for handling packets that packets underwent head splitting).

Thanks for sharing your commit message! Now I see what you mean. But I'm
not sure if "ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS" is true when  
"ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL" is true. We only know that
the head splitting case is exclusively dealt with by the function 
qlge_process_mac_split_rx_intr,
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
		

And skb_build_skb is only called by qlge_build_rx_skb. So this part of
code that deals with the packets that don't go through head splitting
must be dead code. And the test that ping the NIC with packets of
different sizes could also confirm it.

>
>TBH, I don't know the code well enough to understand the second
>paragraph but the first paragraph is straight forward.
>
>regards,
>dan carpenter

-- 
Best regards,
Coiby
