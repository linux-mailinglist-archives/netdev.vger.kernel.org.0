Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F365C484B9C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 01:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbiAEATf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 19:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbiAEATc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 19:19:32 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6ACC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 16:19:32 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id v10so29675726ilj.3
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 16:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IZNOSQLFPt2ivrINKanjBaceD/raH4rE98ZUKMdJ+zA=;
        b=fx1DFM6zuPJ0Rb4QEDB/acnGpIAaC5vErjYeUurJkbnIGQcDr7HMFpeDard/Oxh+Cy
         OFsKqU9zw1c3vEo1o4dZj9gNAQL+B0FhNu8xolpcxWT2aE+gc00D3Vtp11Cbnw5r4meE
         vRQ7jt1V0suNv4dUNMYbmm0JPihGHnqzL+NgSsGSLnrJ9scfoGEe5HP8Gns7VjXtZJGH
         m9DystLWSBeZWN17bSM62Is8w+/75M85dSn8X2TnCVVHb40YQUtyvfJLEgnIpKouTYtO
         /GucKFh18c4pQX5wN82z2aZhpWErOvnrVSawIRIXZwEQ+g0TeqAjMnAs2UpssnM25YLu
         9OhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IZNOSQLFPt2ivrINKanjBaceD/raH4rE98ZUKMdJ+zA=;
        b=0V55bU8RzBclAFawdytml74st6sQNZkmxc7FyCpMQ2/TMTfHHluSzg8dZm8X/mmbOi
         B9N+epGt3s5JW7Q+GhwYVriaVH86dl70VgUyBzjcOenEpD29lkGIaklbfyCH70v9vb9V
         IB2WO3NDKqgmmCQ9qSeQh2lCioWH9i/LPYoZK3gitVvMiBNqmFV37AnOPAvuemrpEYUM
         UM+ADxgylvaMbdf0srx37rP6yiiBmMVzPIY3/0WToVQJHNL6RhlMx44EIy3wyy1paIkB
         tbbKP0wxQnpiAkT7+R2bXx08jhv7VnNi7MBjoGYQNp7mpkgBkVLIqdOyvH+SdbVz5p62
         +vvQ==
X-Gm-Message-State: AOAM533Dc/dcJKEN+OMXSHiga+P7uS7bsqnfBrYzF9rgQnbYQCFuCEaF
        5gCvYV3Sv/tRrcvCzU6zf6U=
X-Google-Smtp-Source: ABdhPJx7g0P8fiIv1gE88PMCLw6VD+yZJxV4wyDQrAp86hUu8ujdbbt68Z3lFVFF/r9ysFSx6xs9zw==
X-Received: by 2002:a92:c246:: with SMTP id k6mr21975835ilo.287.1641341971599;
        Tue, 04 Jan 2022 16:19:31 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id x5sm26645657iov.50.2022.01.04.16.19.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 16:19:31 -0800 (PST)
Message-ID: <fa09b12c-24f0-86ea-b9d0-ac470961eb64@gmail.com>
Date:   Tue, 4 Jan 2022 17:19:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH net-next v6] rtnetlink: Support fine-grained netdevice
 bulk deletion
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        idosch@idosch.org, nicolas.dichtel@6wind.com, nikolay@nvidia.com
References: <20220104081053.33416-1-lschlesinger@drivenets.com>
 <66d3e40c-4889-9eed-e5af-8aed296498e5@gmail.com>
 <20220104204033.rq4467r3kaaowczj@kgollan-pc>
 <20220104131210.0a2afea8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220104131210.0a2afea8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/4/22 2:12 PM, Jakub Kicinski wrote:
> With the dev->bulk_delete flag and raw array instead of attributes you
> can go back to the version of the code which stores dev pointers in a
> temp kmalloc'd array, right?

missed this response ... that should work as well once duplicates are
caught.
