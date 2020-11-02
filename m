Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2C82A2B79
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgKBN1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgKBN1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 08:27:21 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76662C0617A6;
        Mon,  2 Nov 2020 05:27:21 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id p3so11384000qkk.7;
        Mon, 02 Nov 2020 05:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PdvDuP7e3w2Z1tBi0oPx/qF1V99ajnCRYtINddpeaV8=;
        b=oELlHAqZObXU/0Y1vLQClILBhaSo1PyaDxNvAK4JCbQUlPkY2EBe7YCZEkwC/I4KcD
         eQ2va6VWfVDNqiDoQYgv914RPRL9YLtEmRWkrJFINQAygSzcTgsh1JRxlnJyLw1/r1vO
         jXEEYjedt6AEM0Xz840DMDiPp0jJeM4FmN6+uK+hLRDnJnltsapz+BZwXFmyVJ5UwZlZ
         8VENknNQJmGCXLXPUgjDwnL+gZusf3tHjn76mvJY6OeGqc04h5pBrrw5Uszs+nCQ+DfA
         zYQgS6vjsNXY5cQao5QESVLzLvLDiObkO+afYF8OI4MKxpda1rutpuZeiL4KiS1U14cT
         +wMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PdvDuP7e3w2Z1tBi0oPx/qF1V99ajnCRYtINddpeaV8=;
        b=DWeOmi8eIyUgc6sj3juz1UlqearIJOXKhdVoxhN+guASvoNL3H60XEBY/24IneYr24
         zIBORBtcteWRBZBkbYZ6DqXaIqcgCIj4wUjHehtGBcisyKVLn/fkqOOOIHeXDrjpQBSz
         yimohj0kFgXmlfRboqwsmZtOZ1nRBy4a7+pK9FJPsK8qQJ0E7tRq/OFS0246qL/IrS9B
         YvJWvlsG+v21hRyU24h4C7LXVDehUeDnpYL6hFkejJxr14fJvlJ+HUslj//BkQD2Pm/o
         UlIppedTkQvIkTSR2Tc39FPCkL9Wo0k2CS56XGci1nulOxdDOf7WqOroSHvinCZo4A5A
         f/Nw==
X-Gm-Message-State: AOAM5305Ie3ZhkGq1moockNQ1aZYrcOkY9Z0Bzj5PIDjNfRyiNVlpeTS
        0BDIShZdAZnJelencspx12g=
X-Google-Smtp-Source: ABdhPJyxPF2bCnNggS7wxbBQGiC+TY0Piw/sUKV9ySKTqBbl7NWqIINfq79wpjhNZPP7Q2lepbeUeg==
X-Received: by 2002:a37:6790:: with SMTP id b138mr15047011qkc.355.1604323640677;
        Mon, 02 Nov 2020 05:27:20 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f016:de27:b805:b146:db09:c9cb])
        by smtp.gmail.com with ESMTPSA id t12sm7670804qkg.132.2020.11.02.05.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 05:27:19 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 92CA7C0DAB; Mon,  2 Nov 2020 10:27:17 -0300 (-03)
Date:   Mon, 2 Nov 2020 10:27:17 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Petr Malat <oss@malat.biz>
Cc:     linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: Fix COMM_LOST/CANT_STR_ASSOC err reporting on
 big-endian platforms
Message-ID: <20201102132717.GI11030@localhost.localdomain>
References: <20201030132633.7045-1-oss@malat.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030132633.7045-1-oss@malat.biz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 02:26:33PM +0100, Petr Malat wrote:
> Commit 978aa0474115 ("sctp: fix some type cast warnings introduced since
> very beginning")' broke err reading from sctp_arg, because it reads the
> value as 32-bit integer, although the value is stored as 16-bit integer.
> Later this value is passed to the userspace in 16-bit variable, thus the
> user always gets 0 on big-endian platforms. Fix it by reading the __u16
> field of sctp_arg union, as reading err field would produce a sparse
> warning.

Makes sense.

> 
> Signed-off-by: Petr Malat <oss@malat.biz>

Then, it also needs:
Fixes: 978aa0474115 ("sctp: fix some type cast warnings introduced since very beginning")'

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
(If the maintainers can't add the Fixes tag above, please keep the ack
on the v2)

Thanks.
