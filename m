Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212DD646BDF
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiLHJ1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiLHJ1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:27:49 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E21183BC
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 01:27:47 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id kw15so2426110ejc.10
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 01:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S7L33auxegiEIKrrvWMx/+gEeNtiB6ZnhCMqPB7h5vQ=;
        b=PZAxcULAIONiAFESfqWrL5SExs/29cA9RVxSg/M6P+dCd75O3tGzJHFZd8yrTFa4dn
         7Y0B5aAf+GwwcWgyrXFMeVdK5lu9WsLD4Kehqc3+92TigH1KdPNJ5tpAmI5P1Gt4q+hz
         7OLTaqAeG1iS0dnXr6aF1kMSQtQCZdOL4TOlliLFIDJkcIGzmVgsjjPH9t2nHJF7OsbN
         8ZawBoeH6nU9MI0Q0HFl2x9NzvndVFM1N2QcizbQuxBNKmQ0rsfTtFWiDrtgvTdxOMjA
         j/NuTBVUCJPj/8unXszZrzPpg2QB3N66bHEZwEOG+Yk4WtPyBf6V1/8TyODIj3yK4Fl6
         eHiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S7L33auxegiEIKrrvWMx/+gEeNtiB6ZnhCMqPB7h5vQ=;
        b=E8cGkc0DGuxx974PvFj0e6fPn12KUvb3Ma/GHpl3PNYR+754bcMa7ntZImSf0fKEfb
         qCLPTUtTY5oyoah3PJ/yTjYYQ2EoN2/sUsN9tbBrZ07fXQIvP38wwRqmTfJ+QFt49G+Y
         Crc53yHyICfXYSD0lTIaNQWz8nmKJhPBG32/Forb+/3t18kUEG2f+zf9YN5W6YaNVWKC
         2KlDR0XvCsD8pYmWv3PzjgEcDmNMtsIFkIvxeChOPcTBitKJli4fvJkA/gRMrq0ZnaYc
         +5ckeb/EYKERCPhAPw1UWNvxoxi++lOBu/8C/CVMGcdmdtBTSGHY0WvCfDYFX+w6RWaV
         70mA==
X-Gm-Message-State: ANoB5pkve6lQz4jx3I/v3AJ2cdsJuAWv+fVNP+85gWZv16YYQBZma0fv
        OfuQnTqmljtnk3dVDy5A8Y4=
X-Google-Smtp-Source: AA0mqf4YyTMVYoPgwIw2AErQCk3ydoNjoyV4aohmGdYlEqHto1+4/a86hWnAIS+OCcD44qLdSXLlTg==
X-Received: by 2002:a17:906:4a44:b0:7c1:49c:f9cd with SMTP id a4-20020a1709064a4400b007c1049cf9cdmr1343529ejv.54.1670491665778;
        Thu, 08 Dec 2022 01:27:45 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id q12-20020aa7cc0c000000b0046bada4b121sm3143636edt.54.2022.12.08.01.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 01:27:43 -0800 (PST)
Date:   Thu, 8 Dec 2022 10:27:56 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, Voon Weifeng <weifeng.voon@intel.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Antonio Borneo <antonio.borneo@st.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: Re: [PATCH net] stmmac: fix potential division by 0
Message-ID: <Y5GuHEn161H35/xZ@gvm01>
References: <Y4f3NGAZ2rqHkjWV@gvm01>
 <Y4gFt9GBRyv3kl2Y@lunn.ch>
 <Y4iA6mwSaZw+PKHZ@gvm01>
 <Y4i/Aeqh94ZP/mA0@lunn.ch>
 <20221206182823.08e5f917@kernel.org>
 <Y5CZp0QJVejOpWSY@lunn.ch>
 <87v8mne09m.fsf@kurt>
 <Y5EvKciMg3Nkj8ln@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5EvKciMg3Nkj8ln@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > 
> > Here's the Altera manual:
> > 
> >  https://www.intel.com/content/www/us/en/docs/programmable/683126/21-2/functional-description-of-the-emac.html
> > 
> > Table 183 shows the minimum PTP frequencies and also states "Therefore,
> > a higher PTP clock frequency gives better system performance.".
> > 
> > So, I'd say using a clock of 2.5MHz seems possible, but will result in
> > suboptimal precision.
> 
> Thanks for the info. So i seems like the correct fix is to camp to
> 0xff, rather than mask with 0xff.
Andrew, given your comment, do you wish me to re-post the patch with
this fix? Or wait for more feedback first?

Thanks,
Piergiorgio
