Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E532C108242
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 06:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbfKXF4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 00:56:32 -0500
Received: from mail-io1-f48.google.com ([209.85.166.48]:38945 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfKXF4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 00:56:31 -0500
Received: by mail-io1-f48.google.com with SMTP id k1so12554421ioj.6;
        Sat, 23 Nov 2019 21:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=KulttFPDW3mLuvQ33yKOWGg0gUgXlrOVI1ma02RiZ5o=;
        b=cxsXoI2ailb8jMiw+YmEUcVLKfE43OGSWkX1UABnegT1I9T3D2ne+GC8Qd7r6tPafH
         iqvIWYAmRgP/4sJzy4CDxYG2LmmxDAYVyQxfBC/4ILxagajxRzsbkzvEsPm9qcQV+VC6
         Ofqu1CdBMpf+XVNeC+A0ppwqU2W7RBrikgfzTjVRtpSx5L6MPl442N9S/lRc7l8Vi9uH
         0Su7iYSbk9k27Zl2mxbKJNj23kXtzGAdRSeDL/+9Wo+mbpxqPRCBW5xxa9YsXY2VD7/2
         sdnx/qdv106thqOfNIvCsUBo8QRcWPDBR6W/XDKlfN02hse4EpZMgcKVB7rl2gW4Y1HC
         Flvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=KulttFPDW3mLuvQ33yKOWGg0gUgXlrOVI1ma02RiZ5o=;
        b=Ay082qnYuf0Eib7CYJlLUYxUdD4kjuufgs6P3IojJcEJP2t/5zNZc/maRsnadE2KL6
         nspwG5WKxi0gWO3NpJ8PV3sSYNbXyMhnllA+1iAT8uclnVxrnwQWzpgHv3gSglpJdCaZ
         YWnC9n70ft6nX/SxDq5sxUVrf7T6R9r+4vbZjlKReipFlkgg0skXrifNOkhFbcIqtPbK
         zQhh57hrfwFCQAPGHnLaWknGMx+UzJJe9JvetopRkCYKn0wp1Va50N9u2AOKWPAuYzPL
         DVBvzPZqAr1EOpd0VCGIaIPPQbPT7sAR8rEvLu3h3tEyJdn8z6+w5OvtGqvMcL0xXTA1
         /KLg==
X-Gm-Message-State: APjAAAUgjixsv0aoekYj1GFB9/BCUeU1mvV+TelRfiImVNZh4FNjvXjk
        HHFI1tglWCup8SW/zTgRLVg=
X-Google-Smtp-Source: APXvYqwaXdL/vjunwxNAGcfsopLexKZlBcKX7yWBldsIgGshkfKVH5ywp1rOIYMwuuMAwb+azrMuZQ==
X-Received: by 2002:a6b:9245:: with SMTP id u66mr20432594iod.98.1574574990873;
        Sat, 23 Nov 2019 21:56:30 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b13sm937563ill.61.2019.11.23.21.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 21:56:30 -0800 (PST)
Date:   Sat, 23 Nov 2019 21:56:22 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5dda1b86b9b0a_62c72ad877f985c4b5@john-XPS-13-9370.notmuch>
In-Reply-To: <20191123110751.6729-5-jakub@cloudflare.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-5-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket inherit
 psock or its ops on copy
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Sockets cloned from the listening sockets that belongs to a SOCKMAP must
> not inherit the psock state. Otherwise child sockets unintentionally share
> the SOCKMAP entry with the listening socket, which would lead to
> use-after-free bugs.
> 
> Restore the child socket psock state and its callbacks at the earliest
> possible moment, that is right after the child socket gets created. This
> ensures that neither children that get accept()'ed, nor those that are left
> in accept queue and will get orphaned, don't inadvertently inherit parent's
> psock.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
