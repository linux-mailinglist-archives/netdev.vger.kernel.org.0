Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5DC6068B4
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 21:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiJTTNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 15:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiJTTNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 15:13:20 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96EA664C3
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 12:13:17 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x31-20020a17090a38a200b0020d2afec803so574922pjb.2
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 12:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iDRsdEdNVDLU/Tw2UK+o9RS6jTDRWTOD1iHgRCgqnvE=;
        b=JKXusd5ga07OHi0ZSXr1qgRVnM6fk4xv7V1mKCCUVoxRN4m+PcDN4xmrYXH4Lp+jlY
         BRkjX1oC2KAc4die4n9/0cqvlkVOUD8uSkiDCIxTpMFUud11E17QdA7Ln/N5wis6RYuo
         e9qFo0ZkH7utlMMCwcDZHyc+HHom2m3cG9HAQhOVvXF644gBB8yzEiDXiLLXnPEPGO1m
         BhexKm39r7W4xjlGG539+IfLZt2ZKRC7fV8IE2IwDcV7gRWau3fY4ja9CCV0SgW4osJJ
         fbkx/jMe2El7W+ipgfiH+cd+pr1WhSW9w9B97hHe6GstZOv33QyutV1uoLQ2qe/sa8Ul
         /SWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iDRsdEdNVDLU/Tw2UK+o9RS6jTDRWTOD1iHgRCgqnvE=;
        b=EIj7aHrmNkVPKXcafO8n3wqXL1BjJ7GtCkslsz52jT9p5tRMy6k1XMx2FlDJqK+VAP
         NEWHK/UBBQmcirO7XYMV0kPp/TD1VzZdBi3B50Li77gM+PFvzq4XnWIpSVFr7zanDoIz
         emWotzzxHD2CE+7BAZ56lKhBZ1i2DfpEHvi+FgJsdNoUQsSmok1HBIxJWnFMKb5Ad5j3
         54gr5eES6WXob9ju6So97ZHoXcs5sG3+yX5P61q7M5POB+h5q+chTf0REmSkSNw+WEU3
         D3IL/Zm11fHUiRDkDr7y8sQY5YlO0K8F45+tgHb/Qw5j0HmoImmvAvwLbSP7RN2mRQS9
         unVA==
X-Gm-Message-State: ACrzQf1hxiDHNa/xyiOpMMp3GxWyciq7kDty38wCzJ84Fk3cs7I144NC
        b74gTF7qqslOm1+vD3gD41KW6ELygtg=
X-Google-Smtp-Source: AMsMyM7Bjstf4gJqSG2wkX+IFr8wwhVs1MMtncnlna/FwyetrGRE4WUm1uEYQDEHt4X+kw0LKDnxhw==
X-Received: by 2002:a17:90b:3890:b0:20a:9ab0:6fa2 with SMTP id mu16-20020a17090b389000b0020a9ab06fa2mr54581719pjb.49.1666293197331;
        Thu, 20 Oct 2022 12:13:17 -0700 (PDT)
Received: from arch-desk ([2601:601:9100:2c:40bc:2209:ea1d:5052])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e81200b001866eeacd53sm1094465plg.17.2022.10.20.12.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 12:13:16 -0700 (PDT)
Date:   Thu, 20 Oct 2022 12:13:04 -0700
From:   Shane Parslow <shaneparslow808@gmail.com>
To:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control channel
 mapping
Message-ID: <Y1GdwOVJ7qXLBjP4@arch-desk>
References: <20220926040524.4017-1-shaneparslow808@gmail.com>
 <SJ0PR11MB5008658CADCDADE43C6B0D5BD7559@SJ0PR11MB5008.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR11MB5008658CADCDADE43C6B0D5BD7559@SJ0PR11MB5008.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chetan, just making sure you saw my previous email, which I believe
addressed some of your concerns. Do you have any further questions or
concerns about the channel remapping patch?
