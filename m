Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294725B30D3
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 09:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiIIHsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 03:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiIIHr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 03:47:56 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4093A12A329;
        Fri,  9 Sep 2022 00:44:02 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id z20so855148ljq.3;
        Fri, 09 Sep 2022 00:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=4XMjwR+ZVeD0USbUtiJHh3TkUmGAdp/KlppcqPAVl1E=;
        b=choRwB5G8477CiDOj2pqYwuD9m2AS55XMrKVnGig2OvBR1eCq7RxsLzpulqA2nYZlr
         E2hpeVWo6QP+Y+giRj6Mo/4a2a2Z7qjEVOpMDBskCPg2wKXbgwyISJPPn0cNctE1wrGw
         TVCidUSbPePmCrcfapYi5hkVK1Ch/gtJPWc8Iyzw5t5gbIHtqe2B9NsYmWKomNR9z+/s
         f/nln8Dpka3XLbqD68Ew6Oqcz26dqOj78HsrbkiV6QRaxaXJZcXNYpYlo2TQAT0x3bcC
         yujyILzBlabLOZRRwsDig5/kX2aV/ivVW/h00aedB6cNghw+WbH7VBBJnUr094Or/qTp
         Zb9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4XMjwR+ZVeD0USbUtiJHh3TkUmGAdp/KlppcqPAVl1E=;
        b=Uw9qqC9hZut9D5lQn/XjVlX4FfyaSMl8+Y+QxpiOXVYBYp+2hrfSc3PA4Bk+dCtA95
         LSdnfS4WwAQJzwuP0v38y7YgVqD3NXIHDZq24sdWsORQwlozhoM7pEbuwURyucAsxp1f
         pH0Xcq1+b/N4In7duI2Nemz32amsmNSqQ9x8N6DCc7eozSVurbW3t+HlJ1gdQeQnoo7C
         p9OEradu35r2lI+r5GJ9EtxXIIDB0dXzF3OCEgt5W8zwuqpCFGDIR9cbJFNckUl+8jo5
         u6+9jGw592bxc2ExzX8YWYo4ragGUItfMTpAH3wydOcZ1jt19VlPxsoLSjEFB1W1z7x8
         DiUw==
X-Gm-Message-State: ACgBeo0QO2TYcmIjMbrjDbs8OSTq/eyr0OfcParLD4Dp8E4kKWzHsx/0
        0bNO5rBu7EnLQnR83CbTgew=
X-Google-Smtp-Source: AA6agR7+yVTqO60RqNzHeqffx6oFD+WICAw4ojvnQWZqe1a8W6jSo+QmECUJX5sc0vEmcnl0zde9oQ==
X-Received: by 2002:a05:651c:b26:b0:267:18e2:2024 with SMTP id b38-20020a05651c0b2600b0026718e22024mr3764904ljr.409.1662709413556;
        Fri, 09 Sep 2022 00:43:33 -0700 (PDT)
Received: from home.paul.comp (paulfertser.info. [2001:470:26:54b:226:9eff:fe70:80c2])
        by smtp.gmail.com with ESMTPSA id q30-20020ac2511e000000b004979ec19387sm153247lfb.305.2022.09.09.00.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 00:43:32 -0700 (PDT)
Received: from home.paul.comp (home.paul.comp [IPv6:0:0:0:0:0:0:0:1])
        by home.paul.comp (8.15.2/8.15.2/Debian-22) with ESMTP id 2897hT0H020245;
        Fri, 9 Sep 2022 10:43:30 +0300
Received: (from paul@localhost)
        by home.paul.comp (8.15.2/8.15.2/Submit) id 2897hRPB020244;
        Fri, 9 Sep 2022 10:43:27 +0300
Date:   Fri, 9 Sep 2022 10:43:27 +0300
From:   Paul Fertser <fercerpav@gmail.com>
To:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ncsi: Add Intel OS2BMC OEM command
Message-ID: <Yxrun9LRcFv2QntR@home.paul.comp>
References: <20220909025716.2610386-1-jiaqing.zhao@linux.intel.com>
 <YxrWPfErV7tKRjyQ@home.paul.comp>
 <8eabb29b-7302-d0a2-5949-d7aa6bc59809@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8eabb29b-7302-d0a2-5949-d7aa6bc59809@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, Sep 09, 2022 at 03:34:53PM +0800, Jiaqing Zhao wrote:
> > Can you please outline some particular use cases for this feature?
> > 
> It enables access between host and BMC when BMC shares the network connection
> with host using NCSI, like accessing BMC via HTTP or SSH from host. 

Why having a compile time kernel option here more appropriate than
just running something like "/usr/bin/ncsi-netlink --package 0
--channel 0 --index 3 --oem-payload 00000157200001" (this example uses
another OEM command) on BMC userspace startup?

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
