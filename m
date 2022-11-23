Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4B0634F6E
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 06:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbiKWFRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 00:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235763AbiKWFRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 00:17:33 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D886FC4
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 21:17:32 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so902871pjb.0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 21:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XuKBoivNS+XH/kfJTexdv6yWwsgRaDQWG1xYb7pLGuY=;
        b=a8yZjIdYk3T1wfeZ+xCtDTXFB4Pzpki125Ph/ggjEarIJbbhcCwdYMpdVqgIq/F78x
         YIhlS94Wj6ocNneeAWpWliv0M1Xeut8+IGiSiFtt72M6JLjttGLbNw6EcihE37OlgZ0+
         WMyehxENHSt+I0WNRW6guzAtz1Jo/M+A7nyzM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XuKBoivNS+XH/kfJTexdv6yWwsgRaDQWG1xYb7pLGuY=;
        b=jmBtyATnc2e24/tYnbnOV4Aw8sOHhw88OyTKxrl0DmEjWWgDOmnQPv2Rtg+ewb9KNG
         br5lB9iwvuvqN2MK6qeok7Q/N5ANsgINTojdSctqBtBhUmsc4dyB5u2J6oFPmVphrzhr
         tPxXBZlt4aB6jh4xFfFmhIE+rRLRuj0vd1wRvngqAANL9M3GZuibcgT+w8X3+Hs1QLOv
         iAqYdNqpBcR4MH0iMxdLx/0CKKSeiQBT7/v6i0070Frq0tmwlMOvGu/tGBF+9Wp/L+Bt
         5MH2cEbN+yi3HqqrkJZenpJ+QBuUHRDTMPRCjzgLQ8KQneisSNOePTDeiSVTIjM2n8AW
         XhQA==
X-Gm-Message-State: ANoB5pmt2JEEsU7lqs+n5ZQHFmdCNgTHiNIC6LYdAv8N2o5L477YKuQZ
        seByv0hPj2tpuagq235cGrSokE1NEhtM5lZ9
X-Google-Smtp-Source: AA0mqf5W5QTCCRpeYVTqXiKXUMW0ju8V0GuES8Vm7sqGsKifj0n7NQ88H9KpIUSRGrPTRzFxMijvow==
X-Received: by 2002:a17:902:c7d1:b0:179:b756:5b60 with SMTP id r17-20020a170902c7d100b00179b7565b60mr10838554pla.22.1669180651819;
        Tue, 22 Nov 2022 21:17:31 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p22-20020a170902a41600b001869079d083sm8068698plq.90.2022.11.22.21.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 21:17:31 -0800 (PST)
Date:   Tue, 22 Nov 2022 21:17:30 -0800
From:   Kees Cook <keescook@chromium.org>
To:     edward.cree@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next] sfc: ensure type is valid before updating
 seen_gen
Message-ID: <202211222117.40BF455@keescook>
References: <20221121213708.13645-1-edward.cree@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121213708.13645-1-edward.cree@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 09:37:08PM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> In the case of invalid or corrupted v2 counter update packets,
>  efx_tc_rx_version_2() returns EFX_TC_COUNTER_TYPE_MAX.  In this case
>  we should not attempt to update generation counts as this will write
>  beyond the end of the seen_gen array.
> 
> Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
> Addresses-Coverity-ID: 1527356 ("Memory - illegal accesses")
> Fixes: 25730d8be5d8 ("sfc: add extra RX channel to receive MAE counter updates on ef100")
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
