Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C27261B01
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731500AbgIHSvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731124AbgIHSvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 14:51:09 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01603C061755
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 11:51:08 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id y194so9613470vsc.4
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 11:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zOlhJ759ELcXKOOqGfeV77lWnqUEXIcww3cWbaCaKkc=;
        b=asMCyCblUJ33Hh1IyVh0VZu7tMxhHYb406jcoN65/Ckc5Cy3HmZxaGc0l3YM2bM6ZS
         7vuWk/QUhenCg2yMvFRCoESv3ihcogVS4LwbQZeaUpckhZQmDueM/rWLsXoGdHU4bDTH
         bQfqdBpWSrdeiCNhpGCiHj/vNPk/xDZ4QGTXiRLdR618sMBpoS7HEFfmgqZmGsMLDK48
         S8Hb29RJnLYz1jUUekIIgDiQufX1Gqo3nz73aWI7EkBdhySBUP17SoGbxQdhX1PNhtyH
         137QcCqMVVx92Ej8bRIugQs6Bv5StdTuPOajKPLbZNwHIfFyh9386HCNfNYLOCtUenIA
         L2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zOlhJ759ELcXKOOqGfeV77lWnqUEXIcww3cWbaCaKkc=;
        b=SZbkt5MJJ9a6fmuUsPZUE5j8FTGqdPFfs88z7fDwMrQuNU4rdcVpPb0GwlHJKD6i5p
         J38TkMvROMqkO+Fv0Ah2tpAzQrOs6uorxU5IqPL+NMkRMa4cDnvfC6yTACfdskpq23JJ
         Ze3U8DbHDRoAycADZ1DEL3XULMYt5537L3aZgswb2voP001wDA+NVgCdIo5CtD3VgPfs
         VUvaq1kXH2x2VahKYvvSNBqY7WOTUe7WT6quf8mtF/35RdgUw6yqUhQ7ozWyVlJcxoEu
         OrKXpYLUMpiPoa5jMxp+M8GxGuMQJ0wS1lcr8LbTQaUDbI6HZJo5Ue7DqOqRRPG4UOiT
         fMDQ==
X-Gm-Message-State: AOAM531KuCt/1Thuznv/9+Zt6/SPGNlr936mT8+sjcamoWSF4CSXQCVR
        iuE9jGexcnugyYo98HLDa9hUqS0aSiljMA==
X-Google-Smtp-Source: ABdhPJzTMT1yL78s1WAzIChebAgXR0ubWNo8n4jSLuMiIGfid+3d6geas6gjgAOrfQ7fXvX3EesKOQ==
X-Received: by 2002:a05:6102:1173:: with SMTP id k19mr394746vsg.91.1599591066934;
        Tue, 08 Sep 2020 11:51:06 -0700 (PDT)
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com. [209.85.222.45])
        by smtp.gmail.com with ESMTPSA id r64sm23377vsr.8.2020.09.08.11.51.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 11:51:05 -0700 (PDT)
Received: by mail-ua1-f45.google.com with SMTP id e41so67334uad.6
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 11:51:05 -0700 (PDT)
X-Received: by 2002:ab0:24cd:: with SMTP id k13mr348997uan.92.1599591064900;
 Tue, 08 Sep 2020 11:51:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200901195415.4840-1-m-karicheri2@ti.com> <d93fbc54-1721-ebec-39ca-dc8b45e6e534@ti.com>
 <15bbf7d2-627b-1d52-f130-5bae7b7889de@ti.com> <CA+FuTSeri93irC9eaQqrFrY2++d0zJ4-F0YAfCXfX6XVVqU6Pw@mail.gmail.com>
 <bf8a22c2-0ebe-7a52-2e79-7dde72d444ba@ti.com> <CA+FuTSeE_O_XozfnzDED_S4of-NwtRCN+oWr=O3JPpByfCz3Vg@mail.gmail.com>
In-Reply-To: <CA+FuTSeE_O_XozfnzDED_S4of-NwtRCN+oWr=O3JPpByfCz3Vg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 8 Sep 2020 20:50:26 +0200
X-Gmail-Original-Message-ID: <CA+FuTSde4fAiy6t-Q4o1C8wdU4ZYqNt0Qd2F8PsrnXvA8q03=A@mail.gmail.com>
Message-ID: <CA+FuTSde4fAiy6t-Q4o1C8wdU4ZYqNt0Qd2F8PsrnXvA8q03=A@mail.gmail.com>
Subject: Re: [PATCH net-next 0/1] Support for VLAN interface over HSR/PRP
To:     Murali Karicheri <m-karicheri2@ti.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, nsekhar@ti.com,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >>>
> > >>> Shouldn't it show vlan_do_receive() ?
> > >>>
> > >>>       if (skb_vlan_tag_present(skb)) {
> > >>>           if (pt_prev) {
> > >>>               ret = deliver_skb(skb, pt_prev, orig_dev);
> > >>>               pt_prev = NULL;
> > >>>           }
> > >>>           if (vlan_do_receive(&skb))
> > >>>               goto another_round;
> > >>>           else if (unlikely(!skb))
> > >>>               goto out;
> > >>>       }
> > >>>
> > >>> Thanks
> > >>>
> > >>
> > >> I did an ftrace today and I find vlan_do_receive() is called for the
> > >> incoming frames before passing SKB to hsr_handle_frame(). If someone
> > >> can review this, it will help. Thanks.
> > >>
> > >> https://pastebin.ubuntu.com/p/CbRzXjwjR5/
> > >
> > > hsr_handle_frame is an rx_handler called after
> > > __netif_receive_skb_core called vlan_do_receive and jumped back to
> > > another_round.
> >
> > Yes. hsr_handle_frame() is a rx_handler() after the above code that
> > does vlan_do_receive(). The ftrace shows vlan_do_receive() is called
> > followed by call to hsr_handle_frame(). From ifconfig I can see both
> > hsr and vlan interface stats increments by same count. So I assume,
> > vlan_do_receive() is called initially and it removes the tag, update
> > stats and then return true and go for another round. Do you think that
> > is the case?
>
> That was my understanding.
>
> > vlan_do_receive() calls vlan_find_dev(skb->dev, vlan_proto, vlan_id)
> > to retrieve the real netdevice (real device). However VLAN device is
> > attached to hsr device (real device), but SKB will have HSR slave
> > Ethernet netdevice (in our case it is cpsw device) and vlan_find_dev()
> > would have failed since there is no vlan_info in cpsw netdev struct. So
> > below code  in vlan_do_receive() should have failed and return false.
> >
> >         vlan_dev = vlan_find_dev(skb->dev, vlan_proto, vlan_id);
> >         if (!vlan_dev)
> >                 return false;
> >
> > So how does it goes for another_round ? May be vlan_find_dev is
> > finding the hsr netdevice?
>
> It's good to answer this through code inspection and/or
> instrumentation. I do not have the answer immediately either.

Agreed that from reading the code I would vlan_do_receive to not find
a vlan dev associated with the physical nic, then passes the packet
unmodified to hsr_handle_frame.

Perhaps this seems to work because skb_vlan_untag has already
pulled the tag out of the packet?

But then you should not see counters increased on the vlan dev.
