Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EE6587AC5
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 12:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbiHBKdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 06:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbiHBKc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 06:32:58 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A73B7F8;
        Tue,  2 Aug 2022 03:32:58 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b96so6726594edf.0;
        Tue, 02 Aug 2022 03:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bkidQQTL4ByERxgSKW8Xd149iagPvKvBVb7oyCiXx1k=;
        b=omxvNSeHrlrzpuIqWb4BRBUU+S6bOdd6aPa9nM0t44Slqd3oc9tWUwXqVomZYFLgVC
         NPYbo7x8Dw9vqt5TcEPYw7JUssOenkWXiGR+LZBqdVmmXcoSfIhSUAFH5zdXckjjkAbx
         0JdstTEa2ZwpG7ybfKrzLosHYkbQxqYphNLMXgmH0d9ktyAxHkMshUyj2Swowuo6gKO9
         GUDgADAgs0pf7nleq9gVOP1P608fM7puL7V2piOA65ArHV3IcdTGo4Ygtt5Lxwyb8aA/
         DOjEW3QNEvBCKHPVFBqiFX/uB+PeqBbq0LnWhtqO3CKFOaHsj3/EjsWefQ8wUT2v8tyD
         E/RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bkidQQTL4ByERxgSKW8Xd149iagPvKvBVb7oyCiXx1k=;
        b=KVPM0WfPyDtA7OCwAnO5kExczNlhE3j3WrPeDpeALwEDxB3x44vRfRZxxue7ITASKK
         wjX1ne67Q8ZhV8Xay7+kXSw0xEmqGjLonTkABzKqIwTkVkGj4A+l6deGey2dmaxGBdUQ
         8hhBV4By77PtxPzDmxKn7XeMgWGvd33HeK1xFZb7+yP1uX09Q7fAV2Cm2Sd7DWb/y/kb
         CxZdf4wRQh8zUIwXPBmPWZr3QDJ1yG4a0W6eR5kR6RuFB45SYQPWKshituw16vsfWZsb
         0ILHnC7EsbEHHcJ4x5kweXmp87yF7JFe0fGZjDsc7GwYLf2vVfqytwWVHMGkB20w80Sj
         bkLg==
X-Gm-Message-State: AJIora9Gkpoz/HvD7tmk1VnUxLfxg+HbJt7yCOe0NgR5CGxJQsWX2sPT
        mjgfHReNRJBrwYMgsPvzVSo=
X-Google-Smtp-Source: AGRyM1u22TSEcD+Q34CaxMUtOGG2oQGwd2G+A9UoEmvCXwMLUkk1LZuYsLvXZwG3w6yxSN/GYNmETw==
X-Received: by 2002:a05:6402:5489:b0:43b:b935:db37 with SMTP id fg9-20020a056402548900b0043bb935db37mr20352184edb.347.1659436376450;
        Tue, 02 Aug 2022 03:32:56 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id fw16-20020a170907501000b007306d3c338dsm2785962ejc.164.2022.08.02.03.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 03:32:55 -0700 (PDT)
Date:   Tue, 2 Aug 2022 13:32:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [Patch RFC net-next 1/4] net: dsa: microchip: modify vlan_add
 function prototype
Message-ID: <20220802103253.z7jryvmnef5bzdww@skbuf>
References: <20220729151733.6032-1-arun.ramadoss@microchip.com>
 <20220729151733.6032-2-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729151733.6032-2-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 08:47:30PM +0530, Arun Ramadoss wrote:
> diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
> index 42c50cc4d853..6529f2e2426a 100644
> --- a/drivers/net/dsa/microchip/ksz8.h
> +++ b/drivers/net/dsa/microchip/ksz8.h
> @@ -38,9 +38,8 @@ int ksz8_mdb_del(struct ksz_device *dev, int port,
>  		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db);
>  int ksz8_port_vlan_filtering(struct ksz_device *dev, int port, bool flag,
>  			     struct netlink_ext_ack *extack);
> -int ksz8_port_vlan_add(struct ksz_device *dev, int port,
> -		       const struct switchdev_obj_port_vlan *vlan,
> -		       struct netlink_ext_ack *extack);
> +int ksz8_port_vlan_add(struct ksz_device *dev, int port, u16 vlan_vid,

I don't see an impediment to naming "vlan_vid" just "vid".

> +		       u16 flags);
>  int ksz8_port_vlan_del(struct ksz_device *dev, int port,
>  		       const struct switchdev_obj_port_vlan *vlan);

Won't you convert vlan_del too?
