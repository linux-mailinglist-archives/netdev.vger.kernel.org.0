Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12BE3E979E
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhHKS3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhHKS3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 14:29:01 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A49C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 11:28:37 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id r17-20020a0568302371b0290504f3f418fbso4403202oth.12
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 11:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UTnDnEFzbHdsylY3V2WWZ1+POdKahK+hzSDlICSpspM=;
        b=T8ZTCEA7dCsgxJxE+r3bN0OQAonMsd+VW7S3rZnrL6tTcCO8W9u4YF2Beik7aBGxnu
         KjADm7smwxRYQy7utApM1GL/1oRX+tOgTlXrxfXHeG7Wf+NUSLSCvQAItmyo50EsnYSC
         01t8G5pmxxbADl+7mAAPZG0UcV5sD1CWZ30BaulQBZmPpuJrxoJYcfT7iED7XS+Z+SEy
         8fNJ8NuRxD6xB3CSU4Us+t6fa7uBLdNZ7FsOrjCAfBhknDOZhpvRwOv4ICVjT+6ZNiDQ
         1S16B5feRFDtEIR/NjzcMamYu82bPQY7CmOyi3xpCxj5NF3/RAN1jeMubdeM5aLQq+CE
         /PXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UTnDnEFzbHdsylY3V2WWZ1+POdKahK+hzSDlICSpspM=;
        b=B7ARDMWnv7T8GpzjJIifq035OpFNou7xshBk0byqpesFex8qWLYH1oxaczhKsG3lWB
         E4EVZLUBl8hWI5fUH7Xe+qgB5NrMMfJS/d8sLlLQWy/0vdiUkQco7cZ1waIkN+mE70gb
         +CeOMmO/sT3jnS/m0478+9/5/z50Hk53sUTy+gvoMLDxdLICzY4uVqjPoeY5/8sJaH+d
         7L1cPfu09qpNs7OU0WsRDmK+0XNYItQx/cfEHsYXdOQGFlloIffx8LyBTVdMKJZWZRVP
         I4lhjjXzIevYmbsszkfTgCv5jAjTOfZycxnW9QKDf77a8HWXOx1t4FyvuIiN7CeUeN+O
         mM8A==
X-Gm-Message-State: AOAM5314nG5tisxZk8BIMUDZJmhWPwuE3OxKXW2hVVMmuul+ux5JTjta
        nEoILf/DpIEu9+0MgXPsIM8=
X-Google-Smtp-Source: ABdhPJxln6+pIy3pPe3B5S07ujq0MiZEM5M55FvpauK0uQuIX/z3jAy/R5asNItnl2p4BFtlCUnAQw==
X-Received: by 2002:a9d:37c9:: with SMTP id x67mr273457otb.2.1628706516618;
        Wed, 11 Aug 2021 11:28:36 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id r15sm58678oth.7.2021.08.11.11.28.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 11:28:36 -0700 (PDT)
Subject: Re: [PATCHv2 iproute2-next] ip/bond: add lacp active support
To:     Hangbin Liu <haliu@redhat.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <liuhangbin@gmail.com>
References: <20210809030153.10851-1-haliu@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b933d5df-71d9-4d99-7737-d3a682ec3403@gmail.com>
Date:   Wed, 11 Aug 2021 12:28:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809030153.10851-1-haliu@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/21 9:01 PM, Hangbin Liu wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> 
> lacp_active specifies whether to send LACPDU frames periodically.
> If set on, the LACPDU frames are sent along with the configured lacp_rate
> setting. If set off, the LACPDU frames acts as "speak when spoken to".
> 
> v2: use strcmp instead of match for new options.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/uapi/linux/if_link.h |  1 +
>  ip/iplink_bond.c             | 26 +++++++++++++++++++++++++-
>  2 files changed, 26 insertions(+), 1 deletion(-)
> 

applied to iproute2-next

