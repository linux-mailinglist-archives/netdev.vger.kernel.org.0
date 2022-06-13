Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEED54834D
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 11:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbiFMJgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 05:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiFMJgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 05:36:22 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5D66356;
        Mon, 13 Jun 2022 02:36:19 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id n10so10017468ejk.5;
        Mon, 13 Jun 2022 02:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kxhsb4j+LHktkCeM8EHAsOHU0Xef2/yfMBziY6AVgmc=;
        b=UVdGvKSRxf1rkD9O+mZfi9f1MOXkwIfGxIJ8NDPLZVP591C2nJTkMEljvhe2taf9BJ
         LJiZpIAhqTLLfd+IQi50zINWtKdylmjLTZLNHvHRZe/WIhWsQXLecWkoANc4BjvrzjnJ
         oYtUkNuko8Jn5fovpSoF2MyVDj0t3Itt9lf9fs8A9dyt4StUBtLYSoZtsA0XE4/wOjru
         dp4VQ1XAArQ36I2qbvC4UwDvcHRRXCYTiFgcLhOW4MPG24rMYV6i+XTAere4il09TtzC
         uMDZ3sm52bLxFfZyk1O/txRtJdUmgnGR8qD0LaEN3NhI2VUuSgPxfmrX/WrzaYSvJn9D
         MlGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kxhsb4j+LHktkCeM8EHAsOHU0Xef2/yfMBziY6AVgmc=;
        b=QW6/dXqRF+817osULhPNmO8OF3TzGm9NuwlubUn0gq+WWEGgzOntHk/2N2NC0d9Z5w
         IvtVruyin5evOBHvQrGdqBzEtdGdXM5mcRgwfalYPjO9/AhNiJ2G+Y5SfTc0G5cPwObq
         UAMCGXHygO+RZK/Met6xvCgPL8/3KTzUIpcs1JEQpurJQSbiKqex4fm+J+DykxMSJzYV
         1aieaZqZERwHe8M+P6fPEfvPUd9jlHP+ommH98jvgqOaqhV5I7mTjVq2NOOiMD8Umm5B
         MJtPdLMbL9S9wykfVSoBJZkr83qzUVH9CBztj6Yzbdtcw32653HbA5VR3KTDTb5VWrak
         FPbw==
X-Gm-Message-State: AOAM5330OtjuIp31mDttqMGmdLjZqpBlgr22U73ExPT/8vhm3kQFM78V
        IrhJtJkmuKDUaYzfCfmNhCG3MggXvvg=
X-Google-Smtp-Source: ABdhPJzgQ9L7Bl8OQAcZPxd6LcZ7d6mZk413LmeDZR/0FkrPRxwaL0vSs8nNlvuwI5e9LK5Yk2FkCA==
X-Received: by 2002:a17:906:6009:b0:6fe:9813:14ea with SMTP id o9-20020a170906600900b006fe981314eamr51856681ejj.732.1655112978526;
        Mon, 13 Jun 2022 02:36:18 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id u10-20020a1709061daa00b00711d546f8a8sm3592471ejh.139.2022.06.13.02.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 02:36:17 -0700 (PDT)
Date:   Mon, 13 Jun 2022 12:36:16 +0300
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
Subject: Re: [RFC Patch net-next v2 08/15] net: dsa: microchip: update the
 ksz_port_mdb_add/del
Message-ID: <20220613093616.mqpdzqfmapbj4svt@skbuf>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
 <20220530104257.21485-9-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530104257.21485-9-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 04:12:50PM +0530, Arun Ramadoss wrote:
> ksz_mdb_add/del in ksz_common.c is specific for the ksz8795.c file. The

ksz_port_mdb_add

> ksz9477 has its separate ksz9477_port_mdb_add/del functions.  This patch
> moves the ksz8795 specific mdb functionality from ksz_common to ksz8795.
> And this dsa_switch_ops hooks for ksz8795/ksz9477 are invoked through
> the ksz_port_mdb_add/del.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
