Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACCBDFF554
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 20:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfKPTrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 14:47:46 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46967 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbfKPTrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 14:47:45 -0500
Received: by mail-pl1-f193.google.com with SMTP id l4so7059725plt.13;
        Sat, 16 Nov 2019 11:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OYC2ekx7Tzmq1QfMcXgIkodtKuvAto7LJnsdQYrM5P0=;
        b=O/DQ/d+SOGMDbioUU5bvadLkKDnTXUk7FRJF1g2GFbdPQm9yWrAopHx7hJg+wAtSDB
         aynBQ/HG50v06LEuARaPf+RM5PPAKgPRvKGVPKCnUOqFHMJGPDzXKf9+7CH1qdx+z6hE
         b5zIz5Y6VRUvJmjS8QbwPMYRPMVQcR7MhkbAykyzXtEMu63YVUEzjqeWMX6sqBJTZIHt
         JFL9dlDKuRpzk6S+rk0ztqrb8T9Vqy23SuYsik14+0KHWiS6mgbtjEvYvZJYz+Ipwmxg
         4l8sV0cNGS9zko/Kg91UQV7y93HM+zE1Lrm1URK3jvL8FopPdnQzsUzMnzV5SeUzPntr
         nlMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OYC2ekx7Tzmq1QfMcXgIkodtKuvAto7LJnsdQYrM5P0=;
        b=GLbGsGWxMpJ1l9oLGcP9ABDmq9ZJv34ySeBqdG+zJi/J1qg+p15OgB0NqaLptm6XLd
         8rg6qDKvxuiDobXVlSGzDLgsXXUSJDZ5vwDwgVwwtZYqrys5w2ycx9lG1H7xL95aC0c2
         aHU2XpK5jwSiTKCpeoMjib99lFpM8AkmSY57JjbSuNH7q3j6ITo3247gwmbmej99siie
         soUkYdXBRXNBlf7b4LwI5DGBqxnKUhp1mHwqB+UAQLKHFUqp+w5IBFlPqJaSFAjeqalb
         Xn2qz1OuVNrcimyXVOghf87bKdtvz53W2zyLptWLkYT6gDWm6oVnGu7gyTsN6ZGelBKG
         ijAg==
X-Gm-Message-State: APjAAAWBH6942o5uWLL4/HC/lLnQnGxq/fE8Zh1zxsMSNc1qiqtThLks
        2zhbHkClMhAU8VCOiFb3WPT2BAhEhcJf+EDXEOY=
X-Google-Smtp-Source: APXvYqzzKrnIp2YvOOnX+vGIyguect9QGtIIXcMScDxpXTL77ouZZoPvyilpnVU+y7dsn+efWeNlPwsQXCG9e75v9XM=
X-Received: by 2002:a17:902:d684:: with SMTP id v4mr20988116ply.316.1573933664833;
 Sat, 16 Nov 2019 11:47:44 -0800 (PST)
MIME-Version: 1.0
References: <20191112130510.91570-1-tonylu@linux.alibaba.com>
 <20191112130510.91570-2-tonylu@linux.alibaba.com> <ea3bf073-68af-d899-2664-fef54953a68d@gmail.com>
In-Reply-To: <ea3bf073-68af-d899-2664-fef54953a68d@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 16 Nov 2019 11:47:33 -0800
Message-ID: <CAM_iQpW7S9fUX33jCNhRfsK17rGmFSCkO97ujREJGsq1NpwwzQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: add trace events for net_device refcnt
To:     David Ahern <dsahern@gmail.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, shemminger@osdl.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 7:27 AM David Ahern <dsahern@gmail.com> wrote:
> The location alone does nothing for resolving reference count leaks; you
> really have to use stack traces to pair up the hold and put and to give
> context for what are repetitive locations for the hold and put.

+1

And, as you are using tracepoint, you get trace filter and trigger for free,
which already includes stacktrace.
