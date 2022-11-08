Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B92621705
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbiKHOmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234254AbiKHOmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:42:53 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130E32C646
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:42:52 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id 21so22838171edv.3
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 06:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QXljKXuwBMk+OsTizGOu0V1MtZuYBJCVki2QOtDb+JA=;
        b=OtzHTh38wbeW2+6DHRuT1bY8TboZWM4dFCb6TBS9e1+tDi1D1ZvCmpOlplrc1i+ztF
         ZX2vgGiyJyNktp8r4rmEw0fL28JUGOXaLQ1WRYWyZBlcDN+hz85qzuggWg18uTzRn4Av
         x+kj6HuZ9BlzqqabI6XxwdMRG/FkHVca3SD9ocKIgkTMvssmNPe7EjvTY6bOX7QTME/J
         0i9pHg4QjVRA6iSylbNkdmajOUOnbBRxr6nBREamUrtf6bR3QBcVH/pd/rJhS7Fvnn7c
         unTlRqhZDq+d45OkF1ZSFlGzY+WXRvR4nl8gYzAHN63JRF9DlY70TODN/DKcYyStYdfW
         peeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QXljKXuwBMk+OsTizGOu0V1MtZuYBJCVki2QOtDb+JA=;
        b=zdZDSoXR3FuEXtMXILCQ6eGeWOv0ZOYB+zxtRCYzKSRQeOq0euH7TNTkFzh4Mv21yt
         enyp5JA5W4qB+WjLEFBsiAq1BnkEfUptbQOoL93QjFhmdsyZSqewFO21SOxQaXJiSUMZ
         ncfbz++nPPzVgL9vkB3PxxF92gES1aKwpINnn8nuJNsEQZel5M7njsp0MgDOftD5NgEx
         oRFQZUWdgUZWcrUQuh//eQmqMSJRZkBydxmqQE8JpXxPEykwT28b8la/LotB9ZhS1a5z
         WsY3ACLRDDjZ6sy53KxV2bd4k0/G+CN4DedkffmbHYz8VHsQ2iST8TREKvc74l5Iyz3Q
         7p/g==
X-Gm-Message-State: ACrzQf1RTOMMRhfBxvkIXXIG9cQdVEuYoIN1L1lNfm6dY4YhlR2OquHp
        nO8vez4GOYglOpw6HESDP5s=
X-Google-Smtp-Source: AMsMyM5mnaRwuolrGoF+RUbfwg9sOFGg4s7CuPHbEwTis3aQLaY2HXbdtZFwQgQULpZ/QPa/1IELfw==
X-Received: by 2002:aa7:cc13:0:b0:453:52dc:1bbf with SMTP id q19-20020aa7cc13000000b0045352dc1bbfmr56255647edt.30.1667918570622;
        Tue, 08 Nov 2022 06:42:50 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id l2-20020a1709063d2200b0076ff600bf2csm4759244ejf.63.2022.11.08.06.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 06:42:50 -0800 (PST)
Date:   Tue, 8 Nov 2022 16:42:48 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 15/15] selftests: mlxsw: Add a test for invalid
 locked bridge port configurations
Message-ID: <20221108144248.daycrsxaxvwokxfj@skbuf>
References: <cover.1667902754.git.petrm@nvidia.com>
 <9fb8b83ce2029c51c81c942f24ece789ae8fe1c1.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fb8b83ce2029c51c81c942f24ece789ae8fe1c1.1667902754.git.petrm@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 11:47:21AM +0100, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Test that locked bridge port configurations that are not supported by
> mlxsw are rejected.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
