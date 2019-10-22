Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17D6E079E
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732540AbfJVPkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:40:24 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33058 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730141AbfJVPkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 11:40:23 -0400
Received: by mail-pf1-f195.google.com with SMTP id c184so1371264pfb.0
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 08:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=FoJbVcpQFekV28n8lgBuNBz0b0yGKTpdC9qhpQz9810=;
        b=vlcWDlt6JR7Y0Sfm6Lx3O/xRDqzccRQQcsQJOA5i1iECbjDmXPhCNHl0SA/UIR+i0E
         250uuearSoWnxbkIg6ZdahndEBdErb+vzk5rQ4Of4a4Xo1u6I9ciFyJNELZhxMHn6dzE
         ZX7/V4A7DjAKrvpCA708KQost5xVTVnWyv+5GyZoPMMkqtdefAEq547rFC2dGuFHn1pI
         mMGee+XZ6qXeToKhhjSVbvE46Eb2Wb04fMsS3ZTyXepI3rnJ2pW2ZIp6jWoBmB1wST2y
         mQBqJ/97B/ehLvJ9LttUVDinmD4G/XcuBDXLbKHUO+nxyi+lvtVnmaCFBShvVhRDSxT+
         irOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=FoJbVcpQFekV28n8lgBuNBz0b0yGKTpdC9qhpQz9810=;
        b=hbtjYoizZuiY+tlXCnsDahMqnK/cYpW7OWrTPlthDEsYCs0EmjTQoqNalrKoJb33+W
         lcZa2CeYXAscPKQ2Y9n1d1OoJpXI+STBryL57lgdf3Y4lCGOB3CdXxZflSgqNtkz9T0A
         QMvxScVonfIi+o0h8VzDHYFHMKjPldb3I3B506wl0x6IukvhgyxrbWhrJ6uKS5TO6InK
         kpZPLW3QUK/JzM17f7lLxIUEqcgJv3myYe/tNjRm66gFATRq2ziJWX7jmoHIBFX1Amef
         VCqPdaIzt7ctoFpMtfpBdJKVcFs1eUun3wmZMou9205INoQrBeOzRnKdfcVYUNPiXk/N
         ze0Q==
X-Gm-Message-State: APjAAAXwZpLjeIRun+XTixwJy/PaAHSIgdKdtiF6eCFHidD8B0N6mkmv
        WyHlbE6Ycx9D9pD5ttq4Uou7Dw==
X-Google-Smtp-Source: APXvYqwCrWPWg+wLi47aEd7CvoxKolkxixV5Fcv3mI+IXXUmi972scos68U9B4MxpsNpqrLMErPhNA==
X-Received: by 2002:a17:90a:d588:: with SMTP id v8mr5437204pju.51.1571758823085;
        Tue, 22 Oct 2019 08:40:23 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id c7sm18326642pfr.75.2019.10.22.08.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 08:40:22 -0700 (PDT)
Date:   Tue, 22 Oct 2019 08:40:19 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Zhu Yanjun <yanjun.zhu@oracle.com>
Cc:     rain.1986.08.12@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH] net: forcedeth: add xmit_more support
Message-ID: <20191022084019.72c92347@cakuba.netronome.com>
In-Reply-To: <c728e606-c449-d72a-5b3a-fb457b0c34ff@oracle.com>
References: <1571392885-32706-1-git-send-email-yanjun.zhu@oracle.com>
        <20191018154844.34a27c64@cakuba.netronome.com>
        <84839e5f-4543-bbd9-37db-e1777a84992c@oracle.com>
        <20191021083300.0fea8965@cakuba.netronome.com>
        <c728e606-c449-d72a-5b3a-fb457b0c34ff@oracle.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 13:32:35 +0800, Zhu Yanjun wrote:
> On 2019/10/21 23:33, Jakub Kicinski wrote:
> > On Mon, 21 Oct 2019 17:56:06 +0800, Zhu Yanjun wrote:  
> >> On 2019/10/19 6:48, Jakub Kicinski wrote:  
> >>> On Fri, 18 Oct 2019 06:01:25 -0400, Zhu Yanjun wrote:  
> >>>> This change adds support for xmit_more based on the igb commit 6f19e12f6230
> >>>> ("igb: flush when in xmit_more mode and under descriptor pressure") and
> >>>> commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data") that
> >>>> were made to igb to support this feature. The function netif_xmit_stopped
> >>>> is called to check if transmit queue on device is currently unable to send
> >>>> to determine if we must write the tail because we can add no further
> >>>> buffers.
> >>>> When normal packets and/or xmit_more packets fill up tx_desc, it is
> >>>> necessary to trigger NIC tx reg.  
> >>> Looks broken. You gotta make sure you check the kick on _every_ return
> >>> path. There are 4 return statements in each function, you only touched
> >>> 2.  
> >> In nv_start_xmit,
> >>
> >> [...]
> >>
> >> The above are dma_mapping_error. It seems that triggering NIC HW xmit is
> >> not needed.
> >>
> >> So when "tx_desc full" error, HW NIC xmit is triggerred. When
> >> dma_mapping_error,
> >>
> >> NIC HW xmit is not triggerred.
> >>
> >> That is why only 2 "return" are touched.  
> > Imagine you have the following sequence of frames:
> >
> > 	skbA  | xmit_more() == true
> > 	skbB  | xmit_more() == true
> > 	skbC  | xmit_more() == true
> > 	skbD  | xmit_more() == false
> >
> > A, B, and C got queued successfully but the driver didn't kick the
> > queue because of xmit_more(). Now D gets dropped due to a DMA error.
> > Queue never gets kicked.  
> 
> DMA error is a complicated problem. We will delve into this problem later.
> 
>  From the above commit log, this commit is based on the igb commit 
> 6f19e12f6230
> ("igb: flush when in xmit_more mode and under descriptor pressure") and
> commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data").
> 
> It seems that the 2 commits did not consider the DMA errors that you 
> mentioned.

Then igb is buggy, too.
