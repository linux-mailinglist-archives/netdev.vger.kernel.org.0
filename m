Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E1A50FD44
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 14:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350088AbiDZMoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 08:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350068AbiDZMoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 08:44:13 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F8015F59F
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 05:41:06 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l18so9168027ejc.7
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 05:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GgvvLpFQH/B1Q0jID3DFB+p4NStJO6n2fYlzSS3apQs=;
        b=l1mPyhGLHtDDv/w7lfLwKgrZ40C9hBXMVb70CL+4Uj1Bx80QcaKgAxhVOTfjUSkp14
         qChN1Fd8V40U15Sxhda1qO2AfEZeBmynPVLrU3A0chRtzxQNbULtOYYknQa6377jYHME
         pUkzzTrtJo5g6Q1M1xSqb/ZePf7jaCWXPD3ymBLXeHXsvrd/34aLLsXuL4bnOsHuFGOS
         wpX9VDBDwB/zURgl/sDgs/XEFbF2bK68ezdt4nTzRrr2yk3GpFe/i7IJg3D/kaHG5MAs
         MV7HpU3H+GXOTOHGJymC1X0E1Ng4al7P8mekPKaEpfdGbMwxM+VE7uGX7sZUzTHbIQUZ
         cwCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GgvvLpFQH/B1Q0jID3DFB+p4NStJO6n2fYlzSS3apQs=;
        b=SXED3irub7OYcowEWWYLjU0XDffUGp3uWuzNZlTDcn2AceLH+mZJobUaWssOC5zl7s
         d6j/tWCg9ncpo2648CIZg13vjBkmWKVKy03BBz/zo+WqjqM+6yjZ4EQ1G1pxXLgK4Ecb
         x/Z68cA2uzpf2aRvtyM0E2wjZvqV8h0GtYjaOT1c48InhLOJorpBvn4DsvLJSM5tZUgQ
         uz1csi0BRIfqQdkKKFhatIkcmAG2bDSLBWSNpiRjfvCQkqpwf/8Rc2ZHxBMkPIweEQNr
         GZ+BkyJDSiK7Obrxp/FQgrRt/qMvul2vvMRo8aVK9GPxD2hV92cvzK9H6LRz/sKh2+Q6
         NrHQ==
X-Gm-Message-State: AOAM533ZmuIzvWCU+XiQIvJvuSjex1xi8VXpheaNjY/Dp5kTIB4gGaky
        3FkUVe2GnE6Z9Cai81F2Bg5U/w==
X-Google-Smtp-Source: ABdhPJzTLmvvbDWAyrG5hCAbvNeSbbRm276LUnjZ6YXD1641Ti3P8Ddt0EWBFOnAEeFM6k1Wg7xpHw==
X-Received: by 2002:a17:906:dc89:b0:6e8:73e0:ef9a with SMTP id cs9-20020a170906dc8900b006e873e0ef9amr21148372ejc.638.1650976864597;
        Tue, 26 Apr 2022 05:41:04 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d7-20020a170906174700b006e80a7e3111sm5052088eje.17.2022.04.26.05.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 05:41:03 -0700 (PDT)
Date:   Tue, 26 Apr 2022 14:41:02 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YmfoXsw+o9LE9dF3@nanopsycho>
References: <20220425034431.3161260-1-idosch@nvidia.com>
 <20220425090021.32e9a98f@kernel.org>
 <Ymb5DQonnrnIBG3c@shredder>
 <YmeViVZ1XhCBCFLN@nanopsycho>
 <YmflStBQCrzP8E6t@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmflStBQCrzP8E6t@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 26, 2022 at 02:27:54PM CEST, andrew@lunn.ch wrote:
>> It is not a separate devlink device, not removetely. A devlink device is
>> attached to some bus on the host, it contains entities like netdevices,
>> etc.
>> 
>> Line card devices, on contrary, are accessible over ASIC FW interface,
>> they reside on line cards. ASIC FW is using build-in SDK to communicate
>> with them. There is really nothing to expose, except for the face they
>> are there, with some FW version and later on (follow-up patchset) to be
>> able to flash FW on them.
>
>But isn't this just an implementation detail?
>
>Say the flash was directly accessible to the host? It is just another
>mtd devices? The gearbox is just another bunch of MMIO registers. You

Not really, the ASIC FW is also not mtd device. ASIC FW exposes set of
registers to work with the ASIC FW flash. The linecard gearbox
implements the same set of registers, tunneled over MDDT register.

Also, the gearbox is not accessable from the host. The ASIC FW is the
only one able to access it.


>can access the SFP socket via a host i2c bus, etc. More of a SoC like
>implementation, which the enterprise routers are like.
>
>This is a completely different set of implementation details, but i
>still have the same basic building blocks. Should it look the same,
>and the implementation details are hidden, or do you want to expose
>your implementation details?

Well, I got your point. If the HW would be designed in the way the
building blocks are exposed to the host, that would work. However, that
is not the case here, unfortunatelly.


>
>	Andrew
