Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA062626059
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 18:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbiKKRUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 12:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiKKRUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 12:20:52 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6F547303
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 09:20:51 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id p12so4726862plq.4
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 09:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q7Xa+py3hjWExofDQ+1PRKQ3Oe9rzLGK9/H+JFsk8ag=;
        b=0NM6cLhoH+3WjjgYZBTbNSEPh49+js6VWNIUWiAJeeNh8tSXof6Nro/C+hEnmJWwiB
         Z9bOEBFJYbRowPCO40fyyS4rHwlONanG5yjUdlxKUjgy+mug694Rp7NHARCUEIrPm7RA
         QFbgZWQv93vAYE+VekT3Otr+QeE3eAE+Zjppdt0aHfRIxNZOQzJXE11edeuP7qiOME8h
         sMTbbhuu1zDpduNoEuZfBruldCUZX7s2kYSEWHzGG//CkBbgEE25Ci7952WjF/iqwsOG
         T8MAkMe2w+Z2R+WaNNv55iV+tX48ih2NPkgrSkh6PanMu0l2UUMOGEk9YbL6yVOueec4
         k0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q7Xa+py3hjWExofDQ+1PRKQ3Oe9rzLGK9/H+JFsk8ag=;
        b=ZQud2I3PQWVzCr8wBUysd4NOStlL6xG/9liAKIPi3FUWjAtR19IQlPoxd44SbZFjvt
         glI/iDeLwsVTC/7usvH0tsI+v0oo5/BKWsVhDP03BuUc/ySGio3tkM7uKmZDzuC8rKUP
         SaEjsFtgsj1KIVRjAMhk5JCTuk0yS/6b1fAwNpNk2Qz+8Y+EspL28wWD42uKbuKNMwhO
         XBcSltWSFXrmrYeNyKT+pFxWc6YoCpUXArNsJ0LtUfkHL0Mu0w+EmqllUl5AWBWFKgsV
         SSDvjgLcKilDHCCodHTPJ9VmBmufUpZvhN+I2YNOkP76Ye9Pt5Uod2L0NEMAYRjD8+96
         z7Hg==
X-Gm-Message-State: ANoB5pmZHIhdePfZQ4XhxRhV5YJcdKEPf9L9wOPipB4xyeFSKVeRAQCr
        BKArIVpVYjjeOCCwpoHorb+zgg==
X-Google-Smtp-Source: AA0mqf51mmwub1vfvFmX/07Vzj3FK8XOXpnnchQuo8d8uUUfOZNwBCs/XTdFq7fHTsG9jhBRlU24wQ==
X-Received: by 2002:a17:902:7d89:b0:188:5c0c:758a with SMTP id a9-20020a1709027d8900b001885c0c758amr3381385plm.134.1668187251323;
        Fri, 11 Nov 2022 09:20:51 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d207-20020a621dd8000000b0056be1581126sm1892393pfd.143.2022.11.11.09.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 09:20:50 -0800 (PST)
Date:   Fri, 11 Nov 2022 09:20:47 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tcp: Add listening address to SYN flood message
Message-ID: <20221111092047.7d33bcd3@hermes.local>
In-Reply-To: <7ccd58e8e26bcdd82e66993cbd53ff59eebe3949.1668139105.git.jamie.bainbridge@gmail.com>
References: <7ccd58e8e26bcdd82e66993cbd53ff59eebe3949.1668139105.git.jamie.bainbridge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Nov 2022 14:59:32 +1100
Jamie Bainbridge <jamie.bainbridge@gmail.com> wrote:

> +	    xchg(&queue->synflood_warned, 1) == 0) {
> +		if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
> +			net_info_ratelimited("%s: Possible SYN flooding on port %pI6c.%u. %s.\n",
> +					proto, &sk->sk_v6_rcv_saddr,
> +					sk->sk_num, msg);
> +		} else {
> +			net_info_ratelimited("%s: Possible SYN flooding on port %pI4.%u. %s.\n",
> +					proto, &sk->sk_rcv_saddr,
> +					sk->sk_num, msg);

Minor nit, the standard format for printing addresses would be to use colon seperator before port

		if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
			net_info_ratelimited("%s: Possible SYN flooding on [%pI6c]:%u. %s.\n",
					proto, &sk->sk_v6_rcv_saddr, sk->sk_num, msg);
		} else {
			net_info_ratelimited("%s: Possible SYN flooding on %pI4:%u. %s.\n",
					proto, &sk->sk_rcv_saddr, sk->sk_num, msg);
