Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9C16BD138
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjCPNqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbjCPNqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:46:50 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD530C5AFD
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 06:46:30 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id m35so1293397wms.4
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 06:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678974389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pMb6/PASsupcr6he8sVzXRQlrPIQGgN7Aqxu5r+q+nE=;
        b=E/y8VUFvKXomJ/FdeOo5PGL9JIEzDa2mVhlFzrW9r/M/xKB/UisLO4wjyi0MK26zo8
         FgvDCRK7JDCocFRCurnAznWiTiSiHOW6kIwcQQyZP/63zXD17PFbw5vZ+KrIXhsVquC4
         ecgQPkNC0YF+SUv5Jbm7qddv4w8KP1hCTEPvRO4w/yYztrioP74W+0RDns++yJgGWfSC
         mGtq7CjogqN5f2HeV+akQTZfw1OHuAn8Hz5MvOn/mUqGDc6YaFi62jU6It2rcd5s2A6z
         Ir59f/z4yTlZfxeBONafJeZrpepzQN1bQCdTdAhoKFvqSRPplBmj3CrTh2+87E/jQep0
         UYDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678974389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMb6/PASsupcr6he8sVzXRQlrPIQGgN7Aqxu5r+q+nE=;
        b=in7HFtHX806Rv21Y8rcoJ2CCojeo4rVZ3M28gBxj54NufbotY6EYgFr8lCfWu+UKZn
         o/EiMsP/UHx/5gH96wZl7mxadlyiNcTldqkQ0loaL2pHtvqgeIaWNO5E9lPuwHKeFkoV
         maU10d3FzbkOPsG2KSOhaOW27ScL6i8tFBVdFOj+JykKelU2wOhoduzB0GrPAs55PlV8
         uFlpBJgPBh0IWOPrfoRbLn0OPJRKrn70yBnRXNU2tVlBOxZZqQV82StFMtDfdZK+i+lr
         w7CC0N6nmr8xH07vuvK0cM3Hg0fCX11nnjHHpXI74g/JGbW89+VmQykVlOQxqPjBXNrD
         ERPg==
X-Gm-Message-State: AO0yUKWMR+3z1COCfYLsHNmd/rqtoAN1EtDnTlzV3w/HFVsW/Aq/2Nhm
        EEyjGvsN+UE0KATgJYpL5yWEPA==
X-Google-Smtp-Source: AK7set/nW5zUSHMaxTpv2Pw31kptGyNdFxLbvmzoEzS/oND2VCzl2/1KbVC607PtsYw3wTt5haUUTQ==
X-Received: by 2002:a05:600c:3b99:b0:3ed:2352:eebd with SMTP id n25-20020a05600c3b9900b003ed2352eebdmr14221295wms.11.1678974389093;
        Thu, 16 Mar 2023 06:46:29 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o23-20020a05600c511700b003ed29b332b8sm5678370wms.35.2023.03.16.06.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 06:46:28 -0700 (PDT)
Date:   Thu, 16 Mar 2023 14:46:27 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH RFC v6 3/6] dpll: documentation on DPLL subsystem
 interface
Message-ID: <ZBMdszEWZNN2VFz1@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-4-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-4-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:04AM CET, vadfed@meta.com wrote:

[...]


> Documentation/networking/dpll.rst  | 347 +++++++++++++++++++++++++++++

Why this is under networking? It is not networking. Please move,
probably directly under "Documentation"

[...]
