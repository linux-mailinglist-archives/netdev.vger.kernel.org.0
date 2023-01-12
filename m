Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B1E667978
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240495AbjALPhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240480AbjALPg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:36:57 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE213E0D0;
        Thu, 12 Jan 2023 07:27:37 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id v6so2622439ejg.6;
        Thu, 12 Jan 2023 07:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CrbASCzARhVLuaSBXApRdzfPL5S8978znYbA4CmgqDs=;
        b=SwwDNfbgtHXKLyI4R2Efj2SeDZlyvIhbvVT0EQPnlEtQNm/73tCz2acCDRM8C6hGkj
         Wx+WPbNvl2f6CrCSLji1Xivoma14wmMQdgGQlt+uRY/iq68FmsajSKN3qVCS+ZLlqXvQ
         31M2BnksUUZinJ+JMW931PCfOfdLKRfuBnwyc5nkIQecl2zO393xJCAg+xv2VFtUz5k7
         llrVH6Vd5DgfMgOgrcHX/LsPoZTL+Wxe/2/PlATTrpYDXM5EGrnCMXzoO8UGPTD6h9gi
         7NDDmRQikmNpbEaRsRqZRfXF6AnIvG3Dfbo9paMunOCetTHExyxW9suJerCQrG6m0QHM
         Oydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CrbASCzARhVLuaSBXApRdzfPL5S8978znYbA4CmgqDs=;
        b=nV92YZvoSBXpmzGgRSYEB2wQNjeQeYwlNybX5tK1GFiyYIYnU+O1k9WqIQjhyiNtIl
         qK06QZ0KDnZb+XwPdEJu3Q68tOjXur/pPOB38KRh8A6JP2MmopNkuiDnUXM/2QVJNCbN
         VfozrgoiODSf6tUT13gsJLKtsPCxpWxhhBfOVCxC289kMM9nDmY3Yjv4DtDBE28nKhZq
         KvTcNAE0QnRqmZY+gLPwTsMDSRGTCDeHVmc8uET1FXu3uO2Cyhm9om9TlC6WDLUveO65
         /8Brh16PugnU5Cd2waylYiZ5dv8075ceO6hTHRyv253QjfY3C3VvCvTD8Kklosj2S9GQ
         q9Mw==
X-Gm-Message-State: AFqh2kqvfynYN/BipPcU5mGCp4m46m+oLwrQqIWSDyvtMT0UeUS/EdCy
        4kjbKLIi8/Hf1LtspXR/3ug=
X-Google-Smtp-Source: AMrXdXtiw3aoWtSXJ9xoLcmv+rCXEEgL046vLRJKWB8A9VVqoTKgbwxA2TlBIxvThwtDU7f7qWXpfA==
X-Received: by 2002:a17:907:7da4:b0:78d:f455:b5dc with SMTP id oz36-20020a1709077da400b0078df455b5dcmr81517523ejc.28.1673537255980;
        Thu, 12 Jan 2023 07:27:35 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906201100b007bff9fb211fsm7445714ejo.57.2023.01.12.07.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 07:27:35 -0800 (PST)
Date:   Thu, 12 Jan 2023 16:27:37 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: Re: [PATCH net-next 1/1] plca.c: fix obvious mistake in checking
 retval
Message-ID: <Y8Am6VGQRRgPCuBk@gvm01>
References: <f6b7050dcfb07714fb3abdb89829a3820e6a555c.1673458121.git.piergiorgio.beruto@gmail.com>
 <CANn89i+Y-j4RSX7UQO+P6sB9WGsA8ZDb+ruqEv-iJKtzEvGstQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+Y-j4RSX7UQO+P6sB9WGsA8ZDb+ruqEv-iJKtzEvGstQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 03:45:03PM +0100, Eric Dumazet wrote:
> On Wed, Jan 11, 2023 at 6:30 PM Piergiorgio Beruto
> <piergiorgio.beruto@gmail.com> wrote:
> >
> > This patch addresses a wrong fix that was done during the review
> > process. The intention was to substitute "if(ret < 0)" with
> > "if(ret)". Unfortunately, in this specific file the intended fix did not
> > meet the code.
> >
> 
> Please add a Fixes: tag, even for a patch in net-next
Ok, will do, thanks!
> 
> Fixes: 8580e16c28f3 ("net/ethtool: add netlink interface for the PLCA RS")
> 
> > Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> > ---
> >  net/ethtool/plca.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/ethtool/plca.c b/net/ethtool/plca.c
> > index d9bb13ffc654..9c7d29186b4e 100644
> > --- a/net/ethtool/plca.c
> > +++ b/net/ethtool/plca.c
> > @@ -61,7 +61,7 @@ static int plca_get_cfg_prepare_data(const struct ethnl_req_info *req_base,
> >         }
> >
> >         ret = ethnl_ops_begin(dev);
> > -       if (!ret)
> > +       if (ret)
> >                 goto out;
> >
> >         memset(&data->plca_cfg, 0xff,
> > @@ -151,7 +151,7 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
> >                                          tb[ETHTOOL_A_PLCA_HEADER],
> >                                          genl_info_net(info), info->extack,
> >                                          true);
> > -       if (!ret)
> 
> Canonical way of testing an error from ethnl_parse_header_dev_get() is:
> 
> if (ret < 0)
>     return ret;
> 
> 
> Please double check for the rest of the patch (ethnl_ops_begin() ... )
Ok, this is what I had originally. I changed that due to another review
comment. I'll revert this change.
> 
> 
> > +       if (ret)
> >                 return ret;
> >
> >         dev = req_info.dev;
> > @@ -171,7 +171,7 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
> >         }
> >
> >         ret = ethnl_ops_begin(dev);
> > -       if (!ret)
> > +       if (ret)
> >                 goto out_rtnl;
> >
> >         memset(&plca_cfg, 0xff, sizeof(plca_cfg));
> > @@ -189,7 +189,7 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
> >                 goto out_ops;
> >
> >         ret = ops->set_plca_cfg(dev->phydev, &plca_cfg, info->extack);
> > -       if (!ret)
> > +       if (ret)
> >                 goto out_ops;
> >
> >         ethtool_notify(dev, ETHTOOL_MSG_PLCA_NTF, NULL);
> > @@ -233,7 +233,7 @@ static int plca_get_status_prepare_data(const struct ethnl_req_info *req_base,
> >         }
> >
> >         ret = ethnl_ops_begin(dev);
> > -       if (!ret)
> > +       if (ret)
> >                 goto out;
> >
> >         memset(&data->plca_st, 0xff,
> > --
> > 2.37.4
> >
Thanks!
Piergiorgio
