Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3265F65C8
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 14:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiJFMKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 08:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiJFMKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 08:10:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800A74F3A8
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 05:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665058195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ye5axwxywhk4bfb5W0dS6RtY/ES0TszB6FdNd1hrimo=;
        b=VOInmtyuqAFDX4g0c7PnhTAtA72vdkZpwQQ3t/DVbaWvnArfNcOKhUL7JQixw7YPtiDN4z
        mad9Tc3tRlkonQH0ILKIw0kUF0MT/VJelsZ6CTZmNxrsLs0v5qfqdMtZhMjL8bXKxnuElx
        1UcVe7YlDKhRKmiLqOiAwrVAjGC4YuY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-489-uL8oRQRePuWHWKq5PH0zFw-1; Thu, 06 Oct 2022 08:09:51 -0400
X-MC-Unique: uL8oRQRePuWHWKq5PH0zFw-1
Received: by mail-wr1-f69.google.com with SMTP id g15-20020adfbc8f000000b0022a4510a491so461995wrh.12
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 05:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ye5axwxywhk4bfb5W0dS6RtY/ES0TszB6FdNd1hrimo=;
        b=vJhm6A6QR2JDggS45Mr4C6Svygrmkgx/V3DM3nUNKX5AkPQjkCfU+aXc+2CMEPw497
         MqyT8NaNf5Tup8goqieeOSZAdcyBVHv14qpQuSHH8VXAXDmLhByHdIuxKIW5Bc+6Ck+F
         /dD64gK9Bh+U6adQfi+BYzvUMRDIeMf9tzM5V3oOrgmya6HXA+umAdtJMDgE/RfH65Jq
         u5pgJg3UOXYrBTV5YrIbmI6PJVpqvHEggSd1TNzqs0Pev3eb3MHorwflqYaxmZB/gDNu
         JZZG0O+7eYAa3n9cLDFans7uk+HKgXptl6G+hCqSkOx0sInWfKm8znsvxmlfzAgNFnNq
         1FUA==
X-Gm-Message-State: ACrzQf09W/VQ0gO5zFT4cxLaHgaULY2cMsroq/wM3Un9Zir9bfBpLRK6
        hNmCrtpNrLyb5Ykwu97V/FT9qA2uD9tRmfqplaQA0LTVrlfWr72+cpQKjG4Fbsp8BbqKWT6wiiO
        q1ANrk8ghnkVmkuNO
X-Received: by 2002:a5d:47c5:0:b0:22e:655e:f258 with SMTP id o5-20020a5d47c5000000b0022e655ef258mr2754822wrc.569.1665058190156;
        Thu, 06 Oct 2022 05:09:50 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7BR8InjSffnDWWtyZKCR7hmcinwBCXxbudAWkDQ0fs2futcmyh7KqMXaBsmnmDatvDvkJ6ww==
X-Received: by 2002:a5d:47c5:0:b0:22e:655e:f258 with SMTP id o5-20020a5d47c5000000b0022e655ef258mr2754810wrc.569.1665058189870;
        Thu, 06 Oct 2022 05:09:49 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id 18-20020a05600c25d200b003b339438733sm4755572wml.19.2022.10.06.05.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 05:09:49 -0700 (PDT)
Date:   Thu, 6 Oct 2022 14:09:46 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH iproute2-next v2 0/3] L2TPv3 support in tc-flower
Message-ID: <20221006120946.GC3328@localhost.localdomain>
References: <20221005104432.369341-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221005104432.369341-1-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 12:44:29PM +0200, Wojciech Drewek wrote:
> This patchset implements support for matching
> on L2TPv3 session id using tc-flower.
> First two patches are uapi updates.

Patches 1 and 2 can be dropped since iproute2-next has updated its
kernel headers with commit 5e42ff10b12a ("Update kernel headers").

