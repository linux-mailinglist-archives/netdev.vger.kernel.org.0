Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4C4669BCE
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 16:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjAMPUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 10:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjAMPTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 10:19:38 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0DC631A6;
        Fri, 13 Jan 2023 07:12:52 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id l22so23312619eja.12;
        Fri, 13 Jan 2023 07:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aAMj7qXgIqMP9a951ZOqo5S1ivqcPvHwcpyXMZKbg1s=;
        b=M1lRkgqdpVP8SKI2d+tous5WfatoyMxWRiG/awbh/87+ZlPqB3OvNKpZTaNM3dKuMh
         jPDnHCY/jRtBo2lPtBzu2AIcQm8k7XryU7oi5jUT+tmIFMxslCKxVDbF4FR5SYI58M6D
         oaVbOfG4E6AnimG9NQkfzS4WYDfViI/7pdkkXw8MsSVIxv9ynQq0k4Pd8L0u0Qrc3Ng+
         wTQ5p4doDgoZVtIKChO538wUwovuP14x39ta4AtHLxUNBzprL52YdaCnnIH9aZl/EjzO
         XH3mFGHZxL7pIshbnDikiQ22lPyU+l/HEawF9nja4Gzy849gfO0QU3bLuAeOzUMamLK4
         BJ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aAMj7qXgIqMP9a951ZOqo5S1ivqcPvHwcpyXMZKbg1s=;
        b=xOOSFOZbZ+j2FRMk8nnBEL1qM4lcZ3zeE9re55BSZGRV7XX+cb3x5thdKiqmUjyjI0
         M8YgfHo57aouXUxVj2U4r3iyAIfAoTy9J4emzLI6u4mGxkX/TUPxnxZCUQfSrVI6hvFE
         olLDcPTCdzTCUk0QygjRu1h+ljHOgCu+JirS4fATOcY4PsoCP2sut9bkUlHfC71MiXmG
         wXcNV0tG/iCRLSzPsEhaPx2UdkmUdVHmP5QTdlY5RH2s+y7MkTo/VK0KmoolKICpHgpx
         wkcgfRM9T88VOzp+TK41glG2WjxiMSIyHSWulhdLCD+ANzkkQytS9yIVWa3UN3GWVfJw
         k3fA==
X-Gm-Message-State: AFqh2koxGe8BDEHEuyS6vL1+bk4mO1y90rwZsNkFjpKQG+wZbJaJ6IS4
        exKc8wfSglMw7keT9bEbqVc=
X-Google-Smtp-Source: AMrXdXtWKyvRCQJn9HNvLxxGJ38Ld02avtwRTHNn+spVEnP2y21Ynf5Esu7/CXGnND0Wmzw/709WrA==
X-Received: by 2002:a17:906:a3cf:b0:861:3ed5:e029 with SMTP id ca15-20020a170906a3cf00b008613ed5e029mr3119418ejb.49.1673622771444;
        Fri, 13 Jan 2023 07:12:51 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id n4-20020a170906164400b007c11e5ac250sm8741535ejd.91.2023.01.13.07.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 07:12:51 -0800 (PST)
Date:   Fri, 13 Jan 2023 17:12:48 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>
Subject: Re: [PATCH net-next] net: dsa: rzn1-a5psw: Add vlan support
Message-ID: <20230113151248.22xexjyxmlyeeg7r@skbuf>
References: <20230111115607.1146502-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230111115607.1146502-1-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 12:56:07PM +0100, Clément Léger wrote:
> Add support for vlan operation (add, del, filtering) on the RZN1
> driver. The a5psw switch supports up to 32 VLAN IDs with filtering,
> tagged/untagged VLANs and PVID for each ports.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---

Have you run the bridge_vlan_aware.sh and bridge_vlan_unaware.sh from
tools/testing/selftests/drivers/net/dsa/?
