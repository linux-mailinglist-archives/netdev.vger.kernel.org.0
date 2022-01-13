Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E28548E102
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 00:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbiAMXg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 18:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbiAMXg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 18:36:28 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0661C061574;
        Thu, 13 Jan 2022 15:36:27 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id o3so12837363wrh.10;
        Thu, 13 Jan 2022 15:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tUo2cMqKLPbXZrnnNNPjbjaaZtZQwLD95xB0k3rASxQ=;
        b=gMZMX9isgGpTMX8AibaOSaw54UrM35vzjEsGBke6kYbnzUmKwibcI2GzWWfAmmw/HP
         0QD9bbdEJiexy52FxaNrH2ZCX/7Us1F6/gAT83jtEDLWkKmvfsAp6jLdLaPTOXOQPh/8
         64N+dDalgGB3prMCjNYKl4m6PHcTpQhQgLuNKXVwuwj7SrOqrsyojk2nim2NhHduU5iY
         7KE80Z3CMeqwmqDixWA0/34UB6L1U/VQFgFmLjENHIVi15Yb+B1wigk64pRK9/TTvoS4
         LUXLavswuG2fRzAlWAd9+5tSGKLmNjbdtsho6QwXcIERQnBiodWNMWpFZ0Riz9R12c1K
         VfqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tUo2cMqKLPbXZrnnNNPjbjaaZtZQwLD95xB0k3rASxQ=;
        b=PEjlep5t8DPKmnZd/CGsumat5YZbykvWxEAaI8NlOsM8rBSjV8Jrg54DnWLGVhRiNT
         wxANLnQ0oT57DONUQL0zD3ZgeANT3VNHSEAmuwUTYp+HBEhEzKz66IeHob/VIN33Ul4g
         +uGML+sd4z9jRx7y71AYHJDdFCjz6FdZwWBCfY8WuE2cqjipvv6dTlvByX/Apcml2WD4
         +RVKzjPt8EYvmleTiYVFLYn1OUxVUVcVFw6txqFFe30kPCbT2A4kZyhYieazGA26UHf2
         4WIyT92Ag/MZEep9wX0HI6lDd6E7FNsr7mx2i5/iEsqlBwe/QiedsWHxHIlZHr1V50aB
         gLDg==
X-Gm-Message-State: AOAM533IaMoIsIlWNqHxitMmZ2Me+kbqnSxWUpFwG5Vwb7L3QajRBazi
        nnBono67RbzRpnxskana1LdXaxJmkeI3nTLLoEU=
X-Google-Smtp-Source: ABdhPJykqZSfG79YfZBppPhjLTyecAz41qXyBbno5e2mN1phneKmbfBubz8nFgDoKll+/XFD9+9atJ0NyCbkwZo28cM=
X-Received: by 2002:adf:d1c7:: with SMTP id b7mr866130wrd.81.1642116986593;
 Thu, 13 Jan 2022 15:36:26 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com> <20220112173312.764660-7-miquel.raynal@bootlin.com>
In-Reply-To: <20220112173312.764660-7-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 13 Jan 2022 18:36:15 -0500
Message-ID: <CAB_54W79S1gtNJtq+wzCig82KqauMXXOtdZ1VaNH97xXQEmUCQ@mail.gmail.com>
Subject: Re: [wpan-next v2 06/27] net: mac802154: Set the symbol duration automatically
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
...
> +               case IEEE802154_4030KHZ_MEAN_PRF:
> +                       duration = 3974;
> +                       break;
> +               case IEEE802154_62890KHZ_MEAN_PRF:
> +                       duration = 1018;
> +                       break;
> +               default:
> +                       break;
> +               }
> +               break;
> +       default:
> +               break;
> +       }
> +
> +set_duration:
> +       if (!duration)
> +               pr_debug("Unknown PHY symbol duration, the driver should be fixed\n");

Why should the driver be fixed? It's more this table which needs to be fixed?

> +       else
> +               phy->symbol_duration = duration;

Can you also set the lifs/sifs period after the duration is known?

- Alex
