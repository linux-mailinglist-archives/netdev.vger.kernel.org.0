Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F976226BE
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 10:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiKIJVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 04:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiKIJVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 04:21:12 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8492C11
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 01:21:11 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id n12so44925988eja.11
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 01:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7g0AbY5/adDRQsHrmygyhM6FzTVG4xjy6DBIzTAO0mk=;
        b=di4Uj0oh7+iqBZqbaRrqFsIeaBk5lzHnPlWP+70SlXufN7d7RjOJrIzWoluXMpU7ob
         PRLFUxAtPWw3qG8bDgGxHlGh+BzNRm+YAZOTaMxGLjjFivHe3gX0ienVyqFBtfEaBB0i
         qLTCxSSx22l7uzAhr3q12mbKTHX18eVdYS2yRx+JsL4XFzNS0m8azxRmG0gpn1+wnevN
         0AW2RlLuAYmhmMnFUP7Dzg+CmaxknJd2sfymxW7NTi6qMQ4G7eTlRVCgWijlHru+iw4f
         F5cWmR2u3KnxtOL/m9O6NRwRVY0pr0wD25OUw/pDR3cm6AYQuNFMgX7ZyZSUGa6ZPAaM
         AbmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7g0AbY5/adDRQsHrmygyhM6FzTVG4xjy6DBIzTAO0mk=;
        b=Y0SvyxwopG1vi48b94WhTxMy5qMmYZAmNu2sYqdWQHGfQyHmO44ecHihkKCVIEdzBs
         CKq1V2+1PMsbjnSfi/61lecInNjky2TEFSIycLPHo5p36ehZn3E75jNRHfE/tCEz01R4
         gamWm5DwUb32EJwzMJPeiKTlxeU/0Km7iuQxj2WwjH7xgg2KYhkSfakmkUqF0gVY3q0Q
         uaK5KsVTkpFw3SghLZeieuutNw//p4PTO44ty9mTYpiSHp8Yozu2J3J7qtznWPOVzX2Q
         FhDqKLLMzd5UA9hIZEzo9RfxdYqynx+yW9yjaY02oFFn2tLjdPm6NzTCZGLEUxGlKWav
         vx6Q==
X-Gm-Message-State: ACrzQf3wZPKaBG2rVDb6TRB8Yl1CdhaIYDK+v3LlxItOXGoIJ96p871g
        W7Q2ywBRxMyL2LQKupNcmaI=
X-Google-Smtp-Source: AMsMyM5TLpQs092Eg9MW7B1tNG6W1ZYXz2ZXsCfVfkLGtxbgEXnKGft2jEf8L/GxoE++O6PG+IA5PA==
X-Received: by 2002:a17:906:9f15:b0:78c:fb5e:8592 with SMTP id fy21-20020a1709069f1500b0078cfb5e8592mr1096742ejc.711.1667985670076;
        Wed, 09 Nov 2022 01:21:10 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id v2-20020a170906292200b00779cde476e4sm5625287ejd.62.2022.11.09.01.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 01:21:09 -0800 (PST)
Date:   Wed, 9 Nov 2022 11:21:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        bridge@lists.linux-foundation.org,
        "Hans J . Schultz" <netdev@kapio-technology.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 11/15] mlxsw: spectrum_switchdev: Add locked
 bridge port support
Message-ID: <20221109092107.dzgogolaox7upnit@skbuf>
References: <cover.1667902754.git.petrm@nvidia.com>
 <f433543efdb610ef5a6aba9ac52b4783ff137a13.1667902754.git.petrm@nvidia.com>
 <20221108145929.qmu2gvd5vvgvasyy@skbuf>
 <Y2tkNa7nnAdeD5Nc@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2tkNa7nnAdeD5Nc@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 10:26:29AM +0200, Ido Schimmel wrote:
> On Tue, Nov 08, 2022 at 04:59:29PM +0200, Vladimir Oltean wrote:
> > Can't really figure out from the patch, sorry. Port security works with
> > LAG offload?
> 
> Yes. It's just that port security needs to be enabled on each of the
> member ports. FDB entries that point to a LAG are programmed with a
> lag_id. When a packet is received from a LAG the hardware will compare
> source_lag_id == lag_id instead of rx_local_port == tx_local_port.

Okay, understood, the concepts are clear.
