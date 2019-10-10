Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFDEED1FD2
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbfJJEvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:51:40 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38104 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfJJEvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:51:40 -0400
Received: by mail-pl1-f193.google.com with SMTP id w8so2159143plq.5
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=E95iLPRzqraIZP9Y+QxKrR0ngsZqsRYmLKpfqkMfGkA=;
        b=dBz+azGAAFXHeiqkZsRQ/8MoRZUOvg/04rb1XTJjfQurcE3xRjEpAVK0I1hzpXDRKA
         oT305B6QW4hWfw0yIGdSZljwdZe+vT99Z2EMFD+3K0MIS85ibCdNoDGoZmqeTV418RUf
         y7bAlEuZ5XyjwMG7cSNz1mtRh2HgQTzhpaF1es+/jLV/d7tE/whE/GTyF41CdR5Khw3z
         i9Ez+LCbxb45dzR/5Yd5CudD1tN627q1lciuK7QV68jwh27ekOZLWLC+kyuH07/wO/bd
         149slkZg44B7mmZIPz8c0wrj4Zcj1vEJn9vU9LqKMtodaJRIM+zRmHihDGPLcnXPAGPz
         PlzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=E95iLPRzqraIZP9Y+QxKrR0ngsZqsRYmLKpfqkMfGkA=;
        b=IzzJpPqxQJ9aoqadYEtIUxMpr4zyc7Zda3+MDi5f/3/KMYENy0sug+Q6YiKQZqax/v
         mX4S5nk9I8SK2n7TLTI4ZiVAmzXJ4X/1z91d0rgCgsVLDlPVzugGZpRdADBmrmlhAlMd
         b/o2PwFTA499HDaW5lJzSkkUTKD+Iy5f6Iw153upGPrWfwUi+QhBauZWwLiUr4PLyZuS
         mG7J05ZnMKUhFRZVH1/6j4ySRiLsvdWFd+FJte+toW8APFx2NbwlaG5M0NOt5VCuejD9
         jq0ctAiHMzXrWGBTpYHXMBdWLui7x9hrfUDr3dIst7X7TqL+sz0RzdTte0q8/08BvJCJ
         5fig==
X-Gm-Message-State: APjAAAX7Qfsm3v8OSZmeyWkm9iwFWKsi0zlced+9oF0/E5MP/ws8RiSA
        skCpJ7oBJQK3taMjahARged6SQ==
X-Google-Smtp-Source: APXvYqxYQlPvA+Ccmt8D8pTqypwfNN7B3T6deAB5sMuQX0fZJhqSaIFshh5XrUSFBqajXtMBk68sKw==
X-Received: by 2002:a17:902:8ecc:: with SMTP id x12mr7403440plo.189.1570683099346;
        Wed, 09 Oct 2019 21:51:39 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id w6sm4565502pfj.17.2019.10.09.21.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 21:51:39 -0700 (PDT)
Date:   Wed, 9 Oct 2019 21:51:25 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net: silence KCSAN warnings around sk_add_backlog()
 calls
Message-ID: <20191009215125.0375d687@cakuba.netronome.com>
In-Reply-To: <20191009222113.43209-1-edumazet@google.com>
References: <20191009222113.43209-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 15:21:13 -0700, Eric Dumazet wrote:
> sk_add_backlog() callers usually read sk->sk_rcvbuf without
> owning the socket lock. This means sk_rcvbuf value can
> be changed by other cpus, and KCSAN complains.
> 
> Add READ_ONCE() annotations to document the lockless nature
> of these reads.
> 
> Note that writes over sk_rcvbuf should also use WRITE_ONCE(),
> but this will be done in separate patches to ease stable
> backports (if we decide this is relevant for stable trees).
> 
> [...]
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied, thanks.

There was a minor conflict on net/sctp/input.c here, hopefully resolved
correctly.
