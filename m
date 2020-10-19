Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E27292182
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 05:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731675AbgJSDtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 23:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731306AbgJSDtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 23:49:35 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F336FC061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 20:49:33 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id o9so4288257plx.10
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 20:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yyMfIj+kU8+pqrQ/btCQJu8vMqR44MABK0jC++tcDuc=;
        b=RYt9d+azGgStnRt0SNLnN11Rr7nZcJ+Zg9OU0+R+m6nCqztUI3jPodgexIgCCTLtLF
         Pk5Rnx1ngzQ1STJRMte6/QS/w1iaLXooxdIMP6hCDfWKd964vczGIeeJeVIKbh8QARRe
         FIQKb+rE40JeAZjrGyJc7ukboR2OCDgkYY+e0AVyDLa4WHnerH6uzMkv5+tZtKZag5pX
         3SbA+MplO2eITH3cwzw47VVFWP7glWIljFBfgA/huafNM66iLZFm0a+Q9SFSg+R0672r
         3FaODC/WzSwgfg7J6UoYTL7myzEwgaKuWpdnbewVtIKBQHUGUOnJfz9flgGvChZU+5XW
         NtXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yyMfIj+kU8+pqrQ/btCQJu8vMqR44MABK0jC++tcDuc=;
        b=uaYEZK8Gszb/K2ES8G2+ID3LotjdiX5xVKRpRovaoAOg//Yu9VJ9vd090UfKmqAomp
         qAh+U6lZt+PA6Gdkrb+myjflLqVd2F1pEmvJqpCMQQ64Fj4rdrMDgX8cNSlnAbcsBbcH
         wZ2P9CDNiNrtB0aN+IgDjwdSGdO3UjL07ZTmCxd79lpiTk++hm1t2iu3E4MzZb4BDfT6
         6h7einCiddlmP1PtJ8vF4py+MWPpFSd0PrttoxUqjeKninGnPCqAxPBiPCj8oJTIDT3K
         tfRN61GymB9Py66Em7dBUrur6jo5ySJl+EHJVAjxsE0Bdnd1VqBW5jGEXtjJMr+u550l
         f+jA==
X-Gm-Message-State: AOAM533or3GuO9paO+heUSWpdqXZ8wOyfHkPS34ICGEFNngJWPcRaUXd
        tkY+1ecpcoD/I0xFY5TF3pA=
X-Google-Smtp-Source: ABdhPJzr80C0rq9DtLuBQ3vH+ifwabUajKWBuOTbBACTCqGg6b9My0stJoF0DlBwCIU99zCCX372JA==
X-Received: by 2002:a17:90b:717:: with SMTP id s23mr16217181pjz.122.1603079373524;
        Sun, 18 Oct 2020 20:49:33 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y5sm10652206pge.62.2020.10.18.20.49.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2020 20:49:32 -0700 (PDT)
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-2-vladimir.oltean@nxp.com>
 <06538edb-65a9-c27f-2335-9213322bed3a@gmail.com>
 <20201018121640.jwzj6ivpis4gh4ki@skbuf>
 <19f10bf4-4154-2207-6554-e44ba05eed8a@gmail.com>
 <20201018134843.emustnvgyby32cm4@skbuf>
 <2ae30988-5918-3d02-87f1-e65942acc543@gmail.com>
 <20201018225820.b2vhgzyzwk7vy62j@skbuf>
 <b43ad106-9459-0ce9-0999-a6e46af36782@gmail.com>
 <20201019002123.nzi2zhfak3r3lis3@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Message-ID: <da422046-fc3e-9aba-88d1-e7a4d3a74843@gmail.com>
Date:   Sun, 18 Oct 2020 20:49:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201019002123.nzi2zhfak3r3lis3@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/18/2020 5:21 PM, Vladimir Oltean wrote:
> On Sun, Oct 18, 2020 at 04:11:14PM -0700, Florian Fainelli wrote:
>> How about when used as a netconsole? We do support netconsole over DSA
>> interfaces.
> 
> How? Who is supposed to bring up the master interface, and when?
> 

You are right that this appears not to work when configured on the 
kernel command line:

[    6.836910] netpoll: netconsole: local port 4444
[    6.841553] netpoll: netconsole: local IPv4 address 192.168.1.10
[    6.847582] netpoll: netconsole: interface 'gphy'
[    6.852305] netpoll: netconsole: remote port 9353
[    6.857030] netpoll: netconsole: remote IPv4 address 192.168.1.254
[    6.863233] netpoll: netconsole: remote ethernet address 
b8:ac:6f:80:af:7e
[    6.870134] netpoll: netconsole: device gphy not up yet, forcing it
[    6.876428] netpoll: netconsole: failed to open gphy
[    6.881412] netconsole: cleaning up

looking at my test notes from 2015 when it was added, I had only tested 
dynamic netconsole while the network devices have already been brought 
up which is why I did not catch it. Let me see if I can fix that somehow.
-- 
Florian
