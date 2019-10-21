Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1ABDDE252
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 04:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfJUCqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 22:46:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46720 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbfJUCqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 22:46:16 -0400
Received: by mail-pf1-f196.google.com with SMTP id q5so7424573pfg.13;
        Sun, 20 Oct 2019 19:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DTpTVkESn2vrQ+FsIrJTz16bCNnqcqqTMFT1dR0+ZsM=;
        b=aH0WYxbDf/0OBoHNaXb2q5bVYzYHKGTipxNLaDcvWqq/6nttgpVGsjoXuANiNg/Xif
         FZmOudKgonGJ5H+MCNLmhRJAbrAEzJFwkbnCRGyP/SDpJ18wNQ/Ierf5auqi8oNWCO3J
         oy/EeZzhda+jjygYXSq12jSvTmrDnNyOvarWnQqFPwvz6lXY7vT1bo8IjJcZ+k9I2YkY
         c3u0uGe3+Lc8B5k23t9OOWw8OHFjH/zhxUSbfUbKlCzrJtqmzcduB9Ep85U+mmFZ9mUk
         v+Abi8OK70ZNSpKDmF7xSyNRN4NcIuxGz8f9XlA1Wj5lAXfMPWu0FtqC/E6VOAbGSkvD
         WjJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DTpTVkESn2vrQ+FsIrJTz16bCNnqcqqTMFT1dR0+ZsM=;
        b=EMmFUlU4NEUouSnw5xJJxrtI42uk0RFHqBtEVhRBXLQsAvwtR5b3XO9JK+Zg+QMuno
         l6bAuoiJnSogUXr2VN6nl6PnzS2OOEHTT1gygGHEztliCaRALl9z6hxA0YgHH27yo/wl
         /9SA3nPIyheJUlgS8EYn9tL3SO4mLwA70UQgEA/6V9pnXDlEZeXQGua5mx6vvUQWlyR0
         nR5pwVpSe5Ekw2v3634PgmLJmQlLIQtS7DQJPHWgzBOzCS9atD1zcnkDvDDMONdrdtsi
         upXxneMKqI58KJrZ2AN2UNPYzMCdQg17jp4bNlMVSUFJ8zkQNlxClINbBaoHgSKA3esW
         x3MQ==
X-Gm-Message-State: APjAAAUeQbx6YsLq9WPAQqBOQkVbRJ5U7L+O0AIcyChkTSjKDw1st9g6
        N3UpVyBnNfgEdBhBv37hZ/shesik
X-Google-Smtp-Source: APXvYqwxZkm32dsiZf6s0HGpxEOe099f71kxaIYpWQjZ3n43WfUuzh8CMTPG+OdaDvCYJMLZyyYTIQ==
X-Received: by 2002:a62:60c6:: with SMTP id u189mr20352460pfb.4.1571625975586;
        Sun, 20 Oct 2019 19:46:15 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id q6sm16416016pgn.44.2019.10.20.19.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2019 19:46:14 -0700 (PDT)
Subject: Re: [PATCH net-next 09/16] net: dsa: use ports list to find first CPU
 port
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-10-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c6b2502b-e06c-8589-3f41-97962e1130bd@gmail.com>
Date:   Sun, 20 Oct 2019 19:46:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191020031941.3805884-10-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> Use the new ports list instead of iterating over switches and their
> ports when looking up the first CPU port in the tree.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
