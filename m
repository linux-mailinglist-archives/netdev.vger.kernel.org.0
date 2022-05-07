Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2815D51E2EF
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 03:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244805AbiEGBOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 21:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236738AbiEGBOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 21:14:20 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D591F13F0E
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 18:10:34 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n8so9002114plh.1
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 18:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9vWd1LhMURqGl7+uIR67JirMFTq6bLPMzdhJYJHWWJM=;
        b=DinifjsJFM4TDwEIDnB0yYbG6G9kIU7vJbv4FpqmBJkVTA3Xb/4Iv/XPMXmvt2giBI
         MQrLGgxfZdpxu9v6fdbpFCVcQZBZ1MwBOGqHtbPerPiqQfZIr+qap7CulzxO06AraLta
         l+qFgMajF591ChVZqiJs9vIY5tT3VbcrJO8tHjW+xMP3HvDMddMZsBKF3MLgzJq6HYZL
         fkIO09qTp2YAOmA+k4EQCWwN/tf3Uoaz69paCZ6linE2zVtzEwWgJ8v/c2hDU0Uhf3Eo
         Al06DjDszYFy3Jwl7xXuuLLqhWQryhNHI+FaW6li5gycz+gAxM8G2ba0SOQ394Al9P8s
         FqAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9vWd1LhMURqGl7+uIR67JirMFTq6bLPMzdhJYJHWWJM=;
        b=0cTDAbQ1kG0N6yXTRbqp7S6sDG1snk2s6NdgmrpCMWImSd7ztddGzNhDq9quV3wa/F
         MR2aDwtio6zp+6WsIJXhf3khwExHW1juRumhq563wYVvguc0P83lkuBZGBEcHlMhEl3j
         aImCT2r6zc5TqmG3XJvNMWpLSCqibhg6EMzk+gS5WFhoCbA/XbzGsDluvqLVji+rnEgy
         5uKjjFQrmZkTrtd8Eo+J33s4upayzsNGVvBK1UmYQOFYs6iHo1lMjsZk/9Y5LihF5/b3
         qF+c1Wjeo+JzUTC6T4OVpt3M/VonYd82dn2OeeyX1nlFM7olfCrtWXo20ba98sieTfJA
         4CIg==
X-Gm-Message-State: AOAM5308kgse8gBey91FBVvRSIsZ9FyLZL0fMps2D10ZIfF9BQ3LZjjI
        5OKYimDk3j33B368KArMHNs=
X-Google-Smtp-Source: ABdhPJxWgWYt7ewmlPXqjRmqhUde6+OcLxt6zmSuQNu94y6Jvxib3K2Tmsameqlh20cn4QNaAPOkuQ==
X-Received: by 2002:a17:902:ea53:b0:15b:1bb8:ac9e with SMTP id r19-20020a170902ea5300b0015b1bb8ac9emr6213786plg.45.1651885834292;
        Fri, 06 May 2022 18:10:34 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id a8-20020a1709027d8800b0015e8d4eb256sm2377490plm.160.2022.05.06.18.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 18:10:33 -0700 (PDT)
Date:   Fri, 6 May 2022 18:10:31 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     vinicius.gomes@intel.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org, mlichvar@redhat.com, willemb@google.com,
        kafai@fb.com, jonathan.lemon@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 4/6] ptp: Support late timestamp determination
Message-ID: <20220507011031.GA27468@hoboy.vegasvil.org>
References: <20220506200142.3329-1-gerhard@engleder-embedded.com>
 <20220506200142.3329-5-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506200142.3329-5-gerhard@engleder-embedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 10:01:40PM +0200, Gerhard Engleder wrote:
> If a physical clock supports a free running cycle counter, then
> timestamps shall be based on this time too. For TX it is known in
> advance before the transmission if a timestamp based on the free running
> cycle counter is needed. For RX it is impossible to know which timestamp
> is needed before the packet is received and assigned to a socket.
> 
> Support late timestamp determination by a network device. Therefore, an
> address/cookie is stored within the new netdev_data field of struct
> skb_shared_hwtstamps. This address/cookie is provided to a new network
> device function called ndo_get_tstamp(), which returns a timestamp based
> on the normal/adjustable time or based on the free running cycle
> counter. If function is not supported, then timestamp handling is not
> changed.
> 
> This mechanism is intended for RX, but TX use is also possible.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
