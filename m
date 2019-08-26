Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0D69D53E
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387552AbfHZRyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:54:37 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40453 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728280AbfHZRyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 13:54:37 -0400
Received: by mail-pf1-f195.google.com with SMTP id w16so12267023pfn.7;
        Mon, 26 Aug 2019 10:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kM47wPSGoWQoKFogwJD1jolEo0D/cEX5m8eHxwo2vmQ=;
        b=iedmC87RDiN0rkKMrHaCW54/21FsAuYp/o982i8HQTHXbjjgoD24hQL17mlz2hW/Mz
         XR8Zk5zgWBm1C2JcQ3is3EDkonIWZX8KNrTRxsz/Zn509ULREYzqW7lA85lYSAqPuxay
         8C+LTArBpQyfE3G39o6KOm1TdNbj83KdGqbLrKAQVn5+oKEeJC/u15Cb5jhR7XjffzaD
         t5B6RsNKKKCvQ8xRA8SDkymSqOlb2Xl8TKAutP2tWnwDfHc8pwt2QRU7vI3obhzjW/8+
         9gBRzNqc5lrez2M3EvOG53p6Dii6ge9PmWMhFXlDKb/XWwjI83NEHac/PaRH17aiEI+a
         Gdtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kM47wPSGoWQoKFogwJD1jolEo0D/cEX5m8eHxwo2vmQ=;
        b=bZGjbzuR0ved1WpexIMJey0mN/wx+ny/8E3+E5RGVg85+3zMZ9LmOj6b4tVk3SVXx5
         /Rte0Gxx7xkCugmnONBqwkUb3gfV8h4iTPc9b1yu/QId08TJdR/icgVmBakxIz/uD0IU
         cotKkFA6yc4utNrVOj5v0+JA8oZmQDpyXCAkWIW1BF340lglC+jyPp+zI61DLGpRwdjN
         Rwo8z16WJ29r9Wn0r6MTxcJV0kBL16w7TSvu6Ml4l6uhpFppPpRGVdnJspcUficzkgca
         Yru6pNXPG+rRlI8NUMk9iJnl2Dd47aPSg2jUQUATPW5XGq7IFmRvtoSl/WQF5JaAVAuF
         QwfA==
X-Gm-Message-State: APjAAAWtJIuPtPCFuESvoBuVDtd/FyciYLBb65/VNTFj96+Slx+Eds4g
        t9il04sJpDEN/W61PUA1QOg=
X-Google-Smtp-Source: APXvYqwrKVgW/Wh3U3M1lg8TqtrE/XLv1cAH3bWW5OOQV84UFc1x3cXXXJuNpcRae5TcStbVh+FVGg==
X-Received: by 2002:a17:90a:2667:: with SMTP id l94mr21578665pje.74.1566842076513;
        Mon, 26 Aug 2019 10:54:36 -0700 (PDT)
Received: from [172.20.53.188] ([2620:10d:c090:200::3:2982])
        by smtp.gmail.com with ESMTPSA id 10sm14047831pfv.63.2019.08.26.10.54.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 10:54:35 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: Re: [PATCH bpf-next v2 2/4] xsk: add proper barriers and {READ,
 WRITE}_ONCE-correctness for state
Date:   Mon, 26 Aug 2019 10:54:34 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <324C76C6-2D31-4509-A22D-4796694A4FBC@gmail.com>
In-Reply-To: <20190826061053.15996-3-bjorn.topel@gmail.com>
References: <20190826061053.15996-1-bjorn.topel@gmail.com>
 <20190826061053.15996-3-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25 Aug 2019, at 23:10, Björn Töpel wrote:

> From: Björn Töpel <bjorn.topel@intel.com>
>
> The state variable was read, and written outside the control mutex
> (struct xdp_sock, mutex), without proper barriers and {READ,
> WRITE}_ONCE correctness.
>
> In this commit this issue is addressed, and the state member is now
> used a point of synchronization whether the socket is setup correctly
> or not.
>
> This also fixes a race, found by syzcaller, in xsk_poll() where umem
> could be accessed when stale.
>
> Suggested-by: Hillf Danton <hdanton@sina.com>
> Reported-by: syzbot+c82697e3043781e08802@syzkaller.appspotmail.com
> Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP 
> rings")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
