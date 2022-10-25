Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E5C60D64B
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 23:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbiJYVqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 17:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiJYVqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 17:46:14 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D607B1FB;
        Tue, 25 Oct 2022 14:46:13 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id kt23so10722059ejc.7;
        Tue, 25 Oct 2022 14:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ycaLfQNN3PInfkiIqW8vGIwheuToIkql0ZXT6kL83w0=;
        b=HMzqPmg3+I/LZ4ykgnsR1UOL10k6OHyRYRve9fldSPZghKL9PFO8UXVI40qxg3El/o
         ANe/d8U65VDSoiHMWFQCUCxLnDQoroHkgRiwACiATleADIPEI+UEcMf+7Pa9GqxCwuRw
         eAMTPxEu/lGDOLPXvhDjJ4ldaPdFWDg4XUt3fU1o/tyh8odLbKXCUqbV7tp7wUlFFekD
         A0gTEcKaqaoP7XKjuyuAu5VXBQ3k2qbvUu/ieTComDXeqBP0Yd9+y6u85qec02ot3UEk
         4TvQYfz8FB/Vqm8KEt4QWcrz3zn50mkLlI9iATMA4+nOvDn6pQCS5TgCFtsacLdnmscq
         2KYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ycaLfQNN3PInfkiIqW8vGIwheuToIkql0ZXT6kL83w0=;
        b=wGAIl0fSF9CSe+jQusrXjYR2KPpvHoQ51G7kuzU3f07UIGSrzblynehlRcthfKpzZv
         EQg955rKBVBn6gg+BxuhtH2BO2amq+a98FyJ9tLR294On0ec2HRo5nzEPgtGifHBoZuC
         AN0KbWZQhl2lyaQkgIdQ0qhzUWQ6irf9YmH5zSPSQRN60M+ZUOoc1OB/zg7KPVhYtoNq
         A0M4AVFzJ62fL3Z14CyPHj2z+WADtVakI1i55qDDnDRJNMxAiOPKrLE8wLEGTd0ggWGv
         +W8ERPTvLvrqd1ta7H2cyxn763pJPCmuWAE8XJFuHbc+n6V3U7I/jtX4ry1uIlnNwAwr
         tLww==
X-Gm-Message-State: ACrzQf27WP8IzVAEFxA7GypAc0AoeM2MIXhMcbsRnqUny7NxLICic6rk
        l6BpqxQqjoPSfu6vlt2yjsg=
X-Google-Smtp-Source: AMsMyM5bA2tXfDp3eP42q1NHNDaYfxq4s7SDSLn65pBbpY/KnzTuOBmgeN3+hQcIi7ehV69UgjUzVA==
X-Received: by 2002:a17:907:7e87:b0:78e:1a4:130 with SMTP id qb7-20020a1709077e8700b0078e01a40130mr35116946ejc.101.1666734372185;
        Tue, 25 Oct 2022 14:46:12 -0700 (PDT)
Received: from hoboy.vegasvil.org (81-223-89-254.static.upcbusiness.at. [81.223.89.254])
        by smtp.gmail.com with ESMTPSA id fj20-20020a0564022b9400b004618f2127d2sm2277197edb.57.2022.10.25.14.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 14:46:11 -0700 (PDT)
Date:   Tue, 25 Oct 2022 14:46:08 -0700
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
Message-ID: <Y1hZID8iRtg73hV3@hoboy.vegasvil.org>
References: <20221021054111.25852-1-sarath.babu.naidu.gaddam@amd.com>
 <20221024165723.GA1896281-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024165723.GA1896281-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 11:57:23AM -0500, Rob Herring wrote:
> On Thu, Oct 20, 2022 at 11:41:10PM -0600, Sarath Babu Naidu Gaddam wrote:
> > There is currently no standard property to pass PTP device index
> > information to ethernet driver when they are independent.
> > 
> > ptp-hardware-clock property will contain phandle to PTP clock node.
> > 
> > Freescale driver currently has this implementation but it will be
> > good to agree on a generic (optional) property name to link to PTP
> > phandle to Ethernet node. In future or any current ethernet driver
> > wants to use this method of reading the PHC index,they can simply use
> > this generic name and point their own PTP clock node, instead of
> > creating separate property names in each ethernet driver DT node.
> 
> Seems like this does the same thing as 
> Documentation/devicetree/bindings/ptp/timestamper.txt.

That is different. It goes from:

   MAC -> time stamp generator

The proposed binding goes from:

  MAC (with built in time stamp generator) -> PTP Hardware Clock (with get/settime etc)


Thanks,
Richard
