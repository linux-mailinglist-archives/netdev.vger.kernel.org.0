Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE23C4F7180
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 03:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237058AbiDGBd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 21:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240353AbiDGB37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 21:29:59 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FC81A590A;
        Wed,  6 Apr 2022 18:22:26 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id kw18so4156872pjb.5;
        Wed, 06 Apr 2022 18:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NgQfrEiHvY0rj5bc8G96bBHD3fUTUsFrxi+7ks+aDZs=;
        b=NV5tFDPkfdZQe29Eg0I3Kzg8Xl7j/aLXgeBNe/8tJHlG1t2vU5gltbuZXdTqhKNFVq
         hu29WB/Oc8wZt6aBV7ShihlNxasT5emfz0esy4jcTSDYFT+tnLebthmgV9xpOLlJ9Ctn
         VySi/Iww4lvjOEnXRICOK8UAJDXpJ8Phi39Dl8hy4jUDXbPPiFPczLjNU2Zyd6xwnQux
         lj5TtCTGj/h7GtGHy5BKxGnXYNwNpKDTJF9nxzYC9ZPfFEtR3MTyoMchMRc2FVsyuwbf
         hVssd4O/kAws0q/WoQciKRUKA++Tls2Z+x6scGpY1LWk2wFsqhpBtzkw5ZOWYzvH8maW
         AXhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NgQfrEiHvY0rj5bc8G96bBHD3fUTUsFrxi+7ks+aDZs=;
        b=Qvq0fBISrGXGMKk0IhND/y/PbDops2sjUyMtdrJjL9/12HdkzwDv9udRgZXcFDL4s/
         1Dw2E61uxOaGQf67P72M3vGyXEKs4MJKqKFNFPgYG+V3V0GpvQhrd1JPHk9AttKQa9LI
         bNzTyTQ2MgOSZvi1OObsOYcfQmHuiS+2htCEf3f9hjl9U1ej6Rh6wqBXJmZ0DuFXGqmo
         EvK9PTzYMtsjlslAy5uEysQAhTI/wTOx+2NQ+Hf2SpQsLZ49hOKsynU2sap9ZS561BP/
         paQNG6C8p9rk0N0gP70P3ukC5miW/vZBWwUCEq2T/b5UytJyZOxWkQ6eXA+FILXMLB/n
         6R4A==
X-Gm-Message-State: AOAM532hXcfntd+dYET2nz4iPC3wU1jOO4DVOvy97zIdgTY+SLnR8hdt
        puAWqD1axRPaPzaJzeONTTg/mZ97U/NV4A==
X-Google-Smtp-Source: ABdhPJxEDnQ+Tly+aqkALKcBREuDaPyhDPJaGLOSEmmM4+wJSwoG5LeQ6N7eSwmj/RiW+kiS+IxEDg==
X-Received: by 2002:a17:902:e74d:b0:156:9d3c:4271 with SMTP id p13-20020a170902e74d00b001569d3c4271mr11427623plf.79.1649294545595;
        Wed, 06 Apr 2022 18:22:25 -0700 (PDT)
Received: from localhost.localdomain ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id s20-20020a17090aad9400b001ca8fcfd1e9sm6848166pjq.26.2022.04.06.18.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 18:22:25 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     kuba@kernel.org
Cc:     aelior@marvell.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, manishc@marvell.com,
        netdev@vger.kernel.org, pabeni@redhat.com, xiam0nd.tong@gmail.com
Subject: Re: [PATCH] qed: remove an unneed NULL check on list iterator
Date:   Thu,  7 Apr 2022 09:22:07 +0800
Message-Id: <20220407012207.14442-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220405182641.08cd18ff@kernel.org>
References: <20220405182641.08cd18ff@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Apr 2022 18:26:41 -0700, Jakub Kicinski wrote:
> On Tue,  5 Apr 2022 08:22:56 +0800 Xiaomeng Tong wrote:
> >  struct pci_dev *qed_validate_ndev(struct net_device *ndev)
> >  {
> > -	struct pci_dev *pdev = NULL;
> > +	struct pci_dev *pdev;
> >  	struct net_device *upper;
> 
> Please keep the longest-to-shortest ordering of variable declaration
> lines.

I have fix it in v2 patch [1], as you suggested. Please check it.
Thank you very much.

[1] https://lore.kernel.org/lkml/20220406015921.29267-1-xiam0nd.tong@gmail.com/
--
Xiaomeng Tong
