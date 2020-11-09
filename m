Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA5B2AC626
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 21:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbgKIUrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 15:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgKIUrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 15:47:41 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE27C0613CF;
        Mon,  9 Nov 2020 12:47:41 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id d9so11715405oib.3;
        Mon, 09 Nov 2020 12:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Pu3jH2lz4/aHz11/lZmOnPGy2ngd1re4TGNzl/qDjng=;
        b=pvBHxUjqoNi19gCKutnmqMrB7RPRgFUK4YePaHcl2A3nPiQLXQadfvn/RpvUClTiUk
         uZuGDwlPaSYOorKS9Vha++wsz3MY+ysB5rS20spBy5ehwwFC0J5gjpUZnmyzNSayQKnQ
         H/stTCPqEm34/KreDppUz2XIuOhYLh2A4fyrudnVqkEmcmDnKWJqy5ChZlmdUH/6JkAl
         DRp6MtyvtBn530jiOUDlfjc+dwxZSORcju9MnYwGQPWjCiqymn/lXoR1lhjuZCzMjBYW
         fdKwMg2XxKgkIVBEkJaXo6YstUKQM11hwMszW682xywrkfES6+wfKgFAo+AJGG/iQSA0
         e4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Pu3jH2lz4/aHz11/lZmOnPGy2ngd1re4TGNzl/qDjng=;
        b=oel/mB8Sd9MoHfZdvMJqphUIkuqq6JSiRix8f9+tFQERgipFPypAtMquy2QdhnefAv
         E+wFi79tC2I3YJCvQPXX/Ie0gcvnroDsPpAH3mrDYv1ZFCKFN4GGsi3xGOwfBjbA91u/
         Rfsj/JTA9lbOK7A+82OWByORX4h+8SPat/1J/MmiR1WerqymVzGZCU8yY+P0SxTquRDI
         t5cMz/H+RqJ3pSuMVXJ5Mz4PM02CBMt347hCxPUU/C31lT/5r0/nFSi150scq0UFKrXy
         19viA4COabmuNy5x9pWUJ0waTv8empcboFGEw/p/gsXKemeYMd/q9fILraJ4G6klIJzA
         kS7g==
X-Gm-Message-State: AOAM533aXR0+qFrC7kBsi0nwoKv7EZnYbi8bi9zY7+rlLlJMSpH3/Fq7
        BvuR4+AQiVePvsUpGKhYh+Q=
X-Google-Smtp-Source: ABdhPJwQu88ixW27YnfsTtPxhcBhyX/XDGy49u3xYIsO4KJMqsk1NkzGQdLdP1YzHxxg8uTrxCON4Q==
X-Received: by 2002:aca:e187:: with SMTP id y129mr654712oig.61.1604954859874;
        Mon, 09 Nov 2020 12:47:39 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j23sm2772770otr.80.2020.11.09.12.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 12:47:39 -0800 (PST)
Date:   Mon, 09 Nov 2020 12:47:32 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        bpf@vger.kernel.org
Message-ID: <5fa9aae46c442_8c0e208b5@john-XPS-13-9370.notmuch>
In-Reply-To: <1604498942-24274-3-git-send-email-magnus.karlsson@gmail.com>
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
 <1604498942-24274-3-git-send-email-magnus.karlsson@gmail.com>
Subject: RE: [Intel-wired-lan] [PATCH bpf-next 2/6] samples/bpf: increment Tx
 stats at sending
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Increment the statistics over how many Tx packets have been sent at
> the time of sending instead of at the time of completion. This as a
> completion event means that the buffer has been sent AND returned to
> user space. The packet always gets sent shortly after sendto() is
> called. The kernel might, for performance reasons, decide to not
> return every single buffer to user space immediately after sending,
> for example, only after a batch of packets have been
> transmitted. Incrementing the number of packets sent at completion,
> will in that case be confusing as if you send a single packet, the
> counter might show zero for a while even though the packet has been
> transmitted.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---

LGTM. Just one question then if we wanted to know the old value, packet
completion counter it looks like (tx_npkts - outstanding_tx) would give
that value?

Acked-by: John Fastabend <john.fastabend@gmail.com>
