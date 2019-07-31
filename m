Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9587C455
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 16:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbfGaOGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 10:06:41 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36008 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfGaOGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 10:06:41 -0400
Received: by mail-pf1-f195.google.com with SMTP id r7so31938820pfl.3;
        Wed, 31 Jul 2019 07:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yaCtomcHuu4LU8eJA4RM4z2Fuw/j7eJshgdH32LTxlg=;
        b=gTyw9bvRppHK8/eTcDglLLhmsTpsx/gpNRpX8nEG7U1thjRemVYUodA/RADG2q63Ig
         t1KXu7KrzUGbhJWuObNY03eubS3LSyQy2jmD3feG3oMOuA51erjwIXGz9vx/nCJ/za7z
         dsKmnAqjIPoqCr4IKmpTqamLKCMO8+d42ihI5QM9JoHhgxHXWObt18sKc2oUpAGRZCDz
         Nlh7qsDO0+RgSXXZ8tz6um7eJTrffkZysy8JorxRwgYd+UedpMg3pNItRlEULWkH7RyG
         XZztZfgWyqdp0P6Mi7n/vIWMsluQSQau5CA+xmh4cdUGAFJQ6Kvqzeopp8ot+c8xHQbz
         tGyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yaCtomcHuu4LU8eJA4RM4z2Fuw/j7eJshgdH32LTxlg=;
        b=uTh9KFAXTrYK43C0+j6ytAUFcwRAmm0IlzKMQSwe0BZc/6CZ9qRy8IrLDNVCRNJJ0G
         TO4efidjxBYR2EBvXnvL0VehuQVtv5ags/wDtSNbUzQI7372/OPmXGvz+wOksJkaDTBn
         NAVXul/H78fk1ggxH/iJN2/77yiqkGKKo2QiSvYUNlWRfFsIc3YAB/CPdKsYyWrnWF6m
         TGCuEtlwq4mue+vMvRItsGHzh8CdjvstiY52GjKQkXEka0C2hPoI+9JLCyScm5c+YFNr
         Es4RwXBXUJBN/V4TgjTd1FDenXZVBtB+mhdUJawKcPnva7xKgalGCEchfECfZ9Ujn2Q9
         jK6g==
X-Gm-Message-State: APjAAAXdYThHpEhhFlhAqeRzwHFRXE8kac4DkDrm/kbPI82NHJzPOewa
        anP0BDCukk23b6VnFY4o4MA=
X-Google-Smtp-Source: APXvYqwayt0zMSfma9PStUVvuMT69pbR38P3xHJEd4bFX35IW70nsfKrSXBQe+VVLRfVpQ+RqEE/UQ==
X-Received: by 2002:a65:5b8e:: with SMTP id i14mr112702552pgr.188.1564582000667;
        Wed, 31 Jul 2019 07:06:40 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id d17sm77609090pgl.66.2019.07.31.07.06.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 07:06:39 -0700 (PDT)
Date:   Wed, 31 Jul 2019 07:06:36 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH net-next v2 6/6] net: dsa: mv88e6xxx: add PTP support for
 MV88E6250 family
Message-ID: <20190731140636.GA1690@localhost>
References: <20190731082351.3157-1-h.feurstein@gmail.com>
 <20190731082351.3157-7-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731082351.3157-7-h.feurstein@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 10:23:51AM +0200, Hubert Feurstein wrote:
> This adds PTP support for the MV88E6250 family.
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c |  4 ++
>  drivers/net/dsa/mv88e6xxx/chip.h |  4 ++
>  drivers/net/dsa/mv88e6xxx/ptp.c  | 79 +++++++++++++++++++++++++++-----
>  drivers/net/dsa/mv88e6xxx/ptp.h  |  2 +
>  4 files changed, 78 insertions(+), 11 deletions(-)

Acked-by: Richard Cochran <richardcochran@gmail.com>
