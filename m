Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35C7583CFF
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbiG1LSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235855AbiG1LSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:18:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECA1266BB6
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659007112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yGpfeBLU4npZy08UlhzYAxMc8V/X2DiDxiToV52TcZU=;
        b=a+GiM+wLwBIBqmAVDKsSXfW6Y2LUv8iTiZAm+PmBXzO13D0mMSlUBPkF7SeALojSHvdPde
        kE1qYWvHzzeC9BxLkdTJCugOADnXHVOTz/mrtPEiqOB/jNUbHE9Z8kJqhtUXutGLe1dLbA
        1H7P0F1mDo9AoKsn1iqepAXYh+iEBbM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-zfuIegDBO4qbUTZhZ19fcw-1; Thu, 28 Jul 2022 07:18:30 -0400
X-MC-Unique: zfuIegDBO4qbUTZhZ19fcw-1
Received: by mail-wm1-f71.google.com with SMTP id az39-20020a05600c602700b003a321d33238so822854wmb.1
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:18:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yGpfeBLU4npZy08UlhzYAxMc8V/X2DiDxiToV52TcZU=;
        b=mqn+9Hicr7bP2xmbQq682BYwUWbyRkf5D8zlIX0hE/LQLwzZP4oEfX6gKstWo7JCed
         +lxMn0bEyAQgUloRWbgZGt2WVXU8oILSUs7IZf077lmmG4UI/mm2GsRPR3wapNcKOOs/
         XWSN0F14tFHDMj3mAW77pM/8m2ZqYsfDk/NJT4u80IUmx689fie3jbUqrQGAbI14uFJL
         o8zWoj85M37Znbkdjl4co+yQTAFNOPZ3Nwpgc5emuZo2uzqO+rly5q0wvO9lFOG3PiFQ
         26+pUKtXWo4T6pzwv+1a6zxFAEvh0zdFzcJY7lTyWG4gB8kzg3ranbq9Gzabe8HP25Ok
         jCIA==
X-Gm-Message-State: AJIora+zcqlUUt9/ycPuhbaH5yvP+81s40sA1wDoT0otvfjiyBDn/oGd
        U5LmkNkS0Q3usczQSGBAVwL46DbPqXdAOIosj5WeLIh5MBCHUkJeWytHoqKZIjVquVbn6i09wpf
        /E0DtRO0eePKg5vfl
X-Received: by 2002:a5d:6d8f:0:b0:21d:b7d0:a913 with SMTP id l15-20020a5d6d8f000000b0021db7d0a913mr16684057wrs.462.1659007109715;
        Thu, 28 Jul 2022 04:18:29 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vRIvMBIWmwipgoz0xflo5ttZd8NUau3ZBaw6KFAcH63VIptYi+yklx/dO3OyyYABsXrfUp0Q==
X-Received: by 2002:a5d:6d8f:0:b0:21d:b7d0:a913 with SMTP id l15-20020a5d6d8f000000b0021db7d0a913mr16684038wrs.462.1659007109277;
        Thu, 28 Jul 2022 04:18:29 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id l3-20020a5d4bc3000000b0021d928d2388sm652887wrt.85.2022.07.28.04.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 04:18:28 -0700 (PDT)
Date:   Thu, 28 Jul 2022 13:18:27 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH iproute-next v3 3/3] f_flower: Introduce PPPoE support
Message-ID: <20220728111827.GF18015@pc-4.home>
References: <20220728110117.492855-1-wojciech.drewek@intel.com>
 <20220728110117.492855-4-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728110117.492855-4-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 01:01:17PM +0200, Wojciech Drewek wrote:
> Introduce PPPoE specific fields in tc-flower:
> - session id (16 bits)
> - ppp protocol (16 bits)
> Those fields can be provided only when protocol was set to
> ETH_P_PPP_SES. ppp_proto works similar to vlan_ethtype, i.e.
> ppp_proto overwrites eth_type. Thanks to that, fields from
> encapsulated protocols (such as src_ip) can be specified.

Acked-by: Guillaume Nault <gnault@redhat.com>

Thanks for working on PPP/PPPoE!

