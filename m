Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B645660480
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbjAFQkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbjAFQj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:39:29 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7877778A64;
        Fri,  6 Jan 2023 08:39:28 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id t17so4663184eju.1;
        Fri, 06 Jan 2023 08:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=62whTgwgxgcK47Dt+65MfHt3OP2RRvwYQXr7nW+cRsc=;
        b=PXjjrBc0txLZcl8hUAjtECmhB84OGy+/jHK9l6ujHR1e5Z5AkJGvyt4BN+OvrCIQdE
         CPdMqmCVq3YfxeeKMD+3GuwQypFZ+OLegZyBmgOAsGnirVk4zjrXVmCoCUYZ4s5J0uwh
         EUgebIhXbNkym9OsA7dSvSPgVJ4QCv9WSifZN2YzlveTQGSkJ+0k/1DLTnAtUnrgP9Mm
         Znifygp9Zwn7W01AxqzY+v9JYrZeTALnwb8sydq/ha+YzqKqupbwRNSSn2TAdtvSTUyi
         UwpSILaa97KtddjgvInx9m1srk0ZdsAafe7U9A6bIYtVnl2WwTkQJyz76lWsVjr/WlSt
         4ZCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62whTgwgxgcK47Dt+65MfHt3OP2RRvwYQXr7nW+cRsc=;
        b=ugxAtGsw19SyAerRcRVJY0CvvRpE605m5GDAvpfHbKzRR910SbqcAn8RAooxcjRX6Z
         v9xUeHYnUec9/Jpbqcn3wgfCwEN3PV/82I7UDR/veMGDaETnQgQB83ToN5YmBCsu1O6y
         BAB1JqD8+PQL474xRCsSf812Ttq0Fg4Umg2Vn6K9bAy99zbTC9cW7a2yYovjs/gcMoBK
         dhNR7BSaW505+3bHNn6bpxpRz4vZ68O7RjfvIfof83Jt6tlF4em3KQdxILcLJ5ltb8lt
         aWbHdVr6zMPRbSshYyoPUoXBVAfqEX4bRGvu0sdyJXFMSekKH50eeRMVVI4+wQeE9FG3
         b11A==
X-Gm-Message-State: AFqh2kqkY05geFjYR8LawMTpFPfUz3qAFXDnQDCZAqX5hDnEpuNGY3Zq
        KSWgjvuPdwrtsLjw5JDoMOk=
X-Google-Smtp-Source: AMrXdXtuU8FtF1HayoHRDOCl0DcmSv/ba7G3iGXBIv7V3RJcx1lMYP4kSihxNp+rXs7/25uR5ySdVg==
X-Received: by 2002:a17:906:12c7:b0:7c1:639:6b42 with SMTP id l7-20020a17090612c700b007c106396b42mr56094594ejb.62.1673023166932;
        Fri, 06 Jan 2023 08:39:26 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id w2-20020aa7cb42000000b0046a0096bfdfsm646278edt.52.2023.01.06.08.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 08:39:26 -0800 (PST)
Date:   Fri, 6 Jan 2023 18:39:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 1/3] net: dsa: mv88e6xxx: change default
 return of mv88e6xxx_port_bridge_flags
Message-ID: <20230106163924.jxrdthslsxjogahs@skbuf>
References: <20230106160529.1668452-1-netdev@kapio-technology.com>
 <20230106160529.1668452-2-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106160529.1668452-2-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 05:05:27PM +0100, Hans J. Schultz wrote:
> The default return value -EOPNOTSUPP of mv88e6xxx_port_bridge_flags()
> came from the return value of the DSA method port_egress_floods() in
> commit 4f85901f0063 ("net: dsa: mv88e6xxx: add support for bridge flags"),
> but the DSA API was changed in commit a8b659e7ff75 ("net: dsa: act as
> passthrough for bridge port flags"), resulting in the return value
> -EOPNOTSUPP not being valid anymore, and sections for new flags will not
> need to set the return value to zero on success, as with the new mab flag
> added in a following patch.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---

Please add Acked-by/Reviewed-by tags when posting new versions. However,
there's no need to repost patches *only* to add the tags. The upstream
maintainer will do that for acks received on the version they apply.

If a tag was not added on purpose, please state why and what changed.

Missing tags:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
