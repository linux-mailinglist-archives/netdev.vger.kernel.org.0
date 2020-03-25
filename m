Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A1519300E
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbgCYSGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:06:44 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38738 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgCYSGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 14:06:44 -0400
Received: by mail-pg1-f193.google.com with SMTP id x7so1523455pgh.5;
        Wed, 25 Mar 2020 11:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UBVlc240FbLXR1uBYzhk/ck+Wv5OR2EIrMIlpjj1smo=;
        b=ncbLsxJ7lRV583DfgrqdA28VTb8Qf1+KsCu25/dW1PSL3zVDD0OwgBl+05my12NQMP
         nnnJwwzS+fIj1K6o/LEbeAAxxeEzqI/GRbTnQ33IUn+3w6pWZ9h2zk0WQLqGkmlOhQsu
         2x6zqrm1ANo5+TET+ncjWL6C5QZtKLuvoTdc8BedTkaPJ+74ncb5iI0cFJx7Zr80HUMp
         C/ejK5uQZQwL+ry8fKsubDEYIZsfldLimkMDwrsS5nCO49oe7QGX9zJ1RIPOa5MwCfJY
         KBf0Q7SEc9kKluvU5SbQINvz8/usWcfrrpT7Vgsjm+8HAdPri/lflOpzWhdajE02ZBMA
         gj3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UBVlc240FbLXR1uBYzhk/ck+Wv5OR2EIrMIlpjj1smo=;
        b=mxPLCRxaGK5sEJcl4UBBuBqSgYwPpJO7Wp7wLa0TonBFb/6PZ/E7VSQ6azqHmkR4kx
         Fgo+5eUii5NZCynxBH+D+tOu66p0R7NRsPx1IN7KsAsGXuZFO4eeB0ON9OPrZwjqvjM+
         FzoYQBg7hbk1acUNNukBk8L1D6cVn0kmSaZUOmgAqVQyXNjhP/JQOTTO4EcbvrZFKOmL
         zAGzp+bjycHzDflcwI8n6GYiuYeAJymG4k42l0KlfPDK3XnQjZ8ubPNbCWePfTlI72n0
         iZ4pHzxZS/+jY274BTtw9Q4znxnEb2qcovBhn5Gex4tY6VGtEpF0z5T1p8dRkt2g3Atj
         YPRQ==
X-Gm-Message-State: ANhLgQ3e981orrwtpAYD/L9MbIVTW7bRo8drzQBWq54Oii9ZSVsjmP6T
        pIgKwfPP/w3pPR0ss2oM8ZM=
X-Google-Smtp-Source: ADFU+vscGyxXg01vmAQ+pETGFyzzSx8viPkzXHeZ2xDFuppavHyRpKvKiNZEdjmMhfN24+rIAQZ/FA==
X-Received: by 2002:a63:9210:: with SMTP id o16mr4432234pgd.442.1585159603299;
        Wed, 25 Mar 2020 11:06:43 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:b339])
        by smtp.gmail.com with ESMTPSA id f68sm5008289pje.0.2020.03.25.11.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 11:06:41 -0700 (PDT)
Date:   Wed, 25 Mar 2020 11:06:38 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200325180638.el22n4ms6aau42r4@ast-mbp>
References: <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk>
 <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <5e7a5e07d85e8_74a82ad21f7a65b88d@john-XPS-13-9370.notmuch>
 <20200325013631.vuncsvkivexdb3fr@ast-mbp>
 <20200324191554.46a7e0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324191554.46a7e0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 07:15:54PM -0700, Jakub Kicinski wrote:
> 
> It is the way to configure XDP today, so it's only natural to
> scrutinize the attempts to replace it. 

No one is replacing it.

> Also I personally don't think you'd see this much push back trying to
> add bpf_link-based stuff to cls_bpf, that's an add-on. XDP is
> integrated very fundamentally with the networking stack at this point.
> 
> > Details are important and every case is different. So imo:
> > converting ethtool to netlink - great stuff.
> > converting netdev irq/queue management to netlink - great stuff too.
> > adding more netlink api for xdp - really bad idea.
> 
> Why is it a bad idea?

I explained in three other emails. tldr: lack of ownership.

> There are plenty things which will only be available over netlink.
> Configuring the interface so installing the XDP program is possible
> (disabling features, configuring queues etc.). Chances are user gets
> the ifindex of the interface to attach to over netlink in the first
> place. The queue configuration (which you agree belongs in netlink)
> will definitely get more complex to allow REDIRECTs to work more
> smoothly. AF_XDP needs all sort of netlink stuff.

sure. that has nothing to do with ownership of attachment.

> Netlink gives us the notification mechanism which is how we solve
> coordination across daemons (something that BPF subsystem is only 
> now trying to solve).

I don't care about notifications on attachment and no one is trying to
solve that as far as I can see. It's not a problem to solve in the first place.
