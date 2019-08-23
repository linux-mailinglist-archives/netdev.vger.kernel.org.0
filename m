Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47409B484
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 18:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390951AbfHWQc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 12:32:28 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37482 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfHWQc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 12:32:28 -0400
Received: by mail-ed1-f65.google.com with SMTP id f22so14328042edt.4
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 09:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sLdThN0FeI477VzsJ5dTkt6kMxKyBYiruGmxfMfN2vY=;
        b=bCBQdaHHi5NFpSBajfHtReVme2btpBSqOJSkfAYe5IFXMUsHyh6FSzTlurpKlgnHH/
         +HFxY2R1Ono/tBm3LKKErB8M2lS2ovkjRLlWzom9IRG5yDx8nlSqMbgMKkhnbQDlH6jh
         /31shMzSdEVI9nYLo8eENR55roqVhHQn2JcDK8Gz9nJBtGg9qprqf8Tg5EOleJtwlHnm
         nyi471XcZVVbsdDnpTJI/8m595Fq3C2IWto+zuEV0TfOXWJRlgbE6ucCTxLPKnDGeNUx
         Rz1+UTF9z9cJLVMTKTUg+tV01RAeYPbVls7Od8o6bRjAaYB1oqtW057L0d/9j9GUayqW
         vTqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sLdThN0FeI477VzsJ5dTkt6kMxKyBYiruGmxfMfN2vY=;
        b=sfj5cvwqq8ElyTEdKpYB9RtCpn1YnP3+2B9UaFnlT18M87fg+ehU4Lm3UgXIBKCyGP
         aSseggMblM43hqMA+LMHI3bRfc606JCHJJkQUZTKDKpUM+Sm0Uvin+PNSDYLIVhrQt+m
         OZQuEKaDTRs6R7Vt4dBubYW/PZpqRI/saKHsYkN0ZhtcK5NZd0NHiiHlJqrdPnyu80BJ
         qqeYHLT87IqsCEF/a6sE9oquCvtMh9lx2WETsivRyS1QR2pkSzxsWaNnHCh33G/gpH9m
         KThhxBaYMAykXpjWaZHJmY0CwjOU6+kZ34brkzZbcwmuyhyHgtiYjKmq7Klz2zh8f9Tn
         qXhA==
X-Gm-Message-State: APjAAAX/yMyXmL4WucnxnNE9BxLj9wfdkb+dDp2NOhQC4SJrhHKmMmDr
        KWwZYxOxMqGnZiL7lddG2d7wAlT79S0AmupyX90=
X-Google-Smtp-Source: APXvYqzqEWEQGH/72ZnWYeqrTs9+zRpjhpV5dCZpjZdLesrnX8zoEQs4nUbloH62XqgKAe2rU5vGfuf6UEXji5BQ6k4=
X-Received: by 2002:a50:c385:: with SMTP id h5mr5425115edf.18.1566577946641;
 Fri, 23 Aug 2019 09:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
 <20190822201323.1292-3-vivien.didelot@gmail.com> <f179fa10-3123-d055-1c67-0d24adf3cb08@gmail.com>
 <20190822194304.GB30912@t480s.localdomain> <CA+h21hpgCJ9oKwQxzu62hmvyCOyDZ52R5fYnejprGHWeZR7L6Q@mail.gmail.com>
 <2a43ee4c-0e20-1037-d856-3945d516ea7b@gmail.com>
In-Reply-To: <2a43ee4c-0e20-1037-d856-3945d516ea7b@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 23 Aug 2019 19:32:15 +0300
Message-ID: <CA+h21hpzSNZTK6-wQJkJCC9vs0hao12_tpQRLM5JLXXD_26c_w@mail.gmail.com>
Subject: Re: [PATCH net-next 2/6] net: dsa: do not skip -EOPNOTSUPP in dsa_port_vid_add
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Fri, 23 Aug 2019 at 19:23, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 8/22/19 4:44 PM, Vladimir Oltean wrote:
> > On Fri, 23 Aug 2019 at 02:43, Vivien Didelot <vivien.didelot@gmail.com> wrote:
> >>
> >> Hi Vladimir,
> >>
> >> On Fri, 23 Aug 2019 01:06:58 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> >>> Hi Vivien,
> >>>
> >>> On 8/22/19 11:13 PM, Vivien Didelot wrote:
> >>>> Currently dsa_port_vid_add returns 0 if the switch returns -EOPNOTSUPP.
> >>>>
> >>>> This function is used in the tag_8021q.c code to offload the PVID of
> >>>> ports, which would simply not work if .port_vlan_add is not supported
> >>>> by the underlying switch.
> >>>>
> >>>> Do not skip -EOPNOTSUPP in dsa_port_vid_add but only when necessary,
> >>>> that is to say in dsa_slave_vlan_rx_add_vid.
> >>>>
> >>>
> >>> Do you know why Florian suppressed -EOPNOTSUPP in 061f6a505ac3 ("net:
> >>> dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")?
> >>> I forced a return value of -EOPNOTSUPP here and when I create a VLAN
> >>> sub-interface nothing breaks, it just says:
> >>> RTNETLINK answers: Operation not supported
> >>> which IMO is expected.
> >>
> >> I do not know what you mean. This patch does not change the behavior of
> >> dsa_slave_vlan_rx_add_vid, which returns 0 if -EOPNOTSUPP is caught.
> >>
> >
> > Yes, but what's wrong with just forwarding -EOPNOTSUPP?
>
> It makes us fail adding the VLAN to the slave network device, which
> sounds silly, if we can't offload it in HW, that's fine, we can still do
> a SW VLAN instead, see net/8021q/vlan_core.c::vlan_add_rx_filter_info().
>
> Maybe a more correct solution is to set the NETIF_F_HW_VLAN_CTAG_FILTER
> feature bit only if we have the ability to offload, now that I think
> about it. Would you want me to cook a patch doing that?

sja1105 doesn't support offloading NETIF_F_HW_VLAN_CTAG_FILTER even
though it does support programming VLANs.
Adding an offloaded VLAN sub-interface on a standalone switch port
(vlan_filtering=0, uses dsa_8021q) would make the driver insert a VLAN
entry whilst the TPID is ETH_P_DSA_8021Q.
Maybe just let the driver set the netdev features, similar to how it
does for the number of TX queues?

> --
> Florian

Regards,
-Vladimir
