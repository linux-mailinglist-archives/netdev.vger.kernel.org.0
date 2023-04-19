Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38C06E7D75
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbjDSOva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbjDSOv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:51:29 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7581BF6
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:51:28 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id xd13so48439610ejb.4
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681915887; x=1684507887;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RjstvdYGMUmwl7cuoyXhYmHvHwi1+kSblwe4AfO4hek=;
        b=S72bQ216c1qdQUkdu/+jPjWWX97Yo8PU2hHNUcu4JxwHcSouaiZzG7iMmqshjym9Fy
         Ua1d59+VZ6TmuTy3QqRTzwEj2PVoBsGzIIP3Hg1WZvkDBC1x/xQhXN3MBwa6hkM6G04l
         +cnDmHizyTZMlbsYbGfyRDXDmVm1dDuYTM+n1lAuSROUW0uIoKgeQCpLjMtsoA4rVvp6
         e0b9ozjgsK1en+uy8C4aTVWVQrxXSccdmgkfEsDDpnufegsXK91iHrWWH7MO5KurRPew
         0rPGsn4KIBdKAVIJwt6Hzmem3/iXs+w9RyGe2YSR4TUII736yF7/WmOq2/+qRAn+uAWS
         vapQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681915887; x=1684507887;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RjstvdYGMUmwl7cuoyXhYmHvHwi1+kSblwe4AfO4hek=;
        b=fPQEoddpocullX3K9pEwUgRANy1nk3CHR2jLCFwPEo+6mKxFSLtfmC7jhK6JzOg/pW
         QlmqUGMgTWWn/IhzI+U6c+SWgHR6KsXJWPVtKX+wC2Ah/NvK22fx/becaGShCwTGE0x4
         FMeD8K/OkIt8F6g6Qv3jQKGFodhHDGtanbr56z0zATZD1YMgUb/e4xgnFYtcfqHiTmf2
         E8rdwLuS+1vplIp3PJb8hveb6ndcCvdT10KsUjs68Dw3y751kxwCxW4D9nB3QPukYuHR
         86H+ZLs6YnkPHCuA2jekFESQV1mDZUmgs4rh+HfAtXwrcvNXz2hOV7DwIHaB7MqUh91F
         4tqg==
X-Gm-Message-State: AAQBX9emoIf/Zo7dkp8Kj4qFfAmH7Hi+wwVCGe/SerLmNWgQzI9LjFsR
        I8xXOrtYKmV9tpSkt9B+x/U=
X-Google-Smtp-Source: AKy350Y+J74xVdupdmKrGhaq4ESmwt3/eFjWoEplpxHaVt+3Ucce8B8QPRA1/RLctUXnC0InuOV2wQ==
X-Received: by 2002:a17:907:86a4:b0:953:37eb:7727 with SMTP id qa36-20020a17090786a400b0095337eb7727mr4725912ejc.43.1681915886687;
        Wed, 19 Apr 2023 07:51:26 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ca11-20020a170906a3cb00b0094f14286f86sm6589334ejb.48.2023.04.19.07.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 07:51:26 -0700 (PDT)
Date:   Wed, 19 Apr 2023 17:51:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        roopa@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com
Subject: Re: [RFC PATCH net-next 0/9] bridge: Add per-{Port, VLAN} neighbor
 suppression
Message-ID: <20230419145124.5z47v2p62nbskqr2@skbuf>
References: <20230413095830.2182382-1-idosch@nvidia.com>
 <95a773f6-5f88-712e-c494-9414d7090144@blackwall.org>
 <ZD/z2vI5ab0zPdRf@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD/z2vI5ab0zPdRf@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 04:59:54PM +0300, Ido Schimmel wrote:
> On Wed, Apr 19, 2023 at 03:30:07PM +0300, Nikolay Aleksandrov wrote:
> > For the set:
> > Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
> 
> Thanks! Will rebase, retest and submit v1

Shouldn't the version numbers be independent of the RFC/PATCH
designation (and thus this would be a v2)? I know I was extremely
confused when I had to review a series by Colin Foster which jumped back
and forth between PATCH v6, RFC v3, PATCH v7, etc.
