Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E566129F945
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 00:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgJ2XxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 19:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2XxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 19:53:15 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00880C0613CF;
        Thu, 29 Oct 2020 16:53:13 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r10so3648793pgb.10;
        Thu, 29 Oct 2020 16:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iajN6+Bdu9Z9/QCDKIFZkvulhDtiIEMGuk/fU8yMhhw=;
        b=syb75leUvcZrKb4pYQqARaf+cCz5vU4rIAhGUkYoFGZ3mYSh3rpps0kcDiRmuAxxNQ
         pwWuSCrKTupelZ7LJLE+zFJuOhImGjRDwu3oSlYSN+ZzDMnZj9HLYVAscfgfIyk70Dcl
         0rMzSPq/IGgqaRZc6OgE3j5S1h29vDVTPx9UXgtFz2fxXvh8KL0cI6km8dO4yArQEcIE
         KRqDImZ0tMpXYFLvZVxhWbhU0m8v+19aEdBpDnWQpJ6gLNz5QYygkJdMWykUHFcyC3Bz
         wtW29OLb/MJfADzI0v+pKH5brNach5tIMMVq1H3EVMjWkUMJyVxEi9G1j1p0sYJFpMKl
         FtcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iajN6+Bdu9Z9/QCDKIFZkvulhDtiIEMGuk/fU8yMhhw=;
        b=lrxQOLdAaxOqFSduHxS6Zgz/mTyHJBndCGj5O1laBmXgf2qRuCXyrsdGUzuBuSoCiV
         1DIyOev0aSUyCX+Tqfv5RqAIuP6tw4OX7F3XmN91uVRdBtzeKBWjs11THHQeqWc/DtNJ
         fRyHyPNAtfBv/PzEIVRcEIrT4S4tFxgjz58WdccPeI8BtSs3J3nR6RR43fJwoYz19fy4
         ax/PkxyUFhHX6umKZK63cQHEd55cjYRMvJT2rnjcZHvvDYl6ajp0bTaIDPm5k+nv9vF2
         IYlbLMMY+Jplh5Q6SUHPKmyINOMyOSwhqWl849k4dtMCq5bzlB5zmnsK174QOLTmVK+E
         YZIQ==
X-Gm-Message-State: AOAM531K8miTF27bGlNcRsFKyLhsXzc3KfFLyVt3ng86sFqYLhOFCG/W
        UnjICjrR/EfNGxTRZ9EbwIsb33toRq5XVJvb9lk=
X-Google-Smtp-Source: ABdhPJzEuZehZt2BgAN6UUK1QkfgpHOZrvzWbnofNfU1fdvyPejsjAsBJse4XDrSnk5dErN++f/Mr9qV533qEt581rI=
X-Received: by 2002:a65:52cb:: with SMTP id z11mr5929253pgp.368.1604015593456;
 Thu, 29 Oct 2020 16:53:13 -0700 (PDT)
MIME-Version: 1.0
References: <20201028131807.3371-1-xie.he.0141@gmail.com> <20201028131807.3371-5-xie.he.0141@gmail.com>
 <CA+FuTSeBZWsy4w4gdPU2sb2-njuEiqbXMgfnA5AdsXkNr__xRA@mail.gmail.com>
In-Reply-To: <CA+FuTSeBZWsy4w4gdPU2sb2-njuEiqbXMgfnA5AdsXkNr__xRA@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 29 Oct 2020 16:53:02 -0700
Message-ID: <CAJht_EMOxSn-hraig1jnF_KwNsYaCYnwaZvVH7rutdS0Lj0sGA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/4] net: hdlc_fr: Add support for any Ethertype
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 10:24 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> > Also add skb_reset_mac_header before we pass an skb (received on normal
> > PVC devices) to upper layers. Because we don't use header_ops for normal
> > PVC devices, we should hide the header from upper layer code in this case.
>
> This should probably be a separate commit

OK. I'll make it a separate commit in the next version of the series. Thanks!

> Does it make sense to define a struct snap_hdr instead of manually
> casting all these bytes?

> And macros or constant integers to self document these kinds of fields.

Yes, we can define a struct snap_hdr, like this:

struct snap_hdr {
        u8 oui[3];
        __be16 pid;
} __packed;

And then the fr_snap_parse function could be like this:

static int fr_snap_parse(struct sk_buff *skb, struct pvc_device *pvc)
{
       struct snap_hdr *hdr = (struct snap_hdr *)skb->data;

       if (hdr->oui[0] == OUI_ETHERTYPE_1 &&
           hdr->oui[1] == OUI_ETHERTYPE_2 &&
           hdr->oui[2] == OUI_ETHERTYPE_3) {
               if (!pvc->main)
                       return -1;
               skb->dev = pvc->main;
               skb->protocol = hdr->pid; /* Ethertype */
               skb_pull(skb, 5);
               skb_reset_mac_header(skb);
               return 0;

       } else if (hdr->oui[0] == OUI_802_1_1 &&
                  hdr->oui[1] == OUI_802_1_2 &&
                  hdr->oui[2] == OUI_802_1_3) {
               if (hdr->pid == htons(PID_ETHER_WO_FCS)) {

Would this look cleaner?
