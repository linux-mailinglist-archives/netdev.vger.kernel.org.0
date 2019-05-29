Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC2E2E25C
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfE2Qhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:37:43 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35187 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfE2Qhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 12:37:43 -0400
Received: by mail-pf1-f194.google.com with SMTP id d126so1991104pfd.2
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 09:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rYXje7pkSQOlawqAWE5SmLuc60hKf0FafMLhT40aro4=;
        b=HzpC0qmw+hi+wxNs0qM40dFyonuMi7Bwb2k+tFbOesTzBeZBOfDBx0+EAkrAoZCUHw
         XYtC7TeTj/1vIUxlmgGzB1AhFFhRBsE+jMIH6a3R5WIAFYvzuLhSBnp/IEEQBkZ5e/ek
         WsQz9YWMWQn+K6ij5Yj5irLOe4DGrjvwRUsI5aK7JHVo0QFgzLQvCKcpAIWAN6s98P8m
         0SYsWPVf0/IuQKFxW4LajOrGMRv+AVFbjaGYwdkJ9EpLTu0A4m+taaOAyVV1IhNAUzeI
         PtJG1T4XS5PhwlMeW4/sVsCIzxLxsZVwqLOXB+WnjakWX9il7Nyt4L5cDR/UsZcLJKhD
         MdrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rYXje7pkSQOlawqAWE5SmLuc60hKf0FafMLhT40aro4=;
        b=X14nHklP8yUnt/CQeIYOomzp3vj54w7ftmH8rhuoBBoDqbcCxmVWqPKgMZNkXu0kc0
         DHTvI2zTGKhs9434XZf7Jz7JjjjLFY84+oHrIXghOXyWDr2zUXvdFUMdUDUBFdW55kGV
         DDMkFPcMEN+70Du4PWxtAmc4c/bRNvr/46RH30NQxR5PAn4ysH0pmWH05EqMl2+farUV
         hxoUPCamYS9IBRiYL+h5r7CGmuC7onrBdSqaiI7U0X4vrQR5eyj1mNtRRb1rwNBjQrZd
         eZKvfqQxMYxbe0zlXSstFWH3vkmYs+4L+DKXtoHmKKRn6eJGy023PzWt9gNB0bnHIkry
         qGOQ==
X-Gm-Message-State: APjAAAWv2U0hPl96HaxRT4pAQcFiKCoRaEa086jOG3+Iz+A8/l/Mo1Hf
        tH+9BDotXsYZ3Dop9fwfAvZQPg==
X-Google-Smtp-Source: APXvYqyxEAEh9Ml0eSaDbqfzNPYl7K6SJN3kxuzDOeDcbyjeiHXPApREIkOKRA2MpiLkXWFsDvT14A==
X-Received: by 2002:a62:1846:: with SMTP id 67mr132559052pfy.33.1559147862067;
        Wed, 29 May 2019 09:37:42 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d24sm45802pjv.24.2019.05.29.09.37.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 May 2019 09:37:41 -0700 (PDT)
Date:   Wed, 29 May 2019 09:35:48 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Driver has suspect GRO implementation, TCP performance may be
 compromised.
Message-ID: <20190529093548.3df7ee73@hermes.lan>
In-Reply-To: <CANn89i+VvwMaHy2Br-0CcC3gPQ+PmG3Urpn4KpqL0P7XBykmcw@mail.gmail.com>
References: <e070e241-fb65-a5b0-3155-7380a9203bcf@molgen.mpg.de>
        <8627ea1e-8e51-c425-97f6-aeb57176e11a@gmail.com>
        <eb730f01-0c6d-0589-36cc-7193d64c1ee8@molgen.mpg.de>
        <CANn89i+VvwMaHy2Br-0CcC3gPQ+PmG3Urpn4KpqL0P7XBykmcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 09:00:54 -0700
Eric Dumazet <edumazet@google.com> wrote:

> On Wed, May 29, 2019 at 7:49 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> >
> > Dear Eric,
> >
> >
> > Thank you for the quick reply.
> >
> > On 05/28/19 19:18, Eric Dumazet wrote:  
> > > On 5/28/19 8:42 AM, Paul Menzel wrote:  
> >  
> > >> Occasionally, Linux outputs the message below on the workstation Dell
> > >> OptiPlex 5040 MT.
> > >>
> > >>     TCP: net00: Driver has suspect GRO implementation, TCP performance may be compromised.
> > >>
> > >> Linux 4.14.55 and Linux 5.2-rc2 show the message, and the WWW also
> > >> gives some hits [1][2].
> > >>
> > >> ```
> > >> $ sudo ethtool -i net00
> > >> driver: e1000e
> > >> version: 3.2.6-k
> > >> firmware-version: 0.8-4
> > >> expansion-rom-version:
> > >> bus-info: 0000:00:1f.6
> > >> supports-statistics: yes
> > >> supports-test: yes
> > >> supports-eeprom-access: yes
> > >> supports-register-dump: yes
> > >> supports-priv-flags: no
> > >> ```
> > >>
> > >> Can the driver e1000e be improved?
> > >>
> > >> Any idea, what triggers this, as I do not see it every boot? Download
> > >> of big files?
> > >>  
> > > Maybe the driver/NIC can receive frames bigger than MTU, although this would be strange.
> > >
> > > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > > index c61edd023b352123e2a77465782e0d32689e96b0..cb0194f66125bcba427e6e7e3cacf0c93040ef61 100644
> > > --- a/net/ipv4/tcp_input.c
> > > +++ b/net/ipv4/tcp_input.c
> > > @@ -150,8 +150,10 @@ static void tcp_gro_dev_warn(struct sock *sk, const struct sk_buff *skb,
> > >                 rcu_read_lock();
> > >                 dev = dev_get_by_index_rcu(sock_net(sk), skb->skb_iif);
> > >                 if (!dev || len >= dev->mtu)
> > > -                       pr_warn("%s: Driver has suspect GRO implementation, TCP performance may be compromised.\n",
> > > -                               dev ? dev->name : "Unknown driver");
> > > +                       pr_warn("%s: Driver has suspect GRO implementation, TCP performance may be compromised."
> > > +                               " len %u mtu %u\n",
> > > +                               dev ? dev->name : "Unknown driver",
> > > +                               len, dev ? dev->mtu : 0);
> > >                 rcu_read_unlock();
> > >         }
> > >  }  
> >
> > I applied your patch on commit 9fb67d643 (Merge tag 'pinctrl-v5.2-2' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl):
> >
> >      [ 5507.291769] TCP: net00: Driver has suspect GRO implementation, TCP performance may be compromised. len 1856 mtu 1500  
> 
> 
> The 'GRO' in the warning can be probably ignored, since this NIC does
> not implement its own GRO.
> 
> You can confirm this with this debug patch:
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c
> b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 0e09bede42a2bd2c912366a68863a52a22def8ee..014a43ce77e09664bda0568dd118064b006acd67
> 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -561,6 +561,9 @@ static void e1000_receive_skb(struct e1000_adapter *adapter,
>         if (staterr & E1000_RXD_STAT_VP)
>                 __vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), tag);
> 
> +       if (skb->len > netdev->mtu)
> +               pr_err_ratelimited("received packet bigger (%u) than
> MTU (%u)\n",
> +                                  skb->len, netdev->mtu);
>         napi_gro_receive(&adapter->napi, skb);
>  }

I think e1000 is one of those devices that only has receive limit as power of 2.
Therefore frames up to 2K can be received.

There always some confusion in Linux about whether MTU is transmit only or devices
have to enforce it on receive.
