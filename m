Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B687749690A
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 02:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiAVBDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 20:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiAVBDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 20:03:17 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3981C06173B
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 17:03:16 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id h12so10589065pjq.3
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 17:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TQvLetWvhyaQTIHplHrE9Pl2RPgFLmZNREIFW3mS/tI=;
        b=ZZSo19U7qmmOooiSWB4gPBCNIaWybHCa2JCD+g66RlDZA7Un9luGXHGHHvMoUM4sbE
         CKBANbtIZAgA/FOigr1YjyKlbfCUtJTfZyw42yPeMDSQGtPFQCQeguapBt0gJ8bpnWCP
         MfdurYClfjRinQejhxX6ZYO8rzaQVCTEqmUK/Sa2AnC2d3KpdCQ5dVn7ZmS3E5sDMUr/
         9uN92mUmYn3m44vYHHPfV6xtHc/oxCpadpfsRVU8DAhPLiZ73c2HA1Mh0L/rLGHBuzD6
         yrVNvfWQYWlUeX/eondMaony4YufP6i/D3M+l7Q9s2i4VN1YtaoXKX4B0BfZT9wcx3+y
         zZvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TQvLetWvhyaQTIHplHrE9Pl2RPgFLmZNREIFW3mS/tI=;
        b=JID8KqxD2scKC4csnKaGVM5ImN++G/0drwgZTEYbyRGlcbYvTlUVV0kAP72FV2et84
         UIsqZO+6/L6xxKJKKYJ6Y8RwpvWtjjWGdXKjX54LDiyrBruK7E1e95KvY8iaynQUMCbI
         EIqyCsc0U+45iQftu9srLVHbNFPW1W0wi3RbD19QbmNiqUKiTjhPovH5Gq3HghMQzVHY
         r37aIPNp4JBMEomVzMCmG3tGPxarrxDHa3LlMGN9oZHpBsgX5F428AvwVJ13ErAXZVge
         I0GfBODtxizjlr1f/nigJaVIzAT+rgE0h3uhZePvMQsWibPDu1SFxyv7jcXtyQ14mGBx
         FguA==
X-Gm-Message-State: AOAM533/FMAB/1JiRRfiSGyiuoO5YpaFkqg/mq5/Uf9FxJhhiyre70bH
        58ieHpArw/yYAUXVdWXt9deh8A==
X-Google-Smtp-Source: ABdhPJy03nKaiqWZw6Z4KfyYZV3tKag09Ww/IIWIkIPUzVom06CrthKWLQrZf25ib96/UiGoV9qG0g==
X-Received: by 2002:a17:903:32c2:b0:14a:2099:eb38 with SMTP id i2-20020a17090332c200b0014a2099eb38mr5993297plr.58.1642813396245;
        Fri, 21 Jan 2022 17:03:16 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id oo9sm1024833pjb.15.2022.01.21.17.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 17:03:15 -0800 (PST)
Date:   Fri, 21 Jan 2022 17:03:13 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sergei Trofimovich <slyich@gmail.com>, netdev@vger.kernel.org
Subject: Re: atl1c drivers run 'napi/eth%d-385' named threads with
 unsubstituted %d
Message-ID: <20220121170313.1d6ccf4d@hermes.local>
In-Reply-To: <YetFsbw6885xUwSg@lunn.ch>
References: <YessW5YR285JeLf5@nz>
        <YetFsbw6885xUwSg@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Jan 2022 00:45:53 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Fri, Jan 21, 2022 at 09:57:47PM +0000, Sergei Trofimovich wrote:
> > Hia atl1c maintainers!
> > 
> > This cosmetics bothered me for some time: atl1c driver
> > shows unexpanded % in kernel thread names. Looks like a
> > minor bug:
> > 
> >     $ ping -f 172.16.0.1  # host1
> >     $ top  # host2
> >     ...
> >     621 root 20 0 0 0 0 S 11.0 0.0 0:05.01 napi/eth%d-385
> >     622 root 20 0 0 0 0 S  5.6 0.0 0:02.64 napi/eth%d-386
> >     ...
> > 
> > Was happening for a few years. Likely not a recent regression.
> > 
> > System:
> > - linux-5.16.1
> > - x86_64
> > - 02:00.0 Ethernet controller: Qualcomm Atheros AR8151 v2.0 Gigabit Ethernet (rev c0)
> >   
> > >From what I understand thread name comes from somewhere around:  
> > 
> >   net/core/dev.c:
> >     int dev_set_threaded(struct net_device *dev, bool threaded)
> >     ...
> >         err = napi_kthread_create(napi);
> >     ...
> >     static int napi_kthread_create(struct napi_struct *n)
> >     ...
> >         n->thread = kthread_run(napi_threaded_poll, n, "napi/%s-%d",
> > 
> >   drivers/net/ethernet/atheros/atl1c/atl1c_main.c:
> >     static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >     ...
> >         dev_set_threaded(netdev, true);
> > 
> >   ${somewhere} (not sure where):
> >     ...
> >       strcpy(netdev->name, "eth%d");
> > 
> > I was not able to pinpoint where expansion should ideally happen.
> > Looks like many driver do `strcpy(netdev->name, "eth%d");` style
> > initialization and almost none call `dev_set_threaded(netdev, true);`.
> > 
> > Can you help me find it out how it should be fixed?  
> 
> Hi Sergei
> 
> This is a fun one.
> 
> So, the driver does the usual alloc_etherdev_mq()
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/atheros/atl1c/atl1c_main.c#L2703
> 
> which ends up here:
> 
> https://elixir.bootlin.com/linux/latest/source/net/ethernet/eth.c#L391
> 
> struct net_device *alloc_etherdev_mqs(int sizeof_priv, unsigned int txqs,
>                                       unsigned int rxqs)
> {
>         return alloc_netdev_mqs(sizeof_priv, "eth%d", NET_NAME_UNKNOWN,
>                                 ether_setup, txqs, rxqs);
> }
> 
> So at this point in time, the device has the name "eth%d".
> 
> The normal flow is that sometime later in probe, it calls
> register_netdev().
> 
> https://elixir.bootlin.com/linux/latest/source/net/core/dev.c#L10454
> 
> if you follow that down, you get to: __dev_alloc_name(), which does
> the expansion of the %d to an actual number:
> 
> https://elixir.bootlin.com/linux/latest/source/net/core/dev.c#L1087
> 
> So between alloc_etherdev_mq() and register_netdev(), the device name
> is not valid. And as you pointed out, dev_set_threaded() tries to use
> the name, and is called between these two.
> 
> The atl1c driver appears to be the only driver actually doing
> this. There is a sysfs interface which can call dev_set_threaded(),
> but the sysfs interface is probably not available until after
> register_netdev() has given the interface its name.
> 
> There is a fix for atl1c. Any time after alloc_etherdev_mq(), the
> driver can call dev_alloc_name().
> 
> So please give this a try. I've not even compile tested it...
> 
> iff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index da595242bc13..983a52f77bda 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -2706,6 +2706,10 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>                 goto err_alloc_etherdev;
>         }
>  
> +       err = dev_alloc_name(netdev, netdev->name);
> +       if (err < 0)
> +               goto err_init_netdev;
> +
>         err = atl1c_init_netdev(netdev, pdev);
>         if (err) {
>                 dev_err(&pdev->dev, "init netdevice failed\n");
> 
> If this works, i can turn it into a real patch submission.
> 
>    Andrew


This may not work right because probe is not called with RTNL.
And the alloc_name is using RTNL to prevent two devices from
getting the same name.
