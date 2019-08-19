Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C62594EFA
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbfHSU3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:29:11 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42432 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727988AbfHSU3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:29:11 -0400
Received: by mail-qt1-f196.google.com with SMTP id t12so3417672qtp.9
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 13:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=JE9NE50gW1Dye2LG4r5kUn+4ALy8w0ijIqPdFitTYSg=;
        b=oVleNcGIo4yNdd0pwKc6UcAljtaFVSvBdhu0Ur07inNXzFCHiWqlwUlTYNtdCQjef3
         jcRcqrhuZiREF0HZ3Ewe8qEw5crtqw0Ht6BltmJsw/ff312LtUcPoPng4eXw1zrM0tPa
         3d2dLVxZL/Ahwv0QMM3n+ilNIZ4qZSiyaZzk/aJHzYGnMzyx+c2F3Ru8UhL5h51fCzYp
         1oiqfHtBkHvibENhTMAHl0nj5em+OqypWZYLLThnWYoDmhl5NTOVn0JP5NyrZSo1eCCi
         9amTGL1gGp4kJKvbw2m8uVPUAqx5nc32w5i6KC3vXITZsK/Auq6lWAMeB7wI6bjYhC46
         ct+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=JE9NE50gW1Dye2LG4r5kUn+4ALy8w0ijIqPdFitTYSg=;
        b=jYRuyZklSKpSINwBglCi5SQZww8MTRZvB6WAKcv0V7ovmAuXruAHC8PFMB3rQrY3M5
         oVQZKKW25ye/m1oCHWK2R3CNY5Yhx/nlVZDH8NjJ6h5JQHrVRgfcyZ7ZlfmlOxhR/11m
         cugaS00aPD6KmCIWPObVqElbtgM2hMBKIdQvAOfmAjEsSHRejHk+/qGVpraBd6Nfp0H3
         4i2aGmfam3YM6KkVv6+/jp2RNIpwX9JtKNqWsss889GWAePFyCLbSfyOuBwcfUfC5T/6
         1ZvCPCGM7LpfO+luPp/VRi/VZEY3MzPRfBCToGRN7Fpr8CqX3Z0K6afrL6R4Kv3ZGD92
         aqgw==
X-Gm-Message-State: APjAAAX5hEdQbdBDVLt0uVw8xJuM4Trjx0DejfyZ0lFJxEqaLHfk8qOj
        QOu1FvoZ3DD54SyMPWZvRbmDhA==
X-Google-Smtp-Source: APXvYqyl64YGUHNgloNrkxmuvfvMEMhgcSkXQo3hQcJVMF3D8MMWveUeJAxuzjyL4iTBg4iI0d+g6A==
X-Received: by 2002:ac8:739a:: with SMTP id t26mr23066537qtp.65.1566246550732;
        Mon, 19 Aug 2019 13:29:10 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z33sm7462946qtc.56.2019.08.19.13.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 13:29:10 -0700 (PDT)
Date:   Mon, 19 Aug 2019 13:29:04 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, pablo@netfilter.org
Subject: Re: [PATCH net] nfp: flower: verify that block cb is not busy
 before binding
Message-ID: <20190819132904.0ba5f751@cakuba.netronome.com>
In-Reply-To: <20190819073304.9419-1-vladbu@mellanox.com>
References: <20190819073304.9419-1-vladbu@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Aug 2019 10:33:04 +0300, Vlad Buslov wrote:
> When processing FLOW_BLOCK_BIND command on indirect block, check that flow
> block cb is not busy.
> 
> Fixes: 0d4fd02e7199 ("net: flow_offload: add flow_block_cb_is_busy() and use it")
> Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thank you!
