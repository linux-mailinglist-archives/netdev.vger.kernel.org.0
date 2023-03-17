Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9236BECFB
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbjCQPcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjCQPb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:31:58 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6FC6153C;
        Fri, 17 Mar 2023 08:31:47 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id h8so21894195ede.8;
        Fri, 17 Mar 2023 08:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679067105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9TJgCv8uP/EGpF2zbM75KEFfZndGIlcsO1G99GNTrFg=;
        b=N8YspkOGuGBWotBx1iEZRMkbVJQ0Z53MqKLhuLb36m1w6OVkbz5H7+Cr9JX2FbvDri
         nQsHAvqF1mVaLHNtCrgbM46i2ntim9l3xY8YIyNKTVvzW0Wrjtbj767g30pWehS21EGC
         S0atQ7xQe188aYbBfZ4yXHyFpmy7fsYvFX557BzQyjW6PlnkTZUbTn0YODaU8XCnRDjC
         dRHXyphdWjxdD5KgX+hymgCeZRZ2+BebzepK+SvsTuYro/jsCyvXPsQtTWsPbRsmYnVS
         7080EckHKdzh9XAdfARMPJu28aiesiTtkrE4Q6NFaNndbv4hLw0ZSPakYcSlYo0es1/S
         NB9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679067105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9TJgCv8uP/EGpF2zbM75KEFfZndGIlcsO1G99GNTrFg=;
        b=Dar9R/vmNqSmo/xzkoghYj9f0N8MV2b7WLPKTtGwJTwwMsyWpkJYeLOOJNCIXrpnU8
         hqIWgtQnOQ6asae3Lkag/Klt+Apg13wB0rAQlUVKj0rRPAlk4mjbfRaPTXCh3i1RlYyr
         6EuFOE/f0aSNa5iJw6a6OuCKX+4wO48GOW1lFUkhHebCt7q3K+RkPdaBaNquryCWdNv0
         1TmG6UPG9WrOAOWtm+BKYD97hDFzme/Vx3rx1q+5y7qJam5YEO2110/cQvmvrFjyeZp+
         RlgHVK0FmdSqFNuGa3X3z6JTyDE+cDDI3oL5y9qCvpVmFKECT6J+YU7R0glwy8+4B6+/
         E0xA==
X-Gm-Message-State: AO0yUKV31ZpILbVwh7Or0G0hhKz5IB2iP49urE+AzZpjit/dCHycPsh+
        qv0GCADrBJ8fQIt+cKFIPufsKURCkqakCA==
X-Google-Smtp-Source: AK7set8312plZYVf9gUlPrTfNwF2d+gY1xO+5BwIieTao4fYIv9QYzvOZBHUyc9hiO6q9DrHkYO/aA==
X-Received: by 2002:a17:906:3fd2:b0:885:a62c:5a5c with SMTP id k18-20020a1709063fd200b00885a62c5a5cmr13308948ejj.46.1679067105515;
        Fri, 17 Mar 2023 08:31:45 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id e23-20020a50d4d7000000b004bf28bfc9absm1219939edj.11.2023.03.17.08.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 08:31:45 -0700 (PDT)
Date:   Fri, 17 Mar 2023 17:31:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/4] net: dsa: mv88e6xxx: re-order functions
Message-ID: <20230317153143.njzbfildvvibhkjr@skbuf>
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
 <20230315163846.3114-3-klaus.kudielka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315163846.3114-3-klaus.kudielka@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 05:38:44PM +0100, Klaus Kudielka wrote:
> Move mv88e6xxx_setup() below mv88e6xxx_mdios_register(), so that we are
> able to call the latter one from here. Do the same thing for the
> inverse functions.
> 
> Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
