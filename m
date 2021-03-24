Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59655347D45
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236951AbhCXQHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 12:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbhCXQHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 12:07:09 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59DAC061763;
        Wed, 24 Mar 2021 09:07:09 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id q11so8186165pld.11;
        Wed, 24 Mar 2021 09:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2DGuhHo+Cb6MXVnc++dT+O9N+4yMJ/uTwtOV806nVZc=;
        b=aZCvdWSe8eBrklJYTBHPKA2791MdJnsa72WyCHU0zyW8niq5HqlO3Y4b+R008MSPDr
         0dSouNhxPCtSgyhbtEikIN/wNC4kReZ8nSYNZRVA/RRhjnRhJJ/nuJ8XKI/MhgO2vzuI
         N9hM9YfoMUU0qvcPWQstW8uA0Aukqni4zA+MpvIqRJEKaIOcwWuu8LIHw0iFC31vLEYV
         5B2bQ5QLoZjDiCbtNhiz3QBK7zmqIJgwkBgEpz+NUKHeNw+fgU8QZubYLJ+Sun+6Phzs
         m0/SakNmrHU5jNITXrG7Tc1ezkb/+FlSHoDPlEA1WRywVmxaBQlzLPz6XgsR9inck77X
         EvGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2DGuhHo+Cb6MXVnc++dT+O9N+4yMJ/uTwtOV806nVZc=;
        b=jPhr2Gmd4aZUzKbqwmdmaCWRPRrXYOX0D+XsJU35et+vwLY5gwNlOwDEBxNAD3Y6WM
         pp0vCxHD+O659W0SSpZzmgJXpE266K4jxN56u1ErZXZY7EEViTEa8HtPTqjmA6YyftKx
         nt9kL7HrvJQ379ka0ZPZtJBVIBNZgOASM+W9nrr7ocBq2eNROIxZueiK42I/GK93JOyS
         L8sssh3OabolkmpjKDEmvMiA6jFTJPoIeENRIz7HgYJ2vTc+dy11Doxg9nLVSKe9sJLK
         FAQqqHCl80Fmf04yxSRgJyCGKyQgRDpXwjcGb67TKkpoaQ1d63Sll87PrmVnJfgPtJw6
         WTeA==
X-Gm-Message-State: AOAM533xwJ0zqpdd/nnGkyPK+d9LAHvRbuNZn2yDO+uMaempuQrxYI8p
        OWt+jO4kT2exIlIQqZEhfgE=
X-Google-Smtp-Source: ABdhPJwqoQS8s/i4ScXWFBBj+kIldHD276mDS8J1l3BXlV2zYWT+AZhAofSbPb8/8sr0sskkqxkWxw==
X-Received: by 2002:a17:90a:9b18:: with SMTP id f24mr4061602pjp.96.1616602029216;
        Wed, 24 Mar 2021 09:07:09 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id b9sm2952708pgn.42.2021.03.24.09.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 09:07:08 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next,v2 01/24] net: resolve forwarding path from virtual netdevice and HW destination address
Date:   Thu, 25 Mar 2021 00:07:02 +0800
Message-Id: <20210324160702.3056-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210324100354.GA8040@salvia>
References: <20210324013055.5619-1-pablo@netfilter.org> <20210324013055.5619-2-pablo@netfilter.org> <20210324072711.2835969-1-dqfext@gmail.com> <20210324100354.GA8040@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 11:03:54AM +0100, Pablo Neira Ayuso wrote:
> 
> For this scenario specifically, it should be possible extend the
> existing flowtable netlink API to allow hostapd to flush entries in
> the flowtable for the client changing AP.

The APs are external, are we going to install hostapd to them, and
let them inform the gateway? They may not even run Linux.
Roaming can happen in a wired LAN too, see Vladimir's commit message
90dc8fd36078 ("net: bridge: notify switchdev of disappearance of old FDB entry upon migration").

I think the fastpath should monitor roaming (called "FDB migration" in
that commit) events, and update/flush the flowtable accordingly. 
