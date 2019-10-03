Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5468FCAF07
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbfJCTPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:15:42 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46813 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730382AbfJCTPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:15:42 -0400
Received: by mail-ed1-f67.google.com with SMTP id t3so3585153edw.13
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 12:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vALguFsfrfWNc5BmG1Fs2+rbITu7uKOWUqCot5PmFec=;
        b=SfuJ2OSo7OwFp6xGmwoMK+rloXosdeW9Wq+A62MSRqHAf+Mz76WxWuZnpXFGVS1jKI
         FOpUkHgVvYvzsRIp8+gHJP1mBxxE6147d++aleusYYA/BrwfrShYwI1MBXZ7XNsFgHRP
         Hl8ZKVPbPlRyAGfnqZSE0yaQvcxI+zCcvWMTVPsP7n1ZFXXtnhm97X/fWlUPBnorUsOt
         O3LP1zBjJMceV8pxEpIOwBEw2baArr4KpZRfmbvje7bCXPfrl2xi5q0cMMxQdUsESU6p
         a9uLKPNNSHt522heLQx9LGwsVmcLw798gnpXeFM7xaczEYFC4m5Oue43clfPnM4KVVHF
         dlVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vALguFsfrfWNc5BmG1Fs2+rbITu7uKOWUqCot5PmFec=;
        b=Lwa4GauRDjrjuUcdaDpvi0/qcFECUuWiDCGCpRKY/tdomKVamgrIbtVBszUoX9M3Lf
         ZLC66kM20dNsVv9bD4XaGA/+zSqygSkHSVufhxGMarv1AY+cemZ3nyERLyuDC7nh+AW4
         XRuATculENbdrBDcoTcg7asH4w2TbIPn5SRj8TCKV4r/1GSUnu7tnAF62xj+MPIbmdU7
         rz+70D662HPv5+3y2lT00VGv4OwlgZ5r30FYKKzcTnAnATez8x1HFZMXwrfjvaok9q0g
         VPEGAZEOzftyYDhAtUQ73HvKgP/dINvpZa0u1cIUtR3DcRJhoQ5STq70ASb7Chkg+Jra
         f2yg==
X-Gm-Message-State: APjAAAW+jVvUYLLkc/YTcqFWkwJFiE30acEDXfPZOIAtyET5e5CR7Mwe
        axtFOeRHAAXzMAMZjz3z3EVrogY0QI7325k888k=
X-Google-Smtp-Source: APXvYqzReNxzHdsXaCL0i7GiKYYfpIYuzhU/p60Z1UEg/xxSPMB7Zb/8swLojZJWZD9+QnIwqs5eL6gYi6jt7MKXR4E=
X-Received: by 2002:a17:906:82d3:: with SMTP id a19mr8935510ejy.151.1570130140650;
 Thu, 03 Oct 2019 12:15:40 -0700 (PDT)
MIME-Version: 1.0
References: <20191002233443.12345-1-olteanv@gmail.com> <20191003.120434.606814989607407144.davem@davemloft.net>
In-Reply-To: <20191003.120434.606814989607407144.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 3 Oct 2019 22:15:29 +0300
Message-ID: <CA+h21hoKgFqK6aYErL_dpY+g+-6FzH5vbcuuAZ60Pnev8cn55A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: sja1105: Add support for port mirroring
To:     David Miller <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Thu, 3 Oct 2019 at 22:04, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Thu,  3 Oct 2019 02:34:43 +0300
>
> > +     already_enabled = (general_params->mirr_port != SJA1105_NUM_PORTS);
> > +     if (already_enabled && enabled && general_params->mirr_port != to) {
> > +             dev_err(priv->ds->dev,
> > +                     "Delete mirroring rules towards port %d first", to);
> > +             return -EBUSY;
> > +     }
>
> In this situation, the user is trying to add a mirror rule to port 'to'
> when we already have rules pointing to "general_params->mirr_port".
>
> So you should be printing out the value of "general_params->mirr_port"
> in this message rather than 'to'.

Good catch, thanks.

-Vladimir
