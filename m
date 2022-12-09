Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792C26481D6
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 12:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLILik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 06:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLILii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 06:38:38 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B7B1571B;
        Fri,  9 Dec 2022 03:38:37 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id s5so2694272edc.12;
        Fri, 09 Dec 2022 03:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9AXTqSpnFooFB52J7tpaoo3FAyJlLQ3WSA/kZTD4RcA=;
        b=fecNKEilWUQlPQB2dahLnFmGXR5HpWOvEpibbuQ3Zl+WAH/JYMqhGL0IKctv1iA7mF
         ofPOVQkkCwC2Ar41v+BulectEWgqFFkMp/7QNMDrf9Ndw4qkZ9VVPyq8SUW9PTkQ0oXQ
         U8qO8NqIDQVnxdhjGhQkrPKOXQr7a3PEJ7njmQKlkMj4+LDZB40WIW605BNUN3FiIYC1
         D/3DHrvtlkj/6/r+ekW2xoqiRE2chTXwm7CFCI8RIrl3n2m/uJWLZX6WZ67pl1YLVdrA
         eLFdDyDtmQIOOyE37z6NHAt3CMKzyWgCqw2BmgfgAkJsqUB6Z2nH6iO9AknoB+sPvW9S
         PdOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9AXTqSpnFooFB52J7tpaoo3FAyJlLQ3WSA/kZTD4RcA=;
        b=UpY9gdj3DVyqB1gCDB6bY33RGiSPFQ/mzaraKqqPcP0uIWoWlG7qiG2LI/rsZbXrBm
         1PIhekrf607jwY/Imf2YWmjtiuChCySZo7PumNKHKqri7DMAmhJKEimEwv4hEtNGZjUn
         w9bn0lDlXIbLSTbKAypxNi7De+ltbu36JDA7cn+mB8ov6SFwfhzw9LNSULg8tnFNLTAv
         umvRn6fAchG8Lh3/4ltPLGUk28UBmTDW+jMyaXal88Qoo0UNNZiZsLSAAZXJFS26p6oj
         7J78mRhlR8gtRGc6Z7/8CesvChbpjpnIv56uWO0E3g2qJVOyJIPdUkFUtueMtvVWpPdn
         gOOA==
X-Gm-Message-State: ANoB5pnBouzlfvJF1OzCL5Y4iVrcvBc5BPUAXOb+IGNftv6J3N8VlEAO
        14QY8t/3+Jp3mVxptlUgSk0=
X-Google-Smtp-Source: AA0mqf7t5DriZsn+sBxN3lLIeAGeDK3AnxFlplmNBDn51ZkYJlanZlZMnIARDRAnY/lVwTAeGbDgiA==
X-Received: by 2002:a05:6402:378c:b0:461:cdda:4004 with SMTP id et12-20020a056402378c00b00461cdda4004mr4605515edb.10.1670585915787;
        Fri, 09 Dec 2022 03:38:35 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id eg52-20020a05640228b400b00463c475684csm538329edb.73.2022.12.09.03.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 03:38:35 -0800 (PST)
Date:   Fri, 9 Dec 2022 13:38:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Subject: Re: [Patch net-next v3 03/13] net: dsa: microchip: ptp: add 4 bytes
 in tail tag when ptp enabled
Message-ID: <20221209113833.4kbgof3kfw4zjpaq@skbuf>
References: <20221209072437.18373-1-arun.ramadoss@microchip.com>
 <20221209072437.18373-4-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209072437.18373-4-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 12:54:27PM +0530, Arun Ramadoss wrote:
> When the PTP is enabled in hardware bit 6 of PTP_MSG_CONF1 register, the
> transmit frame needs additional 4 bytes before the tail tag. It is
> needed for all the transmission packets irrespective of PTP packets or
> not.
> The 4-byte timestamp field is 0 for frames other than Pdelay_Resp. For
> the one-step Pdelay_Resp, the switch needs the receive timestamp of the
> Pdelay_Req message so that it can put the turnaround time in the
> correction field.
> Since PTP has to be enabled for both Transmission and reception
> timestamping, driver needs to track of the tx and rx setting of the all
> the user ports in the switch.
> Two flags hw_tx_en and hw_rx_en are added in ksz_port to track the
> timestampping setting of each port. When any one of ports has tx or rx
> timestampping enabled, bit 6 of PTP_MSG_CONF1 is set and it is indicated
> to tag_ksz.c through tagger bytes. This flag adds 4 additional bytes to
> the tail tag.  When tx and rx timestamping of all the ports are disabled,
> then 4 bytes are not added.
> 
> Testing using hwstamp -i <interface>
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com> # mostly api
