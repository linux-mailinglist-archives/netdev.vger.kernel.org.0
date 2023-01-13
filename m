Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1C466956A
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 12:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241008AbjAMLVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 06:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240334AbjAMLUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 06:20:32 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E223A809A1;
        Fri, 13 Jan 2023 03:14:05 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id fy8so51413947ejc.13;
        Fri, 13 Jan 2023 03:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SlAsx/PqlcNVFzMCgHrp9fmyc40IkW8ms/Rh0bpr8X4=;
        b=PE+kIkPbJVaxAgR8K+ZZOuxcHYsnOBqDXN34xzCxwiP2WAI9Ze7n6Gf0mc6YOZPu2A
         JS06+ptYUe6cNl7RKqeldRVNcegDQfdw+2PkH6OTDb5aKrs9VF+HatDU99NZ+49Wmq3L
         XXhSnUkkC5ugjDXfNjivXpGyZWGrt+BQSmSlqR2zXdvHIAg3eN/lhlWcYvqO116BWD/g
         yZ6wqEvMcHh37472JsL0bFTEa7XmUErUmm/wDuc6L+Ye0zLXsqUoNnPCJC1Nt1Kd8HbI
         cRaglv8aPbrjdhk1pNsqsnM28OccuyOUYsIq+XPd6wiOi66tl29H1kqI+1ZCL3E9jEcz
         mBdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SlAsx/PqlcNVFzMCgHrp9fmyc40IkW8ms/Rh0bpr8X4=;
        b=L9MnSD4YNxEInBa6GF0ytDTYa1+5ce9HVnlJ7gDWmWr3uvDPfcYSyInG1tsWVoV/9c
         +xPmmYScmNg8rmn34wO1vqpqJuzFRrkM1VnrdjtSdAGHUe0zOnauWPszqxizre++KLkl
         e8GYYsqnj9/NL4lQ7H6X44DnUJKt4jTJEWnrYOxW3fu22+UNVWiTwDoAsnT+6E4fEtDi
         gb1/OQQLpkXmFrGj4fEjWifJPHPxxEw8sD4jy6XIJ8zzaFK0tVp8yyCX92VDJmrPXy/F
         P+MztyrjKEaa2vL+cAgdTfRQEkF+XQauVXv/FEDz4YZa6e7vyjPwqoj4oyjTGCqWtU0Z
         W3KA==
X-Gm-Message-State: AFqh2kr4uMKbyu5cHLzt195yeKp7+3k2x3VvNaFq1+9Y0KH6tcrPcNYV
        cQEMDE0bLjRU+ytVZVEYSnI=
X-Google-Smtp-Source: AMrXdXsEA5AnfSAZ+cdsRvCpn9hOwRmoJ2j4M29EA1ia0f++obBAbDPdbXxmmgLuNLSQWzURGbh6LQ==
X-Received: by 2002:a17:906:d973:b0:7c1:5982:d729 with SMTP id rp19-20020a170906d97300b007c15982d729mr2797413ejb.56.1673608444366;
        Fri, 13 Jan 2023 03:14:04 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id c10-20020a17090618aa00b0084d14646fd9sm8293024ejf.165.2023.01.13.03.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 03:14:03 -0800 (PST)
Date:   Fri, 13 Jan 2023 13:14:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20230113111401.hyq7xogfo5tx77e7@skbuf>
References: <20230106101651.1137755-1-lukma@denx.de>
 <Y7gdNlrKkfi2JvQk@lunn.ch>
 <20230113113908.5e92b3a5@wsk>
 <20230113104937.75umsf4avujoxbaq@skbuf>
 <20230113120219.7dc931c1@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113120219.7dc931c1@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 12:02:19PM +0100, Lukasz Majewski wrote:
> Hi Vladimir,
> 
> > On Fri, Jan 13, 2023 at 11:39:08AM +0100, Lukasz Majewski wrote:
> > > Are there any more comments, or is this patch set eligible for
> > > pulling into net-next tree?  
> > 
> > How about responding to the comment that was already posted first?
> 
> Could you be more specific?
> 
> 
> On the beginning (first posted version) the patch included 9 patches
> (which included work for ADDR4 for some mv88e6020 setup).
> 
> But after the discussion, I've decided to split this patch set to
> smaller pieces;
> 
> First to add the set_max_frame size with basic definition for mv88e6020
> and mv88e6071 and then follow with more complicated changes (for which
> there is no agreement on how to tackle them).
> 
> For the 'set_max_frame' feature Alexander Dyuck had some comments
> regarding defensive programming approach, but finally he agreed with
> Andrew's approach.
> 
> As of now - the v4 has been Acked by Andrew, so it looks like at least
> this "part" of the work is eligible for upstreaming.
> 
> 
> Or there are any more issues about which I've forgotten ?

Do you agree that for the chip families which neither implement
port_set_jumbo_size() nor set_max_frame_size(), a max MTU of 1492 will
be returned, which currently produces warnings at probe time and should
be fixed first, prior to refactoring the code?
https://patchwork.kernel.org/project/netdevbpf/patch/20230106101651.1137755-1-lukma@denx.de/#25149891
