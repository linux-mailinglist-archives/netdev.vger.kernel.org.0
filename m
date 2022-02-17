Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480874BA961
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 20:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245033AbiBQTO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 14:14:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245032AbiBQTO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 14:14:28 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910049025A
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 11:14:13 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id p8so484960pfh.8
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 11:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wuE56WM3UQB8eFLmSkgtZr3gge+LZEjKxwZ1rSi9WWE=;
        b=zzsLgXzpmqVgSfJH/t8MjbqlV6Y7ElYNibV57rHflGfEmRmYL/R0/u2ng7LHyusyAn
         aFnPuydPR9s54OTPqg3iy/ut4m1YDJzI9cO2M98GxU7DtDniR5eYyTuCtOqBPnGNsqcE
         aGWlKist1OvKEcLnZ9FXc/A+UBYvcGh9y7K64ziaC4bRioiup11h76mJze3O63S8TEIp
         gCqcWNnG2Enyx9sSLVGldYmGh+oNfCBiMqGffJHdSIdi7n4vpW1DZzmLvo50j0s1nVvI
         dSKmsMG7n3yPg9h0OzXkSUltL3rwOR2Q1rJKiArAEXJ6PneNK+dPRNQ6GTBt8T3eQpoF
         Xujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wuE56WM3UQB8eFLmSkgtZr3gge+LZEjKxwZ1rSi9WWE=;
        b=RdpgtRvSSyzN5jkibUA8hgG+K3trSvCt1qiQ1kSb/UXTxvWRyS/zqxDKl+6y31aqw0
         Kwok62zlQsI/sLQu2KmiDPc2ySghSvpozIJ66gpluN/ptvnCzbMIk+rpcoJ47ZzQ/Lu0
         n2xeMU9PApgBy/Z8HKHShlBZtFzu8uas4w+Q4TSUl3WswM+U1oAKnx8dTD0UU487Mv/G
         thkJXXfFMCOG6eWGW/sN4nWOqcd3MteRH9KMDdh20mAqhAoA4/EoL8LZkOkh0uImLkia
         qXHh/sKVsP7TvLNV9lg6CJYK1a1nXa1wzQF47NogN6oJhJDEf7d02cCUaZ6Fo7Im/BLr
         mzzQ==
X-Gm-Message-State: AOAM533PfGonbgXsGhtAm9jjI8x9H3brn2KRJP/4qvZN3DaEtl6jr2Dx
        51nhD/hBreo+MF9Bp0oXzapWGw==
X-Google-Smtp-Source: ABdhPJz6/GQr9jObuzcg1+mgPELGdSMUPcMgi/5aaxx51Ni6tWSvp7q9pwvwJQCdU+UUx1l18EJG0g==
X-Received: by 2002:a05:6a00:16ce:b0:4ce:118f:8e4f with SMTP id l14-20020a056a0016ce00b004ce118f8e4fmr4548648pfc.56.1645125253052;
        Thu, 17 Feb 2022 11:14:13 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id z13sm386767pfe.20.2022.02.17.11.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 11:14:12 -0800 (PST)
Date:   Thu, 17 Feb 2022 11:14:10 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dsahern@gmail.com, gnault@redhat.com, netdev@vger.kernel.org
Subject: Re: [RFC iproute2] tos: interpret ToS in natural numeral system
Message-ID: <20220217111410.70e4dba3@hermes.local>
In-Reply-To: <20220216194205.3780848-1-kuba@kernel.org>
References: <20220216194205.3780848-1-kuba@kernel.org>
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

On Wed, 16 Feb 2022 11:42:05 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> Silently forcing a base numeral system is very painful for users.
> ip currently interprets tos 10 as 0x10. Imagine user's bash script
> does:
> 
>   .. tos $((TOS * 2)) ..
> 
> or any numerical operation on the ToS.
> 
> This patch breaks existing scripts if they expect 10 to be 0x10.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Maybe a warning?? but no one will see it.

