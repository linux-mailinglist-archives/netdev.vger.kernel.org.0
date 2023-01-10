Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F49C664EBC
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 23:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjAJWZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 17:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbjAJWYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 17:24:10 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E067D1AA22
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 14:22:50 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id gh17so32418621ejb.6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 14:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pCT4CocBlPMzqUiwmYePajdQvco5u2DO47TSjkJbx5Y=;
        b=MaAFEV/Sk4dIqnC+oTw1F1FIA9fv9chEckl5V52cyERKnvsedFoQCxfntYm7VO0QVf
         kntI4dTXDgwUUovGEaP725WgUugDtpisIMSi33biOMf0rejZ8tw46htjC4D9z/wxFLpF
         2Snp4NnR6q7eshFWUWoIh4beEjx7ExjJZq2XmI+n7FIYBjbJxSMa+3+p/VjCrGkdkfsb
         2H84rdbov0xJNV6vdk7z94cEeEH4MHuMbki7e257SXUoXuAQ3y0HLC/D56W5yJY9x9Xd
         D/sh6mXHicOPjroYWlss/TV9ycypIUMHGjv80iV70rtQjswtT36NnW5G/bGZvG1rFmw1
         oJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pCT4CocBlPMzqUiwmYePajdQvco5u2DO47TSjkJbx5Y=;
        b=s3FcZWrGSsBcNJPnH1inwLNPsCvTfwmGYLIaqg/dpqtyBdJqkq6XhWXqB3XpKcPTTG
         esQfg5ZpwBHDYnv8grSX5lMbWtKkfRvJ0NVsaXbUcsX/9bprEBIZ71o0ytgq2IpzaGnQ
         1IIHHMIOaxJO+Z7x9Kh/6j8bSL7xt8/FH6EL0eLAnmM027+ZK3yAV8CjT+IWEh68DM+J
         y5T6Tb5wGyDetzhoVdehjOrH7GzOwUH3/Lnn1lKWtai75+Ucl45G8AjBNN3zwMUtPCd2
         SCrwqCWO6+vjv6vdkpd5Js9OpobyKDls+vEN9Iz7IVMspTVdfAjmYsKyhGGUCX5diiJc
         5Zmg==
X-Gm-Message-State: AFqh2kou+abBPbHdzYbvoon/6SQ6izIIKXJwk54unZcEkYSBh2sZUGwP
        AGwtRwTHuon2g7PZ69TQROfB8OVWzEYBAA==
X-Google-Smtp-Source: AMrXdXuePmjIu8xAzGi9ImAdJt6joUrNeFY7NHsHK14ii7mNRJZkNDsw6m04Af54a0uCP4lXI+QrUw==
X-Received: by 2002:a17:906:260e:b0:7c1:9046:878a with SMTP id h14-20020a170906260e00b007c19046878amr60494999ejc.38.1673389369022;
        Tue, 10 Jan 2023 14:22:49 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id p3-20020a1709061b4300b007c09da0d773sm94881ejg.100.2023.01.10.14.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 14:22:48 -0800 (PST)
Date:   Wed, 11 Jan 2023 00:22:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Angelo Dureghello <angelo@kernel-space.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
Message-ID: <20230110222246.iy7m7f36iqrmiyqw@skbuf>
References: <5a746f99-8ded-5ef1-6b82-91cd662f986a@kernel-space.org>
 <Y7yIK4a8mfAUpQ2g@lunn.ch>
 <ed027411-c1ec-631a-7560-7344c738754e@kernel-space.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed027411-c1ec-631a-7560-7344c738754e@kernel-space.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Angelo,

On Tue, Jan 10, 2023 at 11:23:58AM +0100, Angelo Dureghello wrote:
> Hi Andrew,
> 
> thanks a lot for the prompt reply,
> 
> actually, seems i can use both cpu ports by
> some brctl lines:
> 
> ip link add name br0 type bridge
> ip link add name br1 type bridge
> brctl addif br0 eth0
> brctl addif br1 eth1
> 
> I verified looking the tx_packets statistics (ethtool -S)
> and both eth0 and eth1 ports are used.
> 
> Is it something that may work, eventually as a workaround ?

I am afraid that these are DSA extensions added by your kernel vendor.
I would be curious to look at the kernel code, for my amusement, if you
can share it. Generally, DSA masters (eth0, eth1 in this case) cannot be
added to a bridge, because the bridge's RX handler steals packets from
the DSA data path. So I'd also like to see what was done there.

> Also, could you help me to know the kernel version
> implementing dual cpu port properly ?

I would recommend starting with the DSA documentation on this topic:
https://www.kernel.org/doc/html/latest/networking/dsa/configuration.html#affinity-of-user-ports-to-cpu-ports
then with "git blame" on the documentation file, and "git log" to see
the surrounding commits.

For mv88e6xxx, the API for multiple CPU ports is not yet implemented.
On the other hand, there have been proposed RFC patch sets from Marek
Behun and Christian Marangi which can be picked up and used as a base
(they need to be adapted to the API that was merged).

> I cannot actually upgrade the kernel, due to cpu producer
> customizations that are not mainlined, so would try to
> downgrade the driver.

The delta between v5.4 and the kernel where support for multiple CPU
ports was added is ~600 patches to the net/dsa/ folder alone. There are
some non-trivial interdependencies with phylib, phylink, devlink, switchdev.
You might also need support for the end result, if you end up cherry picking
only what you think is useful. Hopefully that will help you reconsider.
