Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F92DF19F
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 17:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbfJUPdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 11:33:05 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41143 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfJUPdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 11:33:05 -0400
Received: by mail-pl1-f195.google.com with SMTP id t10so6779992plr.8
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 08:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=OguQlfyzcFhuVnZE98mDDuMtCdYCC7ty3UgeavXM9MM=;
        b=1C6vwvOBUx6Hx01idRXTT5n9123g3Sz1S+4HhuW/hVcVstxk7dQtVNQ8LZ1OOdxhz0
         EiUjGZ5Xm3qkPVwsmcqlJ9ZGfXVst76JMCqFSp6Vj+C8ZHO8f2GTNS7WaiXcxkF2zBnk
         UgRb1xnAdp5gistb/XwF2Vh9jRssvKw2cWkvqacmbCVjZxoWh7AQmJQWkO6m4dMsitLB
         Gx42rjC3rD618r1bbyL7dPZwtxlF+Voy3CfG3GNS+UZ17glgTu87/+wi+8PdPulv7Y9z
         WItTma80JU7iemi3b4iz+nclKqry0EmquYZx4Xnxcxl5NPhbzsX127Y8Sc00LJScKQSg
         7EBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=OguQlfyzcFhuVnZE98mDDuMtCdYCC7ty3UgeavXM9MM=;
        b=DuoMWgulNkwqd4MDm6ckO17p0XiGs8Ej5VTQgQ+O8MrbAsEUuea4HbTqiNBqSqwvL0
         Q9tdItyJ7zRsX+u21GKOOdbabxRPVCpkgxM29lv/uO3A2v50eGanle4rtEqO0hsNDrZt
         6CHwspSRFVUa37Z4CXaEBVcuY7CJSlys17DPNEn/A/5TV5sJH5h9MJhyIXSwndFdW4tO
         n5AFpxrCl8BNABnwhWi5fsRt5wGmCwhvxOL1jKLvE4LyuUWKllkT+BJnUlMOXuGPj8HJ
         sbf5LIMfA2MREMycCIGbOj0WTIGyqeoCiSProuZ9p3GUXQzTNDv1ZEk0Pb0Jax7PVqz5
         J/gQ==
X-Gm-Message-State: APjAAAVFsCELp9/UyNdLQADeuT5ih2A5L6hkp+caImmcMWjOjBbLt1a+
        l4ozTYK7AyaL1QnTswvTxwFzPw==
X-Google-Smtp-Source: APXvYqwocMpG53/TW+zls8kUF7OaddKwRPkWLhFL4gdBrPBJjRuW3bn7rbt153+2CbgRHLQccJKeuA==
X-Received: by 2002:a17:902:6943:: with SMTP id k3mr25785055plt.158.1571671984376;
        Mon, 21 Oct 2019 08:33:04 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id 11sm15848610pgd.0.2019.10.21.08.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 08:33:04 -0700 (PDT)
Date:   Mon, 21 Oct 2019 08:33:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Zhu Yanjun <yanjun.zhu@oracle.com>
Cc:     rain.1986.08.12@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: forcedeth: add xmit_more support
Message-ID: <20191021083300.0fea8965@cakuba.netronome.com>
In-Reply-To: <84839e5f-4543-bbd9-37db-e1777a84992c@oracle.com>
References: <1571392885-32706-1-git-send-email-yanjun.zhu@oracle.com>
        <20191018154844.34a27c64@cakuba.netronome.com>
        <84839e5f-4543-bbd9-37db-e1777a84992c@oracle.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 17:56:06 +0800, Zhu Yanjun wrote:
> On 2019/10/19 6:48, Jakub Kicinski wrote:
> > On Fri, 18 Oct 2019 06:01:25 -0400, Zhu Yanjun wrote:  
> >> This change adds support for xmit_more based on the igb commit 6f19e12f6230
> >> ("igb: flush when in xmit_more mode and under descriptor pressure") and
> >> commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data") that
> >> were made to igb to support this feature. The function netif_xmit_stopped
> >> is called to check if transmit queue on device is currently unable to send
> >> to determine if we must write the tail because we can add no further
> >> buffers.
> >> When normal packets and/or xmit_more packets fill up tx_desc, it is
> >> necessary to trigger NIC tx reg.  
> > Looks broken. You gotta make sure you check the kick on _every_ return
> > path. There are 4 return statements in each function, you only touched
> > 2.  
> 
> In nv_start_xmit,
> 
> [...]
> 
> The above are dma_mapping_error. It seems that triggering NIC HW xmit is 
> not needed.
> 
> So when "tx_desc full" error, HW NIC xmit is triggerred. When 
> dma_mapping_error,
> 
> NIC HW xmit is not triggerred.
> 
> That is why only 2 "return" are touched.

Imagine you have the following sequence of frames:

	skbA  | xmit_more() == true
	skbB  | xmit_more() == true
	skbC  | xmit_more() == true
	skbD  | xmit_more() == false

A, B, and C got queued successfully but the driver didn't kick the
queue because of xmit_more(). Now D gets dropped due to a DMA error.
Queue never gets kicked.

> > Also the labels should be lower case.  
> 
> This patch passes checkpatch.pl. It seems that "not lower case" is not a 
> problem?
> 
> If you think it is a problem, please show me where it is defined.

Look at this driver and at other kernel code. Labels are lower case,
upper case is for constants and macros.
