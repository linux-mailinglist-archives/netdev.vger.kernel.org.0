Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00253E8E1C
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 18:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbfJ2Rcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 13:32:48 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:37207 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfJ2Rcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 13:32:48 -0400
Received: by mail-pg1-f178.google.com with SMTP id p1so10056730pgi.4
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 10:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=W/BxCEx2JroM9jU6G3GDfiVt+Yf3iTbckAcZOTg3EAM=;
        b=B51zFSdnq4YPuYMpVz3lKbBU/MEAn+ZEJMvxst6sVsef2grOuVnlNcXeHk3mECvs5X
         3/OK2lv35vtWS26vWAaHOnXcBye1LYS6WGsunNGXIXz2TlNcGArk8UFnXwydCwtFPJia
         667P+OGJzD0jezjhIUkz9xD8hb+5j7havnMn4/mk9DyVjzIKrrRkZdFp2KyoTnw/CL+p
         a65O6sfnJs5gl4OVX/bPAabSFqPcdUlOvgcCwSvOyh6/fJnVfL4BBJf3JKovkFprf7Yn
         V+A52UBHzwrMI400gyzv0L9fCVDZMnc582GWrar8/TKCE1C97N8TWRUye9S1oZL+ts3f
         yDaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=W/BxCEx2JroM9jU6G3GDfiVt+Yf3iTbckAcZOTg3EAM=;
        b=MEh/9o0tbcn3xqI6SENGnrrHEPlIB6O29h7XU1oF+sQ3q6RLBF4V94iKfPstb0cUCV
         dfZcobzIqpI4FFm+K3TizwqglJEGi+fR3o8OFG/1wYdBAKokJ4IY5McTm1JJ0dgnBmBA
         IqCDFX3BA+Dw+wp1xnH+5hPH9Lc3ITHSpeOtnZo81l9BXnEe4N9P5VPnBKc5/lwt9Adp
         Hf1Ex59+Wd7NiC6Mq9Xd2sDj1uZWnkF4WtedZmgfiCTLbCnwe68vWkvXcwyqu0BqzJxe
         QxmXrA8wBHrG2GGlt9hv9wofIgFTsZ08So+aldb9aaJwQvS3eDh+Kwcls+Fo7vH0I1p3
         5tTg==
X-Gm-Message-State: APjAAAUPpHX8yTj0ue0DJ3kfbc5pba4QHrCkntam+9d/3pd76R8zQ/tP
        c7urb3fn/mmeW2COQ/rcphWtEQ==
X-Google-Smtp-Source: APXvYqxdHhNGkCPFOSvR7lvPp909hVKao93u9fpiazYGKuGL7z05ALmUb5xKmRgndpSqTtXrWpNeBA==
X-Received: by 2002:a63:3853:: with SMTP id h19mr24837116pgn.55.1572370367492;
        Tue, 29 Oct 2019 10:32:47 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id d5sm349834pjw.31.2019.10.29.10.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 10:32:47 -0700 (PDT)
Date:   Tue, 29 Oct 2019 10:32:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Zhu Yanjun <yanjun.zhu@oracle.com>
Cc:     rain.1986.08.12@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCHv3 1/1] net: forcedeth: add xmit_more support
Message-ID: <20191029103244.3139a6aa@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1572319812-27196-1-git-send-email-yanjun.zhu@oracle.com>
References: <1572319812-27196-1-git-send-email-yanjun.zhu@oracle.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Oct 2019 23:30:12 -0400, Zhu Yanjun wrote:
> This change adds support for xmit_more based on the igb commit 6f19e12f6230
> ("igb: flush when in xmit_more mode and under descriptor pressure") and
> commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data") that
> were made to igb to support this feature. The function netif_xmit_stopped
> is called to check whether transmit queue on device is currently unable to
> send to determine whether we must write the tail because we can add no further
> buffers.
> When normal packets and/or xmit_more packets fill up tx_desc, it is
> necessary to trigger NIC tx reg.
> 

> CC: Joe Jin <joe.jin@oracle.com>
> CC: JUNXIAO_BI <junxiao.bi@oracle.com>
> Reported-and-tested-by: Nan san <nan.1986san@gmail.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> Acked-by: Rain River <rain.1986.08.12@gmail.com>

I explained to you nicely that you have to kick on the DMA error cases.

Please stop wasting everyone's time by reposting this.
