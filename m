Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87FF465EE62
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 15:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbjAEOJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 09:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbjAEOJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 09:09:28 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1932F7AF
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 06:09:26 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 141so6250202pgc.0
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 06:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wv/1ROf5cSrE4etzGJnivLM/9LV4+ygjSdn9zcWL5jQ=;
        b=F09Ao6g+F78kfQhfq55+y0MnCQvp23n+R1EA14g8mQn1PeY9Pl3nCB6ighGTaBhfni
         SGss9jdW018YtAZ8/rFaNV6eY3RGrukiPouEFl4WwObBrkxCzAbo2Z6XF+N+VZJuBhKG
         IkmxoNwBBLSHe4yj6PuLXnRBtLzKljLoEHAwR6EMyW4+WZAiYC6NTZb7o4MB7Guz+3I2
         L2BB1zqMSc74+LN9W0spGbxOO86XTTp+I/TfFmIYf6/8W3Tuz115R2LdL1cKGCTSm9+j
         Hkzyc9r77kB3YQGy4otND+WsnsEcYZW6WIilvhY0DsYzaoeI5S2DAb6hqi/6JTHTx1A+
         iS5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wv/1ROf5cSrE4etzGJnivLM/9LV4+ygjSdn9zcWL5jQ=;
        b=LAHEQ/rPhsES7gpbi//CsEhowHAXAjjHg7X+9VWjVEAMu7B3fN5GGE7HWSb1kjo2Kf
         jt2Rm0TevJYqDkKdzefRgUI9q4hSAKoou56/46/Z/+DvvwbnT+2cPZIrlX+oCakBIPqF
         HZvgvFiEedL7XqH/LtfKb9a7rBgrAl7l/vO7AFIiZLneY0TLApVA8C/wZ8RspWocM985
         MCX6a1dnVUNeeCwpHvWMfEE22Zl3FuURLtPuYf3IJ1BJIyEealrdaMvoF/s7qoydmAWB
         ruCGhJ/YI3qmO63TMwsD3K4Ba7tF8mhReijjV8Lcxy27/grq1z+xBnXWOKek2iuOidgM
         VCKA==
X-Gm-Message-State: AFqh2kq9DN3wKriBezrPdapIOuMbsnctUyMOBKzalW6vJo98FtYCkZIt
        q8OfOATDUaUbDzEXejl0z2xFSNLSz+vhgsi+PpH1AVIy
X-Google-Smtp-Source: AMrXdXt44eZzwDUbweK5bwtXX/tYZo3oP/1fuvfvH8E9dN7ppDoFy1IhqIdGTL0WMSDPHTv1v8KeRA==
X-Received: by 2002:a62:6145:0:b0:581:7cb0:1eb8 with SMTP id v66-20020a626145000000b005817cb01eb8mr30936406pfb.17.1672927766129;
        Thu, 05 Jan 2023 06:09:26 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id h1-20020a628301000000b0056be4dbd4besm9907881pfe.111.2023.01.05.06.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 06:09:25 -0800 (PST)
Date:   Thu, 5 Jan 2023 15:09:22 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Hui Wang <hui.wang@canonical.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        davem@davemloft.net, oliver@neukum.org, kuba@kernel.org
Subject: Re: [PATCH] net: usb: cdc_ether: add support for Thales Cinterion
 PLS62-W modem
Message-ID: <Y7baEkGZg5iHXNDd@nanopsycho>
References: <20230105034249.10433-1-hui.wang@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105034249.10433-1-hui.wang@canonical.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 04:42:49AM CET, hui.wang@canonical.com wrote:
>This modem has 7 interfaces, 5 of them are serial interfaces and are
>driven by cdc_acm, while 2 of them are wwan interfaces and are driven
>by cdc_ether:
>If 0: Abstract (modem)
>If 1: Abstract (modem)
>If 2: Abstract (modem)
>If 3: Abstract (modem)
>If 4: Abstract (modem)
>If 5: Ethernet Networking
>If 6: Ethernet Networking
>
>Without this change, the 2 network interfaces will be named to usb0
>and usb1, our QA think the names are confusing and filed a bug on it.
>
>After applying this change, the name will be wwan0 and wwan1, and
>they could work well with modem manager.
>
>Signed-off-by: Hui Wang <hui.wang@canonical.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

