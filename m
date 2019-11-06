Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C59FEF1B77
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 17:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732255AbfKFQk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 11:40:27 -0500
Received: from mail-pf1-f182.google.com ([209.85.210.182]:34131 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbfKFQk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 11:40:26 -0500
Received: by mail-pf1-f182.google.com with SMTP id n13so7609191pff.1
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 08:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2ybiXq75vGIN54w3fFPOxfHW7LzlGq0puVuBsqDOXuQ=;
        b=Jya/GpbB4+ckzLcJ9D/MnnoqFhUYd7t8vrwfe1doA32wyeDLrZbf1upihUtBJ3UxfC
         Iez/YhrwCdQIClsC9RP9ZT2fN9LhycWegypmzdSkrh/hNQhj6Kw7AEMPLV/va9lxpcI6
         JIvDIZoQdXRPOt8UY3tU3omo+cbElSpwomwgz8Lnd1HlmEdojT4R+mnTfck7jzoB+tML
         38dTvy1Rl5bdDli5iBkY6eT2zX92n9hYKVjVlD9E2LUVMMsRBYPppbHrRUhVkPszYbbh
         WnYsSoTRDR1L64yV3CYq1BMJCUZzHr8LRz1cya6SCe0T+uemgHtxlQaerOA2pITTKhxP
         IrKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2ybiXq75vGIN54w3fFPOxfHW7LzlGq0puVuBsqDOXuQ=;
        b=omRNHrZYW2yCx4HwbZdCWz35vPGdGtpqSrZsvFvuLabb2NleBjfMXd2sZJ5DID8Oh8
         hSghazRlCEo10gNxk/WdoRoZGjLBpMxdA1SM2nOjjc333XZkO1mM/Uf/YKdPeMOHNgwr
         tlIzHXdC4NJqA/Afls518DJ12K7eBaheTXPzsIAVcq1XrQ8JOsD/rbanCT0QjB8XLLyv
         jvt42sCN44QB6bVMPajMv27JRLVBt04nyElu/2KRXOy/dMg9rzX2OC13Y6eE6/23pOg/
         0O+JCYwKDC3YJSPAcktQMXBdIL4fhQmCpB+UjKhspgoYx0pO7ZBtLRlHOtHodTlQfhbV
         NSQQ==
X-Gm-Message-State: APjAAAUb549jM+ID/D00ymYFI1rCSala8A0dlxMeYhaxznt9TW8bZH+K
        8RSL28PaJCdtQJCyUAH0JalCUg==
X-Google-Smtp-Source: APXvYqyJR31MMyIe6pmsC2f3PqqdzxgMFmgciKHZcENSDyh6wEl0+9ZGm8BKiBXDxOZvgwhByL1BzQ==
X-Received: by 2002:a17:90a:1788:: with SMTP id q8mr4939271pja.139.1573058426124;
        Wed, 06 Nov 2019 08:40:26 -0800 (PST)
Received: from cakuba.netronome.com ([216.4.53.35])
        by smtp.gmail.com with ESMTPSA id m68sm23005285pfb.122.2019.11.06.08.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 08:40:25 -0800 (PST)
Date:   Wed, 6 Nov 2019 08:40:23 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Zhu Yanjun <yanjun.zhu@oracle.com>
Cc:     rain.1986.08.12@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCHv5 1/1] net: forcedeth: add xmit_more support
Message-ID: <20191106084023.1d0311a1@cakuba.netronome.com>
In-Reply-To: <1573020071-10503-1-git-send-email-yanjun.zhu@oracle.com>
References: <1573020071-10503-1-git-send-email-yanjun.zhu@oracle.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Nov 2019 01:01:11 -0500, Zhu Yanjun wrote:
> This change adds support for xmit_more based on the igb commit 6f19e12f6230
> ("igb: flush when in xmit_more mode and under descriptor pressure") and
> commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data") that
> were made to igb to support this feature. The function netif_xmit_stopped
> is called to check whether transmit queue on device is currently unable to
> send to determine whether we must write the tail because we can add no
> further buffers.

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
