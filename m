Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C208D2B587B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgKQDtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKQDtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:49:04 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A62C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:49:04 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id u2so9495225pls.10
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HRc12UJTQ3GGiSgPYFkMIQjNBC2gST7WUWe1lY+eIlI=;
        b=XrkfqVF0+trZQLgA5VkVY81PcgHDcq3rpbtyuCdD4JBp81dhrRauFBrZK1FnvIs5F9
         H5cWn6/eRuAuYHV+fGxGp44+iDu2/9ZnfDGussE9nPN1iiQYQNfjfgRY5PePG44CRgtP
         D7NPAr+jN0egDXx+z0iXqo1jps6d8ve/aoxsmb5VrQeTdLPETgEpq94D5ZC1knw78mju
         L0AeO8Di1q2IxY9vLhU6yJKvf6y1fvUJ+/GaENinIHpCE5L+w9qLbvN3e7cvAn4wRx35
         7m0Rs/AXEOPF9WluU0dYFt0XacJH4cB3tQrU9RVByGiWq5tO5sGpZxTXaKNkZt/aKIqG
         pPGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HRc12UJTQ3GGiSgPYFkMIQjNBC2gST7WUWe1lY+eIlI=;
        b=hDZcC7cxDtk11ZTdKLLLWimRb+bt5VEqm0klpFsRqyt3YqdalcZfwYdWXISjdh6vbg
         ts6ccRnQKoHsFUd406MpoWLpI/imUFsDwUB2YN/RUS5Ec9NH37kJPXsEMH9xL4q0KHWz
         Se7/ZwDMGl7EQDKIKX3gcl4B27SL1NJ8uKUXMMBP/6ubYoW9kgca7A4/dwNUrAh+Z2IB
         rA8hHe5qBeG3joTE+v5wE6grff05NTOZGYN0gG4U0fvREWR35Dm9txzN+zV5oPl/+2/2
         HLtNZcTD8xSn1ytmJ4znMTIv+eJxFW7gnpV7p6RVqNPCjSs5bLs1q1ZIri0s/nYmxI/J
         sCxQ==
X-Gm-Message-State: AOAM5324/GpFRcXjxT65QYGS6P3BsUGuMec9LgaMtmiy3T6lOfEou4Ij
        yOEr7J+eMCsGiwgoh3eEGSaKoY3YMEA=
X-Google-Smtp-Source: ABdhPJz8kpR0NmkJDIAjwuqgpuYkJ4Xbxp126A/9jK1aISnPEgoDbX5NypcV0hwRnGHvnvLRp5p9KQ==
X-Received: by 2002:a17:902:c14a:b029:d8:dc05:d7ef with SMTP id 10-20020a170902c14ab02900d8dc05d7efmr13278522plj.83.1605584943596;
        Mon, 16 Nov 2020 19:49:03 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 144sm19645073pfb.71.2020.11.16.19.48.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 19:49:03 -0800 (PST)
Subject: Re: [PATCH v3 net-next 2/3] net: dsa: tag_dsa: Unify regular and
 ethertype DSA taggers
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
References: <20201114234558.31203-1-tobias@waldekranz.com>
 <20201114234558.31203-3-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2473d53c-553a-5d80-7624-1d615d0e079b@gmail.com>
Date:   Mon, 16 Nov 2020 19:48:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201114234558.31203-3-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/14/2020 3:45 PM, Tobias Waldekranz wrote:
> Ethertype DSA encodes exactly the same information in the DSA tag as
> the non-ethertype variety. So refactor out the common parts and reuse
> them for both protocols.
> 
> This is ensures tag parsing and generation is always consistent across
> all mv88e6xxx chips.
> 
> While we are at it, explicitly deal with all possible CPU codes on
> receive, making sure to set offload_fwd_mark as appropriate.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
