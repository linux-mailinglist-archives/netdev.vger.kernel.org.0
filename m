Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C541269721
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgINUxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgINUxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 16:53:51 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9343EC06178A;
        Mon, 14 Sep 2020 13:53:50 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id y5so1174470otg.5;
        Mon, 14 Sep 2020 13:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PLkiy5r7AkNWAevXS1V8KlinKEVQiRdSfzXConk1FcU=;
        b=GaVI6yZI2mk8kdOuZuwzHXnfbXOtzCPZWs0amhTlrYOBCJYWeTSZ1uzXqojwDuqaNC
         WuuntWraNEq1LK8K4ds42nQpKh12CFOM2n/4kk9d6drtSDRyGSbCF13bwLu06VmVzzJJ
         1r2y7sW0ZT2GRwkrSUjNJuFSCwJiSpROuRnsf902QzIIVXZX7NBupXhFdWxeuIA6n/5S
         oJO4xzPEDJAdKs93ATSQueI3n/jMqz5G59zaeDB882oZFr1KAO6wsJCNC3fNgraRRafP
         Oo2GvMRzyZh3qElASxZW+VtUU5TLq3VqqY446zanjDNNL7A9b8gsjHq01jbkKnAANr/8
         duVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PLkiy5r7AkNWAevXS1V8KlinKEVQiRdSfzXConk1FcU=;
        b=udvnVSpgq3LjYx/tLsbMLmib2YowK0o3M6tyTIumhHhpsG51Zj0+lPJ61yqCbivaD4
         YgoPJcvbZeWZM0kj9plv9i98YdY0Maqy+UQCpz6wtBfDzPPK1qz5HGqdJN9Qv6afiI4t
         OlKbaUtCl2la2MwU5MGHUpAGRDN0c5JJ+IBuHoVEQtMtFqCBT2NJbTnuGz5PJC58eDIt
         7CEj/P5S9Eu5yx1CJLz/B81RN8dCRxC3+jl/yf5G9XMjXb/28qXUVkrNtb82w/jCFf4Z
         5x5HmJO8RPDOvjsh6F5TChsyzw/KRi/7ktX1KcEiyIrtJLYcEr7vu79hE0O2d0mh5frN
         XRLg==
X-Gm-Message-State: AOAM532mry7B7Qpkip9q3R0IQFtlhv+ZpF7WP8rLeAPGXpKWa4DOM4by
        anp7rAmHxZjTRdwcYzHytRYanTJQlFm+JnD0vZbWADoOQ6g=
X-Google-Smtp-Source: ABdhPJzU85v3RQa5ss7d4PHabEij4AZnG/1pdCcxUoWaCqXNNp3HOgeqpXzA/bIct/kgiLF0dLJsW/VJqYKvNSYwYUM=
X-Received: by 2002:a9d:66cf:: with SMTP id t15mr11020563otm.143.1600116829721;
 Mon, 14 Sep 2020 13:53:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200912144106.11799-1-oded.gabbay@gmail.com> <20200912144106.11799-13-oded.gabbay@gmail.com>
 <20200914012413.GB3463198@lunn.ch> <20200914130705.45d2b61d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200914130705.45d2b61d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Mon, 14 Sep 2020 23:53:22 +0300
Message-ID: <CAFCwf13soRfPcyi219sfFmubQJDhSmgMbJBvmTvSq3z9fivxLA@mail.gmail.com>
Subject: Re: [PATCH v2 12/14] habanalabs/gaudi: Add ethtool support using coresight
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Omer Shpigelman <oshpigelman@habana.ai>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 11:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 14 Sep 2020 03:24:13 +0200 Andrew Lunn wrote:
> > > +static void gaudi_nic_get_internal_stats(struct net_device *netdev, u64 *data)
> > > +{
> > > +   struct gaudi_nic_device **ptr = netdev_priv(netdev);
> > > +   struct gaudi_nic_device *gaudi_nic = *ptr;
> > > +   struct hl_device *hdev = gaudi_nic->hdev;
> > > +   u32 port = gaudi_nic->port;
> > > +   u32 num_spmus;
> > > +   int i;
> > > +
> > > +   num_spmus = (port & 1) ? NIC_SPMU1_STATS_LEN : NIC_SPMU0_STATS_LEN;
> > > +
> > > +   gaudi_sample_spmu_nic(hdev, port, num_spmus, data);
> > > +   data += num_spmus;
> > > +
> > > +   /* first entry is title */
> > > +   data[0] = 0;
> >
> > You have been looking at statistics names recently. What do you think
> > of this data[0]?
>
> Highly counter-productive, users will commonly grep for statistics.
> Header which says "TX stats:" is a bad idea.
ok, thanks for the input, we will fix that.
Oded
