Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4B3345263
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 23:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhCVWXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 18:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhCVWXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 18:23:08 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A4EC061574;
        Mon, 22 Mar 2021 15:23:07 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id l18so13066611edc.9;
        Mon, 22 Mar 2021 15:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+UmWQ8kPJJXqVddNG8LsP4AVzZRu2CDgrd9TtFHN7bg=;
        b=XKLX57dAd4p2hdUkJzhJ1MGrcYz2dPIyVoib8MVIEPfoabZ8/fzCJPmD7kMfq3qVFj
         g66vGdMwHp9lXjQ7hcgACDo71VL1MBitXIquRKHh28uIfQBb6xeeTifcLZRob+SSE4EA
         a1gfvUA8g54Jr4YIukATSxseE2Rdyhb1CysE+uLG3nFChLKL5ISVBMa3UlAsZ2JCrroJ
         abz7edLSSVUhJLYzFOZFYsPpYtKN+vv5x0uy8MnaDxvsubA7rXOR+gA2dpEuoAqpCzvI
         zRjj1BXzkUoML9P8NW3rGg2+gJSvqSDu7pgWipxhJY51zSvoB3p5yEMb4AOh4ELe/J62
         BdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+UmWQ8kPJJXqVddNG8LsP4AVzZRu2CDgrd9TtFHN7bg=;
        b=GsnIxuD8P4urSt6aFXSWsVo0kg1yIEprkEGVCNPVx+h2ZjDtOcK2rcAIxOFsONTpa4
         jtO74MYkmCYFDx3im9RgPvhCMejMnzTl0VequLsOdWep1QSzZPprKumDgl1YU/GgKnF6
         bJArCZTuncEvodbbBhjMdOxjB/zhH5PQX1rc2nLZS//R64ZYFpb++ICVW4tuzqkQ0MG/
         2du4HQIE452MnAfSDa8mOiDo4g84/Znmn4Ws2ejFpf0nM/Wdi6tblkMzA2/OBxJZ8XFr
         /MZRTp0vzn+j8zQGFDCwurnvRrU2Cc+BsaTqpdbRljhMVNsAPpOvJadscoMNOo6eJ6dV
         p+7Q==
X-Gm-Message-State: AOAM531yqJOVb9lzQycPjJNktWQQL8WwDRYgNh4a82ElxLgpLPw3jKrd
        IslajqwgYHZS2LlHBCS6F3A=
X-Google-Smtp-Source: ABdhPJzz1jbJGrBOXeWUZI/wu28WPNMFVa7h68kFTv0cjOsgf0MdkNg/7oDJK6QCTZpspGQdZ/ZMRw==
X-Received: by 2002:aa7:db53:: with SMTP id n19mr1820956edt.330.1616451786574;
        Mon, 22 Mar 2021 15:23:06 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id ga28sm5732805ejc.82.2021.03.22.15.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 15:23:06 -0700 (PDT)
Date:   Tue, 23 Mar 2021 00:23:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 14/16] net: dsa: don't set
 skb->offload_fwd_mark when not offloading the bridge
Message-ID: <20210322222304.ehinqbq67ikpubqx@skbuf>
References: <20210318231829.3892920-1-olteanv@gmail.com>
 <20210318231829.3892920-15-olteanv@gmail.com>
 <20210319084025.GA2152639@haswell-ubuntu20>
 <20210319090642.bzmtlzc5im6xtbkh@skbuf>
 <CALW65janF_yztk7hH5n8wZFpWXxbCwQu3m4W=B-n2mcNG+W=Mw@mail.gmail.com>
 <20210319104924.gcdobjxmqcf6s4wq@skbuf>
 <CALW65jYc6DFoUiF55Q3KrhamPf75tFRSAkSA6ONrF3KMf9z+7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jYc6DFoUiF55Q3KrhamPf75tFRSAkSA6ONrF3KMf9z+7g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 04:04:01PM +0800, DENG Qingfang wrote:
> On Fri, Mar 19, 2021 at 6:49 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > Why would you even want to look at the source net device for forwarding?
> > I'd say that if dp->bridge_dev is NULL in the xmit function, you certainly
> > want to bypass address learning if you can. Maybe also for link-local traffic.
> 
> Also for trapped traffic (snooping, tc-flower trap action) if the CPU
> sends them back.

This sounds line an interesting use case, please tell me more about what
commands I could run to reinject trapped packets into the hardware data
path.
