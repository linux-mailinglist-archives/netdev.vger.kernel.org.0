Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3008D1363B0
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 00:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbgAIXNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 18:13:24 -0500
Received: from smtp5.emailarray.com ([65.39.216.39]:52138 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgAIXNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 18:13:24 -0500
Received: (qmail 63182 invoked by uid 89); 9 Jan 2020 23:13:22 -0000
Received: from unknown (HELO ?172.20.55.144?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4xMzY=) (POLARISLOCAL)  
  by smtp5.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 9 Jan 2020 23:13:22 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "John Fastabend" <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [bpf PATCH 7/9] bpf: sockmap/tls, skmsg can have wrapped skmsg
 that needs extra chaining
Date:   Thu, 09 Jan 2020 15:13:16 -0800
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <87694789-2BBE-4DB9-ACA8-240175FA269B@flugsvamp.com>
In-Reply-To: <157851815284.1732.9999561233745329569.stgit@ubuntu3-kvm2>
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
 <157851815284.1732.9999561233745329569.stgit@ubuntu3-kvm2>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8 Jan 2020, at 13:15, John Fastabend wrote:

> Its possible through a set of push, pop, apply helper calls to construct
> a skmsg, which is just a ring of scatterlist elements, with the start
> value larger than the end value. For example,
>
>       end       start
>   |_0_|_1_| ... |_n_|_n+1_|
>
> Where end points at 1 and start points and n so that valid elements is
> the set {n, n+1, 0, 1}.
>
> Currently, because we don't build the correct chain only {n, n+1} will
> be sent. This adds a check and sg_chain call to correctly submit the
> above to the crypto and tls send path.
>
> Fixes: d3b18ad31f93d ("tls: add bpf support to sk_msg handling")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
