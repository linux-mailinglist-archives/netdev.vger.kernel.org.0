Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 403601CC0B
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 17:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfENPkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 11:40:35 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:39493 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfENPkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 11:40:35 -0400
Received: by mail-ed1-f54.google.com with SMTP id e24so23493898edq.6
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 08:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BoeWrhlpyL/PtfeSforodNbUO2D7CZqKr1lDbVMDE8k=;
        b=OG+FV0LtlLMgmxpBp5sORd2PhG23czKuCX8KiE3TJEl8Ip2BxDLPWdM4OB74dVB3ls
         0QcdRp9EMy/cipAGWvWvFn01qJhwVhdan2lJ9Qrb36p3yuIb5xcT+BUMjgr/nvFL5UJc
         PIZIhChczpaOCKbLGyHh+gu+Qkvf5OY1XsHAg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BoeWrhlpyL/PtfeSforodNbUO2D7CZqKr1lDbVMDE8k=;
        b=JXV9Gyg4atVoyc/zmRs7xdvqp2rYmefwpoui/w8/TXDrvo7O1v/uEdcYmQ1dm4OmXd
         4WHnthCc2GIxK2BAjqSS4GPXuCVWwwdC5ehCty2UNEIxXd8IZz1AubyjdxbKuSkE5ZCR
         zbjCT5eTjGLGHzXuiaR6TD4CUxn7Q+i0DVTnnJrrRYx0RlDVmIv4bUgBJR3qViy1+tMz
         yGEvzlKNs4RdkolEDJy1Zb84dLzY+GwGBhINAdZpiKzoBonDkhT1oRznd9GAQ4rKQI6i
         N4po6rozHIamiPCjybvYLge4lCIkCz0CuLW1BzB2ebd8PPWOm+RufCiYocamVWOmXnMq
         wieg==
X-Gm-Message-State: APjAAAX+zA7/d7U8HeQMgHhRIyjd9NWTWPqCPJ57jnfgNKZkrg5jKaAH
        q3ZNeB1Ni0t9VwGNqHpU5BOKMXaatry2Oi5+tAAx6A==
X-Google-Smtp-Source: APXvYqz4afOhoNfwX+3+zPjhDZ/7R5DYWA5Jc6tM9kJvjkru5alnyUYFoo3qNJUjbwWu1dHONpEI2tdqutwfRfTmzBA=
X-Received: by 2002:a50:f4fb:: with SMTP id v56mr38328249edm.13.1557848433450;
 Tue, 14 May 2019 08:40:33 -0700 (PDT)
MIME-Version: 1.0
References: <mcmahon@arista.com> <20190513160335.24128-1-mcmahon@arista.com>
In-Reply-To: <20190513160335.24128-1-mcmahon@arista.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Tue, 14 May 2019 08:40:23 -0700
Message-ID: <CAJieiUgHp_uhaH3rL783Ch_PNDq1cVeb7aG+bHerUR7b3SwHZQ@mail.gmail.com>
Subject: Re: getneigh: add nondump to retrieve single entry
To:     mcmahon@arista.com
Cc:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>, christian@brauner.io,
        khlebnikov@yandex-team.ru, lzgrablic@arista.com,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mowat@arista.com, dmia@arista.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 9:04 AM <mcmahon@arista.com> wrote:
>
> From: Leonard Zgrablic <lzgrablic@arista.com>
>
> Currently there is only a dump version of RTM_GETNEIGH for PF_UNSPEC in
> RTNETLINK that dumps neighbor entries, no non-dump version that can be used to
> retrieve a single neighbor entry.
>
> Add support for the non-dump (doit) version of RTM_GETNEIGH for PF_UNSPEC so
> that a single neighbor entry can be retrieved.
>
> Signed-off-by: Leonard Zgrablic <lzgrablic@arista.com>
> Signed-off-by: Ben McMahon <mcmahon@arista.com>
> ---


I am a bit confused here. How is this different from  the below commit
already in the tree ?

commit 82cbb5c631a07b3aa6df6eab644d55da9de5a645
Author: Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Wed Dec 19 12:51:38 2018 -0800
    neighbour: register rtnl doit handler
