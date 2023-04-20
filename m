Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236966E8C08
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbjDTIDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234276AbjDTIDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:03:23 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D6930F4;
        Thu, 20 Apr 2023 01:03:16 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f18335a870so2889825e9.0;
        Thu, 20 Apr 2023 01:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681977795; x=1684569795;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AAPM6wHW6wrMQGuZrkQafpDkz/TIHrKci31TWrxXAhY=;
        b=AA0LDbkPDa0l0JeljO+mKYGTIIB+FMIxJdXJIGjxS3vJfntcx620apG8c31g9kgaBi
         D01S9nFn3tSSqiWimGhH5m6RbCQvaE3fCYRwctHu1ZaR7t3rhGOEaKgMaRbJfv6Z9w9p
         m+43zsbef3ro93pNnFhwhdomdTcTpqDFDr8K8E8nYpnYMYlLOYwQzpA/iTOOC9GrjwFz
         TailWTixRvg2Uh6eUKTR4qyrOAtWfqeQbpQ+KqOlN5xIjN8USK2MVdPRHNqRuMcYPEYI
         7vLDSJjvjPnZqDwmFQ6AAMk5edjWeKbwV6uQCzl69iR3RCHkPJwiVgzWt7FcPC3yuAsp
         de7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681977795; x=1684569795;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AAPM6wHW6wrMQGuZrkQafpDkz/TIHrKci31TWrxXAhY=;
        b=RCluBWUM4h0MqjPqJyotpbE5Igb9gCVS8yQSYTS1nvgpojm1iQ8ezn1uWs5afmome9
         Hkbpd3J5HdwB5AftaiOvC1kvKASNh+HNkXlhlXkJnV8iPBIEndYdTZXFUS6zuUu4xnOy
         Z3rCo/dihWpZZyBxObs1zImcuS7EClzm7i+t7AfKBjiY0VF6P/2TI/2ty5/S9Kd6Hwqg
         fpf9pKFZNMmw2emfbZ+pQplfEFC4xaXgtiUz12KtOk18/lpnCwGYnXbyq3To6AL5HyX2
         zK5aZuTOR1/RQy1Aykg6y42T/H5Qm1KxBPIQFDXw9p0QaZ57rUKZF6GIpLlqsb3TI8R7
         LQ2g==
X-Gm-Message-State: AAQBX9d78NIIsFIOAYOSNh2VhLW8XAn2z3h+rt/tHZ48WhVPQirY/okC
        WwBVHO+tDcVzRN1bc0s9UbY=
X-Google-Smtp-Source: AKy350ZzE8Ttwf893BSTCEUWg/tRe75hZBnBs8xti+RJSH4ibvFN78htjh6yJARuxKJtPDM/R/vCXw==
X-Received: by 2002:adf:df8f:0:b0:2c5:3cd2:b8e with SMTP id z15-20020adfdf8f000000b002c53cd20b8emr601641wrl.1.1681977794674;
        Thu, 20 Apr 2023 01:03:14 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe947000000b003011baf89b3sm1261985wrn.40.2023.04.20.01.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 01:03:14 -0700 (PDT)
Date:   Thu, 20 Apr 2023 11:03:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com, 'Jose Abreu' <Jose.Abreu@synopsys.com>
Subject: Re: [PATCH net-next v3 6/8] net: pcs: Add 10GBASE-R mode for
 Synopsys Designware XPCS
Message-ID: <20230420080312.6ai6yrm6gikljeto@skbuf>
References: <20230419082739.295180-1-jiawenwu@trustnetic.com>
 <20230419082739.295180-1-jiawenwu@trustnetic.com>
 <20230419082739.295180-7-jiawenwu@trustnetic.com>
 <20230419082739.295180-7-jiawenwu@trustnetic.com>
 <20230419131938.3k4kuqucvuuhxcrc@skbuf>
 <037501d9732b$518048d0$f480da70$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <037501d9732b$518048d0$f480da70$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 09:56:26AM +0800, Jiawen Wu wrote:
> On Wednesday, April 19, 2023 9:20 PM, Vladimir Oltean wrote:
> > On Wed, Apr 19, 2023 at 04:27:37PM +0800, Jiawen Wu wrote:
> > > Add basic support for XPCS using 10GBASE-R interface. This mode will
> > > be extended to use interrupt, so set pcs.poll false. And avoid soft
> > > reset so that the device using this mode is in the default configuration.
> > 
> > I'm not clear why the xpcs_soft_reset() call is avoided. Isn't the
> > out-of-reset configuration the "default" one?
> 
> Theoretically so, I need to configure 10GBASE-R mode after reset. But this
> configuration involves board info to configure PMA, etc., I'd like to implement
> it in the next patch. Now the "default" configuration refers to the mode in
> which the firmware is configured.

How much extra complexity are we talking about, to not depend on the
configuration done by the bootloader?
