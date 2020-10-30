Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637AE29FA01
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 01:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgJ3AvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 20:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgJ3AvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 20:51:06 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104E2C0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 17:51:06 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id k12so1255394uad.11
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 17:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PUR3hxWNuXWgt8JjF6mcV9KOB+ukA9WxGvYO8uRlRk8=;
        b=FBECrFu9flb5NhYRAKTfs67/0FKjY7hknH3+/7uYbTky5b02m2J1wZxqCivQ1DK4WX
         Mhol013/PXzw4VcjqJJFyMNc8Xs4YErwZmHqBTUSYioWy9QFvb8yafAJ9njiu/d3Qi9W
         zRZnE89rozk2sZEuq6IGS8ikkuI8XReqYsXcrjN81PI4iVfhLuIkd+DevWTBGqvVZuvd
         iz5I97CBehgPqDUf2KGtCQLexuGA2GCmLFpBXHp8HF25OoLGtnA1KxCEFPVFKLfjvVTe
         81VMVoUSSULqYHeUbvu9q1lX8r08hZMX7vGz7mO7KUOezYDil6GdYZP+chFx3HSHAqGF
         JIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PUR3hxWNuXWgt8JjF6mcV9KOB+ukA9WxGvYO8uRlRk8=;
        b=B9E9nF/a7cb6DUl/iY1x9rDuUENUoTrGQLkkyQwJ6I3aDsX2sYkTnI2hry2i3eUamB
         wWURgFij+HyngqJjGsLBQKlqus8i7KjnolAA77kv6tD3aek/ai8XiXyk2Mj9fZ54s9/l
         9VjgBjKAwRMl02AUZuUWG4F6YHUr7H32PuBzf+dFO+dOsBlAKRY7wue5mW3cvjlyD79o
         M88jg7Q7+OJAwIzdGHiR3mR1ZFJJpMeecwc366CVuu/Z507tqi2XPcpJbT2py9J1JVl4
         pzRTYtyrmnuJw43s45VI+RufTc0IKDl+XJppsmc/6EhPTBEUK1R2/LAHIz1lBuW0kEjq
         xDzg==
X-Gm-Message-State: AOAM531zPvKJhEEASd4/JXr6kXjpi5sF2aqkUypJspoQ9VAqEYgTwjOe
        PlCot0q/hT8D4VDb7tzVMFZW2VdeLEc=
X-Google-Smtp-Source: ABdhPJyT0rgtZOmSkVYQRcE8AsCpsp8OzQBcq38odWE/t6A00zKGRXUvESI2hnKVKSCWMA7rMePYSQ==
X-Received: by 2002:ab0:2101:: with SMTP id d1mr25821ual.125.1604019064280;
        Thu, 29 Oct 2020 17:51:04 -0700 (PDT)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id c18sm509575uap.6.2020.10.29.17.51.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 17:51:02 -0700 (PDT)
Received: by mail-ua1-f46.google.com with SMTP id f15so1257936uaq.9
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 17:51:02 -0700 (PDT)
X-Received: by 2002:ab0:35d7:: with SMTP id x23mr41532uat.92.1604019062121;
 Thu, 29 Oct 2020 17:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <20201028131807.3371-1-xie.he.0141@gmail.com> <20201028131807.3371-5-xie.he.0141@gmail.com>
 <CA+FuTSeBZWsy4w4gdPU2sb2-njuEiqbXMgfnA5AdsXkNr__xRA@mail.gmail.com> <CAJht_EMOxSn-hraig1jnF_KwNsYaCYnwaZvVH7rutdS0Lj0sGA@mail.gmail.com>
In-Reply-To: <CAJht_EMOxSn-hraig1jnF_KwNsYaCYnwaZvVH7rutdS0Lj0sGA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 29 Oct 2020 20:50:23 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf-RcVifpTMTw5OYs5Gdrdf-N6-ZyhC5jZF5qbxTa0t3g@mail.gmail.com>
Message-ID: <CA+FuTSf-RcVifpTMTw5OYs5Gdrdf-N6-ZyhC5jZF5qbxTa0t3g@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/4] net: hdlc_fr: Add support for any Ethertype
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 7:53 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Thu, Oct 29, 2020 at 10:24 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > > Also add skb_reset_mac_header before we pass an skb (received on normal
> > > PVC devices) to upper layers. Because we don't use header_ops for normal
> > > PVC devices, we should hide the header from upper layer code in this case.
> >
> > This should probably be a separate commit
>
> OK. I'll make it a separate commit in the next version of the series. Thanks!
>
> > Does it make sense to define a struct snap_hdr instead of manually
> > casting all these bytes?
>
> > And macros or constant integers to self document these kinds of fields.
>
> Yes, we can define a struct snap_hdr, like this:
>
> struct snap_hdr {
>         u8 oui[3];
>         __be16 pid;
> } __packed;
>
> And then the fr_snap_parse function could be like this:
>
> static int fr_snap_parse(struct sk_buff *skb, struct pvc_device *pvc)
> {
>        struct snap_hdr *hdr = (struct snap_hdr *)skb->data;
>
>        if (hdr->oui[0] == OUI_ETHERTYPE_1 &&
>            hdr->oui[1] == OUI_ETHERTYPE_2 &&
>            hdr->oui[2] == OUI_ETHERTYPE_3) {
>                if (!pvc->main)
>                        return -1;
>                skb->dev = pvc->main;
>                skb->protocol = hdr->pid; /* Ethertype */
>                skb_pull(skb, 5);
>                skb_reset_mac_header(skb);
>                return 0;
>
>        } else if (hdr->oui[0] == OUI_802_1_1 &&
>                   hdr->oui[1] == OUI_802_1_2 &&
>                   hdr->oui[2] == OUI_802_1_3) {
>                if (hdr->pid == htons(PID_ETHER_WO_FCS)) {
>
> Would this look cleaner?

Oh, right. The OUI being 3 bytes introduces masking and endianness
issues if casting to a wider type. Similar to IPv6 flowlabel handling,
for instance.

There is a lot of OUI code, such as cea_db_is_hdmi_forum_vsdb. But no
standard way of going about this. Some does byte-by-byte, some memcmp,
some masks.

The existing is probably as concise and readable as anything, and we
don't really care about a few extra branches here. Never mind this
suggestion.
