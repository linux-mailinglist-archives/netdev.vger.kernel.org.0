Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3724D1B09
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347653AbiCHOzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234154AbiCHOzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:55:05 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E197B3B3CA;
        Tue,  8 Mar 2022 06:54:08 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id d17so8702020pfv.6;
        Tue, 08 Mar 2022 06:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ML3nrcJhigXGREi8g9Ao8b7VLASkDVKP+4T7mWa14QQ=;
        b=Yr+sI3+nu86ai18SgMFUJUXqxotHyynhRczG/fZW6xFgZuO8m3B/PTv/I2mtY2p+mr
         yQqjpsf/5X9zQjnlpC83k6lmZT0DRBvvW65Tl57CirqhZj0xN0BUC0tyun8SVhjC6Z4a
         fsg8oLrhuOFt2nDEeZ/CFQKkcUuoF1X/r2GRIOj2d+tBJjFIRFF5LWzidFrUTZZEMtG+
         zx92IihaheFNr0zf4DzmbO9DaxUllrWReZP3UOxDQQflgX574NAeh+jtsBvlJnUxcs6I
         zg9mtRYIicY6buSjpHXNV09aAHDCPyAp4RFNGQ1gBevVEW3YnSZ2fv26kN8uk4fM9MZY
         W00A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ML3nrcJhigXGREi8g9Ao8b7VLASkDVKP+4T7mWa14QQ=;
        b=5dGXqfTd/NF/7niKcg3hl/6wOsTCNaKBRcJBt9Qq6XSmhNcbqzDAqkllCHFDmd+Thn
         s/1S4xDAD8Euqnn8g2MQL3Tlhou1luygzgVdFzle+6+M7wM/Qxi1R2UWSbgj8i7+aEdP
         uq8yrW4v2KWFqjAgs08mbVY65Cr6Sqsm1dTlwFOkUEeYqF1N5Gvj+ilPPA+2ioX6ozyS
         ToNwbECYDsfBNy5tMZYacDBTLmtfPC/8TY1huG55p/fO31JIvBrGQJ/h2E5Mmrl3iLXP
         9ideka12pN1uWHcnUcIGiyyDUvDoG77BI0YwTuKvvlS95t/PV/IeCZrrptNs8Slzy5XZ
         EKdA==
X-Gm-Message-State: AOAM531qAgPKB8fzJES/hyRJ72ARYcClVizfRc3uSL74XNP2chffvvb4
        nWkWb5QiOTXrBRVBP54fHgI=
X-Google-Smtp-Source: ABdhPJwIXQDCwy0Jko2XAVWGqIW3gzCk2noTRbaDKzo7bfqMxCFhpsGNnMNyjhKymkCgoCiBXymlPg==
X-Received: by 2002:a63:513:0:b0:380:1180:9b48 with SMTP id 19-20020a630513000000b0038011809b48mr12547816pgf.623.1646751248440;
        Tue, 08 Mar 2022 06:54:08 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id pi16-20020a17090b1e5000b001bd1ffaf2basm3323234pjb.0.2022.03.08.06.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 06:54:08 -0800 (PST)
Date:   Tue, 8 Mar 2022 06:54:05 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Divya.Koppera@microchip.com, netdev@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com, Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220308145405.GD29063@hoboy.vegasvil.org>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-3-Divya.Koppera@microchip.com>
 <YiILJ3tXs9Sba42B@lunn.ch>
 <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YiYD2kAFq5EZhU+q@lunn.ch>
 <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YidgHT8CLWrmhbTW@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YidgHT8CLWrmhbTW@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 02:54:37PM +0100, Andrew Lunn wrote:
> This is not a valid use of DT, since this is configuration, not
> describing the hardware. There has been recent extension in the UAPI
> to allow user space to do this configuration. Please look at that
> work.

Yes, I had an RFC up that hopefully will merge soon.

In the mean time, just implement the PHC/time stamping in your PHY
driver unconditionally.

Thanks,
Richard
