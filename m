Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B6D62DFD9
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbiKQP3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbiKQP3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:29:34 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C9DDFF7;
        Thu, 17 Nov 2022 07:29:34 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id r126-20020a1c4484000000b003cffd336e24so691747wma.4;
        Thu, 17 Nov 2022 07:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j+Xk0Di7n2OHXyOV4rdG8M2UQo7QuEdE8CWNeG/BFsU=;
        b=JnJ1hae3VS+zA/nEPAIJ+Qz4UjtYOtfBA8QGtEACYDjArXQAGbWCImJug2+lQKpvnU
         iOTWysufOXNQfOE6WzB7H7ZGO7XkEL4KqdpfWSunXq7lwqs/AY09gaWY9CODZEwTCw3u
         dlIlvps/CMuYezdKd4Jrtl1JebONUxGXDDKbNq+CU8awHU1YipnpZRTrC8alJdd1YRlD
         pcSyeBrv290r2+TvMvcEmPoDUhIWRG4CIT6L2+a54uJzHWk9v3fuDnv70E5N1Yfziiu3
         RiIJE86BXezernVHiv3lsB9mu9pFyZgwXZZZUtlVrvJaJWg0j6pbL/EogjLgUtp2Emmi
         ldUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j+Xk0Di7n2OHXyOV4rdG8M2UQo7QuEdE8CWNeG/BFsU=;
        b=e1QPvUGcXYZPYdeUKVz+W/7TDQLiXr7iUIQ5EjfQWWWDfNVubQXYUn/NmAIlXDx1Om
         5xkS8sGx9i04psZPhytKUJ0QFVCIwOJJ1Auq65V4TURz+0zF5e46Rl4DeuSEskAOPRrW
         zZHQ2exCrW3vER+8Lna0ZMghrXEM0wojiPTseqxX7+Lc6cT9005obGfkAKdPo6U4axJa
         sHAsXWwCMAAH5fA1p60Gy8BCAVSWXyMuB4+y2djQemk3KA4BP69i0bT8FOcxJX7F8Fz5
         vylgorXf7h6tWXEzglc3cFtSI2ZTDvGWlkrHPh4QA1frMWqh8jdShAO2NrURX9X1CMnG
         NhWw==
X-Gm-Message-State: ANoB5pk8dM8erpnc7PDg2sIApaBCIMEzth32qDBBb6TRYsZ/dji5NsKL
        qgT6CCYgIrPouqyOC9HEp3o=
X-Google-Smtp-Source: AA0mqf6f1gP2EX7y93dxK1/NWFzyicAFZEkY3gRbB4blxyDMwZ4AlPc3dmyOiDpZLtnWIio70Zga+w==
X-Received: by 2002:a1c:cc07:0:b0:3cf:5b8a:a7cd with SMTP id h7-20020a1ccc07000000b003cf5b8aa7cdmr5666437wmb.136.1668698972547;
        Thu, 17 Nov 2022 07:29:32 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id b8-20020adff908000000b0022ca921dc67sm1208962wrr.88.2022.11.17.07.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 07:29:32 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:29:28 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Machon <daniel.machon@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: microchip: sparx5: prevent uninitialized
 variable
Message-ID: <Y3ZTWIas5BSxwyg8@kadam>
References: <Y3OQrGoFqvX2GkbJ@kili>
 <519cbacf20b10909ee362e0bcc9aa87cbb7137f3.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <519cbacf20b10909ee362e0bcc9aa87cbb7137f3.camel@redhat.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 04:03:07PM +0100, Paolo Abeni wrote:
> Hello,
> 
> On Tue, 2022-11-15 at 16:14 +0300, Dan Carpenter wrote:
> > Smatch complains that:
> > 
> >     drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c:112
> >     sparx5_dcb_apptrust_validate() error: uninitialized symbol 'match'.
> > 
> > This would only happen if the:
> > 
> > 	if (sparx5_dcb_apptrust_policies[i].nselectors != nselectors)
> > 
> > condition is always true (they are not equal).  The "nselectors"
> > variable comes from dcbnl_ieee_set() and it is a number between 0-256.
> > This seems like a probably a real bug.
> > 
> > Fixes: 23f8382cd95d ("net: microchip: sparx5: add support for apptrust")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> checkpatch complains about the From/SoB mismatch - 
> 'Dan Carpenter <error27@gmail.com>' vs 'Dan Carpenter
> <dan.carpenter@oracle.com>'
> 
> Could you please send a v2 addressing that?

Oops.  Sorry.  Resent.

regards,
dan carpenter

