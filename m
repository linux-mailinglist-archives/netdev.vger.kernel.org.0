Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE55282DA6
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 23:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgJDVCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 17:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgJDVCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 17:02:30 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EABC0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 14:02:29 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l15so4662956wmh.1
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 14:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hCcr/vK9pCSNF2IKfX5Sv6HoYAh5V/ryDj8CkPzk+Hc=;
        b=QCcdPyCXje9oAtRMfGGNyi3znRPQm+IEN75Md4+zrswquicC6PEndYIKjPbphQuVT0
         KxvYWPQaiWP0d5g+dCB0EQkwRUuO+003bsZvJxAElom+Uose9/ayA7tY+EDfxa1LaPnk
         1sfEi2McXixjcaZN9DlPfcx52f9t5H8LaMW1aGO9mzFUMFXE4c3cIe1j02zgb6nUuE73
         trA3E5omq9OR0HhDnSyENnCmreWyx1TzveJsxSvkKByYS7vIkluZtK7K7TsCAnY/ga6p
         KJ22uBI9lVa8rLLZz/JukmSrgxExXrkBau8Eh6ia712EBy0ADnAiHfaLSEmvq+Lr4yaU
         wQMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hCcr/vK9pCSNF2IKfX5Sv6HoYAh5V/ryDj8CkPzk+Hc=;
        b=jDPCEmqJTVs31xCLPpoeLGhHWakgsstNZwXQKg7om4xmR508Q6EEC0fJEF2E/yXaDU
         pA9qs17fslRbgQ4oX/xziCrt45mIQRb1MIkC3ZIiZ+bPWwG2zmTye42o1Z4s3puBwpBY
         G0IEycfMT3p/BCoSQlR1GWGzyhiRHev7dbXP1ov3tIw0WwDeajOqTducRXaBpAJv3Bjy
         WbMRUIdf2sVNV4ak0JiE/UTccYVSCfEksd/KAjLzM1IeXML2eOBveM20zOPVwQAnKj79
         iYHTi7VaV0Efxq/DgXP6FF/GZYkOSs5Rs4g6a5zhR9uybD9PPXzDXWyEI4dRrcEb25v0
         8OWQ==
X-Gm-Message-State: AOAM532WgsnRN4D6JWNQj9KxyObyH3BPbM+dnZoymoa0i+RttPgZ0OQw
        fCVVx2cXt5HnjI9PPeuHhMk=
X-Google-Smtp-Source: ABdhPJz92n92ylrZnk+5LGw816BIE5B/HsJFMMTteRRWHW9oMT6SoG20XTK2jrlNYaDf6XNFs/uyrg==
X-Received: by 2002:a1c:7708:: with SMTP id t8mr1366174wmi.6.1601845348737;
        Sun, 04 Oct 2020 14:02:28 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id n10sm10010012wmk.7.2020.10.04.14.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 14:02:28 -0700 (PDT)
Date:   Mon, 5 Oct 2020 00:02:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 6/7] net: dsa: Add helper for converting
 devlink port to ds and port
Message-ID: <20201004210226.qnbyqxh2vlbxz2ov@skbuf>
References: <20201004161257.13945-1-andrew@lunn.ch>
 <20201004161257.13945-7-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004161257.13945-7-andrew@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 04, 2020 at 06:12:56PM +0200, Andrew Lunn wrote:
> Hide away from DSA drivers how devlink works.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
