Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E471F6B22C9
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 12:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbjCILYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 06:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbjCILY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 06:24:27 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93256E9F0E
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 03:20:46 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id u9so5573449edd.2
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 03:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678360843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=izJKh1chlJfOLCp9j7kE3DtVQUEzxS301qJOV97jESk=;
        b=mfXIPyOv70PRWiEcV58/WMaRg37PYYKmOIxjEYN2lRbRJpXyGlyWlFK1ACHetTzJFa
         xCSS4R2O+fYyJlZQ9wgcgZHm2HhJVahqEjkMI016uP676mL3wkP1fdGT4XeAZ+Zz1bvd
         osALxVxsvzAF9/lVJdJB2vyDoYPiQZEOs1+Bbjqpdv9sZJ+2bJLulZ//vR0CAc+Emp2+
         E9WTwj+lFBkQ+0YIdmoEMoViaODrFohx2ZFDQojSKPtf4+H8piG2nbkDDOQ3P2VOxiaB
         0V9f3nsCGvGy3n0SBIemlxPltvaR8Jhof1Mo2QCJPMKyJlxOK01FsoktEx/bRrpwCw9j
         ky7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678360843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=izJKh1chlJfOLCp9j7kE3DtVQUEzxS301qJOV97jESk=;
        b=Y5i1eqDqHyWhD9ko2zktiVfPtgozXVC7+z3wJap6J8HcTmpvhq5nYMqd81rNRNZEAE
         AiqjGTb+spI4cF4M+nB1y/J1N92SMlVgYCTzaYj/zxnheycxyOcY+vMHLNtN9gRLoleQ
         NDfdN0sNlKgm0YnGWgGK2uErCZLG7R7fGGp1p7jaSWnRAh51C4T/CMSJE2VwEAuyGk4J
         NKB7aLMplgyJ+9KpVl6lfQFPk33kojEcBeJA1KK+U5oJ+zE/Zz+H99zrLXg0+N/q4cdw
         MoyxOHjx71smxRpTLxNkxGS1PDu4ojh9/qXGJ4g0kS7L4h0pkXOnIYGnSIu03BuQQNCO
         P66A==
X-Gm-Message-State: AO0yUKWLNaHtsD14vQOlWtAPIXpaFSSy839U56YvBQrJdkhSeaNNANVv
        siU2UFffuWx7wYgt8DnsrW0JqA==
X-Google-Smtp-Source: AK7set8tjjogZVi126Sp1qDlmUvqfCwwjFraJmMPmH6+IRriMFCahlC7dTlkfFjxtjc2yC4P0IKHkQ==
X-Received: by 2002:aa7:d646:0:b0:4af:601e:6039 with SMTP id v6-20020aa7d646000000b004af601e6039mr18851128edr.22.1678360843343;
        Thu, 09 Mar 2023 03:20:43 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id lc9-20020a170906f90900b008e34bcd7940sm8640657ejb.132.2023.03.09.03.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 03:20:42 -0800 (PST)
Date:   Thu, 9 Mar 2023 12:20:41 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Eizan Miyamoto <eizan@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 net 2/2] net: asix: init mdiobus from one function
Message-ID: <ZAnBCQsv7tTBIUP1@nanopsycho>
References: <20230308202159.2419227-1-grundler@chromium.org>
 <20230308202159.2419227-2-grundler@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308202159.2419227-2-grundler@chromium.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Mar 08, 2023 at 09:21:59PM CET, grundler@chromium.org wrote:
>Make asix driver consistent with other drivers (e.g. tg3 and r8169) which
>use mdiobus calls: setup and tear down be handled in one function each.
>
>Signed-off-by: Grant Grundler <grundler@chromium.org>

This is not fixing a bug. You should send it separatelly to net-next.
