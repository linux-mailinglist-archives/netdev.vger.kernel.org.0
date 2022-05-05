Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C612B51B6B2
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 05:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241723AbiEEDww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 23:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241715AbiEEDwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 23:52:50 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309D31A820
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 20:49:12 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so6911476pju.2
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 20:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fqhzc27a9OulOaELZK8oqmPPExf+OJmruMHx56DlPMU=;
        b=wAam2UzLs8mRTdbrg5Tm4iXKWRxMmW6XB0QLAR3BKrw01jRsRpQJQW/6VvPNy06ZbZ
         gisuWF4BSXLaHyXUsSjs4VpmNzYCYrghRoVYcFNOS/hq1xEVDItHYofzM/itXB35vcYI
         fXTynXq9rjj4jO452GMvNv81Y89/mN2UGBCGDEq7l/Q0hAFvmNLDjzd+cwgGEjTyQkSr
         QrHW2R58Z/oHFRHCnn1etA3Crbj1/pJsrH46fAmj23Eh+5tDnjXJj9VJwzxDAE2X2f/L
         XDv3dHIg//fh4/ZoJDla2ma4g4vQbm0HvKCfCc2IDZHwxVACLz6h5CVuSbpTw4wE/VMP
         IGeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fqhzc27a9OulOaELZK8oqmPPExf+OJmruMHx56DlPMU=;
        b=L8XiPb//8xXOshiRVJYa7DyljUuQ83qQ8Kz3GNsfktCOBYaeje7XlPRF1V3ZRS/jG1
         E6gvR6ElHVnFrjWUT6+hgKtd5ocIzvIhMjwZgHvorm3hSt21BqNv4617G0ggjT3vODL8
         P331rwRnUazin9iwkb0Y9KgUQjuEyyf17aDU9cH77ZFFBVbLsUU4xmc1uL57Cb8Lefzp
         ktCgsNVZdHV8mUBZ0ds8LxPYUdBBXlh2w9QnU5teng5CtnQjhNgG1MO84tT4DRfKX1Ev
         2cHJC4N2tYKMQl3Efkk6g7LLwQkK4peNWm66vOdvWakcynTiMjki2rSVYf+SkpVU4E0a
         GznA==
X-Gm-Message-State: AOAM531KdMnSvpzt/NH7HLdU+MLxT38oYcizLIsM7l64i8J2zpD4nyGg
        /OgQ/2SsvtAh/vYpczKTyZX8yw==
X-Google-Smtp-Source: ABdhPJy/rhPjcoCzFjqmsjiExAwCeGEPmo1rG/SNTjzHOBXgIb1sn7tH5reQLjuL+7lYr8Y+rKyZ7g==
X-Received: by 2002:a17:902:a712:b0:158:9e75:686c with SMTP id w18-20020a170902a71200b001589e75686cmr26328645plq.56.1651722551647;
        Wed, 04 May 2022 20:49:11 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id z3-20020a170902708300b0015e8d4eb201sm294756plk.75.2022.05.04.20.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 20:49:11 -0700 (PDT)
Date:   Wed, 4 May 2022 20:49:08 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Magesh  M P" <magesh@digitizethings.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: gateway field missing in netlink message
Message-ID: <20220504204908.025d798c@hermes.local>
In-Reply-To: <DM5PR20MB2055CCC42062AF5DB5827BAEAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
References: <DM5PR20MB2055102B86DB2C2E41682CE3AEC39@DM5PR20MB2055.namprd20.prod.outlook.com>
        <20220504223100.GA2968@u2004-local>
        <DM5PR20MB2055CCC42062AF5DB5827BAEAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 May 2022 03:43:45 +0000
"Magesh  M P" <magesh@digitizethings.com> wrote:

> Hi Dave,
> 
> Thanks for responding.
> 
> The librtnl/netns.c contains the parser code as below which parses the MULTIPATH attribute. Could you please take a look at the code and see if anything is wrong ?

That won't support IPv6.
