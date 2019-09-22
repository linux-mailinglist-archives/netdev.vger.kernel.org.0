Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 102D5BA01E
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 03:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfIVB3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 21:29:25 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39856 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbfIVB3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 21:29:24 -0400
Received: by mail-pf1-f193.google.com with SMTP id v4so2282822pff.6
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 18:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=DMn51Td2POv7lnNtwrlqLDrrj+YMQmgwExP4qEnhkL0=;
        b=zUYdMzna+R2zI2XOIyeaGmiAQEOgz44LaSfLXx6lFbqfgrl593w7NRGN5Tx79Sg0nC
         rqmOSjzYTVpE7gpQKTwJ6aNM8domemfqPq2SsPiNeVcRgZ5jzvLoqJOKZYwRWRruT76g
         NtXXOAGrYH9fCamvfsFyq3Q18r9dMsP4crRMUJNiQwgoSwKACp9OTwyUsTVPpZ6WX+Ju
         oPgrT7UqF3RXupTacwi0wxzsbahoD2mcZwCdwrqbQ+xBkvAbSWAUT0KUXCAgaw8vUeTd
         kTrK6OhtnVYOhjOLHr8TcNb27iuNK4yNosm20xNdu8UIUWi3iI7C0KDduGjz+afJZEJq
         HPfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=DMn51Td2POv7lnNtwrlqLDrrj+YMQmgwExP4qEnhkL0=;
        b=G+tbQlLhAFjwIEYHT72Q2CBLCEcDlExz6ybzHMJrh4A3ajX+5J4eygg5O6e3G/pzEJ
         yCabWmQFViylInJ8fq+LRr0HCJRcRSbTjQ2yP3MeqUmxVlGWC+K5R6Qkr606/8qg3bKk
         BHdYJZkIJyWjzf385eLKlBguWDMb6k04Taw0KjDODa/gXG5ruompWtg2HL5hYV1AUYdj
         bJkJ6uLFl/7JgAa333TgzwDn86O9rhGi9cFPhe1BLQq9+YhTfC0euU1bHVC2+R8BjBLB
         83rOrZRH6c6rTZjO9pV6WUqQC84rRrxr8AM7qVb+IyxowUkJ34tNDflWVkqbixHpv0xu
         t0sw==
X-Gm-Message-State: APjAAAU8/NsppwVbiMMF4bZIXRBIF798IkDPG2ZXNCQzoBdRYCV02jrF
        O4uVdCFqBpOWIK7IBpFsd/U00g==
X-Google-Smtp-Source: APXvYqzz/GhdU9GscNtk7wgkNvw74Uykne3188YvZa4yf9TZxZP7AruZajWUrGbVd5Ja2vbApg/Abw==
X-Received: by 2002:aa7:9116:: with SMTP id 22mr15330509pfh.81.1569115764088;
        Sat, 21 Sep 2019 18:29:24 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id d69sm5638100pfd.175.2019.09.21.18.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2019 18:29:23 -0700 (PDT)
Date:   Sat, 21 Sep 2019 18:29:20 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Peter Mamonov <pmamonov@gmail.com>, andrew@lunn.ch
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net/phy: fix DP83865 10 Mbps HDX loopback
 disable function
Message-ID: <20190921182920.172ea69d@cakuba.netronome.com>
In-Reply-To: <20190918162755.24024-1-pmamonov@gmail.com>
References: <20190918162755.24024-1-pmamonov@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Sep 2019 19:27:55 +0300, Peter Mamonov wrote:
> According to the DP83865 datasheet "the 10 Mbps HDX loopback can be
> disabled in the expanded memory register 0x1C0.1". The driver erroneously
> used bit 0 instead of bit 1.
> 
> Fixes: 4621bf129856 ("phy: Add file missed in previous commit.")
> Signed-off-by: Peter Mamonov <pmamonov@gmail.com>

Applied, queued, thank you!
