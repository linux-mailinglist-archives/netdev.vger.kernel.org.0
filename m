Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428C69EC21
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 17:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbfH0PPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 11:15:02 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39222 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfH0PPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 11:15:02 -0400
Received: by mail-ed1-f66.google.com with SMTP id g8so31847923edm.6
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 08:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e1OMcBv4d9R66Y96DIqBexPayGtG/0QAoWV2ffq/ib0=;
        b=XdW4rjgBf3ZFuwABYeeL7AM9GPKoq4aBCwN3bzP0g4oU3+L3AuzNyQ/giU0l8O9yR6
         dROxSV2Ep+IzCakanr8ljSJ0N3tR70MAFF42KQ3J6e9OQM1GZRNFoR2KVJX3ogoW4H8s
         pwTjkTsBFnuDDtnUlAlAKY2PRs0Mt/ptlic58=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e1OMcBv4d9R66Y96DIqBexPayGtG/0QAoWV2ffq/ib0=;
        b=cjlZU9aZj6+RCF9D6jLKHBAd+zfpGWrOLuSDITr21kQvoIgyHoQBY1BevdFs7DhH6X
         V+gbiFEmUW3uiKnK2JpnLqLzsE65s1EU6iSrnGnyh6nqwbXELZkSCwvk1v2NcjDo4y38
         ZEC5mNFbDhbCrX5i6EhEmj6VQOErrcvBrxnhMsrLWaD3b/qdajMNOGZ56ZMhjjMReMh0
         F1kTuMqKjpm+HucnGzELFGGQZqg/UrjzaSndE79+5WreDtL/dEfbtsN9uHZxAQxBqqNw
         2fosdHon1aF7UFlN2b5njYI77Q951PyTOCkEZijqmvmAmxAmBjJI19C6xh8e/uAAqNRT
         LCPA==
X-Gm-Message-State: APjAAAVSkNnhgD9fBTHWbEExMUw3ZzpUBWp2FKjQuD45iPV/4xqoSPez
        ngs8JWMCubKfNdglh1uVBp0Sn9bQZd7tBDxPqE3UVQ==
X-Google-Smtp-Source: APXvYqyG6UyjzUTh/HSOzvQdajAKDhoXCRcC2v7jvy834WzkIiBeWtiNKPrHwcA7v7a0hb9yjRBiZ/YPzo3mC2sWp54=
X-Received: by 2002:a17:906:fcbb:: with SMTP id qw27mr21771012ejb.134.1566918900400;
 Tue, 27 Aug 2019 08:15:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190826151552.4f1a2ad9@cakuba.netronome.com> <20190826.151819.804077961408964282.davem@davemloft.net>
 <20190827070808.GA2250@nanopsycho> <20190827.012242.418276717667374306.davem@davemloft.net>
 <20190827093525.GB2250@nanopsycho>
In-Reply-To: <20190827093525.GB2250@nanopsycho>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Tue, 27 Aug 2019 08:14:49 -0700
Message-ID: <CAJieiUjpE+o-=x2hQcsKQJNxB8O7VLHYw2tSnqzTFRuy_vtOxw@mail.gmail.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 2:35 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Tue, Aug 27, 2019 at 10:22:42AM CEST, davem@davemloft.net wrote:
> >From: Jiri Pirko <jiri@resnulli.us>
> >Date: Tue, 27 Aug 2019 09:08:08 +0200
> >
> >> Okay, so if I understand correctly, on top of separate commands for
> >> add/del of alternative names, you suggest also get/dump to be separate
> >> command and don't fill this up in existing newling/getlink command.
> >
> >I'm not sure what to do yet.
> >
> >David has a point, because the only way these ifnames are useful is
> >as ways to specify and choose net devices.  So based upon that I'm
> >slightly learning towards not using separate commands.
>
> Well yeah, one can use it to handle existing commands instead of
> IFLA_NAME.
>
> But why does it rule out separate commands? I think it is cleaner than
> to put everything in poor setlink messages :/ The fact that we would
> need to add "OP" to the setlink message just feels of. Other similar
> needs may show up in the future and we may endup in ridiculous messages
> like:
>
> SETLINK
>   IFLA_NAME eth0
>   IFLA_ATLNAME_LIST (nest)
>       IFLA_ALTNAME_OP add
>       IFLA_ALTNAME somereallylongname
>       IFLA_ALTNAME_OP del
>       IFLA_ALTNAME somereallyreallylongname
>       IFLA_ALTNAME_OP add
>       IFLA_ALTNAME someotherreallylongname
>   IFLA_SOMETHING_ELSE_LIST (nest)
>       IFLA_SOMETHING_ELSE_OP add
>       ...
>       IFLA_SOMETHING_ELSE_OP del
>       ...
>       IFLA_SOMETHING_ELSE_OP add
>       ...
>
> I don't know what to think about it. Rollbacks are going to be pure hell :/

I don't see a huge problem with the above. We need a way to solve this
anyways for other list types in the future correct ?.
The approach taken by this series will not scale if we have to add a
new msg type and header for every such list attribute in the future.

A good parallel here is bridge vlan which uses RTM_SETLINK and
RTM_DELLINK for vlan add and deletes. But it does have an advantage of
a separate
msg space under AF_BRIDGE which makes it cleaner. Maybe something
closer to that  can be made to work (possibly with a msg flag) ?.

Would be good to have a consistent way to update list attributes for
future needs too.
