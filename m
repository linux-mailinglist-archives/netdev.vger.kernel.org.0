Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBCC2E1CE
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfE2QBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:01:11 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:36446 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfE2QBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 12:01:10 -0400
Received: by mail-yw1-f68.google.com with SMTP id e68so1293875ywf.3
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 09:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XPrHCbcCsNef2jSZM/g/XQcezPiyqyIiC5REnh0/eSU=;
        b=u05Zb0trAPOZWtt+gcSapUiKAhRmlKzjqRravknOondeT/3wa6ADIj8DY7WfXOyOLH
         fMJMu9Q+2QLQKPNqpzfdlikJSWDoozUo+ep+yElgkrB07qG6DxzjbFOGSDR0DDwBdpib
         MV4TCgjHYk7KN0kP42CwWaFEu4bOCRnUJQPF08DFFI04VYgqDROaZ+Ec87P6gS+M+Lyf
         jwl1VZ94mKViet2J/Qz0H2dYP1PRGLJD3JSCqt1g7oorovfWQX5VAWjPX8vjxGtwurcB
         mswhIDPfza+bD3GdvMi8Vl+sGU+u9VECrmn3EpAK6PQzyU29oFdf1iA5x5CaLa3d0XiN
         B+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XPrHCbcCsNef2jSZM/g/XQcezPiyqyIiC5REnh0/eSU=;
        b=GT+FHf5LnVbLg2wLPCrGU1B+EY+SWt4kB6nsPTmP4D+bOrV4RROU5VaG7XOYkPr2cw
         W7iPd/sYIFV7uKGX9SB1m5rwF7IrHlkNLN0BtzuCdBzDh3FxtoxpFZPUhcwcE1VdM0gG
         m2Xa2jaY5FpeIpBJH32SBl/xQYsKLgEEaOknPw/LwBK0lXiAcanenmlOApfTctBzYYeK
         DwW+Oo7BIBcPjAsWNyj0AJ73xqlQG5D7dFUq2m9TkfsUaPL+ZqwxtrahSA1DGV7+BIxg
         sEj+masc5t0JRb8r/JwLdZn1vUEOovWiAcH9wZvHs6+rzRCLXhHBQCrZR8FXbTvbqXJp
         RmqA==
X-Gm-Message-State: APjAAAXMx3c8paFW2RXxyh4eXnjT0UAJHvqM4pd5YgfXhg+d8Q75op0/
        iQl9Z05KemGBIlPDP1ii9oj1Jl9Dtldief/0K593Pw==
X-Google-Smtp-Source: APXvYqwfxD9KIX8UqVjT1h6eHKGyi7P+1pkf9cBDw9YJsI/OY+BmVcm2eVABC+x9PT5lSCxxPsKn+fs9F+HYQe0nEp8=
X-Received: by 2002:a81:6946:: with SMTP id e67mr44438984ywc.424.1559145665722;
 Wed, 29 May 2019 09:01:05 -0700 (PDT)
MIME-Version: 1.0
References: <e070e241-fb65-a5b0-3155-7380a9203bcf@molgen.mpg.de>
 <8627ea1e-8e51-c425-97f6-aeb57176e11a@gmail.com> <eb730f01-0c6d-0589-36cc-7193d64c1ee8@molgen.mpg.de>
In-Reply-To: <eb730f01-0c6d-0589-36cc-7193d64c1ee8@molgen.mpg.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 29 May 2019 09:00:54 -0700
Message-ID: <CANn89i+VvwMaHy2Br-0CcC3gPQ+PmG3Urpn4KpqL0P7XBykmcw@mail.gmail.com>
Subject: Re: Driver has suspect GRO implementation, TCP performance may be compromised.
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 7:49 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Eric,
>
>
> Thank you for the quick reply.
>
> On 05/28/19 19:18, Eric Dumazet wrote:
> > On 5/28/19 8:42 AM, Paul Menzel wrote:
>
> >> Occasionally, Linux outputs the message below on the workstation Dell
> >> OptiPlex 5040 MT.
> >>
> >>     TCP: net00: Driver has suspect GRO implementation, TCP performance may be compromised.
> >>
> >> Linux 4.14.55 and Linux 5.2-rc2 show the message, and the WWW also
> >> gives some hits [1][2].
> >>
> >> ```
> >> $ sudo ethtool -i net00
> >> driver: e1000e
> >> version: 3.2.6-k
> >> firmware-version: 0.8-4
> >> expansion-rom-version:
> >> bus-info: 0000:00:1f.6
> >> supports-statistics: yes
> >> supports-test: yes
> >> supports-eeprom-access: yes
> >> supports-register-dump: yes
> >> supports-priv-flags: no
> >> ```
> >>
> >> Can the driver e1000e be improved?
> >>
> >> Any idea, what triggers this, as I do not see it every boot? Download
> >> of big files?
> >>
> > Maybe the driver/NIC can receive frames bigger than MTU, although this would be strange.
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index c61edd023b352123e2a77465782e0d32689e96b0..cb0194f66125bcba427e6e7e3cacf0c93040ef61 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -150,8 +150,10 @@ static void tcp_gro_dev_warn(struct sock *sk, const struct sk_buff *skb,
> >                 rcu_read_lock();
> >                 dev = dev_get_by_index_rcu(sock_net(sk), skb->skb_iif);
> >                 if (!dev || len >= dev->mtu)
> > -                       pr_warn("%s: Driver has suspect GRO implementation, TCP performance may be compromised.\n",
> > -                               dev ? dev->name : "Unknown driver");
> > +                       pr_warn("%s: Driver has suspect GRO implementation, TCP performance may be compromised."
> > +                               " len %u mtu %u\n",
> > +                               dev ? dev->name : "Unknown driver",
> > +                               len, dev ? dev->mtu : 0);
> >                 rcu_read_unlock();
> >         }
> >  }
>
> I applied your patch on commit 9fb67d643 (Merge tag 'pinctrl-v5.2-2' of
> git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl):
>
>      [ 5507.291769] TCP: net00: Driver has suspect GRO implementation, TCP performance may be compromised. len 1856 mtu 1500


The 'GRO' in the warning can be probably ignored, since this NIC does
not implement its own GRO.

You can confirm this with this debug patch:

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c
b/drivers/net/ethernet/intel/e1000e/netdev.c
index 0e09bede42a2bd2c912366a68863a52a22def8ee..014a43ce77e09664bda0568dd118064b006acd67
100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -561,6 +561,9 @@ static void e1000_receive_skb(struct e1000_adapter *adapter,
        if (staterr & E1000_RXD_STAT_VP)
                __vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), tag);

+       if (skb->len > netdev->mtu)
+               pr_err_ratelimited("received packet bigger (%u) than
MTU (%u)\n",
+                                  skb->len, netdev->mtu);
        napi_gro_receive(&adapter->napi, skb);
 }
