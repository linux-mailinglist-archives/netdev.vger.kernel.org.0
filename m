Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BADE258B64
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 11:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgIAJWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 05:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIAJWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 05:22:30 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2C7C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 02:22:29 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id w5so676946wrp.8
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 02:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JId0SkVazCDez5KK5g4ks/W/j+P2ORJmNcED9SIPLI8=;
        b=XXhM+dPf2aCaAvmFC8uGJg2kDixU79a0xCvcJZr5D6Xe/Lqc2tqiGOSrC5jGjkcgp3
         6dQ29E5h9/rgb031e7/jwaok86ClcvNb0Nah3RJaGwandOjfYY7t3EtZbFXP4xDZJpOT
         evpJeOcxK2Zf1NJp4xaRlNe8jw6W0vrTeZcW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JId0SkVazCDez5KK5g4ks/W/j+P2ORJmNcED9SIPLI8=;
        b=HaG9NEHqOE9csJz3rqV81PmVGyU7uph3E5NCbHcjg71+mkPB0OEq2f0VIr+P/OjIsr
         RKNlvOT6cmVULxczinvZaAYF5NZ0YCRi6EYsmUgnEtz6E6k6go1RjwdjJjt+K4qy7dss
         cI9Uh8rhwSGjm+zhhHUPr1qOw9lhSi3JcGU74o5saWcA0ErO/h8nQ4VdZ7W8SkF82j77
         b1dZjDx/iY+Rb25khVhH5F49fy8XNArKEVG1Uh7GaON5A+X1PLYi976cdJnQjAaw9pm9
         9MLCkhfSlLSsHA0RPM4dNx3eRic5Z4DKshvQd5+HQAFs+nl4+xiL8ijU6JaArV6nwbE+
         SsSA==
X-Gm-Message-State: AOAM530rywdLgBTg+gJJPbujmEHCKLHL0qF5RPdt6NBrutFfBTQ/ZRuQ
        M9mg9BxXe9kYkavTzyK90Ydp3Q==
X-Google-Smtp-Source: ABdhPJyYrXPBMuUuxUPwYovheCFfJFXdqwWG/2qh6u65HvgIoov/h/3lZPTljKgnKBvTshLwoWUFnw==
X-Received: by 2002:adf:ef45:: with SMTP id c5mr807011wrp.37.1598952145695;
        Tue, 01 Sep 2020 02:22:25 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id j7sm1462752wrs.11.2020.09.01.02.22.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 02:22:25 -0700 (PDT)
Subject: Re: [PATCH net-next 00/15] net: bridge: mcast: initial IGMPv3 support
 (part 1)
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net
References: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <d7b03d6d-90ca-5df1-13de-33f69d8c86a8@cumulusnetworks.com>
Date:   Tue, 1 Sep 2020 12:22:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/08/2020 18:08, Nikolay Aleksandrov wrote:
> Hi all,
> This patch-set implements the control plane for initial IGMPv3 support.
[snip]

Self-NAK, my torture tests uncovered (a rather obvious) locking issue with the dump
code. The src groups will have to be traversed with RCU, and thus RCU-friendly
since the mdb dump code doesn't acquire multicast_lock and we don't want to block
IGMP processing.

I'll wait with v2 to see if there are any other comments.

Thanks,
 Nik


