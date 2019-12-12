Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E5011CE17
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 14:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbfLLNSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 08:18:53 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:44369 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729331AbfLLNSx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 08:18:53 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f1d7f5ec;
        Thu, 12 Dec 2019 12:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=+U3Pqe7m4fLf4oKCLbxn6mJHU/Q=; b=V5EQ9/
        y4Hz87Ew5GVtjaBpsBSFal+TUrIQlBMDR0iahQVA/6yhmcwkoqmpJe+X5uoF9qal
        ilXq1xtHIWHXPyjl5gERAkWPFJtc14LP00/jqFVSB+iT+SUeOL9KGSuzg80VkR6d
        E4cxE4I79lwZq44tBpbbC7LfSV+p4QcjT+0nkXU816a7lkC3NLQeJ79cxhDBrKAs
        /N/1WW61zF/eOSO1PU1CidslKI9dwIDG2o9Ia23j+Ii77mookE1xx00s2kU2O8ou
        SFOEO2C/OXWViYqUImbt+lYqjkjmToVLIG1/RU+X+nST+zgaXD54kIrcSfhSX25s
        nlLKAZ0hnj4aSYBA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2d34f119 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 12 Dec 2019 12:23:04 +0000 (UTC)
Received: by mail-ot1-f54.google.com with SMTP id a15so1969677otf.1;
        Thu, 12 Dec 2019 05:18:51 -0800 (PST)
X-Gm-Message-State: APjAAAVI297gfK/gIH+KhlEup09apdJgc46YAM1HnNfufhfp9upMSDZs
        DKVu3HOWZg3+5NQ4JRRX78WcUG0qGzI7uWwZxiI=
X-Google-Smtp-Source: APXvYqynF9rpuGdcTgFI25Yw0ARUz0SOhDe9yE6k3uqBPqIUhVVAjbf7THev3UXVoGsdH6cigA7rVH1XsyB3eVZamfY=
X-Received: by 2002:a05:6830:1b6a:: with SMTP id d10mr8381765ote.52.1576156731010;
 Thu, 12 Dec 2019 05:18:51 -0800 (PST)
MIME-Version: 1.0
References: <20191212120055.129801-1-weiyongjun1@huawei.com>
In-Reply-To: <20191212120055.129801-1-weiyongjun1@huawei.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 12 Dec 2019 14:18:39 +0100
X-Gmail-Original-Message-ID: <CAHmME9qjDkwXCF0Q=QNJwZ6Cs97Mbm=V13wA7+zf1PEyifQeZg@mail.gmail.com>
Message-ID: <CAHmME9qjDkwXCF0Q=QNJwZ6Cs97Mbm=V13wA7+zf1PEyifQeZg@mail.gmail.com>
Subject: Re: [PATCH net-next] wireguard: Using kfree_rcu() to simplify the code
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wei,

On Thu, Dec 12, 2019 at 1:03 PM Wei Yongjun <weiyongjun1@huawei.com> wrote:
> The callback function of call_rcu() just calls a kfree(), so we
> can use kfree_rcu() instead of call_rcu() + callback function.
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

I've queued this up as:
https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/wireguard-linux.git/commit/?id=2ddefeb5872878fe2fffb83664c02bd104fb1a52
I'll submit this to net-next next week as part of a cleanup series I'm
preparing.

In case you're curious, this originally was call_rcu_bh, as there was
no kfree_rcu_bh function. Since the _bh functions got unified a few
releases ago, this was changed to just a simple call_rcu, but
apparently missed the optimization you've done here using kfree_rcu.
So thanks for the patch.

Regards,
Jason
