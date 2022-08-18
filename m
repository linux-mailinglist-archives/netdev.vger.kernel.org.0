Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807275982C6
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244310AbiHRL7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244282AbiHRL6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:58:49 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B572BAE221
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 04:58:41 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id qn6so2763441ejc.11
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 04:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=IA88KtjZw9AjMGQV7e7pRC/xtj1obEz8/NeXN0+DLJo=;
        b=lCB4tsjAWpNZRHyZGQf4rIFwaQvd4S0PC3gv+83VKTdh0KEDpxBtI0wSuPpnfKrVMN
         tMBUtnFYaZeZFKKfnNxfEmJVc34BSPA0MuktvohnE5Ru/el9qIrpcw6hEhk+rxFoRRqv
         OHKB7kwMT1qohogG5+Hh1tshm/h6+a+1EUMJrNCTV620YqMZwvKzUaNNA75r3V3Ox4KL
         f4kjhq+R//JruTQvTYVVSOgtfi6aKbbEnBmhkxrK7RWcoK2dlkfJoqq1Q8lhfYQ/yNtf
         Qs19+1LQN/8zTxGM3szRwFhCfFhhivnWn8d+OWfflDenL3gkqbQ7Wb2ZQZMlPRBBbTLc
         G5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=IA88KtjZw9AjMGQV7e7pRC/xtj1obEz8/NeXN0+DLJo=;
        b=PC/fJoIDC0z1VNk+mxaVDy3Svy9DIyoMNegV3KQgYyLNJaEfQmRZ1FrSsLRfKd4bhF
         rCrZ328YqcbG1MCxFe0qVzQhQDvIgcfHnd1cUlFdhuG8urmp+k302iDhM0YkVdSvw619
         diCcHOiGewFYQIqjo75WJD/iOFK5FLfkdOhf58NVZTegc1BqcMb1aFLsQBF0fFEbuYpy
         UGBcWcU0uAK0p8miKXINvF+2fzli4ztTdtksEWbvxy5wKXJTKZp3S41K2pHCF7a9Y4LL
         9QGI1qot6iMOBI35p/oEXVzgwe6AWAMnxXso++rclsJaUH6qtduLoM9wW96K5qaNdJel
         Phqw==
X-Gm-Message-State: ACgBeo2QvcCuOKIROeIeHoDWVxUhX7V+cHzUO5fVsWxqqMqFuFY/yGd5
        SCa3TTJ6203FEuRX5bJul4M=
X-Google-Smtp-Source: AA6agR7kyqYSjadm6QVaH9k41cS/a7QtGV/jMgnpCIfaBViZLJiZKHB6oWMLlj94N/nR2+kacG+uow==
X-Received: by 2002:a17:907:9707:b0:731:5ddc:30f3 with SMTP id jg7-20020a170907970700b007315ddc30f3mr1673406ejc.338.1660823919979;
        Thu, 18 Aug 2022 04:58:39 -0700 (PDT)
Received: from skbuf ([188.25.231.137])
        by smtp.gmail.com with ESMTPSA id l18-20020a1709063d3200b00730bfe6adc4sm742873ejf.37.2022.08.18.04.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 04:58:38 -0700 (PDT)
Date:   Thu, 18 Aug 2022 14:58:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC net-next PATCH 0/3] net: dsa: mv88e6xxx: Add RMU support
Message-ID: <20220818115836.dinoyfw6ukucd6d2@skbuf>
References: <20220818102924.287719-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818102924.287719-1-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 12:29:21PM +0200, Mattias Forsblad wrote:
> The Marvell SOHO switches have the ability to receive and transmit
> Remote Management Frames (Frame2Reg) to the CPU through the
> switch attached network interface.
> These frames is handled by the Remote Management Unit (RMU) in
> the switch.
> These frames can contain different payloads:
> single switch register read and writes, daisy chained switch
> register read and writes, RMON/MIB dump/dump clear and ATU dump.
> The dump functions are very costly over MDIO but it's
> only a couple of network packets via the RMU. Handling these
> operations via RMU instead of MDIO also relieves access
> contention on the MDIO bus.
>
> This request for comment series implements RMU layer 2 and
> layer 3 handling and also collecting RMON counters
> through the RMU.
>
> Next step could be to implement single read and writes but we've
> found that the gain to transfer this to RMU is neglible.
>
> Regards,
> Mattias Forsblad

Have you seen how things work with qca8k_connect_tag_protocol()/
qca8k_master_change()/qca8k_read_eth()/qca8k_write_eth()/
qca8k_phy_eth_command()?
