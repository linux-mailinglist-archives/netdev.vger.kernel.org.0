Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFCE6E9813
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 17:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbjDTPKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 11:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjDTPKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 11:10:18 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20865FCB
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:10:16 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-24986c7cf2dso919873a91.2
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1682003416; x=1684595416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y5IZLdpbJM/eTII3AcIeiqk0+XCcvjMI6PRoCKsISCI=;
        b=XQZ9eRXYt86vSAqiwZs4rf1oJjtSNblInKQw7W3TeDQ98FHbWPWlwnLdkFkgkSuZh2
         +uMLV1zgX+bHg0tPcyT7BFfXzjG2uYMvofDMfCPMriEJLLfe+GffboXiYz94JGgmtSHX
         LY6qUm5bAZR+JXwNo3B7lb1byepwDsGYajifoIBYsih2DI47s2KZGpE7805e7vZOGr5u
         O9jJzBhYv7PIYbFfGbhJYclb6k0Bceh2LIHN393UGD9pTNRR/12LiHXHCDyMX29cbNSB
         yKcMvndarr9HhzezBqCzoDnmx/iLcyD9q5pk70PnNVIr1LuGkzxXgPN92zwwE26sw0Jc
         hnng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682003416; x=1684595416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y5IZLdpbJM/eTII3AcIeiqk0+XCcvjMI6PRoCKsISCI=;
        b=lhIJZoXNFCWbj9A/BHtDCtZkFi5IFjc8Gqzms21EzIo5PzKoO4Jmw73Up9NpNkXT78
         n7UABguG0/MHZG95h81WxQu2FVgCBqq8T6dR0ujQWgygF0o6UdC8NzawDreR0QSwkayD
         OLkN1z0ge2HpP93kHMp8zbZ/9F61giXo7nzdYVFJjgkflMW9KeshSIAEPaafGtQ9U9qw
         nOHDTXDfR3WFDZgI00HzA2WUM1U1iNxOG6GwcWMP+NKjZY7eM8XB1bNHknf7bxbq+Ktr
         oCc4XDOstT5NdOXDQ2iFBaG79B2WCqDKBmvYlUj6IrezGr+bKxZf/WMvCzsbgm8iTXnn
         qU8Q==
X-Gm-Message-State: AAQBX9d/kxSgIe5Xw66t9+Ao8TdM+cAllxV1OXekBSPOcFtBl2EpZ+p1
        amB/tiNbtSpIBwJJXmjk/wVEVA==
X-Google-Smtp-Source: AKy350bqlLt+pHWfNOQ/Vcn8El83+Gz2y75dUld1lKYVK72lJGfMAGhcp/R7KgsuANz5iZDihBQ0QQ==
X-Received: by 2002:a17:90b:4b47:b0:247:bdd3:a034 with SMTP id mi7-20020a17090b4b4700b00247bdd3a034mr1911368pjb.37.1682003416119;
        Thu, 20 Apr 2023 08:10:16 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id lt24-20020a17090b355800b00247735d1463sm1312987pjb.39.2023.04.20.08.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 08:10:15 -0700 (PDT)
Date:   Thu, 20 Apr 2023 08:10:13 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <bjorn@kernel.org>,
        <magnus.karlsson@intel.com>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next v3 1/6] tsnep: Replace modulo operation with
 mask
Message-ID: <20230420081013.6e2040c5@hermes.local>
In-Reply-To: <ZEFKzuPKGRv0bO35@boxer>
References: <20230418190459.19326-1-gerhard@engleder-embedded.com>
        <20230418190459.19326-2-gerhard@engleder-embedded.com>
        <ZEFKzuPKGRv0bO35@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 16:23:10 +0200
Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:

> On Tue, Apr 18, 2023 at 09:04:54PM +0200, Gerhard Engleder wrote:
> > TX/RX ring size is static and power of 2 to enable compiler to optimize
> > modulo operation to mask operation. Make this optimization already in
> > the code and don't rely on the compiler.  
> 
> I think this came out of my review, so:
> Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> Does this give you a minor perf boost?

If you change the loop counter to be unsigned, then Gcc (and Clang)
will optimize this into a mask operation.  That is a better simpler fix.

If loop counter (i) is an integer, then compiler has keep the
potential for wrap around.


