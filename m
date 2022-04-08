Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE204F99B6
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 17:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237722AbiDHPo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 11:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiDHPoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 11:44:55 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3DB8A312;
        Fri,  8 Apr 2022 08:42:51 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id t21so9174547oie.11;
        Fri, 08 Apr 2022 08:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IkU27LeDLz1RvhbmUhGboZx0hYH9VeuwztKc/NAi28Y=;
        b=ZgjJSDCTKUDLDc3NBo4hhtsyBJmI0DCpouMvDza23ZSEfWsBN65jJJAXiNOoGmJEPB
         PHdneJ8eKLEtGwpawftqCwu2+NObvHFymZCi0xkuTZYDjX7Ab5Lm0VsmtVq/L7mL8M0s
         bCre+Pkrm/pbVlxEjwBsxsWNLB0F+spcVIXmToy4Y7pNWp/XKEZ18R/H/5dBX1N4VA81
         Q+uuBQ34KDX69pvfMo3gLAEkpolBKD/1kJ7ANtRRd+QiCpSme04heEM5nX1CvKUjYc31
         2Y36vcD6NLOyPMzucqkZRqgsVTe3aA22He/aFbnEAmPsd21qksOjxlA90j3D4BZ6CQ39
         GgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=IkU27LeDLz1RvhbmUhGboZx0hYH9VeuwztKc/NAi28Y=;
        b=Sv5q5auHjZKWTfHF+KHKj5pvEmO9R++83Y7ij1JeXlw7CqVeVNfpUKFuSff2ZGxIsT
         2Db4QW6BHFHpU3+KiPGZ340JRuFxIeaukFkdzADW98cNJzQ/baL4uoFr0E9piUC2NDSN
         4u7a57eRLXHJyii1od6agjCkgNES6vzZZj0Hr84XiL0Qi19i6+gUWPxq/Az8qcMeZJXv
         sDhxUNGOZeUvv/ZHlx8jc6OowpQFUdA3kg6+/6yD+fnjqUEFXCiWif+1X59kCh5dZVsS
         Nik2T16AvjUYGS1WDtJXFw1RB755R1IKcQIf9zw4f3Fn/NilJzLn+hrRan284ECJTG7B
         G8gg==
X-Gm-Message-State: AOAM531OYdVPRAzHjy1SN8ikHmwUmbOSai0aeBHc1emNAEMyDNlwP5Cz
        3yHb+bUBDtWUcQnLcnrBzb4=
X-Google-Smtp-Source: ABdhPJzjzjlked1QPV0x7+JOmHshn9p8AeCfIVQkMdGb85D7s9fLmVl9Q+yR6LC2W643I02P4wb11w==
X-Received: by 2002:a05:6808:11c2:b0:2f9:b58f:5ac7 with SMTP id p2-20020a05680811c200b002f9b58f5ac7mr135549oiv.132.1649432570787;
        Fri, 08 Apr 2022 08:42:50 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 1-20020a056870104100b000dd9a2eb20asm8843248oaj.21.2022.04.08.08.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 08:42:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Apr 2022 08:42:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Michael Walle <michael@walle.cc>
Cc:     Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH v4 1/2] hwmon: introduce hwmon_sanitize_name()
Message-ID: <20220408154200.GA105453@roeck-us.net>
References: <20220405092452.4033674-1-michael@walle.cc>
 <20220405092452.4033674-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405092452.4033674-2-michael@walle.cc>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 11:24:51AM +0200, Michael Walle wrote:
> More and more drivers will check for bad characters in the hwmon name
> and all are using the same code snippet. Consolidate that code by adding
> a new hwmon_sanitize_name() function.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> Reviewed-by: Tom Rix <trix@redhat.com>

Applied to hwmon-next.

Thanks,
Guenter
