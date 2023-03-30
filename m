Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822966D08E2
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 16:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbjC3O5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 10:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbjC3O45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 10:56:57 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE517BB9C;
        Thu, 30 Mar 2023 07:56:38 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso22209884pjb.3;
        Thu, 30 Mar 2023 07:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680188198;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yU8Am5XS4bF62pVIqk8T6WsY9phiYr9ElUgv6Ugf+V4=;
        b=XNyGjhS0HyE/19hdtnkz4Ep2rUVTq/MvwpH9+sV9RrYuAOe34ArZ34J1LjrpbQDQoT
         j9AorV55iC8yKbebmSG1/CEEmd3RbdrqxzCQgdMKSxKdQbUrt+xH4UWMPS8IyaCN3Jr0
         os1/scO7YSDkUes7sscnsTFqYQss0sfya34emJv8JPXDN5UPcmNrk7ismVAfK2KscYPU
         lsdloEQ2pV36SXEFQySk8wftm1EmE3BnJytvc4gekp6vB6/8FvjU3SM5+IHPS0ZffVu5
         4wsviBgxT3H0OqaVqHVtEBKK5I9zsfDDfiVLWKDkLsKTcZ4NGFmzNsp+Vn2NtL995iIy
         M+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680188198;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yU8Am5XS4bF62pVIqk8T6WsY9phiYr9ElUgv6Ugf+V4=;
        b=l4Ih1f09tUVjXerrBvNHIYIVhtkU11ikQvn3nDaWTXdjWL9LQGLLv/4aRUHC8ubMwJ
         4Z1Y5HBEBwY6gcxdASA5gg0H2qij8KcuHJZKS+LQTZUb/NoPYIzREIOV/4ZApiTi8Ikd
         BmvI37s8dfdTWRhob2vamh8rvYERIWf24pf72XbwIVXdgkihR/bI/LdI7XZ3KwDnu+Lm
         oVvFUfktrRGH/52sc8F6Yr/H0BltG7fnrrLAf7srwXLv8Yc5b9z1YrohMRBLtT85awI6
         jjUwYn7D5ak7coG+3osC5NxgaYZeOyeZPB72FeDabp3Mh6bR5Ir1MOmgp57z23BUtpOt
         P9IQ==
X-Gm-Message-State: AAQBX9fziFVUxwE0wWdr6qafqAnbqAnk6tFcMJ9Rcz/6BPGnkIjH8+1v
        NhGLqnasldeK3a0pxj4OY9g=
X-Google-Smtp-Source: AKy350YoGDgn2poQnnaCqiFv0hhws5xv1ZehFOBFTiz0scDtfRKenDXvcfbcsvYzDmbQEWyFfWyS8A==
X-Received: by 2002:a17:902:ce86:b0:1a1:cef9:cc5c with SMTP id f6-20020a170902ce8600b001a1cef9cc5cmr29508944plg.15.1680188198040;
        Thu, 30 Mar 2023 07:56:38 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id b10-20020a170902a9ca00b001a04a372fa0sm10562439plr.251.2023.03.30.07.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:56:37 -0700 (PDT)
Date:   Thu, 30 Mar 2023 17:56:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Alexis =?utf-8?Q?Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: rzn1-a5psw: enable DPBU for CPU
 port and fix STP states
Message-ID: <20230330145623.z5q44euny3zj3uat@skbuf>
References: <20230330083408.63136-1-clement.leger@bootlin.com>
 <20230330083408.63136-2-clement.leger@bootlin.com>
 <20230330104828.6badaaad@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230330104828.6badaaad@fixe.home>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 10:48:28AM +0200, Clément Léger wrote:
> Actually, after leaving a bridge, it seems like the DSA core put the
> port in STP DISABLED state. Which means it will potentially leave that
> port with TX disable... Since this TX enable is applying not only on
> bridge port but also on standalone port, it seems like this also needs
> to be reenabled in bridge_leave().

That's... not true? dsa_port_switchdev_unsync_attrs() has:

	/* Port left the bridge, put in BR_STATE_DISABLED by the bridge layer,
	 * so allow it to be in BR_STATE_FORWARDING to be kept functional
	 */
	dsa_port_set_state_now(dp, BR_STATE_FORWARDING, true);

a dump_stack() could help explain what's going on in your system?
