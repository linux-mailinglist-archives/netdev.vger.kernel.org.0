Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F845A22C3
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343602AbiHZIRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343619AbiHZIQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:16:57 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B229FD4F41
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:16:53 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id h22so1746855ejk.4
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=1Q7Hr/kBK3RHNgS66LzQ64HakiLtuRzalJMXe3n+bnc=;
        b=V9Md/VEjophn/X7BXuWEfHQuUF+k7RyShZ9ttyDpk3Zi4td6JqkTwEOILZzIe+Chzb
         832Gyy6j4wIYqPz1KY0XQ1H2e+vMn5q6EyQfWNPA9SsnWZGYox6n/x89Ac2TR4Opxek7
         JFnq9CNQ0vN5Xl1OSwsDGdGj4/E8MdGzv0OOVlE2kg0BKXATk3dX8rqZCNNPLfBPHRgC
         Pgh4YjOrQt9VqSl1LNlrI5u05I5g3sAPdUN4t4xL89i1mT+JS8zCKR+vVVjFU5Yjap+Y
         c//ndr4UVV+0kw9VI4Ae5CbXNUET5PrCLG5WgO1Ii/YUeLGJIFvxOIp3KMSOPsHkqW00
         m3mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=1Q7Hr/kBK3RHNgS66LzQ64HakiLtuRzalJMXe3n+bnc=;
        b=ix0hQMnQLTP09j7eFx1CaJuRuPwWxaosVEWo6EtFjrmismV1klgAYuQTnIuMNIE+75
         dauMEHquvetxSC4ML+OkCJ482iZDF7DwXSQSZcPOFoQ5sc7j5tq4k9Rq129T97kjlsJ+
         mxWdrKOQpIXYZtr5p/bv5XBu4cR8L8kZAfrQCUQ6svUiJ9wzw+TJA+vAOT2IOnKwTij3
         hfMZQvfzw+X9IrfFvlpQ4gTU6Cq+u4AB14DRAT3hwFyerlFNqlzBgBDcQHdfSLnxoaY4
         ymsvIiM6TD8zXdhZEGclS4KOIaF0nZhJXUNVWU9HV54Ew24K/tvgIRiViWVkkZjXS4HW
         ajjg==
X-Gm-Message-State: ACgBeo1XnI8SF1zQdWg7rU394dGgC7EMUjlg6U7qCANLn/e5WH+RbZcC
        jXNcE5Saty9N11pqTHycwg9YsNbl+DUEY9JN
X-Google-Smtp-Source: AA6agR50dBbkdVxUKbh8jZI9K1E5pjAEb1Nb7Ofu3PrcPbjUt3ZKI4OMCXO4KbaoKzaMVnVBUX3l9A==
X-Received: by 2002:a17:907:7f8b:b0:73d:6f4f:30f7 with SMTP id qk11-20020a1709077f8b00b0073d6f4f30f7mr4769086ejc.323.1661501812244;
        Fri, 26 Aug 2022 01:16:52 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id cq15-20020a056402220f00b00447f74138d7sm337463edb.8.2022.08.26.01.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 01:16:50 -0700 (PDT)
Date:   Fri, 26 Aug 2022 10:16:49 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [patch net-next] net: devlink: stub port params cmds for they
 are unused internally
Message-ID: <YwiBcYvUejIJ99ne@nanopsycho>
References: <20220825082628.1285458-1-jiri@resnulli.us>
 <20220825181137.4a83b6e2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825181137.4a83b6e2@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 26, 2022 at 03:11:37AM CEST, kuba@kernel.org wrote:
>On Thu, 25 Aug 2022 10:26:28 +0200 Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Follow-up the removal of unused internal api of port params made by
>> commit 42ded61aa75e ("devlink: Delete not used port parameters APIs")
>> and stub the commands and add extack message to tell the user what is
>> going on.
>> 
>> If later on port params are needed, could be easily re-introduced,
>> but until then it is a dead code.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>
>Why no extack on the dump, tho? Wouldn't iproute2 do dumps mostly?

Okay, will add that.

>
>With that answered/addressed:
>
>Reviewed-by: Jakub Kicinski <kuba@kernel.org>
