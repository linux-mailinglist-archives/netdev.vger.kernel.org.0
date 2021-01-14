Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1516A2F5C9A
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 09:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbhANItJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 03:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbhANItI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 03:49:08 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156DEC061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 00:48:22 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id by1so622924ejc.0
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 00:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/czrQQC+4nr84ZXvjU3O3TP7AAP6CJzKZKz3oVwhwpE=;
        b=T30sjzYvcmJm5NMVOotHX1W0vmLEnBCeQei1/b4NgbP58HR0Q+4rCNTIqHlGAIg3dl
         R17f5j1c74THUYhRrkEnmuCRYakcS005ZKg8k/aWnq87Swzgc1mhDgWUwAVme78n1+XP
         eSjGpvbZI7L8S+hn7gXWDdLic/CR2LWW1fcMEWneDA1fcfjwZpTYjW/FeaNdlfzTk/A6
         DA1lZtLx09mtv8SsQza/AG7KLt0hMOZvNEMRleWKJbrqNhvfnO6lwJUWTgk7ZsNkOlkv
         Y/D4nScCzE4IswStZyCNAiqYKAZsi1cqZOQXyVEWG5JXApOOVRnWFFHjVViia24OXK6H
         GQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/czrQQC+4nr84ZXvjU3O3TP7AAP6CJzKZKz3oVwhwpE=;
        b=KchgsQrzMzYSmdoe8DFV2vt6OShK6L8QXZ8vbqz0QXV8EAsCz9+EcVh8qdBA8RbG9g
         gJdHHWee5xzbTHiHJQG6goYVgi3bqxdVBkjY21IIc+POka2V60f73Hgz9PuE9eSbR+vJ
         na0Ehl+M2QxJb334s9Gi9y+aq9SCqA1X2oYz6Ibi3SZzijf5kjsXEPpFfDO7zDT8suVT
         XZjZQF6GVPJtFgaj1QAg7hsfq1BtVphwHohgJx7j+kBhzgsZDC8QBrHQMDZNdJ3926F3
         jfsE+hM8Tvk3pCFIw7BWMn0fxI1cbjmGgjQQbhKoViz2Xhjb/Fxa20myv71+mTDPQshO
         5nxA==
X-Gm-Message-State: AOAM530pv6tCAiWmUIyxwq8bcySL2Uj9ZiwfBYSVIy7d7tsxI2S1d1lS
        D6vAJJcdjSn10uCuK/uZTpq4AiUDMrc=
X-Google-Smtp-Source: ABdhPJybWJihGmxZNQsgd2vpyehkiQQhNOWVb9aA3zSGHvbpohEJjqtMkw7AWm37zD54vpj/3UAyxg==
X-Received: by 2002:a17:906:c5b:: with SMTP id t27mr527841ejf.129.1610614100641;
        Thu, 14 Jan 2021 00:48:20 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h12sm1686991eja.113.2021.01.14.00.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 00:48:20 -0800 (PST)
Date:   Thu, 14 Jan 2021 10:48:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 00/10] Configuring congestion watermarks on
 ocelot switch using devlink-sb
Message-ID: <20210114084818.eht7qbs2grynbqrq@skbuf>
References: <20210111174316.3515736-1-olteanv@gmail.com>
 <20210113192552.7d06261d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113192552.7d06261d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 07:25:52PM -0800, Jakub Kicinski wrote:
> On Mon, 11 Jan 2021 19:43:06 +0200 Vladimir Oltean wrote:
> > In some applications, it is important to create resource reservations in
> > the Ethernet switches, to prevent background traffic, or deliberate
> > attacks, from inducing denial of service into the high-priority traffic.
> >
> > These patches give the user some knobs to turn. The ocelot switches
> > support per-port and per-port-tc reservations, on ingress and on egress.
> > The resources that are monitored are packet buffers (in cells of 60
> > bytes each) and frame references.
> >
> > The frames that exceed the reservations can optionally consume from
> > sharing watermarks which are not per-port but global across the switch.
> > There are 10 sharing watermarks, 8 of them are per traffic class and 2
> > are per drop priority.
> >
> > I am configuring the hardware using the best of my knowledge, and mostly
> > through trial and error. Same goes for devlink-sb integration. Feedback
> > is welcome.
>
> This no longer applies.

I was not expecting you to apply it, giving the feedback.
