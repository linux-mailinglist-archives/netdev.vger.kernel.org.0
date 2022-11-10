Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE38862429A
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 13:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiKJMxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 07:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiKJMxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 07:53:33 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEC7A193
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 04:53:32 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id 21so2946539edv.3
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 04:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zHXAY8REVIACQRKQP4BDdNTuTebJl4riGmtVvgVjJPE=;
        b=VVesb+TlBnWfKYzZGQegpGyhjRSSHy755ZeSQ4XoFPFRvhx1NRLa8gMMTCbjeeuAQn
         00gNaoAkUIoQBNSoPSJ7pNCDyFEU74t5d4cOGxLrzPgCqCJpFfAtzQLtv+NENWbyuIkQ
         ZF5fc3hYB6++JiFPgQN3f+65WYTyOf4wrGUh+4lq1S7VV1z7oERtwSKvGmuxOzVNXj2R
         pN6PyQXyfv3PLxwJZdsY+TtOTHbMLQt/ELLZ8/M7L0Oj4CWgTj+osfGPuDoukjyyxVUq
         Q6xDHZpMkFYBSasnJGUfhuY46c+G7fJxmfiEsxj4KBhYMEcUqu7moyJ3G/T3U0q72NYN
         l8CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zHXAY8REVIACQRKQP4BDdNTuTebJl4riGmtVvgVjJPE=;
        b=MK53lGmDEyXqS5uxN8D2EqFXTqojpHK+u22IWktTBp2++b82ZUbaYyyL5PV9F2CxrM
         29efOW4h01hwThWK17iMKOGR52UrToeUpcQVltFz6cho5pDJdIgc0lcXH9eqMhgDm8/Z
         dSIHZnjx/YUg55DqxTOewr+POMfmS6qE0IJv36gJvb6jMyJ9WlRq3N557xxd5s+SEdiG
         gegpYJaxq0ecH7k5pqpNDmaqJBFKX9z/FiyM+mhG6RkOLNbIxM9ch+6OQUaFsHrBu9BK
         Zm5yIDidqpyHViGMmhrK4gkgX3zk5w43t4FhymXCZgPmQO8HPV9d5Eman9gKcci9l4L4
         hlyg==
X-Gm-Message-State: ACrzQf3F9amgi4MiyIg/8rgcw3gWslO2dB8blxJD77cGh9mzGKze4Rof
        3SQ8cWKTB6WY968AV02ZBjw=
X-Google-Smtp-Source: AMsMyM4lWWj+9hEKINOWWL+ZuUBnC3xGv7LlLGOwiC/5NWfgnxoFSTTsdwUvhYnr4TtH4sHUhQBYmQ==
X-Received: by 2002:a05:6402:2996:b0:463:ce05:c00e with SMTP id eq22-20020a056402299600b00463ce05c00emr2130668edb.46.1668084810597;
        Thu, 10 Nov 2022 04:53:30 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id j2-20020a17090623e200b007aa3822f4d2sm7302995ejg.17.2022.11.10.04.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 04:53:24 -0800 (PST)
Date:   Thu, 10 Nov 2022 14:53:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, andrew@lunn.ch, netdev@vger.kernel.org,
        Steffen =?utf-8?B?QsOkdHo=?= <steffen@innosonix.de>,
        Fabio Estevam <festevam@denx.de>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow hwstamping on the
 master port
Message-ID: <20221110125322.c436jqyplxuzdvcl@skbuf>
References: <20221110124345.3901389-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221110124345.3901389-1-festevam@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 09:43:45AM -0300, Fabio Estevam wrote:
> From: Steffen Bätz <steffen@innosonix.de>
> 
> Currently, it is not possible to run SIOCGHWTSTAMP or SIOCSHWTSTAMP
> ioctls on the dsa master interface if the port_hwtstamp_set/get()
> hooks are present, as implemented in net/dsa/master.c:
> 
> static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
> {
> ...
> 	case SIOCGHWTSTAMP:
> 	case SIOCSHWTSTAMP:
> 		/* Deny PTP operations on master if there is at least one
> 		 * switch in the tree that is PTP capable.
> 		 */
> 		list_for_each_entry(dp, &dst->ports, list)
> 			if (dp->ds->ops->port_hwtstamp_get ||
> 			    dp->ds->ops->port_hwtstamp_set)
> 				return -EBUSY;
> 		break;
> 	}
> 
> Even if the hwtstamping functionality is disabled in the mv88e6xxx driver
> by not setting CONFIG_NET_DSA_MV88E6XXX_PTP, the functions port_hwtstamp_set()
> port_hwtstamp_get() are still present due to their stub declarations.
> 
> Fix this problem, by removing the stub declarations and guarding these
> functions wih CONFIG_NET_DSA_MV88E6XXX_PTP.
> 
> Without this change:
> 
>  # hwstamp_ctl -i eth0
> SIOCGHWTSTAMP failed: Device or resource busy
> 
> With the change applied, it is possible to set and get the timestamping
> options:
> 
>  # hwstamp_ctl -i eth0
> current settings:
> tx_type 0
> rx_filter 0
> 
>  # hwstamp_ctl -i eth0 -r 1 -t 1
> current settings:
> tx_type 0
> rx_filter 0
> new settings:
> tx_type 1
> rx_filter 1
> 
> Tested on a custom i.MX8MN board with a 88E6320 switch.
> 
> Signed-off-by: Steffen Bätz <steffen@innosonix.de>
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> ---

NACK.

Please extend dsa_master_ioctl() to "see through" the dp->ds->ops->port_hwtstamp_get()
pointer, similar to what dsa_port_can_configure_learning() does. Create
a fake struct ifreq, call port_hwtstamp_get(), see if it returned
-EOPNOTSUPP, and wrap that into a dsa_port_supports_hwtstamp() function,
and call that instead of the current simplistic checks for the function
pointers.
