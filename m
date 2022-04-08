Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E152E4F9CDA
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238788AbiDHSkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiDHSkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:40:19 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717D22DA8B;
        Fri,  8 Apr 2022 11:38:12 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id e4so9726653oif.2;
        Fri, 08 Apr 2022 11:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j9URgvci6d6dMD9NFQmmsAHkmfmb5Enalauf6tbhJOA=;
        b=jiPIr7GoWpN9FWlADHmNfwO/MmozypRL1uxibeNbh691ft2PekZcsPtGCCk9WvclG5
         QYQoOR/hba/9yTNagQEEDMFQvLCvPuGQtw+o127QmSBUicvAqu62MmF6ctyTKbAlPs6b
         yzDjJU+NFHY6dPV8dfso6Kt2vrVm8w0+yZaOSzr3Z+B/GbLnlC38yb9QGHWpQzYa2aud
         ajWVzJJKKNmWhipgING1JXq7oRvn+q0G4ih5eSE8iWvJ5QBze+PMJCBThTNBC5Jv3vqk
         niBezhG7WHje1KLJvsieO/0jiRGW+vFsM8NK8oPKUIOOZdcAu/u/ZjdQQfH6hImgh+6n
         Fbag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j9URgvci6d6dMD9NFQmmsAHkmfmb5Enalauf6tbhJOA=;
        b=k2GUap/BeRlomnu5/EQHFSapzu1YdnUdMjWPk8sZ8x3P8bdAQ8cI9zinLUGdN6offb
         rKsL5TZde4LbJizqPFnq1MjyZvd9THupscroJksjvBslChVI2WZYsa0Wbo2qfk5p42wa
         LmR4NV/1pYcY8oPU9qkycvpaW7zEUmaWfgqtYIkflYiVBM9lVVphccOH6qu/TZpJ12IM
         6w/FwXvATbhsbtQZLnOTwgfkXukF6SlX7a41FgtrBdoGhRlsT5+oP6k29Pl5/Zc7YLFH
         rXNgl2fK1np1FiVi7JtkeNNkmO1KrWRDuztBLYrEvHrpLAV7KCN8az0LiK3yGnH29aZ7
         Fm8Q==
X-Gm-Message-State: AOAM533Or0dQsmkUQfRTcUsjvurGkDU8/M5sESGI7peE+vpr9CLHwcwP
        Qd6h409rJOCwMvn/vk2EHj4=
X-Google-Smtp-Source: ABdhPJwqrefsiW7isgWIaV3ZOtcz/4FusHzdZTTS/dCv7uqj1spWsUdkNMYrSPAU/W4EM+DJxXdYaQ==
X-Received: by 2002:a05:6808:3ba:b0:2ec:f2ad:91a4 with SMTP id n26-20020a05680803ba00b002ecf2ad91a4mr512219oie.233.1649443091770;
        Fri, 08 Apr 2022 11:38:11 -0700 (PDT)
Received: from t14s.localdomain ([177.220.172.117])
        by smtp.gmail.com with ESMTPSA id ms25-20020a0568706b9900b000e264986877sm2300773oab.48.2022.04.08.11.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 11:38:11 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 1ECA41DFE33; Fri,  8 Apr 2022 15:38:09 -0300 (-03)
Date:   Fri, 8 Apr 2022 15:38:09 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, omosnace@redhat.com
Subject: Re: [PATCHv2 net] sctp: use the correct skb for
 security_sctp_assoc_request
Message-ID: <YlCBEU6r8Oe8h3CK@t14s.localdomain>
References: <71becb489e51284edf0c11fc15246f4ed4cef5b6.1649337862.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71becb489e51284edf0c11fc15246f4ed4cef5b6.1649337862.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 09:24:22AM -0400, Xin Long wrote:
> Yi Chen reported an unexpected sctp connection abort, and it occurred when
> COOKIE_ECHO is bundled with DATA Fragment by SCTP HW GSO. As the IP header
> is included in chunk->head_skb instead of chunk->skb, it failed to check
> IP header version in security_sctp_assoc_request().
> 
> According to Ondrej, SELinux only looks at IP header (address and IPsec
> options) and XFRM state data, and these are all included in head_skb for
> SCTP HW GSO packets. So fix it by using head_skb when calling
> security_sctp_assoc_request() in processing COOKIE_ECHO.
> 
> v1->v2:
>   - As Ondrej noticed, chunk->head_skb should also be used for
>     security_sctp_assoc_established() in sctp_sf_do_5_1E_ca().
> 
> Fixes: e215dab1c490 ("security: call security_sctp_assoc_request in sctp_sf_do_5_1D_ce")
> Reported-by: Yi Chen <yiche@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
