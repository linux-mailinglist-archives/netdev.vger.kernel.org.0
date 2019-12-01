Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4684610E05A
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 05:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfLAE5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 23:57:38 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43956 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727169AbfLAE5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 23:57:38 -0500
Received: by mail-pl1-f193.google.com with SMTP id q16so10559435plr.10
        for <netdev@vger.kernel.org>; Sat, 30 Nov 2019 20:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M5UdpxtXvZnWhbY5xsRKN13c+prK17Ipuz3ygov9Xfw=;
        b=ljN00OVGde3qbgLsgzYd7IKphBFINTf8+KWps/mIS9GELWMwhXs1r6DexiE8Wud69l
         i5WaQxUGkwVhtiIMvg/I7+LVivdTyTlaQjGsRjm3+82u3QzMKUwHFB2ZQk5pwof64vGt
         Rf0wHxFhAeU9drkxSZB7ejMkDFa2kFwO1YtwCCCzlgimMtR/JcRIl6Yl2FScYvhoEqNi
         sCaapqV7LjJP6CxDXJXZxbAM+WbJ6zHw9ZAQmJ/ju1AZpoZGa5oDvpCyPxx0WnX69EoS
         rLRDsCNdicnAXK4TL1qjr895Bk9YHYNOdAC1ZEyJYCEvwj7iTpvIbuaDfcsIJqRcEWSC
         Bvww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=M5UdpxtXvZnWhbY5xsRKN13c+prK17Ipuz3ygov9Xfw=;
        b=VsIH2tXXPwts/v9kv6uXjb7/h6V9kw8UEp79iD6qiG2wUq6f2yY1zg6Cmn/nRQSUIx
         Vqo33URlFg0GJ1J6jiPomU80RgJq4cYQNcSFCWESNpghbAhF4VRKLA/wV2fe/YC36Nkr
         HlthBwPzVeDcDmgOdFeJQBtlIdGyyu9NJTKs0aQkHC+9CHaVIbPXDkLed6OyyUn/6VDk
         s0DMAqM5sSKIJpXC9KbCd3v6WkvitUkwNwdFV8k1iOznpDxDyjNG1p0QViYfxHleFEGx
         KSGMIQTxJQd7mwasnaY0uTNsMVQIle46Njwv1eXntBxKJJikaw3pZ6xe9QXm1t6vUQjp
         RLzA==
X-Gm-Message-State: APjAAAUqHvqlYcppfAwG1VptubKUpgAL4buKNBES2OnutCc6cs64Lj3N
        oc6MLHFRnIsrtYZF9wW8qMxYPceB
X-Google-Smtp-Source: APXvYqxgM40xZly+KuQYTbb1XuqSN31hzAq4KFd2iMCNLZZwrK26k2UpeDagSD6DqhKDsJzZcaqL3A==
X-Received: by 2002:a17:90a:30a4:: with SMTP id h33mr27678769pjb.50.1575176258040;
        Sat, 30 Nov 2019 20:57:38 -0800 (PST)
Received: from martin-VirtualBox ([42.109.129.152])
        by smtp.gmail.com with ESMTPSA id s2sm30685160pfb.109.2019.11.30.20.57.36
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 30 Nov 2019 20:57:37 -0800 (PST)
Date:   Sun, 1 Dec 2019 10:27:27 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        pravin shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, martin.varghese@nokia.com
Subject: Re: [PATCH v3 net-next] Enhanced skb_mpls_pop to update ethertype of
 the packet in all the cases when an ethernet header is present is the
 packet.
Message-ID: <20191201045727.GA2548@martin-VirtualBox>
References: <1574848877-7531-1-git-send-email-martinvarghesenokia@gmail.com>
 <20191127.112401.1924842050321978996.davem@davemloft.net>
 <CAM_iQpWu9DQ06FYo7xtuLFnHP-wx35Uva_0-im7XwemKtLno0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWu9DQ06FYo7xtuLFnHP-wx35Uva_0-im7XwemKtLno0A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 29, 2019 at 10:07:53PM -0800, Cong Wang wrote:
> On Wed, Nov 27, 2019 at 11:24 AM David Miller <davem@davemloft.net> wrote:
> >
> >
> > net-next is closed, please resubmit this when net-next opens back up.
> >
> 
> I think this patch is intended for -net as it fixes a bug in OVS?
> 
> Martin, if it is the case, please resend with targeting to -net instead.
> Also, please make the $subject shorter.
>
There are few upcoming features to net-next from my side which relies on this fix.
In that case should i post against both net and net-next ?
Please advice
 
Thanks
Martin
