Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDAD60589D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 09:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiJTHbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 03:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiJTHbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 03:31:40 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E266E4C60B;
        Thu, 20 Oct 2022 00:31:38 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id a10so32825807wrm.12;
        Thu, 20 Oct 2022 00:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :organization:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z79Arkt5xOzvPjY1a5juI5H/rNW3whMoxZF+FvMREbw=;
        b=RazdqWN63yJXfYJ86StBl23cef6DFTs5JNs2/ZCRIwVnhutMysChXxhU8M9VSS1Wfm
         SI8ookk3ByODVTHkQMUMCF47BEnH3WixOPlAVXBu0alhZWYJsv5GG/uvRmRgs0mD/3dt
         HhpfZ3OMnUuDZX8b3oysjgcSGbKyTeZcrven8zrs04Sobujice4hGfA8Vx+AnYKHw9Cm
         T03WOBhUwsdDjqUyRkTCsqvayy/Tkp3ZADK1xbYGa93YY2t1qox0Rli6/Tu2ECCDJtOp
         sWYdAee7c+5mN6tT61P18nAFXCuz8NyRBGLyKnlcdYAL4qBNf0rLivoYtEq39dPls5Lq
         PukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :organization:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z79Arkt5xOzvPjY1a5juI5H/rNW3whMoxZF+FvMREbw=;
        b=UWhvHMZw/f0eKZYzBTUk2RdJ2UK6gSaUoZ/sNCdwKOH4WurJ7IIBMYW956ozyCwnb1
         TNaP8pUnJYDUoKjH6N2qMDmpntNdNMH0aBAc0WQRKkqp/bgU+lmlrBdaUWghf9/gJOCU
         oiIdMhKPSUF1M0QjWaKs8d79YorDEI1KMzSuDJa6HLpJT4cGGFZu0sr7IzrNRP9Q9xod
         VPNAhsL3JM7onh4MHcIsDaCd+gUsKriDowrlKDe0tDD5ktjy5Uhi93byMivl8mxVZKrW
         SvmJCATCJxfVOCGoRXUF6J+hzE89nCiu2QgC0NUrfAow8dsJcvYvxPOkukZhxRRmOHgs
         2PRw==
X-Gm-Message-State: ACrzQf2mGpaBS1Pu+O68MdRKenFKoBWaXkeKpRk28KJCCr2GKcsu4Dp3
        firC8Nmkeu17sH87FoHqzwbKQ5LWSjuErQ==
X-Google-Smtp-Source: AMsMyM5+QRPiCIoscx0FYAMfyyMa5WCoxHLYwyqDSBoJXzHftg3D/UDHRqFl1w0DiSjYcUA1llFtBg==
X-Received: by 2002:adf:f58c:0:b0:22d:69b8:da75 with SMTP id f12-20020adff58c000000b0022d69b8da75mr7541882wro.220.1666251096969;
        Thu, 20 Oct 2022 00:31:36 -0700 (PDT)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id q3-20020a056000136300b0022e3cba367fsm15427829wrz.100.2022.10.20.00.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 00:31:35 -0700 (PDT)
Date:   Thu, 20 Oct 2022 09:31:34 +0200
From:   Casper Andersson <casper.casan@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 4/9] net: microchip: sparx5: Adding initial
 tc flower support for VCAP API
Message-ID: <20221020073134.ru2p5m5ittadthzr@wse-c0155>
Organization: Westermo Network Technologies AB
References: <20221019114215.620969-1-steen.hegelund@microchip.com>
 <20221019114215.620969-5-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019114215.620969-5-steen.hegelund@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steen,

It's a pretty big patch series, but overall I think it looks very good.
I've got some minor comments. I also tested it on the Microchip PCB135
switch and it works as described.

On 2022-10-19 13:42, Steen Hegelund wrote:
> +static void sparx5_tc_flower_set_exterr(struct net_device *ndev,
> +					struct flow_cls_offload *fco,
> +					struct vcap_rule *vrule)
> +{
> +	switch (vrule->exterr) {
> +	case VCAP_ERR_NONE:
> +		break;
> +	case VCAP_ERR_NO_ADMIN:
> +		NL_SET_ERR_MSG_MOD(fco->common.extack,
> +				   "Missing VCAP instance");
> +		break;
> +	case VCAP_ERR_NO_NETDEV:
> +		NL_SET_ERR_MSG_MOD(fco->common.extack,
> +				   "Missing network interface");
> +		break;
> +	case VCAP_ERR_NO_KEYSET_MATCH:
> +		NL_SET_ERR_MSG_MOD(fco->common.extack,
> +				   "No keyset matched the filter keys");
> +		break;
> +	case VCAP_ERR_NO_ACTIONSET_MATCH:
> +		NL_SET_ERR_MSG_MOD(fco->common.extack,
> +				   "No actionset matched the filter actions");
> +		break;
> +	case VCAP_ERR_NO_PORT_KEYSET_MATCH:
> +		NL_SET_ERR_MSG_MOD(fco->common.extack,
> +				   "No port keyset matched the filter keys");
> +		break;
> +	}
> +}

Could this also be shared in the VCAP API? It currently doesn't use
anything Sparx5 specific. Though, net_device is unused so I'm guessing
you might have plans for this in the future. And it might fit better
here according to your design goals.

Tested-by: Casper Andersson <casper.casan@gmail.com>
Reviewed-by: Casper Andersson <casper.casan@gmail.com>

