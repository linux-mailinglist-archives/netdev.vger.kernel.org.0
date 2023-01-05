Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E1265EE7A
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 15:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbjAEOMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 09:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbjAEOL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 09:11:59 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BFA54719
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 06:11:55 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id b12so24580205pgj.6
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 06:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JoOKD3fhvjltOz/BKivLTcbhttDC/bdQobavcXcDp9Q=;
        b=gAzUJJZY5TesWCbvlLm0Nvx5S8CWI/OFNcWGJRSXMa4u88qBLtq5Z57hlmLeVUiUXT
         Q8qjI/S0cMW9p8VYrieFiq0UGy5hnC86U+wYcFYymtPtgcdR/0SMbf0iXhDaBCaYTWVM
         6EV941rjN0MvpnXmnAsYcu+KRfPbRLXLKs5RFKov6UP4Z/rLlMqHNZTWzc0GjfGZ98vL
         7bK6FnyecXCpEKUA/oLqjRvQgzrsb270C9MAuES3bQRVOJIjEaB8QihVyc4pLscEdypU
         yNTS7dDPW3Idv+LDW+1kKfPZSvzqYRKttpcOuTb5lR7YyW8LbbVVpp2tQm+NbqpazAAB
         xKIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JoOKD3fhvjltOz/BKivLTcbhttDC/bdQobavcXcDp9Q=;
        b=dqQ4rKZLhz1wo9vD8JLLMCrhBYLPoQ9Mq5p7Q9Z8p8NY3vVz5oGkWk+P875jVun+kT
         HWZMCceVozTt5NiWORQeag3QMdFJZ25Gw+k+Rc35YQ9MP/WxJ/WMRrVUJu+ED/CscGFN
         QeldcO/Jo7DU8s+dqFVGe7RIyrapbHbUAbJYM9HZKO8WlBm0d4QoQC9RgCBvWLg8QhP1
         md5WoYmeWKcvgjCp+ueizjqtMWF3bYDIDCfMvOBT5GttHV6tv/Pb3mLKxTdcp6uSsCZo
         qDiUbsyCceQdXB21RKsVij8Qw+zfxxJZoZ4YK3Ph0bbulXTFcMb4EfDn1oXL6cEV2FrJ
         EYFA==
X-Gm-Message-State: AFqh2ko8J7WyTqlQQmwW8+LlrimpDuQ3ABmQqLpJ/N3vaeUIUGg3XZgV
        zTwSNMpZ/Shg2PgITRe0Fes4TA==
X-Google-Smtp-Source: AMrXdXt6ixVFYcF7JJc/xVT+7SfOpce9UgPPB+H+PfeNMBECoEDdXUIxAj9b40GeUTZxLY9XysPaXQ==
X-Received: by 2002:a05:6a00:c5:b0:582:6173:c6c5 with SMTP id e5-20020a056a0000c500b005826173c6c5mr18357064pfj.14.1672927914729;
        Thu, 05 Jan 2023 06:11:54 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id f76-20020a62384f000000b005810a54fdefsm20048453pfa.114.2023.01.05.06.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 06:11:54 -0800 (PST)
Date:   Thu, 5 Jan 2023 15:11:51 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] fjes: Fix an error handling path in
 fjes_probe()
Message-ID: <Y7bap08pgqs1LL48@nanopsycho>
References: <a294f5f3af7e29212a27cc7d17503fba346266b5.1672864635.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a294f5f3af7e29212a27cc7d17503fba346266b5.1672864635.git.christophe.jaillet@wanadoo.fr>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 04, 2023 at 09:40:47PM CET, christophe.jaillet@wanadoo.fr wrote:
>free_netdev() already calls netif_napi_del(), no need to call it
>explicitly.
>It's harmless, but useless.
>
>Remove the call, make the  error handling path of the probe and the remove
>function be consistent one with the other.
>
>Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
