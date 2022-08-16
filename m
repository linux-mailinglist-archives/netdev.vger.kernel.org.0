Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F635962A8
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbiHPSsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236114AbiHPSsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:48:40 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6E558DCE;
        Tue, 16 Aug 2022 11:48:38 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b96so14685031edf.0;
        Tue, 16 Aug 2022 11:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=TbsInd+1Z+79pFOrHY4RWxlzLqkfeDMvhb4MGLvms5E=;
        b=RgH05S6Hr/GhFaHQWT9VxZfhk3Er4HVs9A0WGEhyspRpqqvXImH1mDNoVQmgCnKQ2Y
         UFnYgFOnla2LaMff9tGzoFRZVVuWJtRWdWFaj+OpRa4z206hwRs71dpcbfMtpVVlla3O
         8sX8CWvwTHbBLbSXxVZAe9VBX/QKY2IbHFSYH+NYlTgZ9VIUg1FroWiJyXJa0sR/YlVH
         dzuoD3g+P4JUeu+2/YGu21asCXF0xPTAVC1tVnUpbsjOL+c9Ik2sEE3QCQeF2Hr4arKK
         66hzxvlkUqYqPYvQAjJN26X2s/ABSnGIEaoPNVnmH0BXhFPIVgWjaBxkwQZ0rV6dmes7
         S7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=TbsInd+1Z+79pFOrHY4RWxlzLqkfeDMvhb4MGLvms5E=;
        b=bQIxu+pBw+t87i4UJqojS3IcaQQkkG4Xn1LG7NldN6Wnz07Py429mj/Gia9L6dFaIg
         LhKxGHm+NrVhBZ9WWhPiTOrdMIrnWbDD7TC2ufG4MQompYSQSPegkUdYh4L3rUCmHp8x
         bvaNMax5KQdn4lRjtqfv7AzkxhY4Zg7koLIUs95pei+RzlUvoiDIZ4LVhOhb5dDXjewA
         dPPVRkKPwESypGFvbS3isQB75OHR/izbIRBENTkipooQLMFFwSB+57l5qtL8hSwQ34Nt
         gYid7NujiTbREWef/YT3xk2mO/f5h51kA0kUiNpR0+bOCEbkHMSUd51ChJK9C4465PSb
         fXCg==
X-Gm-Message-State: ACgBeo0s1HWnxP3PgpobHgxOYgOtlrg/+YH1WSMloPLzwiw8vKQ1e7j7
        FP2TxZ7GHq4JTJdXBxTqq6g=
X-Google-Smtp-Source: AA6agR6rnbGkqugM+WccdAYIVJEjuRVIf/1Sh0Z2u6BMqpsZoc2/y9oOsi7VuLfOmBrexvxCimUOcg==
X-Received: by 2002:a05:6402:20b:b0:440:cb9f:c469 with SMTP id t11-20020a056402020b00b00440cb9fc469mr20484549edv.420.1660675716752;
        Tue, 16 Aug 2022 11:48:36 -0700 (PDT)
Received: from skbuf ([188.26.184.170])
        by smtp.gmail.com with ESMTPSA id n24-20020a17090625d800b0072ee7b51d9asm5631450ejb.39.2022.08.16.11.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 11:48:35 -0700 (PDT)
Date:   Tue, 16 Aug 2022 21:48:33 +0300
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
        Russell King <linux@armlinux.org.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: Re: [patch net v3] net: dsa: microchip: ksz9477: fix fdb_dump last
 invalid entry
Message-ID: <20220816184833.ak2cawbycws7mdzf@skbuf>
References: <20220816105516.18350-1-arun.ramadoss@microchip.com>
 <20220816105516.18350-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816105516.18350-1-arun.ramadoss@microchip.com>
 <20220816105516.18350-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 04:25:16PM +0530, Arun Ramadoss wrote:
> In the ksz9477_fdb_dump function it reads the ALU control register and
> exit from the timeout loop if there is valid entry or search is
> complete. After exiting the loop, it reads the alu entry and report to
> the user space irrespective of entry is valid. It works till the valid
> entry. If the loop exited when search is complete, it reads the alu
> table. The table returns all ones and it is reported to user space. So
> bridge fdb show gives ff:ff:ff:ff:ff:ff as last entry for every port.
> To fix it, after exiting the loop the entry is reported only if it is
> valid one.
> 
> Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
