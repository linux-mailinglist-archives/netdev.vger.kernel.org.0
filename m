Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7FA27EE91
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731177AbgI3QKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730627AbgI3QKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:10:09 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB9BC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 09:10:09 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id u9so1952764ilj.7
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 09:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+DjPkHL73ZcxfEqAyyMgOcRTQAVXbRwJBapYGIOhuLw=;
        b=Ki2AjonTnscSU+63CM5jKG1mj8jHVLvqF9WPp84zsYS7VnijX+Wc3UkEKFIQJluKOA
         UBYrqyZha+JScChReT5PBo7sSNLnKHbWK6gwo4vHcIqWBmI4FJwDu8i9Ji9z1pQprqah
         a5zp0HlfBQYkSgGSL7HwmiA9R0wZMl6fNwE4EQZiZMkDdWEdMhcH+ybylnBxJ/5ItFKB
         T+G7jkTFU8PoA/hgjJbEgEXV8aMdkHQa5hl5bIe8fecAGHek1YNQKWEWW11kzGzCZU0G
         m5TMtFsELLTDW1Vviim2soNgQW9vVV30GDmsXo01MmXx1R1hftK7nUPbBFK4+5zC0VPD
         /SQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+DjPkHL73ZcxfEqAyyMgOcRTQAVXbRwJBapYGIOhuLw=;
        b=UW6r8jxI9hm+fP3JNzUA4PnJItR2kmVHQRPex9gMMnKCobaWHHx7Wh7Llccdd3+6b9
         EXShcI/+MqLvGvVFl47lquybGQV9CvpQOzIGpIUoad0kXb/FUnxUJJ9AICWZD7hcWrzE
         BF16wqaE3/Ek/e2tODKp5pXyEB+vB2JcNPqHSSPLut/LirpjJkEvSc85BScOMPqjo/Cm
         nvBOGMpBzZz1uaIqRS0Df1gVb6hrnbDW7XXELYzJrpoR1vJZ1fzSQshHMVApmwdzK3nY
         1KhyeKiVx9L9FWRIJeJH+6s2jWPZdEDVdhhsNSPmLOXlQUmM8p3mUSQXudq/FK9tQhs3
         Rhbg==
X-Gm-Message-State: AOAM531TJgOIUyKDWCEckkvcaxU6YT2OjfvDrzeP8pYj1dyX8/tZCdGQ
        nO6+kbybVzPPHMzIrmOuTj1SjFgHZwdHsnLg0IdVGTSFtdw=
X-Google-Smtp-Source: ABdhPJxfJhOa58zJOz1aFWbM9Qf7+zWU3J1nq35vz46Nog3kbkoLTEowA84NyoV+A5UwgfB+4cb14qkWyQoo1e/AdeQ=
X-Received: by 2002:a92:cd43:: with SMTP id v3mr2655702ilq.276.1601482208458;
 Wed, 30 Sep 2020 09:10:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200924010104.3196839-1-awogbemila@google.com>
 <20200924010104.3196839-5-awogbemila@google.com> <20200924155103.7b1dda5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200924155103.7b1dda5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Wed, 30 Sep 2020 09:09:57 -0700
Message-ID: <CAL9ddJeQARACr6bSrdod-gEacKLqnYz3=kfkY+ogfkXVo_EnBw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 4/4] gve: Add support for raw addressing in
 the tx path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 3:51 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 23 Sep 2020 18:01:04 -0700 David Awogbemila wrote:
> > +     info->skb =  skb;
>
> double space

Ok, I'll fix this.

>
> > +     addr = dma_map_single(tx->dev, skb->data, len, DMA_TO_DEVICE);
> > +     if (unlikely(dma_mapping_error(tx->dev, addr))) {
> > +             priv->dma_mapping_error++;
> > +             goto drop;
> > +     }
> > +     buf = &info->buf;
> > +     dma_unmap_len_set(buf, len, len);
> > +     dma_unmap_addr_set(buf, dma, addr);
> > +
> > +     payload_nfrags = shinfo->nr_frags;
> > +     if (hlen < len) {
> > +             /* For gso the rest of the linear portion of the skb needs to
> > +              * be in its own descriptor.
> > +              */
> > +             payload_nfrags++;
> > +             gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
> > +                                  1 + payload_nfrags, hlen, addr);
>
> This..
>
> > +             len -= hlen;
> > +             addr += hlen;
> > +             seg_desc = &tx->desc[(tx->req + 1) & tx->mask];
> > +             seg_idx_bias = 2;
> > +             gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
> > +     } else {
> > +             seg_idx_bias = 1;
> > +             gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
> > +                                  1 + payload_nfrags, hlen, addr);
>
> and this look identical. You can probably move it before the if.

Thanks, I need to make sure I understand: you're referring to the call
to gve_tx_fill_pkt_desc? if so, the calls look the same but
payload_nfrags is different in the if and else cases, perhaps I could
move it after the else? but I'm not sure if that helps.


>
> Otherwise this one is:
>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
