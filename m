Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BBF46B1AC
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 04:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbhLGD7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 22:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhLGD7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 22:59:32 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFAEC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 19:56:02 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id b1-20020a4a8101000000b002c659ab1342so5034835oog.1
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 19:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=H2qTzaDJqCJds02VK6fp4CbGFcMMWrGbLHPCul3LCew=;
        b=MpN7L6jhoc9E3zY4rGdcgZ3+36+xTjnR1BQwu2xk4v/mdDV8z47F9SL8Vb78kmnxiC
         YM9LRwRxgzudWysopttavPhT4ldgvyUp9HJHPN7vJfnaFkIEI1kFt8ANNr2uuA7BJ/br
         7/yoPl/OCvTy1zYLpCXK2DnJSB8UQpHYNNM3cXwDGnqUzE9T4s4+V345cSj1HZav75li
         Jx7Sn8i2XgAUYjFMALjnPYUnkYUMI/Ozn5H+MQ+fjqyT8rQbDMJcw4RWJeZDDGOA4nQh
         zTZ2ZmjMUhjuBKo5J5GqArKg7UNC4jNdTHXEBAWcWokrxTQc0TaoV/9rL1w9isy4jpga
         wLiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H2qTzaDJqCJds02VK6fp4CbGFcMMWrGbLHPCul3LCew=;
        b=qbwlWqFGeUsudocincaZb/nsGWJQw9/bl3ShvONEuTrTeeH1RTL3yJE5j94k/zfbw6
         r7mP1MXVXsnrs6cY080xoMIfF8KMJsLp/l7cWU7VxdwevCHXk797FRuPdiVXgsni5MQH
         hO/VDf8Deso8S3M4mYolT97otduU5mnVxO8Cp38JpIAAKhU6laJeIJ8PBGbirG9Cgocn
         l+B3XxFRhl1tdcIaHczKUzvl45k8qaj68lUWs+2/63BfbLxP9dIoSc5Re150qwgcHbPu
         /8KpuWi75QEOJjEHdB4IRVAsgkDibugeOyRoM1yRcwCO20KCVbHqVzgdZemQtIf/HA/Z
         QCfg==
X-Gm-Message-State: AOAM532zAAEe6ci+/RhqHIaDolKWJYJEp2P9uLLiz15+6ROBmaqJPOAP
        9ciYnK0iYfc/JPV8zcBIgZLcLpph0T8=
X-Google-Smtp-Source: ABdhPJxqTLFRihf8yzT/n1UiyfwiCloIAR1GxUA6azje2bWWBY2v4yCLSoovgyhKWwIMHWmU4gw5/A==
X-Received: by 2002:a05:6820:622:: with SMTP id e34mr25820104oow.19.1638849362042;
        Mon, 06 Dec 2021 19:56:02 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id d12sm2568372otq.67.2021.12.06.19.56.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 19:56:01 -0800 (PST)
Message-ID: <3c98edce-c46e-29b7-d3b0-c80576cd9c23@gmail.com>
Date:   Mon, 6 Dec 2021 20:56:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH net-next v4] rtnetlink: Support fine-grained netdevice
 bulk deletion
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org
References: <20211202174502.28903-1-lschlesinger@drivenets.com>
 <YayL/7d/hm3TYjtV@shredder> <20211205121059.btshgxt7s7hfnmtr@kgollan-pc>
 <YazDh1HkLBM4BiCW@shredder>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YazDh1HkLBM4BiCW@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/5/21 6:49 AM, Ido Schimmel wrote:
> In your specific case, it is quite useless for the kernel to generate
> 16k notifications when moving the netdevs to a group since the entire
> reason they are moved to a group is so that they could be deleted in a
> batch.
> 
> I assume that there are other use cases where having the kernel suppress
> notifications can be useful. Did you consider adding such a flag to the
> request? I think such a mechanism is more generic/useful than an ad-hoc
> API to delete a list of netdevs and should allow you to utilize the
> existing group deletion mechanism.

I do agree that we do not want to allow netdev changes without userspace
notifications.

It would be nice to re-use the group delete API, but really there is no
guaranteed, reserved group value that can be used for a temp assignment
and to then use the group delete call.
