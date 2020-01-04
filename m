Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8BD313043F
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 20:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgADT4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 14:56:17 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46922 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgADT4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 14:56:17 -0500
Received: by mail-lj1-f193.google.com with SMTP id m26so44592891ljc.13;
        Sat, 04 Jan 2020 11:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G2RbSSDHVBuVOGQtyC2BtLvSA86nkHkyT+SW5iMV8CE=;
        b=X669DOytXR+OvDZr74nz6auzAi0wH6fTIRkX7KyUYIR6A+0sIi3bv3zNnumw9fPRgF
         TZmu050jP4M55egtvp59IOBEawo0k0WHWsVHU63YJoS+IoJ0K8kCNjCnx6QllA2uif7T
         7q3wutwdtnTGjAZWkufp8UZJwRPdrS1l8fHvzPDvfKZA0L1fhICv/zuUeIiOIT96aCTE
         v+qYXORjbh5QyRePgi/HKloB15IJtgf7NWCt2OKjFP688l0waf9xZJ9SfbJ9t37jnlhT
         jf2EI7FiQuwsN+1VtuGK7Mkbn2/8+/6FMcpj2T/jodJZSYNelrgUd5M8jEWrccRNOfj3
         icTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G2RbSSDHVBuVOGQtyC2BtLvSA86nkHkyT+SW5iMV8CE=;
        b=IMVONlXPawqzrlZXIgRKVrRuagj1RNdqDgn72OO80sJjP8OPX4gSdYoYgwajgZYZMS
         RjwofRBYCmFeSU2vvU7DjzgVRSX25P3E1QBt4JRsO1BCkT5FDwJeG/55raUPikAN1s4q
         kPu7b3NG2uy4gYKY3wYXvNHUDj2dP+8n5OrVCQ5xdEWz5aCptkUA3WIPPeay9xI7DiGI
         61MQUq/ZMe7DCtCSVFDQJWUfEZIWVFVlconyZV9BKmh1cgz1epoxvYpMqi4OmLu6rEUi
         DapdPdvTaaDdJQyf1bMvV4yNdPgUMGsmZvfqUBvDgynvsnbfppSGnuqaRknLudnl/k2P
         83zA==
X-Gm-Message-State: APjAAAVGv4IU+4GsZURYTKECxjCfw+8MMeB5oSCjzlpI1jbJYOMBYIAi
        5CkAAfDvbaP9HuNq42BBb9lf5Doieopy4WJA0MM=
X-Google-Smtp-Source: APXvYqzcZ77FdocZToXsv/9+SDAG1ywkkXxuhPgTgrcnlEHLtgcV64inFsdhzhaHIf4r7pHKFssHT3Bm11nsmpLBGG4=
X-Received: by 2002:a05:651c:1129:: with SMTP id e9mr36552954ljo.239.1578167774756;
 Sat, 04 Jan 2020 11:56:14 -0800 (PST)
MIME-Version: 1.0
References: <20200104195131.16577-1-info@metux.net> <20200104195131.16577-4-info@metux.net>
In-Reply-To: <20200104195131.16577-4-info@metux.net>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Sat, 4 Jan 2020 16:56:23 -0300
Message-ID: <CAOMZO5CpCcwMYwR2o-rgnGV-SAK1o67DZOpDkS38oYp20MrHmA@mail.gmail.com>
Subject: Re: [PATCH 4/8] net: ipv4: use netdev_info()/netdev_warn()
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, Marcel Holtmann <marcel@holtmann.org>,
        johan.hedberg@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, edumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        yoshfuji@linux-ipv6.org, jon.maloy@ericsson.com,
        ying.xue@windriver.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, netdev <netdev@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 4, 2020 at 4:54 PM Enrico Weigelt, metux IT consult
<info@metux.net> wrote:
>
> Use netdev_info() / netdev_warn() instead of pr_info() / pr_warn()
> for more consistent log output.
>
> Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
> ---
>  net/ipv4/tcp_cubic.c    | 1 -
>  net/ipv4/tcp_illinois.c | 1 -
>  net/ipv4/tcp_nv.c       | 1 -
>  3 files changed, 3 deletions(-)
>
> diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
> index 1b3d032a4df2..83fda965186d 100644
> --- a/net/ipv4/tcp_cubic.c
> +++ b/net/ipv4/tcp_cubic.c
> @@ -513,4 +513,3 @@ module_exit(cubictcp_unregister);
>  MODULE_AUTHOR("Sangtae Ha, Stephen Hemminger");
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("CUBIC TCP");
> -MODULE_VERSION("2.3");

Commit message and code change do not match.
