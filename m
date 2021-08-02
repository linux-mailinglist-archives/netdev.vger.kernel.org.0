Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22853DDC7D
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbhHBPbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbhHBPbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 11:31:49 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03170C061760;
        Mon,  2 Aug 2021 08:31:39 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id k2so2496285plk.13;
        Mon, 02 Aug 2021 08:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=C5OMswoswv+jB7pgeCuURms//5qLAEczlfx8fB13L08=;
        b=unv2eUIShdKKvqz+C9284ywgySqqiR+tOum9IzVOEsLofRriNzUvN3A7HBu7FbhmsM
         iPzvDdVMDwThWoXP2MSGoBjT60lrGsFimqHMoQA+9bs8tI9npfXl7lIseiLXbNTYHI+g
         FQ8PIw2ePExWM+xXcczRLdZmQkgKq7rNTLyF764+Jl93soMJt+t2JdOHsiYeT+yC+bVj
         kOKZnR5krlpGvm9YkyuTUdfYXD8KskslTEoifv+Kb2FGoypdb63IqNdLPWpzHdrNH4pX
         3Dn5+XK2RisTlkZxuXTVa8vO44pFeVxXCOMgkM8QlIoMmzFRLy+hBNRZbAvZWycSHYHS
         UQXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=C5OMswoswv+jB7pgeCuURms//5qLAEczlfx8fB13L08=;
        b=X0QEzz/f1/DMqE5g3X/YMCKqSMWvUPdIvn/fGemfZsUrZupyWj2N19lJ3pwNwgJ//k
         RF611jWtJo4kvUPIyfYwR4ast0p88hfd2+AXkWS2/VIAzksOjhKHWRK5/rnBYUwaw66F
         ds4Um0EHRpiDMSTYJoZdsCf7tU+pm6VXZkOPGCpKZPBli9odK/YNQ1GPoPt4zd/imvFC
         pbWyDEoTkjfi/c+UJzTgK40zAiJqSUWmoYj8etPm04rvhss2RnzN+1UuwgBuaI0ChoXx
         HuG3VXsmAsCoEyGXr0FrOR/BCnlwzTkoBM93k/e+0ZH9eBa+o9pY5MZdgFSxHusQVFXu
         C83A==
X-Gm-Message-State: AOAM533r/Ipq9kJ7Q7s5KMxv08V76lc7Lj+qiYMX2lW5g3BYEFHP9tqa
        0E0c0LZimAmLPgNxifmEa34=
X-Google-Smtp-Source: ABdhPJz/8Y4cKIXHJVY6ScTVMCLUzj4aFcyHt+HnBAF2k/MyhE1W2QVgMUm5dqGt1LhAXE4LEHk9Zg==
X-Received: by 2002:a63:4e51:: with SMTP id o17mr2314187pgl.126.1627918298584;
        Mon, 02 Aug 2021 08:31:38 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id d22sm6784080pgi.73.2021.08.02.08.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 08:31:37 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Woudstra <ericwouds@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC net-next v2 3/4] net: dsa: mt7530: set STP state also on filter ID 1
Date:   Mon,  2 Aug 2021 23:31:29 +0800
Message-Id: <20210802153129.1817825-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210802134336.gv66le6u2z52kfkh@skbuf>
References: <20210731191023.1329446-1-dqfext@gmail.com> <20210731191023.1329446-4-dqfext@gmail.com> <20210802134336.gv66le6u2z52kfkh@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 04:43:36PM +0300, Vladimir Oltean wrote:
> On Sun, Aug 01, 2021 at 03:10:21AM +0800, DENG Qingfang wrote:
> > --- a/drivers/net/dsa/mt7530.h
> > +++ b/drivers/net/dsa/mt7530.h
> > @@ -181,7 +181,7 @@ enum mt7530_vlan_egress_attr {
> >  
> >  /* Register for port STP state control */
> >  #define MT7530_SSP_P(x)			(0x2000 + ((x) * 0x100))
> > -#define  FID_PST(x)			((x) & 0x3)
> 
> Shouldn't these macros have _two_ arguments, the FID and the port state?
> 
> > +#define  FID_PST(x)			(((x) & 0x3) * 0x5)
> 
> "* 5": explanation?
> 
> >  #define  FID_PST_MASK			FID_PST(0x3)
> >  
> >  enum mt7530_stp_state {
> > -- 
> > 2.25.1
> > 
> 
> I don't exactly understand how this patch works, sorry.
> Are you altering port state only on bridged ports, or also on standalone
> ports after this patch? Are standalone ports in the proper STP state
> (FORWARDING)?

The current code only sets FID 0's STP state. This patch sets both 0's and
1's states.

The *5 part is binary magic. [1:0] is FID 0's state, [3:2] is FID 1's state
and so on. Since 5 == 4'b0101, the value in [1:0] is copied to [3:2] after
the multiplication.

Perhaps I should only change FID 1's state.

