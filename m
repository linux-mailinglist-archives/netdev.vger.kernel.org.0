Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B356A5636E0
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 17:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiGAP1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 11:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiGAP1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 11:27:05 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3B637A83;
        Fri,  1 Jul 2022 08:27:04 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id lw20so4698470ejb.4;
        Fri, 01 Jul 2022 08:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K0iZiXinEatv8xEcBISd59Ab8eNplLifK/KFllgmDfA=;
        b=AkKkSH90WBGW9spYSEFDjhuJfRAK1ihCSwwzha9d19mrwuRU2ZUQa5QaL9Mx5vKUSw
         0zHYHRn56sSlCNx6XxWOue2MBL05jvRsk9cfBCwzBROcGgURGosPCaCXTn0qhBMZhfjd
         e8zM93KjwIcl3oNi4eG7snL8BNEFwvunUQkQy7MncYAmYtgHXYDz62fxHPJuALmnTBYX
         27n96hX2Hn5khXgz0InQoSDBO1eb1oxxWeO6toAtc2AKzHG9jRWxxqeOt/NAk+2Gy/Kj
         uSRGoVa/M9Ct/sUVJfLqY1V9us0aLfTaUY8j6xMhhnRUy6h8v6WohYydD5/131WLXu2j
         vTFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K0iZiXinEatv8xEcBISd59Ab8eNplLifK/KFllgmDfA=;
        b=OpyMpAbFsIJCs5hVB11mdWeTL3fiRxi5MVvNCI9oCT8dcnxq/YpVGWXp05GvHlC0vA
         Xc7TxF4+DriCaz5mxOfx4dIqqtWxtn90kb47swIEDISgY/CeW1I9Uz2PCGgrIrrCE78J
         6aV5/FV/HnXvCsPgc39myVmKvn7X5aR2MBazjlukAdpONMP4pV/WnXJVuX0Owqk+3mNN
         UWAdkoxizzbUzkUjZgSkqjRe9SqoR3388MGYPkIaMSBUofvSGNAvb6+vFjlRVrxxZVCh
         Y7pneR2I8LZJgeyMTUWm4onJwjtTMbs1kPayiuGKN/H3STr3vDeQ3FeJHcXs+bIIB+My
         X/ug==
X-Gm-Message-State: AJIora80fRAb7oiYoB3EvxQFQpD/Xy1hCXm8BrWrHZC8bPWrt2GJVprj
        UThrrt1ctbFxzHocUkti3Bo=
X-Google-Smtp-Source: AGRyM1vHhGWDNshk6+DsGFfXT4DAA7GcrZfk8btCkoCeO6zUxhUCOz4OsIdskGvX158HiUQC4IF3+Q==
X-Received: by 2002:a17:906:6146:b0:722:f8c4:ec9b with SMTP id p6-20020a170906614600b00722f8c4ec9bmr15708406ejl.708.1656689223488;
        Fri, 01 Jul 2022 08:27:03 -0700 (PDT)
Received: from skbuf ([188.25.161.207])
        by smtp.gmail.com with ESMTPSA id k11-20020a17090632cb00b0072a881b21d8sm1121201ejk.119.2022.07.01.08.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 08:27:02 -0700 (PDT)
Date:   Fri, 1 Jul 2022 18:27:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Hans S <schultz.hans@gmail.com>,
        Hans Schultz <hans@kapio-technology.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that link-local
 traffic cannot unlock a locked port
Message-ID: <20220701152700.sf2h6wbxx6dgll7a@skbuf>
References: <20220630111634.610320-1-hans@kapio-technology.com>
 <Yr2LFI1dx6Oc7QBo@shredder>
 <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr778K/7L7Wqwws2@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 04:51:44PM +0300, Ido Schimmel wrote:
> On Fri, Jul 01, 2022 at 09:47:24AM +0200, Hans S wrote:
> > One question though... wouldn't it be an issue that the mentioned
> > option setting is bridge wide, while the patch applies a per-port
> > effect?
> 
> Why would it be an issue? To me, the bigger issue is changing the
> semantics of "locked" in 5.20 compared to previous kernels.
> 
> What is even the use case for enabling learning when the port is locked?
> In current kernels, only SAs from link local traffic will be learned,
> but with this patch, nothing will be learned. So why enable learning in
> the first place? As an administrator, I mark a port as "locked" so that
> only traffic with SAs that I configured will be allowed. Enabling
> learning when the port is locked seems to defeat the purpose?

I think if learning on a locked port doesn't make sense, the bridge
should just reject that configuration.
