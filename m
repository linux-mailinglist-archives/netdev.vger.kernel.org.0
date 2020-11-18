Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9F12B8827
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgKRXHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbgKRXHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 18:07:47 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14513C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 15:08:04 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id s25so5149004ejy.6
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 15:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fhqzU+ZSFf/gvr9JqXlN4rW008kXBPcVMbUDffy6FxA=;
        b=CSPjjI89sTyJUG7MvxNoDWLg8BtyEdtj681xgqw++mB5YxCpThKfoJ+EdqKbtkgn+7
         oEAZcTCDR+SXZ/yRcstfrYdKmjkGfCS2EC0mjKz6QXBZcWZJFdQAl0tOM8+Yn8XJNKWj
         7SdzblTdtrFzkYaGqzGsk/pIqz0aJJJQSVUGpuAu/c2FDEdjcP4i1N74pqYzJR6S98pV
         g7zO2gReLNgWnEN7hyl3icPTOWzRz3j9sI1Rf2VjQloRdwvNOi+cmC2UKhtRiNou2v6x
         1NLZ3tp4BJ1J42WCJe1w7rEJyyYD239GT5KmvZ9VUhoxBTNNPV04GZXCfEptWX4iT0jy
         CwVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fhqzU+ZSFf/gvr9JqXlN4rW008kXBPcVMbUDffy6FxA=;
        b=ECRSIbHPZ483n3ixFAl9DwaA1FYtyOk+mMWeaFu7z74Sep2B+RMyipkhoQj4xORVac
         efA7ziCyxrBzu5ZHb+6iXInn/SIU8MMjWFOtlC19f3BU38kktNgWmJ+UtirmZFo2+3KZ
         QODVdWqbqNH8bFsxpe21eZ2q+EEOMSZiVHruIvLzETQ8JqIa03tmafNXZec3uu3ooIQ9
         7jnh2/e+xEyxjZRyD9oY5wL+wxA5qcdDlvzrqWl8JqmK3idfTuF9V53vc2mhh1D6S5kl
         4+vr1QEifIHT/Gs61DfX3XFLuu9YPhK9OfMSKkz3su/sXbW7HGbk2YJta6dR01GJUW/F
         8f1A==
X-Gm-Message-State: AOAM531wtOvvWnEF83yuhTsl9YZaFeCDgPM0Ic9tl33NYgEEa6lo6zWP
        ICQXGl3/UxDvaGxjn83J+EA=
X-Google-Smtp-Source: ABdhPJzl41A90+bGz/JoPAgJ2Dv6ZlgjtUAOSAuhE6BdO23af/T4on8UTLCOHzmHYZGw5lqnnmjrNw==
X-Received: by 2002:a17:906:314f:: with SMTP id e15mr25994899eje.496.1605740882818;
        Wed, 18 Nov 2020 15:08:02 -0800 (PST)
Received: from ?IPv6:2a0f:6480:3:1:d65d:64ff:fed0:4a9d? ([2a0f:6480:3:1:d65d:64ff:fed0:4a9d])
        by smtp.gmail.com with ESMTPSA id z2sm14154223edr.47.2020.11.18.15.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 15:08:02 -0800 (PST)
Subject: Re: [PATCH v3] IPv6: RTM_GETROUTE: Add RTA_ENCAP to result
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
References: <20201118151436.GA420026@tws>
 <75cc0e7b-1922-850f-da22-550c8c90aac6@gmail.com>
From:   Oliver Herms <oliver.peter.herms@gmail.com>
Message-ID: <f228cae5-3952-1562-e92a-59e65009d524@gmail.com>
Date:   Thu, 19 Nov 2020 00:08:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <75cc0e7b-1922-850f-da22-550c8c90aac6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.11.20 21:19, David Ahern wrote:
> 
> You forgot to remove the dst part of that. rt6 == dst so to be in this
> branch dst != NULL.
Damn. I've indeed overseen that one.
Just submitted version 4.

Thanks for guiding me through this!

