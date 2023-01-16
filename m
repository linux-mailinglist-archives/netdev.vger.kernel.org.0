Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B26866D099
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbjAPU7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbjAPU7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:59:51 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F81129E28;
        Mon, 16 Jan 2023 12:59:50 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id v30so42332083edb.9;
        Mon, 16 Jan 2023 12:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T5w4k6GgK/MPcdG08vW2aGQ55PObN9+zQUK2bAfgu+w=;
        b=HKFdIIFYZZzMGkKzonuQFoNoXsAk6kCOB333/L/XbRxLJplHWNyc7dM97mrUcRFbyy
         MPSnLZlbZOba/9+Hk3hetYHtwI2FjMYwO0Cqi8wF5H1x8xIj3shMTSzobGBl4Gv2mTDQ
         f1Qe3JD6cc1gTXMI7byIj2aLRTf8dQsIQGJvS4itkjVup5c0Qj24T7eni2ICS2R1CSDF
         kcxYWjRS1DGB1R9is8ZYs8/sekCAi+DV0zHwX6xloOOjkX29GoK8m7e4aFv8wfjIsDRH
         He8TMfzJPwGaEu3zozsqoExpBM8dXLdb9z9t9lSkQ3yetpDroV8iy3vqu/DSMoHzNAB1
         Ag2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T5w4k6GgK/MPcdG08vW2aGQ55PObN9+zQUK2bAfgu+w=;
        b=DaqY0uFDR4wyHDwgqVJZhUUBI7OK7N80trqD9bGp5XB6GiBXVW6VjzzcBuFP0XZEf2
         py0rWTeEVe6XMMomigSmiohVHvTxd9MocYelUz5mQFADWt9otkoDsJJ4tB7MBCLTfOIG
         q4eiDQsllc1OTbE3J1pvKKbzxk3wEOx1QX4SePYxyAC+tDq2P6St7qzlg7oWFiqQA5I2
         yds+dcUNN7li8Lyxbof+Zgz3vE54waTOdgmB4i34B27un+UqlO2bB/58qdSUQZ4AhfWt
         avmiWMKpCgwBJ8DTC2fnR8RNZsteZb5C1/KnAqoPQfP6ei6JhT9N6ZPGbz3fzgc29EXC
         dzDA==
X-Gm-Message-State: AFqh2krmcxdvJ8ltGAoE44dBzOj0VGN8CPN8DBbW85yl/fOgNA1osKgX
        s76E2l05RTvJxp3Asd7wnrZ6GIPTcJ99gA==
X-Google-Smtp-Source: AMrXdXsLFQEoQrT3nQpug+jrJNRvCwFW4bXAZHKNAxZl4GX2OY8MfYZq5UsIdxtV19zb0SB0T3BCaA==
X-Received: by 2002:a05:6402:5110:b0:499:8849:5fb3 with SMTP id m16-20020a056402511000b0049988495fb3mr815962edd.31.1673902788655;
        Mon, 16 Jan 2023 12:59:48 -0800 (PST)
Received: from skbuf ([188.27.185.68])
        by smtp.gmail.com with ESMTPSA id f4-20020a50ee84000000b00494dcc5047asm11822544edr.22.2023.01.16.12.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 12:59:48 -0800 (PST)
Date:   Mon, 16 Jan 2023 22:59:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        arun.ramadoss@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net 1/2] net: dsa: microchip: ksz9477: port map
 correction in ALU table entry register
Message-ID: <20230116205945.fewkozezdxrzhwzs@skbuf>
References: <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
 <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
 <20230116100500.614444-2-rakesh.sankaranarayanan@microchip.com>
 <20230116100500.614444-2-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116100500.614444-2-rakesh.sankaranarayanan@microchip.com>
 <20230116100500.614444-2-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 03:34:59PM +0530, Rakesh Sankaranarayanan wrote:
> ALU table entry 2 register in KSZ9477 have bit positions reserved for
> forwarding port map. This field is referred in ksz9477_fdb_del() for
> clearing forward port map and alu table.
> 
> But current fdb_del refer ALU table entry 3 register for accessing forward
> port map. Update ksz9477_fdb_del() to get forward port map from correct
> alu table entry register.
> 
> With this bug, issue can be observed while deleting static MAC entries.
> Delete any specific MAC entry using "bridge fdb del" command. This should
> clear all the specified MAC entries. But it is observed that entries with
> self static alone are retained.
> 
> Tested on LAN9370 EVB since ksz9477_fdb_del() is used common across
> LAN937x and KSZ series.
> 
> Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
> Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Would be nice to convert the alu_table[] array into a proper structure
in a net-next patch.
