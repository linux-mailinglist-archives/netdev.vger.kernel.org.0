Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0761475916
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 13:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242594AbhLOMsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 07:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhLOMsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 07:48:02 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C32C061574;
        Wed, 15 Dec 2021 04:48:01 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id r11so73587780edd.9;
        Wed, 15 Dec 2021 04:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=G4iF7vOKf1CBkEpRcRf0oLiHOYP/mA9+IrPFcVd3QlU=;
        b=BKiqnk7mas8DsOQtPzaV4pJghP+0Hb1p5bEQfpNlt/LzNwYyNUqdHRX038Z+Dy06+4
         vfpZnd+dDtUWOdGe2Ilj1g06iHB9YdlT10b3xWd5n55ELkUWrTK6sW1n3XNToRmQ16qz
         1ciuI16j5CkYwggJAugSry2uloAohNuZczZ+j1ttB+DUWKi2PK6I8fOqVXhgaREzQIaQ
         fNHjrb6ZXtigAXG9ID5K3vFGyGDawR0eTrAOf7xN/c0IL4wMlbDdoYlSX6DzEmjh5aun
         osV8Sk8cYNiMLPyNZpGIvljNmCjYyAO93USK0YdXiDDdRP2C/i37tNzRXOayfUOnaG4s
         lyeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=G4iF7vOKf1CBkEpRcRf0oLiHOYP/mA9+IrPFcVd3QlU=;
        b=DeeKJIJZxBA5BmqMqFSn9VfoK507kDdKasK2HlGPLqNLyV/H4w/uFvTg3Bi5W1LfDh
         onYJmv/LKtdbrgofu8psgN574G4Ow8qQHESE8anuEhL2nN/GZE/uWqHG4JtSv8OV7Kqu
         IKs5g21Q/jV8kwfykI/ujswo9vczF0hjikO5rMiu+v3qmZO50zLayj0N6MB4iX6FBZ0h
         PAODCDJYR+BSm9H3U8oj/67d7EMpKIbvVQBiQFoC74zaBAd1tTeKOCo4u3/v/qIvX17z
         0tOUmI/6muAkMsU9xL2qd8tRV0Rc7e0HofMlkj/s65eSIMohFzx3J1I/4WNRtbK4n+k4
         YWIQ==
X-Gm-Message-State: AOAM530VlprmTwxTzumH6acxGn1cmKiFE0vWW6TUbaUot5T/+m+kTJTS
        vydSFDVwMRja5Dv7rhsF6Ek=
X-Google-Smtp-Source: ABdhPJzg5AEApCFKM9k1xMgVdQuO4FrvpsYK2L4MgdNCEfz193rMJW48HLKjwcCIRDJ1WuoQW5LgYQ==
X-Received: by 2002:a17:907:7da0:: with SMTP id oz32mr11131887ejc.176.1639572480204;
        Wed, 15 Dec 2021 04:48:00 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id dz18sm999044edb.74.2021.12.15.04.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 04:47:59 -0800 (PST)
Date:   Wed, 15 Dec 2021 14:47:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH RFC v6 12/16] net: dsa: qca8k: add support for
 mdio read/write in Ethernet packet
Message-ID: <20211215124758.4sxjusutfoab5gzt@skbuf>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
 <20211214224409.5770-13-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211214224409.5770-13-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 11:44:05PM +0100, Ansuel Smith wrote:
> +static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
> +				      enum dsa_tag_protocol proto)
> +{
> +	struct qca8k_priv *qca8k_priv = ds->priv;
> +
> +	switch (proto) {
> +	case DSA_TAG_PROTO_QCA:
> +		struct tag_qca_priv *priv;

Actually this fails to compile:

drivers/net/dsa/qca8k.c: In function ‘qca8k_connect_tag_protocol’:
drivers/net/dsa/qca8k.c:2893:3: error: a label can only be part of a statement and a declaration is not a statement
 2893 |   struct tag_qca_priv *priv;
      |   ^~~~~~
make[3]: *** [scripts/Makefile.build:287: drivers/net/dsa/qca8k.o] Error 1

This is what the {} brackets are for.

Also, while you're at this, please name "priv" "tagger_data".

> +
> +		priv = ds->tagger_data;
> +
> +		mutex_init(&qca8k_priv->mdio_hdr_data.mutex);
> +		init_completion(&qca8k_priv->mdio_hdr_data.rw_done);
> +
> +		priv->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
> +
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
>  }
