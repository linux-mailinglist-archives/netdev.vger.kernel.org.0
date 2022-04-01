Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E614EFBF9
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 23:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352719AbiDAVEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 17:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239280AbiDAVEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 17:04:32 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1671F6F0E
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 14:02:42 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r13so5878222wrr.9
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 14:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst.fr; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IvvIRhxPNhYjxrV5a54hMUKh53vUVJBFc2U8my9TRkk=;
        b=tQeCLlwiSMktgDt2zmA7tb9txxwrv9v7Q8hkIcGnk2tk2hOOTL4rRL+zZz5PXeg8//
         xDONWEmrrh12AUEJalzPYKx58bG1u+gvaOltMFgDsZZye9CRYaExAMQg8LMaOKRJEcyT
         T1EkPayhJ4kzmb6zi8Uw84MNwG6DLI+an2T0OMZ4y5j9n9nS9o3JBAI6xBEXecFq5ZIa
         swevJXuTQxqmptbVHhHPPdRigV0Ianou0FNAQEOQQ6Q02VB5K5CwWQcxjtf930z8Zgt4
         tuBacF/xh8GravQBrF1e9Rr7u8X4VZ8gRxLncO7NhP5qq3A4NMVcs5cYCgDJ2HJ3wXyV
         GFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IvvIRhxPNhYjxrV5a54hMUKh53vUVJBFc2U8my9TRkk=;
        b=OWMexyEXdLEbboVW7ZCWv/efxUgxvnSW7byGPz4W9RSgGquXj9Q67MNBw9aJNSKV84
         /BP12pqE3LwMeHSWxZZ05yePIppGzSXK+xQjLFaDfk3NfOa2DY1WW6Rfi/Tehd9S+QOR
         Emt8g0JoMDLV0x9feqa/2XpdiJQQoQQuNIr3iUHNSRh4/6ZPi4pOvx2Qz5pSYsyz/bt6
         I7/vq5hR9E7zZt82kJJu+DKr3zdjxC3mtD+c0VdsqiYy7oPoc9YPSeO4ZaIiQI09Db2a
         3c3/uUf4yOstnahX+xy0dQiPNxNfVNpVhN1LwUOh0zsJEO4ocm3XAS31rGxLOpKa2N2J
         hdTA==
X-Gm-Message-State: AOAM532V2VHuBp5HZ2+9Bn2FyHD8s4dAzkqfOaIec/m881bnxdJmwWDW
        e6iGtMeeNrDPUx/Y2MfiEhv+vg==
X-Google-Smtp-Source: ABdhPJz7MVKjuRpnBF7Hx1uRTvl0zpTB1LTpWWHXzpYd5NOARMneIZux/5WKV1jgGAkBDVDJdnTMyg==
X-Received: by 2002:a5d:6101:0:b0:204:871e:9912 with SMTP id v1-20020a5d6101000000b00204871e9912mr8963830wrt.60.1648846960769;
        Fri, 01 Apr 2022 14:02:40 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:993:6ec0:600b:7e72:20dd:d263? ([2a01:e0a:993:6ec0:600b:7e72:20dd:d263])
        by smtp.gmail.com with ESMTPSA id l20-20020a05600c1d1400b0038cba2f88c0sm14773352wms.26.2022.04.01.14.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 14:02:40 -0700 (PDT)
Message-ID: <1250f3a0-9ed3-cfad-ba93-6b16cad5dcf5@wifirst.fr>
Date:   Fri, 1 Apr 2022 23:02:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2] rtnetlink: enable alt_ifname for setlink/newlink
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com, Jiri Pirko <jiri@mellanox.com>,
        Brian Baboch <brian.baboch@wifirst.fr>
References: <20220401153939.19620-1-florent.fourcot@wifirst.fr>
 <20220401104342.5df7349a@kernel.org>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
In-Reply-To: <20220401104342.5df7349a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> 
> This part depends on your other change, right? Do you care about this
> getting into stable? Otherwise we can downgrade it from a fix to -next
> and merge after your other patch. It never worked so we can go either
> way on it being a fix. Actually leaning slightly towards it _not_ being
> a fix.
> 

I don't really care about getting this into stable, so I will resubmit 
for net-next when opened.
Should I drop "Fixes" tag? Alternatives ifname feature never worked for 
setlink/newlink, but 76c9ac0ee878 claimed it was.


> 
> Formatting slightly off here, should be
> 
> 	} else {
> 

Thanks


> 
> How about we pass tb and extract IFLA_IFNAME and IFLA_ALT_IFNAME inside
> rtnl_dev_get()? All callers seem to pass the same args now.
> 

You are right, it's a good idea for the v3

Best regards,

-- 
Florent Fourcot

