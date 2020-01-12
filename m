Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6DE3138466
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 02:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731851AbgALBH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 20:07:59 -0500
Received: from mail-il1-f178.google.com ([209.85.166.178]:37973 "EHLO
        mail-il1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731842AbgALBH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 20:07:58 -0500
Received: by mail-il1-f178.google.com with SMTP id f5so4946081ilq.5;
        Sat, 11 Jan 2020 17:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=3aiZezXXLGNkOSlMbgvnEbJ3OmTH7yDpKNWYbQfNjUQ=;
        b=f5/xXbbFsRCi094tlXh0jQCi5sAW1+5WLIeQjbYz3hblyc/YaaOqja2d2W59UWiB8Y
         RHd5Eeg5aknI0DOcPHEi3JsnD2Tbicj00gQtKcBfZZ1a68bTFtY8R1fxJYJgHkpxUvLP
         hU/K2oFLj+RUyOQO0W9QfhGPtDvyZ2vfg2wZMejK6F6XIGDmAAhhVVtY0d2tXveQzxpM
         n2oS1vYFk547hzoyXpaOrpe6heLX4br1Yl/O6JV9Wy973KwTbCw0VkL3GTl2YNCXJjDV
         xM+K9Dwc7CbUTUBoXdSHdVYaTRHiS8FAvLnODjdN9X8Rc9pBjnSJYDiDmw4azJCktkA2
         MxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=3aiZezXXLGNkOSlMbgvnEbJ3OmTH7yDpKNWYbQfNjUQ=;
        b=et71Qs6yNG4oPcY/eTN2+CM1XU+gkkZw77//tqHAnyU00+3JTy9YkYL3i0HgUkkHmu
         Lk1FpXe8vLWiCjXhnbIOQFvaQBW4/syKUcYPlu13701qACSvQuTYfTErulFP/woye2UT
         +lVM3MYNGzuIsoDtc3QD3cOZeAR/TfGq7gn8Q82Yf3kuhI3RwuI7ChHP8mWe39jHf424
         D4id1ZHCFj+KkoQq7W5usWBgbv3LSAyd1aajfUjoEtxxNKCuh6QtLuwpswIni9xhs7Wg
         4n7e1r5o+oy9VHP09XDIahq/dcsYZu6Pgbu3I2pAw5ZbfBMs7WTAKEGIQHikHB8kooE/
         je+w==
X-Gm-Message-State: APjAAAUNhuQsCbAdrgOK1o62ZzX/Oodh8kO+cQD/9vL5CHV+jbxQw8/t
        YuJgbMrpKyBUZkl7sBEj8TU=
X-Google-Smtp-Source: APXvYqz5kQz9iACCCWzGaLXyrc9pBUaYsMlyzAq1RU/d/x7QFj79JE+2WIlh1YzOEiShZK/Voufqag==
X-Received: by 2002:a05:6e02:4c2:: with SMTP id f2mr8928553ils.126.1578791278169;
        Sat, 11 Jan 2020 17:07:58 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x77sm2270740ilk.34.2020.01.11.17.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 17:07:57 -0800 (PST)
Date:   Sat, 11 Jan 2020 17:07:49 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5e1a7165b4a67_76782ace374ba5c050@john-XPS-13-9370.notmuch>
In-Reply-To: <5e1a6d8a5de6c_1e7f2b0c859c45c063@john-XPS-13-9370.notmuch>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-7-jakub@cloudflare.com>
 <5e1a6d8a5de6c_1e7f2b0c859c45c063@john-XPS-13-9370.notmuch>
Subject: RE: [PATCH bpf-next v2 06/11] bpf, sockmap: Don't set up sockmap
 progs for listening sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Jakub Sitnicki wrote:
> > Now that sockmap can hold listening sockets, when setting up the psock we
> > will (i) grab references to verdict/parser progs, and (2) override socket
> > upcalls sk_data_ready and sk_write_space.
> > 
> > We cannot redirect to listening sockets so we don't need to link the socket
> > to the BPF progs, but more importantly we don't want the listening socket
> > to have overridden upcalls because they would get inherited by child
> > sockets cloned from it.
> > 
> > Introduce a separate initialization path for listening sockets that does
> > not change the upcalls and ignores the BPF progs.
> > 
> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > ---
> >  net/core/sock_map.c | 34 +++++++++++++++++++++++++++++++++-
> >  1 file changed, 33 insertions(+), 1 deletion(-)
> 
> 
> Any reason only support for sock_map types are added? We can also support
> sock_hash I presume? Could be a follow up patch I guess but if its not
> too much trouble would be worth adding now vs trying to detect at run
> time later. I think it should be as simple as using similar logic as
> below in sock_hash_update_common
> 
> Thanks.

After running through the other patches I think its probably OK to do hash
support as a follow up. Up to you.
