Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82A05442B0
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 06:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbiFIEkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 00:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbiFIEkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 00:40:22 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B45819A708
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 21:40:19 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id o10so29583568edi.1
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 21:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FGwLN6puZ2hD8UNyN4LTRFh855zcMnLstF1aT3B7ECg=;
        b=vckwlfQRJJgVJD2IArXfO8ivPnho4P23qQegmr2OKAnSRJamakuH15QFoEH5y7pl8c
         blM2Fz+NfuJjbvKPf3YJicVjEKs6XYI41DUM4AZgeS3Crl/NvLymV8vPXl3+3feBBdPi
         Dh0y7CoHm2DXxYSBVfPuDJzyW39BDxEZ/QuF4RLdurWL9JHlbx7L1xLb/bVnpI996DX6
         yO5r7IDiAbSEFtqx1gGfbH/pdBIO7Lx4Kmpu6yBbLPH2Xv3WD5I6wXQc3jwWOfFIHvmV
         QyLuvDk8LkAHIqxKHe6UXt7lUONKMkrvnhW8VbmWPjsnDA6dl9FSJ7xMAqrzP8NJ9BgI
         GnPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FGwLN6puZ2hD8UNyN4LTRFh855zcMnLstF1aT3B7ECg=;
        b=dZFqnBC4l7pHyUPUFCin7pgTWd8TYW65ZAaRasAEFibNtGUh7aBWhpy39C9kvjytoq
         BrMwa6PZb5INLuBZ68H+Su+lgeWkv3S4X9UmkdcV65SVXNPiPUcoW6GiGue/nC7P+5kS
         fkpuPXKx+rF1clN9tmq+CPP+y612yKthahr8pT35Nf0pWiuqARrJ3XKw/MTeWYaknwQA
         9jJ8Zpn8+lVGM2nO02AkHWfLLokG6qNV7jZlXmMaVaUVieZFcWLfpPSFdH+GkuSjBlw4
         fHsZjAvLeWajTqvHZCB/P0GDqAQTQRfiYB4STCDS7htVYYhbOu5gsdNwc4HcY8FICsGx
         Lbmg==
X-Gm-Message-State: AOAM532VIgQvyqnEgKAiUJsP65m2qJtafudYV82LuC7sA5fvf9Gi4PmL
        9frRJo1onrLwshoWGddxM9ogNg==
X-Google-Smtp-Source: ABdhPJwkl5Dwf+IBNyE9I/uIGnca3Y413YdqXpI0R0HFLSWuB7sCtSbudO+fNiixBToO1SPOJsk2Ag==
X-Received: by 2002:a50:9f88:0:b0:42d:f7d2:1b7b with SMTP id c8-20020a509f88000000b0042df7d21b7bmr43486428edf.139.1654749617527;
        Wed, 08 Jun 2022 21:40:17 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id t2-20020a056402524200b004333e3e3199sm465008edd.63.2022.06.08.21.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 21:40:17 -0700 (PDT)
Date:   Thu, 9 Jun 2022 06:40:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, dsahern@kernel.org,
        steffen.klassert@secunet.com, jreuter@yaina.de,
        razor@blackwall.org, kgraul@linux.ibm.com, ivecera@redhat.com,
        jmaloy@redhat.com, ying.xue@windriver.com, lucien.xin@gmail.com,
        arnd@arndb.de, yajun.deng@linux.dev, atenart@kernel.org,
        richardsonnick@google.com, hkallweit1@gmail.com,
        linux-hams@vger.kernel.org, dev@openvswitch.org,
        linux-s390@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net-next] net: rename reference+tracking helpers
Message-ID: <YqF5rzIiLCJgW5Gd@nanopsycho>
References: <20220608043955.919359-1-kuba@kernel.org>
 <YqBdY0NzK9XJG7HC@nanopsycho>
 <20220608075827.2af7a35f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608075827.2af7a35f@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jun 08, 2022 at 04:58:27PM CEST, kuba@kernel.org wrote:
>On Wed, 8 Jun 2022 10:27:15 +0200 Jiri Pirko wrote:
>> Wed, Jun 08, 2022 at 06:39:55AM CEST, kuba@kernel.org wrote:
>> >Netdev reference helpers have a dev_ prefix for historic
>> >reasons. Renaming the old helpers would be too much churn  
>> 
>> Hmm, I think it would be great to eventually rename the rest too in
>> order to maintain unique prefix for netdev things. Why do you think the
>> "churn" would be an issue?
>
>Felt like we're better of moving everyone to the new tracking helpers
>than doing just a pure rename. But I'm not opposed to a pure rename.
>
>> >diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
>> >index 817577e713d7..815738c0e067 100644
>> >--- a/drivers/net/macsec.c
>> >+++ b/drivers/net/macsec.c
>> >@@ -3462,7 +3462,7 @@ static int macsec_dev_init(struct net_device *dev)
>> > 		memcpy(dev->broadcast, real_dev->broadcast, dev->addr_len);
>> > 
>> > 	/* Get macsec's reference to real_dev */
>> >-	dev_hold_track(real_dev, &macsec->dev_tracker, GFP_KERNEL);
>> >+	netdev_hold(real_dev, &macsec->dev_tracker, GFP_KERNEL);  
>> 
>> So we later decide to rename dev_hold() to obey the netdev_*() naming
>> scheme, we would have collision.
>
>dev_hold() should not be used in new code, we should use tracking
>everywhere. Given that we can name the old helpers __netdev_hold().
>
>> Also, seems to me odd to have:
>> OLDPREFIX_x()
>> and
>> NEWPREFIX_x()
>> to be different functions.
>> 
>> For the sake of not making naming mess, could we rather have:
>> netdev_hold_track()
>> or
>> netdev_hold_tr() if the prior is too long
>> ?
>
>See above, one day non-track version should be removed.
>IMO to encourage use of the track-capable API we could keep their names
>short and call the legacy functions __netdev_hold() as I mentioned or
>maybe netdev_hold_notrack().

Okay, that makes sense.

