Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15A9644C15
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiLFS4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiLFS4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:56:21 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D34036C5A;
        Tue,  6 Dec 2022 10:56:20 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id f7so21631830edc.6;
        Tue, 06 Dec 2022 10:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s8/1wvkNoEzkNmQ0mgde436T0MNo3Sdud/cN0RRqH44=;
        b=NG55cSmjwkUNiOqFR8Zlwfj/m8Tj4N+Z2SKFMCVzzaOWY5Ai2LJhpQ/9u634zNHuzM
         F2QtZaq5k6S8WembVHOoqmKbNB1cBLhbHIgRyIOLWyp0wY2Gmgbme476WT7FSXoNcs/W
         vNm/0+76yp3zvGZCZ00ArRpySsdkLspLonLeeHmK98Ex82Up+xleu/ZV2l3n7jgd3vW0
         Z2UBxH7Ook5YRrXJYuRtEqzP8LSui/RBVwufAmEkYhmkEyW4aJpkeDC9F/6fBP/TfLMc
         DSl9EPhVmbSWMWQBUQIbegKU1d4hmdQiYho36uUE2SrMX4sb/Kvp4AN5AG8VvZDzaY3D
         sqgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s8/1wvkNoEzkNmQ0mgde436T0MNo3Sdud/cN0RRqH44=;
        b=qlBfloNMyi1XT8HkcnwJT0GFGOKFb9l2FP46RF6pQ7vwXI1fYVQPKLAn2nzi2E39Ey
         FHEXTgT6M/ERyf8XTE+y43hPsJc48EFQv+ja7RZtUmv1wVj+WbC7x70VcdX8QPf12SJE
         6DG+E2b2nmzRSpVnowsGUxXZivD6am4v+JOiWKb+gkdnNT2xbRcdCAF/dKnfX4mCj8N2
         l87xk8IxmHdly1httFtIRwZWB1B4e2fNH0b7a6gfmNsvBaxoUc+/7xMjy2fZY3VWiPJ/
         kjp+zNV31nSG8kEJxa4KhRvbtArf6aGYxAnSDJFqvQsOtKNBxGjRQi8OWWFJzigVhw3c
         akoQ==
X-Gm-Message-State: ANoB5pl6cEvugg7b2EVhGZoQtqEI0VomGIE6cA0ZTxOiCxiFTeHdnedK
        9gi6uqirHxWmEHjD5yFJikg=
X-Google-Smtp-Source: AA0mqf6uuG0p9EnnFd6usvY3vxnXwD2DVZse8EyYviwADlL1uXljQkGwZkKqk+d6E8Pei7JX/C9Asg==
X-Received: by 2002:a05:6402:790:b0:46c:cd6e:811a with SMTP id d16-20020a056402079000b0046ccd6e811amr7742724edy.352.1670352978911;
        Tue, 06 Dec 2022 10:56:18 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id g26-20020a056402181a00b004618a89d273sm1309847edy.36.2022.12.06.10.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 10:56:18 -0800 (PST)
Date:   Tue, 6 Dec 2022 20:56:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v3 1/2] dsa: lan9303: Add port_max_mtu API
Message-ID: <20221206185616.2ksuvlcmgelsfvw5@skbuf>
References: <20221206183500.6898-1-jerry.ray@microchip.com>
 <20221206183500.6898-2-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206183500.6898-2-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 12:34:59PM -0600, Jerry Ray wrote:
> +/* For non-cpu ports, the max frame size is 1518.
> + * The CPU port supports a max frame size of 1522.
> + * There is a JUMBO flag to make the max size 2048, but this driver
> + * presently does not support using it.
> + */
> +static int lan9303_port_max_mtu(struct dsa_switch *ds, int port)
> +{
> +	struct net_device *p = dsa_port_to_master(dsa_to_port(ds, port));

You can put debugging prints in the code, but please, in the code that
you submit, do remove gratuitous poking in the master net_device.

> +	struct lan9303 *chip = ds->priv;
> +
> +	dev_dbg(chip->dev, "%s(%d) entered. NET max_mtu is %d",
> +		__func__, port, p->max_mtu);
> +
> +	if (dsa_port_is_cpu(dsa_to_port(ds, port)))

The ds->ops->port_max_mtu() function is never called for the CPU port.
You must know this, you put a debugging print right above. If this would
have been called for anything other than user ports, dsa_port_to_master()
would have triggered a NULL pointer dereference (dp->cpu_dp is set to
NULL for CPU ports).

So please remove dead code.

> +		return 1522 - ETH_HLEN - ETH_FCS_LEN;
> +	else
> +		return 1518 - ETH_HLEN - ETH_FCS_LEN;

Please replace "1518 - ETH_HLEN - ETH_FCS_LEN" with "ETH_DATA_LEN".

Which brings me to a more serious question. If you say that the max_mtu
is equal to the default interface MTU (1500), and you provide no means
for the user to change the MTU to a different value, then why write the
patch? What behaves differently with and without it?

> +}
> +
>  static const struct dsa_switch_ops lan9303_switch_ops = {
>  	.get_tag_protocol = lan9303_get_tag_protocol,
>  	.setup = lan9303_setup,
> @@ -1299,6 +1318,7 @@ static const struct dsa_switch_ops lan9303_switch_ops = {
>  	.port_fdb_dump          = lan9303_port_fdb_dump,
>  	.port_mdb_add           = lan9303_port_mdb_add,
>  	.port_mdb_del           = lan9303_port_mdb_del,
> +	.port_max_mtu		= lan9303_port_max_mtu,
>  };
