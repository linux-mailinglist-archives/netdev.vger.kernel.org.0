Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC82C35011B
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 15:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbhCaNUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 09:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235347AbhCaNUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 09:20:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BC6C061574;
        Wed, 31 Mar 2021 06:20:17 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id h10so22271474edt.13;
        Wed, 31 Mar 2021 06:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v54OuxXjYPfnkf0eXlXYXJeCY6yKWqaMFwGEwHKRNUA=;
        b=Va6gkTiy/Yw2vvFF7gj9/X/LvdR91Yg183cL1F2pUosKrIka4zePYCYvs2lndKX37O
         fyPJ9gxmxTP7Aj95tFsoCgoE9J2mJc4w59JhsTD+Y7xIJs6utMQGCv7gKJiuNEjd3leb
         6aSKBWWTiXcxRgLb548agTRau/AKJ5zkUxAFpRzb0QV6jxAky/+mNhhfP1kVW3rIoGU3
         2CHKASXyYCRkGHl9N971+mZ05TVN/Bc2Kg/0gb8RtfX0dUwSzGLGkEL2cQ80buZnM7kZ
         pLt/0qEG7gIfgUDP/jhcywl/L7G/f84L8/IMhEJQpcfMNkKHMeA1o0exjurp3atJIdpT
         RmLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v54OuxXjYPfnkf0eXlXYXJeCY6yKWqaMFwGEwHKRNUA=;
        b=k6+2CH2nfTILLd4JzpAMuK3erumqfQtQGpm4fmjQy0aRa5qSUNKHnAV5ptzM0wbpZ1
         +pef9mmDeoTOwcJBQDHYtT+MPW51qfspAshwNiSBZGZWY5erkPPyZeZab0TSVJyIifmn
         vouvrnrVknYpexGpAl8ahoROf6q169q0G5jeCl42B3nFBPbgnpCPKE6AyEO/sTjjljc8
         bkMi+IgrhU9M9XqICa5HS7ovdBYq5zXestYzIEA1GC+CxoGn0SBYADRVEncqNvEs8zsF
         a8wqD1muczppfqRjGitn4RdU4TZlL/7EApVi2PWl5BPAvFDvdGoHPXACeTr4hYEcmZN7
         BQgA==
X-Gm-Message-State: AOAM532SKtEKUtrM3D8C2bVfhqZUyFZ2az0Rgr3YyBDJ1/Xw/CkeHTKx
        Fx4heQ7cVb1CI3bS4/CLK/M=
X-Google-Smtp-Source: ABdhPJyqP9Ogu0G2cFJk+43OiYbaDjJk8d5XhbXxxWVKEli1Te8lmQkzPqg96zlm2PEBrlf2Ewuu6g==
X-Received: by 2002:a50:fd8b:: with SMTP id o11mr3632089edt.346.1617196815723;
        Wed, 31 Mar 2021 06:20:15 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id m7sm1540798edp.81.2021.03.31.06.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 06:20:15 -0700 (PDT)
Date:   Wed, 31 Mar 2021 16:20:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dsa: Allow default tag protocol to be
 overridden from DT
Message-ID: <20210331125753.5kbr4wexmudwmrjc@skbuf>
References: <20210326105648.2492411-1-tobias@waldekranz.com>
 <20210326105648.2492411-3-tobias@waldekranz.com>
 <20210326125720.fzmqqmeotzbgt4kd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326125720.fzmqqmeotzbgt4kd@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 02:57:20PM +0200, Vladimir Oltean wrote:
> Hi Tobias,
> 
> On Fri, Mar 26, 2021 at 11:56:47AM +0100, Tobias Waldekranz wrote:
> >  	} else {
> > -		dst->tag_ops = dsa_tag_driver_get(tag_protocol);
> > -		if (IS_ERR(dst->tag_ops)) {
> > -			if (PTR_ERR(dst->tag_ops) == -ENOPROTOOPT)
> > -				return -EPROBE_DEFER;
> > -			dev_warn(ds->dev, "No tagger for this switch\n");
> > -			dp->master = NULL;
> > -			return PTR_ERR(dst->tag_ops);
> > -		}
> > +		dst->tag_ops = tag_ops;
> >  	}
> 
> This will conflict with George's bug fix for 'net', am I right?
> https://patchwork.kernel.org/project/netdevbpf/patch/20210322202650.45776-1-george.mccollister@gmail.com/
> 
> Would you mind resending after David merges 'net' into 'net-next'?
> 
> This process usually looks like commit d489ded1a369 ("Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net"). However,
> during this kernel development cycle, I have seen no merge of 'net' into
> 'net-next' since commit 05a59d79793d ("Merge
> git://git.kernel.org:/pub/scm/linux/kernel/git/netdev/net"), but that
> comes directly from Linus Torvalds' v5.12-rc2.
> 
> Nonetheless, at some point (and sooner rather than later, I think),
> David or Jakub should merge the two trees. I would prefer to do it this
> way because the merge is going to be a bit messy otherwise, and I might
> want to cherry-pick these patches to some trees and it would be nice if
> the history was linear.
> 
> Thanks!

Tobias, I think you can safely resend now, I see George's change is in
net-next:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/dsa/dsa2.c#n1084
