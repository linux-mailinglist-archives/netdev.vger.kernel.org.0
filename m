Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC83121FDB
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfLQAhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:37:21 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41021 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfLQAhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:37:21 -0500
Received: by mail-pg1-f193.google.com with SMTP id x8so4667425pgk.8;
        Mon, 16 Dec 2019 16:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SQFSETw4Xz7lWLspxui/apQzjaLDfPbcy6MZjlbtiaM=;
        b=a7jgwxe1nhIp6NjFKACWFYKSUaDd5K/NaobbNo4SeOYQBLQyLYFBFzH9liVIuntz1T
         gi9liv7HNbn7EoSdP/ZAT9hHin3eI7h08yrrYNAAMKIu7uyAA6+urmZn9a2FlB+ZiOlq
         iLyLWnP43Laof2vnMBAUzeI9JqqvzY/dnGECZHCQU6hIOPr0C0nbe//V9gRX/L7XDQVx
         yDyHmoFOSQ0EoVR6u1amsp62Ds1zYwqSl6ZPSurG049nR5h2W2qjhBDsy8p3E/zImDMq
         XkDEWaNFDuN2MHj3qtLb0TG8CcSpWvN0ts2CXeFpEJGqOSK4dyqNKx098z41zAecUrQI
         kCpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SQFSETw4Xz7lWLspxui/apQzjaLDfPbcy6MZjlbtiaM=;
        b=glLV316JObYHAHZjX/48ScbZOUDrtFSWA7UR/nClVCyZoaS2oNgmj5hu/R78GbdyRO
         kYFJKgXyQBxNYX5rYK0Dw9MEfWwJff1BY3FPsKNY4JN9nBvi5sb3HI0gDjLU0N/P+gkn
         fjYaMiVjjD6IYgG0y/j9tDIdhhISSnUv6yly4lZDIYiS/BE4S+CljODEqdM8UAlYZUY9
         tMjcoTJ7qHiKAj9lFoVCm2XEZjRHGppCqcVkfFvj18OORY2sWRreFS6huX0/i3ZSlfwx
         8cArBufzE5nD30GvhfjDp4eupl9kzJQGDs+mlGylN36yfrMK9mR8MMwAQ6R6hpPQYcMX
         ogeQ==
X-Gm-Message-State: APjAAAVKThFg7loTkfe8mA/Nn55mMs/cWyZel1Wo8qNtJJdUcOcPqGKY
        t6e4E7k+rvLD1tFZSWemDQUqp8Mcp+g=
X-Google-Smtp-Source: APXvYqyqEit9pkliF11YU1baCODG9ekGu7JsQSrq0svaqH/0LxGNlo0f2+t6EKcLHYniDch+iG0Ckw==
X-Received: by 2002:a62:5243:: with SMTP id g64mr19192407pfb.101.1576543040666;
        Mon, 16 Dec 2019 16:37:20 -0800 (PST)
Received: from localhost.localdomain ([177.220.172.83])
        by smtp.gmail.com with ESMTPSA id in19sm713725pjb.11.2019.12.16.16.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 16:37:19 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id F0DEDC0DB9; Mon, 16 Dec 2019 21:37:16 -0300 (-03)
Date:   Mon, 16 Dec 2019 21:37:16 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     syzbot <syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: memory leak in sctp_stream_init
Message-ID: <20191217003716.GC5058@localhost.localdomain>
References: <000000000000f531080599c4073c@google.com>
 <20191216114828.GA20281@hmswarspite.think-freely.org>
 <20191216145638.GB5058@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216145638.GB5058@localhost.localdomain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 11:56:38AM -0300, Marcelo Ricardo Leitner wrote:
...
> Considering that genradix_prealloc() failure is not fatal, seems the
> fix here is to just ignore the failure in sctp_stream_alloc_out() and
> let genradix try again later on.

Better yet, this fixes it here:

---8<---

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index df60b5ef24cb..e0b01bf912b3 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -84,8 +84,10 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 		return 0;
 
 	ret = genradix_prealloc(&stream->out, outcnt, gfp);
-	if (ret)
+	if (ret) {
+		genradix_free(&stream->out);
 		return ret;
+	}
 
 	stream->outcnt = outcnt;
 	return 0;
@@ -100,8 +102,10 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
 		return 0;
 
 	ret = genradix_prealloc(&stream->in, incnt, gfp);
-	if (ret)
+	if (ret) {
+		genradix_free(&stream->in);
 		return ret;
+	}
 
 	stream->incnt = incnt;
 	return 0;
