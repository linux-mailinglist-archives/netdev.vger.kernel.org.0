Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D06621794
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbiKHO7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbiKHO7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:59:34 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA562450BF
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:59:33 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id n12so39229713eja.11
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 06:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J1AA1jk+noLUWn3EI/QqWPmqga5tVeAmuKcLyOASUC4=;
        b=IEWU2L7UG31b+6vQvoFxaCyrT42BgWijq9qxlw0Uf/9Ba6xAlk4Bxgxca1Xcm8Ccuo
         7F2ubojIxKLT/0z31+7rEioqCjL2UD9+Azteadg8f1HjRQszJBAlfPRNF/VxTvrN968B
         8vxl69gCu+f5oUJixPF3rpKhITtTFXqZwNMrAEfwFyB/ytzWO4PWvIrOmRxjvOwWnjYY
         h8Q+OBg2avLxlA/HgFl/re7DwIg27wrbAK8tPaR8IidURoG0tL4XgJApZjlB1wM+hetX
         bys9z9qYflR+sGikSVfflk4z4VeNvof2IvEc1wU7JbruXt0fpmk4hHpk/3HHTCmdPVNY
         kYXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1AA1jk+noLUWn3EI/QqWPmqga5tVeAmuKcLyOASUC4=;
        b=ke2QUix8CcljXB0H68l6p9oDES4xQvDa/6TiW04vJPfNlqbc879qX4qqab0LwLyJEm
         dIM60rjYGnROVfsy/tfr3Od3cPyP9yWumUYCg48QLpuqfwVSURGL+9d0sNekph2gmmWb
         Sg1fz4Im8VC2/t4Q4SvxlCRZN4W6tm2ESOS3jIPTW8vseXKAlOP0cY+ahqVeXSEurnqw
         txEEY9BSubolxa5s0Sqz9B1UQjp3WFuYYLRHZ/2teCXFJixtWQmMo0Udj6GyHfmefncw
         ini+iNJB+1EUcieK4mRycFjJrx/JGw+bZFOneJDiJ++JI3tRtMfH00jlip4bhzrbkTKe
         Pzkg==
X-Gm-Message-State: ACrzQf1qeXPanDH1FpRhiGCUcEczkqTU7vKINJxTLqbSwW2g/zSyQrzU
        fqVrpZ5M1h+8J3nYBG9CT/A=
X-Google-Smtp-Source: AMsMyM4Ljx+XXPIpKL7Id2vhWE+Fe3vEdcs7aRwa8g0SxxBXGIvy+66vnuylYE+kk5j8vNM0v1qXzw==
X-Received: by 2002:a17:906:8a54:b0:7ad:e517:1eb with SMTP id gx20-20020a1709068a5400b007ade51701ebmr40139744ejc.567.1667919572404;
        Tue, 08 Nov 2022 06:59:32 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id fy8-20020a170906b7c800b007877ad05b32sm4794721ejb.208.2022.11.08.06.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 06:59:31 -0800 (PST)
Date:   Tue, 8 Nov 2022 16:59:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 11/15] mlxsw: spectrum_switchdev: Add locked
 bridge port support
Message-ID: <20221108145929.qmu2gvd5vvgvasyy@skbuf>
References: <cover.1667902754.git.petrm@nvidia.com>
 <f433543efdb610ef5a6aba9ac52b4783ff137a13.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f433543efdb610ef5a6aba9ac52b4783ff137a13.1667902754.git.petrm@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 11:47:17AM +0100, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Add locked bridge port support by reacting to changes in the
> 'BR_PORT_LOCKED' flag. When set, enable security checks on the local
> port via the previously added SPFSR register.
> 
> When security checks are enabled, an incoming packet will trigger an FDB
> lookup with the packet's source MAC and the FID it was classified to. If
> an FDB entry was not found or was found to be pointing to a different
> port, the packet will be dropped. Such packets increment the
> "discard_ingress_general" ethtool counter. For added visibility, user
> space can trap such packets to the CPU by enabling the "locked_port"
> trap. Example:
> 
>  # devlink trap set pci/0000:06:00.0 trap locked_port action trap

Got the answer I was looking for.

> 
> Unlike other configurations done via bridge port flags (e.g., learning,
> flooding), security checks are enabled in the device on a per-port basis
> and not on a per-{port, VLAN} basis. As such, scenarios where user space
> can configure different locking settings for different VLANs configured
> on a port need to be vetoed. To that end, veto the following scenarios:
> 
> 1. Locking is set on a bridge port that is a VLAN upper
> 
> 2. Locking is set on a bridge port that has VLAN uppers
> 
> 3. VLAN upper is configured on a locked bridge port
> 
> Examples:
> 
>  # bridge link set dev swp1.10 locked on
>  Error: mlxsw_spectrum: Locked flag cannot be set on a VLAN upper.
> 
>  # ip link add link swp1 name swp1.10 type vlan id 10
>  # bridge link set dev swp1 locked on
>  Error: mlxsw_spectrum: Locked flag cannot be set on a bridge port that has VLAN uppers.
> 
>  # bridge link set dev swp1 locked on
>  # ip link add link swp1 name swp1.10 type vlan id 10
>  Error: mlxsw_spectrum: VLAN uppers are not supported on a locked port.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---

Can't really figure out from the patch, sorry. Port security works with
LAG offload?
