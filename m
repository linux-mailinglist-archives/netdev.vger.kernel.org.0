Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5D95F6447
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 12:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiJFKVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 06:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiJFKVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 06:21:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091AC12761
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 03:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665051694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E8PQYrKuK2/Hl24+POgcwMXBNTM5dRPCyF3STm9qM0g=;
        b=gkp/i2N1LkL3DA+q6cvzGBAJc1Q6za30ij28t3EtktEqVMD9JX2Gj5XGQRqiidK21Qugx8
        lbk5Ruaz2mJyQgRotI+g85Y1w22ptH99MFg7ZTkZGJrodh5hd9vsjieYQOSYb7JSW/1p9n
        V/WCqH3BIzgEI0ugYNIldG0p/FpqHIM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-447-8g0Fe1SJOWaGcox-36gWbQ-1; Thu, 06 Oct 2022 06:21:30 -0400
X-MC-Unique: 8g0Fe1SJOWaGcox-36gWbQ-1
Received: by mail-wm1-f69.google.com with SMTP id h126-20020a1c2184000000b003c07570f7aeso1491640wmh.3
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 03:21:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=E8PQYrKuK2/Hl24+POgcwMXBNTM5dRPCyF3STm9qM0g=;
        b=tyVSLxkoDUdf6JRRQTdIszJedUCO55TcdBl80po2mi/ijxCs632ZnlKA6KGGoWlYDE
         5gx8JFzywTyy2L5hJOZu3aqZTYfKGkGZJHZCSoSch/Px3ptOYsl81HhdKsR7kE6HE6Xi
         fvD4HOmy9Ft0PiqRntmSnco8D0ZTKCpVeZIghCP1jnB18v6MaXYhitdwKaJxpzYpKVPR
         P1X4xlSCXxJkGpfUfm9Nul81UEUyS9JAVIAvxVdCsUrinQdvB6myv9CEWEv5TW/ITko3
         /A12cZE3pBtE49ZS6PkDxCvEXDT+9aVpGy0Fh9aTyI/36fJA2nbXlGL0NNc/KO4coAKF
         tN0A==
X-Gm-Message-State: ACrzQf0tbLzodfx+ddpQT1ZeAQIl9aUpUS8a4g1hIZ84rG9mN1egMIy2
        ewItga1jCaaMnmRigaYSo9TLke8Yx12Lbb5KjV3AOm+YFWqD7TWIkY5F5C+VhjLgW34wuviJbOe
        r5xz3pnnWg1jmqkIm
X-Received: by 2002:a05:600c:524d:b0:3b4:8ad0:6d with SMTP id fc13-20020a05600c524d00b003b48ad0006dmr2717403wmb.194.1665051689861;
        Thu, 06 Oct 2022 03:21:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5JVp31HaP/KRmbGPg8W12uqDcUB44zqvkXc5dl9LvnPr4lypZ4E1+srBSYlpGawuBaeq/W6g==
X-Received: by 2002:a05:600c:524d:b0:3b4:8ad0:6d with SMTP id fc13-20020a05600c524d00b003b48ad0006dmr2717390wmb.194.1665051689673;
        Thu, 06 Oct 2022 03:21:29 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id n25-20020a05600c3b9900b003a5ffec0b91sm4888829wms.30.2022.10.06.03.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 03:21:29 -0700 (PDT)
Message-ID: <b265d1b7bfcc602f6257877dc430bf89a0323e08.camel@redhat.com>
Subject: Re: [PATCH 1/1] net: fec: remove the unused functions
From:   Paolo Abeni <pabeni@redhat.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, imx@lists.linux.dev
Date:   Thu, 06 Oct 2022 12:21:28 +0200
In-Reply-To: <20221005131109.356046-1-shenwei.wang@nxp.com>
References: <20221005131109.356046-1-shenwei.wang@nxp.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2022-10-05 at 08:11 -0500, Shenwei Wang wrote:
> Removed those unused functions since we simplified the driver
> by using the page pool to manage RX buffers.
> 
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>

This looks net-next material.

The merge window has now started (after Linus tagged 6.0)
and will last until he tags 6.1-rc1 (~10 days from now). During this
time we'll not be taking any patches for net-next so
please repost in around 2 weeks.

When you will repost, please include the target tree into the subj.

Thanks,

Paolo

