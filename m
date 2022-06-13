Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C29548348
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 11:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240791AbiFMJZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 05:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiFMJZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 05:25:00 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB5912AC1;
        Mon, 13 Jun 2022 02:24:59 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id b8so6228731edj.11;
        Mon, 13 Jun 2022 02:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D3wprETyB5Skze6ImbSTdKgKlPg/vR+JTv8MyTrSLYA=;
        b=BkQLGnhbj4tWzVztrwSNDZskNPHTvN7OLCdNEomYH01cAKW/32vISuyW6es9G9qWaw
         PTboTPCnXURLwRJ3zWAf3fS6s2vf+pEwMAF8TNjhoyQmehvAWc6ZGM4t+j6z90XXohnm
         KH/VAqoqQQGKvV0KBkXVmRNO1oI/4saeTYC+MvW7wAVrB8ZDkPfE/9DHXWVhlGtRGVc5
         ZFqWEwrvsJKNr3bKMqtSNRmFVkJPzvR7lBqtp/hibLQhYCWuy23x9sXWNYgCP//wh6Zg
         Qs5A9s9ymwLtcV0tC9Cd9u3I41+yb+yBLmY5XYajJPyI04M0RmE+R7SEW79nRXxuvvb7
         uhDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D3wprETyB5Skze6ImbSTdKgKlPg/vR+JTv8MyTrSLYA=;
        b=BKrOUveDTxfUkpSeUVNS+MZPBVLvT3vvLaALd77jeuxQ4KT8mpnqHepPoZhYpD517C
         BdVSTo+TkiJ4gjaRNn56oehqa/8oBAtLVZqiDZsz/AOF15K6/NHT4tAgkpf/MCLCpJTR
         cQHhnUUTXIANXF5068UmsKeqljuwzUlXgQTM+o5dlEA5HlHtHX5hlKTpKeAstjuTj0qG
         jh+LtwfI9zea04dOGcflj5+JvWayIuFT1q7f6n9wcXe23MkYvn+OV6lLc3FkylWmZHeS
         avns9lKWve078mdeYC7VNTQxpm5DNrTsLVeJDVjitSA4vA1mR9HlCIv1u3lfscat9pZv
         TO8g==
X-Gm-Message-State: AOAM533SSHeIGMV2kbauDq54F+8+m6LmMf9S656gw1Pe7Eima9B+g+yf
        Up76VBE/apyhc1KdnZgI6sY=
X-Google-Smtp-Source: ABdhPJyQFAEfP3q5zIqmL2hPOGbo6BIhG2XR03DQy9P+hCZW+gw5PD+uqurKFBQhqgpvJvYYgEPucQ==
X-Received: by 2002:a05:6402:84a:b0:423:fe99:8c53 with SMTP id b10-20020a056402084a00b00423fe998c53mr63175580edz.195.1655112298357;
        Mon, 13 Jun 2022 02:24:58 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id ew16-20020a170907951000b0070a80f03a44sm3584692ejc.119.2022.06.13.02.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 02:24:57 -0700 (PDT)
Date:   Mon, 13 Jun 2022 12:24:56 +0300
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
Subject: Re: [RFC Patch net-next v2 04/15] net: dsa: microchip: move vlan
 functionality to ksz_common
Message-ID: <20220613092456.o46fumg63vjg53sx@skbuf>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
 <20220530104257.21485-5-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530104257.21485-5-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 04:12:46PM +0530, Arun Ramadoss wrote:
> This patch moves the vlan dsa_switch_ops such as vlan_add, vlan_del and
> vlan_filtering from the individual files ksz8795.c, ksz9477.c to
> ksz_common.c file.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
