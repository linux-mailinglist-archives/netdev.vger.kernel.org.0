Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC0E496C48
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 13:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbiAVMMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 07:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbiAVMMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 07:12:32 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CEEC06173B
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 04:12:31 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id p15so7531244ejc.7
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 04:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7/xqh+L4KZEjLRf9x358Hf7dwqbrJnWC0XErPPybLJk=;
        b=eHMJ72qMZdSaI1jj6EzWWRj60ygDKfKzDnLh6EmAWLWNCabK3ZwldgKomWZA9TB0HM
         P6oGT5DV5wma2CROWhnXF6JAsLeMN1GhufnE+f5VWMS575Nt0eFViaJOkjciCHHiR3s4
         NnNL2/fjFAtylRmhed6hyvERrFm4l9KIzNV97/5ZQ3upqDMqBo24Xdbk49QrfIgCQ4G4
         hCwLNiEHZYOt60s3IahWkqkaKuIiJIDaK68QdT0iRM7z5MTekARwPtfcmA/b0h/1D9Zg
         rZDKdfPLoL+WvfgjvrLoqmd2LFlUqDSYq9rao/wtYQlLC9Z//6ncJqM7ocLuUv+HkIgZ
         Bcsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/xqh+L4KZEjLRf9x358Hf7dwqbrJnWC0XErPPybLJk=;
        b=Sm8pO1XYj3u6ASyQV2v5sTFcyK0FupbalPQoDxgiN20O5GRtFwOugM+2BT2ASvmGE8
         Rhnyh7y4VQ44Sqn06uq0iEBVuGrRnN50nfgqR8Hcp1BlgBbbTcXOKqLJyPTa+QJ6XI8L
         eaDHVz4QdLYbMXKhRg0mTYKLw1uvZmzKcFdkxQxJxrdehsZUPxgRVH3FKE1zkQEr6q8O
         dVFP/+joN9RnFsc7l6AULafKrE7euwYtBP2otCeeOgYr+1fpCQaCIUnjKd1dGDLMfsMm
         pcqoV57lB8pbs/9JdLfpRChKxv5crcrWNNDvx473OA8Caq2ZbnNOi9io2lb8rNndRRVD
         Zy6g==
X-Gm-Message-State: AOAM532O4HmLlDv5H596peDZrhkoNY/8lj+60TqCO5BMx8WkVG2wxEud
        8qZ+GlrmLWPfCzJ1T2irv5rmF7DcDFs=
X-Google-Smtp-Source: ABdhPJx4RaBmOM/RSB+AuwQdz/SdtkRS4lm0LoZdS6P5nMtZ2hAquax73wh8+dy4iXi+h+bwjUOqCQ==
X-Received: by 2002:a17:906:3004:: with SMTP id 4mr6282531ejz.579.1642853550406;
        Sat, 22 Jan 2022 04:12:30 -0800 (PST)
Received: from nz (host81-129-87-131.range81-129.btcentralplus.com. [81.129.87.131])
        by smtp.gmail.com with ESMTPSA id v10sm3626060edx.36.2022.01.22.04.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 04:12:29 -0800 (PST)
Date:   Sat, 22 Jan 2022 12:12:28 +0000
From:   Sergei Trofimovich <slyich@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: atl1c drivers run 'napi/eth%d-385' named threads with
 unsubstituted %d
Message-ID: <20220122121228.3b73db2a@nz>
In-Reply-To: <YetjpvBgQFApTRu0@lunn.ch>
References: <YessW5YR285JeLf5@nz>
        <YetFsbw6885xUwSg@lunn.ch>
        <20220121170313.1d6ccf4d@hermes.local>
        <YetjpvBgQFApTRu0@lunn.ch>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Jan 2022 02:53:42 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> > > So please give this a try. I've not even compile tested it...
> > > 
> > > iff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > > index da595242bc13..983a52f77bda 100644
> > > --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > > +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > > @@ -2706,6 +2706,10 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> > >                 goto err_alloc_etherdev;
> > >         }
> > >  
> > > +       err = dev_alloc_name(netdev, netdev->name);
> > > +       if (err < 0)
> > > +               goto err_init_netdev;
> > > +
> > >         err = atl1c_init_netdev(netdev, pdev);
> > >         if (err) {
> > >                 dev_err(&pdev->dev, "init netdevice failed\n");
> > > 
> > > If this works, i can turn it into a real patch submission.
> > > 
> > >    Andrew  
> > 
> > 
> > This may not work right because probe is not called with RTNL.
> > And the alloc_name is using RTNL to prevent two devices from
> > getting the same name.  
> 
> Oh, yes. I looked at some of the users. And some do take rtnl before
> calling it. And some don't!
> 
> Looking at register_netdev(), it seems we need something like:
> 
> 	if (rtnl_lock_killable()) {
> 	       err = -EINTR;
> 	       goto err_init_netdev;
> 	}
> 	err = dev_alloc_name(netdev, netdev->name);
> 	rtnl_unlock();
> 	if (err < 0)
> 		goto err_init_netdev;
> 
> 
> It might also be a good idea to put a ASSERT_RTNL() in
> __dev_alloc_name() to catch any driver doing this wrong.

Thank you Andrew! I used this second version of your patch
against 5.16.1 and it seems to work:

    $ sudo ping -f 172.16.0.1

    613 root 20 0 0 0 0 S 11.0 0.0 0:07.46 napi/eth0-385
    614 root 20 0 0 0 0 R  5.3 0.0 0:03.96 napi/eth0-386

Posting used diff as is just in case:

Tested-by: Sergei Trofimovich <slyich@gmail.com>

--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2706,6 +2706,15 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_alloc_etherdev;
 	}

+	if (rtnl_lock_killable()) {
+		err = -EINTR;
+		goto err_init_netdev;
+	}
+	err = dev_alloc_name(netdev, netdev->name);
+	rtnl_unlock();
+	if (err < 0)
+		goto err_init_netdev;
+
 	err = atl1c_init_netdev(netdev, pdev);
 	if (err) {
 		dev_err(&pdev->dev, "init netdevice failed\n");

-- 

  Sergei
