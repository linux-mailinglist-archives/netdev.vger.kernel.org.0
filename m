Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E8E3409B9
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhCRQKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbhCRQJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:09:43 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB525C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:09:42 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id k24so1742797pgl.6
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+L2GqwO/dQBSOFDuHMpzPYWS8Lya2d/WnGs5EH4Ollg=;
        b=tp7GUD3XH+JnR3eiUIwmzwfakx/EdC6EENzSuEcWR2omommT+pf9SR03SKM3PVhm2/
         CAVHlWru0po1lljIdz4MdCyLHNRw6ftJYuUZ/m7AXrrLJTJTqswNbKS7Hp34/a/GVopx
         9V0+rgI0pHK5by8dXQDudyr29l05RuvxaiZY9RT6bauhfPhdfwyo8lJNp0/jWV8s9eDS
         HCVG0qAv1MJsA/yww1iQsnmjNWJiPORgez1WiDtQQTl/cwxKHIQ2LJNOVABTdfLS5nqR
         BjROoeyI/pr+EMmr4Scgg8lpl1tO4Tkt0Ndh7vpRnwEM6jKzwn/mcmIChxpiW2JzZ/ly
         u85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+L2GqwO/dQBSOFDuHMpzPYWS8Lya2d/WnGs5EH4Ollg=;
        b=b9PA7Y32YB8shmXf7WkdGwki4bdqEaWjFjDsVpj+eik/wzQU5G5PW6ByIsoWcl5IVt
         j9oWQWdVUe/QBLJD6WfJgb3DDy+icqsmYzjVVTSqYQE7hEypx0ibXQE/jDMOolt3/7S5
         XCNu07Z3cXDvXE5X1CqvQPfF5vvkrJ3Xv/sPBg12lqr7B3I2FWAdruWR9wp/C7BUi38F
         e25L8GDxXmDVRdyYF7C8I6BoG2Z6c1hb9dfuE0B0ACU98Dp7GKi42gUH8vakVV50v5dp
         dPuaEFlqN1i7+dBn0yRonkcv2At3BX05w2jxYRtIIL5OFc53mgk/Loi/3U3zy2D7MjUC
         0bWg==
X-Gm-Message-State: AOAM533BBXd/RbsEAzQmLGI28BIOVCjW2BLs9svcVBBVr5Tv7rrAgEx9
        2mpWAjvimqwskzmMFja0WrK5NjZIHD0=
X-Google-Smtp-Source: ABdhPJx1Ye14ezpwNYTfnjBqCWWzraEr+YG8WnmwgI1vFc0JbO7VZR/ZUdRqzAu9twyHt9qFcjnoDw==
X-Received: by 2002:aa7:814e:0:b029:20e:f3fa:2900 with SMTP id d14-20020aa7814e0000b029020ef3fa2900mr4818616pfn.62.1616083782130;
        Thu, 18 Mar 2021 09:09:42 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p3sm2678313pgi.24.2021.03.18.09.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 09:09:41 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 3/8] net: dsa: mv88e6xxx: Provide generic VTU
 iterator
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
References: <20210318141550.646383-1-tobias@waldekranz.com>
 <20210318141550.646383-4-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0b3d702d-64c2-29b1-57d4-50c08b0425c2@gmail.com>
Date:   Thu, 18 Mar 2021 09:09:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318141550.646383-4-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 7:15 AM, Tobias Waldekranz wrote:
> Move the intricacies of correctly iterating over the VTU to a common
> implementation.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
