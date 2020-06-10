Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C2A1F51D0
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 12:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgFJKEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 06:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbgFJKEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 06:04:08 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC1EC03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 03:04:07 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id o15so1844957ejm.12
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 03:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RuxjbfFH/DZII4QdkiYWrv3xZWCtMaNVtgJA0HHfTC4=;
        b=kBNnX9gMzVqLGCNM36dt6FtEtx/WFYxPimKl1pnd9ENjoltbgjic3TLcpc8aLgQhKq
         thKIivjR63DXsoMGeInY6dsV58N7V9hlNXYcR9tmmupd69zYuu3VSQC6dwhXzFv2d+LG
         zy+L+cVvCO/qhyXvMfPDerbyN3tM134KT24llzehVbT1ZUhNkncKnpXgPowhLuqINDd5
         VCvgFwmkDR8bW7eeC8ynBZvBrBAcTky3Zjx4hL9/rIOAV5nCX3eCLmpn7RWX8g78Nzps
         HqnqKd/de2eyJq6pTyTODG1SZhMZOJKM8htMXaHZkyKfOMn9OoaGu8HzCk1DwysflxK7
         3MGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RuxjbfFH/DZII4QdkiYWrv3xZWCtMaNVtgJA0HHfTC4=;
        b=osOfNzTVWbVKxvJ6Ic6q5uSL6otA4fH1HBkqeia27RzPVW46UR7EPkT6xi040Fs64q
         mpmIbgo5c+lnr22hSHcxaEw6mhxzcGixYbrRFxNQX0zM6UJK8SQkbalwGF8qqSrHbcgb
         cP6CSghpa+LUKcFLQdtIVT2K/QVOym55D4yVeC2RPaupyEYTtM1EhauvtudbMhRW8ec7
         eRo9v05NatYkUwr5/dVwWsQpCm/gfBFu26mUwR3d/9IiqvkGrk/CckLDBiCKfTby7VFg
         BOa24imHj+DXF8yff47B1kqJ3bdI4tC2yuFm2MMsg02VEEVLOpobrl8qorpNCX4BA3La
         jBUQ==
X-Gm-Message-State: AOAM531jnMi1ydASu5yD+nbVht1sggEg5jTC5DwwUGL0rf4iQXKWvKes
        vRJhqjEqrGrrFQvuS8r21J934lf0N7U=
X-Google-Smtp-Source: ABdhPJy3P8GA55s5Pz8c+LYXIT3nvpjsLHqVb6eHHK5N68/2TYRYPb8+boUxukmyr1YOCZtNCyWiIw==
X-Received: by 2002:a17:906:d0d7:: with SMTP id bq23mr2679890ejb.259.1591783445593;
        Wed, 10 Jun 2020 03:04:05 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([79.132.248.22])
        by smtp.gmail.com with ESMTPSA id b15sm16634252edj.37.2020.06.10.03.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 03:04:05 -0700 (PDT)
Subject: Re: [MPTCP] [PATCH net] mptcp: don't leak msk in token container
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
References: <f52cfae0ddacd91b37a804f19a6ffa2f79efe56f.1591778889.git.pabeni@redhat.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <88f6e442-44a7-c33f-33ab-f88c90c35514@tessares.net>
Date:   Wed, 10 Jun 2020 12:04:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <f52cfae0ddacd91b37a804f19a6ffa2f79efe56f.1591778889.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On 10/06/2020 10:49, Paolo Abeni wrote:
> If a listening MPTCP socket has unaccepted sockets at close
> time, the related msks are freed via mptcp_sock_destruct(),
> which in turn does not invoke the proto->destroy() method
> nor the mptcp_token_destroy() function.
> 
> Due to the above, the child msk socket is not removed from
> the token container, leading to later UaF.
> 
> Address the issue explicitly removing the token even in the
> above error path.
> 
> Fixes: 79c0949e9a09 ("mptcp: Add key generation and token tree")
 > Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Thank you for the patch, it looks good to me!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Matthieu Baerts | R&D Engineer
matthieu.baerts@tessares.net
Tessares SA | Hybrid Access Solutions
www.tessares.net
1 Avenue Jean Monnet, 1348 Louvain-la-Neuve, Belgium
