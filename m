Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC4E9F923
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 06:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfH1ERy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 00:17:54 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33273 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfH1ERy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 00:17:54 -0400
Received: by mail-pl1-f194.google.com with SMTP id go14so595949plb.0
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 21:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Niv5l9HH8oX8cmDQomRM75jsIj7Etn+DSuDl0AseyHk=;
        b=uklzTnO6sj9quZIsyajLN4YQZpLDswyJW0qoWczLiRt1E9MByAA+d4sw9320j1gmQ1
         lQ/HuM4Tu70nVTMXRcLfVXXXU5lnmQ1XOg2W8SZ/e7Sj7LGHo/aTw0teGImZ5LX31ND7
         6glsFSfw8+I1faq2Jw60Mb/BCza64SY7bu3rmX3SFNhTphlIVU6fMrf+3n177wBWEj9c
         A6w0k7wST+9kiG4g7CGaGS0NBvBV9RIwSdbikUdpMorZ60AV1jr15Sa7doMqLCiq81Xy
         gY/h8DscCe/rvA1evjYSbaW90bqwOG/P7nl/mrsun/Pw5Ir2y4n7+I5YdjY/BMTxQJW8
         4FWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Niv5l9HH8oX8cmDQomRM75jsIj7Etn+DSuDl0AseyHk=;
        b=j8EGRiq2nLBDGzmTOTleybQYaHaPoreD4P+QmmiW4tKQQot1OuT9CQCknaIQNBv0oh
         i5k++3pTMPcdpLI1MH4WUjaCYQ0uZvq7V+ESPV5Htjb7H6+hYgXHhm02FLszHFCSnbOs
         o4+0jfvPQdsZ+gZZv3zrBasErr7jlULc/f58X6j76e+yOYagTUhcOky/A7DfT7gdl2P3
         uLToZrBX9rcaK6WSEfSRrFTFuIJecl/IORFbkqRHjWAKySLDMWhzkBmCaJYmqlls5jEh
         8/Ic8RSuu3PBhvTGj7uJrn9mypFGXI9208avd0jCGnWQpzmhrcdurSUs8pAjgrqVZcBP
         eZFw==
X-Gm-Message-State: APjAAAX+YE0jQDUhrMxJeVv/AI/eDFPlsIzM97NLzPJgLjgIna/N4/yU
        9BtD9zQZl06ijHI21xk3PZGxEg==
X-Google-Smtp-Source: APXvYqyksML7Z0z2EcU8JugTQamrHOZXVC/fjmpO5hKBEUBs92O6Ek8OPCS5NK3YvrIzBmwogLxnTg==
X-Received: by 2002:a17:902:b605:: with SMTP id b5mr2345725pls.103.1566965873284;
        Tue, 27 Aug 2019 21:17:53 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id y14sm1121054pfq.85.2019.08.27.21.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 21:17:53 -0700 (PDT)
Date:   Tue, 27 Aug 2019 21:17:35 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v3 0/2] r8152: fix side effect
Message-ID: <20190827211735.269764fb@cakuba.netronome.com>
In-Reply-To: <1394712342-15778-320-Taiwan-albertk@realtek.com>
References: <1394712342-15778-314-Taiwan-albertk@realtek.com>
        <1394712342-15778-320-Taiwan-albertk@realtek.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 09:51:40 +0800, Hayes Wang wrote:
> v3:
> Update the commit message for patch #1.
> 
> v2:
> Replace patch #2 with "r8152: remove calling netif_napi_del".
> 
> v1:
> The commit 0ee1f4734967 ("r8152: napi hangup fix after disconnect")
> add a check to avoid using napi_disable after netif_napi_del. However,
> the commit ffa9fec30ca0 ("r8152: set RTL8152_UNPLUG only for real
> disconnection") let the check useless.
> 
> Therefore, I revert commit 0ee1f4734967 ("r8152: napi hangup fix
> after disconnect") first, and add another patch to fix it.

LGTM, seems like if we were to add a Fixes tag it'd point to the

ffa9fec30ca0 ("r8152: set RTL8152_UNPLUG only for real disconnection")

commit, then? So only net needs it, v5.2 is fine.
