Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C85A28210E
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 06:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgJCEJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 00:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgJCEJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 00:09:19 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FB4C0613D0;
        Fri,  2 Oct 2020 21:09:19 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id g3so4555893qtq.10;
        Fri, 02 Oct 2020 21:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oh7VUxla1PMyx5S8F/d6BBPIgZAX2tpeVPfmgqzgvIE=;
        b=W/UDDEy/EHayzSdWLvGQaSeCbloxPSSe1JpIHHJgL1+qKcY8A85ZBcKvAqr4LuNgDS
         SL3SInSZ8I/AMNUUHuwuXTPRvpSYOX5kEhsvg8m1u9HBgFbHdjoe/SfYFloFVuYcFOnU
         c2Dxbz4eNvUd57xCLCukn1KXh1YvCejW+TnFD6pkDp858vS4hsJTeoUTU5CkNjHW+jT6
         TUQlOw1mmY8Im585iNTQ9e0TXfFckM0e736NI+PXCBe2WJBxq0k+dLomG0V5zqg2c1dl
         bLjLDVwr3bOC2uXiarLZ1QYXn4Vzb65XVhwOIllY/sjZ6AP3RP5K+2EorPIlOqVOIthF
         vx+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oh7VUxla1PMyx5S8F/d6BBPIgZAX2tpeVPfmgqzgvIE=;
        b=i8IBkqJGhODds4eWWdlnH9iidjKOkG3F114fbeeHx62g1nGjOkFgApbsPsYWfneKUW
         tBhyAjtrqx0rBbIDeB6eJICfog7K6POuorGQLxmzVUEhq2ZAA4ZecQiECDDt3QZcfPfn
         3sbOHIE5zOyqiRNNs40sqlbMcuHSJ+4EqgieRdKMi0P5w2ZoDMi8xLX7g/KWZHp9L23O
         PPpf8pnGxowmIdHSXzAQv35PT2B8/AuMi73WrNK5pKL4zGIKeYKUNKsWvxc6UKdKWmBg
         rLt5kioNmV8we6yDu04FFciw4jlYBvOakabLsStgTWr0Mlo+N9WypXJAWfno3TY6I8xD
         9c+A==
X-Gm-Message-State: AOAM533Qua4xLWFwEiNfa5Cquii5FDc786sugey4Hua3EOuWG2lq2eGO
        QAy4F9io6HIsDsEpAE510WYuM4kaODJ0fA==
X-Google-Smtp-Source: ABdhPJznw90wUSNqjOG4WJ1TDonGmmBUoTIQ/sz9RVBhpdATVuYAq2v+CKsHCvQR4HoP/axy/eTCiw==
X-Received: by 2002:ac8:1aae:: with SMTP id x43mr5394312qtj.30.1601698158921;
        Fri, 02 Oct 2020 21:09:18 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.62])
        by smtp.gmail.com with ESMTPSA id a3sm2644151qtp.63.2020.10.02.21.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 21:09:18 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id EF57DC6195; Sat,  3 Oct 2020 01:09:15 -0300 (-03)
Date:   Sat, 3 Oct 2020 01:09:15 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: Re: [PATCH net-next 12/15] sctp: call sk_setup_caps in
 sctp_packet_transmit instead
Message-ID: <20201003040915.GH70998@localhost.localdomain>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <3716fc0699dc1d5557574b5227524e80b7fd76b8.1601387231.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3716fc0699dc1d5557574b5227524e80b7fd76b8.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 09:49:04PM +0800, Xin Long wrote:
> sk_setup_caps() was originally called in Commit 90017accff61 ("sctp:
> Add GSO support"), as:
> 
>   "We have to refresh this in case we are xmiting to more than one
>    transport at a time"
> 
> This actually happens in the loop of sctp_outq_flush_transports(),
> and it shouldn't be gso related, so move it out of gso part and

To be more precise, "shouldn't be tied to gso"

> before sctp_packet_pack().
