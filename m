Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4ECB69B1A9
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 18:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjBQRQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 12:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjBQRQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 12:16:47 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC4E6D242;
        Fri, 17 Feb 2023 09:16:46 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 12so1395778wmk.2;
        Fri, 17 Feb 2023 09:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cWhvgqY8/7GeRFiaiZaKXYZ2HAj/UpSPlEUby1vD/r0=;
        b=i0QhIxDT4D5ks2N30YwMENCaCe24zBAkr0Nr3L5Z6K3HbxlYJr9v09ek9W/yiBSQ41
         cyOF8Lu6o3YQSi2ENKcbmcP3ptCCxueNhT4rB4rW9N+X9JIkD6Z+OZt64pbr0Z4usaJe
         fLO5pDDwqb7R4wRAWT1eXyF5GSZnOcFwETCVYVisTjT2ti4AOAxnDDSGnqyLVx5/uZYt
         6s3x9rbgXmI5X9hOixIp2UJiT3XEWjUqM1rjEdbwDRPt6eH5K5YEGyV/gVZ42hTbQjul
         8J47s+4xitlhJCmdkmG0KlAyA7XHLilfTMEOyhANc/T1hrKcPDYmbfYXqCxpSDD5ErbZ
         w6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cWhvgqY8/7GeRFiaiZaKXYZ2HAj/UpSPlEUby1vD/r0=;
        b=VW7zJ6a4YL5E+KJr/S41r2w+kzUzUxm8KXNWQDZ9nzNmlzNsRlXobiIioq2znVj4iB
         AJi93FTJEkkiqdBKpyz1pivYPvQoV6Tlccb6wwhTjNKCzlPCTq6bAU0OD9QdcbLn1X6a
         OhrUIvejyU/XRdoFaT1goSkLMOVTe6WZoam0R4L2cT89sYPgaZKlZ4+Kq9HhwLWyTJY2
         QhpsryqOtF13yUrjhXd8H6kSB6OxrpZ0K2xjqad0Vqf3MvrFEp6bUEZbEBl3M12EYZdF
         Begf7F63eUDY9ExsAaqH1tRh2pJbyk9F5JRafx9ceQRNmU4L7WOte+VM7HLGJe2A8qee
         ZpFw==
X-Gm-Message-State: AO0yUKWey0h53s/MXYeY6rkhMOL6Y3yAEOpGmbLW1rrdeAAyFYPsa2+I
        gGAzId63ISv6aPkSG00cD5k=
X-Google-Smtp-Source: AK7set/m/Cok4aWfKEWak/qeaKgkPmgccVehebqAME0+sWDvCBcpnldp5vKfcSJWA4xC62Q9zhz+6w==
X-Received: by 2002:a05:600c:46d2:b0:3dd:37a5:dc90 with SMTP id q18-20020a05600c46d200b003dd37a5dc90mr1120603wmo.32.1676654205204;
        Fri, 17 Feb 2023 09:16:45 -0800 (PST)
Received: from skbuf ([188.25.231.176])
        by smtp.gmail.com with ESMTPSA id b4-20020a05600c4e0400b003d1d5a83b2esm2057625wmq.35.2023.02.17.09.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 09:16:44 -0800 (PST)
Date:   Fri, 17 Feb 2023 19:16:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 5/5] net: dsa: microchip: remove
 num_alus_variable
Message-ID: <20230217171642.p364te2guqc7klns@skbuf>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
 <20230217110211.433505-6-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217110211.433505-6-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 04:32:11PM +0530, Rakesh Sankaranarayanan wrote:
>     Remove num_alus variable from ksz_chip_data structure since
>     it is unused now.

now=since when?

"git log -Gnum_alus drivers/net/dsa/microchip/" says it was never used.
