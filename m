Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDEF24A8C5
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 23:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgHSV6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 17:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSV6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 17:58:14 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D21C061757;
        Wed, 19 Aug 2020 14:58:14 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d19so127294pgl.10;
        Wed, 19 Aug 2020 14:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=wxmd8DKJTSw2pEZ/YKVFag9RNqVOH5CwCvU1Kdqi78I=;
        b=Ii7B+EsveWXgPOhBsd4UXRt94SgwIGWjQwo1oklRKAIM/oqi85aekg1444gkjotmb1
         UJLpP36v0XsxHu8vAjOVV8FW2XSHj/tcIYmbRz+HMtFycNKNuiisa/aZht8yFCxar4Zy
         tQLb966w+CL12USS5DH1flAE2hQ8yGrj2aGSyjpLSRRpChv0MJqdASGfkb/L7zVXf42u
         cZg57aHBrt+4f863N6zNLZmxfMrNcrZTNP2az03PyDMYNPklC7gfA7MEmCxT9yVAbREJ
         D4SalHBDAenO8B8MkEo/jbDfLh6a23cb+Q4WbGITmQNjGprlDPpBCDhVJaYIWzsClyjB
         ZpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=wxmd8DKJTSw2pEZ/YKVFag9RNqVOH5CwCvU1Kdqi78I=;
        b=kh0HUoN4PCZRhDHHNB2XIb1fWclKKw7GrWeYuyVRmG973QPPO0UjqXj7Fls/l3Pdrv
         bdFajZLYv7FYY/XeRtIJaRkFwDlX48XmvOS06U9fDlqTkqVEDD2Azn9aIdtWoKZQ8hkW
         i0JcT7CAZObGnzPk+tMAv3rsMW4SXBNMWwgGBZks8P3xtg5kXsn4LYPMhBV4Y9QP1pvQ
         vR/8sLzwnlVFa1ebbsCCkB70WFJrDG6fTtYLnoDbyWLn+MNbYWP2XpsAJ7o9TkeLBlcE
         vieLd6FLvDbzjPxvofyf7Emgxni1rEPXursovbsuVtfLFV9f8ZPt+RxIwwHLNIIuyOrh
         kUDg==
X-Gm-Message-State: AOAM533KZ0CKGdRALp1BaN0rwkymYZL0Nsrr3lsWPw4sF/rvVXoOTN5S
        yEEGjdohxVY7DzG0crY1S5HDKS+V9PYBrw==
X-Google-Smtp-Source: ABdhPJyLv4fF3T/pHneVF8HsUhxQ7BG8vmzXlvK1X0sunLV/W3IbFspIUp73l9vIwkCBfwCPh3XGIQ==
X-Received: by 2002:a63:ef46:: with SMTP id c6mr326444pgk.96.1597874293631;
        Wed, 19 Aug 2020 14:58:13 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p9sm145724pge.39.2020.08.19.14.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 14:58:13 -0700 (PDT)
Date:   Wed, 19 Aug 2020 14:58:05 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com
Message-ID: <5f3da06d5de6c_1b0e2ab87245e5c01b@john-XPS-13-9370.notmuch>
In-Reply-To: <20200819141428.24e5183a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1597842004.git.lorenzo@kernel.org>
 <3e0d98fafaf955868205272354e36f0eccc80430.1597842004.git.lorenzo@kernel.org>
 <20200819122328.0dab6a53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200819202223.GA179529@lore-desk>
 <20200819141428.24e5183a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [PATCH net-next 6/6] net: mvneta: enable jumbo frames for XDP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Wed, 19 Aug 2020 22:22:23 +0200 Lorenzo Bianconi wrote:
> > > On Wed, 19 Aug 2020 15:13:51 +0200 Lorenzo Bianconi wrote:  
> > > > Enable the capability to receive jumbo frames even if the interface is
> > > > running in XDP mode
> > > > 
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>  
> > > 
> > > Hm, already? Is all the infra in place? Or does it not imply
> > > multi-buffer.
> > 
> > with this series mvneta supports xdp multi-buff on both rx and tx sides (XDP_TX
> > and ndo_xpd_xmit()) so we can remove MTU limitation.
> 
> Is there an API for programs to access the multi-buf frames?

Hi Lorenzo,

This is not enough to support multi-buffer in my opinion. I have the
same comment as Jakub. We need an API to pull in the multiple
buffers otherwise we break the ability to parse the packets and that
is a hard requirement to me. I don't want to lose visibility to get
jumbo frames.

At minimum we need a bpf_xdp_pull_data() to adjust pointer. In the
skmsg case we use this,

  bpf_msg_pull_data(u32 start, u32 end, u64 flags)

Where start is the offset into the packet and end is the last byte we
want to adjust start/end pointers to. This way we can walk pages if
we want and avoid having to linearize the data unless the user actual
asks us for a block that crosses a page range. Smart users then never
do a start/end that crosses a page boundary if possible. I think the
same would apply here.

XDP by default gives you the first page start/end to use freely. If
you need to parse deeper into the payload then you call bpf_msg_pull_data
with the byte offsets needed.

Also we would want performance numbers to see how good/bad this is
compared to the base case.

Thanks,
John
