Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BC960D6B7
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 00:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiJYWDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 18:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiJYWC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 18:02:59 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209EC26D8;
        Tue, 25 Oct 2022 15:02:58 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b12so38565744edd.6;
        Tue, 25 Oct 2022 15:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B5TwB3HwahgA/DvlgI1SO+JR6TGYUK+JWhOPn24MHF0=;
        b=p7YTe7u30t+3wLVC4on7U1c71rPI4CrZqHI5DQkoHELmnlDvpjydeOPWiCA8eVfhV2
         DUXq3wOnR/TXRGLkGp/Jr6hEU6Hpv0fS2FkBpEVRR1vE62xHJZjCglHXCRGwPH0RFdJI
         +h8qr/Z2VX+X75+ugv8x7SFtcXVhom/3Q1107MN9aSk5pczjy2ipe8LyublfYgVgvrR1
         gEs0zQQlnwtY5eWiBDerpaZYcyLGsOG3/V9xmVorqjvWUiEfaz/G1+LkzoeOlDF365cJ
         /gezABV4ssoMCo6gzRkE9V5xO2CAYVFlOmRS9Q4khn4VEhCTCi34X+cW4DeV0pXE78cy
         SuSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B5TwB3HwahgA/DvlgI1SO+JR6TGYUK+JWhOPn24MHF0=;
        b=R2IpioQU8d3n+O3okdJ3fsyDHUQP1DjLdl+nLUMJhwjcVMWkodvzxI/PAFBD/Iipm5
         Ln2VapqdQlefEw0Meu5NjyJFbxaoRJZHfP6AIwKs2DvdVK7fbBBOn7nBjM4oAIqM9FTZ
         PwLfcvYpz35pATXPWzC7YvyLKQM6Y+vuui78uglQPSolcDvphwIqAgYglU/6xBSxaV2L
         xJiJMFq/mZG4WDaraeocQ9w1itJbRYGg0kNCVwqWbAYGHwHEIaZsRt3AEZuZOOM4xgOK
         ZyB2Pnc4uzmGLEJiFC+VY7efQyNjI7l9PyZroXKF2l6ylAeHb+XAsNnC+V4PmkAgJVJE
         lqhQ==
X-Gm-Message-State: ACrzQf1iAMDGeNZudIaNqdeP++yN5oqzNs0CnO7icru6pwtOFex0pkwv
        gGnkKwfiEIEeUFwmaymKTl4=
X-Google-Smtp-Source: AMsMyM7t1sEqNP3xIjCsI9ZLSpusyMAHmRLROxmox+0BByHaB+dCyYs+tl0tjAQ9uELNr3DURzMF7Q==
X-Received: by 2002:a50:ed03:0:b0:461:9f73:b8d9 with SMTP id j3-20020a50ed03000000b004619f73b8d9mr14573439eds.140.1666735376681;
        Tue, 25 Oct 2022 15:02:56 -0700 (PDT)
Received: from hoboy.vegasvil.org (81-223-89-254.static.upcbusiness.at. [81.223.89.254])
        by smtp.gmail.com with ESMTPSA id kk20-20020a170907767400b0077d37a5d401sm2003091ejc.33.2022.10.25.15.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:02:56 -0700 (PDT)
Date:   Tue, 25 Oct 2022 15:02:53 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, yangbo.lu@nxp.com,
        radhey.shyam.pandey@amd.com, anirudha.sarangi@amd.com,
        harini.katakam@amd.com, git@amd.com
Subject: Re: [PATCH net-next V2] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Message-ID: <Y1hdDc2O0jJG9V+T@hoboy.vegasvil.org>
References: <20221021054111.25852-1-sarath.babu.naidu.gaddam@amd.com>
 <20221024165723.GA1896281-robh@kernel.org>
 <Y1hZID8iRtg73hV3@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1hZID8iRtg73hV3@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 02:46:08PM -0700, Richard Cochran wrote:
> On Mon, Oct 24, 2022 at 11:57:23AM -0500, Rob Herring wrote:
> > On Thu, Oct 20, 2022 at 11:41:10PM -0600, Sarath Babu Naidu Gaddam wrote:
> > > There is currently no standard property to pass PTP device index
> > > information to ethernet driver when they are independent.
> > > 
> > > ptp-hardware-clock property will contain phandle to PTP clock node.
> > > 
> > > Freescale driver currently has this implementation but it will be
> > > good to agree on a generic (optional) property name to link to PTP
> > > phandle to Ethernet node. In future or any current ethernet driver
> > > wants to use this method of reading the PHC index,they can simply use
> > > this generic name and point their own PTP clock node, instead of
> > > creating separate property names in each ethernet driver DT node.
> > 
> > Seems like this does the same thing as 
> > Documentation/devicetree/bindings/ptp/timestamper.txt.
> 
> That is different. It goes from:
> 
>    MAC -> time stamp generator

actually:
     PHY -> time stamp generator

> The proposed binding goes from:
> 
>   MAC (with built in time stamp generator) -> PTP Hardware Clock (with get/settime etc)
> 
> 
> Thanks,
> Richard
