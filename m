Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE17030AB5D
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 16:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhBAPa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 10:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhBAP35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 10:29:57 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911C4C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 07:29:16 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id r12so24979707ejb.9
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 07:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lu8g1x2tQJNXeBvQhLMN6lczEu/N28R4nfZBjk9q/v8=;
        b=sQILmOEqLwgSy8Y0fjb0Cp9ZCuGdM+JhFuEDgMqy3CTCv5/EYhtCLPLs/8SEEBvulh
         MZGD/VPaabymZkmOEASMKCo9L7xIL6y9raVp55vCpqp4ad9zOSmbQMuWZMRKZyuHy6Gm
         rHWu4FvI7uW+h8VngpGeLvqzZTW0XGuTGW8oofQUTKf92esp743vGqx9Rspf/WFFOZ30
         Nh8aNjlUUs0NUZJwNJiEG9aqTF5v8SWraEVlUJ07u7ZrFjhJIrQVQ4PdcHLMO6YzB04X
         CnOIk2qryqUMBbfgzAr7fk21rVqSQfTa97KTNgpF0Y5ySZN4R6wEbeu/btwfYK7pdtoL
         UOIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lu8g1x2tQJNXeBvQhLMN6lczEu/N28R4nfZBjk9q/v8=;
        b=rZ0BRStihNGtZ9fZl97QeJR7MwNbyf0RoL2AM1LcV/FbrfaZPv2st49u11Us6cQZ9C
         1lqw4oTd4YxWQR7PwpXSzPuJEPpoHZu0Y1vFvIbnWYlrhktq2epdJlKJGL5nLYJ8I4zQ
         PWHkFXdzcx6wkrzsAv0+ipEUkksK0LQIrzHn7DK5E3wzVcVvEb0GUS9GsAs2sm/1KPBP
         LRJFo2dOuqwGHFbYQQ1767uS4SXhHVnlxZy0T/XCBvRee/Cl45d0EoXKqiZYhxI4IUCV
         iMW1qo25ysA4q/Rgf2mV4afFRxIhrSIPTKEjiLMyxbL+EDQQmWxoP0gmQcTI4AHknBJg
         5+MA==
X-Gm-Message-State: AOAM533cTjGFDn30oHwHqrXT53F7ZaNd/I+8XLq/U1HoDfEuofQyHedT
        8Sk+PgbccAr1GvrMXT2JgVk=
X-Google-Smtp-Source: ABdhPJzz6b8vo20BhE5jvb6Rm80VDC4v5Iw8sKnic2/X8jf9NtwVAw1hNIeC2Dgl8+1LEwpTrxH3Kg==
X-Received: by 2002:a17:906:8690:: with SMTP id g16mr3590512ejx.113.1612193355351;
        Mon, 01 Feb 2021 07:29:15 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x5sm546641ejw.9.2021.02.01.07.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 07:29:14 -0800 (PST)
Date:   Mon, 1 Feb 2021 17:29:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH net-next 4/4] net: dsa: xrs700x: add HSR
 offloading support
Message-ID: <20210201152913.khrvofpnkghrsba2@skbuf>
References: <20210201140503.130625-1-george.mccollister@gmail.com>
 <20210201140503.130625-5-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201140503.130625-5-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 08:05:03AM -0600, George McCollister wrote:
> Add offloading for HSR/PRP (IEC 62439-3) tag insertion, tag removal
> forwarding and duplication supported by the xrs7000 series switches.
> 
> Only HSR v1 and PRP v1 are supported by the xrs7000 series switches (HSR
> v0 is not).
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---

Does this switch discard duplicates or does it not? If it does, what
algorithm does it use? Does it not need some sort of runtime
communication with the hsr master, like for the nodes table?
How many streams can it keep track of? What happens when the ring is
larger than the switch can keep track of in its internal Link Redundancy
Entity?
