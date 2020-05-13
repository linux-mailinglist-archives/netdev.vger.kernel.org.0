Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810141D0497
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 04:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgEMCD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 22:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727902AbgEMCD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 22:03:28 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E743C061A0C;
        Tue, 12 May 2020 19:03:28 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id t8so7032600qvw.5;
        Tue, 12 May 2020 19:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mnascyUsz5V0FDEjsIfa2buK7teLIaGjv2zdFsy2N+M=;
        b=jbH6+xgjghxL7+AaDRjacF4fwhwmz4I9AocgvDMBNPLb/k6T2p2LIk7q6EA1a29kOX
         DF5zI/zYa1GaOeIzUa1Ppxb+RjMle8BzJYls5Bh+w4xvPs2ZrA2vT8f6pvbaHICCg8VH
         p5bHmD7MvdnljHAtr0eVuMGG9JvvAcs4yHQwI5kKzczxqLB20qtZQ6ldHfUJiLghTFma
         NXWF6JBgo/u90RdjqNDMurp3f6uKPcWNKs5WYivrPDuNYpaSJ8w+ltktyc2M+KMymxaQ
         nXxmU9ufx/31W6/oNtLOAADl2+GmsiuNEfIsB1SEBEAUI0TqDrgxU3ep92OVUwc/c2AR
         SRIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mnascyUsz5V0FDEjsIfa2buK7teLIaGjv2zdFsy2N+M=;
        b=YWPeqcYyL07tIwg+2s1V9vF5j6gnbbTLpwCnjQKWvY3kYbP9bEqvIcriAVNxOO5mcu
         +S5wFSHDBH9MjzukOPxgkCpYmiFDSCez8b//PDN3mQytlCPdVFKF30mDBjNEgHWT54H7
         Kp/YV8Pkvfb9cQ0c0Hi+lkoAflM3IWGeWIJmdL5acjmZqsUPuBpQ2lt9oKChEbWU66KJ
         g5yBlpzzlYWcGm6uAULdPvNybf3eBVSaN/1T3veFHsRIb+mLc6KQjZfyErAgPKV3SlwG
         DZJ8KEj2j86tiH976LTSd66yFAXnch1pH34MuvsUeVPrgawnGCVIj3qjySucGvsIuceC
         mVSg==
X-Gm-Message-State: AOAM531hZm2c8ET1MnakMGOX3UyR//ldcN0ZK2UWcJ+M1wnzWXFoYdNy
        DG716UfyLFSFdXVX0hcq4DV5UoYo
X-Google-Smtp-Source: ABdhPJyPfuG8JfeY7HsCjQWPG400npgxLXBlTmPVrWjc5W/+vJOoI3FBBSrKmTAxkNugakBCURQdXg==
X-Received: by 2002:a05:6214:42a:: with SMTP id a10mr4071727qvy.78.1589335407492;
        Tue, 12 May 2020 19:03:27 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:4082:2138:4ed8:3e6? ([2601:282:803:7700:4082:2138:4ed8:3e6])
        by smtp.googlemail.com with ESMTPSA id p125sm11300584qkf.130.2020.05.12.19.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 19:03:26 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 1/3] ss: introduce cgroup2 cache and
 helper functions
To:     Dmitry Yakunin <zeil@yandex-team.ru>, netdev@vger.kernel.org
Cc:     cgroups@vger.kernel.org
References: <20200509165202.17959-1-zeil@yandex-team.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <42814b4f-dc95-d246-47a4-2b8c46dd607e@gmail.com>
Date:   Tue, 12 May 2020 20:03:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200509165202.17959-1-zeil@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/20 10:52 AM, Dmitry Yakunin wrote:
> This patch prepares infrastructure for matching sockets by cgroups.
> Two helper functions are added for transformation between cgroup v2 ID
> and pathname. Cgroup v2 cache is implemented as hash table indexed by ID.
> This cache is needed for faster lookups of socket cgroup.
> 
> v2:
>   - style fixes (David Ahern)
> 

you missed my other comment about this set. Running this new command on
a kernel without support should give the user a better error message
than a string of Invalid arguments:

$ uname -r
5.3.0-51-generic

$ ss -a cgroup /sys/fs/cgroup/unified
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
RTNETLINK answers: Invalid argument
