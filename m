Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEE153259E
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbiEXIuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 04:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbiEXIuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:50:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 109C071D88
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 01:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653382209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gdVfgoy4DMKIRrDCFm+NlF67nCZ7pRbEEsQazS020wI=;
        b=iJGpYN/hHHkyGZRbGjHCB5V2rwQvsk59YYlcAYPZTzhA7s4zel80Qw2Sc5/gEUOM1NCtFw
        s/2P6qqMVCeB51zU/erPylspVkd97kN0gQaoaYhtf93BOl24R1Q54MR7ZIh+33Qy/wngHf
        DfkmE3T+VdKkdW9uISI4sVNcd1f00cY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-kDqDj3MUNluDZIEMfXoJKA-1; Tue, 24 May 2022 04:50:07 -0400
X-MC-Unique: kDqDj3MUNluDZIEMfXoJKA-1
Received: by mail-wm1-f69.google.com with SMTP id n30-20020a05600c3b9e00b00397335edc7dso224359wms.7
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 01:50:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=gdVfgoy4DMKIRrDCFm+NlF67nCZ7pRbEEsQazS020wI=;
        b=HkY2RabyarBIE2dPpaRszlSzTQAmI6MB6r82GITUQBtaJ9LMIRdxBaVDguung/+Soe
         WPFMIhc4myObdgxWEpXZd/T7hkPrNF1NBLSvy8qrd2leXOGb1K0KG2p9w1i53oBnRbuk
         DT3bTjdwoVrkJ6arvtox85p/g5+fK/yuFQ7OKAM99JeVTipvp56DmSrflK2XyPcVi3ps
         M5oCxNn7YAJboAhoP/gblKfKKLHXaMSlMTtFSKJ4Htl0ODOvsOEXT2ZVEiQ6SwnHebPs
         cTFdx4Xd42OEl1KcF4+zWSJLBRyaWGu2myxlYUu9pP5JF+Av93WVsE9Pj1KBMF9JlddA
         B6Fw==
X-Gm-Message-State: AOAM532cnubvSTA6clhDbWtYp4juf4FH/g+qjie8p2BentsD/7VUEpLO
        8RmBWXPLPRsLAZsZ+hX+w7N3wpWlqA8wNAKTxoa6poDEVLI6gaim6WjZLMm1sDJ7N9jTigsbhta
        Lkd411yB2QcYhnrIf
X-Received: by 2002:a05:600c:4313:b0:397:26c9:dda1 with SMTP id p19-20020a05600c431300b0039726c9dda1mr2713409wme.184.1653382206480;
        Tue, 24 May 2022 01:50:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnlvbuROa+P4IBGkdAWKlHrWe7jd9IcsCGsLZeLRwKLCHZzMgVtKGw3WEXv9+5c7I00mtdCg==
X-Received: by 2002:a05:600c:4313:b0:397:26c9:dda1 with SMTP id p19-20020a05600c431300b0039726c9dda1mr2713392wme.184.1653382206260;
        Tue, 24 May 2022 01:50:06 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id u25-20020adfae59000000b0020d106c0386sm12277805wrd.89.2022.05.24.01.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 01:50:05 -0700 (PDT)
Message-ID: <3090d3059e3493af2b0d69961eaa8584834f7a1a.camel@redhat.com>
Subject: Re: [PATCH v2 net] Revert "net/smc: fix listen processing for
 SMC-Rv2"
From:   Paolo Abeni <pabeni@redhat.com>
To:     liuyacan@corp.netease.com
Cc:     davem@davemloft.net, edumazet@google.com, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        ubraun@linux.ibm.com
Date:   Tue, 24 May 2022 10:50:04 +0200
In-Reply-To: <20220523153110.474996-1-liuyacan@corp.netease.com>
References: <20220523150709.306731-1-liuyacan@corp.netease.com>
         <20220523153110.474996-1-liuyacan@corp.netease.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-05-23 at 23:31 +0800, liuyacan@corp.netease.com wrote:
> From: liuyacan <liuyacan@corp.netease.com>
> 
> This reverts commit 5ec8b414b4381e8714731415fc221ef50a4e7b14.

It looks like the correct hash is
8c3b8dc5cc9bf6d273ebe18b16e2d6882bcfb36d

> 
> Some rollback issue will be fixed in other patches in the future.


Additionally please add an explicit Fixes tag, it will make stable team
life easier, thanks!

Paolo

