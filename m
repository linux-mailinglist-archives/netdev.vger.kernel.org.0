Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABCC13D5BCD
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbhGZN4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbhGZN4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:56:36 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365FEC061757;
        Mon, 26 Jul 2021 07:37:04 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id go31so2997778ejc.6;
        Mon, 26 Jul 2021 07:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nnXH9OEkX6/64CRIXpm2q4YcE5R0RLwwDJpdnIFDAWY=;
        b=a46eeZbS67P014IPIYYEuugVBwQdVkgc3xe0nHoGpHa+CLu7h3/0rDHMm1C9u0Vaqa
         GG6yKIfhXq34B2c+8u8MmZz/P8VknqBLIWzPDzPE5/00VCC4jSFXgeTKTC2wGXJFy4po
         chD8bkSL5cNkfThbloN9qTqGuQWNoVdPsm6e0ey1QHpVLG6oAxNjaLNpThgTzEHom8O3
         rlR5IsNd9LSI3RhMjDl0t54xClnANAGUaIY+79MwKaKe9CAoBzAEPbX7sz5Dq3JuoZjW
         XJLk4RjT0csljKhvY94qUxjlJ53IISuVPtHFebdaSySPN9o7sgHspaWRzl0/RrZs8zdI
         3kTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nnXH9OEkX6/64CRIXpm2q4YcE5R0RLwwDJpdnIFDAWY=;
        b=WacPbHN2dhzqU17ZSg8xt8SxmWb0+2K7pswURSUUe2VI21TKu+LpS/bNw5VG/Ywa43
         DJ16tbXh0gvSAQc7nxxKBFdnv+Oi/QtTO91cKjzXmWr32d3XmdBRVgH7skIyH+9uvvq3
         gvIcCGOn+/BWMlIFty5K3Buiv0hJ0uvMnmeEA/bNHwzSc3/gMeiaWW3Sc0tuOUcCcvmp
         eydRal0uRjwcgpUu2ILC5TPbsdu6VVUr/w0E9+1HlWiv/x1UCVgpOtJUTHmUelYw8dhT
         jZshFOxvQkfyaV6fnQYjOcwxX7O/768fv5qmnQuUKaBfPY9vRssTEnOhORWxU+ztyXr3
         FD9Q==
X-Gm-Message-State: AOAM533kX5oVFCHVYzFwy4pkEFF/f6zWnsCuSta8NN16K+9CisJzmuPq
        YOpxuFAp5rcGuU8+vWoQaV4=
X-Google-Smtp-Source: ABdhPJzWjQjZmVeAk8PLFry/T+D+4zv8qYEjpty4byCCB34i8VAjKq0MnJQSS8SoToMzbNYfSvQY0g==
X-Received: by 2002:a17:906:8158:: with SMTP id z24mr17367464ejw.359.1627310222797;
        Mon, 26 Jul 2021 07:37:02 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id t15sm14213464ejf.119.2021.07.26.07.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 07:37:02 -0700 (PDT)
Date:   Mon, 26 Jul 2021 17:37:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v6 net-next 5/7] net: bridge: switchdev: let drivers
 inform which bridge ports are offloaded
Message-ID: <20210726143700.6lszvah4jqde3o54@skbuf>
References: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
 <20210721162403.1988814-6-vladimir.oltean@nxp.com>
 <CA+G9fYtaM=hexrmMvDXzeHZKuLCp53kRYyyvbBXZzveQzgDSyA@mail.gmail.com>
 <YP7ByrIz4LvrvIY5@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YP7ByrIz4LvrvIY5@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Naresh,

On Mon, Jul 26, 2021 at 04:08:10PM +0200, Andrew Lunn wrote:
> On Mon, Jul 26, 2021 at 07:21:20PM +0530, Naresh Kamboju wrote:
> > On Wed, 21 Jul 2021 at 21:56, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> > >
> > > On reception of an skb, the bridge checks if it was marked as 'already
> > > forwarded in hardware' (checks if skb->offload_fwd_mark == 1), and if it
> > > is, it assigns the source hardware domain of that skb based on the
> > > hardware domain of the ingress port. Then during forwarding, it enforces
> > > that the egress port must have a different hardware domain than the
> > > ingress one (this is done in nbp_switchdev_allowed_egress).
> 
> > [Please ignore if it is already reported]
> > 
> > Following build error noticed on Linux next 20210723 tag
> > with omap2plus_defconfig on arm architecture.
> 
> Hi Naresh
> 
> Please trim emails when replying. It is really annoying to have to
> page down and down and down to find your part in the email, and you
> always wonder if you accidentally jumped over something when paging
> down at speed.

I agree with what Andrew said.
I've sent this patch to address the build issue you reported. Thanks.
https://patchwork.kernel.org/project/netdevbpf/patch/20210726142536.1223744-1-vladimir.oltean@nxp.com/
