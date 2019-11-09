Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E594F5FFC
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 16:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfKIPTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 10:19:46 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40069 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbfKIPTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 10:19:46 -0500
Received: by mail-pl1-f194.google.com with SMTP id e3so5629999plt.7
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 07:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4o36abI2y2iJFL97eUVK55G7zsh7EChWHopq5PMOLm8=;
        b=sjpCNPLoSTPEO6o0W78MBhDu4FAciN+Re2hoj1RynYwzvovgDtpxUP1zHE1xgNg5+x
         /kiJxxyDF0q5YzCv+Qg35jtg7SyMyCnZkklWHsVRY43A3ZQXjoKOt5ma4faHRnxVwG0x
         ap3ydWgjEjQS/v7gnWrmv1cocyscIlG7uvkFWBsIn/e1rTbLWg7Wj+/jEz1iKaSiJ7bZ
         991D3AExumSXSIWHBJY6vC5pozop1NwmPUWWeIY5sF5yhC0J2larzx5RYaTzMRfbdc9G
         aqg/VJeyOTepynHO35abP2iQP18rlboFO3qr040xX14IFl6r0xDZxOsCQPVPHGpAC7zg
         pk2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4o36abI2y2iJFL97eUVK55G7zsh7EChWHopq5PMOLm8=;
        b=PUd4Deyq+QEIL6l3wtTgjTCIFnPpZsoQbIBjg4uhWj5OIBvjUmsps4eyGrKbXJaIJt
         Jsf4skibSWByAStqKUbChc0tX+XQxS1KRzVW81Ysafqs4r7e3ImBxusW57m6W7OJrPMp
         c7oR763pL19ZPR5wTWxfqT0NFOS3fL6ktlJBva0Pj42v1LpygEDBFHFwqWEFXlROh2/V
         mSe2V/co5dlTofs8+pbzZqORESqtBZDba9xIvEdHr8lPCC+E/5ReBBgAmHGRisstEj6b
         CJmwuoblJpabBnWcekESWE/NMJZAQfT+VfdliAh9VJcp4hez28zCIYPnuJ+AqffVHoyO
         8mFg==
X-Gm-Message-State: APjAAAUF6XfhxXoGbjwdGgnsnpslZxEsVqj24URBtmTeg6u77CFApUic
        MZ5jm4LIHqouSsWvlF36ynvj6QkI
X-Google-Smtp-Source: APXvYqz/XmHeOESwvzOZvkxs5xAYCU6CnJ4sRWue2IphJN7fWiAAOX0lwEyyNZpsKAstCsNQSDyVrg==
X-Received: by 2002:a17:902:102:: with SMTP id 2mr17145326plb.156.1573312785792;
        Sat, 09 Nov 2019 07:19:45 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j24sm9014488pff.71.2019.11.09.07.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 07:19:45 -0800 (PST)
Date:   Sat, 9 Nov 2019 07:19:42 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jakub.kicinski@netronome.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] Unlock new potential in SJA1105 with PTP
 system timestamping
Message-ID: <20191109151942.GA1537@localhost>
References: <20191109113224.6495-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191109113224.6495-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 09, 2019 at 01:32:21PM +0200, Vladimir Oltean wrote:
> The SJA1105 being an automotive switch means it is designed to live in a
> set-and-forget environment, far from the configure-at-runtime nature of
> Linux. Frequently resetting the switch to change its static config means
> it loses track of its PTP time, which is not good.
> 
> This patch series implements PTP system timestamping for this switch
> (using the API introduced for SPI here:
> https://www.mail-archive.com/netdev@vger.kernel.org/msg316725.html),
> adding the following benefits to the driver:
> - When under control of a user space PTP servo loop (ptp4l, phc2sys),
>   the loss of sync during a switch reset is much more manageable, and
>   the switch still remains in the s2 (locked servo) state.
> - When synchronizing the switch using the software technique (based on
>   reading clock A and writing the value to clock B, as opposed to
>   relying on hardware timestamping), e.g. by using phc2sys, the sync
>   accuracy is vastly improved due to the fact that the actual switch PTP
>   time can now be more precisely correlated with something of better
>   precision (CLOCK_REALTIME). The issue is that SPI transfers are
>   inherently bad for measuring time with low jitter, but the newly
>   introduced API aims to alleviate that issue somewhat.
> 
> This series is also a requirement for a future patch set that adds full
> time-aware scheduling offload support for the switch.
> 
> Vladimir Oltean (3):
>   net: dsa: sja1105: Implement the .gettimex64 system call for PTP
>   net: dsa: sja1105: Restore PTP time after switch reset
>   net: dsa: sja1105: Disallow management xmit during switch reset

For the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
