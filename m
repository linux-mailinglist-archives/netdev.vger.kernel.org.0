Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D32453D65
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 02:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhKQBEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 20:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhKQBEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 20:04:20 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D975CC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 17:01:22 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id x7so935293pjn.0
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 17:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q/0e654LrQv/vaE9GBCL2FeX5qIGYA4WIFxR7/U11U0=;
        b=Kun1wbZ2BuFvVXD9QcS6/eMctQEZ15f2vm3P7mrtOLzQaZrNQ26/MuOVXzWUymhm0m
         uQ30aXtQhoUV4lx5LeXAphUK/D4HRa2/zjv/hK+EXyTHLP1hE0Zbo80MURNpfHb7rych
         L+IPcODUikRMrno5d/QkYdc66BXb3WmhowbV+RdTeqABzx5389ncFj7bDePR/bEh8U7C
         9ny17ZYuRpfebrkEx6QWfNqYn759S8aJeSOs4/7Uo37XvBW2fHTIAus0aqM9AbO4JRYS
         FJJeXnwqBpL96oVZfIPEam3ZzZqHSTyQWce8gsxsb7W04tNe8sRW1t8tu+UHIQYoDcTu
         2R5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q/0e654LrQv/vaE9GBCL2FeX5qIGYA4WIFxR7/U11U0=;
        b=h2+HEU0EizYT2fK689DBcCNrG67XllQXMElMVFK3IM/xZ+uaqjQaoJzEkPI14qNRP7
         JW15bgiva3LQ2cLOaWridHUy4kfcjyq+tw+a1uR1eL4O3uWKHXAj9CP1n5bK/Hup5kmq
         xbLwC3MND+UthtYZG4Y7BeZTqxCS+kwuzCZrLeSRvmeHrN1K/2JezIF26zkVutEZHyvo
         jjWJbbyDSahXD0U+FEEBYa7hTM1xytKsHCD10ciNrOuUp2Hm8ZMkhKfmnI7KZFu7Kbm1
         0Wu+FIRmVQPC+Lk4Q4zCJsG5jjqEF6J/NuVDsQTOQ/rOlObu78KXJeqd0h/HJVAYx3IO
         GfLw==
X-Gm-Message-State: AOAM53370nJ5pSSIHhwdznXncfnAR/t7QK2gFavFJ+MW5i4z8kpvS/sX
        1PqM1uc0jEpDajYjEV/0kIU=
X-Google-Smtp-Source: ABdhPJwbqKR0GLpp7maE0jkfHUshnyHNUuqdjPr/I3+w2MDHDB+gF4RqpgLBkxjdMNR6z1pqCJUdcA==
X-Received: by 2002:a17:90b:4a4d:: with SMTP id lb13mr4395946pjb.97.1637110882424;
        Tue, 16 Nov 2021 17:01:22 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c1sm21805984pfv.54.2021.11.16.17.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 17:01:21 -0800 (PST)
Date:   Wed, 17 Nov 2021 09:01:15 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next] Bonding: add missed_max option
Message-ID: <YZRUW6wfMdI1aN1o@Laptop-X1>
References: <20211116084840.978383-1-liuhangbin@gmail.com>
 <20211116120058.494d6204@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116120058.494d6204@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 12:00:58PM -0800, Jakub Kicinski wrote:
> On Tue, 16 Nov 2021 16:48:40 +0800 Hangbin Liu wrote:
> > +	[IFLA_BOND_MISSED_MAX]		= { .type = NLA_U32 },
> 
> Why NLA_U32...
> 
> >  
> >  static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
> > @@ -453,6 +454,15 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
> >  			return err;
> >  	}
> >  
> > +	if (data[IFLA_BOND_MISSED_MAX]) {
> > +		int missed_max = nla_get_u8(data[IFLA_BOND_MISSED_MAX]);
> 
> If you read and write a u8?

Ah, that's a typo. I planed to use nla_get_u32(). But looks NLA_U8 also should
be enough. WDYT?

Thanks
Hangbin
