Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEB4125DC6
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 10:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfLSJf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 04:35:26 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:34605 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbfLSJf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 04:35:26 -0500
Received: by mail-il1-f196.google.com with SMTP id s15so4327521iln.1
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 01:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a2DXLhWG+1I/sxJa6YFBWn4bUqJF9bmSM3jLRi/c7dc=;
        b=TRVX4Lc8Y8ErxPbU6eqBYH6CyQy+QfNXWoP+LLwz0l1EvzGtkuSE2oF7wGtG6hkGcu
         KJFIaAtCUTin8SM+ymwrscIObOxEDQaUA5ficzV/EJiwK9hs6DEpMG5QSDBg5hvdwtxt
         lsOwh05wUG56husmLOH5Jwygk1fBcnrM8r08iBc4MvjoTswR9u+3Q/E7kADToRzUcbCF
         jbcrCR5TgBFdWjYrxP18tic69Ck+5+jggbCGc3gqrtFUuVJfQzfsIjG0qwnJT0AL//Om
         Q5ytQHbplugQ7gkUXICfJ0Cq3FLeXnB0/tDw6Qa2CZFYrHHNnovJjCZt/1zOy7LS9Yeh
         6keQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a2DXLhWG+1I/sxJa6YFBWn4bUqJF9bmSM3jLRi/c7dc=;
        b=lyn5i9FuKZJOJlMgWMVoZ9VcNGpstC6m8UqP5JxBzXZyOipVjj7NZYLGp0yNUkl9Wr
         19NTpP9+W7mnEWp6FJeDPYagIzf8rh4VmZgXHVk9dLF7SJFAoLCW4mmwGdAD5itUlxT1
         aPldCa5DS70qeuOFQFyiFv7DTbBaIpAKRU3T0rRmRon6DvvD73wGJrfFKNJ50PqYx2QA
         XGgOpEBEYN6w+bkm7po5NT1PMFb9epL4fQ5E73SYEnEnFzRdhW1fv6zFQaY4t2cvO+bD
         OszskQ3ruEavSJom7w01olyCZVvzRC1l1aZERmvj++QQhnKZaLjLtpQwqltVygbo2BWI
         8q5Q==
X-Gm-Message-State: APjAAAV4gTLAXB9r9zyKMdg+Jm2BTJuK283TcYF0PVc44AB4tfec1Qd/
        /v5dn38uijJZ5GbuTvX1luazUVSANIl84FBSyogu+Q==
X-Google-Smtp-Source: APXvYqxu+jMjNle+ACBvO1nRDbDvShivY/r2tlBkdLEsMASv7gZt8FOunyItaOXZPAMs744KqWkrYdN0Lr/vbe9IxY8=
X-Received: by 2002:a92:ca82:: with SMTP id t2mr6256940ilo.242.1576748125586;
 Thu, 19 Dec 2019 01:35:25 -0800 (PST)
MIME-Version: 1.0
References: <20191127001313.183170-1-zenczykowski@gmail.com> <20191213114934.GB5449@hmswarspite.think-freely.org>
In-Reply-To: <20191213114934.GB5449@hmswarspite.think-freely.org>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Thu, 19 Dec 2019 18:35:13 +0900
Message-ID: <CAKD1Yr1m-bqpeZxMRVs84WvvjRE3zp8kJVx57OXf342r2gzVyw@mail.gmail.com>
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019, 20:49 Neil Horman, <nhorman@tuxdriver.com> wrote:
> Just out of curiosity, why are the portreserve and portrelease utilities not a
> solution to this use case?

As I understand it, those utilities keep the ports reserved by binding
to them so that no other process can. This doesn't work for Android
because there are conformance tests that probe the device from the
network and check that there are no open ports.
