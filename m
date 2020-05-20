Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED7D1DB8A8
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgETPtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgETPtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 11:49:19 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C7FC061A0E;
        Wed, 20 May 2020 08:49:19 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h17so3638074wrc.8;
        Wed, 20 May 2020 08:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qO5KMhvNfzj9bbNCDfA7x6Sp4zrCAtfu4VyOnO2ezqg=;
        b=R0eTv50DGORz/BclJPmcolpMoipyElicThx6Epo19ngTZoDX+44lPGD/tJr33MWNk3
         ESymGiErCdjZwsWJPD1YWwRtm2pF8QoTkouxQkZUZI1K6s6x9/o04+82otPixnV/MpF4
         OnfJik8x08m7bzjOjxHblEhvk7FFcnPmjC9NSBGwi6P6yHkN+DN4dJHTKBju7hkihTkc
         mYH6SI+Ft1z9vASRliYYXqrhEbKVEQDG9CoVhZb7c7KrL1ygWJ1qjIj60Iv9Yw+dGb/Y
         938Gy5BzwPQRStM84Z+oS0eXhV1AVq/6uyyXwOqXf5HTYQ+oxr+XvdHlaBHKYdXqdrgM
         RAZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qO5KMhvNfzj9bbNCDfA7x6Sp4zrCAtfu4VyOnO2ezqg=;
        b=rwG2ecEzHFjwbu8FWcS8GpmIJV9HALMkACROZWEe1B5yKixUc4BRR7xRJpV8D52yR0
         jVKzzOjgr2mgwdFQaQWBU8ZtVZdsr7knPYAgcqBS8LE5Ye0ISkWWWnC3bRBh+5bhhebE
         +i1JKeoPRt5xb4QLc7EHu/nvi/pwYx2Gl72CGwsI5GH0ans0R1nqq+02OwRp22W74riw
         hpAsqfWb3SsviFnyUIGpcdPbErpSl5hS/XKDyxlAjQ0R+jnsyPetExmqqy+2L6u7fEnv
         lfs5eP/s/BZKaJK25/yita2FT9J9umOyUw0dtMQ606Duamlrz5RzXBhxJzpz4kcmftuj
         zkEA==
X-Gm-Message-State: AOAM531dmlSV3pNC9jNA+ms/Yo59la6FMwgrAVwJKsBQpvUa724hqi+1
        dX0uefLSDd+kXKIxXkx9lTlTgdc/
X-Google-Smtp-Source: ABdhPJym+kJeWiwlFXD5FHmX7APmf8B+yHSjHLR97rWIHzV5F8DcSlFRcwMNjvPYn3prx64Xg9Z/hg==
X-Received: by 2002:a5d:6584:: with SMTP id q4mr5015280wru.12.1589989757686;
        Wed, 20 May 2020 08:49:17 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id b145sm3728520wme.41.2020.05.20.08.49.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 08:49:16 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/4] net: phy: dp83869: Set opmode from straps
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20200520121835.31190-1-dmurphy@ti.com>
 <20200520121835.31190-3-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b19dda18-2d33-34de-b8e2-6ccb6ff685a9@gmail.com>
Date:   Wed, 20 May 2020 08:49:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520121835.31190-3-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/20/2020 5:18 AM, Dan Murphy wrote:
> If the op-mode for the device is not set in the device tree then set
> the strapped op-mode and store it for later configuration.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
