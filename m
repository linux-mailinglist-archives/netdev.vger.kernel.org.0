Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B8C6217B6
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiKHPL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbiKHPL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:11:27 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19ACF193DD
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 07:11:27 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id t25so39383036ejb.8
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 07:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4y4rUaYbaz7MBG+9S3FNKhXxJIErUw0KZK+KgNc8tMo=;
        b=A8Eq+ntcGL3Xt10xRJMXfXhZ1Qs1giaozPNWkvbzUZ347P77mULNlBzwkrCmSXhGSr
         aHUsZHSzhpWG3OLyFw8aMC/5wdE9xbLncQ73fIEnIq1oMjT2t76tLQ2p/GI6j55sp+zF
         72OusR6esKv56luQvm2H59r4aMf7LLjZe+LsyiJVOp0xsacn4BhfHB+MZulleSKYlZCO
         ye4Jj2neq+m7mv6QhkRRBgfoLVlQb83vlDmiGxfUlV/S6EWrdrMSMB4zcb9Xj6uxyt8x
         cDx15ui3J3ZYfP2ij+bzZ0LNrHXhC3G9gRmWIGM2QmWro/huTKFivDKtu8dH1ZzRgzPu
         mbvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4y4rUaYbaz7MBG+9S3FNKhXxJIErUw0KZK+KgNc8tMo=;
        b=iAssSw0g8+1UvwleQrC8TDR4ao3kPxJE6vFQAAKpLvWbN8ZKFy4gYiUU4GFqpo33V0
         vlXFYlgsakAXpzOb/XLDEQZ6XiNxCJdcpKABcuRIjbmCD9Jk9HYjGzJnPv8ukQEEJBZq
         3T0m1UQYNePm3Le+/1KKsSeGxKC6pHkVSyhJI85tO97x06+DIm8ZiLlDrAuLFFDhUu16
         gyG8fpqX3yI1hAauLsBzX3BzfVTSegPDVmm/Im4dhuQMgKREiR9Iv3LEqAxLPnIUTKEW
         plXCXtaOun1lD5KjB/NQDRjJHYvXF/qqxzUV/cWCS6oS/ZRYD6Uo4QfAvh8AvVNXO5F/
         STvQ==
X-Gm-Message-State: ACrzQf3TSo/E1/HkGBE6Yy7kUVHBs8j9voQRlErZ3qhG60C7sWGx746L
        wiRO7BlmAIA6tJShydXpGvc=
X-Google-Smtp-Source: AMsMyM5m5a2qJsy6QlKmEDU1vf7Yg1coWHyWSPBfF4tKWIlki5r5pEqitz12fRKtZ5++j6PE4WkAgw==
X-Received: by 2002:a17:907:a087:b0:7ae:45f2:bf2d with SMTP id hu7-20020a170907a08700b007ae45f2bf2dmr17892315ejc.456.1667920285407;
        Tue, 08 Nov 2022 07:11:25 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id s7-20020a056402014700b00461a98a2128sm5597855edu.26.2022.11.08.07.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 07:11:24 -0800 (PST)
Date:   Tue, 8 Nov 2022 17:11:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 13/15] selftests: mlxsw: Add a test for EAPOL
 trap
Message-ID: <20221108151122.bjhi3rmqpofmdeqa@skbuf>
References: <cover.1667902754.git.petrm@nvidia.com>
 <cover.1667902754.git.petrm@nvidia.com>
 <389ee318ff1a799d1e94ba1a33ab2ff42bae50fc.1667902754.git.petrm@nvidia.com>
 <389ee318ff1a799d1e94ba1a33ab2ff42bae50fc.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <389ee318ff1a799d1e94ba1a33ab2ff42bae50fc.1667902754.git.petrm@nvidia.com>
 <389ee318ff1a799d1e94ba1a33ab2ff42bae50fc.1667902754.git.petrm@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 11:47:19AM +0100, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Test that packets with a destination MAC of 01:80:C2:00:00:03 trigger
> the "eapol" packet trap.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
